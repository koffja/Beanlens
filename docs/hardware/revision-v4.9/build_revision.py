"""Offline V4.9 electrical and feed-path revision. Proposal, not bench validation."""
from pathlib import Path
import csv, html, json, math

ROOT=Path(__file__).resolve().parent
REPO=ROOT.parents[2]
V24='#c56b13';V5='#c4323d';V6='#7b45b5';GND='#273843';SIG='#1777ae'
SOURCE={
 'adapter':'https://en.huntkey.com/erp-information/huntkey/hka12024050-6b-hka12024050-7b/',
 'buck':'https://www.xlsemi.com/datasheet/XL4016-EN.pdf',
 'terminal':'https://www.delixi-electric.com/u/cms/delixi/201805/09095528ac23.pdf',
 'buffer':'https://www.ti.com/product/SN74AHCT1G125',
}
H=141.7;kx=27/H;ky=62/H;dx=2*math.sqrt(1+kx*kx);dy=2*math.sqrt(1+ky*ky)
geometry=dict(top_inner_wh_mm=[136,136],bottom_inner_wh_mm=[82,12],height_mm=H,
 top_z_mm=440,bottom_z_mm=298.3,normal_wall_thickness_mm=2,
 top_outer_wh_mm=[136+2*dx,136+2*dy],bottom_outer_wh_mm=[82+2*dx,12+2*dy],
 front_back_outer_face_trapezoid_mm=[136+2*dx,82+2*dx,math.hypot(H,62)],
 left_right_outer_face_trapezoid_mm=[136+2*dy,12+2*dy,math.hypot(H,27)],
 side_miter_from_square_deg=math.degrees(math.acos(kx*ky/math.sqrt((1+kx*kx)*(1+ky*ky))))/2,
 upper_seat_xyz_mm=[40,105,292.3],upper_seat_size_mm=[140,30,6],
 lower_seat_xyz_mm=[40,111,280],lower_seat_size_mm=[140,18,10],
 upper_seat_material='PP-H',lower_seat_material='food_contact_POM',
 gate_gap_z_mm=[290,292.3],gate_thickness_mm=2,stroke_mm=15,
 windows_x_mm=[69,86,103,120,137],windows_y_mm=114,window_wh_mm=[14,12],partition_mm=3,
 nominal_volume_l=H*((136*136)+(136*12+82*136)/2+82*12)/3/1e6,
 weld_horizontal_keepout_mm=4,
 screen_clearance_mm={'front':120-(68-ky*(440-402)+dy)-4-47,'right':188-(110+68-kx*(440-385)+dx)-4},
 status='normal_thickness_geometry_proposal; weld shrinkage / end bevel / holes / flow require mockup')
# Integral volume of two linearly varying widths, not the similar-section frustum formula.
geometry['nominal_volume_l']=H*(136*136-(136*124+136*54)/2+(54*124)/3)/1e6
design=dict(revision='V4.9',date='2026-10-16',status='proposal_not_hardware_validated',
 scope='Power and hopper replacement package. V4.8 frame, nine wood panels and two displays retained.',
 sources=SOURCE,power=dict(input_v=24,input_a=5,input_w=120,logic_v=5,logic_budget_a=4,
 servo_v=6,servo_continuous_a=3,servo_peak_a=5,buck_budget_efficiency=0.8,
 continuous_w=56.5,short_peak_w=71.5,short_peak_input_a=71.5/24,
 fuses_input_side_a={'main':4,'lamp':2,'logic_buck':2,'servo_buck':3},
 fuse_note='Preliminary DC wire protection, not servo jam protection; test inrush and actual holder rating.',
 adapter='Huntkey HKA12024050-7B, 24V 5A; ordered connector and polarity must be checked',
 buck='Two XL4016E1 CC/CV dual-heatsink modules; chip model does not identify a complete board',
 terminal='Delixi TB-1506 / DHATB1506N x2; two matching 3-pole bridges only on TB-A',
 TB_A={'1':'24V+ input / lamp fuse','2':'24V+ logic input fuse','3':'24V+ servo input fuse',
       '4':'adapter return / lamp return','5':'logic buck IN-','6':'servo buck IN-'},
 TB_A_bridges=[[1,2,3],[4,5,6]],
 TB_B={'1':'5V+','2':'5V return','3':'6V+','4':'6V return','5':'unused','6':'unused'},
 TB_B_bridges=[],common_reference='Nonisolated bucks; each load returns to its own output. No extra output-ground jumpers.',
 gpio_pwm=2,pwm_hz=50,io_v=3.3,servo_accepts_3v3='not_verified',
 external_box_nominal_mm=[200,150,80],module_purchase_envelope_mm=[65,55,30],
 box_layout_status='Procurement envelope, not complete mechanical interference approval',
 budget_cny_estimate=[200,370],quoted_total_cny=None),hopper=geometry,
 retained_frame_layout='../assembly-v4.8/assembly-layout-v4.8.json',
 unresolved=['G10 linkage ear height and full sweep guard G20 require mockup',
 'IR beam Z277 and base/feet/bolt clearance must be checked with actual heads',
 'CNC corners, seat flatness after weld, PP creep and bean bridging untested',
 'External power box ventilation / loads / current-limit setting / all connectors need actual sample'])
