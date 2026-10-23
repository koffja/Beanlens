"""Check the portable P2 deliverable and package it without modifying H3/P1."""
from pathlib import Path
import ast, hashlib, json, re, zipfile
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parent
PROJECT=ROOT.parents[3]
ZIP=ROOT/'BeanLens-H3-P2-mount-kit-20261022.zip'
checks=[]
def check(name, condition):
    checks.append({'name':name,'pass':bool(condition)})
    assert condition,name

manifest=json.loads((ROOT/'manifest.json').read_text())
check('six_parts_eighteen_exports',len(manifest['parts'])==6 and sum(len(p['files']) for p in manifest['parts'])==18)
for part in manifest['parts']:
    for ext,name in part['files'].items():check('exists_'+name,(ROOT/name).is_file())
    with zipfile.ZipFile(ROOT/part['files']['3mf']) as z:
        model_names=[n for n in z.namelist() if n.endswith('.model')]
        check(part['name']+'_3mf_millimeters',bool(model_names) and all(ET.fromstring(z.read(n)).get('unit')=='millimeter' for n in model_names))
    check(part['name']+'_220_bed_with_brim',all(s+10<=220 for s in part['print_bounds_mm'][:2]))
validation=json.loads((ROOT/'validation.json').read_text())
check('all_300_CAD_checks',len(validation['checks'])==300 and all(c['pass'] for c in validation['checks']))
browser=json.loads((ROOT/'browser-check.json').read_text())
check('all_browser_checks',len(browser['checks'])==30 and all(c['pass'] for c in browser['checks']) and not browser['errors'] and not browser['network'])
for p in ROOT.glob('*.py'):ast.parse(p.read_text())
check('Python_sources_parse',True)
for p in (ROOT/'templates').glob('*.svg'):
    svg=ET.parse(p).getroot()
    check(p.name+'_physical_mm',svg.get('width').endswith('mm') and svg.get('height').endswith('mm'))
for name in re.findall(r'\]\(([^)]+)\)',(ROOT/'README.md').read_text()):
    if not name.startswith(('http:','https:','#')):check('README_link_'+name,(ROOT/name).exists())
preserved=json.loads((ROOT/'previous-preserved.json').read_text())
for name,sha in preserved.items():check('preserved_'+name,hashlib.sha256((PROJECT/name).read_bytes()).hexdigest()==sha)
report={'revision':'H3-P2','date':'2026-10-22','checks':checks,'previous_files_checked':len(preserved),'printed':False,'physically_fitted':False}
(ROOT/'package-check.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
def deliverables():
    return sorted(p for p in ROOT.rglob('*') if p.is_file() and p!=ZIP and p.name!='checksums-sha256.json' and '__pycache__' not in p.parts and not p.name.endswith('.pyc'))
files=deliverables()
hashes={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
(ROOT/'checksums-sha256.json').write_text(json.dumps(hashes,ensure_ascii=False,indent=2)+'\n')
with zipfile.ZipFile(ZIP,'w',zipfile.ZIP_DEFLATED) as z:
    for p in [*files,ROOT/'checksums-sha256.json']:z.write(p,'BeanLens-H3-P2/'+p.relative_to(ROOT).as_posix())
with zipfile.ZipFile(ZIP) as z:
    assert z.testzip() is None
    for name,sha in hashes.items():assert hashlib.sha256(z.read('BeanLens-H3-P2/'+name)).hexdigest()==sha,name
print(json.dumps({'package':str(ZIP),'bytes':ZIP.stat().st_size,'checks':len(checks),'previous_files_preserved':len(preserved),'exports':18,'zip_integrity':True},ensure_ascii=False))
