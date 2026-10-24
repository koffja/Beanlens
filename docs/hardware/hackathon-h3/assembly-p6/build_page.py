from pathlib import Path
ROOT=Path(__file__).resolve().parent
P4=ROOT.parent/'assembly-p4'
doc=(ROOT/'source/index.html').read_text().replace('__DATA__',(ROOT/'assembly-data.json').read_text()).replace('__BOM__',(ROOT/'bom-p6.json').read_text())
for f in ['vendor/three-0.160.1.min.js','source/model-base-h1.js','source/model.js','source/assembly.js']:
    source=ROOT/f if f=='source/assembly.js' else P4/f
    doc=doc.replace('<script src="'+f+'"></script>','<script>'+source.read_text().replace('</script','<\\/script')+'</script>')
(ROOT/'beanlens-assembly-p6.html').write_text(doc)
print('Standalone HTML',len(doc.encode()))
