"""Derive H3 viewer controls without changing the preserved H1/H2 viewers."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parent
H1=ROOT.parents[1]/'hackathon-h1/realistic'
H2=ROOT.parents[1]/'hackathon-h2/realistic'
index=re.sub(r'\bH1\b','H3',(H1/'index.html').read_text()).replace('bom-h1','bom-h3')
index=index.replace('机构特写','豆路与双摄').replace('挡片相对打开角','闸片后退行程').replace('沿用 H3 相对尺寸','落豆段慢放12× · 非实测速度')
index=index.replace('槽体固定 · 只有一只舵臂带挡片转动','顶入豆 → 单槽抽拉闸 → 水平双摄 → 下接豆斗')
index=index.replace('单颗停稳','预先采集').replace('拍照识别','开闸放豆').replace('结果保存','双摄抓拍').replace('侧摆放豆','配对保存')
index=index.replace('data-time="5"','data-time="4.2"').replace('data-time="8.2"','data-time="7.62"').replace('data-time="10.5"','data-time="8.5"').replace('data-time="15"','data-time="12.5"')
index=index.replace('等你放入一颗豆','从上方放入一颗豆').replace('人工从短槽上方放入一颗生豆。这里没有大料斗，也没有自动逐豆送料器。','保留原本竖直豆路与水平双摄，只将五槽缩成单槽、长闸片改成小抽拉片。比赛仍人工一次一颗。')
index=index.replace('H03 · H10 · H11 · H12','H11 ×1 · H37 ×1 · H36').replace('先看清这四件东西','一只舵臂，怎样拉直线？')
index=index.replace('黑色舵机机身锁在固定支架上；银色直舵臂套在输出轴上，再经小L角片带动白色PP挡片。固定架不转，舵臂只用一只。','固定MG996R带一只R16直臂；两颗球头和一根50mm球心距短杆，拉动铝闸片后退约20mm。两块PP盖板与侧垫条导向，前方外壳封闭。')
index=index.replace('聚焦舵机与挡片 →','聚焦抽拉闸与双球头 →')
index=index.replace('相机板、支架孔位及防转连接待实配；动画时长与角度不代表实测。','连杆、支架、短曝光和漏拍均待实测；落豆段慢放12×，分类画面为预设。')
index=index.replace('本页显示了什么？','先看原豆路与H3差异').replace('黑2020框架、三层海洋板、单GC2093、两条常亮灯、MG996R、固定架、单舵臂、L角片、PP单槽/挡片、两个限位、BOX与收豆杯。机外电源沿用原接线图。','黑2020框架、顶入豆PP斗、单槽小抽拉闸、水平前后两摄、两面常亮灯、下接豆斗、主屏与普通杯。没有透明托片；不做自动逐豆送料、称重或分选。')
index=index.replace('特写隐藏上部框架和相机平台，以便看清内部。展示的分类为预设结果；自动播放代演人工投豆与按KEY0。真实机器须先确认关位，再允许投豆。','相机先采集，闸门再放豆，不能等豆落进窗内才启动相机。局部视图隐藏框架便于看豆路；整机恢复框架和支承。自动播放代演人工动作。')
index=index.replace('单摄 / 单槽 / 人工逐颗 / 静止拍照 / 侧摆放走','顶入豆 / 单槽抽拉闸 / 水平双摄 / 人工单颗 / 落豆抓拍')
index=index.replace('href="../05-signals.svg"','href="../wiring-h3.svg"').replace('信号接线 ↗','电源与信号接线 ↗')
index=index.replace('<a href="README.md">外形依据与验证范围 ↗</a>','<a href="../side-section-h3.svg">豆路 / 闸门剖面 ↗</a> · <a href="README.md">外形依据与验证范围 ↗</a>')
index=index.replace('<span id="viewScale">','<label><input id="cutaway" type="checkbox"> 透视斗壁</label><span id="viewScale">')
index=index.replace('src="model.js"','src="design-data.js"></script><script src="model-base-h1.js"></script><script src="model.js"')
(ROOT/'index.html').write_text(index)
app=(H2/'app.js').read_text()
def replace_block(start,end,text):
 global app
 a=app.index(start);b=app.index(end,a);app=app[:a]+text+app[b:]
replace_block(' const phases=[',' let renderer', ''' const phases=[
  {at:0,title:'顶入豆，仍然人工一次一颗',copy:'保留原本从顶部入豆的豆路。80×80小斗收至18×14单槽；这里只做引导，不会自动从一堆豆中分出单颗。先确认关位，再投一颗。',screen:'等待单颗',sub:'关位明确 → 人工放一颗并确认'},
  {at:2.5,title:'两只水平相机提前开始采集',copy:'豆停在闸片上方。前摄A水平向后、后摄B水平向前，均看下方Z260落豆窗；两路采集和常亮灯应在开闸前准备好。此时还没有拿到本颗的拍摄图。',screen:'双路已准备',sub:'先采集，再开闸；不是停豆拍照'},
  {at:4.2,title:'小抽拉闸后退约20mm',copy:'MG996R机身固定，一只R16直臂经两颗球头和一根50mm短杆拉动铝闸片。上下PP盖板形成导槽，前方固定外壳连续，闸片不会伸到前方外面。',screen:'开闸释放',sub:'单槽 / 无直线导轨 / 无同步横梁'},
  {at:7.45,title:'豆从水平双摄之间下落',copy:'蓝线为前摄A，橙线为后摄B，光轴同高且水平相向。落豆段慢放12×。实际50mm观察带理想通过约45ms，必须验证短曝光、清楚帧数量及两路同颗配对。',screen:'双摄抓拍',sub:'预设抓拍 · 动态豆粒需要短曝光'},
  {at:8.5,title:'下斗接走，双图只计一颗',copy:'下接豆斗在拍摄窗下方，所有类别进入同一普通杯。A/B各有清楚图才配成一颗；漏图、模糊、多豆或配对不确定都待复核。没有合格图也不能把这颗记作正常。',screen:'配对保存',sub:'预设结果：B疑似 / 两图计1颗'},
  {at:11.5,title:'确认豆路为空，再缓关',copy:'人工确认豆已入杯、槽内为空，再让闸片慢慢切回。软件可分步改变PWM目标实现缓关，但仍须动作超时和关限位；卡豆撤销驱动，不持续加力。',screen:'空槽缓关',sub:'关位确认后，再投下一颗'}
 ];
''')
replace_block(' const presets=',' let moveTo=', ''' const presets={mechanism:{target:[114,287,120],distance:730,theta:1.12,phi:1.22},whole:{target:[110,235,120],distance:1020,theta:.53,phi:1.18},parts:{target:[130,310,125],distance:970,theta:.9,phi:1.14},servo:{target:[137,327,69],distance:250,theta:.55,phi:1.18}};
''')
app=app.replace("BeanLens  /  H2","BeanLens  /  H3").replace("预设双摄示例","预设落豆示例").replace("gotA=t>=5.45,gotB=t>=6.85","gotA=t>=7.59,gotB=t>=7.65").replace("B · 透托片下视","B · 后摄水平向前").replace("A · 上视","A · 前摄水平向后").replace("两路均可用后，才允许放豆","先采集 → 开闸 → 配对与复核").replace("KEY0 拍摄 / 确认","KEY0 准备 / 确认")
replace_block(' function applyMotion()',' function setPlaying(', ''' function applyMotion(){const t=state.time;let u=0;if(t>=4.2&&t<6.2)u=ease((t-4.2)/2);else if(t>=6.2&&t<11.5)u=1;else if(t>=11.5)u=1-ease((t-11.5)/3.5);model.setGate(u);$('#gateAngle').textContent=model.gateState.slide_mm.toFixed(1)+' mm';
  model.bean.visible=t>=.8;let z=460;if(t<2.5)z=lerp(460,328.8,ease((t-.8)/1.7));else if(t<6.2)z=328.8;else z=Math.max(32,328.8-.5*9810*Math.pow((t-6.2)/12,2));model.bean.position.copy(model.V(110,120,z));model.bean.rotation.set(t>6.2&&z>32?(t-6.2)*2.2:.15,.1,.13);model.capture.visible=t>=7.35&&t<7.95;
  for(const o of model.explode){o.group.position.copy(o.base).addScaledVector(new T.Vector3(...o.shift),state.explode);if(o.group===model.gate||o.group===model.groups.H12)o.group.position.z-=model.gateState.slide_mm;}
 }
''')
replace_block(' function selectView(',' function cameraUpdate(', ''' function selectView(view){state.view=view;$$('[data-view]').forEach(b=>{b.classList.toggle('active',b.dataset.view===view);b.setAttribute('aria-pressed',b.dataset.view===view?'true':'false');});if(view==='parts'){setPlaying(false);setTime(0);}const whole=view==='whole';model.frame.visible=whole;model.upper.visible=whole;model.bottom.visible=whole;model.work.visible=whole;model.groups.H01.visible=whole;model.groups.H21.visible=view!=='parts';model.cameraSupports.visible=whole;model.groups.H02.visible=true;model.groups.H18.visible=true;model.groups.H34.visible=true;model.groups.H07.visible=whole;model.shield.visible=$('#showShield').checked&&whole;model.wiring.visible=$('#showWires').checked&&view!=='parts';model.paths.visible=view!=='parts';model.setCutaway(view==='mechanism'&&$('#cutaway').checked);$('#showShield').disabled=!whole;$('#viewNote').textContent=whole?'220×240×460 · 顶入豆 / 水平双摄 / 单槽抽拉闸':view==='parts'?'分件外移供认件 · 孔位与采购实物配合待验证':'豆路剖视 · 斗壁半透明仅为教学 · 落豆段慢放12×';$('#viewScale').textContent=view==='parts'?'部件间距为演示外移':'落豆段慢放12× · 非实测速度';setPreset(view);}
''')
a=app.index("$('#explainServo').onclick=");b=app.index('\n',a)
app=app[:a]+"$('#explainServo').onclick=()=>{if(state.view!=='mechanism')selectView('mechanism');setPreset('servo');describe(model.linkage.userData);};"+app[b:]
app=app.replace("&&!(state.view==='mechanism'&&item.text.includes('H02'))",'')
replace_block(' window.beanLensStatus=','\n})();', ''' window.beanLensStatus=()=>({time:state.time,playing:state.playing,view:state.view,gate:model.gateState,beanVisible:model.bean.visible,bean:model.bean.position.toArray(),cameraCount:2,hornCount:1,ballHeadCount:2,stationaryPair:false,frameVisible:model.frame.visible,shieldVisible:model.shield.visible,opticalObstructions:model.opticalObstructions(),geometrySource:'../design-h3.json',appearance:'reconstructed_not_vendor_cad',fallSlowdown:12,gotA:state.time>=7.59,gotB:state.time>=7.65,meshCount:renderer.info.render.calls});
''')
app=app.replace("selectView('mechanism');setPreset('mechanism',true);setTime(0);","selectView('whole');setPreset('whole',true);setTime(0);")
(ROOT/'app.js').write_text(app)
print('H3 viewer prepared')
