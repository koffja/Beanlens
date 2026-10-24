# 16 类推理调度（票 07 草稿）：批量推理 -> NMS -> 单豆判定 -> 映射到 SCA 16 类。
# - 板侧 KPU / nncase 调用只在 KpuDetector 里写注释，主机上调用即抛 NotImplementedError。
# - 主机侧只验证输入输出的形状与签名，不验证检测准确率、延迟或内存（这些必须上板实测）。
# - 检测输出（bbox + 标签 + 置信度）与分类输出不混用；本模块只处理检测输出。
# - 模型只有 16 个瑕疵标签，没有「正常豆」类：没检出瑕疵不等于判为正常豆，
#   所以判定结果用 no_defect_detected，不用 normal。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
from app.core import counting

# 每批最多 8 个裁图（票 07；实测内存后可下调，不可上调）。
BATCH_MAX = 8

# 假设值，待上板对照后写回配置：NMS 的 IoU 阈值。
DEFAULT_NMS_IOU = 0.5

# 数据集 data.yaml 的 16 个模型标签。顺序必须与训练时的类别序号一致；
# 此处按字母序排列只是占位假设，没有在仓库里找到 data.yaml 核对，上板前必须以训练产物为准。
MODEL_LABELS = (
    "broken", "cut", "dry_cherry", "fade", "floater", "full_black",
    "full_sour", "fungus", "husk", "immature", "parchment", "partial_black",
    "partial_sour", "severe_insect_damage", "shell", "withered",
)

# 预处理规格：输入尺寸、颜色通道、缩放、归一化必须与训练一致（k230d/AGENTS.md）。
# 全部为 None 表示尚未核对，不给猜测值。
PREPROCESS_SPEC = {
    "input_size": None,
    "color_order": None,
    "resize_mode": None,
    "mean": None,
    "std": None,
}

# 发布记录模板（k230d/AGENTS.md：发布物须记录版本与校验值；为空是正常的未完成状态）。
MODEL_RECORD_TEMPLATE = {
    "model_name": None,
    "kmodel_sha256": None,
    "labels_sha256": None,
    "preprocess_sha256": None,
    "nncase_version": None,
    "canmv_firmware_version": None,
}

VERDICT_DEFECT = "defect"
VERDICT_FADE = "fade"
VERDICT_NONE = "no_defect_detected"


def _is_number(value):
    return not isinstance(value, bool) and isinstance(value, (int, float))


def make_detection(label, score, bbox):
    """造一个检测结果：bbox 为 (x, y, w, h)，w/h 必须为正。标签不在 MODEL_LABELS 抛 ValueError。"""
    if label not in MODEL_LABELS:
        raise ValueError("未知模型标签: %r" % (label,))
    if not _is_number(score) or score < 0 or score > 1:
        raise ValueError("score 必须在 0-1 之间，实际 %r" % (score,))
    if not isinstance(bbox, (list, tuple)) or len(bbox) != 4:
        raise ValueError("bbox 必须是 (x, y, w, h)")
    for v in bbox:
        if not _is_number(v):
            raise ValueError("bbox 各项必须是数字")
    if bbox[2] <= 0 or bbox[3] <= 0:
        raise ValueError("bbox 的宽高必须为正")
    return {"label": label, "score": score, "bbox": tuple(bbox)}


def iou(box_a, box_b):
    """两个 (x, y, w, h) 框的交并比，0-1。"""
    ax, ay, aw, ah = box_a
    bx, by, bw, bh = box_b
    x0 = max(ax, bx)
    y0 = max(ay, by)
    x1 = min(ax + aw, bx + bw)
    y1 = min(ay + ah, by + bh)
    if x1 <= x0 or y1 <= y0:
        return 0.0
    inter = (x1 - x0) * (y1 - y0)
    union = aw * ah + bw * bh - inter
    if union <= 0:
        return 0.0
    return inter / union


def nms(detections, iou_threshold=DEFAULT_NMS_IOU, score_threshold=0.0):
    """按类别做 NMS：分数低于 score_threshold 的先丢；同类框 IoU 大于阈值时保留分数高者。

    返回新列表（按分数从高到低），不修改入参。板上 KPU 后处理若已含 NMS，这里仅作主机侧对照。
    """
    if not _is_number(iou_threshold) or iou_threshold < 0 or iou_threshold > 1:
        raise ValueError("iou_threshold 必须在 0-1 之间")
    candidates = []
    for det in detections:
        if det["score"] >= score_threshold:
            candidates.append(det)
    candidates.sort(key=lambda d: -d["score"])
    kept = []
    for det in candidates:
        suppressed = False
        for other in kept:
            if other["label"] == det["label"] and iou(other["bbox"], det["bbox"]) > iou_threshold:
                suppressed = True
                break
        if not suppressed:
            kept.append(det)
    return kept


