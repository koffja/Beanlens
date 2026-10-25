from pathlib import Path
import json,csv
ROOT=Path(__file__).resolve().parent;D=json.loads((ROOT/'assembly-data.json').read_text());OUT=ROOT/'templates';OUT.mkdir(exist_ok=True);holes=[];boards={}
def sheet(id,title,w,h,body,pts,notes):
    sw=max(115,w+24);sh=h+70
    for x,y,d,role in pts:
        body+=f'<circle cx="{x}" cy="{y}" r="{d/2}"/><path d="M{x-2} {y}h4M{x} {y-2}v4" stroke="#33829b" stroke-width=".2"/>'
        holes.append([id,x,y,d,role])
    text=''.join(f'<text x="8" y="{h+37+i*5}" font-size="3">{n}</text>' for i,n in enumerate(notes))
    svg=f'''<svg xmlns="http://www.w3.org/2000/svg" width="{sw}mm" height="{sh}mm" viewBox="0 0 {sw} {sh}"><rect width="{sw}" height="{sh}" fill="white"/><g font-family="sans-serif" fill="#294550"><text x="8" y="9" font-size="4">H3-P7 · {id} {title}</text><text x="8" y="15" font-size="3">单位mm；100%实际尺寸；量50mm标尺后先对实物</text><g transform="translate(12 22)" fill="none" stroke="#294550" stroke-width=".3">{body}</g>{text}<path d="M12 {h+57}h50m-50 -2v4m50 -4v4" stroke="#294550" fill="none" stroke-width=".3"/><text x="24" y="{h+65}" font-size="3">本段应为50mm</text></g></svg>'''
    (OUT/(id+'.svg')).write_text(svg)

def board_sheet(id,title,z,notches=False,aperture=None,pts=[]):
    body='<rect width="220" height="240"/>'
    if notches:
        body='<path d="M22.5 0H197.5V22.5H220V217.5H197.5V240H22.5V217.5H0V22.5H22.5Z"/>'
    if aperture:
        x,y,w,h=aperture;body+=f'<rect x="{x}" y="{y}" width="{w}" height="{h}" stroke="#aa7042"/>'
    boards[id]=dict(body=body,pts=pts,title=title)
    sheet(id,title,220,240,body,pts,[f'220沿左右X，240沿前后Y；底Z{z}；纸上方为前。','大板纸样用A3竖向100%；也可用A4分幅PDF，不能缩小。','四角22.5方口避20立柱及角码；顶板不切角。' if notches else '顶部整板盖在型材上面；不沿用旧PP孔图。'])
board_sheet('W01','底板240×220×6',22,True,pts=[(x,y,5.5,'M5直锁底框') for x in [60,160] for y in [10,230]])
board_sheet('W02','下斗承板240×220×6',180,True,(80,90,60,60),[(x,y,3.4,'角片／下斗／灯脚') for x,y in D['wood_holes']])
board_sheet('W06','整顶板240×220×6',460,False,(70,80,80,80),[(x,y,3.4 if x in [64,156] else 5.5,'上斗M3／顶框M5') for x,y in D['ring_holes']])
pts=[(x-22,440-z,3.4,'柱角铝') for x in [30,190] for z in [368,394]]+[(x-22,440-z,3.4,'BOX隔柱') for x in [74,146] for z in [364,416]]
sheet('W03','BOX承板',176,88,'<rect width="176" height="88"/>',pts,['前Y20，底352顶440；柱孔距板顶46/72，旧上孔需另钻；不钻PCB。'])
for r in D['camera_boards']:
    x0,y0,_=r['xyz'];sheet(r['id'],'相机板200×40',200,40,'<rect width="200" height="40"/>',[(y-y0,x-x0,3.4,'端部托片，非相机孔') for x,y in r['holes_xy']],['长200沿前后Y、宽40沿X；顶240；长边10/190，短边20。相机竖直粘内边，不开PCB孔。'])
