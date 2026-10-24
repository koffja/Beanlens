# 会话落盘目录管理：active（扫描中 checkpoint）/ incomplete（未完成会话）/ discarded（已放弃会话）。
# 负责三件事：启动时恢复（recover）、未完成会话最多保留 N 条并滚动删除、已放弃会话到期清理。
# 队列目录不归这里管（见 queue.py），未完成会话不计入队列条数；这里只读队列目录，
# 用来识别“转换已完成、旧 active 文件还没删就断电”的残留。
# 只依赖 storage / config_manager / queue / session_errors，不依赖 scan_session，避免循环引用。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
import os
import time

from app.core import storage
from app.core import config_manager
from app.core import queue
from app.core.session_errors import SessionError, DiscardNotConfirmed

ACTIVE_DIRNAME = "sessions/active"
INCOMPLETE_DIRNAME = "sessions/incomplete"
DISCARDED_DIRNAME = "sessions/discarded"
LOG_RELPATH = "logs/session_store.log"

SESSION_SUFFIX = ".json"
PREV_SUFFIX = ".prev"
TMP_SUFFIX = ".tmp"

DEFAULT_MAX_INCOMPLETE = 20
DEFAULT_DISCARDED_RETENTION_S = 7 * 24 * 3600

_STATE_PENDING = "pending"
_STATE_SCANNING = "scanning"
_STATE_RESULT_READY = "result_ready"


def _is_int(value):
    return isinstance(value, int) and not isinstance(value, bool)


def _is_number(value):
    return isinstance(value, (int, float)) and not isinstance(value, bool)


