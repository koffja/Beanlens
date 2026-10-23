const fs=require('fs'),path=require('path');
const {chromium}=require('/Users/chengzhe/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
(async()=>{
 const root=__dirname,checks=[],errors=[],network=[];
 const browser=await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true});
 const page=await browser.newPage({viewport:{width:1440,height:1100}});
 page.on('pageerror',e=>errors.push(e.message));page.on('request',r=>{if(/^https?:/.test(r.url()))network.push(r.url());});
 function check(name,pass){checks.push({name,pass});if(!pass)throw Error(name);}
 await page.goto('file://'+path.join(root,'index.html'));await page.waitForFunction(()=>window.printJobsStatus);
 check('six_job_cards',await page.locator('article').count()===6);
 check('six_loaded_thumbnails',await page.locator('article img').evaluateAll(imgs=>imgs.every(i=>i.complete&&i.naturalWidth>0)));
 for(const machine of ['P2S','A1','X1C','X2D','H2D']){
  await page.locator('button[data-machine="'+machine+'"]').click();
  const s=await page.evaluate(()=>window.printJobsStatus());
  check(machine+'_correct_six_links',s.machine===machine&&s.links.length===6&&s.links.every(l=>l.startsWith('jobs/'+machine+'/')&&fs.existsSync(path.join(root,l))));
 }
 await page.locator('button[data-machine="P2S"]').click();await page.screenshot({path:path.join(root,'dashboard-desktop.png'),fullPage:true});
 await page.setViewportSize({width:390,height:844});await page.screenshot({path:path.join(root,'dashboard-mobile.png'),fullPage:true});
 check('mobile_no_overflow',await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));
 check('no_script_errors',errors.length===0);check('offline_no_requests',network.length===0);
 fs.writeFileSync(path.join(root,'browser-check.json'),JSON.stringify({checks,errors,network},null,2)+'\n');
 console.log(JSON.stringify({checks:checks.length,errors,network}));await browser.close();
})().catch(e=>{console.error(e);process.exit(1);});
