# 16 类瑕疵：名称与顺序的唯一来源（ADR 0001，SCA 物理性评估表 350g 样品版）。
# 顺序与 ADR 0001 当量表的行序一致：一类 6 项，二类 10 项。
# ADR 0001 只给出中文名；英文键沿用 ARCHITECTURE-v1 示例，其中 quaker 在 ADR 表中
# 无对应行，改为 ADR 的「带壳豆」(parchment)。平台侧正式键冻结后只改这里。

CATEGORY_1 = [
    "full_black",         # 全黑豆
    "full_sour",          # 全酸豆
    "pod_dried_cherry",   # 咖啡干果
    "fungus",             # 发霉豆
    "foreign_matter",     # 异物
    "insect_severe",      # 严重虫蛀豆
]

CATEGORY_2 = [
    "partial_black",      # 局部黑豆
    "partial_sour",       # 局部酸豆
    "parchment",          # 带壳豆
    "floater",            # 漂浮豆
    "immature",           # 未熟豆
    "withered",           # 萎凋豆
    "shell",              # 贝壳豆
    "broken_chipped",     # 破碎/破裂豆
    "hull_husk",          # 干果皮/壳
    "insect_mild",        # 轻微虫蛀豆
]

DEFECT_CLASSES = CATEGORY_1 + CATEGORY_2

DEFECT_NAMES_ZH = {
    "full_black": "全黑豆",
    "full_sour": "全酸豆",
    "pod_dried_cherry": "咖啡干果",
    "fungus": "发霉豆",
    "foreign_matter": "异物",
    "insect_severe": "严重虫蛀豆",
    "partial_black": "局部黑豆",
    "partial_sour": "局部酸豆",
    "parchment": "带壳豆",
    "floater": "漂浮豆",
    "immature": "未熟豆",
    "withered": "萎凋豆",
    "shell": "贝壳豆",
    "broken_chipped": "破碎/破裂豆",
    "hull_husk": "干果皮/壳",
    "insect_mild": "轻微虫蛀豆",
}


def empty_defect_counts():
    """返回 16 类全键齐全、计数均为 0 的新字典。"""
    counts = {}
    for key in DEFECT_CLASSES:
        counts[key] = 0
    return counts
