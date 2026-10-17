"""Dimension/selection/link checks; does not certify a physical assembly."""
from pathlib import Path
import json,math,re,xml.etree.ElementTree as ET
from urllib.parse import unquote,urlsplit
ROOT=Path(__file__).resolve().parent;REPO=ROOT.parents[2]
d=json.loads((ROOT/'design-v4.10.json').read_text());g=d['body'];br=d['brush'];p=d['power']
b=json.loads((REPO/'config/hardware-baseline.json').read_text())
bom=json.loads((ROOT.parent/'procurement-v4.10/beanlens-bom-v4.10.json').read_text());rows={r['id']:r for r in bom['items']};checks=[]
def check(name,truth):
 checks.append({'check':name,'passed':bool(truth)})
 if not truth:raise AssertionError(name)
check('114 unique BOM rows',len(rows)==len(bom['items'])==114)
check('5V candidate unknown SKU is not silently frozen',p['generic_board_sku'] is None and not p['continuous_board_rating_verified'] and 'TPS5450' in rows['A08']['model'])
check('6V follows user UBEC choice, not TPS5450','UBEC' in rows['A17']['model'] and '30607000' in rows['A17']['model'] and 'UBEC' in p['servo_buck'] and 'UBEC' in b['power']['servo_buck_candidate'])
check('Factory5A and machine3A target kept distinct',p['servo_module_factory_continuous_a']==5 and p['servo_continuous_a']==3 and b['power']['servo_buck_continuous_target_a']==3)
check('Unknown new prices remain null',all(rows[x]['price_cny'] is None for x in ['A08','A17','B11','B16','B14','B15','G12']))
check('No unjustified power package quote',bom['power_budget_estimate_cny'] is None)
check('Main hopper geometry retained',d['hopper']['top_inner_wh_mm']==[136,136] and d['hopper']['bottom_z_mm']==298.3 and d['hopper']['height_mm']==141.7)
check('Continuous front bridge covers gap',g['front_bridge_xyz'][2]<=g['gap_z'][0] and g['front_bridge_xyz'][2]+g['front_bridge_pp_mm'][2]>=g['gap_z'][1] and g['front_bridge_xyz'][1]+g['front_bridge_pp_mm'][1]==g['lower_xyz'][1]==g['upper_xyz'][1])
check('Fixed PP weldable body and POM separate alternative',rows['G12']['model'].startswith('食品接触资料可核PP-H10') and rows['G22']['selection']=='备选')
check('Gate front closes under landing1.5',math.isclose(g['window_y'][0]-g['gate_xyz_closed'][1],1.5))
check('Open front clears hole1.5',math.isclose(g['gate_xyz_closed'][1]+g['stroke_mm']-g['window_y'][1],1.5))
check('Nominal 2mm gate and0.3 total play',math.isclose(g['gap_z'][1]-g['gap_z'][0]-g['gate_mm'][2],.3))
check('Side cheek clears optical head nominal top282',min(v[2] for v in g['side_cheek_xyz'])>=283)
check('Side cheek still covers gate gap',all(v[2]<=290 and v[2]+g['side_cheek_pp_mm'][2]>=292.3 for v in g['side_cheek_xyz']))
check('Lower seat rear Y129 misses railY132',g['lower_xyz'][1]+g['lower_pp_mm'][1]==129 and 129<132)
check('10 brush segments retained as requested',br['count']==10 and rows['B11']['qty']==10 and rows['B11']['selection']=='主方案')
check('Brush tips clear moving plane',math.isclose(br['tip_z_mm'],br['root_z_mm']-br['free_length_mm']*math.sin(math.radians(br['angle_down_from_horizontal_deg']))) and math.isclose(br['tip_z_mm']-g['gap_z'][1],15.7))
check('Brush ports fit inside each lane',all(x0<=c-br['port_face_size_mm'][0]/2 and c+br['port_face_size_mm'][0]/2<=x0+14 for x0,c in zip(g['window_x'],br['x_centers_mm'])))
ky=62/141.7;normal_proj=2*math.sqrt(1+ky*ky);theta=math.radians(30)
front_root=br['root_y_mm'][0];zroot=br['root_z_mm'];inner_at_root=114-ky*(zroot-298.3)
t_in=(inner_at_root-front_root)/(math.cos(theta)-ky*math.sin(theta));t_out=(inner_at_root-normal_proj-front_root)/(math.cos(theta)-ky*math.sin(theta))
zs=[zroot-t*math.sin(theta) for t in [t_in,t_out]];half_vertical=2/math.sqrt(1+ky*ky)
check('Bristle crosses wall within nominal 4mm sloped port',0<t_out<t_in<14 and all(310-half_vertical<=z<=310+half_vertical for z in zs))
check('Brush tip intrusion1.5 at actual tip height',math.isclose(br['tip_y_mm'][0]-(114-ky*(br['tip_z_mm']-298.3)),1.5))
check('Four divider profiles reach upper PP seat',br['divider_count']==4 and br['divider_z_mm'][0]==g['upper_xyz'][2]+6 and math.isclose(br['divider_yz_face_mm']['top'],12+40*ky))
check('Top flange shares support elevation440',d['mounting']['flange_xyz'][2]==440 and len(d['mounting']['bracket_xyz'])==4)
check('Existing stock profile order remains180x4',b['mechanics_reference']['frame_revision']['buy_finished_mm']=={'180':4})
check('PWM assignment unmodified',p['gpio_pwm']==2)
check('Continuous and peak budget unchanged and conservative',p['continuous_w']==56.5 and p['short_peak_w']==71.5)
missing=[];n=0
for f in [ROOT/'beanlens-hopper-gate-v4.10.html',ROOT.parent/'procurement-v4.10/beanlens-procurement-v4.10.html']:
 for ref in re.findall(r'(?:href|src)="([^"]+)"',f.read_text()):
  if ref.startswith(('http:','https:','data:','#')):continue
  n+=1
  if not (f.parent/unquote(urlsplit(ref).path)).resolve().exists():missing.append((str(f),ref))
check(f'{n} local artifact links exist',not missing)
for f in ROOT.glob('0*.svg'):ET.parse(f)
check('Five SVG pages parse',len(list(ROOT.glob('0*.svg')))==5)
report={'date':'2026-10-16','checks':checks,'count':len(checks),'missing_links':missing,
 'not_verified':d['unresolved'],'scope':'Nominal dimension, selection and document checks only; no physical / electrical / brush or food-contact validation.'}
(ROOT/'validation-20261016.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(f'{len(checks)} artifact consistency checks passed; physical/electrical validation pending.')
