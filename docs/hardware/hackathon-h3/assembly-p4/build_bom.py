from pathlib import Path
import csv,html,json,math
from collections import Counter
ROOT=Path(__file__).resolve().parent;H3=ROOT.parent
D=json.loads((ROOT/'assembly-data.json').read_text());rows=[]
def row(id,name,kind,spec,installed,unit='件',order=None,parent='',notes=''):
    rows.append({'id':id,'name':name,'kind':kind,'spec':spec,'installed_qty':installed,'unit':unit,'procurement_basis_qty':installed if order is None else order,'included_in':parent,'notes':notes,'unit_price_cny':''})
old={r['id']:r for r in csv.DictReader((H3/'bom-h3.csv').open(encoding='utf-8-sig'))}
for id in ['H01','H02','H03','H04','H05','H06','H07','H09','H11','H12','H21','H23','H24','H25','H26','H27','H28','H29','H36','H37']:
    r=old[id];row(id,r['name'],'采购／复用',r['model']+'；'+r['spec'],float(r['qty']) if '.' in r['qty'] else int(r['qty']),r['unit'],notes=r['notes'])
next(r for r in rows if r['id']=='H07')['notes']+=' 4段在侧PP承板内侧；卡扣不穿LED线路。'
next(r for r in rows if r['id']=='H28')['notes']+=' 机外盒单列H41，保险／开关包不重复计盒。'
next(r for r in rows if r['id']=='H36')['notes']+=' P4另有旗片孔，中心X120/Y184（原球头X110/Y184）。'
row('H08','灯带铝槽','采购／复用','U形铝槽候选14×8×100；须配同槽型安装卡扣',4,notes='槽与卡扣一起对实物；参考外形不作为未核SKU的保证。')
row('LC01','铝槽配套卡扣','采购／复用','H08同规格金属／耐温卡扣；8用＋2备',8,order=10,notes='若槽套装已含足量，扣除；孔型以实物配侧PP承板。')
row('H10','舵机加强角码','采购／复用','40×40×4、宽20；竖面两M5孔，水平两M3孔',1,notes='只保留金属加强角码；旧MG996R金属机身支架由P21替代。')
row('P27','舵机铝底板','采购／改孔','6061 60×60×3；6个φ3.4候选孔',1,notes='左前下角153/159/280.2，保留P2孔图；与加强角码先实配。')
row('H13','白PP板原料','原料采购／余料优先','PP-H 2mm 300×300一片＋PP-H 3mm 300×300一片',1,'组',notes='PP3供顶环、上下盖、68×80承托；PP2仅下短管与前U片。取消原上／下斗与相机PP载板，不与PETG热焊。')
row('H14','黑色欧标2020库存','已有／裁切','已确认460×7根、400×2根；本版用460×4、200×4、180×5',13,'段',order=0,notes='P28包含在13段中；无须新增型材。3mm锯缝排法见裁切表，余料合计453mm。')
row('P28','新增后横梁','裁切子件','黑2020长180；X20/Y220/Z298',1,order=0,parent='H14',notes='从第二根400库存切出，不另买一根180。')
row('H15','2020两孔90°角码','采购／复用','16只框架＋2只后横梁＝18用，2备',18,order=20,notes='P29已包含；M5螺钉、T螺母见K总表，不把原套装附送件再买一遍。')
row('P29','后横梁两角码','装配子件','H15中取2只标准两孔角码',2,order=0,parent='H15',notes='每只两个M5，端部支承上面298。')
row('H16','6mm海洋板原料','原料采购／复用','176×196×6原料3片，可裁W01–W05共5件',5,'成品',order=3,notes='第三片裁88＋30＋30＋3道3mm切缝＝157，余39；已有合格木料则扣库存。')
for id,name,spec in [('W01','底木板','176×196×6；底Z22；孔X60/160、Y30/210'),('W02','开孔工作木台','176×196×6；底Z180；中央60×60孔'),('W03','BOX前承板','176×88×6；X22/Y20/Z334'),('W04','前相机木横条','176×30×6；X22/Y2/Z234'),('W05','后相机木横条','176×30×6；X22/Y208/Z234')]:row(id,name,'裁切子件',spec,1,order=0,parent='H16',notes='定位孔见装配图／裁切表；不能用旧底板孔位。')
row('H17','20×20×2角铝原料','原料采购／复用','6063/6061等边角铝长1000mm；4×宽40＋16×宽20',20,'成品',order=1,notes='工作台4只宽40，相机木条4、屏板4、侧遮光4、背景4均宽20；计20道3mm切缝需540mm，1m足够。裸角铝须按连接详图钻孔，不能默认成品角码孔型相同。')
row('H39','20×2铝扁条原料','原料采购／复用','宽20厚2长500mm；8片40长＋4片12长',12,'成品',order=1,notes='顶环4、底板4平片40×20；BOX压片4为12×20。368净长＋12道3mm切缝＝404，余96；也可买孔距20的40×20平连接片8只，勿两套重复买。')
row('H19','BOX四角固定组件','装配组','4铝压片12×20×2＋4通孔20mm隔柱＋4软垫',1,'组',order=0,notes='铝片已计H39；隔柱N01、软垫N02，M3×35计K。替代旧未定孔位的80×64压框示意；不夹屏幕、不钻PCB，原壳尺寸先核。')
row('N01','BOX绝缘通孔隔柱','采购／复用','M3通孔、外径约7、长20mm；4用＋2备',4,order=6,notes='不是M3×20螺钉；固定原壳角压片与木承板间距。')
row('N02','BOX软垫','采购／复用','约1mm硅胶／EPDM片，100×20候选',4,'小片',order=1,notes='裁4片，只垫外壳角边；不遮屏、按键、接口；轻紧不压弯原壳。')
row('H20','黑PP遮光及灯槽承板','原料采购／复用','黑PP2 300×300一片；2侧196×100＋2背景110×47',4,'成品',order=1,notes='侧片两端开木条避让槽；右侧后上去64×34，后背景右上去30×16。孔与灯槽卡扣先实配。图中透明仅为看装配。')
row('H22','PWM单向缓冲板组件','装配组','SN74AHCT125N＋2N3904＋阻容与洞洞板',1,order=0,notes='采购已分H23–H27，勿再买一套重复板。接线仍用H3，无GPIO改动。')
row('H38','导向侧垫条原料','采购＋裁切','PP2余料＋PET0.3片20×100；组合10×85×2.3，两条',1,'组',notes='PP2已含H13，本行新增PET；导向条不打印、不焊死。')
for id,name,spec in [('C01','PP3顶环','176×196×3，80方孔，4斗孔＋4平片孔'),('C02','PP3下导向盖','50×85×3；18×14孔与4螺栓孔'),('C03','PP3上导向盖','50×85×3；孔与下盖重合'),('C06','PP2下短管','外22×18、内18×14、长21，外焊下盖'),('C07','PP2前U封片','前54×8.3×2，左右16×8.3×2，贴盖板外缘'),('P30','PP3后承托片','68×80×3；20×30窗及8孔')]:row(id,name,'裁切／焊接子件',spec,1,order=0,parent='H13',notes='按P4图加工；不保留原176×50大承托或上PP连接管。')
printfiles={'P11':('upper-hopper-mm','printing-p1','01-upper-hopper'),'P12':('upper-adapter-mm','printing-p1','02-adapter-and-cameras'),'P13':('lower-collector-mm','printing-p1','03-lower-collector'),'P21':('servo-cradle-mm','printing-p2','04-servo-cradle'),'P22':('camera-front-mm','printing-p2','02-adapter-and-cameras'),'P23':('camera-rear-mm','printing-p2','02-adapter-and-cameras'),'P24':('limit-closed-seat-mm','printing-p2','05-limits-and-flag'),'P25':('limit-open-seat-mm','printing-p2','05-limits-and-flag'),'P26':('gate-limit-flag-mm','printing-p2','05-limits-and-flag')}
for id,(filename,folder,job) in printfiles.items():
    p=next(p for p in D['parts'] if p['id']==id);manifest=json.loads((H3/folder/'manifest.json').read_text());m=next(r for r in manifest['parts'] if r['name']==filename)
    size='×'.join(f'{v:g}' for v in m['print_bounds_mm']);row(id,p['name'],'3D打印','Bambu PETG HF；打印包络'+size+'；任务'+job,1,order=0,notes='原文件保持；对应P3已切片文件，先试配再打主件。')
    rows[-1]['stl']='../'+folder+'/parts/'+filename+'.stl';rows[-1]['job']=job
