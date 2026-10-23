"""H3-P2 mount solids. Units mm; no firmware or prior H3/P1 source edits.

Run in a separate Python 3.12 CAD environment with requirements.txt installed.
STL/3MF/individual STEP are oriented for printing; assembly STEP uses H3 XYZ.
"""
from __future__ import annotations
import json, math
from pathlib import Path
import cadquery as cq
import trimesh
from OCP.Bnd import Bnd_Box
from OCP.BRepBndLib import BRepBndLib

ROOT=Path(__file__).resolve().parent
P=json.loads((ROOT/'parameters.json').read_text())
D=json.loads((ROOT/P['source']).read_text())['geometry']
EPS=0.02

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

def B(x,y,z,w,d,h):return box(w,d,h,z,x+w/2,y+d/2)

def slot_z(s,x,y,z,h,length,diam,angle=0):
    wp=cq.Workplane('XY').workplane(offset=z-EPS).center(x,y)
    tool=(wp.circle(diam/2) if abs(length-diam)<1e-8 else wp.slot2D(length,diam,angle)).extrude(h+2*EPS)
    return s.cut(tool)

def rib_x(x0,x1,y,z0,z1,thick=3):
    return cq.Workplane('XZ').polyline([(x0,z0),(x1,z0),(x1,z1)]).close().extrude(thick).translate((0,y+thick,0))

def servo_cradle():
    s=B(145,158,283.2,56,68,5)
    # Open bottom and cable notch: do not trap the servo body or its rear lead.
    s=s.cut(B(159.4,171.2,283,20.9,42.3,6)).cut(B(164,210,283,12,17,6))
    s=s.cut(B(198,219,283,4,8,6)) # Rear-right upright clearance.
    for x in [155.4,180.3]:s=s.union(B(x,160,288.1,4,59,30.9))
    for y,d in [(161.5,9.7),(213.5,5.5)]:s=s.union(B(155.4,y,313,28.9,d,6))
    for y in [161.5,216]:
        s=s.union(rib_x(145.4,155.6,y,288.1,315)).union(rib_x(194.3,184.1,y,288.1,315))
    for x,y in P['servo']['mount_xy']:s=slot_z(s,x,y,283.2,5,7.4,3.4)
    for x in P['servo']['ear_hole_x']:
        for y in P['servo']['ear_hole_y']:s=slot_z(s,x,y,313,6,6.4,3.4)
    return s.clean()

def camera_front():
    s=B(80,2,240,60,28,4).cut(B(88,10,239.9,44,21,4.2))
    s=s.union(B(80,2,240,60,4,48))
    # Clear central rear access, but do not clamp the lens barrel.
    s=s.cut(B(100,1.9,250,20,4.2,20))
    for x in [80,137]:
        r=cq.Workplane('YZ').polyline([(6,243.9),(28,243.9),(6,271)]).close().extrude(3).translate((x,0,0))
        s=s.union(r)
    # Four diagonal slots accept square mounting-hole pitches24..34mm.
    for sx in [-1,1]:
        for sz in [-1,1]:
            a=(110+sx*12,260+sz*12);b=(110+sx*17,260+sz*17)
            length=math.dist(a,b)+2.4;ang=math.degrees(math.atan2(b[1]-a[1],b[0]-a[0]))
            tool=cq.Workplane('XZ').center((a[0]+b[0])/2,(a[1]+b[1])/2).slot2D(length,2.4,ang).extrude(4.2).translate((0,6.1,0))
            s=s.cut(tool)
    for x in [84,136]:s=slot_z(s,x,17,240,4,12,3.4,90)
    return s.clean()

def camera_rear():return camera_front().rotate((110,120,0),(110,120,1),180)

def limit_seat(is_open=False):
    if not is_open:
        s=B(136,181,321,23,16,4).union(B(155,171,324.9,4,26,8.2)).union(B(130,163,333,29,17,4))
        ys=[185,193];sloty=P['limit']['front_slot_y']
    else:
        s=B(136,198,321,23,16,4).union(B(155,198,324.9,4,18,8.2)).union(B(130,208,333,29,17,4))
        ys=[202,210];sloty=P['limit']['rear_slot_y']
    for y in ys:s=slot_z(s,144,y,321,4,3.4,3.4)
    for x in [138.2,147.7]:s=slot_z(s,x,sloty,333,4,8.4,2.4,90)
    return s.clean()

def gate_flag():
    s=B(116,180.5,326,37,9,3).union(B(137,181,328.9,16,6,15.1))
    return slot_z(s,120,184,326,3,3.4,3.4).clean()

