# V4.6 效果图生成记录

日期：2026-10-15。工具：内置 image_gen。参考用户提供的旧外观图，只沿用银色型材、浅色木面板和控制布局；角部改为连续立柱与常规内角码。

输出：[概念效果图](beanlens-frame-v4.6-concept.png)。透视、角码细节和隐藏构件由图像模型表达；尺寸、数量、接合位置以本目录尺寸图和清单为准。不是实物照片、承载验收或开孔加工图。右侧放大图的平片外观不构成新增采购项；实际采用完整的两孔直角角码。

## 生成提示词

```text
Generate a professional industrial product design visualization sheet for BeanLens, a small coffee green-bean visual inspection prototype. Use the attached old product rendering ONLY for material palette (silver aluminum, natural pale plywood, black controls) and overall product identity; REPLACE its impossible cube junctions completely with buildable conventional 2020 extrusion construction.

Create two large views on a light warm neutral studio background, landscape sheet: LEFT a realistic assembled machine three-quarter front-right view, RIGHT an unobscured isometric skeleton of the same machine with a large close-up inset showing the actual corner connector. Minimal clean labels only: "BeanLens", "460 mm", "220 mm", "240 mm", "2020 + L bracket", "Concept / V4.6". No invented measurement text, no extra cube blocks.

MECHANICAL STRUCTURE IS ESSENTIAL:
True frame width220,depth240,height460mm (height is about twice width, compact tabletop, not tall 3x tower). Four identical uninterrupted 20x20 silver T-slot vertical posts run continuously from bottom to top, never spliced. All horizontal rails terminate BETWEEN posts rather than atop them. At top and bottom, front/rear rails are180mm and left/right depth rails200mm. Top rails have their top faces flush with top of460mm uprights. Bottom rails flush with bottom of uprights. There are TWO200mm side rails at height304..324mm and TWO180mm mid crossrails between those side rails, plus TWO180mm width camera bars at height221..241mm. The skeleton must visibly show intermediate support beams. Use small standard die-cast right-angle L gusset brackets installed on INSIDE faces, fastened to T-slot nuts with socket bolts, NOT ornamental connector cubes, NO chunky wraparound corner blocks, NO corner cubes anywhere. The enlarged connector inset shows two ordinary 90-degree gusset brackets on perpendicular inner faces of one continuous post securing two abutting beams, two screws per bracket; visibly ordinary silver or gray L brackets with triangular ribs. Do not draw sideways screws magically joining bare profile without brackets. Small black end caps only on vertical top open ends, four black short feet below base.

ASSEMBLED VIEW: outer removable6mm light natural plywood upper side skins and upper front fascia, exposed silver posts, hidden inward brackets. Keep upper hopper lip about20mm below the very top (top rail bottom at440mm, hopper top440mm). Food hopper has white food-safe PP liner and modest green beans. Front black2.4inch display with case64mmwide on220mmwide face, small neutral line status display no fake large accuracy/readings, two16mm round buttons. Compact right-side black status window. Upper fascia fromZ200 to440. Lower front open bay with removable translucent food-safe bin approx160wide170deep125high on a slim internally supported weighing platform; not a separate bathroom scale. Black light shield separates imaging chamber and lower bin bay nearZ195. No beans flying out. Internal gate and cameras may be omitted in skeleton to keep frame connections clear. Skeleton may show only one ghosted plywood panel to explain detachable skin, no loose electronics. Reproducible clean engineering-aware photorealistic rendering, accurate relative geometry, camera eye level slightly above top. Image is conceptual not fabrication drawing.
```
