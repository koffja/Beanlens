"""V4.11 reviewable hardware proposal: continuous front wall and removable brushes.
No electrical load, brush retention, weld or physical collision validation implied.
"""
from pathlib import Path
import csv,html,json,math
ROOT=Path(__file__).resolve().parent;REPO=ROOT.parents[2]
OLD=ROOT.parent/'revision-v4.9'
prior=json.loads((OLD/'design-v4.9.json').read_text());g=prior['hopper']
k=62/g['height_mm'];dx=2*math.sqrt(1+(27/g['height_mm'])**2);dy=2*math.sqrt(1+k*k)
L=14;angle=math.radians(30);root_z=315;tip_z=root_z-L*math.sin(angle)
front_tip=114-k*(tip_z-298.3)+1.5;front_root=front_tip-L*math.cos(angle)
body=dict(upper_pp_mm=[140,30,6],upper_xyz=[40,105,292.3],lower_pp_mm=[140,24,10],lower_xyz=[40,105,280],
 front_bridge_pp_mm=[140,2,18.3],front_bridge_xyz=[40,103,280],side_cheek_pp_mm=[2,32,15.3],
 side_cheek_xyz=[[38,103,283],[180,103,283]],spacers_pp_mm=[10,24,2.3],
 spacer_xyz=[[40,105,290],[170,105,290]],gate_xyz_closed=[55,112.5,290],gate_mm=[110,45,2],
 gap_z=[290,292.3],stroke_mm=15,window_x=[69,86,103,120,137],window_y=[114,126],
 closed_front_overlap_mm=1.5,open_front_clearance_mm=1.5,
 front_wall_continuous=True,entry='rear_only',front_pocket='Front edge enters landing under upper seat; limit stops motion, no impact against wall.',
 welding='PP fixed body welds into a U enclosure, gate withdraws from rear. POM is an alternative bolted architecture, not a weld-in substitute.')
brush=dict(count=10,per_lane=2,placement='Front and rear of five short inlet lanes ABOVE gate; not inside the 10mm lower outlet throat.',
 fibre='PBT',diameter_mm=[0.10,0.15],backing_material='PP',backing_blank_mm=[12,6,3],active_tuft_width_mm=10,
 free_length_mm=L,angle_down_from_horizontal_deg=30,root_z_mm=root_z,tip_z_mm=tip_z,
 root_y_mm=[front_root,240-front_root],tip_y_mm=[front_tip,240-front_tip],
 intrusion_per_side_mm_initial=1.5,gate_to_tip_clearance_mm=tip_z-292.3,
 x_centers_mm=[76,93,110,127,144],port_face_size_mm=[11,4],port_center_z_mm=310,
 carrier_pp_mm=[110,10,3],carrier_qty=2,clamp_pp_mm=[110,8,2],clamp_qty=2,
 carrier_screw_x_mm=[59,84.5,101.5,118.5,135.5,161],carrier_screw='M2x12 candidate, 12 used + 4 spare; thickness / blind inserts verify',
 fore_aft_adjustment_mm=2,
 divider_count=4,divider_pp_thickness_mm=3,divider_z_mm=[298.3,318.3],
 divider_yz_face_mm={'top':12+40*k,'bottom':12,'height':20},divider_x_mm=[83,100,117,134],
 retention='Supplier tufted, sealed cut ends; removable clamp and PP outer guard. No exposed glue or hand-glued loose fibres.',
 uncertainty='Initial fit geometry. Bristle spread, preload, bean passage, retention and cleanability need sample tests.')
power=prior['power'].copy();power.update(revision='V4.11',adapter='YU2405, user selected24V5A120W; exact maker, plug, polarity and supplied AC lead not verified',adapter_user_selected=True,adapter_factory_datasheet_verified=False,buck='5V logic TPS5450 board candidate; 6V servo HOBBYWING UBEC5A 30607000 / 2-8S, selected6V',
 candidate_preference='5V logic: TPS5450 board candidate. 6V servo: user selected UBEC 5A / 6V; proposed exact model HOBBYWING 30607000 2-8S.',
 logic_buck='TPS5450DDA-based 5V complete board candidate; needs exact maker/SKU and 24V to 5V 4A thermal evidence',
 servo_buck='HOBBYWING UBEC 5A, 30607000, 2-8S version, 6.0V jumper selected; factory 5A rating, system wiring / transient testing pending',
 previous_xl4016='Low cost alternative retained; no unsupported claim that all TPS5450 boards outperform all XL4016 boards',
 generic_board_sku=None,servo_module_candidate_sku='HOBBYWING 30607000',servo_module_factory_continuous_a=5,servo_voltage_setting='6.0V jumper; disconnect power before setting, meter before servo connection',continuous_board_rating_verified=False,budget_cny_estimate=None,
 protection_note='TI chip OVP turns high-side FET off during overshoot; not a separate disconnect against a shorted pass switch.',
 safety='Nonisolated. Reverse polarity / output fault containment depend on full board and external protection. Fuses not servo jam protection.')
sources=dict(TI='https://www.ti.com/lit/ds/symlink/tps5450.pdf',XL='https://www.xlsemi.com/datasheet/XL4016-EN.pdf',
 UBEC='https://oss.hobbywing.com/pdf/pdfcn/UBEC5Acn.pdf',SEN0503='https://www.dfrobot.com.cn/goods-3274.html',
 POM='https://www.ensingerplastics.com/-/media/Ensinger/Files/Document%20Teaser%20Files/Brochures/Shapes/Stock%20Shapes-catalog-en-2024')
d=dict(revision='V4.11',date='2026-10-17',status='proposal_not_bench_or_physical_validated',
 confirmed_user_requirement='Continuous front wall; gate enters from rear and closes inside front landing.',
 hopper=g,body=body,brush=brush,power=power,sources=sources,
 mounting=dict(top_flange_mm=[176,196,3],flange_xyz=[22,22,440],inner_hole_mm=[136,136],
 brackets=4,bracket_raw='6061 angle25x25x2, cut width20, vertical leg22 / horizontal leg14',
 bracket_xyz=[[20,75,438],[20,145,438],[186,75,438],[186,145,438]],
 pp_slot_centers_xy=[[28.5,85],[28.5,155],[191.5,85],[191.5,155]],slot_mm=[3.5,7],
 M5_sets=4,M3x12_sets=4,spares_each=2,M3_washer_od_mm=9,bracket_M5_vertical_slot_mm_proposal=[5.5,8],M5_washer_od_mm=12,
 load_path='Hopper -> PP welds -> PP3 rim -> four supports -> black2020. Lower fixed feed body also locates on G21/G11; align without pulling the weldment out of plane.',
 note='PP3 creep, weld pull-out and single-screw bracket rotation not yet proof-loaded. No wood hopper load support.'),
 retained='V4.8 frame, nine wood panels, screens; V4.9 main four hopper panels and electrical topology retained.',
 unresolved=['G10 ball head ear and full rear moving envelope / hood G20 need physical sweep mockup',
 'IR beam Z277 / base feet clearance remains unverified; brushes stay above gate and do not move beam',
 'PP weld distortion and sliding friction, short brush segments / outer guards / carrier exact holes need samples',
 'Power full board SKU / temperature / ripple / startup / peak response not validated'])
