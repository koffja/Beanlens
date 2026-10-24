import json
import os
import shutil
import tempfile
import unittest
from unittest import mock

from app.core import storage


class AtomicWriteTest(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.mkdtemp(prefix="beanlens-test-")
        self.addCleanup(shutil.rmtree, self.dir, True)
        self.path = os.path.join(self.dir, "sub", "data.json")

    def test_roundtrip_creates_parent_dirs(self):
        storage.atomic_write_json(self.path, {"a": 1, "b": [1, 2]})
        self.assertEqual(storage.read_json(self.path), {"a": 1, "b": [1, 2]})

    def test_missing_file_returns_default(self):
        self.assertIsNone(storage.read_json(self.path))
        self.assertEqual(storage.read_json(self.path, default={"x": 0}), {"x": 0})

    def test_overwrite_keeps_previous_content_in_prev(self):
        storage.atomic_write_json(self.path, {"v": 1})
        storage.atomic_write_json(self.path, {"v": 2})
        self.assertEqual(storage.read_json(self.path), {"v": 2})
        with open(self.path + ".prev") as f:
            self.assertEqual(json.load(f), {"v": 1})

    def test_interrupted_before_any_rename_reads_old(self):
        storage.atomic_write_json(self.path, {"v": 1})
        with mock.patch.object(storage.os, "rename", side_effect=OSError("power cut")):
            with self.assertRaises(OSError):
                storage.atomic_write_json(self.path, {"v": 2})
        self.assertEqual(storage.read_json(self.path), {"v": 1})

    def test_interrupted_between_the_two_renames_reads_old(self):
        storage.atomic_write_json(self.path, {"v": 1})
        real_rename = os.rename
        calls = []

        def rename_then_die(src, dst):
            calls.append(src)
            if len(calls) == 1:
                real_rename(src, dst)
            else:
                raise OSError("power cut")

        with mock.patch.object(storage.os, "rename", side_effect=rename_then_die):
            with self.assertRaises(OSError):
                storage.atomic_write_json(self.path, {"v": 2})
        # 主文件此刻不存在，读回必须是完整的旧内容。
        self.assertEqual(storage.read_json(self.path), {"v": 1})

    def test_half_written_temp_file_is_never_read(self):
        storage.atomic_write_json(self.path, {"v": 1})
        with open(self.path + ".tmp", "w") as f:
            f.write('{"v": 2, "trunc')
        self.assertEqual(storage.read_json(self.path), {"v": 1})
        # 残留的坏临时文件不妨碍下一次写入。
        storage.atomic_write_json(self.path, {"v": 3})
        self.assertEqual(storage.read_json(self.path), {"v": 3})

    def test_corrupt_main_falls_back_to_prev(self):
        storage.atomic_write_json(self.path, {"v": 1})
        storage.atomic_write_json(self.path, {"v": 2})
        with open(self.path, "w") as f:
            f.write('{"v": 2, "trunc')
        self.assertEqual(storage.read_json(self.path), {"v": 1})

    def test_first_write_interrupted_leaves_nothing_readable(self):
        with mock.patch.object(storage.os, "rename", side_effect=OSError("power cut")):
            with self.assertRaises(OSError):
                storage.atomic_write_json(self.path, {"v": 1})
        self.assertIsNone(storage.read_json(self.path))

    def test_unserializable_object_does_not_touch_existing_files(self):
        storage.atomic_write_json(self.path, {"v": 1})
        with self.assertRaises(TypeError):
            storage.atomic_write_json(self.path, {"v": object()})
        self.assertEqual(storage.read_json(self.path), {"v": 1})


if __name__ == "__main__":
    unittest.main()
