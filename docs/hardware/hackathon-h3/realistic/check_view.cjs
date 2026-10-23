const fs=require('fs'),path=require('path');
const {chromium}=require('/Users/chengzhe/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const ROOT=__dirname,FRAMES=path.join(ROOT,'frames');fs.mkdirSync(FRAMES,{recursive:true});
(async()=>{
 const browser=await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true,args:['--allow-file-access-from-files']});
 const page=await browser.newPage({viewport:{width:1440,height:1000},deviceScaleFactor:1}),errors=[],requests=[],checks=[];
 page.on('pageerror',e=>errors.push(e.message));page.on('request',r=>{if(/^https?:/.test(r.url()))requests.push(r.url());});
 function check(name,pass,detail){checks.push({name,pass,detail});if(!pass)throw Error(name+': '+JSON.stringify(detail));}
 const status=()=>page.evaluate(()=>window.beanLensStatus());
 const at=async t=>{await page.locator('#timeline').evaluate((el,v)=>{el.value=v;el.dispatchEvent(new Event('input',{bubbles:true}));},t);await page.waitForTimeout(75);};
 await page.goto('file://'+path.resolve(ROOT,'../beanlens-realistic-h3.html'));await page.waitForFunction(()=>window.beanLensStatus&&window.beanLensStatus().meshCount>0);
 let s=await status();check('offline_initial_whole_frame_two_cameras_one_horn_two_balls',!s.playing&&s.frameVisible&&s.cameraCount===2&&s.hornCount===1&&s.ballHeadCount===2,s);
 check('both_horizontal_central_sight_lines_clear',s.opticalObstructions.every(a=>a.length===0),s.opticalObstructions);
 check('closed_gate_covers_18x14_hole',Math.abs(s.gate.leading_y-108)<1e-6&&s.gate.leading_y+82>127,s.gate);
 await at(2.7);s=await status();check('streams_prepared_before_release_and_no_images_yet',Math.abs(s.bean[1]-328.8)<1e-6&&s.gate.slide_mm<1e-6&&!s.gotA&&!s.gotB,s);
 await at(6.2);s=await status();check('fully_open_before_illustrated_release',Math.abs(s.gate.slide_mm-19.748684174)<1e-6&&s.gate.leading_y>127&&s.bean[1]===328.8,s);
 await at(7.59);const a=await status();await at(7.65);const b=await status();check('two_horizontal_views_capture_falling_not_stationary_bean',a.bean[1]>b.bean[1]&&a.bean[1]<285&&b.bean[1]>235&&b.gotB&&!b.stationaryPair,{a,b});
 await at(10);check('bean_enters_cup_before_closing',(await status()).bean[1]===32);
 await at(12.7);s=await status();check('slow_close_after_empty_path',s.gate.slide_mm>0&&s.gate.slide_mm<19.75&&s.bean[1]===32,s);
 await at(18);check('cycle_ends_closed',Math.abs((await status()).gate.slide_mm)<1e-6);
 await page.getByRole('button',{name:'播放动画',exact:true}).click();await page.waitForTimeout(300);check('play_restarts_finished_cycle',(await status()).playing&&(await status()).time<2);await page.getByRole('button',{name:'暂停动画',exact:true}).click();const pause=(await status()).time;await page.waitForTimeout(180);check('pause_holds_time',pause===(await status()).time);
 await page.locator('#showShield').check();check('side_shields_do_not_block_rear_camera',(await status()).shieldVisible&&(await status()).opticalObstructions.every(a=>a.length===0));await page.locator('#showShield').uncheck();
 await at(7.65);await page.screenshot({path:path.join(ROOT,'preview-whole.png'),fullPage:true});
 await page.getByRole('button',{name:'豆路与双摄',exact:true}).click();await page.waitForTimeout(1200);await page.locator('#cutaway').uncheck();check('opaque_funnels_keep_central_optics_clear',(await status()).opticalObstructions.every(a=>a.length===0));await page.screenshot({path:path.join(ROOT,'preview-optics.png'),fullPage:true});
 await page.getByRole('button',{name:'聚焦抽拉闸与双球头 →',exact:true}).click();await page.waitForTimeout(1200);check('linkage_focus_has_component_explanation',(await page.locator('#partId').textContent())==='H37');await at(2.5);await page.screenshot({path:path.join(ROOT,'preview-gate.png'),fullPage:true});
 await page.getByRole('button',{name:'部件拆解',exact:true}).click();await page.waitForTimeout(1200);s=await status();check('exploded_view_is_paused_and_closed',s.view==='parts'&&!s.playing&&s.time===0,s);await page.screenshot({path:path.join(ROOT,'preview-parts.png'),fullPage:true});
 await page.getByRole('button',{name:'豆路与双摄',exact:true}).click();await page.waitForTimeout(1200);await page.locator('#cutaway').uncheck();
 let previous=-1;const samples=[];for(let i=0;i<=20;i++){await at(4.2+i/10);s=await status();samples.push({t:s.time,slide:s.gate.slide_mm,length:s.gate.rod_length_mm});check('rigid_link_monotonic_sample_'+i,Math.abs(s.gate.rod_length_mm-50)<1e-6&&s.gate.slide_mm>=previous-1e-6,s.gate);previous=s.gate.slide_mm;}
 for(let i=0;i<=72;i++){await at(i/4);await page.locator('#stage').screenshot({path:path.join(FRAMES,`stage-${String(i).padStart(3,'0')}.png`)});const data=await page.locator('#screenPreview').evaluate(el=>el.toDataURL('image/png').split(',')[1]);fs.writeFileSync(path.join(FRAMES,`screen-${String(i).padStart(3,'0')}.png`),Buffer.from(data,'base64'));}
 await page.setViewportSize({width:390,height:844});await at(7.65);await page.waitForTimeout(250);check('mobile_no_horizontal_overflow',await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));await page.screenshot({path:path.join(ROOT,'preview-mobile.png'),fullPage:true});
 check('no_page_errors',errors.length===0,errors);check('no_external_network_requests',requests.length===0,requests);
 fs.writeFileSync(path.join(ROOT,'browser-check.json'),JSON.stringify({date:'2026-10-21',kind:'host_browser_and_geometry_not_hardware_validation',checks,samples,errors,requests},null,2)+'\n');console.log(JSON.stringify({passed:checks.length,errors,networkRequests:requests.length}));await browser.close();
})().catch(e=>{console.error(e);process.exit(1);});
