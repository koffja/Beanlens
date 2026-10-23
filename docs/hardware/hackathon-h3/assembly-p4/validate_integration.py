from pathlib import Path
import ast,csv,hashlib,importlib.util,json,math
from collections import Counter
import xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parent;PROJECT=ROOT.parents[3]
checks=[]
def check(name,passed,detail=None):checks.append({'name':name,'pass':bool(passed),'detail':detail});assert passed,(name,detail)
preserved=json.loads((ROOT/'previous-preserved.json').read_text())
for file,sha in preserved.items():check('preserved_'+file,hashlib.sha256((PROJECT/file).read_bytes()).hexdigest()==sha)
D=json.loads((ROOT/'assembly-data.json').read_text());B=json.loads((ROOT/'bom-p4.json').read_text());bd={b['id']:b for b in B};byid={p['id']:p for p in D['parts']}
G=json.loads((ROOT/'geometry-check.json').read_text());check('all_181_CAD_checks',len(G['checks'])==181 and all(c['pass'] for c in G['checks']) and not G['clashes'])
check('nine_prints',len([p for p in D['parts'] if p['material']=='print'])==9 and sum(b['installed_qty'] for b in B if b['kind']=='3D打印')==9)
check('five_wooden_parts',len([p for p in D['parts'] if p['material']=='wood'])==5)
lengths=Counter(round(max(p['bounds'][i+3]-p['bounds'][i] for i in range(3))) for p in D['parts'] if p['material']=='profile')
check('13_profile_segments',lengths=={460:4,200:4,180:5},dict(lengths))
check('profile_no_purchase',bd['H14']['procurement_basis_qty']==0 and bd['P28']['included_in']=='H14' and bd['P28']['procurement_basis_qty']==0)
check('stock_kerf_balance',7*460+2*400-(4*460+4*200+5*180)-9*3==3*74+14+217)
check('unique_BOM_ids',len(bd)==len(B)==78)
check('all_scene_BOM_ids_exist',all(p['bom'] in bd for p in D['parts']))
for j in D['joints']:check(j['id']+'_part_links',all(id in byid for id in j['parts']))
for key,qty in D['hardware_counts'].items():check(key+'_BOM_total',bd['K-'+key]['installed_qty']==qty)
m3=sum(v for k,v in D['hardware_counts'].items() if k.startswith('M3'));m5=sum(v for k,v in D['hardware_counts'].items() if k.startswith('M5'))
check('M3_nuts_washers',m3==79 and bd['K-M3-N']['installed_qty']==m3 and bd['K-M3-W']['installed_qty']==2*m3)
check('M5_slot_nuts_washers',m5==60 and bd['K-M5-T']['installed_qty']==m5 and bd['K-M5-W']['installed_qty']==m5)
check('no_old_camera_brackets_or_welded_hoppers',not any(id in bd for id in ['H18','H34','H40','H30']))
check('M2_camera_sets',bd['K-M2x5']['installed_qty']==bd['K-M2x8']['installed_qty']==bd['P36']['installed_qty']==8)
base=json.loads((PROJECT/'config/hardware-hackathon-h3.json').read_text());current=json.loads((PROJECT/'config/hardware-hackathon-h3-p4.json').read_text())
for key in ['pins','power','board','schematic','scope','capture','cameras','servo_pulse_us','timing_ms']:check('unchanged_electrical_'+key,base[key]==current[key])
for p in ROOT.glob('*.py'):ast.parse(p.read_text())
check('python_parse',True)
for p in (ROOT/'templates').glob('*.svg'):
    s=ET.parse(p).getroot();check(p.name+'_mm',s.get('width','').endswith('mm') and s.get('height','').endswith('mm'))
# Directly test independent paper-template hole coordinates against the BRep bores.
spec=importlib.util.spec_from_file_location('assembly_validation',ROOT/'build_assembly.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);m.build()
for n,r in enumerate(csv.DictReader((ROOT/'hole-patterns-p4.csv').open(encoding='utf-8-sig')),1):
    id=r['part'];x=float(r['svg_local_x_mm']);y=float(r['svg_local_y_mm']);radius=float(r['diameter_mm'])/2-.04
    tests=[]
    if id in ['W01','W02','C01']:
        z,h={'W01':(22,6),'W02':(180,6),'C01':(440,3)}[id];tests=[(id,[x+22,y+22,z],[0,0,1],h)]
    elif id in ['W04','W05']:tests=[(id,[x+22,y+(2 if id=='W04' else 208),234],[0,0,1],6)]
    elif id=='W03':tests=[(id,[x+22,20,422-y],[0,1,0],6)]
    elif id=='C02-C03':tests=[('C02',[x+85,y+95,321],[0,0,1],3),('C03',[x+85,y+95,326.3],[0,0,1],3)]
    elif id=='H36':tests=[(id,[x+95.3,y+108,324],[0,0,1],2)]
    elif id=='F-flat':tests=[('F01',[x,y+50,438],[0,0,1],2)]
    elif id=='BOX-clip':tests=[('BCL1',[x+68,-2,356-y],[0,1,0],2)]
    elif id.startswith('SH-'):tests=[(id,[62 if id=='SH-L' else 176,x+22,310-y],[1,0,0],2)]
    elif id.startswith('BG-'):tests=[(id,[x+65,28 if id=='BG-F' else 210,292-y],[0,1,0],2)]
    check('template_%d_known'%n,bool(tests))
    for sid,p,d,h in tests:check('template_%d_%s_real_bore'%(n,sid),m.cylinder(p,d,radius,h).intersect(m.solids[sid]).val().Volume()<1e-5)
browser=json.loads((ROOT/'browser-check.json').read_text());check('all_browser_checks',len(browser['checks'])==25 and all(c['pass'] for c in browser['checks']) and not browser['errors'] and not browser['network'])
pdf=json.loads((ROOT/'pdf-layout-check.json').read_text());check('PDF_layout',pdf['pages']==10 and not pdf['DOMOverflow'])
(ROOT/'validation-p4.json').write_text(json.dumps({'revision':'H3-P4','host_only':True,'printed_or_fitted':False,'checks':checks,'old_files_preserved':len(preserved),'summary':{'BOM_rows':len(B),'printed':9,'joints':14,'CAD_checks':181,'browser_checks':25,'templates':18,'M3_screws':m3,'M5_screws':m5}},ensure_ascii=False,indent=2)+'\n')
print(json.dumps({'checks':len(checks),'old_preserved':len(preserved),'all_pass':True}))
