"""票 05：队列状态与转换合法性。只测公开行为。"""
import unittest

from app.core import queue as queue_mod
from app.core.queue import (
    InvalidQueueTransition,
    QueueError,
    SubmissionQueue,
    STATE_FAILED_REJECTED,
    STATE_FAILED_RETRIABLE,
    STATE_PENDING,
    STATE_SAVED,
    STATE_SAVING,
)
from queue_helpers import enqueue_new
from session_helpers import Env

ALL = (STATE_PENDING, STATE_SAVING, STATE_SAVED, STATE_FAILED_RETRIABLE, STATE_FAILED_REJECTED)

# 合法转换的完整清单；其余 25 - 7 = 18 对都必须是非法的。
LEGAL = {
    (STATE_PENDING, STATE_SAVING),
    (STATE_FAILED_RETRIABLE, STATE_SAVING),
    (STATE_SAVING, STATE_SAVED),
    (STATE_SAVING, STATE_FAILED_RETRIABLE),
    (STATE_SAVING, STATE_FAILED_REJECTED),
    (STATE_SAVING, STATE_PENDING),  # 重启后回到可重新提交
    (STATE_FAILED_REJECTED, STATE_PENDING),  # 人工修正后重报
}


class StateNamesTest(unittest.TestCase):
    def test_five_states_with_documented_names(self):
        self.assertEqual(
            queue_mod.ALL_STATES,
            ("pending", "saving", "saved", "failed_retriable", "failed_rejected"),
        )

    def test_can_transition_matches_the_legal_table_exactly(self):
        for a in ALL:
            for b in ALL:
                self.assertEqual(queue_mod.can_transition(a, b), (a, b) in LEGAL, (a, b))


class TransitionTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)
        self.q = self.env.queue

    def state_of(self, op):
        return self.q.get_entry(op)["state"]

    def to_saving(self, op):
        self.q.mark_saving(op)

    def to_saved(self, op):
        self.q.mark_saving(op)
        self.q.mark_saved(op, "rec-1")

    def to_retriable(self, op):
        self.q.mark_saving(op)
        self.q.mark_failed(op, 503, "boom")

    def to_rejected(self, op):
        self.q.mark_saving(op)
        self.q.mark_failed(op, 400, "bad")

    def put_in_state(self, state):
        op = enqueue_new(self.env)
        if state == STATE_PENDING:
            pass
        elif state == STATE_SAVING:
            self.to_saving(op)
        elif state == STATE_SAVED:
            self.to_saved(op)
        elif state == STATE_FAILED_RETRIABLE:
            self.to_retriable(op)
        elif state == STATE_FAILED_REJECTED:
            self.to_rejected(op)
        self.assertEqual(self.state_of(op), state)
        return op

    def test_enqueue_starts_pending_with_zero_retries(self):
        op = enqueue_new(self.env)
        entry = self.q.get_entry(op)
        self.assertEqual(entry["state"], STATE_PENDING)
        self.assertEqual(entry["retry_count"], 0)

    def test_mark_saving_from_pending_persists_and_stamps_attempt_time(self):
        op = enqueue_new(self.env)
        self.env.clock.advance(5)
        self.q.mark_saving(op)
        reopened = SubmissionQueue(base_dir=self.env.dir, clock=self.env.clock)
        entry = reopened.get_entry(op)
        self.assertEqual(entry["state"], STATE_SAVING)
        self.assertEqual(entry["last_attempt_at"], self.env.clock())

    def test_mark_saved_requires_saving_and_keeps_record_id(self):
        op = enqueue_new(self.env)
        self.q.mark_saving(op)
        self.q.mark_saved(op, "rec-42")
        entry = self.q.get_entry(op)
        self.assertEqual(entry["state"], STATE_SAVED)
        self.assertEqual(entry["record_id"], "rec-42")

    def test_every_illegal_transition_raises_and_touches_nothing(self):
        actions = {
            STATE_SAVING: lambda op: self.q.mark_saving(op),
            STATE_SAVED: lambda op: self.q.mark_saved(op, "r"),
            STATE_FAILED_RETRIABLE: lambda op: self.q.mark_failed(op, 503, "x"),
            STATE_FAILED_REJECTED: lambda op: self.q.mark_failed(op, 400, "x"),
        }
        for source in ALL:
            for target in actions:
                if (source, target) in LEGAL:
                    continue
                with self.subTest(source=source, target=target):
                    op = self.put_in_state(source)
                    before = self.env.tree()
                    with self.assertRaises(InvalidQueueTransition):
                        actions[target](op)
                    self.assertEqual(self.env.tree(), before)
                    self.assertEqual(self.state_of(op), source)

    def test_error_message_names_both_the_state_and_the_action(self):
        op = enqueue_new(self.env)
        with self.assertRaises(InvalidQueueTransition) as ctx:
            self.q.mark_saved(op, "r")
        message = str(ctx.exception)
        self.assertIn(STATE_PENDING, message)
        self.assertIn("mark_saved", message)
        self.assertEqual(ctx.exception.state, STATE_PENDING)
        self.assertEqual(ctx.exception.action, "mark_saved")

    def test_invalid_transition_is_a_queue_error(self):
        self.assertTrue(issubclass(InvalidQueueTransition, QueueError))

    def test_unknown_operation_id_raises_queue_error(self):
        with self.assertRaises(QueueError):
            self.q.mark_saving("K230D:DEV0000:scan:deadbeef")
        self.assertIsNone(self.q.get_entry("K230D:DEV0000:scan:deadbeef"))

    def test_mark_failed_classifies_by_http_status(self):
        expected = {
            400: STATE_FAILED_REJECTED,
            403: STATE_FAILED_REJECTED,
            401: STATE_FAILED_RETRIABLE,
            429: STATE_FAILED_RETRIABLE,
            500: STATE_FAILED_RETRIABLE,
            502: STATE_FAILED_RETRIABLE,
            503: STATE_FAILED_RETRIABLE,
        }
        for status in expected:
            with self.subTest(status=status):
                op = enqueue_new(self.env)
                self.q.mark_saving(op)
                self.q.mark_failed(op, status, "msg")
                entry = self.q.get_entry(op)
                self.assertEqual(entry["state"], expected[status])
                self.assertEqual(entry["error_code"], status)
                self.assertEqual(entry["error_message"], "msg")

    def test_unclassified_status_is_refused_and_entry_stays_saving(self):
        for status in (200, 404, 302, 0, None, "503", True):
            with self.subTest(status=status):
                op = enqueue_new(self.env)
                self.q.mark_saving(op)
                with self.assertRaises(ValueError):
                    self.q.mark_failed(op, status, "x")
                self.assertEqual(self.state_of(op), STATE_SAVING)

    def test_retry_count_counts_only_retriable_failures(self):
        op = enqueue_new(self.env)
        self.q.mark_saving(op)
        self.q.mark_failed(op, 503, "x")
        self.assertEqual(self.q.get_entry(op)["retry_count"], 1)
        self.q.mark_saving(op)
        self.q.mark_failed(op, 429, "x")
        self.assertEqual(self.q.get_entry(op)["retry_count"], 2)
        self.q.mark_saving(op)
        self.q.mark_failed(op, 400, "x")
        self.assertEqual(self.q.get_entry(op)["retry_count"], 2)

    def test_list_rejected_returns_only_failed_rejected(self):
        a = self.put_in_state(STATE_FAILED_REJECTED)
        self.put_in_state(STATE_FAILED_RETRIABLE)
        self.put_in_state(STATE_PENDING)
        self.assertEqual([e["operation_id"] for e in self.q.list_rejected()], [a])


if __name__ == "__main__":
    unittest.main()
