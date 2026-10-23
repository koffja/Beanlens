'use strict';
window.createBeanLensModel=function(screenCanvas){
 const T=THREE,D=BEANLENS_H3_DATA.geometry,m=createBeanLensH1BaseModel(screenCanvas),{root,groups,V}=m;
 const black=groups.H03.children[0].material,alu=groups.H10.children[0].material,pp=groups.H13.children[0].material,wood=m.work.children[0].material;
 const mat=(color,metalness=0,roughness=.5)=>new T.MeshStandardMaterial({color,metalness,roughness});
 const steel=mat('#b7c6ce',.75,.3),brass=mat('#bb974f',.6,.35),dark=mat('#24343d',.1,.55);
 function mesh(g,geo,material,pos){const o=new T.Mesh(geo,material);if(pos)o.position.copy(pos);o.castShadow=o.receiveShadow=true;g.add(o);return o;}
 function box(g,x,y,z,w,d,h,material){return mesh(g,new T.BoxGeometry(w,h,d),material,V(x+w/2,y+d/2,z+h/2));}
 function clear(g){g.clear();}
 function group(id,name,copy){const g=new T.Group();g.userData={id,name,copy};groups[id]=g;root.add(g);return g;}
 function cyl(g,x,y,z,r,h,material){return mesh(g,new T.CylinderGeometry(r,r,h,24),material,V(x,y,z));}
 function bolt(g,x,y,z){cyl(g,x,y,z,2.5,1.2,steel);box(g,x-1.6,y-.25,z+.6,3.2,.5,.2,black);}
 function plate(g,x,y,z,w,d,h,hole,material){const s=new T.Shape();s.moveTo(0,0);s.lineTo(w,0);s.lineTo(w,d);s.lineTo(0,d);s.closePath();if(hole){const [hx,hy,hw,hd]=hole,p=new T.Path();p.moveTo(hx,hy);p.lineTo(hx,hy+hd);p.lineTo(hx+hw,hy+hd);p.lineTo(hx+hw,hy);p.closePath();s.holes.push(p);}const geo=new T.ExtrudeGeometry(s,{depth:h,bevelEnabled:false});geo.rotateX(-Math.PI/2);const uv=geo.attributes.uv;for(let i=0;i<uv.count;i++)uv.setXY(i,uv.getX(i)/176,uv.getY(i)/196);return mesh(g,geo,material,V(x,y,z));}
 const walls=[];
 function wall(g,points,t,material=pp){const p=points.map(p=>V(...p)),n=p[1].clone().sub(p[0]).cross(p[2].clone().sub(p[0])).normalize();const center=p.reduce((a,v)=>a.add(v),new T.Vector3()).multiplyScalar(.25);const outward=new T.Vector3(center.x-110,0,center.z-120);if(n.dot(outward)<0)n.negate();const all=[...p,...p.map(v=>v.clone().addScaledVector(n,t))],idx=[0,1,2,0,2,3,4,6,5,4,7,6,0,4,5,0,5,1,1,5,6,1,6,2,2,6,7,2,7,3,3,7,4,3,4,0],geo=new T.BufferGeometry();geo.setAttribute('position',new T.Float32BufferAttribute(all.flatMap(v=>v.toArray()),3));geo.setIndex(idx);geo.computeVertexNormals();const o=mesh(g,geo,material.clone());walls.push(o);return o;}
 function funnel(g,top,bottom,zt,zb){const [tw,td]=top,[bw,bd]=bottom;const a=[[110-tw/2,120-td/2,zt],[110+tw/2,120-td/2,zt],[110+tw/2,120+td/2,zt],[110-tw/2,120+td/2,zt]],b=[[110-bw/2,120-bd/2,zb],[110+bw/2,120-bd/2,zb],[110+bw/2,120+bd/2,zb],[110-bw/2,120+bd/2,zb]];for(let i=0;i<4;i++)wall(g,[a[i],a[(i+1)%4],b[(i+1)%4],b[i]],2);}
 function pipe(g,z0,z1){box(g,99,111,z0,2,18,z1-z0,pp);box(g,119,111,z0,2,18,z1-z0,pp);box(g,101,111,z0,18,2,z1-z0,pp);box(g,101,127,z0,18,2,z1-z0,pp);}
 function tube(g,points,color,r=.65){const path=new T.CatmullRomCurve3(points.map(p=>V(...p)));return mesh(g,new T.TubeGeometry(path,40,r,8,false),mat(color));}
 // Remove H1's opaque camera platform and inclined static bean lane.
 clear(m.work);plate(m.work,22,22,180,176,196,6,[58,68,60,60],wood);m.work.userData.copy='H3工作板开60×60通孔；下斗从孔中穿过并由外侧小耳固定。';
 clear(m.upper);box(m.upper,22,17,334,176,6,88,wood[0]);m.upper.userData.copy='只保留前方BOX承板；去掉原Z344整层板，腾出竖直豆路。';
 const supports=group('H16-camera','前后相机木横条','176×30×6两条，Z234–240；每端有2020角片承托。来自原第三块木板，不再新增整层平台。');
 for(const y of [2,208]){plate(supports,22,y,234,176,30,6,null,wood);for(const x of [22,190]){box(supports,x,y+6,230,8,18,3,alu);box(supports,x===22?20:198,y+6,224,2,18,12,alu);bolt(supports,x+4,y+15,240.8);}}
 const feed=groups.H13;clear(feed);feed.userData={id:'H13',name:'顶入豆PP漏斗与单槽固定盒',copy:'80×80口收至18×14单槽；前方固定外壳连续，铝片从后方抽拉。仅人工一次一颗，不是可自动分出单颗的储料斗。'};
 funnel(feed,[80,80],[18,14],440,350);pipe(feed,329.3,350);pipe(feed,300,321);
 // Fixed enclosure joins the front pocket; neither the leading edge nor beans exit the front.
 const front=box(feed,85,93,321,50,2,29,pp);walls.push(front);
 for(const x of [85,133])box(feed,x,95,321,2,16,29,pp);
 const topRing=group('H39','顶斗承重环与四角支承','PP3顶环176×196、80×80开口。四只角铝把顶环托在顶部2020，斗壁外焊到环口；载荷传给框架，不能只靠细焊缝悬挂。');
 plate(topRing,22,22,440,176,196,3,[48,58,80,80],pp);
 for(const x of [22,178])for(const y of [22,198]){box(topRing,x,y,437,20,20,2,alu);box(topRing,x===22?20:198,y,421,2,20,18,alu);bolt(topRing,x+10,y+10,444);}
 const guide=group('H38','上下盖板＋两侧垫条','上下PP3盖板50×85，PP2+PET0.3两侧垫条组成2.3高导槽；2mm铝闸片上下总隙0.3、左右各0.3。冷却修平后先手推，不能焊死。');
 for(const z of [321,326.3])plate(guide,85,95,z,50,85,3,[16,18,18,14],pp);
 for(const x of [85,125]){box(guide,x,95,324,10,85,2,pp);box(guide,x,95,326,10,85,.3,dark);}
 for(const x of [90,130])for(const y of [105,165]){cyl(guide,x,y,325.5,1.5,10,steel);bolt(guide,x,y,330.1);}
 // Guide box is carried by the two rear uprights through a fixed cross shelf.
 const carrier=group('H13-support','闸盒后支承','PP3 176×50承托片固定到后立柱两端角片；闸盒后段压在承托片上。紧固位避开滑轨和球头；与上斗顶环形成两处支承。');
 plate(carrier,22,165,318,176,50,3,null,pp);
 for(const x of [22,178]){box(carrier,x,207,315,20,13,2,alu);box(carrier,x===22?20:198,207,303,2,23,14,alu);bolt(carrier,x+10,209,322);}
 // Two fixed external ears bridge the guide box to its rear cross shelf; no bean-path screw ends.
 for(const x of [90,130])bolt(carrier,x,171,330.1);
 const gate=group('H36','小型6061铝抽拉闸片','29.4×82×2mm；关时前缘Y108覆盖18×14口，开时后退19.749mm。前方封闭承接，不把豆从外壁推出；只在豆路确认空后缓关。');
 plate(gate,95.3,108,324,29.4,82,2,null,alu);
 // Tail flag runs beside the guide and contacts two fixed low-load switches.
 box(gate,124.7,181,333,20,6,3,pp);box(gate,124.7,181,326,2,6,10,pp);
 const spacer=group('H12','闸片球头同高隔柱','M3×8隔柱＋球头螺柱/垫片；两端球心名义同高337.5。实际球头中心尺寸不同，先量再垫，禁止横向掰紧。');
 cyl(spacer,110,184,330,2.6,8,brass);cyl(spacer,110,184,335.5,1.5,3,steel);
 const servo=groups.H03;servo.position.copy(V(30,54,91).sub(V(0,0,0)));servo.userData.copy='MG996R机身锁在右后立柱固定架，轴心(170,180,331)，机身不跟连杆动。独立UBEC6V供电。';
 groups.H10.position.copy(servo.position);groups.H10.userData.copy='标准MG996R固定架＋60×60×3铝毛坯，借2020加强角码悬臂锁在右后立柱；孔位和高度收到实物后定。';
 // Remove obsolete H1 switch-support tabs from the servo mount, then add its frame attachment.
 groups.H10.children.slice(-4).forEach(o=>groups.H10.remove(o));
 box(groups.H10,140,166,187,30,20,2,alu);box(groups.H10,168,166,160,2,20,29,alu);
 // Old coordinates above are translated with mount: X170..200/Y220..240/Z278..280.
 const limits=groups.H09;const switches=[...limits.children];limits.clear();
 for(let i=0;i<2;i++){const sw=switches[i];sw.position.copy(V(150,i?203.748684:184,331));sw.rotation.y=Math.PI/2;limits.add(sw);box(limits,146,i?198:178,320,2,12,12,alu);box(limits,135,i?198:178,320,13,12,2,alu);}
 limits.userData.copy='开/关位看闸片尾部小旗，不只看舵机轴。位置是示意，须滑片手推后调整触发与安全余量。';
 // Rebuild one recognizable straight horn, with a drilled R16 joint rather than a second arm.
 root.remove(m.rotating);const crank=group('H11','一只25T直臂','输出轴到球头中心R16mm；舵臂转动通过一根50mm球心距短杆推拉闸片，两个球头允许杆角变化。');crank.position.copy(V(170,180,331));
 const hs=new T.Shape();hs.moveTo(4,-3.5);hs.lineTo(-23,-3.5);hs.quadraticCurveTo(-28,-3.5,-28,0);hs.quadraticCurveTo(-28,3.5,-23,3.5);hs.lineTo(4,3.5);hs.closePath();for(const x of [-8,-16,-24]){const h=new T.Path();h.absarc(x,0,1.5,0,Math.PI*2,true);hs.holes.push(h);}const hg=new T.ExtrudeGeometry(hs,{depth:3,bevelEnabled:false});hg.rotateX(-Math.PI/2);mesh(crank,hg,alu,new T.Vector3(0,.3,0));mesh(crank,new T.CylinderGeometry(5.3,5.3,4,32),alu,new T.Vector3(0,2.3,0));mesh(crank,new T.CylinderGeometry(2.5,2.5,1,24),steel,new T.Vector3(0,5,0));
 const linkage=group('H37','两颗球头＋一根50mm连杆','采购看两球心中心距50mm，M3连接件；2颗球头不是2只舵臂。动画每帧按几何约束计算，杆长保持50mm。');
 const rod=mesh(linkage,new T.CylinderGeometry(1.7,1.7,1,24),steel),ends=[];
 for(let i=0;i<2;i++){const g=new T.Group();linkage.add(g);mesh(g,new T.SphereGeometry(3.7,24,16),dark);mesh(g,new T.SphereGeometry(2.4,24,16),steel,new T.Vector3(0,.5,0));mesh(g,new T.CylinderGeometry(1.5,1.5,5,16),steel,new T.Vector3(0,-3,0));ends.push(g);}
 m.rotating=crank;m.crank=crank;m.gate=gate;m.linkage=linkage;
 m.setGate=function(u){const a=T.MathUtils.degToRad(D.gate.theta_closed_deg*(1-u)),p=[170-16*Math.cos(a),180+16*Math.sin(a),337.5],q=[110,p[1]+Math.sqrt(2500-(p[0]-110)**2),337.5],dy=q[1]-184;crank.rotation.y=-a;gate.position.z=-dy;spacer.position.z=-dy;const pv=V(...p),qv=V(...q);ends[0].position.copy(pv);ends[1].position.copy(qv);rod.position.copy(pv).add(qv).multiplyScalar(.5);const direction=qv.clone().sub(pv);rod.scale.y=direction.length();rod.quaternion.setFromUnitVectors(new T.Vector3(0,1,0),direction.normalize());m.gateState={theta_deg:T.MathUtils.radToDeg(a),slide_mm:dy,crank_ball:p,gate_ball:q,rod_length_mm:pv.distanceTo(qv),leading_y:108+dy};};m.setGate(0);
 // Front and rear cameras share a horizontal axis. Their detailed PCB/lens is reused as appearance only.
 const originalCamera=groups.H02;root.remove(originalCamera);root.remove(groups.H18);
 const cameras=group('H02','前后两只GC2093水平相向','两镜头均在Z260，前摄沿+Y，后摄沿−Y。豆从中间开放窗下落；没有透明托片，也没有上下拍摄相机。');
 const oldOrigin=V(110,112,319.5);
 for(let i=0;i<2;i++){const pivot=new T.Group(),camera=originalCamera.clone(true);camera.position.copy(oldOrigin).negate();camera.userData={id:i?'H02-B':'H02-A',name:i?'后摄B · 水平向前':'前摄A · 水平向后',copy:'镜头名义工作距离90mm；模组孔位、排线空间与近焦范围按实物。开闸前已在采集，落豆时挑出同周期的清楚帧。'};pivot.add(camera);pivot.position.copy(V(110,i?210:30,260));pivot.rotation.x=i?-Math.PI/2:Math.PI/2;cameras.add(pivot);}
 const camMounts=[];
 for(let i=0;i<2;i++){const g=group(i?'H34':'H18',i?'后相机角铝支架':'前相机角铝支架','角铝固定到海洋板横条，PP3载板与M2隔柱固定PCB，独立调焦。载板孔按实物，不从40mm占位推孔。');const y=i?235:2;box(g,80,y,240,60,3,45,pp);box(g,132,i?214:5,240,2,20,20,alu);box(g,112,i?214:5,240,22,20,2,alu);for(const x of [94,126])bolt(g,x,i?222:18,242.6);camMounts.push(g);}
 const collect=group('H40','下接豆斗','内顶64×64/Z220收至30×30/Z160；穿过工作台60×60孔，用外焊耳锁到木台。斗口低于摄影窗，不遮水平镜头。');funnel(collect,[64,64],[30,30],220,160);
 for(const x of [77,137])for(const y of [97,137]){box(collect,x,y,186,6,6,2,pp);bolt(collect,x+3,y+3,189);}
 // Four LED U channels stand to the sides, outside the central front/rear sight line.
 const lights=groups.H07;clear(lights);lights.userData.copy='两面各两条侧照常亮灯，总有效0.4m、8W预算。实际短曝光亮度、发热、阴影待实拍调整。';const emit=mat('#fff2ca');emit.emissive=new T.Color('#ffe3aa');emit.emissiveIntensity=.65;
 for(const x of [70,142])for(const y of [77,151]){box(lights,x,y,210,8,3,100,alu);box(lights,x,y,210,1,6,100,alu);box(lights,x+7,y,210,1,6,100,alu);for(let i=0;i<12;i++)box(lights,x+2,y+3,214+i*7.7,4,1,4,emit);}
 clear(m.shield);for(const x of [62,176])box(m.shield,x,60,225,2,120,70,black);
 // Real circular apertures leave both horizontal optical axes open.
 for(const y of [28,210]){const s=new T.Shape();s.moveTo(0,0);s.lineTo(110,0);s.lineTo(110,50);s.lineTo(0,50);s.closePath();const h=new T.Path();h.absarc(45,18,12,0,Math.PI*2,true);s.holes.push(h);const geo=new T.ExtrudeGeometry(s,{depth:2,bevelEnabled:false});geo.scale(1,1,-1);const material=black.clone();material.side=T.DoubleSide;mesh(m.shield,geo,material,V(65,y,242));}
 m.shield.userData.copy='可拆侧遮光片；前后背景片带φ24镜头孔，孔中心X110/Z260，下缘Z242让开木横条。不能恢复H1整后挡板；孔径/边界按模组和实拍重核。';
 clear(m.wiring);for(let i=0;i<3;i++)tube(m.wiring,[[170+i,213,291],[193+i,218,280],[205+i,244,240],[205+i,248,161]],['#3a3028','#b34d46','#d29645'][i]);
 for(const y of [12,227])tube(m.wiring,[[110,y,276],[158,y,285],[191,y,347],[140,20,375]],'#d8c8a7',1.4);
 tube(m.wiring,[[78,8,356],[30,25,345],[28,220,190],[10,245,161]],'#29343b',.9);
 root.remove(m.capture);const capture=new T.Group();root.add(capture);m.capture=capture;
 const paths=new T.Group();root.add(paths);m.paths=paths;
 for(const [lens,color] of [[[110,30,260],'#3a99b3'],[[110,210,260],'#d4a153']]){const line=new T.Line(new T.BufferGeometry().setFromPoints([V(...lens),V(110,120,260)]),new T.LineDashedMaterial({color,dashSize:3,gapSize:2}));line.computeLineDistances();paths.add(line);const from=V(...lens),to=V(110,120,260),dir=to.clone().sub(from);const cone=mesh(capture,new T.ConeGeometry(15,90,32,1,true),new T.MeshBasicMaterial({color,transparent:true,opacity:.09,depthWrite:false,side:T.DoubleSide}),from.clone().add(to).multiplyScalar(.5));cone.quaternion.setFromUnitVectors(new T.Vector3(0,1,0),dir.normalize().negate());}
 const zone=mesh(paths,new T.BoxGeometry(22,50,22),new T.MeshBasicMaterial({color:'#3a99b3',transparent:true,opacity:.035,depthWrite:false}),V(110,120,260));zone.add(new T.LineSegments(new T.EdgesGeometry(zone.geometry),new T.LineBasicMaterial({color:'#6d9d9d',transparent:true,opacity:.35})));
 m.setCutaway=function(enabled){walls.forEach(o=>{o.material.transparent=enabled;o.material.opacity=enabled?.45:1;o.material.depthWrite=!enabled;o.material.needsUpdate=true;});};
 const labelDefs=[['H13 · 顶入豆漏斗',90,100,418],['H36 · 后拉约20mm',108,161,340],['H37 · 双球头连杆',147,185,345],['H03 · 固定舵机',178,193,303],['A · 前摄水平向后',85,25,250],['B · 后摄水平向前',80,215,270],['双摄落豆窗 · Z260',110,120,260],['H40 · 下接豆斗',136,136,214],['H39 · 顶环/角片承重',170,194,448]];
 m.labels=labelDefs.map(([text,x,y,z])=>({text,point:V(x,y,z),kind:'fixed',views:['mechanism','whole']}));
 m.explode=[];for(const [g,shift] of [[feed,[-80,45,0]],[topRing,[-55,85,0]],[guide,[-45,20,10]],[gate,[10,45,35]],[spacer,[10,45,35]],[crank,[55,70,0]],[servo,[90,-10,0]],[groups.H10,[100,-35,0]],[linkage,[45,100,20]],[limits,[90,30,-25]],[cameras,[0,0,65]],[camMounts[0],[-45,0,30]],[camMounts[1],[45,0,-30]],[collect,[-55,-20,0]],[carrier,[0,-30,0]]])m.explode.push({group:g,base:g.position.clone(),shift});
 m.pickables=[];root.traverse(o=>{if(o.isMesh){delete o.userData.component;let p=o;while(p&&!p.userData.id)p=p.parent;if(p){o.userData.component=p.userData;m.pickables.push(o);}}});
 m.opticalObstructions=function(){root.updateMatrixWorld(true);const meshes=[];root.traverse(o=>{if(!o.isMesh)return;let p=o;while(p){if([cameras,m.bean,capture,paths,m.wiring].includes(p))return;p=p.parent;}meshes.push(o);});return [[110,30,260],[110,210,260]].map(lens=>{const from=V(...lens),dir=V(110,120,260).sub(from).normalize();return new T.Raycaster(from,dir,2,88).intersectObjects(meshes).map(h=>h.object.userData.component?.id||'unlabelled');});};
 m.cameraSupports=supports;m.topRing=topRing;m.guide=guide;m.collector=collect;m.carrier=carrier;
 return m;
};
