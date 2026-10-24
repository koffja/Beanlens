# 扫描会话：7 态生命周期（ADR 0004）+ checkpoint + 从 result_ready checkpoint 重新载入。
#   pending -> scanning -> result_ready -> queued -> saved
#                 |             `-> discarded（需 confirmed=True 二次确认）
#                 `-> incomplete（非正常退出；永不入队）
# 终态 saved / discarded / incomplete 没有出口；result_ready 之后不能再补豆（只能新开会话）。
# 非法转换抛 InvalidTransition，且不改内存状态、不碰任何文件。
# 启动时的恢复（scanning -> incomplete）、未完成会话的滚动删除、放弃会话到期清理在 session_store.py。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
import os
import time

from app.core import storage
from app.core import config_manager
from app.core import session_store
from app.core import counting
from app.core.session_errors import SessionError, DiscardNotConfirmed
from app.core.defect_classes import DEFECT_CLASSES, empty_defect_counts

DEFAULT_DEVICE_ID = "DEV0000"  # 占位序列号；真实序列号由后续票接入
ACTIVE_DIRNAME = session_store.ACTIVE_DIRNAME

STATE_PENDING = "pending"
STATE_SCANNING = "scanning"
STATE_RESULT_READY = "result_ready"
STATE_QUEUED = "queued"
STATE_SAVED = "saved"
STATE_DISCARDED = "discarded"
STATE_INCOMPLETE = "incomplete"

ALL_STATES = (
    STATE_PENDING,
    STATE_SCANNING,
    STATE_RESULT_READY,
    STATE_QUEUED,
    STATE_SAVED,
    STATE_DISCARDED,
    STATE_INCOMPLETE,
)

# 操作 -> (前置状态, 后置状态)。合法转换只在这一处定义，can_transition 由它派生。
_ACTIONS = {
    "start": (STATE_PENDING, STATE_SCANNING),
    "stop": (STATE_SCANNING, STATE_RESULT_READY),
    "mark_incomplete": (STATE_SCANNING, STATE_INCOMPLETE),
    "discard": (STATE_RESULT_READY, STATE_DISCARDED),
    "save_to_queue": (STATE_RESULT_READY, STATE_QUEUED),
    "mark_saved": (STATE_QUEUED, STATE_SAVED),
}
# record_bean 不改状态，只在 scanning 里合法。
_RECORD_BEAN_STATE = STATE_SCANNING

# 能导出记录体 / 进入队列的状态。pending、scanning、discarded、incomplete 都不行。
_RECORD_STATES = (STATE_RESULT_READY, STATE_QUEUED, STATE_SAVED)

DEFAULT_CHECKPOINT_EVERY_BEANS = 30
DEFAULT_CHECKPOINT_INTERVAL_S = 5


class InvalidTransition(SessionError):
    def __init__(self, state, action):
        self.state = state
        self.action = action
        message = "非法转换：会话处于 %s 状态，不能执行 %s" % (state, action)
        if state == STATE_RESULT_READY and action in ("start", "record_bean"):
            message += "（结果已冻结，不能继续扫描补豆，请新开会话）"
        SessionError.__init__(self, message)


def can_transition(from_state, to_state):
    for pair in _ACTIONS.values():
        if pair[0] == from_state and pair[1] == to_state:
            return True
    return False


def _rand_hex(n_bytes):
    data = os.urandom(n_bytes)
    out = ""
    for b in data:
        out += "%02x" % b
    return out


def _check_device_id(device_id):
    if not isinstance(device_id, str) or device_id == "":
        raise ValueError("device_id 必须是非空字符串")
    for ch in device_id:
        if ch in "/:\\ \t\r\n":
            raise ValueError("device_id 含有不允许的字符: %r" % ch)


def _check_threshold(name, value, integer):
    if isinstance(value, bool) or not isinstance(value, int if integer else (int, float)) or value <= 0:
        raise ValueError("%s 必须是正%s" % (name, "整数" if integer else "数"))


