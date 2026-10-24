# 扫描中页逻辑（票 08）。纯逻辑，不依赖 LVGL。
# 只有 3 个大数字（豆粒总数 / 瑕疵豆总数 / 配对不明）和「停止」按钮；没有相机预览（ADR 0005）。
# 配对率低于 80% 时 state()["alerts"] 带提示，但不阻断「停止」。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
from app.core import scan_session
from app.ui import alerts

PAGE_ID = "scanning"
BUTTON_STOP = "stop"


class ScanningPage:
    def __init__(self, session):
        """session: 已 start() 的 ScanSession（状态必须是 scanning）。"""
        if session.state != scan_session.STATE_SCANNING:
            raise ValueError("扫描中页需要 scanning 状态的会话，实际是 %s" % session.state)
        self.session = session

    def defect_bean_total(self):
        """瑕疵豆总数 = 16 类瑕疵计数之和（配对不明不计入任何瑕疵类别）。"""
        total = 0
        for key in self.session.defect_counts:
            total += self.session.defect_counts[key]
        return total

    def state(self):
        session = self.session
        alert_list = []
        alert = alerts.pairing_alert(session.bean_count_total, session.unpaired_count)
        if alert is not None:
            alert_list.append(alert)
        return {
            "page": PAGE_ID,
            "camera_preview": False,
            "numbers": [
                {"id": "bean_total", "label": "豆粒总数", "value": session.bean_count_total},
                {"id": "defect_beans", "label": "瑕疵豆总数", "value": self.defect_bean_total()},
                {"id": "unpaired", "label": "配对不明", "value": session.unpaired_count},
            ],
            "alerts": alert_list,
            "buttons": [
                {"id": BUTTON_STOP, "label": "停止", "style": "danger", "enabled": True},
            ],
        }

    def stop(self):
        """点「停止」：冻结计数并进入 result_ready，返回下一页名 "result"。重复调用抛 InvalidTransition。"""
        self.session.stop()
        return "result"

    def tick(self):
        """主循环定期调用，透传给会话的 checkpoint 节奏；返回是否真的写盘。"""
        return self.session.tick()
