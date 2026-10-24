# 结果确认页逻辑（票 08）。纯逻辑，不依赖 LVGL。
# - 16 类分组用 counting.group_counts，预览计点用 counting.preview_points（带规则版本和「临时规则」角标，ADR 0001）。
# - 默认只显示非零项，零项折叠，可按组展开。
# - 只有「本地保存」「放弃」两个按钮，没有「继续扫描」（结果已冻结，补豆只能新开会话）。
# - 放弃必须带 confirmed=True 才调 session.discard()；request_discard() 只返回确认对话框内容，不改任何状态。
# - 预览计点只用于屏显，不写进记录体。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
from app.core import counting
from app.core import scan_session
from app.core.defect_classes import DEFECT_NAMES_ZH
from app.ui import alerts

PAGE_ID = "result"
BUTTON_SAVE = "save_local"
BUTTON_DISCARD = "discard"
GROUP_TITLES = {"category1": "一类瑕疵", "category2": "二类瑕疵"}
DISCARD_MESSAGE = "放弃后本次扫描结果不会保存，也不会上报。确定放弃吗？"


class ResultPage:
    def __init__(self, session, queue):
        """session: 状态为 result_ready 的 ScanSession；queue: SubmissionQueue。"""
        if session.state != scan_session.STATE_RESULT_READY:
            raise ValueError("结果页需要 result_ready 状态的会话，实际是 %s" % session.state)
        self.session = session
        self.queue = queue
        self._expanded = {"category1": False, "category2": False}

    def set_expanded(self, group, expanded):
        """展开 / 折叠某一组的零项。group 只能是 category1 或 category2。"""
        if group not in self._expanded:
            raise ValueError("未知分组: %r" % (group,))
        self._expanded[group] = bool(expanded)

    def _defect_bean_total(self):
        total = 0
        for key in self.session.defect_counts:
            total += self.session.defect_counts[key]
        return total

    def _group(self, name, pairs, points):
        items = []
        for pair in pairs:
            items.append({"key": pair[0], "name": DEFECT_NAMES_ZH[pair[0]], "count": pair[1]})
        expanded = self._expanded[name]
        visible = []
        folded = 0
        for item in items:
            if expanded or item["count"] > 0:
                visible.append(item)
            else:
                folded += 1
        return {
            "title": GROUP_TITLES[name],
            "points": points,
            "items": items,
            "visible_items": visible,
            "folded_zero_count": folded,
            "expanded": expanded,
        }

    def state(self):
        session = self.session
        grouped = counting.group_counts(session.defect_counts)
        preview = counting.preview_points(session.defect_counts)
        alert_list = []
        alert = alerts.pairing_alert(session.bean_count_total, session.unpaired_count)
        if alert is not None:
            alert_list.append(alert)
        settled = session.state != scan_session.STATE_RESULT_READY
        return {
            "page": PAGE_ID,
            "numbers": [
                {"id": "bean_total", "label": "豆粒总数", "value": session.bean_count_total},
                {"id": "defect_beans", "label": "瑕疵豆总数", "value": self._defect_bean_total()},
                {"id": "unpaired", "label": "配对不明", "value": session.unpaired_count},
                {"id": "category1_points", "label": "一类点数", "value": preview["category1_points"]},
                {"id": "category2_points", "label": "二类点数", "value": preview["category2_points"]},
                {"id": "preview_points", "label": "预览计点", "value": preview["preview_points"]},
            ],
            "preview": {
                "rule_version": preview["rule_version"],
                "provisional": preview["provisional"],
                "badge": preview["provisional_label"],
            },
            "groups": {
                "category1": self._group("category1", grouped["category1"], preview["category1_points"]),
                "category2": self._group("category2", grouped["category2"], preview["category2_points"]),
            },
            "alerts": alert_list,
            "buttons": [
                {"id": BUTTON_SAVE, "label": "本地保存", "style": "primary", "enabled": not settled},
                {"id": BUTTON_DISCARD, "label": "放弃", "style": "secondary", "enabled": not settled},
            ],
        }

    # ---- 按钮回调 ----

    def save_local(self):
        """点「本地保存」。返回 {"saved", "next_page", "message"}。

        计数自检不过（16 类之和大于豆粒总数）时不入队、会话保持 result_ready，message 给出原因。
        会话已不是 result_ready（重复点击）时抛 InvalidTransition。
        """
        try:
            self.session.save_to_queue(self.queue)
        except ValueError as e:
            return {"saved": False, "next_page": None, "message": str(e)}
        return {"saved": True, "next_page": "home", "message": ""}

    def request_discard(self):
        """点「放弃」第一步：只返回二次确认对话框内容，不改任何状态。"""
        return {
            "need_confirm": True,
            "message": DISCARD_MESSAGE,
            "confirm_label": "确认放弃",
            "cancel_label": "取消",
        }

    def discard(self, confirmed=False):
        """二次确认后调用：confirmed 必须是 True，否则抛 DiscardNotConfirmed 且不改任何东西。返回下一页名。"""
        self.session.discard(confirmed=confirmed)
        return "home"
