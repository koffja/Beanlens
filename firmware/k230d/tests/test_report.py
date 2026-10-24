"""票 05：ReportOrchestrator 按响应码处置、指数退避、保存后只留元数据。时钟全部注入，不真实等待。"""
import unittest

from app.core import report as report_mod
from app.core.mock_client import MockSubmitClient
from app.core.queue import (
    STATE_FAILED_REJECTED,
    STATE_FAILED_RETRIABLE,
    STATE_PENDING,
    STATE_SAVED,
)
from app.core.report import ReportOrchestrator
from queue_helpers import enqueue_new
from session_helpers import Env


class BackoffDelayTest(unittest.TestCase):
    def test_thirty_seconds_doubling_capped_at_fifteen_minutes(self):
        got = [report_mod.backoff_delay(n) for n in range(1, 9)]
        self.assertEqual(got, [30, 60, 120, 240, 480, 900, 900, 900])

    def test_huge_retry_count_does_not_overflow_the_cap(self):
        self.assertEqual(report_mod.backoff_delay(10000), 900)

    def test_retry_count_must_be_positive_integer(self):
        for bad in (0, -1, None, 1.5, True):
            with self.subTest(bad=bad):
                with self.assertRaises(ValueError):
                    report_mod.backoff_delay(bad)


class SubmitNextTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)
        self.q = self.env.queue
        self.client = MockSubmitClient()
        self.orch = ReportOrchestrator(self.q, self.client)

    def state_of(self, op):
        return self.q.get_entry(op)["state"]

    def test_empty_queue_returns_none_and_calls_nothing(self):
        self.assertIsNone(self.orch.submit_next())
        self.assertEqual(self.client.calls, [])

    def test_200_marks_saved_and_drops_record_body_keeping_metadata(self):
        op = enqueue_new(self.env)
        body = self.q.get_entry(op)["record"]
        result = self.orch.submit_next()
        self.assertEqual(result["operation_id"], op)
        self.assertEqual(result["status"], 200)
        self.assertEqual(result["state"], STATE_SAVED)
        self.assertEqual(self.client.calls[0]["record"], body)
        entry = self.q.get_entry(op)
        self.assertEqual(entry["state"], STATE_SAVED)
        self.assertNotIn("record", entry)
        self.assertEqual(entry["record_id"], result["record_id"])
        meta = entry["metadata"]
        for key in ("session_id", "captured_at", "bean_count_total", "unpaired_count"):
            self.assertEqual(meta[key], body[key])
        self.assertIn("saved_at", entry)

    def test_400_is_rejected_without_retry(self):
        op = enqueue_new(self.env)
        self.client.set_status(400)
        result = self.orch.submit_next()
        self.assertEqual(result["state"], STATE_FAILED_REJECTED)
        self.assertEqual(self.state_of(op), STATE_FAILED_REJECTED)
        self.assertEqual(self.q.get_entry(op)["error_code"], 400)
        self.env.clock.advance(10 * 3600)
        self.assertIsNone(self.orch.submit_next())
        self.assertEqual(len(self.client.calls), 1)

    def test_403_is_rejected_with_quota_exhausted_hint(self):
        op = enqueue_new(self.env)
        self.client.set_status(403)
        result = self.orch.submit_next()
        self.assertEqual(result["state"], STATE_FAILED_REJECTED)
        self.assertIn("额度已用尽", result["hint"])
        self.assertEqual(self.state_of(op), STATE_FAILED_REJECTED)
        self.assertIn("额度已用尽", self.q.get_entry(op)["error_message"])
        self.env.clock.advance(10 * 3600)
        self.assertIsNone(self.orch.submit_next())

    def test_400_has_no_quota_hint(self):
        enqueue_new(self.env)
        self.client.set_status(400)
        self.assertNotIn("额度已用尽", self.orch.submit_next().get("hint") or "")

    def test_401_is_treated_as_retriable_because_v1_has_no_token(self):
        op = enqueue_new(self.env)
        self.client.set_status(401)
        result = self.orch.submit_next()
        self.assertEqual(result["state"], STATE_FAILED_RETRIABLE)
        self.assertEqual(self.state_of(op), STATE_FAILED_RETRIABLE)

    def test_429_and_5xx_are_retriable(self):
        for status in (429, 500, 502, 503, 504):
            with self.subTest(status=status):
                op = enqueue_new(self.env)
                self.client.set_status(status)
                result = self.orch.submit_next()
                self.assertEqual(result["operation_id"], op)
                self.assertEqual(self.state_of(op), STATE_FAILED_RETRIABLE)
                self.assertEqual(self.q.get_entry(op)["retry_count"], 1)
                self.client.set_status(200)
                self.env.clock.advance(60)
                self.orch.submit_next()  # 清掉它，免得影响下一轮

    def test_retriable_waits_for_backoff_then_resubmits_doubling_up_to_cap(self):
        op = enqueue_new(self.env)
        self.client.set_status(503)
        self.orch.submit_next()
        for expected_wait in (30, 60, 120, 240, 480, 900, 900):
            calls_before = len(self.client.calls)
            self.env.clock.advance(expected_wait - 1)
            self.assertIsNone(self.orch.submit_next(), "退避未到期不应提交")
            self.assertEqual(len(self.client.calls), calls_before)
            self.env.clock.advance(1)
            result = self.orch.submit_next()
            self.assertEqual(result["operation_id"], op)
            self.assertEqual(len(self.client.calls), calls_before + 1)
        self.assertEqual(self.q.get_entry(op)["retry_count"], 8)

    def test_retry_after_backoff_can_succeed(self):
        op = enqueue_new(self.env)
        self.client.set_status(429)
        self.orch.submit_next()
        self.client.set_status(200)
        self.env.clock.advance(30)
        result = self.orch.submit_next()
        self.assertEqual(result["state"], STATE_SAVED)
        self.assertEqual(self.state_of(op), STATE_SAVED)

    def test_item_in_backoff_does_not_block_a_newer_pending_item(self):
        first = enqueue_new(self.env)
        self.client.set_status(503)
        self.orch.submit_next()  # first 进入退避
        second = enqueue_new(self.env)
        self.client.set_status(200)
        result = self.orch.submit_next()
        self.assertEqual(result["operation_id"], second)
        self.assertEqual(self.state_of(first), STATE_FAILED_RETRIABLE)

    def test_earliest_submittable_item_goes_first(self):
        first = enqueue_new(self.env)
        second = enqueue_new(self.env)
        self.assertEqual(self.orch.submit_next()["operation_id"], first)
        self.assertEqual(self.orch.submit_next()["operation_id"], second)
        self.assertIsNone(self.orch.submit_next())

    def test_saved_metadata_is_capped_at_the_most_recent_fifty(self):
        ops = []
        for _ in range(55):
            ops.append(enqueue_new(self.env))
        for _ in range(55):
            self.env.clock.advance(1)
            self.assertEqual(self.orch.submit_next()["state"], STATE_SAVED)
        saved = [op for op in ops if self.q.get_entry(op) is not None]
        self.assertEqual(len(saved), 50)
        self.assertEqual(saved, ops[5:])  # 最旧的 5 条被淘汰，保留最近 50 条

    def test_purge_never_touches_unsaved_entries(self):
        keep = enqueue_new(self.env)
        self.client.set_status(400)
        self.orch.submit_next()  # keep 被拒收
        self.client.set_status(200)
        for _ in range(55):
            enqueue_new(self.env)
            self.env.clock.advance(1)
            self.orch.submit_next()
        self.assertEqual(self.state_of(keep), STATE_FAILED_REJECTED)

    def test_pending_items_are_not_touched_by_failures_of_others(self):
        a = enqueue_new(self.env)
        b = enqueue_new(self.env)
        self.client.set_status(500)
        self.orch.submit_next()
        self.assertEqual(self.state_of(b), STATE_PENDING)
        self.assertEqual(self.state_of(a), STATE_FAILED_RETRIABLE)


if __name__ == "__main__":
    unittest.main()