def references():
    # Simplified envelopes, never vendor CAD. Source H3 and P1 are preserved.
    ref={}
    ref['servo-case-reference']=B(160,172,288,19.7,40.7,40.3)
    for y in [165,212.7]:ref['servo-case-reference']=ref['servo-case-reference'].union(B(160,y,319,19.7,7,2))
    ref['aluminum-base-reference']=B(153,159,280.2,60,60,3)
    # Angle on the FRONT face of the right-rear upright.
    ref['metal-angle-reference']=B(200,180,276.2,20,40,4).union(B(200,216,240.2,20,4,40))
    ref['rear-crossbeam-reference']=B(20,220,298,180,20,20)
    # Window lets the two travelling M3 fasteners pass below the gate without scraping PP.
    ref['carrier-PP3-reference']=B(85,160,318,68,80,3).cut(B(105,179,317.9,20,30,3.2))
    ref['rear-right-upright-reference']=B(200,220,0,20,20,460)
    for name,y in [('front-wood-reference',2),('rear-wood-reference',208)]:ref[name]=B(22,y,234,176,30,6)
    ref['gate-guide-reference']=B(85,95,326.3,50,85,3).cut(B(101,113,326.2,18,14,3.2))
    ref['gate-reference']=B(95.3,108,324,29.4,82,2)
    ref['camera-A-PCB-reference']=B(90,13.8,240,40,1.4,40)
    ref['camera-B-PCB-reference']=B(90,224.8,240,40,1.4,40)
    ref['limit-closed-case-reference']=B(133.1,169.7,337,19.8,10.2,6.4)
    ref['limit-open-case-reference']=B(133.1,207.85,337,19.8,10.2,6.4)
    return ref

def print_pose(name,s):
    # Front/rear bases and flag stand flat; limit seat is laid on its outer side.
    if name.startswith('limit-'):s=s.rotate((0,0,0),(0,1,0),90)
    bb=exact_bounds(s.val());return s.translate((-(bb[0]+bb[3])/2,-(bb[1]+bb[4])/2,-bb[2]))

def capsule(p,q,r):
    v=cq.Vector(*q).sub(cq.Vector(*p));s=cq.Solid.makeCylinder(r,v.Length,cq.Vector(*p),v.normalized())
    return cq.Workplane(obj=s).union(cq.Workplane('XY').sphere(r).translate(p)).union(cq.Workplane('XY').sphere(r).translate(q))

