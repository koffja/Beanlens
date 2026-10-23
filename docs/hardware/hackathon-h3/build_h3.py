"""Build independent H3 design records; H1/H2/full-version sources remain intact."""
import copy, csv, html, json, math, re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
PROJECT = ROOT.parents[2]
H1 = ROOT.parent / 'hackathon-h1'
data = copy.deepcopy(json.loads((H1/'design-h1.json').read_text()))
data.update(revision='H3', date='2026-10-21', status='top_feed_horizontal_dual_camera_proposal_not_hardware_validated')
data['scope'].update(camera_count=2, stationary_photo=False, falling_capture=True, dual_camera_pairing=True)
closed_deg = -40.706341765388494
def linkage(deg):
    a=math.radians(deg)
    p=[170-16*math.cos(a),180+16*math.sin(a),337.5]
    q=[110,p[1]+math.sqrt(50**2-(p[0]-110)**2),337.5]
    return p,q
stroke=linkage(0)[1][1]-184
data['geometry']={
 'frame':[220,240,460], 'coordinate':'X left-right / Y front-rear / Z up; all mm',
 'platforms_z':[20,180],
 'hopper':{'inner_top':[80,80],'inner_bottom':[18,14],'center_xy':[110,120],'top_z':440,'bottom_z':350,'wall':2,'top_ring':[176,196,3],'top_ring_xy':[22,22],'top_ring_z':440},
 'gate':{'blank':[29.4,82,2],'material':'6061-T6 deburred aluminum','closed_front_y':108,'open_front_y':108+stroke,'x_range':[95.3,124.7],'z_range':[324,326],'hole_xy':[101,113],'hole_wh':[18,14],
         'covers':{'xy':[85,95],'size':[50,85,3],'lower_z':321,'upper_z':326.3},
         'spacers':{'count':2,'size':[10,85,2.3],'stack':'PP2 + PET0.3; bolted, not welded together','x':[85,125]},
         'stroke':stroke,'side_clearance_each':0.3,'vertical_total_clearance':0.3,'fixed_front_y_range':[93,95],
         'pivot':[170,180,331],'ball_plane_z':337.5,'horn_radius':16,'rod_ball_centers':50,'rod_count':1,'ball_head_count':2,'horn_count':1,'rail_count':0,
         'theta_closed_deg':closed_deg,'theta_open_deg':0,'gate_ball_closed_xyz':[110,184,337.5],'gate_ball_open_xyz':linkage(0)[1],
         'geometry_only_no_pwm_pulse_calibration':True},
 'nozzle':{'inner':[18,14],'z_range':[300,321],'wall':2},
 'camera':{'count':2,'axis':'horizontal_opposed_front_rear','front_lens_xyz':[110,30,260],'rear_lens_xyz':[110,210,260],'station_xyz':[110,120,260],'directions':[[0,1,0],[0,-1,0]],'working_distance_proposal_mm':90,'observation_z':[235,285],'support_in_beam':False,'csi_id_mapping':None},
 'collector':{'inner_top':[64,64],'inner_bottom':[30,30],'top_z':220,'bottom_z':160,'wall':2,'center_xy':[110,120]},
 'work_aperture':{'xy':[80,90],'wh':[60,60],'relative_to_176x196_platform':[58,68]},
 'wood':{'decks':[176,196,6],'deck_count':2,'display_panel':[176,88,6],'camera_strips':[176,30,6],'camera_strip_count':2,'camera_strip_z':234,'camera_strip_y':[2,208],'stock_176x196_count':3},
 'cup':{'xyz':[60,95,26],'size':[100,100,80]}}
