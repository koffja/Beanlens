# 待机页逻辑（票 08）。纯逻辑，不依赖 LVGL：state() 给出页面该显示什么，其余方法是按钮回调。
# - 队列积压条数 = 仍占位的条数（queue.capacity_check()["count"]，不含 saved，不含未完成会话）。
# - 未完成会话横幅：每条一个，可「滑走」（dismiss_banner，只在内存里隐藏，不删数据，
#   新建页面对象后会再出现），不阻断「开始扫描」。
# - 开始扫描前调 queue.can_start_scan()；不通过时不创建任何会话，返回 capacity_check()["message"]。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
import time

from app.core import counting
from app.core.session_errors import SessionError

PAGE_ID = "home"
QUOTA_TEXT = "v1 本地验证"
BUTTON_START = "start_scan"
BUTTON_SETTINGS = "open_settings"


def _clock_text(timestamp):
    t = time.localtime(timestamp)
    return "%02d:%02d" % (t[3], t[4])


class HomePage:
    def __init__(self, queue, store, session_factory):
        """queue: SubmissionQueue；store: SessionStore；session_factory: 无参函数，返回新的 pending ScanSession。"""
        self.queue = queue
        self.store = store
        self.session_factory = session_factory
        self._dismissed = []

    def _banner(self, snap):
        incomplete_at = snap.get("incomplete_at")
        if incomplete_at is None:
            incomplete_at = snap.get("updated_at", 0)
        beans = snap.get("bean_count_total", 0)
        text = "上次扫描未完成（%s，约 %d 颗），查看 / 丢弃" % (_clock_text(incomplete_at), beans)
        return {
            "session_id": snap["session_id"],
            "incomplete_at": incomplete_at,
            "bean_count_total": beans,
            "actions": ["view", "discard"],
            "text": text,
        }

    def state(self):
        capacity = self.queue.capacity_check()
        banners = []
        for snap in self.store.list_incomplete():
            if snap.get("session_id") in self._dismissed:
                continue
            banners.append(self._banner(snap))
        return {
            "page": PAGE_ID,
            "quota_text": QUOTA_TEXT,
            "queue_backlog": capacity["count"],
            "blocked_message": capacity["message"],
            "banners": banners,
            "buttons": [
                {"id": BUTTON_START, "label": "开始扫描", "enabled": not capacity["full"]},
                {"id": BUTTON_SETTINGS, "label": "设置", "enabled": True},
            ],
        }

    # ---- 按钮回调 ----

    def start_scan(self):
        """返回 {"started", "session", "message"}。队列触顶时不创建会话，message 是阻断原因。"""
        if not self.queue.can_start_scan():
            return {
                "started": False,
                "session": None,
                "message": self.queue.capacity_check()["message"],
            }
        session = self.session_factory()
        session.start()
        return {"started": True, "session": session, "message": ""}

    def open_settings(self):
        return "settings"

    # ---- 未完成会话横幅 ----

    def dismiss_banner(self, session_id):
        """滑走横幅：只在本页面对象里隐藏，不删除会话。"""
        if session_id not in self._dismissed:
            self._dismissed.append(session_id)

    def view_incomplete(self, session_id):
        """查看一条未完成会话的计数；它永不可保存，只能丢弃。找不到抛 SessionError。"""
        snap = self.store.get_incomplete(session_id)
        if snap is None:
            raise SessionError("找不到未完成会话: %s" % session_id)
        return {
            "session_id": snap["session_id"],
            "incomplete_at": snap.get("incomplete_at"),
            "bean_count_total": snap.get("bean_count_total", 0),
            "unpaired_count": snap.get("unpaired_count", 0),
            "groups": counting.group_counts(snap.get("defects", {})),
            "saveable": False,
            "actions": ["discard"],
        }

    def discard_incomplete(self, session_id, confirmed=False):
        """丢弃未完成会话；必须 confirmed=True，否则抛 DiscardNotConfirmed 且不删任何东西。"""
        self.store.discard_incomplete(session_id, confirmed=confirmed)
        if session_id in self._dismissed:
            self._dismissed.remove(session_id)