for side in ['L','R']:
    body='<rect width="152" height="110"/><circle cx="76" cy="72" r="16" stroke="#aa7042"/>'
    sheet('SH-'+side,'遮光侧片（外侧看）',152,110,body,[(y-44,332-z,3.4,'灯回折翼／罩角片') for y,z in D['shade_holes']],['横向前Y44到后196，纸上Z332；镜头孔φ32中心Y120/Z260。','实物黑PP2不透明；孔先对镜头／ROI，不钻LED线路。'])
for side in ['F','B']:sheet('SH-'+side,'前／后黑PP片',120,110,'<rect width="120" height="110"/>',[(10,14,3.4,'上角片'),(110,14,3.4,'上角片')],['下Z222，上332；X50到170；仅前后片的上部两孔。'])
# sheet('SH-T','黑PP顶盖',120,148,'<rect width="120" height="148"/><rect x="45" y="61" width="30" height="26" stroke="#aa7042"/>',[(x-50,y-46,3.4,'顶角片') for x in [60,160] for y in [90,150]],['左前50/46，底332；中间进豆30×26；不改上漏斗。'])
body='<path d="M20 0H96V26H116V122H96V148H20V122H0V26H20Z"/><rect x="22" y="38" width="72" height="72" stroke="#aa7042"/>'
sheet('SH-D','黑PP底片',116,148,body,[(x-52,y-46,3.4,'底角片') for x in [60,160] for y in [90,150]],['左前52/46，底222；中72方孔；四角20×26让灯架。'])
sheet('N03','底板PP2支承垫片',40,20,'<rect width="40" height="20"/>',[(20,10,5.5,'M5')],['4片；黑PP2原料余料裁，放底梁上面Z20。'])
sheet('BOX-clip','BOX铝压片',12,20,'<rect width="12" height="20"/>',[(6,10,3.4,'M3×35')],['4片，软垫只压原壳角边。'])
sheet('L01-front','灯角铝20宽平面翼',20,120,'<rect width="20" height="120"/>',[(10,112,3.4,'底端8'),(10,104,3.4,'底端16')],['共4件长120，另一翼见L01-return；本翼粘灯带，不另加孔。','纸底Z186，灯带206到306，留开螺母；右侧回折翼朝外。'])
sheet('L01-return','同灯角铝回折翼',20,120,'<rect width="20" height="120"/>',[(10,56,3.4,'遮光片Z250'),(10,12,3.4,'遮光片Z294')],['同4件，另一翼孔；不代表另买4件；纸底Z186。'])
sheet('L02-foot','灯脚水平翼',20,20,'<rect width="20" height="20"/>',[(5,10,3.4,'木台'),(15,10,3.4,'木台')],['4件，20角铝裁宽20；本图仅水平翼。'])
sheet('L02-upright','同灯脚竖翼',20,20,'<rect width="20" height="20"/>',[(10,12,3.4,'竖灯角铝'),(10,4,3.4,'竖灯角铝')],['同4件，底端8/16；用外φ7平垫防叠压。'])
for side in ['left','right']:
    sheet('A-CAM-'+side,'相机托片水平翼',40,20,'<rect width="40" height="20"/>',[(20,10,3.4,'木条')],['每侧2只，20×20×2宽40，左右镜像。'])
    sheet('A-CAM-post-'+side,'同托片柱侧翼',40,20,'<rect width="40" height="20"/>',[(10 if side=='left' else 30,10,5.5,'柱槽M5')],['同每侧2件，不重复采购。'])
