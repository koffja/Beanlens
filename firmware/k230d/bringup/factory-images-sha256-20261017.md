# 资料盘出厂镜像校验值（BRINGUP 阶段 0 证据）

日期：2026-10-17。来源：`docs/【正点原子】DNK230D开发板资料盘(A盘)/6，软件资料/软件/CanMV固件/`。

状态：**均未烧录**。板上实际运行版本待 `01-version-probe.py` 上板自检后回填。烧录前以本表核对镜像。

| 镜像 | 用途 | SHA256 |
|---|---|---|
| `CanMV_K230D_ATK_DNK230D_micropython_v1.3-0-g8dd764f_nncase_v2.9.0_tf.img.gz` | TF 卡 | `d1c3f51bd7d142be86d2cc0baa94afa9ca8c9400d0a5c17253ed83314c8c371c` |
| `CanMV_K230D_ATK_DNK230D_micropython_v1.3-0-g8dd764f_nncase_v2.9.0.img.gz` | 板载 SD NAND | `697a1a90c870e0d03477d21ae148838da4615774cc63382d023b9d84a0cd6bbc` |
| `CanMV-K230D_ATK_DNK230D_micropython_v1.2-0-g9e4d9ca_nncase_v2.9.0_tf.img.gz` | TF 卡 | `0a4703d1e15a6ac21966e692f332822633edb914321c80e55bde00f475852b53` |
| `CanMV-K230D_ATK_DNK230D_micropython_v1.2-0-g9e4d9ca_nncase_v2.9.0.img.gz` | 板载 SD NAND | `717b0a62151ba9e1dd50d5adad42d3e9c28011944b75b11f1647992ba86ee4b0` |

配套烧录工具（同盘 `K230BurningTool/`）：Windows 与 Linux x86_64（AppImage）v2.0.0，**无 macOS 版**；使用说明见同目录 `K230BurningTool.pdf`。USB 直烧需按住 KEY2 进 BootROM 模式；正点原子 wiki 固件烧录页警告：烧错介质版本（SD NAND 版/TF 版混用）可能导致不可逆损坏。

实机自检回填（待跑）：
- 板上 release/version：
- nncase_runtime：
- /sdcard 内容摘要：
