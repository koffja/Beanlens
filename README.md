# BeanLens · 豆鉴

面向咖啡生豆验收的双摄视觉初筛装置。保存可复核的图像、分类候选与批次记录，后续可关联 Taster-Matrix 杯测资料。

当前状态：V4.4 设计资料已迁入；用户已有训练数据、两次分类训练输出和厂商资料。双板产品固件尚未实现或上板验收。

## 从这里开始

- [Agent 规则](AGENTS.md)
- [当前交接](docs/handoff/HANDOFF-20261012.md)
- [资料索引](docs/README.md)
- [V4.4 手册](docs/hardware/v4.4/beanlens-v4-handbook.html)
- [12 页工程图](docs/hardware/v4.4/beanlens-box-drawings-v4.4.pdf)
- [采购清单](docs/hardware/v4.4/beanlens-box-bom-v4.4.csv)
- [固件分阶段验收](docs/firmware/BRINGUP.md)
- [通信协议草案](docs/firmware/PROTOCOL-v0.1-DRAFT.md)
- [模型与训练现状](docs/ml/TRAINING-BASELINE.md)

## 目录

| 目录 | 用途 |
|---|---|
| `firmware/k230d/` | K230D BOX 视觉、模型与主屏；当前仅规则和准备说明 |
| `firmware/esp32c6/` | C6 机械、称重、状态屏与联网；当前仅规则和准备说明 |
| `shared/protocol/` | 通信契约的共同入口，暂未实现编解码器 |
| `config/` | 硬件基线；引脚与运行版本待实机验证 |
| `docs/hardware/v4.4/` | 迁入的完整设计交付文件 |
| `docs/research/` | 旧研究及审查依据 |
| `docs/【正点原子】DNK230D开发板资料盘(A盘)/` | 用户已有厂商资料，保持原样 |
| `scripts/`、`datasets/`、`runs/` | 用户已有训练工作区，保持原样 |

本次仅配置规则、资料和开发入口。没有安装 ESP-IDF、升级训练环境、烧录设备或启动新训练。目录当前尚未初始化 Git；忽略规则已准备。
