import os
import shutil
import tempfile
import unittest
from unittest import mock

from app.core import storage


class PowerCut(Exception):
    pass


class RemoveJsonTest(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.mkdtemp(prefix="beanlens-test-")
        self.addCleanup(shutil.rmtree, self.dir, True)
        self.path = os.path.join(self.dir, "data.json")

    def _write_two_versions(self):
        storage.atomic_write_json(self.path, {"v": 1})
        storage.atomic_write_json(self.path, {"v": 2})  # 此时存在 data.json 与 data.json.prev

    def test_removes_main_prev_and_tmp(self):
        self._write_two_versions()
        with open(self.path + ".tmp", "w") as f:
            f.write("{")
        storage.remove_json(self.path)
        self.assertEqual(os.listdir(self.dir), [])
        self.assertIsNone(storage.read_json(self.path))

    def test_missing_file_is_not_an_error(self):
        storage.remove_json(self.path)
        self.assertEqual(os.listdir(self.dir), [])

    def test_power_cut_during_remove_never_resurrects_the_older_version(self):
        # 无论在第几次 os.remove 处断电，读回的要么是当前版本 v2，要么什么都没有，
        # 绝不能读到更旧的 v1（否则已入队的会话会“复活”成旧的扫描中状态）。
        real_remove = os.remove
        for cut_at in (1, 2, 3):
            with self.subTest(cut_at=cut_at):
                shutil.rmtree(self.dir)
                os.mkdir(self.dir)
                self._write_two_versions()
                with open(self.path + ".tmp", "w") as f:
                    f.write("{")
                calls = []

                def flaky_remove(p):
                    calls.append(p)
                    if len(calls) >= cut_at:
                        raise PowerCut()
                    real_remove(p)

                with mock.patch.object(storage.os, "remove", side_effect=flaky_remove):
                    with self.assertRaises(PowerCut):
                        storage.remove_json(self.path)
                self.assertIn(storage.read_json(self.path), ({"v": 2}, None))


if __name__ == "__main__":
    unittest.main()