# Synchronize retained hopper metadata with the current continuous PP body.
g.update(lower_seat_xyz_mm=body['lower_xyz'],lower_seat_size_mm=body['lower_pp_mm'],lower_seat_material='PP-H')
d['mvp_revision_scope']='Replace beam sensor with DFRobot SEN0503 and adapter with YU2405; retain V4.10 mechanics and 5V TPS candidate / 6V UBEC selection.'
d['beam_hint']={'model':'DFRobot SEN0503','supply_v':5,'working_voltage_range_v':[3,5],'manufacturer_range_at_5v_mm':500,'manufacturer_range_at_3v3_mm':200,'manufacturer_response_ms':2,'manufacturer_current_ma':25,'head_lwh_mm':[20,10,9],'cable_mm':250,'output':'NPN normally open; internal pullup and beam-block polarity not verified','gpio':20,'signal_pullup_v':3.3,'pullup_ohm':10000,'series_ohm':1000,'active_level':None,'hardware_verified':False,'source':'https://www.dfrobot.com/product-2388.html','installed_head_axis_mapping_verified':False,'purpose':'passage_hint_not_bean_counter'}
d['power'].pop('module_purchase_envelope_mm',None)
d['power']['logic_module_purchase_envelope_mm_proposal']=[65,55,30]
d['power']['servo_module_factory_mm']=[50,17,10]
(ROOT/'design-v4.11.json').write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n')

class Sheet:
 def __init__(self,n,title,sub):
  self.n=n;self.s=[f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1500 1060" role="img" aria-label="{html.escape(title)}">',
  '<style>text{font-family:"PingFang SC","Microsoft YaHei",sans-serif;fill:#253c36;font-size:21px}.wire{fill:none;stroke-width:3;stroke-linecap:round;stroke-linejoin:round}.bold{font-weight:700}</style><rect width="1500" height="1060" fill="#fafbf7"/>']
  self.text(48,55,f'BEANLENS / V4.11 / {n:02d}',16,'#477d67');self.text(48,108,title,36);self.text(48,148,sub,19,'#667c71')
 def text(self,x,y,t,size=20,col=None,cls=''):
  self.s.append(f'<text x="{x}" y="{y}" class="{cls}" style="font-size:{size}px'+(f';fill:{col}' if col else '')+'">'+html.escape(str(t))+'</text>')
 def rect(self,x,y,w,h,fill='#fff',stroke='#c6d6ca',r=8):self.s.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}" fill="{fill}" stroke="{stroke}" stroke-width="2"/>')
 def line(self,pts,col='#487465',dash=False):self.s.append('<polyline class="wire" points="'+' '.join(f'{x},{y}' for x,y in pts)+f'" stroke="{col}"'+(' stroke-dasharray="8 6"' if dash else '')+'/>')
 def poly(self,pts,fill='#d4e9db',stroke='#50896b'):self.s.append('<polygon points="'+' '.join(f'{x},{y}' for x,y in pts)+f'" fill="{fill}" stroke="{stroke}" stroke-width="2"/>')
 def box(self,x,y,w,h,title,lines,fill='#fff'):
  self.rect(x,y,w,h,fill);self.text(x+16,y+31,title,23,cls='bold')
  for i,t in enumerate(lines):self.text(x+16,y+61+27*i,t,18)
 def save(self,name):
  self.line([(48,1000),(1452,1000)],'#d3ded4');self.text(48,1030,'2026-10-17 · 方案尺寸，非实物验收 · 先试焊 / 手推 / 无刷与带刷单槽对照，再五槽联调',16);self.text(1390,1030,f'{self.n} / 6',16)
  self.s.append('</svg>');(ROOT/name).write_text('\n'.join(self.s));return name

p=Sheet(1,'料斗靠“顶托环 + 四只金属托片”挂在黑色 2020 上','PP 与木板不是一回事：木板只做外壳；豆路组件的重量经顶部托环传给铝框。左图为俯视，单位 mm。')
sx=2.5;ox=70;oy=225
def rxy(x,y,w,h,fill,stroke='#496e5a'):p.rect(ox+x*sx,oy+y*sx,w*sx,h*sx,fill,stroke,0)
rxy(0,0,220,240,'#242b2e');rxy(20,20,180,200,'#fafbf7')
rxy(22,22,176,196,'#c5dfcf');rxy(42,52,136,136,'#fafbf7')
for x,y in [(20,75),(20,145),(186,75),(186,145)]:rxy(x,y,14,20,'#9aaeb5')
for x,y in d['mounting']['pp_slot_centers_xy']:
 p.s.append(f'<ellipse cx="{ox+x*sx}" cy="{oy+y*sx}" rx="8.75" ry="4.375" fill="#fff" stroke="#916a29" stroke-width="2"/>')
p.text(213,471,'136 × 136 投料口',24);p.text(202,506,'PP3 顶托环',22)
p.text(76,203,'外框 220 × 240',23);p.text(81,858,'顶托环外形 176 × 196，内孔 136 方',20)
p.text(81,891,'4个长孔中心见数据；M3槽 3.5 × 7',20)
p.line([(ox+28.5*sx,oy+85*sx),(720,410)],'#93692f');p.text(744,417,'支点侧剖面（放大示意）',20)
# local side section, true X/Z ratio: profile x0..20,z440..460.
X=lambda x:795+x*7;Z=lambda z:695-(z-430)*7
p.rect(X(0),Z(460),140,140,'#252e31','#1c2528',0)
p.poly([(X(20),Z(452)),(X(18),Z(452)),(X(18),Z(454)),(X(15),Z(454)),(X(15),Z(446)),(X(18),Z(446)),(X(18),Z(448)),(X(20),Z(448))],'#fafbf7','#73857d')
p.rect(X(15.5),Z(452),14,28,'#aa8a4f','#785d31',0)
p.rect(X(20),Z(460),14,154,'#a7b9bf','#667c83',0)
p.rect(X(20),Z(440),98,14,'#a7b9bf','#667c83',0)
p.rect(X(22),Z(443),126,21,'#9dccad','#578465',0)
p.rect(X(40),Z(440),14,82,'#d8e8dd','#578465',0)
p.poly([(X(38),Z(440)),(X(40),Z(440)),(X(40),Z(438))],'#d18d49')
p.line([(X(28.5),Z(446)),(X(28.5),Z(435))],'#87631c')
p.line([(X(16),Z(450)),(X(24),Z(450))],'#87631c')
p.text(1160,465,'M5 / T螺母 + 竖长孔',20);p.line([(1150,473),(X(21),Z(450))])
p.text(1160,525,'M3×12 + φ9垫片',20);p.line([(1150,532),(X(28.5),Z(443))])
p.text(1160,580,'PP3 托环底 Z440',20);p.line([(1150,586),(X(34),Z(441.5))])
p.text(1160,638,'PP2 壁与托环外侧焊',20);p.line([(1150,646),(X(40),Z(438))])
p.text(1160,694,'金属角片：宽20，厚2',20)
p.box(744,190,704,177,'装配顺序',['① M5/T螺母把4只金属托片锁在顶框内侧槽。','② 焊好的PP斗连顶托环从上方放下，坐在4托片上。','③ 4颗M3穿长孔固定；量平整、检查焊筋和屏幕间隙。','④ 最后接闸片/连杆；焊接和承重不靠木外壳。'],'#eaf3ea')
p.box(744,750,704,218,'力是这样传的',['上斗 → PP焊缝 → PP3托环','→ 4只金属托片 → M5/T螺母 → 黑2020框。','托片由25×25×2角铝裁制，竖脚22 / 横脚14。','M3槽补偿装配偏差，不能靠松螺丝消除晃动。','PP蠕变、焊缝拉脱和托片转动还要做静载试验。','下槽盒另由G21/G11定位，禁止上下硬拉找平。'])
names=[p.save('01-hopper-mount.svg')]

