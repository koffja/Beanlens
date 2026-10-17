"""Dimensioned vector assembly sheets and an offline explorable parts viewer.

All dimensions are project design references or explicitly marked layout proposals.
This generator does not touch firmware, training data or vendor originals.
"""
from pathlib import Path
import json, math, html, csv

ROOT = Path(__file__).resolve().parent
BOM = json.loads((ROOT.parent/'procurement-v4.11/beanlens-bom-v4.11.json').read_text())
FRAME = json.loads((ROOT.parent/'assembly-v4.8/design-v4.8.json').read_text())
HOPPER = FRAME['hopper_reference']
hx,hy,hz=HOPPER['pos_mm'];hw,hd,hh=HOPPER['outer_mm'];wall=HOPPER['wall_mm']
C = {'ink':'#223d38','muted':'#62736e','line':'#b8c7c1','alu':'#b8c8d0','frame':'#30353b','wood':'#d5b58a','pp':'#69b6a0','blue':'#6b9abb','orange':'#cb8351','ghost':'#e8eeeb'}
def esc(x): return html.escape(str(x),quote=True)
def text(x,y,s,size=17,fill=None,anchor='start',bold=False):
    return f'<text x="{x:.2f}" y="{y:.2f}" font-size="{size}" fill="{fill or C["ink"]}" text-anchor="{anchor}" font-weight="{650 if bold else 400}">{esc(s)}</text>'
def lines(x,y,ss,size=17,step=27,fill=None):return ''.join(text(x,y+i*step,s,size,fill) for i,s in enumerate(ss))
def line(x1,y1,x2,y2,color=None,dash=False,width=1.5):return f'<path d="M{x1:.2f},{y1:.2f} L{x2:.2f},{y2:.2f}" fill="none" stroke="{color or C["line"]}" stroke-width="{width}"'+(' stroke-dasharray="6 5"' if dash else '')+'/>'
def rect(x,y,w,h,fill='none',stroke=None,rx=0):return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" stroke="{stroke or C["ink"]}" stroke-width="1.3"/>'
def circle(x,y,r=5,fill='white'):return f'<circle cx="{x}" cy="{y}" r="{r}" fill="{fill}" stroke="{C["ink"]}" stroke-width="1.3"/>'
def poly(pts,fill,opacity=1):return f'<polygon points="'+ ' '.join(f'{x:.2f},{y:.2f}' for x,y in pts)+f'" fill="{fill}" fill-opacity="{opacity}" stroke="{C["ink"]}" stroke-width="1.15" stroke-linejoin="round"/>'
def dim(x1,y1,x2,y2,label,dy=0):
    dx=x2-x1; yy=y2-y1; n=math.hypot(dx,yy); nx=-yy/n*5;ny=dx/n*5
    return line(x1,y1,x2,y2,C['orange'])+line(x1-nx,y1-ny,x1+nx,y1+ny,C['orange'])+line(x2-nx,y2-ny,x2+nx,y2+ny,C['orange'])+text((x1+x2)/2,(y1+y2)/2-8+dy,label,16,C['orange'],'middle',True)
def table(x,y,width,heads,rows,colwidths=None,rowh=31,size=15):
    cols=colwidths or [width/len(heads)]*len(heads);out=rect(x,y,width,rowh,'#edf3ef',C['line'])
    for i,h in enumerate(heads):out+=text(x+sum(cols[:i])+9,y+22,h,size,bold=True)
    for r,row in enumerate(rows):
        yy=y+(r+1)*rowh;out+=line(x,yy,x+width,yy)
        for i,val in enumerate(row):out+=text(x+sum(cols[:i])+9,yy+22,val,size)
    return out+line(x,y+(len(rows)+1)*rowh,x+width,y+(len(rows)+1)*rowh)
