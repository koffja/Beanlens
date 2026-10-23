"""H3-P4 integrated assembly: original P1/P2 CAD + explicit fixed structure.
All units mm. Host geometry is a candidate, not a physical assembly approval.
Run using the separate P1 CAD environment, never the user's training environment.
"""
from pathlib import Path
import csv,hashlib,importlib.util,json,math
from collections import Counter
import cadquery as cq
from OCP.Bnd import Bnd_Box
from OCP.BRepBndLib import BRepBndLib

ROOT=Path(__file__).resolve().parent;H3=ROOT.parent;EPS=.02
def load(name,path):
    spec=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m
p1=load('original_p1',H3/'printing-p1/build_print_models.py')
p2=load('original_p2',H3/'printing-p2/build_models.py')
parts=[];solids={};joints=[];hardware=Counter();checks=[]
COLORS={'print':'#248b91','wood':'#c69a65','aluminum':'#b9c6ce','pp':'#e8e8dd','profile':'#252e33','hardware':'#bd9b57','shield':'#343b40','reference':'#283d49'}
def bounds(shape):
    b=Bnd_Box();BRepBndLib.AddOptimal_s(shape.val().wrapped,b,False,False);return list(b.Get())
def B(x,y,z,w,d,h):return cq.Workplane('XY').box(w,d,h,centered=(False,False,False)).translate((x,y,z))
def cylinder(p,d,r,l):return cq.Workplane(obj=cq.Solid.makeCylinder(r,l,cq.Vector(*p),cq.Vector(*d)))
def drill(s,p,d,r,l):
    p=[p[i]-d[i]*EPS for i in range(3)];return s.cut(cylinder(p,d,r,l+2*EPS))
def holes_z(s,xy,z,h,diam=3.4):
    for x,y in xy:s=drill(s,[x,y,z],[0,0,1],diam/2,h)
    return s.clean()
def add(id,name,bom,material,system,shape,shift=(0,0,0),note='',reference=False):
    assert id not in solids,id
    shape=shape.clean();solids[id]=shape
    vertices,faces=shape.val().tessellate(.14,.15)
    row={'id':id,'name':name,'bom':bom,'material':material,'system':system,'color':COLORS[material],'bounds':bounds(shape),'explode':list(shift),'note':note,'reference':reference,'vertices':[[v.x,v.y,v.z] for v in vertices],'triangles':faces}
    parts.append(row);return id
def check(name,passed,detail=None):checks.append({'name':name,'pass':bool(passed),'detail':detail});assert passed,(name,detail)
def joint(id,title,chain,ids,fasteners,target,steps,note=''):
    joints.append({'id':id,'title':title,'chain':chain,'parts':ids,'fasteners':fasteners,'target':target,'steps':steps,'note':note})
def fastener(id,key,entry,d,length,stack,system,tnut=False):
    """Entry = actual material face, direction points into the joint.
    Nominal shafts/heads/nuts have no threads; slot nut envelopes are illustrative.
    """
    hardware[key]+=1;r=2.5 if key.startswith('M5') else 1 if key.startswith('M2') else 1.5
    head_r=4.25 if r==2.5 else 1.9 if r==1 else 2.75
    head_h=2.7 if r==2.5 else 1.6 if r==1 else 2.3
    p=cq.Vector(*entry);v=cq.Vector(*d);under=p-v*.5
    shaft=cylinder(under.toTuple(),d,r,length)
    head=cylinder((under-v*head_h).toTuple(),d,head_r,head_h)
    washer=cylinder((p-v*.5).toTuple(),d,4.5 if r>=1.5 else 2.5,.5)
    nut_h=3 if tnut else 1.8 if r==1 else 2.4
    nut_start=p+v*(stack+(1.8 if tnut else .5))
    # Cylinder/hex envelope rather than a mating thread model.
    nut=cylinder(nut_start.toTuple(),d,4.4 if tnut else 2.3 if r==1 else 3.2,nut_h)
    exit_washer=cylinder((p+v*stack).toTuple(),d,4.5 if r>=1.5 else 2.5,.5)
    shape=cq.Compound.makeCompound([s.val() for s in ([shaft,head,washer,nut] if tnut else [shaft,head,washer,exit_washer,nut])])
    add(id,key+' 螺栓／垫片／'+('槽内螺母' if tnut else '防松螺母'),'K-'+key,'hardware',system,cq.Workplane(obj=shape),tuple(-a*20 for a in d),note='轴／螺母为无螺纹参考；长度需实物试配，不能顶槽底。',reference=True)
    return id

