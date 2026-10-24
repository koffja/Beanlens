# 双摄驱动接口（票 06 草稿）。
# - BaseCamera：接口约定（open / grab_low_res / burst / close）。
# - CanmvCamera：板侧实现占位，只有注释骨架，调用即抛 NotImplementedError，不碰任何板级 API。
# - FakeCamera：主机侧 mock，按脚本吐假图像，用于验证 CaptureManager 的逻辑。
# 帧的统一形状：{"image": 灰度二维列表, "t_ms": 整数毫秒时间戳}。
#
# 上板前必须先做的核对（票 06 第一项，结论写入验证记录，不假定通用 K230 API）：
#   1. 已装 CanMV 固件版本、nncase 版本。
#   2. 是否支持两路 CSI 同时出图（CSI1 前摄 / CSI2 后摄）以及实际同时帧率。
#   3. 是否支持短曝光 / 手动曝光；是否有硬同步（预期没有，ADR 0002）。
#   4. 两路各自的 sensor / 采集缓冲 API 名称，以用户已有的匹配 CanMV 官方例程为准。
# 只用标准库子集，按 MicroPython 可用的写法编写（未在 CanMV 板上验证）。

SIDE_FRONT = "front"
SIDE_REAR = "rear"
SIDES = (SIDE_FRONT, SIDE_REAR)

# 一次触发的连拍帧数（ADR 0002：3 帧短曝光连拍）。
BURST_COUNT = 3


class BaseCamera:
    def __init__(self, side):
        if side not in SIDES:
            raise ValueError("side 只能是 front 或 rear，实际 %r" % (side,))
        self.side = side

    def open(self):
        raise NotImplementedError("子类实现")

    def grab_low_res(self):
        """抓一帧低分辨率监视帧，返回 {"image", "t_ms"}。"""
        raise NotImplementedError("子类实现")

    def burst(self, count):
        """短曝光连拍 count 帧，返回 [{"image", "t_ms"}, ...]。"""
        raise NotImplementedError("子类实现")

    def close(self):
        raise NotImplementedError("子类实现")


class CanmvCamera(BaseCamera):
    """K230D BOX 真机相机。以下全是占位注释，未在板上验证，不真实调用任何 SDK。"""

    def open(self):
        # 板侧占位：
        #   - 按 side 选 CSI1 / CSI2 对应的 sensor 设备号
        #   - 配置低分辨率监视流（分辨率/帧率来自 capture_config.json 的 csi1 / csi2）
        #   - 预分配有上限的采集缓冲（128MB 内存，不累计整批全帧）
        raise NotImplementedError("板侧占位：待上板核对 CanMV 双 CSI API 后实现")

    def grab_low_res(self):
        # 板侧占位：取一帧，用单调毫秒时钟（如 ticks_ms）打时间戳；转灰度或直接在板上做差分
        raise NotImplementedError("板侧占位")

    def burst(self, count):
        # 板侧占位：切到短曝光，连拍 count 帧，每帧各打时间戳，拍完恢复监视配置
        raise NotImplementedError("板侧占位")

    def close(self):
        # 板侧占位：释放采集缓冲和 sensor
        raise NotImplementedError("板侧占位")


class FakeCamera(BaseCamera):
    """主机 mock：low_res_script 与 burst_script 各是图像列表，按顺序取，取完后返回 idle_image。

    clock 是返回毫秒数的无参函数；连拍时每帧在 clock() 基础上加 frame_interval_ms。
    """

    def __init__(self, side, clock, idle_image, low_res_script=None, burst_script=None,
                 frame_interval_ms=33):
        BaseCamera.__init__(self, side)
        self.clock = clock
        self.idle_image = idle_image
        self.low_res_script = list(low_res_script) if low_res_script else []
        self.burst_script = list(burst_script) if burst_script else []
        self.frame_interval_ms = frame_interval_ms
        self.opened = False
        self.burst_calls = 0

    def open(self):
        self.opened = True

    def grab_low_res(self):
        if self.low_res_script:
            image = self.low_res_script.pop(0)
        else:
            image = self.idle_image
        return {"image": image, "t_ms": self.clock()}

    def burst(self, count):
        self.burst_calls += 1
        base = self.clock()
        frames = []
        for i in range(count):
            if self.burst_script:
                image = self.burst_script.pop(0)
            else:
                image = self.idle_image
            frames.append({"image": image, "t_ms": base + i * self.frame_interval_ms})
        return frames

    def close(self):
        self.opened = False