def classify_bean(front_detections, rear_detections, min_score):
    """合并一颗配对豆前后两面的检测，给出单豆判定。

    规则：分数不低于 min_score 的检测里取分数最高者（并列取先出现者）。
    返回 {"verdict", "defect", "model_label", "score", "fade"}：
      defect   命中 SCA 16 类之一时为其键，否则 None（可直接传给 session.record_bean(defect=...)）
      fade     褪色豆在 SCA 表无对应行，defect 为 None、fade 为 True，由调用方单独计数
      verdict  defect / fade / no_defect_detected（没检出瑕疵，不等于判为正常豆）
    """
    best = None
    for det in list(front_detections) + list(rear_detections):
        if det["label"] not in MODEL_LABELS:
            raise ValueError("未知模型标签: %r" % (det["label"],))
        if det["score"] < min_score:
            continue
        if best is None or det["score"] > best["score"]:
            best = det
    if best is None:
        return {"verdict": VERDICT_NONE, "defect": None, "model_label": None,
                "score": None, "fade": False}
    if best["label"] == counting.FADE_LABEL:
        return {"verdict": VERDICT_FADE, "defect": None, "model_label": best["label"],
                "score": best["score"], "fade": True}
    return {"verdict": VERDICT_DEFECT, "defect": counting.MODEL_TO_SCA[best["label"]],
            "model_label": best["label"], "score": best["score"], "fade": False}


def annotate_candidates(candidates, detections_per_candidate):
    """把检测结果挂回候选的 track_id：返回 [{"track_id","side","t_ms","detections"}, ...]。"""
    if len(candidates) != len(detections_per_candidate):
        raise ValueError("候选数与检测结果数不一致")
    out = []
    for i in range(len(candidates)):
        c = candidates[i]
        out.append({
            "track_id": c["track_id"],
            "side": c["side"],
            "t_ms": c["t_ms"],
            "detections": list(detections_per_candidate[i]),
        })
    return out


# ---------------------------------------------------------------- 检测器

class BaseDetector:
    def load(self):
        raise NotImplementedError("子类实现")

    def infer(self, crops):
        """对一批裁图（不超过 BATCH_MAX 张）推理，返回与 crops 等长的列表，
        每项是该裁图的检测结果列表（make_detection 的形状）。"""
        raise NotImplementedError("子类实现")


class KpuDetector(BaseDetector):
    """板侧 KPU 检测器占位。以下全是注释，未在板上验证，不真实调用任何 SDK。"""

    def load(self):
        # 板侧占位：
        #   - 记录并核对 kmodel / 标签 / 预处理文件的校验值，填入 MODEL_RECORD_TEMPLATE
        #   - 加载 kmodel（nncase 版本须与转换时一致；ONNX 不能当 KPU 可执行模型）
        #   - 按 PREPROCESS_SPEC 配置输入（颜色通道、缩放、归一化与训练一致）
        raise NotImplementedError("板侧占位：待上板核对 CanMV / nncase 版本后实现")

    def infer(self, crops):
        # 板侧占位：逐张预处理 -> KPU 前向 -> 解码输出为 bbox + 标签 + 置信度 -> nms()
        # 检测输出不得与分类输出混用；推理结束后立即释放输入缓冲。
        raise NotImplementedError("板侧占位")


class FakeDetector(BaseDetector):
    """主机 mock：script 是「每张裁图一份检测列表」的序列，按推理顺序消费，用完返回空列表。"""

    def __init__(self, script=None):
        self.script = list(script) if script else []
        self.loaded = False
        self.batch_sizes = []

    def load(self):
        self.loaded = True

    def infer(self, crops):
        self.batch_sizes.append(len(crops))
        out = []
        for _ in crops:
            if self.script:
                out.append(list(self.script.pop(0)))
            else:
                out.append([])
        return out


def split_batches(items, batch_max=BATCH_MAX):
    """把列表切成每份不超过 batch_max 的批。batch_max 超过 BATCH_MAX 或小于 1 抛 ValueError。"""
    if isinstance(batch_max, bool) or not isinstance(batch_max, int) or batch_max < 1 or batch_max > BATCH_MAX:
        raise ValueError("batch_max 必须是 1-%d 的整数，实际 %r" % (BATCH_MAX, batch_max))
    batches = []
    index = 0
    while index < len(items):
        batches.append(list(items[index:index + batch_max]))
        index += batch_max
    return batches


def infer_batches(detector, crops, batch_max=BATCH_MAX):
    """分批推理，返回与 crops 等长的检测列表。检测器返回条数不对时抛 ValueError。"""
    results = []
    for batch in split_batches(crops, batch_max):
        out = detector.infer(batch)
        if len(out) != len(batch):
            raise ValueError("检测器返回 %d 项，应为 %d 项" % (len(out), len(batch)))
        for item in out:
            results.append(item)
    return results