def run():
    out=ROOT/'parts';out.mkdir(exist_ok=True)
    parts={'servo-cradle-mm':servo_cradle(),'camera-front-mm':camera_front(),'camera-rear-mm':camera_rear(),'limit-closed-seat-mm':limit_seat(),'limit-open-seat-mm':limit_seat(True),'gate-limit-flag-mm':gate_flag()}
    refs=references();records=[];meshes={};checks=[]
    def check(name,condition,detail=None):
        checks.append({'name':name,'pass':bool(condition),'detail':detail});assert condition,(name,detail)
    colors=[(.24,.50,.61),(.33,.62,.51),(.29,.50,.40),(.84,.56,.25),(.77,.40,.22),(.60,.37,.57)]
    assembly=cq.Assembly(name='H3-P2_printed_parts_REFERENCE_ONLY')
    for (name,s),color in zip(parts.items(),colors):
        check(name+'_valid_single_solid',s.val().isValid() and len(s.solids().vals())==1)
        p=print_pose(name,s);bb=exact_bounds(p.val());bounds=[bb[i+3]-bb[i] for i in range(3)];files={}
        for ext in ['stl','3mf','step']:
            file=out/(name+'.'+ext);kw=dict(tolerance=.025,angularTolerance=.08) if ext!='step' else {}
            cq.exporters.export(p,str(file),**kw);files[ext]=file.relative_to(ROOT).as_posix()
        mesh=trimesh.load_mesh(out/(name+'.stl'),process=True)
        check(name+'_closed_mesh',mesh.is_watertight and mesh.is_winding_consistent and len(mesh.split())==1)
        check(name+'_mesh_volume_matches_CAD',abs(mesh.volume-p.val().Volume())/p.val().Volume()<.005)
        check(name+'_bed_and_floor',bounds[0]+10<=220 and bounds[1]+10<=220 and abs(mesh.bounds[0][2])<1e-5)
        imported=cq.importers.importStep(str(out/(name+'.step')))
        check(name+'_STEP_roundtrip',imported.val().isValid() and len(imported.solids().vals())==1 and abs(imported.val().Volume()-p.val().Volume())<.001)
        records.append({'name':name,'quantity':1,'files':files,'print_bounds_mm':bounds,'volume_mm3':p.val().Volume(),'watertight':True,'single_solid':True,'as_mounted_exact_bounds':list(exact_bounds(s.val()))})
        assembly.add(s,name=name,color=cq.Color(*color))
        v,f=s.val().tessellate(.1,.1);vp,fp=p.val().tessellate(.1,.1)
        meshes[name]={'vertices':[[a.x,a.y,a.z] for a in v],'triangles':f,'print_vertices':[[a.x,a.y,a.z] for a in vp],'print_triangles':fp,'color':color,'bounds':bounds}
    assembly.export(str(ROOT/'assembly-reference-only.step'))
    refassembly=cq.Assembly(name='H3-P2_printed_and_reference_NOT_FOR_PRINT')
    for name,s in parts.items():refassembly.add(s,name=name)
    for name,s in refs.items():
        refassembly.add(s,name=name,color=cq.Color(.7,.72,.72))
        v,f=s.val().tessellate(.15,.12);meshes[name]={'vertices':[[a.x,a.y,a.z] for a in v],'triangles':f,'color':[.65,.68,.67],'reference':True}
    refassembly.export(str(ROOT/'assembly-with-references-NOT-FOR-PRINT.step'))
    def overlap(a,b):return a.intersect(b).val().Volume()
    for i,(n,a) in enumerate(parts.items()):
        for m,b in list(parts.items())[i+1:]:check(n+'_clear_'+m,overlap(a,b)<1e-5)
    for n,a in parts.items():
        for m,b in refs.items():
            if m=='gate-reference' and n=='gate-limit-flag-mm':continue # Mating surface only.
            check(n+'_clear_'+m,overlap(a,b)<1e-5)
    # Record why this is an assembly revision rather than a blind copy of the old mesh.
    old_carrier=B(22,165,318,176,50,3);old_plate=B(155,169,280.2,60,60,3)
    old_interferences={'carrier_vs_servo_case_mm3':overlap(old_carrier,refs['servo-case-reference']),'aluminum_plate_vs_upright_mm3':overlap(old_plate,refs['rear-right-upright-reference'])}
    check('revised_carrier_clears_servo',overlap(refs['carrier-PP3-reference'],refs['servo-case-reference'])<1e-5)
    check('revised_aluminum_plate_clears_upright',overlap(refs['aluminum-base-reference'],refs['rear-right-upright-reference'])<1e-5)
    # Motion audit: gate and raised flag move together, without touching any fixed printed part.
    samples=[]
    for i in range(21):
        ang=math.radians(D['gate']['theta_closed_deg']*(1-i/20));p=[170-16*math.cos(ang),180+16*math.sin(ang),337.5];q=[110,p[1]+math.sqrt(2500-(p[0]-110)**2),337.5];dy=q[1]-184
        moving=parts['gate-limit-flag-mm'].translate((0,dy,0));gate=refs['gate-reference'].translate((0,dy,0))
        for n,s in parts.items():
            if n!='gate-limit-flag-mm':check('motion_%02d_clear_%s'%(i,n),overlap(moving,s)<1e-5 and overlap(gate,s)<1e-5)
        rod=capsule(p,q,1.7)
        check('motion_%02d_flag_clear_rod'%i,overlap(moving,rod)<1e-5)
        for x in [110,120]:
            fastener=cq.Workplane('XY').circle(3.2).extrude(7).translate((x,184+dy,319))
            check('motion_%02d_fastener_%s_clear_carrier'%(i,x),overlap(fastener,refs['carrier-PP3-reference'])<1e-5)
        samples.append({'fraction':i/20,'slide_mm':dy,'ball_centers_mm':[p,q]})
    # Horizontal central rays are represented by tiny cylinders, not claimed whole FOV.
    for start,end in [([110,30,260],[110,120,260]),([110,210,260],[110,120,260])]:
        ray=capsule(start,end,.05)
        check('central_optical_axis_clear_'+str(start[1]),all(overlap(s,ray)<1e-6 for s in parts.values()))
    manifest={'revision':'H3-P2','date':'2026-10-22','units':'mm','parts':records,'printed_parts':6,'main_mounts':5,'additional_flag':1,'actual_servo_ear_dimensions_verified':False,'actual_camera_PCB_verified':False,'physical_limit_trigger_verified':False,'cadquery':cq.__version__,'checks':checks,'prior_layout_interferences':old_interferences,'motion_samples':samples,'sources':{'omron':'https://omronfs.omron.com/en_US/ecb/products/pdf/en-ss.pdf','H3':'source-design-h3.json'}}
    (ROOT/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
    (ROOT/'preview-meshes.json').write_text(json.dumps(meshes,separators=(',',':'))+'\n')
    (ROOT/'validation.json').write_text(json.dumps({'host_only':True,'printed':False,'load_tested':False,'checks':checks,'old_layout_interferences':old_interferences},ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'parts':len(records),'checks':len(checks),'bounds':{a['name']:a['print_bounds_mm'] for a in records},'prior_layout_interferences':old_interferences},ensure_ascii=False))

if __name__=='__main__':run()

