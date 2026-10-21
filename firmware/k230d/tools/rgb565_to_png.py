"""把 K230D BOX 存的 .rgb565 原始像素文件转成 PNG（电脑端运行，只用标准库）。

用法：
    python3 rgb565_to_png.py <capNNN 目录或单个 .rgb565 文件> [--out 输出目录]
                             [--width 320 --height 180] [--byteorder le|be]

支持两种板端格式：
  - 每帧一个 .rgb565 文件（cap010 及之前）；
  - 每相机一个 camN.rgb565stream 连续文件 + index.csv（cam,frame,t_ms,offset[,length]），拆成 camN_帧号_时间ms.png；
  - 每相机一个 camN.jpgstream 连续 JPEG 文件 + index.csv（含 length），直接拆成 .jpg（无需转换）。
未正常结束（无 done.txt）的目录也能转换：截断的帧和写了一半的索引行会跳过。
尺寸默认从同目录 meta.txt 读取；PNG 默认写到 <输入目录>_png/，不改动原始文件。
板端字节序：ATK v1.3 的 RGB565 为小端（le，默认），2026-10-17 用 cap011 对照确认；be 会成花屏。
"""

import argparse
import array
import pathlib
import struct
import sys
import zlib


def read_meta(folder):
    meta = {}
    path = folder / "meta.txt"
    if path.exists():
        for line in path.read_text().splitlines():
            if "=" in line:
                k, v = line.split("=", 1)
                meta[k.strip()] = v.strip()
    return meta


def build_lut():
    # RGB565 值 -> 3 字节 RGB888
    lut = []
    for v in range(65536):
        r, g, b = (v >> 11) & 0x1F, (v >> 5) & 0x3F, v & 0x1F
        lut.append(bytes(((r * 255 + 15) // 31, (g * 255 + 31) // 63, (b * 255 + 15) // 31)))
    return lut


def png_chunk(kind, data):
    body = kind + data
    return struct.pack(">I", len(data)) + body + struct.pack(">I", zlib.crc32(body) & 0xFFFFFFFF)


def convert(src, dst, width, height, big_endian, lut):
    data = src.read_bytes()
    if len(data) != width * height * 2:
        raise ValueError("%s: %d bytes, expected %d for %dx%d RGB565"
                         % (src.name, len(data), width * height * 2, width, height))
    write_png(data, dst, width, height, big_endian, lut)


def write_png(data, dst, width, height, big_endian, lut):
    px = array.array("H", data)
    if big_endian != (sys.byteorder == "big"):
        px.byteswap()
    raw = bytearray()
    for y in range(height):
        raw.append(0)  # PNG 行过滤：None
        raw += b"".join(lut[v] for v in px[y * width:(y + 1) * width])
    png = (b"\x89PNG\r\n\x1a\n"
           + png_chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0))
           + png_chunk(b"IDAT", zlib.compress(bytes(raw), 6))
           + png_chunk(b"IEND", b""))
    dst.write_bytes(png)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("input", type=pathlib.Path)
    ap.add_argument("--out", type=pathlib.Path)
    ap.add_argument("--width", type=int)
    ap.add_argument("--height", type=int)
    ap.add_argument("--byteorder", choices=("le", "be"), default="le")
    args = ap.parse_args()

    if args.input.is_dir():
        folder, files = args.input, sorted(args.input.glob("*.rgb565"))
    else:
        folder, files = args.input.parent, [args.input]

    meta = read_meta(folder)
    width = args.width or int(meta.get("width", 0))
    height = args.height or int(meta.get("height", 0))
    if not (width and height):
        sys.exit("size unknown: no meta.txt, pass --width/--height")

    out = args.out or folder.parent / (folder.name + "_png")
    lut = build_lut()
    big_endian = args.byteorder == "be"

    index = folder / "index.csv"
    if args.input.is_dir() and index.exists():
        out.mkdir(parents=True, exist_ok=True)
        jpg = meta.get("save_mode") == "jpg"
        frame_bytes = width * height * 2
        streams, ok, rows = {}, 0, index.read_text().splitlines()[1:]
        for line in rows:
            try:
                cols = [int(x) for x in line.split(",")]
                cam, frame, t_ms, offset = cols[:4]
            except ValueError:
                # 板端卡死时最后一行可能只写了一半
                print("skip malformed index line: %r" % line)
                continue
            length = cols[4] if len(cols) > 4 else frame_bytes
            if cam not in streams:
                ext = "jpgstream" if jpg else "rgb565stream"
                streams[cam] = (folder / ("cam%d.%s" % (cam, ext))).read_bytes()
            data = streams[cam][offset:offset + length]
            if len(data) != length:
                print("skip cam%d #%d: stream truncated" % (cam, frame))
                continue
            name = "cam%d_%03d_%05dms" % (cam, frame, t_ms)
            if jpg:
                (out / (name + ".jpg")).write_bytes(data)
            else:
                write_png(data, out / (name + ".png"), width, height, big_endian, lut)
            ok += 1
        print("%d/%d frames converted (%dx%d, %s) -> %s" % (ok, len(rows), width, height, args.byteorder, out))
        return

    if not files:
        sys.exit("no .rgb565 files or index.csv in %s" % args.input)
    out.mkdir(parents=True, exist_ok=True)
    ok = 0
    for f in files:
        try:
            convert(f, out / (f.stem + ".png"), width, height, big_endian, lut)
            ok += 1
        except ValueError as e:
            print("skip", e)
    print("%d/%d converted (%dx%d, %s) -> %s" % (ok, len(files), width, height, args.byteorder, out))


if __name__ == "__main__":
    main()
