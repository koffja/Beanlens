# 队列管理页（票 10）：查看各条记录状态、删除项、失败项重报，供设置页的队列管理入口使用。
# - 不改旧的 UIController，新增一个薄的控制器，前端由工程接手。
# - 队列项的格式同 report.py + queue.py，诊断用 stats 同 scan_runner.stats()。
# - 删除：转发 queue.delete_entry，只允许 pending / failed_retriable / failed_rejected。
#   saving 中的项不能删（可能正在写盘）；saved 项走 purge_saved，不走这里。
# - 重报：转发 queue.resubmit_rejected，不生成新 operation_id（ADR 0004）。
# - queue.py 的 QueueError / InvalidQueueTransition 在这里统一包装成 QueueManagerError。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
from app.core import queue as queue_mod


class QueueManagerError(Exception):
    """队列管理页的操作不被允许（找不到条目、状态不可删等）。"""


class QueueManager:
    """队列管理接口：查看各条记录状态，可删除项，失败项可重报并看到失败原因。

    - pending / saving / saved / failed（retriable / rejected）四种状态各一份列表。
    - saved 只含元数据（正文已删），最多 50 条（queue.py purge_saved 规则）。
    """

    def __init__(self, submission_queue):
        self.queue = submission_queue

    def query(self):
        """返回 {"pending", "saving", "saved", "failed"}，每项是按 state_changed_ms 降序的列表。"""
        allitems = self.queue.list_all()
        result = {"pending": [], "saving": [], "saved": [], "failed": []}
        for item in allitems:
            if item["state"] == queue_mod.STATE_PENDING:
                result["pending"].append(item)
            elif item["state"] == queue_mod.STATE_SAVING:
                result["saving"].append(item)
            elif item["state"] == queue_mod.STATE_SAVED:
                result["saved"].append(item)
            else:
                result["failed"].append(item)
        for key in result:
            result[key].sort(key=lambda x: -x.get("state_changed_ms", 0))
        return result

    def stats(self):
        """队列计数：可提交项数 / 正在保存数 / 失败项数 / 已保存项数（含历史，截至 50）。"""
        data = self.query()
        return {
            "pending_count": len(data["pending"]),
            "saving_count": len(data["saving"]),
            "failed_count": len(data["failed"]),
            "saved_count": len(data["saved"]),
        }

    def failure_reason(self, operation_id):
        """返回某条队列项的失败原因（failed_* 才有）。找不到或不是失败项抛 QueueManagerError。"""
        entry = self.queue.get_entry(operation_id)
        if entry is None:
            raise QueueManagerError("找不到队列项: %s" % operation_id)
        if entry["state"] not in (queue_mod.STATE_FAILED_RETRIABLE, queue_mod.STATE_FAILED_REJECTED):
            raise QueueManagerError("队列项 %s 当前不是失败状态" % operation_id)
        return {
            "operation_id": operation_id,
            "state": entry["state"],
            "error_code": entry.get("error_code"),
            "error_message": entry.get("error_message"),
            "retry_count": entry.get("retry_count", 0),
        }

    def delete(self, operation_id):
        """删除一条队列项：转发到 queue.delete_entry（只允许 pending / failed_retriable /
        failed_rejected；saving / saved 拒绝，错误改抛 QueueManagerError 供 UI 统一捕获）。
        """
        try:
            self.queue.delete_entry(operation_id)
        except queue_mod.QueueError as e:
            raise QueueManagerError(str(e))

    def resubmit(self, operation_id, new_record=None):
        """失败项重报：转发到 queue.resubmit_rejected（复用同一 operation_id，ADR 0004）。

        只有 failed_rejected 能重报；其余状态抛 InvalidQueueTransition，这里包装为
        QueueManagerError 供 UI 统一捕获。
        """
        try:
            return self.queue.resubmit_rejected(operation_id, new_record)
        except (queue_mod.QueueError, queue_mod.InvalidQueueTransition) as e:
            raise QueueManagerError(str(e))


def format_diagnostics(stats):
    """把 scan_runner.stats() 变成易读的字符串摘要行（用于诊断文本或日志）。

    不含多行表格：只输出关键指标。前端应用可按需把 stats 原字典投影为 UI 卡片。
    """
    pairing_alert = "配对超限" if stats.get("pairing_alert", False) else "正常"
    error = stats.get("error")
    msg = "扫描诊断：总数=%d 配对=%d 不明=%d 拒判=%d 褪色=%d 配对=%s" % (
        stats.get("bean_count_total", 0), stats.get("paired_count", 0),
        stats.get("unpaired_count", 0), stats.get("rejected_count", 0),
        stats.get("fade_count", 0), pairing_alert
    )
    if error:
        msg += " 推理故障=[%s]" % (error,)
    return msg
