/* Export the ten vector sheets and check the shared frame projection.
 * Uses the bundled browser runtime; never touches the training environment.
 */
const fs = require('node:fs');
const path = require('node:path');
const os = require('node:os');
const assert = require('node:assert/strict');
const { createRequire } = require('node:module');
const runtime = path.join(os.homedir(), '.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules');
const { chromium } = createRequire(path.join(runtime, '_beanlens.cjs'))('playwright');
const root = path.resolve(__dirname, '../../..');
const origin = process.env.BEANLENS_DOC_ORIGIN || 'http://127.0.0.1:8767';
const url = p => origin + '/' + p;

(async () => {
  const browser = await chromium.launch({ headless: true, executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' });
  try {
    const page = await browser.newPage({ viewport: { width: 1400, height: 960 }, deviceScaleFactor: 1 });
    const consoleErrors = [];
    page.on('pageerror', error => consoleErrors.push(error.message));
    const result = { revision: 'V4.8-thickness-displays', date: '2026-10-16', consoleErrors, sheets: [] };
    const layout = JSON.parse(fs.readFileSync(path.join(__dirname, 'assembly-layout-v4.8.json')));
    for (const file of layout.drawing_files) {
      await page.goto(url('docs/hardware/assembly-v4.8/' + file));
      const bounds = await page.evaluate(() => {
        const texts = [...document.querySelectorAll('text')];
        const outside = texts.filter(t => { const b = t.getBBox(); return b.x < 0 || b.y < 0 || b.x+b.width > 1400 || b.y+b.height > 960; }).map(t => t.textContent);
        const overlaps = [];
        for (let i=0;i<texts.length;i++) for (let j=i+1;j<texts.length;j++) {
          const a=texts[i].getBBox(), b=texts[j].getBBox();
          if (Math.min(a.x+a.width,b.x+b.width)-Math.max(a.x,b.x)>2 && Math.min(a.y+a.height,b.y+b.height)-Math.max(a.y,b.y)>2) overlaps.push([texts[i].textContent,texts[j].textContent]);
        }
        return { outside, overlaps };
      });
      result.sheets.push({ file, ...bounds });
      await page.locator('svg').screenshot({ path: path.join(__dirname, file.replace('.svg','.png')) });
    }
    await page.goto(url('docs/hardware/assembly-v4.8/frame-comparison-v4.8.svg'));
    result.comparison = await page.evaluate(() => {
      let compared = 0, maxDeltaError = 0;
      for (let n=1;n<=18;n++) {
        const id='T'+String(n).padStart(2,'0');
        const aa=[...document.querySelectorAll(`#assembled-product [data-part="${id}"] polygon`)];
        const bb=[...document.querySelectorAll(`#bare-frame [data-part="${id}"] polygon`)];
        if (aa.length!==3 || bb.length!==3) throw Error('Missing frame faces '+id);
        for (let f=0;f<3;f++) {
          const parse=p=>p.getAttribute('points').trim().split(/\s+/).map(s=>s.split(',').map(Number));
          const a=parse(aa[f]),b=parse(bb[f]);
          a.forEach((p,i)=>{maxDeltaError=Math.max(maxDeltaError,Math.abs((b[i][0]-p[0])-750),Math.abs(b[i][1]-p[1]));});
        }
        compared++;
      }
      return { comparedFrameMembers: compared, horizontalTranslationPx: 750, maxDeltaErrorPx: maxDeltaError, sameScaleAndView: maxDeltaError < .02 };
    });
    assert(result.comparison.sameScaleAndView);
    await page.locator('svg').screenshot({ path: path.join(root,'docs/hardware/assembly-v4.8/frame-comparison-v4.8.png') });
    await page.goto(url('docs/hardware/assembly-v4.8/beanlens-assembly-v4.8.html'));
    result.interaction = await page.evaluate(() => {
      const $=id=>document.getElementById(id),points=()=>document.querySelector('#model [data-id="T01"] polygon').getAttribute('points');
      $('assembled').click();const assembled=points();
      $('wood').click();const afterHide=points(),withoutPanels=document.querySelectorAll('#model [data-id]').length;
      $('group').value='骨架';$('group').dispatchEvent(new Event('change'));const frameOnly=points(),frameCount=document.querySelectorAll('#model [data-id]').length;
      window.beanlensAssembly.select('T01');const bomDetail=$('partBom').textContent,partDetail=$('partSize').textContent;
      $('exploded').click();const explosionMoves=points()!==assembled;
      $('assembled').click();const reset=points()===assembled;
      $('group').value='';$('group').dispatchEvent(new Event('change'));$('wood').click();
      return { initialAssembly:true, hidePanelsKeepsScale:assembled===afterHide, groupKeepsScale:assembled===frameOnly, frameCount, withoutPanels, bomDetail, partDetail, explosionMoves, reset };
    });
    assert(result.interaction.hidePanelsKeepsScale && result.interaction.groupKeepsScale && result.interaction.frameCount===18 && result.interaction.explosionMoves && result.interaction.reset);
    result.dualScreens=await page.evaluate(()=>{
 const a=window.beanlensAssembly.data.parts;const ids=['A01','D01','D02','D03','E01','D04','D05','D06'];
 document.getElementById('screens').click();const count=document.querySelectorAll('#model [data-id]').length;
 window.beanlensAssembly.select('E01');const detail=document.getElementById('partNote').textContent;
 document.getElementById('group').value='';document.getElementById('group').dispatchEvent(new Event('change'));
 document.getElementById('clearance').click();const keepouts=['D90','D91'].every(id=>document.querySelector('#model [data-id="'+id+'"]'));
 document.getElementById('clearance').click();document.getElementById('assembled').click();
 return {idsPresent:ids.every(id=>a.some(p=>p.id===id)),partsInScreenGroup:count,c6NonTouchDescription:detail,keepoutsCanBeShown:keepouts};
 });assert(result.dualScreens.idsPresent && result.dualScreens.partsInScreenGroup===12 && result.dualScreens.keepoutsCanBeShown);
 await page.emulateMedia({ media:'print' });
    await page.pdf({ path:path.join(root,'output/pdf/beanlens-assembly-v4.8-20261016.pdf'), format:'A3', landscape:true, printBackground:true, preferCSSPageSize:true });
    await page.emulateMedia({ media:'screen' });
    await page.setViewportSize({ width:390,height:844 });
    result.mobile=await page.evaluate(()=>({ viewport:innerWidth,bodyWidth:document.documentElement.scrollWidth,noPageOverflow:document.documentElement.scrollWidth<=innerWidth,drawingsScroll:document.querySelector('.sheet').scrollWidth>document.querySelector('.sheet').clientWidth }));
    assert(result.mobile.noPageOverflow);
    await page.goto(url('docs/hardware/frame-v4.6/beanlens-frame-v4.6.html'));
    result.framePage=await page.evaluate(async()=>{
      const views=['comparisonView','renderView','dimensionView'];const toggles=[];
      for(const id of views){document.querySelector(`[data-view="${id}"]`).click();toggles.push(!document.getElementById(id).hidden&&views.filter(v=>v!==id).every(v=>document.getElementById(v).hidden));}
      const links=[...document.querySelectorAll('a[href],img[src]')].map(n=>n.href||n.src).filter(u=>u.startsWith(location.origin));
      const checks=await Promise.all(links.map(async u=>({u,status:(await fetch(u)).status})));
      return {toggles,missingLocalLinks:checks.filter(v=>v.status!==200)};
    });
    assert(result.framePage.toggles.every(Boolean) && result.framePage.missingLocalLinks.length===0);
    assert(consoleErrors.length===0);
    result.fabricationTemplates=[];
    await page.setViewportSize({width:1400,height:1200});
    for(let i=1;i<=8;i++) {
      await page.goto(url(`docs/hardware/fabrication-v4.8/template-${String(i).padStart(2,'0')}.svg`));
      const measured=await page.evaluate(()=>{
        const svg=document.querySelector('svg'),vb=svg.viewBox.baseVal,ts=[...svg.querySelectorAll('text')];
        return {viewBox:[vb.width,vb.height],physicalWidthPx:svg.getBoundingClientRect().width,
          textOutside:ts.filter(t=>{const b=t.getBBox();return b.x<0||b.y<0||b.x+b.width>210||b.y+b.height>297}).map(t=>t.textContent)};
      });
      result.fabricationTemplates.push({page:i,...measured});
      await page.locator('svg').screenshot({path:path.join(root,`docs/hardware/fabrication-v4.8/template-${String(i).padStart(2,'0')}.png`)});
    }
    await page.goto(url('docs/hardware/fabrication-v4.8/beanlens-fabrication-v4.8.html'));
    await page.emulateMedia({media:'print'});
    await page.pdf({path:path.join(root,'output/pdf/beanlens-pp-templates-v4.8-20261016.pdf'),format:'A4',printBackground:true,preferCSSPageSize:true});
    await page.emulateMedia({media:'screen'});
    result.fabricationLinks=await page.evaluate(async()=>{
      const us=[...document.querySelectorAll('a[href],img[src]')].map(n=>n.href||n.src).filter(u=>u.startsWith(location.origin));
      const rs=await Promise.all(us.map(async u=>({u,status:(await fetch(u)).status})));
      return rs.filter(r=>r.status!==200);
    });
    assert(result.fabricationLinks.length===0);
    assert(result.fabricationTemplates.every(t=>t.textOutside.length===0));
    fs.writeFileSync(path.join(__dirname,'browser-check-20261016.json'),JSON.stringify(result,null,2)+'\n');
    console.log(JSON.stringify({sheets:result.sheets,templates:result.fabricationTemplates,interaction:result.interaction,consoleErrors,links:result.fabricationLinks},null,2));
  } finally { await browser.close(); }
})().catch(error=>{console.error(error.stack);process.exitCode=1;});
