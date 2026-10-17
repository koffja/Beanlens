# 资料索引

## 当前主入口

- **V4.12 当前整机图与流程演示（2026-10-17）**：[完整运作HTML动画](hardware/assembly-v4.12/beanlens-operation-v4.12.html)、[交互组装/爆炸与十二页接线图](hardware/assembly-v4.12/beanlens-assembly-v4.12.html)、[12页A3 PDF](../output/pdf/beanlens-assembly-v4.12-20261017.pdf)、[型材/木板CSV](hardware/assembly-v4.12/cut-list-v4.12.csv)、[装配说明](hardware/assembly-v4.12/README.md)。整机模型已移除旧小过渡斗/双法兰/叠片，更新连续PP主斗、PP6/PP10槽座、PBT、SEN0503与机外YU2405/低压盒。框架/9木板/双屏保留，BOM继续用下方V4.11的114项。动画含停止/卡豆/失联演示，是教学模拟，非固件或实物验收。

- **V4.11 当前采购与豆路细节来源（2026-10-17）**：[六页结构与接线图](hardware/revision-v4.11/beanlens-hopper-gate-v4.11.html)、[详细说明](hardware/revision-v4.11/README.md)、[114项BOM](hardware/procurement-v4.11/beanlens-procurement-v4.11.html)、[CSV](hardware/procurement-v4.11/beanlens-bom-v4.11.csv)、[六页A3 PDF](../output/pdf/beanlens-hopper-gate-v4.11-20261017.pdf)。对射改DFRobot **SEN0503，50cm@5V**，电源改用户指定**YU2405 24V5A/120W**；舵机**UBEC5A/6V**保留。传感器信号拟10k上拉3.3V、1k串GPIO20，遮挡有效电平待测；YU2405实物插头、极性和厂牌待核。机械沿用V4.10，黑2020/9木板/双屏沿用V4.8。

- **V4.10 机械来源与历史电源选型（2026-10-16）**：[固定/连续前壁/槽内PBT刷/5V TPS比较与接线图](hardware/revision-v4.10/beanlens-hopper-gate-v4.10.html)、[详细说明](hardware/revision-v4.10/README.md)、[114项BOM](hardware/procurement-v4.10/beanlens-procurement-v4.10.html)、[CSV](hardware/procurement-v4.10/beanlens-bom-v4.10.csv)、[五页A3 PDF](../output/pdf/beanlens-hopper-gate-v4.10-20261016.pdf)。用户确认前壁连续、闸片从后方关闭；固定槽体PP可焊，刷排位于闸片上方分道入口。**6V舵机用UBEC5A/6V（好盈30607000可核候选），TPS5450仅评估5V逻辑路。** V4.9主斗外形、V4.8机架/9木板/双屏保留；V4.9的POM分离下座与6V通用降压主方案已替换。


- **历史V4.9 电源与豆路替换包（2026-10-16）**：[可放大的四页接线/端子/连续PP斗图](hardware/revision-v4.9/beanlens-power-and-feed-v4.9.html)、[逐步说明/淘宝关键词/估价](hardware/revision-v4.9/README.md)、[107项新版采购表](hardware/procurement-v4.9/beanlens-procurement-v4.9.html)、[CSV](hardware/procurement-v4.9/beanlens-bom-v4.9.csv)、[四页A3 PDF](../output/pdf/beanlens-power-and-feed-v4.9-20261016.pdf)。外置航嘉24V5A＋两XL4016（5V/6V）＋独立电源盒；连续四片PP2斗＋PP6/POM10两块五孔座，取消中间双法兰。**以下V4.8只保留机架、9片木板和双屏参考；其电源/料斗/五窗结构按最新V4.10替换，旧8片PP模板勿混用。**