p=Sheet(2,'前壁连续：关闸藏入前承接槽，开闸只向后退','侧剖面：左为机器前方，右为后方。绿色是固定PP件；灰色为铝闸片。可在网页拖动“开度”。')
Y=lambda y:70+(y-100)*7;ZZ=lambda z:790-(z-275)*10
def yz(y,z,w,h,fill='#b4d9c0'):p.rect(Y(y),ZZ(z+h),w*7,h*10,fill,'#548668',0)
# Same V4.9 sloped hopper, showing only its lower region.
p.poly([(Y(114-20*k),ZZ(318.3)),(Y(114),ZZ(298.3)),(Y(114-dy),ZZ(298.3)),(Y(114-20*k-dy),ZZ(318.3))])
p.poly([(Y(126+20*k),ZZ(318.3)),(Y(126+dy+20*k),ZZ(318.3)),(Y(126+dy),ZZ(298.3)),(Y(126),ZZ(298.3))])
for z,h in [(292.3,6),(280,10)]:
 yz(105,z,9,h);yz(126,z,9 if h==6 else 3,h)
yz(103,280,2,18.3,'#5eaf7e')
p.s.append('<g id="moving-gate">');yz(112.5,290,45,2,'#b8c0c5');p.s.append('</g>')
p.line([(Y(112.5),ZZ(290)),(Y(112.5),ZZ(287)),(Y(114),ZZ(287))],'#8b49b1')
p.text(65,844,'闭合前缘 Y112.5：藏入前承接槽 1.5',20,'#7844a3')
p.text(65,878,'打开前缘 Y127.5：退过孔尾 Y126 再多 1.5',20)
p.text(65,912,'侧面封板 / 两端隔距条未画在中心剖面内',18)
p.text(67,945,'绿色前封壁贯穿 Z280–298.3；槽口只朝后开',19)
p.text(65,240,'连续PP前封壁',22);p.line([(163,248),(Y(104),ZZ(286))])
p.text(284,224,'在上斗内向上延伸20mm的分道片与刷排',20)
p.text(284,254,'刷毛最低 Z308，远离闸片上表面 Z292',18)
p.line([(Y(134),ZZ(308)),(Y(151),ZZ(308)),(Y(155),ZZ(315))],'#ab7643',True)
p.text(462,321,'后部连杆 / 防护罩另试配',18)
p.text(317,498,'PP6 上座',21);p.line([(306,505),(Y(130),ZZ(295))])
p.text(317,711,'PP10 下座',21);p.line([(306,718),(Y(127),ZZ(285))])
p.text(420,578,'← 关 / 开 →',22,'#62727b')
p.box(744,190,704,171,'这次修正了什么',['PP上座 + PP下座 + 前封壁 + 两侧封板，焊成固定槽体。','前面和两侧没有整条贯通的闸缝，豆子不能被向外推。','闸片只从后方进出；到位用限位停车，不撞前壁。','10mm下座只是出豆孔段厚度，不负责装刷条。'],'#eaf3ea')
p.box(744,380,704,171,'固定件 / 移动件的尺寸',['上座140×30×6；下座140×24×10，前脸同在Y105。','下座后端仍到Y129，避开Y132起的后导轨。','前封片140×18.3×2，两侧封片32×15.3×2。','闸缝2.3，闸片2，行程15；间隙先按实厚试配。'])
p.box(744,570,704,171,'为什么下座改 PP？',['POM滑动、耐磨与尺寸稳定性更好，原选材有理由。','现在优先要可热焊的连续固定壁，所以用PP-H槽体。','PP手推阻力、焊后平整与磨损必须试验，不能当成POM。','POM保留为可拆螺接版本备选，不能直接焊到PP里。'])
p.box(744,760,704,210,'别把 PP 焊死在移动件上',['固定槽体焊接时，用量规控制闸缝，闸片/刷毛不在场。','冷却后再装铝闸片，手推全程；不靠螺丝挤压调间隙。','可从后方退出闸片清槽；盲承接位需检查积屑。','后退片罩、球头共面和光束/底脚仍需全行程试配。','这张剖面表达连续豆路，不代表整机碰撞审查完成。'],'#fff3dc')
names.append(p.save('02-continuous-front-gate.svg'))

p=Sheet(3,'PBT刷在五槽入口，夹在可拆刷盒里，不塞进10mm下座','五槽分道片从上座顶 Z298.3 向上延伸到 Z318.3。前后各5段轻刷，刷根在斗外，刷毛经小槽伸入。')
p.text(48,200,'从正面看五槽 / 前排刷根位置（后排相同）',22)
xx=lambda x:65+(x-62)*6.2
for x in [83,100,117,134]:p.rect(xx(x),240,3*6.2,180,'#bddbc7','#669478',0)
for i,x in enumerate(brush['x_centers_mm']):
 p.rect(xx(x-6),275,12*6.2,6*6,'#d2b28a','#956f3b',2)
 for j in range(7):p.line([(xx(x-5+j*10/6),311),(xx(x-5+j*10/6),361)],'#b08d51')
 p.text(xx(x-4),231,str(i+1),21)
