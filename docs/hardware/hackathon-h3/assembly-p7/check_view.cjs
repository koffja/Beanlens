const fs=require('fs'),path=require('path');
const {chromium}=require('/Users/chengzhe/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const ROOT=__dirname;
(async()=>{
 const browser=await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true});
 const page=await browser.newPage({viewport:{width:1500,height:1100}}),checks=[],errors=[],network=[];
 page.on('pageerror',e=>errors.push(e.message));page.on('request',r=>{if(/^https?:/.test(r.url()))network.push(r.url());});
 function check(name,pass){checks.push({name,pass});if(!pass)throw Error(name);}
 const shots=path.join(ROOT,'shots');fs.mkdirSync(shots,{recursive:true});
 await page.goto('file://'+path.join(ROOT,'beanlens-assembly-p7.html'));await page.waitForFunction(()=>window.assemblyStatus);await page.waitForTimeout(250);
 const initial=await page.evaluate(()=>window.assemblyStatus());check('two_hopper_print_parts',initial.printedCount===2);check('six_wood_parts',initial.visibleParts.filter(id=>/^W\d\d$/.test(id)).length===6);check('twelve_profiles',initial.visibleParts.filter(id=>/^T\d\d$/.test(id)||id==='P28').length===12);
 await page.locator('#stage').screenshot({path:path.join(shots,'whole.png')});
 check('no_printed_camera_or_roof_records',!initial.visibleParts.some(id=>['P22','P23','SH-T'].includes(id)));check('four_adhesive_fillets_visible',initial.visibleParts.filter(id=>id.startsWith('GL-')).length===4);
 check('P7_camera_board_and_box_geometry',await page.evaluate(()=>{const d=window.P7DATA,p=id=>d.parts.find(p=>p.id===id);return p('W05').bounds[0]===0&&p('W04').bounds[3]===220&&p('W03').bounds[2]===352&&p('W03').bounds[5]===440&&d.camera_boards.every(b=>b.size[0]===40)&&d.camera_separation_mm===110.4;}));
 check('five_real_shield_parts_no_roof',(await page.evaluate(()=>assemblyStatus())).shieldCount===5);
 const solid=await page.locator('#stage').screenshot({path:path.join(shots,'shield-solid.png')});
 await page.locator('[data-material=shield]').uncheck();await page.waitForTimeout(150);check('shield_checkbox_really_hides',(await page.evaluate(()=>assemblyStatus())).shieldVisible===0);
 const hidden=await page.locator('#stage').screenshot({path:path.join(shots,'shield-hidden.png')});check('shield_render_changes',!solid.equals(hidden));
 await page.locator('#shield-mode').selectOption('transparent');await page.waitForTimeout(150);check('shield_transparent_has_five',(await page.evaluate(()=>assemblyStatus())).shieldVisible===5);
 const transparent=await page.locator('#stage').screenshot({path:path.join(shots,'shield-transparent.png')});check('transparent_differs_from_hidden_and_black',!transparent.equals(hidden)&&!transparent.equals(solid));
 await page.locator('#shield-mode').selectOption('solid');await page.locator('#focus-shield').click();check('shield_shortcut_focuses_J15',(await page.evaluate(()=>assemblyStatus())).joint==='J15');await page.getByRole('button',{name:'整机组装',exact:true}).click();

 await page.getByRole('button',{name:'整机爆炸',exact:true}).click();check('exploded_view',(await page.evaluate(()=>window.assemblyStatus())).explode===.65);await page.waitForTimeout(200);await page.locator('#stage').screenshot({path:path.join(shots,'exploded.png')});
 for(const i of [1,2,3,4,5,6,10,12,13,14,15]){
  const id='J'+String(i).padStart(2,'0');await page.locator('#joint').selectOption(id);const state=await page.evaluate(()=>window.assemblyStatus());check(id+'_focus',state.view==='joint'&&state.joint===id&&state.visibleParts.length>0);
  await page.waitForTimeout(120);await page.locator('#stage').screenshot({path:path.join(shots,id+'-assembled.png')});
  await page.locator('#explode').fill('0.6');await page.locator('#explode').dispatchEvent('input');await page.waitForTimeout(100);await page.locator('#stage').screenshot({path:path.join(shots,id+'-exploded.png')});
 }
 await page.getByRole('button',{name:'整机组装',exact:true}).click();await page.locator('#timeline').fill('0.9');await page.locator('#timeline').dispatchEvent('input');await page.locator('#demo-result').selectOption('missing');check('manual_missing_image_message',(await page.locator('#demo-text').textContent()).includes('不能追回'));
 await page.locator('#reset-demo').click();check('demo_reset',(await page.evaluate(()=>window.assemblyStatus())).demoProgress===0);
 check('no_servo_records',!(await page.evaluate(()=>window.assemblyStatus())).visibleParts.some(id=>['H03','H36','P21','P24','P25','P26','P28','P30','H11','H37'].includes(id)));
 await page.locator('#bom-search').fill('H02');await page.locator('#bom-list button').first().click();check('BOM_finds_glued_camera',(await page.evaluate(()=>window.assemblyStatus())).selected==='H02-A');
 await page.getByRole('button',{name:'整机组装',exact:true}).click();await page.locator('input[data-material="wood"]').uncheck();check('wood_filter_hides',!(await page.evaluate(()=>window.assemblyStatus())).visibleParts.some(id=>/^W\d\d$/.test(id)));await page.locator('input[data-material="wood"]').check();
 await page.locator('input[data-material="print"]').uncheck();check('print_filter_hides',!(await page.evaluate(()=>window.assemblyStatus())).visibleParts.some(id=>['P11','P13'].includes(id)));await page.locator('input[data-material="print"]').check();
 await page.locator('#bom-search').fill('');await page.screenshot({path:path.join(ROOT,'preview-whole.png'),fullPage:true});
 await page.getByRole('button',{name:'正视',exact:true}).click();await page.waitForTimeout(120);await page.locator('#stage').screenshot({path:path.join(shots,'front.png')});await page.getByRole('button',{name:'侧视',exact:true}).click();await page.waitForTimeout(120);await page.locator('#stage').screenshot({path:path.join(shots,'side.png')});
 await page.evaluate(()=>window.assemblySet({view:'whole',progress:.52}));await page.waitForTimeout(150);await page.locator('#stage').screenshot({path:path.join(shots,'manual-drop.png')});await page.evaluate(()=>window.assemblySet({progress:0}));
 await page.setViewportSize({width:390,height:844});await page.getByRole('button',{name:'整机组装',exact:true}).click();await page.waitForTimeout(200);check('mobile_no_overflow',await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));await page.screenshot({path:path.join(ROOT,'preview-mobile.png'),fullPage:true});
 check('no_page_errors',errors.length===0);check('offline_no_requests',network.length===0);
 fs.writeFileSync(path.join(ROOT,'browser-check.json'),JSON.stringify({checks,errors,network,physicalVerified:false},null,2)+'\n');console.log(JSON.stringify({checks:checks.length,errors,network}));await browser.close();
})().catch(e=>{console.error(e);process.exit(1);});
