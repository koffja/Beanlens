from pathlib import Path
import hashlib,json,shutil,zipfile
ROOT=Path(__file__).resolve().parent;PROJECT=ROOT.parents[3]
OUT=ROOT/'BeanLens-H3-P4-assembly-kit-20261022.zip'
report=json.loads((ROOT/'validation-p4.json').read_text())
assert all(c['pass'] for c in report['checks'])
checks=[]
for file in ['beanlens-assembly-p4.html','assembly-guide-p4.pdf','bom-p4.html','bom-p4.csv','procurement-p4.csv','fasteners-p4.csv','cut-list-p4.csv','README.md']:
    assert (ROOT/file).is_file(),file;checks.append(file)
# Keep a PDF in the repository's common output location, with identical bytes.
pdfout=PROJECT/'output/pdf/beanlens-h3-p4-assembly-20261022.pdf';shutil.copy2(ROOT/'assembly-guide-p4.pdf',pdfout)
assert pdfout.read_bytes()==(ROOT/'assembly-guide-p4.pdf').read_bytes()
files=sorted(p for p in ROOT.rglob('*') if p.is_file() and '__pycache__' not in p.parts and p!=OUT and p.name!='checksums-sha256.json')
hashes={p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
(ROOT/'checksums-sha256.json').write_text(json.dumps(hashes,indent=2)+'\n')
with zipfile.ZipFile(OUT,'w',zipfile.ZIP_DEFLATED) as z:
    for p in [*files,ROOT/'checksums-sha256.json']:z.write(p,'BeanLens-H3-P4/'+p.relative_to(ROOT).as_posix())
with zipfile.ZipFile(OUT) as z:
    assert z.testzip() is None
    for rel,sha in hashes.items():assert hashlib.sha256(z.read('BeanLens-H3-P4/'+rel)).hexdigest()==sha
print(json.dumps({'zip':str(OUT),'bytes':OUT.stat().st_size,'files':len(files)+1,'pdf':str(pdfout),'all_integrity_pass':True}))