(ROOT/'design-v4.9.json').write_text(json.dumps(design,ensure_ascii=False,indent=2)+'\n')

class Sheet:
 def __init__(self,n,title,sub):
  self.n=n;self.s=[f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1500 1060" role="img" aria-label="{html.escape(title)}">',
  '<style>text{font-family:"PingFang SC","Microsoft YaHei",sans-serif;fill:#233b38;font-size:21px} .small{font-size:18px}.tiny{font-size:16px}.title{font-size:37px;font-weight:700}.bold{font-weight:700} .wire{fill:none;stroke-linejoin:round;stroke-linecap:round;stroke-width:4}</style>',
  '<rect width="1500" height="1060" fill="#fafbf7"/>']
  self.text(48,56,f'BEANLENS  /  V4.9  /  {n:02d}',16,'#47786b')
  self.text(48,110,title,37);self.text(48,148,sub,19,'#657a73')
 def text(self,x,y,t,size=21,color=None,cls=''):
  self.s.append(f'<text x="{x}" y="{y}" class="{cls}" style="font-size:{size}px'+(f';fill:{color}' if color else '')+'">'+html.escape(str(t))+'</text>')
 def rect(self,x,y,w,h,fill='#fff',stroke='#c8d6ce',r=10):
  self.s.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}" fill="{fill}" stroke="{stroke}" stroke-width="2"/>')
 def line(self,pts,color=GND,rail='',dash=False):
  self.s.append(f'<polyline class="wire" data-rail="{rail}" points="'+ ' '.join(f'{x},{y}' for x,y in pts)+f'" stroke="{color}"'+(' stroke-dasharray="9 7"' if dash else '')+'/>')
 def dot(self,x,y,color=GND):self.s.append(f'<circle cx="{x}" cy="{y}" r="5" fill="{color}"/>')
 def box(self,x,y,w,h,title,lines,fill='#fff'):
  self.rect(x,y,w,h,fill);self.text(x+17,y+32,title,23,cls='bold')
  for i,t in enumerate(lines):self.text(x+17,y+62+i*27,t,18)
 def footer(self):
  self.line([(48,1000),(1452,1000)],'#d2ddd6')
  self.text(48,1030,'2026-10-16 · 样机方案 / 尚未带载、带豆或焊接验收 · 电气连接按端子文字核对，不按图中物理引脚位置猜接',16)
  self.text(1390,1030,f'{self.n} / 4',16)
 def save(self,name):
  self.footer();self.s.append('</svg>');(ROOT/name).write_text('\n'.join(self.s));return name

p=Sheet(1,'先分出三路电压，再分别接回负极','橙24V、红5V、紫6V、黑返回；蓝虚线为信号。跨桥不相连，圆点是接点；端子编号见第2页。')
p.box(48,190,280,125,'A07 航嘉外置适配器',['HKA12024050-7B','24V / 5A / 120W'])
p.text(48,345,'成品带开关插排 → 成品交流线',18);p.text(48,373,'220V 留在机外；总开关在插排',18)
p.text(48,401,'P03 插头尺寸与中心正负先实测',18)
p.line([(328,229),(358,229)],V24,'24');p.rect(358,208,104,42,'#fff2df',V24,4);p.text(369,236,'主 4A',19)
p.line([(462,229),(510,229),(510,722)],V24,'24')
p.line([(328,275),(477,275),(477,768)],GND,'ground');p.text(346,301,'0V',18)
p.text(495,191,'TB-A 1–3',17,V24);p.text(389,820,'TB-A 4–6',17)
for y,fuse,buck,rail,col,port,lines in [
 (229,'灯 2A','24V 灯带', '24',V24,'TB-A 1 / 4',['A05 共 0.4m，预算 ≤8W','正接 +，负接 −']),
 (470,'5V 输入 2A','A08 XL4016 模块 A','5',V5,'TB-B 1 / 2',['先空载调到 5.00V','供两板与低压外设，共 ≤4A']),
 (722,'6V 输入 3A','A17 XL4016 模块 B','6',V6,'TB-B 3 / 4',['先空载调到 6.00V','目标 3A 连续 / 5A 短峰'])]:
 p.dot(510,y,V24);p.line([(510,y),(550,y)],V24,'24');p.rect(550,y-22,155,44,'#fff2df',V24,4);p.text(560,y+7,fuse,18)
 p.line([(705,y),(750,y)],V24,'24')
 p.dot(477,y+46)
 if y+46<722:
  bridge=f'M477 {y+46} H498 Q510 {y+26} 522 {y+46} H750'
  p.s.append(f'<path d="{bridge}" fill="none" stroke="#fafbf7" stroke-width="11"/>')
  p.s.append(f'<path d="{bridge}" class="wire" data-rail="ground" stroke="{GND}"/>')
 else:p.line([(477,y+46),(750,y+46)],GND,'ground')
 if rail=='24':
  p.box(750,196,640,130,buck,lines,'#fff6e9');p.text(717,y-12,'+',20,V24);p.text(717,y+72,'−',20)
 else:
  p.box(750,y-42,290,160,buck,lines,'#f0f5ef')
  p.text(717,y-10,'IN+',16,V24);p.text(716,y+72,'IN−',16)
  p.text(1048,y-12,'OUT+',16,col);p.text(1048,y+71,'OUT−',16)
  p.line([(1040,y),(1110,y)],col,rail);p.line([(1040,y+46),(1110,y+46)],GND,'ground')
  p.text(1110,y-(52 if rail=='6' else 63),port,18,col)
  if rail=='5':
   p.box(1110,y-42,340,166,'P09 5V 配电板',['双 USB-A → 成品 A→C 短线','→ BOX Type-C1 电源口 + C6','辅助 5V/GND → 2167 对射','C6 3.3V/GND → NAU7802'])
   p.text(1110,y+155,'C02 470µF/10V 并在 5V 与返回',17,V5)
  else:
   p.box(1110,y-42,340,137,'P14 XT30 → MG996R',['正接舵机 V+，负接舵机 GND','C01 1000µF/16V 就近并联'])
   p.text(1110,y+128,'不能从 C6 板脚给舵机供电',18,V6)