row('H41','机外低压电气盒','采购／复用','绝缘盒200×150×80候选，带盖与防拉脱线口',1,notes='电源适配器在机外；24V分配／5V板／UBEC／缓冲固定在绝缘底板，孔距按实物。未纳入机架尺寸；不接裸交流。已有原低压盒则复用。')
row('H42','防滑脚垫','可选采购','20×20×约3自粘硅胶垫',4,order=4,notes='可贴四立柱底端；460为裸框高度，垫脚另计；图中不作承载保证。')
hw=dict(D['hardware_counts']);hw.update({'M2x5':8,'M2x8':8})
for key,qty in sorted(hw.items(),key=lambda kv:(int(kv[0][1:].split('x')[0]),int(kv[0].split('x')[1]))):
    spare=max(2,math.ceil(qty*.15));order=qty+spare
    row('K-'+key,key.replace('x','×')+'螺钉','紧固件采购',('低头内六角，配欧标槽6螺母' if key.startswith('M5') else '304圆柱／盘头，按连接面选；长度为候选'),qty,order=order,notes='按各连接图分配。下列数量为整机总需求，购买前扣除原套件内已有数量。M5先试槽不顶底；M2只适配实物孔。')
row('K-M5-T','M5欧标槽内螺母','紧固件采购','欧标2020槽6兼容M5；56+4＝60用，10备',60,order=70,notes='不能用国标槽型替代；按实际型材槽口确认。')
row('K-M5-W','M5平垫','紧固件采购','M5平垫约φ10；60用，10备',60,order=70)
row('K-M3-N','M3防松螺母','紧固件采购','79用，建议备至100',79,order=100,notes='球头套件与隔柱自带的螺母不重复计；绝缘隔柱用通孔款。')
row('K-M3-W','M3大平垫','紧固件采购','内φ3.2／外φ9；两面各一，158用',158,order=180,notes='M3穿平片φ5.5孔时必须加大垫片，不能直接用小螺母压孔。')
row('K-M2-N','M2螺母','紧固件采购','SS-01GL 4用，6备',4,order=10)
row('K-M2-W','M2平垫','紧固件采购','开关8＋相机16＝24用',24,order=40)
row('P36','相机M2内内隔柱','采购／复用','M2内内8mm，8用＋2备；PCB侧M2×5、背板侧M2×8候选',8,order=10,notes='8mm是当前镜头位置候选；核实际PCB厚、元件突出及两侧螺纹不得顶碰。')