def build():
    # Nine ORIGINAL print solids, as installed. No re-meshing into a substitute part.
    prints=[('P11','上漏斗斗身',p1.shape_to_world(p1.upper_body()),(-80,0,35),'01-upper-hopper'),('P12','上漏斗接座',p1.shape_to_world(p1.upper_adapter()),(0,-30,35),'02-adapter-and-cameras'),('P13','下接豆斗',p1.shape_to_world(p1.lower_collector()),(0,0,55),'03-lower-collector'),('P21','MG996R打印固定架',p2.servo_cradle(),(75,0,-5),'04-servo-cradle'),('P22','前相机打印座',p2.camera_front(),(0,-60,15),'02-adapter-and-cameras'),('P23','后相机打印座',p2.camera_rear(),(0,60,15),'02-adapter-and-cameras'),('P24','关位开关打印座',p2.limit_seat(),(20,-35,30),'05-limits-and-flag'),('P25','开位开关打印座',p2.limit_seat(True),(20,35,45),'05-limits-and-flag'),('P26','闸片限位旗片',p2.gate_flag(),(0,0,55),'05-limits-and-flag')]
    systems={'P11':'top','P12':'gate','P13':'collector','P21':'servo','P22':'camera','P23':'camera','P24':'gate','P25':'gate','P26':'gate'}
    for id,name,s,shift,job in prints:
        add(id,name,id,'print',systems[id],s,shift,'原P1/P2 CAD；打印任务 '+job)
    # Profile envelopes. Viewer replaces these with actual T-slot appearance.
    for i,(x,y) in enumerate([(0,0),(200,0),(0,220),(200,220)],1):add(f'T{i:02}',f'460立柱{i}','H14','profile','frame',B(x,y,0,20,20,460),(-40 if x==0 else 40,-40 if y==0 else 40,0))
    i=5
    for z in [0,440]:
        for y in [0,220]:add(f'T{i:02}',f'180宽梁{i-4}','H14','profile','frame',B(20,y,z,180,20,20),(0,-30 if y==0 else 30,-20 if z==0 else 60));i+=1
        for x in [0,200]:add(f'T{i:02}',f'200深梁{i-4}','H14','profile','frame',B(x,20,z,20,200,20),(-30 if x==0 else 30,0,-20 if z==0 else 60));i+=1
    add('P28','新增180后横梁','P28','profile','gate',B(20,220,298,180,20,20),(0,45,0),'从原400mm余料裁；不是增加一根整机立柱。')
    # Wooden panels: explicit holes for every fixed joint.
    W01holes=[(60,30),(160,30),(60,210),(160,210)]
    W02holes=[(30,30),(190,30),(30,210),(190,210)]+[(x,y) for x in [73,147] for y in [83,157]]
    W03holes=[(x,z) for x in [30,190] for z in [350,406]]+[(x,z) for x in [74,146] for z in [346,398]]
    add('W01','海洋板底板 176×196×6','H16','wood','wood',holes_z(B(22,22,22,176,196,6),W01holes,22,6),(0,-20,-30),'底面Z22：在底框顶面增加2mm平连接片；杯底随之Z28。')
    work=B(22,22,180,176,196,6).cut(B(80,90,179.9,60,60,6.2))
    add('W02','开60方孔工作木台','H16','wood','wood',holes_z(work,W02holes,180,6),(0,0,0),'下斗法兰落在顶面Z186，木孔80/90为全局左前角。')
    panel=B(22,20,334,176,6,88)
    for x,z in W03holes:panel=drill(panel,[x,20,z],[0,1,0],1.7,6)
    add('W03','BOX前承板 176×88×6','H16','wood','screen',panel,(0,-60,0),'前面Y20，比旧图后移3mm；原壳接口、按键与软垫须实配。')
    for id,y in [('W04',2),('W05',208)]:
        footy=17 if y==2 else 223;shy=27 if y==2 else 213
        xy=[(30,footy),(190,footy),(84,footy),(136,footy),(52,shy),(188,shy)]
        add(id,'前相机木横条' if y==2 else '后相机木横条','H16','wood','camera',holes_z(B(22,y,234,176,30,6),xy,234,6),(0,-35 if y==2 else 35,-12),'176×30×6，底234／顶240；相机与遮光片有独立穿板孔。')
    # PP ring, lower guide, upper guide, spacers, small fixed front enclosure.
    ring=B(22,22,440,176,196,3).cut(B(70,80,439.9,80,80,3.2))
    ringholes=[(x,y) for x in [64,156] for y in [74,166]]+[(x,y) for x in [30,190] for y in [60,180]]
    add('C01','PP3顶承重环','H13','pp','top',holes_z(ring,ringholes,440,3),(0,0,45),'80×80中孔，承托原P1斗身法兰，不与PETG热焊。')
    for id,z in [('C02',321),('C03',326.3)]:
        s=B(85,95,z,50,85,3).cut(B(101,113,z-.1,18,14,3.2));s=holes_z(s,[(x,y) for x in [90,130] for y in [105,165]],z,3)
        add(id,'下导向盖' if id=='C02' else '上导向盖','H13','pp','gate',s,(0,0,-25 if id=='C02' else 20),'50×85×3，18×14豆孔；可拆夹层，不焊死滑道。')
    for id,x in [('C04',85),('C05',125)]:
        for suffix,z,t in [('',324,2),('-PET',326,.3)]:
            s=holes_z(B(x,95,z,10,85,t),[(x+5,y) for y in [105,165]],z,t)
            add(id+suffix,'PP2侧垫条' if not suffix else 'PET0.3配隙片','H38','pp','gate',s,(-15 if x==85 else 15,0,0),'组合槽高2.3mm；PP/PET不焊接。')
    tube=B(99,111,300,22,18,21).cut(B(101,113,299.9,18,14,21.2))
    add('C06','PP2下短管','H13','pp','gate',tube,(0,0,-45),'外22×18、内18×14、长21；外焊至下盖，出口Z300。')
    cap=B(83,93,321,54,2,8.3).union(B(83,95,321,2,16,8.3)).union(B(135,95,321,2,16,8.3))
    add('C07','PP2固定前封口U片','H13','pp','gate',cap,(0,-25,0),'前片54×8.3、两翼16×8.3；贴盖板外缘，保持前方固定承接口；不保留旧29高侧片穿过打印接座。')
    carrier=B(85,160,318,68,80,3).cut(B(105,179,317.9,20,30,3.2))
    carrier=holes_z(carrier,[(90,165),(130,165)]+[(144,y) for y in [185,193,202,210]],318,3)
    carrier=holes_z(carrier,[(95,230),(140,230)],318,3,5.5)
    add('P30','PP3后承托片 68×80','P30','pp','gate',carrier,(0,30,-20),'20×30移动螺母避让窗；后两M5锁P28顶槽。')
    # Revised aluminium pieces and real guide holes.
    gate=holes_z(B(95.3,108,324,29.4,82,2),[(110,184),(120,184)],324,2)
    add('H36','6061-T6单槽铝闸片','H36','aluminum','gate',gate,(0,35,0),'2mm铝片，新增旗片孔120/184；球头孔110/184。')
    plate=holes_z(B(153,159,280.2,60,60,3),[(x,y) for x in [159,193] for y in [165,213]]+[(207.5,y) for y in [196,212]],280.2,3)
    add('P27','60×60×3舵机铝底板','P27','aluminum','servo',plate,(65,0,-35),'左前下角153/159/280.2；保持P2孔图与打印架轴高。')
    angle=B(200,180,276.2,20,40,4).union(B(200,216,240.2,20,4,40))
    angle=holes_z(angle,[(207.5,y) for y in [196,212]],276.2,4)
    for z in [250.2,270.2]:angle=drill(angle,[210,216,z],[0,1,0],2.75,4)
    add('H10','40×40×4舵机加强角码','H10','aluminum','servo',angle,(35,10,-20),'宽20，竖边贴右后立柱前面Y220；实际购件孔型先核。')
    # Eight 40x20 flat plates: four under top ring and four above bottom frame.
    flatids=[]
    for i,(x,y) in enumerate([(0,50),(180,50),(0,170),(180,170)],1):
        s=holes_z(B(x,y,438,40,20,2),[(x+10,y+10),(x+30,y+10)],438,2,5.5)
        id=f'F{i:02}';add(id,'顶环40×20平连接片','H39','aluminum','top',s,(-25 if x==0 else 25,0,0),'一孔M5向上进顶梁底槽，一孔M3＋φ9垫片穿PP环；两孔均φ5.5，孔距20。');flatids.append(id)
        profile_x=x+10 if x==0 else x+30;ring_x=x+30 if x==0 else x+10
        fastener(id+'-M5','M5x8',[profile_x,y+10,438],[0,0,1],8,2,'top',True)
        fastener(id+'-M3','M3x12',[ring_x,y+10,443],[0,0,-1],12,5,'top')
    for i,(x,y) in enumerate([(50,0),(150,0),(50,200),(150,200)],5):
        s=holes_z(B(x,y,20,20,40,2),[(x+10,y+10),(x+10,y+30)],20,2,5.5)
        id=f'F{i:02}';add(id,'底板40×20平连接片','H39','aluminum','wood',s,(0,-25 if y==0 else 25,-5),'压在底梁顶槽上；木底板从Z20改为Z22。')
        beam_y=y+10 if y==0 else y+30;wood_y=y+30 if y==0 else y+10
        fastener(id+'-M5','M5x8',[x+10,beam_y,22],[0,0,-1],8,2,'wood',True)
        fastener(id+'-M3','M3x16',[x+10,wood_y,28],[0,0,-1],16,8,'wood')
    # Angle helpers: post-side bracket supporting a horizontal wooden strip.
    def wood_angle(id,left,y,z,width,wood_xy,system):
        x=20 if left else 180
        s=B(x,y,z-2,20,width,2).union(B(20 if left else 198,y,z-20,2,width,20))
        wx,wy=wood_xy;s=holes_z(s,[(wx,wy)],z-2,2)
        py=10 if y<100 else 230;pz=z-10;px=20 if left else 200
        s=drill(s,[20 if left else 198,py,pz],[1,0,0],2.75,2)
        add(id,'工作台40宽角铝' if width==40 else '相机横条20宽角铝','H17','aluminum',system,s,(-18 if left else 18,0,0),'20×20×2角铝，按宽度裁切；一侧M5进立柱槽，一侧M3穿木板。')
        fastener(id+'-M5','M5x8',[22 if left else 198,py,pz],[-1,0,0] if left else [1,0,0],8,2,system,True)
        fastener(id+'-M3','M3x16',[wx,wy,z+6],[0,0,-1],16,8,system)
    for i,(left,y,xy) in enumerate([(True,0,(30,30)),(False,0,(190,30)),(True,200,(30,210)),(False,200,(190,210))],1):wood_angle(f'A{i:02}',left,y,180,40,xy,'wood')
    for i,(left,y,xy) in enumerate([(True,0,(30,17)),(False,0,(190,17)),(True,220,(30,223)),(False,220,(190,223))],5):wood_angle(f'A{i:02}',left,y,234,20,xy,'camera')
    # BOX panel attaches with four upright side tabs; original BOX held by corner clamps.
    for i,(left,z) in enumerate([(True,350),(False,350),(True,406),(False,406)],9):
        x=20 if left else 180;vx=20 if left else 198
        s=B(x,18,z-10,20,2,20).union(B(vx,0,z-10,2,20,20))
        s=drill(s,[vx,10,z],[1,0,0],2.75,2);sx=30 if left else 190
        s=drill(s,[sx,18,z],[0,1,0],1.7,2)
        add(f'A{i:02}','BOX承板侧角铝','H19','aluminum','screen',s,(-15 if left else 15,-15,0),'侧角铝长20，木板前面Y20；避开料斗，面板不承担斗重。')
        fastener(f'A{i:02}-M5','M5x8',[22 if left else 198,10,z],[-1,0,0] if left else [1,0,0],8,2,'screen',True)
        fastener(f'A{i:02}-M3','M3x16',[sx,18,z],[0,1,0],16,8,'screen')
    for i,(x,z) in enumerate([(x,z) for x in [74,146] for z in [346,398]],1):
        s=B(x-6,-2,z-10,12,2,20);s=drill(s,[x,-2,z],[0,1,0],1.7,2)
        add(f'BCL{i}','BOX角部铝压片','H19','aluminum','screen',s,(0,-30,0),'20×12×2裁片；只压原壳边缘，不压屏幕、按键或PCB。')
        spacer=cylinder([x,0,z],[0,1,0],3.5,20).cut(cylinder([x,-.1,z],[0,1,0],1.6,20.2))
        add(f'BST{i}','BOX 20mm绝缘隔柱','H19','pp','screen',spacer,(0,-18,0),'M3通孔，20mm长，原壳后面与木板有间隔；尺寸实物复核。')
        fastener(f'BCL{i}-M3','M3x35',[x,-2,z],[0,1,0],35,28,'screen')
    # Guide and printed part fasteners.
    for i,(x,y) in enumerate([(x,y) for x in [64,156] for y in [74,166]],1):fastener(f'TOP-{i}','M3x16',[x,y,443],[0,0,-1],16,7,'top')
    for i,(x,y) in enumerate([(x,y) for x in [73,147] for y in [83,157]],1):fastener(f'LOW-{i}','M3x16',[x,y,190],[0,0,-1],16,10,'collector')
    for i,(x,y) in enumerate([(x,y) for x in [90,130] for y in [105,165]],1):fastener(f'GUIDE-{i}','M3x20' if y==105 else 'M3x25',[x,y,332.3],[0,0,-1],20 if y==105 else 25,11.3 if y==105 else 14.3,'gate')
    for i,(x,y) in enumerate([(95,230),(140,230)],1):fastener(f'CARRIER-{i}','M5x10',[x,y,321],[0,0,-1],10,3,'gate',True)
    for i,(x,y) in enumerate([(x,y) for x in [159,193] for y in [165,213]],1):fastener(f'SERVO-FOOT-{i}','M3x12',[x,y,288.2],[0,0,-1],12,8,'servo')
    for i,(x,y) in enumerate([(x,y) for x in [164.45,175.25] for y in [168.5,216.2]],1):fastener(f'SERVO-EAR-{i}','M3x16',[x,y,321],[0,0,-1],16,8,'servo')
    for i,y in enumerate([196,212],1):fastener(f'SERVO-AL-{i}','M3x12',[207.5,y,283.2],[0,0,-1],12,7,'servo')
    for i,z in enumerate([250.2,270.2],1):fastener(f'SERVO-FRAME-{i}','M5x10',[210,216,z],[0,1,0],10,4,'servo',True)
    for i,(x,y) in enumerate([(x,y) for x in [84,136] for y in [17,223]],1):fastener(f'CAM-FOOT-{i}','M3x16',[x,y,244],[0,0,-1],16,10,'camera')
    for i,y in enumerate([185,193,202,210],1):fastener(f'LIMIT-FOOT-{i}','M3x12',[144,y,325],[0,0,-1],12,7,'gate')
    for i,(x,y) in enumerate([(x,y) for x in [138.2,147.7] for y in [172.6,215.15]],1):fastener(f'LIMIT-SW-{i}','M2x14',[x,y,343.4],[0,0,-1],14,10.4,'gate')
    fastener('FLAG','M3x10',[120,184,329],[0,0,-1],10,5,'gate')
    # Rear beam standard corner brackets (two, from original H15 spare stock).
    for left in [True,False]:
        x=20 if left else 180;vx=20 if left else 198
        s=B(x,220,278,20,2,20).union(B(vx,220,278,2,20,20))
        s=drill(s,[vx,230,288],[1,0,0],2.75,2)
        # Vertical leg at post inner X; horizontal leg actually points UP to bottom of beam.
        s=B(x,220,296,20,20,2).union(B(vx,220,278,2,20,20))
        s=drill(s,[vx,230,288],[1,0,0],2.75,2)
        bx=30 if left else 190;s=holes_z(s,[(bx,230)],296,2,5.5)
        id='RB-L' if left else 'RB-R';add(id,'新增后横梁两孔角码','P29','aluminum','gate',s,(-20 if left else 20,20,0),'从H15的4只备用角码中取2只，剩2只备用。')
        fastener(id+'-POST','M5x8',[22 if left else 198,230,288],[-1,0,0] if left else [1,0,0],8,2,'gate',True)
        fastener(id+'-BEAM','M5x8',[bx,230,296],[0,0,1],8,2,'gate',True)
    # 16 frame corner brackets: two per corner, one for each horizontal beam.
    for top in [False,True]:
        for left in [True,False]:
            for front in [True,False]:
                px=10 if left else 210;py=10 if front else 230
                z0=420 if top else 20;zbolt=430 if top else 30
                x=20 if left else 180;y=0 if front else 220;vx=20 if left else 198
                s=B(x,y,438 if top else 20,20,20,2).union(B(vx,y,z0,2,20,20))
                s=drill(s,[vx,py,zbolt],[1,0,0],2.75,2);bx=30 if left else 190
                s=holes_z(s,[(bx,py)],438 if top else 20,2,5.5)
                id=f'FC-X-{int(top)}{int(left)}{int(front)}';add(id,'框架宽梁角码','H15','aluminum','frame',s,(0,0,0))
                fastener(id+'-P','M5x8',[22 if left else 198,py,zbolt],[-1,0,0] if left else [1,0,0],8,2,'frame',True)
                fastener(id+'-B','M5x8',[bx,py,438 if top else 22],[0,0,1] if top else [0,0,-1],8,2,'frame',True)
                x=0 if left else 200;y=20 if front else 200;vy=20 if front else 218
                s=B(x,y,438 if top else 20,20,20,2).union(B(x,vy,z0,20,2,20))
                s=drill(s,[px,vy,zbolt],[0,1,0],2.75,2);by=30 if front else 210
                s=holes_z(s,[(px,by)],438 if top else 20,2,5.5)
                id=f'FC-Y-{int(top)}{int(left)}{int(front)}';add(id,'框架深梁角码','H15','aluminum','frame',s,(0,0,0))
                fastener(id+'-P','M5x8',[px,22 if front else 218,zbolt],[0,-1,0] if front else [0,1,0],8,2,'frame',True)
                fastener(id+'-B','M5x8',[px,by,438 if top else 22],[0,0,1] if top else [0,0,-1],8,2,'frame',True)
    # Removable side panels with a real clearance notch for the servo assembly.
    for side,left in [('L',True),('R',False)]:
        x=62 if left else 176;s=B(x,22,210,2,196,100)
        if not left:s=s.cut(B(175.9,154,276,2.2,64.1,34.1))
        for yy in [21.9,207.5]:s=s.cut(B(x-.1,yy,233.8,2.2,10.6,6.4))
        for yy,zz in [(27,250),(213,250),(40,264),(200,264)]+[(yy,zz) for yy in [80,142] for zz in [220,300]]:s=drill(s,[x,yy,zz],[1,0,0],1.7,2)
        add('SH-'+side,'左遮光／灯槽承板' if left else '右遮光／灯槽承板','H20','shield','light',s,(-45 if left else 45,0,0),'PP2 196×100；两端开木横条避让槽；右片后上角去64×34，避开舵机与铝板。')
        for i,(y,wy) in enumerate([(12,27),(208,213)],1):
            ax=42 if left else 178;vx=60 if left else 178
            a=B(ax,y,240,20,20,2).union(B(vx,y,240,2,20,20))
            wx=52 if left else 188;a=holes_z(a,[(wx,wy)],240,2);a=drill(a,[vx,wy,250],[1,0,0],1.7,2)
            id=f'SA-{side}{i}';add(id,'遮光板到木横条角铝','H20','aluminum','light',a,(-15 if left else 15,0,0))
            fastener(id+'-WOOD','M3x16',[wx,wy,242],[0,0,-1],16,8,'light')
            fastener(id+'-PP','M3x10',[60 if left else 180,wy,250],[1,0,0] if left else [-1,0,0],10,4,'light')
    # Optional front/rear backgrounds attach to side panels, with clear lens apertures.
    for side,y in [('F',28),('B',210)]:
        s=B(65,y,245,110,2,47);s=drill(s,[110,y,260],[0,1,0],12,2)
        if side=='B':s=s.cut(B(145,y-.1,276,30.1,2.2,16.1))
        for x in [74,166]:s=drill(s,[x,y,264],[0,1,0],1.7,2)
        add('BG-'+side,'前带镜头孔背景片' if side=='F' else '后带镜头孔背景片','H20','shield','light',s,(0,-35 if side=='F' else 35,0),'110×47×2，底245避开相机底脚；φ24孔中心110/260，后片右上角去30×16避舵机。')
        for left in [True,False]:
            x=64 if left else 156;vx=64 if left else 174;yy=30 if side=='F' else 190;vy=30 if side=='F' else 208;sy=40 if side=='F' else 200
            s=B(x,vy,254,20,2,20).union(B(vx,yy,254,2,20,20))
            s=drill(s,[vx,sy,264],[1,0,0],1.7,2);hx=74 if left else 166;s=drill(s,[hx,vy,264],[0,1,0],1.7,2)
            id=f'BA-{side}{"L" if left else "R"}';add(id,'背景片角铝连接片','H20','aluminum','light',s,(0,-15 if side=='F' else 15,0))
            fastener(id+'-SIDE','M3x10',[62 if left else 178,sy,264],[1,0,0] if left else [-1,0,0],10,4,'light')
            fastener(id+'-BG','M3x10',[hx,28 if side=='F' else 212,264],[0,1,0] if side=='F' else [0,-1,0],10,4,'light')
    # Compatible metal clip reference, never asserted to match an unreceived SKU.
    for side,left in [('L',True),('R',False)]:
        for y in [80,142]:
            for z in [220,300]:
                footx=64 if left else 175;cx=68 if left else 164
                c=B(footx,y-10,z-3,1,20,6)
                c=c.union(B(65 if left else 172,y-10,z-3,3,3,6)).union(B(65 if left else 172,y+7,z-3,3,3,6))
                c=drill(c,[footx,y,z],[1,0,0],1.7,1)
                id=f'LC-{side}-{y}-{z}';add(id,'灯槽配套卡扣参考','H08','aluminum','light',c,(0,0,0),'买槽时配8只同规格卡扣；孔型、槽背与螺钉头净空按实物，不按参考包络定SKU。',True)
                fastener(id+'-M3','M3x10',[65 if left else 175,y,z],[-1,0,0] if left else [1,0,0],10,3,'light')
    # Vendor component envelopes for the CAD file, replaced by detailed appearances in viewer.
    add('H03','MG996R舵机参考','H03','reference','servo',p2.references()['servo-case-reference'],(55,0,25),'舵机耳面319、目标轴心331；实物耳孔与轴高待核。',True)
    for id,y in [('H02-A',13.8),('H02-B',224.8)]:add(id,'前摄A参考' if id=='H02-A' else '后摄B参考','H02','reference','camera',B(90,y,240,40,1.4,40),(0,-45 if id=='H02-A' else 45,20),'40方PCB是参考；实际孔距先核P2纸样。',True)
    for id,y in [('H09-C',169.7),('H09-O',207.85)]:add(id,'关限位SS-01GL' if id=='H09-C' else '开限位SS-01GL','H09','reference','gate',B(133.1,y,337,19.8,10.2,6.4),(0,-20 if id=='H09-C' else 20,30),'9.5孔距，按P2槽位调OP；开关不承担硬限位力。',True)
    add('H01','K230D BOX原壳参考','H01','reference','screen',B(77.85,1,346.2,64.3,15.4,47.6),(0,-60,0),'外壳参考64.3×47.6×15.4；不把孔位参考当厂商CAD。',True)
    add('H21','普通收豆杯参考','H21','reference','collector',B(60,95,28,100,100,80),(0,-25,0),'底面随木底板到Z28；出口Z160，杯沿Z108，约52mm净高。',True)
    # Nominal spacer under moving gate ball.
    spacer=cylinder([110,184,326],[0,0,1],2.6,8)
    add('H12','M3×8球头隔柱','H12','aluminum','gate',spacer,(0,35,15),'配球头实测中心高337.5，不把8mm当绝对通用值。',True)
    # Connection index drives both the viewer and the printed instructions.
    bysys=lambda system:[r['id'] for r in parts if r['system']==system]
    joint('J01','2020框架角码','两孔角码 → M5 → 槽内螺母',['T01','T02','T05','T07']+[r['id'] for r in parts if r['id'].startswith('FC-')],['M5×8候选，32套；槽内螺母32'],[20,20,35],['4立柱保持460整根；宽梁180、深梁200。','每个框角用两只标准角码，分别连接两根横梁，共16只。','M5进型材侧槽，不钻立柱；先松装找方，再对角轻紧。'],'M5长度按实际角码厚度和T螺母核验；先试槽，不顶槽底。')
    joint('J02','底木板到黑色底框','木板6 → 平连接片2 → 底梁顶槽',['W01','T05','T06','T07','T08','H21']+[r['id'] for r in parts if r['id'].startswith(tuple(f'F{i:02}' for i in range(5,9)))],['M3×16 4套','M5×8/T螺母 4套'],[110,120,25],['4只40×20×2平片先锁底框顶槽，并避开四角角码。','木板放上平片，底面Z22，四孔(60/160，30/210)穿M3。','杯底Z28，放在板上；不安装称重组件。'])
    joint('J03','工作木台到四立柱','木台6 → 40宽角铝 → 立柱侧槽',['W02','T01','T02','T03','T04']+[r['id'] for r in parts if re_id(r['id'],'A',1,4)],['M3×16 4套','M5×8/T螺母 4套'],[110,120,180],['四只角铝为20×20×2、宽40，支承顶面Z180。','竖边M5锁立柱内侧槽；横边M3穿木板。','工作台60×60孔对中豆路，先确认不蹭下斗。'])
    joint('J04','相机木横条到立柱','木横条6 → 20宽角铝 → 立柱槽',['W04','W05','T01','T02','T03','T04']+[r['id'] for r in parts if re_id(r['id'],'A',5,8)],['M3×16 4套','M5×8/T螺母 4套'],[110,120,234],['两条176×30×6木条，底234、顶240。','前条Y2，后条Y208；每端一只20宽角铝。','条上相机孔与遮光板孔分别开，不让排线承重。'])
    joint('J05','PP顶环到顶部型材','PP环3 → 平片2 → 顶深梁底槽',['C01','T09','T10','T11','T12']+[r['id'] for r in parts if r['id'].startswith(('F01','F02','F03','F04'))],['M3×12/φ9垫片 4套','M5×8/T螺母 4套'],[110,120,440],['四只40×20平片在顶梁底面Z440向内伸。','外侧孔M5向上锁底槽，内侧孔M3穿PP顶环。','顶环底Z440；不用旧图朝下但无法贴梁的L角片。'])
    joint('J06','上漏斗法兰与接座','打印法兰4 → PP环3；颈口 → 可拆接座',['P11','P12','C01']+[r['id'] for r in parts if r['id'].startswith('TOP-')],['M3×16 4套'],[110,120,395],['上斗104×104法兰贴PP顶环下面，4孔为64/156与74/166。','上斗颈插入P12，保留0.2mm轴向间隙；不与PP热焊。','斗身由顶环承重；接座只定位，不能强压两端。'])
    joint('J07','后横梁与PP承托片','后横梁 → 顶槽M5 → PP3承托片',['P28','P30','RB-L','RB-R','T03','T04','C02','C03','P12']+[r['id'] for r in parts if r['id'].startswith(('CARRIER-','RB-L-','RB-R-'))],['后梁角码2只＋M5×8 4套','M5×10/T螺母 2套'],[120,210,312],['新增180mm后梁在Z298–318，端部两只角码固定。','PP3承托片68×80贴梁顶；后孔(95/140，230)锁顶槽。','20×30窗给移动螺母避让，不装旧176×50整片。'])
    joint('J08','单槽导向夹层','接座3 → 上盖3 → 2.3导槽 → 下盖3 → 后承托3',['P12','C02','C03','C04','C04-PET','C05','C05-PET','C06','C07','P30','H36']+[r['id'] for r in parts if r['id'].startswith('GUIDE-')],['前M3×20 2套','后M3×25 2套'],[110,135,324],['PP2叠PET0.3组成2.3槽高；2mm铝片上下总隙0.3。','前两螺栓夹11.3厚；后两多穿PP3承托，总厚14.3。','下短管外焊下盖，前U片只包外缘；先手推，再接舵机。'])
    joint('J09','舵机到铝板与立柱','舵机耳 → 打印架 → 铝板3 → 加强角码4 → 立柱',['H03','P21','P27','H10','T04']+[r['id'] for r in parts if r['id'].startswith('SERVO-')],['耳M3×16 4套','底脚M3×12 4套','铝板M3×12 2套','立柱M5×10/T螺母 2套'],[175,190,303],['40×40×4角码锁右后立柱前槽，水平上面Z280.2。','铝板顶283.2，打印架底贴板，安装耳承面319。','舵机耳面实核，目标轴心(170,180,331)；固定架不转。'])
    joint('J10','双摄PCB与打印座','PCB → M2隔柱8 → 打印背板4 → 打印底脚4 → 木条6',['P22','P23','H02-A','H02-B','W04','W05']+[r['id'] for r in parts if r['id'].startswith('CAM-FOOT-')],['底脚M3×16 4套','M2内内8mm隔柱 8只','M2×5与M2×8各8只候选'],[110,120,260],['前后座各四只M2隔柱，夹PCB边，不夹镜筒。','底脚两孔穿木条；光轴均Z260、水平相向。','24–34方孔距只是候选适配范围；先纸样核PCB和线缆。'])
    joint('J11','开关、旗片和连杆','SS-01GL → 打印座 → PP承托；旗片 → 铝闸片',['P24','P25','P26','H09-C','H09-O','H36','P30','H12']+[r['id'] for r in parts if r['id'].startswith(('LIMIT-','FLAG'))],['座M3×12 4套','开关M2×14 4套','旗片M3×10 1套','R16单舵臂＋50球心距双球头杆'],[140,191,334],['开关用M2，9.5孔距；关位杠杆向后、开位向前。','旗片孔120/184与球头110/184分开；只用新旗片。','断6V手推约19.75行程，用万用表调触发；开关不做硬挡块。'])
    joint('J12','下斗法兰到开孔木台','打印法兰4 → 木台6 → 垫片／螺母',['P13','W02']+[r['id'] for r in parts if r['id'].startswith('LOW-')],['M3×16 4套'],[110,120,190],['下斗从60×60孔中穿过，90×90法兰落在木台上面Z186。','4孔(73/147，83/157)；每侧垫片，松装对中再紧。','上口220、出口160；不再装PP焊接小耳。'])
    joint('J13','BOX原壳到木承板','铝压片＋软垫 → 20mm隔柱 → 木板 → 四侧角铝',['H01','W03']+[r['id'] for r in parts if r['id'].startswith(('BCL','BST')) or re_id(r['id'],'A',9,12)],['压片4、20mm通孔隔柱4、软垫4','M3×35 4套','板到角铝M3×16 4套','角铝到柱M5×8/T螺母 4套'],[110,15,375],['四侧角铝把面板固定到前立柱内侧槽，板前面Y20。','20×12铝压片只压原壳角部，20mm绝缘隔柱回传到木板。','压片与孔位为参考，先按实物核屏、KEY、TF与Type-C；不钻PCB。'])
    joint('J14','灯槽与可拆遮光板','灯槽 → 配套卡扣 → PP侧板 → 角铝 → 木横条',[r['id'] for r in parts if r['system']=='light']+['W04','W05'],['配套灯槽卡扣8＋M3×10 8套','侧板角铝4：M3×16 4、M3×10 4','背景角铝4：M3×10 8'],[110,120,260],['两侧PP2板用角铝锁前后木条；灯槽靠配套卡扣固定。','前后背景片φ24孔让镜头通过，装配视图可隐藏。','右侧片后上角64×34缺口避让舵机；线不跨球头全行程。'],'灯槽／卡扣参考不是已核SKU；按实物位置打侧板孔，不穿透LED线路。')
    return prints

