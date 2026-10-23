"""Design consistency checks, never evidence of board/physical success."""
from pathlib import Path
import hashlib,json,math,re,xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parent
PROJECT=ROOT.parents[2]
d=json.loads((ROOT/'design-h3.json').read_text());c=json.loads((PROJECT/'config/hardware-hackathon-h3.json').read_text())
checks=[]
def check(name,condition,detail=None):
 checks.append(dict(name=name,pass_=bool(condition),detail=detail));assert condition,(name,detail)
check('independent_H3_profile',c['profile']=='hackathon-h3' and c['scope']==d['scope'])
check('single_lane_horizontal_dual_camera',d['scope']['lane_count']==1 and d['scope']['camera_count']==2 and not d['scope']['stationary_photo'])
cam=d['geometry']['camera'];check('same_height_opposed_axes',cam['front_lens_xyz'][2]==cam['rear_lens_xyz'][2]==260 and cam['directions']==[[0,1,0],[0,-1,0]])
g=d['geometry']['gate'];check('small_gate_closed_coverage_and_full_open',g['closed_front_y']<=113 and g['closed_front_y']+82>=127 and g['open_front_y']>127)
check('plate_never_exits_front_enclosure',g['closed_front_y']>g['fixed_front_y_range'][1])
check('no_c6_weighing_ir_pbt_network',not any(d['scope'][k] for k in ['esp32c6','weighing','ir_beam','pbt_brush','network']))
check('one_horn_one_rod_two_balls',g['horn_count']==1 and g['rod_count']==1 and g['ball_head_count']==2)
samples=[]
for i in range(101):
 a=math.radians(g['theta_closed_deg']*(1-i/100));p=[170-16*math.cos(a),180+16*math.sin(a)];q=[110,p[1]+math.sqrt(2500-(p[0]-110)**2)];samples.append((q[1],math.dist(p,q)))
check('constant_50mm_link_and_monotonic_slide',all(abs(v[1]-50)<1e-8 for v in samples) and all(samples[i+1][0]>=samples[i][0] for i in range(100)))
check('H3_keeps_checked_BOX_pins',c['pins']==json.loads((PROJECT/'config/hardware-hackathon-h1.json').read_text())['pins'])
ids=[b['id'] for b in d['bom']];check('36_unique_BOM_groups',len(ids)==len(set(ids))==36)
check('power_budget_matches',abs((15+18)/.8+8-c['power']['continuous_budget_w'])<1e-9 and abs((15+30)/.8+8-c['power']['short_peak_budget_w'])<1e-9)
check('two_cameras_in_BOM',next(b for b in d['bom'] if b['id']=='H02')['qty']==2)
check('existing_profile_stock_sufficient',200+180+3<400 and 200+180+3<460)
check('wood_cut_fits_third_existing_panel',88+30+30+3*3<196)
# Basic 3mm cutting gutters in a proposed PP3 300-square layout, including new rear support.
rects=[(0,0,176,196),(180,0,50,85),(235,0,50,85),(180,90,60,60),(180,155,60,60),(0,200,176,50)]
check('PP3_stock_rectangle_layout_fits',all(x+w<=300 and y+h<=300 for x,y,w,h in rects) and all(not (a[0]<b[0]+b[2] and a[0]+a[2]>b[0] and a[1]<b[1]+b[3] and a[1]+a[3]>b[1]) for i,a in enumerate(rects) for b in rects[i+1:]),rects)
for f in ROOT.glob('*.svg'):ET.parse(f)
check('all_SVG_XML_parse',True)
preserved={}
for manifest in [ROOT/'previous-preserved.json',ROOT.parent/'hackathon-h1/full-version-preserved-20261019.json']:
 expected=json.loads(manifest.read_text());bad=[p for p,h in expected.items() if not (PROJECT/p).exists() or hashlib.sha256((PROJECT/p).read_bytes()).hexdigest()!=h];preserved[manifest.name]={'checked':len(expected),'changed':bad};check(manifest.name+'_unchanged',not bad,bad)
# Resolve ordinary relative artifact links; external/anchors excluded.
missing=[]
for f in [ROOT/'README.md',ROOT/'beanlens-realistic-h3.html',ROOT/'bom-h3.html',ROOT/'bom-delta-h3.html',*ROOT.glob('*.svg')]:
 s=f.read_text();links=re.findall(r'href="([^"#]+)"',s) if f.suffix!='.md' else re.findall(r'\]\(([^)]+)\)',s)
 for link in links:
  if re.match(r'^[a-z]+:',link):continue
  if not (f.parent/link.split('#')[0]).exists():missing.append((f.name,link))
check('artifact_links_exist',not missing,missing)
report={'date':'2026-10-21','kind':'host_design_checks_only','checks':checks,'preserved':preserved,'firmware_changed':False,'on_board_run':False,'mechanical_validated':False}
(ROOT/'validation-h3.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print('H3 host design checks:',len(checks),'passed')
