# 双摄采集管理（票 06 草稿）：两路低分辨率监视 -> 前景触发 -> 3 帧连拍 -> 选最清晰 -> 裁 ROI -> 候选队列。
# - 候选带时间戳，经 tracks() 变成 pairing.make_track 的形状，交给 pairing.pair_tracks 配对（票 04）。
# - 每路候选队列有上限（roi_queue_max，初值 3），满了丢最旧的并计数，不无限增长。
# - 裁图是复制；连拍帧在选完后立即丢引用，不保存全部原始帧（AGENTS.md）。
# - 所有阈值来自 capture_config.json，不硬编码。ΔT 不在这里算，见 pairing.load_tolerance_ms。
# 板侧部分（真实相机、短曝光）只在 camera.CanmvCamera 里写注释，本模块不碰任何板级 API。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。
from app.capture import camera
from app.capture import imaging
from app.capture import pairing
from app.core import storage

DEFAULT_ROI_QUEUE_MAX = 3


def _is_number(value):
    return not isinstance(value, bool) and isinstance(value, (int, float))


def load_capture_config(path=None):
    """读 capture_config.json 并做最小校验，返回字典。缺失或不合法抛 ValueError。"""
    if path is None:
        path = pairing.DEFAULT_CONFIG_PATH
    config = storage.read_json(path)
    if not isinstance(config, dict):
        raise ValueError("capture_config 缺失或不是合法 JSON 对象: %s" % path)
    check_config(config)
    return config


def check_config(config):
    if not isinstance(config, dict):
        raise ValueError("capture_config 必须是 JSON 对象")
    if not _is_number(config.get("motion_threshold")) or config["motion_threshold"] < 0:
        raise ValueError("motion_threshold 必须是 >= 0 的数字")
    if not _is_number(config.get("trigger_cooldown_ms")) or config["trigger_cooldown_ms"] < 0:
        raise ValueError("trigger_cooldown_ms 必须是 >= 0 的数字")
    queue_max = config.get("roi_queue_max")
    if isinstance(queue_max, bool) or not isinstance(queue_max, int) or queue_max < 1:
        raise ValueError("roi_queue_max 必须是 >= 1 的整数")
    size = config.get("roi_size_max")
    if not isinstance(size, (list, tuple)) or len(size) != 2:
        raise ValueError("roi_size_max 必须是 [宽, 高]")
    for v in size:
        if isinstance(v, bool) or not isinstance(v, int) or v < 1:
            raise ValueError("roi_size_max 必须是正整数")


class SideState:
    """一路相机的运行状态：上一帧、冷却时间、候选队列、统计。"""

    def __init__(self, cam):
        self.cam = cam
        self.prev_image = None
        self.last_trigger_ms = None
        self.next_track_id = 1
        self.candidates = []
        self.triggers = 0
        self.dropped = 0


class CaptureManager:
    def __init__(self, front_cam, rear_cam, config):
        """front_cam / rear_cam: camera.BaseCamera 子类（主机用 FakeCamera）；config: capture_config 字典。"""
        check_config(config)
        if front_cam.side != camera.SIDE_FRONT or rear_cam.side != camera.SIDE_REAR:
            raise ValueError("front_cam 必须是前摄，rear_cam 必须是后摄")
        self.config = config
        self._sides = {
            camera.SIDE_FRONT: SideState(front_cam),
            camera.SIDE_REAR: SideState(rear_cam),
        }

    def open(self):
        for side in camera.SIDES:
            self._sides[side].cam.open()

    def close(self):
        for side in camera.SIDES:
            self._sides[side].cam.close()

    # ---- 单路轮询 ----

    def _poll_side(self, side):
        state = self._sides[side]
        frame = state.cam.grab_low_res()
        image = frame["image"]
        t_ms = frame["t_ms"]
        prev = state.prev_image
        state.prev_image = image  # 只留上一帧低分辨率图，供下次差分
        if prev is None:
            return None
        roi = imaging.foreground_roi(prev, image, self.config["motion_threshold"])
        if roi is None:
            return None
        cooldown = self.config["trigger_cooldown_ms"]
        if state.last_trigger_ms is not None and t_ms - state.last_trigger_ms < cooldown:
            return None
        state.last_trigger_ms = t_ms
        state.triggers += 1
        return self._burst_and_crop(side, roi)

    def _burst_and_crop(self, side, roi):
        state = self._sides[side]
        frames = state.cam.burst(camera.BURST_COUNT)
        if len(frames) == 0:
            return None
        images = []
        for f in frames:
            images.append(f["image"])
        best = imaging.sharpest_index(images)
        max_w, max_h = self.config["roi_size_max"]
        crop_box = imaging.clamp_roi(roi, max_w, max_h)
        crop = imaging.crop_roi(frames[best]["image"], crop_box)
        sharpness = imaging.laplacian_variance(crop)
        t_ms = frames[best]["t_ms"]
        # 板侧占位：裁图复制完成后立即释放采集缓冲，frames / images 在本函数返回时不再被引用。
        del frames
        del images
        candidate = {
            "track_id": state.next_track_id,
            "side": side,
            "t_ms": t_ms,
            "roi": crop_box,
            "crop": crop,
            "sharpness": sharpness,
        }
        state.next_track_id += 1
        self._push(state, candidate)
        return candidate

    def _push(self, state, candidate):
        state.candidates.append(candidate)
        limit = self.config.get("roi_queue_max", DEFAULT_ROI_QUEUE_MAX)
        while len(state.candidates) > limit:
            state.candidates.pop(0)
            state.dropped += 1

    # ---- 对外接口 ----

    def poll_once(self):
        """两路各轮询一次，返回 {"front": 新候选或 None, "rear": 新候选或 None}。"""
        result = {}
        for side in camera.SIDES:
            result[side] = self._poll_side(side)
        return result

    def pending(self, side):
        """某一路当前排队的候选（从旧到新），返回副本列表。"""
        return list(self._sides[side].candidates)

    def drain(self, side):
        """取走某一路全部候选并清空队列。"""
        state = self._sides[side]
        items = state.candidates
        state.candidates = []
        return items

    def tracks(self, side):
        """把某一路排队的候选转成 pairing.make_track 的形状（不清空队列）。"""
        out = []
        for c in self._sides[side].candidates:
            out.append(pairing.make_track(c["track_id"], c["t_ms"]))
        return out

    def stats(self):
        """每路触发次数、丢弃次数、队列长度，供诊断与性能监控读取。"""
        out = {}
        for side in camera.SIDES:
            state = self._sides[side]
            out[side] = {
                "triggers": state.triggers,
                "dropped": state.dropped,
                "queued": len(state.candidates),
            }
        return out
