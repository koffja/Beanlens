# K230D BOX 应用准备

目标：CanMV/MicroPython 视觉应用。当前仅准备目录和规范，没有创建可烧录应用，也没有选定实机固件版本。

先验证：主屏显示 → UART 收发 → 单摄静态图/调焦 → 双摄时间戳与帧率 → YOLO26-CLS 的 KPU 对照 → 单槽跟踪与证据。

参考 `../../docs/firmware/BRINGUP.md`、`../../config/hardware-baseline.json` 及已有正点原子资料。计划把采集、分类、跟踪、通信、证据和 UI 分模块，但等官方 API 基线确认后再创建实现，避免生成无法上板的空壳代码。
