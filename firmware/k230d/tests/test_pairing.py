import os
import shutil
import tempfile
import unittest

from app.capture import pairing
from app.core import storage

SHIPPED_CONFIG = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "..", "app", "config", "capture_config.json"
)


def T(track_id, t_ms, bad=False):
    return pairing.make_track(track_id, t_ms, insufficient=bad)


def pair_ids(result):
    return sorted((p["front_id"], p["rear_id"]) for p in result["pairs"])


class ToleranceConfigTest(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.mkdtemp(prefix="beanlens-test-")
        self.addCleanup(shutil.rmtree, self.dir, True)

    def cfg(self, tolerance=None, fps1=30, fps2=30):
        return {
            "csi1": {"width": 640, "height": 480, "fps": fps1},
            "csi2": {"width": 640, "height": 480, "fps": fps2},
            "time_pair_tolerance_ms": tolerance,
        }

    def test_null_tolerance_is_two_frame_intervals(self):
        self.assertAlmostEqual(pairing.tolerance_ms_from_config(self.cfg()), 2000.0 / 30)

    def test_explicit_ms_overrides_frame_rate(self):
        self.assertEqual(pairing.tolerance_ms_from_config(self.cfg(tolerance=25)), 25)

    def test_zero_tolerance_is_allowed(self):
        self.assertEqual(pairing.tolerance_ms_from_config(self.cfg(tolerance=0)), 0)

    def test_slower_camera_sets_the_default(self):
        got = pairing.tolerance_ms_from_config(self.cfg(fps1=30, fps2=15))
        self.assertAlmostEqual(got, 2000.0 / 15)

    def test_bad_explicit_tolerance_is_rejected(self):
        for bad in (-1, "20", True, [10]):
            with self.assertRaises(ValueError):
                pairing.tolerance_ms_from_config(self.cfg(tolerance=bad))

    def test_null_tolerance_needs_usable_fps_on_both_cameras(self):
        for bad_fps in (0, -5, None, "30", True):
            with self.assertRaises(ValueError):
                pairing.tolerance_ms_from_config(self.cfg(fps1=bad_fps))
            with self.assertRaises(ValueError):
                pairing.tolerance_ms_from_config(self.cfg(fps2=bad_fps))
        with self.assertRaises(ValueError):
            pairing.tolerance_ms_from_config({"time_pair_tolerance_ms": None})
        with self.assertRaises(ValueError):
            pairing.tolerance_ms_from_config(None)

    def test_load_from_json_file(self):
        path = os.path.join(self.dir, "cfg", "capture_config.json")
        storage.atomic_write_json(path, self.cfg(tolerance=40))
        self.assertEqual(pairing.load_tolerance_ms(path), 40)
        storage.atomic_write_json(path, self.cfg(tolerance=None, fps1=20, fps2=20))
        self.assertAlmostEqual(pairing.load_tolerance_ms(path), 100.0)

    def test_missing_or_corrupt_file_is_rejected(self):
        with self.assertRaises(ValueError):
            pairing.load_tolerance_ms(os.path.join(self.dir, "nope.json"))
        bad = os.path.join(self.dir, "bad.json")
        with open(bad, "w") as f:
            f.write("{not json")
        with self.assertRaises(ValueError):
            pairing.load_tolerance_ms(bad)

    def test_shipped_config_has_expected_fields_and_default_tolerance(self):
        config = storage.read_json(SHIPPED_CONFIG)
        for key in ("csi1", "csi2", "roi_queue_max", "time_pair_tolerance_ms",
                    "motion_threshold", "trigger_cooldown_ms"):
            self.assertIn(key, config)
        # 随包配置的 ΔT 为 null，所以应落在「2 帧间隔」上。
        self.assertIsNone(config["time_pair_tolerance_ms"])
        expected = 2000.0 / min(config["csi1"]["fps"], config["csi2"]["fps"])
        self.assertAlmostEqual(pairing.load_tolerance_ms(SHIPPED_CONFIG), expected)
        # 不传路径时读的就是随包配置，且与当前工作目录无关。
        self.assertAlmostEqual(pairing.load_tolerance_ms(), expected)


class PairTracksTest(unittest.TestCase):
    def assertConsistent(self, result, fronts, rears):
        """所有结果都必须满足的不变式：总数恒等式、每个 track 恰好被消费一次。"""
        self.assertEqual(
            result["bean_count_total"], result["paired_count"] + result["unpaired_count"]
        )
        self.assertEqual(result["paired_count"], len(result["pairs"]))
        self.assertEqual(
            result["unpaired_count"],
            len(result["unpaired_front_ids"]) + len(result["unpaired_rear_ids"]),
        )
        used_front = [p["front_id"] for p in result["pairs"]] + result["unpaired_front_ids"]
        used_rear = [p["rear_id"] for p in result["pairs"]] + result["unpaired_rear_ids"]
        self.assertEqual(sorted(used_front), sorted(t["track_id"] for t in fronts))
        self.assertEqual(sorted(used_rear), sorted(t["track_id"] for t in rears))
        self.assertLessEqual(result["rejected_count"], result["paired_count"])
        self.assertEqual(
            result["classifiable_count"], result["paired_count"] - result["rejected_count"]
        )

    def run_pair(self, fronts, rears, tolerance_ms):
        result = pairing.pair_tracks(fronts, rears, tolerance_ms)
        self.assertConsistent(result, fronts, rears)
        return result

    def test_normal_pairing(self):
        fronts = [T("f1", 100), T("f2", 200), T("f3", 300)]
        rears = [T("r1", 110), T("r2", 205), T("r3", 290)]
        result = self.run_pair(fronts, rears, 30)
        self.assertEqual(pair_ids(result), [("f1", "r1"), ("f2", "r2"), ("f3", "r3")])
        self.assertEqual(result["paired_count"], 3)
        self.assertEqual(result["unpaired_count"], 0)
        self.assertEqual(result["bean_count_total"], 3)
        self.assertEqual(result["pairing_rate"], 1.0)
        self.assertFalse(result["alert"]["triggered"])
        self.assertEqual(sorted(p["dt_ms"] for p in result["pairs"]), [5, 10, 10])

    def test_rear_frame_lost_leaves_front_unpaired(self):
        fronts = [T("f1", 100), T("f2", 200), T("f3", 300)]
        rears = [T("r1", 105), T("r3", 295)]
        result = self.run_pair(fronts, rears, 30)
        self.assertEqual(pair_ids(result), [("f1", "r1"), ("f3", "r3")])
        self.assertEqual(result["unpaired_front_ids"], ["f2"])
        self.assertEqual(result["unpaired_rear_ids"], [])
        self.assertEqual(result["bean_count_total"], 3)
        self.assertAlmostEqual(result["pairing_rate"], 2.0 / 3)

    def test_front_frame_lost_leaves_rear_unpaired(self):
        fronts = [T("f1", 100), T("f3", 300)]
        rears = [T("r1", 105), T("r2", 200), T("r3", 295)]
        result = self.run_pair(fronts, rears, 30)
        self.assertEqual(pair_ids(result), [("f1", "r1"), ("f3", "r3")])
        self.assertEqual(result["unpaired_front_ids"], [])
        self.assertEqual(result["unpaired_rear_ids"], ["r2"])
        self.assertEqual(result["unpaired_count"], 1)

    def test_two_beans_almost_simultaneous_stay_one_to_one(self):
        fronts = [T("f1", 1000), T("f2", 1004)]
        rears = [T("r1", 1001), T("r2", 1005)]
        result = self.run_pair(fronts, rears, 66)
        self.assertEqual(result["paired_count"], 2)
        self.assertEqual(result["unpaired_count"], 0)
        self.assertEqual(len(set(p["front_id"] for p in result["pairs"])), 2)
        self.assertEqual(len(set(p["rear_id"] for p in result["pairs"])), 2)

    def test_one_rear_cannot_be_consumed_by_two_fronts(self):
        fronts = [T("f1", 100), T("f2", 104)]
        rears = [T("r1", 102)]
        result = self.run_pair(fronts, rears, 66)
        self.assertEqual(result["paired_count"], 1)
        self.assertEqual(len(result["unpaired_front_ids"]), 1)
        self.assertEqual(result["bean_count_total"], 2)

    def test_one_front_cannot_be_consumed_by_two_rears(self):
        fronts = [T("f1", 102)]
        rears = [T("r1", 100), T("r2", 104)]
        result = self.run_pair(fronts, rears, 66)
        self.assertEqual(result["paired_count"], 1)
        self.assertEqual(len(result["unpaired_rear_ids"]), 1)

    def test_crowded_cluster_pairs_as_many_as_possible(self):
        # 若每颗前摄豆都抢最近的后摄豆，f2 会先占走 r1，f1 就落单；
        # 正确做法是 f1-r1、f2-r2 都成对。
        fronts = [T("f1", 0), T("f2", 8)]
        rears = [T("r1", 5), T("r2", 13)]
        result = self.run_pair(fronts, rears, 8)
        self.assertEqual(result["paired_count"], 2)
        self.assertEqual(result["unpaired_count"], 0)

    def test_input_order_does_not_matter_and_inputs_are_untouched(self):
        fronts = [T("f3", 300), T("f1", 100), T("f2", 200)]
        rears = [T("r2", 205), T("r3", 290), T("r1", 110)]
        fronts_before = [dict(t) for t in fronts]
        rears_before = [dict(t) for t in rears]
        result = self.run_pair(fronts, rears, 30)
        self.assertEqual(pair_ids(result), [("f1", "r1"), ("f2", "r2"), ("f3", "r3")])
        self.assertEqual(fronts, fronts_before)
        self.assertEqual(rears, rears_before)

    def test_front_and_rear_ids_are_separate_namespaces(self):
        result = self.run_pair([T("a", 100)], [T("a", 100)], 10)
        self.assertEqual(pair_ids(result), [("a", "a")])

    def test_duplicate_id_on_one_side_is_rejected(self):
        with self.assertRaises(ValueError):
            pairing.pair_tracks([T("f1", 100), T("f1", 200)], [], 30)
        with self.assertRaises(ValueError):
            pairing.pair_tracks([], [T("r1", 100), T("r1", 200)], 30)

    def test_negative_tolerance_is_rejected(self):
        with self.assertRaises(ValueError):
            pairing.pair_tracks([T("f1", 100)], [T("r1", 100)], -1)

    def test_larger_tolerance_pairs_what_a_smaller_one_leaves_alone(self):
        fronts = [T("f1", 100)]
        rears = [T("r1", 150)]
        wide = self.run_pair(fronts, rears, 60)
        self.assertEqual(wide["paired_count"], 1)
        self.assertEqual(wide["unpaired_count"], 0)
        self.assertEqual(wide["bean_count_total"], 1)
        # ΔT 过小时，同一颗豆的两路 track 各自落单，豆粒总数随之虚高。
        narrow = self.run_pair(fronts, rears, 40)
        self.assertEqual(narrow["paired_count"], 0)
        self.assertEqual(narrow["unpaired_count"], 2)
        self.assertEqual(narrow["bean_count_total"], 2)
        self.assertEqual(narrow["pairing_rate"], 0.0)
        self.assertTrue(narrow["alert"]["triggered"])

    def test_difference_exactly_delta_t_is_paired(self):
        for t_front, t_rear in ((100, 150), (150, 100)):
            result = self.run_pair([T("f1", t_front)], [T("r1", t_rear)], 50)
            self.assertEqual(result["paired_count"], 1)
            self.assertEqual(result["pairs"][0]["dt_ms"], 50)

    def test_difference_just_over_delta_t_is_not_paired(self):
        for t_front, t_rear in ((100, 151), (151, 100)):
            result = self.run_pair([T("f1", t_front)], [T("r1", t_rear)], 50)
            self.assertEqual(result["paired_count"], 0)
            self.assertEqual(result["unpaired_count"], 2)

    def test_zero_tolerance_only_pairs_identical_timestamps(self):
        self.assertEqual(self.run_pair([T("f", 100)], [T("r", 100)], 0)["paired_count"], 1)
        self.assertEqual(self.run_pair([T("f", 100)], [T("r", 101)], 0)["paired_count"], 0)

    def test_fractional_tolerance_from_frame_rate_works(self):
        tolerance = 2000.0 / 30  # 66.67ms
        self.assertEqual(self.run_pair([T("f", 0)], [T("r", 66)], tolerance)["paired_count"], 1)
        self.assertEqual(self.run_pair([T("f", 0)], [T("r", 67)], tolerance)["paired_count"], 0)


class RejectedTest(unittest.TestCase):
    def test_rejected_pair_is_counted_apart_from_unpaired(self):
        fronts = [T("f1", 100, bad=True), T("f2", 500)]
        rears = [T("r1", 105)]
        result = pairing.pair_tracks(fronts, rears, 30)
        self.assertEqual(result["rejected_count"], 1)
        self.assertEqual(result["unpaired_count"], 1)
        self.assertEqual(result["unpaired_front_ids"], ["f2"])
        # 拒判的豆双侧都看到了，仍是一颗独立豆粒；它不进配对不明。
        self.assertEqual(result["paired_count"], 1)
        self.assertEqual(result["bean_count_total"], 2)
        self.assertEqual(result["classifiable_count"], 0)
        self.assertTrue(result["pairs"][0]["rejected"])

    def test_bad_flag_on_either_side_rejects_the_pair(self):
        by_front = pairing.pair_tracks([T("f", 100, bad=True)], [T("r", 100)], 10)
        by_rear = pairing.pair_tracks([T("f", 100)], [T("r", 100, bad=True)], 10)
        both = pairing.pair_tracks([T("f", 100, bad=True)], [T("r", 100, bad=True)], 10)
        for result in (by_front, by_rear, both):
            self.assertEqual(result["rejected_count"], 1)
            self.assertEqual(result["unpaired_count"], 0)

    def test_bad_single_sided_track_is_unpaired_not_rejected(self):
        result = pairing.pair_tracks([T("f1", 100, bad=True)], [], 30)
        self.assertEqual(result["rejected_count"], 0)
        self.assertEqual(result["unpaired_count"], 1)
        self.assertEqual(result["bean_count_total"], 1)

    def test_rejected_does_not_count_against_pairing_rate(self):
        fronts = [T("f%d" % i, i * 1000, bad=True) for i in range(10)]
        rears = [T("r%d" % i, i * 1000) for i in range(10)]
        result = pairing.pair_tracks(fronts, rears, 30)
        self.assertEqual(result["rejected_count"], 10)
        self.assertEqual(result["pairing_rate"], 1.0)
        self.assertFalse(result["alert"]["triggered"])

    def test_track_without_flag_defaults_to_usable(self):
        fronts = [{"track_id": "f1", "t_ms": 100}]
        rears = [{"track_id": "r1", "t_ms": 100}]
        result = pairing.pair_tracks(fronts, rears, 10)
        self.assertEqual(result["rejected_count"], 0)
        self.assertEqual(result["classifiable_count"], 1)


class AlertThresholdTest(unittest.TestCase):
    def synth(self, n_paired, n_unpaired):
        fronts = []
        rears = []
        for i in range(n_paired):
            fronts.append(T("fp%d" % i, i * 1000))
            rears.append(T("rp%d" % i, i * 1000 + 5))
        for i in range(n_unpaired):
            fronts.append(T("fu%d" % i, 1000000 + i * 1000))
        return pairing.pair_tracks(fronts, rears, 30)

    def test_exactly_80_percent_is_not_an_alert(self):
        result = self.synth(80, 20)
        self.assertEqual(result["bean_count_total"], 100)
        self.assertEqual(result["pairing_rate"], 0.8)
        self.assertFalse(result["alert"]["low_pairing_rate"])
        self.assertFalse(result["alert"]["high_unpaired_ratio"])
        self.assertFalse(result["alert"]["triggered"])
        self.assertIsNone(result["alert"]["message"])

    def test_just_below_80_percent_is_an_alert(self):
        result = self.synth(79, 21)
        self.assertTrue(result["alert"]["low_pairing_rate"])
        self.assertTrue(result["alert"]["high_unpaired_ratio"])
        self.assertTrue(result["alert"]["triggered"])
        self.assertIn("豆路对准或光照异常", result["alert"]["message"])

    def test_summarize_counts_boundaries(self):
        ok = pairing.summarize_counts(4, 1)  # 80% / 20%
        self.assertFalse(ok["alert"]["triggered"])
        bad = pairing.summarize_counts(3, 1)  # 75% / 25%
        self.assertTrue(bad["alert"]["triggered"])
        self.assertEqual(bad["bean_count_total"], 4)
        tight = pairing.summarize_counts(799, 201)  # 79.9% / 20.1%
        self.assertTrue(tight["alert"]["triggered"])
        loose = pairing.summarize_counts(801, 199)  # 80.1% / 19.9%
        self.assertFalse(loose["alert"]["triggered"])

    def test_unpaired_ratio_is_reported(self):
        result = pairing.summarize_counts(3, 1)
        self.assertEqual(result["unpaired_ratio"], 0.25)
        self.assertEqual(result["pairing_rate"], 0.75)

    def test_summarize_counts_keeps_rejected_inside_paired(self):
        result = pairing.summarize_counts(8, 2, rejected_count=3)
        self.assertEqual(result["bean_count_total"], 10)
        self.assertEqual(result["rejected_count"], 3)
        self.assertEqual(result["classifiable_count"], 5)
        self.assertEqual(result["pairing_rate"], 0.8)

    def test_summarize_counts_rejects_nonsense(self):
        for args in ((-1, 0), (0, -1), (1, 0, 2), (1.5, 0), (True, 0)):
            with self.assertRaises(ValueError):
                pairing.summarize_counts(*args)


class EmptyInputTest(unittest.TestCase):
    def test_both_sides_empty(self):
        result = pairing.pair_tracks([], [], 66)
        self.assertEqual(result["pairs"], [])
        self.assertEqual(result["paired_count"], 0)
        self.assertEqual(result["unpaired_count"], 0)
        self.assertEqual(result["rejected_count"], 0)
        self.assertEqual(result["bean_count_total"], 0)
        # 没有豆就没有配对率，也不该拿它告警。
        self.assertIsNone(result["pairing_rate"])
        self.assertIsNone(result["unpaired_ratio"])
        self.assertFalse(result["alert"]["triggered"])

    def test_only_one_side_has_tracks(self):
        result = pairing.pair_tracks([T("f1", 100), T("f2", 200)], [], 66)
        self.assertEqual(result["paired_count"], 0)
        self.assertEqual(result["unpaired_count"], 2)
        self.assertEqual(result["bean_count_total"], 2)
        self.assertEqual(result["pairing_rate"], 0.0)
        self.assertTrue(result["alert"]["triggered"])

    def test_empty_summary(self):
        result = pairing.summarize_counts(0, 0)
        self.assertEqual(result["bean_count_total"], 0)
        self.assertIsNone(result["pairing_rate"])
        self.assertFalse(result["alert"]["triggered"])


if __name__ == "__main__":
    unittest.main()
