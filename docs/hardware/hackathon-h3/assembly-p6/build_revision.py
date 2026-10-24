"""H3-P6 manual-feed revision. Existing P1-P4 assets are read only.
Run in the separate /tmp/beanlens-h3p1-cad-env, not the training environment.
"""
from pathlib import Path
import importlib.util,json,math,csv,copy,hashlib
from collections import Counter
import cadquery as cq

ROOT=Path(__file__).resolve().parent
H3=ROOT.parent
spec=importlib.util.spec_from_file_location('p4_source',H3/'assembly-p4/build_assembly.py')
p4=importlib.util.module_from_spec(spec);spec.loader.exec_module(p4)
B=p4.B;drill=p4.drill;holes_z=p4.holes_z;bounds=p4.bounds
parts=[];solids={};joints=[];checks=[];hw=Counter()

def check(name,value,detail=None):
    checks.append(dict(name=name,pass_=bool(value),detail=detail))
    if not value:raise AssertionError((name,detail))

def add(id,name,bom,material,system,s,shift=(0,0,0),note='',reference=False,visual=None):
    assert id not in solids,id
    s=s.clean();solids[id]=s
    verts,faces=s.val().tessellate(.14,.15)
    r=dict(id=id,name=name,bom=bom,material=material,system=system,color=p4.COLORS[material],bounds=bounds(s),explode=list(shift),note=note,reference=reference,vertices=[[v.x,v.y,v.z] for v in verts],triangles=faces)
    if visual:r['visual_transform']=visual
    parts.append(r)
    return id

def bolt(id,key,entry,d,length,stack,system,tnut=False,small_washer=False):
    # Reuse the nominal bolt builder in memory; it never writes P4 files.
    if small_washer:
        assert key=='M3x10' and not tnut
        p=cq.Vector(*entry);v=cq.Vector(*d);under=p-v*.5
        pieces=[p4.cylinder(under.toTuple(),d,1.5,length),p4.cylinder((under-v*2.3).toTuple(),d,2.75,2.3),p4.cylinder((p-v*.5).toTuple(),d,3.5,.5),p4.cylinder((p+v*stack).toTuple(),d,3.5,.5),p4.cylinder((p+v*(stack+.5)).toTuple(),d,3.2,2.4)]
        shape=cq.Workplane(obj=cq.Compound.makeCompound([s.val() for s in pieces]))
        add(id,key+' 螺栓／φ7垫片／防松螺母','K-'+key,'hardware',system,shape,tuple(-a*20 for a in d),'仅灯脚竖翼8套用常规外φ7平垫，留开螺母上方灯带。',True)
        hw[key]+=1
        return id
    temp='P6-TEMP-'+id
    before=len(p4.parts);p4.fastener(temp,key,entry,d,length,stack,system,tnut)
    r=copy.deepcopy(p4.parts[-1]);assert len(p4.parts)==before+1
    r['id']=id;parts.append(r);solids[id]=p4.solids[temp];hw[key]+=1
    return id

def j(id,title,chain,ids,fasteners,target,steps,note=''):
    joints.append(dict(id=id,title=title,chain=chain,parts=ids,fasteners=fasteners,target=target,steps=steps,note=note))

def copy_part(r,delta=(0,0,0)):
    id=r['id'];s=p4.solids[id].translate(delta)
    add(id,r['name'],r['bom'],r['material'],r['system'],s,r['explode'],r['note'],r['reference'],dict(translate=list(delta)) if any(delta) else None)
    if r['material']=='hardware':hw[r['name'].split(' ')[0]]+=1

def notched_board(z):
    s=B(0,0,z,220,240,6)
    for x in [0,197.5]:
        for y in [0,217.5]:s=s.cut(B(x,y,z-.1,22.5,22.5,6.2))
    return s

