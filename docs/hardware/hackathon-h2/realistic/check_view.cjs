const fs=require('fs'),path=require('path');
const {chromium}=require('/Users/chengzhe/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const ROOT=__dirname,FRAMES=path.join(ROOT,'frames');fs.mkdirSync(FRAMES,{recursive:true});
(async()=>{
 const browser=await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true,args:['--allow-file-access-from-files']});
 const page=await browser.newPage({viewport:{width:1280,height:1000},deviceScaleFactor:1}),errors=[],requests=[],checks=[];
 page.on('pageerror',e=>errors.push(e.message));page.on('request',r=>{if(/^https?:/.test(r.url()))requests.push(r.url());});
 function check(name,pass,detail){checks.push({name,pass,detail});if(!pass)throw Error(name+': '+JSON.stringify(detail));}
 const status=()=>page.evaluate(()=>window.beanLensStatus());
 const at=async t=>{await page.locator('#timeline').evaluate((el,v)=>{el.value=v;el.dispatchEvent(new Event('input',{bubbles:true}));},t);await page.waitForTimeout(90);};
 await page.goto('file://'+path.resolve(ROOT,'../beanlens-realistic-h2.html'));await page.waitForFunction(()=>window.beanLensStatus&&window.beanLensStatus().meshCount>0);
 let s=await status();check('offline_paused_two_cameras_one_horn',!s.playing&&s.cameraCount===2&&s.hornCount===1,s);
 const ends=s.chuteEnds;check('glass_surface_matches_calculated_35deg',Math.abs(ends[0][1]-220)<.01&&Math.abs(ends[1][1]-263.706524)<.01&&Math.abs(ends[1][2]-178.419386)<.01,ends);
 check('both_central_sight_lines_clear_of_opaque_parts',s.opticalObstructions.every(a=>a.length===0),s.opticalObstructions);
 await at(5.7);const a=await status();await at(7.2);const b=await status();check('same_stationary_bean_during_A_and_B',a.gateAngle===0&&b.gateAngle===0&&a.bean.every((v,i)=>Math.abs(v-b.bean[i])<.001),{a,b});
 await at(8.2);await page.screenshot({path:path.join(ROOT,'preview-optics.png'),fullPage:true});check('pair_before_release',(await status()).gateAngle===0);
 await page.locator('#cutaway').uncheck();check('cutaway_toggle_does_not_change_geometry',(await status()).opticalObstructions.every(a=>a.length===0));await page.locator('#cutaway').check();
 await at(12.6);check('gate_open_90deg',(await status()).gateAngle===90,await status());
 await at(13.3);s=await status();check('rear_release_keeps_bean_behind_camera',Math.abs(240-s.bean[2]-165)<.001&&s.bean[1]<146,s);
 await at(16);s=await status();check('slow_close_after_bean_in_cup',s.gateAngle>0&&s.gateAngle<90&&s.bean[1]===32,s);
 await at(18);check('cycle_ends_closed',(await status()).gateAngle===0);
 await page.getByRole('button',{name:'播放动画',exact:true}).click();await page.waitForTimeout(350);check('restart_after_completion',(await status()).playing&&(await status()).time<3);await page.getByRole('button',{name:'暂停动画',exact:true}).click();const pause=(await status()).time;await page.waitForTimeout(200);check('pause_holds',pause===(await status()).time);
 await page.getByRole('button',{name:'整机装配',exact:true}).click();await page.waitForTimeout(1400);check('whole_view_frame',(await status()).frameVisible);await page.locator('#showShield').check();check('removable_shield_toggle',(await status()).shieldVisible);await page.locator('#showShield').uncheck();await at(8.2);await page.screenshot({path:path.join(ROOT,'preview-whole.png'),fullPage:true});
 await page.getByRole('button',{name:'部件拆解',exact:true}).click();await page.waitForTimeout(1400);s=await status();check('exploded_mode_paused_and_closed',s.view==='parts'&&!s.playing&&s.time===0,s);await page.screenshot({path:path.join(ROOT,'preview-parts.png'),fullPage:true});
 await page.getByRole('button',{name:'双摄光路',exact:true}).click();await page.waitForTimeout(1400);
 for(let i=0;i<=72;i++){await at(i/4);await page.locator('#stage').screenshot({path:path.join(FRAMES,`stage-${String(i).padStart(3,'0')}.png`)});const data=await page.locator('#screenPreview').evaluate(el=>el.toDataURL('image/png').split(',')[1]);fs.writeFileSync(path.join(FRAMES,`screen-${String(i).padStart(3,'0')}.png`),Buffer.from(data,'base64'));}
 await page.setViewportSize({width:390,height:844});await at(8.2);await page.waitForTimeout(300);check('mobile_no_horizontal_overflow',await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));await page.screenshot({path:path.join(ROOT,'preview-mobile.png'),fullPage:true});
 check('no_page_errors',errors.length===0,errors);check('no_network_requests',requests.length===0,requests);
 fs.writeFileSync(path.join(ROOT,'browser-check.json'),JSON.stringify({date:'2026-10-21',kind:'host_browser_and_geometry_not_hardware_or_optical_validation',checks,errors,requests},null,2)+'\n');console.log(JSON.stringify({passed:checks.length,errors,networkRequests:requests.length}));await browser.close();
})().catch(e=>{console.error(e);process.exit(1);});
