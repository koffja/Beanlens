"""票 02 测试共用的小工具：可注入时钟、临时目录环境、按状态造会话。只在测试里用 tempfile。"""
import json
import os
import shutil
import tempfile

from app.core import storage
from app.core.queue import SubmissionQueue
from app.core.scan_session import ScanSession

CLOCK_START = 1800000000

DEFAULT_CAPTURE_CONFIG = {
    "csi1": {"width": 640, "height": 480, "fps": 30},
    "csi2": {"width": 640, "height": 480, "fps": 30},
    "roi_queue_max": 3,
    "roi_size_max": [320, 320],
    "time_pair_tolerance_ms": 66,
    "motion_threshold": 25,
    "trigger_cooldown_ms": 50,
}

DEFAULT_DEVICE_INFO = {
    "manufacturer": "K230D BOX",
    "model": "v1.0",
    "serial_number": "DEV0000",
    "firmware_version": "YYMMDDHHMM",
    "operator": "",
}


class FakeClock:
    """可注入时钟：测试里用 advance() 推进时间，不真实等待。"""

    def __init__(self, start=CLOCK_START):
        self.now = start

    def __call__(self):
        return self.now

    def advance(self, seconds):
        self.now += seconds


class Env:
    """一个临时 base_dir + 共用时钟 + 队列。用例结束自动删除目录。"""

    def __init__(self, test):
        self.dir = tempfile.mkdtemp(prefix="beanlens-test-")
        test.addCleanup(shutil.rmtree, self.dir, True)
        self.clock = FakeClock()
        self.queue = SubmissionQueue(base_dir=self.dir, clock=self.clock)
        self._write_config_files()

    def _write_config_files(self):
        with open(os.path.join(self.dir, "capture_config.json"), "w", encoding="utf-8") as f:
            json.dump(DEFAULT_CAPTURE_CONFIG, f, ensure_ascii=False, indent=2)
        with open(os.path.join(self.dir, "device_info.json"), "w", encoding="utf-8") as f:
            json.dump(DEFAULT_DEVICE_INFO, f, ensure_ascii=False, indent=2)

    def path(self, *parts):
        return os.path.join(self.dir, *parts)

    def active_path(self, session_id):
        return self.path("sessions", "active", session_id + ".json")

    def incomplete_path(self, session_id):
        return self.path("sessions", "incomplete", session_id + ".json")

    def discarded_path(self, session_id):
        return self.path("sessions", "discarded", session_id + ".json")

    def new_session(self, **kwargs):
        return ScanSession(base_dir=self.dir, clock=self.clock, **kwargs)

    def session_in_state(self, state):
        """用公开接口把一个新会话推进到 state（incomplete 走 mark_incomplete）。"""
        session = self.new_session()
        if state == "pending":
            return session
        session.start()
        if state == "scanning":
            return session
        if state == "incomplete":
            session.mark_incomplete()
            return session
        session.record_bean()
        self.clock.advance(3)
        session.stop()
        if state == "result_ready":
            return session
        if state == "discarded":
            session.discard(confirmed=True)
            return session
        session.save_to_queue(self.queue)
        if state == "queued":
            return session
        session.mark_saved()
        if state == "saved":
            return session
        raise ValueError("未知状态: %r" % state)

    def tree(self):
        """目录下所有文件的 {相对路径: 内容}，用来断言「被拒绝的操作没有碰任何文件」。"""
        result = {}
        for root, _dirs, files in os.walk(self.dir):
            for name in files:
                full = os.path.join(root, name)
                with open(full, "rb") as f:
                    result[os.path.relpath(full, self.dir)] = f.read()
        return result


def read(path):
    return storage.read_json(path)


def record_exists(path):
    """逻辑上存在：主文件或 .prev 任一可读（与 storage.read_json 的回退一致）。"""
    return storage.read_json(path) is not None
