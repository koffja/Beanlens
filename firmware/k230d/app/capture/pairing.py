# 双摄配对核心（票 04，ADR 0002）：纯逻辑，不 import 任何相机 / K230 SDK / 板级模块。
# 两路相机不是硬同步曝光，所以只靠时间戳容差 ΔT 做一对一配对，不假设两路同时曝光。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
#
# 术语（CONTEXT.md，三者不得混用）：
#   配对成功：前后摄各有一个 track 且时间差 <= ΔT，一对一消费。
#   配对不明：只被单侧看到的 track，每个落单 track 算一个。计入豆粒总数，不归类。
#   拒判：配对成功、但任一侧成像不足以定类。它是配对成功的子集，不进配对不明。
#   豆粒总数 = 配对成功 + 配对不明。
from app.core import storage

# 告警阈值（ADR 0002 / CONTEXT.md）：配对率 < 80% 或 配对不明占豆粒总数 > 20%。
MIN_PAIRING_RATE_PERCENT = 80
MAX_UNPAIRED_RATIO_PERCENT = 20
ALERT_TEXT = "豆路对准或光照异常"

# 默认 ΔT = 这么多个帧间隔（ADR 0002 初值）。
DEFAULT_TOLERANCE_FRAMES = 2


def _default_config_path():
    here = globals().get("__file__")
    if isinstance(here, str) and here.count("/") >= 2:
        app_dir = here.rsplit("/", 2)[0]
        return storage.join_path(app_dir, "config", "capture_config.json")
    return "app/config/capture_config.json"


DEFAULT_CONFIG_PATH = _default_config_path()


def _is_number(value):
    return not isinstance(value, bool) and isinstance(value, (int, float))


def _is_count(value):
    return not isinstance(value, bool) and isinstance(value, int) and value >= 0


def make_track(track_id, t_ms, insufficient=False):
    """造一个候选 track：track_id 在同一路内唯一，t_ms 是该 track 的时间戳（毫秒），
    insufficient 表示这一路的成像不足以定类（糊、遮挡、只露一角）。"""
    return {"track_id": track_id, "t_ms": t_ms, "insufficient": bool(insufficient)}


# ---------------------------------------------------------------- ΔT 配置

def _fps_of(config, key):
    cam = config.get(key)
    fps = cam.get("fps") if isinstance(cam, dict) else None
    if not _is_number(fps) or fps <= 0:
        raise ValueError("time_pair_tolerance_ms 为 null 时需要 %s.fps 为正数" % key)
    return fps


def tolerance_ms_from_config(config):
    """从 capture_config 取 ΔT（毫秒）。

    time_pair_tolerance_ms 显式给了数值（>= 0）就直接用，覆盖帧率换算；
    为 null 时取两路里较慢的帧率，ΔT = 2 个帧间隔 = 2000 / fps。
    """
    if not isinstance(config, dict):
        raise ValueError("capture_config 必须是 JSON 对象")
    explicit = config.get("time_pair_tolerance_ms")
    if explicit is not None:
        if not _is_number(explicit) or explicit < 0:
            raise ValueError("time_pair_tolerance_ms 必须是 >= 0 的数字或 null")
        return explicit
    slowest = min(_fps_of(config, "csi1"), _fps_of(config, "csi2"))
    return DEFAULT_TOLERANCE_FRAMES * 1000.0 / slowest


def load_tolerance_ms(path=None):
    """读 capture_config.json（走 storage.read_json）并返回 ΔT（毫秒）。
    文件缺失、损坏或内容不合法一律抛 ValueError，不静默给默认值。"""
    if path is None:
        path = DEFAULT_CONFIG_PATH
    config = storage.read_json(path)
    if not isinstance(config, dict):
        raise ValueError("capture_config 缺失或不是合法 JSON 对象: %s" % path)
    return tolerance_ms_from_config(config)


# ---------------------------------------------------------------- 配对

def _check_tracks(tracks, side):
    seen = {}
    entries = []
    index = 0
    for track in tracks:
        track_id = track["track_id"]
        t_ms = track["t_ms"]
        if not _is_number(t_ms):
            raise ValueError("%s track %r 的 t_ms 必须是数字" % (side, track_id))
        if track_id in seen:
            raise ValueError("%s 路 track_id 重复: %r" % (side, track_id))
        seen[track_id] = True
        entries.append((t_ms, index, track_id, bool(track.get("insufficient", False))))
        index += 1
    # 时间相同时按输入顺序，结果不依赖排序实现的稳定性。
    entries.sort()
    return entries


