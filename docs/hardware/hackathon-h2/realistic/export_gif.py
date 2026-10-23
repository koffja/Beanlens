"""Combine rendered 3D frames and BOX screen; pre-set teaching animation only."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageOps

ROOT = Path(__file__).resolve().parent
frames = sorted((ROOT / "frames").glob("stage-*.png"))
assert len(frames) == 73, f"Expected 73 newly rendered frames, got {len(frames)}"
font_path = "/System/Library/Fonts/STHeiti Medium.ttc"
font = ImageFont.truetype(font_path, 18)
small = ImageFont.truetype(font_path, 13)
phases = [(0, "人工单颗，透明托片停豆"), (2.5, "豆粒停稳，人工按KEY0"), (5, "静止拍A上视，再拍B透片"), (8.2, "A/B同一颗配对，保存证据"), (10.5, "侧摆打开，后斜槽放豆"), (15, "空槽确认后，缓慢关闸")]
out = []
for i, p in enumerate(frames):
    canvas = Image.new("RGB", (1024, 630), "#f4f7f8")
    d = ImageDraw.Draw(canvas)
    d.text((24, 17), "BeanLens H2 · 上下双摄静拍", font=font, fill="#1d3038")
    title = next(text for start, text in reversed(phases) if i / 4 >= start)
    d.text((24, 47), f"{i / 4:04.1f}s  /  {title}", font=small, fill="#146d83")
    stage = ImageOps.contain(Image.open(p).convert("RGB"), (752, 510), Image.Resampling.LANCZOS)
    canvas.paste(stage, (16 + (752 - stage.width) // 2, 80 + (510 - stage.height) // 2))
    screen = Image.open(p.with_name(p.name.replace("stage-", "screen-"))).convert("RGB").resize((232, 174), Image.Resampling.LANCZOS)
    d.rounded_rectangle((778, 215, 1016, 401), radius=9, fill="#1a2329")
    canvas.paste(screen, (781, 221))
    d.text((781, 183), "K230D BOX 主屏", font=small, fill="#47626e")
    for j, text in enumerate(["两摄，仍只用一只舵臂", "玻璃托片可拆清洁", "侧壁透视仅为教学", "两张图只计一颗豆"]):
        d.text((786, 430 + j * 25), text, font=small, fill="#62747e")
    d.text((24, 605), "外形重建 / 预设A/B / 光学与净空待实配 / 非实机测试", font=small, fill="#788992")
    out.append(canvas)

palette_img = Image.new("RGB", (256 * 5, 158))
for i, n in enumerate([0, 24, 33, 48, 63]):
    palette_img.paste(out[n].resize((256, 158)), (i * 256, 0))
palette = palette_img.quantize(colors=160)
quantized = [im.quantize(palette=palette, dither=Image.Dither.NONE) for im in out]
gif = ROOT / "beanlens-h2-motion.gif"
quantized[0].save(gif, save_all=True, append_images=quantized[1:], duration=[250] * 72 + [1500], loop=0, optimize=True, disposal=2)
out[33].save(ROOT / "preview.png")
print(f"已生成 {gif.name}: {gif.stat().st_size:,} bytes, {len(quantized)} frames")
