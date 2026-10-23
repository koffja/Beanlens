"""Generate only the independent H1 documents. Does not execute or modify full-version generators."""
from pathlib import Path
import math,json,csv,html
from draw_helpers import *
ROOT=Path(__file__).resolve().parent;REPO=ROOT.parents[2]
d=json.loads((ROOT/'design-h1.json').read_text());b=json.loads((REPO/'config/hardware-hackathon-h1.json').read_text());g=d['geometry'];ch=g['chute'];parts=[]
def part(id,bom,name,pos,size,col,group,e=(0,0,0),note='',shape='box',**kw):
 p=dict(id=id,bom=bom,name=name,pos=pos,size=size,color=C.get(col,col),group=group,explode=list(e),note=note,shape=shape,**kw);parts.append(p);return p
n=0
for x,y in [(0,0),(200,0),(0,220),(200,220)]:
 n+=1;part(f'T{n:02}','H14','黑2020立柱460',[x,y,0],[20,20,460],'frame','骨架',((x-100)*.3,(y-110)*.3,0))
for z in [0,440]:
 for y in [0,220]:
  n+=1;part(f'T{n:02}','H14','黑2020宽梁180',[20,y,z],[180,20,20],'frame','骨架',(0,(y-110)*.3,-30 if z==0 else 60))
 for x in [0,200]:
  n+=1;part(f'T{n:02}','H14','黑2020深梁200',[x,20,z],[20,200,20],'frame','骨架',((x-100)*.3,0,-30 if z==0 else 60))
for id,z in [('P01',20),('P02',180),('P03',344)]:part(id,'H16','固定海洋板平台',[22,22,z],[176,196,6],'wood','平台',(0,0,-55 if z==20 else 75 if z==344 else 15),shape='platform',aperture=[85,122,50,45] if z==180 else None,note='176×196×6；工作板孔50×45。均固定，不安装称重。')
for k,z in enumerate([20,180,344]):
 for j,(x,y) in enumerate([(20,40),(185,40),(20,180),(185,180)]):part(f'Q{k}{j}','H17','平台承托角片',[x,y,z-20],[15,20,20],'alu','平台',((x-100)*.5,0,20),note='只画支承包络；竖脚向下，M5锁框槽，水平脚承平台底。孔位/根部R按实际配套。',shape='angle',right=x>100)
