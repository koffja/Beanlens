# 资料索引

## 当前主入口

- [HANDOFF-20261012.md](handoff/HANDOFF-20261012.md)：下一会话的工作上下文。
- [V4.4 手册](hardware/v4.4/beanlens-v4-handbook.html)：机械、光路、电气、屏幕与采购规划。
- [工程图 PDF](hardware/v4.4/beanlens-box-drawings-v4.4.pdf)：12 页图纸。
- [完整手册 PDF](hardware/v4.4/beanlens-box-handbook-v4.4.pdf)：28 页快照。
- [BOM JSON](hardware/v4.4/beanlens-box-bom-v4.4.json)、[BOM CSV](hardware/v4.4/beanlens-box-bom-v4.4.csv)：用户报价、规划额度与待询价分列。
- [设计元数据](hardware/v4.4/beanlens-box-design-v4.4.json)、[原文档校验记录](hardware/v4.4/beanlens-box-validation-v4.4.json)：文档验证不等于实物验收。
- [硬件基线](../config/hardware-baseline.json)：固件接线起点，状态为拟定。
- [固件验收路线](firmware/BRINGUP.md)、[协议草案](firmware/PROTOCOL-v0.1-DRAFT.md)、[训练现状](ml/TRAINING-BASELINE.md)。

## 历史研究

- [2026-10-11 综合研究](research/BeanLens_Research_20261011.html)：GLM 复核、机构物理、模型和参赛价值。
- [GLM 对 V4 的审查](research/BeanLens_V4_Handbook_Review_20261011.html)：历史审查，不直接作为最新设计要求。
- [摄像头、模型和抽样](research/beanlens-camera-model-sampling-20261009.md)。
- [本地训练与来源](research/beanlens-local-training-primary-sources-20261009.md)。
- [咖啡行业需求](research/coffee-industry-hardware-primary-sources-20261008.md)。
- [赛事初期规划](research/wtcc-2026-beanlens-green-defect-scanner.md)、[项目参赛策略](research/wtcc-2026-tastermatrix-ai-hardware-strategy.md)。

研究文件保留写作时的路径、日期和判断。V4.4 之后的灯带选择、3kg 候选报价等，以当前手册与后续实测为准。不要把多个历史方案的采购件混在一起。

## 用户已有厂商资料

`docs/【正点原子】DNK230D开发板资料盘(A盘)/` 中有底板/核心板原理图、引脚表、标准例程、CanMV v1.2/v1.3 例程及 nncase 2.9.0 配套镜像。它们保持原样，只作开发参考；不自动代表设备上已烧录的版本。

原厂入口：

- [正点原子 BOX 介绍](https://wiki.alientek.com/docs/Boards/Kendryte/DNK230D/start-guide/k230d-box-introduction/)
- [正点原子下载](https://wiki.alientek.com/docs/Boards/Kendryte/DNK230D/start-guide/download/)
- [Waveshare C6 非 Touch 板](https://www.waveshare.com/wiki/ESP32-C6-LCD-1.47)
- [嘉楠 CanMV 文档](https://www.kendryte.com/k230_canmv/en/main/)

## 迁移规则

`handoff/MIGRATION-20261012.json` 记录迁入文件和校验值。已有数据、环境、run 和厂商原件未改动。V4.4 压缩包保留原始字节；迁入 HTML 的本地研究链接及设计 JSON 的手册位置做了重定位，记录在清单中。PDF 仍为原版快照。
