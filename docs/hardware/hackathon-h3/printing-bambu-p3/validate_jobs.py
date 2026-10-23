"""Validate all actual sliced archives, and make a portable print dashboard."""
from pathlib import Path
import hashlib,json,re,zipfile,csv,math
import xml.etree.ElementTree as ET
import trimesh,numpy as np

ROOT=Path(__file__).resolve().parent;PROJECT=ROOT.parents[3]
SPEC=json.loads((ROOT/'job-spec.json').read_text());checks=[];records=[]
def check(name,passed):
    checks.append({'name':name,'pass':bool(passed)})
    assert passed,name

def support_in_lower_passage(gcode):
    x=y=z=e=0.;feature='';relative=True;total=inside=0;segments=[]
    for line in gcode.splitlines():
        if line.startswith('; FEATURE:'):feature=line[11:].strip()
        if line=='M82':relative=False
        if line=='M83':relative=True
        if line.startswith('G92 E'):e=float(line.split('E')[1].split()[0])
        if not re.match(r'^G[01] ',line):continue
        d={k:float(v) for k,v in re.findall(r'([XYZE])(-?\d*\.?\d+)',line.split(';')[0])}
        nx,ny,nz=d.get('X',x),d.get('Y',y),d.get('Z',z)
        de=d.get('E',0) if relative else d.get('E',e)-e
        if 'E' in d:e=e+d['E'] if relative else d['E']
        if feature.startswith('Support') and de>0 and (nx!=x or ny!=y):
            total+=1;half=(30+34*nz/60)/2-.6
            segments.append([[x,y,z],[nx,ny,nz]])
            for tx,ty in [(x,y),(nx,ny),((x+nx)/2,(y+ny)/2)]:
                if abs(tx-128)<half and abs(ty-128)<half:inside+=1;break
        x,y,z=nx,ny,nz
    return total,inside,segments

def main():
    (ROOT/'thumbnails').mkdir(exist_ok=True)
    preserved=json.loads((ROOT/'previous-preserved.json').read_text())
    for name,sha in preserved.items():check('preserved_'+name,hashlib.sha256((PROJECT/name).read_bytes()).hexdigest()==sha)
    for jid,job in SPEC['jobs'].items():
        for rel,dx,dy in job['parts']:
            source=trimesh.load_mesh(ROOT.parent/rel,process=True)
            model=trimesh.load_mesh(ROOT/'models'/jid/Path(rel).name,process=True)
            check('mesh_'+jid+'_'+Path(rel).stem,model.is_watertight and np.allclose(source.extents,model.extents,atol=2e-5) and math.isclose(source.volume,model.volume,rel_tol=1e-5))
            check('bed_'+jid+'_'+Path(rel).stem,model.bounds[0][0]>=5 and model.bounds[0][1]>=5 and model.bounds[1][0]<=251 and model.bounds[1][1]<=251 and abs(model.bounds[0][2])<1e-5)
    for code,machine in SPEC['machines'].items():
        for jid,job in SPEC['jobs'].items():
            run=json.loads((ROOT/'logs'/code/jid/'run.json').read_text())
            status=run['slicer_result'];plate=status['sliced_plates'][0]
            check(code+'_'+jid+'_slicer_success',run['return_code']==0 and status['return_code']==0 and status['error_string']=='Success.' and plate['warning_message']=='')
            file=ROOT/run['output']
            with zipfile.ZipFile(file) as archive:
                check(code+'_'+jid+'_archive_CRC',archive.testzip() is None)
                for name in archive.namelist():
                    if name.endswith(('.xml','.model','.rels')) or name.endswith(('model_settings.config','slice_info.config')):ET.fromstring(archive.read(name))
                config=json.loads(archive.read('Metadata/project_settings.config'))
                check(code+'_'+jid+'_exact_setup',config['printer_settings_id']==machine[0] and config['printer_model']==machine[0].removesuffix(' 0.4 nozzle') and set(config['nozzle_diameter'])=={'0.4'} and config['filament_type']==['PETG'] and config['filament_settings_id']==[machine[2]] and config['curr_bed_type']=='Textured PEI Plate')
                check(code+'_'+jid+'_process',config['wall_loops']==job['walls'] and config['sparse_infill_density']==job['fill'] and config['enable_support']==job['support'] and config['layer_height']=='0.2' and set(config['filament_max_volumetric_speed'])=={'10'})
                gcode=archive.read('Metadata/plate_1.gcode').decode()
                check(code+'_'+jid+'_gcode_MD5',hashlib.md5(gcode.encode()).hexdigest()==archive.read('Metadata/plate_1.gcode.md5').decode().strip().lower())
                check(code+'_'+jid+'_no_unexpanded_placeholders',not re.search(r'^.*\[[a-z_]+\].*$',gcode[gcode.index('; CONFIG_BLOCK_END'):],re.M))
                info=ET.fromstring(archive.read('Metadata/slice_info.config'))
                meta={el.get('key'):el.get('value') for el in info.findall('./plate/metadata')}
                check(code+'_'+jid+'_machine_identity',meta['printer_model_id']==run['printer_model_id'] and meta['outside']=='false' and set(meta['nozzle_diameters'].split(','))=={'0.4'})
                nozzles=info.findall('./plate/nozzle')
                check(code+'_'+jid+'_single_standard_nozzle',len(nozzles)==1 and nozzles[0].get('extruder_id')=='1' and nozzles[0].get('volume_type')=='Standard')
                check(code+'_'+jid+'_object_count',len(ET.fromstring(archive.read('Metadata/model_settings.config')).findall('./object'))==len(job['parts']))
                if jid=='03-lower-collector':
                    count,inside,segments=support_in_lower_passage(gcode)
                    check(code+'_lower_external_support',count>0 and inside==0)
                    if code=='P2S':(ROOT/'lower-support-paths.json').write_text(json.dumps({'units':'mm','from_actual_Gcode':True,'support_segments':segments},separators=(',',':'))+'\n')
                if code=='P2S':(ROOT/'thumbnails'/(jid+'.png')).write_bytes(archive.read('Metadata/plate_1.png'))
                seconds=round(plate['total_predication']);weight=round(sum(f['total_used_g'] for f in plate['filaments']),2)
                records.append({'machine':code,'job':jid,'parts':len(job['parts']),'file':run['output'],'estimated_seconds':seconds,'estimated_g':weight,'support':job['support']=='1','nozzle_temp':config['nozzle_temperature'],'first_nozzle_temp':config['nozzle_temperature_initial_layer'],'bed_temp':config['textured_plate_temp'],'sha256':hashlib.sha256(file.read_bytes()).hexdigest()})
    check('thirty_machine_specific_jobs',len(records)==30)
    report={'revision':'H3-Bambu-P3','host_slice_only':True,'printed':False,'printer_firmware_verified':False,'checks':checks,'jobs':records,'previous_files_preserved':len(preserved),'source':'BambuStudio 02.08.02.61 installed official profiles + actual sliced archives'}
    (ROOT/'validation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    with (ROOT/'print-jobs.csv').open('w') as f:
        out=csv.DictWriter(f,fieldnames=['machine','job','parts','file','estimated_seconds','estimated_g','support']);out.writeheader();out.writerows({k:r[k] for k in out.fieldnames} for r in records)
    print(json.dumps({'checks':len(checks),'sliced_jobs':len(records),'previous_files_preserved':len(preserved),'all_pass':True}))

if __name__=='__main__':main()
