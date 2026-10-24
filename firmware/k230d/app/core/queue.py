# 本地队列（票 01 + 票 05）：每条记录一个文件 <queue_dir>/<operation_id>.json。
# 状态（ADR 0004，v1 的 saving/saved 对应「上传中/已入库」）：
#   pending -> saving -> saved
#                    |-> failed_retriable -> saving（退避到期后重试）
#                    |-> failed_rejected  -> pending（人工改数据后重报，operation_id 不变）
#                    `-> pending（重启后 saving 的项回到可重新提交）
# 非法转换抛 InvalidQueueTransition，且不写任何文件。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
import json
import os
import time

from app.core import storage
from app.core import config_manager
from app.core import counting

STATE_PENDING = "pending"
STATE_SAVING = "saving"
STATE_SAVED = "saved"
STATE_FAILED_RETRIABLE = "failed_retriable"
STATE_FAILED_REJECTED = "failed_rejected"

ALL_STATES = (
    STATE_PENDING,
    STATE_SAVING,
    STATE_SAVED,
    STATE_FAILED_RETRIABLE,
    STATE_FAILED_REJECTED,
)

# 合法转换只在这一处定义，can_transition 由它派生。
_TRANSITIONS = (
    (STATE_PENDING, STATE_SAVING),
    (STATE_FAILED_RETRIABLE, STATE_SAVING),
    (STATE_SAVING, STATE_SAVED),
    (STATE_SAVING, STATE_FAILED_RETRIABLE),
    (STATE_SAVING, STATE_FAILED_REJECTED),
    (STATE_SAVING, STATE_PENDING),
    (STATE_FAILED_REJECTED, STATE_PENDING),
)

# HTTP 失败码 -> 失败后的队列状态（mock 与未来真实客户端共用这一张表）。
# 401：v1 没有令牌可刷新，按可重试处理；P2 接令牌后改成「先刷新令牌再重试」。
_REJECTED_STATUSES = (400, 403)
_RETRIABLE_STATUSES = (401, 429)

RECORD_SUFFIX = ".json"
PREV_SUFFIX = ".prev"

# 指数退避（ADR 0004）：30 秒起步、每次翻倍、上限 15 分钟；只适用 failed_retriable。
BACKOFF_BASE_S = 30
BACKOFF_CAP_S = 15 * 60
# 保存成功后只留元数据，且最多保留最近 50 条。
MAX_SAVED_METADATA = 50
# 容量保护（ADR 0004）：占位条数（不含 saved）达 100 阻断新扫描。
# 500MB 是证据图总量阈值，v1 没有证据图，只预留常量，不做图片统计，capacity_check 的 size_mb 恒为 0。
MAX_QUEUE_ENTRIES = 100
MAX_QUEUE_SIZE_MB = 500
CAPACITY_FULL_MESSAGE = "队列已满（%d 条），请清理或恢复网络后再扫描"
# 保存成功后从记录体里留下的元数据字段（用于对账）。
_META_KEYS = ("session_id", "captured_at", "duration_s", "bean_count_total", "unpaired_count")


def backoff_delay(retry_count):
    """第 retry_count 次可重试失败之后要等的秒数：30、60、120……封顶 900。retry_count 从 1 起。"""
    if not (isinstance(retry_count, int) and not isinstance(retry_count, bool)) or retry_count < 1:
        raise ValueError("retry_count 必须是 >= 1 的整数，实际 %r" % (retry_count,))
    delay = BACKOFF_BASE_S
    step = 1
    while step < retry_count and delay < BACKOFF_CAP_S:
        delay = delay * 2
        step += 1
    if delay > BACKOFF_CAP_S:
        delay = BACKOFF_CAP_S
    return delay


class QueueError(Exception):
    """队列操作不被允许（找不到队列项等）。"""


class InvalidQueueTransition(QueueError):
    def __init__(self, state, action):
        self.state = state
        self.action = action
        QueueError.__init__(self, "非法转换：队列项处于 %s 状态，不能执行 %s" % (state, action))


def can_transition(from_state, to_state):
    return (from_state, to_state) in _TRANSITIONS


