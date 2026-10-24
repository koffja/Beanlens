import json
import os
import shutil
import tempfile
import unittest

from app.core import counting
from app.core.defect_classes import (
    CATEGORY_1,
    CATEGORY_2,
    DEFECT_CLASSES,
    empty_defect_counts,
)
from app.core.scan_session import ScanSession

# ADR 0001 当量表（N 颗计 1 个 full defect），测试里独立抄一份用来对照配置文件。
ADR_RATIOS = {
    "full_black": 1,
    "full_sour": 1,
    "pod_dried_cherry": 1,
    "fungus": 1,
    "foreign_matter": 1,
    "insect_severe": 5,
    "partial_black": 3,
    "partial_sour": 3,
    "parchment": 5,
    "floater": 5,
    "immature": 5,
    "withered": 5,
    "shell": 5,
    "broken_chipped": 5,
    "hull_husk": 5,
    "insect_mild": 10,
}

# 数据集 data.yaml 里的 16 个模型标签。
MODEL_LABELS = [
    "broken", "cut", "dry_cherry", "fade", "floater", "full_black", "full_sour",
    "fungus", "husk", "immature", "parchment", "partial_black", "partial_sour",
    "severe_insect_damage", "shell", "withered",
]


def _counts(**kwargs):
    counts = empty_defect_counts()
    for key in kwargs:
        counts[key] = kwargs[key]
    return counts


def _all_keys(obj):
    keys = []
    if isinstance(obj, dict):
        for k in obj:
            keys.append(k)
            keys.extend(_all_keys(obj[k]))
    elif isinstance(obj, (list, tuple)):
        for item in obj:
            keys.extend(_all_keys(item))
    return keys


