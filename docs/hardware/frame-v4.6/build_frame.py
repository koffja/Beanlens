"""Generate V4.7 frame and inset-enclosure proposal, with stock accounting; no hardware control."""
import csv
import html
import itertools
import json
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent
parts = []


def add(name, length, pos, size):
    parts.append(dict(id=f"R{len(parts)+1:02}", bom="F01", name=name,
                      length_mm=length, pos_mm=pos, size_mm=size))


for x, y in [(0, 0), (200, 0), (0, 220), (200, 220)]:
    add("连续立柱", 460, [x, y, 0], [20, 20, 460])
for z, name in [(0, "底框"), (440, "顶框")]:
    for y in [0, 220]:
        add(name + "宽向梁", 180, [20, y, z], [180, 20, 20])
    for x in [0, 200]:
        add(name + "深向梁", 200, [x, 20, z], [20, 200, 20])
for x in [0, 200]:
    add("料斗中框侧梁", 200, [x, 20, 304], [20, 200, 20])
for y in [0, 220]:
    add("料斗中框外露横梁", 180, [20, y, 304], [180, 20, 20])
for y in [0, 220]:
    add("独立相机梁", 180, [20, y, 221.25], [180, 20, 20])

counts = Counter(p["length_mm"] for p in parts)
assert counts == {460: 4, 200: 6, 180: 8}
assert len(parts) == 18 and sum(p["length_mm"] for p in parts) == 4480
for a, b in itertools.combinations(parts, 2):
    overlap = [min(a["pos_mm"][i] + a["size_mm"][i], b["pos_mm"][i] + b["size_mm"][i])
               - max(a["pos_mm"][i], b["pos_mm"][i]) for i in range(3)]
    assert not all(v > 1e-6 for v in overlap), (a["id"], b["id"])

stocks = []
for i in range(1, 8):
    cuts = [460] if i <= 4 else [200, 200]
    kerf = 0 if i <= 4 else 6
    stocks.append(dict(id=f"S{i:02}", source="已有", raw_mm=460, outputs_mm=cuts,
                       kerf_mm=kerf, offcut_mm=460-sum(cuts)-kerf))
for i in range(8, 10):
    stocks.append(dict(id=f"S{i:02}", source="已有", raw_mm=400, outputs_mm=[180, 180],
                       kerf_mm=6, offcut_mm=34))
for i in range(10, 14):
    stocks.append(dict(id=f"S{i:02}", source="新购成品", raw_mm=180, outputs_mm=[180],
                       kerf_mm=0, offcut_mm=0))
assert Counter(v for s in stocks for v in s["outputs_mm"]) == counts
assert sum(s["raw_mm"] for s in stocks) == 4740
assert sum(s["kerf_mm"] for s in stocks) == 30
assert sum(s["offcut_mm"] for s in stocks) == 230
assert all(s["raw_mm"] == sum(s["outputs_mm"]) + s["kerf_mm"] + s["offcut_mm"] for s in stocks)
panels=[
    dict(id='P01',name='前上屏幕板',pos=[22,1,326],size=[176,6,112]),
    dict(id='P02',name='后上检修板',pos=[22,233,326],size=[176,6,112]),
    dict(id='P03',name='左上侧板',pos=[1,22,326],size=[6,196,112]),
    dict(id='P04',name='右上侧板',pos=[213,22,326],size=[6,196,112]),
    dict(id='P05',name='左下侧板',pos=[1,22,22],size=[6,196,280]),
    dict(id='P06',name='右下侧板',pos=[213,22,22],size=[6,196,280]),
    dict(id='P07',name='后中检修板',pos=[22,233,244],size=[176,6,58]),
    dict(id='P08',name='后下检修板',pos=[22,233,22],size=[176,6,197]),
    dict(id='P09',name='前中按钮板',pos=[22,1,244],size=[176,6,58]),
]
woodcuts=[['P05',196,280,3,3],['P03',196,112,3,286],['H01',158,110,3,401],
          ['H05',40,30,3,514],['H06',40,30,46,514],
          ['P06',196,280,202,3],['P04',196,112,202,286],['H02',158,110,202,401],
          ['P08',176,197,401,3],['P02',176,112,401,203],['P07',176,58,401,318],
          ['P01',176,112,401,379],['P09',176,58,401,494],
          ['H03',146,110,580,3],['H04',146,110,580,116]]
