import os
import unittest

from app.core.scan_session import DiscardNotConfirmed, ScanSession, SessionError
from app.core.session_store import SessionStore
from session_helpers import Env, read, record_exists

DAY = 24 * 3600


def make_store(env, **kwargs):
    return SessionStore(base_dir=env.dir, clock=env.clock, **kwargs)


def read_log(env):
    path = env.path("logs", "session_store.log")
    if not os.path.exists(path):
        return ""
    with open(path) as f:
        return f.read()


def scanning_session(env, beans=0):
    """造一个正在扫描、已写过 checkpoint 的会话，然后推进 1 秒（让各会话的新旧可区分）。"""
    s = env.new_session()
    s.start()
    for _ in range(beans):
        s.record_bean()
    env.clock.advance(1)
    return s


def incomplete_ids(store):
    return [snap["session_id"] for snap in store.list_incomplete()]


class RecoveryTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)

    def test_scanning_session_becomes_incomplete_with_checkpointed_counts(self):
        s = scanning_session(self.env)
        for _ in range(45):  # 第 30 颗写过 checkpoint，后 15 颗只在内存里，断电就丢
            s.record_bean()
        store = make_store(self.env)
        report = store.recover()
        self.assertEqual(report["recovered_incomplete"], [s.session_id])
        snap = store.get_incomplete(s.session_id)
        self.assertEqual(snap["state"], "incomplete")
        self.assertEqual(snap["bean_count_total"], 30)
        self.assertEqual(snap["operation_id"], s.operation_id)
        self.assertIs(snap["saveable"], False)
        self.assertFalse(record_exists(self.env.active_path(s.session_id)))
        self.assertTrue(record_exists(self.env.incomplete_path(s.session_id)))

    def test_recovered_session_never_enters_the_queue(self):
        s = scanning_session(self.env, beans=40)
        make_store(self.env).recover()
        self.assertIsNone(self.env.queue.next_pending())
        self.assertFalse(os.path.exists(self.env.path("queue")))
        with self.assertRaises(SessionError):
            ScanSession.load(base_dir=self.env.dir, session_id=s.session_id, clock=self.env.clock)

    def test_recover_is_idempotent(self):
        scanning_session(self.env, beans=3)
        store = make_store(self.env)
        store.recover()
        before = self.env.tree()
        report = make_store(self.env).recover()
        self.assertEqual(report["recovered_incomplete"], [])
        self.assertEqual(self.env.tree(), before)

    def test_session_that_never_started_is_cleaned_not_made_incomplete(self):
        s = self.env.new_session()
        store = make_store(self.env)
        store.recover()
        self.assertEqual(store.list_incomplete(), [])
        self.assertFalse(record_exists(self.env.active_path(s.session_id)))

    def test_result_ready_session_is_left_for_the_operator(self):
        s = self.env.session_in_state("result_ready")
        report = make_store(self.env).recover()
        self.assertEqual(report["result_ready"], [s.session_id])
        again = ScanSession.load(base_dir=self.env.dir, session_id=s.session_id,
                                 clock=self.env.clock)
        self.assertEqual(again.state, "result_ready")
        self.assertEqual(again.operation_id, s.operation_id)
        again.save_to_queue(self.env.queue)
        self.assertEqual(self.env.queue.next_pending()["operation_id"], s.operation_id)

    def test_stale_active_file_left_by_a_finished_transition_is_dropped(self):
        # 转换已经完成（新位置已写好），但旧 active 文件没来得及删就断电。
        cases = {}
        s = self.env.session_in_state("result_ready")
        cases["queued"] = (s, read(s.checkpoint_file))
        s.save_to_queue(self.env.queue)
        d = self.env.session_in_state("result_ready")
        cases["discarded"] = (d, read(d.checkpoint_file))
        d.discard(confirmed=True)
        i = self.env.session_in_state("scanning")
        i.record_bean()
        cases["incomplete"] = (i, read(i.checkpoint_file))
        i.mark_incomplete()
        from app.core import storage
        for session, old in cases.values():
            storage.atomic_write_json(self.env.active_path(session.session_id), old)
        store = make_store(self.env)
        report = store.recover()
        for session, _old in cases.values():
            self.assertFalse(record_exists(self.env.active_path(session.session_id)))
        self.assertEqual(sorted(report["dropped_stale"]),
                         sorted([s.session_id, d.session_id, i.session_id]))
        self.assertEqual(report["recovered_incomplete"], [])
        self.assertEqual(incomplete_ids(store), [i.session_id])
        self.assertEqual(self.env.queue.next_pending()["operation_id"], s.operation_id)
        self.assertEqual([x["session_id"] for x in store.list_discarded()], [d.session_id])

    def test_leftover_temp_files_are_cleaned(self):
        s = scanning_session(self.env, beans=1)
        tmp = self.env.active_path(s.session_id) + ".tmp"
        with open(tmp, "w") as f:
            f.write('{"half')
        make_store(self.env).recover()
        self.assertFalse(os.path.exists(tmp))

    def test_unreadable_active_file_is_reported_and_left_alone(self):
        os.makedirs(self.env.path("sessions", "active"))
        bad = self.env.path("sessions", "active", "sess-bad.json")
        with open(bad, "w") as f:
            f.write("{not json")
        store = make_store(self.env)
        report = store.recover()
        self.assertEqual(report["unreadable"], ["sess-bad"])
        self.assertTrue(os.path.exists(bad))
        self.assertEqual(store.list_incomplete(), [])

    def test_recover_on_a_fresh_base_dir_is_harmless(self):
        report = make_store(self.env).recover()
        for key in report:
            self.assertEqual(report[key], [], key)


class IncompleteSessionTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)

    def test_list_is_oldest_first_and_get_returns_none_for_unknown(self):
        ids = []
        for _ in range(3):
            s = scanning_session(self.env, beans=1)
            ids.append(s.session_id)
            s.mark_incomplete()
        store = make_store(self.env)
        self.assertEqual(incomplete_ids(store), ids)
        self.assertIsNone(store.get_incomplete("sess-nope"))

    def test_discarding_needs_confirmation_and_removes_without_retention(self):
        s = scanning_session(self.env, beans=2)
        s.mark_incomplete()
        store = make_store(self.env)
        for flag in ({}, {"confirmed": False}, {"confirmed": 1}):
            with self.assertRaises(DiscardNotConfirmed):
                store.discard_incomplete(s.session_id, **flag)
            self.assertIsNotNone(store.get_incomplete(s.session_id))
        store.discard_incomplete(s.session_id, confirmed=True)
        self.assertIsNone(store.get_incomplete(s.session_id))
        self.assertEqual(store.list_discarded(), [])  # 未完成会话被丢弃不进 7 天留档
        self.assertIn(s.session_id, read_log(self.env))

    def test_discarding_an_unknown_session_is_an_error(self):
        with self.assertRaises(SessionError):
            make_store(self.env).discard_incomplete("sess-nope", confirmed=True)

    def test_incomplete_sessions_do_not_count_toward_the_queue(self):
        for _ in range(3):
            self.env.session_in_state("queued")
        for _ in range(2):
            scanning_session(self.env, beans=1).mark_incomplete()
        self.assertEqual(len(os.listdir(self.env.path("queue"))), 3)

    def test_keeps_at_most_twenty_and_logs_each_rolled_out_session(self):
        ids = []
        for _ in range(25):
            s = scanning_session(self.env, beans=1)
            ids.append(s.session_id)
            s.mark_incomplete()
        store = make_store(self.env)
        self.assertEqual(incomplete_ids(store), ids[5:])
        log = read_log(self.env)
        for gone in ids[:5]:
            self.assertIn(gone, log)
            self.assertFalse(record_exists(self.env.incomplete_path(gone)))
        for kept in ids[5:]:
            self.assertNotIn(kept, log)

    def test_the_cap_is_also_enforced_when_recovering_after_a_crash(self):
        ids = [scanning_session(self.env, beans=1).session_id for _ in range(23)]
        store = make_store(self.env)
        report = store.recover()
        self.assertEqual(incomplete_ids(store), ids[3:])
        self.assertEqual(sorted(report["rolled_out"]), sorted(ids[:3]))
        for gone in ids[:3]:
            self.assertIn(gone, read_log(self.env))

    def test_cap_is_configurable_and_validated(self):
        ids = []
        for _ in range(5):
            s = scanning_session(self.env, beans=1)
            ids.append(s.session_id)
            s.mark_incomplete()
        store = make_store(self.env, max_incomplete=3)
        store.recover()
        self.assertEqual(incomplete_ids(store), ids[2:])
        for bad in (0, -1, 2.5, True, None):
            with self.assertRaises(ValueError):
                make_store(self.env, max_incomplete=bad)


class DiscardedRetentionTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)

    def _discard_one(self):
        s = self.env.session_in_state("result_ready")
        s.discard(confirmed=True)
        return s

    def test_kept_until_seven_days_then_purged(self):
        s = self._discard_one()
        store = make_store(self.env)
        self.env.clock.advance(7 * DAY - 1)
        self.assertEqual(store.purge_expired_discarded(), [])
        self.assertTrue(record_exists(self.env.discarded_path(s.session_id)))
        self.env.clock.advance(1)
        self.assertEqual(store.purge_expired_discarded(), [s.session_id])
        self.assertFalse(record_exists(self.env.discarded_path(s.session_id)))
        self.assertEqual(store.list_discarded(), [])

    def test_only_the_expired_ones_are_purged(self):
        old = self._discard_one()
        self.env.clock.advance(3 * DAY)
        recent = self._discard_one()
        self.env.clock.advance(5 * DAY)  # old 满 8 天，recent 满 5 天
        store = make_store(self.env)
        self.assertEqual(store.purge_expired_discarded(), [old.session_id])
        self.assertEqual([x["session_id"] for x in store.list_discarded()], [recent.session_id])

    def test_recover_purges_expired_discarded_sessions_too(self):
        s = self._discard_one()
        self.env.clock.advance(8 * DAY)
        report = make_store(self.env).recover()
        self.assertEqual(report["expired_discarded"], [s.session_id])

    def test_retention_is_configurable_and_validated(self):
        s = self._discard_one()
        self.env.clock.advance(61)
        self.assertEqual(make_store(self.env, discarded_retention_s=60).purge_expired_discarded(),
                         [s.session_id])
        for bad in (0, -1, "7", None, True):
            with self.assertRaises(ValueError):
                make_store(self.env, discarded_retention_s=bad)

    def test_discarded_sessions_are_never_queued_and_keep_their_counts(self):
        s = self._discard_one()
        store = make_store(self.env)
        self.assertIsNone(self.env.queue.next_pending())
        kept = store.list_discarded()[0]
        self.assertEqual(kept["state"], "discarded")
        self.assertEqual(kept["bean_count_total"], 1)
        self.assertEqual(kept["operation_id"], s.operation_id)

    def test_age_never_purges_incomplete_sessions(self):
        s = scanning_session(self.env, beans=1)
        s.mark_incomplete()
        self.env.clock.advance(30 * DAY)
        store = make_store(self.env)
        store.purge_expired_discarded()
        store.recover()
        self.assertEqual(incomplete_ids(store), [s.session_id])


if __name__ == "__main__":
    unittest.main()
