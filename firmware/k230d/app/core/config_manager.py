# 用户配置读写（<base_dir>/config.json + capture_config.json + device_info.json）。
# 板侧实际运行时 base_dir 对应 CanMV 内置文件系统或外挂 SD 卡根目录。
import time

from app.capture import capture_manager
from app.core import storage

DEFAULT_SAMPLE_WEIGHT_G = 350
MIN_SAMPLE_WEIGHT_G = 300
MAX_SAMPLE_WEIGHT_G = 400
CONFIG_FILENAME = "config.json"
QUEUE_DIRNAME = "queue"
CAPTURE_CONFIG_FILENAME = "capture_config.json"
DEVICE_INFO_FILENAME = "device_info.json"


def _valid_weight(value):
    if isinstance(value, bool):
        return False
    if not isinstance(value, (int, float)):
        return False
    return MIN_SAMPLE_WEIGHT_G <= value <= MAX_SAMPLE_WEIGHT_G


def _valid_path(value):
    return isinstance(value, str) and value != ""


def _valid_serial(value):
    return isinstance(value, str) and value != ""


class ConfigManager:
    def __init__(self, base_dir=None):
        if base_dir is None:
            base_dir = storage.default_base_dir()
        self.base_dir = base_dir
        self.config_path = storage.join_path(base_dir, CONFIG_FILENAME)
        self.capture_config_path = storage.join_path(base_dir, CAPTURE_CONFIG_FILENAME)
        self.device_info_path = storage.join_path(base_dir, DEVICE_INFO_FILENAME)
        self._counter = 0

    def defaults(self):
        return {
            "sample_weight_g": DEFAULT_SAMPLE_WEIGHT_G,
            "queue_path": storage.join_path(self.base_dir, QUEUE_DIRNAME),
        }

    def load(self):
        """返回完整配置；文件缺失、损坏或某字段不合法时该字段用默认值。不写盘。"""
        config = self.defaults()
        stored = storage.read_json(self.config_path)
        if isinstance(stored, dict):
            if _valid_weight(stored.get("sample_weight_g")):
                config["sample_weight_g"] = stored["sample_weight_g"]
            if _valid_path(stored.get("queue_path")):
                config["queue_path"] = stored["queue_path"]
        return config

    def save(self, config):
        """校验后原子写入。只保存已知字段,其余字段丢弃。非法值抛 ValueError。"""
        defaults = self.defaults()
        weight = config.get("sample_weight_g", defaults["sample_weight_g"])
        queue_path = config.get("queue_path", defaults["queue_path"])
        if not _valid_weight(weight):
            raise ValueError(
                "sample_weight_g 必须在 %d-%d 之间" % (MIN_SAMPLE_WEIGHT_G, MAX_SAMPLE_WEIGHT_G)
            )
        if not _valid_path(queue_path):
            raise ValueError("queue_path 必须是非空字符串")
        clean = {"sample_weight_g": weight, "queue_path": queue_path}
        storage.atomic_write_json(self.config_path, clean)
        return clean

    def set_sample_weight_g(self, weight):
        config = self.load()
        config["sample_weight_g"] = weight
        return self.save(config)

    # ---- 采集配置（票 11）----

    def get_capture_config(self):
        """返回 capture_config.json；校验失败时抛 ValueError（启动时由 UI 捕获并展示）。"""
        config = storage.read_json(self.capture_config_path)
        if not isinstance(config, dict):
            raise ValueError("capture_config.json 缺失或不是合法 JSON 对象")
        capture_manager.check_config(config)
        return config

    def update_capture_config(self, changes):
        """部分更新：只改 changes 里出现的键,其他保留。写入前校验,不合法抛 ValueError。"""
        config = self.get_capture_config()
        config.update(changes)
        capture_manager.check_config(config)
        storage.atomic_write_json(self.capture_config_path, config)
        return config

    # ---- 设备元数据（票 12）----

    def get_device_info(self):
        """返回 device_info.json；校验失败时抛 ValueError。"""
        info = storage.read_json(self.device_info_path)
        if not isinstance(info, dict):
            raise ValueError("device_info.json 缺失或不是合法 JSON 对象")
        if not _valid_serial(info.get("serial_number")):
            raise ValueError("serial_number 不能为空")
        return info

    def update_device_info(self, changes):
        """部分更新：只改 changes 里出现的键,其他保留。serial_number 不能为空,否则抛 ValueError。"""
        info = self.get_device_info()
        info.update(changes)
        if not _valid_serial(info.get("serial_number")):
            raise ValueError("serial_number 不能为空")
        storage.atomic_write_json(self.device_info_path, info)
        return info

    def create_operation_id(self):
        """生成新 operation_id（格式 K230D:{serial}:scan:{8位十六进制}）。

        用 time.time() 做种子,同一秒内重复调用保证唯一(内部计数器累加)。
        """
        info = self.get_device_info()
        serial = info["serial_number"]
        seed = int(time.time()) * 1000 + self._counter
        self._counter = (self._counter + 1) % 1000
        return "K230D:%s:scan:%08x" % (serial, seed & 0xFFFFFFFF)
