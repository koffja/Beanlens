import unittest

from app.core import scan_session
from app.core.scan_session import (
    ALL_STATES,
    DiscardNotConfirmed,
    InvalidTransition,
    SessionError,
    can_transition,
)
from session_helpers import Env, read, record_exists

EDGES = {
    ("pending", "scanning"),
    ("scanning", "result_ready"),
    ("scanning", "incomplete"),
    ("result_ready", "queued"),
    ("result_ready", "discarded"),
    ("queued", "saved"),
}

# 公开操作 -> 在 (状态, 操作) 合法时的后置状态。record_bean 是 scanning 内的自循环。
LEGAL_ACTIONS = {
    ("pending", "start"): "scanning",
    ("scanning", "record_bean"): "scanning",
    ("scanning", "stop"): "result_ready",
    ("scanning", "mark_incomplete"): "incomplete",
    ("result_ready", "discard"): "discarded",
    ("result_ready", "save_to_queue"): "queued",
    ("queued", "mark_saved"): "saved",
}


def run_action(env, session, action):
    if action == "start":
        return session.start()
    if action == "record_bean":
        return session.record_bean()
    if action == "stop":
        return session.stop()
    if action == "mark_incomplete":
        return session.mark_incomplete()
    if action == "discard":
        return session.discard(confirmed=True)
    if action == "save_to_queue":
        return session.save_to_queue(env.queue)
    if action == "mark_saved":
        return session.mark_saved()
    raise ValueError(action)


class TransitionTableTest(unittest.TestCase):
    def test_exactly_seven_states(self):
        self.assertEqual(
            set(ALL_STATES),
            {"pending", "scanning", "result_ready", "queued", "saved", "discarded", "incomplete"},
        )
        self.assertEqual(len(ALL_STATES), 7)

    def test_every_pair_matches_the_adr_graph(self):
        for a in ALL_STATES:
            for b in ALL_STATES:
                self.assertEqual(can_transition(a, b), (a, b) in EDGES, "%s -> %s" % (a, b))

    def test_terminal_states_have_no_exit(self):
        for terminal in ("saved", "discarded", "incomplete"):
            for b in ALL_STATES:
                self.assertFalse(can_transition(terminal, b))


class LegalPathTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)

    def test_pending_to_scanning(self):
        s = self.env.new_session()
        self.assertEqual(s.state, "pending")
        self.assertEqual(read(s.checkpoint_file)["state"], "pending")
        s.start()
        self.assertEqual(s.state, "scanning")
        self.assertEqual(read(s.checkpoint_file)["state"], "scanning")
        self.assertEqual(s.start_time, self.env.clock())

    def test_scanning_to_result_ready_freezes_and_persists(self):
        s = self.env.session_in_state("scanning")
        s.record_bean()
        s.record_bean(unpaired=True)
        self.env.clock.advance(12)
        s.stop()
        self.assertEqual(s.state, "result_ready")
        self.assertEqual(s.duration_s, 12)
        saved = read(s.checkpoint_file)
        self.assertEqual(saved["state"], "result_ready")
        self.assertEqual(saved["bean_count_total"], 2)
        self.assertEqual(saved["unpaired_count"], 1)
        self.assertEqual(saved["duration_s"], 12)

    def test_result_ready_to_queued_moves_record_into_queue(self):
        s = self.env.session_in_state("result_ready")
        path = s.save_to_queue(self.env.queue)
        self.assertEqual(s.state, "queued")
        entry = self.env.queue.next_pending()
        self.assertEqual(entry["operation_id"], s.operation_id)
        self.assertEqual(entry["record"]["session_id"], s.session_id)
        self.assertTrue(path.endswith(".json"))
        self.assertFalse(record_exists(self.env.active_path(s.session_id)))

    def test_queued_to_saved(self):
        s = self.env.session_in_state("queued")
        s.mark_saved()
        self.assertEqual(s.state, "saved")

    def test_result_ready_to_discarded_needs_confirmation_and_keeps_a_copy(self):
        s = self.env.session_in_state("result_ready")
        s.discard(confirmed=True)
        self.assertEqual(s.state, "discarded")
        kept = read(self.env.discarded_path(s.session_id))
        self.assertEqual(kept["state"], "discarded")
        self.assertEqual(kept["discarded_at"], self.env.clock())
        self.assertEqual(kept["bean_count_total"], 1)
        self.assertFalse(record_exists(self.env.active_path(s.session_id)))
        self.assertIsNone(self.env.queue.next_pending())

    def test_scanning_to_incomplete_is_unsaveable(self):
        s = self.env.session_in_state("scanning")
        s.mark_incomplete()
        self.assertEqual(s.state, "incomplete")
        kept = read(self.env.incomplete_path(s.session_id))
        self.assertEqual(kept["state"], "incomplete")
        self.assertIs(kept["saveable"], False)
        self.assertFalse(record_exists(self.env.active_path(s.session_id)))

    def test_full_happy_path_keeps_the_same_idempotency_key(self):
        s = self.env.new_session()
        key = s.operation_id
        s.start()
        s.record_bean()
        self.env.clock.advance(5)
        s.stop()
        s.save_to_queue(self.env.queue)
        s.mark_saved()
        self.assertEqual(s.state, "saved")
        self.assertEqual(s.operation_id, key)
        self.assertEqual(self.env.queue.next_pending()["operation_id"], key)


class IllegalTransitionTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)

    def test_discard_without_confirmation_is_refused(self):
        for flag in ({}, {"confirmed": False}, {"confirmed": None}, {"confirmed": 1}):
            s = self.env.session_in_state("result_ready")
            before = self.env.tree()
            with self.assertRaises(DiscardNotConfirmed):
                s.discard(**flag)
            self.assertEqual(s.state, "result_ready")
            self.assertEqual(self.env.tree(), before)

    def test_result_page_cannot_continue_scanning_or_add_beans(self):
        s = self.env.session_in_state("result_ready")
        frozen = (s.bean_count_total, s.duration_s, s.end_time)
        with self.assertRaises(InvalidTransition) as ctx:
            s.start()
        self.assertIn("result_ready", str(ctx.exception))
        with self.assertRaises(InvalidTransition) as ctx:
            s.record_bean()
        self.assertIn("result_ready", str(ctx.exception))
        self.assertEqual((s.bean_count_total, s.duration_s, s.end_time), frozen)
        self.assertEqual(s.state, "result_ready")

    def test_scanning_cannot_be_discarded_or_saved(self):
        s = self.env.session_in_state("scanning")
        with self.assertRaises(InvalidTransition):
            s.discard(confirmed=True)
        with self.assertRaises(InvalidTransition):
            s.save_to_queue(self.env.queue)
        self.assertEqual(s.state, "scanning")

    def test_incomplete_session_can_never_enter_the_queue(self):
        s = self.env.session_in_state("incomplete")
        with self.assertRaises(InvalidTransition):
            s.save_to_queue(self.env.queue)
        with self.assertRaises(SessionError):
            s.to_record_json()
        self.assertIsNone(self.env.queue.next_pending())

    def test_non_saveable_states_refuse_to_export_a_record(self):
        for state in ("pending", "scanning", "discarded", "incomplete"):
            s = self.env.session_in_state(state)
            with self.assertRaises(SessionError, msg=state):
                s.to_record_json()
        for state in ("result_ready", "queued", "saved"):
            self.assertEqual(
                self.env.session_in_state(state).to_record_json()["bean_count_total"], 1
            )

    def test_every_state_times_every_action(self):
        actions = ["start", "record_bean", "stop", "mark_incomplete", "discard",
                   "save_to_queue", "mark_saved"]
        for state in ALL_STATES:
            for action in actions:
                with self.subTest(state=state, action=action):
                    env = Env(self)
                    session = env.session_in_state(state)
                    self.assertEqual(session.state, state)
                    before = env.tree()
                    expected = LEGAL_ACTIONS.get((state, action))
                    if expected is None:
                        with self.assertRaises(InvalidTransition) as ctx:
                            run_action(env, session, action)
                        self.assertEqual(ctx.exception.state, state)
                        self.assertEqual(session.state, state)
                        self.assertEqual(env.tree(), before)
                    else:
                        run_action(env, session, action)
                        self.assertEqual(session.state, expected)


class FakeSessionStateTest(unittest.TestCase):
    def test_fake_session_is_a_finished_result_ready_session(self):
        env = Env(self)
        s = scan_session.ScanSession.fake(base_dir=env.dir, clock=env.clock)
        self.assertEqual(s.state, "result_ready")
        s.save_to_queue(env.queue)
        self.assertEqual(s.state, "queued")


if __name__ == "__main__":
    unittest.main()