p.box(48,461,370,142,'共地不是混接正极',['两块降压为非隔离型，已有共同参考。','负载负线分别回各自 OUT−。','5V+、6V+、24V+ 绝不互相相连。'],'#eaf2ee')
p.box(48,634,370,140,'电源能力按整块模块验收',['50V 输入电容 / 双散热片优先。','“XL4016 8A/12A”不是整板承诺。','电容不能代替降压模块的供电能力。'])
p.rect(799,614,270,46,'#e9f2f7',SIG,6);p.text(812,644,'C6 GPIO2 · 信号输出',20,SIG)
p.line([(1069,637),(1090,637),(1090,650),(1466,650),(1466,855),(1270,855),(1270,817)],SIG,'signal',True)
p.text(870,891,'C6 GPIO2 → 舵机信号（拟定 50Hz / 3.3V 接受能力待测）',20,SIG)
p.text(48,936,'功率预算：持续 56.5W / 短峰 71.5W（两路降压按 80%）→ 24V / 5A 有预算余量；仍须实测温升与压降。',21)
p.text(48,973,'保险均装正线上、靠近分支起点；保险保护线路，不负责卡豆停止。停止、复位与限位仍按固件验收要求执行。',18)
names=[p.save('01-power-wiring.svg')]

p=Sheet(2,'端子一格一格接：把“共地”接得清楚','P05 选德力西 TB-1506 / DHATB1506N ×2。每格上下两螺钉互通，左右相邻格原本不通。')
for bx,title,labels,bridges in [(48,'TB-A：24V 输入与三路分支',['24V+','24V+','24V+','0V','0V','0V'],[(0,2,V24),(3,5,GND)]),(790,'TB-B：5V / 6V 输出，绝不加桥条',['5V+','5V−','6V+','6V−','空','空'],[])]:
 p.text(bx,208,title,23)
 for i,label in enumerate(labels):
  x=bx+i*108;p.rect(x,230,92,147,'#e8eeea');p.text(x+35,256,i+1,20)
  for y in [283,351]:
   p.s.append(f'<circle cx="{x+46}" cy="{y}" r="12" fill="#fafafa" stroke="#84988b" stroke-width="2"/>')
   p.line([(x+38,y),(x+54,y)],'#84988b')
  p.line([(x+46,298),(x+46,335)],'#84988b');p.text(x+11,319,label,18)
 for i,j,col in bridges:p.line([(bx+46+i*108,391),(bx+46+j*108,391)],col)
p.text(48,426,'仅 TB-A 加两段配套 3 位短接片：1–2–3 一组；4–5–6 另一组。',20,V24)
p.text(790,426,'TB-B 的 1/2/3/4 分别独立；5、6 空置。',20,V6)
rows=[
 ['线号','起点','终点','导线 / 说明'],
 ['W01','适配器 + → 主 4A','TB-A 1 上','0.75mm²；先测插头极性'],
 ['W02','适配器 −','TB-A 4 上','0.75mm² 黑线'],
 ['W03/04','TB-A 1 下 → 灯 2A / 4 下','灯带 + / −','各自接一根，不借铝框回流'],
 ['W05/06','TB-A 2 下 → 输入 2A / 5 下','模块 A IN+ / IN−','24V 输入对'],
 ['W07/08','TB-A 3 下 → 输入 3A / 6 下','模块 B IN+ / IN−','24V 输入对'],
 ['W09/10','模块 A OUT+ / OUT−','TB-B 1 上 / 2 上','5V 输出对'],
 ['W11/12','TB-B 1 下 / 2 下','P09 配电板 + / −','USB + 独立辅助焊盘/端子'],
 ['W13/14','模块 B OUT+ / OUT−','TB-B 3 上 / 4 上','6V 输出对'],
 ['W15/16','TB-B 3 下 / 4 下','XT30 → 舵机 V+ / GND','0.75mm²；电容并在舵机近端'],
 ['W17','C6 GPIO2','舵机 SIGNAL','只传信号，必要时加 O01 缓冲'],
]
yy=468
for i,row in enumerate(rows):
 p.rect(48,yy,1400,37,'#eaf2ed' if i%2==0 else '#fff','#e1e8e2',0)
 for x,t in zip([60,204,660,1050],row):p.text(x,yy+25,t,17)
 yy+=37
