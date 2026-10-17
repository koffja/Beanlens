"""V4.8 exact normal-thickness PP shell wedges, A4 templates and illustrated guide.
The wedge/STL geometry includes symmetric miters and horizontal end trims;
welding shrinkage and as-built fit remain coupon/fixture verification steps.
"""
import csv,html,json,math,re
from pathlib import Path
ROOT=Path(__file__).resolve().parent
D=json.loads((ROOT.parent/'assembly-v4.8/design-v4.8.json').read_text())
G=D['pp_geometry'];N=8
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


def text(x,y,s,size=3.4,color='#243e36',anchor='start'):
 return f'<text x="{x:.3f}" y="{y:.3f}" font-size="{size}" fill="{color}" text-anchor="{anchor}">{html.escape(str(s))}</text>'
def line(x,y,xx,yy,color='#243e36',dash=False,width=.3):
 return f'<path d="M{x:.4f},{y:.4f}L{xx:.4f},{yy:.4f}" stroke="{color}" stroke-width="{width}" fill="none"'+(' stroke-dasharray="1.5 1"' if dash else '')+'/>'
def rect(x,y,w,h,fill='none',stroke='#243e36'):
 return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" fill="{fill}" stroke="{stroke}" stroke-width=".3"/>'
def dim(x,y,xx,yy,s):return line(x,y,xx,yy,'#ae6435')+text((x+xx)/2,(y+yy)/2-2,s,3.2,'#ae6435','middle')
def notes(x,y,items):return ''.join(text(x,y+5*i,s,3.2) for i,s in enumerate(items))
def sheet(i,title,body):
 return f'<svg xmlns="http://www.w3.org/2000/svg" width="210mm" height="297mm" viewBox="0 0 210 297"><style>text{{font-family:Arial,"PingFang SC",sans-serif}}</style><rect width="210" height="297" fill="white"/>{text(12,12,"BEANLENS / V4.8 / 2026-10-16",3)}{text(12,23,title,5.2)}{text(12,31,"尺寸单位mm；原尺寸模板；粗坯修边/角度/首样试焊仍需检查。",3.1)}{body}{line(20,279,120,279)}{line(20,277,20,281)}{line(120,277,120,281)}{text(70,277,"100mm校验线：实际大小打印，不适合页面",3,anchor="middle")}{text(12,290,"V4.7内面模板已过时，本版已计2mm法向板厚。",3)}{text(198,290,f"{i}/{N}",3,anchor="end")}</svg>'
def trap(x,y,top,bottom,h,dash=False):
 off=(top-bottom)/2
 return f'<polygon points="{x},{y} {x+top},{y} {x+off+bottom},{y+h} {x+off},{y+h}" fill="'+('none' if dash else '#e8f1eb')+'" stroke="'+('#387ca4' if dash else '#243e36')+'" stroke-width=".35"'+(' stroke-dasharray="1.5 1"' if dash else '')+'/>'
# Conservative rectangular stock nesting, with 8mm space around most PP2 blanks.
stock=[]
def stockpart(id,sheet,x,y,w,h):stock.append(dict(id=id,sheet=sheet,xy_mm=[x,y],size_mm=[w,h]))
g=G['main'];a=g['outer_top'][0];b=g['outer_top'][1];ah=g['front_slant'];bh=g['side_slant']
stockpart('A1','PP2-A',3,3,a,ah);stockpart('A2','PP2-A',3+a+8,3,a,ah)
stockpart('B1','PP2-A',3,3+ah+8,b,bh);stockpart('B2','PP2-A',3+b+8,3+ah+8,b,bh)
g=G['transition'];stockpart('C1','PP2-A',300,3,g['outer_top'][0],g['front_slant']);stockpart('C2','PP2-A',300,37.477,g['outer_top'][0],g['front_slant'])
stockpart('D1','PP2-A',300,72,g['outer_top'][1],g['side_slant']);stockpart('D2','PP2-A',342.254,72,g['outer_top'][1],g['side_slant'])
stockpart('LID optional','PP2-B',3,3,172,192)
for id,x,y,w,h in [('RIM',3,3,176,196),('U1',3,207,140,30),('U2',151,207,140,30),('L1',3,245,140,18),('L2',151,245,140,18),('FLANGE1',3,271,146,66),('FLANGE2',157,271,146,66),('C6 REAR',187,3,56,38)]:stockpart(id,'PP3',x,y,w,h)
stockpart('BOX FRONT','BLACK PP2',3,3,80,64);stockpart('C6 FRONT','BLACK PP2',91,3,56,38)
sizes={'PP2-A':[420,297],'PP2-B':[420,297],'PP3':[400,400],'BLACK PP2':[160,100]}
for p in stock:
 x,y=p['xy_mm'];w,h=p['size_mm'];sw,sh=sizes[p['sheet']];assert x>=3 and y>=3 and x+w<=sw-3 and y+h<=sh-3