data['capture']={'method':'both streams running before release; bounded ROIs; one manually introduced bean per cycle','hardware_sync_claim':False,'stationary_capture':False,'one_pair_one_count':True,'frame_rate_measured':None,'exposure_us_measured':None,'time_pair_tolerance_ms':None,'reject_if':['missing_view','blur','multiple_beans','uncertain_pair'],'roi_queue_example':{'per_camera_max':3,'max_wh':[320,320],'rgb_bytes_total':2*3*320*320*3,'actual_runtime_memory_validated':False}}
data['ideal_fall_estimate']={'assumptions':'zero initial speed, no friction or collision, not measured','gate_surface_z':326,'station_z':260,'speed_mm_s':math.sqrt(2*9810*66),'observation_band_ms':1000*(math.sqrt(2*91/9810)-math.sqrt(2*41/9810)),'max_exposure_for_0_2mm_blur_us':.2/math.sqrt(2*9810*66)*1e6,'trial_exposure_us':[100,200],'animation_fall_slowdown':12}
updates={
 'H02':dict(name='水平相向双摄',qty=2,spec='GC2093-M12-90度无畸变，两只完整模组＋兼容BOX排线',notes='前镜头(110,30,260)向后；后镜头(110,210,260)向前，各约90mm工作距起试。两CSI映射、近焦/像素密度与短曝光待实机核验。'),
 'H03':dict(notes='位置版，独立6V。机身固定，轴目标(170,180,331)；只推拉轻闸片，不能用标称扭矩证明不卡豆。'),
 'H05':dict(spec='24V→5.00V成品板；BOX双摄＋缓冲，3A连续预算待验'),
 'H07':dict(qty=4,spec='4段各100mm有效长，合计0.4m；≤8W预算',notes='两面各两条，侧向常亮；先核实际剪切点。100–200µs仅曝光试验起点，亮度是否够必须实拍。'),
 'H08':dict(qty=4,spec='配实际灯带PCB宽；候选外14×8×100mm，4条'),
 'H09':dict(notes='两只检测闸片尾部旗片，闭位/开位分别确认；装在豆路之外。座位、触发余量按实物调；不可只检测舵臂角度。'),
 'H10':dict(model='MG996R金属固定架＋6061 60×60×3毛坯＋2020加强角码',spec='右后立柱悬臂固定；角码候选40×40×4、宽20，两孔固定；轴(170,180,331)',notes='转接板目标Z280.2–283.2，固定架抬到安装耳约Z320。加强角码一侧用两颗M5/T螺母固定右后立柱，一侧托铝板；另配M3连接件。非最终钻孔图，先量舵机偏轴/支架。'),
 'H11':dict(notes='只有一只25T直臂，使用R16孔接连杆球头；不是双舵臂。中心螺钉用舵机原配，孔径M3优先；几何角度不等于PWM标定。'),
 'H12':dict(name='闸片球头垫高件',model='M3×8六角隔柱＋M3球头螺柱/垫片',spec='1套；使闸片球心与舵臂球心同高，名义Z337.5',notes='8mm隔柱是候选，须扣除实际球头中心高度后配垫。球心共面后再连接，禁止靠拧紧掰弯连杆。球头本体计H37，不重复买。'),
 'H13':dict(name='上下PP豆路与导向板材',model='PP-H 2mm 300×300一片＋PP-H 3mm 300×300一片',qty=1,unit='组',spec='PP2做上斗/短管/下斗；PP3做顶环、导向盖、后支承片176×50、相机载板；导向条PP2+PET0.3',notes='H38/H39/H40为加工子件，PP板在本项统一购买。漏斗外侧焊、内部修平；导向区用螺栓拆装，不把铝闸片焊死。先纸样与试焊；斜面给毛坯而非已补偿焊接的CNC尺寸。'),
 'H16':dict(qty=5,name='木平台/相机横条/BOX面板',spec='176×196×6两片；176×88×6一片；176×30×6两条',notes='共5成品，由原3片176×196×6裁出；第三片切88+30+30，留锯缝余量。工作板60×60孔全局X80/Y90；不再装Z344整层相机板，以免挡豆路。'),
 'H17':dict(spec='底/工作板8点＋相机横条4点=12用，16套购含4备',notes='底面Z20/180；相机横条Z234–240；BOX固定框H19另计。不可把屏面板装入漏斗内部。'),
 'H18':dict(name='前相机可调安装',spec='前镜头(110,30,260)，水平向后；1套',notes='角铝/PP3载板/4只M2隔柱承重，固定到前木横条；不靠排线承重。实际孔距和镜头突出量收到后定。'),
 'H19':dict(notes='BOX原壳固定前面176×88×6承板，Z334–422；背后与料斗外壁最小约60mm名义净空（不含线缆），按实物核接口与弯曲半径。'),
 'H20':dict(spec='侧遮光片＋前/后带镜头孔背景片；黑PP2 300×300候选',notes='不能保留H1封死后摄光路的整后片。镜头孔φ24起试，中心Z260/X110；侧片不可侵入拍摄窗，亮度/反光再实配。'),
 'H21':dict(notes='下斗直落同一普通杯，所有分类都进同一杯；无称重、无分选。杯位置可调，使中心落点(110,120)在杯内。'),
 'H30':dict(spec='M3×16盖板连接4套、M3连接/防松件；M2相机隔柱与螺钉各8套',notes='H37球头和H12隔柱不重复计。盖板螺栓在X90/130，Y105/165外侧，避开闸片轨道。螺钉长度按实际垫片/螺母复核。')}
