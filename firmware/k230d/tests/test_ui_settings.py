import unittest

from app.core.config_manager import ConfigManager
from app.ui.diagnostics import DiagnosticsPage
from app.ui.settings import SettingsPage
from tests.queue_helpers import enqueue_new
from tests.session_helpers import Env


class SettingsPageTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)
        self.config = ConfigManager(self.env.dir)
        self.page = SettingsPage(self.config, self.env.queue)

    def test_state_shows_default_sample_weight_and_range(self):
        state = self.page.state()
        self.assertEqual(state["page"], "settings")
        self.assertEqual(state["sample_weight_g"], 350)
        self.assertEqual(state["sample_weight_range"], (300, 400))

    def test_set_sample_weight_saves_valid_values(self):
        for value in (300, 380, 400):
            result = self.page.set_sample_weight(value)
            self.assertTrue(result["ok"])
            self.assertEqual(result["message"], "")
            self.assertEqual(self.page.state()["sample_weight_g"], value)
            self.assertEqual(self.config.load()["sample_weight_g"], value)

    def test_out_of_range_or_bad_type_is_rejected_and_not_saved(self):
        self.page.set_sample_weight(360)
        before = self.env.tree()
        for bad in (299, 401, 0, -5, "350", None, True):
            result = self.page.set_sample_weight(bad)
            self.assertFalse(result["ok"], repr(bad))
            self.assertIn("300", result["message"])
            self.assertIn("400", result["message"])
        self.assertEqual(self.config.load()["sample_weight_g"], 360)
        self.assertEqual(self.env.tree(), before)

    def test_queue_summary_counts_and_rejected_list(self):
        keep = enqueue_new(self.env)
        bad = enqueue_new(self.env)
        self.env.queue.mark_saving(bad)
        self.env.queue.mark_failed(bad, 400, "数据校验失败")
        summary = self.page.state()["queue"]
        self.assertEqual(summary["backlog"], 2)
        self.assertEqual([e["operation_id"] for e in self.page.rejected_items()], [bad])
        self.assertNotEqual(keep, bad)

    def test_clear_saved_keeps_everything_that_is_not_saved(self):
        done = enqueue_new(self.env)
        waiting = enqueue_new(self.env)
        self.env.queue.mark_saving(done)
        self.env.queue.mark_saved(done, "rec-1")
        removed = self.page.clear_saved()
        self.assertEqual(removed, [done])
        self.assertIsNotNone(self.env.queue.get_entry(waiting))
        self.assertIsNone(self.env.queue.get_entry(done))

    def test_open_diagnostics_names_the_page(self):
        self.assertEqual(self.page.open_diagnostics(), "diagnostics")

    def test_settings_has_no_network_or_pairing_entry(self):
        text = repr(self.page.state()).lower()
        for banned in ("wifi", "ssid", "password", "pair", "bind", "配对", "绑定", "二维码", "配网"):
            self.assertNotIn(banned, text)
        for name in dir(self.page):
            for banned in ("wifi", "pair", "bind", "qr"):
                self.assertNotIn(banned, name.lower())


class DiagnosticsPageTest(unittest.TestCase):
    def test_placeholder_state_says_it_is_not_implemented_yet(self):
        page = DiagnosticsPage()
        state = page.state()
        self.assertEqual(state["page"], "diagnostics")
        self.assertFalse(state["preview_running"])
        self.assertFalse(state["implemented"])
        self.assertIn("上板", state["notice"])

    def test_open_and_close_do_not_start_any_camera(self):
        page = DiagnosticsPage()
        self.assertEqual(page.open(), {"started": False, "message": page.state()["notice"]})
        self.assertFalse(page.state()["preview_running"])
        self.assertEqual(page.close(), "settings")

    def test_preview_rate_is_two_fps_per_architecture(self):
        self.assertEqual(DiagnosticsPage().state()["preview_fps"], 2)

    # ---- 预览骨架（票 10，传相机后走预览，不传时保持桩行为）----

    def test_open_with_cameras_starts_preview(self):
        front = FakeCamera("front")
        rear = FakeCamera("rear")
        page = DiagnosticsPage(front, rear)
        result = page.open()
        self.assertTrue(result["started"])
        self.assertEqual(result["message"], "")
        self.assertTrue(page.state()["preview_running"])
        self.assertTrue(page.state()["implemented"])
        self.assertEqual(front.open_calls, 1)
        self.assertEqual(rear.open_calls, 1)

    def test_tick_returns_none_when_not_running(self):
        front = FakeCamera("front")
        rear = FakeCamera("rear")
        page = DiagnosticsPage(front, rear)
        self.assertIsNone(page.tick(1000))

    def test_tick_grabs_frames_at_2fps(self):
        front = FakeCamera("front")
        rear = FakeCamera("rear")
        page = DiagnosticsPage(front, rear)
        page.open()
        now = 1000
        result = page.tick(now)
        self.assertIsNotNone(result)
        self.assertIn("front", result)
        self.assertIn("rear", result)
        self.assertEqual(page.state()["frames_shown"], 1)
        self.assertIsNone(page.tick(now + 100))  # 不足 500ms，跳过
        result2 = page.tick(now + 500)
        self.assertIsNotNone(result2)
        self.assertEqual(page.state()["frames_shown"], 2)

    def test_close_stops_preview_and_releases_cameras(self):
        front = FakeCamera("front")
        rear = FakeCamera("rear")
        page = DiagnosticsPage(front, rear)
        page.open()
        page.tick(1000)
        page.close()
        self.assertFalse(page.state()["preview_running"])
        self.assertEqual(front.close_calls, 1)
        self.assertEqual(rear.close_calls, 1)

    def test_open_during_scanning_is_refused(self):
        front = FakeCamera("front")
        rear = FakeCamera("rear")
        page = DiagnosticsPage(front, rear, is_scanning=lambda: True)
        result = page.open()
        self.assertFalse(result["started"])
        self.assertIn("扫描中", result["message"])
        self.assertEqual(front.open_calls, 0)

    def test_detector_output_appears_in_boxes(self):
        front = FakeCamera("front")
        rear = FakeCamera("rear")
        detector = FakeDetector([{"label": "shell", "score": 0.9, "bbox": (0, 0, 4, 4)}])
        page = DiagnosticsPage(front, rear, detector)
        page.open()
        result = page.tick(1000)
        self.assertEqual(len(result["boxes"]["front"]), 1)
        self.assertEqual(result["boxes"]["front"][0]["label"], "shell")

    def test_mismatched_camera_pair_is_rejected(self):
        with self.assertRaises(ValueError):
            DiagnosticsPage(FakeCamera("front"), None)


class FakeCamera:
    def __init__(self, side):
        self.side = side
        self.open_calls = 0
        self.close_calls = 0

    def open(self):
        self.open_calls += 1

    def close(self):
        self.close_calls += 1

    def grab_low_res(self):
        return {"side": self.side, "image": [[0] * 20 for _ in range(20)], "t_ms": 1000}


class FakeDetector:
    def __init__(self, output=None):
        self.output = output or []

    def infer(self, crops):
        return [self.output for _ in crops]


if __name__ == "__main__":
    unittest.main()
