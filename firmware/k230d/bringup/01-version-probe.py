#####################################################################################################
# BeanLens BRINGUP 阶段0：K230D BOX 板卡自检（只读脚本，不驱动任何外设、不写任何文件）
#
# 用途：确认板上实际运行的 CanMV 固件版本、nncase 运行时与存储内容。
#       对应 docs/firmware/BRINGUP.md 阶段0 第2条：记录 BOX 当前运行的 CanMV/nncase 版本、TF 内容。
#
# 操作：CanMV IDE → 打开本脚本 → 点击“运行”(绿色三角) → 底部串口终端查看输出
# 预期：约1秒内打印完并自动结束。资料盘镜像有 v1.2/v1.3 两个版本，打印结果即板上真实版本。
# 失败：单项读取失败只打印“读取失败”，脚本不会中断；请把完整输出复制回本目录留证。
#####################################################################################################

import os

LINE = "=" * 50

print(LINE)
print("BeanLens BOX 自检  阶段0：版本与存储（只读）")
print(LINE)

# --- 1. 固件/系统版本（MicroPython 标准接口）---
u = os.uname()
print("sysname :", u.sysname)    # CanMV 固件一般为 CanMV
print("machine :", u.machine)    # 板卡标识
print("release :", u.release)    # 固件版本号，对照资料盘 v1.2/v1.3
print("version :", u.version)    # 构建信息

# --- 2. nncase 推理运行时（AI 例程的导入方式为 import nncase_runtime as nn）---
try:
    import nncase_runtime as nn
    print("nncase_runtime :", getattr(nn, "__version__", "已安装（无 __version__ 属性）"))
except BaseException as e:
    print("nncase_runtime : 导入失败 ->", e)

# --- 3. 内存余量（后续 128MB 内存管理的基线数据）---
try:
    import gc
    print("MicroPython 堆剩余 :", gc.mem_free(), "字节")
except BaseException as e:
    print("内存信息读取失败 ->", e)

# --- 4. 存储目录内容（只列名字，确认出厂资源与 main.py 位置）---
def ls_top(path):
    try:
        names = os.listdir(path)
        print(f"{path} : {len(names)} 项 -> {names[:20]}")
        try:
            s = os.statvfs(path)
            total = s[0] * s[2] / 1024 / 1024
            free = s[0] * s[3] / 1024 / 1024
            print(f"    容量 {total:.1f} MB，剩余 {free:.1f} MB")
        except BaseException:
            pass
    except BaseException as e:
        print(f"{path} : 读取失败 -> {e}")

ls_top("/")
ls_top("/sdcard")   # 出厂综合例程从 /sdcard 读 CanMV Sample；main.py 优先取 /sdcard
ls_top("/data")     # 部分固件把用户脚本放这里，读不到属正常

print(LINE)
print("自检结束。请把以上完整输出复制回 firmware/k230d/bringup/ 留证。")
print(LINE)