plan = dict(revision="V4.7-inset-PP-weld", date="2026-10-16", status="proposal_not_hardware_verified",
            hopper_reference=dict(pos_mm=[31,41,330],outer_mm=[158,158,110],wall_mm=6,
                                  pp_top_inner_mm=[136,136],pp_bottom_inner_mm=[110,30],pp_wall_mm=2,
                                  top_rim_outer_mm=[158,158],top_rim_z_mm=[440,442]),
            enclosure_reference=dict(panels=panels,face_recess_mm=1,gap_mm_nominal=2,
                                     wood_cuts=woodcuts,wood_sheet_mm=[800,600,6],
                                     alternative_stock='2 x 600x600x6; nine outer panels on A, six hopper/ear pieces on B',
                                     panel_brackets_used=32,front_light_strip_brackets_used=2,
                                     panel_brackets_purchase=40),
            lane_reference=dict(top_z=330,collar_bottom_z=327,transition_bottom_z=298.3,
                                upper_comb_z=[292.3,295.3,298.3],gate_gap_z=[290,292.3],
                                pom_support_z=[286,290],lower_comb_z=[280,283,286],
                                comb_width_mm=140,window_width_mm=14,window_depth_mm=12,
                                partition_mm=3,active_width_mm=82,stroke_mm=15),
            hopper_height_chain_mm=dict(midframe_top_z=324,support_ear_thickness=6,
                                       hopper_bottom_z=330,hopper_height=110,hopper_top_z=440,
                                       top_frame_bottom_z=440,frame_top_z=460),
            profile=dict(system="European 2020", finish="black anodized", slot_width_mm=None,
                         slot_note="User confirms black EU2020; measure actual groove before buying nuts."),
            frame_mm=[220, 240, 460], parts=parts, stocks=stocks,
            kerf_per_cut_mm_assumed=3, finished_length_mm=4480,
            purchase_finished_profile_mm={"180": 4}, brackets_used=28, brackets_purchase=32,
            bracket_screws_and_tnuts_each_purchase=64,
            caution="Stock lengths must be usable, square-ended and the same 2020 groove system; no end trim included. Parts only validate extrusion geometry, not joint or component clearance.")
(ROOT / "frame-plan-v4.6.json").write_text(json.dumps(plan, ensure_ascii=False, indent=2)+"\n")
with (ROOT / "stock-cut-v4.6.csv").open("w", encoding="utf-8-sig", newline="") as f:
    w = csv.writer(f, lineterminator="\n")
    w.writerow(["原料编号", "来源", "可用长mm", "每根产出净长mm", "锯缝合计mm", "余料mm"])
    for s in stocks:
        w.writerow([s["id"], s["source"], s["raw_mm"], "+".join(map(str, s["outputs_mm"])), s["kerf_mm"], s["offcut_mm"]])

svg = ['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1400 1080" role="img" aria-labelledby="title desc">',
       '<title id="title">BeanLens V4.7 连续立柱机架尺寸及角码位置</title><desc id="desc">220宽240深460高，18根型材；中框前后梁与柱面齐。尺寸均为毫米。</desc>',
       '<defs><marker id="arr" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M10 0L0 5L10 10" fill="none" stroke="#33594f"/></marker></defs>',
       '<style>text{font-family:system-ui,"PingFang SC",sans-serif;fill:#243e36;font-size:19px}.small{font-size:16px}.title{font-size:30px;font-weight:700}.rail{fill:#30353b;stroke:#111920;stroke-width:1.5}.slot{stroke:#89939b;stroke-width:2}.dim{stroke:#33594f;stroke-width:1.1;fill:none;marker-start:url(#arr);marker-end:url(#arr)}.ext{stroke:#a1b3ab;stroke-width:1}.angle{fill:#b2dccb;stroke:#117e60;stroke-width:1.5}.note{fill:#9a532a}.mono{font-variant-numeric:tabular-nums}</style>',
       '<rect width="1400" height="1080" fill="#fffefa"/>']


def text(x, y, content, cls="", anchor="start"):
    svg.append(f'<text x="{x:g}" y="{y:g}" class="{cls}" text-anchor="{anchor}">{html.escape(content)}</text>')


def rect(x, y, w, h, attrs='class="rail"'):
    svg.append(f'<rect x="{x:g}" y="{y:g}" width="{w:g}" height="{h:g}" {attrs}/>')