part('B01','H13','PP3槽盒底座',[75,65,186],[80,110,3],'pp','停豆槽',(0,0,40),shape='platform',aperture=[90,124,40,40],note='落豆开口40×40，全局X90/Y124，必须连通下方木板孔。')
u=ch['upstream_y'];top=ch['upstream_z'];span=124-u
part('C01','H13','PP3斜槽底',[98,u,top],[24,60,3],'pp','停豆槽',(0,-65,75),shape='ramp',note='板面24×60×3，35°起试；模型给的是面长，不是水平投影。')
for id,x,ex in [('C02',95,-55),('C03',122,55)]:part(id,'H13','PP3槽壁及下支承',[x,u,189],[3,span,top+14-189],'pp','停豆槽',(ex,0,60),shape='chuteside',note='侧片水平底49.149，前高79.414，后高45；一片兼作槽壁和下支承。')
part('S01','H03','MG996R，轴竖直',[130,118,197],[19.7,40.7,42.9],'orange','摆闸',(80,45,50),note='机身外形仅参考；输出轴目标X140/Y126/Z240，原厂轴偏置和支架待实量。')
part('S02','H10','舵机固定架/转接',[125,115,186],[60,60,3],'alu','摆闸',(90,45,20),note='60方毛坯；必须避落豆孔/槽壁，支架高度与固定孔按实物。',shape='outline')
part('S03','H11','25T直舵臂16mm孔',[122,122,239],[20,8,2],'alu','摆闸',(65,0,100),note='输出轴X140/Y126；16mm孔在X124/Y126；相对0/90仅示意，不是标定PWM。')
part('S04','H12','挡片连接角铝',[118,124,220.5],[12,20,20],'alu','摆闸',(70,0,100),note='20×20×2切宽12；开孔与安装朝向按舵臂/PP挡片实配。',shape='outline')
part('S05','H13','PP3侧摆挡片',[94,124.5,220.5],[46,3,18],'pp','摆闸',(0,85,70),note='闭合覆盖24mm出口，底比槽底高0.5起试；顺时针向后摆90°清空出口；只在空槽时关。')
part('S06','H13','限位触发旗片',[110,122,242],[30,16,3],'orange','摆闸',(50,0,110),note='随挡片固定角件转动，开/关检测同一刚性组件；旗片孔位与碰轮位置样件调。',shape='outline')
for id,x,y in [('L01',108,116),('L02',135,151)]:part(id,'H09','SS-01GL限位占位',[x,y,244],[20,7,8],'orange','摆闸',(45,35,80),note='固定在支架，不跟舵机转动；检测旗片，实际触发高度/孔距需试装。')
part('CAM','H02','唯一GC2093相机占位',[90,92,320],[40,40,25],'blue','成像',(0,-30,160),note='40×40×25仅占位！镜头朝下、光轴X110/Y112；80–140mm起试调焦。')
part('CAMM','H18','相机PP安装毛坯',[80,82,341],[60,60,3],'pp','成像',(0,-30,190),note='60方PP3；按PCB孔距/突出物定孔，不能按40方包络钻孔。')
for id,x in [('LEDL',73),('LEDR',148)]:part(id,'H07 / H08','灯带与铝槽',[x,62,270],[14,100,8],'orange','成像',((-60 if x==73 else 60),0,90),note='100有效段按实际切点重定；安装倾角朝停豆位，连续常亮，不用PWM调光。')
part('BOX','H01','K230D BOX含主屏',[77.85,1,346.2],[64.3,15.4,47.6],'blue','主屏',(0,-130,50),note='原壳夹持，KEY0/KEY1和Type-C1/TF可达；不另购屏。')
part('BOXM','H19','BOX夹持承板',[22,17,334],[176,3,88],'wood','主屏',(0,-90,50),note='176×112毛坯可裁至88高；按原壳实配夹片，不钻原壳。')
for id,x in [('SHL',65),('SHR',175)]:part(id,'H20','侧遮光片',[x,70,225],[2,120,100],'#353d39','遮光',((-90 if x==65 else 90),0,0),note='可拆黑PP2，不承料斗/相机重量。')
part('SHB','H20','后遮光片',[65,190,225],[110,2,100],'#353d39','遮光',(0,120,0),note='前方敞开人工投豆，后板避摆片扫掠。')
part('CUP','H21','固定收豆杯',[60,95,26],[100,100,80],'pp','收豆',(0,-95,-20),shape='cup',note='杯直接放固定底板，所有类别混合收集；不称重。')
part('PWR','H04 / H05 / H06 / H22 / H28','机外电源/缓冲盒占位',[270,40,0],[200,150,80],'blue','机外配电',(80,0,0),shape='outline',note='示意采购包络；适配器外形未知，不把此框当YU2405尺寸。')
# Flat cutting records distinguish face lengths from horizontal projections.
cuts=[['H14','黑欧标2020','460','4','原料460×4保留'],['H14','黑欧标2020','200','4','460×3各出1，400×1出1'],['H14','黑欧标2020','180','4','同上；另1根400不切'],['H16','海洋板6','176×196','3','工作台另开50×45孔'],['H13','PP-H3','24×60','1','斜槽底板面尺寸，35°'],['H13','PP-H3',f'梯形：底{span:.3f}/前高{top+14-189:.3f}/后高45','2','竖直侧支承，两片对称'],['H13','PP-H3','80×110','1','X75/Y65，开40×40落豆孔'],['H13','PP-H3','46×18','1','侧摆挡片；厚3；圆角去毛刺'],['H13','PP-H3','30×16','1','限位旗片毛坯，实配'],['H12','6061角铝20×20×2','宽12×1；宽15×2','3','挡片角件1＋固定槽底脚2'],['H18','PP-H3','60×60','1','相机载板，孔实配'],['H20','黑PP2','120×100','2','侧遮光'],['H20','黑PP2','110×100','1','后遮光'],['H19','木/PP余料','176×112','1','BOX固定承板，必要时裁88高']]
with (ROOT/'cut-list-h1.csv').open('w',encoding='utf-8-sig',newline='') as f:w=csv.writer(f,lineterminator='\n');w.writerow(['BOM','材料','裁切mm','数量','说明']);w.writerows(cuts)
(ROOT/'assembly-h1.json').write_text(json.dumps(dict(revision='H1',parts=parts,geometry=g),ensure_ascii=False,indent=2)+'\n')
with (ROOT/'bom-h1.csv').open('w',encoding='utf-8-sig',newline='') as f:
 w=csv.writer(f,lineterminator='\n');w.writerow(['编号','名称','型号','规格','数量','单位','采购状态','完整版对应','说明','单价CNY'])
 for p in d['bom']:w.writerow([p[k] if p[k] is not None else '' for k in ['id','name','model','spec','qty','unit','status','full_bom','notes','unit_price_cny']])
(ROOT/'bom-h1.json').write_text(json.dumps(dict(revision='H1',date=d['date'],items=d['bom'],total_cny=None,unknown_prices_are_not_zero=True),ensure_ascii=False,indent=2)+'\n')

def verts(p):
 x,y,z=p['pos'];w,deep,h=p['size']
 if p['shape']=='ramp':
  a=math.radians(35);out=[]
  for xx,along,t in [(0,0,0),(1,0,0),(1,1,0),(0,1,0),(0,0,1),(1,0,1),(1,1,1),(0,1,1)]:out.append([x+xx*w,y+along*deep*math.cos(a)-t*3*math.sin(a),z-along*deep*math.sin(a)-t*3*math.cos(a)])
  return out
 if p['shape']=='chuteside':return [[x+xx*w,y+yy*deep,z+zz*(h if yy==0 else 45)] for xx,yy,zz in [(0,0,0),(1,0,0),(1,1,0),(0,1,0),(0,0,1),(1,0,1),(1,1,1),(0,1,1)]]
 return [[x+xx*w,y+yy*deep,z+zz*h] for xx,yy,zz in [(0,0,0),(1,0,0),(1,1,0),(0,1,0),(0,0,1),(1,0,1),(1,1,1),(0,1,1)]]
