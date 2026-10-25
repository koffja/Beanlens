from pathlib import Path
import json,html,ast
ROOT=Path(__file__).resolve().parent
D=json.loads((ROOT/'assembly-data.json').read_text());B=json.loads((ROOT/'bom-p7.json').read_text());pages=[]
# Reuse pure typography/stack helpers only; never execute the P4 document generator.
tree=ast.parse((ROOT.parent/'assembly-p4/build_docs.py').read_text())
functions=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['esc','table','stack','camstack']]
exec(compile(ast.Module(body=functions,type_ignores=[]),'P4_readonly_pure_helpers','exec'))
css=next(ast.literal_eval(n.value) for n in tree.body if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='css' for t in n.targets))
css+=' .sheet:nth-of-type(6) figure img{height:82mm}.wide main{display:block}.wiring{width:400mm;height:224mm;object-fit:contain} '
def fig(src,caption):return f'<figure><img src="{src}"><figcaption>{caption}</figcaption></figure>'
def sheet(title,subtitle,left,right='',wide=False):
    n=len(pages)+1;cls='sheet wide' if wide else 'sheet'
    pages.append(f'<section class="{cls}"><header><small>BEANLENS H3-P7 / 2026.10.24</small><h1>{title}</h1><p>{subtitle}</p></header><main><div>{left}</div><aside>{right}</aside></main><footer>{n:02} / 11　单位mm；主机设计检查，未实物装配／双摄验收。2漏斗打印实体沿用P1；P6/P5手动版及P4舵机版保留。</footer></section>')
def connection(id,svg='',extra=''):
    j=next(j for j in D['joints'] if j['id']==id)
    return '<h2>'+j['chain']+'</h2><div class="fast">'+'<br>'.join(j['fasteners'])+'</div><ol>'+''.join('<li>'+s+'</li>' for s in j['steps'])+'</ol>'+svg+'<p class="note">'+(j['note'] or '先对纸样和实物，螺长核板厚、垫片、螺母与槽底。')+'</p>'+extra

