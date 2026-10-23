"""H2 is a separate static dual-camera proposal; preserve H1 and full version."""
import copy
import csv
import hashlib
import html
import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parent
PROJECT = ROOT.parents[2]
H1 = ROOT.parent / "hackathon-h1"
SLOPE = math.radians(35)
length, width, thickness = 76.2, 25.4, 1.1
run = length * math.cos(SLOPE)
up_y = 124 - run
up_z = 220 + length * math.sin(SLOPE)
station = [110, 116.5, 220 + (124-116.5)*math.tan(SLOPE)+2.8]
data = copy.deepcopy(json.loads((H1 / "design-h1.json").read_text()))
data.update(revision="H2", date="2026-10-21", status="dual_camera_proposal_not_hardware_validated", single_camera_retained="../hackathon-h1/beanlens-realistic-h1.html")
data["scope"].update(camera_count=2, dual_camera_pairing=True, stationary_photo=True)
data["geometry"]["chute"].update(inner_width=25.8, floor_face=[width,length,thickness], floor_material="removable_7101_plain_ground_edge_slide", upstream_y=up_y, upstream_z=up_z)
data["geometry"]["work_aperture"]={"xy":[75,55],"wh":[70,110],"relative_to_176x196_platform":[53,33]}
data["geometry"]["glass"]={"size":[width,length,thickness],"nominal_thickness_range":[1.0,1.2],"side_clearance_each":0.2,"edge_support_each":3,"clear_optical_width":19.8,"rails_face_mm":[3,length,3],"removable":True,"do_not_weld_glass":True}
data["geometry"]["base"]={"xy":[60,50],"size":[100,130,3],"hole_xy":[86,60],"hole_wh":[48,105],"notes":"Sidewalls over the opening use two outward L feet, bolt centers X80/X140; no PP floor below optical zone."}
data["geometry"]["camera"]={"count":2,"station_xyz":station,"upper_lens_xyz":[110,116.5,station[2]+90],"lower_lens_xyz":[110,116.5,station[2]-90],"directions":[[0,0,-1],[0,0,1]],"axis":"vertical_opposed","working_distance_proposal_mm":90,"working_distance_trial_range_mm":[80,110],"independent_focus":True,"optical_incidence_to_glass_normal_deg":35,"csi_id_mapping":None}
data["geometry"]["feed_mouth"]={"front_y":35,"rear_y":up_y,"front_inner_width":45,"rear_inner_width":25.8,"side_height":14,"floor_face_length":(up_y-35)/math.cos(SLOPE),"manual_only":True}
data["geometry"]["collector"]={"ramp_start_xyz":[110,132,197],"ramp_end_xyz":[110,165,143],"inside_width":46,"side_height":18,"guard":{"y":145,"z":[110,165],"width":60,"thickness":2},"camera_lower_pcb_max_y":136.5,"guard_pcb_nominal_gap_mm":3.5,"cup_y_range":[95,195],"not_automatic_sorting":True}
updates={
"H02":{"name":"上下两只相机","qty":2,"spec":"两只同批GC2093完整模组＋各自兼容CSI排线；独立调焦","notes":"优先复用原双摄套件。BOX两CSI口分别接，物理口与Sensor(id)映射须实测；静止状态先A后B，两个视角共享一颗豆的cycle_id。"},
"H07":{"qty":4,"spec":"上方2段＋下方2段，各100mm有效长，合计0.4m、≤8W预算","notes":"先核实际剪切点；上下独立摆角。下灯从木台开口内侧斜照，防止托条/板边遮挡，不以动画证明照明合格。"},
"H08":{"qty":4,"spec":"配实际灯带PCB宽；上下各两条，候选外14×8×100mm"},
"H10":{"model":"MG996R固定架＋6061铝板60×60×3；固定架/垫高待实配","spec":"竖轴目标X140/Y126/Z240，转接板向右让开玻璃托座","notes":"支架不是已放行成品图。铝板在PP底座上方叠放，外侧垫片找平；限位放舵机侧，避开两条拍摄轴线。"},
"H11":{"notes":"仍只用一只驱动舵臂；长度/长孔与上摄ROI手动核避让。中心螺钉用舵机原配；先试25T配合，不能硬拉花键。"},
"H12":{"spec":"宽12连接挡片；宽15两只向外伸出固定玻璃槽侧支承","notes":"侧支承脚位于PP底座开口内，必须用向外的角铝落到实体边框；螺栓中心参考X80/140，不可悬空。挡片角件防转孔位仍待实配。"},
"H13":{"model":"PP-H 3mm 板，候选300×300mm一片","spec":"开窗底座100×130、玻璃槽侧支承×2、承托条/压扣、短导豆口、后接豆斜槽；包含相机载板","notes":"H32/H33为本板加工子件，不另买同样板材；按裁切表及样板排版。透明拍摄底为H31玻璃，禁止焊回不透明PP底。"},
"H16":{"spec":"176×196×6共3片；工作板开70×110通孔，孔全局X75/Y55","notes":"其余两片尺寸保留；已有H1工作板可扩孔，先确认未削到安装点。孔相对板左前角53/33，不可沿用H1的50×45孔。"},
"H18":{"spec":"上相机1套，镜头目标X110/Y116.5/Z318.05，垂直向下","notes":"沿用上层支架实配。相机外形包络不是孔位；手转挡片和旗片，核ROI不被遮挡。"},
"H20":{"model":"黑PP2，候选300×300mm","spec":"侧/后可拆遮光片＋镜头周围背景片＋下相机防撞挡板60×55","notes":"取放口和两个镜头光路不能封住；下方防撞挡板位于Y145/Z110–165，名义距PCB边8.5mm，实际PCB/线缆尺寸变化要重核。"},
"H21":{"notes":"原普通收豆杯复用；后斜槽出口Y165落入同一杯。下相机载板在杯口前半区上方，取杯前断6V，不得顶碰镜头。"},
"H30":{"spec":"沿用M3/M2小件包；增加玻璃压扣用M2螺钉/垫片4套、下相机隔柱4套","notes":"玻璃夹持只防滑，不拧弯；豆路内无裸露螺纹。所需隔柱高度按相机和支架实物选；毛坯/孔位先纸样，非正式加工图。"},
}
for b in data["bom"]:
    if b["id"] in updates: b.update(updates[b["id"]])
