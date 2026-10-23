"""Package the reviewed Bambu jobs without the isolated slicer runtime caches."""
from pathlib import Path
import ast,hashlib,json,re,zipfile
ROOT=Path(__file__).resolve().parent
OUT=ROOT/'BeanLens-H3-Bambu-P3-20261022.zip'
checks=[]
def check(name,value):
    checks.append({'name':name,'pass':bool(value)})
    assert value,name
report=json.loads((ROOT/'validation.json').read_text());browser=json.loads((ROOT/'browser-check.json').read_text())
check('all_host_slice_checks',len(report['checks'])==446 and all(c['pass'] for c in report['checks']))
check('all_browser_checks',len(browser['checks'])==10 and all(c['pass'] for c in browser['checks']))
for file in ROOT.glob('*.py'):ast.parse(file.read_text())
check('all_python_sources_parse',True)
for rel in re.findall(r'href="([^"]+)"',(ROOT/'index.html').read_text()):
    if rel.startswith(('https:','http:','data:','#')) or rel==OUT.name:continue
    check('dashboard_link_'+rel,(ROOT/rel).exists())
for folder,name in [('printing-p1','BeanLens-H3-P1-print-kit-20261022.zip'),('printing-p2','BeanLens-H3-P2-mount-kit-20261022.zip')]:
    check('original_kit_'+folder,(ROOT/'original-cad-kits'/name).read_bytes()==(ROOT.parent/folder/name).read_bytes())
smoke=(ROOT/'logs/reopen-smoke/slicer.log').read_text()
check('Bambu_reopens_completed_3mf','manifold = yes' in smoke and 'size_x = 90.000000' in smoke)
(ROOT/'package-check.json').write_text(json.dumps({'checks':checks,'printed':False},ensure_ascii=False,indent=2)+'\n')
def selected(p):
    rel=p.relative_to(ROOT)
    if not p.is_file() or p==OUT or p.name=='checksums-sha256.json' or '__pycache__' in p.parts:return False
    if 'logs' in rel.parts:return p.name in ['run.json','result.json','slicer.log','cli-help-result.json'] and 'runtime' not in rel.parts
    return True
files=sorted(p for p in ROOT.rglob('*') if selected(p))
hashes={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
(ROOT/'checksums-sha256.json').write_text(json.dumps(hashes,ensure_ascii=False,indent=2)+'\n')
with zipfile.ZipFile(OUT,'w',zipfile.ZIP_DEFLATED) as archive:
    for p in [*files,ROOT/'checksums-sha256.json']:archive.write(p,'BeanLens-H3-Bambu-P3/'+p.relative_to(ROOT).as_posix())
with zipfile.ZipFile(OUT) as archive:
    assert archive.testzip() is None
    for rel,sha in hashes.items():assert hashlib.sha256(archive.read('BeanLens-H3-Bambu-P3/'+rel)).hexdigest()==sha
print(json.dumps({'zip':str(OUT),'bytes':OUT.stat().st_size,'files':len(files)+1,'machine_jobs':len(report['jobs']),'integrity':True},ensure_ascii=False))