class ScanSession:
    def __init__(self, base_dir=None, device_id=DEFAULT_DEVICE_ID, sample_weight_g=None,
                 clock=None, sample_seq=1,
                 checkpoint_every_beans=DEFAULT_CHECKPOINT_EVERY_BEANS,
                 checkpoint_interval_s=DEFAULT_CHECKPOINT_INTERVAL_S,
                 restore=None):
        _check_threshold("checkpoint_every_beans", checkpoint_every_beans, True)
        _check_threshold("checkpoint_interval_s", checkpoint_interval_s, False)
        if base_dir is None:
            base_dir = storage.default_base_dir()
        if clock is None:
            clock = time.time

        self.base_dir = base_dir
        self.clock = clock
        self.checkpoint_every_beans = checkpoint_every_beans
        self.checkpoint_interval_s = checkpoint_interval_s
        self._store = session_store.SessionStore(base_dir, clock=clock)

        self._beans_since_checkpoint = 0
        self._last_checkpoint_at = None
        self._dirty = False
        self.last_checkpoint_error = None

        if restore is not None:
            # 从磁盘快照重建（ScanSession.load），不重新生成 id，也不重写文件。
            self.device_id = restore["device_id"]
            self.sample_seq = restore.get("sample_seq", 1)
            self.session_id = restore["session_id"]
            self.operation_id = restore["operation_id"]
            self._apply_snapshot(restore)
            self.checkpoint_file = self._store.active_path(self.session_id)
            return

        _check_device_id(device_id)
        if sample_weight_g is None:
            sample_weight_g = config_manager.ConfigManager(base_dir).load()["sample_weight_g"]

        self.device_id = device_id
        self.sample_seq = sample_seq

        # 生成一次，之后永不重算（ADR 0004）。
        self.session_id = "sess-" + _rand_hex(8)
        self.operation_id = "K230D:%s:scan:%s" % (device_id, _rand_hex(4))

        self.state = STATE_PENDING
        self.start_time = None
        self.end_time = None
        self.duration_s = 0
        self.captured_at = None
        self.bean_count_total = 0
        self.unpaired_count = 0
        self.defect_counts = empty_defect_counts()
        self.sample_weight_g = sample_weight_g

        self.checkpoint_file = self._store.active_path(self.session_id)
        self._persist()

    @classmethod
    def fake(cls, base_dir=None, device_id=DEFAULT_DEVICE_ID, sample_weight_g=None,
             clock=None, duration_s=12, sample_seq=1):
        """硬编码的假会话：已走完 start/stop，处于 result_ready，16 类计数全 0。"""
        session = cls(base_dir=base_dir, device_id=device_id,
                      sample_weight_g=sample_weight_g, clock=clock, sample_seq=sample_seq)
        session.start()
        session.start_time = session.clock() - duration_s
        session.stop()
        return session

    @classmethod
    def load(cls, base_dir=None, session_id=None, clock=None,
             checkpoint_every_beans=DEFAULT_CHECKPOINT_EVERY_BEANS,
             checkpoint_interval_s=DEFAULT_CHECKPOINT_INTERVAL_S):
        """重新载入一个磁盘上停在 result_ready 的会话（停止后、保存/放弃前断电的情况）。

        scanning 会话不能重新载入继续扫描：它们在启动时被恢复成 incomplete。
        """
        if base_dir is None:
            base_dir = storage.default_base_dir()
        path = session_store.SessionStore(base_dir).active_path(session_id)
        snapshot = storage.read_json(path)
        if not isinstance(snapshot, dict):
            raise SessionError("找不到会话 checkpoint: %s" % session_id)
        if snapshot.get("state") != STATE_RESULT_READY:
            raise SessionError("只能重新载入 result_ready 会话，当前是 %s" % snapshot.get("state"))
        return cls(base_dir=base_dir, clock=clock,
                   checkpoint_every_beans=checkpoint_every_beans,
                   checkpoint_interval_s=checkpoint_interval_s, restore=snapshot)

    # ---- 快照 / 持久化 ----

    def _snapshot(self):
        return {
            "session_id": self.session_id,
            "operation_id": self.operation_id,
            "device_id": self.device_id,
            "sample_seq": self.sample_seq,
            "state": self.state,
            "start_time": self.start_time,
            "end_time": self.end_time,
            "duration_s": self.duration_s,
            "captured_at": self.captured_at,
            "bean_count_total": self.bean_count_total,
            "unpaired_count": self.unpaired_count,
            "defects": dict(self.defect_counts),
            "sample_weight_g": self.sample_weight_g,
            "updated_at": self.clock(),
        }

    def _apply_snapshot(self, snap):
        self.state = snap["state"]
        self.start_time = snap["start_time"]
        self.end_time = snap["end_time"]
        self.duration_s = snap["duration_s"]
        self.captured_at = snap["captured_at"]
        self.bean_count_total = snap["bean_count_total"]
        self.unpaired_count = snap["unpaired_count"]
        self.defect_counts = empty_defect_counts()
        for key in snap["defects"]:
            self.defect_counts[key] = snap["defects"][key]
        self.sample_weight_g = snap["sample_weight_g"]

    def _persist(self):
        storage.atomic_write_json(self.checkpoint_file, self._snapshot())

    def _persist_or_rollback(self, old):
        """写盘失败时把内存状态退回 old，保证“内存状态 = 磁盘状态”。"""
        try:
            self._persist()
        except Exception:
            self._apply_snapshot(old)
            raise

    def _drop_active_file(self):
        """转换完成后清掉 active 里的旧 checkpoint。失败不影响转换结果：
        残留文件会在下次启动恢复时按“已转换”识别并清理（SessionStore.recover）。"""
        try:
            storage.remove_json(self.checkpoint_file)
        except OSError:
            pass

    def _require(self, action):
        if action == "record_bean":
            expected = _RECORD_BEAN_STATE
        else:
            expected = _ACTIONS[action][0]
        if self.state != expected:
            raise InvalidTransition(self.state, action)

    # ---- 转换 ----

    def start(self):
        self._require("start")
        old = self._snapshot()
        now = self.clock()
        self.state = STATE_SCANNING
        self.start_time = now
        self._persist_or_rollback(old)
        self._last_checkpoint_at = now
        self._beans_since_checkpoint = 0
        self._dirty = False

    def record_bean(self, unpaired=False, defect=None):
        """记一颗豆：豆粒总数 +1；unpaired=True 同时计配对不明；defect 为 16 类之一则该类 +1。

        配对不明不计入任何瑕疵类别（CONTEXT.md），所以两者不能同时给。
        """
        self._require("record_bean")
        if defect is not None and defect not in DEFECT_CLASSES:
            raise ValueError("未知瑕疵类别: %r" % (defect,))
        if unpaired and defect is not None:
            raise ValueError("配对不明的豆不能计入瑕疵类别")
        self.bean_count_total += 1
        if unpaired:
            self.unpaired_count += 1
        if defect is not None:
            self.defect_counts[defect] += 1
        self._beans_since_checkpoint += 1
        self._dirty = True
        if self._beans_since_checkpoint >= self.checkpoint_every_beans or self._interval_elapsed():
            self._checkpoint()

    def tick(self):
        """主循环定期调用：scanning 中有未落盘的计数且距上次写盘满 checkpoint_interval_s 就写一次。

        返回是否真的写盘成功。非 scanning 状态、或没有新数据时什么都不做。
        """
        if self.state != STATE_SCANNING or not self._dirty:
            return False
        if not self._interval_elapsed():
            return False
        return self._checkpoint()

    def _interval_elapsed(self):
        return self.clock() - self._last_checkpoint_at >= self.checkpoint_interval_s

    def _checkpoint(self):
        """把当前计数原子写进 active checkpoint；数量与时间两个计数器一起归零（先到先写）。

        写盘失败（TF 卡错误等）不能让正在进行的扫描崩溃：内存计数保留，
        下一颗豆或下一次 tick 会重试；错误记在 last_checkpoint_error。
        """
        try:
            self._persist()
        except OSError as e:
            self.last_checkpoint_error = e
            return False
        self.last_checkpoint_error = None
        self._last_checkpoint_at = self.clock()
        self._beans_since_checkpoint = 0
        self._dirty = False
        return True

    def stop(self):
        self._require("stop")
        old = self._snapshot()
        now = self.clock()
        self.state = STATE_RESULT_READY
        self.end_time = now
        duration = now - self.start_time
        self.duration_s = duration if duration > 0 else 0  # 本机钟可能回拨（v1 无 NTP）
        self.captured_at = int(self.start_time)
        self._persist_or_rollback(old)
        self._dirty = False

    def mark_incomplete(self):
        """扫描中放弃继续并存为未完成会话（含内存里尚未 checkpoint 的计数）。永不入队。"""
        self._require("mark_incomplete")
        snap = self._snapshot()
        snap["state"] = STATE_INCOMPLETE
        snap["saveable"] = False
        snap["incomplete_at"] = self.clock()
        self._store.add_incomplete(snap)
        self.state = STATE_INCOMPLETE
        self._drop_active_file()

    def discard(self, confirmed=False):
        """放弃会话：必须 confirmed is True（二次确认）才生效。本地留档 7 天，永不入队。"""
        self._require("discard")
        if confirmed is not True:
            raise DiscardNotConfirmed()
        snap = self._snapshot()
        snap["state"] = STATE_DISCARDED
        snap["discarded_at"] = self.clock()
        self._store.add_discarded(snap)
        self.state = STATE_DISCARDED
        self._drop_active_file()

    def save_to_queue(self, queue):
        """result_ready -> queued：自检通过后把记录原子写进队列，再清掉 active checkpoint。
        
        16 类之和大于豆粒总数时抛 ValueError（ADR 0002 / 票 03）。
        """
        self._require("save_to_queue")
        counting.check_counts(self.bean_count_total, self.defect_counts)
        path = queue.enqueue(self)
        self.state = STATE_QUEUED
        self._drop_active_file()
        return path

    def mark_saved(self):
        """queued -> saved。队列项本身的状态由队列模块管（票 05），这里只改内存里的会话状态。"""
        self._require("mark_saved")
        self.state = STATE_SAVED

    # ---- 记录体 ----

    def to_record_json(self):
        """返回可直接 json.dumps 的 dict（v1 本地记录体）。不含点值、等级、lot_id、证据图。

        只有 result_ready / queued / saved 能导出；其余状态（尤其 incomplete）抛 SessionError。
        """
        if self.state not in _RECORD_STATES:
            raise SessionError("会话处于 %s 状态，不能导出记录体" % self.state)
        defects = {}
        for key in self.defect_counts:
            defects[key] = self.defect_counts[key]
        return {
            "operation_id": self.operation_id,
            "session_id": self.session_id,
            "captured_at": self.captured_at,
            "duration_s": self.duration_s,
            "bean_count_total": self.bean_count_total,
            "unpaired_count": self.unpaired_count,
            "defects": defects,
            "sample_weight_g": self.sample_weight_g,
            "metadata": {
                # v1 无联网对时，本机时钟一律视为不可靠（ADR 0004）。
                "clock_unreliable": True,
                "form_config": {
                    "sample_ids": ["BL-LOCAL-%04d" % self.sample_seq],
                },
                "quality": {
                    "fade_count": self.defect_counts.get("fade", 0),
                },
            },
        }
