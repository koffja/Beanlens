const fs=require('fs'),path=require('path');
const {chromium}=require('/Users/chengzhe/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
(async()=>{
 const root=__dirname,repo=path.resolve(root,'../../..');
 const b=await chromium.launch({headless:true,executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'});
 const p=await b.newPage({viewport:{width:1500,height:1060},deviceScaleFactor:1});
 const errors=[];p.on('pageerror',e=>errors.push(String(e)));
 const pageurl='file://'+path.join(root,'beanlens-hopper-gate-v4.10.html');
 await p.goto(pageurl);await p.evaluate(()=>document.fonts.ready);
 await p.locator('#gate').fill('100');await p.locator('#gate').dispatchEvent('input');
 const gateTransform=await p.locator('#moving-gate').getAttribute('transform');
 const gateLabel=await p.locator('#gateout').textContent();
 await p.click('#play');await p.waitForTimeout(260);await p.click('#play');
 const played=Number(await p.locator('#gate').inputValue())<100;
 await p.locator('#zoom').fill('150');await p.locator('#zoom').dispatchEvent('input');
 const zoom=await p.locator('#zout').textContent();await p.click('#reset');
 const sheets=await p.locator('.sheet svg').count();
 const bounds=await p.locator('.sheet svg').evaluateAll(nodes=>nodes.map((s,i)=>({page:i+1,outside:[...s.querySelectorAll('text')].map(t=>{const b=t.getBBox();return {text:t.textContent,x:b.x,y:b.y,right:b.x+b.width,bottom:b.y+b.height}}).filter(b=>b.x<0||b.y<0||b.right>1500||b.bottom>1060)})));
 await p.pdf({path:path.join(repo,'output/pdf/beanlens-hopper-gate-v4.10-20261016.pdf'),preferCSSPageSize:true,printBackground:true});
 for(const file of fs.readdirSync(root).filter(x=>/^0\d-.*\.svg$/.test(x))){
  await p.goto('file://'+path.join(root,file));await p.evaluate(()=>document.fonts.ready);
  await p.screenshot({path:path.join(root,file.replace('.svg','.png'))});
 }
 await p.goto('file://'+path.join(repo,'docs/hardware/procurement-v4.10/beanlens-procurement-v4.10.html'));
 const bomcount=await p.locator('tbody tr').count();await p.locator('#search').fill('TPS5450DDA方案');
 const filtered=await p.locator('tbody tr:visible').count();await p.click('#reset');
 const resetcount=await p.locator('tbody tr:visible').count();
 const result={date:'2026-10-16',sheets,gateTransform,gateLabel,played,zoom,bounds,bomcount,filtered,resetcount,errors,scope:'Offline browser rendering / interaction / PDF export only, not electrical or physical validation'};
 fs.writeFileSync(path.join(root,'browser-check-20261016.json'),JSON.stringify(result,null,2)+'\n');
 await b.close();console.log(JSON.stringify(result));
 if(errors.length||sheets!==5||gateTransform!=='translate(105 0)'||!gateLabel.includes('127.5')||!played||zoom!=='150%'||bounds.some(b=>b.outside.length)||filtered!==1||bomcount!==resetcount)process.exitCode=1;
})().catch(e=>{console.error(e);process.exitCode=1});
