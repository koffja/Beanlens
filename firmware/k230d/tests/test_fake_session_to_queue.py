import json
import os
import re
import shutil
import tempfile
import unittest

from app.core import defect_classes, storage
from app.core.queue import SubmissionQueue
from app.core.scan_session import ScanSession

OPERATION_ID_RE = re.compile(r"^K230D:[^:/\s]+:scan:[0-9a-f]{8}$")


class DefectClassesTest(unittest.TestCase):
    def test_sixteen_unique_classes_six_plus_ten(self):
        self.assertEqual(len(defect_classes.CATEGORY_1), 6)
        self.assertEqual(len(defect_classes.CATEGORY_2), 10)
        self.assertEqual(defect_classes.DEFECT_CLASSES,
                         defect_classes.CATEGORY_1 + defect_classes.CATEGORY_2)
        self.assertEqual(len(set(defect_classes.DEFECT_CLASSES)), 16)

    def test_fungus_is_category_one_and_fade_is_not_reported(self):
        self.assertIn("fungus", defect_classes.CATEGORY_1)
        self.assertNotIn("fade", defect_classes.DEFECT_CLASSES)
        self.assertNotIn("elephant_ear", defect_classes.DEFECT_CLASSES)

    def test_empty_counts_has_every_key_at_zero(self):
        counts = defect_classes.empty_defect_counts()
        self.assertEqual(list(counts.keys()), defect_classes.DEFECT_CLASSES)
        self.assertEqual(set(counts.values()), {0})


class FakeSessionToQueueTest(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.mkdtemp(prefix="beanlens-test-")
        self.addCleanup(shutil.rmtree, self.dir, True)
        self.queue_dir = os.path.join(self.dir, "queue")

    def _enqueue_fake(self, **kwargs):
        session = ScanSession.fake(base_dir=self.dir, clock=lambda: 1_800_000_000, **kwargs)
        queue = SubmissionQueue(base_dir=self.dir)
        path = queue.enqueue(session)
        return session, queue, path

    def test_enqueue_writes_file_named_by_idempotency_key(self):
        session, _queue, path = self._enqueue_fake()
        self.assertTrue(os.path.isfile(path))
        self.assertEqual(os.listdir(self.queue_dir), [session.operation_id + ".json"])

    def test_queue_file_is_valid_json_with_all_sixteen_zero_counts(self):
        _session, _queue, path = self._enqueue_fake()
        with open(path) as f:
            entry = json.loads(f.read())
        record = entry["record"]
        self.assertEqual(list(record["defects"].keys()), defect_classes.DEFECT_CLASSES)
        self.assertEqual(set(record["defects"].values()), {0})

    def test_record_fields_and_v1_omissions(self):
        _session, _queue, path = self._enqueue_fake()
        with open(path) as f:
            record = json.load(f)["record"]
        for key in ("operation_id", "session_id", "captured_at", "duration_s",
                    "bean_count_total", "unpaired_count", "defects",
                    "sample_weight_g", "metadata"):
            self.assertIn(key, record)
        self.assertEqual(record["sample_weight_g"], 350)
        self.assertEqual(record["bean_count_total"], 0)
        self.assertEqual(record["unpaired_count"], 0)
        self.assertNotIn("lot_id", record["metadata"])
        self.assertNotIn("evidence_images", record["metadata"])
        sample_ids = record["metadata"]["form_config"]["sample_ids"]
        self.assertEqual(len(sample_ids), 1)
        self.assertRegex(sample_ids[0], r"^BL-LOCAL-\d{4}$")
        text = json.dumps(record).lower()
        for banned in ("wifi", "ssid", "password", "token", "pairing"):
            self.assertNotIn(banned, text)

    def test_idempotency_key_format_and_stable_after_readback(self):
        session, queue, path = self._enqueue_fake(device_id="TM0007")
        self.assertRegex(session.operation_id, OPERATION_ID_RE)
        self.assertTrue(session.operation_id.startswith("K230D:TM0007:scan:"))

        first = session.operation_id
        self.assertEqual(session.operation_id, first)  # 读属性不会重算
        session.to_record_json()
        self.assertEqual(session.operation_id, first)  # 导出记录不会重算

        pending = queue.next_pending()
        self.assertEqual(pending["operation_id"], first)
        self.assertEqual(pending["record"]["operation_id"], first)
        # 重新开一个队列对象从磁盘读回，仍是同一个键。
        reopened = SubmissionQueue(base_dir=self.dir).next_pending()
        self.assertEqual(reopened["operation_id"], first)
        # 会话创建时持久化的文件里也是同一个键。
        saved = storage.read_json(session.checkpoint_file)
        self.assertEqual(saved["operation_id"], first)
        self.assertEqual(saved["session_id"], session.session_id)

    def test_default_device_id_still_gives_valid_key(self):
        session, _queue, _path = self._enqueue_fake()
        self.assertRegex(session.operation_id, OPERATION_ID_RE)

    def test_two_sessions_get_different_keys(self):
        a = ScanSession.fake(base_dir=self.dir)
        b = ScanSession.fake(base_dir=self.dir)
        self.assertNotEqual(a.operation_id, b.operation_id)
        self.assertNotEqual(a.session_id, b.session_id)

    def test_invalid_device_id_rejected(self):
        for bad in ("", "a:b", "a/b", "a b", None):
            with self.assertRaises(ValueError):
                ScanSession.fake(base_dir=self.dir, device_id=bad)

    def test_session_uses_configured_sample_weight(self):
        from app.core.config_manager import ConfigManager
        ConfigManager(self.dir).set_sample_weight_g(380)
        session = ScanSession.fake(base_dir=self.dir)
        self.assertEqual(session.to_record_json()["sample_weight_g"], 380)

    def test_next_pending_returns_earliest_and_none_when_empty(self):
        queue = SubmissionQueue(base_dir=self.dir, clock=iter([100, 200]).__next__)
        self.assertIsNone(queue.next_pending())
        first = ScanSession.fake(base_dir=self.dir)
        second = ScanSession.fake(base_dir=self.dir)
        queue.enqueue(first)
        queue.enqueue(second)
        self.assertEqual(queue.next_pending()["operation_id"], first.operation_id)

    def test_queue_dir_follows_config_queue_path(self):
        from app.core.config_manager import ConfigManager
        custom = os.path.join(self.dir, "elsewhere")
        ConfigManager(self.dir).save({"sample_weight_g": 350, "queue_path": custom})
        session = ScanSession.fake(base_dir=self.dir)
        SubmissionQueue(base_dir=self.dir).enqueue(session)
        self.assertEqual(os.listdir(custom), [session.operation_id + ".json"])
        self.assertFalse(os.path.exists(self.queue_dir))

    def test_enqueue_interrupted_midway_leaves_no_half_json(self):
        from unittest import mock
        session = ScanSession.fake(base_dir=self.dir)
        queue = SubmissionQueue(base_dir=self.dir)
        with mock.patch.object(storage.os, "rename", side_effect=OSError("power cut")):
            with self.assertRaises(OSError):
                queue.enqueue(session)
        self.assertIsNone(queue.next_pending())


if __name__ == "__main__":
    unittest.main()
