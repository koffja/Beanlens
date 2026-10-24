const fs=require('fs'),path=require('path');
const {chromium}=require('/Users/chengzhe/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
(async()=>{
 const root=__dirname,browser=await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true}),page=await browser.newPage();
 await page.goto('file://'+path.join(root,'assembly-guide-p5.html'));await page.emulateMedia({media:'print'});await page.evaluate(()=>document.fonts.ready);
 const overflow=await page.locator('.sheet').evaluateAll(sheets=>sheets.map((s,i)=>({page:i+1,overflow:s.scrollHeight>s.clientHeight+1,mainBottom:s.querySelector('main').getBoundingClientRect().bottom,footerTop:s.querySelector('footer').getBoundingClientRect().top})).filter(s=>s.overflow||s.mainBottom>s.footerTop-4));
 if(overflow.length)throw Error(JSON.stringify(overflow));
 const pdf=path.join(root,'assembly-guide-p5.pdf');await page.pdf({path:pdf,preferCSSPageSize:true,printBackground:true});
 fs.writeFileSync(path.join(root,'pdf-layout-check.json'),JSON.stringify({pages:9,DOMOverflow:overflow,generated:true,physicallyVerified:false},null,2)+'\n');
 console.log(JSON.stringify({pdf,bytes:fs.statSync(pdf).size,overflow}));await browser.close();
})().catch(e=>{console.error(e);process.exit(1);});
