from pathlib import Path
import csv,hashlib,json,importlib.util,re,math,ast
from pypdf import PdfReader

ROOT=Path(__file__).resolve().parent;PROJECT=ROOT.parents[3];checks=[]
def ck(name,value,detail=None):
    checks.append(dict(name=name,pass_=bool(value),detail=detail))
    assert value,(name,detail)
D=json.loads((ROOT/'assembly-data.json').read_text());B=json.loads((ROOT/'bom-p7.json').read_text());G=json.loads((ROOT/'geometry-check.json').read_text())
for c in G['checks']:ck(c['name'],c['pass_'],c['detail'])
prev=json.loads((ROOT/'previous-preserved.json').read_text())
for name,digest in prev.items():ck('preserved_'+name,hashlib.sha256((PROJECT/name).read_bytes()).hexdigest()==digest)
ck('BOM_unique',len(B)==len(set(r['id'] for r in B))==53)
ck('two_prints',len([r for r in B if r['kind']=='3D打印'])==2)
ck('manual_no_legacy_procurement',not set(r['id'] for r in B)&{'H03','H06','H09','H10','H11','H12','H22','H23','H24','H25','H26','H27','H36','H37','H38','P12','P21','P24','P25','P26','P27','P28','P29','P30','LC01','H08','P22','P23','P36','K-M2x5','K-M2x8','K-M2-W','SH-T'})
ids={r['id'] for r in B}
for p in D['parts']:ck('part_BOM_'+p['id'],p['bom'] in ids,p['bom'])
for j in D['joints']:ck('joint_parts_'+j['id'],set(j['parts'])<=set(p['id'] for p in D['parts']))
for r in B:
    if r['included_in']:ck('raw_parent_'+r['id'],r['included_in'] in ids and r['procurement_basis_qty']==0)
