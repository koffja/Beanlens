"""票 09 主机测试存根：用 ui.fake_data 之外的假候选 + session_helpers 走一遍
开始 -> 采集 -> 配对 -> 推理 -> 计数 -> 停止 -> 保存。全部是假数据，
不验证配对精度、帧率、推理准确率（这些必须上板实测）。"""
import os
import unittest

from app.capture import detection, scan_runner, stream_pairing
from app.core.config_manager import ConfigManager
from app.core.session_store import SessionStore
from app.ui.controller import UIController
from tests.session_helpers import Env

K230D_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RUNNER_PATH = os.path.join(K230D_DIR, "app", "capture", "scan_runner.py")
TOLERANCE_MS = 66


def cand(track_id, side, t_ms, sharpness=100.0):
    return {"track_id": track_id, "side": side, "t_ms": t_ms,
            "roi": (0, 0, 4, 4), "crop": [[0] * 4 for _ in range(4)], "sharpness": sharpness}


class FakeManager:
    """每次 poll_once 取脚本里的下一步 (front 候选列表, rear 候选列表)，drain 时交出。"""

    def __init__(self, steps):
        self.steps = list(steps)
        self._front = []
        self._rear = []

    def poll_once(self):
        if self.steps:
            front, rear = self.steps.pop(0)
            self._front.extend(front)
            self._rear.extend(rear)

    def drain(self, side):
        if side == "front":
            out, self._front = self._front, []
        else:
            out, self._rear = self._rear, []
        return out


class Clock:
    def __init__(self):
        self.now = 1000

    def __call__(self):
        return self.now

    def advance(self, ms):
        self.now += ms


def make_ui(env):
    store = SessionStore(base_dir=env.dir, clock=env.clock)
    return UIController(env.queue, store, ConfigManager(env.dir), env.new_session)


def det(label, score=0.9):
    return detection.make_detection(label, score, (0, 0, 4, 4))


class RunnerFlowTest(unittest.TestCase):
    def setUp(self):
        self.env = Env(self)
        self.ui = make_ui(self.env)
        self.clock = Clock()

    def build(self, steps, script=None, min_sharpness=None):
        manager = FakeManager(steps)
        detector = detection.FakeDetector(script)

        def build_runner(session, refresh):
            return scan_runner.ScanRunner(session, manager, detector, TOLERANCE_MS, self.clock,
                                          ui_refresh=refresh, min_sharpness=min_sharpness)
        return build_runner, detector

    def run_cycle(self, build_runner, steps):
        count = [0]

        def should_stop(runner):
            count[0] += 1
            self.clock.advance(100)
            return count[0] > steps
        return scan_runner.run_scan_cycle(self.ui, build_runner, should_stop)

    def test_full_flow_start_to_queue(self):
        # 第 1 步：一颗配对豆（前后摄各 1）；第 2 步：只前摄有（配对不明）；第 3 步：又一颗配对豆。
        steps = [
            ([cand(1, "front", 1000)], [cand(1, "rear", 1010)]),
            ([cand(2, "front", 1100)], []),
            ([cand(3, "front", 1200)], [cand(2, "rear", 1205)]),
        ]
        # 推理按「前裁图、后裁图」顺序消费：第一颗全黑豆，第二颗无瑕疵。
        script = [[det("full_black")], [], [], []]
        build_runner, detector = self.build(steps, script)
        result = self.run_cycle(build_runner, 4)

        self.assertTrue(result["started"])
        self.assertTrue(result["stopped"])
        self.assertFalse(result["incomplete"])
        stats = result["stats"]
        self.assertEqual(stats["paired_count"], 2)
        self.assertEqual(stats["unpaired_count"], 1)
        self.assertEqual(stats["bean_count_total"], 3)
        self.assertEqual(self.ui.page_name, "result")
        session = self.ui.session
        self.assertEqual(session.bean_count_total, 3)
        self.assertEqual(session.unpaired_count, 1)
        self.assertEqual(session.defect_counts["full_black"], 1)

        saved = self.ui.save_local()
        self.assertTrue(saved["saved"])
        record = self.env.queue.next_pending()["record"]
        self.assertEqual(record["bean_count_total"], 3)
        self.assertEqual(record["unpaired_count"], 1)

    def test_unpaired_bean_never_counts_as_defect_or_normal(self):
        build_runner, _ = self.build([([cand(1, "front", 1000)], [])])
        result = self.run_cycle(build_runner, 3)
        self.assertEqual(result["stats"]["unpaired_count"], 1)
        self.assertEqual(sum(self.ui.session.defect_counts.values()), 0)

    def test_insufficient_sharpness_is_rejected_not_inferred(self):
        steps = [([cand(1, "front", 1000, sharpness=1.0)], [cand(1, "rear", 1005)])]
        build_runner, detector = self.build(steps, min_sharpness=10.0)
        result = self.run_cycle(build_runner, 3)
        self.assertEqual(result["stats"]["rejected_count"], 1)
        self.assertEqual(result["stats"]["paired_count"], 1)
        self.assertEqual(detector.batch_sizes, [])
        self.assertEqual(self.ui.session.bean_count_total, 1)
        self.assertEqual(sum(self.ui.session.defect_counts.values()), 0)

    def test_fade_is_counted_separately_not_as_sca_defect(self):
        steps = [([cand(1, "front", 1000)], [cand(1, "rear", 1005)])]
        build_runner, _ = self.build(steps, script=[[det("fade")], []])
        result = self.run_cycle(build_runner, 3)
        self.assertEqual(result["stats"]["fade_count"], 1)
        self.assertEqual(self.ui.session.bean_count_total, 1)
        self.assertEqual(sum(self.ui.session.defect_counts.values()), 0)

    def test_inference_error_makes_session_incomplete_and_never_queues(self):
        class Boom(detection.BaseDetector):
            def infer(self, crops):
                raise RuntimeError("kpu timeout")

        manager = FakeManager([([cand(1, "front", 1000)], [cand(1, "rear", 1005)])])

        def build_runner(session, refresh):
            return scan_runner.ScanRunner(session, manager, Boom(), TOLERANCE_MS, self.clock,
                                          ui_refresh=refresh)
        result = self.run_cycle(build_runner, 5)
        self.assertTrue(result["incomplete"])
        self.assertFalse(result["stopped"])
        self.assertIn("kpu timeout", result["message"])
        self.assertEqual(self.ui.session.state, "incomplete")
        self.assertEqual(len(self.ui.store.list_incomplete()), 1)
        self.assertIsNone(self.env.queue.next_pending())

    def test_queue_full_blocks_start(self):
        for i in range(100):
            session = self.env.session_in_state("result_ready")
            session.operation_id = "K230D:DEV0000:scan:%08x" % i
            session.save_to_queue(self.env.queue)
        build_runner, _ = self.build([])
        result = scan_runner.run_scan_cycle(self.ui, build_runner, lambda r: True)
        self.assertFalse(result["started"])
        self.assertEqual(self.ui.page_name, "home")

    def test_ui_refresh_is_called_each_step(self):
        calls = [0]
        manager = FakeManager([])
        session = self.env.session_in_state("scanning")
        runner = scan_runner.ScanRunner(session, manager, detection.FakeDetector(), TOLERANCE_MS,
                                        self.clock, ui_refresh=lambda: calls.__setitem__(0, calls[0] + 1))
        runner.step()
        runner.step()
        self.assertEqual(calls[0], 2)

    def test_runner_does_not_import_ui_or_board_modules(self):
        with open(RUNNER_PATH, encoding="utf-8") as f:
            lines = [l for l in f.read().splitlines() if not l.strip().startswith("#")]
        text = "\n".join(lines)
        for banned in ("app.ui", "import lvgl", "import sensor", "from media", "import nncase"):
            self.assertNotIn(banned, text)