def _is_int(value):
    return isinstance(value, int) and not isinstance(value, bool)


def classify_status(status):
    """失败响应码 -> 队列状态。400/403 -> failed_rejected；401/429/5xx -> failed_retriable。

    其余码（含 200）不是失败，抛 ValueError。
    """
    if not _is_int(status):
        raise ValueError("HTTP 状态码必须是整数，实际 %r" % (status,))
    if status in _REJECTED_STATUSES:
        return STATE_FAILED_REJECTED
    if status in _RETRIABLE_STATUSES or 500 <= status <= 599:
        return STATE_FAILED_RETRIABLE
    raise ValueError("无法归类的失败状态码: %r" % (status,))


def filename_for(operation_id):
    """队列文件名。operation_id 含冒号，FAT/exFAT 的 TF 卡可能不接受；若板上验证失败，只改这里。"""
    return operation_id + RECORD_SUFFIX


class SubmissionQueue:
    def __init__(self, base_dir=None, queue_dir=None, clock=None):
        if base_dir is None:
            base_dir = storage.default_base_dir()
        if queue_dir is None:
            queue_dir = config_manager.ConfigManager(base_dir).load()["queue_path"]
        if clock is None:
            clock = time.time
        self.base_dir = base_dir
        self.queue_dir = queue_dir
        self.clock = clock

    def _path_for(self, operation_id):
        return storage.join_path(self.queue_dir, filename_for(operation_id))

    def enqueue(self, session):
        """把会话记录写成一条 pending 队列项，返回文件路径。同一 operation_id 重复入队只会覆盖同一文件。"""
        record = session.to_record_json()
        entry = {
            "operation_id": record["operation_id"],
            "state": STATE_PENDING,
            "retry_count": 0,
            "created_at": self.clock(),
            "record": record,
        }
        path = self._path_for(record["operation_id"])
        storage.atomic_write_json(path, entry)
        return path

    def _entry_paths(self):
        """列出队列项主文件路径。只剩 .prev 的项（rename 中途中断）也算，读取时会回退 .prev。"""
        try:
            names = os.listdir(self.queue_dir)
        except OSError:
            return []
        bases = []
        for name in names:
            if name.endswith(RECORD_SUFFIX + PREV_SUFFIX):
                name = name[:-len(PREV_SUFFIX)]
            if name.endswith(RECORD_SUFFIX) and name not in bases:
                bases.append(name)
        return [storage.join_path(self.queue_dir, n) for n in bases]

    def _all_entries(self):
        entries = []
        for path in self._entry_paths():
            entry = storage.read_json(path)
            if isinstance(entry, dict):
                entries.append(entry)
        return entries

    def get_entry(self, operation_id):
        """返回队列项（dict），不存在返回 None。"""
        entry = storage.read_json(self._path_for(operation_id))
        if isinstance(entry, dict):
            return entry
        return None

    def next_pending(self):
        """返回最早（created_at，相同则按 operation_id）的 pending 项，没有则 None。"""
        best = None
        best_key = None
        for entry in self._all_entries():
            if entry.get("state") != STATE_PENDING:
                continue
            key = (entry.get("created_at", 0), entry.get("operation_id", ""))
            if best is None or key < best_key:
                best = entry
                best_key = key
        return best

    # ---- 状态转换 ----

    def _load_for(self, operation_id, action, target):
        """取出队列项并检查 current -> target 合法；不存在抛 QueueError，非法抛 InvalidQueueTransition。"""
        entry = self.get_entry(operation_id)
        if entry is None:
            raise QueueError("找不到队列项: %s" % operation_id)
        if not can_transition(entry.get("state"), target):
            raise InvalidQueueTransition(entry.get("state"), action)
        return entry

    def _save(self, entry):
        storage.atomic_write_json(self._path_for(entry["operation_id"]), entry)

    def mark_saving(self, operation_id):
        """pending / failed_retriable -> saving，记录本次尝试时间。"""
        entry = self._load_for(operation_id, "mark_saving", STATE_SAVING)
        entry["state"] = STATE_SAVING
        entry["last_attempt_at"] = self.clock()
        self._save(entry)
        return entry

    def mark_saved(self, operation_id, record_id):
        """saving -> saved：记下 record_id，删掉记录正文，只留元数据（同一次原子写完成）。"""
        entry = self._load_for(operation_id, "mark_saved", STATE_SAVED)
        record = entry.pop("record", None)
        metadata = {}
        if isinstance(record, dict):
            for key in _META_KEYS:
                if key in record:
                    metadata[key] = record[key]
        entry["state"] = STATE_SAVED
        entry["record_id"] = record_id
        entry["metadata"] = metadata
        entry["saved_at"] = self.clock()
        self._save(entry)
        return entry

    def purge_saved(self, keep=MAX_SAVED_METADATA):
        """只保留最近 keep 条 saved 元数据，更旧的删除，返回被删的 operation_id 列表。

        不碰任何非 saved 的项。
        """
        saved = []
        for entry in self._all_entries():
            if entry.get("state") == STATE_SAVED:
                key = (entry.get("saved_at", 0), entry.get("created_at", 0), entry.get("operation_id", ""))
                saved.append((key, entry["operation_id"]))
        saved.sort()
        removed = []
        excess = len(saved) - keep
        index = 0
        while index < excess:
            operation_id = saved[index][1]
            storage.remove_json(self._path_for(operation_id))
            removed.append(operation_id)
            index += 1
        return removed

    def _backoff_due(self, entry):
        """failed_retriable 项的退避是否已到期。缺少时间戳时视为已到期（宁可重试，不卡死）。"""
        last = entry.get("last_attempt_at")
        retries = entry.get("retry_count", 0)
        if last is None or retries < 1:
            return True
        return self.clock() - last >= backoff_delay(retries)

    def next_submittable(self):
        """最早可提交的项：pending，或退避已到期的 failed_retriable。没有则 None。

        failed_rejected / saving / saved 永远不会被选中；退避中的项不会挡住后面的 pending。
        """
        best = None
        best_key = None
        for entry in self._all_entries():
            state = entry.get("state")
            if state == STATE_FAILED_RETRIABLE:
                if not self._backoff_due(entry):
                    continue
            elif state != STATE_PENDING:
                continue
            key = (entry.get("created_at", 0), entry.get("operation_id", ""))
            if best is None or key < best_key:
                best = entry
                best_key = key
        return best

    def mark_failed(self, operation_id, http_status, error):
        """saving -> failed_retriable / failed_rejected，按 http_status 分类（见 classify_status）。

        只有 failed_retriable 会让 retry_count 加一。无法归类的码抛 ValueError，队列项保持 saving。
        """
        target = classify_status(http_status)
        action = "mark_failed(%s)" % http_status
        entry = self._load_for(operation_id, action, target)
        entry["state"] = target
        entry["error_code"] = http_status
        entry["error_message"] = error
        if target == STATE_FAILED_RETRIABLE:
            entry["retry_count"] = entry.get("retry_count", 0) + 1
        self._save(entry)
        return entry

    def resubmit_rejected(self, operation_id, new_record=None):
        """failed_rejected -> pending：人工改数据后重报，复用同一个 operation_id（ADR 0004）。

        new_record 为 None 时原样重发旧记录体；给了就整体替换，但 operation_id 必须不变，
        且 16 类之和不能大于豆粒总数（与保存入队时同一条自检）。校验不过抛 ValueError，不写任何文件。
        """
        entry = self.get_entry(operation_id)
        if entry is None:
            raise QueueError("找不到队列项: %s" % operation_id)
        if entry.get("state") != STATE_FAILED_REJECTED:
            raise InvalidQueueTransition(entry.get("state"), "resubmit_rejected")
        if new_record is not None:
            if not isinstance(new_record, dict) or new_record.get("operation_id") != operation_id:
                raise ValueError("重报必须复用原 operation_id %s，不能更换" % operation_id)
            counting.check_counts(new_record.get("bean_count_total"), new_record.get("defects"))
            entry["record"] = json.loads(json.dumps(new_record))
        entry["state"] = STATE_PENDING
        entry["retry_count"] = 0
        entry.pop("error_code", None)
        entry.pop("error_message", None)
        self._save(entry)
        return entry

    def delete_entry(self, operation_id):
        """删除一条队列项（票 10 队列管理页用）：只允许 pending / failed_retriable /
        failed_rejected；saving（可能正在写盘）与 saved（走 purge_saved）都拒绝。

        不存在的 operation_id 或不可删状态抛 QueueError，不触碰磁盘。
        """
        entry = self.get_entry(operation_id)
        if entry is None:
            raise QueueError("找不到队列项: %s" % operation_id)
        if entry.get("state") not in (STATE_PENDING, STATE_FAILED_RETRIABLE, STATE_FAILED_REJECTED):
            raise QueueError("队列项 %s 处于 %s 状态，不能删除" % (operation_id, entry.get("state")))
        storage.remove_json(self._path_for(operation_id))

    def list_all(self):
        """所有队列项，按 (created_at, operation_id) 从旧到新。"""
        items = []
        for entry in self._all_entries():
            items.append((entry.get("created_at", 0), entry.get("operation_id", ""), entry))
        items.sort(key=lambda item: (item[0], item[1]))
        return [item[2] for item in items]

    def capacity_check(self):
        """返回 {"count", "size_mb", "full", "message"}。

        count 是仍占位的条数（pending / saving / failed_*，不含只剩元数据的 saved）；
        达到 MAX_QUEUE_ENTRIES 即 full，message 给 UI 显示。size_mb 见 MAX_QUEUE_SIZE_MB 的说明。
        """
        count = 0
        for entry in self._all_entries():
            if entry.get("state") != STATE_SAVED:
                count += 1
        full = count >= MAX_QUEUE_ENTRIES
        message = CAPACITY_FULL_MESSAGE % count if full else ""
        return {"count": count, "size_mb": 0, "full": full, "message": message}

    def can_start_scan(self):
        """队列未触顶才允许开始新扫描。UI 在「开始扫描」前调用；不通过时显示 capacity_check()["message"]。"""
        return not self.capacity_check()["full"]

    def list_rejected(self):
        """所有 failed_rejected 项，按 (created_at, operation_id) 从旧到新，供 UI 显示。"""
        items = []
        for entry in self._all_entries():
            if entry.get("state") == STATE_FAILED_REJECTED:
                items.append((entry.get("created_at", 0), entry.get("operation_id", ""), entry))
        items.sort(key=lambda item: (item[0], item[1]))
        return [item[2] for item in items]

    def recover(self):
        """重启后调用：把 saving 状态的项回到 pending（可重新提交）；清除孤立的 .tmp；返回报告。

        报告字典：{"requeued", "cleaned_tmp", "unreadable"}，各为一个列表（没有则空列表）。
        半写的 .tmp 直接删，不影响正式条目；损坏的 .json 留原地（供人工排查）但不致崩溃。
        """
        requeued = []
        cleaned_tmp = []
        unreadable = []

        try:
            names = os.listdir(self.queue_dir)
        except OSError:
            return {"requeued": requeued, "cleaned_tmp": cleaned_tmp, "unreadable": unreadable}

        bases = []
        for name in names:
            if name.endswith(".tmp"):
                path = storage.join_path(self.queue_dir, name)
                try:
                    os.remove(path)
                    cleaned_tmp.append(name)
                except OSError:
                    pass
                continue

            # 只剩 .json.prev 的项（rename 中途断电）也要处理，read_json 会回退读 .prev。
            if name.endswith(RECORD_SUFFIX + PREV_SUFFIX):
                name = name[:-len(PREV_SUFFIX)]
            if name.endswith(RECORD_SUFFIX) and name not in bases:
                bases.append(name)

        for name in bases:
            path = storage.join_path(self.queue_dir, name)
            entry = storage.read_json(path)
            if not isinstance(entry, dict):
                unreadable.append(name)
                continue

            if entry.get("state") == STATE_SAVING:
                entry["state"] = STATE_PENDING
                storage.atomic_write_json(path, entry)
                requeued.append(entry["operation_id"])

        return {"requeued": requeued, "cleaned_tmp": cleaned_tmp, "unreadable": unreadable}
