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

## 云端训练与 kmodel 转换（Modal）

`scripts/modal_train.py` 在 [Modal](https://modal.com) 云端完成训练（GPU）→ 导出 ONNX → nncase 2.9.0 编译 K230 kmodel，本机不需要 GPU，也不需要 Linux/nncase 环境。完整流程、结果与已知问题见 [训练基线](docs/ml/TRAINING-BASELINE.md)。

### 1. 注册 Modal 账号

1. 打开 <https://modal.com>，用 GitHub 或 Google 账号注册。
2. 免费的 Starter 套餐每月附带一定额度的计算费用，足够跑本项目的分类训练（一次 100 epoch 训练 + 转换在 L4 上约 10 分钟）。具体额度和单价以 <https://modal.com/pricing> 为准；超出额度需要在 Settings → Billing 绑定付款方式。

### 2. 安装 Modal CLI 并登录

需要 Python 3.10 及以上。任选一种安装方式（不要装进训练用的 `.venv`）：

```bash
uv tool install modal      # 推荐：独立的命令行工具环境
# 或
pipx install modal
# 或
pip install --user modal
```

登录（会打开浏览器授权，令牌保存在 `~/.modal.toml`，不要提交到仓库）：

```bash
modal setup
modal profile current      # 显示你的工作区名称，说明登录成功
```

### 3. 准备数据集

数据集不在 Git 里（`datasets/` 已被忽略）。把 Roboflow 导出的 `Green Coffee Bean Defects.v2i.yolo26/` 放在仓库根目录，生成分类裁图：

```bash
python scripts/prepare_coffee_defect.py    # 输出 datasets/coffee-defect-16/{train,val}/
```

### 4. 运行

在仓库根目录执行：

```bash
modal run scripts/modal_train.py::main                          # 训练 YOLO26n-cls 并转换 kmodel
modal run scripts/modal_train.py::main --model yolo11n-cls.pt   # YOLO11n 对照
modal run scripts/modal_train.py::main --no-convert             # 只训练
modal run scripts/modal_train.py::convert --run <run名>          # 只转换已有 run
```

- 训练结果：`runs/modal/<run名>/`；kmodel、标签、manifest 和板端测试样本：`output/kmodel/<run名>/`。云端副本保存在 Modal Volume `beanlens-runs`（首次运行自动创建，可用 `modal volume ls beanlens-runs` 查看）。
- 每次运行使用带时间戳的新名称，不会覆盖已有结果。
- 默认用公开数据裁图做量化校准，只是占位；有了 BOX 实机裁图后加 `--calib-dir <目录>` 重新转换。
- 生成的 kmodel 只经过主机模拟器对照。上板验证步骤见 [固件分阶段验收](docs/firmware/BRINGUP.md) 阶段 3。

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