p.box(48,900,678,77,'压接与绝缘',['TB 螺钉配 M3 叉形/环形压接端子；降压板端口用合适管形端头。'], '#fff6e9')
p.box(750,900,698,77,'不要额外拉三根“地线桥”',['TB-B 2/4 不再外接 TB-A 4；共地已通过非隔离降压内部实现。'],'#eee9f6')
names.append(p.save('02-terminal-map.svg'))

p=Sheet(3,'四片 PP 焊成一个料斗，五槽只留两块座','上料斗与 PP 上座可以焊为一个可取出的模块；滑动机构仍可拆，避免清洁与卡豆维修被焊死。尺寸单位 mm。')
p.text(48,205,'原 V4.8：8 片斗板 + 中间双法兰 + 多层五窗',21,'#718078')
p.text(48,240,'作用是便于薄片加工和调整；不是五槽必须这样做。',19)
p.text(48,280,'V4.9 推荐：4 片连续斜板 + 单块 PP6 上座',24,'#18765d')
# Central front view, X and Z scaled equally; gate shown displaced below for illustration.
cx=350;top=320;scale=2.5;bottom=top+H*scale
def poly(points,fill,stroke='#739a8b'):
 p.s.append('<polygon points="'+' '.join(f'{x},{y}' for x,y in points)+f'" fill="{fill}" stroke="{stroke}" stroke-width="2"/>')
poly([(cx-70.036*scale,top),(cx+70.036*scale,top),(cx+43.036*scale,bottom),(cx-43.036*scale,bottom)],'#e0eee6')
p.rect(cx-88*scale,top-7.5,176*scale,7.5,'#bdd7c7',r=0)
p.line([(cx-68*scale,top),(cx-41*scale,bottom)],'#8da898');p.line([(cx+68*scale,top),(cx+41*scale,bottom)],'#8da898')
p.text(218,308,'顶内口 136×136，Z440',20)
p.text(189,494,'PP-H 2mm 法向板厚',22)
p.text(192,533,'内高 141.7 / 连续四片',21)
p.line([(cx+195,top),(cx+230,top),(cx+230,bottom),(cx+125,bottom)],'#6d887b')
p.text(600,510,'141.7',20)
p.text(177,710,'底内口 82×12，Z298.3',20)
p.s.append('<g id="upper-seat">');p.rect(cx-175,bottom,350,15,'#65aa89',r=0)
poly([(cx-43.036*scale,bottom),(cx-43.036*scale-10,bottom),(cx-43.036*scale-2,bottom-9)],'#d88944')
poly([(cx+43.036*scale,bottom),(cx+43.036*scale+10,bottom),(cx+43.036*scale+2,bottom-9)],'#d88944')
p.s.append('</g>')
p.text(60,757,'PP6 上座：140×30×6，五孔 14×12',20)
p.s.append('<g id="gate-layer">');p.rect(cx-137.5,788,275,5,'#b6bdc0','#757e83',0);p.text(62,822,'铝闸片 110×45×2；前后移动 15',20);p.s.append('</g>')
p.s.append('<g id="lower-seat">');p.rect(cx-175,861,350,25,'#3f5865',r=0);p.text(62,920,'POM10 下座：140×18×10，可拆',20);p.s.append('</g>')
p.text(65,963,'以上为分解示意；实际闸缝 Z290–292.3 = 2.3',19,V6)
p.box(742,196,706,172,'五槽是五个孔，不是五个盒子',['PP 上座 / POM 下座各直接加工同样五孔。','孔宽 14，前后孔深 12，隔肋 3，总活跃宽度 82。','上座焊接冷却后检查平整，再装闸片与下座。','内角暂按 R1.5；孔缘倒钝，先做单槽流豆试验。'],'#eaf3eb')
for i in range(5):p.rect(853+i*85,394,70,60,'#fff','#377b61',2)
p.text(775,484,'俯视：14 | 3 | 14 | 3 | 14 | 3 | 14 | 3 | 14',19)
p.box(742,522,706,172,'焊接范围与可拆范围',['外侧焊四条斜缝 + 斗底外侧围焊到 PP 上座。','内面应平顺；毛刺/焊瘤会挂豆，先试焊再处理。','取消中间双法兰、硅胶垫、4 个连接螺栓。','顶承托法兰仍保留；POM 与 PP 不互相热风焊接。'])
p.box(742,716,706,122,'与双屏的名义净空重新计算',['预留外焊筋横向 4 后：前屏约 15.4，侧屏约 14.4。','这是 V4.8 屏幕服务包络与新斗面的几何检查；','完整插头、线缆弯曲、焊接变形仍须实物试配。'],'#fff6e9')
p.box(742,860,706,130,'下座为何只有 18 深？',['保持下座 Z280–290；30 深的整块下座可能撞后方导轨。','后部退片护罩、连杆耳高度、Z277 光束 / 脚座避让仍待试配。','名义容积约 1.22L；不能据此承诺能装 1kg 生豆。'])
names.append(p.save('03-one-piece-hopper.svg'))

