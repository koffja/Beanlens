// Local artifact checks and visual export. No hardware, firmware or model inference.
const fs=require('fs'),path=require('path');
const {chromium}=require('/Users/chengzhe/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const ROOT=__dirname,OUT=path.join(ROOT,'frames');fs.mkdirSync(OUT,{recursive:true});
(async()=>{
 const browser=await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true,args:['--allow-file-access-from-files']});
 const page=await browser.newPage({viewport:{width:1280,height:1000},deviceScaleFactor:1});const errors=[],requests=[];
 page.on('pageerror',e=>errors.push(e.message));page.on('request',r=>{if(/^https?:/.test(r.url()))requests.push(r.url());});
 await page.goto('file://'+path.resolve(ROOT,'../beanlens-realistic-h1.html'));await page.waitForFunction(()=>window.beanLensStatus&&window.beanLensStatus().meshCount>0);
 const checks=[];function check(name,pass,detail){checks.push({name,pass,detail});if(!pass)throw Error(name+': '+JSON.stringify(detail));}
 const status=()=>page.evaluate(()=>window.beanLensStatus());
 const time=async t=>{await page.locator('#timeline').evaluate((el,v)=>{el.value=v;el.dispatchEvent(new Event('input',{bubbles:true}));},t);await page.waitForTimeout(80);};
 check('offline_start_paused',!(await status()).playing,await status());
 const ends=(await status()).chuteEnds;check('chute_surface_matches_h1_upstream_and_downstream',Math.abs(ends[0][1]-220)<.01&&Math.abs(ends[0][2]-116)<.01&&Math.abs(ends[1][1]-254.4146)<.01&&Math.abs(ends[1][2]-165.1491)<.01,ends);
 await time(8.2);const closed=await status();check('stationary_photo_gate_closed',closed.gateAngle===0&&closed.beanVisible,closed);
 await page.screenshot({path:path.join(ROOT,'preview-mechanism.png'),fullPage:true});
 await time(12.6);const opened=await status();check('gate_opens_90_degrees',opened.gateAngle===90,opened);
 await time(16);const closing=await status();check('empty_before_slow_close',closing.gateAngle>0&&closing.gateAngle<90&&closing.bean[1]<40,closing);
 await time(18);check('end_gate_closed',(await status()).gateAngle===0,await status());
 await page.getByRole('button',{name:'播放动画',exact:true}).click();await page.waitForTimeout(400);const moving=await status();check('play_restarts_completed_cycle',moving.playing&&moving.time<3,moving);
 await page.getByRole('button',{name:'暂停动画',exact:true}).click();const paused=(await status()).time;await page.waitForTimeout(200);check('pause_holds_time',(await status()).time===paused,await status());
 await page.getByRole('button',{name:'整机装配',exact:true}).click();await page.waitForTimeout(1400);check('whole_frame_visible',(await status()).frameVisible,await status());await page.locator('#showShield').check();check('shield_toggle',(await status()).shieldVisible,await status());await page.locator('#showShield').uncheck();
 await time(8.2);await page.screenshot({path:path.join(ROOT,'preview-whole.png'),fullPage:true});
 await page.getByRole('button',{name:'部件拆解',exact:true}).click();await page.waitForTimeout(1400);const parts=await status();check('parts_pause_and_reset',parts.view==='parts'&&!parts.playing&&parts.time===0,parts);await page.screenshot({path:path.join(ROOT,'preview-parts.png'),fullPage:true});
 await page.getByRole('button',{name:'机构特写',exact:true}).click();await page.waitForTimeout(1400);
 await page.getByRole('button',{name:'聚焦舵机与挡片 →',exact:true}).click();await page.waitForTimeout(1000);check('component_explanation',await page.locator('#partName').innerText()==='单只25T直舵臂');
 await page.getByRole('button',{name:'恢复视角 ↺',exact:true}).click();await page.waitForTimeout(1400);
 // Native animation preview: 18 seconds, 4 fps, with the 3D view and BOX display.
 for(let i=0;i<=72;i++){await time(i/4);await page.locator('#stage').screenshot({path:path.join(OUT,`stage-${String(i).padStart(3,'0')}.png`)});const data=await page.locator('#screenPreview').evaluate(el=>el.toDataURL('image/png').split(',')[1]);fs.writeFileSync(path.join(OUT,`screen-${String(i).padStart(3,'0')}.png`),Buffer.from(data,'base64'));}
 await page.setViewportSize({width:390,height:844});await time(8.2);await page.waitForTimeout(500);check('mobile_no_horizontal_overflow',await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));await page.screenshot({path:path.join(ROOT,'preview-mobile.png'),fullPage:true});
 check('no_page_errors',errors.length===0,errors);check('no_network_requests',requests.length===0,requests);
 const report={date:'2026-10-21',kind:'local_browser_only_not_hardware_validation',checks,errors,requests};fs.writeFileSync(path.join(ROOT,'browser-check.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify({passed:checks.length,errors,networkRequests:requests.length}));await browser.close();
})().catch(e=>{console.error(e);process.exit(1);});