def add(id,name,model,spec,qty,unit,notes):
    data["bom"].append(dict(id=id,name=name,model=model,spec=spec,qty=qty,unit=unit,notes=notes,status="新增/改制，待实配",full_bom=None,unit_price_cny=None))
add("H31","透明拍摄托片","7101普通无磨砂磨边载玻片（品牌/订单确认）","指定25.4×76.2×1.0–1.2mm；模型1.1mm；不买盖玻片/磨砂/凹槽/粘附涂层",3,"片","1用2备；店铺可能按50/72片一盒卖。不同7101存在25×75、26×76等规格，先量实物再定托座，不能只认7101号。不是承1kg料斗的底。")
add("H32","玻璃托座与压扣加工","H13的PP3子件＋H30的M2紧固件","内宽25.8起试；每侧3mm承托，中央约19.8mm通光；压扣4只",1,"套","已计入H13板材/H30紧固件，不重复买板；上下两面均可擦拭，玻璃可从前端抽出，不粘死。厚度范围1.0–1.2，压扣高度按实物配。")
add("H33","后接豆斜槽加工","H13 PP3子件＋H20 PP2防撞挡板","内宽46，斜底33mm水平/54mm落差，面长63.29；两侧挡边18高",1,"套","斜槽上沿Y132/Z197，出口Y165/Z143；防撞片Y145。与摄影托片分离，不把下相机包进封闭漏斗；内焊筋修平，手放实豆确认不反弹到镜头。")
add("H34","下相机可调安装","30×30×2角铝长40＋PP3开框载板60×40＋M2隔柱","1套；镜头X110/Y116.5/Z138.05向上；载板候选Z111.5–114.5",1,"套","新增第二套角铝/M2隔柱；PP板料在H13内。载板后缘Y136.5，防撞片Y145，名义8.5mm间隙须实配放大；不能靠CSI排线承重。")
data.pop("flat_stock_pp3",None)
data["sources"]["plain_slide"]="https://www.hinotek.com/lab/microscope-slide/"
data["sequential_capture"]={"one_cycle_one_bean":True,"order":["A_top","B_through_slide","pair_validate","save_pair","release"],"count_pair_once":True,"both_required_before_auto_release":True,"sync_claim":False,"whole_surface_claim":False,"frame_age_limit_ms":None,"roi_pixel_check_required":True}
(ROOT/"design-h2.json").write_text(json.dumps(data,ensure_ascii=False,indent=2)+"\n")

baseline=copy.deepcopy(json.loads((PROJECT/"config/hardware-hackathon-h1.json").read_text()))
baseline.update(profile="hackathon-h2",date="2026-10-21",status="dual_static_camera_proposal_pending_board_optical_and_mechanical_tests",source="docs/hardware/hackathon-h2/design-h2.json",single_camera_profile="config/hardware-hackathon-h1.json")
baseline["scope"]=data["scope"]
baseline["power"].update(led_budget_w=8,continuous_budget_w=49.25,short_peak_budget_w=64.25)
baseline["cameras"]={"count":2,"model":"GC2093-M12-90deg user supplied","physical_ports":["BOX CSI1","BOX CSI2"],"sensor_id_mapping":None,"capture":"static_sequential_one_pair_per_cycle","board_dual_capture_validated":False,"model_paired_inference_validated":False}
baseline["optics"]={"transparent_support":"7101 plain slide specified25.4x76.2x1.0-1.2mm","glass_focus_glare_cleanliness_test":False,"pair_fusion":"any suspect=>suspect; any unusable=>review; both usable/normal=>normal; class thresholds to validate","camera_lens_target_xyz":data["geometry"]["camera"],"roi_native_pixel_density_validated":False}
(PROJECT/"config/hardware-hackathon-h2.json").write_text(json.dumps(baseline,ensure_ascii=False,indent=2)+"\n")

