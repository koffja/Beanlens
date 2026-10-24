import os
import subprocess
import sys
import unittest
from unittest import mock

from app.core import queue as queue_mod
from app.core.config_manager import ConfigManager
from app.core.scan_session import DiscardNotConfirmed, InvalidTransition
from app.core.session_store import SessionStore
from app.ui import fake_data
from app.ui.controller import UIController
from app.ui.diagnostics import DiagnosticsPage
from session_helpers import Env, record_exists

K230D_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
UI_DIR = os.path.join(K230D_DIR, "app", "ui")
CORE_DIR = os.path.join(K230D_DIR, "app", "core")


def make_controller(env):
    store = SessionStore(base_dir=env.dir, clock=env.clock)
    config = ConfigManager(env.dir)
    return UIController(env.queue, store, config, env.new_session)


def code_lines(path):
    """源码里去掉整行注释和行内注释后的文本（约束测试只查代码，不查说明性注释）。"""
    lines = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            stripped = line.strip()
            if stripped.startswith("#"):
                continue
            lines.append(line.split("  #")[0])
    return "\n".join(lines)


class FullFlowTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)
        self.ui = make_controller(self.env)

    def test_starts_on_the_home_page(self):
        self.assertEqual(self.ui.page_name, "home")
        self.assertEqual(self.ui.state()["page"], "home")

    def test_home_scan_stop_result_save_back_to_home(self):
        result = self.ui.start_scan()
        self.assertTrue(result["started"])
        self.assertEqual(self.ui.page_name, "scanning")
        fake_data.feed(self.ui.session, clean=8, defects={"full_black": 1, "shell": 1}, unpaired=1)
        numbers = dict((n["id"], n["value"]) for n in self.ui.state()["numbers"])
        self.assertEqual(numbers["bean_total"], 11)
        self.assertEqual(numbers["defect_beans"], 2)
        self.assertEqual(numbers["unpaired"], 1)

        self.env.clock.advance(9)
        self.ui.stop()
        self.assertEqual(self.ui.page_name, "result")
        self.assertEqual(self.ui.session.state, "result_ready")
        self.assertEqual(self.ui.state()["preview"]["badge"], "临时规则")

        saved = self.ui.save_local()
        self.assertTrue(saved["saved"])
        self.assertEqual(self.ui.page_name, "home")
        self.assertEqual(self.ui.state()["queue_backlog"], 1)
        self.assertEqual(self.env.queue.next_pending()["record"]["bean_count_total"], 11)

    def test_discard_path_needs_confirmation_then_goes_home(self):
        self.ui.start_scan()
        fake_data.feed(self.ui.session, clean=3)
        self.ui.stop()
        session = self.ui.session
        dialog = self.ui.request_discard()
        self.assertTrue(dialog["need_confirm"])
        self.assertEqual(self.ui.page_name, "result")
        with self.assertRaises(DiscardNotConfirmed):
            self.ui.discard()
        self.assertEqual(session.state, "result_ready")
        self.ui.discard(confirmed=True)
        self.assertEqual(session.state, "discarded")
        self.assertEqual(self.ui.page_name, "home")
        self.assertEqual(self.ui.state()["queue_backlog"], 0)
        self.assertTrue(record_exists(self.env.discarded_path(session.session_id)))

    def test_failed_self_check_keeps_the_result_page(self):
        self.ui.start_scan()
        fake_data.feed(self.ui.session, clean=2)
        self.ui.stop()
        self.ui.session.defect_counts["fungus"] = 50
        saved = self.ui.save_local()
        self.assertFalse(saved["saved"])
        self.assertEqual(self.ui.page_name, "result")
        self.assertIn("计数不自洽", saved["message"])

    def test_stop_outside_scanning_is_refused(self):
        with self.assertRaises(ValueError):
            self.ui.stop()
        self.assertEqual(self.ui.page_name, "home")

    def test_result_page_has_no_way_back_into_scanning(self):
        self.ui.start_scan()
        fake_data.feed(self.ui.session, clean=1)
        self.ui.stop()
        with self.assertRaises(ValueError):
            self.ui.start_scan()
        self.assertEqual(self.ui.page_name, "result")
        self.assertEqual(self.ui.session.state, "result_ready")

    def test_two_scans_in_a_row_make_two_queue_items(self):
        for _ in range(2):
            self.ui.start_scan()
            fake_data.feed(self.ui.session, clean=2)
            self.env.clock.advance(1)
            self.ui.stop()
            self.ui.save_local()
        self.assertEqual(self.ui.state()["queue_backlog"], 2)
        self.assertEqual(len(self.env.queue.list_all()), 2)

    # ---- 队列触顶 ----

    def test_full_queue_blocks_the_scan_and_stays_on_home_with_the_reason(self):
        with mock.patch.object(queue_mod, "MAX_QUEUE_ENTRIES", 1):
            self.ui.start_scan()
            fake_data.feed(self.ui.session, clean=1)
            self.ui.stop()
            self.ui.save_local()
            expected = self.env.queue.capacity_check()["message"]
            result = self.ui.start_scan()
            self.assertFalse(result["started"])
            self.assertEqual(result["message"], expected)
            self.assertEqual(self.ui.page_name, "home")
            self.assertEqual(self.ui.state()["blocked_message"], expected)

    # ---- 设置 / 诊断导航 ----

    def test_settings_and_diagnostics_navigation(self):
        self.ui.open_settings()
        self.assertEqual(self.ui.page_name, "settings")
        self.ui.open_diagnostics()
        self.assertEqual(self.ui.page_name, "diagnostics")
        self.ui.back()
        self.assertEqual(self.ui.page_name, "settings")
        self.ui.back()
        self.assertEqual(self.ui.page_name, "home")

    def test_settings_cannot_be_opened_during_a_scan(self):
        self.ui.start_scan()
        with self.assertRaises(ValueError):
            self.ui.open_settings()
        self.assertEqual(self.ui.page_name, "scanning")

    # ---- 按按钮 id 派发 ----

    def test_press_dispatches_by_button_id(self):
        self.ui.press("start_scan")
        self.assertEqual(self.ui.page_name, "scanning")
        fake_data.feed(self.ui.session, clean=2)
        self.ui.press("stop")
        self.assertEqual(self.ui.page_name, "result")
        dialog = self.ui.press("discard")
        self.assertTrue(dialog["need_confirm"])
        self.assertEqual(self.ui.page_name, "result")
        self.ui.press("save_local")
        self.assertEqual(self.ui.page_name, "home")

    def test_press_unknown_or_wrong_page_button_raises(self):
        with self.assertRaises(ValueError):
            self.ui.press("nope")
        with self.assertRaises(ValueError):
            self.ui.press("stop")  # 待机页上没有「停止」