def base():
    p4.build()
    for r in list(p4.parts):
        keep=(r['system']=='frame' or p4.re_id(r['id'],'A',1,4) or r['system']=='collector' or r['system']=='screen')
        if keep:copy_part(r,(0,0,-110) if r['system']=='screen' else (0,0,0))
    bottomholes=[(x,y) for x in [60,160] for y in [10,230]]
    add('W01','嵌角底木板 240×220×6','W01','wood','wood',holes_z(notched_board(22),bottomholes,22,6,5.5),(0,-25,-20),'220沿X、240沿Y；四角22.5方缺口；底22顶28，4只PP2垫片避开底框角码。')
    for i,(x,y) in enumerate(bottomholes,1):
        add('BP'+str(i),'底板黑PP2支承垫片','N03','pp','wood',holes_z(B(x-20,y-10,20,40,20,2),[(x,y)],20,2,5.5),(0,0,-6),'40×20×2，放底梁顶；与框角码2mm厚齐平。')
        bolt('BOTTOM-'+str(i),'M5x14',[x,y,28],[0,0,-1],14,8,'wood',True)
    points=[(x,y) for x in [30,190] for y in [30,210]]+[(x,y) for x in [73,147] for y in [83,157]]
    points += [(x+dx,y) for x in [60,160] for dx in [-5,5] for y in [40,200]]
    work=notched_board(180).cut(B(80,90,179.9,60,60,6.2))
    add('W02','嵌角下斗承板 240×220×6','W02','wood','wood',holes_z(work,points,180,6),note='220沿X、240沿Y，四角22.5×22.5；底180。中60方孔，另8灯架脚孔。')
    for r in parts:
        if r['system']=='screen':
            r['note']='BOX承板底Z224，原壳／接口先试配；J7供电线须从原壳开口引出，不钻PCB。'
            if r['id']=='W03':r['bom']='W03';r['name']='BOX前承板 176×88×6，底Z224'
    top=B(0,0,460,220,240,6).cut(B(70,80,459.9,80,80,6.2))
    top_holes=[(x,y) for x in [64,156] for y in [74,166]]
    top_fix=[(x,y) for x in [10,210] for y in [60,180]]
    add('W06','顶部海洋板 240×220×6','W06','wood','top',holes_z(holes_z(top,top_holes,460,6),top_fix,460,6,5.5),(0,0,55),'220沿X、240沿Y；整板盖顶框上面，底460顶466；不切角，80方孔。')
    add('P11','打印上漏斗（上移20）','P11','print','top',p4.p1.shape_to_world(p4.p1.upper_body()).translate((0,0,20)),(-70,0,20),'原P1几何不改；整体上移20。法兰贴木板下方，颈出口349.5；不装接座。')
    for i,(x,y) in enumerate(top_holes,1):bolt('TOP-'+str(i),'M3x16',[x,y,466],[0,0,-1],16,10,'top')
    for i,(x,y) in enumerate(top_fix,1):bolt('TOP-FRAME-'+str(i),'M5x12',[x,y,466],[0,0,-1],12,6,'top',True)
    for label,x,y,front in [('FL',50,50,True),('FR',150,50,True),('BL',50,170,False),('BR',150,170,False)]:
        vy=y if front else y+18
        angle=B(x,vy,186,20,2,120).union(B(x if x==50 else x+18,y,186,2,20,120))
        for z in [194,202]:angle=drill(angle,[x+10,vy,z],[0,1,0],1.7,2)
        # Shade fixes to the RETURN wing, not through the LED circuit.
        for z in [250,294]:angle=drill(angle,[x if x==50 else x+18,60 if front else 180,z],[1,0,0],1.7,2)
        add('LA-'+label,'灯带竖角铝 '+label,'L01','aluminum','light',angle,(-25 if x<100 else 25,0,0),'20×20×2长120；右侧回折翼朝外。遮光片固定在回折翼，不能穿灯带。')
        fy=30 if front else 190;fvy=48 if front else 190
        foot=B(x,fy,186,20,20,2).union(B(x,fvy,186,20,2,20))
        for xx in [x+5,x+15]:foot=holes_z(foot,[(xx,40 if front else 200)],186,2)
        for z in [194,202]:foot=drill(foot,[x+10,fvy,z],[0,1,0],1.7,2)
        add('LF-'+label,'灯架脚角片 '+label,'L02','aluminum','light',foot,(0,-20 if front else 20,0),'20×20×2宽20；两翼各2孔防旋。')
        for k,xx in enumerate([x+5,x+15],1):bolt('LF-'+label+f'-W{k}','M3x16',[xx,40 if front else 200,188],[0,0,-1],16,8,'light')
        for k,z in enumerate([194,202],1):bolt('LF-'+label+f'-L{k}','M3x10',[x+10,48 if front else 192,z],[0,1,0] if front else [0,-1,0],10,4,'light',small_washer=True)
    return points,top_holes+top_fix