def line(x, y, x2, y2, cls="ext"):
    svg.append(f'<line x1="{x:g}" y1="{y:g}" x2="{x2:g}" y2="{y2:g}" class="{cls}"/>')


def dim(x, y, x2, y2, label, tx, ty):
    line(x, y, x2, y2, "dim")
    text(tx, ty, label, "small", "middle")


text(50, 50, "BeanLens V4.7｜黑色欧标2020，连续立柱", "title")
text(50, 82, "尺寸化布局提案 · 2026-10-16 · 单位mm · 不含脚套/端盖 · 不作为1:1钻孔模板", "small")
scale, top = 1.25, 145
front_x, side_x = 140, 630
bottom = top + 460 * scale
text(front_x+137.5, 125, "正视图", anchor="middle")
text(side_x+150, 125, "右视图", anchor="middle")
for x0, depth, length in [(front_x, 220, 180), (side_x, 240, 200)]:
    for x in [0, depth-20]:
        rect(x0+x*scale, top, 20*scale, 460*scale)
        line(x0+(x+10)*scale, top+5, x0+(x+10)*scale, bottom-5, "slot")
    heights = [0, 221.25, 304, 440] if depth == 220 else [0, 304, 440]
    for z in heights:
        yy = top+(460-z-20)*scale
        rect(x0+20*scale, yy, (depth-40)*scale, 20*scale)
        line(x0+25*scale, yy+10*scale, x0+(depth-25)*scale, yy+10*scale, "slot")
        text(x0+depth*scale/2, yy+17, str(length), "small", "middle")
        for sign, xx in [(1, x0+20*scale), (-1, x0+(depth-20)*scale)]:
            # Symbols locate bracket zones, not exact fastener geometry.
            base = yy-1 if z == 0 else yy+20*scale+1
            dy = -24 if z == 0 else 24
            svg.append(f'<path d="M{xx} {base}h{sign*24}L{xx} {base+dy}Z" class="angle"/>')
    line(x0, bottom+8, x0, bottom+47)
    line(x0+depth*scale, bottom+8, x0+depth*scale, bottom+47)
    dim(x0, bottom+40, x0+depth*scale, bottom+40, str(depth), x0+depth*scale/2, bottom+64)
dim(95, top, 95, bottom, "460", 66, (top+bottom)/2)
line(100, top, front_x-4, top)
line(100, bottom, front_x-4, bottom)
for z, label in [(440, "顶框下表面 Z440"), (324, "中框顶面 Z324"), (241.25, "相机梁顶 Z241.25"), (20, "底框顶面 Z20")]:
    yy = top+(460-z)*scale
    line(front_x+275, yy, front_x+305, yy)
    text(front_x+310, yy+6, label, "small")
text(front_x, bottom+99, "立柱460×4；横梁都夹在立柱之间", "small")
text(side_x, bottom+99, "中框横梁在外侧柱面；不是四通节点", "small")

text(1010, 135, "净料清点（F01）")
for y, row in enumerate(["460 × 4  立柱", "200 × 6  顶/底/中侧梁", "180 × 8  顶/底/中/相机梁", "共18根；净长4480mm"], 0):
    text(1010, 172+y*31, row, "small")
text(1010, 325, "角码（F02）")
for y, row in enumerate(["上下框：16套", "中框：8套；相机梁：4套", "用28套，购32套含备用", "每套2螺钉＋2匹配T螺母", "绿色三角仅标示安装区域", "两侧角码可能在投影中重叠"], 0):
    text(1010, 362+y*30, row, "small")
text(1010, 585, "称台底板四角需避角码", "note")
text(1010, 616, "约25×25核对区，不先切角", "small")
text(1010, 646, "不抬高称台去硬凑净空", "small")
text(1010, 695, "主斗110：330→440，圈顶442", "small")
text(1010, 725, "梁顶324＋托耳6＝330", "small")
text(1010, 755, "斗顶440＋顶框20＝460", "small")
for x0, offset in [(front_x,31),(side_x,41)]:
    rect(x0+offset*scale,top+20*scale,158*scale,110*scale,
         'fill="none" stroke="#bd7541" stroke-width="1.5" stroke-dasharray="6 5"')

text(50, 875, "现有料 → 只补购180mm成品4根", "title")
for y, row in enumerate(["460×4 保留整根做立柱；另外460×3 每根切200＋200（锯缝6，余54）",
                         "400×2 每根切180＋180（锯缝6，余34）；新购180×4直接用",
                         "合计：已有4020＋补购720＝成品4480＋锯屑30＋余料230＝4740mm",
                         "假设锯缝每刀3mm、原料端面可直接用；下料前量槽口、实际长度和端面。"], 0):
    text(50, 918+y*35, row, "small")
