# K230D / 正点原子 DNK230D BOX — WiFi 功能核查与对接参考

> 用途:本文件供其他会话/agent 快速了解 K230D 平台与正点原子 DNK230D BOX 的 WiFi 现状,以及如何对接使用网络能力。
> 核查日期:2026-10-23

## 一、核心结论(先读)

1. **K230D SoC 芯片本身不含任何无线射频。** 嘉楠 K230D 的片上接口只有:5×UART、5×I2C、5×PWM、50×GPIO、1×USB2.0 OTG、2×SDxC、3×SPI、WDT/RTC/Timer。没有 WiFi/蓝牙/以太网控制器。
2. **我们手上的正点原子 DNK230D BOX(底板 DNK230D + 核心板 CNK230DF)没有板载 WiFi/蓝牙/以太网模组。**
   - 依据:正点原子官方「K230D BOX 介绍」硬件资源清单未列出任何无线/网络接口;
   - 依据:项目内 `docs/【正点原子】DNK230D开发板资料盘(A盘)/3，原理图/ATK-DNK230D V1.0.pdf` 与 `ATK-CNK230DF V1.0.pdf` 全文搜索 `RTL/AIC/8189/8800/CYW/4343/AP62/BCM/ESP/WIFI/WLAN/无线/天线/ANT/BT_` 均无命中,核心板器件手册目录也无无线芯片。
3. **嘉楠官方明确:已发布的 K230D 标准固件(含 CanMV MicroPython)不支持网络功能。**
   - 出处:`k230_canmv` 文档 "K230D目前不支持网络功能";`wifi_drivers` 页警告 "当前发布的 K230D 标准固件不支持网络功能…属于自定义板级和驱动适配范围,不能直接套用标准固件"。
   - 即:即便硬件上有 WiFi 模组,标准 CanMV v1.3 固件也**不提供 `network.WLAN` 接口**,不能像 K230(非 D)那样直接 `import network; network.WLAN()`。

## 二、"K230D 有 WiFi 芯片" 这个说法从哪来

- 嘉楠的**参考设计板 CanMV-K230D-Zero(Banana Pi 开源社区合作版)** 板载了一颗 **2.4GHz Wi-Fi 模组**(官方参数写 "Network: 2.4GHz Wi-Fi module")。正点原子 DNK230D BOX 是基于该参考设计做的产品化版本,但**去掉了无线模组**。
- 所以"K230D 有 WiFi"对**参考板**成立,对**正点原子这版 BOX** 不成立。

## 三、K230D 平台"若外接 WiFi" 官方支持的芯片/方案(来自嘉楠 RTOS WiFi 文档)

这些方案属于**自定义板级适配 / RTOS 固件**范围,不是标准 CanMV 固件开箱即用:

| 方案 | 传输接口 | 能力 | 备注 |
|---|---|---|---|
| AIC8800 / AIC8801 系列(爱科微) | USB、SDIO | Wi-Fi 6,部分 2.4/5GHz + BLE | **嘉楠主推方案**,多型号 D80/D40/D80X2/DC/DW/DL |
| Realtek RTL8189FTV | SDIO | 2.4GHz Wi-Fi 4,STA/SoftAP | 常见低成本 SDIO WiFi |
| Realtek RTL8733BS | SDIO | 5GHz Wi-Fi 4,STA/SoftAP | |
| Broadcom CYW43438 / AP6212 | SDIO | 2.4GHz Wi-Fi 4 | |
| RW007 | SPI | STA/SoftAP | |
| ESP-Hosted(ESP32 协处理器) | SPI 全双工 / SDIO | ESP 固件管连接与 WPA,支持 WLAN offload | 用 ESP32 当 WiFi 协处理器 |

应用层统一走 RT-Thread WLAN / NetMgmt / lwIP / `wifi` 命令,不随模组重写联网逻辑。
部分板级 defconfig 已集成 AIC8800(如 `k230_canmv_01studio_defconfig` 支持 AIC8800 USB+SDIO)。

## 四、给"另一会话"的对接建议(落到本项目实际)

本项目(BeanLens)的实际网络分工已在 `AGENTS.md` 定义:**K230D BOX 负责双摄采集/分类/主屏,ESP32-C6 负责网络队列/状态屏/送料**。因此对接 WiFi 的正确路径是:

1. **首选:WiFi 走 ESP32-C6 协处理器,不要指望 K230D 直连无线。**
   - K230D ↔ ESP32-C6 用 UART(项目已有 PH2.0 / 双串口通道)交换"待上传批次/分类结果/队列指令"。
   - 这与"K230D 标准固件无网络"的限制完全吻合,无需自定义固件。
2. **若坚持让 K230D 直连 WiFi(需要自定义固件,工作量大):**
   - 硬件上外接模组(推荐 AIC8800 USB/SDIO 或 ESP-Hosted 方案);
   - 切换/构建 **RTOS(RT-Smart)固件** 而非 CanMV MicroPython,因为只有 RTOS 路径提供 `network.WLAN` / lwIP;
   - 按目标板 defconfig 启用对应驱动,烧录协处理器固件(ESP-Hosted 需 ESP 端固件)。
3. **不要**在 CanMV v1.3 MicroPython 固件里尝试 `network.WLAN()` —— 该接口在 K230D 标准固件中不存在,会直接报错。

## 五、一句话给另一会话

> K230D SoC 无内置无线;正点原子 DNK230D BOX(本项目在用板)也未板载 WiFi 模组,且标准 CanMV 固件不支持网络。要做网络,请把 WiFi 放到 ESP32-C6 侧,通过 UART 与 K230D 通信;若必须 K230D 直连,需外接 AIC8800/ESP-Hosted 等模组并改用 RTOS 固件。参考板 CanMV-K230D-Zero 才有板载 2.4GHz WiFi 模组。

## 六、证据来源

- 正点原子官方在线文档(项目内 `.url` → wiki.alientek.com/docs/Boards/Kendryte/DNK230D/):「K230D BOX 介绍」「入门指南 TOC」—— 无网络/WiFi 章节与硬件资源。
- 嘉楠 K230D 产品页(canaan-creative.com / kendryte.com proDetail/230d):K230D 片上接口清单,无无线。
- 嘉楠 k230_canmv 文档:网络例程警告 "K230D目前不支持网络功能";wifi_drivers 页 K230D 标准固件不支持网络。
- 嘉楠 Kendryte 社区《K230/K230D RTOS Wi-Fi Refresh》:支持芯片表(AIC8800/RTL8189FTV/RTL8733BS/CYW43438/RW007/ESP-Hosted)。
- 项目本地:【正点原子】DNK230D开发板资料盘(A盘)/3，原理图/ATK-DNK230D V1.0.pdf、ATK-CNK230DF V1.0.pdf(无 WiFi 芯片);7，硬件资料/器件手册(无无线芯片)。
