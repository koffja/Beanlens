from pathlib import Path
import json,html,ast
ROOT=Path(__file__).resolve().parent
D=json.loads((ROOT/'assembly-data.json').read_text());B=json.loads((ROOT/'bom-p6.json').read_text());pages=[]
# Reuse pure typography/stack helpers only; never execute the P4 document generator.
tree=ast.parse((ROOT.parent/'assembly-p4/build_docs.py').read_text())
functions=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['esc','table','stack','camstack']]
exec(compile(ast.Module(body=functions,type_ignores=[]),'P4_readonly_pure_helpers','exec'))
css=next(ast.literal_eval(n.value) for n in tree.body if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='css' for t in n.targets))
css+=' .sheet:nth-of-type(6) figure img{height:82mm}.wide main{display:block}.wiring{width:400mm;height:224mm;object-fit:contain} '
def fig(src,caption):return f'<figure><img src="{src}"><figcaption>{caption}</figcaption></figure>'
def sheet(title,subtitle,left,right='',wide=False):
    n=len(pages)+1;cls='sheet wide' if wide else 'sheet'
    pages.append(f'<section class="{cls}"><header><small>BEANLENS H3-P6 / 2026.10.24</small><h1>{title}</h1><p>{subtitle}</p></header><main><div>{left}</div><aside>{right}</aside></main><footer>{n:02} / 11　单位mm；主机设计检查，未实物装配／双摄验收。4打印实体沿用P1/P2；P5手动版与P4舵机版保留。</footer></section>')
def connection(id,svg='',extra=''):
    j=next(j for j in D['joints'] if j['id']==id)
    return '<h2>'+j['chain']+'</h2><div class="fast">'+'<br>'.join(j['fasteners'])+'</div><ol>'+''.join('<li>'+s+'</li>' for s in j['steps'])+'</ol>'+svg+'<p class="note">'+(j['note'] or '先对纸样和实物，螺长核板厚、垫片、螺母与槽底。')+'</p>'+extra

