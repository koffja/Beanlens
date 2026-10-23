"""Parametric H3-P1 hopper solids. Units mm; no firmware or prior H3 source edits.

Run in a separate Python 3.12 CAD environment with requirements.txt installed.
STL/3MF/individual STEP are oriented for printing; assembly STEP uses H3 XYZ.
"""
from __future__ import annotations
import hashlib, json, math, platform
from pathlib import Path
import cadquery as cq
import trimesh
from OCP.Bnd import Bnd_Box
from OCP.BRepBndLib import BRepBndLib

ROOT=Path(__file__).resolve().parent
P=json.loads((ROOT/'parameters.json').read_text())
D=json.loads((ROOT/P['source_design']).read_text())['geometry']
EPS=0.02
T=P['wall_min_normal']

def exact_bounds(shape):
    # OCCT cached triangulation can enlarge a generic BoundingBox by its deflection.
    # Use the exact BRep surfaces for dimensions, independently of preview tessellation.
    bb=Bnd_Box()
    BRepBndLib.AddOptimal_s(shape.wrapped,bb,False,False)
    return bb.Get()

def box(w,d,h,z,x=0,y=0,r=0):
    s=cq.Workplane('XY').box(w,d,h,centered=(True,True,False))
    if r:s=s.edges('|Z').fillet(r)
    return s.translate((x,y,z))

def taper(bottom,top,z0,z1):
    return cq.Workplane('XY').workplane(offset=z0).rect(*bottom).workplane(offset=z1-z0).rect(*top).loft(ruled=True,combine=True)

def void_taper(bottom,top,z0,z1):
    # Extend the same linear surfaces beyond the end faces to avoid closed caps.
    h=z1-z0
    lo=[a-(b-a)*EPS/h for a,b in zip(bottom,top)]
    hi=[b+(b-a)*EPS/h for a,b in zip(bottom,top)]
    return taper(lo,hi,z0-EPS,z1+EPS)

def holes(s,xy,z,h):
    for x,y in xy:s=s.cut(cq.Workplane('XY').workplane(offset=z-EPS).center(x,y).circle(P['screw_clearance_diameter']/2).extrude(h+2*EPS))
    return s.clean()

def normal_offsets(bottom,top,h):
    return [T*math.sqrt(1+((b-a)/2/h)**2) for a,b in zip(bottom,top)]

def upper_body():
    a=D['hopper'];b=a['inner_bottom'];top=a['inner_top'];z0=a['bottom_z'];zt=a['top_z']
    off=normal_offsets(b,top,zt-z0)
    outer=taper([v+2*k for v,k in zip(b,off)],[v+2*k for v,k in zip(top,off)],z0,zt)
    male=[v+2*T for v in b]
    neck=box(*male,z0-P['upper_body_bottom_z']+EPS,P['upper_body_bottom_z'],r=.8)
    w,d,h=P['upper_rim_size'];rim=box(w,d,h,zt-h,r=P['corner_radius'])
    result=outer.union(neck).union(rim).cut(void_taper(b,top,z0,zt))
    result=result.cut(box(*b,z0-P['upper_body_bottom_z']+2*EPS,P['upper_body_bottom_z']-EPS))
    q=P['upper_rim_hole_pitch']/2
    return holes(result,[(x,y) for x in [-q,q] for y in [-q,q]],zt-h,h)

def upper_adapter():
    base_z=D['gate']['covers']['upper_z']+D['gate']['covers']['size'][2]
    w,d,h=P['adapter_flange'];xy=D['gate']['covers']['xy'];center=D['hopper']['center_xy']
    y_offset=xy[1]+d/2-center[1]
    throat=D['hopper']['inner_bottom'];male=[a+2*T for a in throat]
    pocket=[a+2*P['fit_clearance_each'] for a in male]
    tube=[a+2*T for a in pocket]
    result=box(w,d,h,base_z,y=y_offset,r=2).union(box(*tube,P['upper_socket_top_z']-base_z,base_z,r=1.2))
    zs=P['adapter_bore_taper_start_z'];seat=P['upper_socket_seat_z']
    mouth=[a+2*P['fit_clearance_each'] for a in throat]
    result=result.cut(box(*throat,zs-base_z+EPS,base_z-EPS))
    result=result.cut(void_taper(throat,mouth,zs,seat))
    result=result.cut(box(*pocket,P['upper_socket_top_z']-seat+EPS,seat,r=.8))
    # Reuse existing H3 guide holes; this adapter sits ON TOP, not in the slide gap.
    return holes(result,[(-20,-15),(20,-15),(-20,45),(20,45)],base_z,h)

