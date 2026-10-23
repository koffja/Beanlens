const fs=require('fs'),path=require('path');
const {chromium}=require('/Users/chengzhe/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const ROOT=__dirname;
(async()=>{
 const browser=await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true,args:['--allow-file-access-from-files']});
 const p=await browser.newPage({viewport:{width:1380,height:1000}}),errors=[],network=[],checks=[];
 p.on('pageerror',e=>errors.push(e.message));p.on('request',r=>{if(/^https?:/.test(r.url()))network.push(r.url());});
 function check(name,pass){checks.push({name,pass});if(!pass)throw Error(name);}
 await p.goto('file://'+path.join(ROOT,'preview.html'));await p.waitForFunction(()=>window.printPreviewStatus);await p.waitForTimeout(200);
 check('three_mounted_parts',(await p.evaluate(()=>window.printPreviewStatus())).visibleParts.length===3);
 await p.screenshot({path:path.join(ROOT,'preview-assembly.png'),fullPage:true});
 await p.getByRole('button',{name:'拆开看接口',exact:true}).click();await p.waitForTimeout(100);await p.screenshot({path:path.join(ROOT,'preview-exploded.png'),fullPage:true});
 for(const name of ['upper-hopper-mm','upper-adapter-mm','lower-collector-mm']){
  await p.locator('#part').selectOption(name);const s=await p.evaluate(()=>window.printPreviewStatus());
  check('single_print_'+name,s.mode==='print'&&s.visibleParts.length===1&&!s.referenceVisible);
  check('download_matches_selection_'+name,(await p.locator('#stl').getAttribute('href'))==='parts/'+name+'.stl');
  await p.waitForTimeout(100);await p.screenshot({path:path.join(ROOT,'preview-'+name+'.png'),fullPage:true});
 }
 await p.setViewportSize({width:390,height:844});await p.waitForTimeout(300);
 check('mobile_no_overflow',await p.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));
 await p.screenshot({path:path.join(ROOT,'preview-mobile.png'),fullPage:true});
 check('no_page_errors',!errors.length);check('offline_no_network',!network.length);
 fs.writeFileSync(path.join(ROOT,'browser-check.json'),JSON.stringify({date:'2026-10-22',checks,errors,network,printed:false},null,2)+'\n');
 console.log(JSON.stringify({checks:checks.length,errors,network}));await browser.close();
})().catch(e=>{console.error(e);process.exit(1);});
