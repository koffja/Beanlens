const fs=require('fs'),path=require('path');
const {chromium}=require('/Users/chengzhe/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const ROOT=__dirname;
(async()=>{
 const browser=await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true,args:['--allow-file-access-from-files']});
 const p=await browser.newPage({viewport:{width:1440,height:1080}}),errors=[],network=[],checks=[];
 p.on('pageerror',e=>errors.push(e.message));p.on('request',r=>{if(/^https?:/.test(r.url()))network.push(r.url());});
 function check(name,pass){checks.push({name,pass});if(!pass)throw Error(name);}
 await p.goto('file://'+path.join(ROOT,'preview.html'));await p.waitForFunction(()=>window.printPreviewStatus);await p.waitForTimeout(300);
 check('six_mounted_parts',(await p.evaluate(()=>window.printPreviewStatus())).visibleParts.length===6);
 await p.screenshot({path:path.join(ROOT,'preview-assembly.png'),fullPage:true});
 await p.locator('#slide').fill('1');await p.locator('#slide').dispatchEvent('input');
 check('full_gate_travel',(await p.locator('#travel').textContent()).startsWith('19.75mm'));
 await p.locator('#references').uncheck();check('hide_references',!(await p.evaluate(()=>window.printPreviewStatus())).referenceVisible);
 await p.locator('#references').check();
 await p.getByRole('button',{name:'舵机组特写',exact:true}).click();await p.waitForTimeout(200);
 await p.screenshot({path:path.join(ROOT,'preview-servo-open.png'),fullPage:true});
 await p.locator('#slide').fill('0');await p.locator('#slide').dispatchEvent('input');await p.waitForTimeout(100);
 await p.screenshot({path:path.join(ROOT,'preview-servo-closed.png'),fullPage:true});
 await p.getByRole('button',{name:'拆开看',exact:true}).click();await p.waitForTimeout(100);
 await p.screenshot({path:path.join(ROOT,'preview-exploded.png'),fullPage:true});
 for(const name of ['servo-cradle-mm','camera-front-mm','camera-rear-mm','limit-closed-seat-mm','limit-open-seat-mm','gate-limit-flag-mm']){
  await p.locator('#part').selectOption(name);const s=await p.evaluate(()=>window.printPreviewStatus());
  check('single_print_'+name,s.mode==='print'&&s.visibleParts.length===1&&!s.referenceVisible);
  for(const [id,ext] of [['stl','stl'],['mf','3mf'],['step','step']])check('download_'+ext+'_'+name,(await p.locator('#'+id).getAttribute('href'))==='parts/'+name+'.'+ext);
  await p.waitForTimeout(120);await p.screenshot({path:path.join(ROOT,'preview-'+name+'.png'),fullPage:true});
 }
 await p.setViewportSize({width:390,height:844});await p.waitForTimeout(300);
 check('mobile_no_overflow',await p.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));
 await p.screenshot({path:path.join(ROOT,'preview-mobile.png'),fullPage:true});
 for(const name of ['aluminum-base','carrier','camera-hole-check','servo-ear-check']){
  await p.goto('about:blank');await p.setViewportSize({width:850,height:1000});
  await p.setContent('<!doctype html><meta charset="utf-8"><style>body{margin:20px;background:#eee}svg{background:white}</style>'+fs.readFileSync(path.join(ROOT,'templates',name+'.svg'),'utf8'));
  await p.screenshot({path:path.join(ROOT,'template-'+name+'.png'),fullPage:true,timeout:10000});
 }
 check('no_page_errors',!errors.length);check('offline_no_network',!network.length);
 fs.writeFileSync(path.join(ROOT,'browser-check.json'),JSON.stringify({date:'2026-10-22',checks,errors,network,printed:false},null,2)+'\n');
 console.log(JSON.stringify({checks:checks.length,errors,network}));await browser.close();
})().catch(e=>{console.error(e);process.exit(1);});
