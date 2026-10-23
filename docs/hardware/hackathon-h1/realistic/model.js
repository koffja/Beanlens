/* H1 appearance reconstruction. Units: mm. Engineering X/Y/Z -> Three X/Z/(240-Y). */
'use strict';
window.createBeanLensModel = function (screenCanvas) {
 const T=THREE, root=new T.Group(), groups={}, pickables=[], labels=[], explode=[];
 const V=(x,y,z)=>new T.Vector3(x,z,240-y);
 const mat=(color,metalness=0,roughness=.5)=>new T.MeshStandardMaterial({color,metalness,roughness});
 const M={black:mat('#161b20',.22,.35),edge:mat('#354048',.6,.32),steel:mat('#b9c4cb',.8,.26),alu:mat('#bcc7ce',.7,.34),pp:mat('#f4f3e9',0,.45),ppEdge:mat('#e1e0d6',0,.55),gold:mat('#ba8b39',.7,.28),pcb:mat('#224f49',.1,.68),chip:mat('#172126',.05,.6),copper:mat('#c1ac75',.6,.5),blue:mat('#214b66',.15,.4),orange:mat('#dc973d',.1,.45),red:mat('#ab4542',0,.65),wire:mat('#262a2f',0,.65),yellow:mat('#d9b34c',0,.65)};
 const glass=new T.MeshPhysicalMaterial({color:'#d1e3e4',roughness:.13,metalness:.05,transparent:true,opacity:.23,depthWrite:false,side:T.DoubleSide});
 const lensMat=new T.MeshPhysicalMaterial({color:'#17344a',metalness:.65,roughness:.1,clearcoat:1});
 function rndShape(w,h,r){const s=new T.Shape(),x=-w/2,y=-h/2;r=Math.min(r,w/2,h/2);s.moveTo(x+r,y);s.lineTo(x+w-r,y);s.quadraticCurveTo(x+w,y,x+w,y+r);s.lineTo(x+w,y+h-r);s.quadraticCurveTo(x+w,y+h,x+w-r,y+h);s.lineTo(x+r,y+h);s.quadraticCurveTo(x,y+h,x,y+h-r);s.lineTo(x,y+r);s.quadraticCurveTo(x,y,x+r,y);return s;}
 function rb(w,h,d,r=1){const g=new T.ExtrudeGeometry(rndShape(w,h,r),{depth:d,bevelEnabled:false,curveSegments:6});g.translate(0,0,-d/2);return g;}
 function mesh(parent,geo,material,pos=[0,0,0]){const o=new T.Mesh(geo,material);o.position.set(...pos);o.castShadow=true;o.receiveShadow=true;parent.add(o);return o;}
 function cube(parent,w,h,d,position,material,r=0){return mesh(parent,r?rb(w,h,d,r):new T.BoxGeometry(w,h,d),material,position);}
 function box(parent,x,y,z,w,d,h,material,r=0){return cube(parent,w,h,d,[x+w/2,z+h/2,240-y-d/2],material,r);}
 function cyl(parent,r,h,position,material,rt=r){return mesh(parent,new T.CylinderGeometry(rt,r,h,40),material,position);}
 function ball(parent,r,position,material){return mesh(parent,new T.SphereGeometry(r,20,12),material,position);}
 function bolt(parent,pos,axis='y',radius=1.9){const g=new T.Group();g.position.set(...pos);if(axis==='z')g.rotation.x=Math.PI/2;if(axis==='x')g.rotation.z=Math.PI/2;parent.add(g);cyl(g,radius,1.1,[0,0,0],M.steel);const slot=cube(g,radius*1.15,.15,.38,[0,.6,0],M.chip,.1);const slot2=slot.clone();slot2.rotation.y=Math.PI/2;g.add(slot2);return g;}
 function flatPlate(parent,w,d,h,pos,material,holes=[],r=1){const s=rndShape(w,d,r);holes.forEach(([x,z,rad])=>{const p=new T.Path();p.absarc(x,-z,rad,0,Math.PI*2,false);s.holes.push(p);});const g=new T.ExtrudeGeometry(s,{depth:h,bevelEnabled:false,curveSegments:8});g.rotateX(-Math.PI/2);g.translate(0,-h/2,0);return mesh(parent,g,material,pos);}
 function wire(parent,points,color,r=.55){const curve=new T.CatmullRomCurve3(points.map(p=>new T.Vector3(...p)));return mesh(parent,new T.TubeGeometry(curve,48,r,7,false),mat(color,0,.55));}
 function tag(parent,geo,material,pos,id,name,copy){const o=mesh(parent,geo,material,pos);o.userData={id,name,copy};pickables.push(o);return o;}
 function component(name,id,copy){const g=new T.Group();g.userData={id,name,copy};root.add(g);groups[id]=g;return g;}
 function makeLabel(text,x,y,z,kind='fixed',views=['mechanism','whole']){labels.push({text,point:V(x,y,z),kind,views});}
 function texture(draw,w=512,h=256){const c=document.createElement('canvas');c.width=w;c.height=h;draw(c.getContext('2d'),w,h);const t=new T.CanvasTexture(c);t.colorSpace=T.SRGBColorSpace;t.anisotropy=4;return t;}
 const woodTex=texture((c,w,h)=>{c.fillStyle='#ccab7b';c.fillRect(0,0,w,h);for(let i=0;i<450;i++){const y=i*h/450;c.strokeStyle=`rgba(${i%3?100:255},${i%3?65:229},${i%3?35:189},${.03+(i%7)*.008})`;c.lineWidth=.5+(i%4)*.35;c.beginPath();for(let x=0;x<=w;x+=8){const yy=y+Math.sin(x/65+i*.09)*2+Math.sin(x/120+i*.31)*2;x?c.lineTo(x,yy):c.moveTo(x,yy);}c.stroke();}},512,512);
 woodTex.wrapS=woodTex.wrapT=T.RepeatWrapping;const wood=mat('#fff1d5',0,.66);wood.map=woodTex;
 const layerTex=texture((c,w,h)=>{c.fillStyle='#c29d6d';c.fillRect(0,0,w,h);for(let i=0;i<7;i++){c.fillStyle=i%2?'#b18b5d':'#e1c79c';c.fillRect(0,i*h/7,w,h/7-1);}},256,84);const woodEdge=mat('#fff',0,.72);woodEdge.map=layerTex;
 function woodPanel(g,x,y,z,w,d,h,cut){const s=new T.Shape();s.moveTo(0,0);s.lineTo(w,0);s.lineTo(w,d);s.lineTo(0,d);s.closePath();if(cut){const [cx,cy,cw,cd]=cut;const p=new T.Path();p.moveTo(cx,cy);p.lineTo(cx,cy+cd);p.lineTo(cx+cw,cy+cd);p.lineTo(cx+cw,cy);p.closePath();s.holes.push(p);}const geo=new T.ExtrudeGeometry(s,{depth:h,bevelEnabled:false});geo.rotateX(-Math.PI/2);const uv=geo.attributes.uv;for(let i=0;i<uv.count;i++)uv.setXY(i,uv.getX(i)/176,uv.getY(i)/196);const o=mesh(g,geo,[wood,woodEdge]);o.position.copy(V(x,y,z));return o;}
 // Open T slots and center bore, rather than a painted rectangular bar.
 function extrusionGeometry(len){const s=new T.Shape(),top=[[-10,10],[-3,10],[-3,8],[-6,8],[-6,6],[-3,3],[3,3],[6,6],[6,8],[3,8],[3,10],[10,10]];for(let q=0;q<4;q++){top.forEach(([x,y],i)=>{for(let k=0;k<q;k++){[x,y]=[y,-x];}if(q===0&&i===0)s.moveTo(x,y);else s.lineTo(x,y);});}s.closePath();const hole=new T.Path();hole.absarc(0,0,2.15,0,Math.PI*2,true);s.holes.push(hole);const g=new T.ExtrudeGeometry(s,{depth:len,bevelEnabled:false,curveSegments:10});g.translate(0,0,-len/2);return g;}
 const frame=component('黑色欧标2020机架','H14','真实槽口截面与中央孔可见；沿用220×240×460mm外框。特写隐藏机架以便看清机构。');
 function profile(x,y,z,axis,len){const o=mesh(frame,extrusionGeometry(len),M.black);o.position.copy(V(x,y,z));if(axis==='z')o.rotation.x=-Math.PI/2;if(axis==='x')o.rotation.y=Math.PI/2;return o;}
 for(const x of [10,210])for(const y of [10,230])profile(x,y,230,'z',460);
 for(const z of [10,450]){for(const y of [10,230])profile(110,y,z,'x',180);for(const x of [10,210])profile(x,120,z,'y',200);}
 // Standard angle brackets with bolts inside each corner.
 for(const z of [20,438])for(const x of [20,200])for(const y of [20,220]){box(frame,x===20?x:x-16,y,z,16,2,16,M.black);box(frame,x===20?x:x-2,y,z,2,16,16,M.black);bolt(frame,V(x===20?x+8:x-8,y-1,z+8),'z');}
 const work=component('海洋板工作台','H16','固定6mm海洋板，50×45落豆孔保持贯通。木板与PP槽体都不随舵机转。');woodPanel(work,22,22,180,176,196,6,[63,100,50,45]);
 const upper=component('相机平台与BOX承板','H16-top','海洋板相机平台位于Z344；正面承板夹持BOX原壳，不另买第二屏。');woodPanel(upper,22,22,344,176,196,6);box(upper,22,17,334,176,3,88,wood);
 const bottom=component('固定底板','H16-base','收豆杯直接放在固定底板上，没有称重传感器或称台。');woodPanel(bottom,22,22,20,176,196,6);
 for(const g of [work,upper,bottom])for(const x of [30,190])for(const y of [30,210]){const z=g===work?186:g===upper?350:26;bolt(g,V(x,y,z+.5));}
 const ppBase=component('PP底座与短斜槽','H13','3mm PP固定短槽，内宽24mm、底板面长60mm、坡度35°起试；豆停在下游挡片前。两侧板兼支承，内侧焊缝需修平。');
 // Base aperture is a real hole in the mesh.
 const baseShape=rndShape(80,110,1), aperture=new T.Path();aperture.moveTo(-25,-36);aperture.lineTo(-25,4);aperture.lineTo(15,4);aperture.lineTo(15,-36);aperture.closePath();baseShape.holes.push(aperture);
 baseShape.holes=[];const correctAperture=new T.Path();correctAperture.moveTo(-25,4);correctAperture.lineTo(-25,44);correctAperture.lineTo(15,44);correctAperture.lineTo(15,4);correctAperture.closePath();baseShape.holes.push(correctAperture);
 const bg=new T.ExtrudeGeometry(baseShape,{depth:3,bevelEnabled:false});bg.rotateX(-Math.PI/2);mesh(ppBase,bg,M.pp,[115,186,120]);
 const slope=Math.PI*35/180, chuteFloor=mesh(ppBase,new T.BoxGeometry(24,3,60),M.pp,V(110,99.4254,237.2073).add(new T.Vector3(0,-1.5*Math.cos(slope),1.5*Math.sin(slope))).toArray());chuteFloor.rotation.x=-slope;
 function sideWall(x){const s=new T.Shape();s.moveTo(74.8509,189);s.lineTo(124,189);s.lineTo(124,234);s.lineTo(74.8509,268.4146);s.closePath();const g=new T.ExtrudeGeometry(s,{depth:3,bevelEnabled:false});const arr=g.attributes.position;for(let i=0;i<arr.count;i++){const y=arr.getX(i),z=arr.getY(i),xx=arr.getZ(i);arr.setXYZ(i,x+xx,z,240-y);}g.computeVertexNormals();mesh(ppBase,g,M.pp);}
 sideWall(95);sideWall(122);
 // External weld beads visible along the floor, kept out of nominal clear passage.
 for(const x of [94.7,125.3])wire(ppBase,[V(x,76,254).toArray(),V(x,98,238.5).toArray(),V(x,123,221).toArray()],'#deded2',.7);
 for(const x of [91,127]){box(ppBase,x,88,189,2,15,20,M.alu);box(ppBase,x,88,189,10,15,2,M.alu);bolt(ppBase,V(x+5,95,191.8));}
 // MG996R: 40.7 x 19.7 x 42.9 body reference, with ears, lid seams and label.
 const servo=component('MG996R机身','H03','位置舵机，机身固定不转；独立6V供电。输出轴向上，只带一片轻挡豆片。这里的壳体、安装耳和出线用于辨认，不代替实物孔距。');
 box(servo,130,118,197,19.7,40.7,33,M.black,1.5);box(servo,130,118,230.2,19.7,40.7,7.1,M.black,1.2);box(servo,129.8,117.8,227.5,20.1,41.1,1.3,M.edge,.7);box(servo,130,118,197,19.7,40.7,2.6,M.edge,.7);
 for(const y of [111,158.7]){flatPlate(servo,19.7,7,2,V(139.85,y+3.5,229),M.black,[[-5.4,0,1.7],[5.4,0,1.7]],.8);for(const x of [134.45,145.25])bolt(servo,V(x,y+3.5,230.5));}
 cyl(servo,8.6,4,V(140,126,237),M.black);cyl(servo,3,4,V(140,126,240),M.gold);
 for(let a=0;a<25;a++){const angle=a*Math.PI*2/25;const tooth=cube(servo,.35,2.5,.8,V(140+3*Math.cos(angle),126+3*Math.sin(angle),241).toArray(),M.gold);tooth.rotation.y=-angle;}
 const servoLabel=texture((c,w,h)=>{c.fillStyle='#b5883e';c.fillRect(0,0,w,h);c.fillStyle='#f2dc9c';c.fillRect(10,10,w-20,h-20);c.fillStyle='#222b2b';c.textAlign='center';c.font='bold 75px sans-serif';c.fillText('MG996R',w/2,96);c.font='27px sans-serif';c.fillText('DIGITAL · METAL GEAR',w/2,149);c.fillStyle='#a36d26';c.fillRect(14,181,w-28,54);c.fillStyle='white';c.font='bold 30px sans-serif';c.fillText('HIGH TORQUE',w/2,218);});
 const sticker=mesh(servo,new T.PlaneGeometry(16.5,22),new T.MeshStandardMaterial({map:servoLabel,roughness:.65}),V(139.85,117.7,215).toArray());
 const mount=component('舵机固定架＋转接板','H10','固定件，随工作台保持静止。60×60×3铝毛坯只是转接板；支架外形、孔位、垫高均待所购实物核对。图中是安装原理，不是FIT0038原位装配保证。');
 // Illustrative stack avoids coincident PP/Al solids: PP top189, plate bottom189.2.
 // Riser height and washers are still fitting dimensions, not released drill positions.
 flatPlate(mount,60,60,3,V(155,145,190.7),M.alu,[[-24,-24,1.8],[24,-24,1.8],[-24,24,1.8],[24,24,1.8]],1.2);
 for(const y of [112,162]){const ms=rndShape(23,35,1);ms.holes.push(new T.Path(rndShape(15,25,1).getPoints(16)));const mg=new T.ExtrudeGeometry(ms,{depth:2,bevelEnabled:false});mg.translate(0,0,-1);mesh(mount,mg,M.alu,V(140.5,y+1,209.7).toArray());box(mount,129,y,192.2,23,10,2,M.alu);flatPlate(mount,23,9,2,V(140.5,y+1,227.3),M.alu,[[-6,0,1.7],[6,0,1.7]],.8);for(const x of [134,147])bolt(mount,V(x,y+1,229));}
 for(const x of [131,179])for(const y of [121,169]){cyl(mount,3,3.2,V(x,y,187.6),M.alu);bolt(mount,V(x,y,192.8));}
 // Rotating assembly: one horn, one L bracket, one PP gate. All share one pivot.
 const rotating=new T.Group();rotating.position.copy(V(140,126,240));root.add(rotating);rotating.userData={id:'H11',name:'单只25T直舵臂',copy:'只有一只驱动舵臂。25T是花键齿数；16mm是轴心到连接孔中心距。舵臂、L角片和PP挡片作为一个整体绕竖轴侧摆。角片须防转，最终连接孔按实物确定。'};groups.H11=rotating;
 const horn=new T.Group();rotating.add(horn);
 const arm=new T.Shape(rndShape(30,7,3.4).getPoints(24).map(p=>new T.Vector2(p.x-12,p.y)));for(const x of [-8,-16,-24]){const hole=new T.Path();hole.absarc(x,0,1.5,0,Math.PI*2,true);arm.holes.push(hole);}const hg=new T.ExtrudeGeometry(arm,{depth:3,bevelEnabled:false,curveSegments:16});hg.rotateX(-Math.PI/2);mesh(horn,hg,M.alu,[0,.3,0]);cyl(horn,5.1,4.2,[0,2.4,0],M.alu);bolt(horn,[0,5,0],'y',2.2);
 const bracket=new T.Group();rotating.add(bracket);bracket.userData={id:'H12',name:'连接小L角片',copy:'水平翼连接舵臂，竖直翼连接PP挡片。连接必须防转；本页孔位仅帮助理解，尚不是可直接加工的孔位图。'};
 cube(bracket,12,2,20,[-16,-.5,-10],M.alu,.4);cube(bracket,12,20,2,[-16,-9.5,-1.7],M.alu,.4);bolt(bracket,[-16,1.1,-.3]);bolt(bracket,[-16,-11,.0],'z',1.9);
 const gate=cube(rotating,46,18,3,[-23,-10.5,0],M.pp,1);gate.userData={id:'H13-gate',name:'PP侧摆挡豆片',copy:'46×18×3mm轻PP片横挡单槽出口。拍照时不动；拍完向侧后方摆开。确认空槽后才缓关，不带豆强行关闭。'};
 cube(rotating,30,3,16,[-15,6,-13],M.pp,.6); // illustrative flag offset, final switch engagement awaits fitting
 const limits=component('开／关两个限位','H09','固定的微动开关检测转动旗片，确认实际位置。开、关各一只；它们不是两只舵臂。安装位置、触发量与避让仍待实物调整。');
 function limit(x,y,z,angle){const g=new T.Group();g.position.copy(V(x,y,z));g.rotation.y=angle;limits.add(g);cube(g,19.8,6.4,10,[0,0,0],M.black,.7);for(const xx of [-4.75,4.75])bolt(g,[xx,.2,5.4],'z',1.2);cube(g,19,.5,3,[0,4,0],M.steel,.2);cyl(g,1.8,3,[9.3,4,0],M.black);for(const xx of [-6,0,6])cube(g,1,4,.5,[xx,-5,0],M.gold);return g;}
 limit(151,132,247,Math.PI);limit(144,154,247,Math.PI/2);
 // Small fixed limit-support tabs are appearance-only; hole positions await fitting.
 box(mount,159,130,229,1.5,10,14.5,M.alu);box(mount,146,130,242,14.5,10,1.5,M.alu);
 box(mount,148,153,229,1.5,10,14.5,M.alu);box(mount,139,153,242,10.5,10,1.5,M.alu);
 // Camera PCB, mounting posts, component packages, M12 lens barrel and ribbon connector.
 const camera=component('单GC2093相机','H02','唯一相机朝下拍停稳的豆。镜头、PCB、排线是识别性重建；用户型号为GC2093-M12-90°无畸变，实际板形、孔距及近焦距离未冻结。相机不跟挡片运动。');
 flatPlate(camera,40,40,1.4,V(110,112,335),M.pcb,[[-16,-16,1.25],[16,-16,1.25],[-16,16,1.25],[16,16,1.25]],.8);
 for(const x of [94,126])for(const y of [96,128]){cyl(camera,1.6,8,V(x,y,340),M.gold);bolt(camera,V(x,y,344.8),'y',1.3);}
 box(camera,101,103,328,18,18,7,M.black,1);cyl(camera,7.2,9,V(110,112,325),M.black);for(let i=0;i<6;i++)cyl(camera,7.5,.5,V(110,112,321+i),M.edge);cyl(camera,6.4,.8,V(110,112,320),M.black);cyl(camera,5.4,.3,V(110,112,319.5),lensMat);cyl(camera,2.1,.32,V(108,110,319.3),new T.MeshBasicMaterial({color:'#436b86'}));
 for(let i=0;i<16;i++){const x=94+(i%4)*8,y=98+Math.floor(i/4)*8;if(Math.abs(x-110)<9&&Math.abs(y-112)<9)continue;box(camera,x,y,336,3.5,2,1,M.chip,.2);box(camera,x-1,y,336,1,2,.4,M.gold);}
 box(camera,94,127,336,32,4,3,M.ppEdge,.5);
 const camBracket=component('相机固定角铝','H18','相机载板、M2隔柱和固定角铝从上层平台承重，CSI排线不承重。特写隐藏平台，但角铝与固定相机仍显示。');
 flatPlate(camBracket,60,60,3,V(110,112,347),M.pp,[[-16,-16,1.2],[16,-16,1.2],[-16,16,1.2],[16,16,1.2]],1);box(camBracket,130,100,348,2,30,20,M.alu);box(camBracket,110,100,348,22,30,2,M.alu);
 // Constant illumination: U channel, white PCB, individual LED packages.
 const lights=component('两条常亮灯','H07','两段灯带固定斜照停豆位。实际常亮；画面中的拍照提示不是灯带闪光。长度按真实剪切点决定。');
 for(const x of [75,158]){box(lights,x,66,292,14,100,2,M.alu);box(lights,x,66,286,1.4,100,6,M.alu);box(lights,x+12.6,66,286,1.4,100,6,M.alu);box(lights,x+2,68,291,10,96,.6,M.pp);for(let i=0;i<12;i++){const em=new T.MeshStandardMaterial({color:'#fff6cf',emissive:'#ffe4a6',emissiveIntensity:.7,roughness:.5});box(lights,x+4,70+i*7.8,290,6,4,1,em,.2);}}
 // BOX: original enclosure size, recessed screen, three user buttons and clear rear cover.
 const controller=component('K230D BOX主屏与控制板','H01','黑色原壳64.3×47.6×15.4mm参考；只有这一块屏。上方三只按键中KEY0用于确认拍摄，KEY1用于软件停止；KEY2保留。透明背板下的PCB仅表示结构。');
 box(controller,77.85,1,346.2,64.3,15.4,47.6,M.black,3);box(controller,80.1,.65,349.7,59.8,.7,40.5,M.edge,2.1);
 const screenTexture=new T.CanvasTexture(screenCanvas);screenTexture.colorSpace=T.SRGBColorSpace;screenTexture.minFilter=T.LinearFilter;
 const screen=mesh(controller,new T.PlaneGeometry(53.2,39.9),new T.MeshBasicMaterial({map:screenTexture}),V(110,.1,370).toArray());
 const back=box(controller,79,16.45,347.2,62,1,45.6,glass,2);box(controller,81,15.5,350,58,1,40,M.pcb,1);for(const x of [83,137])for(const z of [351,389])bolt(controller,V(x,17.1,z),'z',1.4);
 for(let i=0;i<3;i++){box(controller,85+i*12,6,393.8,6,4,1.5,M.edge,.6);box(controller,86+i*12,7,395.3,4,2,1,M.black,.5);}
 for(const z of [357,373]){box(controller,77.1,6,z,1.2,7,3,M.steel,.8);box(controller,76.9,7,z+.6,.3,5.2,1.8,M.chip,.4);}
 // Semi-translucent hollow cup, no weighing platform.
 const cup=component('普通PP收豆杯','H21','所有结果都落进同一个杯，不做自动分选、不称重。杯体100×100×80mm参考，实际容器可复用。');
 const cupMat=new T.MeshPhysicalMaterial({color:'#e9eff0',roughness:.38,transparent:true,opacity:.48,side:T.DoubleSide,depthWrite:false});
 const cs=rndShape(100,100,9),inner=rndShape(94,94,7);cs.holes.push(new T.Path(inner.getPoints()));const cg=new T.ExtrudeGeometry(cs,{depth:80,bevelEnabled:false,curveSegments:12});cg.rotateX(-Math.PI/2);mesh(cup,cg,cupMat,V(110,145,26).toArray());flatPlate(cup,95,95,3,V(110,145,27.5),cupMat,[],8);flatPlate(cup,102,102,2,V(110,145,106),cupMat,[/* rim below */],9).visible=false;
 // Fine raised cup rim uses tube and avoids a solid lid.
 const rimPts=rndShape(100,100,9).getPoints(32).map(v=>new T.Vector3(v.x,0,v.y));rimPts.push(rimPts[0]);const rim=new T.CatmullRomCurve3(rimPts,true);const rm=mesh(cup,new T.TubeGeometry(rim,128,1.1,7,true),cupMat,V(110,145,106).toArray());
 const shield=component('可拆局部遮光片','H20','左右与后面黑PP遮光，前方留投豆入口。为了看清机构，初始隐藏；不是取消采购。');box(shield,65,70,225,2,120,100,M.black);box(shield,175,70,225,2,120,100,M.black);box(shield,65,190,225,110,2,100,M.black);shield.visible=false;
 const wiring=component('线束走向','H29','只表示布线方向，不表示完整电气接法。舵机三芯线接独立UBEC6V与缓冲PWM；主板供5V。准确端子与引脚请看原接线图。');
 for(let i=0;i<3;i++)wire(wiring,[V(140+i,159,200).toArray(),V(154+i,171,196).toArray(),V(180+i,185,191).toArray(),V(188+i,220,184).toArray(),V(205+i,250,160).toArray()],[ '#322922','#ab4542','#cb8d40'][i],.62);
 for(let i=0;i<2;i++){const w=wire(wiring,[V(77,8+i,356).toArray(),V(45,16+i,351).toArray(),V(32,25+i,337).toArray(),V(28,210+i,185).toArray(),V(10,245+i,161).toArray()],[ '#20272d','#434c54'][i],.85);w.userData.overhead=true;}
 // Flat FFC ribbon with visible contact stripes; fixed to camera and BOX, not to moving gate.
 const ffcPath=new T.CatmullRomCurve3([V(110,130,339),V(125,140,355),V(135,55,365),V(137,16,375)]),fp=ffcPath.getPoints(60),fv=[],fi=[],fu=[];
 fp.forEach((p,i)=>{fv.push(p.x-5,p.y,p.z,p.x+5,p.y,p.z);fu.push(0,i/60,1,i/60);if(i<60){const a=i*2;fi.push(a,a+1,a+2,a+1,a+3,a+2);}});
 const fg=new T.BufferGeometry();fg.setAttribute('position',new T.Float32BufferAttribute(fv,3));fg.setAttribute('uv',new T.Float32BufferAttribute(fu,2));fg.setIndex(fi);fg.computeVertexNormals();const ffcTex=texture((c,w,h)=>{c.fillStyle='#e9dfc9';c.fillRect(0,0,w,h);for(let i=0;i<16;i++){c.fillStyle='#bca97c';c.fillRect(i*w/16+5,0,1,h);c.fillStyle='#c5a65d';c.fillRect(i*w/16+3,h-24,12,24);}});const ffc=mesh(wiring,fg,new T.MeshStandardMaterial({map:ffcTex,side:T.DoubleSide,roughness:.6}));ffc.userData.overhead=true;
 for(const x of [10,210])for(const y of [10,230])cyl(frame,7.5,7,V(x,y,-3.5),M.black);
 // Bean has an irregular oval body and a curved central crease.
 const bean=new T.Group();root.add(bean);const beanMat=mat('#96936c',0,.78);
 const body=mesh(bean,new T.SphereGeometry(1,36,24),beanMat);body.scale.set(4.25,2.7,6.1);
 const groovePoints=[];for(let i=0;i<=20;i++){const z=-5+i*.5;const y=2.7*Math.sqrt(Math.max(0,1-z*z/(6.1*6.1)))+.025;groovePoints.push([.32*Math.sin(z*.65),y,z]);}wire(bean,groovePoints,'#514f37',.21);wire(bean,groovePoints.map(([x,y,z])=>[x+.35,y-.03,z]),'#c4be93',.12);
 for(let i=0;i<18;i++){const a=i*2.399;const z=Math.sin(i*3.7)*4.3;const x=Math.cos(a)*3.1*Math.sqrt(1-z*z/40);const y=2.7*Math.sqrt(Math.max(.05,1-x*x/18-z*z/38));ball(bean,.13,[x,y+.03,z],i%3?beanMat:mat('#aaa580',0,.9));}
 bean.position.copy(V(110,83,260));bean.visible=false;
 const capture=new T.Group();root.add(capture);const capMat=new T.MeshBasicMaterial({color:'#48b7cb',transparent:true,opacity:.22,depthWrite:false,side:T.DoubleSide});
 const cone=mesh(capture,new T.ConeGeometry(18,84,4,1,true),capMat,V(110,112,278).toArray());cone.rotation.y=Math.PI/4;
 const captureRing=mesh(capture,new T.RingGeometry(10,10.4,64),new T.MeshBasicMaterial({color:'#45abc3',transparent:true,opacity:.7,side:T.DoubleSide}),V(110,115,228).toArray());captureRing.rotation.x=-Math.PI/2;capture.visible=false;
 makeLabel('H03 · MG996R机身',149,145,215);makeLabel('H10 · 固定支架',176,163,202);makeLabel('H11 · 单只金属舵臂',141,123,254,'moving');makeLabel('H13 · PP单槽',90,83,274);makeLabel('H13 · 侧摆挡豆片',103,127,233,'gate');makeLabel('H02 · 单GC2093',111,108,306);makeLabel('H09 · 两个限位',151,155,260);makeLabel('H01 · K230D BOX',110,0,409,'fixed',['whole']);makeLabel('H21 · 无称重收豆杯',111,183,117,'fixed',['whole']);
 const partItems=[{group:servo,shift:[70,8,20]},{group:mount,shift:[100,-20,-10]},{group:rotating,shift:[50,45,15]},{group:limits,shift:[100,55,-40]},{group:ppBase,shift:[-28,15,0]},{group:camera,shift:[-15,50,0]},{group:camBracket,shift:[-15,65,0]}];
 partItems.forEach(o=>{o.base=o.group.position.clone();explode.push(o);});
 root.traverse(o=>{if(o.isMesh){let par=o;while(par&&!par.userData.id)par=par.parent;if(par&&par.userData.id){o.userData.component=par.userData;pickables.push(o);}}});
 return {root,groups,frame,work,upper,bottom,rotating,bean,capture,shield,wiring,labels,pickables,screenTexture,explode,chuteFloor,V};
};
