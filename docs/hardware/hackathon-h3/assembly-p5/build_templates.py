from pathlib import Path
import json,csv
ROOT=Path(__file__).resolve().parent;D=json.loads((ROOT/'assembly-data.json').read_text());OUT=ROOT/'templates';OUT.mkdir(exist_ok=True);holes=[]
def sheet(id,title,w,h,body,pts,notes):
    sw=max(115,w+24);sh=h+70
    for x,y,d,role in pts:
        body+=f'<circle cx="{x}" cy="{y}" r="{d/2}"/><path d="M{x-2} {y}h4M{x} {y-2}v4" stroke="#33829b" stroke-width=".2"/>'
        holes.append([id,x,y,d,role])
    text=''.join(f'<text x="8" y="{h+37+i*5}" font-size="3">{n}</text>' for i,n in enumerate(notes))
    svg=f'''<svg xmlns="http://www.w3.org/2000/svg" width="{sw}mm" height="{sh}mm" viewBox="0 0 {sw} {sh}"><rect width="{sw}" height="{sh}" fill="white"/><g font-family="sans-serif" fill="#294550"><text x="8" y="9" font-size="4">H3-P5 · {id} {title}</text><text x="8" y="15" font-size="3">单位mm；100%实际尺寸；量50mm标尺后先对实物</text><g transform="translate(12 22)" fill="none" stroke="#294550" stroke-width=".3">{body}</g>{text}<path d="M12 {h+57}h50m-50 -2v4m50 -4v4" stroke="#294550" fill="none" stroke-width=".3"/><text x="24" y="{h+65}" font-size="3">本段应为50mm</text></g></svg>'''
    (OUT/(id+'.svg')).write_text(svg)

sheet('W01','底板',176,196,'<rect width="176" height="196"/>',[(x-22,y-22,3.4,'底平片') for x in [60,160] for y in [30,210]],['底Z22，左前X22/Y22；沿用P4底板孔。'])
sheet('W02','工作台＋灯脚',176,196,'<rect width="176" height="196"/><rect x="58" y="68" width="60" height="60" stroke="#aa7042"/>',[(x-22,y-22,3.4,'工作台孔（角铝／法兰／灯脚）') for x,y in D['wood_holes']],['中孔60×60；底Z180。灯脚8孔：X55/65/155/165，Y40/200。','先放下斗法兰再核灯脚孔，板内坐标＝全局减22。'])
pts=[(x-22,312-z,3.4,'柱角铝') for x in [30,190] for z in [240,296]]+[(x-22,312-z,3.4,'原壳角压片隔柱') for x in [74,146] for z in [236,288]]
sheet('W03','BOX承板（正面）',176,88,'<rect width="176" height="88"/>',pts,['板前Y20、底Z224；纸上方Z312。','原壳尺寸先核；孔与旧P4相对板边位置一致，整体降低110。'])
for r in D['camera_boards']:
    # Paper long edge is globalY; short edge globalX, with explicit origin.
    x0,y0,_=r['xyz'];pts=[(y-y0,x-x0,3.4,'两端托片／中间相机脚') for x,y in r['holes_xy']]
    sheet(r['id'],'相机板200×30',200,30,'<rect width="200" height="30"/>',pts,['纸横向＝全局Y20→220；纵向＝全局X'+str(x0)+'→'+str(x0+30)+'。','两端孔在10/190，中间脚孔74/126；全在短边中线15。','相机座原件转90°，板顶Z240；按外形先试摆。'])