for b in data['bom']:
 if b['id'] in updates:b.update(updates[b['id']])
def add(id,name,model,spec,qty,unit,notes):
 data['bom'].append(dict(id=id,name=name,model=model,spec=spec,qty=qty,unit=unit,notes=notes,status='新增/改制，待实配',full_bom=None,unit_price_cny=None))
add('H34','后相机可调安装','30×30×2角铝长40＋PP3 60×60载板＋M2隔柱','后镜头(110,210,260)，水平向前；1套',1,'套','角铝/M2件增加第二套；PP3板料计H13。后横条承重，后摄与前摄独立调焦。')
add('H36','单槽铝闸片','6061-T6 29.4×82×2mm','两面平整、倒钝去毛刺；球头孔中心距前缘76mm，横向居中',1,'片','先裁毛坯试配；M3孔径按连接件，正式孔待球头确认。关闭前缘Y108，打开前缘127.749，行程19.749。不要带豆强关。')
add('H37','双球头短连杆','RC模型M3球头连杆，球心距50mm，可调约±3mm','1根杆＋2颗球头；M3连接螺柱/孔；要求卖家注明球心距',1,'套','淘宝搜索：M3 球头连杆 球心距50mm。不是50mm裸螺杆；不接受球心距不明的套件。无已验证专属SKU，收到量中心距后重算端点。')
add('H38','简易导向间隔条','H13 PP2余料＋PET0.3mm垫片','10×85×2.3两条；PET可买20×100×0.3mm',1,'套','PP2已计H13；仅新增PET片。上下PP3盖板50×85，槽高2.3容纳2mm闸片。PET不与PP焊，固定区螺栓夹紧。')
add('H39','顶斗承重环/角片','H13 PP3顶环＋25×25×2角铝宽20mm','顶环176×196×3，开80×80口；顶环4只＋闸盒后支承2只使用，另2只备用',8,'只角片','PP顶环不重复购。8只角片配M5螺钉/T螺母16套、M3连接件8套（含备用），螺长实配；角片锁到顶部2020，再托住顶环；PP斗外缘焊到环口，载荷走顶环/角片/框架。仅单颗人工投豆，不宣称1kg验证。')
add('H40','下接豆斗加工','H13 PP2板材子件','内顶64×64/Z220；内底30×30/Z160；高60',1,'套','不另买PP板；经工作台60×60孔穿过，用4只PP外焊小耳与M3固定。观察区下缘235距斗上口15mm，镜头中心260不被斗沿遮挡。')
data['sources'].update(box='https://wiki.alientek.com/docs/Boards/Kendryte/DNK230D/start-guide/k230d-box-introduction/',exposure_version='https://www.kendryte.com/answer/questions/10010000000012329')
data['power_budget']={'logic_5v_a':3,'servo_6v_continuous_a':3,'servo_6v_peak_a':5,'led_w':8,'conversion_efficiency_budget':0.8,'continuous_input_w':49.25,'short_peak_input_w':64.25,'measured':False}
(ROOT/'design-h3.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')
cfg=copy.deepcopy(json.loads((PROJECT/'config/hardware-hackathon-h1.json').read_text()))
cfg.update(profile='hackathon-h3',date='2026-10-21',status='top_feed_horizontal_dual_camera_proposal_pending_board_and_fall_tests',source='docs/hardware/hackathon-h3/design-h3.json')
cfg['scope']=data['scope'];cfg['geometry']=data['geometry'];cfg['capture']=data['capture']
cfg['power'].update(led_budget_w=8,continuous_budget_w=49.25,short_peak_budget_w=64.25)
cfg['cameras']={'count':2,'model':'GC2093-M12-90deg user supplied','physical_ports':['BOX CSI1','BOX CSI2'],'sensor_id_mapping':None,'capture':'both_running_before_gate_release_falling_pair','short_exposure_supported_on_installed_BOX_firmware':None,'board_dual_capture_validated':False,'installed_firmware_version':None}
cfg['gate_motion']=data['geometry']['gate'];cfg['no_firmware_modified']=True
cfg['servo_pulse_us']['reason']='H3 geometry -40.706/0 is not PWM calibration; empty mechanism endpoints pending'
cfg['timing_ms'].pop('settle',None)
cfg['timing_ms']['reason']='streams ready before release; match frame freshness and calibrate actual timeouts; not animation timing'
(PROJECT/'config/hardware-hackathon-h3.json').write_text(json.dumps(cfg,ensure_ascii=False,indent=2)+'\n')
cols=['id','name','model','spec','qty','unit','notes','status','full_bom','unit_price_cny']
with (ROOT/'bom-h3.csv').open('w',newline='',encoding='utf-8-sig') as f:
 w=csv.DictWriter(f,fieldnames=cols);w.writeheader();w.writerows(data['bom'])
