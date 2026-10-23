import html,math
C = {'ink':'#223d38','muted':'#62736e','line':'#b8c7c1','alu':'#b8c8d0','frame':'#30353b','wood':'#d5b58a','pp':'#69b6a0','blue':'#6b9abb','orange':'#cb8351','ghost':'#e8eeeb'}
def esc(x): return html.escape(str(x),quote=True)
def text(x,y,s,size=17,fill=None,anchor='start',bold=False):
    return f'<text x="{x:.2f}" y="{y:.2f}" font-size="{size}" fill="{fill or C["ink"]}" text-anchor="{anchor}" font-weight="{650 if bold else 400}">{esc(s)}</text>'
def lines(x,y,ss,size=17,step=27,fill=None):return ''.join(text(x,y+i*step,s,size,fill) for i,s in enumerate(ss))
def line(x1,y1,x2,y2,color=None,dash=False,width=1.5):return f'<path d="M{x1:.2f},{y1:.2f} L{x2:.2f},{y2:.2f}" fill="none" stroke="{color or C["line"]}" stroke-width="{width}"'+(' stroke-dasharray="6 5"' if dash else '')+'/>'
def rect(x,y,w,h,fill='none',stroke=None,rx=0):return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" stroke="{stroke or C["ink"]}" stroke-width="1.3"/>'
def circle(x,y,r=5,fill='white'):return f'<circle cx="{x}" cy="{y}" r="{r}" fill="{fill}" stroke="{C["ink"]}" stroke-width="1.3"/>'
def poly(pts,fill,opacity=1):return f'<polygon points="'+ ' '.join(f'{x:.2f},{y:.2f}' for x,y in pts)+f'" fill="{fill}" fill-opacity="{opacity}" stroke="{C["ink"]}" stroke-width="1.15" stroke-linejoin="round"/>'
def dim(x1,y1,x2,y2,label,dy=0):
    dx=x2-x1; yy=y2-y1; n=math.hypot(dx,yy); nx=-yy/n*5;ny=dx/n*5
    return line(x1,y1,x2,y2,C['orange'])+line(x1-nx,y1-ny,x1+nx,y1+ny,C['orange'])+line(x2-nx,y2-ny,x2+nx,y2+ny,C['orange'])+text((x1+x2)/2,(y1+y2)/2-8+dy,label,16,C['orange'],'middle',True)
def table(x,y,width,heads,rows,colwidths=None,rowh=31,size=15):
    cols=colwidths or [width/len(heads)]*len(heads);out=rect(x,y,width,rowh,'#edf3ef',C['line'])
    for i,h in enumerate(heads):out+=text(x+sum(cols[:i])+9,y+22,h,size,bold=True)
    for r,row in enumerate(rows):
        yy=y+(r+1)*rowh;out+=line(x,yy,x+width,yy)
        for i,val in enumerate(row):out+=text(x+sum(cols[:i])+9,yy+22,val,size)
    return out+line(x,y+(len(rows)+1)*rowh,x+width,y+(len(rows)+1)*rowh)
def sheet(title,subtitle,content,num):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="1400" height="960" viewBox="0 0 1400 960" role="img" aria-label="{esc(title)}"><style>text{{font-family:Arial,"PingFang SC","Microsoft YaHei",sans-serif}}.pick{{cursor:pointer}}.pick:hover polygon{{stroke:#00876b;stroke-width:3}}</style><rect width="1400" height="960" fill="#fffefa"/>{text(32,34,'BEANLENS  /  HACKATHON H1 /  2026-10-19',13,C['muted'],bold=True)}{text(32,77,title,30,bold=True)}{text(32,108,subtitle,16,C['muted'])}{line(32,127,1368,127)}{content}{line(32,916,1368,916)}{text(32,942,'单位 mm · 尺寸为设计/布局提案，非孔位加工图；未知元件只画安装占位。按标注尺寸，不量屏幕或缩印图。',13,C['muted'])}{text(1368,942,f'{num:02d} / 6',13,C['muted'],'end')}</svg>'''

