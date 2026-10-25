"""Generate P7 documents from assembly-data, including consistent quantities."""
from pathlib import Path
import json,csv,html,math,copy

ROOT=Path(__file__).resolve().parent;PROJECT=ROOT.parents[3]
D=json.loads((ROOT/'assembly-data.json').read_text());P4=ROOT.parent/'assembly-p4'
OLD={r['id']:r for r in json.loads((P4/'bom-p4.json').read_text())};rows=[]
def esc(v):return html.escape(str(v))
def row(id,name,spec,qty,unit='件',order=None,parent='',kind='采购／复用',notes=''):
    rows.append(dict(id=id,name=name,spec=spec,installed_qty=qty,unit=unit,procurement_basis_qty=qty if order is None else order,procurement_unit=unit,included_in=parent,kind=kind,notes=notes,unit_price_cny=''))
for id in ['H01','H02','H04','H05','H07','H21','H29','H41','H42']:
    r=OLD[id];row(id,r['name'],r['spec'],r['installed_qty'],r['unit'],notes=r['notes'])
for r in rows:
    if r['id']=='H01':r.update(name='K230D BOX识别／显示板',notes='P7不驱动执行器；整组上移到顶框下缘，背板底352顶440，原壳安装接口按实物核验。')
    if r['id']=='H02':r.update(name='左右水平相向双摄',notes='兼容BOX的两条CSI排线；镜头间距按参考模组约110.4mm；虚线路径约165.3mm但不含真实接头／弯曲余量；先实际走线及采集测试。')
    if r['id']=='H05':r.update(spec='TPS5450成品降压板候选，24V→5.00V；模块留≥3A能力余量；本版5V支路2A起始预算；整板SKU、散热及保护实测',notes='空载量5.00V；经5V支路2A保险到J7-2，GND到J7-1。J7与Type-C1供电二选一，跳过USB输入限流，接头与压降先实测。')
    if r['id']=='H07':r.update(notes='4段各100mm直接贴20角铝平面；灯带宽≤12mm候选、剪切点／Ra98／功率待实核。灯带线路不钻孔。')
    if r['id']=='H29':r.update(spec='24V用0.75mm²铜线；5V短线22AWG约0.34mm²、≤200mm；2.54mm 2×3带壳母接头只装1/2，端子额定需核；DC座匹配YU2405',notes='J7原理图1=GND，2=VCC_5V；其余4孔留空绝缘，不用松散单芯跳线承载供电；不是XH2.5mm或PH2.0。')
row('H28','低压配电／保险／开关','沿用DC分线、主4A、灯1A、5V降压输入1.5A、5V输出2A直流保险；开关额定DC≥24V/5A；无UBEC支路',1,'套',notes='已有套件扣库存；保险须有匹配DC额定，线径与实际电流先复核。')
row('H14','黑色欧标2020库存','460×4＋200×4＋180×4＝12段；由7×460＋2×400库存裁',12,order=0,notes='不新增订货；P7不需要P4新增180后梁。已切好的后梁保留。')
row('H15','2020两孔90°角码','欧标2020槽6兼容；16用＋4备',16,order=20,notes='框架每角两只；不再计入P4后横梁两角码。厚度改变须重选螺长。')
row('H16','6件海洋板汇总','6mm：240×220三块（顶整板，底／台各四角22.5）；176×88一块；200×40两条',6,'成品',order=0,notes='按W01–W06成品行采购／扣库存；原176×196底板和工作台不能直接加大。')
for id in ['W01','W02','W03','W04','W05','W06']:
    p=next(p for p in D['parts'] if p['id']==id);b=p['bounds'];dims=[round(b[i+3]-b[i],2) for i in range(3)]
    row(id,p['name'],'×'.join(str(x) for x in dims)+'mm；'+p['note'],1,'片',kind='木板加工／复用',notes='P7加工纸样；220沿左右X、240沿前后Y。其余小板按各自标注。')
