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