class RecoveryBannerFlowTest(unittest.TestCase):
    def test_crash_during_scan_shows_banner_after_restart_and_can_be_discarded(self):
        env = Env(self)
        crashed = env.new_session()
        crashed.start()
        fake_data.feed(crashed, clean=30)  # 30 颗触发 checkpoint
        env.clock.advance(2)

        # 重启：全新的控制器与 store，先 recover
        ui = make_controller(env)
        report = ui.store.recover()
        self.assertEqual(report["recovered_incomplete"], [crashed.session_id])
        banners = ui.state()["banners"]
        self.assertEqual(len(banners), 1)
        self.assertEqual(banners[0]["session_id"], crashed.session_id)
        self.assertEqual(banners[0]["bean_count_total"], 30)
        self.assertTrue(ui.state()["buttons"][0]["enabled"])  # 不阻断使用

        detail = ui.view_incomplete(crashed.session_id)
        self.assertFalse(detail["saveable"])
        ui.discard_incomplete(crashed.session_id, confirmed=True)
        self.assertEqual(ui.state()["banners"], [])
        self.assertIsNone(env.queue.next_pending())


class FakeDataTest(unittest.TestCase):
    def test_feed_updates_session_counts(self):
        env = Env(self)
        session = env.session_in_state("scanning")
        fake_data.feed(session, clean=4, defects={"fungus": 2}, unpaired=3)
        self.assertEqual(session.bean_count_total, 4 + 2 + 3)
        self.assertEqual(session.unpaired_count, 3)
        self.assertEqual(session.defect_counts["fungus"], 2)

    def test_feed_rejects_unknown_defect(self):
        env = Env(self)
        session = env.session_in_state("scanning")
        with self.assertRaises(ValueError):
            fake_data.feed(session, defects={"not_a_class": 1})


