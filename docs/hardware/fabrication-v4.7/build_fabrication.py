"""Generate 1:1 control templates and a self-contained fabrication guide.

The patterns control inside geometry, not unverified welding allowances/hole fits.
"""
import csv
import html
import json
import math
import re
from pathlib import Path

ROOT=Path(__file__).resolve().parent
FRAME=json.loads((ROOT.parent/'frame-v4.6/frame-plan-v4.6.json').read_text())
woodcuts=FRAME['enclosure_reference']['wood_cuts']
alt_h={'H01':(3,3),'H02':(164,3),'H03':(325,3),'H04':(3,116),'H05':(152,116),'H06':(195,116)}
wood_options=[]
for id,w,h,x,y in woodcuts:
    board='A' if id.startswith('P') else 'B'
    ax,ay=(x,y) if board=='A' else alt_h[id]
    wood_options.append(dict(id=id,size_mm=[w,h,6],primary_sheet='800x600',primary_xy_mm=[x,y],alternative_sheet=board,alternative_xy_mm=[ax,ay]))
(ROOT/'wood-layout-options-v4.7.json').write_text(json.dumps(wood_options,ensure_ascii=False,indent=2)+'\n')
with (ROOT/'wood-layout-options-v4.7.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.writer(f,lineterminator='\n');w.writerow(['板号','净尺寸mm','主方案800×600的X/Y','备选600方板号','备选X/Y'])
    for p in wood_options:w.writerow([p['id'],'×'.join(map(str,p['size_mm'])),'/'.join(map(str,p['primary_xy_mm'])),p['alternative_sheet'],'/'.join(map(str,p['alternative_xy_mm']))])
top=FRAME['hopper_reference']['pp_top_inner_mm'][0]
A=math.hypot(110,(top-30)/2)
B=math.hypot(110,(top-110)/2)
C=math.hypot(28.7,9)
D=math.hypot(28.7,14)
assert abs(math.hypot(A,(top-110)/2)-math.hypot(B,(top-30)/2))<1e-9
cuts=[('A','F04','PP-H2',top,110,A,2),('B','F04','PP-H2',top,30,B,2),
      ('C','F05','PP-H2',110,82,C,2),('D','F05','PP-H2',30,12,D,2)]
with (ROOT/'pp-cuts-v4.7.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.writer(f,lineterminator='\n');w.writerow(['编号','BOM','材料','上边或外长mm','下边或外宽mm','斜高/厚度mm','数量','注意'])
    for id,bom,mat,tt,bb,hh,n in cuts:w.writerow([id,bom,mat,tt,bb,round(hh,3),n,'内表面控制尺寸；外留约1mm修边，先纸样试夹'])
    for row in [('RIM','F04','PP-H2',158,158,2,1,'中心开136方孔'),('COLLAR','F05','PP-H3',124,44,3,1,'中心开110×30孔'),('U1/U2','F05','PP-H3',140,30,3,2,'五窗14×12，X29/46/63/80/97，Y9；红孔先试装'),('L1/L2','F05','PP-H3',140,18,3,2,'同X；Y3，五窗贯通'),('S','G12','POM',140,30,4,1,'同X；Y9，不与PP热焊')]:w.writerow(row)

def t(x,y,s,size=3.5,color='#243e36',anchor='start'):
    return f'<text x="{x}" y="{y}" font-size="{size}" fill="{color}" text-anchor="{anchor}">{html.escape(str(s))}</text>'
def ln(x,y,xx,yy,color='#243e36',dash=False):
    return f'<path d="M{x},{y}L{xx},{yy}" fill="none" stroke="{color}" stroke-width=".3"'+(' stroke-dasharray="2 1"' if dash else '')+'/>'
def rect(x,y,w,h,color='none',stroke='#243e36'):
    return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{color}" stroke="{stroke}" stroke-width=".3"/>'
def dim(x,y,xx,yy,label,tx=None,ty=None):
    return ln(x,y,xx,yy,'#a65d32')+t((x+xx)/2 if tx is None else tx,(y+yy)/2-2 if ty is None else ty,label,3.5,'#a65d32','middle')
def note(x,y,ss):return ''.join(t(x,y+i*5,s,3.3) for i,s in enumerate(ss))
packing=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1400 800"><style>text{font-family:system-ui,\"PingFang SC\",sans-serif}</style><rect width="1400" height="800" fill="#fffefa"/>',t(40,45,'备选：两张600×600×6（已有一张时只追加一张）',28)]
for board,ox in [('A',60),('B',740)]:
    packing+=[t(ox,100,'板'+board+('：九块外壳' if board=='A' else '：料斗/托耳'),21),rect(ox,130,540,540,'#f8f0e3')]
    for p in wood_options:
        if p['alternative_sheet']!=board:continue
        x,y=p['alternative_xy_mm'];w,h,_=p['size_mm'];xx=ox+x*.9;yy=130+y*.9
        packing+=[rect(xx,yy,w*.9,h*.9,'#d5b58a'),t(xx+4,yy+18,p['id'],14)]
        if h>40:packing.append(t(xx+4,yy+36,f'{w}×{h}',12))
packing+=[t(40,735,'矩形间与板边按约3mm留量；尺寸是净长，不能把锯缝吃进成品。两种板料方案二选一。',19),'</svg>']
(ROOT/'wood-alternative-v4.7.svg').write_text(''.join(packing))
def pattern(x,y,upper,lower,height,label):
    off=(upper-lower)/2
    p=f'<polygon points="{x},{y} {x+upper},{y} {x+off+lower},{y+height} {x+off},{y+height}" fill="#eef5ee" stroke="#243e36" stroke-width=".4"/>'
    return p+dim(x,y-6,x+upper,y-6,str(upper))+dim(x+off,y+height+7,x+off+lower,y+height+7,str(lower))+t(x+upper/2,y+height/2,label,4.5,anchor='middle')
def sheet(n,title,body):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="210mm" height="297mm" viewBox="0 0 210 297" role="img" aria-label="{html.escape(title)}"><style>text{{font-family:Arial,"PingFang SC",sans-serif}}</style><rect width="210" height="297" fill="white"/>{t(12,13,'BEANLENS / V4.7 / 2026-10-16',3.2)}{t(12,24,title,5.6)}{t(12,31,'黑线为内表面控制线；外留修边量；先纸样，再试焊。',3.4)}{body}{ln(20,279,120,279)}{ln(20,277,20,281)}{ln(120,277,120,281)}{t(70,277,'100mm校验线：打印100%，关闭缩放',3.1,anchor='middle')}{t(12,290,'2mm板厚、坡口/焊筋/最终孔位须实物修配，非免试装刀模。',3)}{t(198,290,f'{n}/6',3,anchor='end')}</svg>'''

sheets=[]
body=pattern(37,60,top,110,A,'A 前／后 ×2')
body+=dim(27,60,27,60+A,f'{A:.2f}斜高',29,125)
body+=note(15,220,['垂直高度110，不等于本片斜高。',f'下边相对上边每侧缩{(top-110)/2:g}；相邻斜接边约122.79。','本页打印两份。先在纸上闭合，确认底口110×30。','PP-H 2mm；控制线外留约1mm，试夹后刮修坡口。'])
sheets.append(sheet(1,'A：主斗前后片 / 内面1:1',body))
body=pattern(37,60,top,30,B,'B 左／右 ×2')
body+=dim(27,60,27,60+B,f'{B:.2f}斜高',28,120)
body+=note(15,217,['本片下边30，不是110；左右片与前后片不同。',f'每侧缩{(top-30)/2:g}，四片顶边均为136。','本页打印两份。用上下定位框维持垂直高度110。','角度由试夹得，不把所有接边统一切成45°。'])
sheets.append(sheet(2,'B：主斗左右片 / 内面1:1',body))
body=rect(26,44,158,158,'#eef5ee')+rect(37,55,136,136,'white')
body+=t(105,115,'口圈：PP2，外158 / 内136',4,anchor='middle')
body+=dim(26,38,184,38,'158')+t(14,213,'口圈焊在斗顶；坐木壳Z440，上表面Z442。',3.5)
body+=rect(43,228,124,44,'#eef5ee')+rect(50,235,110,30,'white')+t(105,253,'接环：PP3 / 内110×30',3.4,anchor='middle')
body+=t(14,222,'接环在Z327→330；小过渡斗接其下方。',3.5)
sheets.append(sheet(3,'口圈与下接环 / 平面1:1',body))
body=pattern(50,49,110,82,C,'C 前后片 ×2')+pattern(50,110,110,82,C,'C 第二片')
body+=pattern(50,180,30,12,D,'D')+pattern(130,180,30,12,D,'D')
body+=note(12,239,[f'C斜高{C:.2f}；D斜高{D:.2f}；均为PP-H2。','垂直高28.7，上110×30，下82×12，中心对齐。','上接环厚3另计，合计到主斗下口Z330。'])
sheets.append(sheet(4,'小过渡斗：四片 / 内面1:1',body))

def comb(x,y,w,h,offset,holes=True):
    out=rect(x,y,w,h,'#eef5ee')
    for xx in [29,46,63,80,97]:out+=rect(x+xx,y+offset,14,12,'white')
    if holes:
        ys=[9 if h==18 else 15]
        for xx in [7.5,132.5]:
            for yy in ys:out+=f'<circle cx="{x+xx}" cy="{y+yy}" r="1.6" fill="none" stroke="#bd473c" stroke-width=".25" stroke-dasharray="1 .7"/>'
    return out

body=comb(35,48,140,30,9)+t(35,40,'U1/U2：PP3，140×30，做两片',3.6)
body+=note(15,135,['孔左边X＝29、46、63、80、97；每孔14×12。','上片孔Y9→21；后罩另做，不把平板伸到加强梁上方。'])
body+=comb(35,163,140,18,3)+t(35,157,'L1/L2：PP3，140×18，做两片',3.6)
body+=note(15,203,['下片孔Y3→15；装配后与上片同处整机Y114→126。','红圈Ø3.2只是候选安装孔，纸样避开滑轨后再钻。','本页打印两份，可分别转印上下两层。','3mm筋位于相邻窗口之间；不能把筋锯掉。','窗口先做一片检查；同批CNC比手修更容易对齐。'])
sheets.append(sheet(5,'五槽PP叠片 / 平面1:1',body))
body=comb(35,50,140,30,9)+t(35,43,'S：POM4，140×30，仅一片',3.6)
body+=note(15,94,['POM顶面Z290，上承闸片；五窗必须贯通。','不能与PP热焊；螺栓夹持在远离豆路的两翼。'])
body+=rect(55,124,10,30,'#dfe9ec')+rect(145,124,10,30,'#dfe9ec')
body+=t(105,118,'隔片10×30，两处：2mm＋约0.3薄片',3.4,anchor='middle')
body+=note(15,167,['隔片在140宽板的X0→10、130→140。','闸片扫掠X15→125，不能被隔片或螺钉挡住。'])
for yy,hh0,label,col in [(192,12,'上PP3＋PP3，Z292.3→298.3','#b8d8c9'),(204,4.6,'间隙2.3：闸片实厚＋余量','#efccaa'),(208.6,8,'POM4，Z286→290','#d2dbe2'),(216.6,12,'下PP3＋PP3，Z280→286','#b8d8c9')]:
    body+=rect(20,yy,45,hh0,col)+t(72,yy+4,label,3.2)
body+=note(15,246,['剖面为2倍示意；只有上方平面和隔片为1:1。','上罩仍需配G13/G20后防护，不能直接加平底撞滑块。'])
sheets.append(sheet(6,'POM支承、隔距与闸片层次',body))
for i,s in enumerate(sheets,1):(ROOT/f'template-{i:02}.svg').write_text(s)

def inline(s):
    s=html.escape(s)
    s=re.sub(r'\[([^\]]+)\]\(([^)]+)\)',r'<a href="\2">\1</a>',s)
    s=re.sub(r'\*\*(.+?)\*\*',r'<strong>\1</strong>',s)
    return re.sub(r'`([^`]+)`',r'<code>\1</code>',s)

def markdown(source):
    lines=source.splitlines();out=[];i=0
    while i<len(lines):
        s=lines[i]
        if not s.strip():i+=1;continue
        if s.startswith('#'):
            level=len(s)-len(s.lstrip('#'));out.append(f'<h{level}>{inline(s[level:].strip())}</h{level}>');i+=1;continue
        if s.startswith('|'):
            rows=[]
            while i<len(lines) and lines[i].startswith('|'):
                row=[v.strip() for v in lines[i].strip('|').split('|')]
                if not all(re.fullmatch(r'[:\- ]+',c) for c in row):rows.append(row)
                i+=1
            out.append('<div class="scroll"><table>')
            for n,row in enumerate(rows):
                tag='th' if n==0 else 'td';out.append('<tr>'+''.join(f'<{tag}>{inline(v)}</{tag}>' for v in row)+'</tr>')
            out.append('</table></div>');continue
        m=re.match(r'^(?:- |\d+\. )(.*)',s)
        if m:
            ordered=not s.startswith('- ');tag='ol' if ordered else 'ul';out.append('<'+tag+'>')
            while i<len(lines) and (m:=re.match(r'^(?:- |\d+\. )(.*)',lines[i])):
                out.append('<li>'+inline(m[1])+'</li>');i+=1
            out.append('</'+tag+'>');continue
        out.append('<p>'+inline(s)+'</p>');i+=1
    return '\n'.join(out)

# Explanatory section and exploded layer view. Coordinates/dimensions come from the shared geometry.
def poly(points,fill,stroke='#243e36'):
    return '<polygon points="'+' '.join(f'{x},{y}' for x,y in points)+f'" fill="{fill}" stroke="{stroke}" stroke-width="1.5"/>'
def iso_pt(x,y,z):return (780+1.8*x+.85*y,730+.33*x-.55*y-z)
def slab(z,width,depth,x0=0,y0=0,fill='#d8ebe2',holes=False,label=''):
    xy=lambda x,y:iso_pt(x,y,z)
    a=poly([xy(x0,y0),xy(x0+width,y0),xy(x0+width,y0+depth),xy(x0,y0+depth)],fill)
    if holes:
        for xx in [29,46,63,80,97]:a+=poly([xy(xx,9),xy(xx+14,9),xy(xx+14,21),xy(xx,21)],'#fffefa')
    if label:
        px,py=xy(x0+width,y0+depth/2);a+=ln(px+5,py,1100,py)+t(1110,py+5,label,16)
    return a
v=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1400 900"><style>text{font-family:system-ui,"PingFang SC",sans-serif}</style><rect width="1400" height="900" fill="#fffefa"/>',t(35,45,'料斗接到五槽：左看豆路，右看闸片夹在哪两层之间',28),t(35,80,'解释图：右侧层间距已拉开，按文字尺寸制作，不量图下料。',18)]
# Front section through one channel: widths in X, vertical heights share a scale of 2.4.
cx=335;zz=lambda z:760-(z-280)*3.3
v+=[t(45,125,'A / 正视剖面：主斗 → 小过渡 → 五槽',22)]
for dx in [-1,1]:v.append(ln(cx+dx*68*2.6,zz(440),cx+dx*55*2.6,zz(330),'#527b6a'))
v+=[ln(cx-68*2.6,zz(440),cx+68*2.6,zz(440)),rect(cx-79*2.6,zz(442),158*2.6,6.6,'none'),rect(cx-62*2.6,zz(330),124*2.6,9.9,'#d8ebe2')]
for dx in [-1,1]:v.append(ln(cx+dx*55*2.6,zz(327),cx+dx*41*2.6,zz(298.3),'#527b6a'))
v+=[rect(cx-70*2.6,zz(298.3),140*2.6,6*3.3,'#d8ebe2'),rect(cx-70*2.6,zz(290),140*2.6,4*3.3,'#bcced1'),rect(cx-70*2.6,zz(286),140*2.6,6*3.3,'#d8ebe2')]
for xx in [-41,-24,-7,10,27]:
    v.append(rect(cx+xx*2.6,zz(298.3),14*2.6,18.3*3.3,'#fffefa'))
v+=[ln(cx-55*2.6,zz(291),cx+55*2.6,zz(291),'#b3753b'),t(45,820,'主斗110高；下方模块50高；主斗顶Z440、槽底Z280。',17),t(45,850,'槽孔全都贯通；豆路内的3mm筋不跨过闸片缝。',17),t(185,260,'主斗：PP-H 2mm',20),t(220,290,'上136方 / 下110×30',18),t(200,zz(313),'小过渡斗：高28.7',17)]
# Upper and lower plates are separated for understanding; local windows align after assembly.
v += [t(755,125,'B / 从上到下叠装',22),slab(520,140,30,holes=True,label='U2：PP3，140×30'),slab(440,140,30,holes=True,label='U1：PP3，140×30'),slab(335,110,45,x0=15,y0=7.5,fill='#e9c69a',label='G07：闸片110×45×2'),slab(225,140,30,fill='#bcced1',holes=True,label='G12：POM4，140×30')]
# Lower plate windows have Y3..15, translated here to match same whole-machine aperture.
for z,label in [(140,'L2：PP3，140×18'),(65,'L1：PP3，140×18')]:
    v.append(slab(z,140,18,y0=6,holes=True,label=label))
v+=[t(760,810,'装回后U1底与POM顶间名义2.3；闸片厚2，余量约0.3。',17),t(760,840,'隔距件装在两侧翼，不穿闸片；五窗均14×12、筋3。',17),t(760,870,'小过渡斗焊到U2，冷却校平后才组装；POM不与PP焊。',17),'</svg>']
(ROOT/'hopper-stack-v4.7.svg').write_text(''.join(v).replace('stroke-width=".3"','stroke-width="1.4"'))

css='''body{margin:0;background:#f1f2ed;color:#243e36;font:16px/1.8 system-ui,-apple-system,"PingFang SC",sans-serif}main{max-width:1200px;margin:auto;padding:30px 22px}h1{font-size:32px;line-height:1.3}h2{margin-top:40px;border-top:1px solid #ccd7cf;padding-top:20px}h3{margin-top:25px}a{color:#087857}p,li{max-width:1050px}li{margin:9px 0}table{border-collapse:collapse;min-width:680px;width:100%;font-size:14px}td,th{padding:9px;border:1px solid #ccd7cf;text-align:left}th{background:#e3eee4}.scroll{overflow:auto}.sheet{background:white;margin:25px auto;border:1px solid #ccd7cf;max-width:794px}.sheet svg{display:block;width:100%;height:auto}button{font:inherit;padding:10px 20px;background:#087857;border:0;border-radius:5px;color:white;cursor:pointer}.hero{width:100%;height:auto}.badge{padding:14px 18px;background:#fff9e8;border-left:4px solid #ba7740}@page{size:A4 portrait;margin:0}@media print{.no-print{display:none!important}body,main{margin:0;padding:0;background:white}.sheet{width:210mm;height:297mm;margin:0;border:0;break-after:page;max-width:none}.sheet:last-child{break-after:auto}.sheet svg{width:210mm;height:297mm}}'''
md=markdown((ROOT/'README.md').read_text())
page=f'''<!doctype html><html lang="zh-CN"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="data:,"><title>BeanLens V4.7 PP料斗与五槽制作</title><style>{css}</style></head><body><main><div class="no-print"><div class="badge">先做纸样和废料焊接练习。模板控制内面几何；板厚、坡口、后防护及最终固定孔须实物试配。</div><img class="hero" src="../frame-v4.6/black-frame-comparison-v4.6.svg" alt="三面木板延伸、型材外露的内嵌面板方案">{md}<h2>料斗剖面与五槽分层图</h2><img class="hero" src="hopper-stack-v4.7.svg" alt="料斗豆路剖面与上五窗板、闸片、POM支承、下五窗板的分层关系"><h2>已买600方板时的替代排版</h2><img class="hero" src="wood-alternative-v4.7.svg" alt="两张600方海洋板的备选排版"><p><a href="wood-layout-options-v4.7.csv">下载两种木料排版坐标CSV</a></p><button onclick="window.print()">打印六页A4控制模板（100%）</button><h2>原尺寸模板预览</h2></div>'''
page+=''.join(f'<section class="sheet" id="template{i}">{s}</section>' for i,s in enumerate(sheets,1))+'</main></body></html>'
(ROOT/'beanlens-fabrication-v4.7.html').write_text(page)
(ROOT/'fabrication-dimensions-v4.7.json').write_text(json.dumps(dict(date='2026-10-16',revision='V4.7',main_top_mm=top,main_bottom_mm=[110,30],main_height_mm=110,front_back_slant_mm=A,left_right_slant_mm=B,transition_slants_mm=[C,D],pp_plate_mm=2,templates_are_inner_surface_control_not_finished_bevel_patterns=True),indent=2)+'\n')
print(f'Generated 6 A4 1:1 control templates; main slants {A:.3f}/{B:.3f}; transition {C:.3f}/{D:.3f}.')