fields=["id","name","model","spec","qty","unit","status","notes","unit_price_cny"]
with (ROOT/"bom-h2.csv").open("w",newline="",encoding="utf-8-sig") as f:
    out=csv.DictWriter(f,fields,extrasaction="ignore");out.writeheader();out.writerows(data["bom"])
(ROOT/"bom-h2.json").write_text(json.dumps(data["bom"],ensure_ascii=False,indent=2)+"\n")
old={b["id"]:b for b in json.loads((H1/"design-h1.json").read_text())["bom"]}
delta=[b for b in data["bom"] if b["id"] not in old or b!=old[b["id"]]]
with (ROOT/"delta-h1-to-h2.csv").open("w",newline="",encoding="utf-8-sig") as f:
    out=csv.DictWriter(f,fields,extrasaction="ignore");out.writeheader();out.writerows(delta)
rows=''.join('<tr>'+''.join('<td>'+html.escape(str(b.get(k,"")))+'</td>' for k in fields[:-1])+'</tr>' for b in data["bom"])
(ROOT/"bom-h2.html").write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>BeanLens H2 双摄采购表</title><style>body{font:14px/1.7 sans-serif;margin:30px;color:#213944}table{border-collapse:collapse;width:100%;font-size:12px}td,th{padding:10px;border:1px solid #ccd7dd;vertical-align:top}th{background:#e9f0f3;position:sticky;top:0}a{color:#146d83}</style><h1>H2 双摄版 · 34组采购/加工项</h1><p>单槽、人工单颗、静止上下双摄；H1与完整版保留。价格未知不按0算；H32/H33是H13板料加工子项，不重复购料。</p><p><a href="beanlens-realistic-h2.html">拟真动画</a> · <a href="README.md">装配与光路说明</a> · <a href="bom-h2.csv">完整CSV</a> · <a href="delta-h1-to-h2.csv">H1改动项</a> · <a href="wiring-h2.svg">接线示意</a></p><table><thead><tr>'+''.join('<th>'+x+'</th>' for x in ["编号","名称","型号/买什么","规格","数量","单位","状态","说明"])+'</tr></thead><tbody>'+rows+'</tbody></table></html>')

cuts=[
["H14","黑欧标2020","460×4 / 180×4 / 200×4","12段","沿用H1；已有460×7+400×2足够，不新订型材"],
["H16","海洋板6","176×196","3片","仅工作板改孔70×110；孔相对53/33，全局75/55"],
["H13","PP3底座","100×130；开48×105","1片","孔相对26/10，全局86/60"],
["H13","PP3侧支承梯形",f"水平{run:.3f}；前高{up_z+14-189:.3f}；后高45","2片","底Z189；上边跟35°玻璃斜面，另有14高挡边"],
["H32","PP3托条",f"3×{length}（沿板面）","2条","压在玻璃下侧外缘；中央通光约19.8宽"],
["H32","PP3可拆压扣","12×8毛坯","4只","外侧M2夹持，不压弯玻璃；孔按实物"],
["H31","成品玻璃载玻片","25.4×76.2×1.0–1.2","1用2备","不自行裁切，不PP焊，不用盖玻片"],
["H13","PP3导豆口底板",f"板面长{(up_y-35)/math.cos(SLOPE):.3f}；前宽45/后宽25.8","1片","梯形；Y35到玻璃上沿Y61.58，纸样配缝后裁"],
["H13","PP3导豆口侧片","按两端14高+底面35°纸样展开","2片","外扩侧壁为斜平面，不能直接用矩形硬拉焊"],
["H13","PP3后接豆底板",f"46×{math.hypot(33,54):.3f}","1片","水平33，落差54；不是长度33的斜板"],
["H13","PP3后接豆挡边",f"{math.hypot(33,54):.3f}×18","2片","沿斜面两边焊；豆路焊筋修平"],
["H20","PP2镜头防撞挡板","60×55","1片","X80–140/Y145/Z110–165，先实豆验证不反弹"],
["H34","PP3下相机载板","60×40；中央孔/孔距实配","1片","X80/Y96.5/Z111.5候选；非放行孔位图"],
["H13","PP3挡片/旗片","46×18 / 30×16","各1","沿用轻侧摆；旗片不能遮挡上摄ROI"],
["H07/H08","灯带/铝槽","100有效长","4段","切点、底灯摆角、散热实配"],
]
with (ROOT/"cut-list-h2.csv").open("w",newline="",encoding="utf-8-sig") as f:
    w=csv.writer(f);w.writerow(["BOM","材料","尺寸mm","数量","装配说明"]);w.writerows(cuts)
print(f"H2: {len(data['bom'])} BOM groups, {len(delta)} delta groups, unchanged frame stock; glass upstream {up_y:.3f}/{up_z:.3f}")
