import csv, hashlib, json, math, re
from pathlib import Path
ROOT=Path(__file__).resolve().parent
PROJECT=ROOT.parents[2]
d=json.loads((ROOT/'design-h2.json').read_text())
c=json.loads((PROJECT/'config/hardware-hackathon-h2.json').read_text())
h1=json.loads((PROJECT/'config/hardware-hackathon-h1.json').read_text())
checks=[]
def check(name,condition):
    checks.append(dict(name=name,pass_=bool(condition)))
    assert condition,name
check('scope_dual_camera_static_manual_single_lane',d['scope']['camera_count']==2 and d['scope']['manual_one_bean'] and d['scope']['stationary_photo'] and d['scope']['lane_count']==1)
check('no_C6_scale_IR_PBT_network',not any(d['scope'][k] for k in ['esp32c6','weighing','ir_beam','pbt_brush','network']))
check('full_BOM_34_unique_groups',len(d['bom'])==34 and len({b['id'] for b in d['bom']})==34)
bm={b['id']:b for b in d['bom']}
check('two_cameras_four_lights_one_horn',bm['H02']['qty']==2 and bm['H07']['qty']==4 and bm['H11']['qty']==1)
check('no_new_frame_lengths',d['geometry']['frame']==[220,240,460])
check('glass_central_clear_width',abs(25.8-2*3-d['geometry']['glass']['clear_optical_width'])<.001)
check('glass_slope_projection',abs(124-76.2*math.cos(math.radians(35))-d['geometry']['chute']['upstream_y'])<.001)
opt=d['geometry']['camera'];check('opposed_vertical_optics',opt['upper_lens_xyz'][:2]==opt['lower_lens_xyz'][:2]==opt['station_xyz'][:2] and abs(opt['upper_lens_xyz'][2]-opt['lower_lens_xyz'][2]-180)<.001)
for key in ['work_aperture','base']:
    g=d['geometry'][key];xy=g['xy'] if key=='work_aperture' else g['hole_xy'];wh=g['wh'] if key=='work_aperture' else g['hole_wh'];p=opt['station_xyz'];check(key+'_central_sight_line_inside',xy[0]<p[0]<xy[0]+wh[0] and xy[1]<p[1]<xy[1]+wh[1])
check('rear_ramp_outside_photo_axis',d['geometry']['collector']['ramp_start_xyz'][1]>opt['station_xyz'][1]+10)
check('ramp_exit_inside_cup',95<d['geometry']['collector']['ramp_end_xyz'][1]<195)
check('guard_clear_of_camera_nominal',d['geometry']['collector']['guard']['y']-d['geometry']['collector']['camera_lower_pcb_max_y']>=8)
check('pins_unchanged_from_H1',c['pins']==h1['pins'])
check('power_budget_arithmetic',abs(c['power']['continuous_budget_w']-(5*3/.8+6*3/.8+8))<.001 and abs(c['power']['short_peak_budget_w']-(5*3/.8+6*5/.8+8))<.001)
check('no_board_or_hardware_pass_claim',not c['validation']['on_board_run'] and not c['validation']['mechanical_test'] and not c['cameras']['board_dual_capture_validated'])
saved=json.loads((ROOT/'h1-preserved.json').read_text());check('single_camera_H1_byte_preserved',all((PROJECT/p).exists() and hashlib.sha256((PROJECT/p).read_bytes()).hexdigest()==h for p,h in saved.items()))
full=json.loads((ROOT.parent/'hackathon-h1/full-version-preserved-20261019.json').read_text())
check('full_version_files_byte_preserved',all((PROJECT/p).exists() and hashlib.sha256((PROJECT/p).read_bytes()).hexdigest()==h for p,h in full.items()))
source=(ROOT/'beanlens-realistic-h2.html').read_text();check('offline_embedded_sources',not re.search(r'<script[^>]+src=',source))
check('no_wrong_BOM_replacement_in_intro','H02 ×2 · H31 · H33' in source)
result={'date':'2026-10-21','status':'host_design_checks_only','checks':checks,'physical_validation':False}
(ROOT/'validation-h2.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
print(len(checks),'H2 document checks passed; physical/optical tests pending')
