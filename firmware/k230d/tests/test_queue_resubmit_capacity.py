"""票 05：400 拒收后改数据重报（复用 operation_id）、队列容量保护（100 条触顶）。"""
import unittest

from app.core import queue as queue_mod
from app.core.mock_client import MockSubmitClient
from app.core.queue import (
    InvalidQueueTransition,
    STATE_FAILED_REJECTED,
    STATE_FAILED_RETRIABLE,
    STATE_PENDING,
    STATE_SAVED,
)
from app.core.report import ReportOrchestrator
from queue_helpers import enqueue_new
from session_helpers import Env


class ResubmitRejectedTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)
        self.q = self.env.queue
        self.client = MockSubmitClient()
        self.orch = ReportOrchestrator(self.q, self.client)

    def reject(self, status=400):
        op = enqueue_new(self.env)
        self.client.set_status(status)
        self.orch.submit_next()
        self.assertEqual(self.q.get_entry(op)["state"], STATE_FAILED_REJECTED)
        self.client.set_status(200)
        return op

    def corrected_record(self, op, beans=10):
        record = dict(self.q.get_entry(op)["record"])
        record["bean_count_total"] = beans
        record["defects"] = dict(record["defects"])
        record["defects"]["full_black"] = 2
        return record

    def test_resubmit_with_changed_data_keeps_the_same_operation_id(self):
        op = self.reject(400)
        new_record = self.corrected_record(op)
        self.q.resubmit_rejected(op, new_record)
        entry = self.q.get_entry(op)
        self.assertEqual(entry["state"], STATE_PENDING)
        self.assertEqual(entry["operation_id"], op)
        self.assertEqual(entry["record"]["bean_count_total"], 10)
        self.assertEqual(entry["record"]["operation_id"], op)
        self.assertEqual(entry["retry_count"], 0)
        self.assertNotIn("error_code", entry)
        self.assertNotIn("error_message", entry)

    def test_resubmitted_body_is_sent_with_the_same_idempotency_key_and_saves(self):
        op = self.reject(400)
        self.q.resubmit_rejected(op, self.corrected_record(op))
        result = self.orch.submit_next()
        self.assertEqual(result["state"], STATE_SAVED)
        first_call, second_call = self.client.calls
        self.assertEqual(first_call["operation_id"], second_call["operation_id"])
        self.assertEqual(second_call["record"]["bean_count_total"], 10)

    def test_still_one_queue_entry_after_resubmit(self):
        op = self.reject(400)
        self.q.resubmit_rejected(op, self.corrected_record(op))
        self.assertEqual(len(self.q.list_all()), 1)

    def test_resubmit_without_new_data_resends_the_original_body(self):
        op = self.reject(403)
        original = self.q.get_entry(op)["record"]
        self.q.resubmit_rejected(op)
        self.assertEqual(self.q.get_entry(op)["state"], STATE_PENDING)
        self.assertEqual(self.q.get_entry(op)["record"], original)
        self.assertEqual(self.orch.submit_next()["state"], STATE_SAVED)

    def test_changing_the_operation_id_is_refused_and_nothing_is_written(self):
        op = self.reject(400)
        bad = self.corrected_record(op)
        bad["operation_id"] = "K230D:DEV0000:scan:ffffffff"
        before = self.env.tree()
        with self.assertRaises(ValueError):
            self.q.resubmit_rejected(op, bad)
        self.assertEqual(self.env.tree(), before)

    def test_self_inconsistent_counts_are_refused(self):
        op = self.reject(400)
        bad = self.corrected_record(op, beans=1)  # full_black=2 > 总数 1
        before = self.env.tree()
        with self.assertRaises(ValueError):
            self.q.resubmit_rejected(op, bad)
        self.assertEqual(self.env.tree(), before)

    def test_only_failed_rejected_can_be_resubmitted(self):
        pending = enqueue_new(self.env)
        saved = enqueue_new(self.env)
        retriable = enqueue_new(self.env)
        self.client.script(200)
        self.orch.submit_next()  # pending 里最早的一条（pending 那条）先被存成 saved
        self.assertEqual(self.q.get_entry(pending)["state"], STATE_SAVED)
        self.client.set_status(503)
        self.orch.submit_next()  # saved 变量那条进入 failed_retriable
        states = {
            saved: STATE_FAILED_RETRIABLE,
            retriable: STATE_PENDING,
            pending: STATE_SAVED,
        }
        for op in states:
            with self.subTest(op=op, state=states[op]):
                self.assertEqual(self.q.get_entry(op)["state"], states[op])
                before = self.env.tree()
                with self.assertRaises(InvalidQueueTransition):
                    self.q.resubmit_rejected(op)
                self.assertEqual(self.env.tree(), before)

    def test_unknown_operation_id_raises_queue_error(self):
        with self.assertRaises(queue_mod.QueueError):
            self.q.resubmit_rejected("K230D:DEV0000:scan:deadbeef")


class CapacityTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)
        self.q = self.env.queue
        self.client = MockSubmitClient()
        self.orch = ReportOrchestrator(self.q, self.client)

    def fill(self, n):
        return [enqueue_new(self.env) for _ in range(n)]

    def test_limits_are_one_hundred_entries_and_five_hundred_mb(self):
        self.assertEqual(queue_mod.MAX_QUEUE_ENTRIES, 100)
        self.assertEqual(queue_mod.MAX_QUEUE_SIZE_MB, 500)

    def test_empty_queue_is_not_full(self):
        info = self.q.capacity_check()
        self.assertEqual(info["count"], 0)
        self.assertFalse(info["full"])
        self.assertTrue(self.q.can_start_scan())

    def test_ninety_nine_entries_still_allow_a_new_scan(self):
        self.fill(99)
        info = self.q.capacity_check()
        self.assertEqual(info["count"], 99)
        self.assertFalse(info["full"])
        self.assertTrue(self.q.can_start_scan())

    def test_one_hundred_entries_block_new_scans_with_a_message(self):
        self.fill(100)
        info = self.q.capacity_check()
        self.assertEqual(info["count"], 100)
        self.assertTrue(info["full"])
        self.assertFalse(self.q.can_start_scan())
        self.assertIn("请清理", info["message"])
        self.assertIn("恢复网络", info["message"])

    def test_not_full_has_no_message(self):
        self.fill(1)
        self.assertFalse(self.q.capacity_check()["message"])

    def test_failed_entries_count_toward_the_limit_but_saved_ones_do_not(self):
        self.fill(100)
        self.client.set_status(503)
        for _ in range(3):
            self.orch.submit_next()  # 3 条进入 failed_retriable，仍占位
        self.assertTrue(self.q.capacity_check()["full"])
        self.client.set_status(200)
        self.orch.submit_next()  # 第 4 条（pending）存成 saved，释放一个位置
        info = self.q.capacity_check()
        self.assertEqual(info["count"], 99)
        self.assertFalse(info["full"])

    def test_mock_back_to_success_clears_the_block(self):
        self.fill(100)
        self.client.set_status(503)
        self.orch.submit_next()
        self.assertFalse(self.q.can_start_scan())
        self.client.set_status(200)
        self.assertEqual(self.orch.submit_next()["state"], STATE_SAVED)
        self.assertTrue(self.q.can_start_scan())

    def test_rejected_entries_keep_the_block_until_removed(self):
        self.fill(100)
        self.client.set_status(400)
        self.orch.submit_next()
        self.client.set_status(200)
        self.assertEqual(self.q.capacity_check()["count"], 100)
        self.assertFalse(self.q.can_start_scan())


if __name__ == "__main__":
    unittest.main()
