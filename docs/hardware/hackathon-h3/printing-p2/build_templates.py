from pathlib import Path
ROOT=Path(__file__).resolve().parent
OUT=ROOT/'templates';OUT.mkdir(exist_ok=True)
def sheet(file,title,w,h,body,notes):
    text=''.join(f'<text x="8" y="{h+36+i*5}" font-size="3">{n}</text>' for i,n in enumerate(notes))
    svg=f'''<svg xmlns="http://www.w3.org/2000/svg" width="110mm" height="{h+65}mm" viewBox="0 0 110 {h+65}"><rect width="110" height="{h+65}" fill="white"/><g font-family="sans-serif" fill="#243b45"><text x="8" y="9" font-size="4">H3-P2 · {title}</text><text x="8" y="15" font-size="3">mm / 100%实际尺寸 / 先对实物，不选适应页面</text><g transform="translate(16 22)" fill="none" stroke="#233d49" stroke-width=".3">{body}</g>{text}<path d="M16 {h+54}h50m-50 -2v4m50 -4v4" fill="none" stroke="#243b45" stroke-width=".3"/><text x="32" y="{h+61}" font-size="3">核验这段应为50mm</text></g></svg>'''
    (OUT/file).write_text(svg)
def cross(x,y,d):return f'<circle cx="{x}" cy="{y}" r="{d/2}"/><path d="M{x-2} {y}h4M{x} {y-2}v4" stroke="#29849b" stroke-width=".2"/>'
body='<rect width="60" height="60"/>'
for x in [6,40]:
 for y in [6,54]:body+=cross(x,y,3.4)
for y in [37,53]:body+=cross(54.5,y,3.4)
sheet('aluminum-base.svg','60×60×3铝底板',60,60,body,['4孔接打印架：相对左前角X6/40、Y6/54，φ3.4。','右侧2孔接金属角码：X54.5、Y37/53，φ3.4。','角码实物不匹配时先改孔；不要强行拉弯铝板。'])
body='<rect width="68" height="80"/><rect x="20" y="19" width="20" height="30" stroke="#a35432"/>'
for x,y,d in [(5,5,3.4),(45,5,3.4),(10,70,5.5),(55,70,5.5),(59,25,3.4),(59,33,3.4),(59,42,3.4),(59,50,3.4)]:body+=cross(x,y,d)
sheet('carrier.svg','68×80×3新承托片',68,80,body,['左前角为整机X85/Y160；这片替换原176×50。','20×30窗口让移动螺母通过，左前角X20/Y19。','前2孔φ3.4接闸盒；后2孔φ5.5接180型材顶槽。','侧边4孔φ3.4固定限位座；先松装，后校准触发。'])
body='<rect x="0" y="0" width="60" height="48"/><rect x="20" y="18" width="20" height="20"/>'
for sx in [-1,1]:
 for sz in [-1,1]:
  # y downward on paper; centre is (30,28), corresponding world Z260.
  body+=f'<path d="M{30+sx*12} {28-sz*12}L{30+sx*17} {28-sz*17}" stroke-width="2.4" stroke-linecap="round" stroke="#7babb6"/>'
  body+=cross(30+sx*16,28-sz*16,2.4)
sheet('camera-hole-check.svg','相机安装面候选孔槽',60,48,body,['背板60×48；默认方孔距32，槽覆盖方孔距24–34。','非方孔距、PCB过大或元件顶住时，改参数后再打印。','相机不是40方/32孔距通用件；不能凭此图给PCB钻孔。'])
body='<rect width="56" height="68"/><rect x="14.4" y="13.2" width="20.9" height="42.3" stroke-dasharray="1 1"/>'
for x in [19.45,30.25]:
 for y in [10.5,58.2]:body+=cross(x,y,3.4)
sheet('servo-ear-check.svg','舵机耳孔纸样',56,68,body,['外框为打印架底面包络；实测舵机安装耳对孔。','候选孔距X10.8、Y47.7；横向长槽有小范围余量。','轴心到承托面差名义12；不符时改支架高度。'])
print('Four 1:1 SVG templates generated')
