# 设置页逻辑（票 08，接口 + 校验）。纯逻辑，不依赖 LVGL。
# - 样品重量：默认 350g，范围 300-400，校验沿用 ConfigManager，非法值不写盘。
# - 队列管理入口：积压条数、清空已保存、查看被拒项。
# - 诊断入口：只返回页面名，诊断页本身见 diagnostics.py（上板票 10 再补）。
# v1 没有 WiFi、配对、绑定账号的入口，这里不提供任何相关方法。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
from app.core import config_manager

PAGE_ID = "settings"


class SettingsPage:
    def __init__(self, config, queue):
        """config: ConfigManager；queue: SubmissionQueue。"""
        self.config = config
        self.queue = queue

    def state(self):
        return {
            "page": PAGE_ID,
            "sample_weight_g": self.config.load()["sample_weight_g"],
            "sample_weight_range": (
                config_manager.MIN_SAMPLE_WEIGHT_G,
                config_manager.MAX_SAMPLE_WEIGHT_G,
            ),
            "queue": {"backlog": self.queue.capacity_check()["count"]},
        }

    def set_sample_weight(self, value):
        """保存样品重量。返回 {"ok", "message"}；非法值不写盘，message 给出合法范围。"""
        try:
            self.config.set_sample_weight_g(value)
        except ValueError:
            return {
                "ok": False,
                "message": "样品重量必须在 %d-%d g 之间" % (
                    config_manager.MIN_SAMPLE_WEIGHT_G,
                    config_manager.MAX_SAMPLE_WEIGHT_G,
                ),
            }
        return {"ok": True, "message": ""}

    def rejected_items(self):
        """被拒项（failed_rejected）列表，从旧到新。"""
        return self.queue.list_rejected()

    def clear_saved(self):
        """清空已保存（saved）的元数据，返回被删的 operation_id 列表；不碰任何未保存的项。"""
        return self.queue.purge_saved(keep=0)

    def open_diagnostics(self):
        return "diagnostics"