class BoundaryTest(unittest.TestCase):
    """界面层不含联网入口；界面逻辑与业务层解耦（票 08 验收项）。"""

    BANNED_IN_UI = ("wifi", "ssid", "password", "qrcode", "qr_", "bind", "token",
                    "绑定", "二维码", "配网", "pair_code", "pairing_code", "配对码")

    def ui_sources(self):
        for name in sorted(os.listdir(UI_DIR)):
            if name.endswith(".py"):
                yield name, code_lines(os.path.join(UI_DIR, name))

    def test_ui_code_has_no_wifi_pairing_or_binding_entry(self):
        for name, text in self.ui_sources():
            lowered = text.lower()
            for banned in self.BANNED_IN_UI:
                self.assertNotIn(banned, lowered, "%s 含有 %s" % (name, banned))

    def test_ui_pages_expose_no_network_buttons(self):
        env = Env(self)
        ui = make_controller(env)
        ids = [b["id"] for b in ui.state()["buttons"]]
        self.assertEqual(ids, ["start_scan", "open_settings"])
        ui.open_settings()
        text = repr(ui.state()).lower()
        for banned in ("wifi", "pair", "bind", "qr"):
            self.assertNotIn(banned, text)

    def test_ui_modules_do_not_import_lvgl_or_hardware_modules(self):
        for name, text in self.ui_sources():
            for banned in ("import lvgl", "from lvgl", "import machine", "from machine",
                           "import sensor", "from media", "import nncase", "import network"):
                self.assertNotIn(banned, text, "%s 含有 %s" % (name, banned))

    def test_ui_does_not_import_the_capture_layer(self):
        for name, text in self.ui_sources():
            self.assertNotIn("app.capture", text, name)

    def test_business_layer_never_imports_ui(self):
        for name in sorted(os.listdir(CORE_DIR)):
            if name.endswith(".py"):
                text = code_lines(os.path.join(CORE_DIR, name))
                self.assertNotIn("app.ui", text, name)

    def test_core_modules_load_without_pulling_in_the_ui_package(self):
        code = (
            "import sys\n"
            "import app.core.scan_session, app.core.queue, app.core.report, "
            "app.core.session_store, app.core.counting, app.core.config_manager\n"
            "bad = [m for m in sys.modules if m == 'app.ui' or m.startswith('app.ui.')]\n"
            "sys.exit(1 if bad else 0)\n"
        )
        done = subprocess.run([sys.executable, "-c", code], cwd=K230D_DIR)
        self.assertEqual(done.returncode, 0)

    def test_ui_uses_no_micropython_unfriendly_modules(self):
        for name, text in self.ui_sources():
            for banned in ("dataclasses", "pathlib", "import typing", "from typing", "tempfile"):
                self.assertNotIn(banned, text, "%s 含有 %s" % (name, banned))


class _PreviewCamera:
    def __init__(self, side):
        self.side = side
        self.open_calls = 0
        self.close_calls = 0

    def open(self):
        self.open_calls += 1

    def close(self):
        self.close_calls += 1

    def grab_low_res(self):
        return {"side": self.side, "image": [[0] * 4 for _ in range(4)], "t_ms": 0}


class DiagnosticsRoutingTest(unittest.TestCase):
    """票 10：控制器把诊断页接到设置页，离开即释放相机，扫描中进不去。"""

    def setUp(self):
        self.env = Env(self)
        self.front = _PreviewCamera("front")
        self.rear = _PreviewCamera("rear")
        store = SessionStore(base_dir=self.env.dir, clock=self.env.clock)
        config = ConfigManager(self.env.dir)
        self.ui = UIController(
            self.env.queue, store, config, self.env.new_session,
            diagnostics_factory=lambda: DiagnosticsPage(
                self.front, self.rear, is_scanning=lambda: self.ui.page_name == "scanning"),
        )

    def _enter_diagnostics(self):
        self.ui.open_settings()
        self.ui.open_diagnostics()

    def test_without_factory_diagnostics_stays_a_placeholder(self):
        store = SessionStore(base_dir=self.env.dir, clock=self.env.clock)
        ui = UIController(self.env.queue, store, ConfigManager(self.env.dir), self.env.new_session)
        ui.open_settings()
        ui.open_diagnostics()
        self.assertFalse(ui.state()["implemented"])
        self.assertFalse(ui.diagnostics_open()["started"])

    def test_preview_is_off_until_the_operator_opens_it(self):
        self._enter_diagnostics()
        self.assertEqual(self.front.open_calls, 0)
        self.assertIsNone(self.ui.diagnostics_tick(1000))
        self.assertTrue(self.ui.diagnostics_open()["started"])
        self.assertEqual((self.front.open_calls, self.rear.open_calls), (1, 1))

    def test_tick_runs_at_two_fps_through_the_controller(self):
        self._enter_diagnostics()
        self.ui.diagnostics_open()
        self.assertIsNotNone(self.ui.diagnostics_tick(1000))
        self.assertIsNone(self.ui.diagnostics_tick(1100))
        self.assertIsNotNone(self.ui.diagnostics_tick(1500))

    def test_back_closes_both_cameras_and_returns_to_settings(self):
        self._enter_diagnostics()
        self.ui.diagnostics_open()
        self.ui.back()
        self.assertEqual(self.ui.page_name, "settings")
        self.assertEqual((self.front.close_calls, self.rear.close_calls), (1, 1))
        self.assertIsNone(self.ui.diagnostics_tick(2000))

    def test_back_without_opening_preview_touches_no_camera(self):
        self._enter_diagnostics()
        self.ui.back()
        self.assertEqual((self.front.close_calls, self.rear.close_calls), (0, 0))

    def test_cannot_reach_diagnostics_while_scanning(self):
        self.ui.start_scan()
        self.assertEqual(self.ui.page_name, "scanning")
        with self.assertRaises(ValueError):
            self.ui.open_diagnostics()
        with self.assertRaises(ValueError):
            self.ui.diagnostics_open()
        self.assertEqual(self.front.open_calls, 0)

    def test_diagnostics_open_outside_diagnostics_page_is_rejected(self):
        with self.assertRaises(ValueError):
            self.ui.diagnostics_open()
        self.assertIsNone(self.ui.diagnostics_tick(1000))


if __name__ == "__main__":
    unittest.main()
