from pathlib import Path
import json,hashlib,shutil,zipfile,csv
ROOT=Path(__file__).resolve().parent;PROJECT=ROOT.parents[3]
report=json.loads((ROOT/'validation-p5.json').read_text());assert report['all_pass']
out=PROJECT/'output/pdf/beanlens-h3-p5-assembly-20261023.pdf';out.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(ROOT/'assembly-guide-p5.pdf',out)
PRINTS=ROOT/'prints';PRINTS.mkdir(exist_ok=True);manifest=[]
for id,sub,stem in [('P11','printing-p1','upper-hopper-mm'),('P13','printing-p1','lower-collector-mm'),('P22','printing-p2','camera-front-mm'),('P23','printing-p2','camera-rear-mm')]:
    for ext in ['stl','3mf','step']:
        src=ROOT.parent/sub/'parts'/(stem+'.'+ext)
        if not src.exists():continue
        target=PRINTS/(id+'-'+stem+'.'+ext);shutil.copy2(src,target)
        digest=hashlib.sha256(src.read_bytes()).hexdigest();assert hashlib.sha256(target.read_bytes()).hexdigest()==digest
        manifest.append(dict(id=id,file=target.name,original=str(src.relative_to(PROJECT)),sha256=digest,geometry_changed=False))
(PRINTS/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
(PRINTS/'README.md').write_text('''# P5仅安装四件原打印几何

P11上斗、P13下斗、P22原前座转向装右、P23原后座转向装左。文件与P1/P2逐字节一致，校验见manifest.json；没有为P5改变几何或重新切片。

这里是模型文件，不是可直接跨机型运行的G-code。按对应拓竹机型、标准0.4mm喷嘴、PETG HF、纹理PEI重新切片，或使用原P3匹配机型已切文件。P3第02盘含本版不用的P12；要省去它，先在Studio删模型后重新切片，不能编辑已切G-code。P3的04/05盘本版不用。

先按整机README核实际相机PCB、8mm隔柱和镜头；打印几何检查不代表实物配合、孔精度或承载验收。整机STEP不能整机打印。
''')
shutil.copy2(ROOT.parent/'assembly-p4/THREE-LICENSE.txt',ROOT/'THREE-LICENSE.txt')
delta=[['相机','前后相向','左右相向，总镜头距200mm已确认；BOX降110','P22/P23转90°复用；需实物排线试套'],['相机木条','176×30×6前后两条','200×30×6左右两条','改4只40宽偏置孔托片；原短条不能加长'],['顶部PP','176×196×3','200×180×3','180沿X/200沿Y，零边隙试套'],['灯架','铝槽/卡扣/PP板','灯带直接20角铝长120','四脚锁工作台，新增8孔'],['送料','MG996R单槽滑闸','人工单颗，直通落豆','删除整个执行器和闸盒；失败无法留豆'],['打印件','9件','只装P11/P13/P22/P23','其余保留不用，原模型不改'],['型材','13段含后梁','12段不含后梁','库存无需新增；3mm锯缝余636'],['电源','24V→5V＋6V UBEC/PWM缓冲','24V→5V BOX＋24V灯','不装UBEC/缓冲/限位；J10不接'],['角铝','约540mm含切缝','1020mm含切缝','全新原料2根1m，扣旧件'],['紧固件','M3 79 / M5 60','M3 52 / M5 52','相机M2与隔柱另列']]
with (ROOT/'revision-delta-p5.csv').open('w',encoding='utf-8-sig',newline='') as f:w=csv.writer(f);w.writerow(['part','P4','P5','action']);w.writerows(delta)
files=[p for p in ROOT.rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.suffix!='.zip' and p.name!='checksums-sha256.json']
digests={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(files)}
(ROOT/'checksums-sha256.json').write_text(json.dumps(digests,ensure_ascii=False,indent=2)+'\n');files.append(ROOT/'checksums-sha256.json')
target=ROOT/'BeanLens-H3-P5-manual-assembly-20261023.zip'
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
    for p in files:z.write(p,'BeanLens-H3-P5/'+str(p.relative_to(ROOT)))
    z.write(PROJECT/'config/hardware-hackathon-h3-p5.json','BeanLens-H3-P5/config/hardware-hackathon-h3-p5.json')
with zipfile.ZipFile(target) as z:
    assert z.testzip() is None
    for path,digest in digests.items():assert hashlib.sha256(z.read('BeanLens-H3-P5/'+path)).hexdigest()==digest
print(json.dumps(dict(zip=str(target),bytes=target.stat().st_size,files=len(files)+1,pdf=str(out),integrity_pass=True),ensure_ascii=False))
