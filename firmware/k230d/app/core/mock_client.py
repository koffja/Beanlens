# mock 提交客户端（票 05）：按需返回 200/400/401/403/429/5xx，不做任何真实网络调用。
# P2 接真实网络时只替换这个客户端，ReportOrchestrator 与队列逻辑不变；
# 真实客户端需要提供同样的 submit(record) -> 带 status / record_id / message 的响应对象。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
import json

_EXACT_STATUSES = (200, 400, 401, 403, 429)

_MESSAGES = {
    400: "数据校验失败",
    401: "令牌无效或已过期",
    403: "额度已用尽",
    429: "请求过于频繁",
}


def _is_int(value):
    return isinstance(value, int) and not isinstance(value, bool)


def _check_status(status):
    if not _is_int(status):
        raise ValueError("mock 状态码必须是整数，实际 %r" % (status,))
    if status in _EXACT_STATUSES or 500 <= status <= 599:
        return
    raise ValueError("mock 不支持的状态码: %r（支持 200/400/401/403/429/5xx）" % (status,))


class MockResponse:
    def __init__(self, status, record_id=None, message=None):
        self.status = status
        self.record_id = record_id
        self.message = message


class MockSubmitClient:
    def __init__(self):
        self._default_status = 200
        self._script = []
        self._next_record_seq = 1
        self.calls = []

    def set_status(self, status):
        """之后的每次 submit 都返回这个状态码，直到再次调用 set_status。"""
        _check_status(status)
        self._default_status = status

    def script(self, *statuses):
        """排一串一次性响应，submit 按顺序消耗；用完后回到 set_status 设定的状态。

        任何一个状态码不合法都整体拒绝，不改动已有脚本。
        """
        for status in statuses:
            _check_status(status)
        self._script = list(statuses)

    def submit(self, record):
        """模拟提交一条记录体，返回 MockResponse。记下调用（记录体深拷贝）供测试断言。"""
        copy = json.loads(json.dumps(record))
        self.calls.append({"operation_id": copy.get("operation_id"), "record": copy})
        if self._script:
            status = self._script.pop(0)
        else:
            status = self._default_status
        if status == 200:
            record_id = "mock-rec-%04d" % self._next_record_seq
            self._next_record_seq += 1
            return MockResponse(200, record_id=record_id)
        message = _MESSAGES.get(status)
        if message is None:
            message = "服务端错误 %d" % status
        return MockResponse(status, message=message)