for n,p in enumerate(stock):
 for q in stock[n+1:]:
  if p['sheet']!=q['sheet']:continue
  x,y=p['xy_mm'];w,h=p['size_mm'];xx,yy=q['xy_mm'];ww,hh=q['size_mm'];assert x+w+3<=xx or xx+ww+3<=x or y+h+3<=yy or yy+hh+3<=y
(ROOT/'flat-stock-v4.8.json').write_text(json.dumps(dict(sheet_sizes_mm=sizes,rectangular_blank_nesting=stock),indent=2)+'\n')
with (ROOT/'flat-stock-v4.8.csv').open('w',encoding='utf-8-sig',newline='') as f:
 w=csv.writer(f,lineterminator='\n');w.writerow(['板料','部件','排版X','排版Y','矩形包络宽','矩形包络高','说明'])
 for p in stock:w.writerow([p['sheet'],p['id'],*p['xy_mm'],*p['size_mm'],'净轮廓矩形包络；实际梯形/开孔看原尺寸模板，余料练习'])
v=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1400 1250"><style>text{font-family:system-ui,"PingFang SC",sans-serif}</style><rect width="1400" height="1250" fill="#fffefa"/>',text(35,45,'PP板料排版：两张A3 PP2＋一张400方PP3＋黑PP2小板',27)]
for name,ox,oy,sc in [('PP2-A',45,120,1.35),('PP2-B',750,120,1.35),('PP3',45,650,1.3),('BLACK PP2',800,750,2.3)]:
 sw,sh=sizes[name];v+=[text(ox,oy-20,f'{name}: {sw}×{sh}',21),rect(ox,oy,sw*sc,sh*sc,'#f7f1e5')]
 for p in stock:
  if p['sheet']!=name:continue
  x,y=p['xy_mm'];w,h=p['size_mm'];v+=[rect(ox+x*sc,oy+y*sc,w*sc,h*sc,'#d3e6db'),text(ox+x*sc+4,oy+y*sc+18,p['id'],13)]
v+=[text(800,1100,'框为保守矩形包络，模板给实际外轮廓。',18),text(800,1133,'PP2留较宽空隙供粗切修边；第二张余料练焊。',18),text(800,1166,'PP3法兰均来自同一张板，F14不重复买板。',18),text(800,1199,'黑色外框同用160×100一片，F16不重复买。',18),'</svg>']
(ROOT/'flat-stock-v4.8.svg').write_text(''.join(v))

