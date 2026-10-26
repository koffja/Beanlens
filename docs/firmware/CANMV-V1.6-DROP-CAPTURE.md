# DNK230D v1.6 落豆 pipeline 适配

2026-10-25。用户选择 v1.6；本改动基于尚未合入 main 的 PR #3
（`feat/k230d-drop-capture`）。这是无执行器的 bring-up 流程，不是已完成的产品计数器。
另一个 `feat/k230d-firmware-v1-host` 分支没有 open PR，其 `CanmvCamera` 仍为占位，
本次没有将主机 mock 图像处理误接到真实传感器。

## 版本与源码依据

- [v1.6 release](https://github.com/kendryte/canmv_k230/releases/tag/v1.6)
  提供 `CanMV_K230D_ATK_DNK230D_micropython_v1.6-0-ge4441cc_nncase_v2.9.0.img.gz`
  和同名 `.md5`。只使用 ATK_DNK230D 板型；本次未下载或核对镜像校验值，未烧录。
- [固定 v1.6 的 sensor.py](https://github.com/kendryte/canmv_k230/blob/v1.6/port/builtin_py/media/sensor.py)：
  `reset()` 后、`run()` 前关闭每路 AE；`run()` 为各路创建 fd 后才查询范围和读写曝光；
  返回范围的顺序是 `(最大微秒, 最小微秒)`。多摄模式首路 `run()` 启动所有已配置设备。
- [同版本手动曝光例程](https://github.com/kendryte/canmv_k230/blob/v1.6/resources/examples/17-Sensor/camera_manual_exposure_lcd.py)。
  SDK 注释中有启动前设置曝光的片段，以实际实现和完整例程的调用顺序为准。

## 脚本行为

`firmware/k230d/bringup/drop_capture.py` script_version=6：

1. 两路 reset、配置 chn0 RGB565、检查曝光 API，然后各自 `auto_exposure(False)`。
2. Display/MediaManager 初始化后仅首路 `run()`；逐路查询曝光范围。
3. `EXPOSURE_US={1:1000, 2:1000}` 是每路独立目标（微秒），1ms 仅为未标定实验起点。
   超出返回范围就停止，要求调整参数，不静默截断。
4. 逐路设置曝光、丢弃 3 张启动帧，再读回曝光；允许 max(100us, 目标的5%) 的行周期量化误差。
   API 缺失、读回为空/异常/超差或 AE 未关闭都停止，走原有 finally 释放资源；不回退 AE。
5. 只有两路均通过读回，才进入 focus/drop 流程。曝光检查失败时不会建 dropNNN 或写 done.txt。
6. 保留原来的网格触发、内存连拍、ROI、RGB565 流、index.csv 和 events.csv 格式。
   meta.txt 追加目标固件、实际 `os.uname()`、每路目标/读回/范围、AE 状态及启动丢帧数。
   `drop_review.py`、`rgb565_to_png.py` 无须改变。focus 模式不存盘，参数在串口输出。

读回只验证驱动参数，不证明画面实际无拖影、双摄硬同步或逐豆计数可靠；增益和白平衡没有新增控制。
v1.3 的 1920×1080@30 / chn0 960×540 路径仅是迁移起点，v1.6 内存和驱动变更后须重测。

## 上板步骤与预期

1. 先把板上脚本、模型和采样数据拷到电脑，核实目标介质及恢复镜像；下载对应 ATK v1.6 镜像和 `.md5` 并核验。
   按正点原子烧录说明操作。本 PR 不执行刷机，也不删除原有数据。
2. 停止会占用相机的自启 demo。用 IDE 运行版本探测，保存 `os.uname()`、板型和 nncase 信息；
   不把 `selected_upgrade` 当成已经安装。模型继续使用 2.9.0 转换物，但仍重跑静态 kmodel 对照。
3. 上传此 PR 的 `drop_capture.py`，先设 `MODE="focus"`。保持豆静止、空出背景，启动后应看到
   两路 requested/actual/range，且无曝光异常，再出现两路预览。手动调焦 M12 镜头；过暗先改善正面补光。
4. 设 `MODE="drop"`，手动单颗投豆，等待 READY 再投下一颗。开始时可分别试 500/1000/2000us，
   仅使用两路返回范围内的值，每档独立新建 run；比较亮度、拖影、漏触发、误触发、重复帧及两路 skew。
5. 逐文件取回 dropNNN，运行 `python firmware/k230d/tools/drop_review.py <目录>`，
   对照 meta.txt 的实际曝光人工检查图像。触发次数不能当真实豆数。
6. 参数越界或 API/读回失败：停止投豆，保留串口错误，核对镜像和参数；不跳过检查继续采样。
   若 run/snapshot 卡死或存储 EIO，保留日志、停止运行，按旧 bring-up 记录断电恢复；
   不自动重试、不在同一 run 混入其他曝光或分辨率。960×540 不可用时断电后另试 640×360（ROI 随分辨率缩放）。

## 验证状态

- 主机：`python -m unittest discover -s firmware/k230d/tests -p 'test_drop_capture_exposure.py' -v`
  10 项测试通过，覆盖双路顺序、分别设置、范围/读回失败、旧固件缺 API、参数量化容差、元数据兼容及不覆盖目录。
- 主机语法检查通过；不是 CanMV 目标构建或上板测试。
- 尚未完成：镜像校验、刷机、双摄 v1.6 运行、亮度/实际短曝光、内存、存储稳定性、模型迁移验收。