def pair_tracks(front_tracks, rear_tracks, tolerance_ms):
    """前后摄 track 一对一配对，返回结构化结果（键见下）。不修改入参。

    规则：|t_front - t_rear| <= tolerance_ms 才允许配对（恰好等于也算）；每个 track
    至多被消费一次。两侧按时间排序后做贪心扫描：对一维时间轴上的容差配对，这样得到
    的配对数是最大的，不会因为先抢了「最近」的而让邻近的另一颗落单。

    返回 dict：
      pairs               [{"front_id","rear_id","dt_ms","rejected"}, ...]，按前摄时间排序
      unpaired_front_ids  只在前摄出现的 track_id（按时间排序）
      unpaired_rear_ids   只在后摄出现的 track_id（按时间排序）
      paired_count        配对成功数（含拒判）
      unpaired_count      配对不明数
      rejected_count      拒判数（配对成功的子集，不含配对不明）
      classifiable_count  paired_count - rejected_count，可送去分类的豆数
      bean_count_total    豆粒总数 = paired_count + unpaired_count
      pairing_rate        paired_count / bean_count_total；总数为 0 时为 None
      unpaired_ratio      unpaired_count / bean_count_total；总数为 0 时为 None
      alert               {"low_pairing_rate","high_unpaired_ratio","triggered","message"}
    """
    if not _is_number(tolerance_ms) or tolerance_ms < 0:
        raise ValueError("tolerance_ms 必须是 >= 0 的数字")
    fronts = _check_tracks(front_tracks, "前摄")
    rears = _check_tracks(rear_tracks, "后摄")

    pairs = []
    unpaired_front = []
    unpaired_rear = []
    j = 0
    for t_front, _, front_id, front_bad in fronts:
        # 比当前前摄早出 ΔT 以上的后摄，对之后更晚的前摄也够不着，直接落单。
        while j < len(rears) and rears[j][0] < t_front - tolerance_ms:
            unpaired_rear.append(rears[j][2])
            j += 1
        if j < len(rears) and rears[j][0] - t_front <= tolerance_ms:
            t_rear, _, rear_id, rear_bad = rears[j]
            pairs.append({
                "front_id": front_id,
                "rear_id": rear_id,
                "dt_ms": abs(t_front - t_rear),
                "rejected": front_bad or rear_bad,
            })
            j += 1
        else:
            unpaired_front.append(front_id)
    while j < len(rears):
        unpaired_rear.append(rears[j][2])
        j += 1

    rejected = 0
    for pair in pairs:
        if pair["rejected"]:
            rejected += 1
    result = summarize_counts(len(pairs), len(unpaired_front) + len(unpaired_rear), rejected)
    result["pairs"] = pairs
    result["unpaired_front_ids"] = unpaired_front
    result["unpaired_rear_ids"] = unpaired_rear
    return result


# ---------------------------------------------------------------- 计数与告警

def _alert(paired, unpaired):
    total = paired + unpaired
    if total == 0:
        # 没有豆就没有配对率，不拿它告警。
        return {"low_pairing_rate": False, "high_unpaired_ratio": False,
                "triggered": False, "message": None}
    # 用整数比较，避免 0.8 / 0.2 的浮点边界误差。
    low_rate = paired * 100 < MIN_PAIRING_RATE_PERCENT * total
    high_unpaired = unpaired * 100 > MAX_UNPAIRED_RATIO_PERCENT * total
    triggered = low_rate or high_unpaired
    message = None
    if triggered:
        message = "%s：配对率 %.1f%%，配对不明占豆粒总数 %.1f%%，请检查豆路对准与光照" % (
            ALERT_TEXT, paired * 100.0 / total, unpaired * 100.0 / total)
    return {"low_pairing_rate": low_rate, "high_unpaired_ratio": high_unpaired,
            "triggered": triggered, "message": message}


def summarize_counts(paired_count, unpaired_count, rejected_count=0):
    """由三个计数得出豆粒总数、配对率与告警（pair_tracks 内部也用它）。
    会话累计多批配对结果后，可直接用累计计数调用，不必保留 track。
    rejected_count 是 paired_count 的子集，不得超过它。"""
    for value in (paired_count, unpaired_count, rejected_count):
        if not _is_count(value):
            raise ValueError("计数必须是非负整数: %r" % (value,))
    if rejected_count > paired_count:
        raise ValueError("拒判数不能超过配对成功数")
    total = paired_count + unpaired_count
    rate = None
    ratio = None
    if total > 0:
        rate = paired_count / total
        ratio = unpaired_count / total
    return {
        "paired_count": paired_count,
        "unpaired_count": unpaired_count,
        "rejected_count": rejected_count,
        "classifiable_count": paired_count - rejected_count,
        "bean_count_total": total,
        "pairing_rate": rate,
        "unpaired_ratio": ratio,
        "alert": _alert(paired_count, unpaired_count),
    }