def shields():
    sideholes=[(y,z) for y in [60,180] for z in [250,294]]+[(y,z) for y in [90,150] for z in [230,322]]+[(56,318),(184,318)]
    for side,left in [('L',True),('R',False)]:
        x=48 if left else 170;s=B(x,44,222,2,152,110)
        s=drill(s,[x,120,260],[1,0,0],16,2)
        for y,z in sideholes:s=drill(s,[x,y,z],[1,0,0],1.7,2)
        add('SH-'+side,('左' if left else '右')+'遮光侧片 φ32镜头孔','SH-'+side,'shield','shade',s,(-45 if left else 45,0,0),'黑PP2；152×110。固定到灯架回折翼，孔避开LED；相机在罩外。')
        for yi,y in enumerate([60,180]):
            for zi,z in enumerate([250,294]):bolt(f'SH-{side}-L{yi}{zi}','M3x10',[48 if left else 172,y,z],[1,0,0] if left else [-1,0,0],10,4,'shade')
    for side,front in [('F',True),('B',False)]:
        y=44 if front else 194;s=B(50,y,222,120,2,110)
        for x in [60,160]:s=drill(s,[x,y,318],[0,1,0],1.7,2)
        add('SH-'+side,('前' if front else '后')+'遮光片','SH-'+side,'shield','shade',s,(0,-35 if front else 35,0),'黑PP2，120×110；上部两孔锁角片，前片在BOX承板后方。')
        for left in [True,False]:
            x=50 if left else 150;vx=50 if left else 168;vy=46 if front else 192;yy=46 if front else 174
            a=B(x,vy,308,20,2,20).union(B(vx,yy,308,2,20,20))
            a=drill(a,[vx,56 if front else 184,318],[1,0,0],1.7,2)
            a=drill(a,[60 if left else 160,vy,318],[0,1,0],1.7,2)
            id=f'SC-{side}{"L" if left else "R"}';add(id,'遮光罩竖角片','S10','aluminum','shade',a,(0,-10 if front else 10,10),'20×20×2宽20；Z308起，位于灯架顶306以上，不与灯架重叠。')
            bolt(id+'-S','M3x10',[48 if left else 172,56 if front else 184,318],[1,0,0] if left else [-1,0,0],10,4,'shade')
            bolt(id+'-F','M3x10',[60 if left else 160,44 if front else 196,318],[0,1,0] if front else [0,-1,0],10,4,'shade')
    roof=B(50,46,332,120,148,2).cut(B(95,107,331.9,30,26,2.2))
    floor=B(52,46,222,116,148,2).cut(B(74,84,221.9,72,72,2.2))
    for x in [52,148]:
        for y in [46,168]:floor=floor.cut(B(x,y,221.9,20,26,2.2))
    for which,s,z in [('T',roof,332),('D',floor,222)]:
        s=holes_z(s,[(x,y) for x in [60,160] for y in [90,150]],z,2)
        add('SH-'+which,'遮光顶盖（进豆孔）' if which=='T' else '遮光底片（下斗孔）','SH-'+which,'shield','shade',s,(0,0,35 if which=='T' else -25),'黑PP2；顶120×148孔30×26，底116×148孔72方并四角让灯架；保留进出豆与通风间隙。')
        for left in [True,False]:
            for y in [80,140]:
                x=50 if left else 150;vx=50 if left else 168;shelf=330 if which=='T' else 220
                a=B(x,y,shelf,20,20,2).union(B(vx,y,312 if which=='T' else 220,2,20,20))
                hx=60 if left else 160;hz=322 if which=='T' else 230
                a=holes_z(a,[(hx,y+10)],shelf,2);a=drill(a,[vx,y+10,hz],[1,0,0],1.7,2)
                id=f'SA-{which}{"L" if left else "R"}{y}';add(id,'遮光顶／底承托角片','S10','aluminum','shade',a,(-15 if left else 15,0,10 if which=='T' else -10),'20×20×2宽20，一翼穿侧片，另一翼穿顶／底PP。')
                bolt(id+'-S','M3x10',[48 if left else 172,y+10,hz],[1,0,0] if left else [-1,0,0],10,4,'shade')
                bolt(id+'-P','M3x10',[hx,y+10,z+2],[0,0,-1],10,4,'shade')
    return sideholes

