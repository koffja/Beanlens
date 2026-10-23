"""Create machine-specific full Bambu configs and preserve existing P1/P2 geometry.
Run in the isolated P1 CAD environment; never requires the training environment.
"""
from pathlib import Path
import argparse, hashlib, json, subprocess, zipfile
import xml.etree.ElementTree as ET
import trimesh

ROOT=Path(__file__).resolve().parent
BBL=Path('/Applications/BambuStudio.app/Contents/Resources/profiles/BBL')
APP=Path('/Applications/BambuStudio.app/Contents/MacOS/BambuStudio')
MACHINES={
 'P2S':('Bambu Lab P2S 0.4 nozzle','0.20mm Standard @BBL P2S','Bambu PETG HF @BBL P2S 0.4 nozzle'),
 'A1':('Bambu Lab A1 0.4 nozzle','0.20mm Standard @BBL A1','Bambu PETG HF @BBL A1'),
 'X1C':('Bambu Lab X1 Carbon 0.4 nozzle','0.20mm Standard @BBL X1C','Bambu PETG HF @BBL X1C'),
 'X2D':('Bambu Lab X2D 0.4 nozzle','0.20mm Standard @BBL X2D','Bambu PETG HF @BBL X2D 0.4 nozzle'),
 'H2D':('Bambu Lab H2D 0.4 nozzle','0.20mm Standard @BBL H2D','Bambu PETG HF @BBL H2D 0.4 nozzle'),
}
JOBS={
 '00-fit-tests':{'parts':[('printing-p1/fit-tests/test-male-mm.stl',-22,0),('printing-p1/fit-tests/test-socket-mm.stl',22,0)],'walls':'5','fill':'25%','support':'0','brim':'no_brim'},
 '01-upper-hopper':{'parts':[('printing-p1/parts/upper-hopper-mm.stl',0,0)],'walls':'5','fill':'25%','support':'0','brim':'outer_only'},
 '02-adapter-and-cameras':{'parts':[('printing-p1/parts/upper-adapter-mm.stl',-48,0),('printing-p2/parts/camera-front-mm.stl',42,-30),('printing-p2/parts/camera-rear-mm.stl',42,30)],'walls':'5','fill':'30%','support':'0','brim':'outer_only'},
 '03-lower-collector':{'parts':[('printing-p1/parts/lower-collector-mm.stl',0,0)],'walls':'5','fill':'25%','support':'1','brim':'outer_only','support_type':'normal(auto)','support_style':'snug','support_base_spacing':'4','buildplate':'1'},
 '04-servo-cradle':{'parts':[('printing-p2/parts/servo-cradle-mm.stl',0,0)],'walls':'6','fill':'40%','support':'1','brim':'outer_only','support_type':'normal(auto)','buildplate':'0'},
 '05-limits-and-flag':{'parts':[('printing-p2/parts/limit-closed-seat-mm.stl',-32,0),('printing-p2/parts/limit-open-seat-mm.stl',0,0),('printing-p2/parts/gate-limit-flag-mm.stl',40,0)],'walls':'5','fill':'35%','support':'0','brim':'outer_only'},
}
source_profiles={}
def resolve(kind,name,stack=()):
    assert name not in stack,(kind,name,stack)
    p=BBL/kind/(name+'.json');d=json.loads(p.read_text())
    source_profiles[str(p.relative_to(BBL))]=hashlib.sha256(p.read_bytes()).hexdigest()
    r=resolve(kind,d['inherits'],stack+(name,)) if d.get('inherits') else {}
    for inc in d.get('include',[]):r.update(resolve(kind,inc,stack+(name,)))
    r.update({k:v for k,v in d.items() if k not in ['inherits','include']})
    return r

