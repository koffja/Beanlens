"""票 05 测试共用的小工具：往队列里塞一条 pending 记录。"""


def enqueue_new(env):
    """用公开接口造一条已入队（pending）的记录，返回它的 operation_id。每次调用时钟都会前进。"""
    session = env.session_in_state("queued")
    return session.operation_id