p=Sheet(4,'电源盒放在机外，先调电压，再接设备','低价 XL4016 双散热板不能假定塞得进原 21mm 后腔。推荐另配 ABS 盒，避免修改双屏与豆路空间。')
p.text(48,205,'P11 ABS 盒：外形 200×150×80，尺寸为采购起点',23)
# internal layout 170x120 at3.2 scale
bx=70;by=249;s=3.2
p.rect(bx,by,170*s,120*s,'#e9eeea','#71867b',5)
for x,name,color in [(5,'模块 A → 5V',V5),(85,'模块 B → 6V',V6)]:
 p.rect(bx+x*s,by+5*s,65*s,55*s,'#fff',color,6);p.text(bx+x*s+10,by+35,name,20,color)
 p.text(bx+x*s+10,by+68,'≤65×55×30',18);p.text(bx+x*s+10,by+98,'采购包络，非实测',16)
for x,name in [(5,'TB-A 24V'),(85,'TB-B 5V/6V')]:
 p.rect(bx+x*s,by+70*s,73.5*s,22*s,'#cdd9d0');p.text(bx+x*s+10,by+70*s+43,name,19)
p.text(91,by+110*s,'余区：4 路保险座 / 线槽，按到货件排布',18)
p.text(70,683,'示意安装板 170×120×2；留通风孔、线夹和约 6mm 绝缘支柱。',18)
p.text(70,716,'不能把板上散热片当绝缘件；裸焊点、端子与盒盖保持间距。',18)
p.box(742,190,706,156,'采购先核这几条',['XL4016E1 双散热、CC/CV 可调、输入电容 50V。','卖家确认 24→5V / 4A 与 24→6V / 3A 工况；峰值另验。','整板尺寸 / 端子电流 / CC 操作方法按所购板资料。','两块总损耗预算约 9.5W，通风不足时加 5V 4010 风扇。'])
p.box(742,366,706,176,'第一次上电的顺序',['1 断开主板、舵机、灯带；检查正负与端子桥条。','2 仅给降压供 24V，用万用表调 5.00V / 6.00V。','3 用电子负载核电流与温升；不明 CC 操作不要接舵机。','4 断电接主板，量插头端 5V；再断电接空载舵机。','5 最后分阶段到单槽 / 五槽，记录压降、温升与超时。'],'#eaf3eb')
p.box(742,562,706,149,'接口分开，减少误插',['5V：双 USB-A → A→C 成品线；BOX 只用 Type-C1 供电。','6V：XT30 两芯，电源端使用不露导体的配对方向。','24V：单独两芯端子 → 灯带，显著标 24V。','USB 联电脑调试时先断该板外部 5V，避免两路 VBUS 并供。'])
p.box(742,731,706,245,'可选 O01：舵机不认 3.3V PWM 时再加',['TI SN74AHCT1G125DBVR + SOT23-5 转接板。','模块 VCC → 5V；GND 与 /OE → 逻辑地。','GPIO2 → IN（10k 下拉）；OUT → 100Ω → 舵机信号。','VCC/GND 旁放 100nF；按原厂脚位接，禁止把 VCC 接 6V。','停止/失联先撤销送料许可；卡豆超时后停止加力。','插排总开关不是硬件急停，断电也不保证闸门自行关闭。'],'#eee9f6')
p.box(48,758,635,218,'更容易搜索的关键词',['航嘉 HKA12024050-7B 24V5A','XL4016 恒流恒压 双散热 50V电容','德力西 TB1506 端子排 + 配套3位短接片','ABS 接线盒 200 150 80 / XT30 插头','32V MINI 保险座 / M3 0.75平方叉形端子','电源包预算约 ¥200–370，非卖家现价，不含工具运费。'])
names.append(p.save('04-powerbox-and-bringup.svg'))

cuts=[]
for name,key in [('前片','front_back_outer_face_trapezoid_mm'),('后片','front_back_outer_face_trapezoid_mm'),('左片','left_right_outer_face_trapezoid_mm'),('右片','left_right_outer_face_trapezoid_mm')]:
 a,b,c=geometry[key];cuts.append(dict(part=name,material='PP-H 2mm',upper_outer_edge_mm=round(a,3),lower_outer_edge_mm=round(b,3),outer_face_slant_height_mm=round(c,3),qty=1,status='外面控制梯形；不是内面模板；端面/斜接坡口需试焊量规，禁按矩形竖边直接拼'))
with (ROOT/'pp-panel-cuts-v4.9.csv').open('w',encoding='utf-8-sig',newline='') as f:
 w=csv.DictWriter(f,fieldnames=list(cuts[0]));w.writeheader();w.writerows(cuts)

