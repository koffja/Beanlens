import unittest

from app.core.scan_session import InvalidTransition
from app.ui.scanning import ScanningPage
from session_helpers import Env


class ScanningPageTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)
        self.session = self.env.session_in_state("scanning")
        self.page = ScanningPage(self.session)

    def numbers(self):
        return dict((n["id"], n) for n in self.page.state()["numbers"])

    # ---- 页面内容：只有 3 个大数字和「停止」----

    def test_exactly_three_big_numbers_with_the_agreed_names(self):
        numbers = self.page.state()["numbers"]
        self.assertEqual([n["id"] for n in numbers],
                         ["bean_total", "defect_beans", "unpaired"])
        self.assertEqual([n["label"] for n in numbers],
                         ["豆粒总数", "瑕疵豆总数", "配对不明"])

    def test_only_one_button_stop(self):
        buttons = self.page.state()["buttons"]
        self.assertEqual(len(buttons), 1)
        self.assertEqual(buttons[0]["id"], "stop")
        self.assertEqual(buttons[0]["label"], "停止")
        self.assertEqual(buttons[0]["style"], "danger")
        self.assertTrue(buttons[0]["enabled"])

    def test_no_camera_preview_anywhere_in_state(self):
        state = self.page.state()
        self.assertEqual(state["page"], "scanning")
        self.assertIs(state["camera_preview"], False)
        for key in state:
            self.assertNotIn("preview", key.replace("camera_preview", ""))

    def test_counts_start_at_zero(self):
        for number in self.page.state()["numbers"]:
            self.assertEqual(number["value"], 0)

    # ---- 数字随会话更新 ----

    def test_numbers_follow_the_session(self):
        self.session.record_bean()
        self.session.record_bean(defect="full_black")
        self.session.record_bean(defect="partial_sour")
        self.session.record_bean(unpaired=True)
        numbers = self.numbers()
        self.assertEqual(numbers["bean_total"]["value"], 4)
        self.assertEqual(numbers["defect_beans"]["value"], 2)
        self.assertEqual(numbers["unpaired"]["value"], 1)

    def test_unpaired_beans_are_not_counted_as_defect_beans(self):
        self.session.record_bean(unpaired=True)
        self.session.record_bean(unpaired=True)
        numbers = self.numbers()
        self.assertEqual(numbers["defect_beans"]["value"], 0)
        self.assertEqual(numbers["unpaired"]["value"], 2)

    # ---- 配对提示 ----

    def test_no_alert_when_pairing_is_healthy(self):
        for _ in range(10):
            self.session.record_bean()
        self.session.record_bean(unpaired=True)
        self.assertEqual(self.page.state()["alerts"], [])

    def test_alert_appears_when_unpaired_over_twenty_percent(self):
        for _ in range(7):
            self.session.record_bean()
        for _ in range(3):
            self.session.record_bean(unpaired=True)
        alerts = self.page.state()["alerts"]
        self.assertEqual(len(alerts), 1)
        self.assertEqual(alerts[0]["kind"], "pairing")
        self.assertIn("豆路对准或光照异常", alerts[0]["message"])

    def test_alert_does_not_block_stopping(self):
        for _ in range(3):
            self.session.record_bean(unpaired=True)
        self.assertEqual(len(self.page.state()["alerts"]), 1)
        self.assertTrue(self.page.state()["buttons"][0]["enabled"])
        self.page.stop()
        self.assertEqual(self.session.state, "result_ready")

    # ---- 停止 ----

    def test_stop_freezes_the_session_and_names_the_result_page(self):
        self.session.record_bean()
        self.env.clock.advance(4)
        self.assertEqual(self.page.stop(), "result")
        self.assertEqual(self.session.state, "result_ready")
        self.assertEqual(self.session.duration_s, 4)

    def test_stop_twice_is_refused(self):
        self.page.stop()
        with self.assertRaises(InvalidTransition):
            self.page.stop()

    # ---- 只接受扫描中的会话 ----

    def test_page_refuses_a_session_that_is_not_scanning(self):
        for state in ("pending", "result_ready", "discarded", "incomplete"):
            session = Env(self).session_in_state(state)
            with self.assertRaises(ValueError):
                ScanningPage(session)

    # ---- tick 透传 checkpoint ----

    def test_tick_writes_a_checkpoint_after_the_interval(self):
        self.session.record_bean()
        self.env.clock.advance(6)
        self.assertTrue(self.page.tick())


if __name__ == "__main__":
    unittest.main()