for p in parts:p['vertices']=verts(p)
(ROOT/'assembly-h1.json').write_text(json.dumps(dict(revision='H1',parts=parts,geometry=g),ensure_ascii=False,indent=2)+'\n')
def iso(ps,box,e=0,labels=(),bounds=None):
 raw=lambda v:(.8660254*(v[0]+v[1]),.5*(v[0]-v[1])-v[2])
 def vs(p):return [[v[i]+p['explode'][i]*e for i in range(3)] for v in p['vertices']]
 vv=[v for p in ps for v in vs(p)] if bounds is None else bounds
 pt=[raw(v) for v in vv];xs=[v[0] for v in pt];ys=[v[1] for v in pt];minx,maxx,miny,maxy=min(xs),max(xs),min(ys),max(ys);ox,oy,vw,vh=box;k=min((vw-40)/(maxx-minx),(vh-30)/(maxy-miny))
 def pr(v):x,y=raw(v);return [ox+vw/2+(x-(minx+maxx)/2)*k,oy+vh/2+(y-(miny+maxy)/2)*k]
 out='';ann=''
 for p in sorted(ps,key=lambda p:p['pos'][0]-p['pos'][1]+p['pos'][2]*.15):
  v=vs(p);col=p['color'];op=.3 if p['shape'] in ['cup','outline'] else .75 if p['group']=='遮光' else .96
  out+=f'<g data-part="{p["id"]}">'
  if p['shape']=='outline':
   for i,j in [(0,1),(1,2),(2,3),(3,0),(4,5),(5,6),(6,7),(7,4),(0,4),(1,5),(2,6),(3,7)]:out+=line(*pr(v[i]),*pr(v[j]),C['orange'],True)
  elif p['shape']=='angle':
   x,y,z=p['pos'];w,dep,h=p['size'];ex,ey,ez=[a*e for a in p['explode']];x+=ex;y+=ey;z+=ez;xx=x+w-2 if p.get('right') else x
   out+=poly([pr(v) for v in [[x,y,z+h],[x+w,y,z+h],[x+w,y+dep,z+h],[x,y+dep,z+h]]],col)
   out+=poly([pr(v) for v in [[xx,y,z],[xx+2,y,z],[xx+2,y,z+h],[xx,y,z+h]]],col)
  elif p['shape']=='platform' and p.get('aperture'):
   x,y,ww,dd=p['aperture'];zz=p['pos'][2]+p['size'][2]+p['explode'][2]*e;ex,ey=p['explode'][:2]
   loops=[[pr(v[i]) for i in [4,5,6,7]],[pr([xx+ex*e,yy+ey*e,zz]) for xx,yy in [(x,y),(x+ww,y),(x+ww,y+dd),(x,y+dd)]]]
   out+='<path d="'+' '.join('M'+' L'.join(f'{x:.2f},{y:.2f}' for x,y in loop)+' Z' for loop in loops)+f'" fill="{col}" fill-rule="evenodd" stroke="{C["ink"]}"/>'
  else:
   for face in ([[0,1,5,4],[1,2,6,5],[0,1,2,3]] if p['shape']=='cup' else [[0,1,5,4],[1,2,6,5],[4,5,6,7]]):out+=poly([pr(v[i]) for i in face],col,op)
  if p['id'] in labels:
   center=[sum(a[i] for a in v)/8 for i in range(3)];x,y=pr(center);ann+=rect(x-23,y-11,46,21,'#fffefa',C['line'],3)+text(x,y+4,p['id'],12,anchor='middle')
  out+='</g>'
 return out+ann
sheets=[];frame=[p for p in parts if p['group']=='骨架'];inner=[p for p in parts if p['group'] not in ['遮光','机外配电']]
major=['BOX','CAM','S01','CUP'];body=text(50,165,'人工逐颗投豆 / 停住再拍 / 拍完放走',22,bold=True)+iso(inner,(30,185,610,610),0,major)
body+=text(730,165,'同一组件的分解方向（非安装距离）',22,bold=True)+iso(inner,(720,185,650,610),.75,major)
body+=lines(45,826,['骨架保留220×240×460；12根型材，现有460×7和400×2足够，不新增型材。',
 'BOX独立完成识别/显示/动作；无C6、无称重、无第二相机、无对射、无刷排、无联网。',
 '以单颗静止豆的当前可见面做初筛；不自动分选，所有样本落同一杯。'],18,27)
sheets.append(sheet('01  比赛版H1：整机组装与爆炸关系','当前是可审查的原型尺寸方案；现有完整版V4.12完整保留。前方敞开手投，遮光片可拆。',body,1))
mech=[p for p in parts if p['group'] in ['停豆槽','摆闸']]
body=iso(mech,(30,155,620,620),.8,['B01','C01','C02','C03','S01','S03','S05','L01','L02'])
body+=table(670,155,690,['图号 / BOM','装配关系'],[
 ('C01–03 / H13','PP3槽底24×60；两侧片兼下支承；35°起试'),('B01 / H13','80×110×3底座；开40×40落豆孔'),('S01/S02 / H03/H10','MG996R固定；轴竖直，目标(140,126,240)'),('S03/S04 / H11/H12','25T直臂16mm孔 → 小角铝 → 轻PP挡片'),('S05 / H13','挡片46×18×3，关闭挡出口，向后侧摆90°'),('S06 / H13','刚性旗片跟随挡片，2固定微动开关检测'),('L01/L02 / H09','开关限位NO接地；未触发上拉；检测真实摆片'),('CAM / H02','光轴(110,112)，镜头Z320起试，调焦后定孔')],[225,465],44,15)