svg.append('</svg>')
svg_text = "\n".join(svg)
(ROOT / "frame-dimensions-v4.6.svg").write_text(svg_text)

table = "".join(f'<tr><td>{s["id"]}</td><td>{s["source"]}</td><td>{s["raw_mm"]}</td><td>{"＋".join(map(str,s["outputs_mm"]))}</td><td>{s["kerf_mm"]}</td><td>{s["offcut_mm"]}</td></tr>' for s in stocks)
page = '''<!doctype html><html lang="zh-CN"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="data:,"><title>BeanLens V4.7 黑色欧标机架与统一比例</title><style>
:root{color-scheme:light;--ink:#243e36;--muted:#64756c;--line:#cad5cc;--green:#107456}*{box-sizing:border-box}body{margin:0;background:#f3f2ec;color:var(--ink);font:16px/1.7 system-ui,-apple-system,"PingFang SC",sans-serif}main{max-width:1400px;margin:auto;padding:32px 24px}h1{font-size:clamp(26px,4vw,44px);line-height:1.2;margin:8px 0 16px}h2{font-size:23px}a{color:var(--green)}.muted{color:var(--muted)}nav{display:flex;flex-wrap:wrap;gap:18px;margin:20px 0}.box{padding:23px;background:#fffefa;border:1px solid var(--line);border-radius:12px;margin:22px 0}.tabs{display:flex;gap:12px;flex-wrap:wrap}button{font:inherit;border:1px solid var(--green);border-radius:5px;padding:8px 18px;color:var(--green);background:white;cursor:pointer}button[aria-pressed=true]{color:white;background:var(--green)}button:focus-visible{outline:3px solid #e3ad53;outline-offset:3px}img{display:block;width:100%;height:auto}.scroll{overflow-x:auto}table{border-collapse:collapse;width:100%;min-width:600px;text-align:left}th,td{padding:9px 12px;border-bottom:1px solid var(--line)}th{background:#e8f1e9}.columns{display:grid;grid-template-columns:1fr 1fr;gap:25px}.callout{border-left:4px solid #bd7541;padding-left:18px}.num{font-size:30px;font-weight:700}footer{font-size:13px;color:var(--muted)}@media(max-width:760px){main{padding:22px 12px}.columns{grid-template-columns:1fr}.box{padding:16px}.technical{min-width:900px}}@media print{nav,.tabs{display:none}main{padding:0}.box{break-inside:avoid}#dimensionView{display:block!important}#renderView{display:none}table{min-width:0}}</style></head><body><main>
<p class="muted">BEANLENS / 2026-10-16 / V4.7内嵌面板/PP制作</p><h1>黑色欧标2020，成品与裸框共用一套尺寸</h1><p>骨架220宽×240深×460高mm。保留7根460mm、2根400mm现有料中的有效长度，补购<strong>同槽型黑色欧标2020、净长180mm × 4根</strong>。</p>
<nav><a href="README.md">方案比较与装配说明</a><a href="stock-cut-v4.6.csv" download>切料CSV</a><a href="frame-plan-v4.6.json" download>尺寸JSON</a><a href="frame-dimensions-v4.6.svg">尺寸SVG</a><a href="../procurement-v4.5/beanlens-procurement-v4.5.html">采购总表</a><a href="IMAGE-PROMPT-V47.md">效果图生成记录</a><a href="../fabrication-v4.7/beanlens-fabrication-v4.7.html">PP料斗/五槽制作步骤与模板</a></nav>
<section class="box"><div class="tabs"><button data-view="comparisonView" aria-pressed="true">同尺寸成品／裸框</button><button data-view="renderView" aria-pressed="false">黑色外观参考</button><button data-view="dimensionView" aria-pressed="false">准确尺寸与数量</button></div><div id="comparisonView"><img src="black-frame-comparison-v4.6.svg" alt="共用坐标、相同视角和相同缩放的黑色2020成品与裸框，虚线显示110mm高料斗"><p>中框顶324＋托耳6＝斗底330；PP主斗110到440，上口圈到442；框顶460。<a href="../assembly-v4.5/beanlens-assembly-v4.5.html">打开已更新的交互组装／爆炸图</a> · <a href="../../../output/pdf/beanlens-assembly-v4.5-20261013.pdf">七页A3尺寸PDF</a> · <a href="../assembly-v4.5/cut-list-v4.5.csv">型材／海洋板裁切CSV</a></p></div><div id="renderView" hidden><img src="beanlens-frame-v4.7-inset-concept.png" alt="BeanLens V4.7完整机与机架概念效果图，使用连续立柱和内侧角码"><p class="muted">黑色外观参考由共享坐标对照图引导生成；准确高度、梁数和下料以同尺寸对照/尺寸图为准，不以AI局部细节加工。三面内嵌板下延，以黑色腰梁分块；正面留取盒口。</p></div><div id="dimensionView" hidden><div class="scroll">__SVG__</div><p class="muted">按数值测量；绿色符号标示角码区域，不是安装孔模板。</p></div></section>
<section class="columns"><article class="box"><h2>为什么用连续立柱</h2><p>立柱从底到顶不中断，顶/底横梁抵在柱侧。两个方向各用直角角码，不依赖四通方块；位置可调，也不用先在端面攻牙。</p><p>代价是内部角码占空间，需要校方、复紧和称台避让。现有2020继续用；是否承受整机载荷和侧推仍需实物验证。</p><p class="num">460×4 / 200×6 / 180×8</p><p>18根净长4.48m。三面木板分块内嵌下延，边缝约2、面内凹1；型材在外角外露。</p></article><article class="box"><h2>连接件如何配</h2><p>紧凑2020两孔90°角码：用28套，买32套；螺钉、匹配T螺母各64只。内嵌面板固定F11另列；F08只管料斗木壳/托耳。</p><p><a href="https://www.item24.com/en-tr/angle-bracket-set-5-20x20-42502">槽5系统的item 0.0.425.02</a>仅是历史规格参照，不列本次欧标型材默认采购项。已知型材为黑色欧标2020，T螺母/角码按实际槽口向原卖家配套，M5长度按角码厚度与槽深确定。</p><p>端盖/脚套各4；面板固定改用F11内角片背托。称台底板四角约25方区域先核净空；紧凑角码在梁宽内可不切角。</p></article></section>
<section class="box"><h2>每根现有料怎样使用</h2><p>按3mm锯缝，原料已修平。数字为成品净长，单位mm；新购四根180成品不再扣锯缝。</p><div class="scroll"><table><thead><tr><th>编号</th><th>来源</th><th>原料长</th><th>产出净长</th><th>锯缝合计</th><th>余料</th></tr></thead><tbody>__TABLE__</tbody></table></div><p><strong>4020＋720＝4480＋30＋230＝4740mm。</strong>400原料不能切200＋200。只买原棒时，可用一根750mm代替四根180成品，由供应商切4×180；这是替代选项，不重复购买。</p></section>
<section class="box callout"><h2>装配前先核这几处</h2><p>量现有型材槽口并向原卖家配套；先松装上下框、量对角线校方，再锁紧和定位中框/相机梁。称台底板与底角码、活动称台与豆盒不能互相顶住。中框前后梁与柱面齐；按钮中心移到Z273，按实物核背部空间。</p><p>旧V4.5的400mm柱＋220mm横梁属于440高搭法，不与本版混用。滑闸、双摄、称重孔位仍需实物纸样；本页没有证明±0.1g精度、1kg联调或整机承载通过。</p></section>
<footer>内置image_gen生成概念图；尺寸图由可复核坐标绘制。当前仅文档几何与配料检查。交互图册、7页PDF和裁切表均已更新；旧路径保留兼容，内容为V4.7黑色内嵌面板及PP修订。</footer></main><script>document.querySelectorAll('[data-view]').forEach(b=>b.onclick=()=>{for(const id of ['comparisonView','renderView','dimensionView'])document.getElementById(id).hidden=id!==b.dataset.view;document.querySelectorAll('[data-view]').forEach(v=>v.setAttribute('aria-pressed',String(v===b)))});</script></body></html>'''
(ROOT / "beanlens-frame-v4.6.html").write_text(page.replace("__SVG__", svg_text.replace('viewBox="0 0 1400 1080"', 'class="technical" style="width:100%;height:auto" viewBox="0 0 1400 1080"')).replace("__TABLE__", table))
print("V4.7: 18 profiles, no solid overlaps; 4480mm net; buy 4x180; 30mm kerf + 230mm offcuts.")