readme='''# BeanLens V4.9：低成本供电与连续 PP 豆路

2026-10-16，样机方案。此包替代 V4.8 的电源选型、主/过渡斗、双法兰及五窗叠片；机架、9 块木外壳、双屏及型材采购沿用 V4.8。不是整机已经完成实物验收的新加工图。

## 打开图纸

- [四页可放大接线/豆路示意](beanlens-power-and-feed-v4.9.html)
- [完整采购表](../procurement-v4.9/beanlens-procurement-v4.9.html)
- [PP 四片外面控制尺寸 CSV](pp-panel-cuts-v4.9.csv)
- [数据与验算基线](design-v4.9.json)
- [A3 打印图册](../../../output/pdf/beanlens-power-and-feed-v4.9-20261016.pdf)

## 电源推荐：常见器件，留出调试与散热空间

外置航嘉 HKA12024050-7B，24V/5A/120W。厂商已核电压电流，插头尺寸、极性、交流入口形式与包装电源线仍按所购 SKU 核实，不能从型号尾缀猜。优先购买正规全新、适用当地认证与成品电源线的完整适配器；电源自身的外壳不拆。

两块 XL4016E1 恒流恒压双散热降压板分别调 5.00V / 6.00V。XL4016E1 是芯片型号，淘宝整板没有统一型号；询价必须带工况、尺寸、散热与电容要求，而非只搜“8A”。选输入电容 50V、适配 24V 输入、端子接受 0.75mm² 铜线的板，采购包络先按每块不大于 65×55×30mm。卖家须确认连续目标 24→5V/4A 与 24→6V/3A；6V/5A 短峰另验。CC 电流限值必须依整板说明和负载测试设定，不能用舵机堵转当电子负载。

原 Pololu D36V50F5/F6 更紧凑、原厂规格更完整，可作已购/高预算备选。廉价大板需要独立低压电源盒；不按原机背 21mm 深度硬塞。建议 ABS 外形 200×150×80 起点、约 170×120 安装板，外形并不保证实际可用内腔；按到货盒柱、端子与线弯曲复核。预留通风，必要时 5V 40×40×10 风扇；风扇计入逻辑 4A 总预算。外置适配器也在机外。成品插排开关作总电源，取消默认购买 NKK S1A；这不是硬件急停，也不保证失电自闭。

P05 改德力西 TB-1506 / DHATB1506N 两条。每条 73.5×22×17.5mm，原厂载流规格 15A、导线 0.5–1.5mm²、M3 螺钉。TB-A 仅安装两段配套 3 位短接片：1–3 正、4–6 负；两个组之间不连。TB-B 不装桥，1=5V+、2=5V返回、3=6V+、4=6V返回、5/6空。每个负载回各自降压输出，不额外桥输出负极。两个非隔离模块已有共同参考，不能称电源隔离。不要在一个螺钉下堆三四根线。

TB 配 M3 叉形/环形压接端子（如 UT0.75-3 / OT0.75-3，按供货尺寸）；模块笼式端子用合适管形端头，两种端头不能混为一谈。24V 输入、降压、舵机回路用 0.75mm² 铜线起点。5V 被动配电板要有双 USB-A 与独立辅助 5V/GND 焊盘或端子；总承载至少 4A，不是 PD 诱骗模块。辅助口供低压对射，电容用配电焊盘，不能把无关电压正极并接。

保险：主 4A、灯支路 2A、5V 降压输入 2A、6V 降压输入 3A，均 MINI 32VDC 配匹配座；灯支路改2A以便统一常见规格，仍是保护0.75mm²线路。安装在正线靠近支路起点，保险和线材配合仍要试验，不负责舵机卡豆停止。1000µF/16V 电解在舵机近端，470µF/10V 在逻辑 5V 端，极性正确；100nF 作旁路。电源端 XT30 方向按实物保证导体不裸露。24V 灯线与 6V 舵机线用不同接口并贴电压标签。

图 2 的 W01–W17 是逐线端到端表。GPIO2 / 50Hz 来自项目拟定基线，3.3V PWM 接受能力待测；需要时用 O01 单向缓冲。舵机电流不经过 C6 地针、5V 引脚或杜邦线。称重 NAU7802 仍用 C6 的3.3V/GND（新增外设35mA预算待测），不接5V/6V；传感器激励从称重模块按原基线连接。两板 UART 仅 TX/RX/GND，绝不互接 5V；短信号地不是负载回流线。电脑调试时先断开该板外部 5V，避免两路 USB VBUS 并供。

预算按降压效率 80%：5V×4A /0.8 + 6V×3A /0.8 + 灯8W + 其他24V预留1W = 56.5W。舵机短峰 5A 时 71.5W，24V 输入约 2.98A。120W 适配器有预算余量，但廉价板的热性能、短峰、压降都未验收。输入保险 3A 与短峰时长及上电浪涌须配合实测，不能只凭计算宣布通过。

### 淘宝搜索与估价（非卖家报价）

|物料|搜索关键词|估价人民币|
|---|---|---|
|24V适配器|航嘉 HKA12024050-7B 24V5A|100–150|
|降压板×2|XL4016 恒流恒压 双散热 50V电容|共24–50|
|端子排×2及桥条|德力西 TB1506 配套3位短接片|共10–25|
|保险及座|32V MINI 插片保险座|15–25|
|电线/压接/接口|0.75平方铜线 UT0.75-3 XT30|15–35|
|5V配电/短USB线|双USB母座 被动配电 辅助焊盘|10–25|
|电容|1000uF16V 470uF10V 低ESR|2–6|
|盒/板/支柱|ABS接线盒 200 150 80|20–45|
|可选风扇|5V 4010|5–12|

总包粗估约 200–370，不含工具、运费及选购风扇，为逐项估价范围取整；不是已核实的淘宝购物车总价。BOM 未报价项仍为 null，不能按 0 元相加。若适配器不含交流线或需新购插排则另计。若已有明纬/Pololu 则优先复用，不能假定再买一套更省钱。

## PP：建议焊一个连续漏斗，闸门保持可拆

旧方案叠片是为了薄片易裁、分层调间隙，双法兰是为了分段制作/拆洗；都不是五槽结构的必需功能。若能获得 PP6 与 POM10 的 CNC 加工，建议上斗与小过渡斗合并，四片 PP2 连续斜板焊为一体，底端外侧围焊到一块 PP6 上座。取消中间双法兰、硅胶垫和连接螺栓。顶 PP3 承托法兰仍保留，它承担悬挂，不是多余的豆路接头。

新内口 136×136，Z440；底口 82×12，Z298.3；垂直高 141.7。法向板厚 2，外顶口 140.072×140.366，外底口 86.072×16.366。前后片外面梯形：上140.072/下86.072/斜高154.670，各1；左右片：上140.366/下16.366/斜高144.249，各1。CSV 是外面控制尺寸，不是四边直切后直接对接的净料模板。斜边需配合相邻面的坡口，端边切至水平端面；焊缝收缩不是通用固定加量。

先用边角料做相同2mm坡口试片，确认枪嘴、流量、温度和焊条相容性；采用同牌号 PP-H 焊条，温度以材料/焊枪资料和试片为准。用 136口/82×12底口及141.7高的胎具定位；对角点焊、复测两口和扭曲，再分段交替外焊。底部在同样定位下焊到 PP6 上座，冷却后量上座平整度，整组放入机框试配。避免内侧留焊瘤挂豆；焊枪显示温度不代表焊缝已熔合。没有试片与实测收缩前，不直接按 CSV 批量加工。V4.8 的八片 STL/A4 模板不再用于此连续斗。

PP6 上座外形 140×30×6，底Z292.3；POM10 下座140×18×10，顶Z290。两者各加工5个14×12通孔，隔肋3，内角R1.5暂定；全局孔起点X69/86/103/120/137，Y114。闸片110×45×2，15行程，拟定闸缝2.3。POM下座18深是为避开后导轨，不能随手改成30深的全厚矩形。下座、闸片、两条隔距块用螺栓可拆，不能把移动槽和润滑导向焊死；POM也不能直接与PP热风熔焊。

G21 两端隔距块先按10×18×2加0.3调垫；下支脚候选3mm。夹紧螺栓M3×30只是25.3mm名义堆叠的起点，孔位/螺母/垫片/脚座实量后定。PP6先焊后量平整，不能带着闸片焊。安装后须验证整段行程不夹紧、所有五孔同开同关；2.3mm是初试间隙，不是已验证公差。厚料CNC可能有最低加工费，减少零件不等于首台一定更便宜。

以原双屏服务包络与外焊筋横向4mm限界重算：前约15.4、侧约14.4mm。不是完整线缆碰撞审查。新斗名义容积约1.222L，实际1kg豆所需容积必须用用户豆样验证。大斗压向82×12五窗处仍可能架桥，先做单槽带豆样机，不依据空载动画宣布送料成功。

## 保留与未完成项

- 黑欧标2020仍460×4、200×6、180×8；已有460×7/400×2时仍补净长180×4。9片6mm木外壳、双屏安装位置沿用V4.8。
- G10连杆耳共面高度、G20退片全行程防护仍需实物试配。光束Z277与底座/下脚/螺栓避让仍未完成验收；不要据本页宣布无干涉。
- 本包不重新发布完整十页整机爆炸图；旧图中的电源/双斗/叠片按本包替换，框架与屏幕尺寸可继续查旧图。不得混用旧PP模板。
- 关闭速度可以由PWM目标角分步缓慢变化实现；缓关不等于限力。限位/超时/卡豆退出必须单独验证，不能持续堵转。

## 原厂资料

- [航嘉24V/5A型号](https://en.huntkey.com/erp-information/huntkey/hka12024050-6b-hka12024050-7b/)
- [XL4016数据手册](https://www.xlsemi.com/datasheet/XL4016-EN.pdf)：芯片资料，不是淘宝整板认证。
- [德力西TB端子目录](https://www.delixi-electric.com/u/cms/delixi/201805/09095528ac23.pdf)：TB-1506 / DHATB1506N。
- [TI缓冲器](https://www.ti.com/product/SN74AHCT1G125)
'''
(ROOT/'README.md').write_text(readme)

