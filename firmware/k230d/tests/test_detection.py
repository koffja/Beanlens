"""票 07 主机测试存根：只验证检测数据形状、NMS 逻辑、标签映射与分批接口。
不验证检测准确率、延迟、内存（这些必须上板用已标注样本实测）。"""
import unittest

from app.capture import detection
from app.core import counting
from app.core.defect_classes import DEFECT_CLASSES


def det(label, score, bbox=(0, 0, 10, 10)):
    return detection.make_detection(label, score, bbox)


class LabelTest(unittest.TestCase):
    def test_sixteen_unique_labels(self):
        self.assertEqual(len(detection.MODEL_LABELS), 16)
        self.assertEqual(len(set(detection.MODEL_LABELS)), 16)

    def test_every_label_maps_to_sca_or_is_fade(self):
        for label in detection.MODEL_LABELS:
            if label == counting.FADE_LABEL:
                continue
            self.assertIn(counting.MODEL_TO_SCA[label], DEFECT_CLASSES)

    def test_preprocess_and_record_templates_start_unverified(self):
        for key in detection.PREPROCESS_SPEC:
            self.assertIsNone(detection.PREPROCESS_SPEC[key])
        for key in detection.MODEL_RECORD_TEMPLATE:
            self.assertIsNone(detection.MODEL_RECORD_TEMPLATE[key])


class MakeDetectionTest(unittest.TestCase):
    def test_rejects_unknown_label(self):
        with self.assertRaises(ValueError):
            detection.make_detection("normal", 0.9, (0, 0, 5, 5))

    def test_rejects_bad_score_and_bbox(self):
        with self.assertRaises(ValueError):
            detection.make_detection("shell", 1.5, (0, 0, 5, 5))
        with self.assertRaises(ValueError):
            detection.make_detection("shell", 0.5, (0, 0, 0, 5))
        with self.assertRaises(ValueError):
            detection.make_detection("shell", 0.5, (0, 0, 5))


class NmsTest(unittest.TestCase):
    def test_iou_identical_and_disjoint(self):
        self.assertEqual(detection.iou((0, 0, 10, 10), (0, 0, 10, 10)), 1.0)
        self.assertEqual(detection.iou((0, 0, 10, 10), (20, 20, 5, 5)), 0.0)

    def test_overlapping_same_class_keeps_higher_score(self):
        a = det("shell", 0.9, (0, 0, 10, 10))
        b = det("shell", 0.6, (1, 1, 10, 10))
        kept = detection.nms([b, a], 0.5)
        self.assertEqual(len(kept), 1)
        self.assertEqual(kept[0]["score"], 0.9)

    def test_overlapping_different_class_both_kept(self):
        a = det("shell", 0.9, (0, 0, 10, 10))
        b = det("fungus", 0.8, (0, 0, 10, 10))
        self.assertEqual(len(detection.nms([a, b], 0.5)), 2)

    def test_score_threshold_drops_low_scores_and_input_untouched(self):
        items = [det("shell", 0.2), det("fungus", 0.8, (50, 50, 5, 5))]
        kept = detection.nms(items, 0.5, score_threshold=0.5)
        self.assertEqual(len(kept), 1)
        self.assertEqual(len(items), 2)


class ClassifyBeanTest(unittest.TestCase):
    def test_highest_score_across_both_sides_wins(self):
        result = detection.classify_bean([det("full_black", 0.9)], [det("shell", 0.6)], 0.3)
        self.assertEqual(result["verdict"], "defect")
        self.assertEqual(result["defect"], "full_black")

    def test_cut_and_broken_merge_to_broken_chipped(self):
        self.assertEqual(detection.classify_bean([det("cut", 0.8)], [], 0.3)["defect"], "broken_chipped")
        self.assertEqual(detection.classify_bean([], [det("broken", 0.8)], 0.3)["defect"], "broken_chipped")

    def test_fade_has_no_sca_row(self):
        result = detection.classify_bean([det("fade", 0.9)], [], 0.3)
        self.assertIsNone(result["defect"])
        self.assertTrue(result["fade"])
        self.assertEqual(result["verdict"], "fade")

    def test_nothing_detected_is_not_normal(self):
        result = detection.classify_bean([], [det("shell", 0.1)], 0.3)
        self.assertEqual(result["verdict"], "no_defect_detected")
        self.assertIsNone(result["defect"])
        self.assertNotEqual(result["verdict"], "normal")

    def test_unknown_label_in_raw_dict_rejected(self):
        with self.assertRaises(ValueError):
            detection.classify_bean([{"label": "x", "score": 0.9, "bbox": (0, 0, 1, 1)}], [], 0.3)


class AnnotateTest(unittest.TestCase):
    def test_track_id_carried_over(self):
        cands = [{"track_id": 7, "side": "front", "t_ms": 100}]
        out = detection.annotate_candidates(cands, [[det("shell", 0.9)]])
        self.assertEqual(out[0]["track_id"], 7)
        self.assertEqual(len(out[0]["detections"]), 1)

    def test_length_mismatch_rejected(self):
        with self.assertRaises(ValueError):
            detection.annotate_candidates([{"track_id": 1, "side": "front", "t_ms": 1}], [])


class BatchTest(unittest.TestCase):
    def test_split_batches_never_exceeds_limit(self):
        batches = detection.split_batches(list(range(19)))
        self.assertEqual([len(b) for b in batches], [8, 8, 3])

    def test_batch_max_above_limit_rejected(self):
        with self.assertRaises(ValueError):
            detection.split_batches([1, 2], 9)
        with self.assertRaises(ValueError):
            detection.split_batches([1, 2], 0)

    def test_infer_batches_returns_one_result_per_crop(self):
        fake = detection.FakeDetector([[det("shell", 0.9)]])
        out = detection.infer_batches(fake, ["c"] * 10, 4)
        self.assertEqual(len(out), 10)
        self.assertEqual(fake.batch_sizes, [4, 4, 2])
        self.assertEqual(len(out[0]), 1)
        self.assertEqual(out[1], [])

    def test_wrong_detector_output_length_rejected(self):
        class Broken(detection.BaseDetector):
            def infer(self, crops):
                return []
        with self.assertRaises(ValueError):
            detection.infer_batches(Broken(), ["c"])


class KpuPlaceholderTest(unittest.TestCase):
    def test_kpu_detector_is_placeholder(self):
        kpu = detection.KpuDetector()
        with self.assertRaises(NotImplementedError):
            kpu.load()
        with self.assertRaises(NotImplementedError):
            kpu.infer([])


if __name__ == "__main__":
    unittest.main()
