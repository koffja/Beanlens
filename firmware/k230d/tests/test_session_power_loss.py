"""断电模拟：在每一次文件系统改动（rename / remove / sync）之前各断电一次，
然后“重启”（新对象 + SessionStore.recover），断言：
  1. 目录里没有损坏的 JSON（.tmp 不算，它永远不会被读）；
  2. 会话恰好处于一个确定的位置，状态一致，不丢、不重复、不复活；
  3. 未完成会话永不进队列。
sync 那一档额外把 .tmp 截成一半，模拟“写到一半断电”。
"""
import json
import os
import unittest
from unittest import mock

from app.core import storage
from app.core.queue import SubmissionQueue, filename_for
from app.core.scan_session import ScanSession
from app.core.session_store import SessionStore
from session_helpers import Env

DAY = 24 * 3600


class PowerCut(BaseException):
    """模拟掉电。继承 BaseException：产品代码里的 except Exception 拦不住它，和真实掉电一样没有清理机会。"""


class Cutter:
    """上下文管理器：第 cut_at 次改动之前抛 PowerCut（该次改动没有发生）。cut_at=None 只计数。"""

    def __init__(self, env, cut_at):
        self.env = env
        self.cut_at = cut_at
        self.count = 0
        self._patchers = []

    def _wrap(self, real, torn=False):
        def fake(*args, **kwargs):
            self.count += 1
            if self.cut_at is not None and self.count == self.cut_at:
                if torn:
                    self._tear_temp_files()
                raise PowerCut()
            return real(*args, **kwargs)
        return fake

    def _tear_temp_files(self):
        for root, _dirs, files in os.walk(self.env.dir):
            for name in files:
                if name.endswith(".tmp"):
                    full = os.path.join(root, name)
                    os.truncate(full, os.path.getsize(full) // 2)

    def __enter__(self):
        self._patchers = [
            mock.patch.object(os, "rename", self._wrap(os.rename)),
            mock.patch.object(os, "remove", self._wrap(os.remove)),
            mock.patch.object(os, "sync", self._wrap(getattr(os, "sync", lambda: None), torn=True),
                              create=True),
        ]
        for p in self._patchers:
            p.start()
        return self

    def __exit__(self, *exc):
        for p in reversed(self._patchers):
            p.stop()
        return False


def sweep(test, build, operate, check):
    """对 operate 里的每个改动点各断电一次并检查；最后再检查一次“没断电”的完整结果。返回断电点个数。"""
    cut_at = 1
    while True:
        env = Env(test)
        ctx = build(env)
        cut = False
        try:
            with Cutter(env, cut_at):
                operate(env, ctx)
        except PowerCut:
            cut = True
        if not cut:
            check(env, ctx, None)
            break
        with test.subTest(cut_at=cut_at):
            check(env, ctx, cut_at)
        cut_at += 1
    test.assertGreater(cut_at, 1, "operate 里没有任何文件系统改动，测试没有意义")
    return cut_at - 1


def restart(env, **store_kwargs):
    """模拟重启：全新对象 + 启动恢复。"""
    store = SessionStore(base_dir=env.dir, clock=env.clock, **store_kwargs)
    report = store.recover()
    queue = SubmissionQueue(base_dir=env.dir, clock=env.clock)
    return store, queue, report


def locations(env, session):
    found = set()
    snap = storage.read_json(env.active_path(session.session_id))
    if snap is not None:
        found.add("active:" + snap["state"])
    if storage.read_json(env.incomplete_path(session.session_id)) is not None:
        found.add("incomplete")
    if storage.read_json(env.discarded_path(session.session_id)) is not None:
        found.add("discarded")
    queue_file = os.path.join(env.dir, "queue", filename_for(session.operation_id))
    if storage.read_json(queue_file) is not None:
        found.add("queue")
    return found


def queue_entry_count(env):
    try:
        names = os.listdir(os.path.join(env.dir, "queue"))
    except OSError:
        return 0
    return len([n for n in names if n.endswith(".json")])


def rolled_out_logged(env, session_id):
    path = os.path.join(env.dir, "logs", "session_store.log")
    if not os.path.exists(path):
        return False
    with open(path) as f:
        for line in f.read().splitlines():
            if session_id in line and "rolled_out" in line:
                return True
    return False


def build_scanning(beans):
    def build(env):
        s = env.new_session()
        s.start()
        for _ in range(beans):
            s.record_bean()
        env.clock.advance(2)
        return s
    return build


def build_state(state):
    def build(env):
        return env.session_in_state(state)
    return build


class PowerLossTest(unittest.TestCase):
    def assert_no_corrupt_json(self, env):
        for root, _dirs, files in os.walk(env.dir):
            for name in files:
                if name.endswith(".tmp") or name.endswith(".log"):
                    continue
                full = os.path.join(root, name)
                with open(full) as f:
                    try:
                        json.loads(f.read())
                    except ValueError:
                        self.fail("损坏的 JSON: %s" % os.path.relpath(full, env.dir))

    def assert_unfinished_never_queued(self, env, queue):
        self.assertIsNone(queue.next_pending())

    # ---- checkpoint 写入中途 ----

    def test_power_cut_during_a_bean_count_checkpoint(self):
        def operate(env, s):
            s.record_bean()  # 第 30 颗，触发 checkpoint

        def check(env, s, cut_at):
            store, queue, _report = restart(env)
            self.assert_no_corrupt_json(env)
            self.assertEqual(locations(env, s), {"incomplete"})
            snap = store.get_incomplete(s.session_id)
            self.assertEqual(snap["state"], "incomplete")
            self.assertIs(snap["saveable"], False)
            self.assertEqual(snap["operation_id"], s.operation_id)
            # 要么是旧 checkpoint（start 时的 0 颗），要么是新的 30 颗，不能是别的值。
            self.assertIn(snap["bean_count_total"], (0, 30) if cut_at else (30,))
            self.assert_unfinished_never_queued(env, queue)

        sweep(self, build_scanning(29), operate, check)

    def test_power_cut_during_a_timed_checkpoint(self):
        def build(env):
            s = build_scanning(4)(env)
            return s

        def operate(env, s):
            self.assertTrue(s.tick())  # build 里已推进 2 秒，再推进到 5 秒
        def operate_with_time(env, s):
            env.clock.advance(3)
            operate(env, s)

        def check(env, s, cut_at):
            store, queue, _report = restart(env)
            self.assert_no_corrupt_json(env)
            self.assertEqual(locations(env, s), {"incomplete"})
            self.assertIn(store.get_incomplete(s.session_id)["bean_count_total"],
                          (0, 4) if cut_at else (4,))
            self.assert_unfinished_never_queued(env, queue)

        sweep(self, build, operate_with_time, check)

    # ---- 状态转换中途 ----

    def test_power_cut_while_starting(self):
        def operate(env, s):
            s.start()

        def check(env, s, cut_at):
            store, queue, _report = restart(env)
            self.assert_no_corrupt_json(env)
            found = locations(env, s)
            self.assertIn(found, (set(), {"incomplete"}))
            if cut_at is None:
                self.assertEqual(found, {"incomplete"})
            if found:
                self.assertEqual(store.get_incomplete(s.session_id)["bean_count_total"], 0)
            self.assert_unfinished_never_queued(env, queue)

        sweep(self, lambda env: env.new_session(), operate, check)

    def test_power_cut_while_stopping(self):
        def operate(env, s):
            s.stop()

        def check(env, s, cut_at):
            store, queue, _report = restart(env)
            self.assert_no_corrupt_json(env)
            found = locations(env, s)
            self.assertIn(found, ({"active:result_ready"}, {"incomplete"}))
            if found == {"active:result_ready"}:
                again = ScanSession.load(base_dir=env.dir, session_id=s.session_id, clock=env.clock)
                self.assertEqual(again.bean_count_total, 5)
                self.assertEqual(again.operation_id, s.operation_id)
                self.assertGreaterEqual(again.duration_s, 0)
            else:
                snap = store.get_incomplete(s.session_id)
                self.assertIs(snap["saveable"], False)
                self.assertEqual(snap["bean_count_total"], 0)  # 5 颗从未 checkpoint 过
                self.assertIsNotNone(cut_at)
            self.assert_unfinished_never_queued(env, queue)

        sweep(self, build_scanning(5), operate, check)

    def test_power_cut_while_saving_to_queue(self):
        def operate(env, s):
            s.save_to_queue(env.queue)

        def check(env, s, cut_at):
            _store, queue, _report = restart(env)
            self.assert_no_corrupt_json(env)
            found = locations(env, s)
            self.assertIn(found, ({"active:result_ready"}, {"queue"}))
            if found == {"queue"}:
                entry = queue.next_pending()
                self.assertEqual(entry["operation_id"], s.operation_id)
                self.assertEqual(entry["record"]["session_id"], s.session_id)
                self.assertEqual(entry["record"]["bean_count_total"], 1)
            else:
                # 操作员再点一次「本地保存」：同一个幂等键，队列里仍然只有一条。
                again = ScanSession.load(base_dir=env.dir, session_id=s.session_id, clock=env.clock)
                again.save_to_queue(queue)
                self.assertEqual(queue.next_pending()["operation_id"], s.operation_id)
            self.assertEqual(queue_entry_count(env), 1)
            self.assertEqual(locations(env, s), {"queue"})

        sweep(self, build_state("result_ready"), operate, check)

    def test_power_cut_while_discarding(self):
        def operate(env, s):
            s.discard(confirmed=True)

        def check(env, s, cut_at):
            store, queue, _report = restart(env)
            self.assert_no_corrupt_json(env)
            found = locations(env, s)
            self.assertIn(found, ({"active:result_ready"}, {"discarded"}))
            if found == {"discarded"}:
                snap = store.list_discarded()[0]
                self.assertEqual(snap["state"], "discarded")
                self.assertEqual(snap["bean_count_total"], 1)
                self.assertEqual(snap["operation_id"], s.operation_id)
                self.assertEqual(snap["discarded_at"], env.clock())
            else:
                again = ScanSession.load(base_dir=env.dir, session_id=s.session_id, clock=env.clock)
                again.discard(confirmed=True)
                self.assertEqual(locations(env, s), {"discarded"})
            self.assertIsNone(queue.next_pending())
            self.assertEqual(queue_entry_count(env), 0)

        sweep(self, build_state("result_ready"), operate, check)

    def test_power_cut_while_marking_incomplete(self):
        def operate(env, s):
            s.mark_incomplete()

        def check(env, s, cut_at):
            store, queue, _report = restart(env)
            self.assert_no_corrupt_json(env)
            self.assertEqual(locations(env, s), {"incomplete"})
            snap = store.get_incomplete(s.session_id)
            self.assertIs(snap["saveable"], False)
            self.assertIn(snap["bean_count_total"], (0, 3) if cut_at else (3,))
            self.assertEqual(len(store.list_incomplete()), 1)
            self.assert_unfinished_never_queued(env, queue)

        sweep(self, build_scanning(3), operate, check)

    # ---- 恢复本身、滚动删除、到期清理中途断电 ----

    def test_power_cut_during_recovery_then_recovering_again(self):
        def build(env):
            sessions = [build_scanning(2)(env) for _ in range(3)]
            return sessions

        def operate(env, sessions):
            SessionStore(base_dir=env.dir, clock=env.clock).recover()

        def check(env, sessions, cut_at):
            store, queue, _report = restart(env)  # 第二次启动，补完上一次没做完的恢复
            self.assert_no_corrupt_json(env)
            for s in sessions:
                self.assertEqual(locations(env, s), {"incomplete"})
            self.assertEqual(len(store.list_incomplete()), 3)
            self.assert_unfinished_never_queued(env, queue)
            before = env.tree()
            SessionStore(base_dir=env.dir, clock=env.clock).recover()
            self.assertEqual(env.tree(), before)  # 再恢复一次什么都不变

        sweep(self, build, operate, check)

    def test_power_cut_while_rolling_out_the_oldest_incomplete_session(self):
        def build(env):
            sessions = []
            for _ in range(4):
                s = env.new_session()
                s.start()
                s.record_bean()
                env.clock.advance(1)
                sessions.append(s)  # 不 stop：模拟一直扫到断电
            env.clock.advance(1)
            return sessions

        def operate(env, sessions):
            SessionStore(base_dir=env.dir, clock=env.clock, max_incomplete=3).recover()

        def check(env, sessions, cut_at):
            oldest = sessions[0]
            # 掉电瞬间：已经从磁盘上消失的最旧会话，日志里必须已经有它的滚动删除记录。
            if not locations(env, oldest):
                self.assertTrue(rolled_out_logged(env, oldest.session_id), "删了但没留日志")
            store, queue, _report = restart(env, max_incomplete=3)
            self.assert_no_corrupt_json(env)
            kept = [snap["session_id"] for snap in store.list_incomplete()]
            self.assertEqual(kept, [s.session_id for s in sessions[1:]])
            self.assertEqual(locations(env, oldest), set())
            self.assertTrue(rolled_out_logged(env, oldest.session_id))
            for s in sessions[1:]:
                self.assertEqual(locations(env, s), {"incomplete"})
            self.assert_unfinished_never_queued(env, queue)

        sweep(self, build, operate, check)

    def test_power_cut_while_purging_expired_discarded_sessions(self):
        def build(env):
            old = env.session_in_state("result_ready")
            old.discard(confirmed=True)
            env.clock.advance(8 * DAY)
            fresh = env.session_in_state("result_ready")
            fresh.discard(confirmed=True)
            return old, fresh

        def operate(env, sessions):
            SessionStore(base_dir=env.dir, clock=env.clock).purge_expired_discarded()

        def check(env, sessions, cut_at):
            old, fresh = sessions
            store, _queue, _report = restart(env)
            self.assert_no_corrupt_json(env)
            self.assertEqual(locations(env, old), set())  # 到期的被清掉，不会因为断电“复活”
            self.assertEqual(locations(env, fresh), {"discarded"})
            self.assertEqual([x["session_id"] for x in store.list_discarded()], [fresh.session_id])

        sweep(self, build, operate, check)


if __name__ == "__main__":
    unittest.main()
