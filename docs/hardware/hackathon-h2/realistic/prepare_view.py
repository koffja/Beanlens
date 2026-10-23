"""Adapt the existing H1 viewer into an independent H2 viewer, without touching H1."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parent
H1=ROOT.parents[1]/"hackathon-h1/realistic"
index=re.sub(r'\bH1\b','H2',(H1/"index.html").read_text()).replace("bom-h1", "bom-h2").replace("机构特写", "双摄光路")
index=index.replace('href="../05-signals.svg"','href="../wiring-h2.svg"')
index=index.replace('src="model.js"','src="design-data.js"></script><script src="model-base-h1.js"></script><script src="model.js"')
index=index.replace('先看清这四件东西','为什么下面必须留空？').replace('H03 · H10 · H11 · H12','H02 ×2 · H31 · H33')
index=index.replace('黑色舵机机身锁在固定支架上；银色直舵臂套在输出轴上，再经小L角片带动白色PP挡片。固定架不转，舵臂只用一只。','上相机直接拍上面，下相机透过玻璃拍另一面。PP只托玻璃边缘；后接豆斜槽把豆引到镜头后方。两张图配成一颗豆，仍只用一只舵臂。')
index=index.replace('聚焦舵机与挡片 →','查看中线剖面 →')
index=index.replace('单摄 / 单槽 / 人工逐颗 / 静止拍照 / 侧摆放走','双摄 / 透明托片 / 单槽 / 静止配对 / 侧摆放走')
index=index.replace('黑2020框架、三层海洋板、单GC2093、两条常亮灯、MG996R、固定架、单舵臂、L角片、PP单槽/挡片、两个限位、BOX与收豆杯。机外电源沿用原接线图。','上下两只GC2093、可拆透明托片、短PP导豆口、后接豆斜槽、下摄防撞板，及黑框/木平台、BOX、舵机与同一收豆杯。上下各两条常亮灯。')
index=index.replace('特写隐藏上部框架和相机平台，以便看清内部。','光路视图暂隐木台与遮光片；整机模式恢复木台。')
index=index.replace('本页显示了什么？','双摄怎样保留比赛简化？').replace('相机板、支架孔位及防转连接待实配；动画时长与角度不代表实测。','透明托片光学质量、两摄近焦/像素密度、净空与触发位置待实配；分类与时间为预设。')
index=index.replace('<span id="viewScale">','<label><input id="cutaway" type="checkbox" checked> 透视侧壁</label><span id="viewScale">')
(ROOT/"index.html").write_text(index)
app=(H1/"app.js").read_text()
a=app.index(' const phases=[');b=app.index(' let renderer',a)
app=app[:a]+''' const phases=[
  {at:0,title:'先确认关位，再放一颗',copy:'人工从短PP导豆口放一颗豆，沿透明托片滑到挡片前。大料斗、自动逐豆送料和称重仍不安装。',screen:'等待单颗',sub:'关位明确，人工放豆并按KEY0'},
  {at:2.5,title:'豆粒在透明托片上停稳',copy:'玻璃底可抽出擦拭，PP只在两侧承托；下面的相机可以透片看到另一面。摄影区下面不能补回不透明PP底。透视侧壁仅为教学，实物仍是PP。',screen:'等待停稳',sub:'两相机不动，豆粒也不翻转'},
  {at:5,title:'先拍A上视，再拍B透片',copy:'同一颗豆保持静止，先取A图、再取B图。分别检查曝光、对焦和新帧，按一个cycle_id配对；不宣称两摄硬件同步。',screen:'A / B取图',sub:'任一路缺失或不清楚，整颗待复核'},
  {at:8.2,title:'两张图，合成一颗的结果',copy:'动画预设下视疑似。任一路有效图疑似则整颗疑似，任一路不可用则拒判；两图保存后才放豆。两视图不代表看遍全部表面。',screen:'配对已保存',sub:'预设示例：B侧疑似；两图只计1颗'},
  {at:10.5,title:'侧摆打开，后斜槽接豆',copy:'舵机带一只直臂和挡片侧摆。出口后的斜槽把豆引到下相机后方，再落进同一杯；前挡板保护镜头，仍须实豆验证。',screen:'开闸放走',sub:'后接豆口让开下摄光路'},
  {at:15,title:'确认空槽，再缓慢关闸',copy:'玻璃拍摄带和出口都确认无豆后，挡片才缓关。关位确认后才能下一颗；卡豆、缺图或限位异常不自动重试。',screen:'空槽缓关',sub:'待实机限位与动作时序标定'}
 ];
'''+app[b:]
a=app.index(' const presets=');b=app.index(' let moveTo=',a)
app=app[:a]+''' const presets={mechanism:{target:[118,233,120],distance:555,theta:.7,phi:1.05},whole:{target:[110,235,120],distance:1020,theta:.32,phi:1.15},parts:{target:[133,240,124],distance:650,theta:.75,phi:1.03},servo:{target:[115,230,123],distance:470,theta:1.16,phi:1.31}};
'''+app[b:]
a=app.index(' function drawScreen(');b=app.index(' function setTime(',a)
app=app[:a]+''' function drawScreen(force=false){const t=state.time,n=phaseAt(t),gotA=t>=5.45,gotB=t>=6.85,k=n+'-'+gotA+'-'+gotB;if(!force&&k===screenKey)return;screenKey=k;ctx.fillStyle='#14262e';ctx.fillRect(0,0,640,480);ctx.fillStyle='#d6edf0';ctx.font='600 23px sans-serif';ctx.fillText('BeanLens  /  H2',25,37);ctx.textAlign='right';ctx.fillStyle='#829fa9';ctx.font='16px sans-serif';ctx.fillText('预设双摄示例',615,37);ctx.textAlign='left';
  for(let side=0;side<2;side++){const x=25+side*305;ctx.fillStyle='#213b43';ctx.fillRect(x,59,280,256);ctx.fillStyle=side?'#e1b675':'#84c5d3';ctx.font='19px sans-serif';ctx.fillText(side?'B · 透托片下视':'A · 上视',x+14,88);const ready=side?gotB:gotA;if(ready){if(!side)drawBean(ctx,x+140,195,1.22);else{ctx.save();ctx.translate(x+140,195);ctx.rotate(.18);const g=ctx.createRadialGradient(-10,-10,2,0,0,67);g.addColorStop(0,'#b8b48d');g.addColorStop(1,'#6c7250');ctx.fillStyle=g;ctx.beginPath();ctx.ellipse(0,0,43,63,0,0,Math.PI*2);ctx.fill();ctx.fillStyle='#5f4c34';ctx.beginPath();ctx.ellipse(15,-8,7,12,.25,0,Math.PI*2);ctx.fill();ctx.restore();}ctx.strokeStyle=side?'#e3ac60':'#65acbc';ctx.lineWidth=2;ctx.strokeRect(x+78,111,124,166);ctx.font='17px sans-serif';ctx.fillStyle='#c4dce2';ctx.fillText(side?'示例：可疑斑点':'示例：当前可见面',x+35,300);}else{ctx.fillStyle='#7796a1';ctx.font='21px sans-serif';ctx.fillText('等待本侧图像',x+65,205);}}
  ctx.fillStyle='#b6d4dd';ctx.font='20px sans-serif';ctx.fillText('同一颗豆 / 同一个 cycle_id',25,352);ctx.fillStyle='#e4bf80';ctx.font='23px sans-serif';ctx.fillText(gotB?'配对结果：疑似 · 计1颗':'两路均可用后，才允许放豆',25,393);ctx.fillStyle='#88aab5';ctx.font='17px sans-serif';ctx.fillText('KEY0 拍摄 / 确认     KEY1 软件停止',25,445);model.screenTexture.needsUpdate=true;
 }
'''+app[b:]
a=app.index(' function applyMotion()');b=app.index(' function setPlaying(',a)
app=app[:a]+''' function applyMotion(){const t=state.time;let angle=0;if(t>=10&&t<12)angle=90*ease((t-10)/2);else if(t>=12&&t<14.5)angle=90;else if(t>=14.5)angle=90*(1-ease((t-14.5)/3.1));model.rotating.rotation.y=-angle*Math.PI/180;$('#gateAngle').textContent=Math.round(angle)+'°';
  model.bean.visible=t>=1.5;const b=model.bean;let by=45,bz=300;if(t<2.6){const u=ease((t-1.5)/1.1);by=lerp(45,55,u);bz=lerp(304,220+(124-55)*Math.tan(Math.PI*35/180)+2.8,u);}else if(t<4.5){const u=ease((t-2.6)/1.9);by=lerp(55,116.5,u);bz=220+(124-by)*Math.tan(Math.PI*35/180)+2.8;}else if(t<10.95){by=116.5;bz=228.0516;}else if(t<11.8){const u=ease((t-10.95)/.85);by=lerp(116.5,130,u);bz=lerp(228.0516,216,u);}else if(t<12.2){const u=ease((t-11.8)/.4);by=lerp(130,132,u);bz=lerp(216,200,u);}else if(t<13){const u=ease((t-12.2)/.8);by=lerp(132,165,u);bz=lerp(200,146,u);}else if(t<14){const u=clamp(t-13,0,1);by=165;bz=146-114*u*u;}else{by=165;bz=32;}
  b.position.copy(model.V(110,by,bz));b.rotation.set(t>13&&t<14?(t-13)*3:-.61,0,.08);model.capture.visible=t>=5.1&&t<8;model.upperCone.visible=t>=5.1&&t<6.5;model.lowerCone.visible=t>=6.5&&t<8;
  const e=state.explode;for(const o of model.explode)o.group.position.copy(o.base).addScaledVector(new T.Vector3(...o.shift),e);
 }
'''+app[b:]
a=app.index(' function selectView(');b=app.index(' function cameraUpdate(',a)
app=app[:a]+''' function selectView(view){state.view=view;$$('[data-view]').forEach(b=>{b.classList.toggle('active',b.dataset.view===view);b.setAttribute('aria-pressed',b.dataset.view===view?'true':'false');});if(view==='parts'){setPlaying(false);setTime(0);}model.frame.visible=view==='whole';model.upper.visible=view==='whole';model.bottom.visible=view==='whole';model.groups.H01.visible=view==='whole';model.groups.H21.visible=view==='whole';model.groups.H02.visible=true;model.groups.H18.visible=true;model.groups.H34.visible=true;model.shield.visible=$('#showShield').checked&&view==='whole';model.work.visible=view==='whole';model.groups.H07.visible=view==='whole';model.groups['H07-B'].visible=view==='whole';model.wiring.visible=$('#showWires').checked&&view!=='parts';model.paths.visible=view!=='parts';model.setCutaway(view==='mechanism'&&$('#cutaway').checked);model.wiring.traverse(o=>{if(o.userData.overhead)o.visible=view==='whole';});$('#showShield').disabled=view!=='whole';$('#viewNote').textContent=view==='whole'?'H2 · 两摄静拍 / 玻璃托片 / 后接豆斜槽':view==='parts'?'分件外移供认件 · 摄影托片与接豆斗分离':'蓝线A直拍 · 橙线B透片 · 暂隐木台/遮光/灯架';$('#viewScale').textContent=view==='parts'?'分件间距为演示外移':'上下工作距离各90mm起试';setPreset(view);}
'''+app[b:]
app=app.replace("$('#explainServo').onclick=()=>{if(state.view!=='mechanism')selectView('mechanism');setPreset('servo');describe(model.rotating.userData);};","$('#explainServo').onclick=()=>{window.location.href='side-section-h2.svg';};")
app=app.replace(" document.addEventListener('visibilitychange'", " $('#cutaway').onchange=e=>model.setCutaway(state.view==='mechanism'&&e.target.checked);\n document.addEventListener('visibilitychange'")
# The standalone file is one level above the sources; developer index needs a relative prefix.
app=app.replace("window.location.href='side-section-h2.svg';", "window.location.href=document.body.dataset.bundle==='yes'?'side-section-h2.svg':'../side-section-h2.svg';")
a=app.index(' window.beanLensStatus=');b=app.index('\n})();',a)
app=app[:a]+''' window.beanLensStatus=()=>({time:state.time,playing:state.playing,view:state.view,gateAngle:Math.round(-model.rotating.rotation.y*180/Math.PI),beanVisible:model.bean.visible,bean:model.bean.position.toArray(),chuteEnds:[-38.1,38.1].map(z=>model.chuteFloor.localToWorld(new T.Vector3(0,.55,z)).toArray()),cameraCount:2,hornCount:1,stationaryPair:state.time>=5&&state.time<8.2,opticalObstructions:model.opticalObstructions(),optics:model.optics,meshCount:renderer.info.render.calls,frameVisible:model.frame.visible,shieldVisible:model.shield.visible,geometrySource:'../design-h2.json',appearance:'reconstructed_not_vendor_cad'});
'''+app[b:]
(ROOT/"app.js").write_text(app)
print('H2 viewer sources prepared without changing H1')
