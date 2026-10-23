"""Build standalone offline H3 HTML from local code and structured dimensions."""
import hashlib,json
from pathlib import Path
ROOT=Path(__file__).resolve().parent
data=(ROOT.parent/"design-h3.json").read_text()
(ROOT/"design-data.js").write_text('window.BEANLENS_H3_DATA='+data+';\n')
source=(ROOT/"index.html").read_text().replace('<body>','<body data-bundle="yes">')
source=source.replace('<link rel="stylesheet" href="style.css">','<style>'+(ROOT/"style.css").read_text()+'</style>')
files=['vendor/three-0.160.1.min.js','design-data.js','model-base-h1.js','model.js','app.js']
for f in files:
    code=(ROOT/f).read_text().replace('</script','<\\/script')
    source=source.replace(f'<script src="{f}"></script>','<script>\n'+code+'\n</script>')
source=source.replace('href="../','href="').replace('href="README.md">外形依据','href="README.md">外形依据')
target=ROOT.parent/'beanlens-realistic-h3.html';target.write_text(source)
(ROOT/'build-record.json').write_text(json.dumps({'date':'2026-10-21','revision':'H3','artifact':target.name,'artifact_sha256':hashlib.sha256(target.read_bytes()).hexdigest(),'sources_sha256':{f:hashlib.sha256((ROOT/f).read_bytes()).hexdigest() for f in files},'network_required':False},ensure_ascii=False,indent=2)+'\n')
print(target.name,target.stat().st_size,'bytes')