# Eight solid wedge panels. All vertices share exact common miter faces, no overlap.
geometry=[]
def sub(a,b):return [a[i]-b[i] for i in range(3)]
def cross(a,b):return [a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]]
def dot(a,b):return sum(x*y for x,y in zip(a,b))
def export_wedge(g,side,id):
 bw,bd=g['bottom'];tw,td=g['top'];h=g['height'];dx=g['offset_x_mm'];dy=g['offset_y_mm']
 inside=([[-bw/2,-bd/2,0],[bw/2,-bd/2,0],[tw/2,-td/2,h],[-tw/2,-td/2,h]] if side=='front' else [[bw/2,-bd/2,0],[bw/2,bd/2,0],[tw/2,td/2,h],[tw/2,-td/2,h]])
 outside=([[-bw/2-dx,-bd/2-dy,0],[bw/2+dx,-bd/2-dy,0],[tw/2+dx,-td/2-dy,h],[-tw/2-dx,-td/2-dy,h]] if side=='front' else [[bw/2+dx,-bd/2-dy,0],[bw/2+dx,bd/2+dy,0],[tw/2+dx,td/2+dy,h],[tw/2+dx,-td/2-dy,h]])
 verts=inside+outside
 if id.endswith('2'):verts=[[-x,-y,z] for x,y,z in verts]
 center=[sum(v[i] for v in verts)/8 for i in range(3)];facets=[];signed=0
 for face in [[0,1,2,3],[4,5,6,7],[0,1,5,4],[1,2,6,5],[2,3,7,6],[3,0,4,7]]:
  for tri in [[face[0],face[1],face[2]],[face[0],face[2],face[3]]]:
   a,b,c=[verts[i] for i in tri];normal=cross(sub(b,a),sub(c,a));fc=[(a[i]+b[i]+c[i])/3-center[i] for i in range(3)]
   if dot(normal,fc)<0:b,c=c,b;normal=[-x for x in normal]
   norm=math.sqrt(dot(normal,normal));normal=[x/norm for x in normal];signed+=dot(a,cross(b,c))/6
   facets.append(' facet normal '+' '.join(f'{n:.10g}' for n in normal)+'\n  outer loop\n'+''.join('   vertex '+' '.join(f'{n:.10g}' for n in v)+'\n' for v in [a,b,c])+'  endloop\n endfacet\n')
 (ROOT/f'{id}.stl').write_text('solid '+id+'\n'+''.join(facets)+'endsolid '+id+'\n')
 geometry.append({'id':id,'vertices_mm':verts,'normal_thickness_mm':2,'volume_mm3':signed,'note':'Nominal mitered solid; no weld beads, shrinkage or manufacturing tolerance in STL. Units mm.'})
for name,prefix in [('main','M'),('transition','T')]:
 for side,letter in [('front','A'),('side','B')]:
  for i in [1,2]:export_wedge(G[name],side,prefix+letter+str(i))
# Exact shell volume is area integral (rectangles vary independently, not similar frusta).
for name,prefix in [('main','M'),('transition','T')]:
 g=G[name];bw,bd=g['bottom'];tw,td=g['top'];dx,dy=g['offset_x_mm'],g['offset_y_mm'];h=g['height']
 expected=h*(2*dx*(bd+td)/2+2*dy*(bw+tw)/2+4*dx*dy)
 actual=sum(v['volume_mm3'] for v in geometry if v['id'].startswith(prefix));assert abs(actual-expected)<1e-6,(name,actual,expected)
(ROOT/'pp-panel-solids-v4.8.json').write_text(json.dumps({'revision':'V4.8','panels':geometry,'parameters':G},ensure_ascii=False,indent=2)+'\n')
with (ROOT/'pp-cuts-v4.8.csv').open('w',encoding='utf-8-sig',newline='') as f:
 w=csv.writer(f,lineterminator='\n');w.writerow(['组','片型','数量','法向厚mm','外面上宽mm','外面下宽mm','外面斜高mm','内面上宽mm','内面下宽mm','侧边离直切倒角度','上下端离直切倒角度','条件'])
 for name in ['main','transition']:
  g=G[name]
  for side,index in [('前后',0),('左右',1)]:
   w.writerow([name,side,2,2,g['outer_top'][index],g['outer_bottom'][index],g['front_slant' if index==0 else 'side_slant'],g['top'][index],g['bottom'][index],g['corner_bevel_from_square_deg'],g['end_bevel_front_deg' if index==0 else 'end_bevel_side_deg'],'最终名义外线；角部对称斜接，顶底端面水平；粗坯额外余量不计入成品'])
