from pathlib import Path
import csv,json,shutil
ROOT=Path(__file__).resolve().parent;OUT=ROOT/'templates';OUT.mkdir(exist_ok=True);holes=[]
def sheet(id,title,w,h,body,pts,notes):
    sw=max(110,w+24);sh=h+64
    for x,y,d,role in pts:
        body+=f'<circle cx="{x}" cy="{y}" r="{d/2}"/><path d="M{x-2} {y}h4M{x} {y-2}v4" stroke="#33829b" stroke-width=".2"/>'
        holes.append([id,x,y,d,role])
    text=''.join(f'<text x="8" y="{h+36+i*5}" font-size="3">{n}</text>' for i,n in enumerate(notes))
    svg=f'''<svg xmlns="http://www.w3.org/2000/svg" width="{sw}mm" height="{sh}mm" viewBox="0 0 {sw} {sh}"><rect width="{sw}" height="{sh}" fill="white"/><g font-family="sans-serif" fill="#294550"><text x="8" y="9" font-size="4">H3-P4 · {id} {title}</text><text x="8" y="15" font-size="3">单位mm；100%实际尺寸；先量50mm标尺并对实物</text><g transform="translate(12 22)" fill="none" stroke="#294550" stroke-width=".3">{body}</g>{text}<path d="M12 {h+52}h50m-50 -2v4m50 -4v4" stroke="#294550" fill="none" stroke-width=".3"/><text x="24" y="{h+60}" font-size="3">本段应为50mm</text></g></svg>'''
    (OUT/(id+'.svg')).write_text(svg)

sheet('W01','底木板',176,196,'<rect width="176" height="196"/>',[(x-22,y-22,3.4,'底平片M3') for x in [60,160] for y in [30,210]],['左前角全局X22/Y22，纸面向下为后方。','本版孔位X60/160、Y30/210，底Z22。'])
pts=[(x-22,y-22,3.4,'角铝') for x in [30,190] for y in [30,210]]+[(x-22,y-22,3.4,'下斗法兰') for x in [73,147] for y in [83,157]]
sheet('W02','工作木台',176,196,'<rect width="176" height="196"/><rect x="58" y="68" width="60" height="60" stroke="#aa7042"/>',pts,['60×60孔左前角为板内X58/Y68；底Z180。','外侧4孔接角铝，孔周4孔接打印下斗法兰。'])
sheet('W03','BOX前承板（正面看）',176,88,'<rect width="176" height="88"/>',[(x-22,422-z,3.4,'侧角铝') for x in [30,190] for z in [350,406]]+[(x-22,422-z,3.4,'20mm隔柱') for x in [74,146] for z in [346,398]],['纸面上方为Z422，左下全局X22/Z334。','面板前面Y20；四角原壳压片须先核按键与接口。'])
for id,y in [('W04',2),('W05',208)]:
    yy=17 if id=='W04' else 223;sy=27 if id=='W04' else 213
    sheet(id,'相机木横条',176,30,'<rect width="176" height="30"/>',[(x-22,yy-y,3.4,'立柱角铝／相机座') for x in [30,84,136,190]]+[(x-22,sy-y,3.4,'遮光板角铝') for x in [52,188]],['左前角X22/Y'+str(y)+'；底234、顶240。','外2孔接立柱；中2孔接相机；另2孔接遮光片角铝。'])
sheet('C01','PP3顶环',176,196,'<rect width="176" height="196"/><rect x="48" y="58" width="80" height="80" stroke="#aa7042"/>',[(x-22,y-22,3.4,'上斗法兰') for x in [64,156] for y in [74,166]]+[(x-22,y-22,3.4,'顶平片') for x in [30,190] for y in [60,180]],['底Z440；斗法兰贴环下面，平片从侧面托环。','孔径φ3.4；打印斗法兰孔距92，不用旧焊接孔图。'])
sheet('C02-C03','两块PP3导向盖',50,85,'<rect width="50" height="85"/><rect x="16" y="18" width="18" height="14" stroke="#aa7042"/>',[(x,y,3.4,'夹层螺栓') for x in [5,45] for y in [10,70]],['共2片，左前角全局85/95。','后两孔再穿68×80承托片；夹层先手推。'])
sheet('H36','铝闸片',29.4,82,'<rect width="29.4" height="82"/>',[(14.7,76,3.4,'球头'),(24.7,76,3.4,'旗片')],['前缘为纸上方，全局Y108；左右全局95.3–124.7。','两面平、去毛刺；不增加自动孔补偿。'])
sheet('F-flat','40×20平连接片',40,20,'<rect width="40" height="20"/>',[(10,10,5.5,'M5或M3大垫片'),(30,10,5.5,'M5或M3大垫片')],['8片：4顶环＋4底板；孔距20。','M3过φ5.5孔时用φ9平垫，两面均加。'])
sheet('BOX-clip','20×12铝压片',12,20,'<rect width="12" height="20"/>',[(6,10,3.4,'M3x35')],['共4片，贴软垫后只压原壳角边。','实物按键／接口／屏边先核；不可强压PCB。'])
for side in ['L','R']:
    if side=='L':points=[(0,100),(0,76.2),(10.5,76.2),(10.5,69.8),(0,69.8),(0,0),(196,0),(196,69.8),(185.5,69.8),(185.5,76.2),(196,76.2),(196,100)]
    else:points=[(0,100),(0,76.2),(10.5,76.2),(10.5,69.8),(0,69.8),(0,0),(132,0),(132,34),(196,34),(196,69.8),(185.5,69.8),(185.5,76.2),(196,76.2),(196,100)]
    body='<polygon points="'+' '.join(f'{x},{y}' for x,y in points)+'"/>'
    pts=[(y-22,310-z,3.4,'侧片／背景角铝') for y,z in [(27,250),(213,250),(40,264),(200,264)]]+[(y-22,310-z,3.4,'灯槽卡扣候选') for y in [80,142] for z in [220,300]]
    sheet('SH-'+side,'黑PP2侧片（外侧看）',196,100,body,pts,['纸左为前Y22、右为后Y218；上为Z310。','两端木横条避让槽10.5×6.4；右片再去64×34。','卡扣孔仅候选，先对所购卡扣；建议A4横向100%。'])
for side in ['F','B']:
    body='<path d="M0 47V0H'+('110V47' if side=='F' else '80V16H110V47')+'Z"/><circle cx="45" cy="32" r="12" stroke="#aa7042"/>'
    sheet('BG-'+side,'黑PP2背景片',110,47,body,[(9,28,3.4,'角铝'),(101,28,3.4,'角铝')],['左下全局X65/Z245；上Z292；光孔中心X110/Z260。','后片右上去30×16，避舵机；先对镜头外廓。'])
for name in ['aluminum-base.svg','carrier.svg','camera-hole-check.svg','servo-ear-check.svg']:shutil.copy2(ROOT.parent/'printing-p2/templates'/name,OUT/name)
with (ROOT/'hole-patterns-p4.csv').open('w',encoding='utf-8-sig',newline='') as f:
    out=csv.writer(f);out.writerow(['part','svg_local_x_mm','svg_local_y_mm','diameter_mm','purpose']);out.writerows(holes)
print('SVG templates',len(list(OUT.glob('*.svg'))),'hole records',len(holes))