sheet('C01','PP顶板：180左右／200前后',180,200,'<rect width="180" height="200"/><rect x="50" y="60" width="80" height="80" stroke="#aa7042"/>',[(x-20,y-20,3.4,'上斗法兰／顶平片') for x,y in D['ring_holes']],['实物200×180×3，图中180横向；底Z440。','与内框名义刚好；先试套，必要时少量修边，勿强拧拉平。'])
sheet('F-flat','顶／底平片',40,20,'<rect width="40" height="20"/>',[(10,10,5.5,'M5或M3大垫片'),(30,10,5.5,'M5或M3大垫片')],['8片，孔距20。M3穿φ5.5孔两侧加φ9平垫。'])
sheet('BOX-clip','铝压片',12,20,'<rect width="12" height="20"/>',[(6,10,3.4,'M3×35')],['4片，贴软垫，只压原壳角边。'])
for id,title,w,h,pts,notes in [
 ('L01','灯带竖角铝接脚翼',20,120,[(10,112,3.4,'底端8接脚孔'),(10,104,3.4,'底端16接脚孔')],['4件，20×20×2长120；本图为一个翼的侧面。','纸下端对应底Z186；实际灯带贴Z206–306，先绝缘焊点。']),
 ('L02-foot','灯脚：水平翼',20,20,[(5,10,3.4,'木台'),(15,10,3.4,'木台')],['4件，20×20×2、宽20；本图只展开水平翼。','垫片φ9，孔中心距10；竖翼另见L02-upright。']),
 ('L02-upright','灯脚：竖翼',20,20,[(10,12,3.4,'底端8竖角铝'),(10,4,3.4,'底端16竖角铝')],['同4件，不是另买4件；本图只展开竖翼，纸底对应底Z186。']),
 ('A-CAM-shelf','相机托片：水平翼',40,20,[(17 if side=='L' else 23,10,3.4,'木板') for side in ['L']],['20×20×2宽40，共4；左右镜像，右件孔X23，左件17。','柱侧孔在另一翼：左X30，右X10；按全局坐标核。'])
]:sheet(id,title,w,h,f'<rect width="{w}" height="{h}"/>',pts,notes)
sheet('A-CAM-right','右相机托片水平翼',40,20,'<rect width="40" height="20"/>',[(23,10,3.4,'右木条')],['2件；20×20×2宽40，竖翼锁柱孔在X10。'])
sheet('A-CAM-post-left','左相机托片竖翼',40,20,'<rect width="40" height="20"/>',[(30,10,5.5,'左柱M5')],['同2只左件，另一翼的孔；不是增加2件。'])
sheet('A-CAM-post-right','右相机托片竖翼',40,20,'<rect width="40" height="20"/>',[(10,10,5.5,'右柱M5')],['同2只右件，另一翼的孔；不是增加2件。'])
with (ROOT/'hole-patterns-p5.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.writer(f);w.writerow(['part','paper_x_mm','paper_y_mm','diameter_mm','purpose']);w.writerows(holes)
cuts=[
 ('H14','立柱','黑2020','460',4,'4根460整根保留'),('H14','前后宽梁','黑2020','180',4,'3根460各切200+180；第1根400同切'),('H14','左右深梁','黑2020','200',4,'每根计两道3mm锯缝'),('H14','剩余库存','黑2020','74×3／14／400',1,'余636；第二根400整根保留；无P4后横梁'),
 ('W01','底板','海洋板6','176×196',1,'底Z22，沿用P4'),('W02','工作台','海洋板6','176×196',1,'底180；新增8灯脚孔；60方孔不变'),('W03','BOX板','海洋板6','176×88',1,'前Y20，底224；旧板可整块下移'),('W04/W05','左右相机板','海洋板6','200×30',2,'200沿Y；不能由旧176长条直接加长'),('C01','顶部PP','PP3','200×180',1,'180沿X，200沿Y；中80方孔'),
 ('A-WORK','工作台托片','20×20×2角铝','宽40',4,'沿用P4'),('A-CAM','相机托片','20×20×2角铝','宽40',4,'两端方向与旧相机托片不同；看展开纸样'),('A-BOX','BOX侧托片','20×20×2角铝','宽20',4,'沿用P4，下移110'),('L01','灯带竖角铝','20×20×2角铝','长120',4,'100mm灯带直接贴内侧'),('L02','灯架脚角片','20×20×2角铝','宽20',4,'两翼各2孔；4件共8翼图'),('H17','角铝第1根','1000mm原料','4×120＋8×40',1,'净800＋12刀×3＝836，余164'),('H17','角铝第2根','1000mm原料','8×20',1,'净160＋8刀×3＝184，余816；优先扣旧角片'),('H39','平片＋压片','20×2扁条','8×40＋4×12',1,'净368＋12刀×3＝404，500长足够')]
with (ROOT/'cut-list-p5.csv').open('w',encoding='utf-8-sig',newline='') as f:w=csv.writer(f);w.writerow(['id','part','material','size_mm','qty','notes']);w.writerows(cuts)
print('Templates',len(list(OUT.glob('*.svg'))),'holes',len(holes))
