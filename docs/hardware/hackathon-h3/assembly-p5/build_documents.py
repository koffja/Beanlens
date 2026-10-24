"""Generate P5 documents from assembly-data, including consistent quantities."""
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
    if r['id']=='H01':r.update(name='K230D BOX识别／显示板',notes='P5不驱动执行器；降低到相机光轴同高度附近，原壳安装接口按实物核验。')
    if r['id']=='H02':r.update(name='左右水平相向双摄',notes='兼容BOX的两条CSI排线；20cm是用户布置目标，不是已证明的电气可用长度；先实际走线及采集测试。')
    if r['id']=='H05':r.update(spec='TPS5450成品降压板候选，24V→5.00V；BOX双摄／显示3A连续预算；整板SKU、散热及保护实测',notes='不再给PWM缓冲供电。先空载量5V，再以成品USB线给BOX；严禁24V直入USB。')
    if r['id']=='H07':r.update(notes='4段各100mm直接贴20角铝平面；灯带宽≤12mm候选、剪切点／Ra98／功率待实核。灯带线路不钻孔。')
    if r['id']=='H29':r.update(spec='0.75mm²多股铜线、压接端子；额定≥3A的5V USB成品短线；DC输入座按YU2405实物',notes='无6V支路；24V电流不走杜邦。CSI排线归H02。')
row('H28','低压配电／保险／开关','沿用DC分线、主4A、灯1A、5V降压输入1.5A保险；开关额定DC≥24V/5A；无UBEC支路',1,'套',notes='已有套件扣库存；保险须有匹配DC额定，线径与实际电流先复核。')
row('H13','白PP顶板原料','PP-H 3mm；200×180成品一片，可从300×300余料裁',1,'片',notes='200沿前后，180沿左右；不再购买闸盒PP、PET或下短管。')
row('C01','顶部承重PP板','200×180×3；80×80中孔；4法兰孔＋4平片孔',1,order=0,parent='H13',kind='加工件',notes='底Z440；左前X20/Y20，名义零边隙先试套。')
row('H14','黑色欧标2020库存','460×4＋200×4＋180×4＝12段；由7×460＋2×400库存裁',12,order=0,notes='不新增订货；P5不需要P4新增180后梁。已切好的后梁保留。')
row('H15','2020两孔90°角码','欧标2020槽6兼容；16用＋4备',16,order=20,notes='框架每角两只；不再计入P4后横梁两角码。厚度改变须重选螺长。')
row('H16','海洋板原料','6mm；原176×196两片作底板／工作台；一片176×196余料裁BOX板；另200×30两条',5,'成品',order=0,notes='按W01–W05订成品可不另购本汇总项；原第三片176×196不能直接裁出200长相机条。')
for id in ['W01','W02','W03','W04','W05']:
    p=next(p for p in D['parts'] if p['id']==id);b=p['bounds'];dims=[round(b[i+3]-b[i],2) for i in range(3)]
    row(id,p['name'],'×'.join(str(x) for x in dims)+'mm；'+p['note'],1,'片',kind='木板加工／复用',notes='按P5纸样。原板可用则扣库存；不要按旧孔强拉就位。')
angle_qty=D['angle_stock']['pieces'];row('H17','20×20×2角铝原料','6063/6061等边；总净长'+str(sum(int(k)*v for k,v in angle_qty.items()))+'mm；'+str(D['angle_stock']['raw_1m_count'])+'根1000mm候选',sum(angle_qty.values()),'裁片',order=D['angle_stock']['raw_1m_count'],notes='原料按1m根数下单；H17子件不重复采购。计每刀3mm，详见裁切表。')
rows[-1]['procurement_unit']='根（1m）'
for id,name,spec,qty in [('A-WORK','工作台角片','20×20×2、宽40',4),('A-CAM','相机条支承角片',D['camera_bracket_spec'],4),('A-BOX','BOX板侧角片','20×20×2、宽20',4),('L01','竖向灯带角铝','20×20×2、长120；100灯带直接贴平面',4),('L02','灯架脚角片','20×20×2、宽20；两翼各2孔防旋',4)]:row(id,name,spec,qty,order=0,parent='H17',kind='铝材加工')
row('H39','20×2铝扁条原料','500长；8只40长平片＋4只12长BOX压片；净368＋12刀×3＝404',12,'裁片',order=1,notes='一根500mm足够；已加工件扣库存。');rows[-1]['procurement_unit']='根（500mm）'
row('F-flat','顶／底平片','40×20×2；孔距20、φ5.5，两面φ9垫片',8,order=0,parent='H39',kind='铝材加工')
row('H19','BOX角部压片','12×20×2，中孔φ3.4，4片',4,order=0,parent='H39',kind='铝材加工')
row('N01','BOX绝缘通孔隔柱','M3通孔、长20、约外φ7',4,order=6,notes='原壳角部先核；不是在PCB上打孔。')
row('N02','BOX软垫','约1mm厚硅胶／EPDM，100×20余料',4,'小片',order=1);rows[-1]['procurement_unit']='条（100×20）'
row('L03','灯带导热背胶','约10mm宽，耐温电子用双面导热胶；4×100mm＋余量',.5,'米',notes='只贴灯带背面；接头／焊点热缩绝缘，另用扎带作线端应力释放。')
row('L04','灯线扎带／固定座','小扎带＋自粘固定座，适配线径，避开光路',8,'套',order=10)
for id in ['P11','P13','P22','P23']:
    r=OLD[id];row(id,next(p['name'] for p in D['parts'] if p['id']==id),r['spec']+'；形状不改，安装方位按P5',1,order=0,kind='3D打印',notes='已有打印件直接复用；无须重切片。P3的02盘含本版不用的P12；未打印时可在Studio仅保留两相机座后重新切片。')
