"""票 10 主机测试存根：只验证数据格式与排序规则，删除/重报接口，不验证真实上报与用户体验（P2 现场演示时核对）。"""
import os
import unittest

from app.core.mock_client import MockSubmitClient
from app.core.report import ReportOrchestrator
from app.ui.queue_manager import QueueManager, QueueManagerError, format_diagnostics
from tests.queue_helpers import enqueue_new
from tests.session_helpers import Env

K230D_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
QUEUE_UI_PATH = os.path.join(K230D_DIR, "app", "ui", "queue_manager.py")


class QueueManagerTest(unittest.TestCase):
    def test_query_groups_by_state(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        for i in range(3):
            session = env.session_in_state("result_ready")
            session.operation_id = "op%d" % i
            session.save_to_queue(env.queue)
        env.queue.mark_saving(env.queue.next_pending()["operation_id"])
        data = mgr.query()
        self.assertEqual(len(data["pending"]), 2)
        self.assertEqual(len(data["saving"]), 1)

    def test_items_within_each_group_sorted_by_state_changed_ms_desc(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        ids = []
        for i in range(3):
            session = env.session_in_state("result_ready")
            session.operation_id = "op%d" % i
            session.save_to_queue(env.queue)
            ids.append(session.operation_id)
            env.clock.advance(10000)
        env.queue.mark_saving(ids[1])
        env.clock.advance(5000)
        env.queue.mark_failed(ids[1], 500, "test")
        data = mgr.query()
        pending = [it["operation_id"] for it in data["pending"]]
        self.assertEqual(set(pending), {ids[0], ids[2]})
        self.assertEqual(data["failed"][0]["operation_id"], ids[1])

    def test_stats_match_query_lengths(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        session = env.session_in_state("result_ready")
        session.save_to_queue(env.queue)
        stats = mgr.stats()
        self.assertEqual(stats["pending_count"], 1)
        self.assertEqual(stats["saving_count"], 0)

    def test_saved_items_visible_until_purge(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        session = env.session_in_state("result_ready")
        session.save_to_queue(env.queue)
        entry = env.queue.next_pending()
        env.queue.mark_saving(entry["operation_id"])
        env.queue.mark_saved(entry["operation_id"], "remote123")
        data = mgr.query()
        self.assertEqual(len(data["saved"]), 1)
        env.queue.purge_saved()
        data2 = mgr.query()
        self.assertEqual(len(data2["saved"]), 1)

    # ---- 删除 ----

    def test_delete_pending_entry(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        op = enqueue_new(env)
        mgr.delete(op)
        self.assertIsNone(env.queue.get_entry(op))

    def test_delete_failed_retriable(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        op = enqueue_new(env)
        env.queue.mark_saving(op)
        env.queue.mark_failed(op, 503, "retry me")
        mgr.delete(op)
        self.assertIsNone(env.queue.get_entry(op))

    def test_delete_failed_rejected(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        op = enqueue_new(env)
        env.queue.mark_saving(op)
        env.queue.mark_failed(op, 400, "bad data")
        mgr.delete(op)
        self.assertIsNone(env.queue.get_entry(op))

    def test_delete_saving_entry_is_refused(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        op = enqueue_new(env)
        env.queue.mark_saving(op)
        with self.assertRaises(QueueManagerError):
            mgr.delete(op)
        self.assertIsNotNone(env.queue.get_entry(op))

    def test_delete_saved_entry_is_refused(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        op = enqueue_new(env)
        env.queue.mark_saving(op)
        env.queue.mark_saved(op, "rec-9")
        with self.assertRaises(QueueManagerError):
            mgr.delete(op)
        self.assertIsNotNone(env.queue.get_entry(op))

    def test_delete_unknown_operation_id_raises(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        with self.assertRaises(QueueManagerError):
            mgr.delete("K230D:DEV0000:scan:deadbeef")

    # ---- 重报 ----

    def test_resubmit_rejected_entry(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        client = MockSubmitClient()
        client.set_status(400)
        orch = ReportOrchestrator(env.queue, client)
        op = enqueue_new(env)
        orch.submit_next()
        self.assertEqual(env.queue.get_entry(op)["state"], "failed_rejected")
        mgr.resubmit(op)
        self.assertEqual(env.queue.get_entry(op)["state"], "pending")

    def test_resubmit_pending_entry_is_refused(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        op = enqueue_new(env)
        with self.assertRaises(QueueManagerError):
            mgr.resubmit(op)

    def test_failure_reason(self):
        env = Env(self)
        mgr = QueueManager(env.queue)
        client = MockSubmitClient()
        client.set_status(403)
        orch = ReportOrchestrator(env.queue, client)
        op = enqueue_new(env)
        orch.submit_next()
        reason = mgr.failure_reason(op)
        self.assertEqual(reason["error_code"], 403)
        self.assertEqual(reason["state"], "failed_rejected")
        self.assertEqual(reason["retry_count"], 0)


class DiagnosticsTest(unittest.TestCase):
    def test_format_includes_all_stats_keys(self):
        stats = {"bean_count_total": 50, "paired_count": 40, "unpaired_count": 8,
                 "rejected_count": 2, "fade_count": 1, "pairing_alert": False, "error": None}
        text = format_diagnostics(stats)
        self.assertIn("总数=50", text)
        self.assertIn("配对=40", text)
        self.assertIn("不明=8", text)
        self.assertIn("拒判=2", text)
        self.assertIn("褪色=1", text)
        self.assertIn("正常", text)

    def test_alert_shown_when_true(self):
        stats = {"bean_count_total": 1, "paired_count": 0, "unpaired_count": 1,
                 "rejected_count": 0, "fade_count": 0, "pairing_alert": True, "error": None}
        text = format_diagnostics(stats)
        self.assertIn("配对超限", text)

    def test_error_appended_when_present(self):
        stats = {"bean_count_total": 0, "paired_count": 0, "unpaired_count": 0,
                 "rejected_count": 0, "fade_count": 0, "pairing_alert": False,
                 "error": "kpu timeout"}
        text = format_diagnostics(stats)
        self.assertIn("kpu timeout", text)
        self.assertIn("推理故障", text)


class BoundaryTest(unittest.TestCase):
    def test_queue_manager_does_not_import_capture_layer(self):
        with open(QUEUE_UI_PATH, encoding="utf-8") as f:
            text = f.read()
        self.assertNotIn("app.capture", text)


if __name__ == "__main__":
    unittest.main()