body+=lines(680,585,['豆在固定斜槽末端靠挡片停住，拍摄时舵机不动作。',
 '单颗、双手移开后按KEY0；结果保存后再开闸放走。',
 '空槽确认后才关闸，避免以缓关代替卡豆防护。',
 '本版无双球头杆、直线导轨、长横梁、大PP料斗。',
 '90°仅几何演示；真实PWM端点与超时须空载标定。',
 '轴偏置、角件孔位和限位碰轮高度按实物试配。',
 '相机/支架毛坯不是厂家孔位图；先纸样再钻孔。'],17,33)
sheets.append(sheet('02  停豆槽、侧摆闸与限位爆炸图','MG996R仅带轻挡片；禁止人工按压挡片。两个限位不靠舵机命令推断到位。',body,2))
body=text(45,160,'H13 PP3裁切 / YZ侧视',22,bold=True)
# Exact side-support profile and inclined floor, expanded 4x.
a=math.radians(35);sx=4;px=lambda y:100+(y-u)*sx;pz=lambda z:660-(z-189)*sx
body+=poly([(px(u),pz(189)),(px(124),pz(189)),(px(124),pz(234)),(px(u),pz(top+14))],C['pp'],.45)
body+=line(px(u),pz(top),px(124),pz(220),C['blue'],False,6)
body+=text(45,720,f'侧片×2：水平底{span:.3f}，上游高{top+14-189:.3f}，下游高45',16)
body+=text(45,751,'蓝线=槽底上表面；底板按24×60面长裁，厚3',16)
body+=text(45,782,'两侧名义内净24，内焊筋后有效宽目标≥20',16)
body+=table(600,155,760,['物料','数量/裁切','说明'],[
 ('黑2020','460×4 / 200×4 / 180×4','12段；4根460直接作柱'),('余3根460','各切200+180','每根余80扣锯缝/端面修整'),('1根400','切200+180','余20扣锯缝；另一根400保留'),('海洋板6','176×196共3片','底/工作/相机平台Z20/180/344'),('PP3底座','80×110×1','开40×40口；与木板孔对齐'),('PP3挡片/旗片','46×18 / 30×16，各1','孔按舵臂/限位纸样'),('黑PP2','120×100两片；110×100一片','三片遮光，前方留手投口'),('紧固/灯/相机','详BOM H08/H17/H18/H30','不凭占位图钻最终孔')],[150,300,310],47,15)
body+=lines(610,640,['工作板孔：全局X85/Y122，50×45；底座孔X90/Y124，40×40。',
 '前后/左右必须对齐，禁止豆被木板或底座挡住。',
 'PP3先小样焊接，冷却去毛刺；实豆能滑至挡片再固定坡度。',
 'PP3 200方与相机载板一起排版；遮光PP2 300×200候选。',
 '模块底189，槽底下端220，上端254.414，槽壁高14。',
 '不按旧完整版的1kg料斗承载计算本版手投支架。'],16,34)
sheets.append(sheet('03  现有型材配料与单槽PP裁切','单位mm。板面长、水平投影和高度分别标注；斜槽不按60mm水平长误裁。',body,3))
body='';box=lambda x,y,w,h,title,ss: rect(x,y,w,h,'#edf3ef',C['line'],8)+text(x+15,y+30,title,23,bold=True)+lines(x+15,y+60,ss,17,27)
body+=box(45,180,280,140,'YU2405（机外）',['24V / 5A / 120W','插头与极性按实物','成品AC线留机外'])
body+=box(510,180,310,128,'TPS5450成品板候选',['24V→5.00V / 3A预算','整板SKU/热性能待验'])
body+=box(510,388,310,128,'UBEC5A / 30607000',['24V→6.0V，2–8S版','断电设6V跳帽，再实测'])
body+=box(510,600,310,110,'24V灯带',['两段各100mm有效长','合计≤4W预算，常亮'])
body+=box(1000,180,355,140,'K230D BOX / 缓冲板',['5V→BOX Type-C1','5V→AHCT125的14脚','禁止从Type-C2供电'])
body+=box(1000,388,355,140,'6V开关 → MG996R',['OUT+→红线6V','OUT−→棕/黑GND','1000µF/16V就近并联'])
for y,title in [(240,'1.5A'),(448,'3A'),(655,'1A')]:body+=line(325,248,400,248,C['orange'],False,3)+line(400,248,400,y,C['orange'],False,3)+line(400,y,510,y,C['orange'],False,3)+text(433,y-13,title,16,C['orange'])
body+=line(820,238,1000,238,'#b94d43',False,4)+line(820,448,1000,448,'#80619c',False,4)
body+=lines(45,390,['主保险4A在24V正输入近端。','各负载的返回线独立回降压/分线端。','BOX信号地与UBEC负端共参考。','舵机电流不经过主板脚或杜邦线。','6V开关断开时先装配/初始化。','切断PWM不保证停电自闭。'],17,34)
body+=lines(45,780,['24V只给灯和降压输入；5V和6V正端绝不相连。共同参考地不等于整机电气隔离。',
 '预算：5V×3A/0.8 + 6V×3A/0.8 + 灯4W =45.25W持续；舵机按5A短峰为60.25W。',
 '这是预算，不是实测；保险保护线束，不负责卡豆检测。先断负载量5V/6V，再逐支路接入。'],18,32)