for key,qty in sorted(D['hardware_counts'].items()):row('K-'+key,key.replace('x','×')+'螺钉','304低头／盘头候选；按实际板厚／槽母试配',qty,order=math.ceil(qty*1.15)+2,kind='紧固件',notes='装机数由连接图自动汇总；备件另计。M5不能顶槽底。')
nm3=sum(q for k,q in D['hardware_counts'].items() if k.startswith('M3'));nm5=sum(q for k,q in D['hardware_counts'].items() if k.startswith('M5'))
row('K-M5-T','M5槽6螺母','欧标2020槽6兼容；须与已有黑型材实配',nm5,order=math.ceil(nm5*1.15)+2,kind='紧固件')
row('K-M5-W','M5平垫','约外φ10',nm5,order=math.ceil(nm5*1.15)+2,kind='紧固件')
row('K-M3-N','M3防松螺母','各穿板接头对应一只',nm3,order=math.ceil(nm3*1.15)+2,kind='紧固件')
row('K-M3-W','M3大平垫','内φ3.2／外φ9，除8灯脚竖翼外两面各一',nm3*2-16,order=math.ceil((nm3*2-16)*1.15)+2,kind='紧固件')
row('K-M3-W7','M3常规平垫','内φ3.2／外φ7，8灯脚竖翼接头两面各一',16,order=20,kind='紧固件',notes='对应LF-*-L1/L2共8套M3×10，不能在这里用φ9大垫片叠压；木板脚仍φ9。')
row('K-M2x5','相机PCB侧M2×5','配8mm内内隔柱，螺纹不能顶碰另一端',8,order=10,kind='紧固件')
row('K-M2x8','相机座侧M2×8','配4mm打印背板＋8mm内内隔柱',8,order=10,kind='紧固件')
row('K-M2-W','M2平垫','两相机8孔，两侧螺钉各一',16,order=20,kind='紧固件')
row('P36','相机内内隔柱','M2、长8mm，8用＋2备；核PCB与镜筒突出量',8,order=10)
fields=list(rows[0]);(ROOT/'bom-p5.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n')
for name,chosen in [('bom-p5.csv',rows),('procurement-p5.csv',[r for r in rows if r['procurement_basis_qty']>0]),('fasteners-p5.csv',[r for r in rows if r['id'].startswith('K-') or r['id']=='P36'])]:
    with (ROOT/name).open('w',encoding='utf-8-sig',newline='') as f:w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(chosen)