p.line([(xx(65),430),(xx(155),430)],'#7d8c84');p.text(65,465,'孔口14×12；隔肋3；不是在3mm肋里塞两副刷背。',19)
p.text(65,503,'每段基条12×6×3，毛簇有效宽10；共10段。',19)
p.text(65,541,'两条110×10×3载条，110×8×2压条夹紧。',19)
p.text(65,579,'刷段由厂家植毛并封端；不能用散毛加热熔胶粘。',19)
p.box(48,630,636,336,'安装与调整',['① 先买样段，确认PP基条 / PBT毛径 / 植毛牢度。','② 斗片上每面开5个11×4圆角毛槽，先去毛刺。','③ 焊斗与4片分道片，冷却后再装刷盒。','④ 载条前后调±2mm，毛尖每侧侵入先取1.5。','⑤ 外加可拆PP防豆背罩，把刷根与槽口围住。','⑥ 先无刷试豆，再带刷；碎豆能过、无脱毛。','⑦ 刷阻大先减侵入，不靠加大舵机力压豆。','毛槽与夹盒按样件定孔，图中不是最终植毛加工图。','刷条不保证单豆分离，也不替代图像计数。'],'#eaf3ea')
# Bristle side profile in the same actual Y/Z coordinates, magnified around hopper front.
bx=765;by=590;s=10
py=lambda y:bx+(y-96)*s;pz=lambda z:by-(z-304)*s
p.poly([(py(114-k*(320-298.3)),pz(320)),(py(114-k*(304-298.3)),pz(304)),(py(114-k*(304-298.3)-dy),pz(304)),(py(114-k*(320-298.3)-dy),pz(320))])
p.line([(py(front_root),pz(root_z)),(py(front_tip),pz(tip_z))],'#af8147')
p.rect(py(front_root)-30,pz(root_z)-25,30,50,'#d0ad79','#987043',1)
p.line([(py(front_root),pz(root_z)+35),(py(front_tip),pz(tip_z)+35)],'#987043',True)
p.text(1051,472,'前壁PP2',20);p.text(1051,512,'毛长14，向下30°',20)
p.text(1051,552,'尖端 Z308',20);p.text(1051,589,'侵入1.5（初试）',20)
p.text(756,633,f'前根Y≈{front_root:.2f} / 后根Y≈{240-front_root:.2f}，根Z315',18)
p.text(756,666,'前后对称不是硬挤住豆：毛尖间距与豆样实测调整。',18)
p.box(744,190,704,171,'这里能放得下的原因',['用斗底20mm高的分道区装刷，保留原料斗容积。','4片PP3分道片：高20，上深29.50 / 下深12。','刷毛尖端 Z308，离闸缝顶 Z292.3 约15.7。','下面10mm短出豆孔保持通畅，光电/相机位置不下移。'])
p.box(744,716,704,250,'夹持细节与仍须实配的部分',['载条X55–165，刷毛簇中心X76/93/110/127/144。','压条开5个11×3出毛窗，不可把毛根夹死。','每排6颗M2候选：X59/84.5/101.5/118.5/135.5/161。','M2×12为堆叠起点，螺母与尖头全部位于豆路外。','4只外置PP小托架用长孔给前后调节，不让毛束夹硬。','外侧罩按斜斗面配形；后排刷盒与后罩/连杆联合试配。','不采购缺少植毛/封端资料的“相似小刷条”。'],'#fff3dc')
names.append(p.save('03-pbt-brush-cassette.svg'))

p=Sheet(4,'TPS5450值得优先考虑，但先选整板，再谈性能和安全','此比较只针对5V逻辑路（预算4A）；6V舵机按用户确认采用UBEC 5A / 6V，输入仍接24V支路。')
data=[['比较项','TPS5450','XL4016'],['原厂输入范围','推荐5.5–36V，绝对上限40V','推荐8–36V，绝对上限40V'],['开关频率','500kHz','180kHz'],['芯片电流标称','5A连续 / 6A峰值（有条件）','现行Rev1.6列12A（不是整板保证）'],['原厂资料明确的保护','软启、欠压、过流、过压、过温','过流、短路、过温等'],['不能从型号推定的事','整板4A温升 / 5A峰值 / 纹波','整板4A温升 / 5A峰值 / 纹波'],['电源是否隔离','否，仍需正确共地与分开回流','否，仍需正确共地与分开回流']]
yy=194
for i,row in enumerate(data):
 p.rect(48,yy,1400,53,'#e6f0e6' if i==0 else ('#f0f5ed' if i%2 else '#fff'),'#d5e0d3',0)
 for x,t in zip([62,375,925],row):p.text(x,yy+34,t,18 if i else 21)
 yy+=53
p.box(48,602,686,180,'推荐结论',['5V侧：优先审核TPS5450整板，调压与保护资料更清楚。','6V舵机：好盈UBEC 5A，30607000 / 2–8S版。','UBEC跳帽设6V再实测；不选7.4V，不接到GPIO。','UBEC给电源，舵机信号仍接C6；两路负载分开回流。'],'#eaf3ea')
p.box(760,602,688,180,'为什么不能直接说“更安全”？',['芯片OVP是关断开关，不能隔离已短路的功率开关。','反接保护、保险、线径、输出接口取决于整块板。','PowerPAD焊接、铜皮、外置二极管与电感影响发热。','两者都不能因为换芯片而省掉带载、温升和瞬态检查。'],'#fff3dc')
p.box(48,803,686,172,'性能比较要在同一工况下做',['24V输入：TPS板测5V/4A；UBEC测6V负载与短峰。','记录板端电压、输出纹波、启动过冲和温升。','TPS5450典型参数粗算24→5V/4A芯片损耗约1.57W。','这还没有包含外置二极管、电感等损耗。'])
p.box(760,803,688,172,'采购状态和成本',['原XL4016保留低成本备选，不按“8A/12A”宣传验收。','TPS5450DDA是芯片封装号，不是淘宝整板型号。','5V板核24→5V；UBEC核2–8S版和6V档。','当前整板未选定，旧电源包200–370估价不直接沿用。'])
names.append(p.save('04-tps5450-comparison.svg'))

# Retain previously audited wire topology, updating candidate identity rather than inventing a module pinout.
s=(OLD/'01-power-wiring.svg').read_text().replace('2026-10-16','2026-10-17')
s=s.replace('A07 航嘉外置适配器','A07 外置适配器').replace('HKA12024050-7B','YU2405（用户指定型号）').replace('2167 对射','SEN0503 对射').replace('端子编号见第2页。','TB端子定义见配套说明。')
s=s.replace('V4.9  /  01','V4.11  /  05').replace('1 / 4','5 / 6')
s=s.replace('A08 XL4016 模块 A','A08 TPS5450 候选').replace('A17 XL4016 模块 B','A17 UBEC 5A')
s=s.replace('先空载调到 5.00V','5.00V，整板SKU待核').replace('先空载调到 6.00V','30607000，先确认6V跳帽')
s=s.replace('50V 输入电容 / 双散热片优先。','输入电容 / 散热按整板工况核。').replace('“XL4016 8A/12A”不是整板承诺。','芯片5A不是整板5A的承诺。')
(ROOT/'05-power-wiring-candidates.svg').write_text(s);names.append('05-power-wiring-candidates.svg')