def lower_collector():
    a=D['collector'];b=a['inner_bottom'];top=a['inner_top'];z0=a['bottom_z'];zt=a['top_z']
    off=normal_offsets(b,top,zt-z0)
    outer=taper([v+2*k for v,k in zip(b,off)],[v+2*k for v,k in zip(top,off)],z0,zt)
    w,d,h=P['lower_mount_size'];zm=P['lower_mount_bottom_z']
    result=outer.union(box(w,d,h,zm,r=P['corner_radius'])).cut(void_taper(b,top,z0,zt))
    q=P['lower_mount_hole_pitch']/2
    return holes(result,[(x,y) for x in [-q,q] for y in [-q,q]],zm,h)

def coupons():
    b=D['hopper']['inner_bottom'];male=[a+2*T for a in b];inside=[a+2*P['fit_clearance_each'] for a in male];outside=[a+2*T for a in inside]
    return {
      'test-male-mm':box(*male,8,0,r=.8).cut(box(*b,8+2*EPS,-EPS)),
      'test-socket-mm':box(*outside,6,0,r=1.2).cut(box(*inside,6+2*EPS,-EPS,r=.8))}

def as_printed(name,s):
    if name=='upper-hopper-mm':return s.rotate((0,0,0),(1,0,0),180).translate((0,0,D['hopper']['top_z']))
    z=exact_bounds(s.val())[2]
    return s.translate((0,0,-z))

def shape_to_world(shape):
    x,y=D['hopper']['center_xy']
    return shape.translate((x,y,0))