sheets=[]
for i,side in [(1,'front'),(2,'side')]:
 g=G['main'];j=0 if side=='front' else 1;top=g['outer_top'][j];bottom=g['outer_bottom'][j];h=g['front_slant' if j==0 else 'side_slant'];x=(210-top)/2;y=54
 # Blue guide is an orthogonal projection of the inner surface onto the outer drawing plane.
 shift=2*(g['ky'] if j==0 else g['kx']);off=(top-g['top'][j])/2
 b=trap(x,y,top,bottom,h)+trap(x+off,y+shift,g['top'][j],g['bottom'][j],h,True)
 b+=dim(x,y-7,x+top,y-7,f'{top:.3f} 外面上边')+dim(x+(top-bottom)/2,y+h+8,x+(top+bottom)/2,y+h+8,f'{bottom:.3f} 外面下边')
 b+=notes(14,202,[f'外面斜高{h:.3f}；两片；内面上{g["top"][j]} / 下{g["bottom"][j]}。','黑实线：外面实料轮廓；蓝虚线：内面法向投影。','蓝线是理解板厚用，不是第二条裁切边；不能直接照蓝线切。',f'两斜边离直切倒角{g["corner_bevel_from_square_deg"]:.3f}°（非统一45°）。',f'上下端离直切修{g["end_bevel_front_deg" if j==0 else "end_bevel_side_deg"]:.3f}°，装配后端面水平。','先粗切留1–2mm，再按夹具/端面修到黑线尺寸。','接缝目标0–0.2；主要外焊，内部检查熔合并修平。','外焊筋法向≤3，净空按水平4mm储备；超出需重核。'])
 sheets.append(sheet(i,('A 主斗前/后' if j==0 else 'B 主斗左/右')+'：外面实料1:1',b))
g=G['transition'];b=''
for index,y in [(0,55),(0,110),(1,176)]:
 top=g['outer_top'][index];bot=g['outer_bottom'][index];h=g['front_slant' if index==0 else 'side_slant']
 for x in ([20,135] if index else [(210-top)/2]):
  b+=trap(x,y,top,bot,h)+text(x+top/2,y+h/2,('C' if index==0 else 'D')+f' 外上{top:.3f}',3.1,anchor='middle')
b+=notes(12,231,[f'C外斜高{g["front_slant"]:.3f}；D外斜高{g["side_slant"]:.3f}，各两片。',f'侧边倒角{g["corner_bevel_from_square_deg"]:.3f}°；端部C {g["end_bevel_front_deg"]:.3f}° / D {g["end_bevel_side_deg"]:.3f}°。','内口110×30→82×12；垂直高24.9，不能用旧28.7模板。','黑线只控制外面；端面和斜接须先试夹，STL含完整名义实体。'])
sheets.append(sheet(3,'C/D 小过渡斗：2mm实料外面',b))
b=rect(17,41,176,196,'#e8f1eb')+rect(37,71,136,136,'white')+text(105,120,'PP3：176×196，孔136方',4,anchor='middle')
# Ring global hole center110/120, flange origin22/22 -> local aperture22/30.
b=rect(17,41,176,196,'#e8f1eb')+rect(37,71,136,136,'white')+text(105,120,'PP3：176×196，孔136方',4,anchor='middle')
for x in [17+6.5,17+169.5]:
 for y in [41+63,41+133]:b+=f'<g transform="rotate({math.degrees(math.atan2(y-139,x-105))} {x} {y})">'+rect(x-3.5,y-1.75,7,3.5,'none','#b36f3b')+'</g>'
for xx in [17,191]:
 for yy in [94,164]:b+=f'<rect x="{xx}" y="{yy}" width="2" height="20" fill="none" stroke="#ae6435" stroke-width=".25" stroke-dasharray="1 1"/>'
b+=notes(12,245,['槽孔3.5×7径向；金属脚圆孔3.5，脚顶Z440。','孔中心全局X28.5/191.5、Y85/155；法兰顶443。','橙虚线带仅底面2×2倒角避角铝根R，不切穿。','25×25×2角铝修竖外脚22/横14，宽20，先试配。'])
sheets.append(sheet(4,'顶部承托法兰：PP3 / 1:1',b))
b=''
for n,y in enumerate([40,112,184]):
 b+=rect(32,y,146,66,'#e8f1eb')+rect(50,y+18,110,30,'white')
 for xx in [38,172]:
  for yy in [y+6,y+60]:b+=f'<circle cx="{xx}" cy="{yy}" r="1.7" fill="none" stroke="#ae6435" stroke-width=".3"/>'
 b+=text(105,y+34,['上法兰 PP3','下法兰 PP3','食品接触硅胶：自由厚1mm'][n],3.3,anchor='middle')