p=Sheet(6,'MVP：SEN0503 用5V供电，信号另上拉3.3V','红外型号：DFRobot SEN0503 / 50cm。YU2405替换主适配器；5V逻辑降压与6V UBEC保持分路。')
p.box(48,198,330,142,'发射头 TX',['红线 → 5.0V','黑线 → GND','不接6V / 24V'],'#eaf3ea')
p.box(48,424,330,176,'接收头 RX',['红线 → 5.0V','黑线 → GND','白线 → 信号节点 A','原厂：NPN常开输出'],'#eaf3ea')
p.line([(378,528),(630,528)],'#23789d');p.s.append('<circle cx="630" cy="528" r="6" fill="#23789d"/>')
p.text(616,565,'A',23)
p.rect(582,288,96,45,'#f3eaf9','#8556a8',4);p.text(598,318,'3.3V',20,'#8556a8')
p.line([(630,333),(630,380)],'#8556a8');p.rect(602,380,56,85,'#fff','#8556a8',3);p.text(613,430,'10k',19);p.line([(630,465),(630,528)],'#8556a8')
p.line([(630,528),(805,528)],'#23789d');p.rect(805,505,83,45,'#fff','#23789d',4);p.text(825,536,'1k',20);p.line([(888,528),(1010,528)],'#23789d')
p.box(1010,464,438,127,'C6 GPIO20（拟定）',['确认两状态电压后才接入','串联1k不负责把5V降到3.3V'])
p.text(705,576,'先不接GPIO，在 A 对 GND 测量',17,'#23789d')
p.box(744,198,704,198,'型号和供电已核对',['SEN0503：DC3–5V；50cm是5V供电下的标称距离。','3.3V供电标称20cm，本机首样用5.0V逻辑支路。','外形20×10×9、线长250；安装孔与光轴按实物核对。','5V供电不代表信号可以5V进入C6。','上拉是3.3V，不接红色5V线；两头黑线与C6共地。'],'#eaf3ea')
p.box(48,658,684,300,'接板前只做这几步',['① GPIO保持断开，传感器接5V/GND及10k上拉。','② 测无遮挡/遮挡时 A 对GND电压，记录哪种是高/低。','③ 高低状态须落在3.3V输入域；若超过3.3V，先断开。','④ 若不稳定，查对准、供电与输出接口，不用1k硬顶。','⑤ 合格后再串1k接GPIO20，重复遮挡并检查相机IR亮点。','NPN常开不等于已核对内部电路或遮挡极性。','仍只作豆流经过提示；不能把一次遮挡当一颗豆。','读数阈值与有效电平按实测记录后再配置固件。'])
p.box(760,658,688,300,'YU2405：按用户指定的MVP型号采购',['额定按24V / 5A / 120W纳入，原功率预算不变。','尚无对应实物厂牌/原厂数据，不能沿用航嘉认证或尺寸。','DC母座先按实际外径/内径/极性配，5.5×2.5仅候选。','交流线入口与是否随附按订单核对，不在机内接裸交流。','到货先量24V与正负，再检查5V和UBEC的6V档。','分级带载检查压降/温升，不能把型号额定当实测。','DFRobot国内页参考价15元/收发对，非成交报价。','5V TPS模块仍待整板SKU；舵机仍用UBEC5A/6V。'],'#fff3dc')
names.append(p.save('06-mvp-sensor-wiring.svg'))

cutrows=[['F18','PP-H','140×30×6','1','上五孔座；同V4.9'],['G12','PP-H','140×24×10','1','下五孔座；局部孔Y9，后端全局Y129'],['F19-front','PP-H','140×18.3×2','1','前封壁，固定片全高焊接'],['F19-side','PP-H','32×15.3×2','2','两侧封片Z283–298.3，避开光电头名义顶Z282'],['G21','PP-H','10×24×2.3','2','隔距条名义厚度，按闸片实厚＋总游隙约0.3试配'],['B16','PP-H3','上29.502 / 下12 / 高20','4','分道片YZ面梯形，X厚3，端面配斗壁'],['B14-carrier','PP-H','110×10×3','2','刷排载条'],['B14-clamp','PP-H','110×8×2','2','刷排压条'],['B11','PP基条/PBT','12×6×3基条 / 自由毛长14','10','厂家植毛封端；毛簇宽10、毛径0.10–0.15'],['F04-ports','PP2主斗壁','11×4斜面圆角槽','10','前后面各5；中心X76/93/110/127/144，Z310，按样刷修孔']]
with (ROOT/'changed-cuts-v4.11.csv').open('w',encoding='utf-8-sig',newline='') as f:
 w=csv.writer(f);w.writerow(['BOM','材料','名义规格mm','数量','用途/状态']);w.writerows(cutrows)

