"""主机契约测试：从 bring-up 脚本提取函数，不导入硬件模块或启动相机。"""
import ast
import pathlib
import tempfile
import types
import unittest


SOURCE = pathlib.Path(__file__).parents[1] / "bringup" / "drop_capture.py"


class ExposureTests(unittest.TestCase):
    def setUp(self):
        self.calls = []
        calls = self.calls

        class Sensor:
            RGB565 = 1

            def __init__(self, id, **kwargs):
                self.id = id
                self.ae = True
                self.started = False
                self.value = 1000
                self.readback = None
                self.limits = (33000, 30)
                self.snapshots = 0
                self.stopped = False

            def reset(self):
                calls.append((self.id, "reset"))

            def set_framesize(self, **kwargs):
                pass

            def set_pixformat(self, *args, **kwargs):
                pass

            def auto_exposure(self, enable=None):
                if enable is not None:
                    assert not self.started, "AE must be configured before run"
                    self.ae = enable
                    calls.append((self.id, "ae_off"))
                return self.ae

            def run(self):
                calls.append((self.id, "run"))
                for sensor in self.group:
                    assert sensor.ae is False
                    sensor.started = True

            def get_exposure_time_range(self):
                assert self.started, "range queried before run"
                return self.limits

            def exposure(self, value=None):
                assert self.started, "exposure accessed before run"
                if value is not None:
                    self.value = value
                    calls.append((self.id, "set"))
                    return 0  # 不将底层 setter 状态码误当成曝光时间
                return self.readback() if self.readback else self.value

            def snapshot(self, **kwargs):
                assert self.started
                self.snapshots += 1

            def stop(self):
                self.stopped = True

        self.ns = dict(Sensor=Sensor, CAM_IDS=(1, 2), SENSOR_W=1920, SENSOR_H=1080,
                       FPS=30, CAP_W=960, CAP_H=540, CAM_CHN_ID_0=0,
                       EXPOSURE_US={1: 1000, 2: 2000}, EXPOSURE_SETTLE_FRAMES=3)
        names = {"step", "open_sensor", "positive_number", "start_sensors", "make_run_dir"}
        tree = ast.parse(SOURCE.read_text())
        tree.body = [node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name in names]
        exec(compile(tree, str(SOURCE), "exec"), self.ns)
        self.sensors = [self.ns["open_sensor"](i) for i in (1, 2)]
        for sensor in self.sensors:
            sensor.group = self.sensors

    def start(self):
        return self.ns["start_sensors"](self.sensors)

    def test_two_cameras_order_and_distinct_targets(self):
        records = self.start()
        self.assertEqual(self.calls, [(1, "reset"), (1, "ae_off"), (2, "reset"),
                                     (2, "ae_off"), (1, "run"), (1, "set"), (2, "set")])
        self.assertEqual(records, [(1, 1000, 1000, 30, 33000), (2, 2000, 2000, 30, 33000)])
        self.assertEqual([s.snapshots for s in self.sensors], [3, 3])

    def test_sensor_line_rounding_is_allowed(self):
        self.sensors[0].readback = lambda: 990
        self.assertEqual(self.start()[0][2], 990)

    def test_invalid_targets_abort(self):
        for bad in (None, True, 0, -1, float("nan"), float("inf"), "1000"):
            with self.subTest(value=bad):
                self.ns["EXPOSURE_US"][1] = bad
                with self.assertRaises(ValueError):
                    self.start()

    def test_unavailable_or_malformed_range_aborts(self):
        for bad in (None, (), (1,), (30, 33000), (33000, 0), (float("nan"), 30)):
            with self.subTest(value=bad):
                self.sensors[0].limits = bad
                with self.assertRaises(RuntimeError):
                    self.start()

    def test_outside_range_aborts_before_setter(self):
        self.sensors[0].limits = (900, 30)
        with self.assertRaises(ValueError):
            self.start()
        self.assertNotIn((1, "set"), self.calls)

    def test_failed_readback_aborts_for_either_camera(self):
        for sensor in self.sensors:
            for bad in (None, False, float("nan"), float("inf"), 0, 9000):
                with self.subTest(cam=sensor.id, value=bad):
                    sensor.readback = lambda: bad
                    with self.assertRaises(RuntimeError):
                        self.start()
            sensor.readback = None

    def test_old_firmware_missing_api_stops_sensor(self):
        self.ns["Sensor"].exposure = None
        with self.assertRaisesRegex(RuntimeError, "missing exposure"):
            self.ns["open_sensor"](1)

    def test_auto_exposure_cannot_silently_remain_on(self):
        self.ns["Sensor"].auto_exposure = lambda self, enable=None: True
        with self.assertRaisesRegex(RuntimeError, "disable auto exposure"):
            self.ns["open_sensor"](1)

    def test_setter_exception_propagates(self):
        def fail(value=None):
            raise OSError("sensor I/O failure")
        self.sensors[1].exposure = fail
        with self.assertRaisesRegex(OSError, "sensor I/O failure"):
            self.start()

    def test_metadata_preserves_reader_contract_and_actual_values(self):
        records = self.start()
        with tempfile.TemporaryDirectory() as tmp:
            root = pathlib.Path(tmp)
            self.ns.update(OUT_ROOT=tmp, exists=lambda p: pathlib.Path(p).exists(),
                           os=types.SimpleNamespace(mkdir=lambda p: pathlib.Path(p).mkdir(),
                                                    uname=lambda: "test ATK v1.6"),
                           SCRIPT_VERSION=6, ROI_W=330, ROI_H=360, CELL=30, PATCH=16,
                           DIFF_L=10, MIN_CELLS=2, BURST=3, TARGET_FIRMWARE="ATK v1.6",
                           roi=lambda cam: (0, 0, 330, 360), sync_fs=lambda: None)
            # 使用现有主机复核工具的解析器，确保追加元数据不破坏原格式。
            review_path = SOURCE.parents[1] / "tools" / "drop_review.py"
            review_tree = ast.parse(review_path.read_text())
            review_tree.body = [n for n in review_tree.body if isinstance(n, ast.FunctionDef) and n.name == "read_meta"]
            reader = {}
            exec(compile(review_tree, str(review_path), "exec"), reader)
            first = pathlib.Path(self.ns["make_run_dir"](records))
            meta = reader["read_meta"](first)
            self.assertEqual(meta["save_mode"], "raw")
            self.assertEqual((meta["width"], meta["height"]), ("330", "360"))
            self.assertEqual(meta["cam2_exposure_actual_us"], "2000")
            self.assertEqual(meta["auto_exposure"], "False")
            self.assertEqual(meta["uname"], "test ATK v1.6")
            self.assertEqual(pathlib.Path(self.ns["make_run_dir"](records)).name, "drop001")
            self.assertTrue((root / "drop000" / "meta.txt").exists())


if __name__ == "__main__":
    unittest.main()
