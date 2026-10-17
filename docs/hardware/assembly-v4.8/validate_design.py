"""Independent scoped document checks; run with the bundled Python (pypdf available).
This is not actuator, weld, food-contact, load, thermal or weighing validation.
"""
import csv,hashlib,json,math,re
from collections import Counter
from pathlib import Path
from pypdf import PdfReader
from pypdf.generic import ContentStream
ROOT=Path(__file__).resolve().parents[3];HERE=Path(__file__).resolve().parent
D=json.loads((HERE/'design-v4.8.json').read_text());L=json.loads((HERE/'assembly-layout-v4.8.json').read_text());P={p['id']:p for p in L['parts']}
B=json.loads((ROOT/'docs/hardware/procurement-v4.8/beanlens-bom-v4.8.json').read_text());known={v['id'] for v in B['items']}
def overlap(a,b):return all(min(a['pos'][i]+a['size'][i],b['pos'][i]+b['size'][i])-max(a['pos'][i],b['pos'][i])>1e-6 for i in range(3))
f=[p for p in P.values() if p['group']=='骨架'];panels=[p for p in P.values() if p['group']=='海洋板']
assert len(P)==88 and len(f)==18 and len(panels)==9 and len(B['items'])==len(known)==94
assert not any(x in P for x in ['H01','H02','H03','H04','H05','H06'])
assert sum(max(p['size']) for p in f)==4480
for p,q in zip(f,D['parts']):assert p['pos']==q['pos_mm'] and p['size']==q['size_mm']
assert not any(overlap(p,q) for i,p in enumerate(f) for q in f[i+1:])
assert not any(overlap(p,q) for p in panels for q in f)
for p in P.values():
 for s in p['bom'].split(' / '):
  if '–' in s:
   x,y=s.split('–');ids=[f'{x[0]}{n:02d}' for n in range(int(x[1:]),int(y[1:])+1)]
  else:ids=[s]
  assert all(x in known for x in ids),(p['id'],ids)
assert next(x for x in B['items'] if x['id']=='F08')['qty']==0
for i in range(1,5):
 for id in ['G11','G12','C01','C02','C03','C04']:assert not overlap(P['L'+str(i)],P[id]),(i,id)
assert not overlap(P['E03'],P['B12'])
for p in D['enclosure_reference']['wood_cuts']:
 id,w,h,x,y=p;assert min(x,y)>=3 and x+w<=597 and y+h<=597
for i,p in enumerate(D['enclosure_reference']['wood_cuts']):
 for q in D['enclosure_reference']['wood_cuts'][i+1:]:
  _,w,h,x,y=p;_,ww,hh,xx,yy=q;assert x+w+3<=xx or xx+ww+3<=x or y+h+3<=yy or yy+hh+3<=y
assert len(list(csv.reader((HERE/'cut-list-v4.8.csv').open(encoding='utf-8-sig'))))-1==27
windows={}
for id in ['C01','C02','C03','C04','G12']:
 p=P[id];off=3 if id in ['C03','C04'] else 9;windows[id]=[[p['pos'][0]+x,p['pos'][1]+off,14,12] for x in [29,46,63,80,97]]
assert all(v==windows['C01'] for v in windows.values())
assert math.isclose(18.3+24.9+6+.8,50) and math.isclose(P['H10']['pos'][2]+3,330)
assert math.isclose(P['H12']['pos'][2],P['H08']['pos'][2]+P['H08']['size'][2])
assert math.isclose(P['H07']['pos'][2]+110,P['H09']['pos'][2])
assert math.isclose(P['C01']['pos'][2]-(P['G07']['pos'][2]+2),.3)
for name in ['main','transition']:
 gg=D['pp_geometry'][name];kx=(gg['top'][0]-gg['bottom'][0])/2/gg['height'];ky=(gg['top'][1]-gg['bottom'][1])/2/gg['height']
 assert math.isclose(kx,gg['kx']) and math.isclose(ky,gg['ky'])
 assert math.isclose(gg['offset_x_mm'],2*math.hypot(1,kx)) and math.isclose(gg['offset_y_mm'],2*math.hypot(1,ky))
g=D['pp_geometry']['main'];dx,dy=g['offset_x_mm'],g['offset_y_mm'];reserve=4
front=105-53*(402-330)/110-dy-reserve-47
right=188-(165+13*(385-330)/110+dx+reserve)
assert math.isclose(front,D['displays']['BOX']['min_to_weld_envelope_mm']) and front>17
assert math.isclose(right,D['displays']['C6']['min_to_weld_envelope_mm']) and right>10
# Top bracket solid: horizontal foot x20..34/right186..200, vertical legs x20..22/198..200.
assert (110-g['outer_top'][0]/2-reserve)-34>1.9
assert 186-(110+g['outer_top'][0]/2+reserve)>1.9
assert P['H09']['pos'][0]==22 and P['H09']['pos'][0]+176==198
# Coupling bolts and OD7 washers sit outside the conservative welded-bottom bounding rectangle.
for x in [43,177]:
 for y in [93,147]:
  assert (x+3.5<110-g['outer_bottom'][0]/2-reserve or x-3.5>110+g['outer_bottom'][0]/2+reserve) and (y+3.5<120-g['outer_bottom'][1]/2-reserve or y-3.5>120+g['outer_bottom'][1]/2+reserve)