readme='''# BeanLens V4.11：MVP对射与电源选型、连续PP槽体

2026-10-17。用户确认：**前壁连续，铝闸片从后方关闭，闭合前缘进入前壁内侧承接槽**。本次在V4.10机械方案上改用DFRobot SEN0503对射和YU2405主适配器；保留5V侧TPS5450候选与6V侧UBEC5A/6V。它是样机结构方案，尚未实物或电气验收。

## 文件与版本

- [六页图和闸片开合演示](beanlens-hopper-gate-v4.11.html)：固定、板厚、连续前壁/槽内刷、TPS比较、接线拓扑。
- [采购表](../procurement-v4.11/beanlens-procurement-v4.11.html) / [改动物料尺寸](changed-cuts-v4.11.csv) / [结构数据](design-v4.11.json)。
- [六页A3图册](../../../output/pdf/beanlens-hopper-gate-v4.11-20261017.pdf)。
- 原V4.8机架、9木板与双屏位置不变。V4.9四片主斗外面尺寸、Z440上口和Z298.3底口不变；新增刷孔/分道片，旧V4.8八片模板仍不可混用。V4.9的POM下座被本版PP连续槽体主方案替换。

## TPS5450是否比XL4016合理

**优先审核TPS5450成品板是合理的，不能只按芯片名字直接定型。** TPS5450推荐5.5–36V、芯片5A连续/6A峰值、500kHz，原厂明确软启动、欠压、过流、过压及过温保护。XL4016现行Rev1.6推荐8–36V、180kHz，列12A芯片能力及过流/短路/过温等。两者40V都是绝对上限，不是允许长期工作电压。TPS5450不是因为型号而自动具备更大输出电流，500kHz也不等于实际板的纹波必然更低。

逻辑侧需要24→5V、4A连续预算；TPS5450芯片理论范围覆盖，整板温升和压降必须过关。**舵机侧已由用户确认用UBEC5A/6V，不再列TPS5450为主方案。** 推荐可核原厂型号：好盈HOBBYWING UBEC5A / 30607000 / 2–8S版，50×17×10mm，原厂标称持续5A，设置6.0V。24V在2–8S锂电池对应电压范围内；核所购标签一致，不能换成仅支持2–3S的同名BEC。实际负载仍按6V/3A持续目标、5A短峰预算验收，不因原厂15A瞬间标称提高本机预算。TPS的5A能力不能替代外置二极管、电感、电容、铜皮与PowerPAD散热焊接的设计。按TI简化公式及典型0.11Ω导通参数，24→5V/4A芯片损耗约1.57W，尚未算外部损耗；小板密闭安装不能套用参考板热阻。计算为4²×0.11×5/24 +24×4×0.01 +24×0.01≈1.57W，不是实测。

TPS的OVP主要通过关闭高侧开关限制正常调节过程的过冲；如果功率开关本身短路，它不是一道独立断开故障电压的屏障。不能承诺“TPS一定不烧主板”。两个方案都是非隔离降压。反接保护、保险、接地与接口区分按整板和外部接线检查。没有模块原理图、完整型号和测试数据前，A08标为**5V TPS5450优选候选/暂缓整板定型**；A17主方案改为**UBEC5A/6V，好盈30607000候选**；XL4016另列备选。主适配器按本次MVP改YU2405，24V容量与保险（主4A、灯2A、5V输入2A、6V输入3A）、分路返回与信号电压不变。

采购询问模板（仅5V逻辑板）：需要成品TPS5450模块一块，输入24V，输出5.00V、4A连续预算；请提供整板品牌/SKU、输出设定方式、尺寸与孔位、24V输入工况温升及纹波、负载阶跃、芯片来源和保护说明。不要购买裸TPS5450DDA芯片代替模块。新电源总价待5V板及UBEC报价，旧200–370估价不直接沿用。

UBEC接法：TB-A 3经3A输入保险 → UBEC IN+；TB-A 6 → UBEC IN−。UBEC OUT+/OUT− → TB-B 3/4 → 舵机6V/GND；舵机PWM仍来自C6 GPIO2。先断电，按原厂说明把远离电容的两插针用跳帽设为6.0V，上电实测再接舵机；此跳帽位置只适用该好盈型号，其他型号不能照抄。不得选7.4V；UBEC输出插头是供电，不是PWM，不能接GPIO或5V主板电源。原厂线径与插头额定另外核对，新增0.75mm²线段不能证明原线/触点已能承载全5A；不要用杜邦线作舵机电源转接。

UBEC具有过流、输出短路及过温保护，金属罩有助散热/降低干扰；保护恢复会重新供电，不等于硬件急停或保证关闸。仍与称重/相机线分开布线，按空载舵机、带载压降/温升与实际动作测试验收。原厂5A与15A分别为持续/瞬间标称，不是用户这只MG996R的实测电流。


## 料斗到底如何固定

四只F13金属角片先用M5/T螺母锁在顶框内侧槽。顶PP3托环外形176×196、136方孔，位置X22/Y22/Z440；PP2斗的四边顶端与托环下侧焊为一体。将整组从上方放到四托片上，托环底Z440，顶Z443；再用4颗M3×12、φ9大垫片和螺母固定，另2套备用。

四支承为25×25×2角铝裁宽20，竖外脚22、横外脚14；全局支承起点(20,75,438)/(20,145,438)/(186,75,438)/(186,145,438)。PP长孔中心(28.5,85)/(28.5,155)/(191.5,85)/(191.5,155)，孔3.5×7沿X。根部圆角按实物检查，PP支点处局部2×2倒角沿20长避R仅是候选修配，不能任意削薄大面积。

受力：上斗 → PP焊缝 → PP3托环 → 四金属托片 → M5/T螺母 → 黑2020；下方固定槽体还由G21接G11定位，不能假定所有重量只走顶托环。先把下槽盒/导轨共用底座装平，再让顶环坐实并锁紧，不能用上下螺钉硬拉焊件找平。托片竖脚M5孔建议5.5×8竖长孔，孔中心相对竖脚底12mm（名义Z450），约±1.25mm调节；M5加φ12大垫片，4用2备，按实物槽型核螺钉长度。木板不是料斗承力支座。PP2与PP3厚薄焊先试片；托环平整、焊缝拉脱、长期蠕变与托片单螺钉转动需静载验证。1kg为原载荷目标，不等于现有约1.22L料斗能装1kg生豆；用实际豆样验证容量，不能用板厚代替容量计算。

## “法向板厚”是什么

“法向”只是**垂直于板面**的方向。2mm PP板就是卡尺夹住两面读到2mm。板斜放后，从机器水平方向横着量，两面的截距会大于2mm；本斗前后壁约2.183mm。板没有变厚，只是量的方向变了。外口尺寸用实际板厚换算，不能在内口每边任意加2mm就把斜壁外形算对。图中的示意线加粗不代表购买更厚板。

## 为什么原来用了POM；现在改哪里

POM有较好的滑动、耐磨、刚性和加工稳定性，原来作为可拆滑座有理由。10mm指一块板沿落豆方向的厚度，5个14×12孔贯通这10mm，不是每槽宽10mm。厚板让孔缘有支承、容易加工，不等于更容易逐粒送料；原方案没有充分安排刷排。

连续焊接前壁优先采用PP-H固定槽体：上座仍PP6 140×30，下座改PP10 140×24，前脸均Y105，孔起点局部Y9。下座后端Y129，保持不碰从Y132起的导轨。两端隔距条10×24×2.3；前封片140×18.3×2位于Y103–105，跨过Z280–298.3；两侧封片32×15.3×2位于X38–40和180–182，Z283–298.3；底边高于原光电头名义顶Z282，仍按实物留间隙。固定件焊成前面/两侧连续的U形封闭体，只向后留闸片进出口。

关闭时闸片前缘Y112.5，进入Y105–114的前承接位，覆盖孔前缘1.5mm；打开时前缘Y127.5，退过孔尾126再多1.5mm。整片前缘同时横跨5槽。不能靠撞前壁当限位。闸片Z290–292，闸缝Z290–292.3，名义总隙0.3；按实物厚度和平整度试配。焊接固定件时闸片、滑轨和PBT都拆下，用量规控制间隙，冷却后才装。薄PP封片焊到PP10须先练厚薄件，防薄壁烧穿和上座翘曲。

PP滑动/磨损性能不能直接按POM算；先手推测阻，再空载舵机。手推不顺先修平整和间隙，不加大舵机力。POM保留为另一个可拆螺接槽盒版本备选，不能热风焊进当前PP框替换。固定槽体整体焊接后，可从后方退闸片清理孔与前盲承接位；若积屑不能彻底清除，应改为可拆槽盒再带豆联调。

## PBT刷：在闸片上方的五槽入口安装

保留原主斗形状，在斗底内加4片PP3短分道片，Z298.3–318.3，YZ面梯形上深29.502/下深12/高20，X厚3，起点X83/100/117/134。下端分别焊在五孔上座的4条肋上，前后端配斜斗面。这样五槽入口向上延伸20mm，不缩短主斗；上方外侧两槽随斗面略张开，孔口仍为14×12。

每槽前后各一段PBT，共10段；从原“左右塞进薄隔肋”的含糊表述改为**前后两排刷盒**。基条候选PP12×6×3，毛簇有效宽10，PBT丝径0.10–0.15，自由毛长14mm，向水平下方30°。毛根Z315，毛尖Z308，距闸缝顶约15.7mm。毛尖在各自Z高度的斜斗内面侵入先取1.5mm，不是把14mm毛长全塞进12mm孔深。

初始前毛根Y约99.13、后毛根Y约140.87，前后可调±2mm。前后斗面各5个11×4圆角毛槽，中心X76/93/110/127/144，装机中心Z310；4mm按斜面量。毛束实际散开、角度、PP厚度和焊筋需要样件修孔，不能凭尺寸直接批量开孔。圆角去毛刺，检查来回摩擦不刮断PBT。不能把裸毛直接粘在PP上或对着已安装刷毛热焊。

两条PP3载条110×10、两条PP2压条110×8夹持成品植毛小段，段间及两端设12块4×6×3 PP垫块（每排6），压条开5个11×3出毛窗；窗心X同毛簇，Z约314.4，孔口去毛刺，不夹死毛根。载条在基条背面，压条在出毛面；14mm毛长包含经窗穿出的部分。每排6个M2候选夹持点X59/84.5/101.5/118.5/135.5/161；M2×12起点，12用4备，实量堆叠后定。4只外置PP小托架给前后调节。刷盒外侧加可拆PP防豆背罩，候选包络110×20×16每排一只，按斜面纸样配形；螺母、端头、可能的植毛锚固均在豆路外且封闭。刷盒和盖的孔位不是已冻结加工图，先询价成品样刷再定。

先无刷通过豆样，再逐步加刷验证；取低侵入量，观察正常豆、碎豆、灰屑是否架桥、脱毛或增加破损。关闸扫过的平面不能碰到任何PBT毛尖。刷子不保证单豆分离，不能据此推导计数准确率或五槽吞吐量。

## 验证边界

本包有尺寸和几何一致性检查、网页与PDF排版检查，未做负载、焊接、脱毛、带豆、称重或光学实测。G10球头耳实际高度、G20后退片罩与后刷盒的窗口及全行程仍需纸样/实物联合试配；不要把简单方罩直接扣在球头上。原IR光束Z277与脚座避让仍未验收；此次刷排位于Z308以上，不以随意下移光电来腾位置。仍按无执行器→空载→单槽→五槽顺序验收，卡豆超时不持续加力。

## 原厂资料

- [TI TPS5450，Rev.E](https://www.ti.com/lit/ds/symlink/tps5450.pdf)：5A/6A、保护、布局及损耗简化公式；不是淘宝整板证明。
- [XLSEMI XL4016，Rev1.6](https://www.xlsemi.com/datasheet/XL4016-EN.pdf)：推荐8–36V、180kHz、芯片12A条目；整板另验。
- [好盈UBEC5A原厂中文说明书](https://oss.hobbywing.com/pdf/pdfcn/UBEC5Acn.pdf)：2–8S、5/6/7.4V设置、持续5A及保护；本机选6V档。
- [Ensinger材料目录](https://www.ensingerplastics.com/-/media/Ensinger/Files/Document%20Teaser%20Files/Brochures/Shapes/Stock%20Shapes-catalog-en-2024)：POM滑动、耐磨和加工特性。所购PP/POM/PBT的食品接触资料必须对应具体牌号，不能由材料简称推定。
'''

