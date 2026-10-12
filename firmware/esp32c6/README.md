# ESP32-C6 控制固件准备

目标板：Waveshare ESP32-C6-LCD-1.47 非 Touch。ESP-IDF 是拟定路径；SDK、LCD/LVGL 组件版本及构建配置尚待官方例程核对。

当前没有 `CMakeLists.txt`、产品 `main` 或已编译固件，因此暂不提供会误导为可运行的构建命令。

先验证：屏幕 → UART → 按钮/限位/光电模拟 → 协议和超时 → 独立电源空载舵机 → 称重 → 网络队列 → 单槽联调。

状态机、串口、执行器、称重和网络采用明确模块边界。具体实现与组件清单在 SDK 基线确认后建立。引脚规划见 `../../config/hardware-baseline.json`，不得当作实机已验收接线。
