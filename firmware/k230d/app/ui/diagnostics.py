# 诊断页（票 08 接口桩 + 票 10 预览骨架）。
# - 不传相机时（UIController 现有用法）保持票 08 的桩行为：不碰相机，open() 返回占位提示。
# - 传入 front_cam / rear_cam 后进入预览骨架：open() 才打开相机，tick() 按 2fps 限速抓双摄
#   静态帧并（可选）过检测器得到检测框，close() 立即关相机，离开后不占采集资源（ADR 0005）。
# - 扫描中不能进入：is_scanning 回调返回 True 时 open() 拒绝（UIController 也只允许从设置页进入）。
# - 本模块不 import app.capture：相机与检测器都是鸭子类型（camera.BaseCamera / detection.BaseDetector），
#   由上层注入，避免 UI 层依赖采集层。
# - 板侧占位（未在 CanMV 板上验证，下列均不真实调用）：
#     # 把 frames["front"]["image"] / frames["rear"]["image"] 左右分屏绘制到 LVGL 画布
#     # 在对应画布上按 boxes 画矩形并标注 "标签 置信度"
#     # 页面隐藏/销毁事件里调用 close()
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。

PAGE_ID = "diagnostics"
PREVIEW_FPS = 2
PREVIEW_INTERVAL_MS = 1000 // PREVIEW_FPS
NOTICE = "诊断预览尚未实现，上板票补全"
BLOCKED_SCANNING_MESSAGE = "扫描中不能进入诊断页"
CAMERA_UNAVAILABLE_MESSAGE = "相机不可用，诊断预览无法启动"

SIDE_FRONT = "front"
SIDE_REAR = "rear"


class DiagnosticsPage:
    def __init__(self, front_cam=None, rear_cam=None, detector=None, is_scanning=None):
        """front_cam / rear_cam: camera.BaseCamera 形状；detector: BaseDetector 形状（可选，用于检测框）；
        is_scanning: 无参函数，返回当前是否在扫描（可选）。两个相机都不传就是票 08 的桩。"""
        if (front_cam is None) != (rear_cam is None):
            raise ValueError("front_cam 与 rear_cam 必须同时提供或同时省略")
        self._cams = None
        if front_cam is not None:
            self._cams = {SIDE_FRONT: front_cam, SIDE_REAR: rear_cam}
        self._detector = detector
        self._is_scanning = is_scanning
        self._running = False
        self._last_tick_ms = None
        self._frames = {SIDE_FRONT: None, SIDE_REAR: None}
        self._boxes = {SIDE_FRONT: [], SIDE_REAR: []}
        self.frames_shown = 0

    def state(self):
        implemented = self._cams is not None
        return {
            "page": PAGE_ID,
            "implemented": implemented,
            "preview_running": self._running,
            "preview_fps": PREVIEW_FPS,
            "notice": "" if implemented else NOTICE,
            "frames_shown": self.frames_shown,
            "boxes": {SIDE_FRONT: list(self._boxes[SIDE_FRONT]), SIDE_REAR: list(self._boxes[SIDE_REAR])},
        }

    def open(self):
        """进入诊断页。桩模式返回 {"started": False, "message": 占位提示}；
        预览模式下打开两路相机，扫描中或相机失败时返回 started=False 并给出原因，不留半开的相机。"""
        if self._cams is None:
            return {"started": False, "message": NOTICE}
        if self._is_scanning is not None and self._is_scanning():
            return {"started": False, "message": BLOCKED_SCANNING_MESSAGE}
        if self._running:
            return {"started": True, "message": ""}
        opened = []
        try:
            for side in (SIDE_FRONT, SIDE_REAR):
                self._cams[side].open()
                opened.append(side)
        except NotImplementedError:
            for side in opened:
                self._cams[side].close()
            return {"started": False, "message": CAMERA_UNAVAILABLE_MESSAGE}
        self._running = True
        self._last_tick_ms = None
        return {"started": True, "message": ""}

    def tick(self, now_ms):
        """主循环里调用：距上次抓帧不足 500ms 返回 None；否则抓双摄各一帧并返回
        {"front": 帧, "rear": 帧, "boxes": {"front": [...], "rear": [...]}}。
        没打开预览时返回 None。"""
        if not self._running:
            return None
        if self._last_tick_ms is not None and now_ms - self._last_tick_ms < PREVIEW_INTERVAL_MS:
            return None
        self._last_tick_ms = now_ms
        for side in (SIDE_FRONT, SIDE_REAR):
            frame = self._cams[side].grab_low_res()
            self._frames[side] = frame
            self._boxes[side] = self._detect(frame["image"])
        self.frames_shown += 1
        return {
            SIDE_FRONT: self._frames[SIDE_FRONT],
            SIDE_REAR: self._frames[SIDE_REAR],
            "boxes": {SIDE_FRONT: list(self._boxes[SIDE_FRONT]), SIDE_REAR: list(self._boxes[SIDE_REAR])},
        }

    def _detect(self, image):
        if self._detector is None:
            return []
        out = self._detector.infer([image])
        if len(out) != 1:
            raise ValueError("检测器返回 %d 项，应为 1 项" % len(out))
        return list(out[0])

    def close(self):
        """离开诊断页，回到设置页。预览模式下立即关闭两路相机，释放采集资源。"""
        if self._running:
            self._running = False
            for side in (SIDE_FRONT, SIDE_REAR):
                self._cams[side].close()
            self._frames = {SIDE_FRONT: None, SIDE_REAR: None}
            self._boxes = {SIDE_FRONT: [], SIDE_REAR: []}
        return "settings"