readme=readme.replace('## TPS5450是否比XL4016合理','''## 本次MVP选型（2026-10-17）

- **PH01改DFRobot SEN0503，50cm对射，一组收发对**。原厂3–5V，50cm是在5V下的距离，3.3V下标称20cm；本机取5V供电。外形20×10×9、线250mm、响应约2ms。国内官方商城参考15元/对（检索日2026-10-17），不是用户成交价。
- 输出原厂写NPN常开；没有完整内部输出图和本机实测，**遮挡有效电平暂记null**，不能照搬原2167的遮挡LOW。按NPN下拉接口拟定10k上拉3.3V、1k串GPIO20；先断开GPIO，测A节点两状态，确认在3.3V输入域并记录极性后再接板。若出现5V，停止接板、核查实际输出，1k不是降压器。
- **A07改YU2405，24V/5A/120W**，按用户指定为MVP主方案。厂牌、批次、插头/极性、交流入口/线是否随附、认证与保护实效尚无对应实物资料。不同卖家的同名型号不能互相替代证明，不把航嘉/明纬资料套到YU2405；不填虚构尺寸、证书或价格。5.5×2.5mm仅作P03母座候选，实际核后配。
- 不扩大工作范围：5V TPS5450整板仍待SKU，6V舵机仍为UBEC5A/6V；功率预算持续56.5W/短峰71.5W是按原负载和保守效率计算，24V容量相同所以数值不变，不等于YU2405已试载。
- 机械仍沿用V4.10，SEN0503头部外形资料更新；安装朝向/光轴、支架孔位与Z277光束仍需实物。不能仅按9mm厚度宣称光电/侧封片无干涉。
- 图6补逐线连接，图5更新主适配器和传感器标注。原Adafruit/Huntkey只留历史，不列当前主采购。

### TB端子对应

TB-A的1/2/3分别给灯、5V降压、6V UBEC正输入，各经过对应保险；3位桥只连1–2–3。4/5/6是其返回端，另一段3位桥只连4–5–6。TB-B的1=5V+、2=5V返回、3=6V+、4=6V返回、5/6空，不装桥。相邻格本来不通，同一格上下螺钉才通；不能6位整条短接。C6信号地共参考，舵机大电流仍从独立6V返回，不能经过C6板针。

## TPS5450是否比XL4016合理''')
(ROOT/'README.md').write_text(readme)