def prepare():
    (ROOT/'configs').mkdir(exist_ok=True);(ROOT/'models').mkdir(exist_ok=True)
    source_models={}
    for jid,job in JOBS.items():
        folder=ROOT/'models'/jid;folder.mkdir(exist_ok=True)
        for rel,x,y in job['parts']:
            src=ROOT.parent/rel;source_models[rel]=hashlib.sha256(src.read_bytes()).hexdigest()
            m=trimesh.load_mesh(src,process=False)
            # Preserve handedness, scale and printing orientation. Only XY centering/placement.
            lo,hi=m.bounds;m.apply_translation((128+x-(lo[0]+hi[0])/2,128+y-(lo[1]+hi[1])/2,-lo[2]))
            m.export(folder/src.name)
    for code,(mn,pn,fn) in MACHINES.items():
        folder=ROOT/'configs'/code;folder.mkdir(exist_ok=True)
        machine=resolve('machine',mn);machine['curr_bed_type']='Textured PEI Plate'
        filament=resolve('filament',fn)
        # Same material profile, capped for repeatable prototype walls, not speed benchmarking.
        filament['filament_max_volumetric_speed']=['10']*len(filament['filament_max_volumetric_speed'])
        for name,obj in [('machine',machine),('filament',filament)]: (folder/(name+'.json')).write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n')
        for jid,job in JOBS.items():
            proc=resolve('process',pn)
            proc.update({'wall_loops':job['walls'],'sparse_infill_density':job['fill'],'sparse_infill_pattern':'gyroid','top_shell_layers':'5','bottom_shell_layers':'5','top_shell_thickness':'1','bottom_shell_thickness':'1','layer_height':'0.2','initial_layer_print_height':'0.2','enable_support':job['support'],'support_type':job.get('support_type','tree(auto)'),'support_style':job.get('support_style','default'),'support_base_pattern_spacing':job.get('support_base_spacing','2.5'),'support_on_build_plate_only':job.get('buildplate','1'),'support_interface_top_layers':'3','support_interface_spacing':'0.4','support_top_z_distance':'0.2','support_object_xy_distance':'0.4','brim_type':job['brim'],'brim_width':'5','brim_object_gap':'0.15','seam_position':'rear','wall_generator':'arachne','enable_prime_tower':'0','print_sequence':'by layer'})
            for key,value in {'outer_wall_speed':'60','inner_wall_speed':'100','sparse_infill_speed':'100','internal_solid_infill_speed':'80','top_surface_speed':'60','initial_layer_speed':'20','initial_layer_infill_speed':'30','bridge_speed':'25','support_speed':'60','support_interface_speed':'40','default_acceleration':'3000','outer_wall_acceleration':'1500','travel_speed':'200'}.items():
                proc[key]=[value]*len(proc[key]) if isinstance(proc.get(key),list) else value
            (folder/(jid+'.json')).write_text(json.dumps(proc,ensure_ascii=False,indent=2)+'\n')
    spec={'revision':'H3-Bambu-P3','date':'2026-10-22','BambuStudio':'02.08.02.61','user_confirmed':{'nozzle_mm':0.4,'filament':'Bambu PETG HF','X1_model':'X1 Carbon','bed':'Textured PEI Plate'},'setup':{'bed':'Textured PEI Plate','extruder_variant':'original standard 0.4mm hotend','scale':1.0,'physical_print_verified':False},'machines':MACHINES,'jobs':JOBS,'profile_source_sha256':source_profiles,'model_source_sha256':source_models}
    (ROOT/'job-spec.json').write_text(json.dumps(spec,ensure_ascii=False,indent=2)+'\n')
    print('Prepared',len(MACHINES),'machine variants and',len(JOBS),'jobs; P1/P2 untouched')

def slice_job(code,jid):
    assert code in MACHINES and jid in JOBS
    folder=ROOT/'jobs'/code;folder.mkdir(parents=True,exist_ok=True)
    work=ROOT/'logs'/code/jid;work.mkdir(parents=True,exist_ok=True)
    cfg=ROOT/'configs'/code
    out=folder/(jid+'.gcode.3mf')
    result_path=work/'result.json'
    if result_path.exists():result_path.unlink()
    cmd=['rtk','proxy',str(APP),'--datadir',str(work/'runtime'),'--outputdir',str(work),'--debug','2','--load-settings',str(cfg/'machine.json')+';'+str(cfg/(jid+'.json')),'--load-filaments',str(cfg/'filament.json'),'--orient','0','--arrange','0','--ensure-on-bed','--slice','0','--export-3mf',out.name]
    cmd += [str(ROOT/'models'/jid/Path(p[0]).name) for p in JOBS[jid]['parts']]
    with (work/'slicer.log').open('w') as log:
        result=subprocess.run(cmd,cwd=work,stdout=log,stderr=subprocess.STDOUT)
    if result.returncode==0 and (work/out.name).exists():(work/out.name).replace(out)
    record={'machine':code,'job':jid,'return_code':result.returncode,'output':str(out.relative_to(ROOT)),'exists':out.exists(),'bytes':out.stat().st_size if out.exists() else 0}
    if result_path.exists():record['slicer_result']=json.loads(result_path.read_text())
    if result.returncode==0 and out.exists():
        # macOS CLI looks up machine_full/, absent in this app distribution.
        # Fill only the omitted device identity from the installed official machine model.
        model=json.loads((BBL/'machine'/(MACHINES[code][0].removesuffix(' 0.4 nozzle')+'.json')).read_text())
        with zipfile.ZipFile(out) as z: contents={n:z.read(n) for n in z.namelist()}
        info=ET.fromstring(contents['Metadata/slice_info.config'])
        for el in info.findall('./plate/metadata'):
            if el.get('key')=='printer_model_id':
                assert el.get('value') in ['',model['model_id']]
                el.set('value',model['model_id'])
        contents['Metadata/slice_info.config']=ET.tostring(info,encoding='utf-8',xml_declaration=True)
        with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as z:
            for n,b in contents.items():z.writestr(n,b)
        record['printer_model_id']=model['model_id']
        record['identity_metadata_completed_from_official_profile']=True
        record['bytes']=out.stat().st_size
    (work/'run.json').write_text(json.dumps(record,indent=2)+'\n')
    print(json.dumps(record))
    if result.returncode:raise SystemExit(result.returncode)

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--slice',nargs=2,metavar=('MACHINE','JOB'));args=ap.parse_args()
    if args.slice:slice_job(*args.slice)
    else:prepare()
