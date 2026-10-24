import unittest

from app.core import counting
from app.core.defect_classes import DEFECT_NAMES_ZH
from app.core.scan_session import DiscardNotConfirmed, InvalidTransition
from app.ui.result import ResultPage
from session_helpers import Env, read, record_exists


def finished_session(env, defects=None, unpaired=0, clean=0):
    """用公开接口造一个 result_ready 会话：defects 是 {类别: 颗数}，另有 clean 颗无瑕疵、unpaired 颗配对不明。"""
    session = env.new_session()
    session.start()
    if defects:
        for key in defects:
            for _ in range(defects[key]):
                session.record_bean(defect=key)
    for _ in range(clean):
        session.record_bean()
    for _ in range(unpaired):
        session.record_bean(unpaired=True)
    env.clock.advance(7)
    session.stop()
    return session


class ResultPageTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)
        self.session = finished_session(
            self.env,
            defects={"full_black": 2, "partial_black": 3, "shell": 1},
            clean=10,
            unpaired=1,
        )
        self.page = ResultPage(self.session, self.env.queue)

    def numbers(self):
        return dict((n["id"], n) for n in self.page.state()["numbers"])

    def button_ids(self):
        return [b["id"] for b in self.page.state()["buttons"]]

    # ---- 数字区 ----

    def test_number_labels_use_the_agreed_names(self):
        labels = dict((n["id"], n["label"]) for n in self.page.state()["numbers"])
        self.assertEqual(labels["bean_total"], "豆粒总数")
        self.assertEqual(labels["defect_beans"], "瑕疵豆总数")
        self.assertEqual(labels["unpaired"], "配对不明")

    def test_totals_come_from_the_session(self):
        numbers = self.numbers()
        self.assertEqual(numbers["bean_total"]["value"], 17)
        self.assertEqual(numbers["defect_beans"]["value"], 6)
        self.assertEqual(numbers["unpaired"]["value"], 1)

    def test_category_points_match_counting_preview_points(self):
        expected = counting.preview_points(self.session.defect_counts)
        numbers = self.numbers()
        self.assertEqual(numbers["category1_points"]["value"], expected["category1_points"])
        self.assertEqual(numbers["category2_points"]["value"], expected["category2_points"])
        self.assertEqual(numbers["preview_points"]["value"], expected["preview_points"])
        self.assertEqual(numbers["category1_points"]["label"], "一类点数")
        self.assertEqual(numbers["category2_points"]["label"], "二类点数")
        self.assertEqual(numbers["preview_points"]["label"], "预览计点")

    def test_known_point_values(self):
        # 全黑豆 1:1 -> 2 点；局部黑豆 3:1 -> 3 颗 = 1 点
        numbers = self.numbers()
        self.assertEqual(numbers["category1_points"]["value"], 2)
        self.assertEqual(numbers["category2_points"]["value"], 1 + 1 / 5)
        self.assertAlmostEqual(numbers["preview_points"]["value"], 3 + 1 / 5)

    # ---- 临时规则角标 ----

    def test_preview_shows_rule_version_and_provisional_badge(self):
        preview = self.page.state()["preview"]
        expected = counting.preview_points(self.session.defect_counts)
        self.assertEqual(preview["rule_version"], expected["rule_version"])
        self.assertNotEqual(preview["rule_version"], "")
        self.assertIs(preview["provisional"], True)
        self.assertEqual(preview["badge"], "临时规则")

    # ---- 16 类分组 ----

    def test_groups_have_six_plus_ten_in_rule_file_order(self):
        groups = self.page.state()["groups"]
        expected = counting.group_counts(self.session.defect_counts)
        self.assertEqual(len(groups["category1"]["items"]), 6)
        self.assertEqual(len(groups["category2"]["items"]), 10)
        self.assertEqual([i["key"] for i in groups["category1"]["items"]],
                         [k for k, _ in expected["category1"]])
        self.assertEqual([i["key"] for i in groups["category2"]["items"]],
                         [k for k, _ in expected["category2"]])

    def test_group_items_carry_chinese_names_and_counts(self):
        groups = self.page.state()["groups"]
        items = dict((i["key"], i) for i in groups["category1"]["items"])
        self.assertEqual(items["full_black"]["name"], DEFECT_NAMES_ZH["full_black"])
        self.assertEqual(items["full_black"]["count"], 2)
        self.assertEqual(items["fungus"]["count"], 0)

    def test_group_titles_and_points(self):
        groups = self.page.state()["groups"]
        self.assertEqual(groups["category1"]["title"], "一类瑕疵")
        self.assertEqual(groups["category2"]["title"], "二类瑕疵")
        self.assertEqual(groups["category1"]["points"], 2)

    def test_zero_items_are_folded_by_default(self):
        groups = self.page.state()["groups"]
        shown1 = [i["key"] for i in groups["category1"]["visible_items"]]
        shown2 = [i["key"] for i in groups["category2"]["visible_items"]]
        self.assertEqual(shown1, ["full_black"])
        self.assertEqual(sorted(shown2), ["partial_black", "shell"])
        self.assertEqual(groups["category1"]["folded_zero_count"], 5)
        self.assertEqual(groups["category2"]["folded_zero_count"], 8)
        self.assertFalse(groups["category1"]["expanded"])

    def test_zero_items_can_be_expanded_and_collapsed_again(self):
        self.page.set_expanded("category1", True)
        group = self.page.state()["groups"]["category1"]
        self.assertTrue(group["expanded"])
        self.assertEqual(len(group["visible_items"]), 6)
        self.assertEqual(group["folded_zero_count"], 0)
        # 另一组不受影响
        self.assertEqual(len(self.page.state()["groups"]["category2"]["visible_items"]), 2)
        self.page.set_expanded("category1", False)
        self.assertEqual(len(self.page.state()["groups"]["category1"]["visible_items"]), 1)

    def test_set_expanded_rejects_unknown_group(self):
        with self.assertRaises(ValueError):
            self.page.set_expanded("category3", True)

    def test_all_zero_session_shows_nothing_until_expanded(self):
        page = ResultPage(finished_session(Env(self), clean=5), self.env.queue)
        groups = page.state()["groups"]
        self.assertEqual(groups["category1"]["visible_items"], [])
        self.assertEqual(groups["category2"]["visible_items"], [])
        self.assertEqual(page.state()["preview"]["badge"], "临时规则")

    # ---- 按钮：只有「本地保存」「放弃」，没有「继续扫描」----

    def test_exactly_save_and_discard_buttons(self):
        self.assertEqual(self.button_ids(), ["save_local", "discard"])
        labels = [b["label"] for b in self.page.state()["buttons"]]
        self.assertEqual(labels, ["本地保存", "放弃"])
        styles = [b["style"] for b in self.page.state()["buttons"]]
        self.assertEqual(styles, ["primary", "secondary"])

    def test_there_is_no_continue_scanning_entry(self):
        state_text = repr(self.page.state())
        self.assertNotIn("继续扫描", state_text)
        self.assertNotIn("continue", state_text)
        self.assertFalse(hasattr(self.page, "continue_scan"))
        self.assertFalse(hasattr(self.page, "start_scan"))

    # ---- 配对提示 ----

    def test_no_alert_when_pairing_is_healthy(self):
        self.assertEqual(self.page.state()["alerts"], [])

    def test_alert_when_unpaired_over_twenty_percent(self):
        session = finished_session(self.env, clean=6, unpaired=4)
        alerts = ResultPage(session, self.env.queue).state()["alerts"]
        self.assertEqual(len(alerts), 1)
        self.assertIn("豆路对准或光照异常", alerts[0]["message"])

    # ---- 放弃：二次确认 ----

    def test_request_discard_returns_a_confirmation_dialog_and_changes_nothing(self):
        before = self.env.tree()
        dialog = self.page.request_discard()
        self.assertIs(dialog["need_confirm"], True)
        self.assertIn("放弃", dialog["message"])
        self.assertEqual(dialog["confirm_label"], "确认放弃")
        self.assertEqual(dialog["cancel_label"], "取消")
        self.assertEqual(self.session.state, "result_ready")
        self.assertEqual(self.env.tree(), before)

    def test_discard_without_confirmed_flag_is_refused(self):
        before = self.env.tree()
        for kwargs in ({}, {"confirmed": False}, {"confirmed": None}, {"confirmed": 1}):
            with self.assertRaises(DiscardNotConfirmed):
                self.page.discard(**kwargs)
        self.assertEqual(self.session.state, "result_ready")
        self.assertEqual(self.env.tree(), before)

    def test_confirmed_discard_moves_the_session_to_discarded(self):
        self.assertEqual(self.page.discard(confirmed=True), "home")
        self.assertEqual(self.session.state, "discarded")
        kept = read(self.env.discarded_path(self.session.session_id))
        self.assertEqual(kept["state"], "discarded")
        self.assertFalse(record_exists(self.env.active_path(self.session.session_id)))
        self.assertIsNone(self.env.queue.next_pending())

    def test_discard_twice_is_refused(self):
        self.page.discard(confirmed=True)
        with self.assertRaises(InvalidTransition):
            self.page.discard(confirmed=True)

    # ---- 本地保存 ----

    def test_save_local_enqueues_the_record_and_goes_home(self):
        result = self.page.save_local()
        self.assertTrue(result["saved"])
        self.assertEqual(result["next_page"], "home")
        self.assertEqual(result["message"], "")
        self.assertEqual(self.session.state, "queued")
        entry = self.env.queue.next_pending()
        self.assertEqual(entry["operation_id"], self.session.operation_id)
        self.assertEqual(entry["record"]["bean_count_total"], 17)
        self.assertFalse(record_exists(self.env.active_path(self.session.session_id)))

    def test_save_local_record_has_no_points_or_grade(self):
        self.page.save_local()
        record = self.env.queue.next_pending()["record"]
        text = repr(record)
        for banned in ("preview_points", "category1_points", "rule_version", "grade", "provisional"):
            self.assertNotIn(banned, text)

    def test_inconsistent_counts_block_saving_and_show_the_reason(self):
        # 16 类之和 > 豆粒总数：计数链路有 bug，不允许入队（ADR 0002）
        self.session.defect_counts["full_black"] = 999
        before = self.env.tree()
        result = self.page.save_local()
        self.assertFalse(result["saved"])
        self.assertIsNone(result["next_page"])
        self.assertIn("计数不自洽", result["message"])
        self.assertEqual(self.session.state, "result_ready")
        self.assertIsNone(self.env.queue.next_pending())
        self.assertEqual(self.env.tree(), before)

    def test_save_twice_is_refused(self):
        self.page.save_local()
        with self.assertRaises(InvalidTransition):
            self.page.save_local()
        self.assertEqual(len(self.env.queue.list_all()), 1)

    # ---- 页面只接受 result_ready 会话 ----

    def test_page_refuses_a_session_that_is_not_result_ready(self):
        for state in ("pending", "scanning", "queued", "saved", "discarded", "incomplete"):
            session = Env(self).session_in_state(state)
            with self.assertRaises(ValueError):
                ResultPage(session, self.env.queue)

    # ---- 页面状态在保存/放弃后不再提供按钮 ----

    def test_buttons_are_disabled_after_the_session_is_settled(self):
        self.page.save_local()
        for button in self.page.state()["buttons"]:
            self.assertFalse(button["enabled"])


if __name__ == "__main__":
    unittest.main()