# Offline SVGs are embedded, so rail selection also works without a local server.
cards=''.join(f'<section class="sheet" id="page{i}"><h2>{title}</h2><div class="viewport">'+(ROOT/name).read_text()+'</div></section>' for i,(name,title) in enumerate(zip(names,['总接线','逐线端子表','PP连续料斗 / 闸片分解','电源盒 / 上电顺序']),1))
page='''<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="data:,"><title>BeanLens V4.9 电源接线与连续PP料斗</title><style>
*{box-sizing:border-box}body{margin:0;background:#edf1eb;color:#233b38;font:16px/1.65 system-ui,-apple-system,"PingFang SC",sans-serif}header,main{max-width:1600px;margin:auto;padding:25px}h1{font-size:34px;margin:10px 0}h2{font-size:22px;margin:8px 0}p{max-width:1100px}a{color:#146b50}nav,.controls{display:flex;gap:14px;flex-wrap:wrap;align-items:center}.controls{position:sticky;top:0;z-index:10;background:#fafff7ed;padding:13px;border-bottom:1px solid #ccd7ca}button,select{font:inherit;padding:7px 12px;border:1px solid #9eafa4;border-radius:6px;background:white;color:#233b38}button{cursor:pointer}.sheet{background:#fafbf7;border:1px solid #cad5c8;margin:24px 0;padding:12px;border-radius:8px}.viewport{overflow:auto}svg{display:block;width:100%;min-width:1000px}svg .wire{transition:opacity .18s}.note{padding:16px;background:#fff3db;border-radius:8px}.checks{font-size:14px;color:#567267}body.focused .wire[data-rail]:not(.active){opacity:.12}button:focus-visible,a:focus-visible,select:focus-visible{outline:3px solid #1777ae}input{vertical-align:middle}@media print{@page{size:A3 landscape;margin:0}header,.controls,h2,footer{display:none}main{padding:0}.sheet{margin:0;padding:0;border:0;break-after:page;border-radius:0}.sheet:last-child{break-after:auto}.viewport{overflow:visible}svg{width:420mm;height:297mm;min-width:0}.wire{opacity:1!important}}@media(max-width:700px){header,main{padding:15px}h1{font-size:27px}}
</style><header><small>BEANLENS · 2026-10-16 · V4.9 样机修订</small><h1>看清每条电线，减少豆路接缝</h1><p>外置24V适配器 + 两块常见降压板。四片PP焊一个连续斗，五孔座与闸片保留拆洗。机架、三面木板与双屏沿用V4.8；这里替换旧版电源与料斗结构。</p><nav><a href="../procurement-v4.9/beanlens-procurement-v4.9.html">新版采购表</a><a href="README.md">详细说明与估价</a><a href="pp-panel-cuts-v4.9.csv">PP外面控制尺寸CSV</a><a href="../../../output/pdf/beanlens-power-and-feed-v4.9-20261016.pdf">四页A3 PDF</a><a href="../assembly-v4.8/beanlens-assembly-v4.8.html">保留的机架 / 双屏尺寸</a></nav><p class="note">XL4016是芯片型号，不代表整板持续电流。先调电压、带负载检查，再接板卡与舵机。此包尚未实机/带豆验证，旧八片PP模板不可用于连续斗。</p></header><div class="controls"><label>查看电路 <select id="rail"><option value="">全部</option><option value="24">24V正线</option><option value="5">5V正线</option><option value="6">6V正线</option><option value="ground">各路返回</option><option value="signal">舵机信号</option></select></label><label>放大 <input id="zoom" type="range" min="100" max="200" value="100" step="25"><output id="zout">100%</output></label><button id="reset">复原视图</button><a href="#page2">端子接哪格</a><a href="#page3">PP怎么简化</a></div><main>__CARDS__</main><footer style="padding:25px">原厂资料：<a href="__ADAPTER__">航嘉</a> · <a href="__BUCK__">XLSEMI</a> · <a href="__TERMINAL__">德力西</a> · <a href="__BUFFER__">TI</a>。孔位、光束避让、退片全行程与带载温升仍待试配。</footer><script>
const rail=document.getElementById('rail'),zoom=document.getElementById('zoom');function update(){document.body.classList.toggle('focused',!!rail.value);document.querySelectorAll('.wire[data-rail]').forEach(e=>e.classList.toggle('active',e.dataset.rail===rail.value));document.querySelectorAll('svg').forEach(e=>e.style.width=zoom.value+'%');document.getElementById('zout').textContent=zoom.value+'%'}rail.onchange=update;zoom.oninput=update;document.getElementById('reset').onclick=()=>{rail.value='';zoom.value='100';update()};update();
</script></html>'''.replace('__CARDS__',cards)
for k,v in SOURCE.items():page=page.replace('__'+k.upper()+'__',v)
(ROOT/'beanlens-power-and-feed-v4.9.html').write_text(page)
print('V4.9 sheets:',names,'hopper:',geometry['nominal_volume_l'],'clearances',geometry['screen_clearance_mm'])
