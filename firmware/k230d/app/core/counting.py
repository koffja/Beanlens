# 计数规则与预览计点（票 03，ADR 0001）。
# - 当量从 app/config/rules_sca_provisional.json 读取，代码里不写死。
#   equivalents 的值是整数比例 N，表示「N 颗 = 1 个 full defect」（1:1 记 1，3:1 记 3，……）。
# - 预览计点只供屏显参考，不进记录体；记录体里没有点值和等级（由平台重算）。
# - 豆粒总数 = 配对成功 + 配对不明，与任何模型输出无关。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
from app.core import storage
from app.core.defect_classes import CATEGORY_1, CATEGORY_2, DEFECT_CLASSES, empty_defect_counts

RULES_FILENAME = "rules_sca_provisional.json"
PROVISIONAL_MARK = "provisional"
PROVISIONAL_LABEL = "临时规则"

# 数据集 data.yaml 的 16 个模型标签 -> SCA 行键（沿用 defect_classes.py）。
# cut 与 broken 合并为「破碎/破裂豆」；fade 在 SCA 表无对应行，单独走 FADE_LABEL。
FADE_LABEL = "fade"
MODEL_TO_SCA = {
    "broken": "broken_chipped",
    "cut": "broken_chipped",
    "dry_cherry": "pod_dried_cherry",
    "floater": "floater",
    "full_black": "full_black",
    "full_sour": "full_sour",
    "fungus": "fungus",
    "husk": "hull_husk",
    "immature": "immature",
    "parchment": "parchment",
    "partial_black": "partial_black",
    "partial_sour": "partial_sour",
    "severe_insect_damage": "insect_severe",
    "shell": "shell",
    "withered": "withered",
}

_default_rules = None


def _default_rules_path():
    here = globals().get("__file__")
    if isinstance(here, str) and "/" in here:
        core_dir = here.rsplit("/", 1)[0]
        if "/" in core_dir:
            app_dir = core_dir.rsplit("/", 1)[0]
            return storage.join_path(app_dir, "config", RULES_FILENAME)
    # 假设值：取不到模块路径时按从 firmware/k230d 起运行处理，未在板上核对。
    return storage.join_path("app", "config", RULES_FILENAME)


def _is_int(value):
    return isinstance(value, int) and not isinstance(value, bool)


def _check_key_list(name, value, expected):
    if not isinstance(value, list):
        raise ValueError("规则文件 %s 必须是列表" % name)
    for key in value:
        if not isinstance(key, str):
            raise ValueError("规则文件 %s 含有非字符串项: %r" % (name, key))
    if len(set(value)) != len(value):
        raise ValueError("规则文件 %s 含有重复项" % name)
    if set(value) != set(expected):
        raise ValueError(
            "规则文件 %s 与 ADR 0001 的类别归属不一致，应为 %d 项: %s"
            % (name, len(expected), ", ".join(expected))
        )


def _validate_rules(rules):
    if not isinstance(rules, dict):
        raise ValueError("规则文件必须是 JSON 对象")
    version = rules.get("rule_version")
    if not isinstance(version, str) or version == "":
        raise ValueError("规则文件缺少 rule_version")
    equivalents = rules.get("equivalents")
    if not isinstance(equivalents, dict):
        raise ValueError("规则文件缺少 equivalents")
    if set(equivalents.keys()) != set(DEFECT_CLASSES):
        raise ValueError("规则文件 equivalents 必须恰好包含 16 个 SCA 键")
    for key in equivalents:
        ratio = equivalents[key]
        if not _is_int(ratio) or ratio <= 0:
            raise ValueError("规则文件 equivalents[%s] 必须是正整数比例，实际 %r" % (key, ratio))
    _check_key_list("category1", rules.get("category1"), CATEGORY_1)
    _check_key_list("category2", rules.get("category2"), CATEGORY_2)


def load_rules(path=None):
    """读取并校验规则文件，返回规则字典。文件缺失、损坏或内容不合法抛 ValueError。

    path 为 None 时读 app/config/rules_sca_provisional.json（结果不缓存，调用方自行持有）。
    """
    if path is None:
        path = _default_rules_path()
    rules = storage.read_json(path)
    if rules is None:
        raise ValueError("规则文件缺失或不是合法 JSON: %s" % path)
    _validate_rules(rules)
    return rules


def _rules_or_default(rules):
    global _default_rules
    if rules is not None:
        return rules
    if _default_rules is None:
        _default_rules = load_rules()
    return _default_rules


def _check_count_value(label, value):
    if not _is_int(value) or value < 0:
        raise ValueError("%s 必须是非负整数，实际 %r" % (label, value))


