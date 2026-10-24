"""票 11/12 主机测试存根：只验证默认值与读写接口，不验证 UI 编辑流程（P2 现场演示时核对）。"""
import os
import unittest

from app.core.config_manager import ConfigManager
from tests.session_helpers import Env

K230D_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_CAPTURE = os.path.join(K230D_DIR, "capture_config.json")
DEFAULT_DEVICE = os.path.join(K230D_DIR, "device_info.json")


class ConfigManagerTest(unittest.TestCase):
    def test_load_shipped_defaults(self):
        mgr = ConfigManager(K230D_DIR)
        capture = mgr.get_capture_config()
        self.assertEqual(capture["roi_queue_max"], 3)
        self.assertEqual(capture["time_pair_tolerance_ms"], 66)
        device = mgr.get_device_info()
        self.assertEqual(device["serial_number"], "DEV0000")

    def test_update_and_reload_capture_config(self):
        env = Env(self)
        mgr = ConfigManager(env.dir)
        mgr.update_capture_config({"roi_queue_max": 5, "motion_threshold": 30})
        reloaded = ConfigManager(env.dir).get_capture_config()
        self.assertEqual(reloaded["roi_queue_max"], 5)
        self.assertEqual(reloaded["motion_threshold"], 30)

    def test_update_and_reload_device_info(self):
        env = Env(self)
        mgr = ConfigManager(env.dir)
        mgr.update_device_info({"operator": "张三", "serial_number": "DEV1234"})
        reloaded = ConfigManager(env.dir).get_device_info()
        self.assertEqual(reloaded["operator"], "张三")
        self.assertEqual(reloaded["serial_number"], "DEV1234")

    def test_partial_update_preserves_other_keys(self):
        env = Env(self)
        mgr = ConfigManager(env.dir)
        old_tol = mgr.get_capture_config()["time_pair_tolerance_ms"]
        mgr.update_capture_config({"roi_queue_max": 7})
        self.assertEqual(mgr.get_capture_config()["time_pair_tolerance_ms"], old_tol)

    def test_bad_update_rejected(self):
        mgr = ConfigManager(K230D_DIR)
        with self.assertRaises(ValueError):
            mgr.update_capture_config({"roi_queue_max": 0})
        with self.assertRaises(ValueError):
            mgr.update_device_info({"serial_number": ""})

    def test_create_id_contains_serial_and_scan(self):
        mgr = ConfigManager(K230D_DIR)
        op_id = mgr.create_operation_id()
        self.assertIn("DEV0000", op_id)
        self.assertIn("scan", op_id)
        self.assertRegex(op_id, r"^K230D:DEV\d+:scan:[0-9a-f]{8}$")

    def test_operation_id_is_unique_across_calls(self):
        env = Env(self)
        mgr = ConfigManager(env.dir)
        ids = [mgr.create_operation_id() for _ in range(100)]
        self.assertEqual(len(set(ids)), 100)


if __name__ == "__main__":
    unittest.main()
