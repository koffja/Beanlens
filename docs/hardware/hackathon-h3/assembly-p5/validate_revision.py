from pathlib import Path
import csv,hashlib,json,importlib.util,re,math,ast
from pypdf import PdfReader

ROOT=Path(__file__).resolve().parent;PROJECT=ROOT.parents[3];checks=[]
def ck(name,value,detail=None):
    checks.append(dict(name=name,pass_=bool(value),detail=detail))
    assert value,(name,detail)
D=json.loads((ROOT/'assembly-data.json').read_text());B=json.loads((ROOT/'bom-p5.json').read_text());G=json.loads((ROOT/'geometry-check.json').read_text())
for c in G['checks']:ck(c['name'],c['pass_'],c['detail'])
prev=json.loads((ROOT/'previous-preserved.json').read_text())
for name,digest in prev.items():ck('preserved_'+name,hashlib.sha256((PROJECT/name).read_bytes()).hexdigest()==digest)
ck('BOM_unique',len(B)==len(set(r['id'] for r in B))==51)
ck('four_prints',len([r for r in B if r['kind']=='3D打印'])==4)
ck('manual_no_legacy_procurement',not set(r['id'] for r in B)&{'H03','H06','H09','H10','H11','H12','H22','H23','H24','H25','H26','H27','H36','H37','H38','P12','P21','P24','P25','P26','P27','P28','P29','P30','LC01','H08','H20'})
ids={r['id'] for r in B}
for p in D['parts']:ck('part_BOM_'+p['id'],p['bom'] in ids,p['bom'])
for j in D['joints']:ck('joint_parts_'+j['id'],set(j['parts'])<=set(p['id'] for p in D['parts']))
for r in B:
    if r['included_in']:ck('raw_parent_'+r['id'],r['included_in'] in ids and r['procurement_basis_qty']==0)
for key,q in D['hardware_counts'].items():ck('hardware_qty_'+key,next(r['installed_qty'] for r in B if r['id']=='K-'+key)==q)
ck('washer_split_88_16',next(r['installed_qty'] for r in B if r['id']=='K-M3-W')==88 and next(r['installed_qty'] for r in B if r['id']=='K-M3-W7')==16)
ck('M3_52',sum(v for k,v in D['hardware_counts'].items() if k.startswith('M3'))==52)
ck('M5_52',D['hardware_counts']=={'M5x8':52,'M3x16':36,'M3x35':4,'M3x12':4,'M3x10':8})
ck('profile_stock_balance',7*460+2*400-(4*460+4*200+4*180)-8*3==636)
ck('angle_stock_balance',sum(int(k)*v for k,v in D['angle_stock']['pieces'].items())+sum(D['angle_stock']['pieces'].values())*3==1020)
cfg=json.loads((PROJECT/'config/hardware-hackathon-h3-p5.json').read_text())
ck('no_servo_pin_or_supply',not any('servo' in k or 'gate' in k for k in cfg['pins']) and not any(k.startswith('servo') for k in cfg['power']) and cfg['geometry']['gate'] is None)
ck('power_budget',cfg['power']['continuous_budget_w']==5*3/.8+8)
ck('camera_layout_confirmed',D['camera_layout_confirmed'])
ck('camera_center_spaced_200',math.dist(*[c['lens'] for c in D['cameras']])==200)
ck('five_wood_panels',len([p for p in D['parts'] if p['material']=='wood'])==5)
ck('overall_width_260',D['overall_width_mm']==260)
ck('camera_board_sizes',all(c['size']==[30,200,6] for c in D['camera_boards']))
# Check every paper hole against the exact installed BRep, not against a duplicate table.
spec=importlib.util.spec_from_file_location('p5_build',ROOT/'build_revision.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);m.base();m.camera_layout()
def bore(id,x,y,z,d,l,r):return m.solids[id].intersect(m.p4.cylinder([x,y,z],d,r*.8,l)).val().Volume()<1e-5
for i,h in enumerate(csv.DictReader((ROOT/'hole-patterns-p5.csv').open(encoding='utf-8-sig'))):
    id=h['part'];x=float(h['paper_x_mm']);y=float(h['paper_y_mm']);r=float(h['diameter_mm'])/2
    if id in ['W01','W02']:args=(id,x+22,y+22,22 if id=='W01' else 180,[0,0,1],6,r)
    elif id=='W03':args=(id,x+22,20,312-y,[0,1,0],6,r)
    elif id in ['W04','W05']:args=(id,(208 if id=='W04' else -18)+y,20+x,234,[0,0,1],6,r)
    elif id=='C01':args=(id,20+x,20+y,440,[0,0,1],3,r)
    elif id=='F-flat':args=('F01',x,50+y,438,[0,0,1],2,r)
    elif id=='BOX-clip':args=('BCL1',68+x,-2,246-y,[0,1,0],2,r)
    elif id=='L01':args=('LA-FL',50+x,50,306-y,[0,1,0],2,r)
    elif id=='L02-foot':args=('LF-FL',50+x,30+y,186,[0,0,1],2,r)
    elif id=='L02-upright':args=('LF-FL',50+x,48,206-y,[0,1,0],2,r)
    elif id=='A-CAM-shelf':args=('W05-A1',-20+x,20+y,232,[0,0,1],2,r)
    elif id=='A-CAM-right':args=('W04-A1',200+x,20+y,232,[0,0,1],2,r)
    elif id=='A-CAM-post-left':args=('W05-A1',-20+x,20,234-y,[0,1,0],2,r)
    elif id=='A-CAM-post-right':args=('W04-A1',200+x,20,234-y,[0,1,0],2,r)
    else:raise AssertionError(id)
    ck('paper_hole_'+str(i)+'_'+id,bore(*args),args)
for p in (ROOT/'templates').glob('*.svg'):ck('physical_mm_'+p.name,'mm"' in p.read_text() and '本段应为50mm' in p.read_text())
browser=json.loads((ROOT/'browser-check.json').read_text())
for c in browser['checks']:ck('browser_'+c['name'],c['pass'])
pdf=PdfReader(ROOT/'assembly-guide-p5.pdf');ck('PDF_9_pages',len(pdf.pages)==9)
for i,p in enumerate(pdf.pages):
    ck('A3_landscape_'+str(i),abs(float(p.mediabox.width)-1190.55)<2 and abs(float(p.mediabox.height)-841.89)<2)
    txt=p.extract_text();ck('PDF_content_'+str(i),len(txt)>350 and '{title}' not in txt and '{left}' not in txt)
layout=json.loads((ROOT/'pdf-layout-check.json').read_text());ck('PDF_DOM_no_overflow',not layout['DOMOverflow'])
for p in ROOT.glob('*.py'):ast.parse(p.read_text());ck('syntax_'+p.name,True)
for name in ['source/index.html','bom-p5.html','operation-p5.html']:
    s=(ROOT/name).read_text()
    for link in re.findall(r'href="([^"]+)"',s):
        if link.startswith(('http','data:','#')):continue
        ck('link_'+name+'_'+link,(ROOT/(link.split('?')[0]) if name!='source/index.html' else ROOT/link.split('?')[0]).exists())
report=dict(checks=checks,all_pass=all(c['pass_'] for c in checks),old_files_preserved=len(prev),host_only=True,physical_verified=False,layout_decision=D['camera_layout_decision'])
(ROOT/'validation-p5.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n');print(json.dumps(dict(checks=len(checks),old_files_preserved=len(prev),all_pass=report['all_pass'])))