for r in rows:r['procurement_unit']={'H16':'片原料','H17':'根（1m）','H39':'根（500mm）','H20':'片（300方）','N02':'条（100×20）'}.get(r['id'],r['unit'] if r['procurement_basis_qty'] else '不另购')
fields=['id','name','kind','spec','installed_qty','unit','procurement_basis_qty','included_in','notes','procurement_unit','unit_price_cny']
(ROOT/'bom-p4.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n')
for name,selected in [('bom-p4.csv',rows),('procurement-p4.csv',[r for r in rows if r['procurement_basis_qty']>0])]:
    with (ROOT/name).open('w',encoding='utf-8-sig',newline='') as f:
        out=csv.DictWriter(f,fieldnames=fields,extrasaction='ignore');out.writeheader();out.writerows(selected)
with (ROOT/'fasteners-p4.csv').open('w',encoding='utf-8-sig',newline='') as f:
    out=csv.DictWriter(f,fieldnames=fields,extrasaction='ignore');out.writeheader();out.writerows(r for r in rows if r['id'].startswith('K-') or r['id']=='P36')
cuts=[('H14','立柱','黑2020','460',4,'4根460整根保留'),('H14','底/顶宽梁','黑2020','180',4,'3根460各切200+180，1根400切200+180；每根计两道3mm锯缝'),('H14','底/顶深梁','黑2020','200',4,'见上一行，同槽型不混国标'),('P28','新后横梁','黑2020','180',1,'第2根400切180+3锯缝，余217；型材无需新增'),('H14','预计余料','黑2020','74×3；14×1；217×1',1,'按3mm锯缝，共余453；实物长度与锯缝先复核'),('W01','底板','海洋板6','176×196',1,'底Z22；M3孔X60/160 Y30/210'),('W02','工作台','海洋板6','176×196',1,'底Z180；60方孔左前角80/90；另开4下斗孔'),('W03','BOX面板','海洋板6','176×88',1,'前面Y20；4框架孔与4隔柱孔先核BOX实物'),('W04/W05','相机木条','海洋板6','176×30',2,'底Z234；前Y2后Y208；与88面板共用第3片原料'),('C01','顶环','PP3','176×196',1,'80方孔，底440；4打印斗孔与4平片孔'),('C02/C03','导向盖','PP3','50×85',2,'18×14孔，4螺栓孔；不焊死'),('P30','后承托','PP3','68×80',1,'20×30窗；沿用P2孔图'),('C04/C05','侧导条','PP2＋PET0.3','10×85',2,'名义组合高2.3；刀裁配隙'),('C06','下短管四片','PP2','22×21两片／14×21两片',1,'外包前后片，内18×14；实测板厚及外焊，给试配尺寸'),('C07','前U封片','PP2','54×8.3一片／16×8.3两片',1,'贴盖外缘，侧片X83/135；不是旧29高侧片'),('H17','等边角铝','铝20×20×2','宽40×4／宽20×16',20,'原料1m；计20切3mm余460；孔按连接轴向钻'),('H39','平连接片','铝扁条20×2','40×20',8,'孔距20，两孔φ5.5；M3必须φ9垫片'),('H19','BOX压片','同H39扁条','12×20',4,'共需368净长＋36锯缝＜500；M3孔居中'),('P27','舵机铝板','6061 3','60×60',1,'沿用P2六孔与安装坐标'),('SH-L','左遮光灯承板','黑PP2','196×100',1,'两端木条槽10.5×6.4；先纸样'),('SH-R','右遮光灯承板','黑PP2','196×100',1,'同左，并去后上64×34'),('BG-F','前背景','黑PP2','110×47',1,'底245、φ24孔中心110/260'),('BG-B','后背景','黑PP2','110×47',1,'同前，右上去30×16避舵机')]
with (ROOT/'cut-list-p4.csv').open('w',encoding='utf-8-sig',newline='') as f:
    out=csv.writer(f);out.writerow(['id','part','material','size_mm','qty','notes']);out.writerows(cuts)
