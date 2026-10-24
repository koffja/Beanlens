"""票 11 主机测试：启动流程集成（recover 已在票 02/05 覆盖，这里验证 startup() 返回正确对象与 UI 进入待机页）。"""
import os
import shutil
import tempfile
import unittest

from app.main import startup
from tests.session_helpers import Env


class StartupTest(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.mkdtemp(prefix="beanlens-test-main-")
        self.addCleanup(shutil.rmtree, self.dir, True)

    def test_startup_creates_data_dir_if_missing(self):
        missing = os.path.join(self.dir, "missing")
        result = startup(missing)
        self.assertTrue(os.path.isdir(missing))
        self.assertEqual(result["ui"].page_name, "home")

    def test_startup_returns_ui_queue_store_config(self):
        result = startup(self.dir)
        self.assertIn("ui", result)
        self.assertIn("queue", result)
        self.assertIn("store", result)
        self.assertIn("config", result)
        self.assertIn("queue_report", result)
        self.assertIn("store_report", result)

    def test_ui_initializes_to_home_page(self):
        result = startup(self.dir)
        ui = result["ui"]
        self.assertEqual(ui.page_name, "home")
        state = ui.state()
        self.assertEqual(state["page"], "home")

    def test_queue_recover_is_called_during_startup(self):
        env = Env(self)
        # 造一条 saving 状态项，断电重启后应回到 pending
        session = env.session_in_state("result_ready")
        session.save_to_queue(env.queue)
        op = env.queue.next_pending()["operation_id"]
        env.queue.mark_saving(op)
        self.assertEqual(env.queue.get_entry(op)["state"], "saving")

        result = startup(env.dir)
        report = result["queue_report"]
        self.assertEqual(report["requeued"], [op])
        self.assertEqual(result["queue"].get_entry(op)["state"], "pending")

    def test_store_recover_is_called_during_startup(self):
        env = Env(self)
        # 造一条 scanning 会话（在 active 目录）：用 session_in_state 自动完成 checkpoint
        session = env.session_in_state("scanning")
        # scanning 会话会在 active 目录有 checkpoint 文件

        result = startup(env.dir)
        # 恢复后 scanning -> incomplete
        self.assertIn(session.session_id, result["store_report"]["recovered_incomplete"])
        self.assertEqual(len(result["store"].list_incomplete()), 1)

    def test_session_factory_uses_configured_sample_weight(self):
        result = startup(self.dir)
        ui = result["ui"]
        result["config"].set_sample_weight_g(380)
        scan_result = ui.start_scan()
        self.assertTrue(scan_result["started"])
        self.assertEqual(scan_result["session"].sample_weight_g, 380)

    def test_diagnostics_factory_is_passed_to_the_controller(self):
        calls = []

        def factory():
            calls.append(1)
            from app.ui.diagnostics import DiagnosticsPage
            return DiagnosticsPage()

        ui = startup(self.dir, diagnostics_factory=factory)["ui"]
        ui.open_settings()
        ui.open_diagnostics()
        self.assertEqual(calls, [1])

    def test_startup_on_clean_dir_has_empty_reports(self):
        result = startup(self.dir)
        self.assertEqual(result["queue_report"]["requeued"], [])
        self.assertEqual(result["queue_report"]["cleaned_tmp"], [])
        self.assertEqual(result["store_report"]["recovered_incomplete"], [])
        self.assertEqual(result["store_report"]["dropped_stale"], [])


if __name__ == "__main__":
    unittest.main()