class RulesFileTest(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.mkdtemp(prefix="beanlens-test-")
        self.addCleanup(shutil.rmtree, self.dir, True)

    def _write_rules(self, rules, name="rules.json"):
        path = os.path.join(self.dir, name)
        with open(path, "w") as f:
            f.write(json.dumps(rules))
        return path

    def test_shipped_rules_match_adr_0001(self):
        rules = counting.load_rules()
        self.assertEqual(rules["rule_version"], "sca-provisional")
        self.assertEqual(rules["equivalents"], ADR_RATIOS)
        self.assertEqual(len(rules["category1"]), 6)
        self.assertEqual(len(rules["category2"]), 10)
        self.assertEqual(rules["category1"], CATEGORY_1)
        self.assertEqual(rules["category2"], CATEGORY_2)

    def test_ratios_are_the_four_adr_values(self):
        rules = counting.load_rules()
        self.assertEqual(sorted(set(rules["equivalents"].values())), [1, 3, 5, 10])

    def test_equivalents_are_read_from_the_config_file(self):
        rules = counting.load_rules()
        changed = {
            "rule_version": "sca-test-9",
            "equivalents": dict(rules["equivalents"]),
            "category1": rules["category1"],
            "category2": rules["category2"],
        }
        changed["equivalents"]["full_black"] = 2
        path = self._write_rules(changed)
        loaded = counting.load_rules(path)
        result = counting.preview_points(_counts(full_black=1), loaded)
        self.assertAlmostEqual(result["preview_points"], 0.5)
        self.assertEqual(result["rule_version"], "sca-test-9")

    def test_missing_rules_file_is_an_error(self):
        with self.assertRaises(ValueError):
            counting.load_rules(os.path.join(self.dir, "nope.json"))

    def test_corrupt_rules_file_is_an_error(self):
        path = os.path.join(self.dir, "bad.json")
        with open(path, "w") as f:
            f.write('{"rule_version": "x"')
        with self.assertRaises(ValueError):
            counting.load_rules(path)

    def test_rules_missing_a_class_are_rejected(self):
        rules = counting.load_rules()
        equivalents = dict(rules["equivalents"])
        del equivalents["shell"]
        path = self._write_rules({
            "rule_version": "x",
            "equivalents": equivalents,
            "category1": rules["category1"],
            "category2": rules["category2"],
        })
        with self.assertRaises(ValueError):
            counting.load_rules(path)

    def test_rules_with_nonpositive_ratio_are_rejected(self):
        rules = counting.load_rules()
        for bad in (0, -3, 2.5, "5", None):
            equivalents = dict(rules["equivalents"])
            equivalents["shell"] = bad
            path = self._write_rules({
                "rule_version": "x",
                "equivalents": equivalents,
                "category1": rules["category1"],
                "category2": rules["category2"],
            })
            with self.assertRaises(ValueError):
                counting.load_rules(path)

    def test_rules_with_wrong_category_split_are_rejected(self):
        rules = counting.load_rules()
        path = self._write_rules({
            "rule_version": "x",
            "equivalents": rules["equivalents"],
            "category1": rules["category1"] + ["shell"],
            "category2": [k for k in rules["category2"] if k != "shell"],
        })
        with self.assertRaises(ValueError):
            counting.load_rules(path)


class PreviewPointsTest(unittest.TestCase):
    def test_all_zero_counts_give_zero_points(self):
        result = counting.preview_points(empty_defect_counts())
        self.assertEqual(result["category1_points"], 0)
        self.assertEqual(result["category2_points"], 0)
        self.assertEqual(result["preview_points"], 0)

    def test_each_class_follows_adr_ratio(self):
        for key in DEFECT_CLASSES:
            ratio = ADR_RATIOS[key]
            one = counting.preview_points(_counts(**{key: ratio}))
            self.assertAlmostEqual(one["preview_points"], 1.0, msg=key)
            if key in CATEGORY_1:
                self.assertAlmostEqual(one["category1_points"], 1.0, msg=key)
                self.assertEqual(one["category2_points"], 0, msg=key)
            else:
                self.assertEqual(one["category1_points"], 0, msg=key)
                self.assertAlmostEqual(one["category2_points"], 1.0, msg=key)

    def test_single_bean_is_a_fraction_of_a_full_defect(self):
        self.assertAlmostEqual(
            counting.preview_points(_counts(partial_black=1))["preview_points"], 1.0 / 3)
        self.assertAlmostEqual(
            counting.preview_points(_counts(insect_mild=1))["preview_points"], 0.1)
        self.assertAlmostEqual(
            counting.preview_points(_counts(insect_severe=1))["preview_points"], 0.2)

    def test_category_split_and_total(self):
        counts = _counts(full_black=2, insect_severe=5,
                         partial_sour=3, shell=5, insect_mild=10)
        result = counting.preview_points(counts)
        self.assertAlmostEqual(result["category1_points"], 3.0)
        self.assertAlmostEqual(result["category2_points"], 3.0)
        self.assertAlmostEqual(result["preview_points"], 6.0)

    def test_fractional_sum_has_no_accumulated_error(self):
        # 30 颗局部黑豆 = 10 个 full defect，不能因为 1/3 的浮点累加偏掉。
        result = counting.preview_points(_counts(partial_black=30))
        self.assertEqual(result["preview_points"], 10.0)

    def test_result_carries_rule_version_and_provisional_flag(self):
        result = counting.preview_points(empty_defect_counts())
        self.assertEqual(result["rule_version"], "sca-provisional")
        self.assertTrue(result["provisional"])
        self.assertEqual(result["provisional_label"], "临时规则")

    def test_non_provisional_version_drops_the_label(self):
        rules = counting.load_rules()
        frozen = {
            "rule_version": "sca-v1",
            "equivalents": rules["equivalents"],
            "category1": rules["category1"],
            "category2": rules["category2"],
        }
        result = counting.preview_points(empty_defect_counts(), frozen)
        self.assertEqual(result["rule_version"], "sca-v1")
        self.assertFalse(result["provisional"])
        self.assertEqual(result["provisional_label"], "")

    def test_result_has_no_grade(self):
        result = counting.preview_points(_counts(full_black=9))
        for key in result:
            self.assertNotIn("grade", key)

    def test_does_not_modify_input(self):
        counts = _counts(full_black=2)
        before = dict(counts)
        counting.preview_points(counts)
        self.assertEqual(counts, before)

    def test_invalid_counts_are_rejected(self):
        for bad in (-1, 1.5, "2", None, True):
            with self.assertRaises(ValueError, msg=repr(bad)):
                counting.preview_points(_counts(shell=bad))
        unknown = empty_defect_counts()
        unknown["elephant_ear"] = 1
        with self.assertRaises(ValueError):
            counting.preview_points(unknown)

    def test_missing_keys_count_as_zero(self):
        result = counting.preview_points({"full_black": 2})
        self.assertAlmostEqual(result["preview_points"], 2.0)


class GroupCountsTest(unittest.TestCase):
    def test_groups_are_six_and_ten_in_rule_order(self):
        grouped = counting.group_counts(_counts(full_black=2, shell=4))
        self.assertEqual([k for k, _ in grouped["category1"]], CATEGORY_1)
        self.assertEqual([k for k, _ in grouped["category2"]], CATEGORY_2)
        self.assertEqual(len(grouped["category1"]), 6)
        self.assertEqual(len(grouped["category2"]), 10)

    def test_group_values_follow_the_counts(self):
        grouped = counting.group_counts(_counts(full_black=2, shell=4))
        self.assertEqual(dict(grouped["category1"])["full_black"], 2)
        self.assertEqual(dict(grouped["category2"])["shell"], 4)
        self.assertEqual(dict(grouped["category2"])["floater"], 0)


class ModelMappingTest(unittest.TestCase):
    def test_cut_and_broken_merge_into_broken_chipped(self):
        defects, fade = counting.map_model_counts({"cut": 3, "broken": 4})
        self.assertEqual(defects["broken_chipped"], 7)
        self.assertEqual(fade, 0)

    def test_fade_is_not_a_reported_class(self):
        defects, fade = counting.map_model_counts({"fade": 5})
        self.assertEqual(fade, 5)
        self.assertEqual(sum(defects.values()), 0)
        self.assertEqual(sorted(defects.keys()), sorted(DEFECT_CLASSES))

    def test_result_always_has_all_16_keys(self):
        defects, fade = counting.map_model_counts({})
        self.assertEqual(defects, empty_defect_counts())
        self.assertEqual(fade, 0)

    def test_renamed_labels_land_on_their_sca_rows(self):
        defects, _ = counting.map_model_counts({
            "dry_cherry": 1, "husk": 2, "severe_insect_damage": 3,
        })
        self.assertEqual(defects["pod_dried_cherry"], 1)
        self.assertEqual(defects["hull_husk"], 2)
        self.assertEqual(defects["insect_severe"], 3)

    def test_every_model_label_is_accepted_and_nothing_is_lost(self):
        # 16 个模型标签各出现 1 次：cut+broken 合并成 2，fade 单独记 1，其余各 1。
        model_counts = {}
        for label in MODEL_LABELS:
            model_counts[label] = 1
        defects, fade = counting.map_model_counts(model_counts)
        self.assertEqual(fade, 1)
        self.assertEqual(defects["broken_chipped"], 2)
        self.assertEqual(sum(defects.values()) + fade, 16)

    def test_model_has_no_foreign_matter_or_mild_insect_label(self):
        model_counts = {}
        for label in MODEL_LABELS:
            model_counts[label] = 1
        defects, _ = counting.map_model_counts(model_counts)
        self.assertEqual(defects["foreign_matter"], 0)
        self.assertEqual(defects["insect_mild"], 0)

    def test_unknown_model_label_is_rejected(self):
        with self.assertRaises(ValueError):
            counting.map_model_counts({"quaker": 1})

    def test_bad_model_counts_are_rejected(self):
        for bad in (-1, 1.5, "1", None, True):
            with self.assertRaises(ValueError, msg=repr(bad)):
                counting.map_model_counts({"broken": bad})


class BeanTotalTest(unittest.TestCase):
    def test_total_is_paired_plus_unpaired(self):
        self.assertEqual(counting.compute_bean_total(80, 20), 100)
        self.assertEqual(counting.compute_bean_total(0, 0), 0)
        self.assertEqual(counting.compute_bean_total(0, 7), 7)

    def test_negative_or_non_integer_inputs_are_rejected(self):
        for paired, unpaired in ((-1, 0), (0, -1), (1.5, 0), (0, "2"), (True, 0)):
            with self.assertRaises(ValueError):
                counting.compute_bean_total(paired, unpaired)

    def test_total_does_not_depend_on_model_output(self):
        quiet = counting.build_record_counts(8, 2, {})
        busy = counting.build_record_counts(8, 2, {"broken": 3, "fade": 4, "shell": 1})
        self.assertEqual(quiet["bean_count_total"], 10)
        self.assertEqual(busy["bean_count_total"], 10)

    def test_unpaired_beans_are_in_total_but_in_no_class(self):
        result = counting.build_record_counts(8, 2, {})
        self.assertEqual(result["bean_count_total"], 10)
        self.assertEqual(result["unpaired_count"], 2)
        self.assertEqual(sum(result["defects"].values()), 0)


class SelfCheckTest(unittest.TestCase):
    def test_all_zero_is_valid(self):
        counting.check_counts(0, empty_defect_counts())
        counting.check_counts(100, empty_defect_counts())

    def test_sum_equal_to_total_is_valid(self):
        counting.check_counts(10, _counts(full_black=4, shell=6))

    def test_sum_above_total_is_rejected_with_clear_message(self):
        with self.assertRaises(ValueError) as ctx:
            counting.check_counts(10, _counts(full_black=6, shell=5))
        message = str(ctx.exception)
        self.assertIn("11", message)
        self.assertIn("10", message)

    def test_any_defect_with_zero_total_is_rejected(self):
        with self.assertRaises(ValueError):
            counting.check_counts(0, _counts(floater=1))

    def test_single_class_above_30_percent_is_not_rejected(self):
        counting.check_counts(100, _counts(partial_black=40))
        counting.check_counts(100, _counts(partial_black=100))
        counting.check_counts(10, _counts(full_black=10))

    def test_check_does_not_modify_counts(self):
        counts = _counts(shell=2)
        before = dict(counts)
        counting.check_counts(5, counts)
        self.assertEqual(counts, before)

    def test_invalid_total_is_rejected(self):
        for bad in (-1, 1.5, "10", None, True):
            with self.assertRaises(ValueError, msg=repr(bad)):
                counting.check_counts(bad, empty_defect_counts())


class BuildRecordCountsTest(unittest.TestCase):
    def test_all_zero_session(self):
        result = counting.build_record_counts(0, 0, {})
        self.assertEqual(result["bean_count_total"], 0)
        self.assertEqual(result["unpaired_count"], 0)
        self.assertEqual(result["defects"], empty_defect_counts())
        self.assertEqual(result["fade_count"], 0)

    def test_maps_model_counts_and_reports_fade_separately(self):
        result = counting.build_record_counts(
            45, 5, {"broken": 3, "cut": 2, "fade": 4, "full_black": 1})
        self.assertEqual(result["bean_count_total"], 50)
        self.assertEqual(result["unpaired_count"], 5)
        self.assertEqual(result["defects"]["broken_chipped"], 5)
        self.assertEqual(result["defects"]["full_black"], 1)
        self.assertEqual(result["fade_count"], 4)

    def test_class_share_above_30_percent_is_accepted(self):
        result = counting.build_record_counts(10, 0, {"partial_black": 8})
        self.assertEqual(result["defects"]["partial_black"], 8)

    def test_merged_counts_above_total_are_rejected(self):
        # cut 2 + broken 2 合并成 4，大于豆粒总数 3。
        with self.assertRaises(ValueError):
            counting.build_record_counts(3, 0, {"cut": 2, "broken": 2})

    def test_result_has_no_points_or_grade(self):
        result = counting.build_record_counts(10, 1, {"shell": 2})
        self.assertEqual(
            sorted(result.keys()),
            ["bean_count_total", "defects", "fade_count", "unpaired_count"])

    def test_existing_session_record_body_has_no_points_or_grade(self):
        tmp = tempfile.mkdtemp(prefix="beanlens-test-")
        self.addCleanup(shutil.rmtree, tmp, True)
        record = ScanSession.fake(base_dir=tmp, sample_weight_g=350).to_record_json()
        for key in _all_keys(record):
            lowered = str(key).lower()
            self.assertNotIn("point", lowered)
            self.assertNotIn("grade", lowered)
            self.assertNotIn("full_defect", lowered)


if __name__ == "__main__":
    unittest.main()