for key,q in D['hardware_counts'].items():ck('hardware_qty_'+key,next(r['installed_qty'] for r in B if r['id']=='K-'+key)==q)
ck('washer_split_112_16',next(r['installed_qty'] for r in B if r['id']=='K-M3-W')==112 and next(r['installed_qty'] for r in B if r['id']=='K-M3-W7')==16)
ck('M3_64',sum(v for k,v in D['hardware_counts'].items() if k.startswith('M3'))==64)
ck('M5_52',D['hardware_counts']=={'M5x8':44,'M3x16':28,'M3x35':4,'M5x14':4,'M5x12':4,'M3x10':32})
ck('profile_stock_balance',7*460+2*400-(4*460+4*200+4*180)-8*3==636)
ck('angle_stock_balance',sum(int(k)*v for k,v in D['angle_stock']['pieces'].items())+sum(D['angle_stock']['pieces'].values())*3==1204)
cfg=json.loads((PROJECT/'config/hardware-hackathon-h3-p7.json').read_text())
ck('no_servo_pin_or_supply',not any('servo' in k or 'gate' in k for k in cfg['pins']) and not any(k.startswith('servo') for k in cfg['power']) and cfg['geometry']['gate'] is None)
ck('power_budget',cfg['power']['continuous_budget_w']==5*2/.8+8)
ck('camera_layout_confirmed',D['camera_layout_confirmed'])
ck('camera_center_spaced_110_4',abs(math.dist(*[c['lens'] for c in D['cameras']])-110.4)<1e-6)
ck('six_wood_panels',len([p for p in D['parts'] if p['material']=='wood'])==6)
ck('overall_width_220',D['overall_width_mm']==220)
ck('camera_board_sizes',all(c['size']==[40,200,6] for c in D['camera_boards']))
# Check every paper hole against the exact installed BRep, not against a duplicate table.
spec=importlib.util.spec_from_file_location('p5_build',ROOT/'build_revision.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);m.base();m.camera_layout();m.shields()
def bore(id,x,y,z,d,l,r):return m.solids[id].intersect(m.p4.cylinder([x,y,z],d,r*.8,l)).val().Volume()<1e-5
for i,h in enumerate(csv.DictReader((ROOT/'hole-patterns-p7.csv').open(encoding='utf-8-sig'))):
    id=h['part'];x=float(h['paper_x_mm']);y=float(h['paper_y_mm']);r=float(h['diameter_mm'])/2
    if id in ['W01','W02','W06']:args=(id,x,y,{'W01':22,'W02':180,'W06':460}[id],[0,0,1],6,r)
    elif id=='W03':args=(id,x+22,20,440-y,[0,1,0],6,r)
    elif id in ['W04','W05']:args=(id,(180 if id=='W04' else 0)+y,20+x,234,[0,0,1],6,r)
    elif id in ['SH-L','SH-R']:args=(id,48 if id=='SH-L' else 170,44+x,332-y,[1,0,0],2,r)
    elif id in ['SH-F','SH-B']:args=(id,50+x,44 if id=='SH-F' else 194,332-y,[0,1,0],2,r)
    elif id in ['SH-T','SH-D']:args=(id,(50 if id=='SH-T' else 52)+x,46+y,332 if id=='SH-T' else 222,[0,0,1],2,r)
    elif id=='N03':args=('BP1',40+x,y,20,[0,0,1],2,r)
    elif id=='BOX-clip':args=('BCL1',68+x,-2,374-y,[0,1,0],2,r)
    elif id=='L01-front':args=('LA-FL',50+x,50,306-y,[0,1,0],2,r)
    elif id=='L01-return':args=('LA-FL',50,50+x,306-y,[1,0,0],2,r)
    elif id=='L02-foot':args=('LF-FL',50+x,30+y,186,[0,0,1],2,r)
    elif id=='L02-upright':args=('LF-FL',50+x,48,206-y,[0,1,0],2,r)
    elif id=='A-CAM-left':args=('W05-A1',x,20+y,232,[0,0,1],2,r)
    elif id=='A-CAM-right':args=('W04-A1',180+x,20+y,232,[0,0,1],2,r)
    elif id=='A-CAM-post-left':args=('W05-A1',x,20,234-y,[0,1,0],2,r)
    elif id=='A-CAM-post-right':args=('W04-A1',180+x,20,234-y,[0,1,0],2,r)
    elif id=='S10':args=('SC-FL',50+x,46,328-y,[0,1,0],2,r)
    else:raise AssertionError(id)
    ck('paper_hole_'+str(i)+'_'+id,bore(*args),args)
for p in (ROOT/'templates').glob('*.svg'):ck('physical_mm_'+p.name,'mm"' in p.read_text() and '本段应为50mm' in p.read_text())
browser=json.loads((ROOT/'browser-check.json').read_text())
for c in browser['checks']:ck('browser_'+c['name'],c['pass'])
pdf=PdfReader(ROOT/'assembly-guide-p7.pdf');ck('PDF_11_pages',len(pdf.pages)==11)
for i,p in enumerate(pdf.pages):
    ck('A3_landscape_'+str(i),abs(float(p.mediabox.width)-1190.55)<2 and abs(float(p.mediabox.height)-841.89)<2)
    txt=p.extract_text();ck('PDF_content_'+str(i),len(txt)>350 and '{title}' not in txt and '{left}' not in txt)
layout=json.loads((ROOT/'pdf-layout-check.json').read_text());ck('PDF_DOM_no_overflow',not layout['DOMOverflow'])
for p in ROOT.glob('*.py'):ast.parse(p.read_text());ck('syntax_'+p.name,True)
for name in ['source/index.html','bom-p7.html','operation-p7.html','power-j7-p7.html']:
    s=(ROOT/name).read_text()
    for link in re.findall(r'href="([^"]+)"',s):
        if link.startswith(('http','data:','#')):continue
        ck('link_'+name+'_'+link,(ROOT/(link.split('?')[0]) if name!='source/index.html' else ROOT/link.split('?')[0]).exists())
a4=PdfReader(ROOT/'templates-a4-p7.pdf');ck('A4_six_halves',len(a4.pages)==6)
for i,p in enumerate(a4.pages):ck('A4_portrait_'+str(i),abs(float(p.mediabox.width)-595.28)<2 and abs(float(p.mediabox.height)-841.89)<2)
ck('J7_pin_map',cfg['power']['logic_connection']['pin_1']=='GND' and cfg['power']['logic_connection']['pin_2'].startswith('VCC_5V') and cfg['power']['logic_connection']['schematic_verified'])
for id in ['W01','W02','W06']:
    p=next(p for p in D['parts'] if p['id']==id);ck('wood_240_220_'+id,all(abs(p['bounds'][i+3]-p['bounds'][i]-v)<1e-6 for i,v in enumerate([220,240,6])))
ck('five_shield_panels',len([p for p in D['parts'] if p['material']=='shield'])==5)
parts_by_id={p['id']:p for p in D['parts']}
ck('no_camera_print_or_roof',not {'P22','P23','SH-T'}&set(parts_by_id))
ck('no_roof_supports',not any(id.startswith('SA-T') for id in parts_by_id))
ck('four_glue_fillets',len([p for p in D['parts'] if p['material']=='adhesive'])==4)
ck('wood_and_support_inside_frame',all(p['bounds'][0]>=-1e-6 and p['bounds'][3]<=220+1e-6 for p in D['parts'] if p['system']=='camera' and p['material'] in ['wood','aluminum']))
ck('box_top_aligned_to_frame_underside',parts_by_id['W03']['bounds'][2]==352 and parts_by_id['W03']['bounds'][5]==440)
ck('box_upper_brackets_lowered_for_corner_clearance',all(parts_by_id[id]['bounds'][5]==404 for id in ['A11','A12']))
for id in ['H02-A','H02-B']:
    ck('camera_PCB_vertical_'+id,abs(parts_by_id[id]['bounds'][3]-parts_by_id[id]['bounds'][0]-1.4)<1e-6 and parts_by_id[id]['bounds'][2]==240)
for path in D['cable_routes']:
    ck('cable_reference_below_200_'+path['id'],path['polyline_length_mm']<200 and path['interface_positions_verified'] is False)
ck('53_BOM_rows_config_consistent',cfg['mechanical_revision']['printed_parts']==['P11','P13'] and cfg['mechanical_revision']['shield_panels']==5)
ck('camera_glue_diagram_exists',(ROOT/'camera-glue-p7.svg').exists())
source=json.loads((ROOT/'references/source-check.json').read_text());ck('original_schematic_hash',hashlib.sha256((ROOT/'references/ATK-DNK230D-V1.0.pdf').read_bytes()).hexdigest()==source['sha256']=='caa406fe42535de36d8d51b1cd3158c917569eb2748673e40780465272636a27')
report=dict(checks=checks,all_pass=all(c['pass_'] for c in checks),old_files_preserved=len(prev),host_only=True,physical_verified=False,layout_decision=D['camera_layout_decision'])
(ROOT/'validation-p7.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n');print(json.dumps(dict(checks=len(checks),old_files_preserved=len(prev),all_pass=report['all_pass'])))