def run():
    out=ROOT/'parts';out.mkdir(exist_ok=True)
    tests=ROOT/'fit-tests';tests.mkdir(exist_ok=True)
    mounted={'upper-hopper-mm':upper_body(),'upper-adapter-mm':upper_adapter(),'lower-collector-mm':lower_collector()}
    records=[];meshes={};assembly=cq.Assembly(name='H3-P1_printed_parts_assembly_REFERENCE_ONLY')
    colors={'upper-hopper-mm':(.2,.54,.59),'upper-adapter-mm':(.84,.58,.24),'lower-collector-mm':(.34,.60,.46)}
    for name,s in {**mounted,**coupons()}.items():
        main=name in mounted;folder=out if main else tests
        print_shape=as_printed(name,s);solid=print_shape.val();bb=exact_bounds(solid)
        assert solid.isValid() and len(print_shape.solids().vals())==1,name+' invalid or multiple solids'
        paths={}
        for ext in ['stl','step','3mf']:
            path=folder/(name+'.'+ext)
            kw=dict(tolerance=P['stl_chord_tolerance'],angularTolerance=P['stl_angular_tolerance_radians']) if ext in ['stl','3mf'] else {}
            cq.exporters.export(print_shape,str(path),**kw)
            paths[ext]=path.relative_to(ROOT).as_posix()
        mesh=trimesh.load_mesh(folder/(name+'.stl'),process=True)
        assert mesh.is_watertight and mesh.is_winding_consistent and len(mesh.split())==1,name+' invalid STL'
        assert mesh.volume>0 and abs(mesh.volume-solid.Volume())/solid.Volume()<.005,name+' mesh volume mismatch'
        bounds=[bb[3]-bb[0],bb[4]-bb[1],bb[5]-bb[2]]
        assert max(abs(float(mesh.extents[i])-bounds[i]) for i in range(3))<.001,name+' STL bounds mismatch'
        assert min(mesh.bounds[0])>=-max(bounds)-EPS and abs(mesh.bounds[0][2])<1e-6
        assert bounds[0]+10<=180 and bounds[1]+10<=180,name+' does not fit assumed bed with 5mm brim'
        records.append({'name':name,'main_print_part':main,'quantity':1,'files':paths,'print_bounds_mm':bounds,'print_min_xyz':mesh.bounds[0].tolist(),'volume_mm3':solid.Volume(),'faces':len(mesh.faces),'watertight':bool(mesh.is_watertight),'winding_consistent':bool(mesh.is_winding_consistent),'solid_count':1,'material_candidate':'PETG','estimated_solid_equivalent_g_at_1_27':solid.Volume()/1000*1.27,'slicer_mass_not_computed':True})
        if main:
            assembly.add(shape_to_world(s),name=name,color=cq.Color(*colors[name]))
            v,f=s.val().tessellate(.12,.1)
            meshes[name]={'vertices':[[p.x,p.y,p.z] for p in v],'triangles':f,'color':colors[name]}
    assembly.export(str(ROOT/'assembly-reference-only.step'))
    # Independent mechanical checks use solid intersections, not only bounding boxes.
    checks=[]
    def check(name,passed,detail=None):
        checks.append({'name':name,'pass':bool(passed),'detail':detail});assert passed,(name,detail)
    u=mounted['upper-hopper-mm'];a=mounted['upper-adapter-mm'];lo=mounted['lower-collector-mm']
    check('upper_body_adapter_no_solid_intersection',u.intersect(a).val().Volume()<1e-6)
    check('socket_axial_clearance_mm',abs(P['upper_body_bottom_z']-P['upper_socket_seat_z']-.2)<1e-6)
    # Existing ring is centred at global (110,120); local offset of ring is 0,0.
    ring=box(176,196,3,440).cut(box(80,80,3+2*EPS,440-EPS))
    check('upper_body_below_existing_top_ring',u.intersect(ring).val().Volume()<1e-6)
    # Existing guide top cover, slide plate and work deck are preserved.
    gate=box(29.4,82,2,324,y=29)
    check('adapter_does_not_touch_gate_closed_or_open',all(a.intersect(gate.translate((0,dy,0))).val().Volume()<1e-6 for dy in [0,D['gate']['stroke']]))
    work=box(176,196,6,180).cut(box(60,60,6+2*EPS,180-EPS))
    check('lower_collector_fits_worktable_60mm_hole',lo.intersect(work).val().Volume()<1e-6)
    check('clearance_below_observation_band',abs(D['camera']['observation_z'][0]-exact_bounds(lo.val())[5]-15)<1e-6)
    # Clear straight passages at the two print interfaces and the full tapered lower body.
    check('upper_body_18x14_passage_open',u.intersect(box(18-.01,14-.01,100.5,339.5)).val().Volume()<1e-6)
    check('adapter_18x14_passage_open',a.intersect(box(18-.01,14-.01,16,329.3)).val().Volume()<1e-6)
    check('lower_30x30_outlet_open',lo.intersect(box(30-.01,30-.01,60,160)).val().Volume()<1e-6)
    check('upper_mouth_80x80_unchanged',D['hopper']['inner_top']==[80,80])
    check('lower_mouth_and_height_unchanged',D['collector']['inner_top']==[64,64] and D['collector']['top_z']-D['collector']['bottom_z']==60)
    # Re-import each STEP to verify it is an actual, single, valid solid.
    for rec in records:
        imported=cq.importers.importStep(str(ROOT/rec['files']['step']))
        check(rec['name']+'_STEP_roundtrip',len(imported.solids().vals())==1 and imported.val().isValid() and abs(imported.val().Volume()-rec['volume_mm3'])<.001)
    spec={'revision':'H3-P1','date':'2026-10-22','unit':'mm','parts':records,'dimensions_source':P['source_design'],'source_design_sha256':hashlib.sha256((ROOT/P['source_design']).read_bytes()).hexdigest(),'parameters':'parameters.json','cadquery_version':cq.__version__,'python_version':platform.python_version(),'validation':'host_CAD_mesh_checks_only_not_printed_or_load_tested','checks':checks,'models_as_mounted':meshes,'mount_holes_global_mm':{'top_ring_new_holes':[[x,y] for x in [64,156] for y in [74,166]],'upper_adapter_existing_guide_pattern':[[x,y] for x in [90,130] for y in [105,165]],'lower_worktable_new_holes':[[x,y] for x in [73,147] for y in [83,157]]}}
    (ROOT/'manifest.json').write_text(json.dumps({k:v for k,v in spec.items() if k!='models_as_mounted'},ensure_ascii=False,indent=2)+'\n')
    (ROOT/'preview-meshes.json').write_text(json.dumps(meshes,separators=(',',':'))+'\n')
    (ROOT/'validation.json').write_text(json.dumps({'date':spec['date'],'host_only':True,'on_printer':False,'checks':checks,'mesh_parts':records},ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'parts':len(records),'main_parts':len(mounted),'checks':len(checks),'bounds':{r['name']:r['print_bounds_mm'] for r in records}},ensure_ascii=False))

if __name__=='__main__':run()
