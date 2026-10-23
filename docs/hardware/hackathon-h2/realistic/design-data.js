window.BEANLENS_H2_DATA={
  "revision": "H2",
  "date": "2026-10-21",
  "status": "dual_camera_proposal_not_hardware_validated",
  "full_version_retained": "../assembly-v4.12/beanlens-assembly-v4.12.html",
  "scope": {
    "camera_count": 2,
    "lane_count": 1,
    "controller": "ALIENTEK K230D BOX",
    "actuator": "MG996R position servo",
    "manual_one_bean": true,
    "stationary_photo": true,
    "weighing": false,
    "esp32c6": false,
    "ir_beam": false,
    "pbt_brush": false,
    "dual_camera_pairing": true,
    "network": false
  },
  "geometry": {
    "frame": [
      220,
      240,
      460
    ],
    "platforms_z": [
      20,
      180,
      344
    ],
    "chute": {
      "inner_width": 25.8,
      "floor_face": [
        25.4,
        76.2,
        1.1
      ],
      "slope_deg": 35,
      "downstream_y": 124,
      "downstream_z": 220,
      "upstream_y": 61.58061422517882,
      "upstream_z": 263.7065244499497,
      "side_base_z": 189,
      "wall_vertical_height": 14,
      "floor_material": "removable_7101_plain_ground_edge_slide"
    },
    "gate": {
      "blank": [
        46,
        18,
        3
      ],
      "closed_xyz": [
        94,
        124.5,
        220.5
      ],
      "pivot": [
        140,
        126,
        240
      ],
      "open_angle_deg_proposal": 90,
      "closed_angle_deg_proposal": 0,
      "horn_radius": 16,
      "rod_count": 0,
      "rail_count": 0,
      "geometry_only_no_pwm_pulse_calibration": true
    },
    "camera": {
      "count": 2,
      "station_xyz": [
        110,
        116.5,
        228.05155653657283
      ],
      "upper_lens_xyz": [
        110,
        116.5,
        318.05155653657283
      ],
      "lower_lens_xyz": [
        110,
        116.5,
        138.05155653657283
      ],
      "directions": [
        [
          0,
          0,
          -1
        ],
        [
          0,
          0,
          1
        ]
      ],
      "axis": "vertical_opposed",
      "working_distance_proposal_mm": 90,
      "working_distance_trial_range_mm": [
        80,
        110
      ],
      "independent_focus": true,
      "optical_incidence_to_glass_normal_deg": 35,
      "csi_id_mapping": null
    },
    "work_aperture": {
      "xy": [
        75,
        55
      ],
      "wh": [
        70,
        110
      ],
      "relative_to_176x196_platform": [
        53,
        33
      ]
    },
    "cup": {
      "xyz": [
        60,
        95,
        26
      ],
      "size": [
        100,
        100,
        80
      ]
    },
    "glass": {
      "size": [
        25.4,
        76.2,
        1.1
      ],
      "nominal_thickness_range": [
        1.0,
        1.2
      ],
      "side_clearance_each": 0.2,
      "edge_support_each": 3,
      "clear_optical_width": 19.8,
      "rails_face_mm": [
        3,
        76.2,
        3
      ],
      "removable": true,
      "do_not_weld_glass": true
    },
    "base": {
      "xy": [
        60,
        50
      ],
      "size": [
        100,
        130,
        3
      ],
      "hole_xy": [
        86,
        60
      ],
      "hole_wh": [
        48,
        105
      ],
      "notes": "Sidewalls over the opening use two outward L feet, bolt centers X80/X140; no PP floor below optical zone."
    },
    "feed_mouth": {
      "front_y": 35,
      "rear_y": 61.58061422517882,
      "front_inner_width": 45,
      "rear_inner_width": 25.8,
      "side_height": 14,
      "floor_face_length": 32.44893839976958,
      "manual_only": true
    },
    "collector": {
      "ramp_start_xyz": [
        110,
        132,
        197
      ],
      "ramp_end_xyz": [
        110,
        165,
        143
      ],
      "inside_width": 46,
      "side_height": 18,
      "guard": {
        "y": 145,
        "z": [
          110,
          165
        ],
        "width": 60,
        "thickness": 2
      },
      "camera_lower_pcb_max_y": 136.5,
      "guard_pcb_nominal_gap_mm": 3.5,
      "cup_y_range": [
        95,
        195
      ],
      "not_automatic_sorting": true
    }
  },
  "bom": [
    {
      "id": "H01",
      "name": "识别/显示/控制板",
      "model": "正点原子 K230D BOX",
      "spec": "含内置2.4屏/用户按键，64.3×47.6×15.4外壳参考；TF按原套件",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": "A01",
      "notes": "Type-C1供5V；Type-C2不供电，不拆原壳。已有套件257报价不重计。",
      "unit_price_cny": null
    },
    {
      "id": "H02",
      "name": "上下两只相机",
      "model": "GC2093-M12-90度无畸变（用户型号）",
      "spec": "两只同批GC2093完整模组＋各自兼容CSI排线；独立调焦",
      "qty": 2,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": "B01",
      "notes": "优先复用原双摄套件。BOX两CSI口分别接，物理口与Sensor(id)映射须实测；静止状态先A后B，两个视角共享一颗豆的cycle_id。",
      "unit_price_cny": null
    },
    {
      "id": "H03",
      "name": "舵机",
      "model": "MG996R 位置版",
      "spec": "1只，独立6V；外形40.7×19.7×42.9参考，轴竖直",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": "A03",
      "notes": "非连续旋转版。输出轴只带轻挡片；不承人工按压力。",
      "unit_price_cny": null
    },
    {
      "id": "H04",
      "name": "主电源",
      "model": "YU2405（用户指定）",
      "spec": "机外24V/5A/120W；实际厂牌/插头/极性/AC线另核",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": "A07",
      "notes": "",
      "unit_price_cny": null
    },
    {
      "id": "H05",
      "name": "逻辑降压",
      "model": "TPS5450成品板候选，整板SKU未定",
      "spec": "24V→5.00V；H1只给BOX和缓冲板，3A连续预算待验",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": "A08",
      "notes": "不是裸DDA芯片；先空载量5V再接BOX，不选未证实供电板。",
      "unit_price_cny": null
    },
    {
      "id": "H06",
      "name": "舵机降压",
      "model": "HOBBYWING UBEC5A / 30607000 / 2–8S",
      "spec": "设6.0V；原厂5A持续，本机3A持续/5A短峰预算",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": "A17",
      "notes": "断电设跳帽，量6V后接舵机；不能给GPIO或主板。",
      "unit_price_cny": null
    },
    {
      "id": "H07",
      "name": "固定照明",
      "model": "复用原24V 6000K/Ra98灯带，完整SKU待核",
      "spec": "上方2段＋下方2段，各100mm有效长，合计0.4m、≤8W预算",
      "qty": 4,
      "unit": "段",
      "status": "复用优先，实物核对",
      "full_bom": "A05",
      "notes": "先核实际剪切点；上下独立摆角。下灯从木台开口内侧斜照，防止托条/板边遮挡，不以动画证明照明合格。",
      "unit_price_cny": null
    },
    {
      "id": "H08",
      "name": "灯铝槽",
      "model": "U形铝槽，候选外14×8×100mm",
      "spec": "配实际灯带PCB宽；上下各两条，候选外14×8×100mm",
      "qty": 4,
      "unit": "条",
      "status": "复用优先，实物核对",
      "full_bom": "L02 / L03",
      "notes": "",
      "unit_price_cny": null
    },
    {
      "id": "H09",
      "name": "开/关限位",
      "model": "OMRON SS-01GL 微负载金合金触点",
      "spec": "每端1只，COM/NO，低电平有效；19.8×6.4壳体/9.5孔距参考",
      "qty": 2,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": "S01",
      "notes": "限位检测挡片/支架旗片而非仅检测PWM命令；3.3V内部上拉条件实测接触可靠性。",
      "unit_price_cny": null
    },
    {
      "id": "H10",
      "name": "舵机专用安装件",
      "model": "MG996R固定架＋6061铝板60×60×3；固定架/垫高待实配",
      "spec": "竖轴目标X140/Y126/Z240，转接板向右让开玻璃托座",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": "G14",
      "notes": "支架不是已放行成品图。铝板在PP底座上方叠放，外侧垫片找平；限位放舵机侧，避开两条拍摄轴线。",
      "unit_price_cny": null
    },
    {
      "id": "H11",
      "name": "舵臂",
      "model": "MG996R匹配25T金属直臂，16mm孔半径",
      "spec": "只用16mm孔；孔径优先M3，若现有goBILDAφ4加适配套",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": "G01",
      "notes": "仍只用一只驱动舵臂；长度/长孔与上摄ROI手动核避让。中心螺钉用舵机原配；先试25T配合，不能硬拉花键。",
      "unit_price_cny": null
    },
    {
      "id": "H12",
      "name": "挡片/槽脚角铝加工套件",
      "model": "6061角铝20×20×2，宽12×1、宽15×2",
      "spec": "宽12连接挡片；宽15两只向外伸出固定玻璃槽侧支承",
      "qty": 1,
      "unit": "套",
      "status": "复用优先，实物核对",
      "full_bom": null,
      "notes": "侧支承脚位于PP底座开口内，必须用向外的角铝落到实体边框；螺栓中心参考X80/140，不可悬空。挡片角件防转孔位仍待实配。",
      "unit_price_cny": null
    },
    {
      "id": "H13",
      "name": "PP停豆槽/挡片/旗片",
      "model": "PP-H 3mm 板，候选300×300mm一片",
      "spec": "开窗底座100×130、玻璃槽侧支承×2、承托条/压扣、短导豆口、后接豆斜槽；包含相机载板",
      "qty": 1,
      "unit": "片",
      "status": "复用优先，实物核对",
      "full_bom": null,
      "notes": "H32/H33为本板加工子件，不另买同样板材；按裁切表及样板排版。透明拍摄底为H31玻璃，禁止焊回不透明PP底。",
      "unit_price_cny": null
    },
    {
      "id": "H14",
      "name": "机架型材",
      "model": "已有黑色欧标2020，同槽型",
      "spec": "460×4立柱、180×4宽梁、200×4深梁；共12段",
      "qty": 12,
      "unit": "段",
      "status": "复用优先，实物核对",
      "full_bom": "F01",
      "notes": "4根460留整；另3根460各切200+180；1根400切200+180；剩1根400保留。无需新增型材。",
      "unit_price_cny": null
    },
    {
      "id": "H15",
      "name": "框架角码/M5/T螺母",
      "model": "欧标2020配套两孔90°角码，黑色优先",
      "spec": "16角码使用+4备用；M5螺钉/T螺母各40只",
      "qty": 20,
      "unit": "套",
      "status": "复用优先，实物核对",
      "full_bom": "F02",
      "notes": "含4套备用，长度按槽型配；不使用三通/四通方块。",
      "unit_price_cny": null
    },
    {
      "id": "H16",
      "name": "固定木平台",
      "model": "6mm海洋板，按已有余料裁",
      "spec": "176×196×6共3片；工作板开70×110通孔，孔全局X75/Y55",
      "qty": 3,
      "unit": "片",
      "status": "复用优先，实物核对",
      "full_bom": "F03",
      "notes": "其余两片尺寸保留；已有H1工作板可扩孔，先确认未削到安装点。孔相对板左前角53/33，不可沿用H1的50×45孔。",
      "unit_price_cny": null
    },
    {
      "id": "H17",
      "name": "平台支承角片",
      "model": "2020配套内角片＋M5/T螺母＋M3×16/φ9垫片螺母",
      "spec": "3平台×4点=12用，16套购含4备",
      "qty": 16,
      "unit": "套",
      "status": "复用优先，实物核对",
      "full_bom": "F11",
      "notes": "承托底面Z20/180/344；松装找平，不能用螺钉拉弯木片。",
      "unit_price_cny": null
    },
    {
      "id": "H18",
      "name": "相机可调安装",
      "model": "30×30×2角铝长40＋PP3 60×60载板＋M2隔柱",
      "spec": "上相机1套，镜头目标X110/Y116.5/Z318.05，垂直向下",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": "B13",
      "notes": "沿用上层支架实配。相机外形包络不是孔位；手转挡片和旗片，核ROI不被遮挡。",
      "unit_price_cny": null
    },
    {
      "id": "H19",
      "name": "BOX固定框",
      "model": "复用80×64外压框/背托与软垫夹片",
      "spec": "原壳整机固定在前框，保留KEY0/KEY1及TF/Type-C可达；配M5/T螺母4套与软垫夹片",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": "F15",
      "notes": "不另买屏，不钻原壳；用一块176×112木余料或小PP承板，按原壳实配。",
      "unit_price_cny": null
    },
    {
      "id": "H20",
      "name": "局部遮光片",
      "model": "黑PP2，候选300×300mm",
      "spec": "侧/后可拆遮光片＋镜头周围背景片＋下相机防撞挡板60×55",
      "qty": 3,
      "unit": "片",
      "status": "复用优先，实物核对",
      "full_bom": "F07",
      "notes": "取放口和两个镜头光路不能封住；下方防撞挡板位于Y145/Z110–165，名义距PCB边8.5mm，实际PCB/线缆尺寸变化要重核。",
      "unit_price_cny": null
    },
    {
      "id": "H21",
      "name": "普通收豆杯",
      "model": "PP杯/盒，约100×100×80mm",
      "spec": "固定底板上，覆盖出口下方；不装传感器",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": "B12",
      "notes": "原普通收豆杯复用；后斜槽出口Y165落入同一杯。下相机载板在杯口前半区上方，取杯前断6V，不得顶碰镜头。",
      "unit_price_cny": null
    },
    {
      "id": "H22",
      "name": "PWM缓冲板",
      "model": "SN74AHCT125N（DIP14）＋2N3904，洞洞板30×50mm",
      "spec": "代焊一块3.3→5V单向缓冲，默认/OE拉高禁能",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": null,
      "notes": "器件H23–H27为本板构成，不另买两套整板；完整引脚见接线页。避免用74HC125替代AHCT/HCT阈值。",
      "unit_price_cny": null
    },
    {
      "id": "H23",
      "name": "缓冲IC与插座",
      "model": "TI SN74AHCT125N + DIP14插座",
      "spec": "VCC5V，TTL输入，使用通道1；闲置输入接地、/OE拉高",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": null,
      "notes": "H22构成件；5V不能反接BOX GPIO。",
      "unit_price_cny": null
    },
    {
      "id": "H24",
      "name": "使能三极管",
      "model": "2N3904 NPN TO-92",
      "spec": "E→GND，C→/OE1，B经4.7k到GPIO22",
      "qty": 1,
      "unit": "件",
      "status": "复用优先，实物核对",
      "full_bom": null,
      "notes": "H22构成件，按所购厂家引脚图确认E/B/C。",
      "unit_price_cny": null
    },
    {
      "id": "H25",
      "name": "电阻包",
      "model": "金属膜1% 0.25W",
      "spec": "10k×2，4.7k×1，100k×1，1k×3，220Ω×1；各备1",
      "qty": 1,
      "unit": "包",
      "status": "复用优先，实物核对",
      "full_bom": null,
      "notes": "10k：/OE上拉5V、PWM输入下拉；1k：PWM输入串联及2限位串联；100k基极下拉。",
      "unit_price_cny": null
    },
    {
      "id": "H26",
      "name": "去耦与近端电容",
      "model": "100nF/50V X7R×1；1000µF/16V 105℃低ESR×1",
      "spec": "100nF紧贴IC14/7；1000µF并舵机6V/GND",
      "qty": 1,
      "unit": "包",
      "status": "复用优先，实物核对",
      "full_bom": "C01",
      "notes": "核极性；不以电容替代足够的降压和线径。",
      "unit_price_cny": null
    },
    {
      "id": "H27",
      "name": "信号接线辅料",
      "model": "30×50洞洞板、端子、2.54插座、热缩/绝缘柱",
      "spec": "缓冲板与J10短线，标注GPIO编号及针脚号",
      "qty": 1,
      "unit": "包",
      "status": "复用优先，实物核对",
      "full_bom": null,
      "notes": "J10只12个GPIO，没有地或电源；GND从原理图J6（PH2.0口1）的2脚GND引出，以实物1脚方向核针序；J6的1脚5V及3/4脚不接。",
      "unit_price_cny": null
    },
    {
      "id": "H28",
      "name": "配电/保险/开关包",
      "model": "绝缘低压分线端子；DC保险座；舵机支路电源开关",
      "spec": "主4A、灯1A、5V输入1.5A、UBEC输入3A；6V开关DC≥12V/5A",
      "qty": 1,
      "unit": "包",
      "status": "复用优先，实物核对",
      "full_bom": "P01–P14",
      "notes": "保险位在24V正输入；手动6V开关用于装配/排障，不称自动硬件急停。盒保留机外，不接裸交流。",
      "unit_price_cny": null
    },
    {
      "id": "H29",
      "name": "电源线/接口",
      "model": "0.75mm²多股铜线、压接端子、5V USB-A→C成品短线",
      "spec": "24V/6V电流不走杜邦；DC母座按YU2405实物匹配",
      "qty": 1,
      "unit": "包",
      "status": "复用优先，实物核对",
      "full_bom": "P03 / P09 / P14",
      "notes": "5V接BOX Type-C1；USB调试时禁止另一路5V反灌/并联。信号地与UBEC参考地相连，舵机返回独立走线。",
      "unit_price_cny": null
    },
    {
      "id": "H30",
      "name": "小件紧固包",
      "model": "304 M3×8/12/16、M2×6/8、垫片、防松螺母",
      "spec": "沿用M3/M2小件包；增加玻璃压扣用M2螺钉/垫片4套、下相机隔柱4套",
      "qty": 1,
      "unit": "包",
      "status": "复用优先，实物核对",
      "full_bom": null,
      "notes": "玻璃夹持只防滑，不拧弯；豆路内无裸露螺纹。所需隔柱高度按相机和支架实物选；毛坯/孔位先纸样，非正式加工图。",
      "unit_price_cny": null
    },
    {
      "id": "H31",
      "name": "透明拍摄托片",
      "model": "7101普通无磨砂磨边载玻片（品牌/订单确认）",
      "spec": "指定25.4×76.2×1.0–1.2mm；模型1.1mm；不买盖玻片/磨砂/凹槽/粘附涂层",
      "qty": 3,
      "unit": "片",
      "notes": "1用2备；店铺可能按50/72片一盒卖。不同7101存在25×75、26×76等规格，先量实物再定托座，不能只认7101号。不是承1kg料斗的底。",
      "status": "新增/改制，待实配",
      "full_bom": null,
      "unit_price_cny": null
    },
    {
      "id": "H32",
      "name": "玻璃托座与压扣加工",
      "model": "H13的PP3子件＋H30的M2紧固件",
      "spec": "内宽25.8起试；每侧3mm承托，中央约19.8mm通光；压扣4只",
      "qty": 1,
      "unit": "套",
      "notes": "已计入H13板材/H30紧固件，不重复买板；上下两面均可擦拭，玻璃可从前端抽出，不粘死。厚度范围1.0–1.2，压扣高度按实物配。",
      "status": "新增/改制，待实配",
      "full_bom": null,
      "unit_price_cny": null
    },
    {
      "id": "H33",
      "name": "后接豆斜槽加工",
      "model": "H13 PP3子件＋H20 PP2防撞挡板",
      "spec": "内宽46，斜底33mm水平/54mm落差，面长63.29；两侧挡边18高",
      "qty": 1,
      "unit": "套",
      "notes": "斜槽上沿Y132/Z197，出口Y165/Z143；防撞片Y145。与摄影托片分离，不把下相机包进封闭漏斗；内焊筋修平，手放实豆确认不反弹到镜头。",
      "status": "新增/改制，待实配",
      "full_bom": null,
      "unit_price_cny": null
    },
    {
      "id": "H34",
      "name": "下相机可调安装",
      "model": "30×30×2角铝长40＋PP3开框载板60×40＋M2隔柱",
      "spec": "1套；镜头X110/Y116.5/Z138.05向上；载板候选Z111.5–114.5",
      "qty": 1,
      "unit": "套",
      "notes": "新增第二套角铝/M2隔柱；PP板料在H13内。载板后缘Y136.5，防撞片Y145，名义8.5mm间隙须实配放大；不能靠CSI排线承重。",
      "status": "新增/改制，待实配",
      "full_bom": null,
      "unit_price_cny": null
    }
  ],
  "sources": {
    "box": "https://wiki.alientek.com/docs/Boards/Kendryte/DNK230D/start-guide/k230d-box-introduction/",
    "key": "https://wiki.alientek.com/docs/Boards/Kendryte/DNK230D/example-base/key/",
    "pwm": "https://wiki.alientek.com/docs/Boards/Kendryte/DNK230D/example-base/beep/",
    "fpioa": "https://www.kendryte.com/k230_canmv/en/v1.3/example/peripheral/fpioa.html",
    "buffer": "https://www.ti.com/product/SN74AHCT125",
    "ubec": "https://oss.hobbywing.com/pdf/pdfcn/UBEC5Acn.pdf",
    "plain_slide": "https://www.hinotek.com/lab/microscope-slide/"
  },
  "unknown_prices_are_not_zero": true,
  "total_cost_cny": null,
  "single_camera_retained": "../hackathon-h1/beanlens-realistic-h1.html",
  "sequential_capture": {
    "one_cycle_one_bean": true,
    "order": [
      "A_top",
      "B_through_slide",
      "pair_validate",
      "save_pair",
      "release"
    ],
    "count_pair_once": true,
    "both_required_before_auto_release": true,
    "sync_claim": false,
    "whole_surface_claim": false,
    "frame_age_limit_ms": null,
    "roi_pixel_check_required": true
  }
}
;