sheet('S10','遮光罩角片两翼',20,20,'<rect width="20" height="20"/>',[(10,10,3.4,'每翼一个居中孔')],['8件20×20×2宽20，两翼相同中心孔；不是16件。','4竖角＋4底承，无顶盖或顶承，按爆炸图旋转安装。'])
with (ROOT/'hole-patterns-p7.csv').open('w',encoding='utf-8-sig',newline='') as f:w=csv.writer(f);w.writerow(['part','paper_x_mm','paper_y_mm','diameter_mm','purpose']);w.writerows(holes)
# Six A4 sheets: board halves with20mm overlap and physical50mm rulers.
pages=[]
for id,v in boards.items():
    for offset in [0,100]:
        marks=v['body']+''.join(f'<circle cx="{x}" cy="{y}" r="{diam/2}"/>' for x,y,diam,role in v['pts'])
        svg=f'<svg xmlns="http://www.w3.org/2000/svg" width="210mm" height="297mm" viewBox="0 0 210 297"><defs><clipPath id="clip"><rect x="40" y="25" width="120" height="240"/></clipPath></defs><rect width="210" height="297" fill="white"/><g font-family="sans-serif" fill="#294550"><text x="12" y="10" font-size="4">H3-P7 {id} '+('左' if offset==0 else '右')+'半幅 / 100%实际尺寸</text><text x="12" y="17" font-size="3">全局X'+str(offset)+'–'+str(offset+120)+'；两页重叠20mm，按X110虚线对齐</text><g clip-path="url(#clip)"><g transform="translate('+str(40-offset)+' 25)" fill="none" stroke="#294550" stroke-width=".3">'+marks+'<path d="M110 0V240" stroke="#ad773d" stroke-dasharray="2 2"/></g></g><path d="M40 278h50m-50 -2v4m50 -4v4" stroke="#294550" stroke-width=".3"/><text x="42" y="287" font-size="3">此线应为50mm，关闭适合页面</text></g></svg>'
        pages.append('<section>'+svg+'</section>')
(ROOT/'templates-a4-p7.html').write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><style>@page{size:A4 portrait;margin:0}body{margin:0}section{width:210mm;height:297mm;break-after:page}section:last-child{break-after:auto}svg{display:block}</style>'+''.join(pages))
cuts=[('W01','底板','海洋板6','240×220，四角22.5方口',1,'底Z22；220沿X，240沿Y；4PP2垫片'),('W02','下斗承板','海洋板6','240×220，四角22.5方口',1,'底180，中60方孔；原灯脚和法兰全局孔保留'),('W06','顶板','海洋板6','240×220整板',1,'底460，不切角，中80方孔'),('W03','BOX板','海洋板6','176×88',1,'底352顶440；柱孔Z368/394，上对托片避角码'),('W04/W05','相机条','海洋板6','200×40',2,'200沿Y；左X0…40/右180…220；外侧齐框'),('H14','框架','黑2020','460×4／200×4／180×4',12,'库存够，3mm锯缝余636；不新增'),('H17','角铝根1','20×20×2','4×120＋8×40',1,'净800＋36锯缝＝836；余164'),('H17','角铝根2','20×20×2','16×20',1,'净320＋48锯缝＝368；余632；合计余796'),('H39','BOX压片','20×2扁条','4×12',1,'净48＋12切缝＝60；100mm或旧余料'),('SH-L/R','侧片','黑PP2','152×110，φ32镜头孔',2,'纸样与ROI先核'),('SH-F/B','前后片','黑PP2','120×110',2,'上部2孔'),('SH-D','底片','黑PP2','116×148，72方口＋4角20×26',1,'底222'),('N03','底板垫片','黑PP2','40×20',4,'中心φ5.5，原料含在H20'),('H20','黑PP排版','400×300×2','上排116×148＋152×110，下排152×110＋120×110＋120×110',1,'留3mm切缝，最大宽398；4垫片取余料')]
with (ROOT/'cut-list-p7.csv').open('w',encoding='utf-8-sig',newline='') as f:w=csv.writer(f);w.writerow(['id','part','material','size_mm','qty','notes']);w.writerows(cuts)
print('templates',len(list(OUT.glob('*.svg'))),'paper holes',len(holes),'A4 split pages',len(pages))
