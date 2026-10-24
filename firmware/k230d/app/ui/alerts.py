# 配对质量提示（票 08，ADR 0002）。纯逻辑，不依赖 LVGL。
# 配对率 = 配对成功 / 豆粒总数，正常 > 80%；配对不明 / 豆粒总数 > 20% 即提示。
# 两个条件在数学上等价（配对成功 = 豆粒总数 - 配对不明），这里用整数交叉相乘判断，
# 避免 0.2 之类的浮点边界误判；边界值（恰好 80% / 20%）不提示。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。

PAIRING_HINT = "豆路对准或光照异常"
MIN_PAIRING_RATE_PERCENT = 80
MAX_UNPAIRED_PERCENT = 20


def _is_int(value):
    return isinstance(value, int) and not isinstance(value, bool)


def _check(bean_total, unpaired):
    if not _is_int(bean_total) or bean_total < 0:
        raise ValueError("豆粒总数必须是非负整数，实际 %r" % (bean_total,))
    if not _is_int(unpaired) or unpaired < 0:
        raise ValueError("配对不明必须是非负整数，实际 %r" % (unpaired,))
    if unpaired > bean_total:
        raise ValueError("配对不明 %d 不能大于豆粒总数 %d" % (unpaired, bean_total))


def pairing_rate(bean_total, unpaired):
    """配对率（0-1 的小数）；豆粒总数为 0 时返回 None。"""
    _check(bean_total, unpaired)
    if bean_total == 0:
        return None
    return (bean_total - unpaired) / bean_total


def pairing_alert(bean_total, unpaired):
    """配对率低于 80%（即配对不明超过 20%）时返回提示字典，否则返回 None。

    字典字段：kind("pairing") / level("warning") / message / pairing_rate / unpaired_ratio。
    """
    _check(bean_total, unpaired)
    if bean_total == 0:
        return None
    if unpaired * 100 <= bean_total * MAX_UNPAIRED_PERCENT:
        return None
    rate = (bean_total - unpaired) / bean_total
    ratio = unpaired / bean_total
    message = "%s（配对率 %.1f%%，配对不明 %.1f%%）" % (PAIRING_HINT, rate * 100, ratio * 100)
    return {
        "kind": "pairing",
        "level": "warning",
        "message": message,
        "pairing_rate": rate,
        "unpaired_ratio": ratio,
    }
