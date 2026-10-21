# 训练与模型基线

2026-10-12只做文件与环境元数据核查，没有重新训练、验证模型或改变用户环境。

## 已有内容

- 根目录已有`yolo26n-cls.pt`、`yolo11n-cls.pt`、`yolo26n-cls.onnx`；文件存在不表示它们都是训练后的最终发布物。
- `datasets/coffee-defect-16/`有train、val目录；公开数据原始导出目录和zip保持原样。
- `scripts/prepare_coffee_defect.py`、`scripts/build_mydata.py`是已有脚本，本次未修改或审查其实现。
- `runs/classify/runs/warmup-yolo26n-cls-16/`及`runs/classify/runs/warmup-yolo26n-cls/`各有args.yaml、100行训练结果和weights/best.pt。第二个run引用的数据路径与当前数据目录不同，不能直接假设可重复运行。
- 仅在`runs/`范围检查，未发现kmodel；不能据此排除厂商资料其他位置有示例模型。尚未确认BeanLens模型转换/板端部署。

已有`.venv`包元数据：Python3.14.5、ultralytics8.4.175、torch2.14.1、torchvision0.29.1、onnx1.23.2。这是本机观察值，不是建议无条件升级到该版本，也不是nncase兼容证明。

## 后续工作

1. 从args.yaml与模型标签确认哪个best.pt用于当前16类任务，不把根目录预训练权重误作已训练模型。
2. 核查数据许可、类名映射、类别不均衡和同豆/同批次泄漏；保留独立、实际装置采集的测试集。
3. 对比YOLO26n-CLS与YOLO11n-CLS时采用同数据划分和预处理，报告每类召回、混淆、拒判和实际推理代价。
4. 检查分类默认裁切是否丢失完整豆体；标签顺序、RGB/BGR、缩放、归一化统一记录。
5. 先选匹配BOX运行时的nncase版本，再在独立转换环境导出/转换并做主机-KPU对照。不要为了装nncase破坏训练环境。
6. 量化校准数据来自实际灯光、曝光和相机；每次发布记录权重、ONNX、kmodel、标签与预处理校验值。

本页不摘抄训练准确率；后续需读原始结果并独立验证。公开图片上的高分不等于豆帘设备上的可靠率。

## 2026-10-18 Modal 云端训练（主机侧验证，未转换、未上板）

本机此时未找到上文所列根目录`*.pt`、`runs/classify/…`与`.venv`，因此本次从ultralytics官方预训练权重重新训练，不是旧run续训。

- 脚本：`scripts/modal_train.py`（`modal run scripts/modal_train.py::main [--model yolo11n-cls.pt]`）。数据集打包进容器；结果写入Modal Volume `beanlens-runs`并下载到`runs/modal/<名称>/`，名称带时间戳，不覆盖已有run。之后的run会在`modal_meta.json`写入每类召回率。
- 环境：Modal NVIDIA L4，Python 3.12.10，ultralytics 8.4.175，torch 2.14.1+cu130。
- 数据：`datasets/coffee-defect-16`，训练1460/验证258张（val目录多出的1个文件是`.DS_Store`）；图片内容sha256 `90e17042da82…`。每类验证仅8–26张。
- 参数：100 epoch，imgsz 224，batch 64，seed 0，deterministic。

| run | val top1 | val top5 | best.pt sha256 |
|---|---|---|---|
| `yolo26n-cls-coffee-defect-16-20261018-204003` | 0.791 | 0.992 | `b6a37ddad282…` |
| `yolo11n-cls-coffee-defect-16-20261018-210148` | 0.795 | 0.992 | `b381a470a32f…` |

每类召回率（从归一化混淆矩阵读取，YOLO26n / YOLO11n）：broken 0.39/0.61，cut 0.90/0.90，dry_cherry 0.93/0.93，fade 0.62/1.00，floater 0.69/0.56，full_black 1.00/1.00，full_sour 1.00/0.80，fungus 0.73/0.77，husk 1.00/1.00，immature 0.94/0.94，parchment 1.00/1.00，partial_black 0.92/0.88，partial_sour 0.67/0.75，severe_insect_damage 0.75/0.75，shell 0.96/0.71，withered 0.35/0.45。

结论：同一数据划分下两者整体持平；样本量小，类间差异不足以选型。共同弱项是withered→immature、broken↔shell、partial_sour→full_sour的混淆。两者融合后的摘要都显示47层、1,546,520参数，原因未核查。以上只是公开数据集裁图的验证结果，不代表豆帘设备上的可靠率；尚未导出ONNX/kmodel，也未在KPU上运行。

