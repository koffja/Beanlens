import time
import unittest
from unittest import mock

from app.core import queue as queue_mod
from app.core.scan_session import DiscardNotConfirmed, SessionError
from app.core.session_store import SessionStore
from app.ui.home import HomePage
from queue_helpers import enqueue_new
from session_helpers import Env, record_exists


def make_incomplete(env, beans=3):
    """用公开接口造一条未完成会话（扫描中非正常退出）。"""
    session = env.new_session()
    session.start()
    for _ in range(beans):
        session.record_bean()
    env.clock.advance(5)
    session.mark_incomplete()
    return session


def clock_text(timestamp):
    t = time.localtime(timestamp)
    return "%02d:%02d" % (t[3], t[4])


class HomePageTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)
        self.store = SessionStore(base_dir=self.env.dir, clock=self.env.clock)
        self.home = HomePage(self.env.queue, self.store, self.env.new_session)

    def button(self, button_id):
        for button in self.home.state()["buttons"]:
            if button["id"] == button_id:
                return button
        self.fail("没有按钮 %s" % button_id)

    # ---- 基本内容 ----

    def test_idle_state_has_start_and_settings_buttons(self):
        state = self.home.state()
        self.assertEqual(state["page"], "home")
        self.assertEqual([b["id"] for b in state["buttons"]], ["start_scan", "open_settings"])
        self.assertEqual(self.button("start_scan")["label"], "开始扫描")
        self.assertEqual(self.button("open_settings")["label"], "设置")
        self.assertTrue(self.button("start_scan")["enabled"])
        self.assertTrue(self.button("open_settings")["enabled"])

    def test_quota_placeholder_text(self):
        self.assertEqual(self.home.state()["quota_text"], "v1 本地验证")

    def test_backlog_is_zero_on_empty_queue(self):
        self.assertEqual(self.home.state()["queue_backlog"], 0)

    def test_backlog_counts_queued_items_but_not_saved_ones(self):
        enqueue_new(self.env)
        done = enqueue_new(self.env)
        self.assertEqual(self.home.state()["queue_backlog"], 2)
        self.env.queue.mark_saving(done)
        self.env.queue.mark_saved(done, "rec-1")
        self.assertEqual(self.home.state()["queue_backlog"], 1)

    def test_open_settings_names_the_settings_page(self):
        self.assertEqual(self.home.open_settings(), "settings")

    # ---- 未完成会话横幅 ----

    def test_no_banner_when_nothing_incomplete(self):
        self.assertEqual(self.home.state()["banners"], [])

    def test_banner_shows_id_time_and_bean_count_with_view_and_discard(self):
        session = make_incomplete(self.env, beans=3)
        banners = self.home.state()["banners"]
        self.assertEqual(len(banners), 1)
        banner = banners[0]
        self.assertEqual(banner["session_id"], session.session_id)
        self.assertEqual(banner["incomplete_at"], self.env.clock())
        self.assertEqual(banner["bean_count_total"], 3)
        self.assertEqual(banner["actions"], ["view", "discard"])
        self.assertIn("上次扫描未完成", banner["text"])
        self.assertIn(clock_text(self.env.clock()), banner["text"])
        self.assertIn("约 3 颗", banner["text"])
        self.assertIn("查看", banner["text"])
        self.assertIn("丢弃", banner["text"])

    def test_one_banner_per_incomplete_session(self):
        first = make_incomplete(self.env, beans=1)
        self.env.clock.advance(60)
        second = make_incomplete(self.env, beans=2)
        ids = [b["session_id"] for b in self.home.state()["banners"]]
        self.assertEqual(sorted(ids), sorted([first.session_id, second.session_id]))

    def test_banner_does_not_block_starting_a_scan(self):
        make_incomplete(self.env)
        self.assertTrue(self.button("start_scan")["enabled"])
        result = self.home.start_scan()
        self.assertTrue(result["started"])
        self.assertEqual(result["session"].state, "scanning")

    def test_incomplete_sessions_do_not_count_toward_backlog_or_capacity(self):
        for _ in range(3):
            make_incomplete(self.env)
        self.assertEqual(self.home.state()["queue_backlog"], 0)
        with mock.patch.object(queue_mod, "MAX_QUEUE_ENTRIES", 2):
            self.assertTrue(self.home.start_scan()["started"])

    def test_dismiss_hides_the_banner_without_deleting_the_session(self):
        keep = make_incomplete(self.env, beans=1)
        gone = make_incomplete(self.env, beans=2)
        self.home.dismiss_banner(gone.session_id)
        ids = [b["session_id"] for b in self.home.state()["banners"]]
        self.assertEqual(ids, [keep.session_id])
        self.assertTrue(record_exists(self.env.incomplete_path(gone.session_id)))
        self.assertEqual(len(self.store.list_incomplete()), 2)

    def test_dismissed_banner_comes_back_on_a_fresh_page(self):
        session = make_incomplete(self.env)
        self.home.dismiss_banner(session.session_id)
        self.assertEqual(self.home.state()["banners"], [])
        fresh = HomePage(self.env.queue, self.store, self.env.new_session)
        self.assertEqual(len(fresh.state()["banners"]), 1)

    # ---- 查看 / 丢弃 ----

    def test_view_incomplete_shows_counts_and_is_not_saveable(self):
        session = self.env.new_session()
        session.start()
        session.record_bean(defect="full_black")
        session.record_bean(unpaired=True)
        session.record_bean()
        session.mark_incomplete()
        detail = self.home.view_incomplete(session.session_id)
        self.assertEqual(detail["session_id"], session.session_id)
        self.assertEqual(detail["bean_count_total"], 3)
        self.assertEqual(detail["unpaired_count"], 1)
        self.assertIs(detail["saveable"], False)
        self.assertEqual(detail["actions"], ["discard"])
        groups = dict(detail["groups"]["category1"])
        self.assertEqual(groups["full_black"], 1)
        self.assertEqual(len(detail["groups"]["category1"]), 6)
        self.assertEqual(len(detail["groups"]["category2"]), 10)

    def test_view_unknown_incomplete_session_raises(self):
        with self.assertRaises(SessionError):
            self.home.view_incomplete("sess-nope")

    def test_discard_without_confirmation_keeps_the_session(self):
        session = make_incomplete(self.env)
        for kwargs in ({}, {"confirmed": False}, {"confirmed": 1}):
            with self.assertRaises(DiscardNotConfirmed):
                self.home.discard_incomplete(session.session_id, **kwargs)
        self.assertTrue(record_exists(self.env.incomplete_path(session.session_id)))
        self.assertEqual(len(self.home.state()["banners"]), 1)

    def test_confirmed_discard_removes_session_and_banner(self):
        session = make_incomplete(self.env)
        self.home.discard_incomplete(session.session_id, confirmed=True)
        self.assertFalse(record_exists(self.env.incomplete_path(session.session_id)))
        self.assertEqual(self.home.state()["banners"], [])
        self.assertIsNone(self.env.queue.next_pending())

    # ---- 开始扫描 ----

    def test_start_scan_creates_and_starts_a_session(self):
        result = self.home.start_scan()
        self.assertTrue(result["started"])
        self.assertEqual(result["message"], "")
        self.assertEqual(result["session"].state, "scanning")

    def test_full_queue_blocks_start_and_shows_the_reason(self):
        with mock.patch.object(queue_mod, "MAX_QUEUE_ENTRIES", 2):
            enqueue_new(self.env)
            enqueue_new(self.env)
            expected = self.env.queue.capacity_check()["message"]
            self.assertNotEqual(expected, "")
            state = self.home.state()
            self.assertFalse(self.button("start_scan")["enabled"])
            self.assertEqual(state["blocked_message"], expected)
            before = self.env.tree()
            result = self.home.start_scan()
        self.assertFalse(result["started"])
        self.assertIsNone(result["session"])
        self.assertEqual(result["message"], expected)
        self.assertEqual(self.env.tree(), before)  # 被阻断时没有创建任何会话文件

    def test_not_full_queue_has_empty_blocked_message(self):
        self.assertEqual(self.home.state()["blocked_message"], "")


if __name__ == "__main__":
    unittest.main()