sheets.append(sheet('04  H1供电接线：一块BOX与独立6V舵机','24V适配器和低压配电放机外。信号详情看下一页；确认所有端子极性后上电。',body,4))
body=box(45,170,430,220,'K230D BOX：J10（2×6）',['1脚 GPIO25 / PWM5 →1k→IC 2脚1A','2脚 GPIO24 →1k→关限位NO','3脚 GPIO23 →1k→开限位NO','4脚 GPIO22 →4.7k→NPN基极','J10没有GND或5V；不要凭位置找地','J6口1：2脚GND；其余3针不接'])
body+=box(550,170,420,220,'SN74AHCT125N，DIP14',['14=5V，7=GND，100nF紧贴14/7','2=1A输入；3=1Y→220Ω→舵机信号','1=/OE：10k上拉5V，NPN下拉使能','2脚1A另用10k下拉GND','闲置4/10/13脚接5V（禁能）','闲置5/9/12脚接GND'])
body+=box(1040,170,315,220,'2N3904使能',['E→公共GND','C→IC1脚 /OE','B←GPIO22经4.7k','B另经100k→GND','按厂家图确认E/B/C','GPIO22=1才传PWM'])
body+=box(45,455,625,180,'两只限位：固定开关，检测刚性旗片',['COM→公共GND；NO→各自GPIO，串1k','GPIO24/23设内部上拉；触发=0，不触发=1','两者同时0、到位超时或状态不合理→FAULT','仅空槽时关闸；卡住不持续加力，不伪报已关'])
body+=box(725,455,630,180,'板载按键和相机',['KEY0 / GPIO34：确认单颗并启动；忙时重复按忽略','KEY1 / GPIO35：软件停止，记录未完成','KEY2 / GPIO0：启动模式相关，保留不用','单GC2093→兼容CSI；内置屏；不接C6或UART协议'])
body+=rect(45,655,1310,45,'#e3eee6',C['line'],5)+text(65,684,'GPIO25 / PWM5 → 1k → AHCT125的1A / 1Y → 220Ω → MG996R信号；GPIO22只控制NPN使能',19)
body+=lines(45,715,['缓冲默认/OE为高禁能；GPIO22经NPN控制，5V上拉不会直接进GPIO。输入/输出方向不能反接。',
 '不要用普通74HC125替代AHCT/HCT阈值。舵机PWM为5V，主板GPIO仍3.3V。',
 '先不接舵机，用示波器/逻辑分析仪检查50Hz和禁能，再空载标定端点；图中0/90不是PWM脉宽。',
 'GPIO25在BOX原理图列PWM5；实机fpioa.help(25)与PWM5可用性仍须核。针1方向按丝印/万用表复核。',
 'KEY1只能在应用正常运行时响应；不称硬件急停，单板卡死后的故障处置需独立电源开关。'],17,33)
sheets.append(sheet('05  H1信号逐线接法 / 不沿用C6引脚','依据ATK-DNK230D V1.0原理图：J10针1=IO25，针2=IO24，针3=IO23，针4=IO22；实物针序先确认。',body,5))
body=table(45,155,1310,['阶段','操作/预期','失败处理'],[
 ('0 固定图推理','BOX单摄预览、固定ROI、真实模型KPU推理、主屏显示','未跑通不接执行器；保留原训练环境/权重'),('1 空载机构','舵机6V断开先手转；检查0/90几何与限位，之后小角度','卡滞先修机械；不加力硬顶，不猜舵机脉宽'),('2 待投豆','关限位有效/开限位无效，人工放一颗、双手离开后KEY0','限位矛盾/位置不明不运行；不自动找零'),('3 停豆拍摄','相机持续预览，豆静止后取ROI；拒绝明显空槽/多豆/模糊','人工重放；图像检查不保证发现所有贴连'),('4 识别/记录','仅当前可见面；原标签映射；存1张JPEG+本地结果','推理/存储失败保持关，标未完成，不自动放走'),('5 显示/放走','正常结果展示后开；低置信拒判需KEY0确认才放走','拒判不算正常；所有样本入同一杯'),('6 确认空槽再关','开限位确认，清空条件满足后缓关，关限位确认回等待','空槽不明确/开关超时→故障；不持续加力'),('7 连续10次','重复10个有效人工样本，照片/结果/动作一一对应','重复按键不重复记数，空拍不增加样本数')],[160,655,495],65,16)
body+=lines(45,760,['H1仅提供设计文件和教学动画，不表示已经完成固件、KPU、机械、光学或电气验收。',
 '模型部署优先于外壳美化；TF存储先设100次样本上限，满时停止新增循环，不覆盖用户已有文件。',
 '本包不修改firmware/k230d/bringup内用户新增工作；完整版资料保持原字节。'],17,34)