sheet('P6整机：顶盖、嵌角木板和遮光罩','顶／底／下斗承板均240×220；六片遮光罩真实装入，左右相机间距200。',fig('shots/whole.png','黑色为实际遮光罩；可在交互图改透明或隐藏。')+table([('顶盖','220×240×6，不切角；底460顶466'),('底板','220×240×6，四角22.5；底22顶28'),('下斗承板','220×240×6，四角22.5；底180'),('两镜头','X10/210、Y120、Z260'),('原上斗','形状不改，整体上移20；出口349.5')],['部位','同一坐标下的位置']),'<h2>新版与实物一致的三种显示</h2>'+fig('shots/shield-transparent.png','透明看内部；这是演示状态，实物PP不透明。')+'<p>“隐藏”移除6片模型；“黑色实物”恢复不透明。J15单独看遮光罩怎样固定。</p><p>人工单颗，无闸门／舵机。配套电气改J7-2接5V、J7-1接GND，实际针向与供电先核。</p>')
sheet('整机爆炸：木板与罩片不再悬空','4原打印件保留；6木板、6黑PP罩片、金属托片、型材都有明确连接。',fig('shots/exploded.png','爆炸外移仅认件，尺寸没有缩放。'),table([('P11','上斗，随顶板上移20，不重打'),('P13','下斗，法兰仍坐Z186'),('P22／P23','右／左相机座转90°，不重打'),('W06','整顶板直锁顶框'),('W01／W02','角缺口避柱，垫片／角片支承'),('SH-L/R/F/B/T/D','六片黑PP组成遮光罩')],['编号','装配作用'])+'<p>不安装P12接座、舵机／连杆／闸盒／限位、后横梁。P3旧切片继续按对应机型使用，不修改已切G-code。</p><p>原P5资料完整保留；新增2mm底板垫片与罩角片，不沿用旧PP顶板、顶底平片孔图。</p>')
sheet('顶板：240×220海洋板放在框架上方','整顶板底Z460、顶466；原上斗整体上移20mm。',fig('shots/J05-exploded.png','J05：M5穿6mm木板进入顶框上槽，取消旧下托平片。')+table([('顶板外形','220沿X、240沿Y；厚6；不切角'),('中孔','80×80，左前70/80'),('木板锁框孔','X10/210，Y60/180，φ5.5'),('斗法兰孔','X64/156，Y74/166，φ3.4')],['对象','尺寸／全局坐标']),connection('J05',stack([('海洋板',6,'木'),('顶框槽母',3,'型材')],'M5×12候选，先试槽深'))+'<h2>上斗仍用原打印件</h2><p>法兰贴木板下方Z460；M3×16穿木6＋法兰4，四套。形状不变，只上移20；出口从329.5变349.5。实际落豆、短曝光与收集仍需重验。</p>')
sheet('左右相机：200mm间距保持','两条200×30木条及原打印座保持，遮光侧片增加φ32镜头孔。',fig('shots/J10-exploded.png','P22装右、P23装左，PCB不夹镜筒。')+table([('镜头中心','X10／210，Y120，Z260'),('右／左相机条','X208／−18、Y20、Z234'),('木条尺寸','30沿X、200沿Y、厚6'),('镜头孔','罩两侧X48／170，Y120/Z260，φ32')],['对象','候选位置']),connection('J10',camstack())+'<p>模型中心及目标区域四角光线已检查。φ32孔会限制部分全画幅；实际ROI、焦点、暗角与双图配对仍要实测，不宣称全视场或硬同步。</p>')
sheet('灯带直接上角铝，罩片锁另一翼','右侧角铝回折翼朝外；新增罩片孔不穿LED线路。',fig('shots/J14-assembled.png','灯架仍先锁工作台；遮光片拆开时可看两翼方向。')+table([('竖角铝','20×20×2长120，底186顶306'),('灯带','4×100，贴Z206…306'),('底部耳孔','Z194/202，φ7平垫'),('罩片回折翼孔','Y60/180，Z250/294'),('木台8灯脚孔','X55/65/155/165，Y40/200')],['对象','尺寸／孔位']),connection('J14',stack([('脚角片',2,'铝'),('木台',6,'木')],'脚M3×16，竖翼M3×10'))+'<p>遮光片固定在角铝回折翼，主翼粘灯带。首件检查温升、眩光与短曝光；焊点绝缘，线端固定，不靠背胶承拉力。</p>')
sheet('嵌角底板与下斗承板：为什么切22.5','20mm立柱旁还有2mm角码竖边；底框检查发现20.5缺口仍会干涉。',fig('shots/J02-assembled.png','底板与框外轮廓齐；2mm黑垫片藏在板下。')+fig('shots/J03-assembled.png','下斗承板抱柱，原四托角片仍承担木台重量。'),table([('两块毛坯','220×240×6'),('四角缺口','各22.5×22.5；试套后修边'),('底板','底22；PP2垫片4；M5×14四套'),('底板孔','X60/160，Y10/230'),('下斗承板','底180；M3×16／M5×8各4'),('下斗开口','60方孔，左前80/90'),('下斗法兰孔','X73/147，Y83/157')],['对象','加工／安装'])+'<p>整板穿四立柱缺口，是嵌角视觉；不能把未开槽的木板与同高度实心横梁重叠。底板垫高避角码，仍与旧杯底Z28一致。</p><p>四缺口先按22.5试套，不用螺钉把板强拉到位。大板有A3纸样和6页A4两半拼接模板。</p>')
sheet('BOX承板与供电引出：位置保持','承板仍底224，前Y20；新5V线从原壳开口引出，具体走线按实物。',fig('shots/J13-exploded.png','四角软垫压原壳，不穿PCB。')+table([('BOX承板','176×88×6，旧件可用'),('四隔柱','20mm通孔，4只'),('原壳压片','12×20×2，4片'),('供电','J7-1 GND，J7-2 5V'),('线束','22AWG短线、匹配2.54母接头')],['对象','配置']),connection('J13',stack([('铝压片',2,'铝'),('隔柱',20,'PP'),('承板',6,'木')],'M3×35，先核原壳边角'))+'<p>2×3接头只接1/2，3–6留空绝缘；J7不是GPIO排口J10。实物针向、母端子额定、压降和温升均待核。</p>')
sheet('六片遮光罩：侧片到灯架，顶底到角片','不再只有一个空开关；实物模式黑色不透明，透明模式用于看内部。',fig('shots/J15-exploded.png','SH-L/R为两侧，F/B前后，T顶盖，D底片。')+table([('两侧片','152×110×2，φ32镜头孔'),('前后片','120×110×2，上部2孔'),('顶盖','120×148×2，30×26入口'),('底片','116×148×2，72方口，四角让灯架'),('整体范围','X48…172，Y44…196，Z222…334')],['对象','尺寸']),connection('J15',stack([('侧PP片',2,'PP'),('角铝回折翼',2,'铝')],'M3×10，孔不能穿LED'))+'<p>侧片8螺丝锁灯架；4竖角片连接前后片，8承托角片连接顶底，共32套M3×10。罩有进出豆与通风间隙，不称完全光密；先核漏光、ROI与散热。</p>')
sheet('整机接线：5V改接J7，24V仍给灯带','不装6V、舵机、限位或PWM缓冲，J10不接本版外设。','<img class="wiring" src="wiring-p6.svg">',wide=True)
sheet('J7逐针接法：1是GND，2才是5V','已核原厂原理图第1／3页；脚号排列不是实物朝向，先核丝印与导通。','<img class="wiring" src="power-j7-p6.svg">',wide=True)
fas=[(r['name'],r['installed_qty'],r['procurement_basis_qty']) for r in B if r['id'] in ['K-M3x10','K-M3x16','K-M3x35','K-M5x8','K-M5x12','K-M5x14','K-M3-W','K-M3-W7']]
sheet('配料与比赛验收：原库存先扣除','BOM59行；原打印几何和型材切割保持，三块大木板与罩件按P6加工。',table([('型材','460×4＋200×4＋180×4；库存够'),('海洋板','240×220×6三块，小板176×88＋200×30两条'),('黑PP2','400×300一片，6罩片＋4底板垫片'),('角铝','4×120＋8×40＋20×20，净1200'),('含切缝','32刀×3＝96，总1296；2根1m余704'),('扁条','只需4只12长BOX压片，含切缝60'),('5V支路','J7外供，经2A直流保险；USB1供电二选一')],['材料','用量'])+'<h2>先后顺序</h2><ol><li>框架找方，22.5缺口试套；底板垫片与下斗承板。</li><li>整顶板与原上斗，左右摄像头与BOX。</li><li>灯架、六片遮光罩；先看黑色，再透明查内件。</li><li>断电核J7与5V，空载量压，再双摄／照明。</li><li>准备好后手投一颗；缺图／糊图待复核并暂停下一颗。</li></ol>',table(fas,['螺钉／垫片','装机','采购基准'])+'<p>M3螺钉共76、M5共52；M3大垫136＋φ7常规垫16。M2相机螺钉与隔柱另列。采购前扣旧件。</p><p>23张SVG及6页A4拼接模板须100%打印、核50mm标尺；A3图册不是下料纸样。主机检查不等于实物承载、排针供电或双摄验收。</p>')
(ROOT/'assembly-guide-p6.html').write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>H3-P6组装图册</title><style>'+css+'</style>'+''.join(pages)+'</html>')
print('A3 guide pages',len(pages))