b+=notes(12,258,['孔Ø3.4候选：距边6；4×M3×16，不能顶住豆路。','1mm硅胶名义压到0.8；限压0.5+0.3，实物复核。','两法兰6＋密封0.8＋过渡24.9＋五窗18.3＝50。'])
sheets.append(sheet(5,'可拆双法兰与密封圈：1:1',b))
def comb(x,y,dep,off):
 b=rect(x,y,140,dep,'#e8f1eb')
 for xx in [29,46,63,80,97]:b+=rect(x+xx,y+off,14,12,'white')
 for xx in [7.5,132.5]:b+=f'<circle cx="{x+xx}" cy="{y+dep/2}" r="1.6" fill="none" stroke="#ae6435" stroke-width=".3" stroke-dasharray="1 1"/>'
 return b
b=comb(35,65,30,9)+text(105,58,'U1/U2：PP3，140×30，做两片',3.5,anchor='middle')+comb(35,170,18,3)+text(105,162,'L1/L2：PP3，140×18，做两片',3.5,anchor='middle')
b+=notes(12,218,['每窗14×12，筋3；X29/46/63/80/97。','上窗Y9，下窗Y3；装后全在全局Y114→126。','小斗先焊U2，完全冷却校平再叠装；不在闸片旁热焊。','红孔是候选，先量隔距与滑闸路径；做单槽再扩五槽。'])
sheets.append(sheet(6,'五窗叠片：PP3 / 1:1',b))
b=comb(35,70,30,9)+text(105,60,'POM4：140×30，仅一片，不焊PP',3.5,anchor='middle')+rect(50,150,10,30,'#e8f1eb')+rect(150,150,10,30,'#e8f1eb')
b+=notes(12,210,['闸片110×45×2位于两侧隔距件之间；行程15。','名义缝2.3＝闸片2＋总余量0.3，按实测厚调。','隔距10×30×2两条＋0.3薄垫，放局部X0–10/130–140。','螺钉不穿闸片；手推不卡再接舵机；防护未冻结先不带豆。'])
sheets.append(sheet(7,'POM支承与隔距：1:1',b))
b=rect(30,55,80,64,'#e8f1eb')+rect(39.5,65,61,44,'white')+text(130,76,'前框80×64×2',3.6)+text(130,84,'框视窗61×44候选',3.2)+text(130,92,'木板过件65.3×48.6',3.2)
b+=rect(45,165,56,38,'#e8f1eb')+rect(53,172,40,24,'white')+text(118,177,'侧面木板过件孔40×24',3.3)+text(118,185,'外框56×38，孔先实配',3.3)
b+=notes(12,228,['前孔原点整机X77.35/Z345.7；主屏朝前。','侧孔原点整机Y68.185/Z348.16；小屏朝右，长边沿Y。','侧压框视窗33.4×18.4是候选，按有效区实物找正。','C6 M2参考孔距13.08×32；原图2.5H，不盲用M3。','这页不替代厂家孔位基准；先做纸面罩，不直接批量钻孔。'])
sheets.append(sheet(8,'双屏框/过件孔：装配参考1:1',b))
for i,s in enumerate(sheets,1):(ROOT/f'template-{i:02d}.svg').write_text(s)
# Perpendicular-to-corner section, showing the actual finite-thickness miter.
phi=math.radians(G['main']['corner_internal_deg']);half=phi/2;scale=12;ox,oy=420,320
pt=lambda x,y:(ox+x*scale,oy-y*scale)
def polyd(pts,color):return '<polygon points="'+' '.join(f'{x:.2f},{y:.2f}' for x,y in pts)+f'" fill="{color}" stroke="#243e36" stroke-width="1.5"/>'
section=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 650"><style>text{font-family:system-ui,"PingFang SC",sans-serif}</style><rect width="1200" height="650" fill="#fffefa"/>',text(35,48,'主斗斜接接缝：垂直于斜边的剖面',28),text(35,84,'解释放大图；不量图加工；两侧PP均为2mm法向厚度。',18)]
outer=(0,-2/math.sin(half))
for sign in [-1,1]:
 d=(sign*math.sin(half),math.cos(half));n=(sign*math.cos(half),-math.sin(half));end=(23*d[0],23*d[1]);endout=(end[0]+2*n[0],end[1]+2*n[1]);section.append(polyd([pt(0,0),pt(*end),pt(*endout),pt(*outer)],'#b7d8cc'))