rows=[]
def cut(id,part,material,size,qty,note):rows.append(dict(id=id,part=part,material=material,size_mm=size,qty=qty,note=note))
cut('H14','立柱','黑2020','460',4,'7根460中的4根不切')
cut('H14','宽梁','黑2020','180',4,'3根460各取200+180；1根400取200+180，留锯缝')
cut('H14','深梁','黑2020','200',4,'另一根400整根备用；无需新订型材')
cut('H16','底/工作台','海洋板6','176×196',2,'工作台开60×60孔，相对板左前角58/68')
cut('H16','BOX前承板','海洋板6','176×88',1,'第三片176×196裁出；竖装，不深入料斗')
cut('H16','相机横条','海洋板6','176×30',2,'与88板从第三片裁，三道3mm锯缝计157<196')
cut('H13/H39','顶环','PP3','176×196',1,'孔80×80，相对左前角48/58；底Z440')
cut('H13','闸盒后承托片','PP3','176×50',1,'全局X22/Y165/Z318，后立柱两端角片承托；前15mm托住闸盒后段')
cut('H13','导向盖','PP3','50×85',2,'孔18×14，相对左前角16/18；上下孔重合')
cut('H13/H38','间隔条','PP2+PET0.3','10×85',2,'组合厚2.3；PP/PET不焊')
cut('H36','铝闸片','6061-T6 2','29.4×82',1,'球头孔中心：横中14.7，距前缘76；去毛刺')
cut('H13','上斗侧壁毛坯','PP2','100×100',4,'内表面理论前后梯形80/18/斜高95.86，左右80/14/95.19；毛坯须纸样补角缝，不能按理论线直接裁终件')
cut('H13','下斗侧壁毛坯','PP2','75×70',4,'内表面理论梯形64/30/斜高62.36；留外焊与包边修配余量')
cut('H13','短管/前封板/固定耳','PP2余料','按剖面实配',1,'18×14内孔；上管Z329.3–350，下管Z300–321；外封前壁Y93–95')
cut('H18/H34','相机载板毛坯','PP3','60×60',2,'镜头/PCB开孔按模组，不能用占位40方推孔距')
with (ROOT/'cut-list-h3.csv').open('w',newline='',encoding='utf-8-sig') as f:
 w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
def table_page(title,items):
 head=''.join('<th>'+html.escape(x)+'</th>' for x in ['编号','物料','型号 / 规格','数量','说明'])
 body=''.join('<tr><td>'+html.escape(b['id'])+'</td><td>'+html.escape(b['name'])+'</td><td>'+html.escape(b['model']+'；'+b['spec'])+'</td><td>'+str(b['qty'])+html.escape(b['unit'])+'</td><td>'+html.escape(b['notes'])+'</td></tr>' for b in items)
 return '<!doctype html><meta charset="utf-8"><title>'+title+'</title><style>body{font:15px/1.65 system-ui;margin:32px;color:#233740}table{border-collapse:collapse;width:100%}td,th{border:1px solid #cad6da;padding:10px;text-align:left;vertical-align:top}th{background:#e9f0f2}a{color:#16718a}@media print{body{margin:0;font-size:10px}tr{break-inside:avoid}}</style><h1>'+title+'</h1><p>顶入豆 / 单槽抽拉闸 / 水平双摄 / 人工单颗；尺寸为试制候选，未实物验收。36组采购项含加工子件，子件板材不重复购。<a href="beanlens-realistic-h3.html">运行与拆解动画</a> · <a href="wiring-h3.svg">接线图</a> · <a href="side-section-h3.svg">剖面图</a></p><table><thead><tr>'+head+'</tr></thead><tbody>'+body+'</tbody></table>'
(ROOT/'bom-h3.html').write_text(table_page('BeanLens H3 采购与加工表',data['bom']))
delta=[b for b in data['bom'] if b['id'] in updates or b['id'] in ['H34','H36','H37','H38','H39','H40']]
(ROOT/'bom-delta-h3.html').write_text(table_page('H3 相对H1的采购 / 改制差异',delta))
print(f'H3: {len(data["bom"])} BOM groups; gate stroke={stroke:.6f}mm')