def camera_layout():
    """User confirmed: optical lens separation200, BOX between the two in X.
    """
    cameras=[]
    for pid,oid,name,dx in [('P22','H02-A','右',10),('P23','H02-B','左',-10)]:
        original=p4.solids[pid]
        s=original.rotate((110,120,0),(110,120,1),90).translate((dx,0,0))
        add(pid,name+'相机打印座（原'+('前' if pid=='P22' else '后')+'座转向）',pid,'print','camera',s,(45 if dx>0 else -45,0,20),'P2原件绕Z转90°后移位，形状不改；先核PCB与8mm隔柱。')
        pcb=p4.solids[oid].rotate((110,120,0),(110,120,1),90).translate((dx,0,0))
        add(oid,name+'GC2093相机参考','H02','reference','camera',pcb,(50 if dx>0 else -50,0,20),'厂家外形参考；实物接口与安装孔先核。',True,dict(rotate_z_deg=90,translate=[dx,0,0]))
        lens=[210 if dx>0 else 10,120,260]
        cameras.append(dict(id='A' if dx>0 else 'B',position=name,printed_mount=pid,lens=lens,direction=[-1,0,0] if dx>0 else [1,0,0],pcb_center=[236.2 if dx>0 else -5.5,120,260],rotate_z_deg=90,translate=[dx,0,0]))
    boards=[]
    for id,x,name,cx in [('W04',208,'右',223),('W05',-18,'左',-3)]:
        pts=[(cx,y) for y in [30,94,146,210]]
        add(id,name+'相机海洋板 200×30×6',id,'wood','camera',holes_z(B(x,20,234,30,200,6),pts,234,6),(40 if cx>100 else -40,0,-10),'200沿Y、30沿X；底234、顶240；两端接角铝，中间两孔接原打印座。')
        boards.append(dict(id=id,xyz=[x,20,234],size=[30,200,6],holes_xy=pts))
        for k,y in enumerate([94,146],1):bolt(id+f'-CAM{k}','M3x16',[cx,y,244],[0,0,-1],16,10,'camera')
        for k,front in enumerate([True,False],1):
            ax=200 if cx>100 else -20;yy=20 if front else 200;vy=20 if front else 218
            a=B(ax,yy,232,40,20,2).union(B(ax,vy,214,40,2,20))
            wy=30 if front else 210;a=holes_z(a,[(cx,wy)],232,2)
            px=210 if cx>100 else 10;a=drill(a,[px,vy,224],[0,1,0],2.75,2)
            aid=id+f'-A{k}';add(aid,'相机条到立柱40宽角铝','A-CAM','aluminum','camera',a,(25 if cx>100 else -25,0,0),'20×20×2，裁宽40沿X；一翼进前／后柱Y向槽，一翼托木条；孔偏置。')
            bolt(aid+'-M5','M5x8',[px,22 if front else 218,224],[0,-1,0] if front else [0,1,0],8,2,'camera',True)
            bolt(aid+'-M3','M3x16',[cx,wy,240],[0,0,-1],16,8,'camera')
    return cameras,boards

