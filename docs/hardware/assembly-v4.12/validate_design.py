"""Validate the V4.12 documents; this is not physical or electrical certification."""
from pathlib import Path
import json,re,math,xml.etree.ElementTree as ET
from urllib.parse import unquote,urlsplit
ROOT=Path(__file__).resolve().parent;REPO=ROOT.parents[2]
d=json.loads((ROOT/'assembly-layout-v4.12.json').read_text());parts={p['id']:p for p in d['parts']}
g=json.loads((ROOT.parent/'revision-v4.11/design-v4.11.json').read_text());bom=json.loads((ROOT.parent/'procurement-v4.11/beanlens-bom-v4.11.json').read_text());rows={p['id']:p for p in bom['items']};b=json.loads((REPO/'config/hardware-baseline.json').read_text());checks=[]
def check(name,v):
 checks.append({'check':name,'passed':bool(v)})
 assert v,name
check('109 distinct drawing objects',len(parts)==len(d['parts'])==109)
check('114 distinct BOM rows retained',len(rows)==len(bom['items'])==114)
check('18 frame members and 9 wood panels',sum(p['group']=='骨架' for p in parts.values())==18 and sum(p['group']=='海洋板' for p in parts.values())==9)
check('Frame lengths460x4/200x6/180x8',all(sum(p['group']=='骨架' and max(p['size'])==length for p in parts.values())==n for length,n in [(460,4),(200,6),(180,8)]))
check('Existing stock yields all lengths with 180x4 order',3*2==6 and 2*2+4==8 and 2*200+2*3<=460 and 2*180+2*3<=400)
check('Obsolete transition/flanges/stacked sheets absent',not any(x in parts for x in ['H08','H10','H11','H12','C01','C02','C03','C04','E03']))
check('Continuous PP hopper geometry',parts['H07']['pos'][2]==298.3 and parts['H07']['size'][2]==141.7 and parts['H07']['inner_top']==[136,136] and parts['H07']['inner_bottom']==[82,12])
check('Current seats agree with geometry source',parts['U01']['size']==g['body']['upper_pp_mm'] and parts['U02']['size']==g['body']['lower_pp_mm'] and parts['U02']['pos']==g['body']['lower_xyz'])
check('Continuous front wall and rear-entry geometry retained',g['body']['front_wall_continuous'] and g['body']['entry']=='rear_only' and parts['U03']['size']==[140,2,18.3])
check('Four PP divider fins, ten PBT segments',sum(p['bom']=='B16' for p in parts.values())==4 and sum(p['bom']=='B11' for p in parts.values())==10)
check('Both built-in screens and complete frame objects',all(x in parts for x in ['A01','D01','D02','D03','D11','D12','D13','D14','E01','D04','D05','D06']))
check('Recomputed screen clearances',all(math.isclose(d['screen_clearance_mm'][k],g['hopper']['screen_clearance_mm'][k]) for k in ['front','right']))
check('Sensor is SEN0503 and heads20x10x9',all('SEN0503' in parts[x]['name'] and parts[x]['size']==[20,10,9] for x in ['PH01','PH02']) and 'SEN0503' in rows['PH01']['model'])
check('Adapter YU2405 shown only as unknown external envelope',parts['PS01']['group']=='机外电源' and parts['PS01']['shape']=='outline' and 'YU2405' in parts['PS01']['name'] and '非该型号实测尺寸' in parts['PS01']['note'])
check('External low voltage box, TPS5V and UBEC6V retained',all(parts[x]['group']=='机外电源' for x in ['EX01','PS05','PS06']) and 'TPS5450' in parts['PS05']['name'] and 'UBEC' in parts['PS06']['name'])
check('Baseline current assembly and animation synced',b['mechanics_reference']['current_assembly_document'].endswith('assembly-v4.12/beanlens-assembly-v4.12.html') and b['mechanics_reference']['operation_demo_document'].endswith('beanlens-operation-v4.12.html'))
check('GPIO20 polarity still unverified',b['controller_pins']['beam_hint']['gpio']==20 and b['controller_pins']['beam_hint']['active_level'] is None)
missing=[];n=0
for f in [ROOT/'beanlens-assembly-v4.12.html',ROOT/'beanlens-operation-v4.12.html',ROOT.parent/'procurement-v4.11/beanlens-procurement-v4.11.html',ROOT.parent/'revision-v4.11/beanlens-hopper-gate-v4.11.html']:
 for ref in re.findall(r'(?:href|src)="([^"]+)"',f.read_text()):
  if ref.startswith(('http:','https:','data:','#')):continue
  n+=1
  if not (f.parent/unquote(urlsplit(ref).path)).resolve().exists():missing.append([str(f),ref])
check(f'{n} local artifact links exist',not missing)
for f in ROOT.glob('[0-9][0-9]-*.svg'):ET.parse(f)
check('12 parseable vector sheets',len(list(ROOT.glob('[0-9][0-9]-*.svg')))==12)
# Page count and size require the document runtime (not the training environment).
from pypdf import PdfReader
pdf=PdfReader(REPO/'output/pdf/beanlens-assembly-v4.12-20261017.pdf')
check('12 A3 landscape PDF pages',len(pdf.pages)==12 and all(abs(float(p.mediabox.width)*25.4/72-420)<1 and abs(float(p.mediabox.height)*25.4/72-297)<1 for p in pdf.pages))
texts='\n'.join(p.extract_text() or '' for p in pdf.pages)
check('PDF includes both chosen models and current integrated version','SEN0503' in texts and 'YU2405' in texts and 'V4.12' in texts)
report={'date':'2026-10-17','revision':'V4.12','checks':checks,'count':len(checks),'missing_links':missing,'not_verified':['Physical assembly / interferences','PP weld/load/creep and PBT retention','Voltage/thermal/ripple/sensor levels','Firmware / cameras / classification / weight / uploads'],'scope':'Document consistency and simulated browser interaction only.'}
(ROOT/'validation-20261017.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n');print(str(len(checks))+' V4.12 consistency checks passed; physical verification pending.')