sheet('P7整机：相机直接粘贴，BOX上移','无相机打印底座；200×40相机木条齐框；五片遮光罩上方敞开。',fig('shots/whole.png','相机PCB保持竖直，BOX背板上沿贴近顶框下缘。')+table([('相机木条','200沿Y、40沿X、厚6，外侧X0/220齐框'),('镜头参考','X54.8/165.2，Y120，Z260；约110.4间距'),('BOX背板','176×88×6；底352顶440，前Y20'),('三块大板','240×220×6；沿用P6，底/台角口22.5'),('打印件','仅P11上斗、P13下斗，原几何不改')],['部位','位置／做法']),'<h2>五片遮光罩，取消顶盖</h2>'+fig('shots/shield-transparent.png','透明用于看内部；实物黑色PP不透明。')+'<p>黑／透明／隐藏控制真实5片罩件。取消SH-T顶盖及4只顶承角片；侧孔仍φ32，上方敞开后需重测环境光。</p><p>BOX仍显示／识别；人工一次一颗；J7供电方式保持。</p>')
sheet('整机爆炸：移除相机座与顶盖','尺寸同一比例；展开距离只用于认件，不是装配间隙。',fig('shots/exploded.png','旧版P6完整保留；本版只新增P7目录。'),table([('P11/P13','仅保留上下斗两件打印体'),('P22/P23','相机打印底座不再安装'),('GL-L1/L2/R1/R2','PCB背面下沿空白边的绝缘胶脚，名义位置'),('W04/W05','新200×40×6；旧30宽条不可加宽'),('SH-L/R/F/B/D','两侧、前后、底片；上方无盖'),('W03','BOX和背板整组上移128')],['编号','变化'])+'<p>不装相机M2螺钉／8mm隔柱、舵机／闸门／限位。原相机打印件、P3切片保留在旧版，不是删除原文件。</p>')
sheet('顶板与原上斗保持P6','顶海洋板240×220×6放在型材上面；取消的是下方遮光顶盖。',fig('shots/J05-exploded.png','W06木顶板仍安装；SH-T黑PP盖取消，二者不能混淆。')+table([('木顶板','底460顶466；不切角；中80方孔'),('锁顶框孔','X10/210，Y60/180，φ5.5'),('上斗孔','X64/156，Y74/166，φ3.4'),('上斗','法兰顶460，出口349.5；不重打')],['对象','尺寸／坐标']),connection('J05',stack([('海洋板',6,'木'),('顶框槽母',3,'型材')],'M5×12候选'))+connection('J06'))
sheet('相机直粘：200×40木条内侧边','PCB竖直放，镜头水平；旧打印座和M2隔柱全部取消。',fig('shots/J10-assembled.png','木条外边齐框，PCB底边在木面，背面两角点胶。')+table([('左木条','X0…40，Y20…220，Z234…240'),('右木条','X180…220，同Y/Z'),('PCB内面','左X40／右180，底240，参考高40'),('镜头参考间距','165.2−54.8=110.4mm，按实物重核'),('相机托片','40宽角铝全部内收；不再向外伸')],['对象','安装']),connection('J10')+'<p><a href="camera-glue-p7.svg">另见相机粘接侧视大图</a>。木面先封边、平整干燥；两镜头各距中心约55mm，先确认近焦；先试胶温度和可剥离性。胶脚只接PCB空白下沿空白边，不粘镜筒或焊盘。排线单独卸力，胶的承载与温升未实测。</p>')
sheet('灯带与工作台保持，罩侧孔重核','灯带仍直接贴20×20角铝平面；相机更近，需要重新调焦与曝光。',fig('shots/J14-assembled.png','四根120长角铝与灯架脚沿用P6。')+table([('灯角铝','20×20×2×120，Z186…306'),('灯带','四段100，Z206…306'),('底脚孔','Z194/202，φ7平垫'),('罩固定孔','回折翼Y60/180，Z250/294'),('相机光轴','Z260；镜筒穿φ32罩孔')],['对象','规格']),connection('J14',stack([('脚角片',2,'铝'),('木台',6,'木')],'脚M3×16；竖翼M3×10')))
sheet('底板与下斗承板保持P6','240×220×6，四角22.5缺口；上下豆路及下斗法兰保持。',fig('shots/J02-assembled.png','4片PP2垫片支承底板；底22顶28。')+fig('shots/J03-assembled.png','下斗承板底180顶186，角铝支承。'),table([('底板锁框','X60/160，Y10/230，φ5.5，M5×14候选'),('下斗开口','60方孔，左前80/90'),('下斗法兰孔','X73/147，Y83/157'),('两板缺口','四角22.5×22.5；先试套实物角码'),('下斗','法兰落Z186，出豆入同一杯')],['对象','做法'])+connection('J12'))
sheet('BOX背板到顶框下缘','整组上移128mm；背板底352顶440；上对托片额外下让30避开框角码。',fig('shots/J13-assembled.png','上排托片孔Z394，下排368；旧上孔需要按纸样补钻。')+table([('背板','176×88×6，前Y20；顶440'),('柱角铝孔','X30/190，Z368/394'),('BOX隔柱孔','X74/146，Z364/416'),('CSI示意折线','每路约165.3mm，不含接口／弯曲余量')],['对象','位置']),connection('J13',stack([('铝压片',2,'铝'),('隔柱',20,'PP'),('背板',6,'木')],'M3×35，沿用原壳压片'))+'<p>20cm排线不能仅凭虚线判断够长：先断电核针向、自然走线，保留松弯，再固定相机。接头不受拉力；若不够，先调整线路／兼容排线，不硬折。</p>')
sheet('五片遮光罩：上方敞开','取消SH-T顶盖及SA-T四角片，减少8套M3×10；其余罩片仍固定。',fig('shots/J15-exploded.png','两侧L/R、前后F/B、下方D；没有T顶盖。')+table([('侧片两件','152×110×2，φ32镜头孔'),('前后两件','120×110×2，上部两孔'),('底片一件','116×148×2，72方口与四角让灯架'),('支承角片','4竖角＋4底承，共8'),('总范围','X48…172，Y44…196，Z222…332')],['对象','尺寸']),connection('J15',stack([('侧PP片',2,'PP'),('角铝回翼',2,'铝')],'M3×10，避开LED'))+'<p>原侧片可保留不用的Z322孔，不需重裁；新裁按P7纸样不钻旧顶盖孔。敞口不完全遮光；固定赛场照明后重测焦点、ROI、短曝光。</p>')
sheet('整机接线：供电保持，走线随BOX上移','J7-2为5V，J7-1为GND；仅相机／BOX安装位置变化。','<img class="wiring" src="wiring-p7.svg">',wide=True)
sheet('J7逐针接法保持P6','外供绕过USB输入限流；J7与Type-C1供电二选一，实物方向先确认。','<img class="wiring" src="power-j7-p7.svg">',wide=True)
fas=[(r['name'],r['installed_qty'],r['procurement_basis_qty']) for r in B if r['id'] in ['K-M3x10','K-M3x16','K-M3x35','K-M5x8','K-M5x12','K-M5x14','K-M3-W','K-M3-W7']]
sheet('P7配料与先后顺序','BOM53行；两个漏斗不用重打，相机打印座和顶盖不再安装。',table([('型材','460×4＋200×4＋180×4，库存足够'),('海洋板','240×220三块、176×88一块、200×40两条；均厚6'),('黑PP2','400×300一片：5罩片＋4垫片'),('角铝','4×120＋8×40＋16×20＝1120净长'),('含切缝','28刀×3＝84；共1204，两根1m余796'),('紧固件','M3共64、M5共52；M3大垫112、φ7垫16'),('粘接','电子用绝缘可剥离胶候选；先试温度／空白边')],['材料','用量'])+'<h2>装配顺序</h2><ol><li>先框、三大木板、上下斗；按P7补BOX背板孔。</li><li>上移BOX背板；相机木条外侧齐框。</li><li>相机临时定位，先试排线和双图，再点胶。</li><li>装灯架和5片罩，顶部保持敞开。</li><li>调焦／曝光后手投一颗；异常记录待复核并停投。</li></ol>',table(fas,['螺钉／垫片','装机','采购基准'])+'<p>相机M2螺钉、8mm隔柱、P22/P23座不再采购。两根旧30宽木条不能加宽；旧托片可按新孔图实配改孔。</p><p>22张SVG、6页A4大板拼接纸样均须100%打印并核50mm标尺。几何／浏览器检查不等于实物粘接、排线、承载或成像验收。</p>')
(ROOT/'assembly-guide-p7.html').write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>H3-P7组装图册</title><style>'+css+'</style>'+''.join(pages)+'</html>')
print('A3 guide pages',len(pages))
