# 上报编排（mock 版，票 05）：取最早可提交的队列项 -> 调客户端 -> 按响应码处置。
#   200            -> saved（删记录正文只留元数据，元数据最多保留最近 50 条）
#   400            -> failed_rejected（停止重试，人工改数据后重报，operation_id 不变）
#   403            -> failed_rejected，提示「额度已用尽」（停止重试）
#   401            -> failed_retriable：v1 没有令牌可刷新，按可重试处理；P2 接令牌后改成先刷新令牌再重试
#   429 / 5xx      -> failed_retriable，按指数退避重试（30 秒起步、翻倍、上限 15 分钟）
# 时钟由队列持有（SubmissionQueue(clock=...)），测试注入可控时钟，不真实等待。
# P2 接真实网络时只换 client，这里的分类与处置不变。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
from app.core.queue import backoff_delay  # noqa: F401  （同时作为 report.backoff_delay 对外使用）
from app.core import queue as queue_mod

QUOTA_EXHAUSTED_HINT = "额度已用尽"


class ReportOrchestrator:
    def __init__(self, queue, client):
        self.queue = queue
        self.client = client

    def submit_next(self):
        """提交最早可提交的一条。没有可提交项返回 None；否则返回结果字典：

          operation_id / status / state / record_id / message / hint
        state 是处置后的队列状态；hint 目前只有 403 带「额度已用尽」，其余为 None。
        """
        entry = self.queue.next_submittable()
        if entry is None:
            return None
        operation_id = entry["operation_id"]
        record = entry.get("record")
        self.queue.mark_saving(operation_id)
        response = self.client.submit(record)
        status = response.status
        hint = None
        if status == 200:
            self.queue.mark_saved(operation_id, response.record_id)
            self.queue.purge_saved()
            state = queue_mod.STATE_SAVED
        else:
            message = response.message
            if status == 403:
                hint = QUOTA_EXHAUSTED_HINT
                if not message or QUOTA_EXHAUSTED_HINT not in message:
                    message = QUOTA_EXHAUSTED_HINT
            updated = self.queue.mark_failed(operation_id, status, message)
            state = updated["state"]
        return {
            "operation_id": operation_id,
            "status": status,
            "state": state,
            "record_id": response.record_id,
            "message": response.message,
            "hint": hint,
        }