class StreamPairerTest(unittest.TestCase):
    def test_pairs_within_tolerance_and_consumes_once(self):
        pairer = stream_pairing.StreamPairer(TOLERANCE_MS)
        out = pairer.step([cand(1, "front", 1000)], [cand(1, "rear", 1030)], 1040)
        self.assertEqual(len(out["paired"]), 1)
        again = pairer.step([], [], 1500)
        self.assertEqual(again["paired"], [])
        self.assertEqual(pairer.paired_count, 1)

    def test_waits_for_late_partner_then_settles_unpaired(self):
        pairer = stream_pairing.StreamPairer(TOLERANCE_MS)
        first = pairer.step([cand(1, "front", 1000)], [], 1010)
        self.assertEqual(first["unpaired"], [])
        self.assertEqual(pairer.buffered("front"), 1)
        late = pairer.step([], [], 1000 + TOLERANCE_MS + 1)
        self.assertEqual(len(late["unpaired"]), 1)
        self.assertEqual(pairer.unpaired_count, 1)

    def test_late_partner_still_pairs(self):
        pairer = stream_pairing.StreamPairer(TOLERANCE_MS)
        pairer.step([cand(1, "front", 1000)], [], 1010)
        out = pairer.step([], [cand(1, "rear", 1040)], 1050)
        self.assertEqual(len(out["paired"]), 1)

    def test_flush_settles_everything_as_unpaired(self):
        pairer = stream_pairing.StreamPairer(TOLERANCE_MS)
        pairer.step([cand(1, "front", 1000)], [cand(7, "rear", 5000)], 1001)
        out = pairer.flush()
        self.assertEqual(len(out["unpaired"]), 2)
        self.assertEqual(pairer.summary()["bean_count_total"], 2)

    def test_buffer_overflow_counts_oldest_as_unpaired(self):
        pairer = stream_pairing.StreamPairer(10 ** 9, buffer_max=2)
        fronts = [cand(i, "front", 1000 + i) for i in range(1, 5)]
        out = pairer.step(fronts, [], 1010)
        self.assertEqual(len(out["unpaired"]), 2)
        self.assertEqual(pairer.overflow_count, 2)
        self.assertEqual(pairer.buffered("front"), 2)

    def test_rejects_bad_arguments(self):
        with self.assertRaises(ValueError):
            stream_pairing.StreamPairer(-1)
        with self.assertRaises(ValueError):
            stream_pairing.StreamPairer(10, buffer_max=0)


if __name__ == "__main__":
    unittest.main()