def sheet(title,subtitle,content,num):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="1400" height="960" viewBox="0 0 1400 960" role="img" aria-label="{esc(title)}"><style>text{{font-family:Arial,"PingFang SC","Microsoft YaHei",sans-serif}}.pick{{cursor:pointer}}.pick:hover polygon{{stroke:#00876b;stroke-width:3}}</style><rect width="1400" height="960" fill="#fffefa"/>{text(32,34,'BEANLENS  /  ASSEMBLY V4.12 /  2026-10-17',13,C['muted'],bold=True)}{text(32,77,title,30,bold=True)}{text(32,108,subtitle,16,C['muted'])}{line(32,127,1368,127)}{content}{line(32,916,1368,916)}{text(32,942,'单位 mm · 尺寸为设计/布局提案，非孔位加工图；未知元件只画安装占位。按标注尺寸，不量屏幕或缩印图。',13,C['muted'])}{text(1368,942,f'{num:02d} / 12',13,C['muted'],'end')}</svg>'''

parts=[]
def part(id,bom,name,pos,size,color,group,explode=(0,0,0),note='',status='设计尺寸',shape='box'):
    p=dict(id=id,bom=bom,name=name,pos=list(pos),size=list(size),color=C.get(color,color),group=group,explode=list(explode),note=note,status=status,shape=shape);parts.append(p);return p
# X right, Y rear, Z up; frame underside is Z=0, front is Y=0.
for i, fp in enumerate(FRAME['parts'], 1):
    x,y,z=fp['pos_mm']; size=fp['size_mm']
    if size[2] == 460: explode=((x-100)*.35,(y-110)*.35,30)
    elif z in [0,440]: explode=((x-100)*.25,(y-110)*.25,100 if z else -45)
    else: explode=((x-100)*.25,(y-110)*.3,25 if z==304 else -10)
    note='黑色欧标2020；端部抵接，不加方块节点。'
    if z==304: note+='中框顶Z324；前后梁与柱面齐，木斗/木托耳已取消。'
    if z==221.25: note+='前后相机独立梁；光轴Z241.25不是PCB孔高。'
    part(f'T{i:02}','F01',str(fp['length_mm'])+fp['name'],fp['pos_mm'],size,'frame','骨架',explode,note,'V4.6布局提案')
for pn in FRAME['enclosure_reference']['panels']:
    x,y,z=pn['pos'];ex=(-170 if x<10 else 170 if x>200 else 0, -150 if y<10 else 180 if y>220 else 0,0)
    part(pn['id'],'F03 / F11',pn['name'],pn['pos'],pn['size'],'wood','海洋板',ex,note='内嵌：板面内凹约1，边缝约2；角码+隔距背托，先做角样。',status='V4.8裁切提案')
# Self-supporting PP hopper; four metal brackets carry the top flange.
part('H07','F04','PP2主斗（已计板厚斜接）',(42,52,330),(136,136,110),'pp','送料',(0,0,220),shape='hopper',note='内口136方→110×30；外口/斜接见V4.8双面模板。无外侧木壳。')
part('H08','F05','PP2小过渡斗',(55,105,298.3),(110,30,24.9),'pp','送料',(0,0,85),shape='transition',note='高24.9；上Z323.2接下法兰；下Z298.3焊U2。')
p=part('H09','F04 / F13','PP3顶部承托法兰',(22,22,440),(176,196,3),'pp','送料',(0,0,150),shape='ring',note='136方孔；四金属托片支承；孔3.5×7径向槽留膨胀，不能用螺钉硬拉歪。');p['inner_size']=[136,136]
for id,z,bom,label,th in [('H10',327,'F14','主斗侧PP3法兰',3),('H11',326.2,'F14','硅胶密封圈（1压至约0.8）',.8),('H12',323.2,'F14','过渡斗侧PP3法兰',3)]:
 p=part(id,bom,label,(37,87,z),(146,66,th),'pp','送料',(0,0,105+(z-323.2)*4),shape='ring',note='内孔110×30；4孔在X43/177、Y93/147；M3×16及0.8限压垫先试装。');p['inner_size']=[110,30]
for n,(x,y,right) in enumerate([(20,75,False),(20,145,False),(186,75,True),(186,145,True)],1):
 p=part('Q0'+str(n),'F13','顶框金属承托角片',(x,y,438),(14,20,22),'alu','送料',(-45 if x==20 else 45,0,80),shape='bracket',note='25×25×2角铝裁宽20，竖外脚22/横外脚14，顶到460；M5锁顶框内槽，水平脚承托Z440法兰。PP法兰支点底边2×2倒角避根部R，按供货图试配。');p['right']=right
part('D10','F17','可拆PP防尘盖',(24,24,443),(172,192,2),'pp','检修防护',(0,0,290),note='可选；只盖开口，不作为装豆承力件。')['opacity']=.18
for id,z in [('C01',292.3),('C02',295.3)]:
    p=part(id,'F05','上五窗PP3叠片',(40,105,z),(140,30,3),'pp','送料',(0,0,75+(z-292.3)*4),shape='support',note='五窗14×12，X29/46/63/80/97，Y9；上五窗，后部防护另做，孔位先纸样。');p['window_y']=9
for id,z in [('C03',280),('C04',283)]:
    part(id,'F05','下五窗PP3叠片',(40,111,z),(140,18,3),'pp','送料',(0,0,25+(z-280)*3),shape='support',note='五窗与上层对齐；Y3；底部出口Z280。')
part('G07','G07','2mm铝闸片',(55,112.5,290),(110,45,2),'alu','滑闸',(0,90,90),note='闭合位置；向后退15mm开闸。前缘在槽盒内。')
part('G08','G08','滑块转接板',(50,140.5,287),(120,30,3),'blue','滑闸',(0,140,85),note='转接板120×30×3，梁110长；本图轨距94提案。')
for id,x in [('G06L',58.5),('G06R',152.5)]:part(id,'G06','100导轨和长滑块',(x,132,277),(9,100,5.5),'alu','滑闸',(-25 if id.endswith('L') else 25,110,55),note='H10总高仅参考；槽盒/视锥/行程端余量需联调。',status='参考包络')
for id,x in [('G06LB',53),('G06RB',147)]:part(id,'G06','MGN9H长滑块',(x,135.55,282.5),(20,39.9,4.5),'blue','滑闸',(-25 if id=='G06LB' else 25,110,55),note='与同侧轨同一套，非另买滑块；总高/端余量按供货图。',status='参考包络')
part('G11','G11','共用导轨底座毛坯',(40,100,273),(140,140,4),'blue','滑闸',(0,180,45),note='毛坯不能整片装入；前部豆路与后部舵机处必须裁缺。',status='毛坯非最终轮廓',shape='base')
part('G12','G12','开五窗POM支承4mm',(40,105,286),(140,30,4),'pp','滑闸',(0,45,35),note='五通口对齐槽位；不是实心挡豆板。',shape='support')
part('A03','A03 / G01–G05 / G10 / G14','舵机与居中连杆',(100,190,261),(20,41,43),'orange','滑闸',(0,225,85),note='MG996R机身仅参考包络；输出轴/球心高及壳体扫掠未冻结。',status='参考占位',shape='servo')
part('R01','G01–G05 / G10','舵臂与双球头杆',(110,155.5,303),(16,74,2),'orange','滑闸',(0,225,85),note='示意闭合姿态：球心距60，曲柄16；安装高度未冻结。',status='传动示意',shape='link')
part('S01C','S01 / G18','关端限位预留',(183,135,287),(20,8,8),'orange','滑闸',(50,90,20),status='安装占位')
part('S01O','S01 / G18','开端限位预留',(183,185,287),(20,8,8),'orange','滑闸',(50,120,20),status='安装占位')
part('B01A','B01 / B13','前摄像头安装区',(90,20,221.25),(40,25,40),'blue','光学',(0,-110,0),note='40方载板毛坯；镜头端面Y45，距豆流75起试。',status='安装占位')
part('B01B','B01 / B13','后摄像头安装区',(90,195,221.25),(40,25,40),'blue','光学',(0,150,0),note='镜头端面Y195；PCB/镜头长度按实物。',status='安装占位')
for id,x,y in [('L1',24,62),('L2',182,62),('L3',24,170),('L4',182,170)]:part(id,'A05 / L02 / L03','竖灯带与铝槽',(x,y,205),(14,8,100),'orange','光学',((x-110)*.7,(y-120)*.5,0),note='100有效长、14×8候选；X24/182避开底座/叠片，向中心斜照。',status='参考包络')
part('PH01','PH01 / PH04','低压对射安装区',(20,113,272),(20,14,10),'blue','光学',(-70,0,0),note='光束中心Z277；另一头对称；支架孔位未定。',status='安装占位')
part('PH02','PH01 / PH04','对射接收安装区',(180,113,272),(20,14,10),'blue','光学',(70,0,0),status='安装占位')
part('O02','F07 / F11','前相机梁下遮光条',(22,1,197),(176,1,22),'#22282c','光学',(0,-80,0),note='不挡下方取盒口；黑PP窄条无需窄木条。')
part('O01','F07','遮光底板开通口',(20,20,194),(180,200,1),'pp','光学',(0,-35,-50),note='上表面Z195；中央130×50通口，不挡豆。',shape='opticalbase')
part('W06','W06','称台固定底板',(20,25,20),(180,190,4),'alu','称重',(-110,-70,-65),note='180×190×4；不计活动载荷，安装按称重件图。',status='毛坯')
part('W01','W01','HJ-AZ4称重组件预留',(75,75,24),(70,90,19),'ghost','称重',(-110,-70,-30),note='虚线为预留区域，不是HJ-AZ4实际尺寸；接口/高度待图纸。',status='未知外形',shape='placeholder')
part('W05','W05','活动称台板',(25,30,43),(170,180,2),'alu','称重',(-110,-70,5),note='目标台面Z45，组件高度确认后调整；不可连墙或滑轨。',status='毛坯/高度目标')
part('B12','B12','收豆盒占位',(30,30,45),(160,170,125),'pp','称重',(-110,-115,45),note='绘制125高；BOM上限130须复核净间隙、容积和活动重量。',status='尺寸上限占位',shape='bin')
part('A01','A01 / E02','K230D BOX整机含2.4主屏',(77.85,1,346.2),(64.3,15.4,47.6),'blue','双屏',(0,-180,25),note='整机64.3×47.6×15.4，不拆屏、不另买屏。面朝前；突出物/插头按D90服务腔核。',status='原厂外壳尺寸')
part('D01','E02','主屏显示面（BOX内置）',(85.6,.6,353.2),(48.8,.4,36.6),'#122a30','双屏',(0,-181,25),note='2.4英寸640×480；48.8×36.6是名义显示面示意，不用于开孔。',status='内置显示面示意')
p=part('D02','F15','主屏外压框',(70,-1,338),(80,2,64),'#263138','双屏',(0,-220,25),shape='displayframe',note='木板过件孔65.3×48.6；压框80×64×2、视窗61×44候选，不压触摸玻璃/按键。');p['opening']=[61,44]
p=part('D03','F06 / F15','BOX背部承托框毛坯',(70,20,338),(80,2,64),'alu','双屏',(0,-130,25),shape='displayframe',note='80×64×2内开68×52；四角软垫夹片/绝缘柱按原壳避接口，不能把此孔当厂家安装孔。');p['opening']=[68,52]
for n,(x,z) in enumerate([(74,342),(140,342),(74,390),(140,390)],11):
 part('D'+str(n),'F15','BOX壳角夹片＋软垫',(x,16.4,z),(6,3.6,8),'orange','双屏',((x-110)*.7,-110,25+(z-370)*.7),note='四角夹持原壳，软垫0.6接后壳边，夹片接D03；原壳突出物/接口按实物避开。',status='夹片候选包络')
part('D90','F15','主屏插头/排线服务腔',(70,7,338),(80,40,64),'orange','净空（非零件）',(0,-80,25),shape='outline',note='不是实体。到PP外壁+4焊筋储备，最小名义间距约17.1；不得挤排线。')
part('E01','E01','C6非Touch整机含1.47小屏',(211.4,70,350),(7.6,36.37,20.32),'blue','双屏',(180,0,25),note='原厂PCB20.32×36.37，包深7.6，不含全部插头/排针；屏朝右，长边沿Y。',status='原厂二维图参考')
part('D04','E01','侧屏显示面（C6内置）',(219,72,351.5),(.4,32.35,17.39),'#122a30','双屏',(181,0,25),note='1.47英寸172×320；横向显示需软件旋转，显示面位置先对照实物。',status='内置显示面示意')
p=part('D05','F16','侧屏外压框',(219,60.185,341.16),(2,56,38),'#263138','双屏',(225,0,25),shape='displayframe',note='外56×38×2；视窗33.4×18.4为起点，按LCD有效区找正；木板过件孔40×24。');p['opening']=[33.4,18.4]
p=part('D06','F05 / F16','C6绝缘PP后承托框',(205.4,60.185,341.16),(3,56,38),'pp','双屏',(150,0,25),shape='displayframe',note='PP3，56×38开26×10，M2参考孔距13.08×32；原图2.5H，螺钉啮合先量。非金属框；3mm隔柱配M2×8候选，有效进入不超过2，仍按原图/实物核。');p['opening']=[26,10]
part('D91','F16','侧屏接线与天线服务腔',(188,50,338),(25,85,47),'orange','净空（非零件）',(100,0,25),shape='outline',note='不是实体。到PP外壁+4焊筋储备，最小名义间距约10.5；天线净空按模块要求确认。')
part('BTN1','A16','开始按钮安装区',(67,-2,265),(16,18,16),'orange','电控',(0,-150,25),status='开孔按实物')
part('BTN2','A16','停止按钮安装区',(137,-2,265),(16,18,16),'orange','电控',(0,-150,25),status='开孔按实物')
part('G09','G09','闸片后加强角铝',(55,140.5,292),(110,10,10),'alu','滑闸',(0,130,125),shape='angle',note='110长10×10×2，单独列出；角脚贴闸片后部，不能与五窗上板重叠。')
part('G10','G10','居中球头连接耳占位',(100,155.5,295),(20,16,10),'orange','滑闸',(0,150,135),note='居中耳与G09固定；实际孔高与R01共面后冻结。',status='安装占位')
part('G20','G20','后退片罩/润滑隔离预留',(39,138,308),(142,78,1),'ghost','检修防护',(0,160,120),shape='outline',note='罩顶预留，非封闭罩最终零件；前端窄缝/侧封/清理路径待全行程纸样，不可据此带豆电动测试。',status='未完成的防护接口')
part('E03','F06 / A08 / A17 / P05 / P06','后电控托板',(30,207,50),(160,2,130),'blue','电控',(0,230,10),note='下部后方160×130×2托板；模块朝后厚度目标≤21mm，豆盒后留约7mm，按实物重排；适配器机外。',status='托板毛坯')

# V4.12 integration: current V4.11 source; frame, wood and screens retained.
D=json.loads((ROOT.parent/'revision-v4.11/design-v4.11.json').read_text())
g=D['hopper'];b=D['body'];br=D['brush']
parts[:]=[p for p in parts if p['id'] not in ['H08','H10','H11','H12','C01','C02','C03','C04','G12','E03']]
byid={p['id']:p for p in parts}
byid['H07'].update(name='四片连续PP2主斗',pos=[110-g['top_outer_wh_mm'][0]/2,120-g['top_outer_wh_mm'][1]/2,298.3],size=[*g['top_outer_wh_mm'],141.7],bottom_size=g['bottom_outer_wh_mm'],inner_top=[136,136],inner_bottom=[82,12],note='136方内口→82×12，Z298.3→440，高141.7；四壁连续焊接；无中间法兰/小过渡斗。')
byid['P01'].update(shape='panelwindow',opening=[65.3,48.6],opening_origin=[55.35,19.7])
byid['P04'].update(shape='panelwindow',opening=[40,24],opening_origin=[46.185,22.16])
byid['D90']['note']='非实体：主屏80×40×64服务腔，最高Z402；到连续PP外壁和4mm焊筋储备名义15.44。实物线缆另验。'
byid['D91']['note']='非实体：侧屏25×85×47服务腔，最高Z385；到连续PP外壁和4mm焊筋储备名义14.44。天线/接头另验。'
for id,x in [('PH01',20),('PH02',180)]:
 byid[id].update(name='SEN0503发射头占位' if id=='PH01' else 'SEN0503接收头占位',pos=[x,115,272.5],size=[20,10,9],note='DFRobot SEN0503，5V供电；20×10×9为原厂外形，图中轴向/中心并未核对。光束Z277暂定，支架孔/光孔偏置/侧封片避让须实物；不是尺寸加工依据。',status='光轴与安装朝向待核')
for id,name,pos,size,bom,dy,dz in [
 ('U01','PP6五窗上座',b['upper_xyz'],b['upper_pp_mm'],'F18',0,110),
 ('U02','PP10五窗下座',b['lower_xyz'],b['lower_pp_mm'],'G12',0,20)]:
 part(id,bom,name,pos,size,'pp','送料',(0,dy,dz),shape='support',note='五窗14×12，X69/86/103/120/137，Y114；与前/侧PP焊成固定U槽。')['window_y']=9
part('U03','F19','连续前壁封片',b['front_bridge_xyz'],b['front_bridge_pp_mm'],'pp','送料',(0,-60,60),note='PP2 140×18.3，跨过闸缝；闸片由后方插入前承接位，不向前推出豆。')
for n,pos in enumerate(b['side_cheek_xyz'],1):part('U0'+str(n+3),'F19','槽体侧封片',pos,b['side_cheek_pp_mm'],'pp','送料',((-50 if n==1 else 50),0,60),note='PP2 32×15.3，从Z283起；下方光电实际避让另核。')
for n,pos in enumerate(b['spacer_xyz'],1):part('G21'+str(n),'G21','闸缝隔距条',pos,b['spacers_pp_mm'],'pp','送料',((-40 if n==1 else 40),0,65),note='10×24×2.3；名义闸隙2.3配2mm闸片；冷却后量规和手推验收。')
for n,x in enumerate(br['divider_x_mm'],1):
 part('V0'+str(n),'B16','PP3五槽入口分道片',[x,105.2491178546,298.3],[3,br['divider_yz_face_mm']['top'],20],'pp','刷排',(0,0,120),shape='fin',note='YZ梯形上29.502/下12/高20，底焊上座肋；不是矩形堵豆片。')
for row,y in enumerate(br['root_y_mm']):
 for n,x in enumerate(br['x_centers_mm'],1):
  part(('BF' if row==0 else 'BR')+str(n),'B11','槽内PBT植毛小段',[x-6,y-1.5,312],[12,3,6],'orange','刷排',(0,-85 if row==0 else 85,150),note='每槽前后各1，共10；PP基条12×6×3，PBT毛长14/下倾30度，毛尖Z308，侵入1.5起试。基条与毛束均为放大示意。')
 for id,bom,name,pos,size in [
  ('BC','B14','PP3刷盒载条',[55,y-4,310],[110,3,10]),
  ('BP','B14','PP2刷盒压条',[55,y+2,311],[110,2,8]),
  ('BG','B15','可拆防豆背罩包络',[55,y-10,307],[110,20,16])]:
  part(id+str(row+1),bom,name,pos,size,'pp','刷排',(0,-110 if row==0 else 110,150),shape='outline' if id=='BG' else 'box',note='先询样刷再定孔；罩形配斜壁，后侧需避球头/G20；不是已冻结开孔图。')
part('EX01','P01 / P02 / P04 / P05 / P06','机外低压配电盒',[265,30,0],[200,150,80],'blue','机外电源',(160,0,-20),shape='outline',note='200×150×80采购包络；内置TB-A/B、5V TPS候选和6V UBEC，布局/散热待实物。交流不进入机身。')
part('PS01','A07','YU2405 24V5A 外置适配器',[280,55,105],[140,65,40],'ghost','机外电源',(160,0,20),shape='outline',note='24V/5A/120W按用户选择；绘制140×65×40只为示意占位，非该型号实测尺寸！厂牌/插头/极性/AC线待核。',status='未知外形，示意占位')
part('PS05','A08','5V TPS5450整板候选',[285,55,20],[65,55,30],'blue','机外电源',(160,0,70),note='采购包络非所购尺寸；24→5V/4A预算，完整整板SKU/热性能待核。',status='候选整板占位')
part('PS06','A17','UBEC5A 6V候选',[355,55,20],[50,17,10],'orange','机外电源',(160,0,70),note='好盈30607000/2–8S可核候选，断电设6V后实测；原厂5A持续，本机3A持续/5A短峰预算。')

def iso(ps,box,explosion=0,labels=False,opacity=1,bounds=None):
    ox,oy,w,h=box
    def raw(v):x,y,z=v;return (.8660254*(x+y),.5*(x-y)-z)
    points=[]; allv=[]
    for p in ps:
        pos=[p['pos'][i]+p['explode'][i]*explosion for i in range(3)];sz=p['size']
        vs=[(pos[0]+a*sz[0],pos[1]+b*sz[1],pos[2]+c*sz[2]) for a,b,c in [(0,0,0),(1,0,0),(1,1,0),(0,1,0),(0,0,1),(1,0,1),(1,1,1),(0,1,1)]]
        allv.append((p,vs));points.extend(raw(v) for v in vs)
    if bounds is not None: points=[raw(v) for v in bounds]
    xmin=min(p[0] for p in points);xmax=max(p[0] for p in points);ymin=min(p[1] for p in points);ymax=max(p[1] for p in points)
    sc=min((w-42)/(xmax-xmin),(h-32)/(ymax-ymin));cx=ox+w/2;cy=oy+h/2
    def pr(v):x,y=raw(v);return cx+(x-(xmin+xmax)/2)*sc,cy+(y-(ymin+ymax)/2)*sc
    out='';annotations=''
    def depth(pv):
        p,vs=pv
        return (p.get('render_layer',0), sum(v[0]-v[1]+v[2] for v in vs)/8)
    for p,vs in sorted(allv,key=depth):
        # Looking from the front/right/top: front, right and top faces.
        fill=p['color'];op=p.get('opacity',.42 if p['shape'] in ['placeholder','bin','lanebox','hopper'] else opacity)
        out+=f'<g class="pick" data-part="{p["id"]}"><title>{esc(p["id"]+" · "+p["name"]+" · BOM "+p["bom"])}</title>'
        pos=vs[0];w0,d0,h0=p['size']
        def local(pts):return [pr((pos[0]+x,pos[1]+y,pos[2]+z)) for x,y,z in pts]
        def face_with_holes(outline,holes):
            loops=[local(outline)]+[local(h) for h in holes]
            path=' '.join('M'+' L'.join(f'{x:.2f},{y:.2f}' for x,y in loop)+' Z' for loop in loops)
            return f'<path d="{path}" fill="{fill}" fill-opacity="{op}" fill-rule="evenodd" stroke="{C["ink"]}" stroke-width="1.15"/>'
        if p['shape']=='button':
            ring=[(w0/2+w0/2*math.cos(a*math.pi/16),0,h0/2+h0/2*math.sin(a*math.pi/16)) for a in range(32)]
            out+=poly(local(ring),'#c4cbd0')
        elif p['shape'] in ['hopper','transition']:
            bw,bd=p.get('bottom_size',(110,30) if p['shape']=='hopper' else (82,12))
            ax,ay=(w0-bw)/2,(d0-bd)/2
            front=[(ax,ay,0),(ax+bw,ay,0),(w0,0,h0),(0,0,h0)]
            right=[(ax+bw,ay,0),(ax+bw,ay+bd,0),(w0,d0,h0),(w0,0,h0)]
            out+=poly(local(front),fill,.55)+poly(local(right),fill,.55)
            for loop in [[(0,0,h0),(w0,0,h0),(w0,d0,h0),(0,d0,h0)],[(ax,ay,0),(ax+bw,ay,0),(ax+bw,ay+bd,0),(ax,ay+bd,0)]]:
                vv=local(loop);out+=''.join(line(*vv[i],*vv[(i+1)%4],C['ink']) for i in range(4))
        elif p['shape'] in ['displayframe','panelwindow']:
            iw,ih=p['opening']
            if d0<=6:
                ax,az=p.get('opening_origin',[(w0-iw)/2,(h0-ih)/2])
                out+=face_with_holes([(0,0,0),(w0,0,0),(w0,0,h0),(0,0,h0)], [[(ax,0,az),(ax+iw,0,az),(ax+iw,0,az+ih),(ax,0,az+ih)]])
            else:
                ay,az=p.get('opening_origin',[(d0-iw)/2,(h0-ih)/2])
                out+=face_with_holes([(w0,0,0),(w0,d0,0),(w0,d0,h0),(w0,0,h0)], [[(w0,ay,az),(w0,ay+iw,az),(w0,ay+iw,az+ih),(w0,ay,az+ih)]])
        elif p['shape']=='bracket':
            ax=w0-2 if p['right'] else 0
            out+=poly(local([(ax,0,2),(ax+2,0,2),(ax+2,0,h0),(ax,0,h0)]),fill)
            out+=poly(local([(0,0,2),(w0,0,2),(w0,d0,2),(0,d0,2)]),fill)
        elif p['shape']=='angle':
            out+=poly(local([(0,0,2),(w0,0,2),(w0,d0,2),(0,d0,2)]),fill)
            out+=poly(local([(0,d0-2,0),(w0,d0-2,0),(w0,d0-2,h0),(0,d0-2,h0)]),fill)
        elif p['shape']=='fin':
            ay=(d0-12)/2
            out+=poly(local([(0,ay,0),(0,ay+12,0),(0,d0,h0),(0,0,h0)]),fill,.7)
            out+=poly(local([(w0,ay,0),(w0,ay+12,0),(w0,d0,h0),(w0,0,h0)]),fill,.7)
        elif p['shape']=='lanebox':
            out+=poly(local([(0,9,0),(w0,9,0),(w0,9,20),(w0,0,50),(0,0,50),(0,9,20)]),fill,.4)
            out+=poly(local([(w0,9,0),(w0,27,0),(w0,27,20),(w0,36,50),(w0,0,50),(w0,9,20)]),fill,.4)
            vv=local([(0,0,50),(w0,0,50),(w0,36,50),(0,36,50)]);out+=''.join(line(*vv[i],*vv[(i+1)%4],C['ink']) for i in range(4))
        elif p['shape']=='bin':
            for inds in [(0,1,5,4),(1,2,6,5),(0,1,2,3)]:out+=poly([pr(vs[i]) for i in inds],fill,.35)
            out+=''.join(line(*pr(vs[i]),*pr(vs[4+(i-3)%4]),C['ink']) for i in range(4,8))
        elif p['shape'] in ['base','support','opticalbase','ring']:
            outer=[(0,0,h0),(w0,0,h0),(w0,d0,h0),(0,d0,h0)]
            holes=[]
            if p['shape']=='base':
                outer=[(0,0,h0),(29,0,h0),(29,32,h0),(111,32,h0),(111,0,h0),(140,0,h0),(140,140,h0),(85,140,h0),(85,80,h0),(55,80,h0),(55,140,h0),(0,140,h0)]
            elif p['shape']=='support':
                ax=(w0-82)/2;ay=p.get('window_y',(d0-12)/2)
                holes=[[(ax+i*17,ay,h0),(ax+14+i*17,ay,h0),(ax+14+i*17,ay+12,h0),(ax+i*17,ay+12,h0)] for i in range(5)]
            elif p['shape']=='ring':
                iw,idepth=p['inner_size'];ax=(w0-iw)/2;ay=(d0-idepth)/2;holes=[[(ax,ay,h0),(ax+iw,ay,h0),(ax+iw,ay+idepth,h0),(ax,ay+idepth,h0)]]
            else:holes=[[(25,75,h0),(155,75,h0),(155,125,h0),(25,125,h0)]]
            out+=face_with_holes(outer,holes)
        elif p['shape']=='link':
            # The relative drawing matches the project slider geometry at closure.
            out+=line(*local([(0,65.8117,1)])[0],*local([(14.1333,58.3117,1)])[0],C['orange'],False,5)
            out+=line(*local([(14.1333,58.3117,1)])[0],*local([(0,0,1)])[0],C['blue'],False,5)
            for q in [(0,65.8117,1),(14.1333,58.3117,1),(0,0,1)]:out+=circle(*local([q])[0],4)
        elif p['shape']=='outline':
            for a,b in [(0,1),(1,2),(2,3),(3,0),(4,5),(5,6),(6,7),(7,4),(0,4),(1,5),(2,6),(3,7)]:
                out+=line(*pr(vs[a]),*pr(vs[b]),C['orange'],True,1.4)
        else:
            for inds in [(0,1,5,4),(1,2,6,5),(4,5,6,7)]:out+=poly([pr(vs[i]) for i in inds],fill,op)
        if p['shape'] in ['placeholder']:out+=line(*pr(vs[0]),*pr(vs[6]),C['muted'],True)
        if labels and (not isinstance(labels,dict) or p['id'] in labels):
            label=labels[p['id']] if isinstance(labels,dict) else p['id']
            xx,yy=pr(tuple(p['pos'][i]+p['size'][i]/2+p['explode'][i]*explosion for i in range(3)))
            annotations+=rect(xx-19,yy-11,38,19,'#fffefa',C['line'],3)+text(xx,yy+3,label,11,anchor='middle',bold=True)
        out+='</g>'
    return out+annotations


frame=[p for p in parts if p['group']=='骨架']
internal=[p for p in parts if p['group'] not in ['机外电源','净空（非零件）']]
comparison_bounds=[(x,y,z) for x in [-8,228] for y in [-8,248] for z in [0,460]]
hopper_outline=dict(id='HOPPER-REF',bom='F04',name='连续PP斗外包络',pos=byid['H07']['pos'],size=byid['H07']['size'],color=C['orange'],group='参考',explode=[0,0,0],shape='outline')
outer=[dict(p) for p in internal if p['group'] in ['骨架','海洋板','双屏'] or p['id'] in ['H07','H09','B12','W05','W06','BTN1','BTN2']]
for p in outer:
 if p['id'] in ['P02','P03','P05','P07','P08']:p['render_layer']=-10
 if p['id'] in ['D01','D02','D04','D05']:p['render_layer']=21
comparison=text(45,164,'成品外观 / 黑2020和三面下延木板',22,bold=True)+text(795,164,'同一缩放 / 裸框与同一料斗包络',22,bold=True)
comparison+='<g id="assembled-product">'+iso(outer,(20,180,610,620),bounds=comparison_bounds)+iso([hopper_outline],(20,180,610,620),bounds=comparison_bounds)+'</g>'
comparison+='<g id="bare-frame">'+iso(frame+[hopper_outline],(770,180,610,620),bounds=comparison_bounds)+'</g>'
comparison+=lines(40,826,['外框220×240×460；连续PP2斗Z298.3→440，高141.7；内上136方、内下82×12。',
 '两图共用视角和比例；顶PP3托环176×196由4金属角片支承，底Z440/顶443。',
 '三边木板延续到底，框架外露；料斗外无木壳；YU2405及低压配电盒在机外。'],17,27)
(ROOT/'frame-comparison-v4.12.svg').write_text(sheet('同尺寸成品 / 裸框对照','料斗的位置和高度在两图一致；橙虚线只作料斗包络参考。',comparison,1))
svgs=[]
major={'T01':'1','P02':'2','H07':'3','G08':'4','B01A':'5','B12':'6','A01':'7','E01':'8'}
big=[p for p in internal if p['id'] not in ['D10','G20'] and p['group']!='刷排']
body=text(45,163,'组装透视 / 移去前和右面板看内部',20,bold=True)+iso([p for p in big if p['id'] not in ['P01','P04','P06','P09']],(35,180,620,610),0,major)
body+=text(735,163,'整机分解 / 分解距离不是装配间距',20,bold=True)+iso(big,(720,180,640,610),.8,major)
body+=lines(50,822,['1 F01黑2020；2 F03木板；3 F04连续PP斗；4 G06–G21滑闸；5 B01双摄；6 B12/W05收豆称台；7 A01主屏；8 E01侧屏。',
 '本版取消旧小过渡斗/双法兰/五窗叠片；采用PP6上座、PP10下座和连续前侧壁，PBT另见第04页。',
 '机外YU2405与配电盒见第11页；SEN0503对射逐线接法见第12页。双屏固定关系见第08页。'],17,27)
svgs.append(sheet('01  整机组装与部件爆炸图','黑2020外框220×240×460；连续主斗Z298.3→440；保留9木板、双屏和独立称台。',body,1))
exec((ROOT/'frame-wood.pyfrag').read_text())
feed=[p for p in parts if p['group'] in ['送料','刷排','滑闸'] and p['id'] not in ['D10','G20']]
body=iso(feed,(30,150,610,630),.8,{'H07':'H07','H09':'H09','U01':'U01','U02':'U02','U03':'U03','G07':'G07','BC1':'BC1','BC2':'BC2','V01':'V01','A03':'A03'})
body+=table(660,155,700,['图号 / BOM','当前结构与尺寸'],[
 ('H07 / F04','PP2四片连续斗，高141.7，136方→82×12'),('H09/Q01–04 / F13','顶托环PP3＋4金属托片，木板不承斗重'),('U01 / F18','PP6上座140×30×6，底Z292.3'),('U02 / G12','PP10下座140×24×10，Y105–129'),('U03–05 / F19','前封片140×18.3×2；侧32×15.3×2'),('G211/212 / G21','两端10×24×2.3隔距，冷却后校隙'),('V01–04 / B16','4片PP3分道，高20，梯形上29.502/下12'),('BF/BR / B11','10段PBT，毛长14，向下30°；尖Z308'),('BC/BP/BG / B14–15','载条/压条/防豆罩，先样刷再定孔'),('G07 / G06 / R01','铝片110×45×2；双轨；居中M4双球头杆')],[205,495],37,15)
body+=lines(670,603,['固定槽体焊成U形：前壁连续、两侧封闭；只留后入口。',
 '关闸前缘Y112.5，进入前承接位1.5；打开Y127.5。',
 '行程15；闸片Z290–292；闸缝290–292.3。',
 '毛尖与闸缝顶名义15.7；不能把刷毛塞进闸片平面。',
 '图示分开的是加工件，装好后固定PP焊为一体。',
 '后刷盒、球头和G20后罩仍需实物全行程试配。',
 '支点/焊缝/滑阻/容量尚未验收；原1kg装豆目标未证明。'],17,31)
svgs.append(sheet('04  连续PP豆路、PBT与后插闸片爆炸图','部件编号是图中ID；采购按右栏BOM。POM只保留另一可拆螺接版本备选。',body,4))
body=text(40,165,'光学与称重 / 去外壳的安装关系',22,bold=True)
opt=[p for p in internal if p['group'] in ['骨架','光学','称重'] or p['id'] in ['H07','U01','U02','G07']]
body+=iso(opt,(30,180,620,610),0,{'H07':'H07','PH01':'TX','PH02':'RX','B01A':'前摄','B01B':'后摄','W05':'称台','B12':'收豆盒'})
body+=table(680,155,680,['BOM / 位置','接法与装配'],[
 ('PH01 / PH04','SEN0503两侧对射；5V供电，拟光束Z277'),('B01 / B13','前后GC2093相机；独立梁；光轴Z241.25起试'),('A05 / L02–03','四条24V灯带；铝槽散热；对照IR干扰'),('F07','底遮光板180×200×1，开130×50豆通口'),('W01 / W06','HJ-AZ4资料待核；固定端连固定底板'),('W05 / B12','豆与盒→活动板→传感器→固定板→机架'),('P01 / A07','YU2405与低压配电盒均机外，机内不接裸交流'),('A08 / A17','5V给板卡/光电；UBEC6V只给MG996R')],[210,470],42,15)
body+=lines(690,600,['光电头20×10×9为原厂外形；图中轴向/光孔位置待核。',
 '不按单个9mm厚度保证与PP侧封片、脚座无干涉。',
 '相机连续采集；光电仅经过提示，不触发逐豆唯一照片。',
 '收豆盒只压称台，不碰三边木板、线缆或电源盒。',
 '称台Z45仍为目标高度；3kg传感器不等于已验±0.1g。',
 '约1.22L料斗不保证装1kg；容量和总活动载荷分别验。'],17,32)
svgs.append(sheet('05  双摄、SEN0503与独立称重安装','原厂外形、占位尺寸与未核孔位分开标记；图示不能代替实物装配。',body,5))
body=table(40,155,1320,['步','装配对象','操作与预期'],[
 ('1','黑2020 / F01–F02','460立柱与上下/中框松装，校220×240×460和对角线，再锁紧。'),
 ('2','G11/G06/G08/G07','同平面装双轨，先手推15行程，平顺无偏摆后才装执行器。'),
 ('3','PP主斗/F18/G12/F19/G21','练习厚薄PP焊接；固定体焊成连续U槽，冷却后量2.3闸缝、试滑。'),
 ('4','H09/Q01–Q04/F13','下槽体先定位；托环坐实4金属托片，再M3锁紧，不用螺钉硬拉焊件。'),
 ('5','B16/B11/B14/B15','样刷试装前后各5；毛尖Z308，先无刷与小侵入量单槽对比。'),
 ('6','A03/R01/S01','独立6V空载，小角度核方向/限位；上电禁止自动开闸。'),
 ('7','B01/B13/A05/PH01','相机、灯、SEN0503支架按实物；IR开启/关闭对照拍摄。'),
 ('8','W06/W01/W05/B12','核称重件接口/高度再定孔；盒不碰墙、称台无旁路，静态标定。'),
 ('9','A07/A08/A17/P01–P14','机外YU2405量24V/极性，5V板空载量5V，UBEC断电设6V再量。'),
 ('10','双屏/按钮/9块木板','保留屏后服务腔、天线与检修；SEN信号断开GPIO先测两状态。'),
 ('11','无执行器→空载→单槽→五槽','STOP/超时/失联先撤销送料；未确认关限位不能报已关。')],[55,325,940],46,16)
body+=lines(40,765,['角码/螺钉用量：骨架28用/32购；M5和T螺母56用/64购；面板F11与顶托F13分开计。',
 '完整114项物料沿用V4.11 BOM；已有/备选不重复购买，YU2405插头与报价待实际订单。',
 '这是一份装配和验收顺序；不是按“动画播放成功”判定机器已可安全带豆运行。'],17,31)
svgs.append(sheet('06  组装顺序与采购对照','先校框与手推，再焊件/空载/光学/称重，最后小量带豆；执行器电源不经主板。',body,6))
exec((ROOT/'connections-displays.pyfrag').read_text())
body=''
k=62/141.7;dx=2*math.sqrt(1+(27/141.7)**2);dy=2*math.sqrt(1+k*k)
clearances=[]
for ox,z,title in [(70,402,'主屏服务腔最高处 Z402'),(780,385,'侧屏服务腔最高处 Z385')]:
 sc=1.65;oy=190
 def plan(x,y):return ox+x*sc,oy+y*sc
 body+=text(ox,163,title,22,bold=True)+rect(ox,oy,220*sc,240*sc,'none',C['frame'])
 for xx,yy in [(0,0),(200,0),(0,220),(200,220)]:body+=rect(*plan(xx,yy),20*sc,20*sc,C['frame'])
 aa=41+27*(z-298.3)/141.7;bb=6+62*(z-298.3)/141.7
 body+=rect(*plan(110-aa-dx-4,120-bb-dy-4),(2*aa+2*dx+8)*sc,(2*bb+2*dy+8)*sc,'#fff0dd',C['orange'])
 body+=rect(*plan(110-aa-dx,120-bb-dy),(2*aa+2*dx)*sc,(2*bb+2*dy)*sc,'#d9eee5',C['pp'])
 body+=rect(*plan(70,7),80*sc,40*sc,'#d9e8f2',C['blue'])
 if z<=385:body+=rect(*plan(188,50),25*sc,85*sc,'#d9e8f2',C['blue'])
 if z==402:
  edge=120-bb-dy-4;clearance=edge-47;body+=dim(*plan(110,47),*plan(110,edge),f'{clearance:.2f}名义净空')
 else:
  edge=110+aa+dx+4;clearance=188-edge;body+=dim(*plan(edge,105),*plan(188,105),f'{clearance:.2f}名义净空',dy=-18)
 clearances.append(clearance)
 body+=text(ox+150,oy+240*sc+35,'前方 / Y0',16)
body+=table(40,690,1320,['比较对象','当前连续主斗计算','结果与限制'],[
 ('主屏80×40×64服务腔','Z402；实料法向2＋水平4焊筋储备',f'{clearances[0]:.2f}mm；不再沿用旧110高斗的17.09'),
 ('侧屏25×85×47服务腔','Z385；同样扣实料/焊筋',f'{clearances[1]:.2f}mm；不再沿用旧110高斗的10.49'),
 ('外壳与PP斗','无木斗壳；只有独立三边外壳面板','接头/排线/天线实际放得下才成立')],[340,440,540],42,16)
body+=text(40,890,'绿=PP实料外形；橙=焊筋储备；蓝=屏后服务腔。净空不等于已验散热或可维护。',16)
svgs.append(sheet('09  连续主斗与双屏净空重算','几何来自V4.11连续斗；按每个服务腔最高Z截面复核。',body,9))
body=table(40,155,1320,['对象','V4.12当前表达','待实物确认'],[
 ('料斗/框架','Z298.3→440连续PP斗，四金属托片挂顶环','焊接翘曲、PP蠕变、支点与容量'),('闸片/刷排','前壁连续、后插铝闸；前后10段PBT','G10球头/G20后罩/后刷盒全行程避让'),('SEN0503','TX/RX外形20×10×9；5V；信号拟3.3V','朝向/光孔偏置/支架孔/两状态输出电压'),('YU2405','用户指定24V5A120W，机外占位','厂牌/插头/极性/AC线/带载性能'),('5V降压/6V舵机','TPS5450整板候选；UBEC5A设6V','TPS整板SKU/散热纹波；UBEC跳帽与舵机峰值'),('主/侧屏','BOX整机夹壳；C6非Touch绝缘后框','突出物/接口/安装牙深/天线/显示旋转'),('称重','独立活动称台，不由板墙承力','HJ-AZ4接口/高度/标定/误差与稳定性'),('动作/异常','启动不自动开闸，许可有限，停止优先','未写固件；动作超时/卡豆卸力/残流策略标定'),('图册/BOM','本册12页；采购用V4.11的114项','图中ID可映射BOM；占位不当成加工尺寸')],[205,570,545],64,16)
body+=text(40,850,'已有460×7、400×2黑欧标2020：仍只补同槽型180mm×4；裁切顺序和锯缝按裁切表说明。',17,bold=True)
svgs.append(sheet('10  遗漏项与未冻结接口','动画和文档是设计说明；未完成电气、光学、焊接、称重或带豆验收。',body,10))
for filename,n in [('05-power-wiring-candidates.svg',11),('06-mvp-sensor-wiring.svg',12)]:
 s=(ROOT.parent/'revision-v4.11'/filename).read_text()
 s=s.replace('viewBox="0 0 1500 1060"','viewBox="0 0 1500 1060" width="1400" height="960"')
 s=s.replace('BEANLENS  /  V4.11  /  05','BEANLENS  /  V4.12  /  11')
 s=s.replace('BEANLENS / V4.11 / 05','BEANLENS / V4.12 / 11').replace('BEANLENS / V4.11 / 06','BEANLENS / V4.12 / 12').replace('5 / 6','11 / 12').replace('6 / 6','12 / 12')
 svgs.append(s)
names=['01-overall','02-frame','03-plywood','04-feed-gate','05-optics-weight','06-assembly-order','07-connections','08-displays','09-clearance','10-interface-audit','11-power-wiring','12-sensor-wiring']
for n,s in zip(names,svgs):(ROOT/(n+'.svg')).write_text(s)
data=dict(revision='V4.12',date='2026-10-17',status='dimensioned_layout_proposal_not_machining_release',coordinates={'x':'left_to_right','y':'front_to_rear','z':'frame_bottom_up','units':'mm'},frame_mm=FRAME['frame_mm'],profile=FRAME['profile'],parts=parts,wood_cuts=woodcuts,source_bom='../procurement-v4.11/beanlens-bom-v4.11.json',source_geometry='../revision-v4.11/design-v4.11.json',screen_clearance_mm={'front':clearances[0],'right':clearances[1]},unverified=D['unresolved'],drawing_files=[n+'.svg' for n in names])
(ROOT/'assembly-layout-v4.12.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')
with (ROOT/'cut-list-v4.12.csv').open('w',encoding='utf-8-sig',newline='') as f:
 w=csv.writer(f);w.writerow(['零件号','BOM','材料','尺寸mm','数量','状态'])
 for p in frame:w.writerow([p['id'],'F01','黑色欧标2020','20×20×'+str(max(p['size'])),1,'保留V4.8骨架'])
 for id,ww,hh,x,y in woodcuts:w.writerow([id,'F03','6mm海洋板',f'{ww}×{hh}×6',1,'保留外壳净尺寸；孔位先实配'])
exec((ROOT/'viewer-template.pyfrag').read_text())
(ROOT/'beanlens-assembly-v4.12.html').write_text(template)
print('V4.12:',len(parts),'objects;',len(svgs),'sheets; clearances',clearances)