def re_id(id,prefix,a,b):
    # Includes matching angle and its fastener records.
    try:return id.startswith(prefix) and a<=int(id[len(prefix):].split('-')[0])<=b
    except ValueError:return False

def run():
    prints=build()
    # Validate physical fixed solids after bounding-box pruning, excluding vendor envelopes,
    # fasteners (thread mating) and intentional PP-to-PP weld contacts.
    physical=[p for p in parts if not p['reference'] and p['material']!='profile']
    for p in physical:check('valid_'+p['id'],solids[p['id']].val().isValid())
    clashes=[]
    for i,a in enumerate(physical):
        for b in physical[i+1:]:
            if any(min(a['bounds'][j+3],b['bounds'][j+3])-max(a['bounds'][j],b['bounds'][j])<1e-5 for j in range(3)):continue
            v=solids[a['id']].intersect(solids[b['id']]).val().Volume()
            if v>1e-4:clashes.append([a['id'],b['id'],round(v,4)])
    (ROOT/'clashes.json').write_text(json.dumps(clashes,indent=2)+'\n')
    check('fixed_material_solids_clear',not clashes,clashes)
    for i,(id,name,s,shift,job) in enumerate(prints):check(id+'_original_geometry',abs(solids[id].val().Volume()-s.val().Volume())<1e-5)
    for i in range(21):
        angle=math.radians(-40.706341765388494*(1-i/20));p=[170-16*math.cos(angle),180+16*math.sin(angle),337.5];q=[110,p[1]+math.sqrt(2500-(p[0]-110)**2),337.5];dy=q[1]-184;motion_clashes=[]
        for id in ['H36','P26']:
            s=solids[id].translate((0,dy,0));bb=bounds(s)
            for fixed in physical:
                if fixed['id'] in ['H36','P26']:continue
                if any(min(bb[j+3],fixed['bounds'][j+3])-max(bb[j],fixed['bounds'][j])<1e-5 for j in range(3)):continue
                if s.intersect(solids[fixed['id']]).val().Volume()>1e-4:motion_clashes.append([id,fixed['id']])
        check('motion_%02d_fixed_clear'%i,not motion_clashes,motion_clashes)
        check('motion_%02d_rod_flag_clear'%i,p2.capsule(p,q,1.7).intersect(solids['P26'].translate((0,dy,0))).val().Volume()<1e-5)
        for x in [110,120]:check('motion_%02d_fastener_%d_window'%(i,x),cylinder([x,184+dy,319],[0,0,1],3.2,7).intersect(solids['P30']).val().Volume()<1e-5)
    # Central front/rear light rays remain open even with optional background panels.
    for y,d in [(30,[0,1,0]),(210,[0,-1,0])]:
        ray=cylinder([110,y,260],d,.05,90)
        check('central_camera_ray_'+str(y),all(ray.intersect(solids[p['id']]).val().Volume()<1e-5 for p in physical))
    source=json.loads((H3/'design-h3.json').read_text())
    data={'revision':'H3-P4','date':'2026-10-22','units':'mm','frame':[220,240,460],'parts':parts,'joints':joints,'hardware_counts':dict(hardware),'original_H3':source,'physical_verified':False,'changes':{'wood_bottom_z':22,'cup_bottom_z':28,'display_y':20,'top_ring_z':440,'servo_axis':[170,180,331],'camera_z':260,'printed_parts_changed':False}}
    (ROOT/'assembly-data.json').write_text(json.dumps(data,ensure_ascii=False,separators=(',',':'))+'\n')
    (ROOT/'geometry-check.json').write_text(json.dumps({'checks':checks,'clashes':clashes,'host_only':True,'physical_verified':False},ensure_ascii=False,indent=2)+'\n')
    assembly=cq.Assembly(name='H3_P4_MECHANICAL_REFERENCE_NOT_FOR_PRINT')
    for p in parts:
        if p['material']=='hardware':continue
        assembly.add(solids[p['id']],name=p['id'].replace('-','_'))
    assembly.export(str(ROOT/'assembly-p4-reference-NOT-FOR-PRINT.step'))
    print(json.dumps({'parts':len(parts),'printed':len(prints),'joints':len(joints),'checks':len(checks),'hardware':dict(hardware),'clashes':clashes},ensure_ascii=False))

if __name__=='__main__':run()