htmlrows=''.join('<tr id="'+r['id']+'"><td><a href="beanlens-assembly-p4.html?part='+r['id']+'">'+r['id']+'</a></td><td>'+html.escape(r['name'])+'</td><td>'+r['kind']+'</td><td>'+html.escape(r['spec'])+'</td><td>'+str(r['installed_qty'])+' '+r['unit']+'</td><td>'+str(r['procurement_basis_qty'])+' '+r['procurement_unit']+'</td><td>'+html.escape(r['included_in'])+'</td><td>'+html.escape(r['notes'])+'</td></tr>' for r in rows)
(ROOT/'bom-p4.html').write_text('''<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>BeanLens H3-P4 完整BOM</title><style>body{font:14px/1.6 system-ui;color:#263e49;margin:24px}h1{font-size:25px}a{color:#17677e}table{border-collapse:collapse;width:100%;min-width:1050px}td,th{padding:9px;border:1px solid #c8d4db;vertical-align:top}th{background:#edf3f5;text-align:left;position:sticky;top:0}td:nth-child(1){white-space:nowrap}td:nth-child(4){min-width:240px}td:last-child{min-width:270px}.scroll{overflow:auto}input{font:inherit;padding:8px;width:300px;margin:15px 0}@media print{th{position:static}body{margin:0;font-size:10px}input{display:none}table{min-width:0}}</style><h1>BeanLens H3-P4 完整BOM</h1><p><a href="beanlens-assembly-p4.html">整机／爆炸／连接特写</a> · <a href="bom-p4.csv">全表CSV</a> · <a href="procurement-p4.csv">采购基准CSV</a> · <a href="fasteners-p4.csv">紧固件</a> · <a href="cut-list-p4.csv">裁切表</a></p><p>本表采用9打印件方案；原PP焊接斗、MG金属机身架、相机PP载板不再采购。价格未知留空。<b>采购基准是总需求，已有套件／余料需扣库存；0表示已有或已包含在原料／母项中。</b> 型材13段已含新增后横梁，库存7×460＋2×400足够。点击编号回装配图；原料／电气项无固定孔位时会显示说明。</p><input placeholder="输入编号、名称或规格筛选" oninput="for(const r of document.querySelectorAll('tbody tr'))r.hidden=!r.textContent.toLowerCase().includes(this.value.toLowerCase())"><div class="scroll"><table><thead><tr><th>编号</th><th>名称</th><th>处理</th><th>规格</th><th>装机用量</th><th>采购基准</th><th>已计入</th><th>安装与扣库存说明</th></tr></thead><tbody>'''+htmlrows+'''</tbody></table></div><p>螺钉长度与孔位为待实物核验候选；主机CAD检查不代表打印、承载或电气验收。P3打印件尺寸保持不变。</p></html>''')
print(json.dumps({'bom_rows':len(rows),'print_parts':sum(r['installed_qty'] for r in rows if r['kind']=='3D打印'),'M3_screw_count':sum(v for k,v in hw.items() if k.startswith('M3')),'M5_screw_count':sum(v for k,v in hw.items() if k.startswith('M5')),'cut_rows':len(cuts)},ensure_ascii=False))
