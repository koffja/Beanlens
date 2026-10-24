from pathlib import Path
import json,html,ast
ROOT=Path(__file__).resolve().parent
D=json.loads((ROOT/'assembly-data.json').read_text());B=json.loads((ROOT/'bom-p5.json').read_text());pages=[]
# Reuse pure typography/stack helpers only; never execute the P4 document generator.
tree=ast.parse((ROOT.parent/'assembly-p4/build_docs.py').read_text())
functions=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['esc','table','stack','camstack']]
exec(compile(ast.Module(body=functions,type_ignores=[]),'P4_readonly_pure_helpers','exec'))
css=next(ast.literal_eval(n.value) for n in tree.body if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='css' for t in n.targets))
css+=' .wide main{display:block}.wiring{width:400mm;height:224mm;object-fit:contain} '
def fig(src,caption):return f'<figure><img src="{src}"><figcaption>{caption}</figcaption></figure>'
def sheet(title,subtitle,left,right='',wide=False):
    n=len(pages)+1;cls='sheet wide' if wide else 'sheet'
    pages.append(f'<section class="{cls}"><header><small>BEANLENS H3-P5 / 2026.10.23</small><h1>{title}</h1><p>{subtitle}</p></header><main><div>{left}</div><aside>{right}</aside></main><footer>{n:02} / 09　单位mm；主机设计检查，未实物装配／双摄验收。4打印实体沿用P1/P2，P4舵机版保留。</footer></section>')
def connection(id,svg='',extra=''):
    j=next(j for j in D['joints'] if j['id']==id)
    return '<h2>'+j['chain']+'</h2><div class="fast">'+'<br>'.join(j['fasteners'])+'</div><ol>'+''.join('<li>'+s+'</li>' for s in j['steps'])+'</ol>'+svg+'<p class="note">'+(j['note'] or '先对纸样和实物，螺长核板厚、垫片、螺母与槽底。')+'</p>'+extra