def run():
    woodholes,ringholes=base();cameras,boards=camera_layout();shadeholes=shields()
    for r in parts:
        if r['id']=='W01':r['bom']='W01'
        if r['id'].startswith('BP'):r['color']=p4.COLORS['shield']
        if r['system']=='wood' and r['id'].startswith('A'):r['bom']='A-WORK'
        if r['id'].startswith('BST'):r['bom']='N01'
        if r['system']=='screen' and r['id'].startswith('A') and r['material']=='aluminum':r['bom']='A-BOX'
    bysys=lambda s:[p['id'] for p in parts if p['system']==s]
    get=lambda prefixes:[p['id'] for p in parts if p['id'].startswith(tuple(prefixes))]
    j('J01','框架两孔角码','型材 → 两孔角码 → M5／槽6螺母',bysys('frame'),['16角码，M5×8 32套'],[20,20,35],['460立柱4根，200深梁4根，180宽梁4根。','每角两只角码分别连两根梁；先找方再对角轻紧。','不安装P4后横梁，原料库存足够。'])
    j('J02','240×220嵌角底板','木板6 → PP2垫片 → 底梁顶槽',['W01','H21','T05','T06','T07','T08']+get(['BP','BOTTOM-']),['M5×14四套候选'],[110,120,25],['220沿X、240沿Y，四角各去22.5方口，避20立柱。','4只黑PP2垫片使板底22，避开框角码；木板不穿入横梁。','四孔X60/160、Y10/230直锁槽母；杯底仍28。'])
    j('J03','240×220嵌角下斗承板','工作台6 → 40宽角铝 → 立柱内槽',['W02','T01','T02','T03','T04']+[p['id'] for p in parts if p4.re_id(p['id'],'A',1,4)],['M3×16四套，M5×8四套'],[110,120,180],['整板220×240×6，四角22.5方口；板底180。','四角开口抱住立柱，四只40宽角片支承。','60方孔与原下斗法兰孔保持；灯架脚另8孔。'])
    j('J04','200×30相机板到立柱','木条6 → 40宽角铝 → 柱槽',get(['W04','W05'])+['T01','T02','T03','T04'],['M3×16四套，M5×8四套'],[110,120,236],['左右各200×30×6，200沿Y，板顶240。','左X−18，右208，Y20；两相机总距200。','托片宽40、左右镜像；含托片总宽260。'])
    j('J05','240×220顶盖直锁顶框','海洋板6 → 顶框上槽',['W06','T09','T10','T11','T12']+get(['TOP-FRAME-']),['M5×12四套候选'],[110,120,462],['整板220×240，不切角，底460顶466，盖在型材上面。','四孔X10/210、Y60/180，M5穿板进顶槽母。','保留80方孔；本版不再用PP顶环或顶平片。'])
    j('J06','上斗与顶部海洋板','上斗法兰4 → 木板6',['P11','W06']+[p['id'] for p in parts if p['id'].startswith('TOP-') and not p['id'].startswith('TOP-FRAME-')],['M3×16四套'],[110,120,415],['法兰贴木板下方460，孔距92不变。','原上斗整体上移20，出口349.5，不改打印文件。','上斗不装满，仍人工逐颗；先准备双流。'])
    j('J10','左右相机与打印座','PCB → 8mm隔柱 → 原打印座 → 200×30木条',bysys('camera'),['底脚M3×16四套','相机M2×5／×8各8只，8mm内内隔柱8只'],[110,120,260],['P22装右，P23装左；原件绕竖轴转90°后使用。','镜头中心X10/210、Y120、Z260，相向间距200。','BOX下移110mm至光轴附近；排线松弯、接口不受力；先检查CSI线长度与同屏采集。'],'200mm镜头间距已由用户确认；排线紫虚线只是走向参考，不是已确认的接口坐标或可用长度。')
    j('J12','下接豆斗到工作台','打印法兰4 → 工作台6',['P13','W02']+get(['LOW-']),['M3×16四套'],[110,120,190],['下斗穿60方孔，90方法兰落在240×220木台顶186。','四孔X73/147、Y83/157，松装对中再紧。','豆通过同一杯；缺图后豆仍已落入杯中，没有分选或追回机构。'])
    j('J13','低位BOX与承板','原壳角压片 → 隔柱20 → 承板6 → 角片 → 柱槽',bysys('screen')+['T01','T02'],['压片M3×35四套，板M3×16四套，柱M5×8四套'],[110,15,265],['原板176×88×6降低到Z224–312，前面Y20。','隔柱和4压片只压原壳角部，不穿PCB。','先核CSI／USB／KEY／TF可达；线缆固定在框架，不拉扯相机口。'])
    j('J14','灯带直接固定20角铝','灯带 → 导热背胶 → 竖角铝 → 脚角片 → 木台',bysys('light')+['W02'],['脚穿木台M3×16八套','脚到竖角铝M3×10八套，两侧φ7平垫'],[110,120,245],['4只20×20×2角铝长120，100灯带直接贴平面，底206顶306，避开螺母。','每脚两颗螺丝穿工作台，另两颗用外φ7平垫锁竖角铝防旋。','灯带线路不钻孔；接头绝缘，线端扎带卸力，先测温升与曝光。'],'取消P4铝槽／卡扣／PP灯板。图上光源为教学参考，实际剪切点、灯宽、发热与阴影先实测。')
    j('J15','六片遮光罩与灯架','PP侧片 → 灯架回折翼 → 灯脚 → 工作台',bysys('shade')+['LA-FL','LA-FR','LA-BL','LA-BR','W02'],['M3×10共32套，12只20宽角片'],[110,120,280],['6片黑PP2：两侧φ32镜头孔、前后、顶进豆孔、底下斗孔。','两侧各4螺丝锁灯架回折翼，不能穿LED；顶底用8承托角片。','前后上角另4角片连接；进出豆孔保留，现场测漏光和视野。'],'实物为黑色不透明；透明模式仅便于看内部，显示开关会改变真实6片。')
    # Nominal material checks, including center rays and the empty manual drop axis.
    physical=[p for p in parts if not p['reference'] and p['material']!='profile']
    for p in physical:check('valid_'+p['id'],solids[p['id']].val().isValid())
    clashes=[]
    for i,a in enumerate(physical):
        for b in physical[i+1:]:
            if any(min(a['bounds'][k+3],b['bounds'][k+3])-max(a['bounds'][k],b['bounds'][k])<1e-6 for k in range(3)):continue
            v=solids[a['id']].intersect(solids[b['id']]).val().Volume()
            if v>1e-4:clashes.append([a['id'],b['id'],round(v,5)])
    check('fixed_material_clear',not clashes,clashes)
    for id in ['P11','P13','P22','P23']:check('print_unchanged_'+id,abs(solids[id].val().Volume()-p4.solids[id].val().Volume())<1e-5)
    for cam in cameras:
        ray=p4.cylinder(cam['lens'],cam['direction'],.05,99.9)
        check('camera_center_ray_'+cam['id'],all(ray.intersect(solids[p['id']]).val().Volume()<1e-5 for p in physical))
    for cam in cameras:
        for yy in [95,145]:
            for zz in [235,285]:
                start=cq.Vector(*cam['lens']);end=cq.Vector(110,yy,zz);v=end-start
                ray=p4.cylinder(start.toTuple(),v.normalized().toTuple(),.03,v.Length)
                check(f'ROI_ray_{cam["id"]}_{yy}_{zz}',all(ray.intersect(solids[p['id']]).val().Volume()<1e-5 for p in physical))
    check('six_shields',sum(p['material']=='shield' for p in parts)==6)
    drop=p4.cylinder([110,120,221],[0,0,1],.1,128.4)
    check('manual_drop_center_clear',all(drop.intersect(solids[p['id']]).val().Volume()<1e-5 for p in physical))
    check('no_actuator_parts',not any(p['system'] in ['servo','gate'] for p in parts))
    check('four_prints',sum(p['material']=='print' for p in parts)==4)
    check('twelve_profiles',sum(p['material']=='profile' for p in parts)==12)
    lights=[dict(id='LED-'+label,x=x+4,y=y,z=206,front=front) for label,x,y,front in [('FL',50,52.1,True),('FR',150,52.1,True),('BL',50,187.4,False),('BR',150,187.4,False)]]
    for light in lights:
        strip=B(light['x'],light['y'],light['z'],10,.5,100)
        for k in [1,2]:check('LED_clear_of_fastener_'+light['id']+'_'+str(k),strip.intersect(solids['LF-'+light['id'][4:]+f'-L{k}']).val().Volume()<1e-5)
    paths=[dict(id='CSI-A',points=[[236.2,120,278],[222,104,290],[180,58,285],[143,16,270]]),dict(id='CSI-B',points=[[-5.5,120,278],[10,104,290],[40,58,285],[77,16,270]])]
    for path in paths:path['polyline_length_mm']=round(sum(math.dist(a,b) for a,b in zip(path['points'],path['points'][1:])),2);path['interface_positions_verified']=False
    data=dict(revision='H3-P6',date='2026-10-24',units='mm',frame=[220,240,460],overall_width_mm=260,parts=parts,joints=joints,hardware_counts=dict(hw),original_H3=json.loads((H3/'design-h3.json').read_text()),physical_verified=False,camera_layout_confirmed=True,camera_layout_decision='user confirmed lens separation approximately200mm, BOX between cameras, horizontal opposed left-right',cameras=cameras,camera_axis='horizontal_opposed_left_right',camera_separation_mm=200,camera_boards=boards,camera_bracket_spec='20×20×2，宽40沿X；外伸木条孔偏置',station=[110,120,260],lights=lights,cable_routes=paths,angle_stock=dict(pieces={40:8,20:20,120:4},raw_1m_count=2),wood_holes=woodholes,ring_holes=ringholes,shade_holes=shadeholes,feed_top_z=460,upper_exit_z=349.5,top_board=[220,240,6],corner_notch=22.5)
    (ROOT/'assembly-data.json').write_text(json.dumps(data,ensure_ascii=False,separators=(',',':'))+'\n')
    (ROOT/'geometry-check.json').write_text(json.dumps(dict(checks=checks,clashes=clashes,host_only=True,physical_verified=False),ensure_ascii=False,indent=2)+'\n')
    assembly=cq.Assembly(name='H3_P6_MANUAL_MECHANICAL_REFERENCE')
    for p in parts:
        if p['material']!='hardware':assembly.add(solids[p['id']],name=p['id'].replace('-','_'))
    assembly.export(str(ROOT/'assembly-p6-reference-NOT-FOR-PRINT.step'))
    print(json.dumps(dict(parts=len(parts),checks=len(checks),hardware=dict(hw),clashes=clashes,cables=paths),ensure_ascii=False))

if __name__=='__main__':run()
