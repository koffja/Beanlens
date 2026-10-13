# 资料索引

## 当前主入口

- [HANDOFF-20261012.md](handoff/HANDOFF-20261012.md)：下一会话的工作上下文。
- [V4.4 手册](hardware/v4.4/beanlens-v4-handbook.html)：机械、光路、电气与屏幕；当前采购入口已修订为V4.5。
- [五槽同步滑闸修正建议](hardware/GATE-REVISION-20261012.md)：保留MG996R、居中推拉与左右导向；建议待实物验证，原第03图和PDF等快照尚未重绘。
- [滑闸配件选型与1kg载荷计算](hardware/GATE-PARTS-20261012.md)：M4短连杆、25T舵臂、2mm铝闸片和成品导向的候选规格；原厂尺寸核对及计算不等于实物验收。
- [槽内滑闸动画](hardware/illustrations/beanlens-gate-motion-20261012.html)：离线HTML＋JavaScript，俯视传动与单槽剖面同步，可拖动、暂停和调缓关时间；[设计与控制说明](hardware/GATE-ENCLOSED-SLOW-CLOSE-20261012.md)。
- [当前尺寸爆炸图与组装图](hardware/assembly-v4.5/beanlens-assembly-v4.5.html)：七张尺寸页＋交互部件选取，型材T01–T18/木板P/H编号对应BOM；[A3 PDF](../output/pdf/beanlens-assembly-v4.5-20261013.pdf)、[裁切CSV](hardware/assembly-v4.5/cut-list-v4.5.csv)、[装配说明与未定孔位](hardware/assembly-v4.5/README.md)。
- [工程图 PDF](hardware/v4.4/beanlens-box-drawings-v4.4.pdf)：12 页图纸。
- [完整手册 PDF](hardware/v4.4/beanlens-box-handbook-v4.4.pdf)：28 页快照。
- [当前采购表 V4.5](hardware/procurement-v4.5/beanlens-procurement-v4.5.html)、[新CSV](hardware/procurement-v4.5/beanlens-bom-v4.5.csv)、[新JSON](hardware/procurement-v4.5/beanlens-bom-v4.5.json)：旧35项完整核查，拆分84项含备选；新闸门/转接板/接线小件补齐，未知价格留空。
- [采购核查与复算说明](hardware/PROCUREMENT-AUDIT-20261012.md)、[红外对射型号与接线](hardware/BEAM-SENSOR-20261012.md)：用户B3F-20C1、GC2093-M12-90度无畸变、HJ-AZ4-3kg/103元输入；缺资料不编型号。
- [旧BOM JSON](hardware/v4.4/beanlens-box-bom-v4.4.json)、[旧CSV](hardware/v4.4/beanlens-box-bom-v4.4.csv)：仅历史快照，不用于新方案采购。
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