a=pt(-3*math.sin(half),outer[1]+3*math.cos(half));b=pt(3*math.sin(half),outer[1]+3*math.cos(half));c=pt(0,outer[1]-2.2)
section+=[f'<path d="M{a[0]},{a[1]} Q{c[0]},{c[1]+20} {b[0]},{b[1]} L{pt(*outer)[0]},{pt(*outer)[1]}Z" fill="#d99458" stroke="#a56835" stroke-width="1.5"/>',line(*pt(0,0),*pt(*outer),'#795c42',True,1.5),text(420,190,'豆路内侧',23,anchor='middle'),text(720,230,'内侧接边应贴合',20),text(720,265,'接缝0–0.2mm是试样目标',18),text(720,305,'根部必须熔合；需要时内侧补细焊',18),text(720,340,'冷却后检查、修平挂豆台阶',18),line(430,320,700,320,width=1.3),text(420,440,'外侧主焊缝',22,'#a56835','middle'),line(420,385,420,411,'#a56835',False,1.5),text(420,475,'外焊筋法向≤3是净空上限，需试焊确认强度',18,anchor='middle'),text(45,540,f'主斗内夹角{G["main"]["corner_internal_deg"]:.3f}°；两片侧边各离直切倒角43.540°，不统一削45°。',20),text(45,580,'上下端还需单独修成水平面：前后25.726°、左右6.740°（均为离直切角）。',19),text(45,617,'尺寸包含名义板厚；实际热收缩、焊接变形须在定位框/试件上量，不用随意多加1mm代替。',18),'</svg>']
(ROOT/'joint-detail-v4.8.svg').write_text(''.join(section))
guide=markdown((ROOT/'README.md').read_text())
guide=guide.replace('<h2>4. 焊在外侧吗？具体怎样焊</h2>','<h2>4. 焊在外侧吗？具体怎样焊</h2><img class="hero" src="joint-detail-v4.8.svg" alt="2mmPP板斜接、外焊筋及内侧熔合剖面">')
css='''body{margin:0;background:#eef2ef;color:#243e36;font:16px/1.8 system-ui,-apple-system,"PingFang SC",sans-serif}main{max-width:1200px;margin:auto;padding:30px 22px}h1{font-size:32px;line-height:1.3}h2{margin-top:40px;border-top:1px solid #ccd7cf;padding-top:20px}a{color:#087857}li{margin:9px 0}table{border-collapse:collapse;min-width:700px;width:100%;font-size:14px}td,th{padding:9px;border:1px solid #ccd7cf;text-align:left}th{background:#e3eee4}.scroll{overflow:auto}.sheet{background:white;margin:25px auto;border:1px solid #ccd7cf;max-width:794px}.sheet svg{display:block;width:100%;height:auto}button{font:inherit;padding:10px 20px;background:#087857;border:0;color:white}.hero{width:100%;height:auto}.badge{padding:16px;background:#fff5df;border-left:4px solid #b67b43}@page{size:A4 portrait;margin:0}@media print{.no-print{display:none!important}body,main{margin:0;padding:0;background:white}.sheet{width:210mm;height:297mm;margin:0;border:0;break-after:page;max-width:none}.sheet:last-child{break-after:auto}.sheet svg{width:210mm;height:297mm}}'''
page=f'<!doctype html><html lang="zh-CN"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="data:,"><title>BeanLens V4.8 PP实料斜接与双屏净空</title><style>{css}</style></head><body><main><div class="no-print"><div class="badge">V4.8：内面尺寸、外面实料、法向板厚、斜接角和焊筋分别列出。旧V4.7模板不混用。</div>{guide}<h2>板料排版</h2><img class="hero" src="flat-stock-v4.8.svg" alt="PP2、PP3和黑色压框板料矩形排版"><h2>双屏净空切面</h2><img class="hero" src="../assembly-v4.8/09-clearance.svg" alt="主屏与侧屏接线腔到PP含焊筋包络的距离"><h2>完整装配中的双屏</h2><img class="hero" src="../assembly-v4.8/08-displays.svg" alt="BOX前主屏和C6右侧小屏分解装配"><button onclick="window.print()">打印8页A4模板，实际大小</button><h2>模板预览</h2></div>'
page+=''.join('<section class="sheet">'+s+'</section>' for s in sheets)+'</main></body></html>'
(ROOT/'beanlens-fabrication-v4.8.html').write_text(page)
print('Generated 8 A4 templates and 8 closed miter-panel STL solids; normal thickness/volume checked.')