class SessionStore:
    def __init__(self, base_dir=None, clock=None, queue_dir=None,
                 max_incomplete=DEFAULT_MAX_INCOMPLETE,
                 discarded_retention_s=DEFAULT_DISCARDED_RETENTION_S):
        if base_dir is None:
            base_dir = storage.default_base_dir()
        if clock is None:
            clock = time.time
        if not _is_int(max_incomplete) or max_incomplete < 1:
            raise ValueError("max_incomplete 必须是 >= 1 的整数")
        if not _is_number(discarded_retention_s) or discarded_retention_s <= 0:
            raise ValueError("discarded_retention_s 必须是正数")
        self.base_dir = base_dir
        self.clock = clock
        self._queue_dir = queue_dir
        self.max_incomplete = max_incomplete
        self.discarded_retention_s = discarded_retention_s
        self.active_dir = storage.join_path(base_dir, ACTIVE_DIRNAME)
        self.incomplete_dir = storage.join_path(base_dir, INCOMPLETE_DIRNAME)
        self.discarded_dir = storage.join_path(base_dir, DISCARDED_DIRNAME)
        self.log_path = storage.join_path(base_dir, LOG_RELPATH)

    # ---- 路径 ----

    def active_path(self, session_id):
        return storage.join_path(self.active_dir, session_id + SESSION_SUFFIX)

    def incomplete_path(self, session_id):
        return storage.join_path(self.incomplete_dir, session_id + SESSION_SUFFIX)

    def discarded_path(self, session_id):
        return storage.join_path(self.discarded_dir, session_id + SESSION_SUFFIX)

    def _queue_entry_path(self, operation_id):
        if self._queue_dir is None:
            self._queue_dir = config_manager.ConfigManager(self.base_dir).load()["queue_path"]
        return storage.join_path(self._queue_dir, queue.filename_for(operation_id))

    # ---- 日志 ----

    def _log(self, event, snapshot):
        """追加一行日志。日志写不进去（TF 卡满等）不能影响数据操作本身。"""
        line = "%s %s session_id=%s operation_id=%s beans=%s\n" % (
            self.clock(), event, snapshot.get("session_id"),
            snapshot.get("operation_id"), snapshot.get("bean_count_total"),
        )
        try:
            storage.ensure_dir(storage.join_path(self.base_dir, LOG_RELPATH.rsplit("/", 1)[0]))
            with open(self.log_path, "a") as f:
                f.write(line)
        except OSError:
            pass

    # ---- 目录扫描 ----

    def _session_ids(self, directory):
        """目录里的会话 id（主文件或只剩 .prev 的都算），排序后返回。"""
        try:
            names = os.listdir(directory)
        except OSError:
            return []
        ids = []
        for name in names:
            if name.endswith(SESSION_SUFFIX + PREV_SUFFIX):
                base = name[:-len(SESSION_SUFFIX + PREV_SUFFIX)]
            elif name.endswith(SESSION_SUFFIX):
                base = name[:-len(SESSION_SUFFIX)]
            else:
                continue
            if base not in ids:
                ids.append(base)
        ids.sort()
        return ids

    def _clean_tmp(self, directory):
        """删掉半写的 .tmp。主文件永远不会读 .tmp，所以删它不丢任何已提交的数据。"""
        try:
            names = os.listdir(directory)
        except OSError:
            return
        for name in names:
            if name.endswith(SESSION_SUFFIX + TMP_SUFFIX):
                try:
                    os.remove(storage.join_path(directory, name))
                except OSError:
                    pass

    def _load_all(self, directory, time_key):
        """读出目录里所有可解析的快照，按 (time_key, session_id) 从旧到新排序。"""
        items = []
        for sid in self._session_ids(directory):
            snap = storage.read_json(storage.join_path(directory, sid + SESSION_SUFFIX))
            if not isinstance(snap, dict):
                continue
            stamp = snap.get(time_key)
            if not _is_number(stamp):
                stamp = snap.get("updated_at")
            if not _is_number(stamp):
                stamp = 0
            items.append((stamp, sid, snap))
        items.sort()
        return [item[2] for item in items]

    # ---- 未完成会话 ----

    def add_incomplete(self, snapshot, enforce_cap=True):
        """存一份未完成会话快照（原子写）。超过上限就滚动删除最旧的并留日志，返回被删的 id 列表。"""
        storage.atomic_write_json(self.incomplete_path(snapshot["session_id"]), snapshot)
        if enforce_cap:
            return self._enforce_incomplete_cap()
        return []

    def _enforce_incomplete_cap(self):
        rolled = []
        items = self._load_all(self.incomplete_dir, "incomplete_at")
        excess = len(items) - self.max_incomplete
        index = 0
        while index < excess:
            snap = items[index]
            storage.remove_json(self.incomplete_path(snap["session_id"]))
            self._log("rolled_out_incomplete", snap)
            rolled.append(snap["session_id"])
            index += 1
        return rolled

    def list_incomplete(self):
        return self._load_all(self.incomplete_dir, "incomplete_at")

    def get_incomplete(self, session_id):
        snap = storage.read_json(self.incomplete_path(session_id))
        if isinstance(snap, dict):
            return snap
        return None

    def discard_incomplete(self, session_id, confirmed=False):
        """丢弃一条未完成会话：需 confirmed is True；直接删除，不进 7 天留档（它从来不是正式记录）。"""
        if confirmed is not True:
            raise DiscardNotConfirmed()
        snap = self.get_incomplete(session_id)
        if snap is None:
            raise SessionError("找不到未完成会话: %s" % session_id)
        storage.remove_json(self.incomplete_path(session_id))
        self._log("discarded_incomplete", snap)

    # ---- 已放弃会话 ----

    def add_discarded(self, snapshot):
        """存一份已放弃会话快照（原子写）。"""
        storage.atomic_write_json(self.discarded_path(snapshot["session_id"]), snapshot)

    def list_discarded(self):
        return self._load_all(self.discarded_dir, "discarded_at")

    def purge_expired_discarded(self):
        """删掉放弃满保留期（默认 7 天）的会话，返回被删的 id 列表。"""
        now = self.clock()
        purged = []
        for snap in self.list_discarded():
            stamp = snap.get("discarded_at")
            if not _is_number(stamp):
                stamp = snap.get("updated_at")
            if not _is_number(stamp):
                continue  # 没有时间戳就无法判断是否到期，宁可多留
            if now - stamp >= self.discarded_retention_s:
                storage.remove_json(self.discarded_path(snap["session_id"]))
                purged.append(snap["session_id"])
        return purged

    # ---- 启动恢复 ----

    def _already_moved(self, sid, snap):
        """这条 active 快照对应的会话，是否已经在别处（队列 / 放弃 / 未完成）落好了。"""
        if storage.read_json(self.incomplete_path(sid)) is not None:
            return True
        if storage.read_json(self.discarded_path(sid)) is not None:
            return True
        operation_id = snap.get("operation_id")
        if isinstance(operation_id, str) and operation_id != "":
            if storage.read_json(self._queue_entry_path(operation_id)) is not None:
                return True
        return False

    def recover(self):
        """启动时调用一次：把上次非正常退出遗留的状态收拾一致。可重复调用，第二次什么都不做。

        - scanning 的 active checkpoint -> 转成 incomplete（保留已 checkpoint 的计数，不可保存入队）
        - 转换已完成但旧 active 文件没来得及删 -> 删掉旧文件（dropped_stale）
        - 从未开始扫描的 pending 会话 -> 删掉（dropped_pending）
        - result_ready 会话保留在 active，等操作员保存或放弃（result_ready）
        - 读不出来的 active 文件原样保留并报告（unreadable），不自作主张删除
        - 清理半写的 .tmp；未完成会话超上限则滚动删除；放弃满 7 天的清掉
        返回各类 session_id 列表组成的字典。
        """
        report = {
            "recovered_incomplete": [],
            "result_ready": [],
            "dropped_stale": [],
            "dropped_pending": [],
            "unreadable": [],
            "rolled_out": [],
            "expired_discarded": [],
        }
        for directory in (self.active_dir, self.incomplete_dir, self.discarded_dir):
            self._clean_tmp(directory)

        for sid in self._session_ids(self.active_dir):
            snap = storage.read_json(self.active_path(sid))
            if not isinstance(snap, dict) or snap.get("session_id") != sid:
                report["unreadable"].append(sid)
                continue
            state = snap.get("state")
            if state == _STATE_PENDING:
                storage.remove_json(self.active_path(sid))
                report["dropped_pending"].append(sid)
            elif state == _STATE_SCANNING or state == _STATE_RESULT_READY:
                if self._already_moved(sid, snap):
                    storage.remove_json(self.active_path(sid))
                    report["dropped_stale"].append(sid)
                elif state == _STATE_RESULT_READY:
                    report["result_ready"].append(sid)
                else:
                    incomplete = dict(snap)
                    incomplete["state"] = "incomplete"
                    incomplete["saveable"] = False
                    incomplete["recovered"] = True
                    incomplete["recovered_at"] = self.clock()
                    # 掉电的确切时刻不可知，用最后一次 checkpoint 的时间：
                    # 既决定“最旧”的滚动顺序，也是待机页横幅显示的“上次扫描未完成（时间）”。
                    last_seen = snap.get("updated_at")
                    if not _is_number(last_seen):
                        last_seen = self.clock()
                    incomplete["incomplete_at"] = last_seen
                    # 先写新位置再删旧文件：中间断电，下次启动会按 dropped_stale 清掉旧文件。
                    self.add_incomplete(incomplete, enforce_cap=False)
                    storage.remove_json(self.active_path(sid))
                    self._log("recovered_incomplete", incomplete)
                    report["recovered_incomplete"].append(sid)
            else:
                report["unreadable"].append(sid)

        report["rolled_out"] = self._enforce_incomplete_cap()
        report["expired_discarded"] = self.purge_expired_discarded()
        return report