# Check actual generated wedge planes, closed triangulated meshes and signed volumes.
solids=json.loads((ROOT/'docs/hardware/fabrication-v4.8/pp-panel-solids-v4.8.json').read_text())['panels']
for solid in solids:
 id=solid['id'];g=D['pp_geometry']['main' if id.startswith('M') else 'transition'];is_front=id[1]=='A';sign=-1 if id.endswith('2') else 1
 n=[0,-sign,-g['ky']] if is_front else [sign,0,-g['kx']];norm=math.sqrt(sum(v*v for v in n));inner_const=g['bottom'][1 if is_front else 0]/2
 for v in solid['vertices_mm'][:4]:assert abs(sum(n[i]*v[i] for i in range(3))-inner_const)<1e-8
 for v in solid['vertices_mm'][4:]:assert abs((sum(n[i]*v[i] for i in range(3))-inner_const)/norm-2)<1e-8
 stl=(ROOT/f'docs/hardware/fabrication-v4.8/{id}.stl').read_text();vs=[tuple(map(float,v.split())) for v in re.findall(r'vertex ([^\n]+)',stl)];assert len(vs)==36
 edges=Counter()
 for i in range(0,len(vs),3):
  tri=vs[i:i+3]
  for j in range(3):edges[tuple(sorted([tri[j],tri[(j+1)%3]]))]+=1
 assert all(c==2 for c in edges.values()) and solid['volume_mm3']>0
browser=json.loads((HERE/'browser-check-20261016.json').read_text())
assert all(not x['outside'] and not x['overlaps'] for x in browser['sheets'])
assert len(browser['fabricationTemplates'])==8 and not browser['consoleErrors'] and not browser['fabricationLinks']
assert browser['dualScreens']['partsInScreenGroup']==12
pdfs=[]
for name,count,target in [('beanlens-assembly-v4.8-20261016.pdf',10,[420,297]),('beanlens-pp-templates-v4.8-20261016.pdf',8,[210,297])]:
 p=ROOT/'output/pdf'/name;r=PdfReader(p);assert len(r.pages)==count;cal=[];dims=[]
 for pg in r.pages:
  mm=[float(pg.mediabox.width)*25.4/72,float(pg.mediabox.height)*25.4/72];dims.append(mm);assert all(abs(a-b)<.25 for a,b in zip(mm,target));assert 'V4.8' in pg.extract_text() and len(pg.images)==0
  if count==8:
   mat=[1.,0.,0.,1.,0.,0.];stack=[];start=None;found=[]
   def point(x,y):a,b,c,d,e,f=mat;return a*x+c*y+e,b*x+d*y+f
   for args,op in ContentStream(pg.get_contents(),r).operations:
    if op==b'q':stack.append(mat.copy())
    elif op==b'Q':mat=stack.pop()
    elif op==b'cm':
     a,b,c,d,e,f=mat;u,v,w,x,y,z=map(float,args);mat=[a*u+c*v,b*u+d*v,a*w+c*x,b*w+d*x,a*y+c*z+e,b*y+d*z+f]
    elif op==b'm':start=(list(map(float,args)),point(*map(float,args)))
    elif op==b'l' and start and start[0]==[20,279] and list(map(float,args))==[120,279]:found.append(math.dist(start[1],point(*map(float,args)))*25.4/72)
   assert len(found)==1 and abs(found[0]-100)<.02;cal+=found
 pdfs.append({'file':str(p.relative_to(ROOT)),'pages':count,'page_sizes_mm':dims,'calibration_lines_mm':cal,'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'vector_only':True,'visually_reviewed_all_pages':True})
record={'revision':'V4.8','date':'2026-10-16','scope':'scoped document geometry, closed PP meshes, display keepouts, BOM mapping, browser and PDF validation; not hardware','parts':len(P),'BOM_rows_including_historical_and_optional':94,'wood_cuts':9,'profile_members':18,'finished_profile_mm':4480,'cut_csv_rows':27,'closed_pp_solids':8,'normal_thickness_checked_mm':2,'weld_clearance_horizontal_mm':4,'screen_clearance_mm':{'front':front,'right':right},'top_bracket_to_weld_keepout_min_mm':(110-D['pp_geometry']['main']['outer_top'][0]/2-reserve)-34,'coupling_washer_avoids_weld_keepout':True,'shared_layer_height_mm':50,'pdfs':pdfs,'browser':'browser-check-20261016.json','not_verified':['actual welding fusion/shrinkage/food-contact documentation','top flange creep and 1kg load/capacity','actual screen protrusions, plugs, wire bend and antenna clearance','G20 fully enclosed guard interface and actuator sweep/jam response','load cell geometry, optical close focus, thermal and weighing accuracy']}
(HERE/'validation-20261016.json').write_text(json.dumps(record,ensure_ascii=False,indent=2)+'\n')
print('PASS',json.dumps({k:v for k,v in record.items() if k not in ['pdfs','not_verified']},ensure_ascii=False))
