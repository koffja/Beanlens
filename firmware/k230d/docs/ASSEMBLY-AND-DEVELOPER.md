# 装调与开发者文档（草稿）

状态：装调步骤里凡需要实测数值的都留空。只写已在主机验证的结论，其余标「未验证」。

## 一、装调

### 1. 上板前核对（未验证，必须先做）
记录 CanMV 固件、nncase、两路 CSI、短曝光支持，填入 `VERIFICATION-LOG.md` 第 0 节。
不要把资料盘版本当作实机版本，不要照通用 K230 API 假定。

### 2. 豆路对准与光照
具体机械位置和光照参数：未验证，上板后补。判断依据是诊断页里两路画面中豆是否完整落在画面内、无明显过曝或欠曝。

### 3. 用诊断页看双摄
设置 → 诊断 → 手动开启预览。约 2fps。检测框来自检测器，模型未上板前不会有真实框。

### 4. 配对率低时的排查
触发条件：配对不明超过豆粒总数的 20%（配对率低于 80%）。排查顺序：
1. 诊断页确认两路都能看到同一颗豆。
2. 检查光照是否使一侧过曝或欠曝。
3. 调整触发阈值 `motion_threshold` 或配对容差 `time_pair_tolerance_ms`，每次改动后重新测 50 颗。
4. 最终值写回 `capture_config.json`，并记入 `VERIFICATION-LOG.md`。

## 二、开发者

### 目录（均在 `firmware/k230d/`）
| 路径 | 职责 |
| --- | --- |
| `app/core/` | 业务核心：会话状态机、会话存储、队列、配置、计数规则、报告。不依赖 UI。 |
| `app/capture/` | 采集与推理：相机接口、连拍与候选队列、配对、检测调度、扫描主循环。 |
| `app/ui/` | 页面逻辑（纯 Python，不依赖 LVGL）与控制器。 |
| `app/main.py` | 启动入口：恢复队列与会话，创建控制器。LVGL 主循环仍是占位。 |
| `bringup/` | 上板调试脚本，不属于应用。 |
| `tests/` | 主机侧测试。 |

### 配置项
- `config.json`：`sample_weight_g`（默认 350，范围 300–400）、`queue_path`。
- `capture_config.json`：`csi1` / `csi2`（宽、高、帧率）、`roi_queue_max`（每路候选上限）、`roi_size_max`（[宽, 高]）、`time_pair_tolerance_ms`、`motion_threshold`、`trigger_cooldown_ms`。当前数值多为占位，待票 06 / 12 标定。
- `device_info.json`：设备元数据。

### 在主机上跑测试
```bash
cd firmware/k230d
python3 -m unittest discover -s tests -p "test_*.py"     # 全量，441 项，约 3.5 至 7 分钟
python3 -m unittest discover -s tests -p "test_main.py"  # 单个模块
```
不要用 `python3 -m unittest tests.test_xxx` 跑单个模块：部分旧测试用裸导入，会误报导入失败。

### 板侧待补
- `CanmvCamera`、`KpuDetector` 目前只有注释骨架，调用会抛 `NotImplementedError`。
- `main_loop` 是占位，需接 LVGL。
- `startup()` 的 `diagnostics_factory` 需要板侧传入带真实相机的 `DiagnosticsPage`。