sheets.append(sheet('06  比赛验收顺序与运行状态','先图像和真实端侧推理，再空载舵机，最后人工单颗；动画秒数不能作为实际超时参数。',body,6))
# Reuse the audited paired positive/return topology, with H1-only labels.
import xml.etree.ElementTree as ET
wire=ET.parse(ROOT.parent/'revision-v4.11/05-power-wiring-candidates.svg').getroot()
wire.set('width','1400');wire.set('height','960')
rename={
 'BEANLENS  /  V4.11  /  05':'BEANLENS / HACKATHON H1 / 04',
 '橙24V、红5V、紫6V、黑返回；蓝虚线为信号。跨桥不相连，圆点是接点；TB端子定义见配套说明。':'橙24V、红5V、紫6V、黑返回；蓝虚线为缓冲后信号。跨桥不连接，圆点才是接点。',
 'A07 外置适配器':'H04 外置适配器','P03 插头尺寸与中心正负先实测':'H29 插头尺寸与中心正负先实测',
 'TB-A 1–3':'24V+ 分线','TB-A 4–6':'24V 返回','灯 2A':'灯 1A','A05 共 0.4m，预算 ≤8W':'H07 共0.2m，预算 ≤4W',
 '5V 输入 2A':'5V 输入1.5A','A08 TPS5450 候选':'H05 TPS5450候选','供两板与低压外设，共 ≤4A':'给BOX与缓冲板，共≤3A',
 'TB-B 1 / 2':'独立5V支路','P09 5V 配电板':'H29 5V分线','双 USB-A → 成品 A→C 短线':'成品USB-A → C短线',
 '→ BOX Type-C1 电源口 + C6':'→ BOX Type-C1 电源口','辅助 5V/GND → SEN0503 对射':'辅助5V/GND → AHCT缓冲板','C6 3.3V/GND → NAU7802':'无C6、称重、对射支路',
 'C02 470µF/10V 并在 5V 与返回':'5V仅给BOX/缓冲，禁接6V',
 'A17 UBEC 5A':'H06 UBEC 5A','TB-B 3 / 4':'独立6V支路','P14 XT30 → MG996R':'H28 6V开关→MG996R','C01 1000µF/16V 就近并联':'H26 1000µF/16V就近并联',
 '不能从 C6 板脚给舵机供电':'不能从BOX板脚给舵机供电','C6 GPIO2 · 信号输出':'BOX → H22 PWM缓冲',
 'C6 GPIO2 → 舵机信号（拟定 50Hz / 3.3V 接受能力待测）':'BOX GPIO25/PWM5 → H22 3.3/5V缓冲 → 舵机信号（50Hz，见第5页）',
 '功率预算：持续 56.5W / 短峰 71.5W（两路降压按 80%）→ 24V / 5A 有预算余量；仍须实测温升与压降。':'功率预算：持续45.25W / 短峰60.25W（两路降压按80%）→ 24V/5A；仍须实测温升与压降。',
 '2026-10-17 · 样机方案 / 尚未带载、带豆或焊接验收 · 电气连接按端子文字核对，不按图中物理引脚位置猜接':'2026-10-19 · H1设计方案，尚未电气/机械验收 · 按端子标识核线，不按图中物理位置猜接','5 / 6':'4 / 6'
}
for el in wire.iter():
 if el.tag.endswith('text') and el.text in rename:
  el.text=rename[el.text]
  if el.text=='BOX → H22 PWM缓冲':el.set('style','font-size:18px')
  if el.text.startswith('BOX GPIO25/PWM5'):
   el.set('style','font-size:16px');el.set('x','820')
