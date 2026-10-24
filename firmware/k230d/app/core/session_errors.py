# 会话相关的共用异常。单独成模块是为了让 scan_session 和 session_store 都能用，又不互相 import。
# scan_session 会重新导出这些名字，调用方照旧从 scan_session 导入即可。


class SessionError(Exception):
    """会话操作不被允许。"""


class DiscardNotConfirmed(SessionError):
    def __init__(self):
        SessionError.__init__(self, "放弃会话需要二次确认：必须传 confirmed=True")