row('H20','黑PP遮光罩原料','黑色哑光PP2，400×300一片；5罩片＋4底板支承垫片',1,'片',notes='全罩有进出豆孔和装配通风间隙，不称完全光密；模板有排版。')
row('N03','底板PP2支承垫片','40×20×2，中心φ5.5，4片',4,order=0,parent='H20',kind='黑PP加工',notes='板底Z22避开底框角码；不用裸木板压到角码竖翼。')
for id in ['SH-L','SH-R','SH-F','SH-B','SH-D']:
    p=next(p for p in D['parts'] if p['id']==id);b=p['bounds'];sz=[round(b[i+3]-b[i],2) for i in range(3)]
    row(id,p['name'],'×'.join(str(v) for v in sz)+'mm；'+p['note'],1,order=0,parent='H20',kind='黑PP加工',notes='不透明实物；透明仅看图。侧孔φ32是目标ROI候选，先核暗角与焦点。')
angle_qty=D['angle_stock']['pieces'];row('H17','20×20×2角铝原料','6063/6061等边；总净长'+str(sum(int(k)*v for k,v in angle_qty.items()))+'mm；'+str(D['angle_stock']['raw_1m_count'])+'根1000mm候选',sum(angle_qty.values()),'裁片',order=D['angle_stock']['raw_1m_count'],notes='原料按1m根数下单；H17子件不重复采购。计每刀3mm，详见裁切表。')
rows[-1]['procurement_unit']='根（1m）'
for id,name,spec,qty in [('A-WORK','工作台角片','20×20×2、宽40',4),('A-CAM','相机条支承角片',D['camera_bracket_spec'],4),('A-BOX','BOX板侧角片','20×20×2、宽20',4),('L01','竖向灯带角铝','20×20×2、长120；100灯带直接贴平面',4),('L02','灯架脚角片','20×20×2、宽20；两翼各2孔防旋',4),('S10','遮光罩角片','20×20×2、宽20：竖角4＋底承4；无顶承',8)]:row(id,name,spec,qty,order=0,parent='H17',kind='铝材加工')
row('H39','20×2铝扁条原料','100长已够：只裁4只12长BOX压片，净48＋4刀×3＝60',4,'裁片',order=1,notes='旧500mm扁条可复用；顶／底8平片不再安装。');rows[-1]['procurement_unit']='根（100mm或余料）'
row('H19','BOX角部压片','12×20×2，中孔φ3.4，4片',4,order=0,parent='H39',kind='铝材加工')
row('N01','BOX绝缘通孔隔柱','M3通孔、长20、约外φ7',4,order=6,notes='原壳角部先核；不是在PCB上打孔。')
row('N02','BOX软垫','约1mm厚硅胶／EPDM，100×20余料',4,'小片',order=1);rows[-1]['procurement_unit']='条（100×20）'
row('L03','灯带导热背胶','约10mm宽，耐温电子用双面导热胶；4×100mm＋余量',.5,'米',notes='只贴灯带背面；接头／焊点热缩绝缘，另用扎带作线端应力释放。')
row('L04','灯线扎带／固定座','小扎带＋自粘固定座，适配线径，避开光路',8,'套',order=10)
for id in ['P11','P13']:
    r=OLD[id];row(id,next(p['name'] for p in D['parts'] if p['id']==id),r['spec']+'；形状不改，安装方位按P7',1,order=0,kind='3D打印',notes='已有打印件直接复用；无须重切片。本版只用P3的00试片、01上斗和03下斗盘；02相机座/接座、04/05执行器盘均不需要。原模型和切片不改。')
