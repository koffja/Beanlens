# 测试用假数据喂入器（票 08）：批量调用 ScanSession.record_bean()，避免测试重复循环。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
from app.core.defect_classes import DEFECT_CLASSES


def feed(session, clean=0, defects=None, unpaired=0):
    """给扫描中会话添若干计数：clean 颗无瑕疵豆、defects = {类别: 颗数}、unpaired 颗配对不明。

    类别名必须在 DEFECT_CLASSES 里，拼写错误抛 ValueError。
    """
    if defects is None:
        defects = {}
    for key in defects:
        if key not in DEFECT_CLASSES:
            raise ValueError("不认识的瑕疵类别: %s" % key)
    for _ in range(clean):
        session.record_bean()
    for key in defects:
        for _ in range(defects[key]):
            session.record_bean(defect=key)
    for _ in range(unpaired):
        session.record_bean(unpaired=True)