sheets[3]=ET.tostring(wire,encoding='unicode').replace('ns0:','').replace(':ns0','')
names=['01-overall','02-exploded','03-cuts','04-power','05-signals','06-bringup']
for name,s in zip(names,sheets):(ROOT/(name+'.svg')).write_text(s)
# Complete offline viewer.
css='''*{box-sizing:border-box}body{margin:0;background:#edf1e9;color:#233c34;font:16px/1.65 system-ui,-apple-system,"PingFang SC",sans-serif}main{max-width:1480px;margin:auto;padding:28px}h1{font-size:32px;margin:10px 0}a{color:#23765a}nav,.controls{display:flex;gap:15px;align-items:center;flex-wrap:wrap;margin:15px 0}button,select,input{font:inherit}button,select{background:#fffefa;color:inherit;padding:8px 12px;border:1px solid #c6d2c6;border-radius:5px;cursor:pointer}button:focus-visible,a:focus-visible,input:focus-visible{outline:3px solid #2b7b9b}.card,.sheet{background:#fffefa;border:1px solid #cbd7ca;border-radius:8px;padding:18px;margin:20px 0}.sheet{padding:0;overflow:auto}.sheet svg{display:block;width:100%;min-width:1000px}.viewer{display:grid;grid-template-columns:minmax(0,1fr) 320px;gap:20px}.viewer svg{width:100%;height:700px}.hint{color:#66796d;font-size:14px}.small{font-size:13px}.parts{max-height:300px;overflow:auto}.parts button{display:block;width:100%;text-align:left;margin:4px 0;font-size:13px}.warn{padding:12px;border-left:3px solid #b56c25;background:#fcf0dd}#model g{cursor:pointer}#model g:hover polygon{stroke:#23765a;stroke-width:2}@media(max-width:850px){main{padding:16px 12px}.viewer{grid-template-columns:1fr}.viewer svg{height:540px}}@media print{@page{size:A3 landscape;margin:10mm}header,.card,footer{display:none}.sheet{padding:0;margin:0;border:0;break-after:page;width:400mm;height:277mm;border-radius:0;overflow:visible}.sheet:last-child{break-after:auto}.sheet svg{width:400mm;height:274.286mm;min-width:0}main{padding:0;max-width:none}}'''
nav='<nav><a href="operation-h1.html">流程动画</a><a href="bom-h1.html">精简采购表</a><a href="README.md">装配/接线说明</a><a href="cut-list-h1.csv">裁切CSV</a><a href="../../../output/pdf/beanlens-hackathon-h1-20261019.pdf">6页A3 PDF</a><a href="../assembly-v4.12/beanlens-assembly-v4.12.html">保留的完整版</a></nav>'
page='''<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="data:,"><title>BeanLens比赛精简版H1｜组装爆炸与接线</title><style>'''+css+'''</style><main><header><small>BEANLENS / HACKATHON H1 / 2026-10-19</small><h1>单摄、单槽、停豆拍照后开闸</h1><p>一块K230D BOX完成识别、显示和MG996R控制。人工逐颗投豆；轻挡片侧摆，不再做长滑闸。完整版V4.12独立保留。</p>'''+nav+'''<p class="warn">所有孔位、镜头近焦、舵机端点与限位高度仍需实物。图中0/90为相对几何演示，不能直接换算成未经标定的PWM。未写入或烧录产品固件。</p></header><section class="card"><div class="controls"><button id="assembled">组装</button><button id="exploded">爆炸</button><label>分解 <input id="explode" type="range" min="0" max="100" value="0"></label><select id="group"><option value="">全部机身</option>__GROUPS__</select><label><input type="checkbox" id="shield">遮光片</label><label><input type="checkbox" id="power">机外配电</label><label><input type="checkbox" id="labels">部件编号</label></div><div class="viewer"><svg id="model" viewBox="0 0 900 780" role="img" aria-label="比赛版可选取部件的组装与爆炸模型"></svg><aside><h2 id="partTitle">点击部件查看</h2><p id="partBom">图号对应采购H01–H30</p><p id="partSize"></p><p id="partNote">点击可查看尺寸与待核项目。切换遮光与分组不会改变比例。</p><div class="parts" id="parts"></div></aside></div></section>__SHEETS__<footer>文档与动画检查不代表实物通过；普通收豆杯不称重，单面可见瑕疵不等于完整品质鉴定。</footer></main><script>const DATA=__DATA__;
(()=>{const $=id=>document.getElementById(id),NS='http://www.w3.org/2000/svg';function el(tag,a,p){const n=document.createElementNS(NS,tag);for(const[k,v]of Object.entries(a))n.setAttribute(k,v);p.append(n);return n}function select(id){const p=DATA.parts.find(p=>p.id===id);$('partTitle').textContent=p.id+' · '+p.name;$('partBom').textContent='BOM '+p.bom;$('partSize').textContent='绘制包络/面长 '+p.size.map(n=>+n.toFixed(3)).join('×')+' mm';$('partNote').textContent=p.note||'按所属BOM及实物安装。'}function render(){const e=+$('explode').value/100,all=DATA.parts.filter(p=>$('power').checked||p.group!=='机外配电'),raw=v=>[.8660254*(v[0]+v[1]),.5*(v[0]-v[1])-v[2]],bounds=all.flatMap(p=>[0,1].flatMap(t=>p.vertices.map(v=>raw(v.map((x,i)=>x+p.explode[i]*t))))),xs=bounds.map(v=>v[0]),ys=bounds.map(v=>v[1]),a=Math.min(...xs),b=Math.max(...xs),c=Math.min(...ys),d=Math.max(...ys),k=Math.min(810/(b-a),700/(d-c)),pr=v=>{const[x,y]=raw(v);return[450+(x-(a+b)/2)*k,390+(y-(c+d)/2)*k]},svg=$('model');svg.replaceChildren();const ps=all.filter(p=>(!$('group').value||p.group===$('group').value)&&($('shield').checked||p.group!=='遮光')).sort((a,b)=>a.pos[0]-a.pos[1]+a.pos[2]*.15-(b.pos[0]-b.pos[1]+b.pos[2]*.15));for(const p of ps){const v=p.vertices.map(v=>v.map((x,i)=>x+p.explode[i]*e)),gr=el('g',{'data-id':p.id,tabindex:0,role:'button','aria-label':p.id+' '+p.name},svg),attrs={fill:p.color,'fill-opacity':p.shape==='outline'?.1:p.shape==='cup'?.3:.92,stroke:'#52675c','stroke-width':1};if(p.shape==='outline'){for(const[i,j]of[[0,1],[1,2],[2,3],[3,0],[4,5],[5,6],[6,7],[7,4],[0,4],[1,5],[2,6],[3,7]])el('polyline',{...attrs,fill:'none','stroke-dasharray':'6 5',points:[pr(v[i]),pr(v[j])].map(v=>v.join(',')).join(' ')},gr)}else if(p.shape==='angle'){let[x,y,z]=p.pos;const[w,d,h]=p.size;x+=p.explode[0]*e;y+=p.explode[1]*e;z+=p.explode[2]*e;const xx=p.right?x+w-2:x;for(const face of [[[x,y,z+h],[x+w,y,z+h],[x+w,y+d,z+h],[x,y+d,z+h]],[[xx,y,z],[xx+2,y,z],[xx+2,y,z+h],[xx,y,z+h]]])el('polygon',{...attrs,points:face.map(v=>pr(v).join(',')).join(' ')},gr)}else if(p.shape==='platform'&&p.aperture){const[x,y,w,h]=p.aperture,z=p.pos[2]+p.size[2]+p.explode[2]*e,loops=[[4,5,6,7].map(i=>pr(v[i])),[[x,y],[x+w,y],[x+w,y+h],[x,y+h]].map(([x,y])=>pr([x+p.explode[0]*e,y+p.explode[1]*e,z]))];el('path',{...attrs,'fill-rule':'evenodd',d:loops.map(l=>'M'+l.map(v=>v.join(',')).join(' L')+' Z').join(' ')},gr)}else for(const f of(p.shape==='cup'?[[0,1,5,4],[1,2,6,5],[0,1,2,3]]:[[0,1,5,4],[1,2,6,5],[4,5,6,7]]))el('polygon',{...attrs,points:f.map(i=>pr(v[i]).join(',')).join(' ')},gr);if($('labels').checked){const center=[0,1,2].map(i=>v.reduce((s,v)=>s+v[i],0)/8),[x,y]=pr(center);el('rect',{x:x-22,y:y-10,width:44,height:20,rx:3,fill:'#fffefa',stroke:'#b7c9bc'},gr);const t=el('text',{x,y:y+4,'font-size':11,'text-anchor':'middle',fill:'#233c34'},gr);t.textContent=p.id;}gr.onclick=()=>select(p.id);gr.onkeydown=ev=>{if(ev.key==='Enter'||ev.key===' '){ev.preventDefault();select(p.id)}}}}$('explode').oninput=render;$('assembled').onclick=()=>{$('explode').value=0;render()};$('exploded').onclick=()=>{$('explode').value=100;render()};$('shield').onchange=$('power').onchange=$('labels').onchange=render;$('group').onchange=()=>{if($('group').value==='机外配电')$('power').checked=true;if($('group').value==='遮光')$('shield').checked=true;render()};for(const p of DATA.parts){const n=document.createElement('button');n.textContent=p.id+' · '+p.name+' ['+p.bom+']';n.onclick=()=>select(p.id);$('parts').append(n)}window.h1Assembly={data:DATA,render,select};render()})();</script></html>'''
page=page.replace('__GROUPS__',''.join('<option>'+x+'</option>' for x in dict.fromkeys(p['group'] for p in parts))).replace('__DATA__',json.dumps(dict(parts=parts),ensure_ascii=False)).replace('__SHEETS__',''.join(f'<section class="sheet" id="sheet{i}">{s}</section>' for i,s in enumerate(sheets,1)))
(ROOT/'assembly-h1.html').write_text(page)
rows=''.join('<tr>'+''.join('<td>'+html.escape(str(p[k] if p[k] is not None else '待报价'))+'</td>' for k in ['id','name','model','spec','qty','unit','notes'])+'</tr>' for p in d['bom'])
(ROOT/'bom-h1.html').write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>BeanLens H1精简采购表</title><style>'+css+'table{border-collapse:collapse;width:100%;min-width:1100px}th,td{text-align:left;vertical-align:top;padding:12px;border-bottom:1px solid #cbd7ca}th{background:#e1ece2}.table{overflow:auto}</style><main><header><small>2026-10-19 / H1 / 30组</small><h1>比赛精简版采购表</h1>'+nav+'<p>先从完整版已购件中取用，不重复下单。单价未知全部留空，不报虚构总价。H22为缓冲板加工总成，H23–H27是构成件，不能重复买成两套整板。</p><nav><a href="bom-h1.csv">采购CSV</a><a href="bom-h1.json">采购JSON</a><a href="assembly-h1.html">组装/接线图</a></nav></header><div class="table"><table><thead><tr>'+''.join('<th>'+x+'</th>' for x in ['编号','名称','型号','规格','数量','单位','检查/说明'])+'</tr></thead><tbody>'+rows+'</tbody></table></div><p class="warn">本版不装：C6、称重、第二相机、SEN0503、PBT、大斗、长滑闸/双轨/双球头杆、第二屏、网络模块。保留这些旧件供完整版后续使用。</p></main></html>')
print('H1:',len(parts),'drawn objects;',len(d['bom']),'BOM groups;',len(sheets),'sheets')

stock=d['flat_stock_pp3'];flat=rect(30,60,600,600,'#edf4e8',C['line'])+text(30,35,'PP-H3 200×200排版（非1:1模板）',24,bold=True)
for p in stock['rectangles']:
 x,y=p['xy'];w,h=p['wh'];flat+=rect(30+x*3,60+y*3,w*3,h*3,C['pp'])+text(35+x*3,80+y*3,p['id'],13)+text(35+x*3,98+y*3,f'{w:.3f}×{h:.3f}',11)
flat+=text(30,695,'间隔≥3mm；先核板料实厚。侧片为包络内的梯形，孔按实物开。',15)
(ROOT/'flat-stock-h1.svg').write_text('<svg xmlns="http://www.w3.org/2000/svg" width="680" height="730" viewBox="0 0 680 730"><style>text{font-family:Arial,PingFang SC,sans-serif}</style>'+flat+'</svg>')
