"""Dimensioned vector assembly sheets and an offline explorable parts viewer.

All dimensions are project design references or explicitly marked layout proposals.
This generator does not touch firmware, training data or vendor originals.
"""
from pathlib import Path
import json, math, html, csv

ROOT = Path(__file__).resolve().parent
BOM = json.loads((ROOT.parent/'procurement-v4.5/beanlens-bom-v4.5.json').read_text())
C = {'ink':'#223d38','muted':'#62736e','line':'#b8c7c1','alu':'#b8c8d0','wood':'#d5b58a','pp':'#69b6a0','blue':'#6b9abb','orange':'#cb8351','ghost':'#e8eeeb'}
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
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="1400" height="960" viewBox="0 0 1400 960" role="img" aria-label="{esc(title)}"><style>text{{font-family:Arial,"PingFang SC","Microsoft YaHei",sans-serif}}.pick{{cursor:pointer}}.pick:hover polygon{{stroke:#00876b;stroke-width:3}}</style><rect width="1400" height="960" fill="#fffefa"/>{text(32,34,'BEANLENS  /  ASSEMBLY V4.5  /  2026-10-13',13,C['muted'],bold=True)}{text(32,77,title,30,bold=True)}{text(32,108,subtitle,16,C['muted'])}{line(32,127,1368,127)}{content}{line(32,916,1368,916)}{text(32,942,'单位 mm · 尺寸为设计/布局提案，非孔位加工图；未知元件只画安装占位。按标注尺寸，不量屏幕或缩印图。',13,C['muted'])}{text(1368,942,f'{num:02d} / 07',13,C['muted'],'end')}</svg>'''

parts=[]
def part(id,bom,name,pos,size,color,group,explode=(0,0,0),note='',status='设计尺寸',shape='box'):
    p=dict(id=id,bom=bom,name=name,pos=list(pos),size=list(size),color=C.get(color,color),group=group,explode=list(explode),note=note,status=status,shape=shape);parts.append(p);return p
# X right, Y rear, Z up; frame underside is Z=0, front is Y=0.
for i,(x,y) in enumerate([(0,0),(200,0),(200,220),(0,220)],1):part(f'T{i:02}','F01','400立柱',(x,y,20),(20,20,400),'alu','骨架',((x-100)*.35,(y-110)*.35,30))
for i,(y,z) in enumerate([(0,0),(220,0),(0,420),(220,420)],5):part(f'T{i:02}','F01','220前后主梁',(0,y,z),(220,20,20),'alu','骨架',(0,(y-110)*.25,100 if z else -45))
for i,(x,z) in enumerate([(0,0),(200,0),(0,420),(200,420)],9):part(f'T{i:02}','F01','200上下侧梁',(x,20,z),(20,200,20),'alu','骨架',((x-100)*.25,0,100 if z else -45))
for i,x in enumerate([0,200],13):part(f'T{i:02}','F01','200料斗侧托梁',(x,20,304),(20,200,20),'alu','骨架',((x-100)*.35,0,25),note='上表面Z324；6mm托耳上表面Z330。',status='布局提案')
for i,y in enumerate([20,200],15):part(f'T{i:02}','F01','180料斗中框横梁',(20,y,304),(180,20,20),'alu','骨架',(0,(y-110)*.35,25),status='布局提案')
for i,y in enumerate([0,220],17):part(f'T{i:02}','F01','180相机独立梁',(20,y,221.25),(180,20,20),'alu','骨架',(0,(y-110)*.4,-10),note='梁位置可调；光轴Z241.25不是PCB固定孔高度。',status='布局提案')
part('P01','F03','前固定面板',(0,-6,200),(220,6,240),'wood','海洋板',(0,-150,0),note='BOX/按钮开口按实物；下方保持开放。',status='裁切提案')
part('P02','F03','后检修面板',(0,240,200),(220,6,240),'wood','海洋板',(0,180,0),note='先断电，再拆后板；电控托板装在其内侧。',status='裁切提案')
part('P03','F03','左侧面板',(-6,0,200),(6,240,240),'wood','海洋板',(-170,0,0),status='裁切提案')
part('P04','F03','右侧面板',(220,0,200),(6,240,240),'wood','海洋板',(170,0,0),note='C6开口按实物，避天线金属。',status='裁切提案')
for id,pos,size in [('H01',(33,43,330),(154,6,110)),('H02',(33,191,330),(154,6,110)),('H03',(33,49,330),(6,142,110)),('H04',(181,49,330),(6,142,110))]:part(id,'F03','料斗木壳板',pos,size,'wood','送料',(0,0,145),note='木壳外154×154×110；内142×142；PP上口140留装配量。')
for id,x in [('H05',0),('H06',180)]:part(id,'F03','料斗托耳',(x,105,324),(40,30,6),'wood','送料',(-35 if x==0 else 35,0,65),note='本图由约25宽补为40宽，搭住侧梁与木壳；保持中央豆路贯通。',status='裁切提案')
part('H07','F04','渐缩PP内衬',(40,50,330),(140,140,110),'pp','送料',(0,0,235),shape='hopper',note='上140×140，下110×30，净高110；4梯形，折边另加。')
part('H08','F05 / G13','五槽固定槽盒',(55,102,280),(110,36,50),'pp','送料',(0,0,95),note='最大上深36含两壁；闸位净深12。槽内尺寸须纸样。',status='布局占位',shape='lanebox')
part('G07','G07','2mm铝闸片',(55,112.5,290),(110,45,2),'alu','滑闸',(0,90,90),note='闭合位置；向后退15mm开闸。前缘在槽盒内。')
part('G08','G08 / G09','转接板与加强梁',(50,140.5,287),(120,30,3),'blue','滑闸',(0,140,85),note='转接板120×30×3，梁110长；本图轨距94提案。')
for id,x in [('G06L',58.5),('G06R',152.5)]:part(id,'G06','100导轨和长滑块',(x,132,277),(9,100,5.5),'alu','滑闸',(-25 if id.endswith('L') else 25,110,55),note='H10总高仅参考；槽盒/视锥/行程端余量需联调。',status='参考包络')
for id,x in [('G06LB',53),('G06RB',147)]:part(id,'G06','MGN9H长滑块',(x,135.55,282.5),(20,39.9,4.5),'blue','滑闸',(-25 if id=='G06LB' else 25,110,55),note='与同侧轨同一套，非另买滑块；总高/端余量按供货图。',status='参考包络')
part('G11','G11','共用导轨底座毛坯',(40,100,273),(140,140,4),'blue','滑闸',(0,180,45),note='毛坯不能整片装入；前部豆路与后部舵机处必须裁缺。',status='毛坯非最终轮廓',shape='base')
part('G12','G12','开五窗POM支承',(55,105,287),(110,30,3),'pp','滑闸',(0,45,35),note='五通口对齐槽位；不是实心挡豆板。',shape='support')
part('A03','A03 / G01–G05 / G10 / G14','舵机与居中连杆',(100,190,261),(20,41,43),'orange','滑闸',(0,225,85),note='MG996R机身仅参考包络；输出轴/球心高及壳体扫掠未冻结。',status='参考占位',shape='servo')
part('R01','G01–G05 / G10','舵臂与双球头杆',(110,155.5,303),(16,74,2),'orange','滑闸',(0,225,85),note='示意闭合姿态：球心距60，曲柄16；安装高度未冻结。',status='传动示意',shape='link')
part('S01C','S01 / G18','关端限位预留',(167,135,287),(20,8,8),'orange','滑闸',(50,90,20),status='安装占位')
part('S01O','S01 / G18','开端限位预留',(167,185,287),(20,8,8),'orange','滑闸',(50,120,20),status='安装占位')
part('B01A','B01 / B13','前摄像头安装区',(90,20,221.25),(40,25,40),'blue','光学',(0,-110,0),note='40方载板毛坯；镜头端面Y45，距豆流75起试。',status='安装占位')
part('B01B','B01 / B13','后摄像头安装区',(90,195,221.25),(40,25,40),'blue','光学',(0,150,0),note='镜头端面Y195；PCB/镜头长度按实物。',status='安装占位')
for id,x,y in [('L1',42,62),('L2',164,62),('L3',42,170),('L4',164,170)]:part(id,'A05 / L02 / L03','竖灯带与铝槽',(x,y,205),(14,8,100),'orange','光学',((x-110)*.7,(y-120)*.5,0),note='100有效长度、槽外14×8仅候选；光向中心斜照。',status='参考包络')
part('PH01','PH01 / PH04','低压对射安装区',(20,113,272),(20,14,10),'blue','光学',(-70,0,0),note='光束中心Z277；另一头对称；支架孔位未定。',status='安装占位')
part('PH02','PH01 / PH04','对射接收安装区',(180,113,272),(20,14,10),'blue','光学',(70,0,0),status='安装占位')
part('O01','F07','遮光底板开通口',(20,20,194),(180,200,1),'pp','光学',(0,-35,-50),note='上表面Z195；中央130×50通口，不挡豆。',shape='opticalbase')
part('W06','W06','称台固定底板',(20,25,20),(180,190,4),'alu','称重',(-110,-70,-65),note='180×190×4；不计活动载荷，安装按称重件图。',status='毛坯')
part('W01','W01','HJ-AZ4称重组件预留',(75,75,24),(70,90,19),'ghost','称重',(-110,-70,-30),note='虚线为预留区域，不是HJ-AZ4实际尺寸；接口/高度待图纸。',status='未知外形',shape='placeholder')
part('W05','W05','活动称台板',(25,30,43),(170,180,2),'alu','称重',(-110,-70,5),note='目标台面Z45，组件高度确认后调整；不可连墙或滑轨。',status='毛坯/高度目标')
part('B12','B12','收豆盒占位',(30,35,45),(160,170,125),'pp','称重',(-110,-115,45),note='绘制125高；BOM上限130须复核净间隙、容积和活动重量。',status='尺寸上限占位',shape='bin')
part('A01','A01 / F06','BOX及屏幕夹持区',(77.85,0,346.2),(64.3,35,47.6),'blue','电控',(0,-150,25),note='原壳64.3×47.6×15.4，35为服务腔预留，不是壳深。',status='壳参考/腔提案')
part('BTN1','A16','开始按钮安装区',(67,-8,302),(16,18,16),'orange','电控',(0,-150,25),status='开孔按实物')
part('BTN2','A16','停止按钮安装区',(137,-8,302),(16,18,16),'orange','电控',(0,-150,25),status='开孔按实物')
part('E01','E01 / F06','C6小屏安装区',(195,65,350),(25,60,50),'blue','电控',(180,0,25),note='仅安装区，不表示实物60×50；屏幕朝右。',status='安装占位')
part('E03','F06 / A08 / A17 / P05 / P06','后电控托板',(30,233,300),(160,2,130),'blue','电控',(0,230,10),note='160×130×2托板提案；两降压/端子/保险按实物纸样，24V适配器在机外。',status='托板毛坯')

def iso(ps,box,explosion=0,labels=False,opacity=1):
    ox,oy,w,h=box
    def raw(v):x,y,z=v;return (.8660254*(x+y),.5*(x-y)-z)
    points=[]; allv=[]
    for p in ps:
        pos=[p['pos'][i]+p['explode'][i]*explosion for i in range(3)];sz=p['size']
        vs=[(pos[0]+a*sz[0],pos[1]+b*sz[1],pos[2]+c*sz[2]) for a,b,c in [(0,0,0),(1,0,0),(1,1,0),(0,1,0),(0,0,1),(1,0,1),(1,1,1),(0,1,1)]]
        allv.append((p,vs));points.extend(raw(v) for v in vs)
    xmin=min(p[0] for p in points);xmax=max(p[0] for p in points);ymin=min(p[1] for p in points);ymax=max(p[1] for p in points)
    sc=min((w-42)/(xmax-xmin),(h-32)/(ymax-ymin));cx=ox+w/2;cy=oy+h/2
    def pr(v):x,y=raw(v);return cx+(x-(xmin+xmax)/2)*sc,cy+(y-(ymin+ymax)/2)*sc
    out='';annotations=''
    for p,vs in sorted(allv,key=lambda pv:pv[1][0][0]-pv[1][0][1]+pv[1][0][2]*.08):
        # Looking from the front/right/top: front, right and top faces.
        fill=p['color'];op=.42 if p['shape'] in ['placeholder','bin','lanebox','hopper'] else opacity
        out+=f'<g class="pick" data-part="{p["id"]}"><title>{esc(p["id"]+" · "+p["name"]+" · BOM "+p["bom"])}</title>'
        pos=vs[0];w0,d0,h0=p['size']
        def local(pts):return [pr((pos[0]+x,pos[1]+y,pos[2]+z)) for x,y,z in pts]
        def face_with_holes(outline,holes):
            loops=[local(outline)]+[local(h) for h in holes]
            path=' '.join('M'+' L'.join(f'{x:.2f},{y:.2f}' for x,y in loop)+' Z' for loop in loops)
            return f'<path d="{path}" fill="{fill}" fill-opacity="{op}" fill-rule="evenodd" stroke="{C["ink"]}" stroke-width="1.15"/>'
        if p['shape']=='hopper':
            front=[(15,55,0),(125,55,0),(140,0,110),(0,0,110)]
            right=[(125,55,0),(125,85,0),(140,140,110),(140,0,110)]
            out+=poly(local(front),fill,.55)+poly(local(right),fill,.55)
            for z,xy in [(110,[(0,0),(140,0),(140,140),(0,140)]),(0,[(15,55),(125,55),(125,85),(15,85)])]:
                vv=local([(x,y,z) for x,y in xy]);out+=''.join(line(*vv[i],*vv[(i+1)%4],C['ink']) for i in range(4))
        elif p['shape']=='lanebox':
            out+=poly(local([(0,9,0),(w0,9,0),(w0,9,20),(w0,0,50),(0,0,50),(0,9,20)]),fill,.4)
            out+=poly(local([(w0,9,0),(w0,27,0),(w0,27,20),(w0,36,50),(w0,0,50),(w0,9,20)]),fill,.4)
            vv=local([(0,0,50),(w0,0,50),(w0,36,50),(0,36,50)]);out+=''.join(line(*vv[i],*vv[(i+1)%4],C['ink']) for i in range(4))
        elif p['shape']=='bin':
            for inds in [(0,1,5,4),(1,2,6,5),(0,1,2,3)]:out+=poly([pr(vs[i]) for i in inds],fill,.35)
            out+=''.join(line(*pr(vs[i]),*pr(vs[4+(i-3)%4]),C['ink']) for i in range(4,8))
        elif p['shape'] in ['base','support','opticalbase']:
            outer=[(0,0,h0),(w0,0,h0),(w0,d0,h0),(0,d0,h0)]
            holes=[]
            if p['shape']=='base':
                outer=[(0,0,h0),(29,0,h0),(29,32,h0),(111,32,h0),(111,0,h0),(140,0,h0),(140,140,h0),(85,140,h0),(85,80,h0),(55,80,h0),(55,140,h0),(0,140,h0)]
            elif p['shape']=='support':
                holes=[[(14+i*17,9,h0),(28+i*17,9,h0),(28+i*17,21,h0),(14+i*17,21,h0)] for i in range(5)]
            else:holes=[[(25,75,h0),(155,75,h0),(155,125,h0),(25,125,h0)]]
            out+=face_with_holes(outer,holes)
        elif p['shape']=='link':
            # The relative drawing matches the project slider geometry at closure.
            out+=line(*local([(0,65.8117,1)])[0],*local([(14.1333,58.3117,1)])[0],C['orange'],False,5)
            out+=line(*local([(14.1333,58.3117,1)])[0],*local([(0,0,1)])[0],C['blue'],False,5)
            for q in [(0,65.8117,1),(14.1333,58.3117,1),(0,0,1)]:out+=circle(*local([q])[0],4)
        else:
            for inds in [(0,1,5,4),(1,2,6,5),(4,5,6,7)]:out+=poly([pr(vs[i]) for i in inds],fill,op)
        if p['shape'] in ['placeholder']:out+=line(*pr(vs[0]),*pr(vs[6]),C['muted'],True)
        if labels and (not isinstance(labels,dict) or p['id'] in labels):
            label=labels[p['id']] if isinstance(labels,dict) else p['id']
            xx,yy=pr(tuple(p['pos'][i]+p['size'][i]/2+p['explode'][i]*explosion for i in range(3)))
            annotations+=rect(xx-19,yy-11,38,19,'#fffefa',C['line'],3)+text(xx,yy+3,label,11,anchor='middle',bold=True)
        out+='</g>'
    return out+annotations

svgs=[]
# 01: Whole assembly and exploded modules; small parts deliberately belong to subassemblies.
big=[p for p in parts if p['group']!='滑闸' or p['id'] in ['G07','G08','A03']]
major={'T01':'1','P02':'2','H07':'3','G08':'4','B01A':'5','B12':'6','A01':'7'}
body=text(45,163,'组装透视 / 移去前板和右板查看内部',20,bold=True)+iso([p for p in big if p['id'] not in ['P01','P04']],(35,180,620,610),0,major)
body+=text(735,163,'分解状态 / 沿虚拟方向拉开，非安装间距',20,bold=True)+iso(big,(720,180,640,610),1,major)
body+=lines(50,822,['图中编号：1 F01骨架；2 F03面板；3 F04/F05送料；4 G01–G20滑闸；5 B01/L02双摄灯；6 B12/W05称台；7 A01/F06电控。',
                          '上部棕色：海洋板；绿色：PP与豆路；银色：型材与铝板；蓝色：安装托架；橙色：舵机/灯。',
                          '细件和螺钉在第04/06页核对。未知称重件、PCB、支架只画预留包络，不表示已经确认能直接装入。'],17,27)
svgs.append(sheet('01  整机组装图与部件爆炸图','保留现有220×240×440骨架；下方开放取盒。外壳面板与支架位置为本次装配布局提案。',body,1))
# 02: Frame assembly, actual cut lengths and datum views.
frame=[p for p in parts if p['group']=='骨架']
body=iso(frame,(30,150,470,600),.65,True)+text(55,779,'T01–T18：共18段 / 净长4400',18,bold=True)
body+=table(520,155,840,['编号','切长','数量','装到哪里'],[
 ('T01–T04','400','4','四根立柱，Z20→420'),('T05–T08','220','4','上/下框的前、后整宽主梁'),('T09–T12','200','4','上/下框左右侧梁，夹在前后梁之间'),('T13–T14','200','2','料斗中框左右托梁，顶面Z324提案'),('T15–T16','180','2','料斗中框前后横梁，夹在两侧托梁间'),('T17–T18','180','2','前后相机梁，夹在同侧两立柱间')],[140,85,70,545],35,16)
# Orthographic front and side.
for ox,deep,title in [(555,220,'正视：外宽220'),(980,240,'右视：外深240')]:
    scale=.70;oy=830
    body+=text(ox,450,title,18,bold=True)
    body+=rect(ox,oy-440*scale,deep*scale,440*scale,'none',C['muted'])
    for z in [0,420]:body+=rect(ox,oy-(z+20)*scale,deep*scale,20*scale,C['alu'])
    for xx in [0,deep-20]:body+=rect(ox+xx*scale,oy-420*scale,20*scale,400*scale,C['alu'])
    body+=line(ox,oy-324*scale,ox+deep*scale,oy-324*scale,C['pp'],True)
    body+=line(ox,oy-241.25*scale,ox+deep*scale,oy-241.25*scale,C['blue'],True)
    body+=dim(ox,oy+27,ox+deep*scale,oy+27,str(deep))
    body+=dim(ox-27,oy,ox-27,oy-440*scale,'440',0)
body+=lines(760,510,['高度基准：','Z440 骨架顶','Z330 木壳底','Z324 中框顶','Z292 闸片顶','Z280 五槽出口','Z241.25 光轴','Z195 遮光板顶','Z45 称台面目标','Z0 骨架底'],15,26)
body+=text(35,884,'连接：上下框16个角码＋料斗中框8个＋相机梁4个＝28个使用；BOM F02购32个（含4备）。先量对角线，再逐级锁紧。',16)
svgs.append(sheet('02  铝型材骨架尺寸与逐根定位','2020截面20×20；200侧梁＋前后各20构成240深；180中横梁＋左右各20构成220宽；400立柱＋上下各20构成440高。',body,2))
# 03: One marine plywood sheet packing; cuts are unambiguous, holes remain unmeasured.
woodcuts=[('P01',220,240,3,3),('P03',240,240,226,3),('P02',220,240,3,246),('P04',240,240,226,246),('H01',154,110,3,489),('H02',110,154,469,3),('H03',110,142,469,160),('H04',110,142,469,305),('H05',40,30,160,489),('H06',40,30,203,489)]
body=text(40,163,'F03 海洋板600×600×6：一张排版提案',20,bold=True)
ox,oy,sc=45,190,.93;body+=rect(ox,oy,600*sc,600*sc,'#f6eddf',C['line'])
for id,w,h,x,y in woodcuts:
    xx,yy=ox+x*sc,oy+y*sc;body+=rect(xx,yy,w*sc,h*sc,C['wood'])+text(xx+6,yy+21,id,16,bold=True)
    if h>45:body+=text(xx+6,yy+43,f'{w}×{h}',14)
body+=dim(ox,oy+600*sc+25,ox+600*sc,oy+600*sc+25,'600')
body+=table(665,155,690,['板号','净裁切尺寸 / 数量','位置 / 连接'],[
 ('P01/P02','220×240×6，各1','前固定 / 后可拆，Z200→440'),('P03/P04','240×240×6，各1','左右包侧；前后板夹在侧板之间'),('H01/H02','154×110×6，各1','料斗前后板（H02排版旋转90°）'),('H03/H04','142×110×6，各1','夹在前后板之间，外尺寸154'),('H05/H06','40×30×6，各1','左右托耳；搭侧梁并托住木壳')],[135,255,300],36,15)
body+=lines(670,426,['面板外壳：232宽×252深×440高（不含脚垫/插头）。','正面下方：180宽，遮光底板下约174高可取盒。','排版预留：板边约3，矩形间距至少3（按锯片复核）。','实际6mm板厚需量；若厚度不同，侧板142重新算。'],17,29)
body+=text(670,575,'局部：料斗耳板托住木壳，不横挡110×30豆路',18,bold=True)
body+=rect(715,661,75,110,C['alu'])+rect(715,639,150,22,C['wood'])+rect(838,590,22,49,C['wood'])
body+=lines(895,621,['木壳底面 Z330','托耳厚6，下面 Z324','侧梁顶面 Z324','托耳宽40：跨13间隙＋6木壁，','另一端搭住20型材。'],16,27)
body+=line(790,655,875,655,C['orange'],True)+text(715,804,'托耳螺钉进型材T螺母；木壳与托耳用外侧小角片固定。',15)
body+=text(40,884,'所有屏幕、按钮、USB/TF及相机支架孔先不加工。板料表是净裁切提案，非1:1刀模；中间不加木底板。',16)
svgs.append(sheet('03  海洋板拆件、排版与安装关系','保持6mm海洋板600×600一张；本图排版可容纳完整面板、四片料斗壁和两只托耳。',body,3))
# 04: Detailed feeder and gate; 2D plan is more legible than a pseudo-CAD screw cloud.
gate=[p for p in parts if p['group']=='滑闸' or p['id'] in ['H07','H08']]
body=iso(gate,(30,150,500,610),.75,{p['id']:p['id'] for p in gate if p['id'] not in ['R01','G06LB','G06RB']})
body+=table(550,155,810,['BOM','零件 / 尺寸','连接位置'],[
 ('F04','PP内衬：140口→110×30口','四梯形，外翻折边；不贴实心底'),('F05 / G13','五槽：外宽110、高50；净14×12','固定在料斗口下；可拆清洁'),('G07 / G12','铝闸片110×45×2 / 开窗POM支承','闸片沿前后滑，前缘在槽内'),('G08 / G09','转接120×30×3 / 角铝110长','桥接两侧滑块；闸片后部接加强梁'),('G06 / G11','100轨块套×2 / 140×140×4底座毛坯','同一平面，底座必须避豆路/舵机'),('G01–G05','16孔舵臂 / M4双球头 / 30牙条','约60球心距；中心耳G10接滑架'),('A03 / G14','MG996R＋专用支架/转接毛坯','独立固定，轴竖直，高度按实物'),('S01 / G18','两端限位＋保护挡块','检测滑架；正常端点不顶死')],[130,360,320],34,15)
body+=text(550,497,'闸门俯视尺寸链 / 本次布局提案',19,bold=True)
sx,sy,sc=720,550,1.6
# Lane pattern has 82 active width, 14 wings each side, not legacy ambiguous 94.
for i in range(5):body+=rect(sx+(-41+i*17)*sc,sy,14*sc,12*sc,'#d9eee5')
body+=rect(sx-55*sc,sy-3*sc,110*sc,18*sc,'none')
body+=rect(sx-55*sc,sy+13.5*sc,110*sc,45*sc,C['alu'])
body+=rect(sx-60*sc,sy+41*sc,120*sc,30*sc,C['blue'])
for x in [-47,47]:body+=rect(sx+(x-4.5)*sc,sy+30*sc,9*sc,100*sc,'none',C['muted'])
body+=dim(sx-55*sc,sy-27,sx+55*sc,sy-27,'110外宽')
body+=dim(sx-47*sc,sy+151*sc,sx+47*sc,sy+151*sc,'94轨中心距提案')
body+=lines(955,545,['五槽横向：','5×14＋4×3＝82','110－82＝28','两侧结构区各14','（含侧壁与安装翼）','前后：12＋1.5＋1.5＝15行程','全关覆盖1.5；全开退让1.5。','轨距90是旧起点，本图94。'],16,27)
body+=lines(40,819,['G15 M3×6：转接板→滑块（8用＋2备）；G16 M3×8：导轨→底座（先量孔深）；G17：闸片后部连接。',
 '纵向叠高起点：底座顶Z277 → 轨块总高参考10 → 转接板3 → 闸片2，闸片顶Z292。真实块高不同时重算。',
 '图中的舵机、中心耳及底座仍需1:1纸样：避后摄视锥、给机身留缺口，未冻结连杆平面和螺孔。'],16,27)
svgs.append(sheet('04  送料与槽内滑闸爆炸图','滑闸工作区在槽盒内；后部传动区与豆路隔开。图中标注毛坯的部件不能整片照装。',body,4))
# 05: Side section, optics and independent weighing force path.
body=text(40,163,'侧剖面 / 前← Y →后；X方向看全部五槽',20,bold=True)
ox,oy,sc=65,830,1.35
def p(y,z):return ox+y*sc,oy-z*sc
# base and boundaries
body+=rect(*p(0,440),240*sc,440*sc,'none',C['line'])
for yy in [0,220]:body+=rect(*p(yy,420),20*sc,400*sc,C['alu'])
body+=rect(*p(43,440),154*sc,110*sc,'#ead9bf')
body+=poly([p(50,440),p(190,440),p(135,330),p(105,330)],C['pp'],.5)
body+=rect(*p(102,330),36*sc,50*sc,'none',C['pp'])
body+=line(*p(112.5,292),*p(157.5,292),C['orange'],False,4)
body+=rect(*p(20,261.25),25*sc,40*sc,C['blue'])+rect(*p(195,261.25),25*sc,40*sc,C['blue'])
for yy in [45,195]:
    body+=poly([p(yy,241.25),p(120,275),p(120,207.5)],C['blue'],.12)
    body+=line(*p(yy,241.25),*p(120,241.25),C['blue'],True)
body+=rect(*p(20,195),200*sc,1*sc,C['pp'])
# draw bean opening through optical floor as white interruption in cross-section
body+=rect(*p(95,196),50*sc,3*sc,'#fffefa','#fffefa')
body+=rect(*p(35,170),170*sc,125*sc,'#d9eee5',C['pp'])
body+=rect(*p(30,45),180*sc,2*sc,C['alu'])
body+=rect(*p(75,43),90*sc,19*sc,'none',C['muted'])
body+=rect(*p(25,24),190*sc,4*sc,C['alu'])
body+=dim(*p(45,285),*p(120,285),'75起试')+dim(*p(120,285),*p(195,285),'75起试')
for z,lbl in [(330,'料斗口Z330'),(292,'闸片顶Z292'),(280,'槽口Z280'),(241.25,'光轴Z241.25'),(195,'遮光顶Z195'),(45,'台面Z45目标')]:
    xx,yy=p(240,z);body+=line(xx+7,yy,xx+35,yy,C['line'])+text(xx+40,yy+5,lbl,15)
body+=text(66,875,'底板孔130×50；盒口≤Z175，净间距需计板厚。',15)
body+=table(680,155,680,['BOM','安装方法 / 对照尺寸'],[
 ('B01 / B13','前后相机各一套，固定独立T17/T18梁'),('B13','L角铝30×30×2、长40＋40方载板毛坯'),('A05 / L02','四条竖灯100有效长；前后各两条，斜照'),('PH01 / PH04','收发头两侧，光束中心约Z277'),('F07','遮光底板180×200×1，开130×50通口'),('W06','固定底板180×190×4，连机架'),('W01','HJ-AZ4外形与接口未知；收到图后定孔'),('W05','活动台170×180×2，只连接称重活动端'),('B12','盒≤160×170×130，不接墙/承重滑轨'),('F06','BOX、C6、后电控三片托板由200方铝板排')],[145,535],34,15)
body+=lines(690,565,['称重力路：豆＋盒 → W05 → 传感器 → W06 → 机架。','后电控：托板160×130×2，尼龙柱隔开模块与金属。','BOX夹持板80×60×2，C6夹持板60×35×2均为毛坯。','BOX壳64.3×47.6×15.4；箱内服务深度约35起试。','24V适配器在机外；后板内只布置低压配电。','降压、保险、端子实际占位与插拔间距仍需摆件确认。'],17,31)
body+=lines(690,790,['当前未解决：HJ-AZ4组件高度/孔距；GC2093实际PCB/镜头长度；',
                          'MG996R支架共面高度与扫掠；灯条切点与散热槽；后视锥净空。',
                          '称台Z45与前后75均是目标起点，未核实前不钻最终孔。'],16,28,C['orange'])
svgs.append(sheet('05  相机、灯、称台与电控安装剖面','相机与灯固定在机架，收豆盒只压独立称台。图中的称重虚框不是HJ-AZ4实际外形。',body,5))
# 06: Explicit assembly sequence and connectors, quantities and scope.
body=table(40,155,1320,['步骤','装配对象 / BOM','操作与检查'],[
 ('1','F01 / F02：T01–T12主框架','先下框、立柱、上框；量外宽220/深240/高440与两面对角线，先轻锁。'),
 ('2','T13–T16中框＋H05/H06托耳','中框顶Z324提案；加6mm托耳到Z330，试放154方木壳。'),
 ('3','H01–H04木壳 / F04内衬 / F05槽盒','前后板包侧板；PP折边朝外。110×30下口贯通，槽盒牢固且可拆。'),
 ('4','G06 / G11 / G12 / G07–G10滑架','先装导轨、转接、支承与闸片；不接舵机，手推15mm不偏摆不卡滞。'),
 ('5','A03 / G01–G05 / G14 / S01','装支架与短杆，核花键/孔深/摆角；独立6V空载标定限位，启动不自动开闸。'),
 ('6','T17/T18 / B13 / B01 / L02 / PH04','相机固定独立梁；75起试，标尺检120视宽；灯与光电开关对照图像。'),
 ('7','W06 / W01 / W05 / B12','组件资料确认后装；盒、活动台、线缆不得碰外壳；称稳定再报重。'),
 ('8','F06电控 / A08 / A17 / P05 / P06','先不接负载量5V/6V；信号与舵机电流分开走；留排线应力释放。'),
 ('9','P01–P04 / F08 / F07','收到屏与插头后开口；固定前板，侧后检修；复查无背光漏入、无碰称台。'),
 ('10','单槽 → 五槽联调','从少量豆开始；观察夹豆/飞豆/残流/偏转；卡豆停机排障，不持续硬关。')],[70,370,880],38,16)
body+=text(40,618,'连接件清点 / 本次BOM补充',21,bold=True)
body+=table(40,640,1320,['BOM','使用数量','购买/核对事项'],[
 ('F02','角码28用；M5×8/T螺母各56用','购32角码、64螺钉/64 T螺母；只计骨架，另留F08面板固定。'),
 ('F08（新增）','外壳面板16点＋托耳2点＝18点','M5×12、T螺母、垫片各20；6mm板/槽深实际核，不可拿M5×8直接穿板。'),
 ('F08（新增）','料斗木壳8小角片＋托耳外侧2小角片','15×15×约1.5小角片10；M3×12/螺母/垫片各28含备，内侧头平齐并隔离豆路。'),
 ('B13 / G15–G18','相机支架/滑块/导轨/限位各自独立','按各行数量；安装M5件随B13套件核对。不能把相机孔距、限位孔距混用。'),
 ('未逐件画出','电阻、电容、线缆、保险备件、砝码等','完整采购仍以V4.5表为准；互斥工业光电/称重备选没有同时画入整机。')],[145,400,775],36,15)
svgs.append(sheet('06  按BOM组装的顺序与连接件核对','先机架与手推机械，再空载动作与成像，最后称重/面板。图纸检查不代替实机联调。',body,6))

body=text(40,165,'A / 两根型材怎样用角码连接',22,bold=True)
body+=rect(85,215,75,300,C['alu'])+rect(160,440,320,75,C['alu'])
body+=rect(160,354,24,86,C['blue'])+rect(160,416,130,24,C['blue'])
body+=circle(172,391,8)+circle(249,428,8)
body+=line(121,220,121,507,C['muted'],False,5)+line(166,478,468,478,C['muted'],False,5)
body+=line(232,391,180,391,C['orange'],True,3)+line(249,362,249,419,C['orange'],True,3)
body+=lines(80,553,['角码两只脚各一枚M5×8螺钉，旋入各自槽内的T螺母。','先把T螺母滑入/转入槽内，再轻锁角码；校方后锁紧。',
                   '图是连接方向剖示，不是角码实际外形；槽型按同一供应商。'],16,28)
body+=text(750,165,'B / 海洋板怎样固定到型材槽',22,bold=True)
body+=rect(850,250,180,200,C['alu'])+rect(795,250,55,200,C['wood'])
body+=rect(850,325,45,50,'#fffefa')+rect(879,333,32,34,C['blue'])
body+=line(755,350,901,350,C['ink'],False,7)+rect(747,333,13,34,C['ink'])+rect(785,330,10,40,C['blue'])
body+=lines(1070,285,['从外到内：','M5螺钉头','平垫片','6mm海洋板','型材槽内T螺母'],17,31)
body+=dim(795,485,850,485,'6mm板')
body+=lines(750,553,['F08拟用M5×12；有效啮合与是否顶底必须实际试装。','不要拿F02的M5×8直接穿6mm木板。',
                    '面板先只做定位小孔，屏幕/按钮/插头开口另按实物。'],16,28)
body+=text(40,685,'C / 滑架厚度与螺钉方向：螺钉只锁滑块，不向下顶住导轨',21,bold=True)
for yy,h,w,fill,lbl in [(725,13,380,C['alu'],'G08 转接板3'),(760,33,150,C['blue'],'MGN9H轨块总高参考10'),(810,18,380,C['blue'],'G11 底座厚4')]:
    body+=rect(110,yy,w,h,fill)+text(530,yy+16,lbl,17)
body+=line(145,700,145,783,C['orange'],True,3)+line(225,700,225,783,C['orange'],True,3)
body+=text(40,881,'G15：M3×6穿3mm转接板，余下约3mm进入滑块（未计垫片）。收到后量有效牙深，避免顶底或啮合不足。',16)
svgs.append(sheet('07  三种常见连接的放大装配图','螺钉长度按真实板厚、垫片和螺纹深度核对；图示只说明方向及层次，不代替零件厂家尺寸图。',body,7))

names=['01-overall','02-frame','03-plywood','04-gate','05-optics-weight','06-assembly-order','07-connections']
for n,s in zip(names,svgs):(ROOT/(n+'.svg')).write_text(s)
data={'date':'2026-10-13','status':'dimensioned_layout_proposal_not_machining_release','coordinates':{'x':'left_to_right','y':'front_to_rear','z':'frame_bottom_up','units':'mm'},'frame_mm':[220,240,440],'outer_wood_envelope_mm':[232,252,440],'parts':parts,'wood_cuts':woodcuts,'wood_sheet_mm':[600,600,6],'kerf_planning_mm':3,'source_bom':'../procurement-v4.5/beanlens-bom-v4.5.json','unverified':['actual_hardware_holes','gate_servo_plane_and_clearance','load_cell_geometry','camera_PCB_and_lens','all_hardware_assembly'],'drawing_files':[n+'.svg' for n in names]}
(ROOT/'assembly-layout-v4.5.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')
with (ROOT/'cut-list-v4.5.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.writer(f);w.writerow(['零件号','BOM','材料','尺寸mm','数量','状态'])
    for p in frame:w.writerow([p['id'],'F01','2020铝型材','20×20×'+str(max(p['size'])),1,p['status']])
    for id,ww,hh,x,y in woodcuts:w.writerow([id,'F03','6mm海洋板',f'{ww}×{hh}×6',1,'净裁切提案，非孔位图'])

template='''<!doctype html><html lang="zh-CN"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="data:,"><title>BeanLens V4.5 尺寸爆炸图与组装图</title><style>
:root{--bg:#eef2ef;--card:#fffefa;--ink:#223d38;--muted:#62736e;--accent:#087f65;--line:#ced9d2}*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--ink);font:16px/1.65 system-ui,-apple-system,"PingFang SC",sans-serif}main{max-width:1448px;margin:auto;padding:30px 24px}h1{font-size:34px;margin:8px 0}h2{font-size:20px}p{margin:8px 0}.eyebrow{font-size:12px;letter-spacing:2px;color:var(--accent);font-weight:700}a{color:var(--accent)}nav{display:flex;gap:16px;flex-wrap:wrap;margin:20px 0}.card,.sheet{background:var(--card);border:1px solid var(--line);border-radius:12px;margin:20px 0;overflow:hidden}.card{padding:22px}.controls{display:flex;align-items:center;gap:16px;flex-wrap:wrap}button,select,input{font:inherit}button,select{border:1px solid var(--line);border-radius:7px;background:var(--card);color:var(--ink);padding:8px 13px;cursor:pointer}button.primary{background:var(--accent);color:white}.controls label{display:flex;align-items:center;gap:8px}input[type=range]{width:230px;accent-color:var(--accent)}.viewer{display:grid;grid-template-columns:1fr 330px;gap:20px}.viewer svg{width:100%;height:680px;display:block}.info{border-left:1px solid var(--line);padding:12px 0 0 20px;font-size:14px}.info b{font-size:19px}.hint{color:var(--muted);font-size:14px}.sheet>svg{display:block;width:100%;height:auto}.sheet nav{padding:0 24px 12px;margin:0}.warning{border-left:4px solid #cb8351;padding-left:14px}.pick:hover{filter:brightness(1.07)}.pick{cursor:pointer}details{margin-top:20px}summary{cursor:pointer}#list{max-height:300px;overflow:auto}#list button{display:block;width:100%;text-align:left;margin:4px 0;font-size:13px}.unverified{color:#976036}.stat{display:flex;gap:25px;flex-wrap:wrap}.stat strong{font-size:23px}footer{font-size:13px;color:var(--muted)}@media(max-width:900px){main{padding:20px 12px}.viewer{grid-template-columns:1fr}.viewer svg{height:560px}.info{border-left:0;border-top:1px solid var(--line);padding:15px 0}h1{font-size:27px}.sheet{overflow:auto}.sheet>svg{min-width:1050px}}@page{size:A3 landscape;margin:12mm}@media print{body,main{margin:0;padding:0;background:white;max-width:none}.no-print,.sheet nav{display:none!important}.sheet{width:396mm;height:273mm;margin:0;padding:0;border:0;border-radius:0;break-after:page;overflow:visible}.sheet:last-of-type{break-after:auto}.sheet>svg{width:396mm;height:271.54mm;min-width:0}a{color:inherit}}
</style></head><body><main><header class="no-print"><div class="eyebrow">BEANLENS / DIMENSIONED ASSEMBLY / 2026-10-13</div><h1>铝型材、海洋板与部件，怎样装在一起</h1><p>先用下方模型看装配关系，再看七张尺寸图。点击零件或列表，读取BOM编号、规格和安装注意事项。</p><nav><a href="../../../output/pdf/beanlens-assembly-v4.5-20261013.pdf">下载7页A3 PDF</a><a href="cut-list-v4.5.csv" download>下载型材/木板裁切表</a><a href="assembly-layout-v4.5.json" download>下载布局数据</a><a href="../procurement-v4.5/beanlens-procurement-v4.5.html">当前BOM</a><a href="../illustrations/beanlens-gate-motion-20261012.html">滑闸运动动画</a><button onclick="window.print()">打印七张图</button></nav><p class="warning">这是尺寸化装配提案，不是已验收加工图。实线标准件/板料按标注核对；元件占位与未定孔位明确标记。所有螺孔先按实物纸样确认。</p></header>
<section class="card no-print"><div class="controls"><button id="assembled">组装状态</button><button id="exploded" class="primary">爆炸状态</button><label>分解程度 <input id="explode" type="range" min="0" max="100" value="100"><span id="explodeVal">100%</span></label><label>显示 <select id="group"><option value="">全部部件</option>__GROUPS__</select></label><label><input id="wood" type="checkbox" checked>显示外壳面板</label></div><div class="viewer"><svg id="model" viewBox="0 0 980 800" role="img" aria-label="可选取部件的组装与爆炸模型"></svg><aside class="info"><b id="partTitle">选择一个部件</b><p id="partBom">编号与BOM在此显示</p><p id="partSize"></p><p id="partNote">模型用于看安装关系；真实螺孔和接触面见尺寸页及收到的部件。</p><p id="partStatus" class="unverified"></p><details open><summary>零件目录</summary><div id="list"></div></details></aside></div><p class="hint">前方是取豆方向，背面是低压电控检修区。组装模型使用简化包络；例如称重虚框不是HJ-AZ4实际外形。</p></section>
__SHEETS__<footer class="no-print"><p>资料来源：当前V4.4手册、V4.5采购表、槽内缓关补充。新布局变更：托耳40×30、中框顶Z324、轨距94提案；F02角码与F08面板固定件已同步。无采购、加工、实物承载或电气验收。</p></footer></main><script>
const DATA=__DATA__;
(()=>{const $=id=>document.getElementById(id),NS='http://www.w3.org/2000/svg';let chosen='';function el(tag,attrs,parent){const n=document.createElementNS(NS,tag);for(const [k,v]of Object.entries(attrs))n.setAttribute(k,v);parent.append(n);return n}function select(id){const p=DATA.parts.find(p=>p.id===id);if(!p)return;chosen=id;$('partTitle').textContent=p.id+' · '+p.name;$('partBom').textContent='BOM '+p.bom;$('partSize').textContent='绘制包络 '+p.size.join(' × ')+' mm';$('partNote').textContent=p.note||'按所属组件说明装配。';$('partStatus').textContent=p.status+'；未实物验收';render()}function render(){const e=+$('explode').value/100;$('explodeVal').textContent=Math.round(e*100)+'%';const ps=DATA.parts.filter(p=>(!$('group').value||p.group===$('group').value)&&($('wood').checked||p.group!=='海洋板'));const svg=$('model');svg.replaceChildren();if(!ps.length)return;const raw=v=>[.8660254*(v[0]+v[1]),.5*(v[0]-v[1])-v[2]],items=ps.map(p=>{const q=p.pos.map((v,i)=>v+p.explode[i]*e),s=p.size;return {p,q,vs:[[0,0,0],[1,0,0],[1,1,0],[0,1,0],[0,0,1],[1,0,1],[1,1,1],[0,1,1]].map(a=>a.map((v,i)=>q[i]+v*s[i]))}});const pts=items.flatMap(it=>it.vs.map(raw)),xs=pts.map(p=>p[0]),ys=pts.map(p=>p[1]),a=Math.min(...xs),b=Math.max(...xs),c=Math.min(...ys),d=Math.max(...ys),k=Math.min(850/(b-a),700/(d-c)),pr=v=>{const [x,y]=raw(v);return[490+(x-(a+b)/2)*k,400+(y-(c+d)/2)*k]};items.sort((a,b)=>(a.q[0]-a.q[1]+a.q[2]*.08)-(b.q[0]-b.q[1]+b.q[2]*.08));for(const {p,vs}of items){const g=el('g',{'class':'pick','data-id':p.id,tabindex:0,role:'button','aria-label':p.id+' '+p.name},svg);const title=el('title',{},g);title.textContent=p.id+' · '+p.name+' · BOM '+p.bom;const q=vs[0],w=p.size[0],d=p.size[1],h=p.size[2],local=arr=>arr.map(v=>pr(v.map((a,i)=>a+q[i]))),attrs={fill:p.color,'fill-opacity':['bin','hopper','lanebox','placeholder'].includes(p.shape)?'.4':'.95',stroke:p.id===chosen?'#00876b':'#39554c','stroke-width':p.id===chosen?3:1.1,'stroke-dasharray':p.shape==='placeholder'?'6 4':''},face=arr=>el('polygon',{...attrs,points:local(arr).map(v=>v.join(',')).join(' ')},g),edge=arr=>el('polyline',{...attrs,fill:'none',points:local(arr).map(v=>v.join(',')).join(' ')},g);if(p.shape==='hopper'){face([[15,55,0],[125,55,0],[140,0,110],[0,0,110]]);face([[125,55,0],[125,85,0],[140,140,110],[140,0,110]]);edge([[0,0,110],[140,0,110],[140,140,110],[0,140,110],[0,0,110]]);edge([[15,55,0],[125,55,0],[125,85,0],[15,85,0],[15,55,0]])}else if(p.shape==='bin'){for(const inds of [[0,1,5,4],[1,2,6,5],[0,1,2,3]])el('polygon',{...attrs,points:inds.map(i=>pr(vs[i]).join(',')).join(' ')},g);edge([[0,0,h],[w,0,h],[w,d,h],[0,d,h],[0,0,h]])}else if(['base','support','opticalbase'].includes(p.shape)){let outer=[[0,0,h],[w,0,h],[w,d,h],[0,d,h]],holes=[];if(p.shape==='base')outer=[[0,0,h],[29,0,h],[29,32,h],[111,32,h],[111,0,h],[140,0,h],[140,140,h],[85,140,h],[85,80,h],[55,80,h],[55,140,h],[0,140,h]];else if(p.shape==='support')for(let i=0;i<5;i++)holes.push([[14+i*17,9,h],[28+i*17,9,h],[28+i*17,21,h],[14+i*17,21,h]]);else holes=[[[25,75,h],[155,75,h],[155,125,h],[25,125,h]]];const path=[outer,...holes].map(loop=>'M'+local(loop).map(v=>v.join(',')).join(' L')+' Z').join(' ');el('path',{...attrs,d:path,'fill-rule':'evenodd'},g)}else if(p.shape==='link'){edge([[0,65.8117,1],[14.1333,58.3117,1],[0,0,1]])}else for(const inds of [[0,1,5,4],[1,2,6,5],[4,5,6,7]])el('polygon',{...attrs,points:inds.map(i=>pr(vs[i]).join(',')).join(' ')},g);const center=p.pos.map((v,i)=>v+p.size[i]/2+p.explode[i]*e),[x,y]=pr(center);el('rect',{x:x-20,y:y-12,width:40,height:21,rx:3,fill:'#fffefa',stroke:'#b8c7c1'},g);const t=el('text',{x,y:y+3,'text-anchor':'middle','font-size':11,fill:'#223d38'},g);t.textContent=p.id;g.onclick=()=>select(p.id);g.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();select(p.id)}}} }$('explode').oninput=render;$('group').onchange=render;$('wood').onchange=render;$('assembled').onclick=()=>{$('explode').value=0;render()};$('exploded').onclick=()=>{$('explode').value=100;render()};for(const p of DATA.parts){const b=document.createElement('button');b.textContent=p.id+' · '+p.name+' ['+p.bom+']';b.onclick=()=>select(p.id);$('list').append(b)}window.beanlensAssembly={data:DATA,select,render};render()})();
</script></body></html>'''
template=template.replace('__GROUPS__',''.join(f'<option>{g}</option>' for g in dict.fromkeys(p['group'] for p in parts)))
template=template.replace('__SHEETS__',''.join(f'<section class="sheet" id="sheet{i}">{s}<nav class="no-print"><a href="{n}.svg" download>下载本页矢量SVG</a></nav></section>' for i,(s,n) in enumerate(zip(svgs,names),1)))
template=template.replace('__DATA__',json.dumps(data,ensure_ascii=False).replace('</','<\\/'))
(ROOT/'beanlens-assembly-v4.5.html').write_text(template)
print(f'Generated {len(parts)} parts, 7 SVG sheets, HTML, layout JSON and cut list.')
