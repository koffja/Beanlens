from pathlib import Path
import json
ROOT=Path(__file__).resolve().parent
doc=(ROOT/'source/index.html').read_text().replace('__DATA__',(ROOT/'assembly-data.json').read_text()).replace('__BOM__',(ROOT/'bom-p4.json').read_text())
for f in ['vendor/three-0.160.1.min.js','source/model-base-h1.js','source/model.js','source/assembly.js']:
    doc=doc.replace('<script src="'+f+'"></script>','<script>'+ (ROOT/f).read_text().replace('</script','<\\/script')+'</script>')
(ROOT/'beanlens-assembly-p4.html').write_text(doc)
print('Assembly page bytes',len(doc.encode()))
