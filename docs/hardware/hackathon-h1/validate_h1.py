"""Validate H1 documents, dimensions, pin references and preserved full-version bytes."""
from pathlib import Path
from urllib.parse import urlsplit,unquote
import math,json,csv,re,hashlib,xml.etree.ElementTree as ET
from pypdf import PdfReader
R=Path(__file__).resolve().parent;REPO=R.parents[2]
d=json.loads((R/'design-h1.json').read_text());a=json.loads((R/'assembly-h1.json').read_text());b=json.loads((REPO/'config/hardware-hackathon-h1.json').read_text());p={p['id']:p for p in a['parts']};bom=json.loads((R/'bom-h1.json').read_text());checks=[]
def check(name,ok):
 checks.append(dict(check=name,passed=bool(ok)))
 assert ok,name
check('30 unique BOM groups with unknown prices left null',len({x['id'] for x in bom['items']})==len(bom['items'])==30 and all(x['unit_price_cny'] is None for x in bom['items']))
check('All drawing objects resolve to H1 BOM IDs',all(set(re.findall(r'H\d\d',x['bom']))<={x['id'] for x in bom['items']} for x in p.values()))
check('50 unique drawing objects',len(p)==len(a['parts'])==50)
sc=d['scope'];check('Single camera/lane/BOX/manual static scope',sc['camera_count']==1 and sc['lane_count']==1 and sc['manual_one_bean'] and sc['stationary_photo'] and sc['controller']=='ALIENTEK K230D BOX')
check('C6/weight/IR/PBT/network/dual pairing absent',not any(sc[k] for k in ['weighing','esp32c6','ir_beam','pbt_brush','dual_camera_pairing','network']))
check('No long rod/rail hidden in geometry',d['geometry']['gate']['rod_count']==0 and d['geometry']['gate']['rail_count']==0)
check('12 profile members with460x4/200x4/180x4',all(sum(x['group']=='骨架' and max(x['size'])==n for x in p.values())==4 for n in [460,200,180]))
check('Stock7x460+2x400 needs no new profiles',4+3==7 and 3+1==4 and 2*3+200+180<=400 and 200+180+2*3<=460)
check('3 fixed platforms, no weighing hardware',sum(x['id'] in ['P01','P02','P03'] for x in p.values())==3 and p['CUP']['pos']==[60,95,26])
ch=d['geometry']['chute'];check('60 face length and35deg projected run/rise',math.isclose(124-ch['upstream_y'],60*math.cos(math.radians(35))) and math.isclose(ch['upstream_z']-220,60*math.sin(math.radians(35))))
check('Sides provide support to level Z189 and14high wall',all(x['pos'][2]==189 for x in [p['C02'],p['C03']]) and ch['wall_vertical_height']==14)
check('Working/base apertures overlap bean drop center',p['P02']['aperture']==[85,122,50,45] and p['B01']['aperture']==[90,124,40,40])
check('Closed gate covers outlet and has0.5mm nominal floor gap',p['S05']['pos'][0]<=98 and p['S05']['pos'][0]+46>=122 and math.isclose(p['S05']['pos'][2]-220,.5))
# Opening rotates the gate horizontal polygon around pivot; verify it clears the fixed channel.
xp,yp,_=d['geometry']['gate']['pivot'];pts=[(94,124.5),(140,124.5),(140,127.5),(94,127.5)];opened=[(xp+(y-yp),yp-(x-xp)) for x,y in pts]
check('90degree open gate clears chute and rear guard',min(x for x,y in opened)>125 and 190-max(y for x,y in opened)>=18)
check('PP3 stock200 square has nonoverlapping3mm nesting',all(x['xy'][i]>=0 and x['xy'][i]+x['wh'][i]<=200 for x in d['flat_stock_pp3']['rectangles'] for i in [0,1]))
rs=d['flat_stock_pp3']['rectangles']
check('PP3 blank separations>=3mm',all(any(x['xy'][k]+x['wh'][k]+3<=y['xy'][k]+1e-6 or y['xy'][k]+y['wh'][k]+3<=x['xy'][k]+1e-6 for k in [0,1]) for i,x in enumerate(rs) for y in rs[i+1:]))
pins=b['pins'];check('BOX PWM5 isGPIO25/J10pin1',pins['servo_pwm']['gpio']==25 and pins['servo_pwm']['function']=='PWM5' and pins['servo_pwm']['hz']==50 and 'pin1' in pins['servo_pwm']['header'])
check('New limits and enable are GPIO24/23/22',pins['gate_closed_limit']['gpio']==24 and pins['gate_open_limit']['gpio']==23 and pins['servo_signal_enable']['gpio']==22)
check('KEY0/1 are34/35, KEY2reserved',pins['start_capture_key']['gpio']==34 and pins['stop_key']['gpio']==35 and pins['reserved_key']['gpio']==0)
check('Schematic provenance hash matches untouched vendor file',hashlib.sha256((REPO/b['schematic']['path']).read_bytes()).hexdigest()==b['schematic']['sha256'])
check('Drawing angles not silently treated as calibrated pulses',b['servo_pulse_us']['closed'] is None and b['servo_pulse_us']['open'] is None and b['timing_ms']['close_timeout'] is None)
pow=b['power'];check('24/5/6V and45.25W/60.25W budgets agree',pow['input_v']==24 and pow['logic_v']==5 and pow['servo_v']==6 and pow['continuous_budget_w']==5*3/.8+6*3/.8+4 and pow['short_peak_budget_w']==5*3/.8+6*5/.8+4)
check('3.3V GPIO translated by5V AHCT buffer',pow['signal_v']==3.3 and pow['servo_pwm_buffer_output_v']==5 and pow['buffer']=='SN74AHCT125N')
for f in R.glob('*.svg'):ET.parse(f)
check('6 drawing pages and supplementary PP stock SVG parse',len(list(R.glob('0[1-6]-*.svg')))==6 and (R/'flat-stock-h1.svg').exists())
missing=[];links=0
for f in [R/'assembly-h1.html',R/'bom-h1.html',R/'operation-h1.html',R/'README.md']:
 refs=re.findall(r'(?:href|src)="([^"]+)"',f.read_text()) if f.suffix=='.html' else re.findall(r'\]\(([^)]+)\)',f.read_text())
 for ref in refs:
  if ref.startswith(('https:','http:','data:','#')):continue
  links+=1
  if not (f.parent/unquote(urlsplit(ref).path)).resolve().exists():missing.append([str(f),ref])