# The normal-thickness explanation is an interactive screen section, kept alongside the printable sheets.
normal='''<section class="explain"><h2>“法向”就是垂直板面</h2><svg viewBox="0 0 900 350" role="img" aria-label="板厚方向解释"><polygon points="150,70 530,260 542,236 162,46" fill="#cee4d4" stroke="#609474" stroke-width="2"/><path d="M330 160L342 136" fill="none" stroke="#9255b2" stroke-width="4"/><text x="365" y="150" font-size="23" fill="#64367f">垂直板面量：2mm</text><path d="M380 185H440" stroke="#a87a3d" stroke-width="3"/><text x="440" y="212" font-size="22" fill="#675642">水平截线量：本斗前后壁约2.18mm</text><text x="55" y="315" font-size="22" fill="#294636">买的仍是2mm PP板；板斜放后，不同方向量到的截距不同。</text></svg></section>'''
cards=''.join(f'<section class="sheet" id="page{i}"><h2>{title}</h2><div class="viewport">'+(ROOT/name).read_text()+'</div></section>' for i,(name,title) in enumerate(zip(names,['料斗怎样固定','连续前壁 / 开合演示','PBT刷盒','TPS5450 与 XL4016','电源接线候选','SEN0503与YU2405 MVP接线']),1))
page='''<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" href="data:,"><title>BeanLens V4.11 连续前壁与PBT刷盒</title><style>*{box-sizing:border-box}body{margin:0;background:#edf1e9;color:#294035;font:16px/1.65 system-ui,-apple-system,"PingFang SC",sans-serif}header,main{max-width:1600px;margin:auto;padding:25px}h1{font-size:34px;margin:10px 0}h2{font-size:23px}a{color:#187248}nav,.controls{display:flex;gap:14px;flex-wrap:wrap;align-items:center}.controls{position:sticky;top:0;z-index:5;background:#fafef6f0;padding:12px;border-bottom:1px solid #c6d8c4}button,select{font:inherit;padding:7px 12px;border:1px solid #91ab94;border-radius:6px;background:white;color:inherit}button{cursor:pointer}button:focus-visible,a:focus-visible,input:focus-visible{outline:3px solid #387995}.sheet,.explain{background:#fafbf7;border:1px solid #c8d5c4;padding:12px;margin:24px 0;border-radius:8px}.explain{max-width:1000px}.explain svg{min-width:650px}.viewport{overflow:auto}.sheet svg{display:block;width:100%;min-width:1050px}.note{padding:16px;background:#fff1d6;border-radius:8px}input{vertical-align:middle}#moving-gate{transition:transform .07s linear}footer{padding:25px}@media print{@page{size:A3 landscape;margin:0}header,.controls,h2,footer,.explain{display:none}main{padding:0}.sheet{margin:0;padding:0;border:0;break-after:page;border-radius:0}.sheet:last-child{break-after:auto}.viewport{overflow:visible}.sheet svg{width:420mm;height:297mm;min-width:0}#moving-gate{transform:none!important;transition:none}}@media(max-width:700px){header,main{padding:15px}h1{font-size:27px}.explain{overflow:auto}}</style><header><small>BEANLENS · V4.11 · 2026-10-17</small><h1>让固定方式、连续前壁和刷排都看得清楚</h1><p>本版MVP改为DFRobot SEN0503 50cm对射及YU2405 24V5A主适配器。机械沿用V4.10：前壁和两侧固定封闭，闸片从后方进出。刷排位于闸片上方的五槽入口；固定槽体改PP，POM保留可拆版本备选。</p><nav><a href="README.md">完整说明 / 采购询问模板</a><a href="../procurement-v4.11/beanlens-procurement-v4.11.html">新版BOM</a><a href="changed-cuts-v4.11.csv">改动材料尺寸CSV</a><a href="../../../output/pdf/beanlens-hopper-gate-v4.11-20261017.pdf">六页A3图册</a><a href="#normal">板厚是什么意思</a><a href="#page4">TPS5450比较</a><a href="#page6">MVP传感器接线</a></nav><p class="note">5V逻辑侧TPS5450优先审核整板；6V舵机已选UBEC5A/6V，好盈30607000为可核候选。刷盒、后退片罩和球头仍需样件联合试配；这里的名义尺寸不能代替实物承重、焊接、脱毛与电气验收。机架、9块木板、双屏和四片主斗外形保留原尺寸。</p></header><div class="controls"><label>闸片开度 <input id="gate" type="range" min="0" max="100" value="0"><output id="gateout">关闭 · 前缘Y112.5</output></label><button id="play">缓慢开关</button><label>放大 <input id="zoom" type="range" min="100" max="200" value="100" step="25"><output id="zout">100%</output></label><button id="reset">复原</button><a href="#page1">看固定</a><a href="#page2">看关闸</a><a href="#page3">看刷盒</a></div><main><div id="normal">__NORMAL__</div>__CARDS__</main><footer>原厂资料：<a href="__TI__">TI TPS5450</a> · <a href="__XL__">XL4016</a> · <a href="__UBEC__">好盈UBEC5A</a> · <a href="__POM__">Ensinger材料目录</a> · <a href="__SEN0503__">DFRobot SEN0503</a>。资料比较不等于所购整板、PP/PBT牌号已经认证或通过验收。</footer><script>const gate=document.getElementById('gate'),zoom=document.getElementById('zoom'),play=document.getElementById('play');let timer=null,dir=1;function update(){document.getElementById('moving-gate').setAttribute('transform',`translate(${Number(gate.value)*1.05} 0)`);document.getElementById('gateout').textContent=`${gate.value}% · 前缘Y${(112.5+Number(gate.value)*.15).toFixed(1)}`;document.querySelectorAll('.sheet svg').forEach(s=>s.style.width=zoom.value+'%');document.getElementById('zout').textContent=zoom.value+'%'}gate.oninput=zoom.oninput=update;function stop(){clearInterval(timer);timer=null;play.textContent='缓慢开关'}play.onclick=()=>{if(timer){stop();return}play.textContent='暂停';timer=setInterval(()=>{let v=Number(gate.value)+dir;if(v>=100||v<=0)dir*=-1;gate.value=Math.max(0,Math.min(100,v));update()},60)};document.getElementById('reset').onclick=()=>{stop();gate.value=0;zoom.value=100;update()};update();</script></html>'''.replace('__CARDS__',cards).replace('__NORMAL__',normal)
for key,value in sources.items():page=page.replace('__'+key+'__',value)
page=page.replace('<header>','<header><aside data-current-assembly="v4.12" style="padding:16px;background:#e5f1e5;color:#233c34;font:16px/1.7 system-ui"><b>最新整机装配与运作演示：V4.12。</b> <a href="../assembly-v4.12/beanlens-assembly-v4.12.html">整机组装／爆炸及12页接线图</a> · <a href="../assembly-v4.12/beanlens-operation-v4.12.html">整个运作流程动画</a>。本页保留历史参考，旧小过渡斗、双法兰和叠片不用于当前装配。</aside>',1)
(ROOT/'beanlens-hopper-gate-v4.11.html').write_text(page)
print('Generated V4.11',len(names),'sheets; brush root',brush['root_y_mm'],'tip',tip_z)
