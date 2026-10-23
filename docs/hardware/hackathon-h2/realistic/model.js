'use strict';
window.createBeanLensModel=function(screenCanvas){
 const T=THREE,D=BEANLENS_H2_DATA.geometry,old=createBeanLensH1BaseModel(screenCanvas),{root,groups,V}=old;
 const black=groups.H03.children[0].material,alu=groups.H10.children[0].material,pp=groups.H13.children[0].material,woodMats=old.work.children[0].material;
 const material=(color,metalness=0,roughness=.5)=>new T.MeshStandardMaterial({color,metalness,roughness});
 const steel=material('#b5c1c8',.75,.3),dark=material('#25323a',.2,.4);
 function mesh(g,geo,mat,pos){const o=new T.Mesh(geo,mat);if(pos)o.position.copy(pos);o.castShadow=true;o.receiveShadow=true;g.add(o);return o;}
 function box(g,x,y,z,w,d,h,m){return mesh(g,new T.BoxGeometry(w,h,d),m,V(x+w/2,y+d/2,z+h/2));}
 function clear(g){while(g.children.length)g.remove(g.children[0]);}
 function group(id,name,copy){const g=new T.Group();g.userData={id,name,copy};root.add(g);groups[id]=g;return g;}
 function bolt(g,x,y,z){const o=mesh(g,new T.CylinderGeometry(1.7,1.7,1,24),steel,V(x,y,z));box(g,x-1,y-.16,z+.5,2,.32,.15,black);return o;}
 function panel(g,x,y,z,w,d,h,hole,mats){const s=new T.Shape();s.moveTo(0,0);s.lineTo(w,0);s.lineTo(w,d);s.lineTo(0,d);s.closePath();if(hole){const [hx,hy,hw,hd]=hole,p=new T.Path();p.moveTo(hx,hy);p.lineTo(hx,hy+hd);p.lineTo(hx+hw,hy+hd);p.lineTo(hx+hw,hy);p.closePath();s.holes.push(p);}const geo=new T.ExtrudeGeometry(s,{depth:h,bevelEnabled:false});geo.rotateX(-Math.PI/2);const uv=geo.attributes.uv;for(let i=0;i<uv.count;i++)uv.setXY(i,uv.getX(i)/176,uv.getY(i)/196);return mesh(g,geo,mats,V(x,y,z));}
 function quad(g,a,b,c,d,thickness,mat){const v=[...a,...b,...c,...a,...c,...d],geo=new T.BufferGeometry();geo.setAttribute('position',new T.Float32BufferAttribute(v,3));geo.computeVertexNormals();const m=mat.clone();m.side=T.DoubleSide;return mesh(g,geo,m);}
 function slopedFloor(g,x,y0,z0,width,faceLength,angle,t,mat){const midY=y0+faceLength*Math.cos(angle)/2,midZ=z0-faceLength*Math.sin(angle)/2;const pos=V(x,midY,midZ).add(new T.Vector3(0,-t*Math.cos(angle)/2,t*Math.sin(angle)/2));const o=mesh(g,new T.BoxGeometry(width,t,faceLength),mat,pos);o.rotation.x=-angle;return o;}
 function wire(g,points,color,r=.6){const c=new T.CatmullRomCurve3(points.map(v=>V(...v)));return mesh(g,new T.TubeGeometry(c,36,r,7,false),material(color));}
 // Larger clear aperture; the old opaque bottom and closed base are completely removed.
 clear(old.work);const A=D.work_aperture;panel(old.work,22,22,180,176,196,6,[A.xy[0]-22,A.xy[1]-22,...A.wh],woodMats);
 for(const x of [30,190])for(const y of [30,210])bolt(old.work,x,y,186.5);
 old.work.userData.copy='工作板开70×110通孔，既让下摄光路穿过，也让后段落豆通过；不能沿用H1小孔。';
 const chute=groups.H13;clear(chute);chute.userData.copy='H2用玻璃底、PP侧壁和边托。底下没有不透明PP板；侧支承通过向外角铝落在实体框上，拍摄段与后接豆斜槽分离。';
 panel(chute,60,50,186,100,130,3,[26,10,48,105],pp);
 const slope=Math.PI*35/180,up=D.chute.upstream_y,upZ=D.chute.upstream_z;
 const sideWalls=[];for(const x of [94.1,122.9]){const s=new T.Shape();s.moveTo(up,189);s.lineTo(124,189);s.lineTo(124,234);s.lineTo(up,upZ+14);s.closePath();const geo=new T.ExtrudeGeometry(s,{depth:3,bevelEnabled:false});const p=geo.attributes.position;for(let i=0;i<p.count;i++){const y=p.getX(i),z=p.getY(i),xx=p.getZ(i);p.setXYZ(i,x+xx,z,240-y);}geo.computeVertexNormals();sideWalls.push(mesh(chute,geo,pp.clone()));}
 old.setCutaway=enabled=>sideWalls.forEach(o=>{o.material.transparent=enabled;o.material.opacity=enabled?.2:1;o.material.depthWrite=!enabled;o.material.needsUpdate=true;});
 const holders=group('H32','可拆玻璃边托与压扣','每侧3mm承托，中央约19.8mm通光。四只外侧压扣只防滑、不压弯玻璃；按实物厚度配垫。H13板材加工子件，不另买重复板材。');
 for(const x of [98.6,121.4]){const rail=slopedFloor(holders,x,up,upZ-1.1/Math.cos(slope),3,76.2,slope,3,pp);}
 for(const x of [91,120])for(const y of [73,112]){const z=220+(124-y)*Math.tan(slope);box(holders,x,y,z+1.4,9,7,2.2,dark);bolt(holders,x+(x===91?3:6),y+3.5,z+4);}
 for(const x of [77,123]){box(chute,x,82,189,20,15,2,alu);box(chute,x===77?94.1:123,82,189,2,15,18,alu);bolt(chute,x===77?80:140,89,191.8);}
 const glassGroup=group('H31','透明玻璃拍摄托片','7101普通磨边无磨砂载玻片，指定25.4×76.2×1.0–1.2mm。下相机透片看另一面；有接触遮挡、反光与豆屑影响，不是无损全表面检测。只承单颗，不能手按。');
 const glassMat=new T.MeshPhysicalMaterial({color:'#cee9e4',roughness:.1,metalness:0,clearcoat:1,transparent:true,opacity:.3,depthWrite:false,side:T.DoubleSide});
 const pane=slopedFloor(glassGroup,110,up,upZ,25.4,76.2,slope,1.1,glassMat);const outline=new T.LineSegments(new T.EdgesGeometry(pane.geometry),new T.LineBasicMaterial({color:'#5f9d9b',transparent:true,opacity:.65}));pane.add(outline);
 old.chuteFloor=pane;
 // Hand-fed short flared mouth, ahead of the transparent optical zone.
 const mouth=group('H13-mouth','短PP导豆口','前口45mm收至25.8，人工一次只放一颗。这里只引导豆，不装1kg储豆漏斗；PP导豆段在上游，不能伸到下相机光路里。');
 const fy=35,ry=up,fz=220+(124-fy)*Math.tan(slope),rz=upZ;
 quad(mouth,V(87.5,fy,fz).toArray(),V(132.5,fy,fz).toArray(),V(122.9,ry,rz).toArray(),V(97.1,ry,rz).toArray(),3,pp);
 for(const side of [-1,1]){const xf=110+side*22.5,xr=110+side*12.9;quad(mouth,V(xf,fy,fz).toArray(),V(xr,ry,rz).toArray(),V(xr,ry,rz+14).toArray(),V(xf,fy,fz+14).toArray(),3,pp);}
 // Camera A reuses H1 appearance; camera B is the same detailed module rotated upward.
 const camOld=groups.H02;root.remove(camOld);const camCarrier=groups.H18;root.remove(camCarrier);
 const cameras=group('H02','上下两只GC2093','同一颗豆停稳，先A上视，再B透托片，绑定一个cycle_id。BOX两CSI口接两只模组；Sensor编号、内存、对焦与图像可用性均需实机验证。');
 const station=D.camera.station_xyz,upper=D.camera.upper_lens_xyz,lower=D.camera.lower_lens_xyz;
 const top=camOld;top.position.set(0,upper[2]-319.5,112-upper[1]);top.userData={id:'H02-A',name:'A 上相机',copy:'镜头垂直向下，直接看停稳豆粒的上面。与下相机分别调焦；原90°镜头在90mm工作距离下的豆粒像素密度必须实拍核对。'};cameras.add(top);
 const bottomPivot=new T.Group(),bottomCam=camOld.clone(true);bottomCam.position.set(-110,-319.5,-128);bottomCam.userData={id:'H02-B',name:'B 下相机',copy:'镜头垂直向上，穿过木台与PP底座开口、再透玻璃拍另一面。玻璃有35°倾角，要独立调焦、遮反光与清洁；不能当成无遮挡的完整另一面。'};bottomPivot.add(bottomCam);bottomPivot.position.copy(V(...lower));bottomPivot.rotation.x=Math.PI;cameras.add(bottomPivot);
 const mounts=group('H18','上相机固定支架','沿用上平台可调支架；相机不跟舵机动。H2把相机光轴移至Y116.5，孔位按模组实配。');
 panel(mounts,80,86.5,344,60,60,3,null,pp);box(mounts,130,105,347,2,30,18,alu);box(mounts,110,105,347,22,30,2,alu);
 const lowerMount=group('H34','下相机可调支架','PP3载板60×40、角铝与M2隔柱固定到框架侧支承，不靠排线承重。载板/PCB后缘距防撞板约8.5mm名义值，按实际PCB/插头向前调整并重核光轴。');
 panel(lowerMount,80,96.5,111.5,60,40,3,[15,7,30,26],pp);box(lowerMount,45,103,108.5,2,30,23,alu);box(lowerMount,45,103,111.5,35,30,2,alu);box(lowerMount,23,103,108.5,24,30,2,alu);
 for(const x of [94,126])for(const y of [100.5,132.5])bolt(lowerMount,x,y,114.8);
 // The rear collector intercepts the bean before it can fall onto the bottom camera.
 const collect=group('H33','后接豆斜槽＋防撞板','拍摄托片与接豆斜槽分开。豆在Y132/Z197落到斜面，导至Y165/Z143；相机位于前方Y116.5，防撞片挡住接近镜头的反弹。须先用纸板相机占位试豆。');
 const rampAngle=Math.atan2(54,33),rampLength=Math.hypot(33,54);
 slopedFloor(collect,110,132,197,46,rampLength,rampAngle,3,pp);
 for(const x of [85,133]){const s=new T.Shape();s.moveTo(132,197);s.lineTo(165,143);s.lineTo(165,161);s.lineTo(132,215);s.closePath();const geo=new T.ExtrudeGeometry(s,{depth:3,bevelEnabled:false});const p=geo.attributes.position;for(let i=0;i<p.count;i++)p.setXYZ(i,x+p.getZ(i),p.getY(i),240-p.getX(i));geo.computeVertexNormals();mesh(collect,geo,pp);}
 box(collect,80,145,110,60,2,55,dark);
 // Lamp channels below the work aperture; actual LED aim and cut length await test.
 const lowerLight=group('H07-B','下方两条补光','上方原两条常亮，下方新增两条常亮。下补光须从大开口内侧斜照，实拍调整防眩光，不照抄上方曝光。4段合计0.4m、8W为预算。');
 const emit=new T.MeshStandardMaterial({color:'#fff1c5',emissive:'#ffd68b',emissiveIntensity:.4,roughness:.4});
 for(const x of [80,127]){box(lowerLight,x,64,169,14,100,2,alu);box(lowerLight,x,64,171,1.4,100,6,alu);box(lowerLight,x+12.6,64,171,1.4,100,6,alu);for(let i=0;i<12;i++)box(lowerLight,x+4,68+i*7.8,173.5,6,4,.8,emit);}
 // Keep the servo's base plate clear of the wider H2 right sidewall.
 groups.H10.children[0].position.x+=3;
 for(const o of groups.H10.children){if(Math.abs(o.position.x-131)<.01&&o.position.y<195){o.position.x=138;if(o.geometry?.type==='CylinderGeometry'){o.scale.y=.2/3.2;o.position.y=189.1;}}}
 groups.H01.userData.copy='同一块K230D BOX负责两路图像、A/B结果配对、主屏和MG996R控制。两图只计一颗；任一路失败/不清楚需拒判，不能把动画预设图当成部署成功。';
 const wires=old.wiring;for(const c of [...wires.children])if(c.userData.overhead)wires.remove(c);
 wire(wires,[[110,134,337],[135,144,355],[138,50,365],[138,16,375]],'#d9c9aa',1.5).userData.overhead=true;
 wire(wires,[[110,132,122],[75,134,126],[45,50,184],[45,15,350],[78,9,356]],'#d9c9aa',1.5).userData.overhead=true;
 for(let i=0;i<2;i++)wire(wires,[[77,8+i,356],[32,25+i,337],[28,210+i,185],[10,245+i,161]],i?'#434c54':'#20272d',.8).userData.overhead=true;
 root.remove(old.capture);const capture=new T.Group();root.add(capture);const topCapMat=new T.MeshBasicMaterial({color:'#47acc9',transparent:true,opacity:.06,side:T.DoubleSide,depthWrite:false}),bottomCapMat=topCapMat.clone();bottomCapMat.color.set('#db9e4c');
 const upperCone=mesh(capture,new T.ConeGeometry(13,90,32,1,true),topCapMat,V(110,116.5,station[2]+45));
 const lowerCone=mesh(capture,new T.ConeGeometry(13,90,32,1,true),bottomCapMat,V(110,116.5,station[2]-45));lowerCone.rotation.x=Math.PI;old.capture=capture;old.upperCone=upperCone;old.lowerCone=lowerCone;
 const paths=new T.Group();root.add(paths);for(const [lens,color] of [[upper,'#348ea9'],[lower,'#c89043']]){const line=new T.Line(new T.BufferGeometry().setFromPoints([V(...lens),V(...station)]),new T.LineDashedMaterial({color,dashSize:3,gapSize:2,transparent:true,opacity:.75}));line.computeLineDistances();paths.add(line);}old.paths=paths;
 const labels=[['A · 上摄直拍',110,116.5,330,'fixed'],['B · 下摄透片拍',110,116.5,129,'fixed'],['H31 · 可拆透明托片',95,92,253,'fixed'],['H13 · 短导豆口',88,44,297,'fixed'],['H03 · MG996R',153,144,216,'fixed'],['H33 · 后接豆斜槽',136,159,170,'fixed'],['H13 · 侧摆挡片',103,127,233,'gate'],['H01 · BOX双摄显示',110,0,409,'whole']];
 old.labels=labels.map(([text,x,y,z,kind])=>({text,point:V(x,y,z),kind,views:kind==='whole'?['whole']:['mechanism','whole']}));
 old.explode=old.explode.filter(o=>![camOld,camCarrier,chute].includes(o.group));
 for(const [g,shift] of [[chute,[-35,0,0]],[glassGroup,[-30,40,0]],[holders,[-45,5,0]],[mouth,[-45,25,40]],[cameras,[-20,30,0]],[mounts,[-20,55,0]],[lowerMount,[-55,-10,0]],[collect,[50,-25,-10]],[lowerLight,[60,-20,10]]])old.explode.push({group:g,base:g.position.clone(),shift});
 old.optics={upper,lower,station,glassLength:76.2,glassThickness:1.1,glassRun:76.2*Math.cos(slope)};
 old.pickables=[];root.traverse(o=>{if(o.isMesh){delete o.userData.component;let p=o;while(p&&!p.userData.id)p=p.parent;if(p){o.userData.component=p.userData;old.pickables.push(o);}}});
 // Occlusion audit of the two central sight lines; the transparent pane is excluded.
 old.opticalObstructions=function(){root.updateMatrixWorld(true);const meshes=[];root.traverse(o=>{if(!o.isMesh)return;let p=o;while(p){if(p===cameras||p===old.bean||p===capture||p===glassGroup)return;p=p.parent;}meshes.push(o);});return [upper,lower].map(lens=>{const from=V(...lens),to=V(...station),dir=to.clone().sub(from).normalize(),ray=new T.Raycaster(from,dir,2,85);return ray.intersectObjects(meshes).map(hit=>hit.object.userData.component?.id||'unlabelled');});};
 return old;
};
