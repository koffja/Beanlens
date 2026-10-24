"""票 06 主机测试存根：只用假图像数组验证接口、队列上限和数据形状。
不验证配对精度、帧率、曝光等板上指标（这些必须上板实测）。"""
import unittest

from app.capture import camera, capture_manager, imaging, pairing

CONFIG = {
    "csi1": {"width": 20, "height": 20, "fps": 30},
    "csi2": {"width": 20, "height": 20, "fps": 30},
    "roi_queue_max": 3,
    "roi_size_max": [8, 8],
    "time_pair_tolerance_ms": None,
    "motion_threshold": 25,
    "trigger_cooldown_ms": 50,
}


class MsClock:
    def __init__(self):
        self.now = 1000

    def __call__(self):
        return self.now

    def advance(self, ms):
        self.now += ms


def blank():
    return imaging.new_image(20, 20, 0)


def with_block(value=200, x=5, y=5, size=4):
    image = blank()
    for yy in range(y, y + size):
        for xx in range(x, x + size):
            image[yy][xx] = value
    return image


def make_manager(clock, front_low=None, rear_low=None, front_burst=None, rear_burst=None, config=None):
    front = camera.FakeCamera(camera.SIDE_FRONT, clock, blank(), front_low, front_burst)
    rear = camera.FakeCamera(camera.SIDE_REAR, clock, blank(), rear_low, rear_burst)
    manager = capture_manager.CaptureManager(front, rear, config or dict(CONFIG))
    manager.open()
    return manager, front, rear


class ImagingTest(unittest.TestCase):
    def test_crop_returns_a_copy(self):
        image = with_block()
        crop = imaging.crop_roi(image, (5, 5, 4, 4))
        crop[0][0] = 7
        self.assertEqual(image[5][5], 200)
        self.assertEqual(imaging.image_size(crop), (4, 4))

    def test_crop_without_overlap_raises(self):
        with self.assertRaises(ValueError):
            imaging.crop_roi(blank(), (50, 50, 4, 4))

    def test_clamp_roi_keeps_center(self):
        self.assertEqual(imaging.clamp_roi((0, 0, 20, 10), 8, 8), (6, 1, 8, 8))

    def test_foreground_roi_none_when_identical(self):
        self.assertIsNone(imaging.foreground_roi(blank(), blank(), 25))

    def test_foreground_roi_bounding_box(self):
        self.assertEqual(imaging.foreground_roi(blank(), with_block(), 25), (5, 5, 4, 4))

    def test_sharpest_index_prefers_sharp_edges(self):
        flat = blank()
        self.assertEqual(imaging.sharpest_index([flat, with_block(), flat]), 1)


class CameraTest(unittest.TestCase):
    def test_canmv_camera_is_placeholder(self):
        cam = camera.CanmvCamera(camera.SIDE_FRONT)
        with self.assertRaises(NotImplementedError):
            cam.open()
        with self.assertRaises(NotImplementedError):
            cam.grab_low_res()

    def test_rejects_unknown_side(self):
        with self.assertRaises(ValueError):
            camera.FakeCamera("left", MsClock(), blank())

    def test_fake_burst_frames_have_increasing_timestamps(self):
        clock = MsClock()
        cam = camera.FakeCamera(camera.SIDE_REAR, clock, blank())
        frames = cam.burst(camera.BURST_COUNT)
        self.assertEqual(len(frames), 3)
        stamps = [f["t_ms"] for f in frames]
        self.assertEqual(stamps, sorted(stamps))


class ConfigTest(unittest.TestCase):
    def test_shipped_config_loads(self):
        config = capture_manager.load_capture_config()
        self.assertEqual(config["roi_queue_max"], 3)

    def test_bad_config_rejected(self):
        bad = dict(CONFIG)
        bad["roi_queue_max"] = 0
        with self.assertRaises(ValueError):
            capture_manager.check_config(bad)


class CaptureManagerTest(unittest.TestCase):
    def test_no_motion_means_no_candidates(self):
        manager, _, _ = make_manager(MsClock())
        manager.poll_once()
        result = manager.poll_once()
        self.assertIsNone(result["front"])
        self.assertIsNone(result["rear"])

    def test_motion_triggers_burst_and_produces_candidate(self):
        clock = MsClock()
        manager, front, _ = make_manager(
            clock, front_low=[blank(), with_block()],
            front_burst=[blank(), with_block(), blank()])
        manager.poll_once()
        clock.advance(33)
        result = manager.poll_once()
        cand = result["front"]
        self.assertIsNotNone(cand)
        self.assertEqual(front.burst_calls, 1)
        self.assertEqual(cand["side"], "front")
        self.assertEqual(cand["roi"], (5, 5, 4, 4))
        self.assertEqual(imaging.image_size(cand["crop"]), (4, 4))
        self.assertIsInstance(cand["t_ms"], int)

    def test_cooldown_blocks_second_trigger(self):
        clock = MsClock()
        manager, front, _ = make_manager(
            clock, front_low=[blank(), with_block(), blank(), with_block()])
        manager.poll_once()
        manager.poll_once()
        clock.advance(10)
        manager.poll_once()
        clock.advance(10)
        manager.poll_once()
        self.assertEqual(front.burst_calls, 1)

    def test_queue_is_bounded_and_counts_drops(self):
        clock = MsClock()
        script = [blank()]
        for _ in range(6):
            script.append(with_block())
            script.append(blank())
        manager, _, _ = make_manager(clock, front_low=script)
        for _ in range(len(script)):
            clock.advance(100)
            manager.poll_once()
        self.assertLessEqual(len(manager.pending("front")), 3)
        self.assertGreater(manager.stats()["front"]["dropped"], 0)

    def test_tracks_feed_pairing_without_error(self):
        clock = MsClock()
        manager, _, _ = make_manager(
            clock, front_low=[blank(), with_block()], rear_low=[blank(), with_block()])
        manager.poll_once()
        clock.advance(33)
        manager.poll_once()
        front_tracks = manager.tracks("front")
        rear_tracks = manager.tracks("rear")
        result = pairing.pair_tracks(front_tracks, rear_tracks, 66)
        self.assertIn("bean_count_total", result)
        self.assertEqual(result["paired_count"] + result["unpaired_count"], result["bean_count_total"])

    def test_drain_empties_queue(self):
        clock = MsClock()
        manager, _, _ = make_manager(clock, front_low=[blank(), with_block()])
        manager.poll_once()
        clock.advance(33)
        manager.poll_once()
        self.assertEqual(len(manager.drain("front")), 1)
        self.assertEqual(manager.pending("front"), [])

    def test_swapped_cameras_rejected(self):
        clock = MsClock()
        front = camera.FakeCamera(camera.SIDE_FRONT, clock, blank())
        rear = camera.FakeCamera(camera.SIDE_REAR, clock, blank())
        with self.assertRaises(ValueError):
            capture_manager.CaptureManager(rear, front, dict(CONFIG))


if __name__ == "__main__":
    unittest.main()