- **保留机架/双屏参考V4.8（2026-10-16）**：[10页组装／双屏爆炸／净空／遗漏检查](hardware/assembly-v4.8/beanlens-assembly-v4.8.html)、[A3图册](../output/pdf/beanlens-assembly-v4.8-20261016.pdf)、[型材/9片木板CSV](hardware/assembly-v4.8/cut-list-v4.8.csv)。取消料斗外侧木壳/木托耳，顶框支承PP法兰，外壳三面木板仍下延、黑2020外露。
- **历史PP制作与采购V4.8（已被V4.9替换）**：[V4.8实料斜接/焊接/双法兰指南](hardware/fabrication-v4.8/beanlens-fabrication-v4.8.html)、[8页A4模板](../output/pdf/beanlens-pp-templates-v4.8-20261016.pdf)、[94项BOM](hardware/procurement-v4.8/beanlens-procurement-v4.8.html)、[CSV](hardware/procurement-v4.8/beanlens-bom-v4.8.csv)。已计法向板厚、内外面/坡口及焊筋储备，V4.7内面模板不作当前下料。

以下V4.7及更早路径保留历史查阅；整机装配以V4.12，采购/豆路细节以V4.11；V4.8仅作框架/木板原始数据，不混用料斗模板、木件或屏幕夹框尺寸。


- [历史V4.7 PP料斗／五槽制作](hardware/fabrication-v4.7/beanlens-fabrication-v4.7.html)、[六页A4 1:1控制模板](../output/pdf/beanlens-pp-templates-v4.7-20261016.pdf)：2mm PP四片试焊、136口/110×30底、五窗叠层留闸缝；三面木板下延、型材外露；[两种木料排版](hardware/fabrication-v4.7/wood-layout-options-v4.7.csv)。

- [历史机架V4.7：效果图、尺寸与配料](hardware/frame-v4.6/beanlens-frame-v4.6.html)、[方案比较/连接件与避让说明](hardware/frame-v4.6/README.md)：2026-10-16更新，黑色欧标2020、连续460立柱、220×240×460；已有460×7/400×2，补同规格黑色180×4；旧440高型材图不混用。

- [HANDOFF-20261012.md](handoff/HANDOFF-20261012.md)：下一会话的工作上下文。
- [开源发布切分方案](opensource/OPEN-SOURCE-PUBLICATION-20261015.md)：公开仓库进/排/待定清单、许可建议与发布前审计清单；是规划不是已执行操作，开仓前须先满足文中时机闸门。
- [V4.4 手册](hardware/v4.4/beanlens-v4-handbook.html)：机械、光路、电气与屏幕；当前采购入口已修订为V4.5。
- [五槽同步滑闸修正建议](hardware/GATE-REVISION-20261012.md)：保留MG996R、居中推拉与左右导向；建议待实物验证，原第03图和PDF等快照尚未重绘。
- [滑闸配件选型与1kg载荷计算](hardware/GATE-PARTS-20261012.md)：M4短连杆、25T舵臂、2mm铝闸片和成品导向的候选规格；原厂尺寸核对及计算不等于实物验收。
- [槽内滑闸动画](hardware/illustrations/beanlens-gate-motion-20261012.html)：离线HTML＋JavaScript，俯视传动与单槽剖面同步，可拖动、暂停和调缓关时间；[设计与控制说明](hardware/GATE-ENCLOSED-SLOW-CLOSE-20261012.md)。
- [历史V4.7内嵌木板与PP组装／爆炸图（保留旧路径）](hardware/assembly-v4.5/beanlens-assembly-v4.5.html)：七张尺寸页与PDF/CSV均已同步V4.7内嵌板/PP方案；料斗Z330→440、高110；切换外壳和分组时保持模型缩放，型材T01–T18/木板P/H编号对应BOM；[A3 PDF](../output/pdf/beanlens-assembly-v4.5-20261013.pdf)、[裁切CSV](hardware/assembly-v4.5/cut-list-v4.5.csv)、[装配说明与未定孔位](hardware/assembly-v4.5/README.md)。
- [工程图 PDF](hardware/v4.4/beanlens-box-drawings-v4.4.pdf)：12 页图纸。
- [完整手册 PDF](hardware/v4.4/beanlens-box-handbook-v4.4.pdf)：28 页快照。
- [历史采购表 V4.5](hardware/procurement-v4.5/beanlens-procurement-v4.5.html)、[新CSV](hardware/procurement-v4.5/beanlens-bom-v4.5.csv)、[新JSON](hardware/procurement-v4.5/beanlens-bom-v4.5.json)：旧35项完整核查，当前89项含备选（新增端盖/脚套，机架/外壳/PP按V4.7）；新闸门/转接板/接线小件补齐，未知价格留空。
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