for key,qty in sorted(D['hardware_counts'].items()):row('K-'+key,key.replace('x','×')+'螺钉','304低头／盘头候选；按实际板厚／槽母试配',qty,order=math.ceil(qty*1.15)+2,kind='紧固件',notes='装机数由连接图自动汇总；备件另计。M5不能顶槽底。')
nm3=sum(q for k,q in D['hardware_counts'].items() if k.startswith('M3'));nm5=sum(q for k,q in D['hardware_counts'].items() if k.startswith('M5'))
row('K-M5-T','M5槽6螺母','欧标2020槽6兼容；须与已有黑型材实配',nm5,order=math.ceil(nm5*1.15)+2,kind='紧固件')
row('K-M5-W','M5平垫','约外φ10',nm5,order=math.ceil(nm5*1.15)+2,kind='紧固件')
row('K-M3-N','M3防松螺母','各穿板接头对应一只',nm3,order=math.ceil(nm3*1.15)+2,kind='紧固件')
row('K-M3-W','M3大平垫','内φ3.2／外φ9，除8灯脚竖翼外两面各一',nm3*2-16,order=math.ceil((nm3*2-16)*1.15)+2,kind='紧固件')
row('K-M3-W7','M3常规平垫','内φ3.2／外φ7，8灯脚竖翼接头两面各一',16,order=20,kind='紧固件',notes='对应LF-*-L1/L2共8套M3×10，不能在这里用φ9大垫片叠压；木板脚仍φ9。')
row('C01','相机可剥离绝缘固定胶','电子装配用非导电低温热熔胶，透明／半透明，胶枪规格匹配；不使用导电胶或酸性胶',1,'条',order=2,notes='两相机各2个背面下沿空白边胶脚；先在废板试温度、剥离和粘接。PCB空白边不足时先换固定点，不盖焊盘、连接器和镜筒。胶脚为位置示意，强度待实物试验。')
fields=list(rows[0]);(ROOT/'bom-p7.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n')
for name,chosen in [('bom-p7.csv',rows),('procurement-p7.csv',[r for r in rows if r['procurement_basis_qty']>0]),('fasteners-p7.csv',[r for r in rows if r['id'].startswith('K-') or r['id']=='P36'])]:
    with (ROOT/name).open('w',encoding='utf-8-sig',newline='') as f:w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(chosen)
css='body{font:14px/1.6 system-ui;color:#294552;margin:24px}h1{font-size:25px}a{color:#17677e}table{border-collapse:collapse;width:100%;font-size:13px}td,th{border:1px solid #b8cbd5;padding:8px;text-align:left;vertical-align:top}th{background:#edf3f6}input{padding:8px;width:320px;max-width:95%;margin:12px 0}.scroll{overflow:auto}.scroll table{min-width:1000px}'
tr=''.join('<tr>'+''.join('<td>'+v+'</td>' for v in [f'<a href="beanlens-assembly-p7.html?part={r["id"]}">{r["id"]}</a>',esc(r['name']),esc(r['spec']),str(r['installed_qty'])+' '+r['unit'],str(r['procurement_basis_qty'])+' '+r['procurement_unit'],r['included_in'],esc(r['notes'])])+'</tr>' for r in rows)
(ROOT/'bom-p7.html').write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>H3-P7手动版BOM</title><style>'+css+'</style><h1>H3-P7 · 人工投豆版BOM</h1><p><a href="beanlens-assembly-p7.html">交互组装／爆炸</a> · <a href="bom-p7.csv">BOM CSV</a> · <a href="procurement-p7.csv">采购CSV</a> · <a href="fasteners-p7.csv">紧固件</a> · <a href="cut-list-p7.csv">裁切表</a></p><p>本版取消舵机／闸盒及配套电气，只保留上下斗2件打印件，相机改直接粘木板，取消遮光顶盖。采购基准是总量，已有库存须扣除。母项／子件不重复买，价格未知留空。</p><input placeholder="编号、名称或尺寸" oninput="for(const r of document.querySelectorAll(\'tbody tr\'))r.hidden=!r.textContent.toLowerCase().includes(this.value.toLowerCase())"><div class="scroll"><table><thead><tr><th>编号</th><th>名称</th><th>型号／尺寸</th><th>装机</th><th>采购基准</th><th>计入原料</th><th>说明</th></tr></thead><tbody>'+tr+'</tbody></table></div><p>尺寸／螺长为候选，先纸样对实物；CAD检查不等于实打、承载或电气验收。</p></html>')

