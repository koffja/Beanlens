# 票 11：固件启动流程（主机验证骨架，板侧真实 LVGL / CanMV 调用待上板补全）。
# 启动顺序：
#   1. 从磁盘恢复队列（queue.recover），将 saving 状态项回退到 pending。
#   2. 从磁盘恢复未完成会话（store.recover），清理损坏的临时文件。
#   3. 初始化 UIController，进入待机页（home）。
#   4. 进入 LVGL 主循环（占位注释，上板时换成真实 lvgl.scr_act() 绑定与事件循环）。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
import os
import sys
import time

# 板侧：把项目根目录加入 sys.path，使得 `from app.core import ...` 能正常导入。
FIRMWARE_DIR = os.path.dirname(os.path.abspath(__file__))
if FIRMWARE_DIR not in sys.path:
    sys.path.insert(0, os.path.dirname(FIRMWARE_DIR))

from app.core.config_manager import ConfigManager
from app.core.queue import SubmissionQueue
from app.core.scan_session import ScanSession
from app.core.session_store import SessionStore
from app.ui.controller import UIController

# 板侧路径规划（ADR 0003）：数据目录固定在 /sdcard/beanlens/data/。
# 主机测试时可传入 base_dir 覆盖（供 test_main.py 使用）。
DEFAULT_BASE_DIR = "/sdcard/beanlens/data"


def _make_session_factory(store, config):
    """返回一个无参函数，创建新 pending 会话（供 HomePage 使用）。"""
    def factory():
        # 构造即写 pending checkpoint；start() 由 HomePage.start_scan 调用。
        weight = config.load()["sample_weight_g"]
        return ScanSession(base_dir=store.base_dir, sample_weight_g=weight)
    return factory


def startup(base_dir=None, diagnostics_factory=None):
    """启动固件：恢复队列、恢复会话、初始化 UI 控制器。

    返回 {"ui", "queue", "store", "config", "queue_report", "store_report"}。
    主机测试时传入 base_dir；板侧运行时不传，使用 DEFAULT_BASE_DIR。
    diagnostics_factory：板侧注入的无参函数，返回带双摄与检测器的 DiagnosticsPage；
    不传则诊断页保持占位（相机接入需上板验证，见票 06 / 10）。
    """
    if base_dir is None:
        base_dir = DEFAULT_BASE_DIR
    # 确保数据目录存在
    if not os.path.exists(base_dir):
        os.makedirs(base_dir)

    # 1. 恢复队列：saving 状态项回退到 pending，清理半写的 .tmp 文件
    queue = SubmissionQueue(base_dir=base_dir)
    queue_report = queue.recover()

    # 2. 恢复会话存储：清理损坏的临时文件，加载未完成会话列表
    store = SessionStore(base_dir=base_dir)
    store_report = store.recover()

    # 3. 初始化配置与 UI 控制器
    config = ConfigManager(base_dir=base_dir)
    # 确保配置文件存在：首次启动时写入默认值
    if not os.path.exists(config.capture_config_path):
        import json
        # 与仓库内 firmware/k230d/capture_config.json 保持一致；ΔT 等数值待票 06/12 上板标定后回填。
        defaults = {
            "csi1": {"width": 640, "height": 480, "fps": 30},
            "csi2": {"width": 640, "height": 480, "fps": 30},
            "roi_queue_max": 3,
            "roi_size_max": [320, 320],
            "time_pair_tolerance_ms": 66,
            "motion_threshold": 25,
            "trigger_cooldown_ms": 50,
        }
        with open(config.capture_config_path, "w") as f:
            json.dump(defaults, f)
    ui = UIController(queue, store, config, _make_session_factory(store, config),
                      diagnostics_factory=diagnostics_factory)

    return {
        "ui": ui,
        "queue": queue,
        "store": store,
        "config": config,
        "queue_report": queue_report,
        "store_report": store_report,
    }


def main_loop(ui):
    """LVGL 主循环（占位）。板侧上线时替换为真实 LVGL 事件循环。

    占位行为：打印当前页面状态，每秒刷新一次，按 Ctrl+C 退出。
    板侧真实代码示例（不在主机运行）：
        # import lvgl as lv
        # screen = lv.scr_act()
        # _bind_ui_buttons(screen, ui)  # 绑定按钮回调
        # while True:
        #     lv.task_handler()
        #     time.sleep_ms(5)
    """
    print("进入 LVGL 主循环（占位）。当前页面：%s" % ui.page_name)
    try:
        while True:
            state = ui.state()
            print("页面状态：%s" % state["page"])
            time.sleep(1)
    except KeyboardInterrupt:
        print("用户中断，退出。")


if __name__ == "__main__":
    # 板侧：直接调用 startup() + main_loop(ui)。
    # 主机测试：在 test_main.py 里用 tempdir 调用 startup(base_dir=...)。
    result = startup()
    main_loop(result["ui"])