css='body{font:14px/1.6 system-ui;color:#294552;margin:24px}h1{font-size:25px}a{color:#17677e}table{border-collapse:collapse;width:100%;font-size:13px}td,th{border:1px solid #b8cbd5;padding:8px;text-align:left;vertical-align:top}th{background:#edf3f6}input{padding:8px;width:320px;max-width:95%;margin:12px 0}.scroll{overflow:auto}.scroll table{min-width:1000px}'
tr=''.join('<tr>'+''.join('<td>'+v+'</td>' for v in [f'<a href="beanlens-assembly-p5.html?part={r["id"]}">{r["id"]}</a>',esc(r['name']),esc(r['spec']),str(r['installed_qty'])+' '+r['unit'],str(r['procurement_basis_qty'])+' '+r['procurement_unit'],r['included_in'],esc(r['notes'])])+'</tr>' for r in rows)
(ROOT/'bom-p5.html').write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>H3-P5手动版BOM</title><style>'+css+'</style><h1>H3-P5 · 人工投豆版BOM</h1><p><a href="beanlens-assembly-p5.html">交互组装／爆炸</a> · <a href="bom-p5.csv">BOM CSV</a> · <a href="procurement-p5.csv">采购CSV</a> · <a href="fasteners-p5.csv">紧固件</a> · <a href="cut-list-p5.csv">裁切表</a></p><p>本版取消舵机／闸盒及配套电气，保留4件打印件。采购基准是总量，已有库存须扣除。母项／子件不重复买，价格未知留空。</p><input placeholder="编号、名称或尺寸" oninput="for(const r of document.querySelectorAll(\'tbody tr\'))r.hidden=!r.textContent.toLowerCase().includes(this.value.toLowerCase())"><div class="scroll"><table><thead><tr><th>编号</th><th>名称</th><th>型号／尺寸</th><th>装机</th><th>采购基准</th><th>计入原料</th><th>说明</th></tr></thead><tbody>'+tr+'</tbody></table></div><p>尺寸／螺长为候选，先纸样对实物；CAD检查不等于实打、承载或电气验收。</p></html>')

# Independent manual-feed baseline: no legacy servo pins or regulator remain active.
base=copy.deepcopy(json.loads((PROJECT/'config/hardware-hackathon-h3-p4.json').read_text()))
base.update(profile='hackathon-h3-p5-manual',date='2026-10-23',status='manual_feed_design_not_physically_verified',source='docs/hardware/hackathon-h3/assembly-p5/assembly-data.json')
base['scope'].update(actuator=None,servo=False,gate=False,manual_one_bean=True)
base['pins']={k:v for k,v in base['pins'].items() if k in ['start_capture_key','stop_key','reserved_key']}
base['pins']['stop_key']['meaning']='stop acquisition permission and prompt operator; cannot stop gravity or hold a dropped bean'
base['schematic']['notes']='P5 J10 has no connected peripherals; old pin table is schematic reference only. CSI ports and actual installed runtime mapping must be verified.'
base['power']={k:v for k,v in base['power'].items() if not k.startswith('servo') and k not in ['buffer','continuous_budget_w','short_peak_budget_w']}
base['power'].update(continuous_budget_w=26.75,short_peak_budget_w=None,logic_board='TPS5450 complete board candidate; BOX+dual camera 5V3A budget; SKU unverified',notes='No 6V branch or PWM buffer. Budget: 5V*3A/0.8 + 8W LEDs; not measured consumption.')
base.pop('servo_pulse_us',None);base.pop('gate_motion',None);base.pop('timing_ms',None)
geo=base['geometry'];geo['gate']=None;geo['nozzle']=None
geo['hopper'].update(top_ring=[180,200,3],top_ring_xy=[20,20],bottom_z=329.5,neck_exit_z=329.5,upper_mount='P11 flange under PP3 top board; P12 not installed')
geo['camera']=dict(count=2,axis=D['camera_axis'],cameras=D['cameras'],station_xyz=D['station'],lens_separation_mm=D['camera_separation_mm'],csi_id_mapping=None,observation_z=[235,285])
geo['wood'].update(camera_strips=[200,30,6],camera_placements=D['camera_boards'],display_panel_z=224,stock_176x196_count=3,extra_camera_strip_count=2)
geo['wood'].pop('camera_strip_y',None)
geo['wood']['camera_strip_axis']='long200mm alongY; width30mm alongX'
base['capture']['method']='both streams ready -> operator drops one bean -> free-fall paired clear frames -> same cup -> operator waits for result'
base['capture']['failure_action']='record review_required and prompt pause before next drop; already released bean remains in common cup; no mechanical stop'
base['cameras']['capture']='both_running_before_manual_drop_falling_pair'
base['mechanical_revision']=dict(printed_parts=['P11','P13','P22','P23'],printed_geometry_changed=False,source='assembly-p5/README.md',profile_segment_count=12,camera_repositioned=True,printed_geometry_source='P1/P2 unchanged; P3 existing slices usable',top_pp_size_mm=[200,180,3],led_mount='directly bonded onto20x20x2 aluminium angle',removed=['MG996R','gate','linkage','limits','servo bracket','P12 adapter','rear beam','UBEC6V','PWM buffer'])
base['mechanical_revision']['camera_layout_confirmed']=D['camera_layout_confirmed']
base['mechanical_revision']['camera_layout_decision']=D['camera_layout_decision']
(PROJECT/'config/hardware-hackathon-h3-p5.json').write_text(json.dumps(base,ensure_ascii=False,indent=2)+'\n')
print('BOM rows',len(rows),'M3',nm3,'M5',nm5)
