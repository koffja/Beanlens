from pathlib import Path
import json,hashlib,shutil,zipfile,csv
ROOT=Path(__file__).resolve().parent;PROJECT=ROOT.parents[3]
report=json.loads((ROOT/'validation-p7.json').read_text());assert report['all_pass']
out=PROJECT/'output/pdf/beanlens-h3-p7-assembly-20261024.pdf';out.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(ROOT/'assembly-guide-p7.pdf',out)
PRINTS=ROOT/'prints';PRINTS.mkdir(exist_ok=True);manifest=[]
for id,sub,stem in [('P11','printing-p1','upper-hopper-mm'),('P13','printing-p1','lower-collector-mm')]:
    for ext in ['stl','3mf','step']:
        src=ROOT.parent/sub/'parts'/(stem+'.'+ext)
        if not src.exists():continue
        target=PRINTS/(id+'-'+stem+'.'+ext);shutil.copy2(src,target)
        digest=hashlib.sha256(src.read_bytes()).hexdigest();assert hashlib.sha256(target.read_bytes()).hexdigest()==digest
        manifest.append(dict(id=id,file=target.name,original=str(src.relative_to(PROJECT)),sha256=digest,geometry_changed=False))
(PRINTS/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
(PRINTS/'README.md').write_text('''# P7仅安装两个原漏斗打印体

P11上斗、P13下斗与P1逐字节一致，见manifest.json；本轮没有修改几何或重新切片。上斗位置沿用P6，法兰位于W06木顶板下方；按P7整机图装配。

P22/P23相机底座本版不装，模型仍保留在旧P2/P3/P6目录。P3只需匹配机器的00试片、01上斗、03下斗；02相机座/接座、04/05执行器盘不用。不能修改已切G-code，也不能跨机型直接运行。原厂标准0.4mm喷嘴、PETG HF、纹理PEI配置须与实际机器匹配。

相机改为竖直PCB直接粘木条内边，不再装M2隔柱；先临时定位通双图、核约55mm近焦与排线，再在背面下沿空白边点绝缘胶。模型／主机检查不代表实打、粘接或承载验收。整机STEP不能整机打印。
''')
(ROOT/'PACKAGE-README.md').write_text('''# P7离线包入口

解压后打开beanlens-assembly-p7.html查看组装、爆炸和人工投豆演示；打开assembly-guide-p7.pdf打印图册，bom-p7.html查看采购表。camera-glue-p7.svg是相机直粘侧视图。独立基线位于本包config/hardware-hackathon-h3-p7.json；整机README中以../../../../开头的链接是完整项目路径，在独立ZIP中请改看本包config目录。

本包仅含两件原漏斗打印模型，不含已切G-code；旧P6及其他版本在项目原目录保留。先按README做临时定位、排线、近焦和绝缘胶试装。页面与主机检查不等于实物验收。脚本重建仍需要完整项目及独立CAD环境。
''')
shutil.copy2(ROOT.parent/'assembly-p4/THREE-LICENSE.txt',ROOT/'THREE-LICENSE.txt')
delta=[
 ['相机底座','P22/P23打印座＋8mm隔柱/M2螺钉','取消，PCB下沿直接粘木条内边','不再打印或采购相机座/M2；原件保留'],
 ['相机木条','200×30×6，向外伸','200×40×6，外侧齐框','200沿Y；左X0…40、右180…220；新板加工'],
 ['镜头间距','约200mm','参考110.4mm，用户接受约110','每侧到豆路约55mm；先核近焦再点胶'],
 ['相机托片','外伸40宽偏孔片','40宽角铝移入框内，重排孔','水平翼中孔、柱翼偏孔；实配旧件能否复用'],
 ['相机胶脚','无','每相机下沿空白边2处绝缘可剥离胶','先试温度/粘性；焊盘、四角孔、接口和镜筒留空'],
 ['遮光盖','SH-T与4顶承角片','取消，保留5片罩','少8套M3×10；侧片不钻旧Z322孔，旧孔可闲置'],
 ['BOX背板','底224顶312，低位','底352顶440，顶边贴顶框下缘','整组上移128；上对角片另下让30，避框角码'],
 ['BOX柱孔','Z240/296','Z368/394','背板补新孔；隔柱孔Z364/416'],
 ['CSI路径','低位BOX旁横向路由','折线参考每路165.33mm','不含真实接口和弯曲；20cm排线须实物试走线'],
 ['角铝','1296含切缝','1204含切缝','两根1m足够，合计余796；扣旧件'],
 ['紧固件','M3共76，M5共52','M3共64，M5共52','M3大垫112、φ7垫16；相机M2/隔柱取消'],
 ['打印与板材','4打印、6木板','2漏斗打印、6木板','三大木板与上下斗位置沿用P6，模型不改'],
 ['供电与送料','J7外供，人工逐颗','相同','5V支线短；降压靠近高位BOX，J7/USB1供电互斥']
]
with (ROOT/'revision-delta-p7.csv').open('w',encoding='utf-8-sig',newline='') as f:w=csv.writer(f);w.writerow(['part','P6','P7','action']);w.writerows(delta)
files=[p for p in ROOT.rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.suffix!='.zip' and p.name!='checksums-sha256.json']
digests={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(files)}
(ROOT/'checksums-sha256.json').write_text(json.dumps(digests,ensure_ascii=False,indent=2)+'\n');files.append(ROOT/'checksums-sha256.json')
target=ROOT/'BeanLens-H3-P7-manual-assembly-20261024.zip'
with zipfile.ZipFile(target,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
    for p in files:z.write(p,'BeanLens-H3-P7/'+str(p.relative_to(ROOT)))
    z.write(PROJECT/'config/hardware-hackathon-h3-p7.json','BeanLens-H3-P7/config/hardware-hackathon-h3-p7.json')
with zipfile.ZipFile(target) as z:
    assert z.testzip() is None
    for path,digest in digests.items():assert hashlib.sha256(z.read('BeanLens-H3-P7/'+path)).hexdigest()==digest
print(json.dumps(dict(zip=str(target),bytes=target.stat().st_size,files=len(files)+1,pdf=str(out),integrity_pass=True),ensure_ascii=False))