sheet('比赛手动版：左右双摄与整机组装','相机改到BOX左右，灯带直接上20角铝；完全人工逐颗投豆。',fig('shots/whole.png','裸框220×240×460；左右托片计入后横向约260。')+'<p>用户已确认两镜头相距约200mm、BOX位于两者之间、左右水平相向。BOX中心约Z260，以缩短排线路径。</p>',table([('裸框','220×240×460'),('两镜头','X10/210，Y120，Z260'),('两相机板','200×30×6，顶240'),('BOX木承板','176×88×6，底224'),('上PP顶板','200×180×3，底440'),('上斗颈出口','Z329.5，直接落豆'),('下斗上口／下口','Z220／160'),('工作台／底板顶','Z186／28'),('灯带有效高度','Z206…306')],['部位','P5安装位置'])+'<p>人工一次一颗；先准备两路采集，再放豆。缺图／糊图／多豆须复核，提示停投；豆已落杯，不能追回。</p>')
sheet('整机爆炸：只安装四件打印件','打印、木板、角铝和型材始终保持同一尺寸比例。',fig('shots/exploded.png','爆炸仅外移认件，不能按爆炸间距下料。'),table([('P11','上漏斗直通身，原P1'),('P13','下接豆斗，原P1'),('P22','原前相机座，转90°装右'),('P23','原后相机座，转90°装左')],['打印编号','本版用途'])+'<h2>本版不安装</h2><p>P12接座、舵机／舵臂／连杆、铝闸片、导向盖／侧条、限位与旗片、舵机铝板／固定架、后承托／新增后梁、旧灯槽／卡扣及PP遮光板。</p><p>原9件与P3切片全部保留；本版只是4件装机。P3的02盘含不用的P12，尚未打印时在Studio删模型后重新切片；不编辑已切G-code。</p><p>银色件仍有平片、框角码、木板托角片、BOX压片和灯架，不因取消舵机而全部取消。</p>')
sheet('顶部：200×180 PP板与直通上斗','180沿左右X，200沿前后Y；法兰在PP板下方。',fig('shots/J06-exploded.png','J06：四颗M3×16穿PP3和上斗法兰4。')+table([('PP左前／尺寸','20/20；180×200×3'),('PP中孔','80×80，板内50/60'),('斗孔全局','X64/156，Y74/166'),('平片孔全局','X30/190，Y60/180'),('平片锁梁孔','X10/210，Y60/180')],['对象','孔位／尺寸']),connection('J06',stack([('PP顶板',3,'PP'),('上斗法兰',4,'PETG')],'M3×16，两面垫片／防松螺母'))+'<p>J05：四平片外M5×8向上锁顶深梁底槽，内M3×12穿PP，配φ9垫片。顶板名义零边隙，先试套，误差时局部修边；不强挤框架。</p>')
sheet('左右相机：200×30木条、40宽托角片','原P22／P23打印座转90°使用；两光轴保持同高。',fig('shots/J10-exploded.png','镜头相距200；略伸出框架侧面，BOX在前方中间。')+table([('右木条W04','X208，Y20，Z234；30×200×6'),('左木条W05','X−18，Y20，Z234；30×200×6'),('木条孔（板内）','长边10/74/126/190，短边15'),('柱M5孔','X10/210，Y20/220，Z224'),('相机底脚孔','X−3/223，Y94/146')],['对象','候选位置']),connection('J10',camstack())+'<p>J04：4只40宽20角铝，左右镜像；一翼M5锁柱Y槽，另一翼M3×16托板。紫虚线仅CSI走向参考，200mm排线仍须实物试套。</p>')
sheet('灯带：直接贴20角铝，双螺丝防旋','四只长120竖角铝由四脚连接工作木台；不再使用铝槽和卡扣。',fig('shots/J14-exploded.png','灯带→导热背胶→竖角铝→脚角片→工作台。')+table([('竖角铝','20×20×2，120长，底186'),('脚角片','20×20×2，宽20，共4'),('木台8脚孔','X55/65/155/165，Y40/200'),('竖翼接脚孔','Z194/202；前Y50、后190'),('灯带','4×100，Z206…306')],['对象','尺寸／位置']),connection('J14',stack([('角片水平脚',2,'铝'),('海洋板',6,'木')],'每脚M3×16两颗；竖翼另两颗M3×10'))+'<p>先去毛刺、贴背胶；焊盘／接头热缩绝缘，不钻灯带线路，线端扎带卸力。首件先量温升、核背胶与眩光；实际剪切点以灯带标记为准。</p>')
sheet('下斗与木台：灯脚孔和法兰孔分开','原下斗、底板可复用；工作台新增灯架脚孔。',fig('shots/J12-exploded.png','下斗法兰放在木台上面，底Z186。')+table([('木台外形','176×196×6；底180'),('中孔','60×60，板内58/68'),('下斗法兰孔','X73/147，Y83/157'),('木台角片孔','X30/190，Y30/210'),('底板平片孔','X60/160，Y30/210')],['对象','孔位']),connection('J12',stack([('打印法兰',4,'PETG'),('工作木台',6,'木')],'下斗M3×16四套'))+'<p>J03木台4只40宽角铝锁立柱。J02底板4平片锁底框顶槽，底Z22、顶28；普通杯接豆，不装称重件。</p>')
sheet('BOX：整体下移，与相机同高附近','原承板和相对孔位不改，仅将承板沿立柱降低110mm。',fig('shots/J13-exploded.png','先核接口／按键，再轻压四角；不穿PCB。')+table([('承板','176×88×6，前Y20，底224'),('板角孔','X30/190，Z240/296'),('压片隔柱孔','X74/146，Z236/288'),('隔柱／压片','通孔20长；12×20×2四片'),('CSI走线参考','右约145／左138mm折线')],['对象','候选位置']),connection('J13',stack([('铝角压片',2,'铝'),('绝缘通孔隔柱',20,'PP'),('木承板',6,'木')],'压片M3×35；原壳边角先试配'))+'<p>排线参考长度未包含真实接口、插入和弯曲余量，不能保证20cm线够用；断电试套，固定线端，不拉紧或带电插拔。</p>')
sheet('接线：取消6V执行器支路','相机只由配套CSI供电；BOX只接已核5V电源；J10本版不接外设。','<img class="wiring" src="wiring-p5.svg">',wide=True)
fas=[(r['name'],r['installed_qty'],r['procurement_basis_qty']) for r in B if r['id'] in ['K-M3x10','K-M3x12','K-M3x16','K-M3x35','K-M5x8','K-M3-N','K-M3-W','K-M3-W7','K-M5-T']]
sheet('配料与人工流程：先扣已有库存','新BOM51行；原料、加工子件、复用件分别列出，不重复采购。',table([('黑2020','12段：460×4＋200×4＋180×4；不用新增'),('库存余料','74×3＋14＋整400＝636，按3mm锯缝'),('木板','底／台176×196，BOX176×88，两条200×30'),('PP顶板','200×180×3，旧板需换'),('20角铝','8×40＋8×20＋4×120＝960净长'),('角铝锯缝','20刀×3＝60；计1020，1根1m不够'),('全新角铝','2根1m；旧P4角片和余料优先扣库存'),('20×2扁条','500一根：8×40＋4×12＋36锯缝＝404')],['物料','P5用量'])+'<h2>安装顺序</h2><ol><li>空框找方，底板与工作台。</li><li>PP顶板与上斗，下斗与杯。</li><li>左右木条／打印座／PCB，低位BOX。</li><li>灯角铝与接线；断电试套CSI。</li><li>双摄准备后手投一颗；完成核图再投下一颗。</li></ol>',table(fas,['规格','装机','采购基准'])+'<p>相机另M2×5与×8各8、8mm内内隔柱8；具体备件见CSV。原料采购基准不是新增订购量，先扣旧件。</p><h2>失败处理</h2><p>缺图／糊图／多豆／配对不明→记录待复核→提示人工暂停。豆已进同杯，不能留在闸上；KEY1不能阻挡已落豆。</p><p>15张1:1 SVG按实际100%打印、核50mm标尺。A3图册不是下料纸样。所有图、孔距和电气仍需首件验证。</p>')
(ROOT/'assembly-guide-p5.html').write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>H3-P5组装图册</title><style>'+css+'</style>'+''.join(pages)+'</html>')
print('A3 guide pages',len(pages))