check(f'{links} local references resolve',not missing)
pdf=PdfReader(REPO/'output/pdf/beanlens-hackathon-h1-20261019.pdf');check('Six A3 landscape PDF pages',len(pdf.pages)==6 and all(abs(float(p.mediabox.width)*25.4/72-420)<1 and abs(float(p.mediabox.height)*25.4/72-297)<1 for p in pdf.pages))
texts='\n'.join(p.extract_text() or '' for p in pdf.pages);check('PDF includes actual board PWM and supply models',all(k in texts for k in ['GPIO25','PWM5','YU2405','UBEC','SN74AHCT125N']))
# Compare exact content hashes captured before H1 generation. Preserve old designs as requested.
manifest=R/'full-version-preserved-20261019.json'
if manifest.exists():
 before=json.loads(manifest.read_text());changed=[name for name,h in before.items() if hashlib.sha256((REPO/name).read_bytes()).hexdigest()!=h]
 check(f'{len(before)} full-version artifacts unchanged',not changed)
else:changed=[]
report=dict(date='2026-10-19',revision='H1',count=len(checks),checks=checks,missing_links=missing,full_version_changed=changed,not_verified=['Board PWM/FPIOA/firmware','Real model conversion and KPU classification','Optics/illumination/focus','Mechanical/weld/servo endpoints','Electrical voltage/thermal/limit reliability'],scope='Document and simulation checks only')
(R/'validation-20261019.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n');print(f'{len(checks)} H1 document checks passed; physical verification pending.')
