from pathlib import Path
import json,hashlib,shutil,zipfile,csv
ROOT=Path(__file__).resolve().parent;PROJECT=ROOT.parents[3]
report=json.loads((ROOT/'validation-p6.json').read_text());assert report['all_pass']
out=PROJECT/'output/pdf/beanlens-h3-p6-assembly-20261024.pdf';out.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(ROOT/'assembly-guide-p6.pdf',out)
PRINTS=ROOT/'prints';PRINTS.mkdir(exist_ok=True);manifest=[]
for id,sub,stem in [('P11','printing-p1','upper-hopper-mm'),('P13','printing-p1','lower-collector-mm'),('P22','printing-p2','camera-front-mm'),('P23','printing-p2','camera-rear-mm')]:
    for ext in ['stl','3mf','step']:
        src=ROOT.parent/sub/'parts'/(stem+'.'+ext)
        if not src.exists():continue
        target=PRINTS/(id+'-'+stem+'.'+ext);shutil.copy2(src,target)
        digest=hashlib.sha256(src.read_bytes()).hexdigest();assert hashlib.sha256(target.read_bytes()).hexdigest()==digest
        manifest.append(dict(id=id,file=target.name,original=str(src.relative_to(PROJECT)),sha256=digest,geometry_changed=False))
(PRINTS/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
(PRINTS/'README.md').write_text('''# P6仅安装四件原打印几何

P11上斗、P13下斗、P22原前座转向装右、P23原后座转向装左。文件与P1/P2逐字节一致，校验见manifest.json；没有为P6改变几何或重新切片。P11整件比P5安装位置抬高20mm，法兰承接在W06木顶板下方；按P6整机图装配。

这里是模型文件，不是可直接跨机型运行的G-code。按对应拓竹机型、标准0.4mm喷嘴、PETG HF、纹理PEI重新切片，或使用原P3匹配机型已切文件。P3第02盘含本版不用的P12；要省去它，先在Studio删模型后重新切片，不能编辑已切G-code。P3的04/05盘本版不用。

先按整机README核实际相机PCB、8mm隔柱和镜头；打印几何检查不代表实物配合、孔精度或承载验收。整机STEP不能整机打印。
''')
shutil.copy2(ROOT.parent/'assembly-p4/THREE-LICENSE.txt',ROOT/'THREE-LICENSE.txt')
delta=[
 ['遮光罩','无实体，保留了无效开关','新增6片黑色PP2实体及12只角铝支架','黑色/透明/隐藏三态同步；新增J15固定特写'],
 ['顶部连接板','C01 PP200×180×3','W06海洋板240×220×6，置于型材上方','不切四角；新增4个M5框架孔'],
 ['底板W01','176×196×6','240×220×6，四角22.5×22.5切除','Z22不变；新增4片PP2垫片；M5×14候选'],
 ['工作台W02','176×196×6','240×220×6，四角22.5×22.5切除','中央60方孔及下斗/灯架位置不变'],
 ['上斗P11','原安装高度','整件抬高20，法兰上表面Z460','原打印模型与切片保留，顶板压在法兰上方'],
 ['框架连接片','顶/底8片平连接片','取消8片平连接片','顶板与底板改由M5直接接型材槽'],
 ['BOX供电','Type-C1输入5V','J7-1 GND / J7-2 VCC_5V输入','22AWG短线；拟用2A保险；与Type-C1供电互斥，绕过USB输入限流'],
 ['灯架','四根120长20角铝，灯带直贴','保留；右侧回翼朝外，补遮光罩孔','新增孔不能穿灯带电路；按新纸样核旧孔'],
 ['角铝原料','1020mm含切缝','1296mm含切缝','全新原料2根1m足够；扣除已完成的旧件'],
 ['PP2原料','无本版遮光罩','400×300一片','6片罩板＋4片底板垫片排料；按纸样先试装'],
 ['紧固件','M3 52 / M5 52','M3 76 / M5 52','M3垫片φ9共136、φ7共16；相机M2另列'],
 ['相机/打印/送料','左右相距200；4件打印；人工单颗','相同','原模型不改，不装执行器；200×30木条保持'],
 ['型材库存','12段，库存满足','相同','460×4、200×4、180×4；按3mm锯缝余636']
]
with (ROOT/'revision-delta-p6.csv').open('w',encoding='utf-8-sig',newline='') as f:w=csv.writer(f);w.writerow(['part','P5','P6','action']);w.writerows(delta)
files=[p for p in ROOT.rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.suffix!='.zip' and p.name!='checksums-sha256.json']
digests={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(files)}
(ROOT/'checksums-sha256.json').write_text(json.dumps(digests,ensure_ascii=False,indent=2)+'\n');files.append(ROOT/'checksums-sha256.json')
target=ROOT/'BeanLens-H3-P6-manual-assembly-20261024.zip'
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
    for p in files:z.write(p,'BeanLens-H3-P6/'+str(p.relative_to(ROOT)))
    z.write(PROJECT/'config/hardware-hackathon-h3-p6.json','BeanLens-H3-P6/config/hardware-hackathon-h3-p6.json')
with zipfile.ZipFile(target) as z:
    assert z.testzip() is None
    for path,digest in digests.items():assert hashlib.sha256(z.read('BeanLens-H3-P6/'+path)).hexdigest()==digest
print(json.dumps(dict(zip=str(target),bytes=target.stat().st_size,files=len(files)+1,pdf=str(out),integrity_pass=True),ensure_ascii=False))