def _normalized_counts(defect_counts):
    """校验并补齐 16 键；缺的键按 0，未知键或非法值抛 ValueError。返回新字典。"""
    if not isinstance(defect_counts, dict):
        raise ValueError("defect_counts 必须是字典")
    for key in defect_counts:
        if key not in DEFECT_CLASSES:
            raise ValueError("未知瑕疵键: %r" % (key,))
    counts = empty_defect_counts()
    for key in defect_counts:
        _check_count_value("瑕疵计数 %s" % key, defect_counts[key])
        counts[key] = defect_counts[key]
    return counts


def _gcd(a, b):
    while b:
        a, b = b, a % b
    return a


def _lcm_of(values):
    result = 1
    for v in values:
        result = result // _gcd(result, v) * v
    return result


def group_counts(defect_counts, rules=None):
    """按一类 / 二类分组，供 UI 列表使用。

    返回 {"category1": [(key, count), ...], "category2": [...]}，各组顺序与规则文件一致。
    """
    rules = _rules_or_default(rules)
    counts = _normalized_counts(defect_counts)
    grouped = {"category1": [], "category2": []}
    for key in rules["category1"]:
        grouped["category1"].append((key, counts[key]))
    for key in rules["category2"]:
        grouped["category2"].append((key, counts[key]))
    return grouped


def preview_points(defect_counts, rules=None):
    """按规则文件当量算预览计点（仅供屏显，不进记录体，没有等级）。

    返回字典：
      rule_version        规则版本串，屏上必须显示
      provisional         True 表示临时规则
      provisional_label   临时规则时为「临时规则」，否则 ""
      category1_points    一类 full defect 数
      category2_points    二类 full defect 数
      preview_points      两类合计
    用整数通分后再相除，避免 1/3 之类的浮点累加误差。
    """
    rules = _rules_or_default(rules)
    counts = _normalized_counts(defect_counts)
    equivalents = rules["equivalents"]
    common = _lcm_of([equivalents[k] for k in DEFECT_CLASSES])

    units1 = 0
    for key in rules["category1"]:
        units1 += counts[key] * (common // equivalents[key])
    units2 = 0
    for key in rules["category2"]:
        units2 += counts[key] * (common // equivalents[key])

    version = rules["rule_version"]
    provisional = version.find(PROVISIONAL_MARK) >= 0
    return {
        "rule_version": version,
        "provisional": provisional,
        "provisional_label": PROVISIONAL_LABEL if provisional else "",
        "category1_points": units1 / common,
        "category2_points": units2 / common,
        "preview_points": (units1 + units2) / common,
    }


def map_model_counts(model_counts):
    """把模型 16 类计数映射到 SCA 16 行。

    返回 (defects, fade_count)：defects 为 16 键齐全的新字典；fade（褪色豆）不进 defects，
    单独返回，供 metadata.quality.fade_count 使用。未知标签或非法计数抛 ValueError。
    """
    if not isinstance(model_counts, dict):
        raise ValueError("model_counts 必须是字典")
    defects = empty_defect_counts()
    fade_count = 0
    for label in model_counts:
        value = model_counts[label]
        if label != FADE_LABEL and label not in MODEL_TO_SCA:
            raise ValueError("未知模型类别: %r" % (label,))
        _check_count_value("模型计数 %s" % label, value)
        if label == FADE_LABEL:
            fade_count += value
        else:
            defects[MODEL_TO_SCA[label]] += value
    return defects, fade_count


def compute_bean_total(paired_count, unpaired_count):
    """豆粒总数 = 配对成功 + 配对不明，与模型输出无关。"""
    _check_count_value("配对成功数", paired_count)
    _check_count_value("配对不明数", unpaired_count)
    return paired_count + unpaired_count


def check_counts(bean_total, defect_counts):
    """自检：16 类计数之和大于豆粒总数时抛 ValueError（调用方据此拒绝保存）。"""
    _check_count_value("豆粒总数", bean_total)
    counts = _normalized_counts(defect_counts)
    total = 0
    for key in counts:
        total += counts[key]
    if total > bean_total:
        raise ValueError(
            "计数不自洽：16 类瑕疵计数之和 %d 大于豆粒总数 %d，拒绝保存" % (total, bean_total)
        )


def build_record_counts(paired_count, unpaired_count, model_counts):
    """由配对结果和模型类计数生成记录体用的计数，并做自检。

    返回 {"bean_count_total", "unpaired_count", "defects", "fade_count"}；
    不含点值与等级。自检不通过抛 ValueError。
    """
    total = compute_bean_total(paired_count, unpaired_count)
    defects, fade_count = map_model_counts(model_counts)
    check_counts(total, defects)
    return {
        "bean_count_total": total,
        "unpaired_count": unpaired_count,
        "defects": defects,
        "fade_count": fade_count,
    }