# Independent manual-feed baseline: no legacy servo pins or regulator remain active.
base=copy.deepcopy(json.loads((PROJECT/'config/hardware-hackathon-h3-p4.json').read_text()))
base.update(profile='hackathon-h3-p7-manual',date='2026-10-24',status='manual_feed_design_not_physically_verified',source='docs/hardware/hackathon-h3/assembly-p7/assembly-data.json')
base['scope'].update(actuator=None,servo=False,gate=False,manual_one_bean=True)
base['pins']={k:v for k,v in base['pins'].items() if k in ['start_capture_key','stop_key','reserved_key']}
base['pins']['stop_key']['meaning']='stop acquisition permission and prompt operator; cannot stop gravity or hold a dropped bean'
base['schematic']['notes']='P7 J10 has no connected peripherals; old pin table is schematic reference only. CSI ports and actual installed runtime mapping must be verified.'
base['power']={k:v for k,v in base['power'].items() if not k.startswith('servo') and k not in ['buffer','continuous_budget_w','short_peak_budget_w']}
base['power']['logic_budget_a']=2
base['power'].update(continuous_budget_w=20.5,short_peak_budget_w=None,logic_board='TPS5450 complete board candidate; BOX+dual camera 5V2A initial branch budget, module>=3A capability candidate; SKU unverified',notes='No 6V branch or PWM buffer. Budget: 5V*2A/0.8 + 8W LEDs; not measured consumption.')
base['power']['logic_connection']={'connector':'J7 2x3 header,2.54mm','pin_1':'GND','pin_2':'VCC_5V input5.00V','pins_3_6':'unused,insulate','output_fuse_a':2,'wire':'22AWG short<=200mm, contact rating and actual peak pending','schematic_verified':True,'physically_verified':False,'dual_supply_forbidden':'disconnect J7 supply before Type-C1 supply; Type-C2 does not supply power','bypasses':'USB1 VBUS -> U5 MT9700 input current-limit path'}
base.pop('servo_pulse_us' ,None);base.pop('gate_motion',None);base.pop('timing_ms',None)
geo=base['geometry'];geo['gate']=None;geo['nozzle']=None
geo['hopper'].update(top_ring=[220,240,6],top_ring_xy=[0,0],top_ring_z=460,top_z=460,bottom_z=349.5,neck_exit_z=349.5,upper_mount='P11 flange under marine plywood6, top frame above; translated20mm; P12 not installed')
geo['camera']=dict(count=2,axis=D['camera_axis'],cameras=D['cameras'],station_xyz=D['station'],lens_separation_mm=D['camera_separation_mm'],csi_id_mapping=None,observation_z=[235,285])
geo['wood'].update(camera_strips=[200,40,6],camera_placements=D['camera_boards'],display_panel_z=352,stock_176x196_count=0,extra_camera_strip_count=2,decks=[220,240,6],top_board=[220,240,6],top_board_z=460,corner_notch=22.5,large_board_count=3,small_panel_count=3)
geo['wood'].pop('camera_strip_y',None)
geo['wood']['camera_strip_axis']='long200mm alongY; width40mm alongX; outer edges X0/220 flush to frame'
base['capture']['method']='both streams ready -> operator drops one bean -> free-fall paired clear frames -> same cup -> operator waits for result'
base['capture']['failure_action']='record review_required and prompt pause before next drop; already released bean remains in common cup; no mechanical stop'
base['cameras']['capture']='both_running_before_manual_drop_falling_pair'
base['mechanical_revision']=dict(printed_parts=['P11','P13'],printed_geometry_changed=False,source='assembly-p7/README.md',profile_segment_count=12,camera_repositioned=True,printed_geometry_source='P1/P2 unchanged; P3 existing slices usable',top_plywood_size_mm=[240,220,6],shield_panels=5,led_mount='directly bonded onto20x20x2 aluminium angle',removed=['MG996R','gate','linkage','limits','servo bracket','P12 adapter','rear beam','UBEC6V','PWM buffer'])
geo['shield']={'material':'matte black PP2','side_size':[152,110],'open_top':True,'front_back_size':[120,110],'roof_size':None,'floor_size':[116,148],'lens_hole_d':32,'roof_entry':None,'floor_opening':[72,72],'z_range':[222,332]}
base['schematic']['j7']={'1':'GND','2':'VCC_5V','3':'SPK-','4':'SPK+','5':'ADC_1','6':'ADC_0'}
base['mechanical_revision']['camera_layout_confirmed']=D['camera_layout_confirmed']
base['mechanical_revision'].update(camera_mount='direct vertical PCB adhesive fillets on inner wood edge; no printed mount or M2 standoffs',box_board_z=[352,440],box_upper_support_shift_z=-30,removed_since_p6=['P22','P23','M2 camera hardware','SH-T','four roof support angles'])
geo['wood'].update(display_panel_top_z=440,display_post_hole_z=[368,394])
base['mechanical_revision']['camera_layout_decision']=D['camera_layout_decision']
(PROJECT/'config/hardware-hackathon-h3-p7.json').write_text(json.dumps(base,ensure_ascii=False,indent=2)+'\n')
print('BOM rows',len(rows),'M3',nm3,'M5',nm5)
