"""Artifact consistency checks, not bench or physical validation."""
from pathlib import Path
import json,math,re,xml.etree.ElementTree as ET
from urllib.parse import unquote,urlsplit
ROOT=Path(__file__).resolve().parent;REPO=ROOT.parents[2]
d=json.loads((ROOT/'design-v4.9.json').read_text());g=d['hopper'];p=d['power']
b=json.loads((REPO/'config/hardware-baseline.json').read_text())
bom=json.loads((ROOT.parent/'procurement-v4.9/beanlens-bom-v4.9.json').read_text())
rows={r['id']:r for r in bom['items']};checks=[]
def check(name,truth):
 checks.append({'check':name,'passed':bool(truth)})
 if not truth:raise AssertionError(name)
check('Unique BOM IDs',len(rows)==len(bom['items'])==107)
check('Unknown purchase prices remain unknown',all(rows[x]['price_cny'] is None for x in ['A07','A08','A17','P05','P11','F18','G12']))
check('Removed middle coupling not ordered',rows['F14']['qty']==0)
check('Two terminal blocks; two TB-A-only bridge segments',rows['P05']['qty']==2 and rows['P16']['qty']==2 and p['TB_A_bridges']==[[1,2,3],[4,5,6]] and p['TB_B_bridges']==[])
check('Bucks and sensors are not assigned to 24V GPIO',b['power']['logic_v']==5 and b['power']['servo_v']==6 and b['power']['io_v']==3.3)
check('Controller PWM stays GPIO2',p['gpio_pwm']==2)
check('Power continuous sum',math.isclose(5*4/.8+6*3/.8+8+1,p['continuous_w']))
check('Power short peak sum',math.isclose(5*4/.8+6*5/.8+8+1,p['short_peak_w']))
check('Input fuse map matches baseline',b['power']['fuses_input_side_a']==p['fuses_input_side_a'])
check('Window total active width',5*14+4*3==82 and len(g['windows_x_mm'])==5)
check('Window X and Y within lower seat',all(40<=x and x+14<=180 for x in g['windows_x_mm']) and 111<=114 and 126<=129)
check('Lower seat misses rail Y132+',g['lower_seat_xyz_mm'][1]+g['lower_seat_size_mm'][1]<132)
check('Gate nominal clearance',math.isclose(g['gate_gap_z_mm'][1]-g['gate_gap_z_mm'][0]-g['gate_thickness_mm'],.3))
check('Upper seat and continuous hopper meet',math.isclose(g['upper_seat_xyz_mm'][2]+6,g['bottom_z_mm']))
check('Hopper normal thickness creates larger outer dimensions',all(a>b for a,b in zip(g['top_outer_wh_mm'],g['top_inner_wh_mm'])))
check('Screen clearance kept positive',min(g['screen_clearance_mm'].values())>14)
check('Hopper volume independent numerical integration',math.isclose(sum((136-54*(i+.5)/10000)*(136-124*(i+.5)/10000)*141.7/10000/1e6 for i in range(10000)),g['nominal_volume_l'],rel_tol=1e-8))
check('Baseline uses new bottom and two solid seats',b['mechanics_reference']['hopper_reference']['pp_bottom_inner_mm']==[82,12] and b['mechanics_reference']['lane_reference']['lower_comb_z']==[])
missing=[];local=0
for f in [ROOT/'beanlens-power-and-feed-v4.9.html',ROOT.parent/'procurement-v4.9/beanlens-procurement-v4.9.html']:
 for link in re.findall(r'(?:href|src)="([^"]+)"',f.read_text()):
  if link.startswith(('http:','https:','data:','#')):continue
  local+=1
  if not (f.parent/unquote(urlsplit(link).path)).resolve().exists():missing.append((str(f),link))
check(f'Local artifact links ({local}) resolve',not missing)
for s in ROOT.glob('0*.svg'):ET.parse(s)
check('Four SVGs parse',len(list(ROOT.glob('0*.svg')))==4)
report={'date':'2026-10-16','checks':checks,'count':len(checks),'missing_links':missing,
 'not_validated':['electrical load / thermal / connector samples','weld shrinkage / flatness','linkage ear / rear guard / optical beam collision','real bean capacity / bridging / weighing']}
(ROOT/'validation-20261016.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(f'{len(checks)} artifact consistency checks passed. Physical/electrical validation pending.')