## 2026-10-18 kmodel 转换流水线（主机转换 + 模拟器对照，未上板）

- 一条命令：`modal run scripts/modal_train.py::main`，依次完成训练（L4）→ 导出 ONNX（训练镜像，opset 13）→ nncase 编译（独立镜像：Linux x86_64、Python 3.10、.NET 7、nncase/nncase-kpu 2.9.0）。对已有 run 只做转换：`modal run scripts/modal_train.py::convert --run <run>`。加 `--tag <名>` 可用同一权重生成量化变体，输出到 `<run>-<名>`，不覆盖原 kmodel。产物在 `output/kmodel/<run>/`（已被 gitignore）和 Volume `beanlens-runs` 的 `kmodel/<run>`。
- kmodel 输入：uint8 RGB NCHW 1×3×224×224；x/255 在模型内完成。短边缩放到 224 加中心裁切不在模型内，板端必须按同样方式处理。输出是 16 类 softmax，标签顺序见 `labels.txt`。
- 主机对照：在 val 上取 50 张，比较 ONNX 与 nncase 模拟器的结果。`board_test/` 里存了其中 20 张预处理后的 .bin 和参考输出，供板端 `firmware/k230d/bringup/kmodel_static_check.py` 使用。
- 校准数据目前是占位：用公开数据集的 train 裁图，manifest 中 `ptq.calib_source` 标明了这一点。实机裁图就绪后，用 `--calib-dir <本地目录>` 重新转换。

| run | 量化 | kmodel sha256 | 模拟器与 ONNX top1 一致率（50 张） | 余弦相似度 min / mean |
|---|---|---|---|---|
| yolo26n-…-204003 | int16/int16, NoClip, 100 张 | `54db37ced435…` | 1.00 | 0.9983 / 0.9999 |
| yolo11n-…-210148 | int16/int16, NoClip, 100 张 | `eb74dc5fb3cb…` | 0.96 | 0.9942 / 0.9992 |

转换过程中查明并修复的问题：
1. `convert_kmodel.py preprocess()` 返回的是 transpose 后的不连续数组视图，而 `nncase.RuntimeTensor.from_numpy` 按原始内存读取，导致校准和模拟器都收到 HWC 排列的数据（top1 一致率约 0.05）。已改为返回 `np.ascontiguousarray`。
2. Modal 的 gVisor 沙箱里，`unlink("dir/")` 返回 ENOTDIR 而不是 EISDIR，导致 k230 模拟器的 `remove_all` 失败、进程 abort。只给 compile 子进程加了 `LD_PRELOAD` 的 `remove()` 补丁；在真 Linux 上不需要。
3. 模拟器可执行文件 `nncase.simulator.k230.sc` 装在 site-packages 根目录，不在 PATH 里，已在镜像中软链到 `/usr/local/bin`。

量化选项对比（YOLO26n，修复输入排列后，val 20 张，uint8 输入加模型内预处理）：全 uint8 时一致率 0.70（KLD 0.70，UseSquant 0.80）；激活 uint8 / 权重 int16 为 0.90（3.4MB）；激活 int16 / 权重 uint8 为 0.70；全 int16 为 0.95，余弦 0.9997（6.2MB）。因此默认用 int16，可用 `--quant-type/--w-quant-type` 切换。int16 在 KPU 上的耗时和内存尚未实测。2026-10-21 上板：yolo26n 全 int16 kmodel 与模拟器 top1 一致率 1.0，但单次推理约 16.3 s，不可用于实时分类；同权重 u8w16 变体（`--tag u8w16`）上板约 7.7 ms/次，与模拟器一致率 1.0；主机 50 张与 ONNX 一致率 0.92（余弦 min 0.74 / mean 0.98）；u8w8 主机一致率 0.76（余弦 min 0.07），未上板。当前端侧候选为 u8w16；默认 int16 只适合主机对照。（见 `docs/firmware/BRINGUP.md`）

仍未完成：板端运行时版本未读取（不能确认与 nncase 2.9.0 配套）；`kmodel_static_check.py` 未上板运行；未用实机光照的裁图校准；未测板端推理耗时。

一条命令的端到端验证（2026-10-18）：`modal run scripts/modal_train.py::main` 生成了 `yolo26n-cls-coffee-defect-16-20261018-231224`，val top1 = 0.7907，kmodel sha256 是 `54db37ced435…`，和 204003 那次单独转换的结果完全相同；主机对照 top1 一致率 1.00。两次的 best.pt 文件校验值不同（ultralytics 在 .pt 里写了日期等元数据），但导出的 kmodel 一字节不差，说明相同 seed 下权重和转换都能复现。
