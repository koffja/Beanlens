; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 11m 24s; total estimated time: 18m 27s
; total layer number: 40
; total filament length [mm] : 1063.59
; total filament volume [cm^3] : 2558.23
; total filament weight [g] : 3.27
; model label id: 47,58
; object max height: 8.00,6.00
; filament_density: 1.28
; filament_diameter: 1.75
; max_z_height: 8.00
; filament: 1
; support_material_on_wipe_tower: 0
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0
; additional_cooling_fan_speed = 0
; additional_fan_full_speed_layer = 0
; alternate_extra_wall = 0
; ams_filament_load_time_ams = 0
; ams_filament_load_time_ams_lite = 0
; ams_filament_load_time_n3f_s = 0
; ams_filament_unload_time_ams = 0
; ams_filament_unload_time_ams_lite = 0
; ams_filament_unload_time_n3f_s = 0
; apply_scarf_seam_on_circles = 1
; auxiliary_fan = 1
; avoid_crossing_wall_includes_support = 0
; bed_custom_model = 
; bed_custom_texture = 
; bed_exclude_area = 
; bed_heat_soak_area = 
; bed_temperature_formula = by_first_filament
; before_layer_change_gcode = 
; best_object_pos = 0.5,0.5
; bottom_color_penetration_layers = 3
; bottom_shell_layers = 5
; bottom_shell_thickness = 1
; bottom_surface_density = 100%
; bottom_surface_pattern = monotonic
; bridge_angle = 0
; bridge_flow = 1
; bridge_no_support = 0
; bridge_speed = 25
; brim_object_gap = 0.15
; brim_type = no_brim
; brim_width = 5
; chamber_temperatures = 0
; change_filament_gcode = ;======== P2S filament_change gcode ==========\n;===== 2026/05/15 =====\n\nM620 S[next_filament_id]A\nM204 S9000\n{if toolchange_count > 1 && (z_hop_types[current_filament_id] == 0 || z_hop_types[current_filament_id] == 3)}\nG17\nG2 Z{z_after_toolchange + 0.4} I0.86 J0.86 P1 F10000 ; spiral lift a little from second lift\n{endif}\n\n;nozzle_change_gcode\n\nG1 Z{max_layer_z + 3.0} F1200\n\nM400\nM106 P1 S0\n\n{if toolchange_count == 2}\n; get travel path for change filament\n;M620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0\n;M620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1\n;M620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2\n{endif}\n\n{if ((filament_type[current_filament_id] == \"PLA\") || (filament_type[current_filament_id] == \"PLA-CF\") || (filament_type[current_filament_id] == \"PETG\")) && (nozzle_diameter_at_nozzle_id[current_nozzle_id] == 0.2)}\nM620.10 A0 F74.8347 L[flush_length] H{nozzle_diameter_at_nozzle_id[current_nozzle_id]} T{flush_temperatures[current_filament_id]} P[old_filament_temp] S1\n{else}\nM620.10 A0 F{flush_volumetric_speeds[current_filament_id]/2.4053*60} L[flush_length] H{nozzle_diameter_at_nozzle_id[current_nozzle_id]} T{flush_temperatures[current_filament_id]} P[old_filament_temp] S1\n{endif}\n\n{if ((filament_type[next_filament_id] == \"PLA\") || (filament_type[next_filament_id] == \"PLA-CF\") || (filament_type[next_filament_id] == \"PETG\")) && (nozzle_diameter_at_nozzle_id[next_nozzle_id] == 0.2)}\nM620.10 A1 F74.8347 L[flush_length] H{nozzle_diameter_at_nozzle_id[next_nozzle_id]} T{flush_temperatures[next_filament_id]} P[new_filament_temp] S1\n{else}\nM620.10 A1 F{flush_volumetric_speeds[next_filament_id]/2.4053*60} L[flush_length] H{nozzle_diameter_at_nozzle_id[next_nozzle_id]} T{flush_temperatures[next_filament_id]} P[new_filament_temp] S1\n{endif}\n\nM620.15 C{new_filament_temp - filament_cooling_before_tower[next_filament_id]}\n\n{if long_retraction_when_cut}\nM620.11 P1 L0 I[current_filament_id] E-{retraction_distance_when_cut} F{max((flush_volumetric_speeds[current_filament_id]/2.4053*60), 200)}\n{else}\nM620.11 P0 L0 I[current_filament_id] E0\n{endif}\n\nM620.11 K0 I[current_filament_id] R0\n\n\nT[next_filament_id]\n\n;deretract\n{if filament_type[next_filament_id] == \"TPU\"}\n{else}\n{if filament_type[next_filament_id] == \"PA\"}\n;VG1 E1 F{max(new_filament_e_feedrate, 200)}\n;VG1 E1 F{max(new_filament_e_feedrate/2, 100)}\n{else}\n;VG1 E4 F{max(new_filament_e_feedrate, 200)}\n;VG1 E4 F{max(new_filament_e_feedrate/2, 100)}\n{endif}\n{endif}\n\n; VFLUSH_START\n{if flush_length>41.5}\n;VG1 E41.5 F{min(old_filament_e_feedrate,new_filament_e_feedrate)}\n;VG1 E{flush_length-41.5} F{new_filament_e_feedrate}\n{else}\n;VG1 E{flush_length} F{min(old_filament_e_feedrate,new_filament_e_feedrate)}\n{endif}\nSYNC T{ceil(flush_length / 80) * 5}\n; VFLUSH_END\n\nM1002 set_filament_type:{filament_type[next_filament_id]}\n\nM400\nM83\n{if next_filament_id < 255}\nM620.10 R{retract_length_toolchange[filament_map[next_filament_id]-1]}\nM628 S0\n;VM109 S[new_filament_temp]\n\nM629\nM400\nM983.3 F{filament_max_volumetric_speed[next_filament_id]/2.4} A0.4 R{retract_length_toolchange[filament_map[next_filament_id]-1]}\nM400\nG1 Y247 F30000\nG1 Y217 F18000\n\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[travel_acceleration]\n{endif}\n\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\n\nM621 S[next_filament_id]A\n\nM622.1 S0 ;for prev version, default skip\nM1002 judge_flag powerloss_resume_flag\nM622 J1\nM983.3 F{filament_max_volumetric_speed[next_filament_id]/2.4} A0.4 R{retract_length_toolchange[filament_map[next_filament_id]-1]}\nM400\nG1 Y247 F30000\nG1 Y217 F18000\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[travel_acceleration]\n{endif}\nM1002 set_flag powerloss_resume_flag=0\nM623\n\n{if (filament_type[next_filament_id] == \"PLA\") ||  (filament_type[next_filament_id] == \"PETG\")\n ||  (filament_type[next_filament_id] == \"PLA-CF\")  ||  (filament_type[next_filament_id] == \"PETG-CF\")}\nM1015.4 S1 K1 H{nozzle_diameter_at_nozzle_id[next_nozzle_id]} ;enable E air printing detect\n{else}\nM1015.4 S0 K0 H{nozzle_diameter_at_nozzle_id[next_nozzle_id]} ;disable E air printing detect\n{endif}\n\nM620.6 I[next_filament_id] W1 ;enable ams air printing detect\n\nG1 Y256 F18000\n\n{if (overall_chamber_temperature < 40)}\n{if (layer_num + 1 <= close_additional_fan_first_x_layers[next_filament_id])}\n    {if (min_vitrification_temperature <= 50)}\n        M106 P2 S{first_x_layer_fan_speed[next_filament_id]*255.0/100.0 };set first x_layer aux fan\n    {endif}\n{elsif (layer_num + 1 < additional_fan_full_speed_layer[next_filament_id] && additional_fan_full_speed_layer[next_filament_id] > close_additional_fan_first_x_layers[next_filament_id])}\n    {if (min_vitrification_temperature <= 50)}\n        M106 P2 S{(first_x_layer_fan_speed[next_filament_id] + (additional_cooling_fan_speed[next_filament_id] - first_x_layer_fan_speed[next_filament_id]) * (layer_num + 1 - close_additional_fan_first_x_layers[next_filament_id]) / max(additional_fan_full_speed_layer[next_filament_id] - close_additional_fan_first_x_layers[next_filament_id], 1)) * 255.0/100.0}\n    {endif}\n{else}\n    {if (min_vitrification_temperature <= 50)}\n        {if (nozzle_diameter_at_nozzle_id[current_nozzle_id] == 0.2)}\n            M142 P1 R30 S40 U{max_additional_fan/100.0} V1.0 O45; set PLA/TPU ND0.2 chamber autocooling\n        {else}\n            M142 P1 R30 S40 U{max_additional_fan/100.0} V1.0 O45; set PLA/TPU ND0.4 chamber autocooling\n        {endif}\n    {endif}\n{endif}\n{endif}\n\nM622.1 S0\nM1002 judge_flag ventobox_replace_aux1_fan_flag\nM622 J0\n{if (layer_num + 1 <= close_additional_fan_first_x_layers[next_filament_id])}\n    M106 P10 S{first_x_layer_fan_speed[next_filament_id]*255.0/100.0 };set first x_layer left aux fan\n{elsif (layer_num + 1 < additional_fan_full_speed_layer[next_filament_id] && additional_fan_full_speed_layer[next_filament_id] > close_additional_fan_first_x_layers[next_filament_id])}\n    M106 P10 S{(first_x_layer_fan_speed[next_filament_id] + (additional_cooling_fan_speed[next_filament_id] - first_x_layer_fan_speed[next_filament_id]) * (layer_num + 1 - close_additional_fan_first_x_layers[next_filament_id]) / max(additional_fan_full_speed_layer[next_filament_id] - close_additional_fan_first_x_layers[next_filament_id], 1)) * 255.0/100.0}\n{else}\n    M106 P10 S{additional_cooling_fan_speed[next_filament_id]*255.0/100.0};set left aux fan\n{endif}\nM623\n\n;not set fan changing filament
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200
; close_additional_fan_first_x_layers = 3
; close_fan_the_first_x_layers = 3
; compatible_printers_condition = 
; complete_print_exhaust_fan_speed = 70
; cool_plate_temp = 0
; cool_plate_temp_initial_layer = 0
; cooling_filter_enabled = 0
; cooling_perimeter_transition_distance = 10
; cooling_slowdown_logic = uniform_cooling
; counter_coef_1 = 0
; counter_coef_2 = 0.0058
; counter_coef_3 = 0.0107
; counter_limit_max = 0.15
; counter_limit_min = 0.01
; counterbore_hole_bridging = none
; curr_bed_type = Textured PEI Plate
; default_acceleration = 3000
; default_ams_type = -1
; default_filament_colour = ""
; default_filament_profile = "Bambu PLA Basic @BBL P2S"
; default_jerk = 0
; default_nozzle_volume_type = Standard
; default_print_profile = 0.20mm Standard @BBL P2S
; deretraction_speed = 30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50
; different_settings_to_system = ;;
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70
; elefant_foot_compensation = 0.15
; embedding_wall_into_infill = 0
; enable_arc_fitting = 1
; enable_circle_compensation = 0
; enable_filament_dynamic_map = 0
; enable_height_slowdown = 0
; enable_long_retraction_when_cut = 2
; enable_mixed_color_sublayer = 0
; enable_order_independent_overlap_carving = 0
; enable_overhang_bridge_fan = 1
; enable_overhang_speed = 1
; enable_pre_heating = 0
; enable_pressure_advance = 0
; enable_prime_tower = 0
; enable_support = 0
; enable_support_ironing = 0
; enable_tower_interface_features = 0
; enable_wrapping_detection = 0
; enforce_support_layers = 0
; eng_plate_temp = 70
; eng_plate_temp_initial_layer = 70
; ensure_vertical_shell_thickness = enabled
; exclude_object = 1
; extruder_ams_count = 
; extruder_clearance_dist_to_rod = 36.5
; extruder_clearance_height_to_lid = 141.5
; extruder_clearance_height_to_rod = 32.5
; extruder_clearance_max_radius = 72
; extruder_colour = #018001
; extruder_max_nozzle_count = 1
; extruder_nozzle_stats = 
; extruder_offset = 0x0
; extruder_printable_area = 
; extruder_type = Direct Drive
; extruder_variant_list = "Direct Drive Standard,Direct Drive High Flow,Direct Drive E3D High Flow"
; fan_cooling_layer_time = 20
; fan_direction = right
; fan_max_speed = 60
; fan_min_speed = 30
; farthest_point_timelapse = 1
; filament_adaptive_volumetric_speed = 0
; filament_adhesiveness_category = 300
; filament_bridge_speed = 25
; filament_change_length = 12
; filament_change_length_nc = 10
; filament_colour = #00AE42
; filament_cooling_before_tower = 10
; filament_cost = 19.99
; filament_density = 1.28
; filament_dev_ams_drying_ams_limitations = 1
; filament_dev_ams_drying_heat_distortion_temperature = 75
; filament_dev_ams_drying_temperature = 65
; filament_dev_ams_drying_time = 12
; filament_dev_chamber_drying_bed_temperature = 80
; filament_dev_chamber_drying_time = 12
; filament_dev_drying_cooling_temperature = 55
; filament_dev_drying_softening_temperature = 60
; filament_diameter = 1.75
; filament_enable_overhang_speed = 1
; filament_end_gcode = "; filament end gcode \n\n"
; filament_extruder_compatibility = 0
; filament_extruder_variant = "Direct Drive Standard"
; filament_flow_ratio = 0.95
; filament_flush_temp = 240
; filament_flush_temp_fast = 0
; filament_flush_volumetric_speed = 0
; filament_ids = GFG02
; filament_is_mixed = 0
; filament_is_support = 0
; filament_map = 1
; filament_map_2 = 0
; filament_map_mode = Auto For Flush
; filament_max_volumetric_speed = 10
; filament_metal_stickiness = High
; filament_minimal_purge_on_wipe_tower = 15
; filament_mixed_components = ""
; filament_mixed_gradient = 0
; filament_mixed_gradient_curve = ""
; filament_mixed_gradient_per_part = 0
; filament_mixed_gradient_range = ""
; filament_mixed_sublayer_ratios = ""
; filament_notes = 
; filament_nozzle_map = 0
; filament_overhang_1_4_speed = 0
; filament_overhang_2_4_speed = 50
; filament_overhang_3_4_speed = 30
; filament_overhang_4_4_speed = 10
; filament_overhang_totally_speed = 10
; filament_pre_cooling_temperature = 0
; filament_pre_cooling_temperature_nc = 0
; filament_preheat_temperature_delta = 10
; filament_prime_volume = 30
; filament_prime_volume_nc = 60
; filament_printable = 3
; filament_ramming_travel_time = 0
; filament_ramming_travel_time_nc = 0
; filament_ramming_volumetric_speed = -1
; filament_ramming_volumetric_speed_nc = -1
; filament_retract_length_nc = 14
; filament_retraction_distances_when_cut = 0
; filament_retraction_length = 0.4
; filament_scarf_gap = 0%
; filament_scarf_height = 10%
; filament_scarf_length = 10
; filament_scarf_seam_type = none
; filament_self_index = 1
; filament_settings_id = "Bambu PETG HF @BBL P2S 0.4 nozzle"
; filament_shrink = 100%
; filament_soluble = 0
; filament_start_gcode = "; filament start gcode\n"
; filament_tower_interface_pre_extrusion_dist = 10
; filament_tower_interface_pre_extrusion_length = 0
; filament_tower_interface_print_temp = -1
; filament_tower_interface_purge_volume = 20
; filament_tower_ironing_area = 8
; filament_type = PETG
; filament_velocity_adaptation_factor = 1
; filament_vendor = "Bambu Lab"
; filament_volume_map = 0
; filament_wipe = 1
; filament_wipe_distance = 1
; filament_z_hop_types = Spiral Lift
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; fill_multiline = 1
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; first_x_layer_fan_speed = 0
; first_x_layer_part_fan_speed = 0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1
; flush_multiplier_fast = 1.2
; flush_volumes_matrix = 0,280,280,280,280,0,280,280,280,280,0,280,280,280,280,0
; flush_volumes_vector = 140,140,140,140,140,140,140,140
; full_fan_speed_layer = 0
; fuzzy_skin = none
; fuzzy_skin_first_layer = 0
; fuzzy_skin_mode = displacement
; fuzzy_skin_noise_type = classic
; fuzzy_skin_octaves = 4
; fuzzy_skin_persistence = 0.5
; fuzzy_skin_point_distance = 0.8
; fuzzy_skin_scale = 1
; fuzzy_skin_thickness = 0.3
; gap_infill_speed = 250
; gcode_add_line_number = 0
; gcode_flavor = marlin
; grab_length = 0
; group_algo_with_time = 0
; has_filament_switcher = 0
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 
; hole_coef_1 = 0
; hole_coef_2 = -0.0042
; hole_coef_3 = 0.2006
; hole_limit_max = 0.2
; hole_limit_min = 0.09
; hot_plate_temp = 70
; hot_plate_temp_initial_layer = 70
; hotend_cooling_rate = 2
; hotend_heating_rate = 2
; impact_strength_z = 10.6
; independent_support_layer_height = 1
; infill_combination = 0
; infill_direction = 45
; infill_instead_top_bottom_surfaces = 0
; infill_jerk = 9
; infill_lock_depth = 1
; infill_rotate_step = 0
; infill_shift_step = 0.4
; infill_wall_overlap = 15%
; inherits_group = ;;
; initial_layer_acceleration = 500
; initial_layer_flow_ratio = 1
; initial_layer_infill_speed = 30
; initial_layer_jerk = 9
; initial_layer_line_width = 0.5
; initial_layer_print_height = 0.2
; initial_layer_speed = 20
; initial_layer_travel_acceleration = 6000
; inner_wall_acceleration = 0
; inner_wall_jerk = 9
; inner_wall_line_width = 0.45
; inner_wall_speed = 100
; interface_shells = 0
; interlocking_beam = 0
; interlocking_beam_layer_count = 2
; interlocking_beam_width = 0.8
; interlocking_boundary_avoidance = 2
; interlocking_depth = 2
; interlocking_orientation = 22.5
; internal_bridge_support_thickness = 0.8
; internal_solid_infill_line_width = 0.42
; internal_solid_infill_pattern = zig-zag
; internal_solid_infill_speed = 80
; ironing_direction = 45
; ironing_fan_speed = -1
; ironing_flow = 10%
; ironing_inset = 0.21
; ironing_pattern = zig-zag
; ironing_spacing = 0.15
; ironing_speed = 30
; ironing_type = no ironing
; is_infill_first = 0
; layer_change_gcode = ;======== P2S layer_change gcode ==========\n;===== 2026/05/15 ====\n\n{if (layer_num + 1 == 1)}\n{if (overall_chamber_temperature >= 40)}\n    ;not reset filter fan in first layer\n    ;not reset fan\n{else}\n{if (min_vitrification_temperature > 50)}\n    ;not reset filter fan in first layer\n    ;not reset fan\n{endif}\n{endif}\n{endif}\n\n{if (layer_num + 1 <= close_additional_fan_first_x_layers[current_filament_id])}\n{if (overall_chamber_temperature < 40)}\n    {if (min_vitrification_temperature <= 50)}\n        M106 P2 S{first_x_layer_fan_speed[current_filament_id]*255.0/100.0}\n    {endif}\n{endif}\n    M622.1 S0\n    M1002 judge_flag ventobox_replace_aux1_fan_flag\n    M622 J0\n    M106 P10 S{first_x_layer_fan_speed[current_filament_id]*255.0/100.0}; set first x_layer left aux fan\n    M623\n;not reset fan\n{elsif (layer_num + 1 < additional_fan_full_speed_layer[current_filament_id] && additional_fan_full_speed_layer[current_filament_id] > close_additional_fan_first_x_layers[current_filament_id])}\n{if (overall_chamber_temperature < 40)}\n    {if (min_vitrification_temperature <= 50)}\n        M106 P2 S{(first_x_layer_fan_speed[current_filament_id] + (additional_cooling_fan_speed[current_filament_id] - first_x_layer_fan_speed[current_filament_id]) * (layer_num + 1 - close_additional_fan_first_x_layers[current_filament_id]) / max(additional_fan_full_speed_layer[current_filament_id] - close_additional_fan_first_x_layers[current_filament_id], 1)) * 255.0/100.0}\n    {endif}\n{endif}\n    M622.1 S0\n    M1002 judge_flag ventobox_replace_aux1_fan_flag\n    M622 J0\n    M106 P10 S{(first_x_layer_fan_speed[current_filament_id] + (additional_cooling_fan_speed[current_filament_id] - first_x_layer_fan_speed[current_filament_id]) * (layer_num + 1 - close_additional_fan_first_x_layers[current_filament_id]) / max(additional_fan_full_speed_layer[current_filament_id] - close_additional_fan_first_x_layers[current_filament_id], 1)) * 255.0/100.0}\n    M623\n;not reset fan\n{elsif (layer_num + 1 == max(close_additional_fan_first_x_layers[current_filament_id] + 1, additional_fan_full_speed_layer[current_filament_id]))}\n{if (overall_chamber_temperature < 40)}\n    ;updata chamber autocooling in Xth layer\n    {if (min_vitrification_temperature <= 50)}\n        {if (nozzle_diameter_at_nozzle_id[current_nozzle_id] == 0.2)}\n            M142 P1 R30 S40 U{max_additional_fan/100.0} V1.0 O45; set PLA/TPU ND0.2 chamber autocooling\n        {else}\n            M142 P1 R30 S40 U{max_additional_fan/100.0} V1.0 O45; set PLA/TPU ND0.4 chamber autocooling\n        {endif}\n    {else}\n            ;not reset filter fan in Xth layer\n    {endif}\n{else}\n        ;not reset filter fan in Xth layer\n{endif}\n    M622.1 S0\n    M1002 judge_flag ventobox_replace_aux1_fan_flag\n    M622 J0\n    M106 P10 S{additional_cooling_fan_speed[current_filament_id]*255.0/100.0}; set left aux fan\n    M623\n;not reset fan\n{endif}\n\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change\n\n
; layer_height = 0.2
; line_width = 0.42
; locked_skeleton_infill_pattern = zigzag
; locked_skin_infill_pattern = crosszag
; long_retractions_when_cut = 0
; long_retractions_when_ec = 0
; machine_bed_mass_Y = 0
; machine_end_gcode = ;======== P2S end gcode ==========\n;===== 2026/05/18 =====\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nM211 Z1\n\nG90\nG1 Z{max_layer_z + 0.4} F900 ; lower z a little\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    G150.3\n    M400 ; wait all motion done\n    M991 S0 P-1 ;end smooth timelapse at safe pos\n    M400 S5 ;wait for last picture to be taken\nM623  ;end of \"timelapse_record_flag\n\nG90\nG1 Z{max_layer_z + 10} F900 ; lower z a little\n\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\nM106 P10 S0 ; turn off left aux fan\n\n; pull back filament to AMS\nM620 S65535\nT65535\nG150.1 F8000\nM621 S65535\n\nG150.3\nM104 S0 ; turn off hotend\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (80.0 - max_layer_z/2) > 0}\n    {if (max_layer_z + 80.0 - max_layer_z/2) < 256}\n        G1 Z{max_layer_z + 80.0 - max_layer_z/2} F600\n        G1 Z{max_layer_z + 78.0 - max_layer_z/2}\n    {else}\n        G1 Z256 F600\n        G1 Z256\n    {endif}\n{else}\n    {if (max_layer_z + 4.0) < 256}\n        G1 Z{max_layer_z + 4.0} F600\n        G1 Z{max_layer_z + 2.0}\n    {else}\n        G1 Z256 F600\n        G1 Z256\n    {endif}\n{endif}\nM400 P100\nM17 R ; restore z current\n\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2 R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n\nM1015.3 S0 ;disable clog detect\nM1015.4 S0 K0 ;disable air printing detect\n\n;=====printer finish air purification=========\nM622.1 S0\nM1002 judge_flag print_finish_air_filt_flag\n\nM622 J1\nM1002 gcode_claim_action : 66\nM145 P1\nM106 P2 S255\nM400 S180\nM106 P2 S0\nM623\n\nM622 J2\nM1002 gcode_claim_action : 66\nM145 P0\nM106 P3 S255\nM400 S180\nM106 P3 S0\nM623\n;=====printer finish air purification=========\n\n;=====printer finish  sound=========\nM17\nM400 S1\nM1006 S1\nM1006 A53 B10 L50 C53 D10 M50 E53 F10 N50 \nM1006 A57 B10 L50 C57 D10 M50 E57 F10 N50 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A53 B10 L50 C53 D10 M50 E53 F10 N50 \nM1006 A57 B10 L50 C57 D10 M50 E57 F10 N50 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A48 B10 L50 C48 D10 M50 E48 F10 N50 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A60 B10 L50 C60 D10 M50 E60 F10 N50 \nM1006 W\n;=====printer finish  sound=========\nM400\nM18\n
; machine_hotend_change_time = 0
; machine_load_filament_time = 26
; machine_max_acceleration_e = 5000,5000
; machine_max_acceleration_extruding = 20000,20000
; machine_max_acceleration_retracting = 5000,5000
; machine_max_acceleration_travel = 10000,10000
; machine_max_acceleration_x = 20000,20000
; machine_max_acceleration_y = 20000,20000
; machine_max_acceleration_z = 500,500
; machine_max_force_Y = 0
; machine_max_jerk_e = 2.5,2.5
; machine_max_jerk_x = 9,9
; machine_max_jerk_y = 9,9
; machine_max_jerk_z = 3,3
; machine_max_printed_mass = 0
; machine_max_speed_e = 30,30
; machine_max_speed_x = 600,600
; machine_max_speed_y = 600,600
; machine_max_speed_z = 20,20
; machine_min_extruding_rate = 0
; machine_min_travel_rate = 0
; machine_pause_gcode = M400 U1
; machine_prepare_compensation_time = 370
; machine_start_gcode = ;M1002 set_flag extrude_cali_flag=1\n;M1002 set_flag g29_before_print_flag=1\n;M1002 set_flag auto_cali_toolhead_offset_flag=1\n;M1002 set_flag build_plate_detect_flag=1\n\n;======== P2S start gcode==========\n;===== 2026/05/18 =====\n\n  M140 S[bed_temperature_initial_layer_single] ; heat heatbed first\n  M993 A0 B0 C0 ; nozzle cam detection not allowed.\n  M400\n\n;=====printer start sound ===================\nM17\nM400 S1\nM1006 S1\nM1006 A53 B9 L50 C53 D9 M50 E53 F9 N50\nM1006 A56 B9 L50 C56 D9 M50 E56 F9 N50\nM1006 A61 B9 L50 C61 D9 M50 E61 F9 N50\nM1006 A53 B9 L50 C53 D9 M50 E53 F9 N50\nM1006 A56 B9 L50 C56 D9 M50 E56 F9 N50\nM1006 A61 B18 L50 C61 D18 M50 E61 F18 N50\nM1006 W\n;=====printer start sound ===================\n\n  M620 M ;enable remap\n  G389\n\n;===== avoid end stop =================\n  G91\n  G380 S2 Z22 F1200\n  G380 S2 Z-12 F1200\n  G90\n;===== avoid end stop =================\n\n;===== reset machine status =================\n  M204 S10000\n  M630 S0 P1\n  G90\n  M17 D ; reset motor current to default\n  M960 S5 P1 ; turn on logo lamp\n  G90\n  M220 S100 ;Reset Feedrate\n  M1002 set_gcode_claim_speed_level: 5\n  M221 S100 ;Reset Flowrate\n  M73.2   R1.0 ;Reset left time magnitude\n  G29.1 Z{+0.0} ; clear z-trim value first\n  M983.1 M1\n  M982.2 S1 ; turn on cog noise reduction\n  M983.4 S0\n;===== reset machine status =================\n\n;==== set airduct mode ====\n;==== if Chamber Cooling is necessary ====\n{if (overall_chamber_temperature >= 40)}\nM145 P1 ; set airduct mode to heating mode for heating\nM106 P2 S255 ; turn on filter fan\nM622.1 S0\nM1002 judge_flag ventobox_replace_aux1_fan_flag\nM622 J0\nM106 P10 S0 ; turn off left aux fan\nM623\n{else}\n{if (min_vitrification_temperature <= 50)}\nM145 P0 ; set airduct mode to cooling mode for cooling\nM106 P2 S255 ; turn on auxiliary fan for cooling\nM106 P3 S127 ; turn on chamber fan for cooling\nM1002 gcode_claim_action : 29\nM191 S0 ; wait for chamber temp\nM106 P2 S102 ; turn on chamber cooling fan\nM622.1 S0\nM1002 judge_flag ventobox_replace_aux1_fan_flag\nM622 J0\nM106 P10 S0 ; turn off left aux fan\nM623\nM142 P6 R30 S40 U0.3 V0.8 ; set PETG exhaust chamber autocooling\n{else}\nM145 P1 ; set airduct mode to heating mode for heating\nM106 P2 S127 ; turn on 50% filter fan\nM142 P6 R30 S40 U0.3 V0.8 ; set PLA/TPU exhaust chamber autocooling\n{endif}\n{endif}\n;==== set airduct mode ====\n\n;===== start to heat heatbed & hotend==========\n  M1002 gcode_claim_action : 2\n  M1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\n  M104 S140 A\n\n  G29.2 S0 ; avoid invalid abl data\n\n;===== first homing start =====\n  M1002 gcode_claim_action : 13\n  G28 X T300\n  G150.1 F8000 ; wipe mouth to avoid filament stick to heatbed\n  G150.3\n  M972 S24 P0\n  M972 S26 P0 C0\n  M972 S42 P0 T5000\n  G150.1 F8000 ; wipe mouth to avoid filament stick to heatbed\n  G90\n  G1 X128 Y128 F30000\n  G28 Z P0 T400\n  M400\n;===== first homign end =====\n\n;===== detection start =====\n  M1002 gcode_claim_action : 11\n  M104 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]-80} A ; rise temp in advance\n  M972 S19 P0 T5000 ;plate type detection\n\n  {if max_print_z >= 145}\n    M1002 gcode_claim_action : 75 ;  Detect obstacles at the botton of the heated bed\n    G150.3\n    M104 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]} ; rise temp in advance\n    G3811 Z{max_print_z}  ; Detect obstacles at the bottom of the heated bed\n  {endif}\n;===== detection end =====\n\n;===== prepare print temperature and material ==========\n  M400\n  M211 X0 Y0 Z0 ;turn off soft endstop\n  M975 S1 ; turn on input shaping\n\n  G29.2 S0 ; avoid invalid abl data\n  G150.3\n{if ((filament_type[initial_no_support_filament_id] == \"PLA\") || (filament_type[initial_no_support_filament_id] == \"PLA-CF\") || (filament_type[initial_no_support_filament_id] == \"PETG\")) && (nozzle_diameter_at_nozzle_id[initial_nozzle_id] == 0.2)}\nM620.10 A0 F74.8347 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} T{flush_temperatures[initial_no_support_filament_id]} P{nozzle_temperature_initial_layer[initial_no_support_filament_id]} S1\nM620.10 A1 F74.8347 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} T{flush_temperatures[initial_no_support_filament_id]} P{nozzle_temperature_initial_layer[initial_no_support_filament_id]} S1\n{else}\nM620.10 A0 F{flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60} H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} T{flush_temperatures[initial_no_support_filament_id]} P{nozzle_temperature_initial_layer[initial_no_support_filament_id]} S1\nM620.10 A1 F{flush_volumetric_speeds[initial_no_support_filament_id]/2.4053*60} H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} T{flush_temperatures[initial_no_support_filament_id]} P{nozzle_temperature_initial_layer[initial_no_support_filament_id]} S1\n{endif}\n\n M620.11 P0 L0 I[initial_no_support_filament_id] E0\n M620.11 K0 I[initial_no_support_filament_id] R0\n\n  M620 S[initial_no_support_filament_id]A   ; switch material if AMS exist\n  M1002 gcode_claim_action : 4\n  M1002 set_filament_type:UNKNOWN\n  M400\n  T[initial_no_support_filament_id]\n  M400\n  M628 S0\n  M629\n  M400\n  M1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\n  M621 S[initial_no_support_filament_id]A\n  M104 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]}\n  M400\n  M106 P1 S0\n  M400\n  G29.2 S1\n;===== prepare print temperature and material ==========\n\n\n;===== auto extrude cali start =========================\n  M975 S1\n  M1002 judge_flag extrude_cali_flag\n  M622 J0\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4} A0.4 ; cali dynamic extrusion compensation\n  M623\n\n  M622 J1\n    M1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\n    M1002 gcode_claim_action : 8\n    M109 S{nozzle_temperature[initial_no_support_filament_id]}\n    G90\n    M83\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4} A0.4 ; cali dynamic extrusion compensation\n    M400\n    M106 P1 S255\n    M400 S5\n    M106 P1 S0\n    G150.3\n  M623\n\n  M622 J2\n    M1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\n    M1002 gcode_claim_action : 8\n    M109 S{nozzle_temperature[initial_no_support_filament_id]}\n    G90\n    M83\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2.4} A0.4 ; cali dynamic extrusion compensation\n    M400\n    M106 P1 S255\n    M400 S5\n    M106 P1 S0\n    G150.3\n  M623\n;===== auto extrude cali end =========================\n\n  {if hold_chamber_temp_for_flat_print}\n    M1002 gcode_claim_action : 58\n    M104 S{first_layer_temperature[initial_no_support_filament_id]}\n    {if bed_temperature_initial_layer_single > 89}\n        M1030 S1800\n        SYNC R0 T1800\n    {else}\n        M1030 S300\n        SYNC R0 T300\n    {endif}\n    M1030 C\n  {endif}\n\n  {if filament_type[initial_filament_id] == \"TPU\" || filament_type[initial_filament_id] == \"PVA\"}\n  {else}\n    M83\n    G1 E-3 F1800\n    M400 P500\n  {endif}\n  G150.2\n  G150.1 F8000\n  G150.2\n  G150.1 F8000\n\n  G91\n  G1 Y-16 F12000 ; move away from the trash bin\n  G90\n  M400\n\n  M104 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]-80} A\n\n;===== wipe right nozzle start =====\n  M1002 gcode_claim_action : 14\n  G150 T{nozzle_temperature_initial_layer[initial_no_support_filament_id]}\n  M400\n\n{if filament_type[initial_filament_id] == \"PC\"}\n  M109 S170 A\n{else}\n  M109 S140 A\n{endif}\n  G91\n  G1 Z5 F1200\n  G90\n  M400\n  G150.1\n;===== wipe left nozzle end =====\n\n\n;===== mech mode sweep start =====\n  M1002 gcode_claim_action : 3\n  G90\n  G1 X128 Y128 F20000\n  G1 Z5 F1200\n  M400 P200\n  M970.3 Q1 A5 K0 O1\n  M970.2 Q1 K1 W74 Z0.01\n  M974 Q1 S2 P0\n  M970.3 Q0 A7 K0 O1\n  M970.2 Q0 K1 W74 Z0.01\n  M974 Q0 S2 P0\n  M975 S1\n  M400\n;===== mech mode sweep end =====\n\n;===== bed leveling ==================================\n  M1002 gcode_claim_action : 54\n  M190 S[bed_temperature_initial_layer_single]; ensure bed temp\n  M109 S140 A\n  M106 S0 ; turn off fan , too noisy\n  M1002 judge_flag g29_before_print_flag\n  M622 J1\n    M1002 gcode_claim_action : 1\n    {if hold_chamber_temp_for_flat_print}\n      G29 H\n    {else}\n      G29 A1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    {endif}\n    M400\n  M623\n\n  M622 J2\n    M1002 gcode_claim_action : 1\n    {if hold_chamber_temp_for_flat_print}\n      G29 H\n    {else}\n      G29 A2 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    {endif}\n    M400\n  M623\n\n  M622 J0\n    G28\n  M623\n  G29.2 S1\n  G28\n;===== bed leveling end ================================\n\n  M985.1 U0 E2\n  M985.1 U1 E2\n\n  M104 S{nozzle_temperature_initial_layer[initial_filament_id]} A\n  G150.3 ; move to garbage can to wait for temp\n\n;===== wait temperature reaching the reference value =======\n  M190 S[bed_temperature_initial_layer_single]\n\n  ;========turn off light and fans =============\n  M960 S1 P0 ; turn off laser\n  M960 S2 P0 ; turn off laser\n  M106 S0 ; turn off cooling fan\n\n;===== wait temperature reaching the reference value =======\n\n  M1002 gcode_claim_action : 255\n  M400\n  M975 S1 ; turn on mech mode supression\n\n;============switch again==================\n  M211 X0 Y0 Z0 ;turn off soft endstop\n  G91\n  G1 Z6 F1200\n  G90\n  M1002 set_filament_type:{filament_type[initial_no_support_filament_id]}\n  M620 S[initial_no_support_filament_id]A\n  M400\n  T[initial_no_support_filament_id]\n  M400\n  M628 S0\n  M629\n  M400\n  M621 S[initial_no_support_filament_id]A\n;============switch again==================\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n  {if bed_temperature_initial_layer_single > 89}\n    {if curr_bed_type==\"Textured PEI Plate\"}\n      G29.1 Z{-0.02} ; for Textured PEI Plate\n    {else}\n      G29.1 Z{0.0}\n    {endif}\n  {else}\n    {if curr_bed_type==\"Textured PEI Plate\"}\n      G29.1 Z{0.01} ; for Textured PEI Plate\n    {else}\n      G29.1 Z{0.03}\n    {endif}\n  {endif}\n\n\n;===== nozzle load line ===============================\nM1002 gcode_claim_action : 51\n  G29.2 S1 ; ensure z comp turn on\n  G90\n  M83\n  M400 P50\n  M500 D1\n  M400 S3\n  M109 S{nozzle_temperature_initial_layer[initial_no_support_filament_id]}\n  G0 X100 Y0 F24000\n  M400\n  ;G130 O0 X100 Y-0.4 Z0.8 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2/2.4053} L40 E20 D5\n  G130 O0 X100 Y-0.2 Z0.6 F{filament_max_volumetric_speed[initial_no_support_filament_id]/2/2.4053} L40 E12 D4\n  G90\n  M83\n  G1 Z1\n  M400\n;===== noozle load line end ===========================\nM1002 gcode_claim_action : 0\n  G29.99\n\n{if (filament_type[initial_no_support_filament_id] == \"TPU\") ||\n(filament_type[initial_no_support_filament_id] == \"PLA\") ||  (filament_type[initial_no_support_filament_id] == \"PETG\")}\nM1015.3 S1 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]};enable tpu, pla and petg clog detect\n{else}\nM1015.3 S0;disable clog detect\n{endif}\n\n{if (filament_type[initial_no_support_filament_id] == \"PLA\") ||  (filament_type[initial_no_support_filament_id] == \"PETG\")\n ||  (filament_type[initial_no_support_filament_id] == \"PLA-CF\")  ||  (filament_type[initial_no_support_filament_id] == \"PETG-CF\")}\nM1015.4 S1 K1 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} ;enable E air printing detect\n{else}\nM1015.4 S0 K0 H{nozzle_diameter_at_nozzle_id[initial_nozzle_id]} ;disable E air printing detect\n{endif}\n\nM620.6 I[initial_no_support_filament_id] W1 ;enable ams air printing detect\n\nM1010 Q0 B0.023 S0.01\nM1010 Q1 B0.005 S0.01\nM1010.1 S1\n
; machine_switch_extruder_time = 0
; machine_unload_filament_time = 31
; master_extruder_id = 1
; max_bridge_length = 0
; max_layer_height = 0.28
; max_travel_detour_distance = 0
; min_bead_width = 85%
; min_feature_size = 25%
; min_layer_height = 0.08
; minimum_sparse_infill_area = 15
; mmu_segmented_region_interlocking_depth = 0
; mmu_segmented_region_max_width = 0
; monotonic_travel_into_wall = 45%
; no_slow_down_for_cooling_on_outwalls = 0
; nozzle_diameter = 0.4
; nozzle_flush_dataset = 0
; nozzle_height = 4.2
; nozzle_temperature = 245
; nozzle_temperature_initial_layer = 230
; nozzle_temperature_range_high = 270
; nozzle_temperature_range_low = 230
; nozzle_type = hardened_steel
; nozzle_volume = 110
; nozzle_volume_type = Standard
; only_one_wall_first_layer = 0
; ooze_prevention = 0
; other_layers_print_sequence = 0
; other_layers_print_sequence_nums = 0
; outer_wall_acceleration = 1500
; outer_wall_jerk = 9
; outer_wall_line_width = 0.42
; outer_wall_speed = 60
; overhang_1_4_speed = 0
; overhang_2_4_speed = 50
; overhang_3_4_speed = 30
; overhang_4_4_speed = 10
; overhang_fan_speed = 100
; overhang_fan_threshold = 10%
; overhang_threshold_participating_cooling = 95%
; overhang_totally_speed = 10
; override_filament_scarf_seam_setting = 0
; override_process_overhang_speed = 0
; physical_extruder_map = 0
; post_process = 
; pre_start_fan_time = 0
; precise_outer_wall = 0
; precise_z_height = 0
; pressure_advance = 0.02
; prime_tower_brim_width = 3
; prime_tower_enable_framework = 0
; prime_tower_extra_rib_length = 0
; prime_tower_fillet_wall = 1
; prime_tower_flat_ironing = 1
; prime_tower_infill_gap = 150%
; prime_tower_lift_height = -1
; prime_tower_lift_speed = 90
; prime_tower_max_speed = 90
; prime_tower_rib_wall = 1
; prime_tower_rib_width = 8
; prime_tower_skip_points = 1
; prime_tower_width = 35
; prime_volume_mode = Default
; print_compatible_printers = "Bambu Lab P2S 0.4 nozzle"
; print_extruder_id = 1
; print_extruder_variant = "Direct Drive Standard"
; print_flow_ratio = 1
; print_in_clockwise = 1
; print_sequence = by layer
; print_settings_id = 0.20mm Standard @BBL P2S
; printable_area = 0x0,256x0,256x256,0x256
; printable_height = 256
; printer_extruder_id = 1
; printer_extruder_variant = "Direct Drive Standard"
; printer_model = Bambu Lab P2S
; printer_notes = 
; printer_settings_id = Bambu Lab P2S 0.4 nozzle
; printer_structure = corexy
; printer_technology = FFF
; printer_variant = 0.4
; printing_by_object_gcode = 
; process_notes = 
; raft_contact_distance = 0.1
; raft_expansion = 1.5
; raft_first_layer_density = 90%
; raft_first_layer_expansion = -1
; raft_layers = 0
; reduce_crossing_wall = 0
; reduce_fan_stop_start_freq = 1
; reduce_infill_retraction_mode = Auto
; required_nozzle_HRC = 3
; resolution = 0.012
; retract_before_wipe = 0%
; retract_length_toolchange = 2
; retract_lift_above = 0
; retract_lift_below = 249
; retract_restart_extra = 0
; retract_restart_extra_toolchange = 0
; retract_when_changing_layer = 1
; retraction_distances_when_cut = 18
; retraction_distances_when_ec = 0
; retraction_length = 0.8
; retraction_minimum_travel = 1
; retraction_speed = 30
; role_base_wipe_speed = 1
; scan_first_layer = 0
; scarf_angle_threshold = 155
; seam_gap = 15%
; seam_placement_away_from_overhangs = 0
; seam_position = aligned
; seam_slope_conditional = 1
; seam_slope_entire_loop = 0
; seam_slope_gap = 0
; seam_slope_inner_walls = 1
; seam_slope_min_length = 10
; seam_slope_start_height = 10%
; seam_slope_steps = 10
; seam_slope_type = none
; silent_mode = 0
; single_extruder_multi_material = 1
; skeleton_infill_density = 15%
; skeleton_infill_line_width = 0.45
; skin_infill_density = 15%
; skin_infill_depth = 2
; skin_infill_line_width = 0.45
; skirt_distance = 2
; skirt_height = 1
; skirt_loops = 0
; skirt_per_object = 1
; slice_closing_radius = 0.049
; slicing_mode = regular
; slow_down_for_layer_cooling = 1
; slow_down_layer_time = 10
; slow_down_min_speed = 20
; slowdown_end_acc = 100000
; slowdown_end_height = 400
; slowdown_end_speed = 1000
; slowdown_start_acc = 100000
; slowdown_start_height = 0
; slowdown_start_speed = 1000
; small_perimeter_speed = 50%
; small_perimeter_threshold = 0
; smooth_coefficient = 4
; smooth_speed_discontinuity_area = 1
; solid_infill_filament = 0
; sparse_infill_acceleration = 100%
; sparse_infill_anchor = 400%
; sparse_infill_anchor_max = 20
; sparse_infill_density = 25%
; sparse_infill_filament = 0
; sparse_infill_lattice_angle_1 = -45
; sparse_infill_lattice_angle_2 = 45
; sparse_infill_line_width = 0.45
; sparse_infill_pattern = gyroid
; sparse_infill_speed = 100
; spiral_mode = 0
; spiral_mode_max_xy_smoothing = 200%
; spiral_mode_smooth = 0
; standby_temperature_delta = -5
; start_end_points = 30x-3,54x245
; supertack_plate_temp = 60
; supertack_plate_temp_initial_layer = 60
; support_air_filtration = 0
; support_angle = 0
; support_base_pattern = default
; support_base_pattern_spacing = 2.5
; support_bottom_interface_spacing = 0.5
; support_bottom_z_distance = 0.2
; support_chamber_temp_control = 0
; support_cooling_filter = 0
; support_critical_regions_only = 0
; support_expansion = 0
; support_fast_purge_mode = 0
; support_filament = 0
; support_interface_bottom_layers = 2
; support_interface_filament = 0
; support_interface_loop_pattern = 0
; support_interface_not_for_body = 1
; support_interface_pattern = auto
; support_interface_spacing = 0.4
; support_interface_speed = 40
; support_interface_top_layers = 3
; support_ironing_direction = 0
; support_ironing_flow = 10%
; support_ironing_inset = 0
; support_ironing_pattern = zig-zag
; support_ironing_spacing = 0.15
; support_ironing_speed = 30
; support_line_width = 0.42
; support_object_first_layer_gap = 0.2
; support_object_skip_flush = 1
; support_object_xy_distance = 0.4
; support_on_build_plate_only = 1
; support_remove_small_overhang = 1
; support_speed = 60
; support_style = default
; support_threshold_angle = 30
; support_top_z_distance = 0.2
; support_type = tree(auto)
; symmetric_infill_y_axis = 0
; temperature_vitrification = 70
; template_custom_gcode = 
; textured_plate_temp = 70
; textured_plate_temp_initial_layer = 70
; thick_bridges = 0
; thumbnail_size = 50x50
; time_lapse_gcode = ;======== P2S timelapes gcode ==========\n;===== 2025/06/16 ====\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firware, default turned on\n\nM1002 judge_flag timelapse_record_flag\nM622 J1\n{if timelapse_type == 0} ; timelapse without wipe tower\n  M971 S11 C10 O0\n  M1004 S5 P1  ; external shutter\n{elsif timelapse_type == 1} ; timelapse with wipe tower\n  G150.3 ; move to garbage can\n  M400\n  M1004 S5 P1  ; external shutter\n  M400 P300\n  M971 S11 C10 O0\n  M400 P350\n  \n  G90\n  G1 Z{max_layer_z + 3.0} F1200\n  G1 Y247 F30000\n  G1 Y217 F18000\n{endif}\nM623\n; SKIPPABLE_END\n
; timelapse_type = 0
; top_area_threshold = 200%
; top_color_penetration_layers = 5
; top_one_wall_type = all top
; top_shell_layers = 5
; top_shell_thickness = 1
; top_solid_infill_flow_ratio = 1
; top_surface_acceleration = 2000
; top_surface_density = 100%
; top_surface_jerk = 9
; top_surface_line_width = 0.42
; top_surface_pattern = monotonicline
; top_surface_speed = 60
; top_z_overrides_xy_distance = 0
; travel_acceleration = 10000
; travel_jerk = 9
; travel_short_distance_acceleration = 250
; travel_speed = 200
; travel_speed_z = 0
; tree_support_branch_angle = 45
; tree_support_branch_diameter = 2
; tree_support_branch_diameter_angle = 5
; tree_support_branch_distance = 5
; tree_support_wall_count = -1
; upward_compatible_machine = "Bambu Lab A1 0.4 nozzle";"Bambu Lab H2S 0.4 nozzle";"Bambu Lab H2D 0.4 nozzle";"Bambu Lab H2D Pro 0.4 nozzle";"Bambu Lab H2C 0.4 nozzle";"Bambu Lab X2D 0.4 nozzle";"Bambu Lab A2L 0.4 nozzle"
; use_firmware_retraction = 0
; use_relative_e_distances = 1
; vertical_shell_speed = 80%
; volumetric_speed_coefficients = "0 0 0 0 0 0"
; wall_distribution_count = 1
; wall_filament = 0
; wall_generator = arachne
; wall_loops = 5
; wall_sequence = inner wall/outer wall
; wall_transition_angle = 10
; wall_transition_filter_deviation = 25%
; wall_transition_length = 100%
; wipe = 1
; wipe_distance = 2
; wipe_speed = 80%
; wipe_tower_no_sparse_layers = 0
; wipe_tower_rotation_angle = 0
; wipe_tower_x = 15
; wipe_tower_y = 220
; wrapping_detection_gcode = ;======== P2S 20250822 clumping ========\n{if !spiral_mode}\n    M622.1 S0 ; for previous firmware, default turn off\n    M1002 set_flag g39_forced_detection_flag=1\n    M1002 judge_flag g39_forced_detection_flag\n    M622 J1\n        {if layer_num == 3 || layer_num == 10 || layer_num == 19}\n            M993 A2 B2 C2 ; nozzle cam detection allow status save.\n            M993 A0 B0 C0 ; nozzle cam detection not allowed.\n\n            M400 P100\n\n            G39\n\n            G90\n            G1 Y247 F30000\n            G1 Y217 F18000\n            \n            M993 A3 B3 C3 ; nozzle cam detection allow status restore.\n        {endif}\n    M623\n{endif}
; wrapping_detection_layers = 20
; wrapping_exclude_area = 153x256,216x256,216x235,153x235
; xy_contour_compensation = 0
; xy_hole_compensation = 0
; z_direction_outwall_speed_continuous = 0
; z_hop = 0.4
; z_hop_types = Auto Lift
; CONFIG_BLOCK_END

; EXECUTABLE_BLOCK_START
M73 P0 R18
M201 X20000 Y20000 Z500 E5000
M203 X600 Y600 Z20 E30
M204 P20000 R5000 T20000
M205 X9.00 Y9.00 Z3.00 E2.50
M106 S0
M106 P2 S0
; FEATURE: Custom
;M1002 set_flag extrude_cali_flag=1
;M1002 set_flag g29_before_print_flag=1
;M1002 set_flag auto_cali_toolhead_offset_flag=1
;M1002 set_flag build_plate_detect_flag=1

;======== P2S start gcode==========
;===== 2026/05/18 =====

  M140 S70 ; heat heatbed first
  M993 A0 B0 C0 ; nozzle cam detection not allowed.
  M400

;=====printer start sound ===================
M17
M400 S1
M1006 S1
M1006 A53 B9 L50 C53 D9 M50 E53 F9 N50
M1006 A56 B9 L50 C56 D9 M50 E56 F9 N50
M1006 A61 B9 L50 C61 D9 M50 E61 F9 N50
M1006 A53 B9 L50 C53 D9 M50 E53 F9 N50
M1006 A56 B9 L50 C56 D9 M50 E56 F9 N50
M1006 A61 B18 L50 C61 D18 M50 E61 F18 N50
M1006 W
;=====printer start sound ===================

  M620 M ;enable remap
  G389

;===== avoid end stop =================
  G91
  G380 S2 Z22 F1200
  G380 S2 Z-12 F1200
  G90
;===== avoid end stop =================

;===== reset machine status =================
  M204 S10000
  M630 S0 P1
  G90
  M17 D ; reset motor current to default
  M960 S5 P1 ; turn on logo lamp
  G90
  M220 S100 ;Reset Feedrate
  M1002 set_gcode_claim_speed_level: 5
  M221 S100 ;Reset Flowrate
  M73.2   R1.0 ;Reset left time magnitude
  G29.1 Z0 ; clear z-trim value first
  M983.1 M1
  M982.2 S1 ; turn on cog noise reduction
  M983.4 S0
;===== reset machine status =================

;==== set airduct mode ====
;==== if Chamber Cooling is necessary ====


M145 P1 ; set airduct mode to heating mode for heating
M106 P2 S127 ; turn on 50% filter fan
M142 P6 R30 S40 U0.3 V0.8 ; set PLA/TPU exhaust chamber autocooling


;==== set airduct mode ====

;===== start to heat heatbed & hotend==========
  M1002 gcode_claim_action : 2
  M1002 set_filament_type:PETG
  M104 S140 A

  G29.2 S0 ; avoid invalid abl data

;===== first homing start =====
  M1002 gcode_claim_action : 13
  G28 X T300
  G150.1 F8000 ; wipe mouth to avoid filament stick to heatbed
  G150.3
  M972 S24 P0
  M972 S26 P0 C0
  M972 S42 P0 T5000
  G150.1 F8000 ; wipe mouth to avoid filament stick to heatbed
  G90
  G1 X128 Y128 F30000
  G28 Z P0 T400
  M400
;===== first homign end =====

;===== detection start =====
  M1002 gcode_claim_action : 11
  M104 S150 A ; rise temp in advance
  M972 S19 P0 T5000 ;plate type detection

  
;===== detection end =====

;===== prepare print temperature and material ==========
  M400
  M211 X0 Y0 Z0 ;turn off soft endstop
  M975 S1 ; turn on input shaping

  G29.2 S0 ; avoid invalid abl data
  G150.3

M620.10 A0 F249.449 H0.4 T240 P230 S1
M620.10 A1 F249.449 H0.4 T240 P230 S1


 M620.11 P0 L0 I0 E0
 M620.11 K0 I0 R0

  M620 S0A   ; switch material if AMS exist
  M1002 gcode_claim_action : 4
  M1002 set_filament_type:UNKNOWN
  M400
  T0
  M400
  M628 S0
  M629
  M400
  M1002 set_filament_type:PETG
  M621 S0A
  M104 S230
  M400
  M106 P1 S0
  M400
  G29.2 S1
;===== prepare print temperature and material ==========


;===== auto extrude cali start =========================
  M975 S1
  M1002 judge_flag extrude_cali_flag
  M622 J0
    M983.3 F4.16667 A0.4 ; cali dynamic extrusion compensation
  M623

  M622 J1
    M1002 set_filament_type:PETG
    M1002 gcode_claim_action : 8
    M109 S245
    G90
    M83
    M983.3 F4.16667 A0.4 ; cali dynamic extrusion compensation
    M400
    M106 P1 S255
    M400 S5
    M106 P1 S0
    G150.3
  M623

  M622 J2
    M1002 set_filament_type:PETG
    M1002 gcode_claim_action : 8
    M109 S245
    G90
    M83
    M983.3 F4.16667 A0.4 ; cali dynamic extrusion compensation
    M400
    M106 P1 S255
    M400 S5
    M106 P1 S0
    G150.3
  M623
;===== auto extrude cali end =========================

  

  
    M83
    G1 E-3 F1800
    M400 P500
  
  G150.2
  G150.1 F8000
  G150.2
  G150.1 F8000

  G91
  G1 Y-16 F12000 ; move away from the trash bin
  G90
  M400

  M104 S150 A

;===== wipe right nozzle start =====
  M1002 gcode_claim_action : 14
  G150 T230
  M400


  M109 S140 A

  G91
M73 P2 R18
  G1 Z5 F1200
  G90
  M400
  G150.1
;===== wipe left nozzle end =====


;===== mech mode sweep start =====
  M1002 gcode_claim_action : 3
  G90
M73 P3 R17
  G1 X128 Y128 F20000
  G1 Z5 F1200
  M400 P200
  M970.3 Q1 A5 K0 O1
  M970.2 Q1 K1 W74 Z0.01
  M974 Q1 S2 P0
  M970.3 Q0 A7 K0 O1
  M970.2 Q0 K1 W74 Z0.01
  M974 Q0 S2 P0
  M975 S1
  M400
;===== mech mode sweep end =====

;===== bed leveling ==================================
  M1002 gcode_claim_action : 54
  M190 S70; ensure bed temp
  M109 S140 A
  M106 S0 ; turn off fan , too noisy
  M1002 judge_flag g29_before_print_flag
  M622 J1
    M1002 gcode_claim_action : 1
    
      G29 A1 X94.6 Y116 I69.4 J24
    
    M400
  M623

  M622 J2
    M1002 gcode_claim_action : 1
    
      G29 A2 X94.6 Y116 I69.4 J24
    
    M400
  M623

  M622 J0
    G28
  M623
  G29.2 S1
  G28
;===== bed leveling end ================================

  M985.1 U0 E2
  M985.1 U1 E2

  M104 S230 A
  G150.3 ; move to garbage can to wait for temp

;===== wait temperature reaching the reference value =======
  M190 S70

  ;========turn off light and fans =============
  M960 S1 P0 ; turn off laser
  M960 S2 P0 ; turn off laser
  M106 S0 ; turn off cooling fan

;===== wait temperature reaching the reference value =======

  M1002 gcode_claim_action : 255
  M400
  M975 S1 ; turn on mech mode supression

;============switch again==================
  M211 X0 Y0 Z0 ;turn off soft endstop
  G91
  G1 Z6 F1200
  G90
  M1002 set_filament_type:PETG
  M620 S0A
  M400
  T0
  M400
  M628 S0
  M629
  M400
  M621 S0A
;============switch again==================

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
  
    
      G29.1 Z0.01 ; for Textured PEI Plate
    
  


;===== nozzle load line ===============================
M1002 gcode_claim_action : 51
  G29.2 S1 ; ensure z comp turn on
  G90
  M83
  M400 P50
  M500 D1
  M400 S3
  M109 S230
  G0 X100 Y0 F24000
  M400
  ;G130 O0 X100 Y-0.4 Z0.8 F2.07874 L40 E20 D5
  G130 O0 X100 Y-0.2 Z0.6 F2.07874 L40 E12 D4
  G90
  M83
  G1 Z1
  M400
;===== noozle load line end ===========================
M1002 gcode_claim_action : 0
  G29.99


M1015.3 S1 H0.4;enable tpu, pla and petg clog detect



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I0 W1 ;enable ams air printing detect

M1010 Q0 B0.023 S0.01
M1010 Q1 B0.005 S0.01
M1010.1 S1
; MACHINE_START_GCODE_END
; filament start gcode
;VT0 H-1
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.4 F1800
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====




    ;not reset filter fan in first layer
    ;not reset fan






    

    M622.1 S0
    M1002 judge_flag ventobox_replace_aux1_fan_flag
    M622 J0
    M106 P10 S0; set first x_layer left aux fan
    M623
;not reset fan


; update layer progress
M73 L1
M991 S0 P0 ;notify layer change


M106 S0
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M73 P37 R11
G1 X162.682 Y117.317 F12000
M204 S6000
G1 Z.4
G1 Z.2
M73 P38 R11
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.50604
G1 F1200
M204 S500
G1 X161.738 Y117.317 E.03453
G1 X162.135 Y117.567 E.01718
G1 X162.379 Y117.801 E.01237
G1 X162.682 Y118.256 E.01997
G1 X162.682 Y117.377 E.03214
; WIPE_START
G1 X161.738 Y117.317 E-.35941
G1 X161.784 Y117.346 E-.02059
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I-1.216 J.054 P1  F12000
G1 X162.683 Y137.718 Z.6
G1 Z.2
G1 E.4 F1800
; LINE_WIDTH: 0.49989
G1 F1200
M204 S500
G1 X162.384 Y138.186 E.02004
G1 X162.093 Y138.465 E.01453
G1 X161.723 Y138.686 E.01557
G1 X162.683 Y138.686 E.03464
G1 X162.683 Y137.778 E.03277
; WIPE_START
G1 X162.384 Y138.186 E-.19212
G1 X162.093 Y138.465 E-.15297
G1 X162.014 Y138.512 E-.03491
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I-.009 J-1.217 P1  F12000
G1 X138.26 Y138.682 Z.6
G1 Z.2
G1 E.4 F1800
; LINE_WIDTH: 0.50726
G1 F1200
M204 S500
G3 X137.635 Y138.212 I.861 J-1.797 E.02888
G1 X137.318 Y137.745 E.02069
G1 X137.318 Y138.682 E.03436
G1 X138.2 Y138.682 E.03237
; WIPE_START
G1 X137.912 Y138.469 E-.13646
G1 X137.635 Y138.212 E-.14338
G1 X137.487 Y137.994 E-.10017
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.216 J.046 P1  F12000
G1 X138.266 Y117.314 Z.6
G1 Z.2
G1 E.4 F1800
; LINE_WIDTH: 0.49997
G1 F1200
M204 S500
G1 X137.317 Y117.314 E.03426
G1 X137.317 Y118.286 E.03509
G1 X137.617 Y117.814 E.0202
G3 X138.213 Y117.341 I1.578 J1.379 E.02761
; WIPE_START
G1 X137.317 Y117.314 E-.34055
G1 X137.317 Y117.418 E-.03945
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I-.012 J1.217 P1  F12000
G1 X161.381 Y117.653 Z.6
G1 Z.2
G1 E.4 F1800
; LINE_WIDTH: 0.584124
G1 F1200
M204 S500
G1 X161.245 Y117.588 E.00646
; LINE_WIDTH: 0.62619
G1 X161.065 Y117.502 E.0092
G1 X160.803 Y117.486 E.01207
; LINE_WIDTH: 0.61439
G1 X139.193 Y117.486 E.97553
; LINE_WIDTH: 0.62035
G2 X138.875 Y117.564 I-.029 J.566 E.01515
; LINE_WIDTH: 0.58023
G1 X138.691 Y117.634 E.00838
; LINE_WIDTH: 0.54011
G1 X138.506 Y117.703 E.00775
; LINE_WIDTH: 0.49999
G1 X138.044 Y118.014 E.0201
G1 X137.762 Y118.392 E.01702
; LINE_WIDTH: 0.542517
G1 X137.675 Y118.59 E.00853
; LINE_WIDTH: 0.585044
G1 X137.588 Y118.787 E.00925
; LINE_WIDTH: 0.62757
G2 X137.487 Y119.16 I.479 J.329 E.01817
; LINE_WIDTH: 0.61424
G1 X137.486 Y136.805 E.79632
; LINE_WIDTH: 0.64493
G1 X137.528 Y137.222 E.01995
G1 X137.57 Y137.288 E.00371
; LINE_WIDTH: 0.60547
G1 X137.612 Y137.354 E.00346
; LINE_WIDTH: 0.56601
G1 X137.654 Y137.42 E.00322
; LINE_WIDTH: 0.52655
G1 X137.948 Y137.874 E.02069
; LINE_WIDTH: 0.49999
G2 X138.454 Y138.271 I1.245 J-1.066 E.02338
; LINE_WIDTH: 0.54052
G1 X138.634 Y138.349 E.00769
; LINE_WIDTH: 0.58105
G1 X138.813 Y138.427 E.00832
; LINE_WIDTH: 0.62158
G2 X139.193 Y138.514 I.307 J-.462 E.01822
; LINE_WIDTH: 0.61585
G1 X160.878 Y138.512 E.98139
G1 X161.063 Y138.479 E.00851
; LINE_WIDTH: 0.59723
G1 X161.324 Y138.366 E.01245
; LINE_WIDTH: 0.54861
G1 X161.585 Y138.254 E.01136
; LINE_WIDTH: 0.49999
G1 X161.957 Y137.986 E.01655
G1 X162.236 Y137.611 E.01686
; LINE_WIDTH: 0.54777
G1 X162.357 Y137.338 E.01193
; LINE_WIDTH: 0.59555
G1 X162.478 Y137.064 E.01305
; LINE_WIDTH: 0.6143
G1 X162.511 Y136.878 E.00854
G1 X162.514 Y119.197 E.79805
; LINE_WIDTH: 0.64406
G1 X162.472 Y118.78 E.01986
G1 X162.38 Y118.625 E.00857
; LINE_WIDTH: 0.596037
G1 X162.288 Y118.47 E.00788
; LINE_WIDTH: 0.548014
G1 X162.195 Y118.315 E.0072
; LINE_WIDTH: 0.49999
G1 X161.971 Y118.047 E.01262
G1 X161.605 Y117.76 E.01679
; LINE_WIDTH: 0.542057
G1 X161.435 Y117.679 E.00742
M204 S6000
G1 X161.175 Y118.08 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.49999
G1 F1200
M204 S500
G1 X161.079 Y118.036 E.00379
G1 X160.803 Y118 E.01003
G1 X139.193 Y118 E.78024
G1 X138.823 Y118.063 E.01356
G1 X138.422 Y118.29 E.01662
G1 X138.132 Y118.661 E.01699
G1 X138.001 Y119.16 E.01864
G1 X138 Y136.805 E.63708
G1 X138.051 Y137.138 E.01217
G1 X138.259 Y137.539 E.0163
G1 X138.535 Y137.795 E.01362
G1 X138.973 Y137.975 E.01706
G1 X139.193 Y138 E.00802
G1 X160.878 Y137.997 E.78294
G1 X161.263 Y137.904 E.01429
G1 X161.586 Y137.704 E.01374
G1 X161.867 Y137.342 E.01651
G1 X161.997 Y136.878 E.01742
G1 X162 Y119.197 E.63839
M73 P39 R11
G1 X161.95 Y118.864 E.01216
G1 X161.788 Y118.523 E.0136
G1 X161.5 Y118.228 E.0149
G1 X161.229 Y118.105 E.01074
; WIPE_START
G1 X161.079 Y118.036 E-.06274
G1 X160.803 Y118 E-.10561
G1 X160.246 Y118 E-.21166
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I.439 J1.135 P1  F12000
G1 X162.987 Y116.94 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F1200
M204 S500
G1 X162.979 Y116.931 E.00043
G1 X162.729 Y116.857 E.00944
G1 X161.786 Y116.857 E.03404
; LINE_WIDTH: 0.542057
G1 X161.555 Y116.878 E.00914
; LINE_WIDTH: 0.584124
G1 X161.324 Y116.899 E.00991
; LINE_WIDTH: 0.62619
G3 X160.803 Y116.914 I-.328 J-2.324 E.02406
; LINE_WIDTH: 0.61439
G1 X139.193 Y116.914 E.97553
G1 X138.933 Y116.89 E.01178
; LINE_WIDTH: 0.566025
G1 X138.673 Y116.866 E.01079
; LINE_WIDTH: 0.51766
G1 X137.89 Y116.857 E.02938
; LINE_WIDTH: 0.49999
G1 X137.264 Y116.857 E.02262
G1 X137.035 Y116.922 E.00858
G1 X136.897 Y117.068 E.00723
G1 X136.86 Y117.299 E.00846
G1 X136.86 Y118.099 E.02888
; LINE_WIDTH: 0.50699
G1 X136.864 Y118.541 E.01622
; LINE_WIDTH: 0.547184
G1 X136.884 Y118.667 E.00505
; LINE_WIDTH: 0.587377
G1 X136.904 Y118.792 E.00545
; LINE_WIDTH: 0.62757
G3 X136.917 Y119.16 I-.958 J.218 E.01712
; LINE_WIDTH: 0.61424
G1 X136.915 Y136.805 E.79632
; LINE_WIDTH: 0.64615
G1 X136.93 Y137.285 E.02288
G1 X136.906 Y137.493 E.01
; LINE_WIDTH: 0.59743
G1 X136.882 Y137.702 E.0092
; LINE_WIDTH: 0.54871
G1 X136.857 Y137.91 E.00839
; LINE_WIDTH: 0.49999
G1 X136.857 Y138.743 E.03006
G1 X136.943 Y139.012 E.0102
G1 X137.116 Y139.125 E.00744
G1 X137.828 Y139.143 E.02572
; LINE_WIDTH: 0.53394
G1 X138.683 Y139.126 E.03319
; LINE_WIDTH: 0.574165
G1 X138.938 Y139.106 E.01073
; LINE_WIDTH: 0.61439
G1 X139.193 Y139.086 E.01154
; LINE_WIDTH: 0.61585
G1 X160.878 Y139.085 E.9814
G1 X161.079 Y139.104 E.00913
; LINE_WIDTH: 0.57723
G1 X161.28 Y139.124 E.00851
; LINE_WIDTH: 0.53861
G1 X161.48 Y139.143 E.0079
; LINE_WIDTH: 0.49999
G1 X162.736 Y139.143 E.04535
G1 X162.965 Y139.078 E.00858
; object ids of layer 1 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer1 end: 47,58
M625
G1 X163.103 Y138.932 E.00724
G1 X163.14 Y138.701 E.00847
G1 X163.14 Y137.485 E.0439
; LINE_WIDTH: 0.538094
G1 X163.121 Y137.283 E.00795
; LINE_WIDTH: 0.576197
G1 X163.102 Y137.08 E.00856
; LINE_WIDTH: 0.6143
G1 X163.083 Y136.878 E.00917
G1 X163.085 Y119.197 E.79805
; LINE_WIDTH: 0.64406
G3 X163.094 Y118.518 I2.35 J-.308 E.03235
; LINE_WIDTH: 0.596037
G1 X163.118 Y118.303 E.00946
; LINE_WIDTH: 0.548014
G1 X163.142 Y118.087 E.00864
; LINE_WIDTH: 0.49999
G1 X163.142 Y117.278 E.02922
G1 X163.109 Y117.081 E.00721
G1 X163.026 Y116.986 E.00457
M204 S6000
G1 X163.357 Y116.634 F12000
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X163.105 Y116.465 E.01097
G1 X162.684 Y116.4 E.01538
G1 X137.223 Y116.4 E.91926
G1 X136.927 Y116.453 E.01088
G1 X136.659 Y116.617 E.01132
G1 X136.476 Y116.869 E.01126
G1 X136.403 Y117.259 E.01431
G1 X136.4 Y138.779 E.777
G1 X136.442 Y139.045 E.00973
G1 X136.577 Y139.296 E.01028
G1 X136.758 Y139.463 E.0089
G1 X137.111 Y139.585 E.01349
G1 X137.828 Y139.6 E.02589
G1 X162.777 Y139.6 E.90078
G1 X163.073 Y139.547 E.01088
G1 X163.34 Y139.384 E.01131
G1 X163.523 Y139.131 E.01126
G1 X163.597 Y138.741 E.01432
G1 X163.599 Y117.278 E.77493
G1 X163.537 Y116.899 E.01387
G1 X163.392 Y116.683 E.00941
; OBJECT_ID: 47
; WIPE_START
G1 X163.105 Y116.465 E-.13687
G1 X162.684 Y116.4 E-.16183
G1 X162.47 Y116.4 E-.0813
; WIPE_END
M73 P40 R11
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S6000
G17
G3 Z.6 I-.489 J-1.115 P1  F12000
G1 X116.533 Y136.541 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F1200
M204 S500
G1 X116.541 Y136.023 E.01871
; LINE_WIDTH: 0.5404
G1 X116.521 Y135.799 E.00884
; LINE_WIDTH: 0.58081
G1 X116.501 Y135.575 E.00956
; LINE_WIDTH: 0.62122
G3 X116.484 Y135.171 I1.789 J-.274 E.01847
; LINE_WIDTH: 0.61402
G1 X116.485 Y120.829 E.64705
G1 X116.504 Y120.545 E.0128
; LINE_WIDTH: 0.57601
G1 X116.523 Y120.262 E.01195
; LINE_WIDTH: 0.538
G1 X116.542 Y119.979 E.0111
; LINE_WIDTH: 0.49999
G1 X116.542 Y119.473 E.01826
G1 X116.024 Y119.461 E.0187
; LINE_WIDTH: 0.53745
G1 X115.74 Y119.48 E.01113
; LINE_WIDTH: 0.57491
G1 X115.456 Y119.499 E.01197
; LINE_WIDTH: 0.61237
G1 X115.172 Y119.517 E.01281
; LINE_WIDTH: 0.61424
G1 X96.829 Y119.514 E.82783
G1 X96.545 Y119.495 E.01283
; LINE_WIDTH: 0.576157
G1 X96.262 Y119.476 E.01197
; LINE_WIDTH: 0.538074
G1 X95.978 Y119.457 E.01112
; LINE_WIDTH: 0.49999
G1 X95.463 Y119.461 E.01858
G1 X95.459 Y119.976 E.01858
; LINE_WIDTH: 0.537807
G1 X95.478 Y120.26 E.01113
; LINE_WIDTH: 0.575624
G1 X95.497 Y120.544 E.01199
; LINE_WIDTH: 0.61344
G1 X95.516 Y120.829 E.01284
; LINE_WIDTH: 0.6143
G1 X95.514 Y135.171 E.64737
G1 X95.495 Y135.455 E.01285
; LINE_WIDTH: 0.576197
G1 X95.476 Y135.739 E.01199
; LINE_WIDTH: 0.538094
G1 X95.457 Y136.023 E.01113
; LINE_WIDTH: 0.49999
G1 X95.46 Y136.536 E.0185
G1 X95.977 Y136.543 E.01863
; LINE_WIDTH: 0.5381
G1 X96.261 Y136.524 E.01113
; LINE_WIDTH: 0.57621
G1 X96.545 Y136.505 E.01199
; LINE_WIDTH: 0.61432
G1 X96.829 Y136.486 E.01285
G1 X115.171 Y136.484 E.82794
; LINE_WIDTH: 0.61345
G1 X115.455 Y136.503 E.01282
; LINE_WIDTH: 0.57563
G1 X115.739 Y136.522 E.01197
; LINE_WIDTH: 0.53781
G1 X116.023 Y136.541 E.01112
; LINE_WIDTH: 0.49999
G1 X116.473 Y136.541 E.01626
M204 S6000
G1 X116.821 Y136.925 F12000
; FEATURE: Outer wall
M73 P40 R10
G1 F1200
M204 S500
G1 X116.959 Y136.732 E.00856
G1 X116.998 Y136.532 E.00738
G1 X116.999 Y119.473 E.61589
G1 X116.942 Y119.207 E.00985
G1 X116.818 Y119.073 E.0066
G1 X116.53 Y119.004 E.01068
G1 X95.416 Y119 E.76236
G1 X95.182 Y119.071 E.00882
G1 X95.066 Y119.191 E.00601
G1 X95.002 Y119.461 E.01003
G1 X95 Y136.576 E.61795
G1 X95.06 Y136.792 E.00808
G1 X95.236 Y136.959 E.00874
G1 X95.48 Y137 E.00894
G1 X116.61 Y136.998 E.76288
G1 X116.765 Y136.945 E.00592
; WIPE_START
G1 X116.959 Y136.732 E-.10941
G1 X116.998 Y136.532 E-.07766
G1 X116.998 Y136.024 E-.19294
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I.033 J-1.217 P1  F12000
G1 X96.199 Y135.451 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.58139
G1 F1200
M204 S500
G1 X96.26 Y135.538 E.00449
; LINE_WIDTH: 0.54069
G1 X96.344 Y135.656 E.00571
; LINE_WIDTH: 0.5381
G1 X96.505 Y135.742 E.00716
; LINE_WIDTH: 0.57621
G1 X96.667 Y135.828 E.00771
; LINE_WIDTH: 0.61432
G1 X96.829 Y135.914 E.00826
G1 X115.171 Y135.914 E.82794
; LINE_WIDTH: 0.62123
G2 X115.419 Y135.823 I.051 J-.245 E.01269
; LINE_WIDTH: 0.580817
G1 X115.538 Y135.74 E.00616
; LINE_WIDTH: 0.5404
G2 X115.74 Y135.538 I-.18 J-.382 E.01145
; LINE_WIDTH: 0.58081
G1 X115.823 Y135.419 E.00616
; LINE_WIDTH: 0.62122
G2 X115.914 Y135.171 I-.154 J-.197 E.01269
; LINE_WIDTH: 0.61402
G1 X115.914 Y120.829 E.64705
G1 X115.828 Y120.667 E.00824
; LINE_WIDTH: 0.57601
G1 X115.743 Y120.506 E.00769
; LINE_WIDTH: 0.538
G1 X115.657 Y120.345 E.00714
; LINE_WIDTH: 0.53745
G1 X115.495 Y120.259 E.00716
; LINE_WIDTH: 0.57491
G1 X115.333 Y120.173 E.00771
; LINE_WIDTH: 0.61237
M73 P41 R10
G1 X115.171 Y120.087 E.00825
; LINE_WIDTH: 0.61424
G1 X96.829 Y120.086 E.82782
; LINE_WIDTH: 0.62203
G2 X96.581 Y120.176 I-.051 J.244 E.0127
; LINE_WIDTH: 0.58135
G1 X96.463 Y120.26 E.00616
; LINE_WIDTH: 0.54067
G1 X96.344 Y120.343 E.0057
; LINE_WIDTH: 0.537807
G1 X96.258 Y120.505 E.00716
; LINE_WIDTH: 0.575624
G1 X96.172 Y120.667 E.00771
; LINE_WIDTH: 0.61344
G1 X96.086 Y120.829 E.00826
; LINE_WIDTH: 0.6143
G1 X96.086 Y135.171 E.64737
; LINE_WIDTH: 0.62209
G2 X96.161 Y135.406 I.244 J.051 E.0118
M204 S6000
G1 X96.013 Y135.961 F12000
; LINE_WIDTH: 0.62458
G1 F1200
M204 S500
G2 X96.049 Y136.024 I-.032 J.06 E.01617
; WIPE_START
G1 X96.013 Y136.086 E-.076
G1 X95.94 Y136.086 E-.076
G1 X95.904 Y136.024 E-.076
G1 X95.94 Y135.961 E-.076
G1 X96.013 Y135.961 E-.076
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1 J.693 P1  F12000
G1 X96.6 Y135.113 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.49999
G1 F1200
M204 S500
G1 X96.6 Y135.171 E.0021
G1 X96.667 Y135.333 E.00632
G1 X96.829 Y135.4 E.00632
G1 X115.171 Y135.4 E.66228
G1 X115.333 Y135.333 E.00632
G1 X115.4 Y135.171 E.00631
G1 X115.4 Y120.829 E.51786
G1 X115.333 Y120.667 E.0063
G1 X115.172 Y120.6 E.00633
G1 X96.829 Y120.6 E.66228
G1 X96.667 Y120.667 E.00631
G1 X96.6 Y120.829 E.00632
G1 X96.6 Y135.053 E.51359
; WIPE_START
G1 X96.6 Y135.171 E-.04486
G1 X96.667 Y135.333 E-.06647
G1 X96.829 Y135.4 E-.06647
G1 X97.361 Y135.4 E-.20221
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.212 J-.105 P1  F12000
G1 X96.014 Y119.913 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.6234
G1 F1200
M204 S500
G2 X96.05 Y119.976 I-.032 J.06 E.0161
; WIPE_START
G1 X96.014 Y120.039 E-.076
G1 X95.942 Y120.039 E-.076
G1 X95.905 Y119.976 E-.076
G1 X95.942 Y119.913 E-.076
G1 X96.014 Y119.913 E-.076
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I0 J1.217 P1  F12000
G1 X116.06 Y119.917 Z.6
G1 Z.2
G1 E.4 F1800
; LINE_WIDTH: 0.6218
G1 F1200
M204 S500
G2 X116.097 Y119.979 I-.032 J.06 E.01602
; WIPE_START
G1 X116.06 Y120.042 E-.076
G1 X115.988 Y120.042 E-.076
G1 X115.952 Y119.979 E-.076
G1 X115.988 Y119.917 E-.076
G1 X116.06 Y119.917 E-.076
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I-1.217 J0 P1  F12000
G1 X116.059 Y135.96 Z.6
G1 Z.2
G1 E.4 F1800
; LINE_WIDTH: 0.62236
G1 F1200
M204 S500
G2 X116.095 Y136.023 I-.032 J.06 E.01605
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F1200
G1 X116.059 Y136.085 E-.07601
G1 X115.987 Y136.085 E-.076
G1 X115.95 Y136.023 E-.076
G1 X115.987 Y135.96 E-.07601
G1 X116.059 Y135.96 E-.07599
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





    

    M622.1 S0
    M1002 judge_flag ventobox_replace_aux1_fan_flag
    M622 J0
    M106 P10 S0; set first x_layer left aux fan
    M623
;not reset fan


; update layer progress
M73 L2
M991 S0 P1 ;notify layer change


; open powerlost recovery
M1003 S1
M104 S245 ; set nozzle temperature
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z.6 I.451 J1.13 P1  F12000
G1 X162.62 Y117.379 Z.6
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.37467
G1 F6000
M204 S3000
G1 X161.973 Y117.379 E.01696
G1 X162.416 Y117.756 E.01524
G1 X162.62 Y118.027 E.00889
G1 X162.62 Y117.439 E.01541
; WIPE_START
G1 X161.973 Y117.379 E-.24695
G1 X162.24 Y117.606 E-.13305
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-1.217 J.023 P1  F12000
G1 X162.618 Y137.98 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X162.341 Y138.334 E.01176
G1 X161.971 Y138.622 E.01226
G1 X162.618 Y138.622 E.01693
G1 X162.618 Y138.04 E.01521
; WIPE_START
G1 X162.341 Y138.334 E-.15364
G1 X161.971 Y138.622 E-.17811
G1 X162.098 Y138.622 E-.04825
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01187
G1 X137.379 Y137.972 E.01231
G1 X137.379 Y138.621 E.01702
G1 X137.964 Y138.621 E.01535
; WIPE_START
G1 X137.667 Y138.343 E-.15467
G1 X137.379 Y137.972 E-.17839
G1 X137.379 Y138.096 E-.04694
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.216 J.039 P1  F12000
G1 X138.036 Y117.378 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.37271
G1 F6000
M204 S3000
G1 X137.381 Y117.378 E.01707
G1 X137.381 Y118.026 E.01688
G1 X137.665 Y117.657 E.01213
G1 X137.988 Y117.414 E.01054
; WIPE_START
G1 X137.381 Y117.378 E-.23118
G1 X137.381 Y117.769 E-.14882
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I.014 J1.217 P1  F12000
G1 X161.367 Y117.497 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.45842
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00718
G2 X160.8 Y117.397 I-.299 J1.425 E.01185
; LINE_WIDTH: 0.43732
G1 X139.199 Y117.397 E.67298
; LINE_WIDTH: 0.44903
G1 X138.742 Y117.457 E.01479
; LINE_WIDTH: 0.44999
G1 X138.4 Y117.587 E.01177
G1 X137.93 Y117.912 E.01837
G1 X137.655 Y118.275 E.01466
; LINE_WIDTH: 0.45045
G1 X137.493 Y118.626 E.01242
G1 X137.398 Y119.168 E.01773
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.0507
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44608
G1 X137.408 Y136.971 E.00543
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01266
G1 X137.667 Y137.74 E.01361
G1 X137.939 Y138.093 E.01433
G1 X138.417 Y138.423 E.01867
G1 X138.742 Y138.543 E.01115
; LINE_WIDTH: 0.44904
G1 X139.2 Y138.603 E.01479
; LINE_WIDTH: 0.43741
G1 X140.865 Y138.603 E.05188
; LINE_WIDTH: 0.43752
G1 X142.865 Y138.602 E.06234
; LINE_WIDTH: 0.43764
G1 X144.865 Y138.602 E.06236
; LINE_WIDTH: 0.43775
G1 X146.865 Y138.602 E.06238
; LINE_WIDTH: 0.43787
G1 X148.865 Y138.602 E.0624
; LINE_WIDTH: 0.43798
G1 X150.865 Y138.602 E.06241
; LINE_WIDTH: 0.4381
G1 X152.865 Y138.602 E.06243
; LINE_WIDTH: 0.43821
G1 X154.865 Y138.601 E.06245
; LINE_WIDTH: 0.43833
G1 X156.865 Y138.601 E.06247
; LINE_WIDTH: 0.43844
G1 X158.865 Y138.601 E.06249
; LINE_WIDTH: 0.43856
G1 X160.865 Y138.601 E.06251
; LINE_WIDTH: 0.44999
G1 X161.394 Y138.502 E.01731
G1 X161.74 Y138.333 E.01239
G1 X162.092 Y138.062 E.01428
G1 X162.423 Y137.583 E.01873
G1 X162.542 Y137.257 E.01116
; LINE_WIDTH: 0.44852
G1 X162.602 Y136.801 E.01476
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04969
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.0181
G1 X162.333 Y118.26 E.0136
G1 X162.121 Y117.979 E.01132
G1 X161.799 Y117.704 E.01361
G1 X161.489 Y117.538 E.01132
; LINE_WIDTH: 0.45842
G1 X161.423 Y117.516 E.00225
M204 S10000
G1 X161.265 Y117.908 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.103 Y117.834 E.00572
G1 X160.8 Y117.798 E.00979
G1 X139.199 Y117.798 E.6946
G1 X139.097 Y117.807 E.00329
G1 X138.613 Y117.934 E.01611
G1 X138.224 Y118.194 E.01504
G1 X137.984 Y118.515 E.01287
G1 X137.889 Y118.721 E.00729
G1 X137.799 Y119.168 E.01468
G1 X137.807 Y136.901 E.57021
G1 X137.887 Y137.269 E.0121
G2 X138.373 Y137.926 I1.603 J-.678 E.02653
G1 X138.814 Y138.142 E.01579
G1 X139.199 Y138.202 E.01255
G1 X160.864 Y138.2 E.69665
G1 X161.011 Y138.181 E.00475
G1 X161.495 Y138.009 E.0165
G2 X161.926 Y137.627 I-.744 J-1.274 E.01863
G1 X162.142 Y137.186 E.01581
G1 X162.202 Y136.801 E.01254
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.731 E.01532
G2 X161.607 Y118.063 I-1.544 J.644 E.02723
G1 X161.319 Y117.933 E.01016
M204 S250
G1 X161.112 Y118.243 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X160.8 Y118.19 E.00941
G1 X139.199 Y118.19 E.64341
G1 X138.883 Y118.244 E.00956
G1 X138.544 Y118.436 E.0116
G1 X138.301 Y118.745 E.01171
G1 X138.191 Y119.168 E.01302
G1 X138.193 Y136.833 E.52617
G1 X138.27 Y137.185 E.01071
G1 X138.516 Y137.539 E.01285
G1 X138.821 Y137.734 E.01077
G1 X139.199 Y137.81 E.01151
G1 X160.864 Y137.808 E.64531
M73 P42 R10
G1 X161.192 Y137.728 E.01003
G1 X161.538 Y137.484 E.01263
G1 X161.734 Y137.179 E.01078
G1 X161.81 Y136.801 E.01151
G1 X161.81 Y119.199 E.52427
G1 X161.73 Y118.815 E.01168
G1 X161.484 Y118.462 E.01284
G1 X161.164 Y118.274 E.01106
; WIPE_START
M204 S3000
G1 X160.8 Y118.19 E-.14161
G1 X160.173 Y118.19 E-.23839
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I.443 J1.133 P1  F12000
G1 X162.949 Y117.104 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.803 Y117.019 E.00546
G1 X161.973 Y117.009 E.02667
; LINE_WIDTH: 0.45842
G3 X160.8 Y117.003 I-.489 J-17.975 E.0385
; LINE_WIDTH: 0.43732
G1 X139.199 Y117.003 E.67298
; LINE_WIDTH: 0.44999
G3 X137.248 Y117.009 I-1.457 J-148.027 E.06274
G1 X137.064 Y117.084 E.00639
G1 X137.013 Y117.258 E.00585
G1 X137.013 Y118.067 E.02599
; LINE_WIDTH: 0.45045
G3 X137.005 Y119.168 I-43.871 J.264 E.03545
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.712 I-90.409 J1.244 E.06147
G1 X137.075 Y138.93 E.00731
G1 X137.301 Y138.991 E.00752
G3 X138.991 Y138.993 I.481 J359.538 E.05433
; LINE_WIDTH: 0.44657
G1 X139.2 Y138.997 E.00667
; LINE_WIDTH: 0.43741
G1 X140.865 Y138.997 E.05188
; LINE_WIDTH: 0.43752
G1 X142.865 Y138.997 E.06234
; LINE_WIDTH: 0.43764
G1 X144.865 Y138.997 E.06236
; LINE_WIDTH: 0.43775
G1 X146.865 Y138.997 E.06238
; LINE_WIDTH: 0.43787
G1 X148.865 Y138.997 E.0624
; LINE_WIDTH: 0.43798
G1 X150.865 Y138.997 E.06241
; LINE_WIDTH: 0.4381
G1 X152.865 Y138.997 E.06243
; LINE_WIDTH: 0.43821
G1 X154.865 Y138.997 E.06245
; LINE_WIDTH: 0.43833
G1 X156.865 Y138.997 E.06247
; LINE_WIDTH: 0.43844
G1 X158.865 Y138.997 E.06249
; LINE_WIDTH: 0.43856
G1 X160.865 Y138.997 E.06251
; LINE_WIDTH: 0.44999
G3 X162.731 Y138.991 I1.231 J97.473 E.06002
G1 X162.931 Y138.924 E.00678
G1 X162.987 Y138.716 E.00694
G3 X162.99 Y137.009 I228.912 J-.462 E.05488
; LINE_WIDTH: 0.44457
G1 X162.995 Y136.801 E.00662
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04969
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.264 I88.018 J-1.259 E.06223
; LINE_WIDTH: 0.44999
G1 X162.964 Y117.162 E.00339
M204 S10000
G1 X163.194 Y116.775 F12000
G1 F6000
M204 S3000
G1 X162.955 Y116.629 E.00901
G2 X161.229 Y116.602 I-1.113 J16.069 E.05554
G1 X137.229 Y116.602 E.77173
G1 X136.887 Y116.7 E.01144
G1 X136.701 Y116.897 E.00869
G1 X136.606 Y117.176 E.0095
G1 X136.602 Y138.748 E.69365
G1 X136.695 Y139.092 E.01145
G1 X136.848 Y139.275 E.00768
G1 X137.108 Y139.376 E.00897
G2 X138.759 Y139.398 I1.259 J-32.567 E.05312
G1 X162.759 Y139.398 E.77173
G1 X163.063 Y139.322 E.01007
G1 X163.246 Y139.188 E.00729
; object ids of layer 2 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer2 end: 47,58
M625
G1 X163.376 Y138.898 E.01023
G2 X163.394 Y137.264 I-39.876 J-1.257 E.05253
G1 X163.397 Y117.264 E.64311
G1 X163.364 Y117.021 E.0079
G1 X163.228 Y116.824 E.00769
M204 S250
G1 X163.501 Y116.526 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.347 Y116.378 E.00635
G1 X163.066 Y116.249 E.00921
G1 X162.455 Y116.21 E.01825
G1 X137.21 Y116.21 E.75195
G2 X136.683 Y116.359 I.215 J1.766 E.01638
G1 X136.449 Y116.558 E.00914
G1 X136.288 Y116.822 E.00921
G1 X136.214 Y117.258 E.01318
G1 X136.21 Y138.783 E.64112
G1 X136.274 Y139.144 E.01092
G1 X136.425 Y139.413 E.00921
G1 X136.618 Y139.598 E.00794
G1 X136.895 Y139.739 E.00926
G1 X137.315 Y139.79 E.01261
G1 X162.786 Y139.79 E.75869
G2 X163.349 Y139.621 I.003 J-1.014 E.01774
G1 X163.55 Y139.443 E.00802
G1 X163.712 Y139.178 E.00925
G1 X163.786 Y138.716 E.01395
G1 X163.789 Y117.264 E.63894
G1 X163.739 Y116.894 E.01112
G1 X163.6 Y116.621 E.00914
G1 X163.544 Y116.567 E.00231
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.347 Y116.378 E-.10379
G1 X163.066 Y116.249 E-.11756
G1 X162.65 Y116.222 E-.15866
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z.8 I-.486 J-1.116 P1  F12000
G1 X116.391 Y136.391 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.614 I102.7 J-1.174 E.04386
G1 X115.022 Y119.607 E.044
; LINE_WIDTH: 0.43483
G1 X114.979 Y119.607 E.00134
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.606 E.06196
; LINE_WIDTH: 0.43534
G1 X110.979 Y119.606 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.605 E.06204
; LINE_WIDTH: 0.43585
G1 X106.979 Y119.605 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.605 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.604 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.604 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.603 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.603 E.06228
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.146 J-103.83 E.04404
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00738
G1 X116.797 Y119.418 E.55047
G1 X116.719 Y119.266 E.0055
G1 X116.562 Y119.207 E.00538
G1 X95.452 Y119.202 E.67882
G1 X95.288 Y119.251 E.00552
G1 X95.202 Y119.463 E.00737
G1 X95.202 Y136.56 E.54974
G1 X95.26 Y136.719 E.00546
G1 X95.463 Y136.798 E.00701
G1 X116.548 Y136.798 E.67798
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.585 J-.806 E.01066
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.418 E.50895
G2 X117.075 Y119.057 I-.999 J.118 E.01132
G1 X116.884 Y118.888 E.00762
G1 X116.562 Y118.815 E.00982
G1 X95.417 Y118.81 E.62982
G1 X95.114 Y118.898 E.00941
G2 X94.868 Y119.155 I.584 J.804 E.01065
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.587 E.50909
G2 X94.955 Y136.98 I.982 J-.138 E.01258
G1 X95.155 Y137.132 E.00747
G1 X95.495 Y137.19 E.01029
G1 X116.583 Y137.19 E.6281
G1 X116.828 Y137.119 E.00762
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.10773
G1 X117.132 Y136.845 E-.04891
G1 X117.19 Y136.505 E-.13112
G1 X117.19 Y136.262 E-.09224
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I.051 J-1.216 P1  F12000
G1 X96.104 Y135.379 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01235
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02416
G1 X115.021 Y119.998 E.02428
; LINE_WIDTH: 0.43483
G1 X114.979 Y119.998 E.00133
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.998 E.06196
; LINE_WIDTH: 0.43534
G1 X110.979 Y119.998 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.998 E.06204
; LINE_WIDTH: 0.43585
G1 X106.979 Y119.998 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.998 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.998 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.998 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.997 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.997 E.06228
; LINE_WIDTH: 0.44605
G1 X96.808 Y120.008 E.00543
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01912
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.076 Y135.325 E.00483
M204 S10000
G1 X96.448 Y135.202 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00833
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.433 Y120.569 E.01425
G1 X115.022 Y120.398 E.01433
G1 X96.979 Y120.398 E.58019
G1 X96.878 Y120.407 E.00323
G1 X96.568 Y120.568 E.01125
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.421 Y135.149 E.00098
M204 S250
G1 X96.791 Y135.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00421
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.846 E.00429
G2 X114.979 Y120.79 I-.155 J.185 E.00566
M73 P43 R10
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00564
G1 X96.79 Y134.965 E.4153
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.07529
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.636 Y135.21 E-.23357
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-.512 J-1.104 P1  F12000
G1 X96.026 Y135.957 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08513
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I0 J1.217 P1  F12000
G1 X116.022 Y119.965 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.41858
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00241
G1 X116.022 Y120.046 E.00241
G1 X116.046 Y120.006 E.00139
; WIPE_START
G1 X116.022 Y120.046 E-.08513
G1 X115.952 Y120.006 E-.14743
G1 X116.022 Y119.965 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z.8 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z.8
G1 Z.4
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





    

    M622.1 S0
    M1002 judge_flag ventobox_replace_aux1_fan_flag
    M622 J0
    M106 P10 S0; set first x_layer left aux fan
    M623
;not reset fan


; update layer progress
M73 L3
M991 S0 P2 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z.8 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z.8
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.3747
G1 F6000
M204 S3000
G1 X161.973 Y117.379 E.01696
G1 X162.415 Y117.756 E.01523
G1 X162.621 Y118.027 E.00891
G1 X162.621 Y117.439 E.01542
; WIPE_START
G1 X161.973 Y117.379 E-.24698
G1 X162.24 Y117.606 E-.13302
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I-1.217 J.023 P1  F12000
G1 X162.621 Y137.976 Z1
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.37495
G1 F6000
M204 S3000
G1 X162.343 Y138.333 E.01188
G1 X161.972 Y138.621 E.01231
G1 X162.621 Y138.621 E.01702
G1 X162.621 Y138.036 E.01536
; WIPE_START
G1 X162.343 Y138.333 E-.15473
G1 X161.972 Y138.621 E-.17838
G1 X162.096 Y138.621 E-.04689
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I0 J-1.217 P1  F12000
G1 X138.023 Y138.618 Z1
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.37399
G1 F6000
M204 S3000
G1 X137.585 Y138.244 E.01507
G1 X137.378 Y137.971 E.00896
G1 X137.378 Y138.618 E.01693
G1 X137.963 Y138.618 E.0153
; WIPE_START
G1 X137.585 Y138.244 E-.20224
G1 X137.378 Y137.971 E-.13015
G1 X137.378 Y138.096 E-.0476
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I1.216 J.038 P1  F12000
G1 X138.03 Y117.378 Z1
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.37373
G1 F6000
M204 S3000
G1 X137.378 Y117.378 E.01705
G1 X137.378 Y118.029 E.01701
G1 X137.663 Y117.658 E.01221
G1 X137.983 Y117.414 E.01051
; WIPE_START
G1 X137.378 Y117.378 E-.23016
G1 X137.378 Y117.772 E-.14984
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I.014 J1.217 P1  F12000
G1 X161.368 Y117.497 Z1
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.45832
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00723
G2 X160.8 Y117.397 I-.298 J1.425 E.01183
; LINE_WIDTH: 0.43732
G1 X139.199 Y117.397 E.67298
; LINE_WIDTH: 0.4495
G1 X138.693 Y117.473 E.01644
; LINE_WIDTH: 0.44999
G1 X138.352 Y117.61 E.01183
G1 X137.929 Y117.914 E.01676
G1 X137.654 Y118.277 E.01465
; LINE_WIDTH: 0.45078
G1 X137.493 Y118.626 E.01238
G1 X137.398 Y119.168 E.01772
; LINE_WIDTH: 0.43756
G1 X137.398 Y124.8 E.17559
; LINE_WIDTH: 0.43746
G1 X137.397 Y130.8 E.18699
; LINE_WIDTH: 0.43735
G1 X137.397 Y136.8 E.18694
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01811
G1 X137.667 Y137.74 E.01361
G1 X137.879 Y138.021 E.01132
G1 X138.201 Y138.296 E.01362
G1 X138.512 Y138.462 E.01132
; LINE_WIDTH: 0.45669
G2 X139.2 Y138.602 I.629 J-1.329 E.02317
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.602 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.602 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.602 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.602 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.602 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.602 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.602 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.603 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.603 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.603 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.603 E.06229
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.01811
G1 X161.74 Y138.334 E.01359
G1 X162.093 Y138.061 E.01433
G1 X162.423 Y137.584 E.01866
G1 X162.543 Y137.258 E.01117
; LINE_WIDTH: 0.44897
G1 X162.603 Y136.8 E.01479
; LINE_WIDTH: 0.43719
G1 X162.603 Y131.2 E.17443
; LINE_WIDTH: 0.43706
G1 X162.603 Y125.2 E.18681
; LINE_WIDTH: 0.43693
G1 X162.603 Y119.2 E.18674
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.01809
G1 X162.334 Y118.26 E.01361
G1 X162.121 Y117.979 E.01134
G1 X161.799 Y117.704 E.01362
G1 X161.488 Y117.538 E.01132
; LINE_WIDTH: 0.45832
G1 X161.424 Y117.517 E.00221
M204 S10000
G1 X161.266 Y117.908 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.102 Y117.834 E.00578
G1 X160.8 Y117.798 E.00978
G1 X139.199 Y117.798 E.6946
G1 X139.086 Y117.809 E.00366
G1 X138.572 Y117.953 E.01716
G1 X138.222 Y118.196 E.01371
G1 X137.983 Y118.516 E.01283
G1 X137.889 Y118.721 E.00726
G1 X137.799 Y119.168 E.01466
G1 X137.798 Y136.8 E.56699
G1 X137.887 Y137.269 E.01532
G2 X138.393 Y137.937 I1.545 J-.644 E.02725
G1 X138.898 Y138.166 E.01781
G1 X139.2 Y138.202 E.00978
G1 X160.801 Y138.202 E.69459
G1 X161.269 Y138.113 E.01533
G2 X161.925 Y137.627 I-.677 J-1.601 E.0265
G1 X162.142 Y137.186 E.01581
G1 X162.202 Y136.8 E.01255
G1 X162.202 Y119.2 E.56596
G1 X162.113 Y118.732 E.01531
G2 X161.607 Y118.063 I-1.546 J.645 E.02726
G1 X161.321 Y117.933 E.01011
M204 S250
G1 X161.112 Y118.243 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.00002
G1 X160.8 Y118.19 E.0094
G1 X139.199 Y118.19 E.64341
G1 X138.849 Y118.256 E.01062
G1 X138.538 Y118.44 E.01075
G1 X138.301 Y118.746 E.01153
G1 X138.191 Y119.168 E.01299
G1 X138.19 Y136.8 E.5252
G1 X138.27 Y137.185 E.01168
G1 X138.516 Y137.539 E.01285
G1 X138.888 Y137.757 E.01285
G1 X139.2 Y137.81 E.00941
G1 X160.801 Y137.81 E.6434
G1 X161.185 Y137.73 E.01168
G1 X161.538 Y137.484 E.01283
G1 X161.733 Y137.179 E.01078
G1 X161.81 Y136.8 E.01152
G1 X161.81 Y119.2 E.52425
G1 X161.73 Y118.816 E.01167
G1 X161.484 Y118.461 E.01286
G1 X161.164 Y118.274 E.01104
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.02308
G1 X160.8 Y118.19 E-.11993
G1 X160.177 Y118.19 E-.23699
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I.454 J1.129 P1  F12000
G1 X162.932 Y117.081 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.78 Y117.018 E.00528
G1 X161.972 Y117.009 E.02598
; LINE_WIDTH: 0.45832
G3 X160.8 Y117.003 I-.488 J-18.03 E.03846
; LINE_WIDTH: 0.43732
G1 X139.199 Y117.003 E.67298
; LINE_WIDTH: 0.4495
G1 X138.647 Y117.009 E.01773
; LINE_WIDTH: 0.44999
G1 X137.268 Y117.009 E.04437
G1 X137.071 Y117.079 E.00671
G1 X137.009 Y117.315 E.00784
G1 X137.009 Y118.069 E.02423
; LINE_WIDTH: 0.45078
G3 X137.003 Y119.168 I-46.623 J.288 E.03542
; LINE_WIDTH: 0.43756
G1 X137.003 Y124.8 E.17559
; LINE_WIDTH: 0.43746
G1 X137.003 Y130.8 E.18699
; LINE_WIDTH: 0.43735
G1 X137.003 Y136.8 E.18694
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.751 I-93.325 J1.279 E.06273
G1 X137.084 Y138.936 E.00641
G1 X137.257 Y138.987 E.00582
G3 X139.038 Y138.992 I.545 J132.446 E.05724
; LINE_WIDTH: 0.44121
G1 X139.2 Y138.995 E.0051
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.995 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.995 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.995 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.996 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.996 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.996 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.996 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.996 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.997 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.997 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.997 E.06229
; LINE_WIDTH: 0.44999
G3 X162.712 Y138.991 I1.247 J90.513 E.06148
G1 X162.926 Y138.923 E.00722
G1 X162.991 Y138.722 E.0068
G3 X162.993 Y137.009 I330.228 J-.505 E.05507
; LINE_WIDTH: 0.44622
G1 X162.997 Y136.8 E.00665
; LINE_WIDTH: 0.43719
G1 X162.997 Y131.2 E.17443
; LINE_WIDTH: 0.43706
G1 X162.997 Y125.2 E.18681
; LINE_WIDTH: 0.43693
G1 X162.997 Y119.2 E.18674
; LINE_WIDTH: 0.45007
G3 X162.99 Y117.263 I89.026 J-1.273 E.06227
; LINE_WIDTH: 0.44999
G1 X162.95 Y117.138 E.00422
M204 S10000
G1 X163.182 Y116.758 F12000
G1 F6000
M204 S3000
G1 X162.985 Y116.638 E.0074
G1 X162.455 Y116.602 E.0171
G1 X137.24 Y116.602 E.8108
G1 X136.931 Y116.687 E.01029
G1 X136.718 Y116.857 E.00877
G1 X136.626 Y117.118 E.00889
G2 X136.602 Y118.771 I21.783 J1.143 E.05319
G1 X136.602 Y138.771 E.64311
G1 X136.7 Y139.113 E.01143
G1 X136.897 Y139.299 E.00871
G1 X137.176 Y139.394 E.0095
G1 X162.748 Y139.398 E.82228
G1 X163.081 Y139.315 E.01103
G1 X163.278 Y139.147 E.00831
; object ids of layer 3 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer3 end: 47,58
M625
G1 X163.376 Y138.892 E.00878
G2 X163.398 Y137.263 I-32.139 J-1.245 E.05239
G1 X163.397 Y117.263 E.64311
G1 X163.365 Y117.029 E.00761
G1 X163.215 Y116.808 E.00859
M204 S250
G1 X163.488 Y116.507 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.342 Y116.386 E.00564
G2 X163.104 Y116.26 I-.629 J.901 E.00804
G1 X162.703 Y116.21 E.01202
G1 X137.213 Y116.21 E.75924
G1 X136.939 Y116.248 E.00825
G1 X136.618 Y116.402 E.01061
G1 X136.4 Y116.621 E.0092
G1 X136.275 Y116.854 E.0079
G1 X136.21 Y117.315 E.01386
G1 X136.21 Y138.79 E.63966
G2 X136.359 Y139.317 I1.746 J-.209 E.01637
G1 X136.559 Y139.551 E.00916
G1 X136.822 Y139.713 E.00921
G1 X137.257 Y139.786 E.01314
G1 X162.783 Y139.79 E.7603
G1 X163.145 Y139.725 E.01096
G1 X163.379 Y139.6 E.00789
G1 X163.599 Y139.381 E.00927
G1 X163.739 Y139.105 E.00921
G1 X163.79 Y138.685 E.0126
M73 P44 R10
G1 X163.789 Y117.263 E.63807
G1 X163.74 Y116.898 E.01097
G2 X163.564 Y116.592 I-1.028 J.389 E.01059
G1 X163.528 Y116.552 E.00161
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.342 Y116.386 E-.09458
G1 X163.104 Y116.26 E-.10237
G1 X162.703 Y116.21 E-.15341
G1 X162.625 Y116.21 E-.02964
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1 I-.487 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.614 I102.706 J-1.174 E.04386
G1 X115.022 Y119.607 E.044
; LINE_WIDTH: 0.43485
G1 X114.979 Y119.607 E.00134
; LINE_WIDTH: 0.4351
G1 X112.979 Y119.606 E.06196
; LINE_WIDTH: 0.43535
G1 X110.979 Y119.606 E.062
; LINE_WIDTH: 0.43561
G1 X108.979 Y119.605 E.06204
; LINE_WIDTH: 0.43586
G1 X106.979 Y119.605 E.06208
; LINE_WIDTH: 0.43611
G1 X104.979 Y119.605 E.06212
; LINE_WIDTH: 0.43636
G1 X102.979 Y119.604 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.604 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.603 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.603 E.06228
; LINE_WIDTH: 0.44999
G3 X95.612 Y119.609 I-1.145 J-103.314 E.04396
G1 X95.604 Y120.978 E.04403
; LINE_WIDTH: 0.43622
G1 X95.604 Y121.021 E.00134
; LINE_WIDTH: 0.43636
G1 X95.604 Y123.021 E.06216
; LINE_WIDTH: 0.4365
G1 X95.604 Y125.021 E.06218
; LINE_WIDTH: 0.43664
G1 X95.604 Y127.021 E.0622
; LINE_WIDTH: 0.43678
G1 X95.604 Y129.021 E.06222
; LINE_WIDTH: 0.43692
G1 X95.603 Y131.021 E.06225
; LINE_WIDTH: 0.43706
G1 X95.603 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.603 Y135.021 E.06229
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-104.872 J1.16 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.715 Y136.742 F12000
G1 F6000
M204 S3000
G1 X116.719 Y136.74 E.00017
G1 X116.798 Y136.537 E.00701
G1 X116.797 Y119.442 E.5497
G1 X116.739 Y119.274 E.00571
G1 X116.563 Y119.207 E.00606
G1 X95.44 Y119.202 E.6792
G1 X95.28 Y119.26 E.00547
G1 X95.204 Y119.414 E.00551
G1 X95.202 Y136.548 E.55098
G1 X95.25 Y136.712 E.00549
G1 X95.463 Y136.798 E.00739
G1 X116.56 Y136.798 E.67837
G1 X116.658 Y136.762 E.00337
M204 S250
G1 X116.85 Y137.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X116.98 Y137.045 I-.401 J-.908 E.00441
G1 X117.132 Y136.845 E.00748
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.442 E.50824
G2 X116.887 Y118.888 I-.677 J.011 E.01954
G1 X116.563 Y118.815 E.0099
G1 X95.413 Y118.81 E.62995
G2 X95.02 Y118.955 I.144 J.998 E.01258
G1 X94.866 Y119.158 E.00758
G1 X94.812 Y119.455 E.009
G1 X94.81 Y136.583 E.51017
G1 X94.898 Y136.886 E.00939
G2 X95.155 Y137.132 I.807 J-.587 E.01066
G1 X95.495 Y137.19 E.01028
G1 X116.587 Y137.19 E.62823
G2 X116.794 Y137.137 I-.138 J-.983 E.00639
; WIPE_START
M204 S3000
G1 X116.98 Y137.045 E-.07881
G1 X117.132 Y136.845 E-.09542
G1 X117.19 Y136.505 E-.1312
G1 X117.19 Y136.309 E-.07458
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I.054 J-1.216 P1  F12000
G1 X96.104 Y135.378 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01235
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02416
G1 X115.021 Y119.998 E.02428
; LINE_WIDTH: 0.43485
G1 X114.979 Y119.998 E.00133
; LINE_WIDTH: 0.4351
G1 X112.979 Y119.998 E.06196
; LINE_WIDTH: 0.43535
G1 X110.979 Y119.998 E.062
; LINE_WIDTH: 0.43561
G1 X108.979 Y119.998 E.06204
; LINE_WIDTH: 0.43586
G1 X106.979 Y119.998 E.06208
; LINE_WIDTH: 0.43611
G1 X104.979 Y119.998 E.06212
; LINE_WIDTH: 0.43636
G1 X102.979 Y119.998 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.998 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.997 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.997 E.06228
; LINE_WIDTH: 0.44605
G1 X96.808 Y120.008 E.00543
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.01908
G1 X95.998 Y120.979 E.02426
; LINE_WIDTH: 0.43622
G1 X95.998 Y121.021 E.00133
; LINE_WIDTH: 0.43636
G1 X95.998 Y123.021 E.06216
; LINE_WIDTH: 0.4365
G1 X95.998 Y125.021 E.06218
; LINE_WIDTH: 0.43664
G1 X95.998 Y127.021 E.0622
; LINE_WIDTH: 0.43678
G1 X95.997 Y129.021 E.06222
; LINE_WIDTH: 0.43692
G1 X95.997 Y131.021 E.06225
; LINE_WIDTH: 0.43706
G1 X95.997 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.997 Y135.021 E.06229
; LINE_WIDTH: 0.44614
G1 X96.008 Y135.192 E.00543
; LINE_WIDTH: 0.44999
G1 X96.076 Y135.325 E.00483
M204 S10000
G1 X96.026 Y135.957 F12000
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
M204 S10000
G1 X96.448 Y135.202 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00834
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.433 Y120.569 E.01425
G1 X115.022 Y120.398 E.01433
G1 X96.979 Y120.398 E.58019
G1 X96.878 Y120.407 E.00323
G1 X96.568 Y120.568 E.01123
G1 X96.398 Y120.978 E.01431
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.421 Y135.149 E.00098
M204 S250
G1 X96.791 Y135.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00421
G2 X97.021 Y135.21 I.155 J-.185 E.00564
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.846 E.00429
G2 X114.979 Y120.79 I-.155 J.185 E.00566
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.00429
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.964 E.4153
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0753
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.636 Y135.21 E-.23356
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I1.21 J-.128 P1  F12000
G1 X96.027 Y119.961 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42052
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00244
G1 X96.027 Y120.043 E.00244
G1 X96.051 Y120.002 E.00141
; WIPE_START
G1 X96.027 Y120.043 E-.08513
G1 X95.957 Y120.002 E-.14744
G1 X96.027 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I0 J1.217 P1  F12000
G1 X116.022 Y119.965 Z1
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.4186
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00241
G1 X116.022 Y120.046 E.00241
G1 X116.046 Y120.006 E.00139
; WIPE_START
G1 X116.022 Y120.046 E-.08512
G1 X115.952 Y120.006 E-.14744
G1 X116.022 Y119.965 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z1
G1 Z.6
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





    ;updata chamber autocooling in Xth layer
    
            ;not reset filter fan in Xth layer
    

    M622.1 S0
    M1002 judge_flag ventobox_replace_aux1_fan_flag
    M622 J0
    M106 P10 S0; set left aux fan
    M623
;not reset fan


; update layer progress
M73 L4
M991 S0 P3 ;notify layer change


M106 S117.3
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z1
G1 Z.8
G1 E.4 F1800
; LINE_WIDTH: 0.37469
G1 F6000
M204 S3000
G1 X161.973 Y117.379 E.01696
G1 X162.415 Y117.756 E.01523
G1 X162.621 Y118.027 E.00891
G1 X162.621 Y117.439 E.01542
; WIPE_START
G1 X161.973 Y117.379 E-.24696
G1 X162.24 Y117.606 E-.13304
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I-1.217 J.023 P1  F12000
G1 X162.621 Y137.976 Z1.2
G1 Z.8
G1 E.4 F1800
; LINE_WIDTH: 0.37496
G1 F6000
M204 S3000
G1 X162.343 Y138.333 E.01187
G1 X161.972 Y138.621 E.01231
G1 X162.621 Y138.621 E.01702
G1 X162.621 Y138.036 E.01535
; WIPE_START
G1 X162.343 Y138.333 E-.15469
G1 X161.972 Y138.621 E-.1784
G1 X162.096 Y138.621 E-.04691
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I0 J-1.217 P1  F12000
G1 X138.02 Y138.618 Z1.2
G1 Z.8
G1 E.4 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.666 Y138.341 E.01176
G1 X137.378 Y137.971 E.01225
G1 X137.378 Y138.618 E.01693
G1 X137.96 Y138.618 E.01521
; WIPE_START
G1 X137.666 Y138.341 E-.15364
G1 X137.378 Y137.971 E-.17806
G1 X137.378 Y138.098 E-.04829
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I1.216 J.038 P1  F12000
G1 X138.033 Y117.378 Z1.2
G1 Z.8
G1 E.4 F1800
; LINE_WIDTH: 0.37264
G1 F6000
M204 S3000
G1 X137.381 Y117.378 E.01698
G1 X137.381 Y118.026 E.01688
G1 X137.665 Y117.657 E.01212
G1 X137.985 Y117.414 E.01049
; WIPE_START
G1 X137.381 Y117.378 E-.23002
G1 X137.381 Y117.772 E-.14999
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I.014 J1.217 P1  F12000
G1 X161.369 Y117.498 Z1.2
G1 Z.8
G1 E.4 F1800
; LINE_WIDTH: 0.45834
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00727
G2 X160.8 Y117.397 I-.298 J1.425 E.01184
; LINE_WIDTH: 0.43732
G1 X139.199 Y117.397 E.67298
; LINE_WIDTH: 0.44945
G1 X138.698 Y117.471 E.01626
; LINE_WIDTH: 0.44999
G1 X138.357 Y117.608 E.01184
G1 X137.929 Y117.913 E.01689
G1 X137.653 Y118.278 E.01471
; LINE_WIDTH: 0.45046
G1 X137.493 Y118.626 E.01234
G1 X137.399 Y119.168 E.0177
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.8 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.8 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.8 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.8 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.8 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.8 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.8 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.8 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.8 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01811
G1 X137.667 Y137.74 E.0136
G2 X138.167 Y138.277 I1.598 J-.989 E.02375
G2 X138.743 Y138.543 I1.023 J-1.46 E.0205
; LINE_WIDTH: 0.44856
G1 X139.199 Y138.602 E.01476
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.602 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.602 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.602 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.602 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.602 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.602 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.602 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.603 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.603 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.603 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.603 E.06229
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.0181
G1 X161.74 Y138.334 E.0136
G1 X162.093 Y138.061 E.01434
G1 X162.423 Y137.583 E.01868
G1 X162.543 Y137.257 E.01116
; LINE_WIDTH: 0.44896
G1 X162.603 Y136.8 E.01479
; LINE_WIDTH: 0.43737
G1 X162.603 Y135.131 E.052
; LINE_WIDTH: 0.43749
G1 X162.602 Y133.131 E.06234
; LINE_WIDTH: 0.43761
G1 X162.602 Y131.131 E.06236
; LINE_WIDTH: 0.43773
G1 X162.602 Y129.131 E.06237
; LINE_WIDTH: 0.43785
G1 X162.601 Y127.131 E.06239
; LINE_WIDTH: 0.43797
G1 X162.601 Y125.131 E.06241
; LINE_WIDTH: 0.43809
M73 P45 R10
G1 X162.601 Y123.131 E.06243
; LINE_WIDTH: 0.43821
G1 X162.601 Y121.131 E.06245
; LINE_WIDTH: 0.43834
G1 X162.6 Y119.131 E.06247
; LINE_WIDTH: 0.45227
G1 X162.502 Y118.604 E.01734
G1 X162.333 Y118.26 E.0124
; LINE_WIDTH: 0.44999
G1 X162.121 Y117.979 E.01133
G1 X161.799 Y117.704 E.01362
G1 X161.488 Y117.538 E.01132
; LINE_WIDTH: 0.45834
G1 X161.426 Y117.517 E.00216
M204 S10000
G1 X161.267 Y117.909 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.103 Y117.834 E.00582
G1 X160.8 Y117.798 E.00978
G1 X139.199 Y117.798 E.6946
G1 X139.087 Y117.809 E.00362
G1 X138.576 Y117.951 E.01705
G1 X138.222 Y118.196 E.01385
G1 X137.983 Y118.516 E.01285
G1 X137.889 Y118.721 E.00724
G1 X137.799 Y119.168 E.01465
G1 X137.798 Y136.8 E.567
G1 X137.887 Y137.269 E.01532
G2 X138.373 Y137.926 I1.602 J-.677 E.02652
G1 X138.814 Y138.142 E.01581
G1 X139.199 Y138.202 E.01254
G1 X160.801 Y138.202 E.6946
G1 X161.269 Y138.113 E.01532
G2 X161.926 Y137.627 I-.677 J-1.603 E.02653
G1 X162.142 Y137.186 E.01581
G1 X162.202 Y136.8 E.01254
G1 X162.199 Y119.132 E.56815
G1 X162.18 Y118.984 E.00479
G1 X162.009 Y118.506 E.01633
G2 X161.607 Y118.063 I-1.209 J.695 E.01938
G1 X161.322 Y117.934 E.01006
M204 S250
G1 X161.114 Y118.244 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.00006
G1 X160.8 Y118.19 E.0094
G1 X139.199 Y118.19 E.64341
G1 X138.853 Y118.255 E.0105
G1 X138.538 Y118.441 E.0109
G1 X138.301 Y118.746 E.01151
G1 X138.191 Y119.168 E.01298
G1 X138.19 Y136.801 E.52521
G1 X138.304 Y137.258 E.01404
G1 X138.571 Y137.587 E.01264
G1 X138.821 Y137.734 E.00862
G1 X139.199 Y137.81 E.0115
G1 X160.801 Y137.81 E.64341
G1 X161.184 Y137.73 E.01168
G1 X161.538 Y137.484 E.01284
G1 X161.734 Y137.179 E.01078
G1 X161.81 Y136.8 E.01151
G1 X161.807 Y119.132 E.52628
G1 X161.728 Y118.808 E.00992
G1 X161.484 Y118.461 E.01264
G1 X161.165 Y118.275 E.011
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.0236
G1 X160.8 Y118.19 E-.11998
G1 X160.178 Y118.19 E-.23642
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I.454 J1.129 P1  F12000
G1 X162.933 Y117.083 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.781 Y117.018 E.00531
G1 X161.973 Y117.009 E.026
; LINE_WIDTH: 0.45834
G3 X160.8 Y117.003 I-.488 J-18.022 E.03847
; LINE_WIDTH: 0.43732
G1 X139.199 Y117.003 E.67298
; LINE_WIDTH: 0.44945
G1 X138.653 Y117.009 E.01754
; LINE_WIDTH: 0.44999
G1 X137.249 Y117.009 E.04516
G1 X137.064 Y117.084 E.0064
G1 X137.013 Y117.257 E.00582
G1 X137.013 Y118.071 E.02615
; LINE_WIDTH: 0.45241
G3 X137.005 Y119.168 I-17.676 J.433 E.03549
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.8 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.8 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.8 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.8 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.8 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.8 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.8 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.8 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.8 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.751 I-92.305 J1.264 E.06272
G1 X137.09 Y138.942 E.00668
G1 X137.266 Y138.987 E.00585
G3 X138.991 Y138.99 I.467 J242.66 E.05547
; LINE_WIDTH: 0.44485
G1 X139.199 Y138.995 E.00662
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.995 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.995 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.995 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.995 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.996 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.996 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.996 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.996 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.997 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.997 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.997 E.06229
; LINE_WIDTH: 0.44999
G3 X162.732 Y138.991 I1.257 J91.454 E.0621
G1 X162.929 Y138.921 E.00672
G1 X162.991 Y138.722 E.0067
G3 X162.993 Y137.009 I329.975 J-.506 E.05507
; LINE_WIDTH: 0.44622
G1 X162.997 Y136.8 E.00665
; LINE_WIDTH: 0.43737
G1 X162.997 Y135.131 E.052
; LINE_WIDTH: 0.43749
G1 X162.997 Y133.131 E.06234
; LINE_WIDTH: 0.43761
G1 X162.997 Y131.131 E.06236
; LINE_WIDTH: 0.43773
G1 X162.997 Y129.131 E.06237
; LINE_WIDTH: 0.43785
G1 X162.996 Y127.131 E.06239
; LINE_WIDTH: 0.43797
G1 X162.996 Y125.131 E.06241
; LINE_WIDTH: 0.43809
G1 X162.996 Y123.131 E.06243
; LINE_WIDTH: 0.43821
G1 X162.996 Y121.131 E.06245
; LINE_WIDTH: 0.43834
G1 X162.996 Y119.131 E.06247
; LINE_WIDTH: 0.45227
G3 X162.99 Y118.039 I38.744 J-.755 E.03532
; LINE_WIDTH: 0.44999
G1 X162.99 Y117.263 E.02496
G1 X162.951 Y117.14 E.00415
M204 S10000
G1 X163.179 Y116.756 F12000
G1 F6000
M204 S3000
G1 X162.988 Y116.639 E.00721
G1 X162.455 Y116.602 E.01719
G1 X137.229 Y116.602 E.81115
G1 X136.887 Y116.7 E.01143
G1 X136.701 Y116.897 E.0087
G1 X136.606 Y117.176 E.00949
G1 X136.602 Y138.771 E.69439
G1 X136.7 Y139.113 E.01143
G1 X136.946 Y139.333 E.01061
G1 X137.266 Y139.394 E.01049
G1 X162.76 Y139.398 E.81976
G1 X163.068 Y139.314 E.01027
G1 X163.278 Y139.147 E.00864
; object ids of layer 4 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer4 end: 47,58
M625
G1 X163.38 Y138.868 E.00956
G2 X163.398 Y137.263 I-37.38 J-1.221 E.0516
G1 X163.397 Y117.263 E.64311
G1 X163.365 Y117.028 E.00762
G1 X163.213 Y116.806 E.00868
M204 S250
G1 X163.487 Y116.506 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.347 Y116.377 E.00566
G1 X163.107 Y116.261 E.00794
G1 X162.703 Y116.21 E.01212
G1 X137.21 Y116.21 E.75935
G2 X136.683 Y116.359 I.21 J1.747 E.01638
G1 X136.449 Y116.558 E.00914
G1 X136.287 Y116.822 E.00922
G1 X136.214 Y117.257 E.01314
G1 X136.21 Y138.79 E.64137
G2 X136.359 Y139.317 I1.722 J-.202 E.01638
G1 X136.56 Y139.552 E.00921
G1 X136.787 Y139.697 E.00803
G1 X137.266 Y139.786 E.0145
G1 X162.787 Y139.79 E.76015
G1 X163.065 Y139.752 E.00836
G1 X163.382 Y139.598 E.01049
G1 X163.599 Y139.38 E.00916
G1 X163.739 Y139.105 E.00919
G1 X163.79 Y138.699 E.01221
G1 X163.789 Y117.263 E.63848
G1 X163.741 Y116.898 E.01096
G1 X163.574 Y116.587 E.0105
G1 X163.531 Y116.547 E.00177
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.347 Y116.377 E-.09501
G1 X163.107 Y116.261 E-.10134
G1 X162.703 Y116.21 E-.15468
G1 X162.627 Y116.21 E-.02897
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1.2 I-.487 J-1.115 P1  F12000
G1 X116.388 Y136.391 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.391 Y135.227 E.03744
; LINE_WIDTH: 0.44498
G1 X116.395 Y135.021 E.00651
; LINE_WIDTH: 0.43608
G1 X116.395 Y134.979 E.00133
; LINE_WIDTH: 0.4362
G1 X116.396 Y132.979 E.06213
; LINE_WIDTH: 0.43631
G1 X116.396 Y130.979 E.06215
; LINE_WIDTH: 0.43643
G1 X116.396 Y128.979 E.06217
; LINE_WIDTH: 0.43655
G1 X116.396 Y126.979 E.06219
; LINE_WIDTH: 0.43667
G1 X116.396 Y124.979 E.06221
; LINE_WIDTH: 0.43679
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43691
G1 X116.397 Y120.979 E.06224
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.614 I101.617 J-1.158 E.04386
G1 X115.022 Y119.607 E.044
; LINE_WIDTH: 0.43484
G1 X114.979 Y119.607 E.00134
; LINE_WIDTH: 0.43509
G1 X112.979 Y119.606 E.06196
; LINE_WIDTH: 0.43535
G1 X110.979 Y119.606 E.062
; LINE_WIDTH: 0.4356
G1 X108.979 Y119.605 E.06204
; LINE_WIDTH: 0.43585
G1 X106.979 Y119.605 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.605 E.06212
; LINE_WIDTH: 0.43636
G1 X102.979 Y119.604 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.604 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.603 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.603 E.06228
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.147 J-103.67 E.04404
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.328 Y136.391 I1.171 J104.873 E.04202
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.795 Y136.589 E.00582
G1 X116.797 Y119.451 E.55108
G1 X116.721 Y119.255 E.00677
G1 X116.554 Y119.207 E.00556
G1 X95.441 Y119.202 E.67892
G1 X95.28 Y119.26 E.00548
G1 X95.202 Y119.463 E.00701
G1 X95.202 Y136.548 E.54936
G1 X95.251 Y136.712 E.00552
G1 X95.463 Y136.798 E.00737
G1 X116.548 Y136.798 E.67798
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.167 Y136.717 I-.352 J-.552 E.01453
G2 X117.187 Y135.451 I-22.197 J-.995 E.03773
G1 X117.189 Y119.451 E.47657
G1 X117.152 Y119.202 E.00749
G1 X117.011 Y118.981 E.00782
G1 X116.749 Y118.841 E.00883
G2 X115.414 Y118.815 I-1.047 J19.245 E.0398
G1 X95.414 Y118.81 E.59572
M73 P45 R9
G2 X95.02 Y118.955 I.137 J.982 E.0126
G1 X94.868 Y119.155 E.00747
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.583 E.50897
G1 X94.898 Y136.886 E.0094
G2 X95.155 Y137.132 I.804 J-.583 E.01065
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00762
; WIPE_START
M204 S3000
G1 X117.061 Y136.939 E-.11175
G1 X117.167 Y136.717 E-.09336
G1 X117.174 Y136.257 E-.1749
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I.051 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01243
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01907
G1 X115.992 Y135.192 E.01914
; LINE_WIDTH: 0.44498
G1 X116.002 Y135.021 E.00542
; LINE_WIDTH: 0.43608
G1 X116.002 Y134.979 E.00133
; LINE_WIDTH: 0.4362
M73 P46 R9
G1 X116.002 Y132.979 E.06213
; LINE_WIDTH: 0.43631
G1 X116.002 Y130.979 E.06215
; LINE_WIDTH: 0.43643
G1 X116.002 Y128.979 E.06217
; LINE_WIDTH: 0.43655
G1 X116.002 Y126.979 E.06219
; LINE_WIDTH: 0.43667
G1 X116.002 Y124.979 E.06221
; LINE_WIDTH: 0.43679
G1 X116.003 Y122.979 E.06223
; LINE_WIDTH: 0.43691
G1 X116.003 Y120.979 E.06224
; LINE_WIDTH: 0.44999
G1 X115.721 Y120.282 E.02416
G1 X115.021 Y119.998 E.02428
; LINE_WIDTH: 0.43484
G1 X114.979 Y119.998 E.00133
; LINE_WIDTH: 0.43509
G1 X112.979 Y119.998 E.06196
; LINE_WIDTH: 0.43535
G1 X110.979 Y119.998 E.062
; LINE_WIDTH: 0.4356
G1 X108.979 Y119.998 E.06204
; LINE_WIDTH: 0.43585
G1 X106.979 Y119.998 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.998 E.06212
; LINE_WIDTH: 0.43636
G1 X102.979 Y119.998 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.998 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.997 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.997 E.06228
; LINE_WIDTH: 0.44605
G1 X96.808 Y120.008 E.00543
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01912
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00475
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.431 Y135.433 E.01122
G1 X115.593 Y135.122 E.01127
G2 X115.602 Y134.979 I-.819 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.433 Y120.569 E.01425
G1 X115.022 Y120.398 E.01432
G1 X96.979 Y120.398 E.58019
G1 X96.878 Y120.407 E.00323
G1 X96.568 Y120.568 E.01125
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.00429
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.846 E.00429
G2 X114.979 Y120.79 I-.155 J.185 E.00566
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00564
G1 X96.79 Y134.961 E.41521
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I-.049 J1.216 P1  F12000
G1 X116.02 Y135.958 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42046
G1 F6000
M204 S3000
G1 X115.949 Y135.999 E.00244
G1 X116.02 Y136.039 E.00244
G1 X116.043 Y135.999 E.00141
; WIPE_START
G1 X116.02 Y136.039 E-.08513
G1 X115.949 Y135.999 E-.14743
G1 X116.02 Y135.958 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I1.217 J0 P1  F12000
G1 X116.022 Y119.965 Z1.2
G1 Z.8
G1 E.4 F1800
; LINE_WIDTH: 0.41852
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00241
G1 X116.022 Y120.046 E.00241
G1 X116.046 Y120.006 E.00139
; WIPE_START
G1 X116.022 Y120.046 E-.08513
G1 X115.952 Y120.006 E-.14743
G1 X116.022 Y119.965 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I0 J-1.217 P1  F12000
G1 X96.026 Y119.961 Z1.2
G1 Z.8
G1 E.4 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08513
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.2 I-1.217 J0 P1  F12000
G1 X96.026 Y135.957 Z1.2
G1 Z.8
G1 E.4 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L5
M991 S0 P4 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1.2 I.327 J1.172 P1  F12000
G1 X162.621 Y117.379 Z1.2
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.37463
G1 F6000
M204 S3000
G1 X161.975 Y117.379 E.0169
G1 X162.333 Y117.657 E.01186
G1 X162.62 Y118.027 E.01228
G1 X162.621 Y117.439 E.01541
; WIPE_START
G1 X161.975 Y117.379 E-.2462
G1 X162.253 Y117.595 E-.1338
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-1.217 J.022 P1  F12000
G1 X162.618 Y137.98 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X162.341 Y138.334 E.01176
G1 X161.971 Y138.622 E.01226
G1 X162.618 Y138.622 E.01693
G1 X162.618 Y138.04 E.01521
; WIPE_START
G1 X162.341 Y138.334 E-.15363
G1 X161.971 Y138.622 E-.17809
G1 X162.098 Y138.622 E-.04828
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I0 J-1.217 P1  F12000
G1 X138.02 Y138.618 Z1.4
G1 Z1
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X137.666 Y138.341 E.01177
G1 X137.378 Y137.971 E.01225
G1 X137.378 Y138.618 E.01693
G1 X137.96 Y138.618 E.01522
; WIPE_START
G1 X137.666 Y138.341 E-.15368
G1 X137.378 Y137.971 E-.17805
G1 X137.378 Y138.098 E-.04828
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.216 J.038 P1  F12000
G1 X138.029 Y117.378 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01693
G1 X137.382 Y118.021 E.01682
G1 X137.757 Y117.585 E.01506
G1 X137.981 Y117.414 E.00737
; WIPE_START
G1 X137.382 Y117.378 E-.22825
G1 X137.382 Y117.778 E-.15175
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.013 J1.217 P1  F12000
G1 X161.422 Y117.518 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.257 Y117.457 E.00566
; LINE_WIDTH: 0.44901
G1 X160.8 Y117.397 E.01478
; LINE_WIDTH: 0.43731
G1 X139.199 Y117.397 E.67297
; LINE_WIDTH: 0.44999
G1 X138.643 Y117.49 E.01811
G1 X138.26 Y117.667 E.01359
G2 X137.448 Y118.772 I.97 J1.564 E.04519
; LINE_WIDTH: 0.44792
G1 X137.399 Y119.167 E.01275
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.8 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.8 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.8 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.8 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.8 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01811
G1 X137.667 Y137.74 E.0136
G1 X137.938 Y138.092 E.01428
G1 X138.417 Y138.423 E.01873
G1 X138.743 Y138.543 E.01116
; LINE_WIDTH: 0.44856
G1 X139.2 Y138.602 E.01476
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.602 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.602 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.602 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.602 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.602 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.602 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.602 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.603 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.603 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.603 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.603 E.06229
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.0181
G1 X161.74 Y138.334 E.0136
G1 X162.092 Y138.062 E.01428
G1 X162.423 Y137.583 E.01872
G1 X162.542 Y137.258 E.01115
; LINE_WIDTH: 0.44852
G1 X162.602 Y136.801 E.01476
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04969
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.0181
G1 X162.334 Y118.26 E.0136
G1 X162.061 Y117.907 E.01435
G1 X161.583 Y117.577 E.01866
G1 X161.479 Y117.539 E.00358
M204 S10000
G1 X161.315 Y117.921 F12000
G1 F6000
M204 S3000
G1 X161.186 Y117.858 E.00464
G1 X160.8 Y117.798 E.01254
G1 X139.199 Y117.798 E.6946
G1 X138.731 Y117.887 E.01532
G1 X138.505 Y117.991 E.00799
G2 X138.069 Y118.382 I.718 J1.24 E.01897
G1 X137.847 Y118.843 E.01645
G1 X137.799 Y119.167 E.01053
G1 X137.798 Y136.801 E.567
G1 X137.887 Y137.269 E.01533
G2 X138.373 Y137.925 I1.602 J-.677 E.02651
G1 X138.814 Y138.142 E.01582
G1 X139.2 Y138.202 E.01254
G1 X160.801 Y138.202 E.69459
G1 X161.269 Y138.113 E.01532
G2 X161.926 Y137.627 I-.677 J-1.602 E.02652
G1 X162.142 Y137.186 E.0158
G1 X162.202 Y136.801 E.01254
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.731 E.01532
G2 X161.627 Y118.075 I-1.601 J.676 E.02651
G1 X161.369 Y117.948 E.00926
M204 S250
G1 X161.151 Y118.261 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X160.8 Y118.19 E.01067
G1 X139.199 Y118.19 E.64341
G1 X138.742 Y118.304 E.01403
G1 X138.462 Y118.516 E.01047
G1 X138.254 Y118.854 E.0118
G1 X138.191 Y119.167 E.00954
G1 X138.19 Y136.801 E.52522
G1 X138.27 Y137.185 E.01168
G1 X138.516 Y137.538 E.01283
G1 X138.821 Y137.734 E.01079
G1 X139.2 Y137.81 E.01151
G1 X160.801 Y137.81 E.6434
G1 X161.184 Y137.73 E.01168
G1 X161.538 Y137.484 E.01284
G1 X161.734 Y137.179 E.01078
G1 X161.81 Y136.801 E.0115
G1 X161.81 Y119.199 E.52427
G1 X161.73 Y118.815 E.01168
G1 X161.484 Y118.462 E.01283
G1 X161.206 Y118.284 E.00985
; WIPE_START
M204 S3000
G1 X160.8 Y118.19 E-.15812
G1 X160.217 Y118.19 E-.22188
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.462 J1.126 P1  F12000
G1 X162.93 Y117.075 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.727 Y117.009 E.00687
G3 X161.009 Y117.008 I-.495 J-357.569 E.05525
; LINE_WIDTH: 0.44649
G1 X160.8 Y117.003 E.00665
; LINE_WIDTH: 0.43731
G1 X139.199 Y117.003 E.67297
; LINE_WIDTH: 0.44999
G3 X137.267 Y117.009 I-1.269 J-92.554 E.06213
G1 X137.086 Y117.066 E.00611
G1 X137.013 Y117.225 E.00562
G3 X137.01 Y118.958 I-233.95 J.505 E.05575
; LINE_WIDTH: 0.44525
G1 X137.005 Y119.167 E.00665
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.8 E.05072
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.8 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.8 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.8 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.8 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.8 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.8 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.8 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.8 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.751 I-92.401 J1.265 E.06273
G1 X137.084 Y138.936 E.00641
G1 X137.257 Y138.987 E.00581
G3 X138.991 Y138.99 I.469 J244.655 E.05575
; LINE_WIDTH: 0.44484
G1 X139.2 Y138.995 E.00662
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.995 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.995 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.995 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.995 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.996 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.996 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.996 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.996 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.997 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.997 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.997 E.06229
; LINE_WIDTH: 0.44999
G3 X162.751 Y138.991 I1.267 J92.552 E.06273
G1 X162.936 Y138.916 E.0064
G1 X162.987 Y138.743 E.00581
G3 X162.99 Y137.01 I232.683 J-.473 E.05572
; LINE_WIDTH: 0.44458
G1 X162.995 Y136.801 E.00663
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04969
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.291 I86.786 J-1.245 E.06138
; LINE_WIDTH: 0.44999
G1 X162.946 Y117.133 E.00527
M204 S10000
G1 X163.181 Y116.771 F12000
G1 F6000
M204 S3000
G1 X163.129 Y116.707 E.00263
G1 X162.815 Y116.611 E.01058
G2 X161.24 Y116.602 I-1.181 J70.378 E.05065
G1 X137.24 Y116.602 E.77173
G1 X136.895 Y116.693 E.01147
G1 X136.703 Y116.895 E.00897
G1 X136.606 Y117.176 E.00956
G1 X136.602 Y138.771 E.69439
G1 X136.7 Y139.113 E.01143
G1 X136.897 Y139.299 E.0087
G1 X137.176 Y139.394 E.0095
G1 X162.771 Y139.398 E.82302
G1 X163.113 Y139.3 E.01142
; object ids of layer 5 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer5 end: 47,58
M625
M73 P47 R9
G1 X163.299 Y139.103 E.00871
G1 X163.394 Y138.824 E.00949
G1 X163.397 Y117.291 E.69239
G1 X163.343 Y116.969 E.0105
G1 X163.219 Y116.817 E.0063
M204 S250
G1 X163.493 Y116.515 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.232 Y116.321 E.00967
G1 X162.963 Y116.238 E.00839
G2 X161.213 Y116.21 I-1.129 J16.091 E.05214
G1 X137.213 Y116.21 E.71486
G1 X136.817 Y116.3 E.01211
G2 X136.214 Y117.282 I.453 J.954 E.03629
G1 X136.21 Y138.79 E.64066
G2 X136.359 Y139.317 I1.748 J-.21 E.01637
G1 X136.559 Y139.551 E.00916
G1 X136.822 Y139.713 E.00921
G1 X137.257 Y139.786 E.01314
G1 X162.79 Y139.79 E.76052
G2 X163.317 Y139.641 I-.21 J-1.748 E.01637
G1 X163.551 Y139.441 E.00916
G1 X163.713 Y139.178 E.00921
G1 X163.786 Y138.743 E.01314
G1 X163.789 Y117.291 E.63895
G1 X163.712 Y116.821 E.0142
G1 X163.55 Y116.557 E.00922
G1 X163.541 Y116.55 E.00033
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.232 Y116.321 E-.14622
G1 X162.963 Y116.238 E-.10704
G1 X162.63 Y116.22 E-.12674
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1.4 I-.487 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.614 I102.702 J-1.174 E.04386
G1 X115.022 Y119.607 E.044
; LINE_WIDTH: 0.43484
G1 X114.979 Y119.607 E.00134
; LINE_WIDTH: 0.43509
G1 X112.979 Y119.606 E.06196
; LINE_WIDTH: 0.43535
G1 X110.979 Y119.606 E.062
; LINE_WIDTH: 0.4356
G1 X108.979 Y119.605 E.06204
; LINE_WIDTH: 0.43585
G1 X106.979 Y119.605 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.605 E.06212
; LINE_WIDTH: 0.43636
G1 X102.979 Y119.604 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.604 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.603 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.603 E.06228
; LINE_WIDTH: 0.44999
G3 X95.612 Y119.609 I-1.142 J-102.761 E.04396
G1 X95.604 Y120.978 E.04403
; LINE_WIDTH: 0.43623
G1 X95.604 Y121.021 E.00134
; LINE_WIDTH: 0.43637
G1 X95.604 Y123.021 E.06216
; LINE_WIDTH: 0.43651
G1 X95.604 Y125.021 E.06218
; LINE_WIDTH: 0.43665
G1 X95.604 Y127.021 E.0622
; LINE_WIDTH: 0.43679
G1 X95.604 Y129.021 E.06223
; LINE_WIDTH: 0.43693
G1 X95.603 Y131.021 E.06225
; LINE_WIDTH: 0.43707
G1 X95.603 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.603 Y135.021 E.06229
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-104.465 J1.157 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.714 Y136.742 F12000
G1 F6000
M204 S3000
G1 X116.72 Y136.74 E.00018
G1 X116.798 Y136.537 E.00701
G1 X116.797 Y119.451 E.54941
G1 X116.744 Y119.278 E.00581
G1 X116.6 Y119.207 E.00515
G1 X95.452 Y119.202 E.68003
G1 X95.288 Y119.25 E.0055
G1 X95.204 Y119.414 E.00589
G1 X95.202 Y136.548 E.55097
G1 X95.25 Y136.712 E.0055
G1 X95.463 Y136.798 E.00738
G1 X116.56 Y136.798 E.67837
G1 X116.658 Y136.762 E.00335
M204 S250
G1 X116.85 Y137.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X116.98 Y137.045 I-.401 J-.908 E.00441
G1 X117.132 Y136.845 E.00748
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.45 E.50798
G1 X117.152 Y119.198 E.0076
G1 X116.968 Y118.955 E.00908
G2 X116.554 Y118.815 I-.414 J.544 E.01323
G1 X95.417 Y118.81 E.62958
G1 X95.114 Y118.898 E.00939
G2 X94.833 Y119.285 I.351 J.551 E.01462
G2 X94.812 Y120.583 I22.874 J1.01 E.03866
G1 X94.81 Y136.583 E.47657
G1 X94.898 Y136.886 E.00939
G2 X95.155 Y137.132 I.806 J-.586 E.01065
G1 X95.495 Y137.19 E.01028
G1 X116.587 Y137.19 E.62823
G2 X116.794 Y137.137 I-.138 J-.983 E.00639
; WIPE_START
M204 S3000
G1 X116.98 Y137.045 E-.07892
G1 X117.132 Y136.845 E-.09542
G1 X117.19 Y136.505 E-.13109
G1 X117.19 Y136.309 E-.07457
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I.054 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01244
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02416
G1 X115.021 Y119.998 E.02428
; LINE_WIDTH: 0.43484
G1 X114.979 Y119.998 E.00133
; LINE_WIDTH: 0.43509
G1 X112.979 Y119.998 E.06196
; LINE_WIDTH: 0.43535
G1 X110.979 Y119.998 E.062
; LINE_WIDTH: 0.4356
G1 X108.979 Y119.998 E.06204
; LINE_WIDTH: 0.43585
G1 X106.979 Y119.998 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.998 E.06212
; LINE_WIDTH: 0.43636
G1 X102.979 Y119.998 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.998 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.997 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.997 E.06228
; LINE_WIDTH: 0.44605
G1 X96.808 Y120.008 E.00543
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.01908
G1 X95.998 Y120.979 E.02426
; LINE_WIDTH: 0.43623
G1 X95.998 Y121.021 E.00133
; LINE_WIDTH: 0.43637
G1 X95.998 Y123.021 E.06216
; LINE_WIDTH: 0.43651
G1 X95.998 Y125.021 E.06218
; LINE_WIDTH: 0.43665
G1 X95.998 Y127.021 E.0622
; LINE_WIDTH: 0.43679
G1 X95.997 Y129.021 E.06223
; LINE_WIDTH: 0.43693
G1 X95.997 Y131.021 E.06225
; LINE_WIDTH: 0.43707
G1 X95.997 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.997 Y135.021 E.06229
; LINE_WIDTH: 0.44614
G1 X96.008 Y135.192 E.00543
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00474
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.433 Y120.569 E.01425
G1 X115.022 Y120.398 E.01433
G1 X96.878 Y120.407 E.58341
G1 X96.568 Y120.568 E.01123
G1 X96.398 Y120.978 E.01431
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00564
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.846 E.00429
G2 X114.979 Y120.79 I-.155 J.185 E.00566
G1 X96.946 Y120.793 E.53711
G1 X96.845 Y120.845 E.00338
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.21 J-.127 P1  F12000
G1 X96.027 Y119.961 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42052
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00244
G1 X96.027 Y120.043 E.00244
G1 X96.051 Y120.002 E.00141
; WIPE_START
G1 X96.027 Y120.043 E-.08513
G1 X95.957 Y120.002 E-.14744
G1 X96.027 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I-1.217 J0 P1  F12000
G1 X96.026 Y135.957 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08513
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I0 J1.217 P1  F12000
G1 X116.021 Y135.957 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; WIPE_START
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F12000
G1 X116.022 Y119.965 Z1.4
G1 Z1
G1 E.4 F1800
; LINE_WIDTH: 0.41858
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00241
G1 X116.022 Y120.046 E.00241
G1 X116.046 Y120.006 E.00139
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.022 Y120.046 E-.08513
G1 X115.952 Y120.006 E-.14743
G1 X116.022 Y119.965 E-.14743
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L6
M991 S0 P5 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1.4 I.067 J1.215 P1  F12000
G1 X162.621 Y117.379 Z1.4
G1 Z1.2
G1 E.4 F1800
; LINE_WIDTH: 0.37464
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01695
G1 X162.415 Y117.756 E.01523
G1 X162.62 Y118.027 E.0089
G1 X162.621 Y117.439 E.01541
; WIPE_START
G1 X161.974 Y117.379 E-.2469
G1 X162.24 Y117.606 E-.1331
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-1.217 J.023 P1  F12000
G1 X162.618 Y137.98 Z1.6
G1 Z1.2
G1 E.4 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.341 Y138.334 E.01176
M73 P48 R9
G1 X161.971 Y138.622 E.01226
G1 X162.618 Y138.622 E.01693
G1 X162.618 Y138.04 E.01521
; WIPE_START
G1 X162.341 Y138.334 E-.15358
G1 X161.971 Y138.622 E-.17814
G1 X162.098 Y138.622 E-.04829
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z1.6
G1 Z1.2
G1 E.4 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01188
G1 X137.379 Y137.972 E.01231
G1 X137.379 Y138.621 E.01702
G1 X137.964 Y138.621 E.01536
; WIPE_START
G1 X137.667 Y138.343 E-.15473
G1 X137.379 Y137.972 E-.17839
G1 X137.379 Y138.096 E-.04688
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.216 J.038 P1  F12000
G1 X138.033 Y117.378 Z1.6
G1 Z1.2
G1 E.4 F1800
; LINE_WIDTH: 0.37261
G1 F6000
M204 S3000
G1 X137.381 Y117.378 E.01697
G1 X137.381 Y118.026 E.01688
G1 X137.664 Y117.657 E.01211
G1 X137.985 Y117.414 E.01049
; WIPE_START
G1 X137.381 Y117.378 E-.22992
G1 X137.381 Y117.772 E-.15008
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I.014 J1.217 P1  F12000
G1 X161.372 Y117.499 Z1.6
G1 Z1.2
G1 E.4 F1800
; LINE_WIDTH: 0.45833
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00736
G2 X160.8 Y117.397 I-.298 J1.425 E.01184
; LINE_WIDTH: 0.43731
G1 X139.199 Y117.397 E.67296
; LINE_WIDTH: 0.4495
G1 X138.693 Y117.473 E.01644
; LINE_WIDTH: 0.44999
G1 X138.35 Y117.611 E.01189
G1 X137.929 Y117.913 E.01668
G1 X137.653 Y118.279 E.01473
; LINE_WIDTH: 0.45046
G1 X137.493 Y118.626 E.0123
G1 X137.399 Y119.167 E.01769
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.666 Y137.74 E.0136
G1 X137.939 Y138.093 E.01434
G1 X138.416 Y138.423 E.01866
G1 X138.742 Y138.543 E.01116
; LINE_WIDTH: 0.44904
G1 X139.2 Y138.603 E.0148
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.603 E.67297
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.01811
G1 X161.74 Y138.333 E.0136
G1 X162.092 Y138.062 E.01428
G1 X162.423 Y137.583 E.01873
G1 X162.542 Y137.257 E.01115
; LINE_WIDTH: 0.44852
G1 X162.602 Y136.8 E.01477
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04967
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.0181
G1 X162.334 Y118.26 E.01361
G1 X162.121 Y117.979 E.01133
G1 X161.799 Y117.704 E.01361
G1 X161.489 Y117.538 E.01132
; LINE_WIDTH: 0.45833
G1 X161.429 Y117.518 E.00208
M204 S10000
G1 X161.27 Y117.91 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.103 Y117.834 E.00591
G1 X160.8 Y117.798 E.00979
G1 X139.199 Y117.798 E.6946
G1 X139.086 Y117.809 E.00366
G1 X138.571 Y117.953 E.0172
G1 X138.221 Y118.197 E.01371
G1 X137.983 Y118.517 E.01283
G1 X137.889 Y118.721 E.00722
G1 X137.799 Y119.167 E.01464
G1 X137.798 Y136.801 E.56701
G1 X137.887 Y137.269 E.01532
G1 X137.991 Y137.494 E.008
G2 X138.373 Y137.925 I1.274 J-.744 E.01863
G1 X138.814 Y138.142 E.0158
G1 X139.2 Y138.202 E.01256
G1 X160.801 Y138.202 E.69459
G1 X161.269 Y138.113 E.01532
G2 X161.926 Y137.627 I-.677 J-1.603 E.02653
G1 X162.142 Y137.186 E.0158
G1 X162.202 Y136.8 E.01255
G1 X162.202 Y119.199 E.56597
G1 X162.113 Y118.732 E.01532
G2 X161.607 Y118.063 I-1.545 J.644 E.02724
G1 X161.325 Y117.935 E.00997
M204 S250
G1 X161.116 Y118.246 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.00015
G1 X160.8 Y118.19 E.00941
G1 X139.199 Y118.19 E.64341
G1 X138.849 Y118.256 E.01062
G1 X138.536 Y118.443 E.01086
G1 X138.301 Y118.746 E.01144
G1 X138.191 Y119.167 E.01297
G1 X138.19 Y136.801 E.52522
G1 X138.304 Y137.258 E.01403
G1 X138.516 Y137.538 E.01048
G1 X138.821 Y137.733 E.01077
G1 X139.2 Y137.81 E.01152
G1 X160.801 Y137.81 E.6434
G1 X161.185 Y137.73 E.01168
G1 X161.539 Y137.484 E.01284
G1 X161.734 Y137.179 E.01077
G1 X161.81 Y136.8 E.01151
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.816 E.01168
G1 X161.484 Y118.461 E.01285
G1 X161.168 Y118.276 E.01091
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.02471
G1 X160.8 Y118.19 E-.12007
G1 X160.182 Y118.19 E-.23522
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I.471 J1.122 P1  F12000
G1 X162.901 Y117.049 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.706 Y117.009 E.0064
G3 X160.963 Y117.006 I-.542 J-160.212 E.05604
; LINE_WIDTH: 0.44285
G1 X160.8 Y117.003 E.00513
; LINE_WIDTH: 0.43731
G1 X139.199 Y117.003 E.67296
; LINE_WIDTH: 0.4495
G1 X138.647 Y117.009 E.01773
; LINE_WIDTH: 0.44999
G1 X137.249 Y117.009 E.04497
G1 X137.065 Y117.083 E.00636
G1 X137.013 Y117.26 E.00594
G1 X137.013 Y118.072 E.02612
; LINE_WIDTH: 0.45244
G3 X137.005 Y119.167 I-17.657 J.432 E.03543
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.8 E.05072
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.8 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.8 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.8 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.8 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.8 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.8 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.8 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.8 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.732 I-91.421 J1.255 E.06211
G1 X137.071 Y138.924 E.0065
G1 X137.315 Y138.991 E.00814
G3 X138.991 Y138.993 I.477 J353.311 E.05388
; LINE_WIDTH: 0.44657
G1 X139.2 Y138.997 E.00666
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.997 E.67297
; LINE_WIDTH: 0.44999
G3 X162.732 Y138.991 I1.27 J92.604 E.06209
G1 X162.932 Y138.923 E.0068
G1 X162.987 Y138.716 E.00687
G3 X162.99 Y137.009 I229.108 J-.462 E.05491
; LINE_WIDTH: 0.44457
G1 X162.995 Y136.8 E.00661
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04967
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.207 I90.651 J-1.287 E.06408
; LINE_WIDTH: 0.44999
G1 X162.93 Y117.101 E.0039
M204 S10000
G1 X163.144 Y116.724 F12000
G1 F6000
M204 S3000
G1 X163.129 Y116.707 E.00072
G1 X162.816 Y116.611 E.01053
G2 X161.229 Y116.602 I-1.215 J75.584 E.05104
G1 X137.229 Y116.602 E.77173
G1 X136.882 Y116.704 E.01163
G1 X136.701 Y116.897 E.00852
G1 X136.606 Y117.176 E.00948
G1 X136.602 Y138.76 E.69403
G1 X136.678 Y139.062 E.01
G1 X136.809 Y139.243 E.00719
G1 X137.1 Y139.371 E.01024
G2 X138.76 Y139.398 I1.266 J-26.685 E.05337
G1 X162.76 Y139.398 E.77173
G1 X163.057 Y139.325 E.00985
G1 X163.247 Y139.188 E.00753
; object ids of layer 6 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer6 end: 47,58
M625
G1 X163.376 Y138.898 E.01021
G2 X163.394 Y137.2 I-41.588 J-1.29 E.0546
G1 X163.397 Y117.2 E.64311
G1 X163.338 Y116.952 E.00821
G1 X163.183 Y116.77 E.00769
M204 S250
G1 X163.441 Y116.463 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.107 Y116.261 E.01161
G1 X162.706 Y116.21 E.01205
G1 X137.21 Y116.21 E.75942
G2 X136.676 Y116.363 I.222 J1.778 E.0166
G1 X136.449 Y116.558 E.00891
G1 X136.287 Y116.822 E.00922
G1 X136.214 Y117.26 E.01322
G1 X136.21 Y138.787 E.6412
G2 X136.556 Y139.549 I1.132 J-.054 E.02554
G1 X136.858 Y139.726 E.01042
G1 X137.315 Y139.79 E.01375
G1 X162.786 Y139.79 E.75868
G2 X163.55 Y139.443 I-.054 J-1.133 E.0256
G1 X163.713 Y139.178 E.00926
G1 X163.786 Y138.716 E.01391
G1 X163.789 Y117.2 E.64088
G1 X163.697 Y116.786 E.01264
G1 X163.48 Y116.507 E.01053
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.107 Y116.261 E-.16983
G1 X162.706 Y116.21 E-.15375
G1 X162.557 Y116.21 E-.05643
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1.6 I-.487 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.614 I102.697 J-1.174 E.04386
G1 X115.022 Y119.607 E.044
; LINE_WIDTH: 0.43482
G1 X114.979 Y119.607 E.00134
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.606 E.06196
; LINE_WIDTH: 0.43533
G1 X110.979 Y119.606 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.605 E.06204
; LINE_WIDTH: 0.43584
G1 X106.979 Y119.605 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.605 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.604 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.604 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.603 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.603 E.06228
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.146 J-103.83 E.04404
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.75 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00738
G1 X116.797 Y119.418 E.55046
G1 X116.718 Y119.265 E.00552
G1 X116.562 Y119.207 E.00535
G1 X95.452 Y119.202 E.67882
G1 X95.288 Y119.251 E.00551
G1 X95.202 Y119.463 E.00738
G1 X95.202 Y136.56 E.54974
G1 X95.26 Y136.72 E.00546
G1 X95.463 Y136.798 E.00701
G1 X116.548 Y136.798 E.67798
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
M73 P49 R9
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.586 J-.806 E.01066
G1 X117.19 Y136.505 E.01027
G1 X117.189 Y119.418 E.50895
G2 X117.075 Y119.058 I-.99 J.115 E.01132
G1 X116.881 Y118.886 E.00771
G1 X116.562 Y118.815 E.00973
G1 X95.417 Y118.81 E.62982
G1 X95.114 Y118.898 E.0094
G2 X94.868 Y119.155 I.584 J.804 E.01065
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.587 E.50909
G2 X94.955 Y136.98 I.983 J-.138 E.01258
G1 X95.155 Y137.132 E.00747
G1 X95.495 Y137.19 E.01029
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.10777
G1 X117.132 Y136.845 E-.04893
G1 X117.19 Y136.505 E-.13107
G1 X117.19 Y136.262 E-.09224
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I.05 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02416
G1 X115.021 Y119.998 E.02428
; LINE_WIDTH: 0.43482
G1 X114.979 Y119.998 E.00133
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.998 E.06196
; LINE_WIDTH: 0.43533
G1 X110.979 Y119.998 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.998 E.06204
; LINE_WIDTH: 0.43584
G1 X106.979 Y119.998 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.998 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.998 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.998 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.997 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.997 E.06228
; LINE_WIDTH: 0.44605
G1 X96.808 Y120.008 E.00543
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01912
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.433 Y120.569 E.01425
G1 X115.022 Y120.398 E.01433
G1 X96.979 Y120.398 E.58019
G1 X96.878 Y120.407 E.00323
G1 X96.568 Y120.568 E.01125
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.846 E.00429
G2 X114.979 Y120.79 I-.155 J.185 E.00566
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00564
G1 X96.793 Y134.994 E.41618
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z1.6
G1 Z1.2
G1 E.4 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08513
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I0 J1.217 P1  F12000
G1 X116.022 Y119.965 Z1.6
G1 Z1.2
G1 E.4 F1800
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00241
G1 X116.022 Y120.046 E.00241
G1 X116.046 Y120.006 E.00139
; WIPE_START
G1 X116.022 Y120.046 E-.08513
G1 X115.952 Y120.006 E-.14743
G1 X116.022 Y119.965 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.6 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z1.6
G1 Z1.2
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L7
M991 S0 P6 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1.6 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z1.6
G1 Z1.4
G1 E.4 F1800
; LINE_WIDTH: 0.37465
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01695
G1 X162.416 Y117.756 E.01524
G1 X162.621 Y118.027 E.00889
G1 X162.621 Y117.439 E.01542
; WIPE_START
G1 X161.974 Y117.379 E-.24692
G1 X162.24 Y117.606 E-.13308
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-1.217 J.023 P1  F12000
G1 X162.621 Y137.976 Z1.8
G1 Z1.4
G1 E.4 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.343 Y138.333 E.01188
G1 X161.972 Y138.621 E.01232
G1 X162.621 Y138.621 E.01703
G1 X162.621 Y138.036 E.01535
; WIPE_START
G1 X162.343 Y138.333 E-.15471
G1 X161.972 Y138.621 E-.17846
G1 X162.095 Y138.621 E-.04683
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z1.8
G1 Z1.4
G1 E.4 F1800
; LINE_WIDTH: 0.37496
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01187
G1 X137.379 Y137.972 E.01231
G1 X137.379 Y138.621 E.01702
G1 X137.964 Y138.621 E.01535
; WIPE_START
G1 X137.667 Y138.343 E-.15469
G1 X137.379 Y137.972 E-.17841
G1 X137.379 Y138.096 E-.0469
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.216 J.039 P1  F12000
G1 X138.035 Y117.378 Z1.8
G1 Z1.4
G1 E.4 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01708
G1 X137.382 Y118.021 E.01682
G1 X137.736 Y117.601 E.01437
G1 X137.987 Y117.414 E.00819
; WIPE_START
G1 X137.382 Y117.378 E-.23028
G1 X137.382 Y117.772 E-.14972
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.014 J1.217 P1  F12000
G1 X161.373 Y117.499 Z1.8
G1 Z1.4
G1 E.4 F1800
; LINE_WIDTH: 0.45828
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00742
G2 X160.8 Y117.397 I-.298 J1.426 E.01183
; LINE_WIDTH: 0.43733
G1 X159.135 Y117.397 E.05189
; LINE_WIDTH: 0.43746
G1 X157.135 Y117.398 E.06233
; LINE_WIDTH: 0.43758
G1 X155.135 Y117.398 E.06235
; LINE_WIDTH: 0.43771
G1 X153.135 Y117.398 E.06237
; LINE_WIDTH: 0.43783
G1 X151.135 Y117.398 E.06239
; LINE_WIDTH: 0.43796
G1 X149.135 Y117.398 E.06241
; LINE_WIDTH: 0.43808
G1 X147.135 Y117.398 E.06243
; LINE_WIDTH: 0.43821
G1 X145.135 Y117.399 E.06245
; LINE_WIDTH: 0.43833
G1 X143.135 Y117.399 E.06247
; LINE_WIDTH: 0.43846
G1 X141.135 Y117.399 E.06249
; LINE_WIDTH: 0.43859
G1 X139.135 Y117.399 E.06251
; LINE_WIDTH: 0.44752
G1 X138.965 Y117.409 E.00545
; LINE_WIDTH: 0.44999
G2 X137.557 Y118.463 I.288 J1.851 E.05885
G1 X137.448 Y118.773 E.01056
; LINE_WIDTH: 0.4479
G1 X137.399 Y119.168 E.01274
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.666 Y137.74 E.0136
G1 X137.939 Y138.093 E.01434
G1 X138.416 Y138.423 E.01865
G1 X138.742 Y138.543 E.01116
; LINE_WIDTH: 0.44904
G1 X139.199 Y138.603 E.0148
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.603 E.67298
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.01811
G1 X161.74 Y138.334 E.0136
G1 X162.093 Y138.061 E.01434
G1 X162.423 Y137.583 E.01867
G1 X162.543 Y137.258 E.01116
; LINE_WIDTH: 0.44897
G1 X162.603 Y136.801 E.01478
; LINE_WIDTH: 0.43719
G1 X162.603 Y131.199 E.17444
; LINE_WIDTH: 0.43706
G1 X162.603 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.603 Y119.199 E.18674
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.01811
G1 X162.333 Y118.26 E.0136
G1 X162.121 Y117.979 E.01131
G1 X161.799 Y117.704 E.01361
G1 X161.489 Y117.538 E.01133
; LINE_WIDTH: 0.45828
G1 X161.43 Y117.519 E.00203
M204 S10000
G1 X161.272 Y117.911 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.102 Y117.834 E.00597
G1 X160.8 Y117.798 E.00978
G1 X139.135 Y117.8 E.69667
G1 X138.669 Y117.909 E.01538
G2 X138.069 Y118.382 I.711 J1.519 E.02479
G1 X137.847 Y118.844 E.01646
G1 X137.799 Y119.168 E.01053
G1 X137.798 Y136.801 E.56699
G1 X137.887 Y137.268 E.01532
G2 X138.373 Y137.926 I1.603 J-.678 E.02653
G1 X138.814 Y138.142 E.01579
G1 X139.199 Y138.202 E.01256
G1 X160.801 Y138.202 E.6946
G1 X161.269 Y138.113 E.01532
G2 X161.925 Y137.627 I-.677 J-1.603 E.02652
G1 X162.142 Y137.186 E.01581
G1 X162.202 Y136.801 E.01254
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.731 E.01532
G2 X161.607 Y118.063 I-1.544 J.644 E.02722
G1 X161.326 Y117.936 E.00993
M204 S250
G1 X161.118 Y118.247 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.0002
G1 X160.8 Y118.19 E.00941
G1 X139.135 Y118.193 E.64532
G1 X138.776 Y118.287 E.01106
G1 X138.459 Y118.518 E.01169
G1 X138.254 Y118.854 E.0117
G1 X138.191 Y119.168 E.00954
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01168
G1 X138.516 Y137.538 E.01285
G1 X138.82 Y137.733 E.01076
G1 X139.199 Y137.81 E.01152
G1 X160.801 Y137.81 E.64341
G1 X161.184 Y137.73 E.01168
G1 X161.538 Y137.484 E.01284
G1 X161.734 Y137.179 E.01078
G1 X161.81 Y136.801 E.01151
G1 X161.81 Y119.199 E.52426
M73 P50 R9
G1 X161.73 Y118.815 E.01168
G1 X161.484 Y118.462 E.01284
G1 X161.169 Y118.277 E.01087
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.0254
G1 X160.8 Y118.19 E-.12001
G1 X160.183 Y118.19 E-.23459
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.455 J1.129 P1  F12000
G1 X162.933 Y117.083 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.779 Y117.017 E.00537
G1 X161.973 Y117.009 E.02592
; LINE_WIDTH: 0.45828
G3 X160.8 Y117.003 I-.488 J-18.087 E.0385
; LINE_WIDTH: 0.43733
G1 X159.135 Y117.003 E.05189
; LINE_WIDTH: 0.43746
G1 X157.135 Y117.003 E.06233
; LINE_WIDTH: 0.43758
G1 X155.135 Y117.003 E.06235
; LINE_WIDTH: 0.43771
G1 X153.135 Y117.003 E.06237
; LINE_WIDTH: 0.43783
G1 X151.135 Y117.003 E.06239
; LINE_WIDTH: 0.43796
G1 X149.135 Y117.003 E.06241
; LINE_WIDTH: 0.43808
G1 X147.135 Y117.003 E.06243
; LINE_WIDTH: 0.43821
G1 X145.135 Y117.003 E.06245
; LINE_WIDTH: 0.43833
G1 X143.135 Y117.003 E.06247
; LINE_WIDTH: 0.43846
G1 X141.135 Y117.003 E.06249
; LINE_WIDTH: 0.43859
G1 X139.135 Y117.003 E.06251
; LINE_WIDTH: 0.44999
G3 X137.266 Y117.009 I-1.257 J-105.924 E.06008
G1 X137.086 Y117.066 E.00609
G1 X137.013 Y117.225 E.00562
G3 X137.01 Y118.959 I-232.323 J.506 E.05578
; LINE_WIDTH: 0.44519
G1 X137.005 Y119.168 E.00663
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.8 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.8 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.8 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.8 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.8 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.712 I-90.194 J1.244 E.06148
G1 X137.075 Y138.93 E.00731
G1 X137.301 Y138.991 E.00751
G3 X138.99 Y138.993 I.484 J358.274 E.05433
; LINE_WIDTH: 0.44657
G1 X139.199 Y138.997 E.00666
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.997 E.67298
; LINE_WIDTH: 0.44999
G3 X162.71 Y138.991 I1.258 J91.348 E.0614
G1 X162.929 Y138.925 E.00735
G1 X162.991 Y138.699 E.00754
G3 X162.993 Y137.009 I325.364 J-.494 E.05433
; LINE_WIDTH: 0.44622
G1 X162.997 Y136.801 E.00665
; LINE_WIDTH: 0.43719
G1 X162.997 Y131.199 E.17444
; LINE_WIDTH: 0.43706
G1 X162.997 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.997 Y119.199 E.18674
; LINE_WIDTH: 0.45008
G3 X162.99 Y117.263 I89.106 J-1.273 E.06227
; LINE_WIDTH: 0.44999
G1 X162.951 Y117.14 E.00416
M204 S10000
G1 X163.185 Y116.761 F12000
G1 F6000
M204 S3000
G1 X162.98 Y116.637 E.0077
G1 X162.455 Y116.602 E.01694
G1 X137.239 Y116.602 E.81082
G1 X136.895 Y116.693 E.01145
G1 X136.703 Y116.895 E.00897
G1 X136.606 Y117.176 E.00956
G1 X136.602 Y138.748 E.69366
G1 X136.695 Y139.092 E.01144
G1 X136.848 Y139.275 E.00768
G1 X137.108 Y139.376 E.00897
G2 X138.747 Y139.398 I1.252 J-32.378 E.05272
G1 X162.747 Y139.398 E.77173
G1 X163.104 Y139.299 E.01193
G1 X163.275 Y139.152 E.00724
; object ids of layer 7 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer7 end: 47,58
M625
G1 X163.376 Y138.893 E.00895
G2 X163.398 Y137.263 I-32.011 J-1.246 E.05241
G1 X163.397 Y117.263 E.64311
G1 X163.365 Y117.028 E.00762
G1 X163.218 Y116.811 E.00845
M204 S250
G1 X163.409 Y116.435 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.348 Y116.378 E.0025
G1 X163.098 Y116.258 E.00824
G1 X162.71 Y116.21 E.01166
G1 X137.213 Y116.21 E.75944
G1 X136.819 Y116.299 E.01204
G2 X136.214 Y117.281 I.451 J.955 E.03633
G1 X136.21 Y138.783 E.64046
G1 X136.274 Y139.144 E.01091
G1 X136.425 Y139.413 E.00921
G1 X136.618 Y139.598 E.00794
G1 X136.895 Y139.739 E.00927
G1 X137.315 Y139.79 E.0126
G1 X162.783 Y139.79 E.75858
G2 X163.598 Y139.382 I-.042 J-1.104 E.028
G1 X163.739 Y139.105 E.00926
G1 X163.79 Y138.682 E.0127
G1 X163.789 Y117.263 E.63797
G1 X163.74 Y116.898 E.01097
G1 X163.574 Y116.587 E.0105
G1 X163.453 Y116.476 E.00491
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.348 Y116.378 E-.05471
G1 X163.098 Y116.258 E-.10514
G1 X162.71 Y116.21 E-.14874
G1 X162.522 Y116.21 E-.07141
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z1.8 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.614 I102.697 J-1.174 E.04386
G1 X115.022 Y119.607 E.044
; LINE_WIDTH: 0.43482
G1 X114.979 Y119.607 E.00134
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.606 E.06196
; LINE_WIDTH: 0.43533
G1 X110.979 Y119.606 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.605 E.06204
; LINE_WIDTH: 0.43584
G1 X106.979 Y119.605 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.605 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.604 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.604 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.603 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.603 E.06228
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.146 J-103.831 E.04404
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00737
G1 X116.797 Y119.416 E.55052
G1 X116.715 Y119.258 E.00573
G1 X116.554 Y119.207 E.0054
G1 X95.452 Y119.202 E.67857
G1 X95.288 Y119.251 E.0055
G1 X95.202 Y119.463 E.00738
G1 X95.202 Y136.56 E.54974
G1 X95.26 Y136.72 E.00547
G1 X95.463 Y136.798 E.007
G1 X116.548 Y136.798 E.67799
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.584 J-.804 E.01066
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.416 E.509
G2 X117.059 Y119.036 I-1.067 J.153 E.01202
G1 X116.883 Y118.886 E.0069
G1 X116.555 Y118.815 E.01
G1 X95.417 Y118.81 E.6296
G1 X95.114 Y118.898 E.0094
G2 X94.868 Y119.155 I.585 J.805 E.01065
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.587 E.50909
G2 X94.955 Y136.981 I.983 J-.139 E.0126
G1 X95.155 Y137.132 E.00747
G1 X95.495 Y137.19 E.01027
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.10779
G1 X117.132 Y136.845 E-.04887
G1 X117.19 Y136.505 E-.13112
G1 X117.19 Y136.262 E-.09223
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I.05 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02416
G1 X115.021 Y119.998 E.02428
; LINE_WIDTH: 0.43482
G1 X114.979 Y119.998 E.00133
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.998 E.06196
; LINE_WIDTH: 0.43533
G1 X110.979 Y119.998 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.998 E.06204
; LINE_WIDTH: 0.43584
G1 X106.979 Y119.998 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.998 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.998 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.998 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.997 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.997 E.06228
; LINE_WIDTH: 0.44605
G1 X96.808 Y120.008 E.00543
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01912
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.433 Y120.569 E.01425
G1 X115.022 Y120.398 E.01433
G1 X96.979 Y120.398 E.58019
G1 X96.878 Y120.407 E.00323
G1 X96.568 Y120.568 E.01125
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.846 E.00429
G2 X114.979 Y120.79 I-.155 J.185 E.00566
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00564
G1 X96.793 Y134.994 E.41618
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
M73 P51 R9
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z1.8
G1 Z1.4
G1 E.4 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08513
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I0 J1.217 P1  F12000
G1 X116.022 Y119.965 Z1.8
G1 Z1.4
G1 E.4 F1800
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00241
G1 X116.022 Y120.046 E.00241
G1 X116.046 Y120.006 E.00139
; WIPE_START
G1 X116.022 Y120.046 E-.08513
G1 X115.952 Y120.006 E-.14743
G1 X116.022 Y119.965 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z1.8 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z1.8
G1 Z1.4
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L8
M991 S0 P7 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1.8 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z1.8
G1 Z1.6
G1 E.4 F1800
; LINE_WIDTH: 0.37465
G1 F6000
M204 S3000
G1 X161.976 Y117.379 E.01689
G1 X162.333 Y117.657 E.01185
G1 X162.621 Y118.027 E.01229
G1 X162.621 Y117.439 E.01541
; WIPE_START
G1 X161.976 Y117.379 E-.24606
G1 X162.254 Y117.595 E-.13394
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-1.217 J.022 P1  F12000
G1 X162.621 Y137.974 Z2
G1 Z1.6
G1 E.4 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X162.244 Y138.415 E.01523
G1 X161.972 Y138.621 E.00894
G1 X162.621 Y138.621 E.01702
G1 X162.621 Y138.034 E.01541
; WIPE_START
G1 X162.244 Y138.415 E-.20387
G1 X161.972 Y138.621 E-.12958
G1 X162.095 Y138.621 E-.04655
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I0 J-1.217 P1  F12000
G1 X138.023 Y138.618 Z2
G1 Z1.6
G1 E.4 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.585 Y138.244 E.01507
G1 X137.378 Y137.971 E.00896
G1 X137.378 Y138.618 E.01693
G1 X137.963 Y138.618 E.0153
; WIPE_START
G1 X137.585 Y138.244 E-.20224
G1 X137.378 Y137.971 E-.13014
G1 X137.378 Y138.096 E-.04762
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.216 J.038 P1  F12000
G1 X138.032 Y117.378 Z2
G1 Z1.6
G1 E.4 F1800
; LINE_WIDTH: 0.37271
G1 F6000
M204 S3000
G1 X137.381 Y117.378 E.01695
G1 X137.381 Y118.026 E.01688
G1 X137.665 Y117.657 E.01212
G1 X137.984 Y117.414 E.01044
; WIPE_START
G1 X137.381 Y117.378 E-.22946
G1 X137.381 Y117.774 E-.15054
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.013 J1.217 P1  F12000
G1 X161.425 Y117.519 Z2
G1 Z1.6
G1 E.4 F1800
; LINE_WIDTH: 0.44999
M73 P51 R8
G1 F6000
M204 S3000
G1 X161.258 Y117.457 E.00573
; LINE_WIDTH: 0.44901
G1 X160.801 Y117.397 E.01479
; LINE_WIDTH: 0.43731
G1 X139.199 Y117.397 E.67297
; LINE_WIDTH: 0.4495
G1 X138.693 Y117.473 E.01644
; LINE_WIDTH: 0.44999
G1 X138.354 Y117.609 E.01177
G1 X137.93 Y117.912 E.01674
G1 X137.655 Y118.275 E.01466
; LINE_WIDTH: 0.45046
G1 X137.493 Y118.625 E.0124
G1 X137.399 Y119.168 E.01773
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.667 Y137.74 E.01361
G1 X137.879 Y138.021 E.01133
G1 X138.202 Y138.296 E.01362
G1 X138.512 Y138.462 E.01132
; LINE_WIDTH: 0.45666
G2 X139.2 Y138.602 I.629 J-1.329 E.02315
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.602 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.602 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.602 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.602 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.602 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.602 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.602 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.603 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.603 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.603 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.603 E.06229
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.0181
G1 X161.74 Y138.333 E.01361
G1 X162.021 Y138.121 E.01133
G1 X162.296 Y137.799 E.01362
; LINE_WIDTH: 0.46173
G1 X162.569 Y137.195 E.02193
G1 X162.603 Y136.8 E.01309
; LINE_WIDTH: 0.43719
G1 X162.603 Y131.199 E.17444
; LINE_WIDTH: 0.43706
G1 X162.603 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.603 Y119.199 E.18674
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.0181
G1 X162.333 Y118.26 E.01361
G1 X162.061 Y117.907 E.01434
G1 X161.583 Y117.577 E.01866
G1 X161.481 Y117.54 E.00349
M204 S10000
G1 X161.318 Y117.922 F12000
G1 F6000
M204 S3000
G1 X161.186 Y117.858 E.00471
G1 X160.801 Y117.798 E.01254
G1 X139.199 Y117.798 E.69461
G1 X139.086 Y117.809 E.00366
G1 X138.573 Y117.952 E.01712
G1 X138.224 Y118.194 E.01367
G1 X137.984 Y118.515 E.01286
G1 X137.89 Y118.72 E.00728
G1 X137.799 Y119.168 E.01468
G1 X137.798 Y136.801 E.567
G1 X137.887 Y137.269 E.01532
G2 X138.393 Y137.937 I1.546 J-.645 E.02726
G1 X138.898 Y138.166 E.01781
G1 X139.199 Y138.202 E.00978
G1 X160.801 Y138.202 E.6946
G1 X161.269 Y138.113 E.01532
G2 X161.937 Y137.607 I-.645 J-1.546 E.02726
G1 X162.163 Y137.123 E.01716
G1 X162.202 Y136.8 E.01046
G1 X162.202 Y119.199 E.56597
G1 X162.113 Y118.731 E.01532
G2 X161.627 Y118.074 I-1.603 J.677 E.02653
G1 X161.372 Y117.949 E.00914
M204 S250
G1 X161.154 Y118.261 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X160.801 Y118.19 E.01073
G1 X139.199 Y118.19 E.64342
G1 X138.784 Y118.282 E.01267
G1 X138.541 Y118.438 E.00861
G1 X138.302 Y118.745 E.0116
G1 X138.191 Y119.168 E.01301
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01168
G1 X138.516 Y137.539 E.01286
G1 X138.888 Y137.757 E.01285
G1 X139.2 Y137.81 E.0094
G1 X160.801 Y137.81 E.64341
G1 X161.184 Y137.73 E.01168
G1 X161.539 Y137.484 E.01286
G1 X161.757 Y137.112 E.01284
G1 X161.81 Y136.8 E.00941
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.815 E.01168
G1 X161.484 Y118.461 E.01285
G1 X161.208 Y118.285 E.00975
; WIPE_START
M204 S3000
G1 X160.801 Y118.19 E-.15884
G1 X160.219 Y118.19 E-.22116
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.456 J1.128 P1  F12000
G1 X162.941 Y117.09 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.83 Y117.025 E.00412
G2 X161.298 Y117.009 I-1.195 J39.618 E.04927
; LINE_WIDTH: 0.44901
G1 X160.801 Y117.003 E.01594
; LINE_WIDTH: 0.43731
G1 X139.199 Y117.003 E.67297
; LINE_WIDTH: 0.4495
G1 X138.647 Y117.009 E.01773
; LINE_WIDTH: 0.44999
G1 X137.268 Y117.009 E.04435
G1 X137.085 Y117.066 E.00615
G1 X137.013 Y117.225 E.00561
G1 X137.013 Y118.067 E.02707
; LINE_WIDTH: 0.45046
G3 X137.005 Y119.167 I-43.748 J.265 E.03544
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.722 I-90.944 J1.25 E.06178
G1 X137.063 Y138.915 E.00645
G1 X137.225 Y138.987 E.00569
G3 X139.037 Y138.992 I.559 J135.32 E.05829
; LINE_WIDTH: 0.44121
G1 X139.2 Y138.995 E.0051
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.995 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.995 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.995 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.995 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.996 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.996 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.996 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.996 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.997 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.997 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.997 E.06229
; LINE_WIDTH: 0.44999
G3 X162.751 Y138.991 I1.266 J92.474 E.06273
G1 X162.904 Y138.938 E.00519
G1 X162.978 Y138.791 E.0053
G1 X162.991 Y137.972 E.02631
; LINE_WIDTH: 0.46173
G3 X162.997 Y136.8 I16.128 J-.499 E.03878
; LINE_WIDTH: 0.43719
G1 X162.997 Y131.199 E.17444
; LINE_WIDTH: 0.43706
G1 X162.997 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.997 Y119.199 E.18674
; LINE_WIDTH: 0.45008
G3 X162.99 Y117.291 I87.8 J-1.259 E.06137
; LINE_WIDTH: 0.44999
G1 X162.955 Y117.148 E.00474
M204 S10000
G1 X163.124 Y116.705 F12000
G1 F6000
M204 S3000
G1 X162.819 Y116.611 E.01025
G2 X161.24 Y116.602 I-1.186 J69.848 E.05077
G1 X137.24 Y116.602 E.77173
G1 X136.896 Y116.692 E.01144
G1 X136.703 Y116.895 E.00901
G1 X136.606 Y117.176 E.00956
G1 X136.602 Y138.754 E.69384
G1 X136.672 Y139.058 E.01003
G1 X136.813 Y139.247 E.00758
G1 X137.102 Y139.377 E.01021
G2 X138.771 Y139.395 I1.303 J-43.557 E.05367
G1 X162.771 Y139.398 E.77173
G1 X163.083 Y139.317 E.01036
; object ids of layer 8 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer8 end: 47,58
M625
G2 X163.355 Y138.996 I-.293 J-.523 E.01383
G1 X163.398 Y138.455 E.01744
G1 X163.397 Y117.291 E.68053
G1 X163.341 Y116.963 E.0107
G1 X163.162 Y116.751 E.00893
M204 S250
G1 X163.413 Y116.439 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.347 Y116.378 E.00268
G1 X163.107 Y116.261 E.00796
G1 X162.708 Y116.21 E.01198
G1 X137.213 Y116.21 E.75938
G1 X136.813 Y116.301 E.01222
G2 X136.214 Y117.283 I.459 J.954 E.03624
G1 X136.21 Y138.785 E.64043
G1 X136.261 Y139.108 E.00974
G1 X136.463 Y139.443 E.01165
G2 X137.297 Y139.786 I.838 J-.85 E.02756
G1 X162.79 Y139.79 E.75934
G2 X163.281 Y139.662 I-.185 J-1.717 E.01515
G1 X163.55 Y139.441 E.01038
G1 X163.729 Y139.132 E.01065
G1 X163.79 Y138.688 E.01334
G1 X163.789 Y117.291 E.63732
G1 X163.711 Y116.819 E.01428
G1 X163.577 Y116.59 E.00789
G1 X163.457 Y116.479 E.00486
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.347 Y116.378 E-.05695
G1 X163.107 Y116.261 E-.10153
G1 X162.708 Y116.21 E-.15284
G1 X162.527 Y116.21 E-.06869
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z2 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z2
M73 P52 R8
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.614 I102.699 J-1.174 E.04386
G1 X115.022 Y119.607 E.044
; LINE_WIDTH: 0.43483
G1 X114.979 Y119.607 E.00134
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.606 E.06196
; LINE_WIDTH: 0.43534
G1 X110.979 Y119.606 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.605 E.06204
; LINE_WIDTH: 0.43585
G1 X106.979 Y119.605 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.605 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.604 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.604 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.603 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.603 E.06228
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.146 J-103.83 E.04404
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.713 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00737
G1 X116.797 Y119.416 E.55053
G1 X116.706 Y119.255 E.00595
G1 X116.554 Y119.207 E.00511
G1 X95.452 Y119.202 E.67857
G1 X95.288 Y119.25 E.00549
G1 X95.202 Y119.463 E.00738
G1 X95.202 Y136.56 E.54975
G1 X95.26 Y136.719 E.00546
G1 X95.463 Y136.798 E.00701
G1 X116.548 Y136.798 E.67799
G1 X116.655 Y136.766 E.00359
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.582 J-.803 E.01065
G1 X117.19 Y136.505 E.01029
G1 X117.189 Y119.416 E.50901
G2 X117.06 Y119.038 I-1.024 J.14 E.01198
G1 X116.863 Y118.876 E.0076
G1 X116.554 Y118.815 E.00936
G1 X95.417 Y118.81 E.62959
G1 X95.114 Y118.898 E.00938
G2 X94.868 Y119.155 I.585 J.806 E.01067
G1 X94.81 Y119.495 E.01027
G1 X94.81 Y136.587 E.50909
G2 X94.955 Y136.98 I.982 J-.138 E.01258
G1 X95.155 Y137.132 E.00748
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.10769
G1 X117.132 Y136.845 E-.04887
G1 X117.19 Y136.505 E-.13124
G1 X117.19 Y136.262 E-.0922
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I.051 J-1.216 P1  F12000
G1 X96.104 Y135.379 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01235
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02416
G1 X115.021 Y119.998 E.02428
; LINE_WIDTH: 0.43483
G1 X114.979 Y119.998 E.00133
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.998 E.06196
; LINE_WIDTH: 0.43534
G1 X110.979 Y119.998 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.998 E.06204
; LINE_WIDTH: 0.43585
G1 X106.979 Y119.998 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.998 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.998 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.998 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.997 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.997 E.06228
; LINE_WIDTH: 0.44605
G1 X96.808 Y120.008 E.00543
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01912
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.076 Y135.325 E.00483
M204 S10000
G1 X96.448 Y135.202 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00833
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.433 Y120.569 E.01425
G1 X115.022 Y120.398 E.01433
G1 X96.979 Y120.398 E.58019
G1 X96.878 Y120.407 E.00323
G1 X96.568 Y120.568 E.01125
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.421 Y135.149 E.00098
M204 S250
G1 X96.791 Y135.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00421
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.846 E.00429
G2 X114.979 Y120.79 I-.155 J.185 E.00566
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00564
G1 X96.79 Y134.964 E.4153
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.07531
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.636 Y135.21 E-.23355
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-.512 J-1.104 P1  F12000
G1 X96.026 Y135.957 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z2
G1 Z1.6
G1 E.4 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08513
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I0 J1.217 P1  F12000
G1 X116.022 Y119.965 Z2
G1 Z1.6
G1 E.4 F1800
; LINE_WIDTH: 0.41858
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00241
G1 X116.022 Y120.046 E.00241
G1 X116.046 Y120.006 E.00139
; WIPE_START
G1 X116.022 Y120.046 E-.08513
G1 X115.952 Y120.006 E-.14743
G1 X116.022 Y119.965 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z2
G1 Z1.6
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L9
M991 S0 P8 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z2 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z2
G1 Z1.8
G1 E.4 F1800
; LINE_WIDTH: 0.37463
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01695
G1 X162.416 Y117.756 E.01523
G1 X162.621 Y118.027 E.0089
G1 X162.621 Y117.439 E.01542
; WIPE_START
G1 X161.974 Y117.379 E-.24691
G1 X162.24 Y117.606 E-.13309
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-1.217 J.023 P1  F12000
G1 X162.621 Y137.976 Z2.2
G1 Z1.8
G1 E.4 F1800
; LINE_WIDTH: 0.37496
G1 F6000
M204 S3000
G1 X162.343 Y138.333 E.01187
G1 X161.972 Y138.621 E.01231
G1 X162.621 Y138.621 E.01702
G1 X162.621 Y138.036 E.01535
; WIPE_START
G1 X162.343 Y138.333 E-.15466
G1 X161.972 Y138.621 E-.17838
G1 X162.096 Y138.621 E-.04696
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I0 J-1.217 P1  F12000
G1 X138.02 Y138.618 Z2.2
G1 Z1.8
G1 E.4 F1800
; LINE_WIDTH: 0.37395
G1 F6000
M204 S3000
G1 X137.666 Y138.341 E.01176
G1 X137.378 Y137.971 E.01226
G1 X137.378 Y138.618 E.01693
G1 X137.96 Y138.618 E.01521
; WIPE_START
G1 X137.666 Y138.341 E-.15363
G1 X137.378 Y137.971 E-.1781
G1 X137.378 Y138.098 E-.04827
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.216 J.038 P1  F12000
G1 X138.029 Y117.378 Z2.2
G1 Z1.8
G1 E.4 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01693
G1 X137.382 Y118.021 E.0168
G1 X137.659 Y117.666 E.01178
G1 X137.982 Y117.415 E.01069
; WIPE_START
G1 X137.382 Y117.378 E-.22845
G1 X137.382 Y117.777 E-.15155
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.014 J1.217 P1  F12000
G1 X161.376 Y117.5 Z2.2
G1 Z1.8
G1 E.4 F1800
; LINE_WIDTH: 0.45828
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00752
G2 X160.8 Y117.397 I-.298 J1.426 E.01184
; LINE_WIDTH: 0.4372
G1 X159.199 Y117.397 E.04987
; LINE_WIDTH: 0.43731
G1 X139.199 Y117.397 E.62308
; LINE_WIDTH: 0.44999
G1 X138.643 Y117.49 E.01812
G1 X138.26 Y117.667 E.01359
G1 X137.908 Y117.938 E.01427
G1 X137.571 Y118.43 E.01918
G1 X137.457 Y118.737 E.01053
; LINE_WIDTH: 0.44877
G1 X137.399 Y119.168 E.01394
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01809
G1 X137.666 Y137.74 E.0136
G2 X138.167 Y138.277 I1.599 J-.989 E.02376
G2 X138.742 Y138.542 I1.023 J-1.459 E.02049
; LINE_WIDTH: 0.44856
G1 X139.199 Y138.602 E.01478
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.602 E.04969
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.602 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.602 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.602 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.602 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.602 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.602 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.603 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.603 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.603 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.603 E.06229
; LINE_WIDTH: 0.44999
G1 X161.357 Y138.51 E.01812
G1 X161.741 Y138.333 E.0136
G1 X162.093 Y138.061 E.01432
G1 X162.423 Y137.583 E.01867
G1 X162.543 Y137.258 E.01115
; LINE_WIDTH: 0.44897
G1 X162.603 Y136.8 E.01479
; LINE_WIDTH: 0.43739
G1 X162.603 Y135.126 E.05217
; LINE_WIDTH: 0.43754
G1 X162.602 Y133.126 E.06234
; LINE_WIDTH: 0.43769
G1 X162.602 Y131.126 E.06237
; LINE_WIDTH: 0.43784
G1 X162.602 Y129.126 E.06239
; LINE_WIDTH: 0.43799
G1 X162.601 Y127.126 E.06242
; LINE_WIDTH: 0.43814
G1 X162.601 Y125.126 E.06244
; LINE_WIDTH: 0.43829
G1 X162.601 Y123.126 E.06246
; LINE_WIDTH: 0.43844
G1 X162.6 Y121.126 E.06249
; LINE_WIDTH: 0.43859
G1 X162.6 Y119.126 E.06251
; LINE_WIDTH: 0.45259
G1 X162.502 Y118.602 E.01727
G1 X162.334 Y118.26 E.01232
; LINE_WIDTH: 0.44999
G1 X162.121 Y117.979 E.01133
G1 X161.799 Y117.704 E.01362
G1 X161.488 Y117.538 E.01132
; LINE_WIDTH: 0.45828
G1 X161.433 Y117.52 E.00192
M204 S10000
G1 X161.275 Y117.912 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.103 Y117.834 E.00607
G1 X160.8 Y117.798 E.00979
G1 X139.199 Y117.798 E.6946
G1 X138.731 Y117.887 E.01533
G2 X138.073 Y118.375 I.672 J1.592 E.0266
G1 X137.856 Y118.814 E.01573
G1 X137.799 Y119.168 E.01152
G1 X137.798 Y136.801 E.56699
M73 P53 R8
G1 X137.887 Y137.268 E.01531
G2 X138.373 Y137.925 I1.603 J-.677 E.02653
G1 X138.814 Y138.142 E.0158
G1 X139.199 Y138.202 E.01255
G1 X160.801 Y138.202 E.6946
G1 X161.269 Y138.113 E.01534
G2 X161.926 Y137.627 I-.678 J-1.602 E.02652
G1 X162.142 Y137.186 E.0158
G1 X162.202 Y136.801 E.01255
G1 X162.199 Y119.126 E.56833
G1 X162.179 Y118.977 E.00484
G1 X162.009 Y118.506 E.01611
G2 X161.607 Y118.063 I-1.209 J.694 E.01937
G1 X161.329 Y117.937 E.00981
M204 S250
G1 X161.121 Y118.248 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.00031
G1 X160.8 Y118.19 E.00941
G1 X139.199 Y118.19 E.64341
G1 X138.815 Y118.27 E.01168
G1 X138.462 Y118.516 E.01282
G1 X138.263 Y118.83 E.01107
G1 X138.191 Y119.168 E.01029
G1 X138.19 Y136.801 E.52521
G1 X138.304 Y137.258 E.01403
G1 X138.571 Y137.587 E.01264
G1 X138.82 Y137.733 E.00861
G1 X139.199 Y137.81 E.01152
G1 X160.801 Y137.81 E.64341
G1 X161.185 Y137.73 E.01169
G1 X161.539 Y137.484 E.01284
G1 X161.734 Y137.179 E.01077
G1 X161.81 Y136.801 E.01151
G1 X161.807 Y119.126 E.52644
G1 X161.728 Y118.808 E.00978
G1 X161.484 Y118.461 E.01262
G1 X161.172 Y118.279 E.01075
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.02671
G1 X160.8 Y118.19 E-.12003
G1 X160.187 Y118.19 E-.23326
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.445 J1.133 P1  F12000
G1 X162.949 Y117.104 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.802 Y117.018 E.00549
G1 X161.973 Y117.009 E.02665
; LINE_WIDTH: 0.45828
G3 X160.8 Y117.003 I-.487 J-18.032 E.03847
; LINE_WIDTH: 0.4372
G1 X159.199 Y117.003 E.04987
; LINE_WIDTH: 0.43731
G1 X139.199 Y117.003 E.62308
; LINE_WIDTH: 0.44999
G3 X137.235 Y117.009 I-1.285 J-94.267 E.06316
G1 X137.051 Y117.104 E.00665
G1 X137.013 Y117.27 E.00549
G3 X137.011 Y118.942 I-344.176 J.447 E.05377
; LINE_WIDTH: 0.44677
G1 X137.005 Y119.168 E.0072
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.751 I-92.252 J1.264 E.06273
G1 X137.091 Y138.943 E.00671
G1 X137.268 Y138.987 E.00586
G3 X138.991 Y138.99 I.463 J245.15 E.05541
; LINE_WIDTH: 0.44486
G1 X139.199 Y138.995 E.00663
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.995 E.04969
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.995 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.995 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.995 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.996 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.996 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.996 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.996 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.997 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.997 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.997 E.06229
; LINE_WIDTH: 0.44999
G3 X162.722 Y138.991 I1.252 J91.242 E.06179
G1 X162.88 Y138.96 E.00518
G1 X162.973 Y138.834 E.00502
G2 X162.991 Y137.297 I-36.003 J-1.196 E.04943
; LINE_WIDTH: 0.44897
G1 X162.997 Y136.8 E.01594
; LINE_WIDTH: 0.43739
G1 X162.997 Y135.126 E.05217
; LINE_WIDTH: 0.43754
G1 X162.997 Y133.126 E.06234
; LINE_WIDTH: 0.43769
G1 X162.997 Y131.126 E.06237
; LINE_WIDTH: 0.43784
G1 X162.997 Y129.126 E.06239
; LINE_WIDTH: 0.43799
G1 X162.996 Y127.126 E.06242
; LINE_WIDTH: 0.43814
G1 X162.996 Y125.126 E.06244
; LINE_WIDTH: 0.43829
G1 X162.996 Y123.126 E.06246
; LINE_WIDTH: 0.43844
G1 X162.996 Y121.126 E.06249
; LINE_WIDTH: 0.43859
G1 X162.996 Y119.126 E.06251
; LINE_WIDTH: 0.45259
G3 X162.99 Y117.687 I53.519 J-.934 E.04656
; LINE_WIDTH: 0.44999
G1 X162.99 Y117.264 E.01363
G1 X162.964 Y117.162 E.00337
M204 S10000
G1 X163.183 Y116.769 F12000
G1 F6000
M204 S3000
G1 X162.954 Y116.628 E.00865
G2 X161.218 Y116.602 I-1.358 J32.589 E.05583
G1 X137.218 Y116.602 E.77173
G1 X136.934 Y116.675 E.00941
G1 X136.712 Y116.879 E.00972
G1 X136.606 Y117.182 E.01032
G1 X136.602 Y138.771 E.69421
G1 X136.7 Y139.113 E.01143
G1 X136.942 Y139.332 E.0105
G1 X137.267 Y139.394 E.01065
G1 X162.754 Y139.398 E.81954
G1 X163.11 Y139.303 E.01186
; object ids of layer 9 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer9 end: 47,58
M625
G1 X163.323 Y139.058 E.01042
G1 X163.398 Y138.754 E.01009
G1 X163.397 Y117.264 E.69103
G1 X163.364 Y117.023 E.00781
G1 X163.221 Y116.814 E.00815
M204 S250
G1 X163.395 Y116.424 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.347 Y116.378 E.00198
G1 X163.066 Y116.248 E.00922
G1 X162.455 Y116.21 E.01824
G1 X137.206 Y116.21 E.75205
G1 X136.752 Y116.32 E.01391
G1 X136.466 Y116.54 E.01076
G1 X136.304 Y116.784 E.00872
G1 X136.214 Y117.267 E.01464
G1 X136.21 Y138.79 E.64108
G2 X136.359 Y139.317 I1.723 J-.203 E.01637
G1 X136.56 Y139.553 E.00922
G1 X136.783 Y139.695 E.00789
G1 X137.132 Y139.786 E.01073
G1 X162.785 Y139.79 E.7641
G1 X163.108 Y139.739 E.00974
G1 X163.335 Y139.63 E.00752
G1 X163.6 Y139.379 E.01086
G1 X163.739 Y139.105 E.00915
G1 X163.79 Y138.699 E.01219
G1 X163.789 Y117.264 E.63847
G1 X163.74 Y116.897 E.01102
G1 X163.6 Y116.621 E.00921
G1 X163.438 Y116.466 E.00668
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.347 Y116.378 E-.04811
G1 X163.066 Y116.248 E-.11769
G1 X162.503 Y116.213 E-.2142
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z2.2 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.614 I102.697 J-1.174 E.04386
G1 X115.022 Y119.607 E.044
; LINE_WIDTH: 0.43482
G1 X114.979 Y119.607 E.00134
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.606 E.06196
; LINE_WIDTH: 0.43533
G1 X110.979 Y119.606 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.605 E.06204
; LINE_WIDTH: 0.43584
G1 X106.979 Y119.605 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.605 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.604 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.604 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.603 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.603 E.06228
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.146 J-103.831 E.04404
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.715 Y136.742 F12000
G1 F6000
M204 S3000
G1 X116.72 Y136.74 E.00016
G1 X116.798 Y136.537 E.00701
G1 X116.797 Y119.416 E.55053
G1 X116.706 Y119.254 E.00596
G1 X116.554 Y119.207 E.00511
G1 X95.452 Y119.202 E.67856
G1 X95.288 Y119.251 E.00551
G1 X95.202 Y119.464 E.00738
G1 X95.202 Y136.548 E.54937
G1 X95.251 Y136.712 E.0055
G1 X95.463 Y136.798 E.00738
G1 X116.559 Y136.798 E.67835
G1 X116.659 Y136.762 E.0034
M204 S250
G1 X116.85 Y137.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X116.98 Y137.045 I-.401 J-.907 E.0044
G1 X117.132 Y136.845 E.00747
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.416 E.50901
G2 X117.06 Y119.038 I-1.023 J.139 E.01198
G1 X116.863 Y118.876 E.0076
G1 X116.554 Y118.815 E.00935
G1 X95.417 Y118.81 E.62959
G1 X95.114 Y118.898 E.00941
G2 X94.868 Y119.155 I.584 J.804 E.01064
G1 X94.81 Y119.495 E.01029
G1 X94.81 Y136.583 E.50897
G1 X94.898 Y136.886 E.00939
G2 X95.155 Y137.132 I.805 J-.584 E.01066
G1 X95.495 Y137.19 E.01028
G1 X116.586 Y137.19 E.62822
G2 X116.795 Y137.137 I-.137 J-.982 E.00642
; WIPE_START
M204 S3000
G1 X116.98 Y137.045 E-.07879
G1 X117.132 Y136.845 E-.0953
G1 X117.19 Y136.505 E-.13115
G1 X117.19 Y136.308 E-.07476
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I.054 J-1.216 P1  F12000
G1 X96.104 Y135.379 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01235
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02416
G1 X115.021 Y119.998 E.02428
; LINE_WIDTH: 0.43482
G1 X114.979 Y119.998 E.00133
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.998 E.06196
; LINE_WIDTH: 0.43533
G1 X110.979 Y119.998 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.998 E.06204
; LINE_WIDTH: 0.43584
G1 X106.979 Y119.998 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.998 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.998 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.998 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.997 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.997 E.06228
; LINE_WIDTH: 0.44605
G1 X96.808 Y120.008 E.00543
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01912
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
M73 P54 R8
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.076 Y135.325 E.00483
M204 S10000
G1 X96.026 Y135.957 F12000
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
M204 S10000
G1 X96.448 Y135.202 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00833
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.433 Y120.569 E.01425
G1 X115.022 Y120.398 E.01433
G1 X96.979 Y120.398 E.58019
G1 X96.878 Y120.407 E.00323
G1 X96.568 Y120.568 E.01125
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.421 Y135.149 E.00098
M204 S250
G1 X96.791 Y135.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00421
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.846 E.00429
G2 X114.979 Y120.79 I-.155 J.185 E.00566
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00564
G1 X96.79 Y134.964 E.4153
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.07531
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.636 Y135.21 E-.23355
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I1.21 J-.128 P1  F12000
G1 X96.026 Y119.961 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08513
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I0 J1.217 P1  F12000
G1 X116.022 Y119.965 Z2.2
G1 Z1.8
G1 E.4 F1800
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00241
G1 X116.022 Y120.046 E.00241
G1 X116.046 Y120.006 E.00139
; WIPE_START
G1 X116.022 Y120.046 E-.08513
G1 X115.952 Y120.006 E-.14743
G1 X116.022 Y119.965 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.2 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z2.2
G1 Z1.8
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L10
M991 S0 P9 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z2.2 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z2.2
G1 Z2
G1 E.4 F1800
; LINE_WIDTH: 0.3746
G1 F6000
M204 S3000
G1 X161.976 Y117.379 E.01689
G1 X162.333 Y117.657 E.01185
G1 X162.62 Y118.027 E.01228
G1 X162.621 Y117.439 E.01541
; WIPE_START
G1 X161.976 Y117.379 E-.24608
G1 X162.254 Y117.595 E-.13392
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-1.217 J.022 P1  F12000
G1 X162.618 Y137.98 Z2.4
G1 Z2
G1 E.4 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.341 Y138.334 E.01176
G1 X161.971 Y138.622 E.01225
G1 X162.618 Y138.622 E.01693
G1 X162.618 Y138.04 E.01521
; WIPE_START
G1 X162.341 Y138.334 E-.15355
G1 X161.971 Y138.622 E-.17808
G1 X162.098 Y138.622 E-.04838
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I0 J-1.217 P1  F12000
G1 X138.02 Y138.618 Z2.4
G1 Z2
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X137.666 Y138.341 E.01176
G1 X137.378 Y137.971 E.01225
G1 X137.378 Y138.618 E.01693
G1 X137.96 Y138.618 E.01521
; WIPE_START
G1 X137.666 Y138.341 E-.15356
G1 X137.378 Y137.971 E-.17807
G1 X137.378 Y138.098 E-.04836
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I1.216 J.038 P1  F12000
G1 X138.034 Y117.378 Z2.4
G1 Z2
G1 E.4 F1800
; LINE_WIDTH: 0.37255
G1 F6000
M204 S3000
G1 X137.381 Y117.378 E.01699
G1 X137.381 Y118.025 E.01687
G1 X137.664 Y117.657 E.01209
G1 X137.986 Y117.414 E.01051
; WIPE_START
G1 X137.381 Y117.378 E-.23021
G1 X137.381 Y117.772 E-.1498
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I.013 J1.217 P1  F12000
G1 X161.427 Y117.52 Z2.4
G1 Z2
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.258 Y117.457 E.00578
; LINE_WIDTH: 0.44901
G1 X160.801 Y117.397 E.01479
; LINE_WIDTH: 0.43719
G1 X159.199 Y117.397 E.04988
; LINE_WIDTH: 0.43731
G1 X139.199 Y117.397 E.62308
; LINE_WIDTH: 0.44951
G1 X138.693 Y117.473 E.01645
; LINE_WIDTH: 0.44999
G1 X138.348 Y117.613 E.01197
G1 X137.928 Y117.914 E.01663
G1 X137.652 Y118.28 E.01474
; LINE_WIDTH: 0.45046
G1 X137.493 Y118.625 E.01223
G1 X137.399 Y119.168 E.01772
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01811
G1 X137.667 Y137.74 E.01361
G1 X137.938 Y138.092 E.01428
G1 X138.417 Y138.423 E.01874
G1 X138.743 Y138.543 E.01114
; LINE_WIDTH: 0.44856
G1 X139.199 Y138.602 E.01476
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.602 E.04969
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.602 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.602 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.602 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.602 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.602 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.602 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.603 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.603 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.603 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.603 E.06229
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.01811
G1 X161.74 Y138.333 E.01361
G1 X162.092 Y138.062 E.01428
G1 X162.423 Y137.583 E.01873
G1 X162.542 Y137.257 E.01114
; LINE_WIDTH: 0.44852
G1 X162.602 Y136.801 E.01476
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.0181
G1 X162.334 Y118.26 E.0136
G1 X162.061 Y117.907 E.01435
G1 X161.583 Y117.577 E.01866
G1 X161.483 Y117.54 E.00343
M204 S10000
G1 X161.32 Y117.923 F12000
G1 F6000
M204 S3000
G1 X161.186 Y117.858 E.00477
G1 X160.801 Y117.798 E.01254
G1 X139.199 Y117.798 E.69461
G1 X139.086 Y117.809 E.00367
G1 X138.569 Y117.954 E.01725
G1 X138.219 Y118.199 E.01374
G1 X137.982 Y118.518 E.01277
G1 X137.889 Y118.721 E.00718
G1 X137.799 Y119.168 E.01467
G1 X137.798 Y136.801 E.567
G1 X137.887 Y137.269 E.01532
G2 X138.373 Y137.926 I1.603 J-.678 E.02654
G1 X138.814 Y138.142 E.01579
G1 X139.199 Y138.202 E.01253
G1 X160.801 Y138.202 E.6946
G1 X161.269 Y138.113 E.01533
G2 X161.926 Y137.627 I-.678 J-1.603 E.02653
G1 X162.142 Y137.186 E.01579
G1 X162.202 Y136.801 E.01254
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.731 E.01532
G2 X161.627 Y118.074 I-1.602 J.677 E.02653
G1 X161.373 Y117.95 E.00909
M204 S250
G1 X161.156 Y118.262 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X160.801 Y118.19 E.01078
G1 X139.199 Y118.19 E.64342
G1 X138.783 Y118.283 E.01271
G1 X138.532 Y118.446 E.00891
G1 X138.301 Y118.746 E.01129
G1 X138.191 Y119.168 E.01298
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.185 E.01168
G1 X138.516 Y137.539 E.01285
G1 X138.821 Y137.734 E.01077
G1 X139.199 Y137.81 E.0115
G1 X160.801 Y137.81 E.64341
G1 X161.185 Y137.73 E.01168
G1 X161.539 Y137.484 E.01285
G1 X161.734 Y137.179 E.01077
G1 X161.81 Y136.801 E.0115
G1 X161.81 Y119.199 E.52427
G1 X161.73 Y118.816 E.01168
G1 X161.484 Y118.462 E.01284
G1 X161.209 Y118.286 E.00971
; WIPE_START
M204 S3000
G1 X160.801 Y118.19 E-.15945
G1 X160.22 Y118.19 E-.22055
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I.46 J1.127 P1  F12000
G1 X162.933 Y117.083 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.762 Y117.012 E.00594
G2 X161.298 Y117.009 I-1.268 J244.488 E.0471
; LINE_WIDTH: 0.44901
G1 X160.801 Y117.003 E.01594
; LINE_WIDTH: 0.43719
G1 X159.199 Y117.003 E.04988
; LINE_WIDTH: 0.43731
G1 X139.199 Y117.003 E.62308
; LINE_WIDTH: 0.44951
G1 X138.647 Y117.009 E.01774
; LINE_WIDTH: 0.44999
G1 X137.268 Y117.009 E.04433
G1 X137.085 Y117.066 E.00615
G1 X137.013 Y117.225 E.00561
G1 X137.013 Y118.075 E.02733
; LINE_WIDTH: 0.45244
G3 X137.005 Y119.168 I-17.599 J.431 E.03536
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.722 I-90.955 J1.25 E.06178
G1 X137.063 Y138.915 E.00646
G1 X137.225 Y138.987 E.00568
G3 X138.991 Y138.99 I.484 J250.185 E.0568
; LINE_WIDTH: 0.44485
G1 X139.199 Y138.995 E.00662
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.995 E.04969
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.995 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.995 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.995 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.996 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.996 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.996 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.996 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.997 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.997 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.997 E.06229
; LINE_WIDTH: 0.44999
G3 X162.722 Y138.991 I1.252 J91.184 E.06179
G1 X162.915 Y138.937 E.00645
G1 X162.987 Y138.775 E.00568
G3 X162.99 Y137.009 I237.552 J-.488 E.0568
; LINE_WIDTH: 0.44457
G1 X162.995 Y136.801 E.00662
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.264 I88.04 J-1.259 E.06226
; LINE_WIDTH: 0.44999
G1 X162.951 Y117.14 E.00416
M204 S10000
G1 X163.192 Y116.768 F12000
G1 F6000
M204 S3000
G1 X162.953 Y116.628 E.00889
G2 X161.24 Y116.602 I-1.32 J30.559 E.0551
G1 X137.24 Y116.602 E.77173
G1 X136.896 Y116.693 E.01146
G1 X136.703 Y116.895 E.009
G1 X136.606 Y117.176 E.00956
G1 X136.602 Y138.754 E.69384
G1 X136.671 Y139.057 E.00999
G1 X136.813 Y139.247 E.00764
G1 X137.102 Y139.377 E.01019
G2 X138.754 Y139.395 I1.268 J-40.647 E.05311
G1 X162.754 Y139.398 E.77173
G1 X163.057 Y139.329 E.00999
; object ids of layer 10 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer10 end: 47,58
M625
G1 X163.247 Y139.187 E.00762
G1 X163.377 Y138.898 E.0102
G2 X163.394 Y137.264 I-40.2 J-1.258 E.05254
G1 X163.397 Y117.264 E.64311
G1 X163.365 Y117.028 E.00764
G1 X163.225 Y116.818 E.00813
M204 S250
G1 X163.395 Y116.422 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.349 Y116.379 E.00189
G1 X163.066 Y116.248 E.00929
G1 X162.455 Y116.21 E.01823
G1 X137.213 Y116.21 E.75184
M73 P55 R8
G1 X136.813 Y116.301 E.01223
G2 X136.214 Y117.283 I.459 J.954 E.03624
G1 X136.21 Y138.785 E.64043
G1 X136.261 Y139.108 E.00974
G1 X136.463 Y139.442 E.01163
G2 X137.297 Y139.786 I.838 J-.847 E.02758
G1 X162.785 Y139.79 E.75918
G1 X163.108 Y139.739 E.00974
G1 X163.442 Y139.538 E.01161
G2 X163.786 Y138.703 I-.848 J-.838 E.02758
G1 X163.789 Y117.264 E.63859
G1 X163.74 Y116.898 E.01099
G1 X163.574 Y116.587 E.0105
G1 X163.439 Y116.463 E.00547
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.349 Y116.379 E-.0469
G1 X163.066 Y116.248 E-.11847
G1 X162.502 Y116.213 E-.21463
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z2.4 I-.337 J-1.169 P1  F12000
G1 X96.103 Y135.376 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01244
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02416
G1 X115.021 Y119.998 E.02428
; LINE_WIDTH: 0.43482
G1 X114.979 Y119.998 E.00133
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.998 E.06196
; LINE_WIDTH: 0.43533
G1 X110.979 Y119.998 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.998 E.06204
; LINE_WIDTH: 0.43584
G1 X106.979 Y119.998 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.998 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.998 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.998 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.997 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.997 E.06228
; LINE_WIDTH: 0.44605
G1 X96.808 Y120.008 E.00543
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.01908
G1 X95.998 Y120.979 E.02426
; LINE_WIDTH: 0.43623
G1 X95.998 Y121.021 E.00133
; LINE_WIDTH: 0.43637
G1 X95.998 Y123.021 E.06216
; LINE_WIDTH: 0.43651
G1 X95.998 Y125.021 E.06218
; LINE_WIDTH: 0.43665
G1 X95.998 Y127.021 E.0622
; LINE_WIDTH: 0.43679
G1 X95.997 Y129.021 E.06223
; LINE_WIDTH: 0.43693
G1 X95.997 Y131.021 E.06225
; LINE_WIDTH: 0.43707
G1 X95.997 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.997 Y135.021 E.06229
; LINE_WIDTH: 0.44614
G1 X96.008 Y135.192 E.00543
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00474
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.433 Y120.569 E.01425
G1 X115.022 Y120.398 E.01433
G1 X96.979 Y120.398 E.58019
G1 X96.878 Y120.407 E.00323
G1 X96.568 Y120.568 E.01123
G1 X96.398 Y120.978 E.01431
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00564
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.846 E.00429
G2 X114.979 Y120.79 I-.155 J.185 E.00566
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.00429
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-.076 J1.215 P1  F12000
G1 X116.391 Y136.391 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.614 I102.697 J-1.174 E.04386
G1 X115.022 Y119.607 E.044
; LINE_WIDTH: 0.43482
G1 X114.979 Y119.607 E.00134
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.606 E.06196
; LINE_WIDTH: 0.43533
G1 X110.979 Y119.606 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.605 E.06204
; LINE_WIDTH: 0.43584
G1 X106.979 Y119.605 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.605 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.604 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.604 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.603 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.603 E.06228
; LINE_WIDTH: 0.44999
G3 X95.612 Y119.609 I-1.145 J-103.478 E.04396
G1 X95.604 Y120.978 E.04403
; LINE_WIDTH: 0.43623
G1 X95.604 Y121.021 E.00134
; LINE_WIDTH: 0.43637
G1 X95.604 Y123.021 E.06216
; LINE_WIDTH: 0.43651
G1 X95.604 Y125.021 E.06218
; LINE_WIDTH: 0.43665
G1 X95.604 Y127.021 E.0622
; LINE_WIDTH: 0.43679
G1 X95.604 Y129.021 E.06223
; LINE_WIDTH: 0.43693
G1 X95.603 Y131.021 E.06225
; LINE_WIDTH: 0.43707
G1 X95.603 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.603 Y135.021 E.06229
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-104.707 J1.16 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00738
G1 X116.797 Y119.418 E.55046
G1 X116.718 Y119.265 E.00554
G1 X116.562 Y119.207 E.00533
G1 X95.439 Y119.202 E.67922
G1 X95.279 Y119.261 E.00548
G1 X95.204 Y119.414 E.00546
G1 X95.202 Y136.548 E.55097
G1 X95.251 Y136.712 E.0055
G1 X95.463 Y136.798 E.00738
G1 X116.548 Y136.798 E.67799
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.584 J-.805 E.01066
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.418 E.50895
G2 X117.076 Y119.058 I-.981 J.112 E.01132
G1 X116.879 Y118.885 E.0078
G1 X116.562 Y118.815 E.00966
G1 X95.413 Y118.81 E.62995
G2 X95.019 Y118.955 I.156 J1.031 E.01259
G1 X94.866 Y119.158 E.00757
G1 X94.812 Y119.454 E.00895
G1 X94.81 Y136.583 E.51021
G1 X94.898 Y136.886 E.0094
G2 X95.155 Y137.132 I.806 J-.586 E.01065
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.10779
G1 X117.132 Y136.845 E-.04889
G1 X117.19 Y136.505 E-.13111
G1 X117.19 Y136.262 E-.09222
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I1.214 J-.087 P1  F12000
G1 X116.022 Y119.965 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00241
G1 X116.022 Y120.046 E.00241
G1 X116.046 Y120.006 E.00139
; WIPE_START
G1 X116.022 Y120.046 E-.08513
G1 X115.952 Y120.006 E-.14743
G1 X116.022 Y119.965 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z2.4
G1 Z2
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; WIPE_START
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I0 J-1.217 P1  F12000
G1 X96.026 Y135.957 Z2.4
G1 Z2
G1 E.4 F1800
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08513
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.4 I1.217 J0 P1  F12000
G1 X96.027 Y119.961 Z2.4
G1 Z2
G1 E.4 F1800
; LINE_WIDTH: 0.42054
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00244
G1 X96.027 Y120.043 E.00244
G1 X96.051 Y120.002 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X96.027 Y120.043 E-.08513
G1 X95.957 Y120.002 E-.14744
G1 X96.027 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L11
M991 S0 P10 ;notify layer change


M106 S114.75
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z2.4 I.047 J1.216 P1  F12000
G1 X162.621 Y117.379 Z2.4
G1 Z2.2
G1 E.4 F1800
; LINE_WIDTH: 0.37462
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01695
G1 X162.416 Y117.756 E.01523
G1 X162.621 Y118.027 E.0089
G1 X162.621 Y117.439 E.01541
; WIPE_START
G1 X161.974 Y117.379 E-.2469
G1 X162.24 Y117.606 E-.1331
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-1.217 J.023 P1  F12000
G1 X162.621 Y137.976 Z2.6
G1 Z2.2
G1 E.4 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.343 Y138.333 E.01187
G1 X161.972 Y138.621 E.01232
G1 X162.621 Y138.621 E.01702
G1 X162.621 Y138.036 E.01535
; WIPE_START
G1 X162.343 Y138.333 E-.15468
G1 X161.972 Y138.621 E-.17844
G1 X162.096 Y138.621 E-.04688
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z2.6
G1 Z2.2
G1 E.4 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01188
G1 X137.379 Y137.972 E.01231
G1 X137.379 Y138.621 E.01702
G1 X137.964 Y138.621 E.01536
; WIPE_START
M73 P56 R8
G1 X137.667 Y138.343 E-.15471
G1 X137.379 Y137.972 E-.1784
G1 X137.379 Y138.096 E-.04689
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I1.216 J.039 P1  F12000
G1 X138.035 Y117.378 Z2.6
G1 Z2.2
G1 E.4 F1800
; LINE_WIDTH: 0.37399
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01708
G1 X137.382 Y118.021 E.0168
G1 X137.736 Y117.601 E.01437
G1 X137.987 Y117.414 E.00818
; WIPE_START
G1 X137.382 Y117.378 E-.23025
G1 X137.382 Y117.772 E-.14975
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I.014 J1.217 P1  F12000
G1 X161.379 Y117.501 Z2.6
G1 Z2.2
G1 E.4 F1800
; LINE_WIDTH: 0.45821
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00763
G2 X160.8 Y117.397 I-.298 J1.426 E.01183
; LINE_WIDTH: 0.43727
G1 X159.135 Y117.397 E.05187
; LINE_WIDTH: 0.4374
G1 X157.135 Y117.398 E.06232
; LINE_WIDTH: 0.43753
G1 X155.135 Y117.398 E.06234
; LINE_WIDTH: 0.43766
G1 X153.135 Y117.398 E.06236
; LINE_WIDTH: 0.43779
G1 X151.135 Y117.398 E.06238
; LINE_WIDTH: 0.43792
G1 X149.135 Y117.398 E.0624
; LINE_WIDTH: 0.43805
G1 X147.135 Y117.398 E.06242
; LINE_WIDTH: 0.43818
G1 X145.135 Y117.399 E.06245
; LINE_WIDTH: 0.43831
G1 X143.135 Y117.399 E.06247
; LINE_WIDTH: 0.43844
G1 X141.135 Y117.399 E.06249
; LINE_WIDTH: 0.43857
G1 X139.135 Y117.399 E.06251
; LINE_WIDTH: 0.4475
G1 X138.965 Y117.409 E.00545
; LINE_WIDTH: 0.44999
G2 X137.908 Y117.938 I.386 J2.092 E.03849
G1 X137.57 Y118.433 E.01929
G1 X137.456 Y118.74 E.01052
; LINE_WIDTH: 0.44871
G1 X137.399 Y119.167 E.01383
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.666 Y137.74 E.0136
G1 X137.939 Y138.093 E.01434
G1 X138.417 Y138.423 E.01867
G1 X138.742 Y138.543 E.01116
; LINE_WIDTH: 0.44904
G1 X139.199 Y138.603 E.01479
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.603 E.67298
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.01811
G1 X161.74 Y138.333 E.0136
G1 X162.093 Y138.061 E.01433
G1 X162.423 Y137.584 E.01865
G1 X162.542 Y137.258 E.01116
; LINE_WIDTH: 0.44897
G1 X162.603 Y136.801 E.0148
; LINE_WIDTH: 0.43719
G1 X162.603 Y131.199 E.17445
; LINE_WIDTH: 0.43706
G1 X162.603 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.603 Y119.199 E.18674
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.0181
G1 X162.333 Y118.26 E.0136
G1 X162.121 Y117.979 E.01132
G1 X161.799 Y117.704 E.01362
G1 X161.488 Y117.538 E.01133
; LINE_WIDTH: 0.45821
G1 X161.436 Y117.521 E.00181
M204 S10000
G1 X161.278 Y117.914 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.102 Y117.834 E.00619
G1 X160.8 Y117.798 E.00978
G1 X139.135 Y117.8 E.69666
G1 X138.67 Y117.909 E.01538
G2 X138.072 Y118.376 I.722 J1.539 E.02458
G1 X137.855 Y118.817 E.01579
G1 X137.799 Y119.167 E.01142
G1 X137.798 Y136.801 E.56701
G1 X137.887 Y137.269 E.01532
G2 X138.373 Y137.926 I1.603 J-.677 E.02652
G1 X138.814 Y138.142 E.0158
G1 X139.199 Y138.202 E.01255
G1 X160.801 Y138.202 E.6946
G1 X161.269 Y138.113 E.01532
G2 X161.925 Y137.627 I-.677 J-1.602 E.02651
G1 X162.142 Y137.187 E.01579
G1 X162.202 Y136.801 E.01256
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.731 E.01532
G2 X161.607 Y118.063 I-1.544 J.644 E.02724
G1 X161.332 Y117.939 E.0097
M204 S250
G1 X161.124 Y118.25 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.00042
G1 X160.8 Y118.19 E.0094
G1 X139.135 Y118.193 E.64531
G1 X138.776 Y118.287 E.01106
G1 X138.459 Y118.518 E.0117
G1 X138.262 Y118.832 E.01103
G1 X138.191 Y119.167 E.01021
G1 X138.19 Y136.801 E.52522
G1 X138.27 Y137.184 E.01168
G1 X138.516 Y137.538 E.01284
G1 X138.821 Y137.734 E.01078
G1 X139.199 Y137.81 E.01151
G1 X160.801 Y137.81 E.64341
G1 X161.185 Y137.73 E.01168
G1 X161.538 Y137.484 E.01284
G1 X161.733 Y137.18 E.01076
G1 X161.81 Y136.801 E.01152
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.815 E.01168
G1 X161.484 Y118.462 E.01284
G1 X161.175 Y118.281 E.01065
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.02815
G1 X160.8 Y118.19 E-.11994
G1 X160.19 Y118.19 E-.23191
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I.453 J1.13 P1  F12000
G1 X162.938 Y117.089 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.759 Y117.013 E.00625
G1 X161.973 Y117.009 E.02529
; LINE_WIDTH: 0.45821
G3 X160.8 Y117.003 I-.487 J-18.075 E.03847
; LINE_WIDTH: 0.43727
G1 X159.135 Y117.003 E.05187
; LINE_WIDTH: 0.4374
G1 X157.135 Y117.003 E.06232
; LINE_WIDTH: 0.43753
G1 X155.135 Y117.003 E.06234
; LINE_WIDTH: 0.43766
G1 X153.135 Y117.003 E.06236
; LINE_WIDTH: 0.43779
G1 X151.135 Y117.003 E.06238
; LINE_WIDTH: 0.43792
G1 X149.135 Y117.003 E.0624
; LINE_WIDTH: 0.43805
G1 X147.135 Y117.003 E.06242
; LINE_WIDTH: 0.43818
G1 X145.135 Y117.003 E.06245
; LINE_WIDTH: 0.43831
G1 X143.135 Y117.003 E.06247
; LINE_WIDTH: 0.43844
G1 X141.135 Y117.003 E.06249
; LINE_WIDTH: 0.43857
G1 X139.135 Y117.003 E.06251
; LINE_WIDTH: 0.44999
G3 X137.249 Y117.009 I-1.266 J-107.145 E.06065
G1 X137.064 Y117.084 E.00641
G1 X137.013 Y117.258 E.00582
G3 X137.011 Y118.943 I-333.568 J.455 E.05419
; LINE_WIDTH: 0.44666
G1 X137.005 Y119.167 E.00716
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.722 I-90.887 J1.249 E.06179
G1 X137.048 Y138.89 E.00555
G1 X137.184 Y138.976 E.00518
G2 X138.703 Y138.991 I1.181 J-41.639 E.04884
; LINE_WIDTH: 0.44904
G1 X139.199 Y138.997 E.01594
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.997 E.67298
; LINE_WIDTH: 0.44999
G3 X162.722 Y138.991 I1.265 J91.938 E.06178
G1 X162.92 Y138.931 E.00665
G1 X162.987 Y138.744 E.00639
G2 X162.991 Y137.298 I-167.453 J-1.192 E.04651
; LINE_WIDTH: 0.44897
G1 X162.997 Y136.801 E.01595
; LINE_WIDTH: 0.43719
G1 X162.997 Y131.199 E.17445
; LINE_WIDTH: 0.43706
G1 X162.997 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.997 Y119.199 E.18674
; LINE_WIDTH: 0.45008
G3 X162.99 Y117.264 I89.084 J-1.273 E.06226
; LINE_WIDTH: 0.44999
G1 X162.955 Y117.147 E.00391
M204 S10000
G1 X163.171 Y116.742 F12000
G1 F6000
M204 S3000
G1 X162.861 Y116.617 E.01076
G2 X161.229 Y116.602 I-1.26 J50.508 E.05247
G1 X137.229 Y116.602 E.77173
G1 X136.887 Y116.7 E.01144
G1 X136.701 Y116.897 E.0087
G1 X136.606 Y117.176 E.00949
G1 X136.602 Y138.754 E.69384
G1 X136.67 Y139.052 E.00981
G1 X136.858 Y139.28 E.00953
G1 X137.12 Y139.378 E.00901
G2 X138.754 Y139.398 I1.243 J-34.957 E.05254
G1 X162.754 Y139.398 E.77173
G1 X163.067 Y139.315 E.01041
G1 X163.288 Y139.134 E.00919
; object ids of layer 11 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer11 end: 47,58
M625
G1 X163.379 Y138.876 E.00877
G2 X163.398 Y137.264 I-35.23 J-1.229 E.05187
G1 X163.397 Y117.264 E.64311
G1 X163.33 Y116.949 E.01034
G1 X163.208 Y116.79 E.00647
M204 S250
G1 X163.426 Y116.44 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.413 Y116.426 E.00057
G1 X163.088 Y116.256 E.01092
G1 X162.455 Y116.21 E.01893
G1 X137.21 Y116.21 E.75194
G2 X136.683 Y116.359 I.21 J1.749 E.01639
G1 X136.449 Y116.559 E.00915
G1 X136.287 Y116.822 E.00921
G1 X136.214 Y117.258 E.01315
G1 X136.21 Y138.785 E.64121
G1 X136.261 Y139.107 E.00973
G1 X136.377 Y139.346 E.00789
G1 X136.621 Y139.6 E.0105
G1 X136.895 Y139.739 E.00916
G1 X137.301 Y139.79 E.0122
G1 X162.785 Y139.79 E.75905
G1 X163.104 Y139.74 E.00961
G2 X163.739 Y139.107 I-.382 J-1.019 E.02753
G1 X163.79 Y138.699 E.01224
M73 P56 R7
G1 X163.789 Y117.264 E.63847
G1 X163.74 Y116.894 E.01109
G1 X163.622 Y116.653 E.008
G1 X163.467 Y116.484 E.00683
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.413 Y116.426 E-.03008
G1 X163.088 Y116.256 E-.13932
G1 X162.536 Y116.216 E-.2106
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z2.6 I-.337 J-1.169 P1  F12000
G1 X96.103 Y135.376 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01243
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02416
G1 X115.021 Y119.998 E.02428
; LINE_WIDTH: 0.43482
G1 X114.979 Y119.998 E.00133
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.998 E.06196
; LINE_WIDTH: 0.43533
G1 X110.979 Y119.998 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.998 E.06204
; LINE_WIDTH: 0.43584
G1 X106.979 Y119.998 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.998 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.998 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.998 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.997 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.997 E.06228
; LINE_WIDTH: 0.44605
G1 X96.808 Y120.008 E.00543
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01912
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00475
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.433 Y120.569 E.01425
G1 X115.022 Y120.398 E.01433
G1 X96.979 Y120.398 E.58019
G1 X96.878 Y120.407 E.00323
G1 X96.568 Y120.568 E.01125
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.846 E.00429
G2 X114.979 Y120.79 I-.155 J.185 E.00566
M73 P57 R7
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00564
G1 X96.79 Y134.961 E.41521
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-.076 J1.215 P1  F12000
G1 X116.391 Y136.391 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.614 I102.697 J-1.174 E.04386
G1 X115.022 Y119.607 E.044
; LINE_WIDTH: 0.43482
G1 X114.979 Y119.607 E.00134
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.606 E.06196
; LINE_WIDTH: 0.43533
G1 X110.979 Y119.606 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.605 E.06204
; LINE_WIDTH: 0.43584
G1 X106.979 Y119.605 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.605 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.604 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.604 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.603 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.603 E.06228
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.146 J-103.831 E.04404
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00737
G1 X116.797 Y119.441 E.54971
G1 X116.739 Y119.273 E.00572
G1 X116.562 Y119.207 E.00606
G1 X95.44 Y119.202 E.6792
G1 X95.281 Y119.26 E.00546
G1 X95.202 Y119.463 E.00701
G1 X95.202 Y136.56 E.54974
G1 X95.26 Y136.72 E.00546
G1 X95.463 Y136.798 E.00701
G1 X116.548 Y136.798 E.67799
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.584 J-.805 E.01067
G1 X117.19 Y136.505 E.01027
G1 X117.189 Y119.441 E.50825
G2 X117.045 Y119.017 I-.606 J-.03 E.01367
G1 X116.792 Y118.858 E.00889
G1 X116.562 Y118.815 E.00697
G1 X95.413 Y118.81 E.62994
G2 X95.02 Y118.955 I.138 J.982 E.01258
G1 X94.868 Y119.155 E.00748
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.587 E.50909
G2 X94.955 Y136.98 I.982 J-.138 E.01259
G1 X95.155 Y137.132 E.00748
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
M204 S3000
G1 X117.054 Y136.947 E-.10787
G1 X117.132 Y136.845 E-.0489
G1 X117.19 Y136.505 E-.13102
G1 X117.19 Y136.262 E-.09222
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I1.214 J-.087 P1  F12000
G1 X116.022 Y119.965 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00241
G1 X116.022 Y120.046 E.00241
G1 X116.046 Y120.006 E.00139
; WIPE_START
G1 X116.022 Y120.046 E-.08513
G1 X115.952 Y120.006 E-.14743
G1 X116.022 Y119.965 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z2.6
G1 Z2.2
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; WIPE_START
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I0 J-1.217 P1  F12000
G1 X96.026 Y135.957 Z2.6
G1 Z2.2
G1 E.4 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.6 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z2.6
G1 Z2.2
G1 E.4 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X96.026 Y120.043 E-.08513
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L12
M991 S0 P11 ;notify layer change


M106 S117.3
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z2.6 I.047 J1.216 P1  F12000
G1 X162.621 Y117.379 Z2.6
G1 Z2.4
G1 E.4 F1800
; LINE_WIDTH: 0.37461
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01695
G1 X162.415 Y117.756 E.01522
G1 X162.62 Y118.027 E.0089
G1 X162.621 Y117.439 E.01541
; WIPE_START
G1 X161.974 Y117.379 E-.24688
G1 X162.24 Y117.606 E-.13312
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-1.217 J.023 P1  F12000
G1 X162.618 Y137.98 Z2.8
G1 Z2.4
G1 E.4 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.341 Y138.334 E.01176
G1 X161.971 Y138.622 E.01225
G1 X162.618 Y138.622 E.01693
G1 X162.618 Y138.04 E.01521
; WIPE_START
G1 X162.341 Y138.334 E-.15357
G1 X161.971 Y138.622 E-.17808
G1 X162.098 Y138.622 E-.04836
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I0 J-1.217 P1  F12000
G1 X138.02 Y138.618 Z2.8
G1 Z2.4
G1 E.4 F1800
; LINE_WIDTH: 0.37394
G1 F6000
M204 S3000
G1 X137.666 Y138.341 E.01177
G1 X137.378 Y137.971 E.01225
G1 X137.378 Y138.618 E.01693
G1 X137.96 Y138.618 E.01522
; WIPE_START
G1 X137.666 Y138.341 E-.15368
G1 X137.378 Y137.971 E-.17807
G1 X137.378 Y138.098 E-.04825
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I1.216 J.038 P1  F12000
G1 X138.031 Y117.378 Z2.8
G1 Z2.4
G1 E.4 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01698
G1 X137.382 Y118.021 E.01682
G1 X137.744 Y117.594 E.01466
G1 X137.983 Y117.414 E.00781
; WIPE_START
G1 X137.382 Y117.378 E-.22897
G1 X137.382 Y117.776 E-.15103
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I.014 J1.217 P1  F12000
G1 X161.381 Y117.502 Z2.8
G1 Z2.4
G1 E.4 F1800
; LINE_WIDTH: 0.45821
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00768
G2 X160.8 Y117.397 I-.298 J1.426 E.01183
; LINE_WIDTH: 0.43726
G1 X159.135 Y117.397 E.05187
; LINE_WIDTH: 0.4374
G1 X157.135 Y117.398 E.06232
; LINE_WIDTH: 0.43753
G1 X155.135 Y117.398 E.06234
; LINE_WIDTH: 0.43766
G1 X153.135 Y117.398 E.06236
; LINE_WIDTH: 0.43779
G1 X151.135 Y117.398 E.06238
; LINE_WIDTH: 0.43792
G1 X149.135 Y117.398 E.0624
; LINE_WIDTH: 0.43805
G1 X147.135 Y117.398 E.06242
; LINE_WIDTH: 0.43818
G1 X145.135 Y117.399 E.06245
; LINE_WIDTH: 0.43831
G1 X143.135 Y117.399 E.06247
; LINE_WIDTH: 0.43844
G1 X141.135 Y117.399 E.06249
; LINE_WIDTH: 0.43858
G1 X139.135 Y117.399 E.06251
; LINE_WIDTH: 0.44751
G1 X138.965 Y117.409 E.00545
; LINE_WIDTH: 0.44999
G2 X138.233 Y117.682 I.274 J1.855 E.02529
G2 X137.448 Y118.772 I1.002 J1.55 E.04422
; LINE_WIDTH: 0.44792
G1 X137.399 Y119.167 E.01275
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01811
G1 X137.666 Y137.74 E.01359
G1 X137.938 Y138.092 E.01428
G1 X138.417 Y138.423 E.01873
G1 X138.743 Y138.542 E.01116
; LINE_WIDTH: 0.44856
G1 X139.199 Y138.602 E.01476
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.602 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.602 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.602 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.602 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.602 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.602 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.602 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.603 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.603 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.603 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.603 E.06229
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.01811
G1 X161.74 Y138.333 E.01361
G1 X162.092 Y138.062 E.01428
G1 X162.423 Y137.584 E.0187
G1 X162.542 Y137.258 E.01115
; LINE_WIDTH: 0.44857
G1 X162.602 Y136.801 E.01478
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04969
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.01809
G1 X162.334 Y118.26 E.01361
G1 X162.121 Y117.979 E.01133
G1 X161.799 Y117.704 E.01362
G1 X161.488 Y117.538 E.01132
; LINE_WIDTH: 0.45821
G1 X161.438 Y117.521 E.00175
M204 S10000
G1 X161.279 Y117.914 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.102 Y117.834 E.00625
G1 X160.8 Y117.798 E.00978
G1 X139.135 Y117.8 E.69666
G1 X138.685 Y117.903 E.01486
G1 X138.483 Y118.004 E.00726
G2 X138.069 Y118.382 I.726 J1.208 E.01815
G1 X137.847 Y118.843 E.01645
G1 X137.799 Y119.167 E.01053
G1 X137.798 Y136.801 E.56701
G1 X137.887 Y137.269 E.01533
G2 X138.373 Y137.925 I1.601 J-.676 E.02651
G1 X138.814 Y138.142 E.01582
G1 X139.199 Y138.202 E.01254
G1 X160.801 Y138.202 E.6946
G1 X161.269 Y138.113 E.01532
G2 X161.926 Y137.627 I-.678 J-1.603 E.02653
G1 X162.142 Y137.187 E.01578
G1 X162.202 Y136.801 E.01255
G1 X162.202 Y119.199 E.56599
G1 X162.113 Y118.732 E.01531
G2 X161.607 Y118.063 I-1.546 J.644 E.02725
G1 X161.334 Y117.939 E.00964
M204 S250
G1 X161.125 Y118.251 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.00047
G1 X160.8 Y118.19 E.0094
G1 X139.135 Y118.193 E.64531
G1 X138.723 Y118.314 E.01281
G1 X138.46 Y118.517 E.0099
G1 X138.254 Y118.854 E.01174
G1 X138.191 Y119.167 E.00954
G1 X138.19 Y136.801 E.52522
G1 X138.27 Y137.185 E.01168
G1 X138.516 Y137.538 E.01283
G1 X138.821 Y137.734 E.01079
G1 X139.199 Y137.81 E.0115
G1 X160.801 Y137.81 E.64341
G1 X161.185 Y137.73 E.01168
G1 X161.539 Y137.484 E.01285
G1 X161.733 Y137.18 E.01076
G1 X161.81 Y136.801 E.01151
G1 X161.81 Y119.199 E.52427
G1 X161.73 Y118.816 E.01167
G1 X161.484 Y118.461 E.01285
G1 X161.177 Y118.281 E.01059
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.02883
G1 X160.8 Y118.19 E-.11996
G1 X160.192 Y118.19 E-.2312
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I.462 J1.126 P1  F12000
G1 X162.923 Y117.069 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
M73 P58 R7
G1 F6000
M204 S3000
G1 X162.722 Y117.009 E.00675
G3 X160.963 Y117.006 I-.548 J-159.89 E.05656
; LINE_WIDTH: 0.44274
G1 X160.8 Y117.003 E.00513
; LINE_WIDTH: 0.43726
G1 X159.135 Y117.003 E.05187
; LINE_WIDTH: 0.4374
G1 X157.135 Y117.003 E.06232
; LINE_WIDTH: 0.43753
G1 X155.135 Y117.003 E.06234
; LINE_WIDTH: 0.43766
G1 X153.135 Y117.003 E.06236
; LINE_WIDTH: 0.43779
G1 X151.135 Y117.003 E.06238
; LINE_WIDTH: 0.43792
G1 X149.135 Y117.003 E.0624
; LINE_WIDTH: 0.43805
G1 X147.135 Y117.003 E.06242
; LINE_WIDTH: 0.43818
G1 X145.135 Y117.003 E.06245
; LINE_WIDTH: 0.43831
G1 X143.135 Y117.003 E.06247
; LINE_WIDTH: 0.43844
G1 X141.135 Y117.003 E.06249
; LINE_WIDTH: 0.43858
G1 X139.135 Y117.003 E.06251
; LINE_WIDTH: 0.44999
G3 X137.239 Y117.009 I-1.26 J-103.831 E.06098
G1 X137.065 Y117.089 E.00616
G1 X137.013 Y117.253 E.00556
G3 X137.01 Y118.958 I-229.194 J.495 E.05482
; LINE_WIDTH: 0.44525
G1 X137.005 Y119.167 E.00665
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.742 I-91.884 J1.259 E.06242
G1 X137.065 Y138.913 E.00579
G1 X137.234 Y138.987 E.00596
G3 X138.991 Y138.99 I.478 J249.129 E.05648
; LINE_WIDTH: 0.44485
G1 X139.199 Y138.995 E.00662
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.995 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.995 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.995 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.995 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.996 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.996 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.996 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.996 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.997 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.997 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.997 E.06229
; LINE_WIDTH: 0.44999
G3 X162.751 Y138.991 I1.267 J92.639 E.06273
G1 X162.94 Y138.912 E.00659
G1 X162.987 Y138.738 E.00581
G3 X162.99 Y137.01 I245.768 J-.468 E.05555
; LINE_WIDTH: 0.44488
G1 X162.995 Y136.801 E.00664
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04969
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.278 I87.36 J-1.252 E.06181
; LINE_WIDTH: 0.44999
G1 X162.941 Y117.126 E.00512
M204 S10000
G1 X163.186 Y116.758 F12000
G1 F6000
M204 S3000
G1 X162.953 Y116.628 E.00856
G2 X161.223 Y116.602 I-1.356 J32.854 E.05565
G1 X137.223 Y116.602 E.77173
G1 X136.94 Y116.671 E.00938
G1 X136.704 Y116.897 E.01049
G1 X136.606 Y117.176 E.00952
G1 X136.602 Y138.766 E.69422
G1 X136.696 Y139.109 E.01144
G1 X136.942 Y139.332 E.01067
G1 X137.27 Y139.394 E.01073
G1 X162.771 Y139.398 E.82001
G1 X163.113 Y139.3 E.01143
; object ids of layer 12 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer12 end: 47,58
M625
G1 X163.294 Y139.115 E.00833
G1 X163.394 Y138.82 E.01001
G1 X163.397 Y117.278 E.6927
G1 X163.355 Y117.001 E.009
G1 X163.22 Y116.807 E.0076
M204 S250
G1 X163.397 Y116.421 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.35 Y116.38 E.00187
G1 X163.066 Y116.248 E.00934
G1 X162.455 Y116.21 E.01824
G1 X137.208 Y116.21 E.752
G1 X136.754 Y116.319 E.0139
G1 X136.464 Y116.542 E.01088
G1 X136.287 Y116.823 E.00991
G1 X136.214 Y117.253 E.01299
G1 X136.21 Y138.789 E.64145
G2 X136.358 Y139.316 I1.572 J-.157 E.0164
G1 X136.56 Y139.553 E.00926
G1 X136.783 Y139.695 E.00789
G1 X137.132 Y139.786 E.01074
G1 X162.79 Y139.79 E.76426
G2 X163.317 Y139.641 I-.204 J-1.727 E.01638
G1 X163.552 Y139.44 E.00919
G1 X163.702 Y139.202 E.00839
G1 X163.786 Y138.738 E.01406
G1 X163.789 Y117.278 E.6392
G1 X163.727 Y116.86 E.01259
G1 X163.548 Y116.556 E.0105
G1 X163.442 Y116.461 E.00423
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.35 Y116.38 E-.04664
G1 X163.066 Y116.248 E-.11915
G1 X162.503 Y116.213 E-.21421
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z2.8 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.614 I102.697 J-1.174 E.04386
G1 X115.022 Y119.607 E.044
; LINE_WIDTH: 0.43482
G1 X114.979 Y119.607 E.00134
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.606 E.06196
; LINE_WIDTH: 0.43533
G1 X110.979 Y119.606 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.605 E.06204
; LINE_WIDTH: 0.43584
G1 X106.979 Y119.605 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.605 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.604 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.604 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.603 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.603 E.06228
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.146 J-103.831 E.04404
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.713 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00737
G1 X116.797 Y119.442 E.5497
G1 X116.742 Y119.279 E.00553
G1 X116.573 Y119.207 E.0059
G1 X95.439 Y119.202 E.67957
G1 X95.279 Y119.262 E.00548
G1 X95.202 Y119.463 E.00695
G1 X95.202 Y136.56 E.54974
G1 X95.26 Y136.719 E.00546
G1 X95.463 Y136.798 E.00702
G1 X116.548 Y136.798 E.67799
G1 X116.655 Y136.766 E.00359
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.583 J-.804 E.01065
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.442 E.50824
G2 X116.864 Y118.876 I-.67 J.009 E.02028
G1 X116.563 Y118.815 E.00915
G1 X95.413 Y118.81 E.62997
G2 X95.019 Y118.955 I.149 J1.009 E.0126
G1 X94.868 Y119.155 E.00745
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.587 E.50909
G2 X94.955 Y136.98 I.982 J-.138 E.01258
G1 X95.155 Y137.132 E.00749
G1 X95.495 Y137.19 E.01027
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00762
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.1077
G1 X117.132 Y136.845 E-.04885
G1 X117.19 Y136.505 E-.1312
G1 X117.19 Y136.262 E-.09224
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I.051 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01243
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02416
G1 X115.021 Y119.998 E.02428
; LINE_WIDTH: 0.43482
G1 X114.979 Y119.998 E.00133
; LINE_WIDTH: 0.43508
G1 X112.979 Y119.998 E.06196
; LINE_WIDTH: 0.43533
G1 X110.979 Y119.998 E.062
; LINE_WIDTH: 0.43559
G1 X108.979 Y119.998 E.06204
; LINE_WIDTH: 0.43584
G1 X106.979 Y119.998 E.06208
; LINE_WIDTH: 0.4361
G1 X104.979 Y119.998 E.06212
; LINE_WIDTH: 0.43635
G1 X102.979 Y119.998 E.06216
; LINE_WIDTH: 0.43661
G1 X100.979 Y119.998 E.0622
; LINE_WIDTH: 0.43686
G1 X98.979 Y119.997 E.06224
; LINE_WIDTH: 0.43712
G1 X96.979 Y119.997 E.06228
; LINE_WIDTH: 0.44605
G1 X96.808 Y120.008 E.00543
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01912
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00475
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.433 Y120.569 E.01425
G1 X115.022 Y120.398 E.01433
G1 X96.979 Y120.398 E.58019
G1 X96.878 Y120.407 E.00323
G1 X96.568 Y120.568 E.01125
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.846 E.00429
G2 X114.979 Y120.79 I-.155 J.185 E.00566
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00564
G1 X96.79 Y134.961 E.41521
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I1.21 J-.128 P1  F12000
G1 X96.026 Y119.961 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
M73 P59 R7
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08513
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I-1.217 J0 P1  F12000
G1 X96.026 Y135.957 Z2.8
G1 Z2.4
G1 E.4 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I0 J1.217 P1  F12000
G1 X116.021 Y135.957 Z2.8
G1 Z2.4
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; WIPE_START
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z2.8 I1.217 J0 P1  F12000
G1 X116.022 Y119.965 Z2.8
G1 Z2.4
G1 E.4 F1800
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00241
G1 X116.022 Y120.046 E.00241
G1 X116.046 Y120.006 E.00139
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.022 Y120.046 E-.08513
G1 X115.952 Y120.006 E-.14743
G1 X116.022 Y119.965 E-.14743
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L13
M991 S0 P12 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z2.8 I.067 J1.215 P1  F12000
G1 X162.621 Y117.379 Z2.8
G1 Z2.6
G1 E.4 F1800
; LINE_WIDTH: 0.37459
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01695
G1 X162.415 Y117.756 E.01521
G1 X162.62 Y118.027 E.00891
G1 X162.621 Y117.439 E.01541
; WIPE_START
G1 X161.974 Y117.379 E-.24687
G1 X162.24 Y117.606 E-.13313
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-1.217 J.023 P1  F12000
G1 X162.618 Y137.98 Z3
G1 Z2.6
G1 E.4 F1800
; LINE_WIDTH: 0.37395
G1 F6000
M204 S3000
G1 X162.341 Y138.334 E.01176
G1 X161.971 Y138.622 E.01226
G1 X162.618 Y138.622 E.01693
G1 X162.618 Y138.04 E.01521
; WIPE_START
G1 X162.341 Y138.334 E-.15359
G1 X161.971 Y138.622 E-.1781
G1 X162.098 Y138.622 E-.0483
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I0 J-1.217 P1  F12000
G1 X138.02 Y138.618 Z3
G1 Z2.6
G1 E.4 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X137.666 Y138.341 E.01176
G1 X137.378 Y137.971 E.01226
G1 X137.378 Y138.618 E.01693
G1 X137.96 Y138.618 E.01521
; WIPE_START
G1 X137.666 Y138.341 E-.15363
G1 X137.378 Y137.971 E-.1781
G1 X137.378 Y138.098 E-.04827
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I1.216 J.039 P1  F12000
G1 X138.034 Y117.378 Z3
G1 Z2.6
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01706
G1 X137.382 Y118.021 E.01682
G1 X137.736 Y117.6 E.01439
G1 X137.986 Y117.414 E.00816
; WIPE_START
G1 X137.382 Y117.378 E-.23005
G1 X137.382 Y117.773 E-.14996
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I.014 J1.217 P1  F12000
G1 X161.382 Y117.502 Z3
G1 Z2.6
G1 E.4 F1800
; LINE_WIDTH: 0.45822
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00774
G2 X160.8 Y117.397 I-.299 J1.427 E.01184
; LINE_WIDTH: 0.43732
G1 X159.117 Y117.398 E.05245
; LINE_WIDTH: 0.43753
G1 X157.117 Y117.398 E.06234
; LINE_WIDTH: 0.43775
G1 X155.117 Y117.398 E.06238
; LINE_WIDTH: 0.43797
G1 X153.117 Y117.398 E.06241
; LINE_WIDTH: 0.43818
G1 X151.117 Y117.399 E.06245
; LINE_WIDTH: 0.4384
G1 X149.117 Y117.399 E.06248
; LINE_WIDTH: 0.43862
G1 X147.117 Y117.399 E.06251
; LINE_WIDTH: 0.43883
G1 X145.117 Y117.4 E.06255
; LINE_WIDTH: 0.43905
G1 X143.117 Y117.4 E.06258
; LINE_WIDTH: 0.43927
G1 X141.117 Y117.4 E.06262
; LINE_WIDTH: 0.43949
G1 X139.117 Y117.4 E.06265
; LINE_WIDTH: 0.44842
G1 X138.946 Y117.411 E.00547
; LINE_WIDTH: 0.44999
G2 X137.448 Y118.772 I.289 J1.823 E.06891
; LINE_WIDTH: 0.44791
G1 X137.399 Y119.168 E.01275
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01811
G1 X137.666 Y137.74 E.0136
G1 X137.938 Y138.092 E.01429
G1 X138.416 Y138.423 E.01871
G1 X138.742 Y138.542 E.01116
; LINE_WIDTH: 0.44857
G1 X139.2 Y138.602 E.01478
; LINE_WIDTH: 0.43593
G1 X140.883 Y138.602 E.05227
; LINE_WIDTH: 0.43628
G1 X142.883 Y138.602 E.06215
; LINE_WIDTH: 0.43662
G1 X144.883 Y138.601 E.0622
; LINE_WIDTH: 0.43696
G1 X146.883 Y138.601 E.06225
; LINE_WIDTH: 0.4373
G1 X148.883 Y138.601 E.06231
; LINE_WIDTH: 0.43764
G1 X150.883 Y138.601 E.06236
; LINE_WIDTH: 0.43799
G1 X152.883 Y138.6 E.06242
; LINE_WIDTH: 0.43833
G1 X154.883 Y138.6 E.06247
; LINE_WIDTH: 0.43867
G1 X156.883 Y138.6 E.06252
; LINE_WIDTH: 0.43901
G1 X158.883 Y138.6 E.06258
; LINE_WIDTH: 0.43936
G1 X160.883 Y138.599 E.06263
; LINE_WIDTH: 0.44999
G1 X161.404 Y138.499 E.01704
G1 X161.74 Y138.334 E.01205
G1 X162.092 Y138.062 E.01429
G1 X162.423 Y137.584 E.01871
G1 X162.542 Y137.258 E.01116
; LINE_WIDTH: 0.44852
G1 X162.602 Y136.801 E.01477
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.01811
G1 X162.333 Y118.26 E.0136
G1 X162.121 Y117.979 E.01133
G1 X161.799 Y117.704 E.01362
G1 X161.488 Y117.538 E.01132
; LINE_WIDTH: 0.45822
G1 X161.439 Y117.522 E.0017
M204 S10000
G1 X161.281 Y117.915 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.103 Y117.834 E.0063
G1 X160.8 Y117.798 E.00979
G1 X139.117 Y117.802 E.69726
G1 X138.663 Y117.911 E.015
G1 X138.216 Y118.21 E.01729
G1 X138.069 Y118.382 E.00728
G1 X137.847 Y118.844 E.01647
G1 X137.799 Y119.168 E.01053
G1 X137.798 Y136.801 E.567
G1 X137.887 Y137.269 E.01532
G1 X137.991 Y137.494 E.00799
G1 X138.238 Y137.817 E.01306
G1 X138.373 Y137.926 E.00556
G1 X138.814 Y138.142 E.0158
G1 X139.199 Y138.202 E.01255
G1 X160.883 Y138.198 E.69726
G1 X161.036 Y138.177 E.00495
G1 X161.494 Y138.009 E.0157
G2 X161.926 Y137.627 I-.744 J-1.274 E.01864
G1 X162.142 Y137.186 E.0158
G1 X162.202 Y136.801 E.01255
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.731 E.01532
G2 X161.607 Y118.063 I-1.545 J.645 E.02725
G1 X161.336 Y117.94 E.00958
M204 S250
G1 X161.127 Y118.252 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.00053
G1 X160.8 Y118.19 E.00941
G1 X139.117 Y118.194 E.64587
G1 X138.774 Y118.287 E.01059
G1 X138.459 Y118.518 E.01162
G1 X138.254 Y118.854 E.01171
G1 X138.191 Y119.168 E.00954
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01168
G1 X138.527 Y137.552 E.01337
G1 X138.82 Y137.733 E.01027
G1 X139.199 Y137.81 E.01152
G1 X160.883 Y137.806 E.64587
G1 X161.194 Y137.728 E.00953
G1 X161.538 Y137.484 E.01258
G1 X161.733 Y137.179 E.01077
G1 X161.81 Y136.801 E.01151
G1 X161.81 Y119.199 E.52427
G1 X161.73 Y118.815 E.01168
G1 X161.484 Y118.461 E.01285
G1 X161.179 Y118.282 E.01053
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.02951
G1 X160.8 Y118.19 E-.12
G1 X160.194 Y118.19 E-.23049
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I.459 J1.127 P1  F12000
G1 X162.928 Y117.076 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.747 Y117.01 E.00619
G3 X160.963 Y117.006 I-.561 J-161.751 E.05738
; LINE_WIDTH: 0.44275
G1 X160.8 Y117.003 E.00514
; LINE_WIDTH: 0.43732
G1 X159.117 Y117.003 E.05245
; LINE_WIDTH: 0.43753
G1 X157.117 Y117.003 E.06234
; LINE_WIDTH: 0.43775
G1 X155.117 Y117.003 E.06238
; LINE_WIDTH: 0.43797
G1 X153.117 Y117.003 E.06241
; LINE_WIDTH: 0.43818
G1 X151.117 Y117.003 E.06245
; LINE_WIDTH: 0.4384
G1 X149.117 Y117.004 E.06248
; LINE_WIDTH: 0.43862
G1 X147.117 Y117.004 E.06251
; LINE_WIDTH: 0.43883
G1 X145.117 Y117.004 E.06255
; LINE_WIDTH: 0.43905
G1 X143.117 Y117.004 E.06258
; LINE_WIDTH: 0.43927
G1 X141.117 Y117.004 E.06262
; LINE_WIDTH: 0.43949
G1 X139.117 Y117.004 E.06265
; LINE_WIDTH: 0.44999
G3 X137.268 Y117.009 I-1.244 J-113.101 E.05944
G1 X137.086 Y117.066 E.00615
G1 X137.013 Y117.225 E.00561
G3 X137.01 Y118.959 I-232.232 J.506 E.05577
; LINE_WIDTH: 0.44522
G1 X137.005 Y119.168 E.00664
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.732 I-91.17 J1.254 E.0621
G1 X137.063 Y138.911 E.006
G1 X137.231 Y138.987 E.00594
G3 X138.991 Y138.99 I.48 J249.815 E.0566
; LINE_WIDTH: 0.44486
G1 X139.2 Y138.995 E.00663
; LINE_WIDTH: 0.43593
G1 X140.883 Y138.995 E.05227
; LINE_WIDTH: 0.43628
G1 X142.883 Y138.995 E.06215
; LINE_WIDTH: 0.43662
G1 X144.883 Y138.995 E.0622
; LINE_WIDTH: 0.43696
G1 X146.883 Y138.995 E.06225
; LINE_WIDTH: 0.4373
G1 X148.883 Y138.995 E.06231
; LINE_WIDTH: 0.43764
G1 X150.883 Y138.995 E.06236
; LINE_WIDTH: 0.43799
G1 X152.883 Y138.995 E.06242
; LINE_WIDTH: 0.43833
G1 X154.883 Y138.996 E.06247
; LINE_WIDTH: 0.43867
G1 X156.883 Y138.996 E.06252
; LINE_WIDTH: 0.43901
G1 X158.883 Y138.996 E.06258
; LINE_WIDTH: 0.43936
G1 X160.883 Y138.996 E.06263
; LINE_WIDTH: 0.44999
G3 X162.732 Y138.991 I1.207 J103.163 E.05944
G1 X162.914 Y138.936 E.00611
G1 X162.987 Y138.769 E.00586
G3 X162.99 Y137.009 I237.077 J-.484 E.05661
; LINE_WIDTH: 0.44457
G1 X162.995 Y136.801 E.00662
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.291 I86.788 J-1.245 E.06137
; LINE_WIDTH: 0.44999
G1 X162.945 Y117.134 E.00526
M204 S10000
G1 X163.13 Y116.71 F12000
G1 F6000
M204 S3000
G1 X162.825 Y116.609 E.01034
G2 X161.24 Y116.602 I-1.22 J97.14 E.05095
G1 X137.24 Y116.602 E.77173
G1 X136.896 Y116.693 E.01145
G1 X136.703 Y116.895 E.009
G1 X136.606 Y117.176 E.00956
G1 X136.602 Y138.76 E.69403
G1 X136.693 Y139.104 E.01145
G1 X136.886 Y139.294 E.00871
G1 X137.18 Y139.394 E.00999
G1 X162.76 Y139.398 E.82254
G1 X163.106 Y139.307 E.01152
G1 X163.289 Y139.12 E.0084
; object ids of layer 13 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer13 end: 47,58
M625
G1 X163.394 Y138.82 E.01021
G1 X163.397 Y117.291 E.69227
G1 X163.342 Y116.966 E.01061
G1 X163.168 Y116.756 E.00877
M204 S250
G1 X163.398 Y116.423 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.349 Y116.379 E.00196
G1 X163.066 Y116.248 E.0093
G1 X162.455 Y116.21 E.01823
G1 X137.213 Y116.21 E.75184
G1 X136.813 Y116.301 E.01223
G2 X136.214 Y117.283 I.459 J.954 E.03624
G1 X136.21 Y138.787 E.6405
G1 X136.301 Y139.187 E.01223
G2 X136.678 Y139.626 I.943 J-.428 E.01746
G2 X137.283 Y139.786 I.604 J-1.059 E.01888
G1 X162.787 Y139.79 E.75964
G1 X163.189 Y139.698 E.01229
G2 X163.619 Y139.331 I-.402 J-.905 E.01708
G2 X163.786 Y138.717 I-1.016 J-.607 E.0192
G1 X163.789 Y117.291 E.63817
G1 X163.711 Y116.82 E.01424
G2 X163.566 Y116.576 I-.91 J.379 E.00848
G1 X163.442 Y116.464 E.00497
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.349 Y116.379 E-.04784
G1 X163.066 Y116.248 E-.11864
G1 X162.505 Y116.214 E-.21352
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z3 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
M73 P60 R7
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.61 I103.431 J-1.178 E.04402
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.4372
G1 X106.979 Y119.603 E.2505
; LINE_WIDTH: 0.4373
G1 X96.979 Y119.603 E.31153
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.17 J-105.192 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00738
G1 X116.797 Y119.441 E.54972
G1 X116.75 Y119.289 E.00511
G1 X116.548 Y119.202 E.00707
G1 X95.441 Y119.202 E.67873
G1 X95.28 Y119.26 E.00548
G1 X95.202 Y119.463 E.00701
G1 X95.202 Y136.548 E.54936
G1 X95.251 Y136.712 E.00552
G1 X95.463 Y136.798 E.00737
G1 X116.548 Y136.798 E.67799
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.584 J-.805 E.01065
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.441 E.50827
G2 X117.058 Y119.034 I-.6 J-.031 E.01304
G1 X116.867 Y118.879 E.00732
G1 X116.513 Y118.81 E.01073
G1 X95.414 Y118.81 E.62845
G2 X95.02 Y118.955 I.138 J.982 E.0126
G1 X94.868 Y119.155 E.00748
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.583 E.50896
G1 X94.898 Y136.886 E.00941
G2 X95.155 Y137.132 I.804 J-.584 E.01065
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00762
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.10772
G1 X117.132 Y136.845 E-.04887
G1 X117.19 Y136.505 E-.13116
G1 X117.19 Y136.262 E-.09225
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I.05 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02423
; LINE_WIDTH: 0.4372
G1 X106.979 Y119.997 E.2505
; LINE_WIDTH: 0.4373
G1 X96.979 Y119.997 E.31153
; LINE_WIDTH: 0.44623
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.793 Y134.994 E.41618
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z3
G1 Z2.6
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z3
G1 Z2.6
G1 E.4 F1800
; LINE_WIDTH: 0.4214
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00141
; WIPE_START
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z3
G1 Z2.6
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L14
M991 S0 P13 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z3 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z3
G1 Z2.8
G1 E.4 F1800
; LINE_WIDTH: 0.37457
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01695
G1 X162.416 Y117.756 E.01523
G1 X162.62 Y118.027 E.00889
G1 X162.621 Y117.439 E.01541
; WIPE_START
G1 X161.974 Y117.379 E-.24685
G1 X162.24 Y117.606 E-.13315
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I-1.217 J.023 P1  F12000
G1 X162.618 Y137.98 Z3.2
G1 Z2.8
G1 E.4 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.341 Y138.334 E.01176
G1 X161.971 Y138.622 E.01226
G1 X162.618 Y138.622 E.01693
G1 X162.618 Y138.04 E.01521
; WIPE_START
G1 X162.341 Y138.334 E-.15353
G1 X161.971 Y138.622 E-.17812
G1 X162.098 Y138.622 E-.04835
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I0 J-1.217 P1  F12000
G1 X138.02 Y138.618 Z3.2
G1 Z2.8
G1 E.4 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X137.666 Y138.341 E.01176
G1 X137.378 Y137.971 E.01226
G1 X137.378 Y138.618 E.01693
G1 X137.96 Y138.618 E.01521
; WIPE_START
G1 X137.666 Y138.341 E-.15355
G1 X137.378 Y137.971 E-.17808
G1 X137.378 Y138.098 E-.04837
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I1.216 J.038 P1  F12000
G1 X138.031 Y117.378 Z3.2
G1 Z2.8
G1 E.4 F1800
; LINE_WIDTH: 0.37327
G1 F6000
M204 S3000
G1 X137.381 Y117.378 E.01694
G1 X137.381 Y118.028 E.01696
G1 X137.66 Y117.664 E.01196
G1 X137.983 Y117.414 E.01065
; WIPE_START
G1 X137.381 Y117.378 E-.22903
G1 X137.381 Y117.775 E-.15097
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I.014 J1.217 P1  F12000
G1 X161.384 Y117.503 Z3.2
G1 Z2.8
G1 E.4 F1800
; LINE_WIDTH: 0.45818
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.0078
G2 X160.8 Y117.397 I-.298 J1.427 E.01183
; LINE_WIDTH: 0.4373
G1 X159.118 Y117.398 E.05242
; LINE_WIDTH: 0.43752
G1 X157.118 Y117.398 E.06234
; LINE_WIDTH: 0.43773
G1 X155.118 Y117.398 E.06237
; LINE_WIDTH: 0.43794
G1 X153.118 Y117.398 E.06241
; LINE_WIDTH: 0.43815
G1 X151.118 Y117.399 E.06244
; LINE_WIDTH: 0.43836
G1 X149.118 Y117.399 E.06247
; LINE_WIDTH: 0.43858
G1 X147.118 Y117.399 E.06251
; LINE_WIDTH: 0.43879
G1 X145.118 Y117.4 E.06254
; LINE_WIDTH: 0.439
G1 X143.118 Y117.4 E.06257
; LINE_WIDTH: 0.43921
G1 X141.118 Y117.4 E.06261
; LINE_WIDTH: 0.43943
G1 X139.118 Y117.4 E.06264
; LINE_WIDTH: 0.44837
G1 X138.947 Y117.411 E.00546
; LINE_WIDTH: 0.44999
G2 X137.912 Y117.933 I.403 J2.088 E.03777
G1 X137.573 Y118.428 E.0193
G1 X137.455 Y118.745 E.01087
; LINE_WIDTH: 0.44859
G1 X137.399 Y119.168 E.01367
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01811
G1 X137.667 Y137.74 E.01361
G1 X137.938 Y138.092 E.01428
G1 X138.417 Y138.423 E.01872
G1 X138.742 Y138.542 E.01115
; LINE_WIDTH: 0.44856
G1 X139.2 Y138.602 E.01477
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.602 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.602 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.602 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.602 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.602 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.602 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.602 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.603 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.603 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.603 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.603 E.06229
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.0181
G1 X161.74 Y138.334 E.01361
G1 X162.092 Y138.062 E.01429
G1 X162.423 Y137.583 E.01873
G1 X162.542 Y137.258 E.01114
; LINE_WIDTH: 0.44852
G1 X162.602 Y136.8 E.01477
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.01811
G1 X162.333 Y118.26 E.0136
G1 X162.121 Y117.979 E.01131
G1 X161.799 Y117.704 E.01361
G1 X161.488 Y117.538 E.01133
; LINE_WIDTH: 0.45818
G1 X161.441 Y117.522 E.00164
M204 S10000
G1 X161.283 Y117.916 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.102 Y117.834 E.00636
G1 X160.8 Y117.798 E.00978
G1 X139.118 Y117.802 E.69722
G1 X138.663 Y117.911 E.01502
G1 X138.232 Y118.194 E.01658
G1 X138.087 Y118.359 E.00708
G1 X137.854 Y118.821 E.01664
G1 X137.799 Y119.168 E.01129
G1 X137.798 Y136.801 E.56699
G1 X137.887 Y137.269 E.01532
G1 X137.991 Y137.495 E.008
G1 X138.238 Y137.817 E.01307
G1 X138.373 Y137.926 E.00558
G1 X138.814 Y138.142 E.01578
G1 X139.199 Y138.202 E.01255
G1 X160.801 Y138.202 E.6946
G1 X161.268 Y138.113 E.01531
G2 X161.926 Y137.627 I-.678 J-1.604 E.02655
G1 X162.142 Y137.186 E.01578
G1 X162.202 Y136.801 E.01254
G1 X162.202 Y119.199 E.56598
M73 P61 R7
G1 X162.113 Y118.731 E.01533
G2 X161.607 Y118.063 I-1.544 J.644 E.02723
G1 X161.337 Y117.941 E.00953
M204 S250
G1 X161.129 Y118.253 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.00058
G1 X160.8 Y118.19 E.00941
G1 X139.118 Y118.194 E.64584
G1 X138.774 Y118.287 E.01062
G1 X138.472 Y118.504 E.01107
G1 X138.262 Y118.834 E.01164
G1 X138.191 Y119.168 E.01017
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01168
G1 X138.528 Y137.552 E.01338
G1 X138.821 Y137.734 E.01026
G1 X139.199 Y137.81 E.01151
G1 X160.801 Y137.81 E.64341
G1 X161.184 Y137.73 E.01167
G1 X161.539 Y137.484 E.01286
G1 X161.734 Y137.179 E.01076
G1 X161.81 Y136.801 E.01151
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.815 E.01168
G1 X161.484 Y118.462 E.01284
G1 X161.18 Y118.283 E.01049
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.03024
G1 X160.8 Y118.19 E-.11999
G1 X160.196 Y118.19 E-.22977
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I.46 J1.127 P1  F12000
G1 X162.927 Y117.075 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.749 Y117.01 E.00611
G3 X160.963 Y117.006 I-.561 J-161.501 E.05743
; LINE_WIDTH: 0.44271
G1 X160.8 Y117.003 E.00514
; LINE_WIDTH: 0.4373
G1 X159.118 Y117.003 E.05242
; LINE_WIDTH: 0.43752
G1 X157.118 Y117.003 E.06234
; LINE_WIDTH: 0.43773
G1 X155.118 Y117.003 E.06237
; LINE_WIDTH: 0.43794
G1 X153.118 Y117.003 E.06241
; LINE_WIDTH: 0.43815
G1 X151.118 Y117.003 E.06244
; LINE_WIDTH: 0.43836
G1 X149.118 Y117.004 E.06247
; LINE_WIDTH: 0.43858
G1 X147.118 Y117.004 E.06251
; LINE_WIDTH: 0.43879
G1 X145.118 Y117.004 E.06254
; LINE_WIDTH: 0.439
G1 X143.118 Y117.004 E.06257
; LINE_WIDTH: 0.43921
G1 X141.118 Y117.004 E.06261
; LINE_WIDTH: 0.43943
G1 X139.118 Y117.004 E.06264
; LINE_WIDTH: 0.44999
G3 X137.268 Y117.009 I-1.244 J-112.448 E.05947
G1 X137.086 Y117.066 E.00615
G1 X137.013 Y117.225 E.00561
G3 X137.011 Y118.946 I-323.24 J.47 E.05535
; LINE_WIDTH: 0.44641
G1 X137.005 Y119.168 E.00707
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.8 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.8 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.8 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.8 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.8 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.732 I-91.368 J1.254 E.0621
G1 X137.066 Y138.915 E.00616
G1 X137.225 Y138.987 E.0056
G3 X138.991 Y138.99 I.486 J248.716 E.0568
; LINE_WIDTH: 0.44486
G1 X139.2 Y138.995 E.00662
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.995 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.995 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.995 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.995 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.996 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.996 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.996 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.996 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.997 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.997 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.997 E.06229
; LINE_WIDTH: 0.44999
G3 X162.742 Y138.991 I1.26 J91.785 E.06242
G1 X162.915 Y138.934 E.00586
G1 X162.987 Y138.775 E.0056
G3 X162.99 Y137.009 I237.591 J-.488 E.0568
; LINE_WIDTH: 0.44457
G1 X162.995 Y136.801 E.00662
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.291 I86.817 J-1.245 E.06137
; LINE_WIDTH: 0.44999
G1 X162.944 Y117.133 E.00531
M204 S10000
G1 X163.13 Y116.71 F12000
G1 F6000
M204 S3000
G1 X162.826 Y116.609 E.01031
G2 X161.24 Y116.602 I-1.221 J96.756 E.05099
G1 X137.24 Y116.602 E.77173
G1 X136.896 Y116.693 E.01145
G1 X136.703 Y116.895 E.009
G1 X136.606 Y117.176 E.00956
G1 X136.602 Y138.76 E.69403
G1 X136.692 Y139.104 E.01144
G1 X136.895 Y139.298 E.00902
G1 X137.176 Y139.394 E.00956
G1 X162.766 Y139.398 E.82284
G1 X163.108 Y139.304 E.01143
; object ids of layer 14 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer14 end: 47,58
M625
G1 X163.298 Y139.105 E.00883
G1 X163.394 Y138.824 E.00956
G1 X163.397 Y117.291 E.69239
G1 X163.342 Y116.966 E.0106
G1 X163.169 Y116.756 E.00875
M204 S250
G1 X163.397 Y116.422 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.35 Y116.379 E.0019
G1 X163.065 Y116.248 E.00932
G1 X162.455 Y116.21 E.01823
G1 X137.213 Y116.21 E.75184
G1 X136.813 Y116.301 E.01224
G2 X136.214 Y117.283 I.459 J.954 E.03623
G1 X136.21 Y138.787 E.64049
G1 X136.301 Y139.187 E.01223
G2 X137.283 Y139.786 I.954 J-.459 E.03624
G1 X162.789 Y139.79 E.7597
G2 X163.316 Y139.642 I-.157 J-1.575 E.01639
G1 X163.551 Y139.441 E.00922
G1 X163.712 Y139.178 E.0092
G1 X163.786 Y138.73 E.01352
G1 X163.789 Y117.291 E.63857
G1 X163.711 Y116.82 E.01424
G2 X163.565 Y116.575 I-.91 J.379 E.00852
G1 X163.441 Y116.463 E.00498
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.35 Y116.379 E-.04703
G1 X163.065 Y116.248 E-.11886
G1 X162.503 Y116.213 E-.21411
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z3.2 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.61 I103.432 J-1.178 E.04402
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43719
G1 X108.979 Y119.603 E.1882
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.37385
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.17 J-105.192 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.715 Y136.742 F12000
G1 F6000
M204 S3000
G1 X116.72 Y136.74 E.00016
G1 X116.798 Y136.537 E.00701
G1 X116.797 Y119.45 E.54943
G1 X116.721 Y119.255 E.00674
G1 X116.512 Y119.202 E.00691
G1 X95.441 Y119.202 E.67757
G1 X95.28 Y119.26 E.00548
G1 X95.202 Y119.463 E.00701
G1 X95.202 Y136.548 E.54936
G1 X95.251 Y136.712 E.00551
G1 X95.463 Y136.798 E.00738
G1 X116.559 Y136.798 E.67835
G1 X116.659 Y136.762 E.00339
M204 S250
G1 X116.85 Y137.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X116.98 Y137.045 I-.401 J-.907 E.0044
G1 X117.132 Y136.845 E.00746
G1 X117.19 Y136.505 E.01029
G1 X117.189 Y119.45 E.50799
G1 X117.152 Y119.202 E.00747
G1 X116.942 Y118.931 E.01022
G1 X116.597 Y118.81 E.0109
G1 X95.414 Y118.81 E.63095
G2 X95.02 Y118.955 I.137 J.982 E.0126
G1 X94.868 Y119.155 E.00747
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.583 E.50896
G1 X94.898 Y136.886 E.0094
G2 X95.155 Y137.132 I.805 J-.584 E.01066
G1 X95.495 Y137.19 E.01028
G1 X116.586 Y137.19 E.62822
G2 X116.795 Y137.137 I-.138 J-.982 E.00642
; WIPE_START
M204 S3000
G1 X116.98 Y137.045 E-.0788
G1 X117.132 Y136.845 E-.09522
G1 X117.19 Y136.505 E-.13126
G1 X117.19 Y136.308 E-.07472
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I.052 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02423
; LINE_WIDTH: 0.43719
G1 X108.979 Y119.997 E.1882
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.37385
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
M73 P62 R7
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
M73 P62 R6
G1 X96.793 Y134.994 E.41618
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z3.2
G1 Z2.8
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z3.2
G1 Z2.8
G1 E.4 F1800
; LINE_WIDTH: 0.4214
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00141
; WIPE_START
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.2 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z3.2
G1 Z2.8
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L15
M991 S0 P14 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z3.2 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z3.2
G1 Z3
G1 E.4 F1800
; LINE_WIDTH: 0.37459
G1 F6000
M204 S3000
G1 X161.976 Y117.379 E.01689
G1 X162.333 Y117.657 E.01185
G1 X162.621 Y118.027 E.01229
G1 X162.621 Y117.439 E.01541
; WIPE_START
G1 X161.976 Y117.379 E-.24602
G1 X162.254 Y117.596 E-.13398
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.4 I-1.217 J.022 P1  F12000
G1 X162.621 Y137.976 Z3.4
G1 Z3
G1 E.4 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X162.343 Y138.333 E.01187
G1 X161.972 Y138.621 E.01232
G1 X162.621 Y138.621 E.01702
G1 X162.621 Y138.036 E.01535
; WIPE_START
G1 X162.343 Y138.333 E-.15464
G1 X161.972 Y138.621 E-.17843
G1 X162.096 Y138.621 E-.04693
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.4 I0 J-1.217 P1  F12000
G1 X138.023 Y138.618 Z3.4
G1 Z3
G1 E.4 F1800
; LINE_WIDTH: 0.37395
G1 F6000
M204 S3000
G1 X137.584 Y138.243 E.01509
G1 X137.378 Y137.971 E.00893
G1 X137.378 Y138.618 E.01693
G1 X137.963 Y138.618 E.0153
; WIPE_START
G1 X137.584 Y138.243 E-.20257
G1 X137.378 Y137.971 E-.12982
G1 X137.378 Y138.096 E-.04761
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.4 I1.216 J.039 P1  F12000
G1 X138.034 Y117.378 Z3.4
G1 Z3
G1 E.4 F1800
; LINE_WIDTH: 0.37399
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01706
G1 X137.382 Y118.021 E.0168
G1 X137.736 Y117.601 E.01437
G1 X137.986 Y117.414 E.00816
; WIPE_START
G1 X137.382 Y117.378 E-.23005
G1 X137.382 Y117.773 E-.14996
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.4 I.013 J1.217 P1  F12000
G1 X161.431 Y117.521 Z3.4
G1 Z3
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.258 Y117.457 E.00594
; LINE_WIDTH: 0.44898
G1 X160.801 Y117.397 E.01479
; LINE_WIDTH: 0.43728
G1 X159.119 Y117.398 E.05239
; LINE_WIDTH: 0.43749
G1 X157.119 Y117.398 E.06234
; LINE_WIDTH: 0.4377
G1 X155.119 Y117.398 E.06237
; LINE_WIDTH: 0.43791
G1 X153.119 Y117.398 E.0624
; LINE_WIDTH: 0.43812
G1 X151.119 Y117.399 E.06244
; LINE_WIDTH: 0.43833
G1 X149.119 Y117.399 E.06247
; LINE_WIDTH: 0.43854
G1 X147.119 Y117.399 E.0625
; LINE_WIDTH: 0.43875
G1 X145.119 Y117.4 E.06254
; LINE_WIDTH: 0.43896
G1 X143.119 Y117.4 E.06257
; LINE_WIDTH: 0.43917
G1 X141.119 Y117.4 E.0626
; LINE_WIDTH: 0.43938
G1 X139.119 Y117.4 E.06263
; LINE_WIDTH: 0.44831
G1 X138.949 Y117.411 E.00546
; LINE_WIDTH: 0.44999
G2 X138.216 Y117.692 I.3 J1.875 E.02542
G1 X137.908 Y117.938 E.01266
G1 X137.567 Y118.439 E.0195
G1 X137.455 Y118.746 E.01052
; LINE_WIDTH: 0.44856
G1 X137.399 Y119.168 E.01361
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01809
G1 X137.666 Y137.74 E.0136
G1 X137.879 Y138.021 E.01132
G1 X138.201 Y138.296 E.01362
G1 X138.512 Y138.462 E.01133
; LINE_WIDTH: 0.45668
G2 X139.199 Y138.602 I.629 J-1.327 E.02316
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.602 E.04969
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.602 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.602 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.602 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.602 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.602 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.602 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.603 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.603 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.603 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.603 E.06229
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.01809
G1 X161.74 Y138.334 E.0136
G1 X162.093 Y138.061 E.01435
G1 X162.423 Y137.584 E.01865
G1 X162.542 Y137.258 E.01115
; LINE_WIDTH: 0.44897
G1 X162.603 Y136.801 E.0148
; LINE_WIDTH: 0.43719
G1 X162.603 Y131.199 E.17445
; LINE_WIDTH: 0.43706
G1 X162.603 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.603 Y119.199 E.18674
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.0181
G1 X162.333 Y118.26 E.0136
G1 X162.061 Y117.907 E.01434
G1 X161.583 Y117.577 E.01866
G1 X161.488 Y117.542 E.00328
M204 S10000
G1 X161.324 Y117.925 F12000
G1 F6000
M204 S3000
G1 X161.186 Y117.858 E.00494
G1 X160.801 Y117.798 E.01254
G1 X139.119 Y117.802 E.6972
G1 X138.956 Y117.825 E.00529
G1 X138.468 Y118.012 E.01681
G2 X138.072 Y118.378 I.745 J1.205 E.01744
G1 X137.854 Y118.822 E.01592
G1 X137.799 Y119.168 E.01125
G1 X137.798 Y136.801 E.567
G1 X137.887 Y137.268 E.01531
G2 X138.393 Y137.937 I1.545 J-.644 E.02724
G1 X138.897 Y138.166 E.01782
G1 X139.199 Y138.202 E.00977
G1 X160.801 Y138.202 E.69461
G1 X161.268 Y138.113 E.01531
G2 X161.926 Y137.627 I-.678 J-1.604 E.02653
G1 X162.142 Y137.187 E.01578
G1 X162.202 Y136.801 E.01256
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.731 E.01532
G2 X161.627 Y118.074 I-1.602 J.677 E.02652
G1 X161.378 Y117.952 E.00893
M204 S250
G1 X161.16 Y118.263 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X160.801 Y118.19 E.01091
G1 X139.119 Y118.194 E.64581
G1 X138.711 Y118.32 E.01273
G1 X138.459 Y118.518 E.00955
G1 X138.261 Y118.837 E.01117
G1 X138.191 Y119.168 E.01008
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01167
G1 X138.516 Y137.538 E.01285
G1 X138.888 Y137.757 E.01286
G1 X139.199 Y137.81 E.00939
G1 X160.801 Y137.81 E.64342
G1 X161.184 Y137.73 E.01167
G1 X161.538 Y137.484 E.01285
G1 X161.733 Y137.18 E.01076
G1 X161.81 Y136.801 E.01152
G1 X161.81 Y119.199 E.52427
G1 X161.73 Y118.816 E.01168
G1 X161.484 Y118.462 E.01284
G1 X161.213 Y118.288 E.00958
; WIPE_START
M204 S3000
G1 X160.801 Y118.19 E-.16106
G1 X160.225 Y118.19 E-.21894
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.4 I.461 J1.126 P1  F12000
G1 X162.933 Y117.083 Z3.4
G1 Z3
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.762 Y117.013 E.00593
G2 X161.298 Y117.009 I-1.219 J166.53 E.0471
; LINE_WIDTH: 0.44898
G1 X160.801 Y117.003 E.01595
; LINE_WIDTH: 0.43728
G1 X159.119 Y117.003 E.05239
; LINE_WIDTH: 0.43749
G1 X157.119 Y117.003 E.06234
; LINE_WIDTH: 0.4377
G1 X155.119 Y117.003 E.06237
; LINE_WIDTH: 0.43791
G1 X153.119 Y117.003 E.0624
; LINE_WIDTH: 0.43812
G1 X151.119 Y117.003 E.06244
; LINE_WIDTH: 0.43833
G1 X149.119 Y117.004 E.06247
; LINE_WIDTH: 0.43854
G1 X147.119 Y117.004 E.0625
; LINE_WIDTH: 0.43875
G1 X145.119 Y117.004 E.06254
; LINE_WIDTH: 0.43896
G1 X143.119 Y117.004 E.06257
; LINE_WIDTH: 0.43917
G1 X141.119 Y117.004 E.0626
; LINE_WIDTH: 0.43938
G1 X139.119 Y117.004 E.06263
; LINE_WIDTH: 0.44999
G3 X137.268 Y117.009 I-1.244 J-111.81 E.05951
G1 X137.085 Y117.066 E.00616
G1 X137.013 Y117.224 E.00561
G3 X137.011 Y118.946 I-311.415 J.481 E.05537
; LINE_WIDTH: 0.44637
G1 X137.005 Y119.168 E.00706
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.722 I-90.906 J1.25 E.06179
G1 X137.07 Y138.924 E.00678
G1 X137.252 Y138.987 E.00622
G3 X139.037 Y138.992 I.545 J133.87 E.05738
; LINE_WIDTH: 0.44122
G1 X139.199 Y138.995 E.00511
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.995 E.04969
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.995 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.995 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.995 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.996 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.996 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.996 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.996 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.997 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.997 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.997 E.06229
; LINE_WIDTH: 0.44999
G3 X162.722 Y138.991 I1.252 J90.953 E.06179
G1 X162.89 Y138.952 E.00556
G1 X162.976 Y138.816 E.00518
G2 X162.991 Y137.298 I-41.805 J-1.181 E.0488
; LINE_WIDTH: 0.44897
G1 X162.997 Y136.801 E.01596
; LINE_WIDTH: 0.43719
G1 X162.997 Y131.199 E.17445
; LINE_WIDTH: 0.43706
G1 X162.997 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.997 Y119.199 E.18674
; LINE_WIDTH: 0.45008
G3 X162.99 Y117.264 I89.069 J-1.273 E.06227
; LINE_WIDTH: 0.44999
G1 X162.951 Y117.14 E.00416
M204 S10000
G1 X163.181 Y116.758 F12000
G1 F6000
M204 S3000
G1 X162.986 Y116.638 E.00734
G1 X162.455 Y116.603 E.01713
G1 X137.24 Y116.602 E.81079
G1 X136.896 Y116.693 E.01145
G1 X136.702 Y116.895 E.00901
G1 X136.606 Y117.176 E.00956
G1 X136.602 Y138.754 E.69384
G1 X136.671 Y139.057 E.00998
G1 X136.801 Y139.236 E.00711
G1 X137.072 Y139.369 E.00974
G2 X138.754 Y139.395 I1.323 J-32.148 E.05409
G1 X162.754 Y139.398 E.77173
G1 X163.051 Y139.33 E.00981
G1 X163.281 Y139.142 E.00954
; object ids of layer 15 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer15 end: 47,58
M625
G1 X163.378 Y138.879 E.009
G2 X163.398 Y137.263 I-34.653 J-1.232 E.05197
G1 X163.397 Y117.264 E.64311
G1 X163.365 Y117.028 E.00763
G1 X163.215 Y116.807 E.00861
M204 S250
G1 X163.398 Y116.424 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.347 Y116.378 E.00205
G1 X163.107 Y116.261 E.00797
G1 X162.717 Y116.21 E.01169
G1 X137.213 Y116.21 E.75966
G1 X136.813 Y116.301 E.01223
G2 X136.214 Y117.283 I.458 J.954 E.03624
G1 X136.21 Y138.785 E.64044
G1 X136.261 Y139.108 E.00975
G1 X136.45 Y139.428 E.01107
M73 P63 R6
G2 X136.823 Y139.713 I1.216 J-1.211 E.01403
G1 X137.252 Y139.786 E.01297
G1 X162.785 Y139.79 E.76051
G1 X163.107 Y139.739 E.00972
G1 X163.346 Y139.623 E.0079
G1 X163.6 Y139.379 E.01051
G1 X163.739 Y139.105 E.00915
G1 X163.79 Y138.699 E.01219
G1 X163.789 Y117.263 E.63847
G1 X163.74 Y116.898 E.01098
G1 X163.574 Y116.588 E.01049
G1 X163.442 Y116.465 E.00538
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.347 Y116.378 E-.04894
G1 X163.107 Y116.261 E-.10164
G1 X162.717 Y116.21 E-.14914
G1 X162.506 Y116.21 E-.08028
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z3.4 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z3.4
G1 Z3
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.61 I103.434 J-1.178 E.04402
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43719
G1 X108.979 Y119.603 E.1882
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.37385
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.17 J-105.192 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.713 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00737
G1 X116.797 Y119.469 E.54881
G1 X116.73 Y119.262 E.00702
G1 X116.511 Y119.202 E.00728
G1 X95.452 Y119.202 E.67718
G1 X95.288 Y119.25 E.00551
G1 X95.202 Y119.463 E.00738
G1 X95.202 Y136.548 E.54937
G1 X95.251 Y136.712 E.0055
G1 X95.463 Y136.798 E.00738
G1 X116.548 Y136.798 E.67799
G1 X116.655 Y136.766 E.00359
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.583 J-.804 E.01065
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.469 E.50742
G1 X117.132 Y119.152 E.00959
G1 X116.948 Y118.935 E.00849
G1 X116.678 Y118.831 E.00862
G2 X115.417 Y118.81 I-.97 J20.73 E.03754
G1 X95.417 Y118.81 E.59572
G1 X95.114 Y118.898 E.0094
G2 X94.868 Y119.155 I.586 J.807 E.01065
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.583 E.50897
G1 X94.898 Y136.886 E.00939
G2 X95.155 Y137.132 I.805 J-.585 E.01066
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00762
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.10774
G1 X117.132 Y136.845 E-.04886
G1 X117.19 Y136.505 E-.13117
G1 X117.19 Y136.262 E-.09223
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.4 I.05 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z3.4
G1 Z3
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02423
; LINE_WIDTH: 0.43719
G1 X108.979 Y119.997 E.1882
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.37385
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.793 Y134.994 E.41618
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.4 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z3.4
G1 Z3
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.4 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z3.4
G1 Z3
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.4 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z3.4
G1 Z3
G1 E.4 F1800
; LINE_WIDTH: 0.42142
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00141
; WIPE_START
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.4 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z3.4
G1 Z3
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L16
M991 S0 P15 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z3.4 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z3.4
G1 Z3.2
G1 E.4 F1800
; LINE_WIDTH: 0.37453
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01694
G1 X162.416 Y117.757 E.01524
G1 X162.62 Y118.027 E.00887
G1 X162.621 Y117.439 E.0154
; WIPE_START
G1 X161.974 Y117.379 E-.24682
G1 X162.24 Y117.607 E-.13319
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.6 I-1.217 J.023 P1  F12000
G1 X162.618 Y137.98 Z3.6
G1 Z3.2
G1 E.4 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X162.341 Y138.334 E.01176
G1 X161.971 Y138.622 E.01226
G1 X162.618 Y138.622 E.01694
G1 X162.618 Y138.04 E.01521
; WIPE_START
G1 X162.341 Y138.334 E-.1536
G1 X161.971 Y138.622 E-.17817
G1 X162.098 Y138.622 E-.04823
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.6 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z3.6
G1 Z3.2
G1 E.4 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01187
G1 X137.379 Y137.972 E.01232
G1 X137.379 Y138.621 E.01702
G1 X137.964 Y138.621 E.01535
; WIPE_START
G1 X137.667 Y138.343 E-.15469
G1 X137.379 Y137.972 E-.17841
G1 X137.379 Y138.096 E-.0469
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.6 I1.216 J.039 P1  F12000
G1 X138.043 Y117.378 Z3.6
G1 Z3.2
G1 E.4 F1800
; LINE_WIDTH: 0.374
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01729
G1 X137.382 Y118.018 E.01672
G1 X137.715 Y117.618 E.01361
G1 X137.995 Y117.414 E.00907
; WIPE_START
G1 X137.382 Y117.378 E-.23326
G1 X137.382 Y117.764 E-.14675
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.6 I.013 J1.217 P1  F12000
M73 P64 R6
G1 X161.387 Y117.504 Z3.6
G1 Z3.2
G1 E.4 F1800
; LINE_WIDTH: 0.45816
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00791
G2 X160.8 Y117.397 I-.298 J1.427 E.01183
; LINE_WIDTH: 0.43721
G1 X159.135 Y117.397 E.05186
; LINE_WIDTH: 0.43734
G1 X157.135 Y117.398 E.06231
; LINE_WIDTH: 0.43748
G1 X155.135 Y117.398 E.06233
; LINE_WIDTH: 0.43762
G1 X153.135 Y117.398 E.06236
; LINE_WIDTH: 0.43775
G1 X151.135 Y117.398 E.06238
; LINE_WIDTH: 0.43789
G1 X149.135 Y117.398 E.0624
; LINE_WIDTH: 0.43802
G1 X147.135 Y117.398 E.06242
; LINE_WIDTH: 0.43816
G1 X145.135 Y117.399 E.06244
; LINE_WIDTH: 0.43829
G1 X143.135 Y117.399 E.06246
; LINE_WIDTH: 0.43843
G1 X141.135 Y117.399 E.06248
; LINE_WIDTH: 0.43857
G1 X139.135 Y117.399 E.06251
; LINE_WIDTH: 0.4475
G1 X138.965 Y117.409 E.00545
; LINE_WIDTH: 0.44992
G1 X138.512 Y117.538 E.01513
G2 X137.733 Y118.151 I.768 J1.778 E.03224
G1 X137.476 Y118.675 E.01875
G1 X137.399 Y119.168 E.01605
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.666 Y137.74 E.0136
G1 X137.939 Y138.093 E.01435
G1 X138.416 Y138.423 E.01865
G1 X138.742 Y138.543 E.01117
; LINE_WIDTH: 0.44904
G1 X139.2 Y138.603 E.0148
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.603 E.67297
; LINE_WIDTH: 0.44999
G1 X161.355 Y138.511 E.01808
G1 X161.74 Y138.334 E.0136
G1 X162.092 Y138.062 E.0143
G1 X162.423 Y137.584 E.01871
G1 X162.542 Y137.258 E.01116
; LINE_WIDTH: 0.44856
G1 X162.602 Y136.8 E.01478
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.0181
G1 X162.334 Y118.26 E.01359
G1 X162.122 Y117.98 E.0113
G1 X161.8 Y117.705 E.01362
G1 X161.489 Y117.538 E.01135
; LINE_WIDTH: 0.45816
G1 X161.444 Y117.523 E.00153
M204 S10000
G1 X161.286 Y117.918 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.102 Y117.834 E.00648
G1 X160.8 Y117.798 E.00978
G1 X139.135 Y117.8 E.69666
G1 X138.63 Y117.927 E.01674
G1 X138.431 Y118.034 E.00728
G1 X138.08 Y118.363 E.01546
G1 X137.874 Y118.762 E.01442
G1 X137.799 Y119.168 E.01328
G1 X137.798 Y136.801 E.56699
G1 X137.887 Y137.268 E.01531
G2 X138.373 Y137.926 I1.604 J-.678 E.02653
G1 X138.814 Y138.142 E.0158
G1 X139.2 Y138.202 E.01256
G1 X160.801 Y138.202 E.69459
G1 X161.268 Y138.113 E.0153
G2 X161.926 Y137.627 I-.678 J-1.604 E.02654
G1 X162.142 Y137.186 E.01579
G1 X162.202 Y136.801 E.01255
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.731 E.01532
G2 X161.608 Y118.064 I-1.543 J.643 E.02721
G1 X161.341 Y117.942 E.00943
M204 S250
G1 X161.132 Y118.255 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.0007
G1 X160.8 Y118.19 E.0094
G1 X139.135 Y118.193 E.64531
G1 X138.744 Y118.303 E.0121
G1 X138.456 Y118.521 E.01078
G1 X138.28 Y118.787 E.0095
G1 X138.191 Y119.168 E.01164
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01167
G1 X138.516 Y137.538 E.01285
G1 X138.82 Y137.733 E.01076
G1 X139.2 Y137.81 E.01152
G1 X160.801 Y137.81 E.6434
G1 X161.184 Y137.73 E.01167
G1 X161.538 Y137.484 E.01286
G1 X161.733 Y137.18 E.01076
G1 X161.81 Y136.801 E.01152
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.815 E.01168
G1 X161.484 Y118.462 E.01283
G1 X161.184 Y118.285 E.01039
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.03168
G1 X160.8 Y118.19 E-.11999
G1 X160.2 Y118.19 E-.22833
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.6 I.453 J1.129 P1  F12000
G1 X162.94 Y117.09 Z3.6
G1 Z3.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.822 Y117.022 E.00438
G1 X161.974 Y117.01 E.02729
; LINE_WIDTH: 0.45816
G3 X160.8 Y117.003 I-.487 J-18.107 E.0385
; LINE_WIDTH: 0.43721
G1 X159.135 Y117.003 E.05186
; LINE_WIDTH: 0.43734
G1 X157.135 Y117.003 E.06231
; LINE_WIDTH: 0.43748
G1 X155.135 Y117.003 E.06233
; LINE_WIDTH: 0.43762
G1 X153.135 Y117.003 E.06236
; LINE_WIDTH: 0.43775
G1 X151.135 Y117.003 E.06238
; LINE_WIDTH: 0.43789
G1 X149.135 Y117.003 E.0624
; LINE_WIDTH: 0.43802
G1 X147.135 Y117.003 E.06242
; LINE_WIDTH: 0.43816
G1 X145.135 Y117.003 E.06244
; LINE_WIDTH: 0.43829
G1 X143.135 Y117.003 E.06246
; LINE_WIDTH: 0.43843
G1 X141.135 Y117.003 E.06248
; LINE_WIDTH: 0.43857
G1 X139.135 Y117.003 E.06251
; LINE_WIDTH: 0.44999
G3 X137.268 Y117.009 I-1.282 J-114.402 E.06003
G1 X137.086 Y117.066 E.00615
G1 X137.013 Y117.224 E.00561
G1 X137.012 Y118.913 E.05429
; LINE_WIDTH: 0.44975
G1 X137.005 Y119.168 E.00819
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.742 I-91.661 J1.259 E.06242
G1 X137.078 Y138.928 E.0064
G1 X137.315 Y138.991 E.00789
G3 X138.991 Y138.993 I.473 J357.045 E.05388
; LINE_WIDTH: 0.44656
G1 X139.2 Y138.997 E.00666
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.997 E.67297
; LINE_WIDTH: 0.44999
G3 X162.751 Y138.991 I1.279 J93.215 E.06273
G1 X162.936 Y138.916 E.0064
G1 X162.987 Y138.742 E.00582
G3 X162.99 Y137.009 I244.93 J-.471 E.05574
; LINE_WIDTH: 0.44484
G1 X162.995 Y136.801 E.00662
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.291 I86.78 J-1.245 E.06137
; LINE_WIDTH: 0.44999
G1 X162.955 Y117.148 E.00474
M204 S10000
G1 X163.126 Y116.707 F12000
G1 F6000
M204 S3000
G1 X162.83 Y116.611 E.01003
G2 X161.24 Y116.603 I-1.224 J82.785 E.05112
G1 X137.24 Y116.602 E.77173
G1 X136.896 Y116.693 E.01145
G1 X136.703 Y116.895 E.00901
G1 X136.606 Y117.176 E.00956
G1 X136.602 Y138.766 E.69421
G1 X136.696 Y139.108 E.01143
G1 X136.905 Y139.299 E.00908
G1 X137.19 Y139.387 E.00959
G2 X138.771 Y139.398 I1.182 J-55.78 E.05085
G1 X162.771 Y139.398 E.77173
G1 X163.113 Y139.3 E.01143
; object ids of layer 16 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer16 end: 47,58
M625
G1 X163.298 Y139.103 E.0087
G1 X163.394 Y138.824 E.0095
G1 X163.397 Y117.291 E.69238
G1 X163.341 Y116.963 E.0107
G1 X163.165 Y116.753 E.00882
M204 S250
G1 X163.393 Y116.42 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.348 Y116.378 E.00182
G1 X163.085 Y116.254 E.00867
G1 X162.455 Y116.21 E.01882
G1 X137.213 Y116.21 E.75184
G1 X136.813 Y116.301 E.01224
G2 X136.214 Y117.283 I.459 J.954 E.03624
G1 X136.21 Y138.789 E.64055
G2 X136.358 Y139.316 I1.57 J-.156 E.01639
G1 X136.558 Y139.55 E.00916
G1 X136.858 Y139.726 E.01038
G1 X137.315 Y139.79 E.01374
G1 X162.79 Y139.79 E.7588
G2 X163.317 Y139.641 I-.21 J-1.749 E.01637
G1 X163.551 Y139.441 E.00916
G1 X163.712 Y139.178 E.0092
G1 X163.786 Y138.743 E.01316
G1 X163.789 Y117.291 E.63894
G1 X163.711 Y116.819 E.01427
G1 X163.577 Y116.59 E.00789
G1 X163.437 Y116.461 E.00568
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.348 Y116.378 E-.04596
G1 X163.085 Y116.254 E-.11058
G1 X162.499 Y116.214 E-.22346
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z3.6 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z3.6
G1 Z3.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.61 I103.439 J-1.178 E.04402
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.4372
G1 X108.979 Y119.603 E.18821
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.37385
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.17 J-105.192 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00738
G1 X116.797 Y119.416 E.55053
G1 X116.715 Y119.262 E.0056
G1 X116.511 Y119.202 E.00685
G1 X95.452 Y119.202 E.67716
G1 X95.287 Y119.251 E.00552
G1 X95.202 Y119.464 E.00738
G1 X95.202 Y136.56 E.54974
G1 X95.26 Y136.72 E.00547
G1 X95.463 Y136.798 E.007
G1 X116.548 Y136.798 E.67799
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.584 J-.804 E.01066
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.416 E.50901
G2 X117.06 Y119.038 I-1.015 J.136 E.01198
G1 X116.866 Y118.879 E.00746
G1 X116.511 Y118.81 E.01078
G1 X95.417 Y118.81 E.62829
G1 X95.114 Y118.898 E.00941
G2 X94.868 Y119.155 I.584 J.804 E.01064
G1 X94.81 Y119.495 E.01029
G1 X94.81 Y136.587 E.50908
G2 X94.955 Y136.98 I.983 J-.139 E.01259
G1 X95.155 Y137.132 E.00747
G1 X95.495 Y137.19 E.01027
M73 P65 R6
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.10778
G1 X117.132 Y136.845 E-.04887
G1 X117.19 Y136.505 E-.13115
G1 X117.19 Y136.262 E-.0922
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.6 I.051 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z3.6
G1 Z3.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01243
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02423
; LINE_WIDTH: 0.4372
G1 X108.979 Y119.997 E.18821
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.37385
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00475
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.0043
G1 X96.979 Y135.21 E.0043
G1 X115.021 Y135.21 E.53742
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.633 Y135.21 E-.24877
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.6 I-.513 J-1.104 P1  F12000
G1 X96.026 Y135.957 Z3.6
G1 Z3.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.6 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z3.6
G1 Z3.2
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.6 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z3.6
G1 Z3.2
G1 E.4 F1800
; LINE_WIDTH: 0.42142
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00141
; WIPE_START
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.6 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z3.6
G1 Z3.2
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L17
M991 S0 P16 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z3.6 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z3.6
G1 Z3.4
G1 E.4 F1800
; LINE_WIDTH: 0.37455
G1 F6000
M204 S3000
G1 X161.976 Y117.379 E.01689
G1 X162.333 Y117.657 E.01185
G1 X162.621 Y118.027 E.01228
G1 X162.621 Y117.439 E.01541
; WIPE_START
G1 X161.976 Y117.379 E-.24605
G1 X162.254 Y117.596 E-.13395
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.8 I-1.217 J.022 P1  F12000
G1 X162.622 Y137.974 Z3.8
G1 Z3.4
G1 E.4 F1800
; LINE_WIDTH: 0.37389
G1 F6000
M204 S3000
G1 X162.344 Y138.331 E.01182
G1 X161.975 Y138.618 E.01223
G1 X162.622 Y138.618 E.01691
G1 X162.622 Y138.034 E.01527
; WIPE_START
G1 X162.344 Y138.331 E-.15449
G1 X161.975 Y138.618 E-.1777
G1 X162.101 Y138.618 E-.04781
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.8 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z3.8
G1 Z3.4
G1 E.4 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01187
G1 X137.379 Y137.972 E.01231
G1 X137.379 Y138.621 E.01702
G1 X137.964 Y138.621 E.01534
; WIPE_START
G1 X137.667 Y138.343 E-.15457
G1 X137.379 Y137.972 E-.1784
G1 X137.379 Y138.096 E-.04703
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.8 I1.216 J.039 P1  F12000
G1 X138.035 Y117.377 Z3.8
G1 Z3.4
G1 E.4 F1800
; LINE_WIDTH: 0.37246
G1 F6000
M204 S3000
G1 X137.381 Y117.377 E.01702
G1 X137.381 Y118.025 E.01686
G1 X137.663 Y117.658 E.01206
G1 X137.987 Y117.414 E.01056
; WIPE_START
G1 X137.381 Y117.377 E-.23068
G1 X137.381 Y117.77 E-.14932
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.8 I.013 J1.217 P1  F12000
G1 X161.433 Y117.522 Z3.8
G1 Z3.4
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.258 Y117.457 E.00601
; LINE_WIDTH: 0.44897
G1 X160.801 Y117.397 E.01478
; LINE_WIDTH: 0.4372
G1 X149.199 Y117.397 E.36133
; LINE_WIDTH: 0.4373
G1 X139.199 Y117.397 E.31153
; LINE_WIDTH: 0.4495
G1 X138.693 Y117.473 E.01645
; LINE_WIDTH: 0.44999
G1 X138.344 Y117.615 E.01212
G1 X137.926 Y117.916 E.01657
G1 X137.649 Y118.283 E.01477
; LINE_WIDTH: 0.45047
G1 X137.494 Y118.625 E.01208
G1 X137.399 Y119.168 E.01774
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.667 Y137.74 E.01361
G1 X137.939 Y138.093 E.01434
G1 X138.417 Y138.423 E.01868
G1 X138.743 Y138.543 E.01115
; LINE_WIDTH: 0.449
G1 X139.2 Y138.603 E.01478
; LINE_WIDTH: 0.43717
G1 X140.801 Y138.603 E.04987
; LINE_WIDTH: 0.43705
G1 X142.801 Y138.603 E.06227
; LINE_WIDTH: 0.43691
G1 X144.801 Y138.603 E.06224
; LINE_WIDTH: 0.43677
G1 X146.801 Y138.602 E.06222
; LINE_WIDTH: 0.43663
G1 X148.801 Y138.602 E.0622
; LINE_WIDTH: 0.43648
G1 X150.801 Y138.602 E.06218
; LINE_WIDTH: 0.43634
G1 X152.801 Y138.602 E.06215
; LINE_WIDTH: 0.4362
G1 X154.801 Y138.602 E.06213
; LINE_WIDTH: 0.43606
G1 X156.801 Y138.602 E.06211
; LINE_WIDTH: 0.43592
G1 X158.801 Y138.602 E.06209
; LINE_WIDTH: 0.43578
G1 X160.801 Y138.602 E.06207
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.01808
G1 X161.74 Y138.334 E.0136
G1 X162.094 Y138.06 E.0144
G1 X162.423 Y137.583 E.01863
G1 X162.543 Y137.258 E.01115
; LINE_WIDTH: 0.44897
G1 X162.603 Y136.801 E.01478
; LINE_WIDTH: 0.43719
G1 X162.603 Y131.199 E.17444
; LINE_WIDTH: 0.43706
G1 X162.603 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.603 Y119.199 E.18674
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.01811
G1 X162.334 Y118.26 E.0136
G1 X162.061 Y117.907 E.01434
G1 X161.583 Y117.577 E.01867
G1 X161.489 Y117.543 E.00321
M204 S10000
G1 X161.326 Y117.926 F12000
G1 F6000
M204 S3000
G1 X161.186 Y117.858 E.00501
G1 X160.801 Y117.798 E.01253
G1 X139.199 Y117.798 E.69461
G1 X138.772 Y117.872 E.01394
G1 X138.311 Y118.124 E.0169
G1 X138.156 Y118.273 E.0069
G1 X137.89 Y118.72 E.01675
G1 X137.799 Y119.167 E.01468
G1 X137.798 Y136.801 E.567
G1 X137.887 Y137.269 E.01532
G2 X138.373 Y137.926 I1.604 J-.678 E.02655
G1 X138.814 Y138.142 E.01579
G1 X139.2 Y138.202 E.01254
G1 X160.801 Y138.202 E.69459
G1 X161.268 Y138.113 E.01531
G2 X161.926 Y137.627 I-.678 J-1.604 E.02654
G1 X162.142 Y137.186 E.01579
G1 X162.202 Y136.801 E.01254
G1 X162.202 Y119.199 E.56597
G1 X162.113 Y118.731 E.01532
G2 X161.627 Y118.075 I-1.602 J.677 E.02651
G1 X161.38 Y117.953 E.00887
M204 S250
G1 X161.162 Y118.263 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X160.801 Y118.19 E.01096
G1 X139.199 Y118.19 E.64342
G1 X138.849 Y118.256 E.01062
G1 X138.526 Y118.451 E.01124
G1 X138.301 Y118.746 E.01106
G1 X138.191 Y119.168 E.01296
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01168
G1 X138.516 Y137.539 E.01286
G1 X138.821 Y137.734 E.01077
G1 X139.2 Y137.81 E.01151
G1 X160.801 Y137.81 E.6434
G1 X161.184 Y137.73 E.01167
G1 X161.539 Y137.484 E.01285
G1 X161.734 Y137.179 E.01077
G1 X161.81 Y136.801 E.01151
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.815 E.01168
G1 X161.484 Y118.462 E.01283
G1 X161.215 Y118.289 E.00953
; WIPE_START
M204 S3000
G1 X160.801 Y118.19 E-.16165
G1 X160.226 Y118.19 E-.21835
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.8 I.466 J1.124 P1  F12000
G1 X162.924 Y117.072 Z3.8
G1 Z3.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.734 Y117.01 E.00644
G3 X161.01 Y117.008 I-.488 J-346.716 E.05544
; LINE_WIDTH: 0.44635
G1 X160.801 Y117.003 E.00666
; LINE_WIDTH: 0.4372
G1 X149.199 Y117.003 E.36133
; LINE_WIDTH: 0.4373
G1 X139.199 Y117.003 E.31153
; LINE_WIDTH: 0.4495
G1 X138.647 Y117.009 E.01774
; LINE_WIDTH: 0.44999
G1 X137.244 Y117.009 E.04512
G1 X137.071 Y117.081 E.00601
G1 X137.013 Y117.253 E.00586
G1 X137.013 Y118.08 E.02658
; LINE_WIDTH: 0.4525
G3 X137.005 Y119.167 I-17.453 J.428 E.0352
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.722 I-90.935 J1.25 E.06179
G1 X137.067 Y138.917 E.00655
M73 P66 R6
G1 X137.187 Y138.976 E.00431
G2 X138.703 Y138.991 I1.175 J-43.117 E.04874
; LINE_WIDTH: 0.449
G1 X139.2 Y138.997 E.01593
; LINE_WIDTH: 0.43717
G1 X140.801 Y138.997 E.04986
; LINE_WIDTH: 0.43705
G1 X142.801 Y138.997 E.06227
; LINE_WIDTH: 0.43691
G1 X144.801 Y138.996 E.06224
; LINE_WIDTH: 0.43677
G1 X146.801 Y138.996 E.06222
; LINE_WIDTH: 0.43663
G1 X148.801 Y138.996 E.0622
; LINE_WIDTH: 0.43648
G1 X150.801 Y138.996 E.06218
; LINE_WIDTH: 0.43634
G1 X152.801 Y138.996 E.06215
; LINE_WIDTH: 0.4362
G1 X154.801 Y138.995 E.06213
; LINE_WIDTH: 0.43606
G1 X156.801 Y138.995 E.06211
; LINE_WIDTH: 0.43592
G1 X158.801 Y138.995 E.06209
; LINE_WIDTH: 0.43578
G1 X160.801 Y138.995 E.06207
; LINE_WIDTH: 0.44999
G3 X162.78 Y138.987 I1.306 J83.776 E.06364
G1 X162.947 Y138.907 E.00597
G1 X162.991 Y138.685 E.00726
G3 X162.993 Y137.009 I322.535 J-.488 E.05389
; LINE_WIDTH: 0.44622
G1 X162.997 Y136.8 E.00665
; LINE_WIDTH: 0.43719
G1 X162.997 Y131.199 E.17444
; LINE_WIDTH: 0.43706
G1 X162.997 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.997 Y119.199 E.18674
; LINE_WIDTH: 0.45008
G3 X162.99 Y117.291 I87.816 J-1.259 E.06137
; LINE_WIDTH: 0.44999
G1 X162.941 Y117.129 E.00543
M204 S10000
G1 X163.131 Y116.71 F12000
G1 F6000
M204 S3000
G1 X162.83 Y116.61 E.01019
G2 X161.226 Y116.603 I-1.205 J90.397 E.05159
G1 X137.226 Y116.602 E.77173
G1 X136.939 Y116.67 E.00948
G1 X136.768 Y116.8 E.00691
G1 X136.626 Y117.091 E.0104
G2 X136.605 Y118.754 I27.855 J1.179 E.05349
G1 X136.602 Y138.754 E.64311
G1 X136.685 Y139.067 E.01041
G1 X136.876 Y139.295 E.00958
G1 X137.192 Y139.389 E.01058
G2 X138.826 Y139.398 I1.197 J-74.128 E.05256
G1 X162.826 Y139.394 E.77173
G1 X163.101 Y139.302 E.00933
; object ids of layer 17 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer17 end: 47,58
M625
G1 X163.279 Y139.148 E.00756
G1 X163.375 Y138.874 E.00935
G2 X163.398 Y137.291 I-29.834 J-1.214 E.0509
G1 X163.397 Y117.291 E.64311
G1 X163.342 Y116.967 E.01058
G1 X163.169 Y116.757 E.00876
M204 S250
G1 X163.393 Y116.418 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.35 Y116.379 E.00172
G1 X163.065 Y116.248 E.00933
G1 X162.455 Y116.211 E.01822
G1 X137.209 Y116.21 E.75198
G2 X136.754 Y116.319 I.174 J1.727 E.01397
G1 X136.475 Y116.53 E.01041
G1 X136.287 Y116.824 E.01041
G1 X136.214 Y117.253 E.01296
G1 X136.21 Y138.785 E.64134
G1 X136.26 Y139.104 E.00961
G1 X136.426 Y139.413 E.01045
G1 X136.653 Y139.623 E.00921
G1 X136.893 Y139.739 E.00794
G1 X137.301 Y139.79 E.01226
G1 X162.871 Y139.786 E.76162
G2 X163.413 Y139.575 I-.078 J-1.002 E.01757
G1 X163.658 Y139.271 E.01164
G1 X163.754 Y138.982 E.00909
G1 X163.79 Y138.453 E.01579
G1 X163.789 Y117.291 E.63031
G1 X163.711 Y116.82 E.01423
G2 X163.562 Y116.572 I-.91 J.379 E.00866
G1 X163.437 Y116.458 E.00503
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.35 Y116.379 E-.04478
G1 X163.065 Y116.248 E-.11897
G1 X162.497 Y116.213 E-.21625
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z3.8 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z3.8
G1 Z3.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.439 J-1.178 E.04402
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.4372
G1 X108.979 Y119.603 E.18821
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.37385
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.17 J-105.192 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00738
G1 X116.797 Y119.45 E.54943
G1 X116.72 Y119.255 E.00674
G1 X116.51 Y119.202 E.00696
G1 X95.438 Y119.202 E.67758
G1 X95.279 Y119.262 E.00548
G1 X95.202 Y119.463 E.00693
G1 X95.202 Y136.56 E.54974
G1 X95.26 Y136.719 E.00546
G1 X95.463 Y136.798 E.00701
G1 X116.548 Y136.798 E.67799
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.584 J-.805 E.01066
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.45 E.508
G1 X117.152 Y119.202 E.00746
G1 X116.942 Y118.931 E.01022
G1 X116.676 Y118.831 E.00847
G2 X115.413 Y118.81 I-.971 J20.878 E.03763
G1 X95.413 Y118.81 E.59572
G2 X95.019 Y118.955 I.153 J1.019 E.01259
G1 X94.868 Y119.155 E.00746
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.587 E.50909
G2 X94.955 Y136.98 I.983 J-.138 E.01258
G1 X95.155 Y137.132 E.00748
G1 X95.495 Y137.19 E.01027
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.10778
G1 X117.132 Y136.845 E-.04888
G1 X117.19 Y136.505 E-.13112
G1 X117.19 Y136.262 E-.09223
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.8 I.05 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z3.8
G1 Z3.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02423
; LINE_WIDTH: 0.4372
G1 X108.979 Y119.997 E.18821
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.37385
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.793 Y134.994 E.41618
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.8 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z3.8
G1 Z3.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.8 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z3.8
G1 Z3.4
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.8 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z3.8
G1 Z3.4
G1 E.4 F1800
; LINE_WIDTH: 0.42144
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
M73 P67 R6
G1 X116.045 Y120.002 E.00141
; WIPE_START
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z3.8 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z3.8
G1 Z3.4
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L18
M991 S0 P17 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z3.8 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z3.8
G1 Z3.6
G1 E.4 F1800
; LINE_WIDTH: 0.37455
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01694
G1 X162.416 Y117.757 E.01523
G1 X162.62 Y118.027 E.00889
G1 X162.621 Y117.439 E.01541
; WIPE_START
G1 X161.974 Y117.379 E-.24684
G1 X162.24 Y117.607 E-.13316
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4 I-1.217 J.023 P1  F12000
G1 X162.619 Y137.978 Z4
G1 Z3.6
G1 E.4 F1800
; LINE_WIDTH: 0.37289
G1 F6000
M204 S3000
G1 X162.342 Y138.332 E.01171
G1 X161.974 Y138.619 E.01217
G1 X162.619 Y138.619 E.01681
G1 X162.619 Y138.038 E.01513
; WIPE_START
G1 X162.342 Y138.332 E-.15341
G1 X161.974 Y138.619 E-.17736
G1 X162.103 Y138.619 E-.04923
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z4
G1 Z3.6
G1 E.4 F1800
; LINE_WIDTH: 0.37496
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01187
G1 X137.379 Y137.972 E.01231
G1 X137.379 Y138.621 E.01702
G1 X137.964 Y138.621 E.01535
; WIPE_START
G1 X137.667 Y138.343 E-.15459
G1 X137.379 Y137.972 E-.17841
G1 X137.379 Y138.096 E-.047
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4 I1.216 J.038 P1  F12000
G1 X138.03 Y117.378 Z4
G1 Z3.6
G1 E.4 F1800
; LINE_WIDTH: 0.37344
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01693
G1 X137.381 Y118.025 E.01689
G1 X137.659 Y117.664 E.01189
G1 X137.982 Y117.415 E.01065
; WIPE_START
G1 X137.382 Y117.378 E-.22873
G1 X137.381 Y117.776 E-.15127
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4 I.014 J1.217 P1  F12000
G1 X161.391 Y117.505 Z4
G1 Z3.6
G1 E.4 F1800
; LINE_WIDTH: 0.45811
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00803
G2 X160.8 Y117.397 I-.298 J1.427 E.01182
; LINE_WIDTH: 0.43718
G1 X159.136 Y117.397 E.05185
; LINE_WIDTH: 0.43732
G1 X157.136 Y117.398 E.06231
; LINE_WIDTH: 0.43745
G1 X155.136 Y117.398 E.06233
; LINE_WIDTH: 0.43759
G1 X153.136 Y117.398 E.06235
; LINE_WIDTH: 0.43773
G1 X151.136 Y117.398 E.06237
; LINE_WIDTH: 0.43787
G1 X149.136 Y117.398 E.0624
; LINE_WIDTH: 0.438
G1 X147.136 Y117.398 E.06242
; LINE_WIDTH: 0.43814
G1 X145.136 Y117.399 E.06244
; LINE_WIDTH: 0.43828
G1 X143.136 Y117.399 E.06246
; LINE_WIDTH: 0.43842
G1 X141.136 Y117.399 E.06248
; LINE_WIDTH: 0.43856
G1 X139.136 Y117.399 E.06251
; LINE_WIDTH: 0.44999
G1 X138.606 Y117.499 E.01732
G1 X138.266 Y117.662 E.01215
G1 X137.911 Y117.934 E.01437
G1 X137.581 Y118.41 E.01861
G1 X137.461 Y118.724 E.01081
; LINE_WIDTH: 0.44906
G1 X137.399 Y119.167 E.01438
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.667 Y137.74 E.01361
G1 X137.939 Y138.093 E.01434
G1 X138.417 Y138.423 E.01868
G1 X138.743 Y138.543 E.01115
; LINE_WIDTH: 0.449
G1 X139.199 Y138.603 E.01478
; LINE_WIDTH: 0.43717
G1 X140.801 Y138.603 E.04987
; LINE_WIDTH: 0.43705
G1 X142.801 Y138.603 E.06227
; LINE_WIDTH: 0.43691
G1 X144.801 Y138.603 E.06224
; LINE_WIDTH: 0.43677
G1 X146.801 Y138.602 E.06222
; LINE_WIDTH: 0.43663
G1 X148.801 Y138.602 E.0622
; LINE_WIDTH: 0.43648
G1 X150.801 Y138.602 E.06218
; LINE_WIDTH: 0.43634
G1 X152.801 Y138.602 E.06215
; LINE_WIDTH: 0.4362
G1 X154.801 Y138.602 E.06213
; LINE_WIDTH: 0.43606
G1 X156.801 Y138.602 E.06211
; LINE_WIDTH: 0.43592
G1 X158.801 Y138.602 E.06209
; LINE_WIDTH: 0.43578
G1 X160.801 Y138.602 E.06207
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.0181
G1 X161.74 Y138.333 E.0136
G1 X162.093 Y138.061 E.01433
G1 X162.423 Y137.583 E.01868
G1 X162.542 Y137.257 E.01115
; LINE_WIDTH: 0.44852
G1 X162.602 Y136.8 E.01476
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.645 E.01808
G1 X162.334 Y118.26 E.0136
G1 X162.121 Y117.98 E.01133
G1 X161.799 Y117.704 E.01362
G1 X161.488 Y117.538 E.01133
; LINE_WIDTH: 0.45811
G1 X161.447 Y117.524 E.00141
M204 S10000
G1 X161.289 Y117.919 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.102 Y117.834 E.0066
G1 X160.8 Y117.798 E.00978
G1 X139.136 Y117.8 E.69665
G1 X138.989 Y117.819 E.00475
G1 X138.509 Y117.989 E.01638
G2 X138.086 Y118.359 I.721 J1.251 E.01819
G1 X137.86 Y118.803 E.01603
G1 X137.799 Y119.167 E.01188
G1 X137.798 Y136.801 E.56701
G1 X137.887 Y137.268 E.01532
G2 X138.373 Y137.926 I1.604 J-.678 E.02655
G1 X138.814 Y138.142 E.01579
G1 X139.199 Y138.202 E.01254
G1 X160.801 Y138.202 E.6946
G1 X161.269 Y138.113 E.01532
G2 X161.926 Y137.627 I-.678 J-1.603 E.02654
G1 X162.142 Y137.186 E.01579
G1 X162.202 Y136.801 E.01254
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.732 E.0153
G2 X161.607 Y118.063 I-1.546 J.644 E.02725
G1 X161.344 Y117.944 E.0093
M204 S250
G1 X161.135 Y118.257 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.00081
G1 X160.8 Y118.19 E.0094
G1 X139.136 Y118.193 E.6453
G1 X138.808 Y118.272 E.01004
G1 X138.472 Y118.505 E.0122
G1 X138.267 Y118.819 E.01116
G1 X138.191 Y119.167 E.01061
G1 X138.19 Y136.801 E.52522
G1 X138.27 Y137.184 E.01168
G1 X138.516 Y137.539 E.01286
G1 X138.821 Y137.734 E.01077
G1 X139.199 Y137.81 E.0115
G1 X160.801 Y137.81 E.64341
G1 X161.185 Y137.73 E.01168
G1 X161.539 Y137.484 E.01285
G1 X161.734 Y137.179 E.01077
G1 X161.81 Y136.801 E.0115
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.816 E.01167
G1 X161.484 Y118.462 E.01285
G1 X161.187 Y118.287 E.01026
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.03315
G1 X160.8 Y118.19 E-.11995
G1 X160.203 Y118.19 E-.22691
; WIPE_END
M73 P67 R5
G1 E-.02 F1800
M204 S10000
G17
G3 Z4 I.457 J1.128 P1  F12000
G1 X162.933 Y117.083 Z4
G1 Z3.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.754 Y117.01 E.00623
G3 X160.963 Y117.006 I-.564 J-160.582 E.05758
; LINE_WIDTH: 0.44266
G1 X160.8 Y117.003 E.00513
; LINE_WIDTH: 0.43718
G1 X159.136 Y117.003 E.05185
; LINE_WIDTH: 0.43732
G1 X157.136 Y117.003 E.06231
; LINE_WIDTH: 0.43745
G1 X155.136 Y117.003 E.06233
; LINE_WIDTH: 0.43759
G1 X153.136 Y117.003 E.06235
; LINE_WIDTH: 0.43773
G1 X151.136 Y117.003 E.06237
; LINE_WIDTH: 0.43787
G1 X149.136 Y117.003 E.0624
; LINE_WIDTH: 0.438
G1 X147.136 Y117.003 E.06242
; LINE_WIDTH: 0.43814
G1 X145.136 Y117.003 E.06244
; LINE_WIDTH: 0.43828
G1 X143.136 Y117.003 E.06246
; LINE_WIDTH: 0.43842
G1 X141.136 Y117.003 E.06248
; LINE_WIDTH: 0.43856
G1 X139.136 Y117.003 E.06251
; LINE_WIDTH: 0.44999
G3 X137.268 Y117.009 I-1.231 J-97.674 E.06005
G1 X137.074 Y117.071 E.00654
G1 X137.013 Y117.284 E.00713
G3 X137.011 Y118.936 I-430.636 J.409 E.05312
; LINE_WIDTH: 0.44738
G1 X137.005 Y119.167 E.00741
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.732 I-91.408 J1.255 E.0621
G1 X137.075 Y138.924 E.00653
G1 X137.288 Y138.991 E.00719
G3 X138.991 Y138.992 I.538 J346.988 E.05475
; LINE_WIDTH: 0.44643
G1 X139.199 Y138.997 E.00666
; LINE_WIDTH: 0.43717
G1 X140.801 Y138.997 E.04987
; LINE_WIDTH: 0.43705
G1 X142.801 Y138.997 E.06227
; LINE_WIDTH: 0.43691
G1 X144.801 Y138.996 E.06224
; LINE_WIDTH: 0.43677
G1 X146.801 Y138.996 E.06222
; LINE_WIDTH: 0.43663
G1 X148.801 Y138.996 E.0622
; LINE_WIDTH: 0.43648
G1 X150.801 Y138.996 E.06218
; LINE_WIDTH: 0.43634
G1 X152.801 Y138.996 E.06215
; LINE_WIDTH: 0.4362
G1 X154.801 Y138.995 E.06213
; LINE_WIDTH: 0.43606
G1 X156.801 Y138.995 E.06211
; LINE_WIDTH: 0.43592
G1 X158.801 Y138.995 E.06209
; LINE_WIDTH: 0.43578
G1 X160.801 Y138.995 E.06207
; LINE_WIDTH: 0.44999
G3 X162.766 Y138.987 I1.299 J83.25 E.06319
G1 X162.924 Y138.924 E.00548
G1 X162.987 Y138.733 E.00647
G3 X162.99 Y137.009 I231.645 J-.468 E.05544
; LINE_WIDTH: 0.44457
G1 X162.995 Y136.801 E.00661
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.264 I87.755 J-1.258 E.06225
; LINE_WIDTH: 0.44999
G1 X162.951 Y117.14 E.00417
M204 S10000
G1 X163.182 Y116.762 F12000
G1 F6000
M204 S3000
G1 X162.952 Y116.628 E.00856
G2 X161.24 Y116.603 I-1.346 J33.369 E.05505
G1 X137.24 Y116.602 E.77173
G1 X136.89 Y116.695 E.01164
G1 X136.667 Y116.948 E.01086
G1 X136.606 Y117.283 E.01096
G1 X136.602 Y138.76 E.69059
G1 X136.671 Y139.046 E.00947
G1 X136.834 Y139.264 E.00876
G1 X137.101 Y139.371 E.00923
G2 X138.818 Y139.398 I1.291 J-27.754 E.05523
G1 X162.818 Y139.394 E.77173
G1 X163.046 Y139.335 E.0076
; object ids of layer 18 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer18 end: 47,58
M625
G1 X163.275 Y139.131 E.00985
G1 X163.373 Y138.9 E.00807
G2 X163.394 Y137.264 I-33.419 J-1.259 E.05262
G1 X163.397 Y117.264 E.64311
G1 X163.365 Y117.028 E.00764
G1 X163.219 Y116.808 E.00851
M204 S250
G1 X163.385 Y116.413 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.349 Y116.379 E.00149
G1 X163.065 Y116.248 E.0093
G1 X162.455 Y116.211 E.01822
G1 X137.213 Y116.21 E.75184
G1 X136.809 Y116.302 E.01234
G1 X136.476 Y116.528 E.012
G1 X136.304 Y116.785 E.00921
G1 X136.214 Y117.267 E.0146
G1 X136.21 Y138.787 E.64098
G1 X136.249 Y139.067 E.00841
G1 X136.379 Y139.349 E.00925
G1 X136.589 Y139.576 E.00921
G1 X136.856 Y139.726 E.00914
G1 X137.315 Y139.79 E.0138
G1 X162.868 Y139.786 E.76112
G1 X163.213 Y139.696 E.01062
G1 X163.498 Y139.498 E.01033
G1 X163.696 Y139.213 E.01035
G1 X163.786 Y138.733 E.01455
G1 X163.789 Y117.264 E.63948
G1 X163.74 Y116.898 E.01099
G1 X163.574 Y116.587 E.0105
G1 X163.429 Y116.453 E.00588
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.349 Y116.379 E-.04177
G1 X163.065 Y116.248 E-.1186
G1 X162.488 Y116.213 E-.21963
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z4 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z4
G1 Z3.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.443 J-1.178 E.04402
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43719
G1 X110.979 Y119.603 E.12592
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.43616
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.772 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.75 F12000
M73 P68 R5
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00738
G1 X116.797 Y119.47 E.5488
G1 X116.737 Y119.271 E.00667
G1 X116.529 Y119.202 E.00704
G1 X95.441 Y119.202 E.6781
G1 X95.281 Y119.26 E.00547
G1 X95.202 Y119.463 E.00701
G1 X95.202 Y136.56 E.54974
G1 X95.26 Y136.72 E.00547
G1 X95.463 Y136.798 E.00701
G1 X116.548 Y136.798 E.67798
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.586 J-.806 E.01066
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.47 E.50741
G1 X117.132 Y119.153 E.00958
G2 X116.824 Y118.858 I-.531 J.246 E.01301
G1 X116.529 Y118.81 E.0089
G1 X95.414 Y118.81 E.62893
G2 X95.02 Y118.955 I.137 J.981 E.01259
G1 X94.868 Y119.155 E.00748
G1 X94.81 Y119.495 E.01029
G1 X94.81 Y136.587 E.50908
G2 X94.955 Y136.98 I.983 J-.138 E.01259
G1 X95.155 Y137.132 E.00746
G1 X95.495 Y137.19 E.01029
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00762
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.10772
G1 X117.132 Y136.845 E-.04889
G1 X117.19 Y136.505 E-.13116
G1 X117.19 Y136.262 E-.09223
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4 I.05 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z4
G1 Z3.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02423
; LINE_WIDTH: 0.43719
G1 X110.979 Y119.997 E.12592
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.43616
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.793 Y134.994 E.41618
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z4
G1 Z3.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z4
G1 Z3.6
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z4
G1 Z3.6
G1 E.4 F1800
; LINE_WIDTH: 0.42144
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00141
; WIPE_START
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z4
G1 Z3.6
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L19
M991 S0 P18 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z4 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z4
G1 Z3.8
G1 E.4 F1800
; LINE_WIDTH: 0.37453
G1 F6000
M204 S3000
G1 X161.976 Y117.379 E.01689
G1 X162.333 Y117.657 E.01185
G1 X162.62 Y118.027 E.01228
G1 X162.621 Y117.439 E.0154
; WIPE_START
G1 X161.976 Y117.379 E-.246
G1 X162.254 Y117.596 E-.134
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.2 I-1.217 J.022 P1  F12000
G1 X162.618 Y137.98 Z4.2
G1 Z3.8
G1 E.4 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X162.341 Y138.334 E.01176
G1 X161.971 Y138.622 E.01226
G1 X162.618 Y138.622 E.01693
G1 X162.618 Y138.04 E.01521
; WIPE_START
G1 X162.341 Y138.334 E-.15361
G1 X161.971 Y138.622 E-.1781
G1 X162.098 Y138.622 E-.04828
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.2 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z4.2
G1 Z3.8
G1 E.4 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01188
G1 X137.379 Y137.972 E.01231
G1 X137.379 Y138.621 E.01702
G1 X137.964 Y138.621 E.01536
; WIPE_START
G1 X137.667 Y138.343 E-.15471
G1 X137.379 Y137.972 E-.17838
G1 X137.379 Y138.096 E-.04691
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.2 I1.216 J.038 P1  F12000
G1 X138.034 Y117.378 Z4.2
G1 Z3.8
G1 E.4 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01707
G1 X137.382 Y118.021 E.01681
G1 X137.736 Y117.601 E.01436
G1 X137.986 Y117.414 E.00818
; WIPE_START
G1 X137.382 Y117.378 E-.23014
G1 X137.382 Y117.773 E-.14986
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.2 I.013 J1.217 P1  F12000
G1 X161.435 Y117.523 Z4.2
G1 Z3.8
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.258 Y117.457 E.00607
; LINE_WIDTH: 0.44897
G1 X160.801 Y117.397 E.01479
; LINE_WIDTH: 0.43722
G1 X159.123 Y117.398 E.05226
; LINE_WIDTH: 0.43741
G1 X157.123 Y117.398 E.06232
; LINE_WIDTH: 0.4376
G1 X155.123 Y117.398 E.06235
; LINE_WIDTH: 0.4378
G1 X153.123 Y117.398 E.06239
; LINE_WIDTH: 0.43799
G1 X151.123 Y117.399 E.06242
; LINE_WIDTH: 0.43818
G1 X149.123 Y117.399 E.06245
; LINE_WIDTH: 0.43837
G1 X147.123 Y117.399 E.06248
; LINE_WIDTH: 0.43857
G1 X145.123 Y117.399 E.06251
; LINE_WIDTH: 0.43876
G1 X143.123 Y117.4 E.06254
; LINE_WIDTH: 0.43895
G1 X141.123 Y117.4 E.06257
; LINE_WIDTH: 0.43915
G1 X139.123 Y117.4 E.0626
; LINE_WIDTH: 0.4481
G1 X138.953 Y117.41 E.00546
; LINE_WIDTH: 0.44999
G2 X137.908 Y117.938 I.4 J2.09 E.03811
G1 X137.565 Y118.446 E.01972
G1 X137.453 Y118.753 E.01051
; LINE_WIDTH: 0.44841
G1 X137.399 Y119.168 E.0134
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44608
G1 X137.408 Y136.971 E.00543
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01267
G1 X137.667 Y137.74 E.0136
G1 X137.939 Y138.093 E.01433
G1 X138.417 Y138.423 E.01868
G1 X138.743 Y138.543 E.01116
; LINE_WIDTH: 0.44903
G1 X139.2 Y138.603 E.01478
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.603 E.67298
; LINE_WIDTH: 0.44999
G1 X161.357 Y138.51 E.01813
G1 X161.741 Y138.333 E.0136
G1 X162.092 Y138.062 E.01426
G1 X162.423 Y137.583 E.01873
G1 X162.542 Y137.257 E.01116
; LINE_WIDTH: 0.44855
G1 X162.602 Y136.8 E.01477
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.0181
G1 X162.334 Y118.26 E.0136
G1 X162.061 Y117.907 E.01434
G1 X161.583 Y117.577 E.01866
G1 X161.491 Y117.543 E.00315
M204 S10000
G1 X161.328 Y117.927 F12000
G1 F6000
M204 S3000
G1 X161.186 Y117.858 E.00508
G1 X160.801 Y117.798 E.01254
G1 X139.123 Y117.802 E.69706
G1 X138.962 Y117.825 E.00525
G1 X138.467 Y118.012 E.01699
G2 X138.071 Y118.379 I.742 J1.199 E.01748
G1 X137.852 Y118.828 E.01605
G1 X137.799 Y119.168 E.01107
G1 X137.807 Y136.901 E.57022
G1 X137.887 Y137.269 E.01211
G2 X138.373 Y137.926 I1.602 J-.677 E.02652
G1 X138.814 Y138.142 E.01581
G1 X139.2 Y138.202 E.01254
G1 X160.801 Y138.202 E.69459
G1 X161.269 Y138.113 E.01534
G2 X161.926 Y137.627 I-.677 J-1.601 E.0265
G1 X162.142 Y137.186 E.01581
G1 X162.202 Y136.801 E.01254
G1 X162.202 Y119.199 E.56597
G1 X162.113 Y118.731 E.01532
G2 X161.627 Y118.075 I-1.602 J.677 E.02652
G1 X161.382 Y117.954 E.0088
M204 S250
G1 X161.163 Y118.263 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X160.801 Y118.19 E.01102
G1 X139.123 Y118.194 E.64569
G1 X138.774 Y118.287 E.01075
G1 X138.459 Y118.518 E.01165
G1 X138.259 Y118.841 E.01131
G1 X138.191 Y119.168 E.00994
G1 X138.193 Y136.833 E.52618
M73 P69 R5
G1 X138.27 Y137.185 E.01072
G1 X138.516 Y137.538 E.01284
G1 X138.821 Y137.734 E.01078
G1 X139.2 Y137.81 E.01151
G1 X160.801 Y137.81 E.6434
G1 X161.185 Y137.73 E.01169
G1 X161.538 Y137.484 E.01283
G1 X161.734 Y137.179 E.01078
G1 X161.81 Y136.8 E.01151
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.816 E.01168
G1 X161.484 Y118.462 E.01284
G1 X161.216 Y118.29 E.00948
; WIPE_START
M204 S3000
G1 X160.801 Y118.19 E-.16231
G1 X160.228 Y118.19 E-.21769
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.2 I.479 J1.119 P1  F12000
G1 X162.892 Y117.05 Z4.2
G1 Z3.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.694 Y117.01 E.00649
G3 X161.01 Y117.008 I-.472 J-333.825 E.05416
; LINE_WIDTH: 0.44633
G1 X160.801 Y117.003 E.00667
; LINE_WIDTH: 0.43722
G1 X159.123 Y117.003 E.05226
; LINE_WIDTH: 0.43741
G1 X157.123 Y117.003 E.06232
; LINE_WIDTH: 0.4376
G1 X155.123 Y117.003 E.06235
; LINE_WIDTH: 0.4378
G1 X153.123 Y117.003 E.06239
; LINE_WIDTH: 0.43799
G1 X151.123 Y117.003 E.06242
; LINE_WIDTH: 0.43818
G1 X149.123 Y117.004 E.06245
; LINE_WIDTH: 0.43837
G1 X147.123 Y117.004 E.06248
; LINE_WIDTH: 0.43857
G1 X145.123 Y117.004 E.06251
; LINE_WIDTH: 0.43876
G1 X143.123 Y117.004 E.06254
; LINE_WIDTH: 0.43895
G1 X141.123 Y117.004 E.06257
; LINE_WIDTH: 0.43915
G1 X139.123 Y117.004 E.0626
; LINE_WIDTH: 0.44999
G3 X137.268 Y117.009 I-1.247 J-110.313 E.05964
G1 X137.09 Y117.062 E.00596
G1 X137.013 Y117.234 E.00609
G3 X137.011 Y118.949 I-283.36 J.487 E.05515
; LINE_WIDTH: 0.44609
G1 X137.005 Y119.168 E.00695
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.712 I-90.372 J1.245 E.06148
G1 X137.075 Y138.925 E.00715
G1 X137.288 Y138.991 E.00716
G3 X138.991 Y138.993 I.491 J358.778 E.05476
; LINE_WIDTH: 0.44655
G1 X139.2 Y138.997 E.00666
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.997 E.67298
; LINE_WIDTH: 0.44999
G3 X162.742 Y138.991 I1.275 J93.119 E.06241
G1 X162.932 Y138.922 E.00653
G1 X162.987 Y138.73 E.00642
G3 X162.99 Y137.009 I242.387 J-.467 E.05534
; LINE_WIDTH: 0.44483
G1 X162.995 Y136.8 E.00662
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.216 I90.194 J-1.282 E.06378
; LINE_WIDTH: 0.44999
G1 X162.923 Y117.101 E.00428
M204 S10000
G1 X163.129 Y116.727 F12000
G1 F6000
M204 S3000
G1 X163.105 Y116.703 E.00109
G1 X162.768 Y116.603 E.01131
G1 X137.24 Y116.602 E.82085
G1 X136.896 Y116.692 E.01145
G1 X136.668 Y116.942 E.01087
G1 X136.606 Y117.283 E.01115
G1 X136.602 Y138.748 E.69022
G1 X136.685 Y139.081 E.01103
G1 X136.857 Y139.282 E.0085
G1 X137.086 Y139.368 E.00788
G2 X138.766 Y139.398 I1.283 J-25.163 E.05402
G1 X162.765 Y139.398 E.77173
G1 X163.112 Y139.302 E.01155
G1 X163.333 Y139.054 E.01068
; object ids of layer 19 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer19 end: 47,58
M625
G1 X163.394 Y138.73 E.01062
G1 X163.397 Y117.216 E.69178
G1 X163.324 Y116.929 E.00955
G1 X163.17 Y116.77 E.00709
M204 S250
G1 X163.426 Y116.439 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.18 Y116.289 E.00856
G1 X162.694 Y116.211 E.01467
G1 X137.213 Y116.21 E.75898
G1 X136.813 Y116.301 E.01223
G1 X136.545 Y116.477 E.00955
G1 X136.378 Y116.668 E.00755
G2 X136.214 Y117.283 I1.109 J.626 E.01918
G1 X136.21 Y138.783 E.64039
G1 X136.275 Y139.146 E.01097
G1 X136.399 Y139.379 E.00788
G1 X136.621 Y139.6 E.00933
G1 X136.855 Y139.725 E.00789
G1 X137.315 Y139.79 E.01385
G1 X162.789 Y139.79 E.75875
G1 X163.155 Y139.709 E.01119
G2 X163.696 Y139.216 I-.488 J-1.078 E.02214
G1 X163.786 Y138.868 E.0107
G1 X163.789 Y117.216 E.64492
G2 X163.67 Y116.733 I-1.571 J.131 E.01488
G1 X163.467 Y116.482 E.00963
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.18 Y116.289 E-.13121
G1 X162.694 Y116.211 E-.1871
G1 X162.532 Y116.211 E-.0617
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z4.2 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z4.2
G1 Z3.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.444 J-1.178 E.04402
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.4372
G1 X110.979 Y119.603 E.12592
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.43616
; LINE_WIDTH: 0.44999
G3 X95.612 Y119.609 I-1.171 J-105.41 E.04396
G1 X95.604 Y120.978 E.04403
; LINE_WIDTH: 0.43622
G1 X95.604 Y121.021 E.00134
; LINE_WIDTH: 0.43636
G1 X95.604 Y123.021 E.06216
; LINE_WIDTH: 0.4365
G1 X95.604 Y125.021 E.06218
; LINE_WIDTH: 0.43664
G1 X95.604 Y127.021 E.0622
; LINE_WIDTH: 0.43678
G1 X95.604 Y129.021 E.06222
; LINE_WIDTH: 0.43692
G1 X95.603 Y131.021 E.06225
; LINE_WIDTH: 0.43706
G1 X95.603 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.603 Y135.021 E.06229
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-104.465 J1.157 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00738
G1 X116.797 Y119.451 E.54941
G1 X116.727 Y119.265 E.00638
G1 X116.528 Y119.202 E.0067
G1 X95.438 Y119.202 E.67817
G1 X95.279 Y119.262 E.00548
G1 X95.204 Y119.414 E.00542
G1 X95.202 Y136.548 E.55098
G1 X95.25 Y136.712 E.0055
G1 X95.463 Y136.798 E.00738
G1 X116.548 Y136.798 E.67798
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.584 J-.804 E.01065
G1 X117.19 Y136.505 E.01029
G1 X117.189 Y119.451 E.50797
G1 X117.152 Y119.202 E.00749
G1 X117.013 Y118.984 E.0077
G1 X116.823 Y118.858 E.0068
G1 X116.528 Y118.81 E.0089
G1 X95.413 Y118.81 E.62894
G2 X95.019 Y118.956 I.171 J1.069 E.01258
G1 X94.866 Y119.158 E.00757
G1 X94.812 Y119.453 E.00893
G1 X94.81 Y136.583 E.51022
G1 X94.898 Y136.886 E.00939
G2 X95.155 Y137.132 I.806 J-.585 E.01065
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00762
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.10771
G1 X117.132 Y136.845 E-.04888
G1 X117.19 Y136.505 E-.13121
G1 X117.19 Y136.262 E-.09221
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.2 I.051 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z4.2
G1 Z3.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01244
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02423
; LINE_WIDTH: 0.4372
G1 X110.979 Y119.997 E.12592
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.43616
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.01907
G1 X95.998 Y120.979 E.02426
; LINE_WIDTH: 0.43622
G1 X95.998 Y121.021 E.00133
; LINE_WIDTH: 0.43636
G1 X95.998 Y123.021 E.06216
; LINE_WIDTH: 0.4365
G1 X95.998 Y125.021 E.06218
; LINE_WIDTH: 0.43664
G1 X95.998 Y127.021 E.0622
; LINE_WIDTH: 0.43678
G1 X95.997 Y129.021 E.06222
; LINE_WIDTH: 0.43692
G1 X95.997 Y131.021 E.06225
; LINE_WIDTH: 0.43706
G1 X95.997 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.997 Y135.021 E.06229
; LINE_WIDTH: 0.44614
G1 X96.008 Y135.192 E.00543
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00474
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.878 Y120.407 E.58341
G1 X96.568 Y120.568 E.01122
G1 X96.398 Y120.978 E.01431
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.0043
M73 P70 R5
G2 X97.021 Y135.21 I.155 J-.185 E.00564
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.946 Y120.793 E.53711
G1 X96.845 Y120.845 E.00338
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.2 I1.21 J-.127 P1  F12000
G1 X96.027 Y119.961 Z4.2
G1 Z3.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00244
G1 X96.027 Y120.042 E.00244
G1 X96.051 Y120.002 E.00141
; WIPE_START
G1 X96.027 Y120.042 E-.08513
G1 X95.957 Y120.002 E-.14743
G1 X96.027 Y119.961 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.2 I-1.217 J0 P1  F12000
G1 X96.026 Y135.957 Z4.2
G1 Z3.8
G1 E.4 F1800
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08513
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.2 I0 J1.217 P1  F12000
G1 X116.021 Y135.957 Z4.2
G1 Z3.8
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; WIPE_START
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.2 I1.217 J0 P1  F12000
G1 X116.021 Y119.961 Z4.2
G1 Z3.8
G1 E.4 F1800
; LINE_WIDTH: 0.42144
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L20
M991 S0 P19 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z4.2 I.067 J1.215 P1  F12000
G1 X162.621 Y117.379 Z4.2
G1 Z4
G1 E.4 F1800
; LINE_WIDTH: 0.37453
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01694
G1 X162.416 Y117.756 E.01522
G1 X162.62 Y118.027 E.00889
G1 X162.621 Y117.439 E.0154
; WIPE_START
G1 X161.974 Y117.379 E-.24682
G1 X162.24 Y117.607 E-.13318
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.4 I-1.217 J.023 P1  F12000
G1 X162.618 Y137.977 Z4.4
G1 Z4
G1 E.4 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X162.243 Y138.416 E.0151
G1 X161.971 Y138.622 E.00893
G1 X162.618 Y138.622 E.01693
G1 X162.618 Y138.037 E.0153
; WIPE_START
G1 X162.243 Y138.416 E-.2027
G1 X161.971 Y138.622 E-.12971
G1 X162.096 Y138.622 E-.04759
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.4 I0 J-1.217 P1  F12000
G1 X138.023 Y138.618 Z4.4
G1 Z4
G1 E.4 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.585 Y138.244 E.01507
G1 X137.378 Y137.971 E.00895
G1 X137.378 Y138.618 E.01693
G1 X137.963 Y138.618 E.0153
; WIPE_START
G1 X137.585 Y138.244 E-.20224
G1 X137.378 Y137.971 E-.13011
G1 X137.378 Y138.096 E-.04765
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.4 I1.216 J.039 P1  F12000
G1 X138.037 Y117.378 Z4.4
G1 Z4
G1 E.4 F1800
; LINE_WIDTH: 0.37399
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01715
G1 X137.382 Y118.021 E.01681
G1 X137.729 Y117.606 E.01414
G1 X137.989 Y117.414 E.00847
; WIPE_START
G1 X137.382 Y117.378 E-.23121
G1 X137.382 Y117.77 E-.14879
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.4 I.013 J1.217 P1  F12000
G1 X161.394 Y117.506 Z4.4
G1 Z4
G1 E.4 F1800
; LINE_WIDTH: 0.45808
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00814
G2 X160.8 Y117.397 I-.298 J1.427 E.01183
; LINE_WIDTH: 0.4372
G1 X159.124 Y117.398 E.05221
; LINE_WIDTH: 0.43739
G1 X157.124 Y117.398 E.06232
; LINE_WIDTH: 0.43758
G1 X155.124 Y117.398 E.06235
; LINE_WIDTH: 0.43777
G1 X153.124 Y117.398 E.06238
; LINE_WIDTH: 0.43796
G1 X151.124 Y117.399 E.06241
; LINE_WIDTH: 0.43815
G1 X149.124 Y117.399 E.06244
; LINE_WIDTH: 0.43834
G1 X147.124 Y117.399 E.06247
; LINE_WIDTH: 0.43853
G1 X145.124 Y117.399 E.0625
; LINE_WIDTH: 0.43872
G1 X143.124 Y117.399 E.06253
; LINE_WIDTH: 0.43891
G1 X141.124 Y117.4 E.06256
; LINE_WIDTH: 0.43911
G1 X139.124 Y117.4 E.06259
; LINE_WIDTH: 0.44805
G1 X138.954 Y117.41 E.00546
; LINE_WIDTH: 0.44999
G1 X138.536 Y117.527 E.01395
G2 X137.717 Y118.178 I.763 J1.799 E.03407
G2 X137.452 Y118.755 I1.558 J1.064 E.0205
; LINE_WIDTH: 0.44835
G1 X137.399 Y119.168 E.01334
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.667 Y137.74 E.01361
G1 X137.879 Y138.021 E.01133
G1 X138.201 Y138.296 E.01362
G1 X138.512 Y138.462 E.01132
; LINE_WIDTH: 0.45667
G2 X139.2 Y138.602 I.629 J-1.329 E.02316
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.602 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.602 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.602 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.602 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.602 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.602 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.602 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.603 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.603 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.603 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.603 E.06229
; LINE_WIDTH: 0.44999
G1 X161.355 Y138.511 E.01808
G1 X161.739 Y138.334 E.0136
G1 X162.02 Y138.121 E.01132
G1 X162.295 Y137.799 E.01362
; LINE_WIDTH: 0.46001
G1 X162.568 Y137.194 E.02187
G1 X162.602 Y136.8 E.01302
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.01809
G1 X162.334 Y118.26 E.0136
G1 X162.121 Y117.979 E.01133
G1 X161.799 Y117.704 E.01362
G1 X161.488 Y117.538 E.01133
; LINE_WIDTH: 0.45808
G1 X161.451 Y117.526 E.0013
M204 S10000
G1 X161.293 Y117.921 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.102 Y117.834 E.00672
G1 X160.8 Y117.798 E.00978
G1 X139.124 Y117.802 E.69701
G1 X138.652 Y117.917 E.01564
G1 X138.213 Y118.213 E.01702
G1 X138.071 Y118.379 E.00705
G1 X137.852 Y118.829 E.01609
G1 X137.799 Y119.168 E.01102
G1 X137.798 Y136.801 E.56699
G1 X137.887 Y137.269 E.01532
G2 X138.393 Y137.937 I1.546 J-.645 E.02725
G1 X138.897 Y138.166 E.01781
G1 X139.199 Y138.202 E.00978
G1 X160.801 Y138.202 E.6946
G1 X161.268 Y138.113 E.0153
G2 X161.936 Y137.607 I-.644 J-1.545 E.02724
G1 X162.163 Y137.123 E.01719
G1 X162.202 Y136.801 E.01045
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.732 E.01531
G2 X161.607 Y118.063 I-1.546 J.644 E.02725
G1 X161.347 Y117.945 E.00918
M204 S250
G1 X161.138 Y118.259 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.00092
G1 X160.8 Y118.19 E.0094
G1 X139.124 Y118.194 E.64564
G1 X138.763 Y118.293 E.01115
G1 X138.412 Y118.573 E.01341
G1 X138.259 Y118.842 E.00922
G1 X138.191 Y119.168 E.00991
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01168
G1 X138.516 Y137.539 E.01286
G1 X138.888 Y137.757 E.01285
G1 X139.2 Y137.81 E.0094
G1 X160.801 Y137.81 E.64341
G1 X161.184 Y137.73 E.01166
G1 X161.538 Y137.484 E.01285
G1 X161.757 Y137.112 E.01287
G1 X161.81 Y136.8 E.0094
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.816 E.01167
G1 X161.484 Y118.462 E.01285
G1 X161.19 Y118.289 E.01015
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.03457
G1 X160.8 Y118.19 E-.11995
G1 X160.207 Y118.19 E-.22548
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.4 I.47 J1.122 P1  F12000
G1 X162.908 Y117.059 Z4.4
G1 Z4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.696 Y117.01 E.007
G3 X160.963 Y117.006 I-.535 J-154.564 E.05572
; LINE_WIDTH: 0.44263
G1 X160.8 Y117.003 E.00513
; LINE_WIDTH: 0.4372
G1 X159.124 Y117.003 E.05221
; LINE_WIDTH: 0.43739
G1 X157.124 Y117.003 E.06232
; LINE_WIDTH: 0.43758
G1 X155.124 Y117.003 E.06235
; LINE_WIDTH: 0.43777
G1 X153.124 Y117.003 E.06238
; LINE_WIDTH: 0.43796
G1 X151.124 Y117.003 E.06241
; LINE_WIDTH: 0.43815
G1 X149.124 Y117.004 E.06244
; LINE_WIDTH: 0.43834
G1 X147.124 Y117.004 E.06247
; LINE_WIDTH: 0.43853
G1 X145.124 Y117.004 E.0625
; LINE_WIDTH: 0.43872
G1 X143.124 Y117.004 E.06253
; LINE_WIDTH: 0.43891
G1 X141.124 Y117.004 E.06256
; LINE_WIDTH: 0.43911
G1 X139.124 Y117.004 E.06259
; LINE_WIDTH: 0.44999
G3 X137.249 Y117.009 I-1.267 J-114 E.0603
G1 X137.064 Y117.084 E.0064
G1 X137.013 Y117.258 E.00582
G3 X137.01 Y118.951 I-275.941 J.472 E.05444
; LINE_WIDTH: 0.44597
G1 X137.005 Y119.168 E.00692
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.732 I-91.341 J1.254 E.0621
G1 X137.066 Y138.914 E.00614
G1 X137.225 Y138.987 E.00562
G3 X139.037 Y138.992 I.559 J135.391 E.05829
; LINE_WIDTH: 0.44121
G1 X139.2 Y138.995 E.0051
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.995 E.04968
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.995 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.995 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.995 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.996 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.996 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.996 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.996 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.997 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.997 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.997 E.06229
; LINE_WIDTH: 0.44999
G3 X162.738 Y138.991 I1.26 J91.801 E.06229
G1 X162.932 Y138.923 E.00661
G1 X162.987 Y138.725 E.00661
G1 X162.987 Y137.973 E.02418
; LINE_WIDTH: 0.46001
G3 X162.995 Y136.8 I16.678 J-.482 E.03863
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.224 I89.575 J-1.278 E.06354
; LINE_WIDTH: 0.44999
G1 X162.934 Y117.113 E.00399
M204 S10000
G1 X163.131 Y116.728 F12000
G1 F6000
M204 S3000
G1 X163.107 Y116.704 E.0011
G1 X162.769 Y116.603 E.01133
G1 X137.229 Y116.602 E.82126
G1 X136.887 Y116.7 E.01144
G1 X136.702 Y116.897 E.00869
G1 X136.606 Y117.176 E.0095
G1 X136.602 Y138.76 E.69403
G1 X136.693 Y139.104 E.01145
G1 X136.895 Y139.297 E.009
G1 X137.176 Y139.394 E.00956
G1 X162.763 Y139.398 E.82276
G1 X163.111 Y139.303 E.01157
G1 X163.333 Y139.054 E.01074
; object ids of layer 20 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer20 end: 47,58
M625
G1 X163.394 Y138.725 E.01077
G1 X163.397 Y117.224 E.69138
G1 X163.318 Y116.918 E.01015
G1 X163.173 Y116.771 E.00666
M204 S250
G1 X163.424 Y116.438 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.18 Y116.289 E.00852
G1 X162.696 Y116.211 E.01462
G1 X137.21 Y116.21 E.75912
G2 X136.682 Y116.359 I.21 J1.749 E.01638
G1 X136.449 Y116.559 E.00914
G1 X136.288 Y116.822 E.00921
G1 X136.214 Y117.257 E.01315
G1 X136.21 Y138.787 E.64127
G1 X136.301 Y139.187 E.01223
G2 X137.283 Y139.786 I.954 J-.459 E.03624
G1 X162.788 Y139.79 E.75967
G1 X163.167 Y139.705 E.01158
G2 X163.696 Y139.216 I-.511 J-1.082 E.0218
M73 P71 R5
G1 X163.786 Y138.733 E.01463
G1 X163.789 Y117.224 E.64066
G2 X163.663 Y116.719 I-1.52 J.113 E.01556
G1 X163.466 Y116.48 E.00922
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.18 Y116.289 E-.13076
G1 X162.696 Y116.211 E-.18654
G1 X162.531 Y116.211 E-.0627
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z4.4 I-.488 J-1.115 P1  F12000
G1 X116.388 Y136.391 Z4.4
G1 Z4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.391 Y135.227 E.03744
; LINE_WIDTH: 0.4451
G1 X116.396 Y135.021 E.00652
; LINE_WIDTH: 0.43619
G1 X116.396 Y134.979 E.00133
; LINE_WIDTH: 0.43629
G1 X116.396 Y132.979 E.06215
; LINE_WIDTH: 0.4364
G1 X116.396 Y130.979 E.06216
; LINE_WIDTH: 0.4366
G1 X116.396 Y126.979 E.12439
; LINE_WIDTH: 0.43671
G1 X116.396 Y124.979 E.06221
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.397 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I102.587 J-1.165 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.4372
G1 X110.979 Y119.603 E.12592
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.43616
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.772 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.328 Y136.391 I1.171 J105.074 E.04203
M204 S10000
G1 X116.72 Y136.74 F12000
G1 F6000
M204 S3000
G1 X116.796 Y136.587 E.00551
G1 X116.797 Y119.451 E.55101
G1 X116.727 Y119.265 E.00639
G1 X116.527 Y119.202 E.00672
G1 X95.438 Y119.202 E.67815
G1 X95.279 Y119.263 E.00548
G1 X95.202 Y119.463 E.00691
G1 X95.202 Y136.548 E.54936
G1 X95.25 Y136.712 E.00551
G1 X95.463 Y136.798 E.00738
G1 X116.56 Y136.798 E.67837
G1 X116.663 Y136.76 E.00353
M204 S250
G1 X116.854 Y137.113 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X116.98 Y137.045 I-.411 J-.921 E.00428
G1 X117.134 Y136.842 E.0076
G1 X117.188 Y136.545 E.00899
G1 X117.189 Y119.451 E.50916
G1 X117.152 Y119.202 E.00749
G1 X117.013 Y118.984 E.0077
G1 X116.824 Y118.858 E.00677
G1 X116.527 Y118.81 E.00895
G1 X95.413 Y118.81 E.62892
G2 X95.019 Y118.956 I.156 J1.027 E.0126
G1 X94.868 Y119.155 E.00744
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.583 E.50896
G1 X94.898 Y136.886 E.0094
G2 X95.155 Y137.132 I.806 J-.586 E.01066
G1 X95.495 Y137.19 E.01028
G1 X116.587 Y137.19 E.62823
G2 X116.798 Y137.136 I-.144 J-.998 E.00652
; WIPE_START
M204 S3000
G1 X116.98 Y137.045 E-.0772
G1 X117.134 Y136.842 E-.0969
G1 X117.188 Y136.545 E-.11464
G1 X117.188 Y136.305 E-.09126
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.4 I.054 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z4.4
G1 Z4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01243
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01907
G1 X115.992 Y135.192 E.01914
; LINE_WIDTH: 0.4451
G1 X116.002 Y135.021 E.00542
; LINE_WIDTH: 0.43619
G1 X116.002 Y134.979 E.00133
; LINE_WIDTH: 0.43629
G1 X116.002 Y132.979 E.06215
; LINE_WIDTH: 0.4364
G1 X116.002 Y130.979 E.06216
; LINE_WIDTH: 0.4366
G1 X116.002 Y126.979 E.12439
; LINE_WIDTH: 0.43671
G1 X116.002 Y124.979 E.06221
; LINE_WIDTH: 0.43681
G1 X116.003 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.4372
G1 X110.979 Y119.997 E.12592
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.43616
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00475
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.433 E.01122
G1 X115.593 Y135.122 E.01126
G2 X115.602 Y134.979 I-.818 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.00429
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.4 I-.049 J1.216 P1  F12000
G1 X116.02 Y135.958 Z4.4
G1 Z4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y135.998 E.00244
G1 X116.02 Y136.039 E.00244
G1 X116.043 Y135.998 E.00141
; WIPE_START
G1 X116.02 Y136.039 E-.08513
G1 X115.949 Y135.998 E-.14743
G1 X116.02 Y135.958 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.4 I1.217 J0 P1  F12000
G1 X116.021 Y119.961 Z4.4
G1 Z4
G1 E.4 F1800
; LINE_WIDTH: 0.4214
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00141
; WIPE_START
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.4 I0 J-1.217 P1  F12000
G1 X96.026 Y119.961 Z4.4
G1 Z4
G1 E.4 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.4 I-1.217 J0 P1  F12000
G1 X96.026 Y135.957 Z4.4
G1 Z4
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L21
M991 S0 P20 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z4.4 I.327 J1.172 P1  F12000
G1 X162.621 Y117.379 Z4.4
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.37451
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01694
G1 X162.415 Y117.756 E.01521
G1 X162.62 Y118.027 E.0089
G1 X162.621 Y117.439 E.0154
; WIPE_START
G1 X161.974 Y117.379 E-.24683
G1 X162.24 Y117.607 E-.13317
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.6 I-1.217 J.023 P1  F12000
G1 X162.618 Y137.98 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.37394
G1 F6000
M204 S3000
G1 X162.341 Y138.334 E.01176
G1 X161.971 Y138.622 E.01226
G1 X162.618 Y138.622 E.01693
G1 X162.618 Y138.04 E.01521
; WIPE_START
G1 X162.341 Y138.334 E-.15363
G1 X161.971 Y138.622 E-.17811
G1 X162.098 Y138.622 E-.04826
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.6 I0 J-1.217 P1  F12000
G1 X138.02 Y138.618 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.666 Y138.341 E.01176
G1 X137.378 Y137.971 E.01225
G1 X137.378 Y138.618 E.01693
G1 X137.96 Y138.618 E.01521
; WIPE_START
G1 X137.666 Y138.341 E-.15356
G1 X137.378 Y137.971 E-.17808
G1 X137.378 Y138.098 E-.04837
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.6 I1.216 J.039 P1  F12000
G1 X138.035 Y117.378 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01708
G1 X137.382 Y118.021 E.01681
G1 X137.736 Y117.6 E.01438
G1 X137.987 Y117.414 E.00817
; WIPE_START
G1 X137.382 Y117.378 E-.23025
G1 X137.382 Y117.772 E-.14975
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.6 I.013 J1.217 P1  F12000
G1 X161.395 Y117.507 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.45805
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00819
G2 X160.8 Y117.397 I-.298 J1.427 E.01182
; LINE_WIDTH: 0.43714
G1 X159.135 Y117.397 E.05184
; LINE_WIDTH: 0.43728
G1 X157.135 Y117.398 E.0623
; LINE_WIDTH: 0.43743
G1 X155.135 Y117.398 E.06233
; LINE_WIDTH: 0.43757
G1 X153.135 Y117.398 E.06235
; LINE_WIDTH: 0.43771
G1 X151.135 Y117.398 E.06237
; LINE_WIDTH: 0.43785
G1 X149.135 Y117.398 E.06239
; LINE_WIDTH: 0.43799
G1 X147.135 Y117.398 E.06242
; LINE_WIDTH: 0.43813
G1 X145.135 Y117.399 E.06244
; LINE_WIDTH: 0.43827
G1 X143.135 Y117.399 E.06246
; LINE_WIDTH: 0.43841
M73 P72 R5
G1 X141.135 Y117.399 E.06248
; LINE_WIDTH: 0.43856
G1 X139.135 Y117.399 E.06251
; LINE_WIDTH: 0.4475
G1 X138.965 Y117.409 E.00545
; LINE_WIDTH: 0.44999
G2 X137.908 Y117.938 I.386 J2.092 E.0385
G1 X137.563 Y118.449 E.01982
G1 X137.452 Y118.756 E.01053
; LINE_WIDTH: 0.44832
G1 X137.399 Y119.168 E.01328
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.667 Y137.74 E.01361
G1 X137.938 Y138.092 E.01428
G1 X138.417 Y138.423 E.01873
G1 X138.742 Y138.542 E.01115
; LINE_WIDTH: 0.44856
G1 X139.199 Y138.602 E.01477
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.602 E.04969
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.602 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.602 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.602 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.602 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.602 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.602 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.603 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.603 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.603 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.603 E.06229
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.0181
G1 X161.74 Y138.334 E.0136
G1 X162.092 Y138.062 E.01429
G1 X162.423 Y137.584 E.01871
G1 X162.542 Y137.258 E.01116
; LINE_WIDTH: 0.44856
G1 X162.602 Y136.801 E.01478
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.01811
G1 X162.333 Y118.26 E.0136
G1 X162.121 Y117.979 E.01132
G1 X161.799 Y117.704 E.01362
G1 X161.488 Y117.538 E.01133
; LINE_WIDTH: 0.45805
G1 X161.452 Y117.526 E.00124
M204 S10000
G1 X161.294 Y117.921 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.102 Y117.834 E.00678
G1 X160.8 Y117.798 E.00977
G1 X139.136 Y117.8 E.69665
G1 X138.67 Y117.909 E.01538
G2 X138.183 Y118.238 I.566 J1.361 E.01901
G1 X138.071 Y118.38 E.00581
G1 X137.851 Y118.831 E.01613
G1 X137.799 Y119.168 E.01097
G1 X137.798 Y136.801 E.567
G1 X137.887 Y137.269 E.01532
G2 X138.373 Y137.926 I1.603 J-.678 E.02654
G1 X138.814 Y138.142 E.01578
G1 X139.199 Y138.202 E.01254
G1 X160.801 Y138.202 E.6946
G1 X161.268 Y138.113 E.01531
G2 X161.925 Y137.627 I-.677 J-1.603 E.02652
G1 X162.142 Y137.186 E.0158
G1 X162.202 Y136.801 E.01255
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.731 E.01533
G2 X161.607 Y118.063 I-1.544 J.644 E.02724
G1 X161.349 Y117.946 E.00911
M204 S250
G1 X161.14 Y118.26 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.111 Y118.243 E.00098
G1 X160.8 Y118.19 E.0094
G1 X139.136 Y118.193 E.64531
G1 X138.776 Y118.286 E.01106
G1 X138.448 Y118.527 E.01212
G1 X138.258 Y118.843 E.01099
G1 X138.191 Y119.168 E.00987
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01168
G1 X138.516 Y137.539 E.01286
G1 X138.821 Y137.734 E.01076
G1 X139.199 Y137.81 E.01151
G1 X160.801 Y137.81 E.64341
G1 X161.184 Y137.73 E.01167
G1 X161.538 Y137.484 E.01284
G1 X161.733 Y137.18 E.01077
G1 X161.81 Y136.801 E.01151
G1 X161.81 Y119.199 E.52427
G1 X161.73 Y118.815 E.01169
G1 X161.484 Y118.461 E.01284
G1 X161.192 Y118.29 E.01009
; WIPE_START
M204 S3000
G1 X161.111 Y118.243 E-.03533
G1 X160.8 Y118.19 E-.11989
G1 X160.209 Y118.19 E-.22479
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.6 I.47 J1.122 P1  F12000
G1 X162.908 Y117.059 Z4.6
G1 Z4.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.697 Y117.01 E.00696
G3 X160.963 Y117.006 I-.536 J-154.156 E.05576
; LINE_WIDTH: 0.4426
G1 X160.8 Y117.003 E.00513
; LINE_WIDTH: 0.43714
G1 X159.135 Y117.003 E.05184
; LINE_WIDTH: 0.43728
G1 X157.135 Y117.003 E.0623
; LINE_WIDTH: 0.43743
G1 X155.135 Y117.003 E.06233
; LINE_WIDTH: 0.43757
G1 X153.135 Y117.003 E.06235
; LINE_WIDTH: 0.43771
G1 X151.135 Y117.003 E.06237
; LINE_WIDTH: 0.43785
G1 X149.135 Y117.003 E.06239
; LINE_WIDTH: 0.43799
G1 X147.135 Y117.003 E.06242
; LINE_WIDTH: 0.43813
G1 X145.135 Y117.003 E.06244
; LINE_WIDTH: 0.43827
G1 X143.135 Y117.003 E.06246
; LINE_WIDTH: 0.43841
G1 X141.135 Y117.003 E.06248
; LINE_WIDTH: 0.43856
G1 X139.135 Y117.003 E.06251
; LINE_WIDTH: 0.44999
G3 X137.268 Y117.009 I-1.254 J-105.184 E.06004
G1 X137.086 Y117.066 E.00615
G1 X137.013 Y117.225 E.00562
G3 X137.01 Y118.951 I-275.575 J.488 E.05552
; LINE_WIDTH: 0.44592
G1 X137.005 Y119.168 E.0069
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.751 I-92.29 J1.264 E.06273
G1 X137.062 Y138.904 E.00518
G1 X137.202 Y138.979 E.00513
G2 X138.703 Y138.988 I1.221 J-76.181 E.04825
; LINE_WIDTH: 0.44856
G1 X139.199 Y138.995 E.01591
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.995 E.04969
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.995 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.995 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.995 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.996 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.996 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.996 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.996 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.997 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.997 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.997 E.06229
; LINE_WIDTH: 0.44999
G3 X162.751 Y138.991 I1.266 J92.45 E.06272
G1 X162.922 Y138.923 E.00593
G1 X162.987 Y138.776 E.00517
G3 X162.99 Y137.009 I250.837 J-.485 E.05679
; LINE_WIDTH: 0.44485
G1 X162.995 Y136.801 E.00663
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.223 I89.933 J-1.279 E.06357
; LINE_WIDTH: 0.44999
G1 X162.935 Y117.113 E.00396
M204 S10000
G1 X163.129 Y116.727 F12000
G1 F6000
M204 S3000
G1 X163.107 Y116.704 E.00104
G1 X162.77 Y116.603 E.01129
G1 X137.24 Y116.602 E.82094
G1 X136.896 Y116.693 E.01146
G1 X136.703 Y116.895 E.009
G1 X136.606 Y117.176 E.00956
G1 X136.602 Y138.771 E.6944
G1 X136.683 Y139.083 E.01036
G1 X136.884 Y139.294 E.00937
G1 X137.182 Y139.394 E.01012
G1 X162.771 Y139.398 E.82283
G1 X163.083 Y139.317 E.01036
; object ids of layer 21 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer21 end: 47,58
M625
G1 X163.3 Y139.1 E.00988
G1 X163.394 Y138.824 E.00938
G1 X163.397 Y117.223 E.69459
G1 X163.318 Y116.918 E.01012
G1 X163.172 Y116.769 E.00672
M204 S250
G1 X163.423 Y116.438 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.18 Y116.289 E.00847
G1 X162.697 Y116.211 E.01459
G1 X137.213 Y116.21 E.75905
G1 X136.813 Y116.301 E.01224
G2 X136.214 Y117.283 I.459 J.954 E.03623
G1 X136.21 Y138.79 E.64061
G2 X136.338 Y139.281 I1.718 J-.185 E.01515
G1 X136.561 Y139.553 E.0105
G1 X136.783 Y139.695 E.00784
G1 X137.132 Y139.786 E.01073
G1 X162.79 Y139.79 E.76426
G2 X163.281 Y139.662 I-.182 J-1.706 E.01515
G1 X163.552 Y139.44 E.01044
G1 X163.713 Y139.178 E.00916
G1 X163.786 Y138.743 E.01314
G1 X163.789 Y117.223 E.64098
G2 X163.663 Y116.72 I-1.526 J.116 E.01554
G1 X163.465 Y116.479 E.00927
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.18 Y116.289 E-.13016
G1 X162.697 Y116.211 E-.18611
G1 X162.529 Y116.211 E-.06373
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z4.6 I-.488 J-1.115 P1  F12000
G1 X116.388 Y136.391 Z4.6
G1 Z4.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.391 Y135.227 E.03744
; LINE_WIDTH: 0.44512
G1 X116.396 Y135.021 E.00652
; LINE_WIDTH: 0.4363
G1 X116.396 Y132.979 E.06348
; LINE_WIDTH: 0.4365
G1 X116.396 Y128.979 E.12436
; LINE_WIDTH: 0.43671
G1 X116.396 Y124.979 E.12443
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.397 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I102.589 J-1.165 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.4372
G1 X110.979 Y119.603 E.12592
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.43616
; LINE_WIDTH: 0.44999
G3 X95.612 Y119.609 I-1.171 J-105.245 E.04396
G1 X95.604 Y120.978 E.04403
; LINE_WIDTH: 0.43623
G1 X95.604 Y121.021 E.00134
; LINE_WIDTH: 0.43637
G1 X95.604 Y123.021 E.06216
; LINE_WIDTH: 0.43651
G1 X95.604 Y125.021 E.06218
; LINE_WIDTH: 0.43665
G1 X95.604 Y127.021 E.0622
; LINE_WIDTH: 0.43679
G1 X95.604 Y129.021 E.06223
; LINE_WIDTH: 0.43693
G1 X95.603 Y131.021 E.06225
; LINE_WIDTH: 0.43707
G1 X95.603 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.603 Y135.021 E.06229
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-104.302 J1.157 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.328 Y136.391 I1.171 J104.913 E.04203
M204 S10000
G1 X116.72 Y136.74 F12000
G1 F6000
M204 S3000
G1 X116.796 Y136.586 E.00551
G1 X116.797 Y119.47 E.5504
G1 X116.737 Y119.271 E.00668
G1 X116.527 Y119.202 E.00709
G1 X95.441 Y119.202 E.67805
G1 X95.28 Y119.26 E.00548
G1 X95.204 Y119.414 E.00551
G1 X95.202 Y136.56 E.55134
G1 X95.26 Y136.719 E.00546
G1 X95.463 Y136.798 E.00702
G1 X116.56 Y136.798 E.67836
G1 X116.663 Y136.76 E.00354
M204 S250
G1 X116.854 Y137.113 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X116.98 Y137.045 I-.41 J-.919 E.00428
G1 X117.134 Y136.842 E.00759
G1 X117.188 Y136.545 E.00899
G1 X117.189 Y119.47 E.50859
G1 X117.132 Y119.153 E.0096
G2 X116.824 Y118.858 I-.531 J.247 E.013
G1 X116.527 Y118.81 E.00895
G1 X95.414 Y118.81 E.62888
G2 X95.02 Y118.955 I.143 J.996 E.0126
G1 X94.866 Y119.158 E.00759
G1 X94.812 Y119.456 E.009
G1 X94.81 Y136.587 E.51027
G2 X94.955 Y136.98 I.983 J-.138 E.01258
M73 P72 R4
G1 X95.155 Y137.132 E.00748
G1 X95.495 Y137.19 E.01028
G1 X116.587 Y137.19 E.62823
G2 X116.798 Y137.136 I-.143 J-.996 E.00652
; WIPE_START
M204 S3000
G1 X116.98 Y137.045 E-.07722
G1 X117.134 Y136.842 E-.09685
G1 X117.188 Y136.545 E-.11472
G1 X117.188 Y136.305 E-.09122
; WIPE_END
M73 P73 R4
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.6 I.054 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z4.6
G1 Z4.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01244
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01907
G1 X115.992 Y135.192 E.01914
; LINE_WIDTH: 0.44512
G1 X116.002 Y135.021 E.00542
; LINE_WIDTH: 0.4363
G1 X116.002 Y132.979 E.06348
; LINE_WIDTH: 0.4365
G1 X116.002 Y128.979 E.12436
; LINE_WIDTH: 0.43671
G1 X116.002 Y124.979 E.12443
; LINE_WIDTH: 0.43681
G1 X116.003 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.4372
G1 X110.979 Y119.997 E.12592
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.43616
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.01907
G1 X95.998 Y120.979 E.02426
; LINE_WIDTH: 0.43623
G1 X95.998 Y121.021 E.00133
; LINE_WIDTH: 0.43637
G1 X95.998 Y123.021 E.06216
; LINE_WIDTH: 0.43651
G1 X95.998 Y125.021 E.06218
; LINE_WIDTH: 0.43665
G1 X95.998 Y127.021 E.0622
; LINE_WIDTH: 0.43679
G1 X95.997 Y129.021 E.06223
; LINE_WIDTH: 0.43693
G1 X95.997 Y131.021 E.06225
; LINE_WIDTH: 0.43707
G1 X95.997 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.997 Y135.021 E.06229
; LINE_WIDTH: 0.44614
G1 X96.008 Y135.192 E.00543
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00474
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.433 E.01122
G1 X115.593 Y135.122 E.01126
G2 X115.602 Y134.979 I-.818 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.878 Y120.407 E.58341
G1 X96.568 Y120.568 E.01122
G1 X96.398 Y120.978 E.01431
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00564
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.00429
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.946 Y120.793 E.53711
G1 X96.845 Y120.845 E.00338
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.6 I1.21 J-.127 P1  F12000
G1 X96.027 Y119.961 Z4.6
G1 Z4.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00244
G1 X96.027 Y120.042 E.00244
G1 X96.051 Y120.002 E.00141
; WIPE_START
G1 X96.027 Y120.042 E-.08513
G1 X95.957 Y120.002 E-.14743
G1 X96.027 Y119.961 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.6 I-1.217 J0 P1  F12000
G1 X96.026 Y135.957 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08513
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.6 I0 J1.217 P1  F12000
G1 X116.02 Y135.958 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y135.998 E.00244
G1 X116.02 Y136.039 E.00244
G1 X116.043 Y135.998 E.00141
; WIPE_START
G1 X116.02 Y136.039 E-.08513
G1 X115.949 Y135.998 E-.14743
G1 X116.02 Y135.958 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.6 I1.217 J0 P1  F12000
G1 X116.021 Y119.961 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.4214
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L22
M991 S0 P21 ;notify layer change


M106 S119.85
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z4.6 I-.787 J.928 P1  F12000
G1 X138.024 Y138.621 Z4.6
G1 Z4.4
G1 E.4 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01187
G1 X137.379 Y137.972 E.01231
G1 X137.379 Y138.621 E.01702
G1 X137.964 Y138.621 E.01535
; WIPE_START
G1 X137.667 Y138.343 E-.15468
G1 X137.379 Y137.972 E-.17839
G1 X137.379 Y138.096 E-.04693
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.8 I.006 J1.217 P1  F12000
G1 X162.618 Y137.98 Z4.8
G1 Z4.4
G1 E.4 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X162.341 Y138.334 E.01176
G1 X161.971 Y138.622 E.01226
G1 X162.618 Y138.622 E.01693
G1 X162.618 Y138.04 E.01521
; WIPE_START
G1 X162.341 Y138.334 E-.15365
G1 X161.971 Y138.622 E-.17816
G1 X162.097 Y138.622 E-.0482
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.8 I1.217 J.03 P1  F12000
G1 X162.621 Y117.379 Z4.8
G1 Z4.4
G1 E.4 F1800
; LINE_WIDTH: 0.37451
G1 F6000
M204 S3000
G1 X161.976 Y117.379 E.01688
G1 X162.333 Y117.657 E.01184
G1 X162.62 Y118.027 E.01228
G1 X162.621 Y117.439 E.0154
M204 S10000
G1 X162.892 Y117.05 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.698 Y117.01 E.00637
G3 X161.01 Y117.008 I-.473 J-331.048 E.05428
; LINE_WIDTH: 0.44631
G1 X160.801 Y117.003 E.00667
; LINE_WIDTH: 0.43706
G1 X157.199 Y117.003 E.11213
; LINE_WIDTH: 0.43716
G1 X149.199 Y117.003 E.24914
; LINE_WIDTH: 0.43729
G1 X139.199 Y117.003 E.31152
; LINE_WIDTH: 0.4495
G1 X138.647 Y117.009 E.01773
; LINE_WIDTH: 0.44999
G1 X137.268 Y117.009 E.04434
G1 X137.086 Y117.066 E.00615
G1 X137.013 Y117.225 E.00561
G1 X137.012 Y118.912 E.05428
; LINE_WIDTH: 0.44979
G1 X137.005 Y119.168 E.0082
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.712 I-90.405 J1.244 E.06148
G1 X137.075 Y138.93 E.00731
G1 X137.301 Y138.991 E.00751
G3 X138.991 Y138.993 I.485 J353.793 E.05433
; LINE_WIDTH: 0.44656
G1 X139.199 Y138.997 E.00666
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.997 E.67298
; LINE_WIDTH: 0.44999
G3 X162.751 Y138.991 I1.28 J93.344 E.06272
G1 X162.943 Y138.909 E.00671
G1 X162.987 Y138.733 E.00586
G3 X162.99 Y137.009 I231.897 J-.468 E.05542
; LINE_WIDTH: 0.44457
G1 X162.995 Y136.8 E.00662
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.216 I89.952 J-1.281 E.06379
; LINE_WIDTH: 0.44999
G1 X162.923 Y117.102 E.00427
M204 S10000
G1 X163.126 Y116.724 F12000
G1 F6000
M204 S3000
G1 X163.105 Y116.703 E.00095
G1 X162.772 Y116.603 E.01119
G1 X137.24 Y116.602 E.82098
G1 X136.896 Y116.693 E.01145
G1 X136.703 Y116.895 E.00901
G1 X136.606 Y117.176 E.00957
G1 X136.602 Y138.748 E.69366
G1 X136.695 Y139.092 E.01144
G1 X136.848 Y139.275 E.00768
G1 X137.108 Y139.376 E.00897
G2 X138.771 Y139.398 I1.264 J-32.807 E.0535
G1 X162.771 Y139.398 E.77173
G1 X163.113 Y139.3 E.01143
; object ids of layer 22 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer22 end: 47,58
M625
G1 X163.332 Y139.058 E.0105
G1 X163.394 Y138.733 E.01064
G1 X163.397 Y117.216 E.69187
G1 X163.322 Y116.925 E.00965
G1 X163.167 Y116.767 E.00712
M204 S250
G1 X163.421 Y116.437 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.18 Y116.289 E.00844
G1 X162.698 Y116.211 E.01454
G1 X137.213 Y116.21 E.75909
G1 X136.813 Y116.301 E.01223
G2 X136.214 Y117.283 I.459 J.954 E.03624
G1 X136.21 Y138.783 E.64038
G1 X136.274 Y139.144 E.01091
G1 X136.425 Y139.413 E.00921
G1 X136.618 Y139.598 E.00795
G1 X136.895 Y139.739 E.00926
G1 X137.315 Y139.79 E.0126
G1 X162.79 Y139.79 E.75881
G2 X163.317 Y139.641 I-.203 J-1.723 E.01638
G1 X163.553 Y139.44 E.00921
G1 X163.695 Y139.217 E.0079
G1 X163.786 Y138.733 E.01467
G1 X163.789 Y117.216 E.64088
G2 X163.668 Y116.73 I-1.597 J.139 E.01499
G1 X163.464 Y116.478 E.00965
; WIPE_START
M204 S3000
G1 X163.18 Y116.289 E-.12969
G1 X162.698 Y116.211 E-.18547
G1 X162.528 Y116.211 E-.06484
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.8 I-.936 J-.777 P1  F12000
G1 X161.438 Y117.524 Z4.8
G1 Z4.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.258 Y117.458 E.00616
; LINE_WIDTH: 0.44896
G1 X160.801 Y117.397 E.01479
; LINE_WIDTH: 0.43706
G1 X157.199 Y117.397 E.11213
; LINE_WIDTH: 0.43716
G1 X149.199 Y117.397 E.24914
; LINE_WIDTH: 0.43729
G1 X139.199 Y117.397 E.31152
; LINE_WIDTH: 0.4495
G1 X138.693 Y117.473 E.01644
; LINE_WIDTH: 0.44993
G1 X138.337 Y117.62 E.01237
G1 X137.922 Y117.919 E.01647
G1 X137.62 Y118.337 E.01656
G1 X137.476 Y118.674 E.01179
G1 X137.399 Y119.168 E.01607
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.666 Y137.74 E.0136
G1 X137.939 Y138.093 E.01434
G1 X138.417 Y138.423 E.01868
G1 X138.743 Y138.543 E.01115
; LINE_WIDTH: 0.44903
G1 X139.199 Y138.603 E.01478
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.603 E.67298
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.0181
G1 X161.74 Y138.334 E.0136
G1 X162.092 Y138.062 E.01429
G1 X162.423 Y137.584 E.01871
G1 X162.542 Y137.258 E.01116
; LINE_WIDTH: 0.44852
G1 X162.602 Y136.8 E.01477
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.01809
G1 X162.334 Y118.26 E.0136
G1 X162.061 Y117.907 E.01435
G1 X161.584 Y117.577 E.01865
G1 X161.494 Y117.544 E.00306
M204 S10000
G1 X161.331 Y117.929 F12000
G1 F6000
M204 S3000
G1 X161.187 Y117.858 E.00516
G1 X160.801 Y117.798 E.01255
G1 X139.199 Y117.798 E.69461
G1 X138.772 Y117.872 E.01393
G2 X138.137 Y118.296 I.589 J1.57 E.0248
G1 X137.874 Y118.761 E.01718
G1 X137.799 Y119.168 E.01329
G1 X137.798 Y136.801 E.567
M73 P74 R4
G1 X137.887 Y137.269 E.01532
G1 X137.991 Y137.494 E.008
G1 X138.239 Y137.818 E.0131
G1 X138.623 Y138.072 E.01481
G1 X138.814 Y138.142 E.00656
G1 X139.199 Y138.202 E.01254
G1 X160.801 Y138.202 E.6946
G1 X161.268 Y138.113 E.01531
G2 X161.925 Y137.627 I-.677 J-1.603 E.02652
G1 X162.142 Y137.186 E.01581
G1 X162.202 Y136.801 E.01255
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.732 E.01531
G2 X161.627 Y118.074 I-1.604 J.678 E.02654
G1 X161.385 Y117.955 E.00869
M204 S250
G1 X161.166 Y118.264 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X160.801 Y118.19 E.0111
G1 X139.199 Y118.19 E.64342
G1 X138.849 Y118.256 E.01062
G1 X138.515 Y118.462 E.0117
G1 X138.284 Y118.781 E.01171
G1 X138.191 Y119.168 E.01185
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01168
G1 X138.516 Y137.538 E.01285
G1 X138.821 Y137.734 E.01078
G1 X139.199 Y137.81 E.0115
G1 X160.801 Y137.81 E.64341
G1 X161.184 Y137.73 E.01168
G1 X161.538 Y137.484 E.01284
G1 X161.733 Y137.179 E.01078
G1 X161.81 Y136.8 E.01152
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.816 E.01167
G1 X161.484 Y118.461 E.01285
G1 X161.219 Y118.292 E.00938
; WIPE_START
M204 S3000
G1 X160.801 Y118.19 E-.16333
G1 X160.231 Y118.19 E-.21667
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.8 I.039 J-1.216 P1  F12000
G1 X137.587 Y117.471 Z4.8
G1 Z4.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.70174
G1 F4553.596
M204 S3000
G2 X137.628 Y117.542 I-.036 J.068 E.02074
; OBJECT_ID: 47
; WIPE_START
G1 X137.587 Y117.613 E-.076
G1 X137.504 Y117.613 E-.076
G1 X137.463 Y117.542 E-.076
G1 X137.505 Y117.471 E-.076
G1 X137.587 Y117.471 E-.07599
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z4.8 I-.81 J-.908 P1  F12000
G1 X116.391 Y136.391 Z4.8
G1 Z4.4
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.451 J-1.178 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.4372
G1 X112.979 Y119.603 E.06363
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.49846
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.772 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.715 Y136.74 F12000
G1 F6000
M204 S3000
G1 X116.721 Y136.738 E.00024
G1 X116.798 Y136.537 E.00692
G1 X116.797 Y119.465 E.54893
G1 X116.734 Y119.27 E.00661
G1 X116.526 Y119.202 E.00703
G1 X95.441 Y119.202 E.67803
G1 X95.281 Y119.26 E.00547
G1 X95.202 Y119.463 E.00702
G1 X95.202 Y136.562 E.54981
G1 X95.262 Y136.721 E.00549
G1 X95.463 Y136.798 E.00692
G1 X116.562 Y136.798 E.67843
G1 X116.658 Y136.761 E.00332
M204 S250
G1 X116.854 Y137.11 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.981 Y137.044 E.00425
G1 X117.132 Y136.845 E.00744
G1 X117.19 Y136.505 E.01029
G1 X117.189 Y119.465 E.50753
G1 X117.137 Y119.164 E.00911
G2 X116.824 Y118.858 I-.537 J.236 E.01337
G1 X116.526 Y118.81 E.00897
G1 X95.414 Y118.81 E.62886
G2 X95.02 Y118.955 I.137 J.981 E.01259
G1 X94.868 Y119.155 E.00749
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.587 E.5091
G2 X94.956 Y136.981 I1.025 J-.155 E.0126
G1 X95.155 Y137.132 E.00744
G1 X95.495 Y137.19 E.01028
G1 X116.587 Y137.19 E.62824
G2 X116.8 Y137.134 I-.155 J-1.024 E.00656
; WIPE_START
M204 S3000
G1 X116.981 Y137.044 E-.0769
G1 X117.132 Y136.845 E-.09493
G1 X117.19 Y136.505 E-.13125
G1 X117.19 Y136.302 E-.07693
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.8 I.052 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z4.8
G1 Z4.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.4372
G1 X112.979 Y119.997 E.06363
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.49846
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.793 Y134.994 E.41618
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.8 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z4.8
G1 Z4.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.8 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z4.8
G1 Z4.4
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.8 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z4.8
G1 Z4.4
G1 E.4 F1800
; LINE_WIDTH: 0.42148
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; WIPE_START
G1 X116.021 Y120.043 E-.08512
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z4.8 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z4.8
G1 Z4.4
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L23
M991 S0 P22 ;notify layer change


M106 S117.3
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z4.8 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z4.8
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.37451
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01694
G1 X162.415 Y117.756 E.0152
G1 X162.621 Y118.027 E.00891
G1 X162.621 Y117.439 E.0154
; WIPE_START
G1 X161.974 Y117.379 E-.24675
G1 X162.241 Y117.607 E-.13325
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5 I-1.217 J.023 P1  F12000
G1 X162.621 Y137.976 Z5
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.343 Y138.333 E.01187
M73 P75 R4
G1 X161.972 Y138.621 E.01232
G1 X162.621 Y138.621 E.01703
G1 X162.621 Y138.036 E.01535
; WIPE_START
G1 X162.343 Y138.333 E-.15464
G1 X161.972 Y138.621 E-.17852
G1 X162.095 Y138.621 E-.04684
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z5
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01187
G1 X137.379 Y137.972 E.01231
G1 X137.379 Y138.621 E.01702
G1 X137.964 Y138.621 E.01535
; WIPE_START
G1 X137.667 Y138.343 E-.15466
G1 X137.379 Y137.972 E-.17841
G1 X137.379 Y138.096 E-.04693
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5 I1.216 J.038 P1  F12000
G1 X138.033 Y117.381 Z5
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.3729
G1 F6000
M204 S3000
G1 X137.381 Y117.381 E.01698
G1 X137.381 Y118.023 E.01673
G1 X137.731 Y117.605 E.0142
G1 X137.984 Y117.417 E.00824
; WIPE_START
G1 X137.381 Y117.381 E-.22961
G1 X137.381 Y117.777 E-.1504
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5 I.014 J1.217 P1  F12000
G1 X161.398 Y117.508 Z5
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.45791
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00829
G2 X160.8 Y117.397 I-.298 J1.428 E.01182
; LINE_WIDTH: 0.43689
G1 X139.135 Y117.4 E.67424
; LINE_WIDTH: 0.44581
G1 X138.965 Y117.41 E.00543
; LINE_WIDTH: 0.44999
G1 X138.547 Y117.523 E.01393
G2 X137.907 Y117.939 I.694 J1.766 E.02471
G1 X137.562 Y118.452 E.01988
G1 X137.451 Y118.76 E.01052
; LINE_WIDTH: 0.44824
G1 X137.399 Y119.168 E.01317
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44608
G1 X137.408 Y136.971 E.00543
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01266
G1 X137.666 Y137.74 E.0136
G1 X137.939 Y138.093 E.01434
G1 X138.417 Y138.423 E.01867
G1 X138.742 Y138.543 E.01115
; LINE_WIDTH: 0.44903
G1 X139.199 Y138.603 E.01479
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.603 E.67298
; LINE_WIDTH: 0.44999
G1 X161.355 Y138.511 E.01808
G1 X161.74 Y138.334 E.0136
G1 X162.093 Y138.061 E.01436
G1 X162.423 Y137.583 E.01868
G1 X162.543 Y137.258 E.01115
; LINE_WIDTH: 0.44897
G1 X162.603 Y136.801 E.01478
; LINE_WIDTH: 0.43719
G1 X162.603 Y131.199 E.17445
; LINE_WIDTH: 0.43706
G1 X162.603 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.603 Y119.199 E.18674
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.01811
G1 X162.333 Y118.26 E.0136
G1 X162.121 Y117.979 E.01132
G1 X161.799 Y117.704 E.01362
G1 X161.488 Y117.538 E.01133
; LINE_WIDTH: 0.45791
G1 X161.455 Y117.527 E.00114
M204 S10000
G1 X161.297 Y117.923 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.102 Y117.834 E.00689
G1 X160.8 Y117.798 E.00978
G1 X139.135 Y117.8 E.69666
G1 X138.659 Y117.914 E.01574
G2 X138.07 Y118.38 I.709 J1.501 E.02438
G1 X137.85 Y118.833 E.01618
G1 X137.799 Y119.168 E.01088
G1 X137.807 Y136.901 E.57022
G1 X137.887 Y137.268 E.0121
G2 X138.373 Y137.926 I1.603 J-.678 E.02654
G1 X138.814 Y138.142 E.01579
G1 X139.199 Y138.202 E.01254
G1 X160.801 Y138.202 E.6946
G1 X161.268 Y138.113 E.0153
G2 X161.926 Y137.627 I-.678 J-1.605 E.02656
G1 X162.142 Y137.186 E.01579
G1 X162.202 Y136.801 E.01254
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.731 E.01532
G2 X161.607 Y118.063 I-1.545 J.644 E.02724
G1 X161.352 Y117.947 E.00901
M204 S250
G1 X161.143 Y118.261 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.00108
G1 X160.8 Y118.19 E.0094
G1 X139.135 Y118.193 E.64531
G1 X138.768 Y118.291 E.01133
G1 X138.458 Y118.519 E.01146
G1 X138.257 Y118.846 E.01142
G1 X138.191 Y119.168 E.0098
G1 X138.193 Y136.833 E.52618
G1 X138.27 Y137.184 E.01071
G1 X138.516 Y137.539 E.01285
G1 X138.821 Y137.734 E.01077
G1 X139.199 Y137.81 E.01151
G1 X160.801 Y137.81 E.64341
G1 X161.184 Y137.73 E.01166
G1 X161.539 Y137.484 E.01287
G1 X161.734 Y137.179 E.01077
G1 X161.81 Y136.801 E.01151
G1 X161.81 Y119.199 E.52427
G1 X161.73 Y118.815 E.01168
G1 X161.484 Y118.462 E.01284
G1 X161.195 Y118.292 E.00998
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.03663
G1 X160.8 Y118.19 E-.11994
G1 X160.212 Y118.19 E-.22343
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5 I.476 J1.12 P1  F12000
G1 X162.894 Y117.05 Z5
G1 Z4.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.699 Y117.01 E.00638
G3 X160.963 Y117.006 I-.556 J-151.756 E.05584
; LINE_WIDTH: 0.44246
G1 X160.8 Y117.003 E.00513
; LINE_WIDTH: 0.43689
G1 X139.135 Y117.006 E.67424
; LINE_WIDTH: 0.44999
G3 X137.234 Y117.013 I-1.292 J-95.694 E.06112
G1 X137.076 Y117.076 E.00548
G1 X137.013 Y117.267 E.00647
G3 X137.01 Y118.953 I-259.216 J.475 E.0542
; LINE_WIDTH: 0.44579
G1 X137.005 Y119.168 E.00685
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.732 I-91.402 J1.255 E.0621
G1 X137.081 Y138.935 E.00694
G1 X137.315 Y138.991 E.00774
G3 X138.991 Y138.993 I.474 J356.427 E.05387
; LINE_WIDTH: 0.44656
G1 X139.199 Y138.997 E.00666
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.997 E.67298
; LINE_WIDTH: 0.44999
G3 X162.712 Y138.991 I1.258 J91.259 E.06147
G1 X162.926 Y138.923 E.00722
G1 X162.991 Y138.722 E.0068
G3 X162.993 Y137.009 I329.648 J-.506 E.05506
; LINE_WIDTH: 0.44622
G1 X162.997 Y136.801 E.00666
; LINE_WIDTH: 0.43719
G1 X162.997 Y131.199 E.17445
; LINE_WIDTH: 0.43706
G1 X162.997 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.997 Y119.199 E.18674
; LINE_WIDTH: 0.45008
G3 X162.99 Y117.221 I91.031 J-1.294 E.06362
; LINE_WIDTH: 0.44999
G1 X162.923 Y117.103 E.00438
M204 S10000
G1 X163.128 Y116.725 F12000
G1 F6000
M204 S3000
G1 X163.106 Y116.703 E.00098
G1 X162.773 Y116.603 E.01119
G1 X137.182 Y116.606 E.8229
G1 X136.954 Y116.665 E.0076
G1 X136.725 Y116.869 E.00984
G1 X136.627 Y117.1 E.00808
G2 X136.605 Y118.76 I34.66 J1.283 E.05338
G1 X136.602 Y138.76 E.64311
G1 X136.686 Y139.069 E.0103
G1 X136.829 Y139.261 E.0077
G1 X137.081 Y139.367 E.00878
G2 X138.748 Y139.398 I1.28 J-24.338 E.05364
G1 X162.748 Y139.398 E.77173
G1 X163.081 Y139.315 E.01103
G1 X163.278 Y139.147 E.00831
; object ids of layer 23 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer23 end: 47,58
M625
G1 X163.376 Y138.892 E.00878
G2 X163.398 Y137.195 I-33.529 J-1.28 E.05459
G1 X163.397 Y117.195 E.64311
G1 X163.314 Y116.912 E.00947
G1 X163.17 Y116.768 E.00656
M204 S250
G1 X163.42 Y116.436 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.18 Y116.289 E.00839
G1 X162.699 Y116.211 E.01452
G1 X137.132 Y116.214 E.76155
G1 X136.787 Y116.304 E.01062
G1 X136.502 Y116.502 E.01033
G1 X136.304 Y116.787 E.01035
G1 X136.214 Y117.267 E.01455
G1 X136.21 Y138.787 E.64099
G1 X136.248 Y139.065 E.00836
G1 X136.403 Y139.384 E.01056
G1 X136.587 Y139.575 E.00789
G1 X136.856 Y139.726 E.0092
G1 X137.315 Y139.79 E.0138
G1 X162.783 Y139.79 E.75858
G1 X163.145 Y139.725 E.01097
G1 X163.379 Y139.6 E.00789
G1 X163.599 Y139.38 E.00927
G1 X163.739 Y139.105 E.00921
G1 X163.79 Y138.685 E.0126
G1 X163.789 Y117.195 E.64011
G2 X163.661 Y116.718 I-2.218 J.339 E.01474
G1 X163.463 Y116.477 E.00928
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.18 Y116.289 E-.1291
G1 X162.699 Y116.211 E-.18521
G1 X162.526 Y116.211 E-.0657
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z5 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z5
G1 Z4.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.453 J-1.178 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.4372
G1 X114.979 Y119.603 E.00134
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.56077
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.772 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.798 Y136.537 E.00738
G1 X116.797 Y119.451 E.5494
G1 X116.727 Y119.265 E.00639
G1 X116.526 Y119.202 E.00678
G1 X95.452 Y119.202 E.67764
G1 X95.288 Y119.251 E.00551
G1 X95.202 Y119.463 E.00738
G1 X95.202 Y136.56 E.54974
G1 X95.26 Y136.719 E.00546
G1 X95.463 Y136.798 E.00701
G1 X116.548 Y136.798 E.67799
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.132 Y136.845 I-.584 J-.805 E.01066
M73 P76 R4
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.451 E.50797
G1 X117.152 Y119.202 E.00749
G1 X117.013 Y118.985 E.00769
G1 X116.824 Y118.858 E.00679
G1 X116.526 Y118.81 E.00898
G1 X95.417 Y118.81 E.62873
G1 X95.114 Y118.898 E.0094
G2 X94.868 Y119.155 I.584 J.804 E.01066
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.587 E.50909
G2 X94.955 Y136.98 I.982 J-.138 E.01258
G1 X95.155 Y137.132 E.00748
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
M204 S3000
G1 X117.054 Y136.948 E-.10774
G1 X117.132 Y136.845 E-.04891
G1 X117.19 Y136.505 E-.13115
G1 X117.19 Y136.262 E-.0922
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5 I.05 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z5
G1 Z4.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.4372
G1 X114.979 Y119.997 E.00134
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.56077
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.793 Y134.994 E.41618
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z5
G1 Z4.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z5
G1 Z4.6
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z5
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.42148
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; WIPE_START
G1 X116.021 Y120.043 E-.08512
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z5
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L24
M991 S0 P23 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z5 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z5
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.3745
G1 F6000
M204 S3000
G1 X161.976 Y117.379 E.01688
G1 X162.333 Y117.657 E.01184
G1 X162.621 Y118.027 E.01228
G1 X162.621 Y117.439 E.01541
; WIPE_START
G1 X161.976 Y117.379 E-.24596
G1 X162.254 Y117.596 E-.13404
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.2 I-1.217 J.022 P1  F12000
G1 X162.621 Y137.976 Z5.2
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X162.343 Y138.333 E.01188
G1 X161.972 Y138.621 E.01232
G1 X162.621 Y138.621 E.01703
G1 X162.621 Y138.036 E.01535
; WIPE_START
G1 X162.343 Y138.333 E-.1547
G1 X161.972 Y138.621 E-.17849
G1 X162.095 Y138.621 E-.0468
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.2 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z5.2
G1 Z4.8
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01187
G1 X137.379 Y137.972 E.01231
G1 X137.379 Y138.621 E.01702
G1 X137.964 Y138.621 E.01535
; WIPE_START
G1 X137.667 Y138.343 E-.15467
G1 X137.379 Y137.972 E-.17841
G1 X137.379 Y138.096 E-.04693
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.2 I1.216 J.039 P1  F12000
G1 X138.05 Y117.381 Z5.2
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.37862
G1 F6000
M204 S3000
G1 X137.384 Y117.381 E.01766
G1 X137.384 Y118.036 E.01739
G1 X137.663 Y117.674 E.01214
G1 X138.002 Y117.417 E.01128
; WIPE_START
G1 X137.384 Y117.381 E-.2353
G1 X137.384 Y117.761 E-.1447
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.2 I.012 J1.217 P1  F12000
G1 X161.439 Y117.524 Z5.2
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.258 Y117.457 E.00622
; LINE_WIDTH: 0.44895
G1 X160.801 Y117.397 E.01478
; LINE_WIDTH: 0.43713
G1 X159.128 Y117.398 E.05208
; LINE_WIDTH: 0.43731
G1 X157.128 Y117.398 E.06231
; LINE_WIDTH: 0.43748
G1 X155.128 Y117.398 E.06233
; LINE_WIDTH: 0.43766
G1 X153.128 Y117.398 E.06236
; LINE_WIDTH: 0.43783
G1 X151.128 Y117.398 E.06239
; LINE_WIDTH: 0.43801
G1 X149.128 Y117.399 E.06242
; LINE_WIDTH: 0.43818
G1 X147.128 Y117.399 E.06245
; LINE_WIDTH: 0.43836
G1 X145.128 Y117.399 E.06247
; LINE_WIDTH: 0.43853
G1 X143.128 Y117.399 E.0625
; LINE_WIDTH: 0.43871
G1 X141.128 Y117.399 E.06253
; LINE_WIDTH: 0.43889
G1 X139.128 Y117.4 E.06256
; LINE_WIDTH: 0.44783
G1 X138.958 Y117.41 E.00546
; LINE_WIDTH: 0.44999
G1 X138.508 Y117.539 E.01504
G1 X138.143 Y117.745 E.01348
G1 X137.91 Y117.952 E.01002
G1 X137.639 Y118.303 E.01428
; LINE_WIDTH: 0.45269
G1 X137.422 Y118.872 E.0197
G1 X137.398 Y119.167 E.00959
; LINE_WIDTH: 0.43609
G1 X137.398 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43636
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43649
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43662
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44608
G1 X137.408 Y136.971 E.00543
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01266
G1 X137.666 Y137.74 E.0136
G1 X137.939 Y138.093 E.01434
G1 X138.417 Y138.423 E.01867
G1 X138.742 Y138.543 E.01115
; LINE_WIDTH: 0.44903
G1 X139.199 Y138.603 E.01479
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.603 E.67298
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.01809
G1 X161.74 Y138.334 E.0136
G1 X162.093 Y138.061 E.01435
G1 X162.423 Y137.583 E.01867
G1 X162.543 Y137.258 E.01116
; LINE_WIDTH: 0.44897
G1 X162.603 Y136.8 E.01479
; LINE_WIDTH: 0.43719
G1 X162.603 Y131.199 E.17444
; LINE_WIDTH: 0.43706
G1 X162.603 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.603 Y119.199 E.18674
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.01809
G1 X162.334 Y118.26 E.0136
G1 X162.061 Y117.907 E.01436
G1 X161.583 Y117.577 E.01867
G1 X161.496 Y117.545 E.003
M204 S10000
G1 X161.332 Y117.929 F12000
G1 F6000
M204 S3000
G1 X161.186 Y117.858 E.00523
G1 X160.801 Y117.798 E.01254
G1 X139.128 Y117.801 E.69689
G1 X138.628 Y117.928 E.0166
G2 X137.799 Y119.167 I.638 J1.324 E.05029
G1 X137.807 Y136.901 E.57023
G1 X137.887 Y137.269 E.0121
G2 X138.373 Y137.926 I1.603 J-.678 E.02654
G1 X138.814 Y138.142 E.0158
G1 X139.199 Y138.202 E.01254
G1 X160.801 Y138.202 E.6946
G1 X161.268 Y138.113 E.01531
G2 X161.925 Y137.627 I-.677 J-1.603 E.02653
G1 X162.142 Y137.186 E.01581
G1 X162.202 Y136.8 E.01255
G1 X162.202 Y119.199 E.56597
G1 X162.113 Y118.732 E.01531
G2 X161.627 Y118.075 I-1.603 J.677 E.02653
G1 X161.386 Y117.956 E.00865
M204 S250
G1 X161.168 Y118.264 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X160.801 Y118.19 E.01114
G1 X139.128 Y118.193 E.64553
G1 X138.743 Y118.303 E.01193
G1 X138.41 Y118.576 E.01283
G1 X138.23 Y118.929 E.0118
G1 X138.191 Y119.167 E.0072
G1 X138.193 Y136.833 E.52619
G1 X138.27 Y137.184 E.01071
G1 X138.516 Y137.539 E.01285
G1 X138.821 Y137.734 E.01077
G1 X139.199 Y137.81 E.01151
G1 X160.801 Y137.81 E.64341
G1 X161.184 Y137.73 E.01167
G1 X161.538 Y137.484 E.01285
G1 X161.734 Y137.179 E.01078
G1 X161.81 Y136.8 E.01151
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.816 E.01167
M73 P77 R4
G1 X161.484 Y118.462 E.01284
G1 X161.22 Y118.292 E.00935
; WIPE_START
M204 S3000
G1 X160.801 Y118.19 E-.16385
G1 X160.232 Y118.19 E-.21615
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.2 I.474 J1.121 P1  F12000
G1 X162.908 Y117.059 Z5.2
G1 Z4.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.701 Y117.01 E.00684
G3 X161.01 Y117.008 I-.471 J-329.213 E.05436
; LINE_WIDTH: 0.44626
G1 X160.801 Y117.003 E.00667
; LINE_WIDTH: 0.43713
G1 X159.128 Y117.003 E.05208
; LINE_WIDTH: 0.43731
G1 X157.128 Y117.003 E.06231
; LINE_WIDTH: 0.43748
G1 X155.128 Y117.003 E.06233
; LINE_WIDTH: 0.43766
G1 X153.128 Y117.003 E.06236
; LINE_WIDTH: 0.43783
G1 X151.128 Y117.003 E.06239
; LINE_WIDTH: 0.43801
G1 X149.128 Y117.003 E.06242
; LINE_WIDTH: 0.43818
G1 X147.128 Y117.004 E.06245
; LINE_WIDTH: 0.43836
G1 X145.128 Y117.004 E.06247
; LINE_WIDTH: 0.43853
G1 X143.128 Y117.004 E.0625
; LINE_WIDTH: 0.43871
G1 X141.128 Y117.004 E.06253
; LINE_WIDTH: 0.43889
G1 X139.128 Y117.004 E.06256
; LINE_WIDTH: 0.44999
G3 X137.249 Y117.009 I-1.286 J-118.488 E.06044
G1 X137.064 Y117.084 E.00641
G1 X137.013 Y117.258 E.00582
G1 X137.013 Y118.166 E.0292
; LINE_WIDTH: 0.45269
G3 X137.005 Y119.167 I-18.038 J.372 E.03243
; LINE_WIDTH: 0.43609
G1 X137.005 Y120.801 E.05072
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43636
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43649
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43662
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.722 I-90.937 J1.25 E.06179
G1 X137.079 Y138.932 E.0071
G1 X137.301 Y138.991 E.00741
G3 X138.991 Y138.993 I.488 J352.177 E.05432
; LINE_WIDTH: 0.44656
G1 X139.199 Y138.997 E.00666
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.997 E.67298
; LINE_WIDTH: 0.44999
G3 X162.712 Y138.991 I1.259 J91.529 E.06147
G1 X162.928 Y138.925 E.00724
G1 X162.991 Y138.722 E.00686
G3 X162.993 Y137.009 I329.973 J-.506 E.05507
; LINE_WIDTH: 0.44622
G1 X162.997 Y136.8 E.00665
; LINE_WIDTH: 0.43719
G1 X162.997 Y131.199 E.17444
; LINE_WIDTH: 0.43706
G1 X162.997 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.997 Y119.199 E.18674
; LINE_WIDTH: 0.45007
G3 X162.99 Y117.221 I90.968 J-1.294 E.06365
; LINE_WIDTH: 0.44999
G1 X162.935 Y117.113 E.0039
M204 S10000
G1 X163.126 Y116.723 F12000
G1 F6000
M204 S3000
G1 X163.106 Y116.703 E.00089
G1 X162.774 Y116.603 E.01114
G1 X137.229 Y116.602 E.82143
G1 X136.887 Y116.7 E.01143
G1 X136.701 Y116.897 E.0087
G1 X136.606 Y117.177 E.0095
G1 X136.602 Y138.754 E.69384
G1 X136.691 Y139.079 E.01082
G1 X136.849 Y139.276 E.00813
G1 X137.121 Y139.378 E.00934
G2 X138.748 Y139.398 I1.24 J-34.891 E.05234
G1 X162.748 Y139.398 E.77173
G1 X163.096 Y139.304 E.01158
G1 X163.276 Y139.151 E.00759
; object ids of layer 24 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer24 end: 47,58
M625
G1 X163.376 Y138.892 E.00892
G2 X163.398 Y137.22 I-32.937 J-1.267 E.05377
G1 X163.397 Y117.221 E.64311
G1 X163.318 Y116.918 E.01007
G1 X163.168 Y116.766 E.00687
M204 S250
G1 X163.419 Y116.435 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.18 Y116.289 E.00834
G1 X162.701 Y116.211 E.01447
G1 X137.21 Y116.21 E.75927
G2 X136.683 Y116.359 I.21 J1.748 E.01637
G1 X136.449 Y116.559 E.00916
G1 X136.287 Y116.822 E.00921
G1 X136.214 Y117.257 E.01315
G1 X136.21 Y138.785 E.64121
G1 X136.261 Y139.104 E.00962
G1 X136.421 Y139.407 E.01023
G1 X136.618 Y139.598 E.00818
G1 X136.895 Y139.739 E.00924
G1 X137.301 Y139.79 E.0122
G1 X162.783 Y139.79 E.75899
G2 X163.598 Y139.382 I-.043 J-1.103 E.02799
G1 X163.739 Y139.105 E.00925
G1 X163.79 Y138.685 E.01261
G1 X163.789 Y117.22 E.63934
G2 X163.663 Y116.719 I-1.548 J.124 E.01547
G1 X163.462 Y116.475 E.0094
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.18 Y116.289 E-.12852
G1 X162.701 Y116.211 E-.18461
G1 X162.525 Y116.211 E-.06687
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z5.2 I-.488 J-1.115 P1  F12000
G1 X116.388 Y136.391 Z5.2
G1 Z4.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.391 Y135.227 E.03744
; LINE_WIDTH: 0.44512
G1 X116.396 Y135.021 E.00652
; LINE_WIDTH: 0.4363
G1 X116.396 Y132.979 E.06348
; LINE_WIDTH: 0.4365
G1 X116.396 Y128.979 E.12436
; LINE_WIDTH: 0.43671
G1 X116.396 Y124.979 E.12443
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.397 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I102.597 J-1.165 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.4372
G1 X114.979 Y119.603 E.00134
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.56077
; LINE_WIDTH: 0.44999
G3 X95.612 Y119.609 I-1.171 J-105.243 E.04396
G1 X95.604 Y120.978 E.04403
; LINE_WIDTH: 0.43622
G1 X95.604 Y121.021 E.00134
; LINE_WIDTH: 0.43636
G1 X95.604 Y123.021 E.06216
; LINE_WIDTH: 0.4365
G1 X95.604 Y125.021 E.06218
; LINE_WIDTH: 0.43664
G1 X95.604 Y127.021 E.0622
; LINE_WIDTH: 0.43678
G1 X95.604 Y129.021 E.06222
; LINE_WIDTH: 0.43692
G1 X95.603 Y131.021 E.06225
; LINE_WIDTH: 0.43706
G1 X95.603 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.603 Y135.021 E.06229
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-104.872 J1.16 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.328 Y136.391 I1.171 J104.913 E.04203
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.796 Y136.586 E.00589
G1 X116.797 Y119.469 E.5504
G1 X116.737 Y119.271 E.00666
G1 X116.525 Y119.202 E.00716
G1 X95.452 Y119.202 E.67762
G1 X95.288 Y119.25 E.00551
G1 X95.204 Y119.414 E.00589
G1 X95.202 Y136.548 E.55098
G1 X95.251 Y136.712 E.0055
G1 X95.463 Y136.798 E.00737
G1 X116.548 Y136.798 E.67799
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.167 Y136.714 I-.35 J-.55 E.01461
G2 X117.188 Y135.469 I-21.94 J-.983 E.03709
G1 X117.189 Y119.47 E.47657
G1 X117.132 Y119.153 E.00958
G2 X116.824 Y118.858 I-.531 J.246 E.01301
G1 X116.525 Y118.81 E.00901
G1 X95.417 Y118.81 E.62871
G1 X95.114 Y118.898 E.0094
G2 X94.833 Y119.285 I.351 J.551 E.0146
G2 X94.812 Y120.583 I22.824 J1.01 E.03867
G1 X94.81 Y136.583 E.47657
G1 X94.898 Y136.886 E.0094
G2 X95.155 Y137.132 I.804 J-.584 E.01065
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
M204 S3000
G1 X117.061 Y136.939 E-.11164
G1 X117.167 Y136.714 E-.09452
G1 X117.175 Y136.257 E-.17384
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.2 I.051 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z5.2
G1 Z4.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01244
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01907
G1 X115.992 Y135.192 E.01914
; LINE_WIDTH: 0.44512
G1 X116.002 Y135.021 E.00542
; LINE_WIDTH: 0.4363
G1 X116.002 Y132.979 E.06348
; LINE_WIDTH: 0.4365
G1 X116.002 Y128.979 E.12436
; LINE_WIDTH: 0.43671
G1 X116.002 Y124.979 E.12443
; LINE_WIDTH: 0.43681
G1 X116.003 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.4372
G1 X114.979 Y119.997 E.00134
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.56077
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.01907
G1 X95.998 Y120.979 E.02426
; LINE_WIDTH: 0.43622
G1 X95.998 Y121.021 E.00133
; LINE_WIDTH: 0.43636
G1 X95.998 Y123.021 E.06216
; LINE_WIDTH: 0.4365
G1 X95.998 Y125.021 E.06218
; LINE_WIDTH: 0.43664
G1 X95.998 Y127.021 E.0622
; LINE_WIDTH: 0.43678
G1 X95.997 Y129.021 E.06222
; LINE_WIDTH: 0.43692
G1 X95.997 Y131.021 E.06225
; LINE_WIDTH: 0.43706
G1 X95.997 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.997 Y135.021 E.06229
; LINE_WIDTH: 0.44614
G1 X96.008 Y135.192 E.00543
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00474
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.433 E.01122
G1 X115.593 Y135.122 E.01126
G2 X115.602 Y134.979 I-.818 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01122
G1 X96.398 Y120.978 E.01431
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.0043
G1 X96.979 Y135.21 E.0043
G1 X115.021 Y135.21 E.53742
G1 X115.155 Y135.155 E.00429
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.00429
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
M73 P78 R4
G1 X97.633 Y135.21 E-.24877
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.2 I-.513 J-1.104 P1  F12000
G1 X96.026 Y135.957 Z5.2
G1 Z4.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08513
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.2 I1.217 J0 P1  F12000
G1 X96.027 Y119.961 Z5.2
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00244
G1 X96.027 Y120.042 E.00244
G1 X96.051 Y120.002 E.00141
; WIPE_START
G1 X96.027 Y120.042 E-.08513
G1 X95.957 Y120.002 E-.14743
G1 X96.027 Y119.961 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.2 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z5.2
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.42144
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00141
; WIPE_START
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.2 I-1.217 J0 P1  F12000
G1 X116.02 Y135.958 Z5.2
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y135.998 E.00244
G1 X116.02 Y136.039 E.00244
G1 X116.043 Y135.998 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.02 Y136.039 E-.08513
G1 X115.949 Y135.998 E-.14743
G1 X116.02 Y135.958 E-.14743
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L25
M991 S0 P24 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z5.2 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z5.2
G1 Z5
G1 E.4 F1800
; LINE_WIDTH: 0.37449
G1 F6000
M204 S3000
G1 X161.976 Y117.379 E.01688
G1 X162.333 Y117.657 E.01184
G1 X162.621 Y118.027 E.01228
G1 X162.621 Y117.439 E.0154
; WIPE_START
G1 X161.976 Y117.379 E-.24593
G1 X162.254 Y117.596 E-.13407
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.4 I-1.217 J.022 P1  F12000
G1 X162.621 Y137.974 Z5.4
G1 Z5
G1 E.4 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.243 Y138.416 E.01526
G1 X161.972 Y138.621 E.00892
G1 X162.621 Y138.621 E.01703
G1 X162.621 Y138.034 E.01541
; WIPE_START
G1 X162.243 Y138.416 E-.20424
G1 X161.972 Y138.621 E-.1293
G1 X162.094 Y138.621 E-.04646
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.4 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z5.4
G1 Z5
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01187
G1 X137.379 Y137.972 E.01231
G1 X137.379 Y138.621 E.01702
G1 X137.964 Y138.621 E.01535
; WIPE_START
G1 X137.667 Y138.343 E-.15465
G1 X137.379 Y137.972 E-.1784
G1 X137.379 Y138.096 E-.04695
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.4 I1.216 J.039 P1  F12000
G1 X138.036 Y117.378 Z5.4
G1 Z5
G1 E.4 F1800
; LINE_WIDTH: 0.3727
G1 F6000
M204 S3000
G1 X137.381 Y117.378 E.01707
G1 X137.381 Y118.026 E.01688
G1 X137.665 Y117.657 E.01213
G1 X137.988 Y117.414 E.01054
; WIPE_START
G1 X137.381 Y117.378 E-.23119
G1 X137.381 Y117.769 E-.14882
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.4 I.012 J1.217 P1  F12000
G1 X161.44 Y117.524 Z5.4
G1 Z5
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.258 Y117.457 E.00625
; LINE_WIDTH: 0.44894
G1 X160.801 Y117.397 E.01478
; LINE_WIDTH: 0.43705
G1 X155.199 Y117.397 E.1744
; LINE_WIDTH: 0.43717
G1 X147.199 Y117.397 E.24914
; LINE_WIDTH: 0.43729
G1 X139.199 Y117.397 E.24922
; LINE_WIDTH: 0.44904
G1 X138.741 Y117.458 E.01481
; LINE_WIDTH: 0.44999
G1 X138.399 Y117.587 E.01176
G1 X137.93 Y117.912 E.01835
G1 X137.655 Y118.275 E.01465
; LINE_WIDTH: 0.45046
G1 X137.493 Y118.625 E.01241
G1 X137.399 Y119.168 E.01773
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44658
G1 X137.416 Y137.012 E.00677
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01131
G1 X137.667 Y137.74 E.01361
G1 X137.939 Y138.093 E.01434
G1 X138.417 Y138.423 E.01868
G1 X138.742 Y138.543 E.01114
; LINE_WIDTH: 0.44904
G1 X139.199 Y138.603 E.01478
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.603 E.67299
; LINE_WIDTH: 0.44999
G1 X161.355 Y138.511 E.01808
G1 X161.74 Y138.334 E.0136
G1 X162.02 Y138.121 E.01133
G1 X162.296 Y137.799 E.01362
; LINE_WIDTH: 0.46172
G1 X162.569 Y137.195 E.02196
G1 X162.603 Y136.8 E.01308
; LINE_WIDTH: 0.43719
G1 X162.603 Y131.199 E.17444
; LINE_WIDTH: 0.43706
G1 X162.603 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.603 Y119.199 E.18674
; LINE_WIDTH: 0.44999
M73 P78 R3
G1 X162.511 Y118.644 E.01811
G1 X162.333 Y118.26 E.0136
G1 X162.061 Y117.907 E.01433
G1 X161.583 Y117.577 E.01867
G1 X161.496 Y117.545 E.00297
M204 S10000
G1 X161.333 Y117.93 F12000
G1 F6000
M204 S3000
G1 X161.186 Y117.858 E.00526
G1 X160.801 Y117.798 E.01254
G1 X139.199 Y117.798 E.69462
G1 X139.097 Y117.807 E.0033
G1 X138.612 Y117.934 E.01611
G1 X138.224 Y118.194 E.01503
G1 X137.984 Y118.515 E.01286
G1 X137.889 Y118.72 E.00729
G1 X137.799 Y119.168 E.01468
G1 X137.798 Y136.801 E.56699
G1 X137.811 Y136.925 E.00403
G2 X138.373 Y137.926 I1.425 J-.142 E.03798
G1 X138.814 Y138.142 E.01578
G1 X139.199 Y138.202 E.01254
G1 X160.801 Y138.202 E.69461
G1 X161.268 Y138.113 E.0153
G2 X161.937 Y137.607 I-.644 J-1.546 E.02725
G1 X162.163 Y137.123 E.01718
G1 X162.202 Y136.8 E.01046
G1 X162.202 Y119.199 E.56597
G1 X162.113 Y118.731 E.01533
G2 X161.627 Y118.075 I-1.601 J.677 E.02651
G1 X161.387 Y117.956 E.00862
M204 S250
G1 X161.168 Y118.264 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X160.801 Y118.19 E.01117
G1 X139.199 Y118.19 E.64343
G1 X138.882 Y118.244 E.00957
G1 X138.544 Y118.436 E.01159
G1 X138.302 Y118.745 E.0117
G1 X138.191 Y119.168 E.01302
G1 X138.194 Y136.841 E.52641
G1 X138.27 Y137.184 E.01047
G1 X138.516 Y137.539 E.01286
G1 X138.821 Y137.734 E.01077
G1 X139.199 Y137.81 E.01149
G1 X160.801 Y137.81 E.64342
G1 X161.184 Y137.73 E.01167
G1 X161.538 Y137.484 E.01285
G1 X161.757 Y137.112 E.01286
G1 X161.81 Y136.8 E.00941
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.815 E.01169
G1 X161.484 Y118.462 E.01283
G1 X161.22 Y118.293 E.00933
; WIPE_START
M204 S3000
G1 X160.801 Y118.19 E-.16412
G1 X160.233 Y118.19 E-.21588
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.4 I.479 J1.119 P1  F12000
G1 X162.893 Y117.05 Z5.4
G1 Z5
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.702 Y117.01 E.00629
G3 X161.01 Y117.008 I-.472 J-329.418 E.0544
; LINE_WIDTH: 0.44625
G1 X160.801 Y117.003 E.00666
; LINE_WIDTH: 0.43705
G1 X155.199 Y117.003 E.1744
; LINE_WIDTH: 0.43717
G1 X147.199 Y117.003 E.24914
; LINE_WIDTH: 0.43729
G1 X139.199 Y117.003 E.24922
; LINE_WIDTH: 0.44999
G3 X137.268 Y117.009 I-1.442 J-146.136 E.06209
G1 X137.09 Y117.062 E.00596
G1 X137.013 Y117.234 E.00609
G1 X137.013 Y118.066 E.02675
; LINE_WIDTH: 0.45046
G3 X137.005 Y119.168 I-43.883 J.264 E.03545
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.712 I-90.413 J1.244 E.06148
G1 X137.076 Y138.93 E.00733
G1 X137.304 Y138.991 E.00758
G3 X138.99 Y138.993 I.48 J360.422 E.05422
; LINE_WIDTH: 0.44659
G1 X139.199 Y138.997 E.00667
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.997 E.67299
; LINE_WIDTH: 0.44999
G3 X162.712 Y138.991 I1.259 J91.347 E.06147
G1 X162.93 Y138.924 E.00733
G1 X162.991 Y138.696 E.00758
G1 X162.991 Y137.973 E.02325
; LINE_WIDTH: 0.46172
G3 X162.997 Y136.8 I16.162 J-.5 E.03881
; LINE_WIDTH: 0.43719
G1 X162.997 Y131.199 E.17444
; LINE_WIDTH: 0.43706
G1 X162.997 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.997 Y119.199 E.18674
; LINE_WIDTH: 0.45008
G3 X162.99 Y117.215 I91.345 J-1.297 E.06382
; LINE_WIDTH: 0.44999
G1 X162.924 Y117.102 E.00422
M204 S10000
G1 X163.125 Y116.722 F12000
G1 F6000
M204 S3000
G1 X163.106 Y116.703 E.00085
G1 X162.776 Y116.603 E.01109
G1 X137.24 Y116.602 E.82111
G1 X136.896 Y116.693 E.01145
G1 X136.668 Y116.942 E.01086
G1 X136.606 Y117.283 E.01116
G1 X136.602 Y138.748 E.69022
G1 X136.695 Y139.092 E.01145
G1 X136.848 Y139.276 E.00769
G1 X137.1 Y139.374 E.0087
G2 X138.748 Y139.398 I1.261 J-30.157 E.053
G1 X162.748 Y139.398 E.77173
G1 X163.092 Y139.305 E.01145
G1 X163.276 Y139.152 E.00769
; object ids of layer 25 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer25 end: 47,58
M625
G1 X163.374 Y138.9 E.00871
G2 X163.398 Y137.215 I-32.709 J-1.304 E.05417
G1 X163.397 Y117.215 E.64311
G1 X163.317 Y116.917 E.00994
G1 X163.167 Y116.765 E.00688
M204 S250
G1 X163.418 Y116.434 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.18 Y116.289 E.0083
G1 X162.702 Y116.211 E.01443
G1 X137.213 Y116.21 E.7592
G1 X136.813 Y116.301 E.01223
G1 X136.545 Y116.477 E.00956
G1 X136.378 Y116.668 E.00754
G2 X136.214 Y117.283 I1.11 J.627 E.01918
G1 X136.21 Y138.783 E.64039
G1 X136.274 Y139.144 E.01091
G2 X136.887 Y139.737 I.992 J-.412 E.02613
G1 X137.315 Y139.79 E.01283
G1 X162.783 Y139.79 E.75859
G1 X163.144 Y139.726 E.01091
G2 X163.737 Y139.112 I-.412 J-.992 E.02613
G1 X163.79 Y138.685 E.01283
G1 X163.789 Y117.215 E.6395
G2 X163.662 Y116.719 I-1.594 J.143 E.01532
G1 X163.461 Y116.474 E.00943
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.18 Y116.289 E-.12808
G1 X162.702 Y116.211 E-.18411
G1 X162.523 Y116.211 E-.06781
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z5.4 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z5.4
G1 Z5
M73 P79 R3
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.458 J-1.178 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.56211
; LINE_WIDTH: 0.44999
G3 X95.612 Y119.609 I-1.171 J-105.243 E.04396
G1 X95.604 Y120.978 E.04403
; LINE_WIDTH: 0.43622
G1 X95.604 Y121.021 E.00134
; LINE_WIDTH: 0.43636
G1 X95.604 Y123.021 E.06216
; LINE_WIDTH: 0.4365
G1 X95.604 Y125.021 E.06218
; LINE_WIDTH: 0.43664
G1 X95.604 Y127.021 E.0622
; LINE_WIDTH: 0.43678
G1 X95.604 Y129.021 E.06222
; LINE_WIDTH: 0.43692
G1 X95.603 Y131.021 E.06225
; LINE_WIDTH: 0.43706
G1 X95.603 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.603 Y135.021 E.06229
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-104.465 J1.157 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.715 Y136.742 F12000
G1 F6000
M204 S3000
G1 X116.72 Y136.74 E.00017
G1 X116.798 Y136.537 E.00701
G1 X116.797 Y119.451 E.54941
G1 X116.727 Y119.265 E.00639
G1 X116.524 Y119.202 E.00682
G1 X95.44 Y119.202 E.67797
G1 X95.28 Y119.26 E.00547
G1 X95.204 Y119.414 E.0055
G1 X95.202 Y136.559 E.55133
G1 X95.26 Y136.719 E.00547
G1 X95.463 Y136.798 E.00701
G1 X116.56 Y136.798 E.67837
G1 X116.658 Y136.762 E.00337
M204 S250
G1 X116.85 Y137.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X116.98 Y137.045 I-.401 J-.908 E.0044
G1 X117.132 Y136.845 E.00747
G1 X117.19 Y136.505 E.01029
G1 X117.189 Y119.451 E.50797
G1 X117.152 Y119.202 E.00749
G1 X117.013 Y118.984 E.00769
G1 X116.824 Y118.858 E.00678
G1 X116.524 Y118.81 E.00903
G1 X95.413 Y118.81 E.62881
G2 X95.02 Y118.955 I.144 J.998 E.01259
G1 X94.866 Y119.158 E.00758
G1 X94.812 Y119.455 E.009
G1 X94.81 Y136.586 E.51027
G2 X94.955 Y136.98 I.982 J-.137 E.01259
G1 X95.155 Y137.132 E.00748
G1 X95.495 Y137.19 E.01028
G1 X116.587 Y137.19 E.62823
G2 X116.794 Y137.137 I-.138 J-.983 E.00639
; WIPE_START
M204 S3000
G1 X116.98 Y137.045 E-.07879
G1 X117.132 Y136.845 E-.09534
G1 X117.19 Y136.505 E-.13126
G1 X117.19 Y136.308 E-.07461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.4 I.054 J-1.216 P1  F12000
G1 X96.104 Y135.379 Z5.4
G1 Z5
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01235
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.56211
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.01907
G1 X95.998 Y120.979 E.02426
; LINE_WIDTH: 0.43622
G1 X95.998 Y121.021 E.00133
; LINE_WIDTH: 0.43636
G1 X95.998 Y123.021 E.06216
; LINE_WIDTH: 0.4365
G1 X95.998 Y125.021 E.06218
; LINE_WIDTH: 0.43664
G1 X95.998 Y127.021 E.0622
; LINE_WIDTH: 0.43678
G1 X95.997 Y129.021 E.06222
; LINE_WIDTH: 0.43692
G1 X95.997 Y131.021 E.06225
; LINE_WIDTH: 0.43706
G1 X95.997 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.997 Y135.021 E.06229
; LINE_WIDTH: 0.44614
G1 X96.008 Y135.192 E.00543
; LINE_WIDTH: 0.44999
G1 X96.077 Y135.325 E.00483
M204 S10000
G1 X96.026 Y135.957 F12000
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
M204 S10000
G1 X96.448 Y135.202 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00833
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01122
G1 X96.398 Y120.978 E.01431
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.421 Y135.149 E.00099
M204 S250
G1 X96.791 Y135.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00421
G2 X97.021 Y135.21 I.155 J-.185 E.00564
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.00429
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.964 E.4153
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.07534
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.636 Y135.21 E-.23351
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.4 I1.21 J-.128 P1  F12000
G1 X96.027 Y119.961 Z5.4
G1 Z5
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00244
G1 X96.027 Y120.042 E.00244
G1 X96.051 Y120.002 E.00141
; WIPE_START
G1 X96.027 Y120.042 E-.08513
G1 X95.957 Y120.002 E-.14743
G1 X96.027 Y119.961 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.4 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z5.4
G1 Z5
G1 E.4 F1800
; LINE_WIDTH: 0.4215
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; WIPE_START
G1 X116.021 Y120.043 E-.08512
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.4 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z5.4
G1 Z5
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L26
M991 S0 P25 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z5.4 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z5.4
G1 Z5.2
G1 E.4 F1800
; LINE_WIDTH: 0.37449
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01694
G1 X162.416 Y117.757 E.01522
G1 X162.621 Y118.027 E.00889
G1 X162.621 Y117.439 E.0154
; WIPE_START
G1 X161.974 Y117.379 E-.24676
G1 X162.241 Y117.607 E-.13324
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.6 I-1.217 J.023 P1  F12000
G1 X162.621 Y137.976 Z5.6
G1 Z5.2
G1 E.4 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.343 Y138.333 E.01188
G1 X161.972 Y138.621 E.01232
G1 X162.621 Y138.621 E.01703
G1 X162.621 Y138.036 E.01535
; WIPE_START
G1 X162.343 Y138.333 E-.1547
G1 X161.972 Y138.621 E-.17845
G1 X162.096 Y138.621 E-.04686
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.6 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z5.6
G1 Z5.2
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01188
G1 X137.379 Y137.972 E.01232
G1 X137.379 Y138.621 E.01703
G1 X137.964 Y138.621 E.01536
; WIPE_START
G1 X137.667 Y138.343 E-.15476
G1 X137.379 Y137.972 E-.17846
G1 X137.379 Y138.095 E-.04679
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.6 I1.216 J.038 P1  F12000
G1 X138.03 Y117.378 Z5.6
G1 Z5.2
G1 E.4 F1800
; LINE_WIDTH: 0.37376
G1 F6000
M204 S3000
G1 X137.378 Y117.378 E.01703
G1 X137.378 Y118.029 E.01701
G1 X137.663 Y117.658 E.01222
G1 X137.982 Y117.415 E.01049
; WIPE_START
G1 X137.378 Y117.378 E-.22993
G1 X137.378 Y117.773 E-.15007
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.6 I.013 J1.217 P1  F12000
G1 X161.403 Y117.509 Z5.6
G1 Z5.2
G1 E.4 F1800
; LINE_WIDTH: 0.45803
G1 F6000
M204 S3000
G1 X161.159 Y117.427 E.00844
G2 X160.8 Y117.397 I-.299 J1.428 E.01183
; LINE_WIDTH: 0.43704
G1 X155.199 Y117.397 E.17438
; LINE_WIDTH: 0.43716
G1 X147.199 Y117.397 E.24914
; LINE_WIDTH: 0.43729
G1 X139.199 Y117.397 E.24922
; LINE_WIDTH: 0.44951
G1 X138.693 Y117.473 E.01645
; LINE_WIDTH: 0.44999
G1 X138.353 Y117.609 E.01176
G1 X137.929 Y117.913 E.01678
G1 X137.655 Y118.275 E.01461
; LINE_WIDTH: 0.45079
G1 X137.493 Y118.625 E.01242
G1 X137.398 Y119.168 E.01774
; LINE_WIDTH: 0.43756
G1 X137.398 Y124.801 E.1756
; LINE_WIDTH: 0.43746
G1 X137.397 Y130.801 E.18699
; LINE_WIDTH: 0.43735
G1 X137.397 Y136.801 E.18694
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.666 Y137.74 E.0136
G1 X137.939 Y138.093 E.01434
G1 X138.417 Y138.423 E.01867
G1 X138.743 Y138.543 E.01117
; LINE_WIDTH: 0.44903
G1 X139.2 Y138.603 E.01478
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.603 E.67297
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.01811
G1 X161.74 Y138.333 E.0136
G1 X162.093 Y138.061 E.01433
G1 X162.423 Y137.583 E.01867
G1 X162.543 Y137.257 E.01116
; LINE_WIDTH: 0.44897
G1 X162.603 Y136.8 E.01478
; LINE_WIDTH: 0.43719
G1 X162.603 Y131.199 E.17444
; LINE_WIDTH: 0.43706
G1 X162.603 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.603 Y119.199 E.18674
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.0181
G1 X162.334 Y118.26 E.0136
G1 X162.121 Y117.979 E.01131
G1 X161.799 Y117.704 E.01361
G1 X161.489 Y117.538 E.01133
; LINE_WIDTH: 0.45803
G1 X161.46 Y117.529 E.00099
M204 S10000
G1 X161.302 Y117.925 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.103 Y117.834 E.00703
G1 X160.8 Y117.798 E.00979
G1 X139.199 Y117.798 E.6946
G1 X139.086 Y117.809 E.00367
G1 X138.573 Y117.952 E.01713
G1 X138.223 Y118.195 E.01369
G1 X137.984 Y118.515 E.01284
G1 X137.889 Y118.72 E.00729
G1 X137.799 Y119.168 E.01467
G1 X137.798 Y136.801 E.567
G1 X137.887 Y137.269 E.01532
G2 X138.373 Y137.925 I1.602 J-.677 E.02651
G1 X138.814 Y138.142 E.01582
G1 X139.2 Y138.202 E.01254
G1 X160.801 Y138.202 E.69459
M73 P80 R3
G1 X161.269 Y138.113 E.01532
G2 X161.926 Y137.627 I-.677 J-1.603 E.02652
G1 X162.142 Y137.186 E.01581
G1 X162.202 Y136.8 E.01254
G1 X162.202 Y119.199 E.56597
G1 X162.113 Y118.731 E.01532
G2 X161.607 Y118.063 I-1.544 J.644 E.02723
G1 X161.356 Y117.95 E.00886
M204 S250
G1 X161.147 Y118.264 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.112 Y118.243 E.00123
G1 X160.8 Y118.19 E.00941
G1 X139.199 Y118.19 E.64341
G1 X138.784 Y118.282 E.01267
G1 X138.541 Y118.438 E.0086
G1 X138.301 Y118.745 E.0116
G1 X138.191 Y119.168 E.01301
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01168
G1 X138.516 Y137.538 E.01283
G1 X138.821 Y137.734 E.01079
G1 X139.2 Y137.81 E.01151
G1 X160.801 Y137.81 E.6434
G1 X161.184 Y137.73 E.01168
G1 X161.538 Y137.484 E.01284
G1 X161.734 Y137.179 E.01078
G1 X161.81 Y136.8 E.01151
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.816 E.01168
G1 X161.484 Y118.462 E.01284
G1 X161.199 Y118.294 E.00984
; WIPE_START
M204 S3000
G1 X161.112 Y118.243 E-.03844
G1 X160.8 Y118.19 E-.12002
G1 X160.217 Y118.19 E-.22154
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.6 I.472 J1.122 P1  F12000
G1 X162.908 Y117.059 Z5.6
G1 Z5.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.703 Y117.01 E.00676
G3 X160.963 Y117.006 I-.535 J-154.086 E.05596
; LINE_WIDTH: 0.44256
G1 X160.8 Y117.003 E.00513
; LINE_WIDTH: 0.43704
G1 X155.199 Y117.003 E.17438
; LINE_WIDTH: 0.43716
G1 X147.199 Y117.003 E.24914
; LINE_WIDTH: 0.43729
G1 X139.199 Y117.003 E.24922
; LINE_WIDTH: 0.44951
G1 X138.647 Y117.009 E.01774
; LINE_WIDTH: 0.44999
G1 X137.26 Y117.009 E.04459
G1 X137.09 Y117.067 E.00578
G1 X137.023 Y117.189 E.00448
G1 X137.009 Y117.745 E.01788
; LINE_WIDTH: 0.45079
G3 X137.003 Y119.168 I-62.293 J.44 E.04584
; LINE_WIDTH: 0.43756
G1 X137.003 Y124.801 E.1756
; LINE_WIDTH: 0.43746
G1 X137.003 Y130.801 E.18699
; LINE_WIDTH: 0.43735
G1 X137.003 Y136.801 E.18694
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.732 I-92.37 J1.269 E.0621
G1 X137.067 Y138.915 E.00619
G1 X137.256 Y138.987 E.0065
G2 X138.703 Y138.991 I1.189 J-165.412 E.04654
; LINE_WIDTH: 0.44903
G1 X139.2 Y138.997 E.01593
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.997 E.67297
; LINE_WIDTH: 0.44999
G3 X162.732 Y138.991 I1.27 J92.603 E.0621
G1 X162.915 Y138.933 E.00619
G1 X162.987 Y138.744 E.0065
G2 X162.991 Y137.297 I-168.191 J-1.193 E.04654
; LINE_WIDTH: 0.44897
G1 X162.997 Y136.8 E.01593
; LINE_WIDTH: 0.43719
G1 X162.997 Y131.199 E.17444
; LINE_WIDTH: 0.43706
G1 X162.997 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.997 Y119.199 E.18674
; LINE_WIDTH: 0.45008
G3 X162.99 Y117.219 I91.107 J-1.295 E.0637
; LINE_WIDTH: 0.44999
G1 X162.935 Y117.112 E.00385
M204 S10000
G1 X163.123 Y116.721 F12000
G1 F6000
M204 S3000
G1 X163.106 Y116.703 E.0008
G1 X162.777 Y116.603 E.01105
G1 X137.235 Y116.602 E.82131
G1 X136.897 Y116.694 E.01127
G1 X136.738 Y116.835 E.00686
G1 X136.621 Y117.126 E.01005
G2 X136.602 Y118.76 I26.504 J1.127 E.05256
G1 X136.602 Y138.76 E.64311
G1 X136.673 Y139.049 E.00958
G1 X136.83 Y139.26 E.00845
G1 X137.125 Y139.379 E.01021
G2 X138.76 Y139.398 I1.241 J-36.008 E.05258
G1 X162.76 Y139.398 E.77173
G1 X163.049 Y139.328 E.00958
G1 X163.26 Y139.17 E.00845
; object ids of layer 26 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer26 end: 47,58
M625
G1 X163.379 Y138.875 E.01021
G2 X163.398 Y137.219 I-36.526 J-1.251 E.05327
G1 X163.397 Y117.219 E.64311
G1 X163.318 Y116.917 E.01003
G1 X163.165 Y116.763 E.00696
M204 S250
G1 X163.416 Y116.434 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.18 Y116.289 E.00826
G1 X162.703 Y116.211 E.01439
G1 X137.212 Y116.21 E.75928
G2 X136.686 Y116.357 I.15 J1.551 E.01635
G1 X136.425 Y116.589 E.01039
G1 X136.26 Y116.897 E.0104
G1 X136.21 Y117.301 E.01214
G1 X136.21 Y138.787 E.63996
G1 X136.249 Y139.066 E.00841
G1 X136.379 Y139.349 E.00926
G1 X136.587 Y139.574 E.00915
G1 X136.897 Y139.74 E.01045
G1 X137.301 Y139.79 E.01215
G1 X162.787 Y139.79 E.75911
G1 X163.067 Y139.751 E.00841
G1 X163.349 Y139.621 E.00925
G1 X163.574 Y139.413 E.00915
G1 X163.74 Y139.103 E.01045
G1 X163.79 Y138.699 E.01214
G1 X163.789 Y117.219 E.63979
G2 X163.662 Y116.719 I-1.562 J.13 E.01543
G1 X163.46 Y116.473 E.00948
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.18 Y116.289 E-.12752
G1 X162.703 Y116.211 E-.1836
G1 X162.522 Y116.211 E-.06888
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z5.6 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z5.6
G1 Z5.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.46 J-1.178 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.56211
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.605 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.714 Y136.742 F12000
G1 F6000
M204 S3000
G1 X116.72 Y136.74 E.00018
G1 X116.798 Y136.537 E.007
G1 X116.797 Y119.467 E.54889
G1 X116.735 Y119.27 E.00663
G1 X116.524 Y119.202 E.00713
G1 X95.441 Y119.202 E.67794
G1 X95.28 Y119.26 E.00548
G1 X95.202 Y119.463 E.00701
G1 X95.202 Y136.548 E.54937
G1 X95.25 Y136.712 E.0055
G1 X95.463 Y136.798 E.00738
G1 X116.56 Y136.798 E.67836
G1 X116.658 Y136.762 E.00336
M204 S250
G1 X116.85 Y137.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X116.98 Y137.045 I-.402 J-.908 E.00441
G1 X117.132 Y136.845 E.00747
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.467 E.5075
G1 X117.136 Y119.161 E.00923
G2 X116.824 Y118.858 I-.535 J.238 E.01328
G1 X116.524 Y118.81 E.00905
G1 X95.414 Y118.81 E.62878
G2 X95.02 Y118.955 I.137 J.982 E.0126
G1 X94.868 Y119.155 E.00747
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.583 E.50898
G1 X94.898 Y136.886 E.00939
G2 X95.155 Y137.132 I.806 J-.585 E.01066
G1 X95.495 Y137.19 E.01028
G1 X116.587 Y137.19 E.62823
G2 X116.794 Y137.137 I-.138 J-.983 E.00639
; WIPE_START
M204 S3000
G1 X116.98 Y137.045 E-.07892
G1 X117.132 Y136.845 E-.09527
G1 X117.19 Y136.505 E-.13118
G1 X117.19 Y136.308 E-.07463
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.6 I.052 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z5.6
G1 Z5.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.56211
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00745
M73 P81 R3
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.793 Y134.994 E.41618
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.6 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z5.6
G1 Z5.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.6 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z5.6
G1 Z5.2
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.6 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z5.6
G1 Z5.2
G1 E.4 F1800
; LINE_WIDTH: 0.42152
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; WIPE_START
G1 X116.021 Y120.043 E-.08512
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.6 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z5.6
G1 Z5.2
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L27
M991 S0 P26 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z5.6 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z5.6
G1 Z5.4
G1 E.4 F1800
; LINE_WIDTH: 0.37448
G1 F6000
M204 S3000
G1 X161.976 Y117.379 E.01688
G1 X162.333 Y117.657 E.01184
G1 X162.621 Y118.027 E.01228
G1 X162.621 Y117.439 E.0154
; WIPE_START
G1 X161.976 Y117.379 E-.24591
G1 X162.255 Y117.596 E-.13409
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.8 I-1.217 J.022 P1  F12000
G1 X162.621 Y137.976 Z5.8
G1 Z5.4
G1 E.4 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.343 Y138.333 E.01187
G1 X161.972 Y138.621 E.01232
G1 X162.621 Y138.621 E.01703
G1 X162.621 Y138.036 E.01535
; WIPE_START
G1 X162.343 Y138.333 E-.15467
G1 X161.972 Y138.621 E-.17846
G1 X162.096 Y138.621 E-.04687
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.8 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z5.8
G1 Z5.4
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01187
G1 X137.379 Y137.972 E.01232
G1 X137.379 Y138.621 E.01703
G1 X137.964 Y138.621 E.01535
; WIPE_START
G1 X137.667 Y138.343 E-.15467
G1 X137.379 Y137.972 E-.17848
G1 X137.379 Y138.095 E-.04685
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.8 I1.216 J.039 P1  F12000
G1 X138.035 Y117.379 Z5.8
G1 Z5.4
G1 E.4 F1800
; LINE_WIDTH: 0.37523
G1 F6000
M204 S3000
G1 X137.379 Y117.379 E.01722
G1 X137.383 Y118.007 E.01649
G1 X137.727 Y117.608 E.01384
G1 X137.987 Y117.415 E.00849
; WIPE_START
G1 X137.379 Y117.379 E-.23139
G1 X137.382 Y117.77 E-.14861
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.8 I.012 J1.217 P1  F12000
G1 X161.442 Y117.525 Z5.8
G1 Z5.4
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.258 Y117.458 E.0063
; LINE_WIDTH: 0.44894
G1 X160.801 Y117.397 E.01479
; LINE_WIDTH: 0.43706
G1 X159.135 Y117.398 E.05186
; LINE_WIDTH: 0.43721
G1 X157.135 Y117.398 E.06229
; LINE_WIDTH: 0.43736
G1 X155.135 Y117.398 E.06232
; LINE_WIDTH: 0.4375
G1 X153.135 Y117.398 E.06234
; LINE_WIDTH: 0.43765
G1 X151.135 Y117.398 E.06236
; LINE_WIDTH: 0.4378
G1 X149.135 Y117.398 E.06239
; LINE_WIDTH: 0.43795
G1 X147.135 Y117.398 E.06241
; LINE_WIDTH: 0.4381
G1 X145.135 Y117.399 E.06243
; LINE_WIDTH: 0.43825
G1 X143.135 Y117.399 E.06246
; LINE_WIDTH: 0.4384
G1 X141.135 Y117.399 E.06248
; LINE_WIDTH: 0.43855
G1 X139.135 Y117.399 E.0625
; LINE_WIDTH: 0.44748
G1 X138.965 Y117.409 E.00545
; LINE_WIDTH: 0.44999
G2 X137.958 Y117.897 I.378 J2.066 E.03642
G1 X137.71 Y118.189 E.01231
G2 X137.447 Y118.773 I1.593 J1.068 E.02068
; LINE_WIDTH: 0.44863
G1 X137.398 Y119.167 E.01275
; LINE_WIDTH: 0.43756
G1 X137.398 Y124.801 E.17561
; LINE_WIDTH: 0.43746
G1 X137.397 Y130.801 E.18699
; LINE_WIDTH: 0.43735
G1 X137.397 Y136.801 E.18694
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.667 Y137.74 E.01361
G1 X137.939 Y138.093 E.01434
G1 X138.417 Y138.423 E.01867
G1 X138.742 Y138.543 E.01114
; LINE_WIDTH: 0.44904
G1 X139.199 Y138.603 E.01479
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.603 E.67299
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.01811
G1 X161.74 Y138.333 E.0136
G1 X162.093 Y138.061 E.01434
G1 X162.423 Y137.583 E.01868
G1 X162.543 Y137.258 E.01114
; LINE_WIDTH: 0.44897
G1 X162.603 Y136.801 E.01478
; LINE_WIDTH: 0.43719
G1 X162.603 Y131.199 E.17445
; LINE_WIDTH: 0.43706
G1 X162.603 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.603 Y119.199 E.18674
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.0181
G1 X162.334 Y118.26 E.0136
G1 X162.061 Y117.907 E.01434
G1 X161.583 Y117.577 E.01867
G1 X161.498 Y117.546 E.00292
M204 S10000
G1 X161.335 Y117.931 F12000
G1 F6000
M204 S3000
G1 X161.186 Y117.858 E.00531
G1 X160.801 Y117.798 E.01254
G1 X139.135 Y117.8 E.69667
G1 X138.664 Y117.912 E.01556
G2 X138.066 Y118.387 I.717 J1.517 E.02481
G1 X137.847 Y118.844 E.01629
G1 X137.799 Y119.167 E.01051
G1 X137.798 Y136.801 E.567
G1 X137.887 Y137.269 E.01532
G2 X138.373 Y137.926 I1.604 J-.678 E.02654
G1 X138.814 Y138.142 E.01578
G1 X139.199 Y138.202 E.01255
G1 X160.801 Y138.202 E.69461
G1 X161.269 Y138.113 E.01532
G2 X161.926 Y137.627 I-.677 J-1.603 E.02653
G1 X162.142 Y137.186 E.01579
G1 X162.202 Y136.801 E.01254
G1 X162.202 Y119.199 E.56599
G1 X162.113 Y118.732 E.01531
G2 X161.627 Y118.075 I-1.603 J.677 E.02653
G1 X161.388 Y117.957 E.00856
M204 S250
G1 X161.17 Y118.265 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X160.801 Y118.19 E.01121
G1 X139.135 Y118.193 E.64533
G1 X138.772 Y118.289 E.0112
G1 X138.408 Y118.578 E.01384
G1 X138.254 Y118.855 E.00943
G1 X138.191 Y119.167 E.00951
G1 X138.19 Y136.801 E.52522
G1 X138.27 Y137.184 E.01168
G1 X138.516 Y137.539 E.01285
G1 X138.821 Y137.733 E.01076
G1 X139.199 Y137.81 E.0115
G1 X160.801 Y137.81 E.64341
G1 X161.184 Y137.73 E.01168
G1 X161.538 Y137.484 E.01284
G1 X161.734 Y137.179 E.01077
G1 X161.81 Y136.801 E.0115
G1 X161.81 Y119.199 E.52427
G1 X161.73 Y118.816 E.01167
G1 X161.484 Y118.462 E.01284
G1 X161.222 Y118.294 E.00928
; WIPE_START
M204 S3000
G1 X160.801 Y118.19 E-.16469
G1 X160.234 Y118.19 E-.21531
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.8 I.48 J1.118 P1  F12000
G1 X162.893 Y117.05 Z5.8
G1 Z5.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.704 Y117.01 E.00619
G3 X161.01 Y117.008 I-.473 J-326.425 E.05448
; LINE_WIDTH: 0.44622
G1 X160.801 Y117.003 E.00667
; LINE_WIDTH: 0.43706
G1 X159.135 Y117.003 E.05186
; LINE_WIDTH: 0.43721
G1 X157.135 Y117.003 E.06229
; LINE_WIDTH: 0.43736
G1 X155.135 Y117.003 E.06232
; LINE_WIDTH: 0.4375
G1 X153.135 Y117.003 E.06234
; LINE_WIDTH: 0.43765
G1 X151.135 Y117.003 E.06236
; LINE_WIDTH: 0.4378
G1 X149.135 Y117.003 E.06239
; LINE_WIDTH: 0.43795
G1 X147.135 Y117.003 E.06241
; LINE_WIDTH: 0.4381
G1 X145.135 Y117.003 E.06243
; LINE_WIDTH: 0.43825
G1 X143.135 Y117.003 E.06246
; LINE_WIDTH: 0.4384
G1 X141.135 Y117.003 E.06248
; LINE_WIDTH: 0.43855
G1 X139.135 Y117.003 E.0625
; LINE_WIDTH: 0.44999
G3 X137.268 Y117.009 I-1.258 J-106.944 E.06003
G1 X137.083 Y117.067 E.00623
G1 X137.013 Y117.256 E.00647
G2 X137.008 Y118.734 I191.035 J1.294 E.04753
; LINE_WIDTH: 0.44863
G1 X137.003 Y119.167 E.0139
; LINE_WIDTH: 0.43756
G1 X137.003 Y124.801 E.17561
; LINE_WIDTH: 0.43746
G1 X137.003 Y130.801 E.18699
; LINE_WIDTH: 0.43735
G1 X137.003 Y136.801 E.18694
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.733 I-92.347 J1.269 E.06213
G1 X137.078 Y138.93 E.00672
G1 X137.301 Y138.991 E.00745
G3 X138.99 Y138.993 I.481 J361.121 E.0543
; LINE_WIDTH: 0.4466
G1 X139.199 Y138.997 E.00667
; LINE_WIDTH: 0.43732
G1 X160.801 Y138.997 E.67299
; LINE_WIDTH: 0.44999
G3 X162.732 Y138.991 I1.269 J92.396 E.0621
G1 X162.915 Y138.933 E.00619
G1 X162.987 Y138.744 E.0065
G2 X162.991 Y137.298 I-168.863 J-1.194 E.04652
; LINE_WIDTH: 0.44897
G1 X162.997 Y136.801 E.01594
; LINE_WIDTH: 0.43719
G1 X162.997 Y131.199 E.17445
; LINE_WIDTH: 0.43706
G1 X162.997 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.997 Y119.199 E.18674
; LINE_WIDTH: 0.45007
G3 X162.99 Y117.221 I90.975 J-1.294 E.06362
; LINE_WIDTH: 0.44999
G1 X162.922 Y117.102 E.0044
M204 S10000
G1 X163.123 Y116.721 F12000
G1 F6000
M204 S3000
G1 X163.106 Y116.703 E.00079
G1 X162.779 Y116.603 E.01099
G1 X137.24 Y116.602 E.8212
G1 X136.945 Y116.676 E.00977
G1 X136.741 Y116.83 E.00824
G1 X136.621 Y117.125 E.01023
G2 X136.602 Y118.76 I37.457 J1.259 E.0526
G1 X136.602 Y138.76 E.64311
G1 X136.676 Y139.046 E.00947
G1 X136.825 Y139.257 E.00832
G1 X137.123 Y139.378 E.01036
G2 X138.76 Y139.398 I1.243 J-35.748 E.05262
G1 X162.76 Y139.398 E.77173
G1 X163.049 Y139.328 E.00958
G1 X163.26 Y139.17 E.00846
; object ids of layer 27 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer27 end: 47,58
M625
G1 X163.379 Y138.875 E.01022
G2 X163.398 Y137.195 I-37.164 J-1.263 E.05404
G1 X163.397 Y117.195 E.64311
G1 X163.314 Y116.912 E.00948
G1 X163.165 Y116.763 E.00676
M204 S250
G1 X163.415 Y116.433 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.18 Y116.289 E.00823
G1 X162.704 Y116.211 E.01435
G1 X137.213 Y116.21 E.75928
G1 X136.934 Y116.249 E.00841
M73 P82 R3
G1 X136.647 Y116.382 E.0094
G1 X136.426 Y116.587 E.00899
G1 X136.26 Y116.897 E.01046
G1 X136.21 Y117.301 E.01215
G1 X136.21 Y138.787 E.63997
G1 X136.247 Y139.06 E.0082
G1 X136.403 Y139.384 E.01071
G1 X136.585 Y139.573 E.00783
G1 X136.897 Y139.74 E.01051
G1 X137.301 Y139.79 E.01214
G1 X162.787 Y139.79 E.75911
G2 X163.349 Y139.621 I.003 J-1.011 E.01773
G1 X163.574 Y139.413 E.00915
G1 X163.74 Y139.103 E.01046
G1 X163.79 Y138.699 E.01213
G1 X163.789 Y117.195 E.64052
G2 X163.661 Y116.717 I-2.219 J.34 E.01475
G1 X163.46 Y116.472 E.00945
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.18 Y116.289 E-.12718
G1 X162.704 Y116.211 E-.18305
G1 X162.521 Y116.211 E-.06977
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z5.8 I-.488 J-1.115 P1  F12000
G1 X116.388 Y136.391 Z5.8
G1 Z5.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.391 Y135.227 E.03744
; LINE_WIDTH: 0.4451
G1 X116.396 Y135.021 E.00652
; LINE_WIDTH: 0.43619
G1 X116.396 Y134.979 E.00133
; LINE_WIDTH: 0.43629
G1 X116.396 Y132.979 E.06215
; LINE_WIDTH: 0.4364
G1 X116.396 Y130.979 E.06216
; LINE_WIDTH: 0.4366
G1 X116.396 Y126.979 E.12439
; LINE_WIDTH: 0.43671
G1 X116.396 Y124.979 E.06221
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.397 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I102.604 J-1.165 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.56211
; LINE_WIDTH: 0.44999
G3 X95.614 Y119.609 I-1.169 J-104.779 E.04389
G1 X95.606 Y120.978 E.04402
; LINE_WIDTH: 0.43532
G1 X95.606 Y121.021 E.00134
; LINE_WIDTH: 0.43558
G1 X95.605 Y123.021 E.06203
; LINE_WIDTH: 0.43583
G1 X95.605 Y125.021 E.06207
; LINE_WIDTH: 0.43609
G1 X95.605 Y127.021 E.06212
; LINE_WIDTH: 0.43635
G1 X95.604 Y129.021 E.06216
; LINE_WIDTH: 0.4366
G1 X95.604 Y131.021 E.0622
; LINE_WIDTH: 0.43686
G1 X95.603 Y133.021 E.06224
; LINE_WIDTH: 0.43712
G1 X95.603 Y135.021 E.06228
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-103.829 J1.146 E.04404
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.328 Y136.391 I1.174 J105.488 E.04203
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F6000
M204 S3000
G1 X116.796 Y136.586 E.00588
G1 X116.797 Y119.466 E.5505
G1 X116.735 Y119.27 E.00662
G1 X116.523 Y119.202 E.00715
G1 X95.44 Y119.202 E.67793
G1 X95.25 Y119.285 E.00667
G1 X95.206 Y119.456 E.00568
G1 X95.202 Y136.56 E.54997
G1 X95.26 Y136.72 E.00546
G1 X95.463 Y136.798 E.00701
G1 X116.548 Y136.798 E.67799
G1 X116.655 Y136.766 E.00359
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X117.167 Y136.715 I-.35 J-.55 E.01461
G2 X117.188 Y135.466 I-21.961 J-.984 E.03719
G1 X117.189 Y119.466 E.47657
G1 X117.136 Y119.161 E.00924
G2 X116.824 Y118.858 I-.535 J.239 E.01327
G1 X116.523 Y118.81 E.00907
G1 X95.413 Y118.81 E.62878
G1 X95.15 Y118.885 E.00817
G1 X94.959 Y119.022 E.00698
G1 X94.814 Y119.35 E.01067
G1 X94.81 Y136.587 E.51342
G2 X94.955 Y136.98 I.982 J-.138 E.01258
G1 X95.155 Y137.132 E.00748
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00762
; WIPE_START
M204 S3000
G1 X117.06 Y136.939 E-.11158
G1 X117.167 Y136.715 E-.09448
G1 X117.175 Y136.257 E-.17394
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.8 I.049 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z5.8
G1 Z5.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01147
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01907
G1 X115.992 Y135.192 E.01914
; LINE_WIDTH: 0.4451
G1 X116.002 Y135.021 E.00542
; LINE_WIDTH: 0.43619
G1 X116.002 Y134.979 E.00133
; LINE_WIDTH: 0.43629
G1 X116.002 Y132.979 E.06215
; LINE_WIDTH: 0.4364
G1 X116.002 Y130.979 E.06216
; LINE_WIDTH: 0.4366
G1 X116.002 Y126.979 E.12439
; LINE_WIDTH: 0.43671
G1 X116.002 Y124.979 E.06221
; LINE_WIDTH: 0.43681
G1 X116.003 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02424
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.56211
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.282 Y120.279 E.01904
G1 X95.998 Y120.979 E.02428
; LINE_WIDTH: 0.43532
G1 X95.998 Y121.021 E.00133
; LINE_WIDTH: 0.43558
G1 X95.998 Y123.021 E.06203
; LINE_WIDTH: 0.43583
G1 X95.998 Y125.021 E.06207
; LINE_WIDTH: 0.43609
G1 X95.998 Y127.021 E.06212
; LINE_WIDTH: 0.43635
G1 X95.998 Y129.021 E.06216
; LINE_WIDTH: 0.4366
G1 X95.998 Y131.021 E.0622
; LINE_WIDTH: 0.43686
G1 X95.997 Y133.021 E.06224
; LINE_WIDTH: 0.43712
G1 X95.997 Y135.021 E.06228
; LINE_WIDTH: 0.44605
G1 X96.008 Y135.192 E.00543
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.349 E.00572
M204 S10000
G1 X96.461 Y135.226 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.433 E.01122
G1 X115.593 Y135.122 E.01126
G2 X115.602 Y134.979 I-.818 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01428
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.569 Y120.567 E.01121
G1 X96.398 Y120.978 E.01432
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00564
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.00429
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.846 Y120.845 E.00429
G2 X96.79 Y121.021 I.185 J.155 E.00566
G1 X96.793 Y134.994 E.41618
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.06427
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24459
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.8 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z5.8
G1 Z5.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42188
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08513
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.8 I1.217 J0 P1  F12000
G1 X96.029 Y119.96 Z5.8
G1 Z5.4
G1 E.4 F1800
; LINE_WIDTH: 0.41948
G1 F6000
M204 S3000
G1 X95.958 Y120.001 E.00242
G1 X96.029 Y120.042 E.00242
G1 X96.052 Y120.001 E.0014
; WIPE_START
G1 X96.029 Y120.042 E-.08513
G1 X95.958 Y120.001 E-.14744
G1 X96.029 Y119.96 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.8 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z5.8
G1 Z5.4
G1 E.4 F1800
; LINE_WIDTH: 0.42146
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00141
; WIPE_START
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z5.8 I-1.217 J0 P1  F12000
G1 X116.02 Y135.958 Z5.8
G1 Z5.4
G1 E.4 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y135.998 E.00244
G1 X116.02 Y136.039 E.00244
G1 X116.043 Y135.998 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.02 Y136.039 E-.08513
G1 X115.949 Y135.998 E-.14743
G1 X116.02 Y135.958 E-.14743
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L28
M991 S0 P27 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z5.8 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z5.8
G1 Z5.6
G1 E.4 F1800
; LINE_WIDTH: 0.37446
G1 F6000
M204 S3000
G1 X161.974 Y117.379 E.01694
G1 X162.416 Y117.757 E.01522
G1 X162.621 Y118.027 E.00889
G1 X162.621 Y117.439 E.0154
; WIPE_START
G1 X161.974 Y117.379 E-.24678
G1 X162.241 Y117.607 E-.13322
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6 I-1.217 J.023 P1  F12000
G1 X162.621 Y137.976 Z6
G1 Z5.6
G1 E.4 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X162.343 Y138.333 E.01188
G1 X161.972 Y138.621 E.01232
G1 X162.621 Y138.621 E.01703
G1 X162.621 Y138.036 E.01535
; WIPE_START
G1 X162.343 Y138.333 E-.15471
G1 X161.972 Y138.621 E-.17846
G1 X162.095 Y138.621 E-.04684
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6 I0 J-1.217 P1  F12000
G1 X138.024 Y138.621 Z6
G1 Z5.6
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X137.667 Y138.343 E.01188
G1 X137.379 Y137.972 E.01232
G1 X137.379 Y138.621 E.01703
G1 X137.964 Y138.621 E.01536
; WIPE_START
G1 X137.667 Y138.343 E-.15476
G1 X137.379 Y137.972 E-.17848
G1 X137.379 Y138.095 E-.04676
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6 I1.216 J.038 P1  F12000
G1 X138.027 Y117.379 Z6
G1 Z5.6
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X137.379 Y117.379 E.017
G1 X137.379 Y118.026 E.01697
M73 P83 R3
G1 X137.755 Y117.585 E.01519
G1 X137.979 Y117.415 E.00739
; WIPE_START
G1 X137.379 Y117.379 E-.22856
G1 X137.379 Y117.777 E-.15144
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6 I.014 J1.217 P1  F12000
G1 X161.405 Y117.51 Z6
G1 Z5.6
G1 E.4 F1800
; LINE_WIDTH: 0.45792
G1 F6000
M204 S3000
G1 X161.158 Y117.427 E.00854
G2 X160.8 Y117.397 I-.298 J1.428 E.01181
; LINE_WIDTH: 0.43706
G1 X159.132 Y117.398 E.05193
; LINE_WIDTH: 0.43722
G1 X157.132 Y117.398 E.06229
; LINE_WIDTH: 0.43739
G1 X155.132 Y117.398 E.06232
; LINE_WIDTH: 0.43755
G1 X153.132 Y117.398 E.06235
; LINE_WIDTH: 0.43771
G1 X151.132 Y117.398 E.06237
; LINE_WIDTH: 0.43787
G1 X149.132 Y117.398 E.0624
; LINE_WIDTH: 0.43804
G1 X147.132 Y117.399 E.06242
; LINE_WIDTH: 0.4382
G1 X145.132 Y117.399 E.06245
; LINE_WIDTH: 0.43836
G1 X143.132 Y117.399 E.06247
; LINE_WIDTH: 0.43852
G1 X141.132 Y117.399 E.0625
; LINE_WIDTH: 0.43869
G1 X139.132 Y117.399 E.06253
; LINE_WIDTH: 0.44999
G1 X138.601 Y117.5 E.01741
G1 X138.256 Y117.669 E.01232
G1 X137.907 Y117.939 E.0142
G2 X137.447 Y118.773 I1.65 J1.454 E.03086
; LINE_WIDTH: 0.44864
G1 X137.398 Y119.168 E.01276
; LINE_WIDTH: 0.43756
G1 X137.398 Y124.801 E.1756
; LINE_WIDTH: 0.43746
G1 X137.397 Y130.801 E.18699
; LINE_WIDTH: 0.43735
G1 X137.397 Y136.801 E.18694
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.01809
G1 X137.666 Y137.74 E.0136
G1 X137.939 Y138.093 E.01435
G1 X138.417 Y138.423 E.01867
G1 X138.743 Y138.543 E.01116
; LINE_WIDTH: 0.44903
G1 X139.2 Y138.603 E.01479
; LINE_WIDTH: 0.43741
G1 X140.868 Y138.603 E.05198
; LINE_WIDTH: 0.43754
G1 X142.868 Y138.602 E.06234
; LINE_WIDTH: 0.43767
G1 X144.868 Y138.602 E.06236
; LINE_WIDTH: 0.4378
G1 X146.868 Y138.602 E.06239
; LINE_WIDTH: 0.43793
G1 X148.868 Y138.602 E.06241
; LINE_WIDTH: 0.43806
G1 X150.868 Y138.602 E.06243
; LINE_WIDTH: 0.43819
G1 X152.868 Y138.601 E.06245
; LINE_WIDTH: 0.43832
G1 X154.868 Y138.601 E.06247
; LINE_WIDTH: 0.43845
G1 X156.868 Y138.601 E.06249
; LINE_WIDTH: 0.43858
G1 X158.868 Y138.601 E.06251
; LINE_WIDTH: 0.43872
G1 X160.868 Y138.601 E.06253
; LINE_WIDTH: 0.44999
G1 X161.395 Y138.501 E.01726
G1 X161.74 Y138.334 E.01233
G1 X162.093 Y138.061 E.01434
G1 X162.423 Y137.584 E.01866
G1 X162.543 Y137.258 E.01116
; LINE_WIDTH: 0.44897
G1 X162.603 Y136.801 E.01479
; LINE_WIDTH: 0.43719
G1 X162.603 Y131.199 E.17445
; LINE_WIDTH: 0.43706
G1 X162.603 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.603 Y119.199 E.18674
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.01809
G1 X162.334 Y118.26 E.0136
G1 X162.121 Y117.98 E.01132
G1 X161.799 Y117.704 E.01362
G1 X161.488 Y117.538 E.01134
; LINE_WIDTH: 0.45792
G1 X161.462 Y117.529 E.0009
M204 S10000
G1 X161.304 Y117.926 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.102 Y117.834 E.00714
G1 X160.8 Y117.798 E.00977
G1 X139.132 Y117.801 E.69675
G1 X138.984 Y117.82 E.00482
G1 X138.502 Y117.993 E.01645
G1 X138.183 Y118.239 E.01297
G1 X138.069 Y118.382 E.00589
G1 X137.847 Y118.844 E.01647
G1 X137.799 Y119.168 E.01052
G1 X137.798 Y136.801 E.567
G1 X137.887 Y137.268 E.01531
G2 X138.373 Y137.925 I1.602 J-.677 E.02652
G1 X138.814 Y138.142 E.01582
G1 X139.2 Y138.202 E.01254
G1 X160.868 Y138.199 E.69675
G1 X161.015 Y138.18 E.00478
G1 X161.494 Y138.009 E.01637
G2 X161.925 Y137.627 I-.743 J-1.274 E.01863
G1 X162.142 Y137.186 E.01581
G1 X162.202 Y136.801 E.01255
G1 X162.202 Y119.199 E.56598
G1 X162.113 Y118.732 E.01531
G2 X161.607 Y118.063 I-1.545 J.644 E.02724
G1 X161.359 Y117.951 E.00877
M204 S250
G1 X161.15 Y118.266 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.111 Y118.243 E.00133
G1 X160.8 Y118.19 E.0094
G1 X139.133 Y118.193 E.6454
G1 X138.805 Y118.273 E.01004
G1 X138.448 Y118.527 E.01306
G1 X138.254 Y118.854 E.01131
G1 X138.191 Y119.168 E.00953
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01167
G1 X138.516 Y137.538 E.01284
G1 X138.821 Y137.734 E.01079
G1 X139.2 Y137.81 E.01151
G1 X160.867 Y137.807 E.6454
G1 X161.192 Y137.728 E.00994
G1 X161.538 Y137.484 E.01262
G1 X161.733 Y137.179 E.01078
G1 X161.81 Y136.801 E.01151
G1 X161.81 Y119.199 E.52427
G1 X161.73 Y118.816 E.01167
G1 X161.484 Y118.462 E.01284
G1 X161.202 Y118.296 E.00976
; WIPE_START
M204 S3000
G1 X161.111 Y118.243 E-.03971
G1 X160.8 Y118.19 E-.11987
G1 X160.22 Y118.19 E-.22042
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6 I.472 J1.122 P1  F12000
G1 X162.907 Y117.059 Z6
G1 Z5.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.706 Y117.01 E.00665
G3 X160.963 Y117.006 I-.537 J-152.663 E.05605
; LINE_WIDTH: 0.4425
G1 X160.8 Y117.003 E.00512
; LINE_WIDTH: 0.43706
G1 X159.132 Y117.003 E.05193
; LINE_WIDTH: 0.43722
G1 X157.132 Y117.003 E.06229
; LINE_WIDTH: 0.43739
G1 X155.132 Y117.003 E.06232
; LINE_WIDTH: 0.43755
G1 X153.132 Y117.003 E.06235
; LINE_WIDTH: 0.43771
G1 X151.132 Y117.003 E.06237
; LINE_WIDTH: 0.43787
G1 X149.132 Y117.003 E.0624
; LINE_WIDTH: 0.43804
G1 X147.132 Y117.004 E.06242
; LINE_WIDTH: 0.4382
G1 X145.132 Y117.004 E.06245
; LINE_WIDTH: 0.43836
G1 X143.132 Y117.004 E.06247
; LINE_WIDTH: 0.43852
G1 X141.132 Y117.004 E.0625
; LINE_WIDTH: 0.43869
G1 X139.132 Y117.004 E.06253
; LINE_WIDTH: 0.44999
G3 X137.268 Y117.009 I-1.228 J-98.802 E.05994
G1 X137.07 Y117.078 E.00677
G1 X137.009 Y117.301 E.00743
G3 X137.008 Y118.959 I-341.361 J.51 E.0533
; LINE_WIDTH: 0.44689
G1 X137.003 Y119.168 E.00667
; LINE_WIDTH: 0.43756
G1 X137.003 Y124.801 E.1756
; LINE_WIDTH: 0.43746
G1 X137.003 Y130.801 E.18699
; LINE_WIDTH: 0.43735
G1 X137.003 Y136.801 E.18694
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.742 I-93.08 J1.275 E.06241
G1 X137.074 Y138.924 E.00623
G1 X137.288 Y138.991 E.0072
G3 X138.991 Y138.993 I.487 J360.458 E.05475
; LINE_WIDTH: 0.44655
G1 X139.2 Y138.997 E.00666
; LINE_WIDTH: 0.43741
G1 X140.868 Y138.997 E.05198
; LINE_WIDTH: 0.43754
G1 X142.868 Y138.997 E.06234
; LINE_WIDTH: 0.43767
G1 X144.868 Y138.997 E.06236
; LINE_WIDTH: 0.4378
G1 X146.868 Y138.997 E.06239
; LINE_WIDTH: 0.43793
G1 X148.868 Y138.997 E.06241
; LINE_WIDTH: 0.43806
G1 X150.868 Y138.997 E.06243
; LINE_WIDTH: 0.43819
G1 X152.868 Y138.997 E.06245
; LINE_WIDTH: 0.43832
G1 X154.868 Y138.997 E.06247
; LINE_WIDTH: 0.43845
G1 X156.868 Y138.997 E.06249
; LINE_WIDTH: 0.43858
G1 X158.868 Y138.997 E.06251
; LINE_WIDTH: 0.43872
G1 X160.868 Y138.997 E.06253
; LINE_WIDTH: 0.44999
G3 X162.742 Y138.991 I1.236 J99.217 E.06026
G1 X162.924 Y138.925 E.00623
G1 X162.991 Y138.712 E.00719
G3 X162.993 Y137.009 I328.059 J-.501 E.05475
; LINE_WIDTH: 0.44622
G1 X162.997 Y136.801 E.00666
; LINE_WIDTH: 0.43719
G1 X162.997 Y131.199 E.17445
; LINE_WIDTH: 0.43706
G1 X162.997 Y125.199 E.18681
; LINE_WIDTH: 0.43693
G1 X162.997 Y119.199 E.18674
; LINE_WIDTH: 0.45007
G3 X162.99 Y117.218 I91.125 J-1.296 E.06374
; LINE_WIDTH: 0.44999
G1 X162.935 Y117.112 E.00384
M204 S10000
G1 X163.12 Y116.718 F12000
G1 F6000
M204 S3000
G1 X163.105 Y116.703 E.00068
G1 X162.78 Y116.603 E.01093
G1 X137.24 Y116.602 E.82125
G1 X136.954 Y116.675 E.0095
G1 X136.743 Y116.825 E.00831
G1 X136.62 Y117.133 E.01066
G2 X136.602 Y118.766 I39.364 J1.249 E.05251
G1 X136.602 Y138.766 E.64311
G1 X136.676 Y139.048 E.00938
G1 X136.834 Y139.264 E.00861
G1 X137.081 Y139.367 E.00861
G2 X138.765 Y139.398 I1.288 J-24.613 E.05418
G1 X162.765 Y139.398 E.77173
G1 X163.048 Y139.324 E.00939
G1 X163.264 Y139.166 E.00862
; object ids of layer 28 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer28 end: 47,58
M625
G1 X163.367 Y138.919 E.00861
G2 X163.398 Y137.218 I-24.849 J-1.295 E.05472
G1 X163.397 Y117.218 E.64311
G1 X163.319 Y116.92 E.0099
G1 X163.162 Y116.76 E.00719
M204 S250
G1 X163.414 Y116.432 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.18 Y116.289 E.00817
G1 X162.706 Y116.211 E.01431
G1 X137.213 Y116.21 E.75931
G1 X136.935 Y116.248 E.00836
G1 X136.616 Y116.403 E.01057
G1 X136.427 Y116.586 E.00783
G1 X136.26 Y116.897 E.01051
G1 X136.21 Y117.301 E.01214
G1 X136.21 Y138.789 E.64002
G1 X136.238 Y139.025 E.00709
G1 X136.38 Y139.35 E.01056
G1 X136.589 Y139.576 E.00915
G1 X136.856 Y139.726 E.00914
G1 X137.315 Y139.79 E.0138
G1 X162.789 Y139.79 E.75875
G1 X163.025 Y139.762 E.00709
G1 X163.35 Y139.62 E.01056
G1 X163.576 Y139.411 E.00915
G1 X163.726 Y139.144 E.00914
G1 X163.79 Y138.685 E.0138
G1 X163.789 Y117.217 E.63942
G2 X163.664 Y116.722 I-1.623 J.146 E.01528
G1 X163.458 Y116.471 E.00968
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.18 Y116.289 E-.12644
G1 X162.706 Y116.211 E-.18254
G1 X162.519 Y116.211 E-.07102
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z6 I-.488 J-1.115 P1  F12000
G1 X116.391 Y136.391 Z6
G1 Z5.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.465 J-1.178 E.04403
M73 P83 R2
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.56211
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.605 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.715 Y136.742 F12000
G1 F6000
M204 S3000
G1 X116.72 Y136.74 E.00017
G1 X116.798 Y136.537 E.00701
G1 X116.797 Y119.467 E.54888
G1 X116.735 Y119.27 E.00663
G1 X116.523 Y119.202 E.00718
G1 X95.441 Y119.202 E.6779
G1 X95.28 Y119.26 E.00548
G1 X95.202 Y119.463 E.00701
G1 X95.202 Y136.548 E.54937
G1 X95.251 Y136.712 E.0055
G1 X95.463 Y136.798 E.00738
G1 X116.56 Y136.798 E.67837
G1 X116.658 Y136.762 E.00337
M204 S250
G1 X116.85 Y137.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X116.98 Y137.045 I-.401 J-.907 E.00441
G1 X117.132 Y136.845 E.00746
G1 X117.19 Y136.505 E.01029
G1 X117.189 Y119.467 E.50748
G1 X117.135 Y119.16 E.00928
G2 X116.824 Y118.858 I-.535 J.239 E.01324
G1 X116.523 Y118.81 E.00909
G1 X95.414 Y118.81 E.62875
G2 X95.02 Y118.955 I.137 J.982 E.0126
G1 X94.868 Y119.155 E.00747
G1 X94.81 Y119.495 E.01029
G1 X94.81 Y136.583 E.50897
G1 X94.898 Y136.886 E.0094
M73 P84 R2
G2 X95.155 Y137.132 I.806 J-.586 E.01066
G1 X95.495 Y137.19 E.01027
G1 X116.587 Y137.19 E.62823
G2 X116.795 Y137.137 I-.138 J-.983 E.0064
; WIPE_START
M204 S3000
G1 X116.98 Y137.045 E-.07887
G1 X117.132 Y136.845 E-.0952
G1 X117.19 Y136.505 E-.13127
G1 X117.19 Y136.308 E-.07466
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6 I.052 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z6
G1 Z5.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02423
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.56211
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.793 Y134.994 E.41618
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z6
G1 Z5.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z6
G1 Z5.6
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z6
G1 Z5.6
G1 E.4 F1800
; LINE_WIDTH: 0.42152
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; WIPE_START
G1 X116.021 Y120.043 E-.08512
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z6
G1 Z5.6
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L29
M991 S0 P28 ;notify layer change


; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z6 I.451 J1.13 P1  F12000
G1 X162.621 Y117.379 Z6
G1 Z5.8
G1 E.4 F1800
; LINE_WIDTH: 0.37444
G1 F6000
M204 S3000
G1 X161.976 Y117.379 E.01687
G1 X162.333 Y117.657 E.01184
G1 X162.621 Y118.027 E.01227
G1 X162.621 Y117.439 E.0154
; WIPE_START
G1 X161.976 Y117.379 E-.24588
G1 X162.255 Y117.596 E-.13412
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.2 I-1.217 J.022 P1  F12000
G1 X162.618 Y137.98 Z6.2
G1 Z5.8
G1 E.4 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.341 Y138.334 E.01176
G1 X161.971 Y138.622 E.01226
G1 X162.618 Y138.622 E.01693
G1 X162.618 Y138.04 E.01521
; WIPE_START
G1 X162.341 Y138.334 E-.15364
G1 X161.971 Y138.622 E-.1781
G1 X162.098 Y138.622 E-.04826
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.2 I0 J-1.217 P1  F12000
G1 X138.02 Y138.618 Z6.2
G1 Z5.8
G1 E.4 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X137.666 Y138.341 E.01176
G1 X137.378 Y137.971 E.01225
G1 X137.378 Y138.618 E.01693
G1 X137.96 Y138.618 E.01521
; WIPE_START
G1 X137.666 Y138.341 E-.15363
G1 X137.378 Y137.971 E-.17808
G1 X137.378 Y138.098 E-.04829
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.2 I1.216 J.038 P1  F12000
G1 X138.029 Y117.378 Z6.2
G1 Z5.8
G1 E.4 F1800
; LINE_WIDTH: 0.37392
G1 F6000
M204 S3000
G1 X137.382 Y117.378 E.01693
G1 X137.382 Y118.022 E.01684
G1 X137.758 Y117.583 E.01513
G1 X137.981 Y117.414 E.00731
; WIPE_START
G1 X137.382 Y117.378 E-.22826
G1 X137.382 Y117.777 E-.15174
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.2 I.013 J1.217 P1  F12000
G1 X161.443 Y117.526 Z6.2
G1 Z5.8
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.258 Y117.457 E.00635
; LINE_WIDTH: 0.44892
G1 X160.8 Y117.397 E.01479
; LINE_WIDTH: 0.43694
G1 X159.199 Y117.397 E.04983
; LINE_WIDTH: 0.43705
G1 X153.199 Y117.397 E.1868
; LINE_WIDTH: 0.43718
G1 X145.199 Y117.397 E.24915
; LINE_WIDTH: 0.43729
G1 X139.199 Y117.397 E.18691
; LINE_WIDTH: 0.44999
G1 X138.643 Y117.49 E.01812
G1 X138.26 Y117.666 E.01357
G2 X137.448 Y118.773 I.971 J1.565 E.04523
; LINE_WIDTH: 0.4479
G1 X137.399 Y119.168 E.01274
; LINE_WIDTH: 0.43608
G1 X137.398 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.398 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.398 Y124.801 E.06216
; LINE_WIDTH: 0.43648
G1 X137.398 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.398 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.398 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.398 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.397 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.397 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G1 X137.489 Y137.356 E.0181
G1 X137.666 Y137.74 E.0136
G1 X137.938 Y138.092 E.01429
G1 X138.417 Y138.423 E.01872
G1 X138.742 Y138.542 E.01116
; LINE_WIDTH: 0.44856
G1 X139.2 Y138.602 E.01477
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.602 E.04969
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.602 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.602 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.602 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.602 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.602 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.602 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.603 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.603 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.603 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.603 E.06229
; LINE_WIDTH: 0.44999
G1 X161.356 Y138.511 E.01809
G1 X161.74 Y138.334 E.0136
G1 X162.092 Y138.062 E.01429
G1 X162.423 Y137.584 E.0187
G1 X162.542 Y137.258 E.01117
; LINE_WIDTH: 0.44852
G1 X162.602 Y136.8 E.01478
; LINE_WIDTH: 0.43572
G1 X162.602 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.603 Y119.199 E.06221
; LINE_WIDTH: 0.44999
G1 X162.511 Y118.644 E.0181
G1 X162.334 Y118.26 E.0136
G1 X162.061 Y117.907 E.01434
G1 X161.583 Y117.577 E.01867
G1 X161.499 Y117.546 E.00288
M204 S10000
G1 X161.336 Y117.931 F12000
G1 F6000
M204 S3000
G1 X161.186 Y117.858 E.00537
G1 X160.8 Y117.798 E.01255
G1 X139.199 Y117.798 E.6946
G1 X138.731 Y117.887 E.01534
G2 X138.07 Y118.381 I.657 J1.568 E.02679
G1 X137.847 Y118.844 E.01653
G1 X137.799 Y119.168 E.01053
G1 X137.798 Y136.801 E.56699
G1 X137.887 Y137.269 E.01532
G1 X137.991 Y137.494 E.008
G1 X138.238 Y137.817 E.01306
G1 X138.373 Y137.926 E.00557
G1 X138.814 Y138.142 E.0158
G1 X139.199 Y138.202 E.01255
G1 X160.801 Y138.202 E.6946
G1 X161.268 Y138.113 E.01531
G2 X161.925 Y137.627 I-.678 J-1.604 E.02652
G1 X162.142 Y137.186 E.0158
G1 X162.202 Y136.801 E.01255
G1 X162.202 Y119.199 E.56597
G1 X162.113 Y118.731 E.01532
G2 X161.627 Y118.075 I-1.602 J.677 E.02652
G1 X161.39 Y117.958 E.00851
M204 S250
G1 X161.171 Y118.265 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X160.8 Y118.19 E.01126
G1 X139.199 Y118.19 E.64341
G1 X138.815 Y118.27 E.01169
G1 X138.463 Y118.515 E.01278
G1 X138.254 Y118.854 E.01185
G1 X138.191 Y119.168 E.00955
G1 X138.19 Y136.801 E.52521
G1 X138.27 Y137.184 E.01168
G1 X138.527 Y137.552 E.01337
G1 X138.821 Y137.733 E.01027
G1 X139.2 Y137.81 E.01151
G1 X160.801 Y137.81 E.64341
G1 X161.184 Y137.73 E.01167
G1 X161.538 Y137.484 E.01284
G1 X161.733 Y137.18 E.01077
G1 X161.81 Y136.8 E.01152
G1 X161.81 Y119.199 E.52426
G1 X161.73 Y118.816 E.01168
G1 X161.484 Y118.462 E.01284
G1 X161.223 Y118.294 E.00924
; WIPE_START
M204 S3000
G1 X160.8 Y118.19 E-.16533
G1 X160.236 Y118.19 E-.21467
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.2 I.48 J1.118 P1  F12000
G1 X162.893 Y117.05 Z6.2
G1 Z5.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.706 Y117.01 E.00614
G3 X161.009 Y117.008 I-.475 J-320.516 E.05457
; LINE_WIDTH: 0.44616
G1 X160.8 Y117.003 E.00665
; LINE_WIDTH: 0.43694
G1 X159.199 Y117.003 E.04983
; LINE_WIDTH: 0.43705
G1 X153.199 Y117.003 E.1868
; LINE_WIDTH: 0.43718
G1 X145.199 Y117.003 E.24915
; LINE_WIDTH: 0.43729
G1 X139.199 Y117.003 E.18691
; LINE_WIDTH: 0.44999
G3 X137.249 Y117.009 I-1.277 J-93.436 E.06272
G1 X137.064 Y117.085 E.00643
G1 X137.013 Y117.257 E.0058
G3 X137.01 Y118.959 I-227.532 J.493 E.05472
; LINE_WIDTH: 0.4452
G1 X137.005 Y119.168 E.00663
; LINE_WIDTH: 0.43608
G1 X137.005 Y120.801 E.05071
; LINE_WIDTH: 0.43622
G1 X137.005 Y122.801 E.06214
; LINE_WIDTH: 0.43635
G1 X137.005 Y124.801 E.06216
; LINE_WIDTH: 0.43648
M73 P85 R2
G1 X137.004 Y126.801 E.06218
; LINE_WIDTH: 0.43661
G1 X137.004 Y128.801 E.0622
; LINE_WIDTH: 0.43675
G1 X137.004 Y130.801 E.06222
; LINE_WIDTH: 0.43688
G1 X137.004 Y132.801 E.06224
; LINE_WIDTH: 0.43701
G1 X137.003 Y134.801 E.06226
; LINE_WIDTH: 0.43715
G1 X137.003 Y136.801 E.06228
; LINE_WIDTH: 0.44999
G3 X137.009 Y138.751 I-92.28 J1.264 E.06272
G1 X137.083 Y138.935 E.00638
G1 X137.258 Y138.987 E.00587
G3 X138.991 Y138.99 I.468 J245.44 E.05572
; LINE_WIDTH: 0.44486
G1 X139.2 Y138.995 E.00662
; LINE_WIDTH: 0.43575
G1 X140.801 Y138.995 E.04969
; LINE_WIDTH: 0.43589
G1 X142.801 Y138.995 E.06208
; LINE_WIDTH: 0.43603
G1 X144.801 Y138.995 E.06211
; LINE_WIDTH: 0.43617
G1 X146.801 Y138.995 E.06213
; LINE_WIDTH: 0.43632
G1 X148.801 Y138.996 E.06215
; LINE_WIDTH: 0.43646
G1 X150.801 Y138.996 E.06217
; LINE_WIDTH: 0.4366
G1 X152.801 Y138.996 E.0622
; LINE_WIDTH: 0.43674
G1 X154.801 Y138.996 E.06222
; LINE_WIDTH: 0.43688
G1 X156.801 Y138.997 E.06224
; LINE_WIDTH: 0.43702
G1 X158.801 Y138.997 E.06226
; LINE_WIDTH: 0.43717
G1 X160.801 Y138.997 E.06229
; LINE_WIDTH: 0.44999
G3 X162.752 Y138.991 I1.266 J92.307 E.06273
G1 X162.936 Y138.916 E.00641
G1 X162.987 Y138.742 E.00583
G3 X162.99 Y137.009 I233.098 J-.472 E.05571
; LINE_WIDTH: 0.44457
G1 X162.995 Y136.8 E.00662
; LINE_WIDTH: 0.43572
G1 X162.995 Y135.199 E.04968
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43622
G1 X162.996 Y127.199 E.06214
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.45006
G3 X162.99 Y117.221 I90.002 J-1.28 E.06362
; LINE_WIDTH: 0.44999
G1 X162.922 Y117.102 E.0044
M204 S10000
G1 X163.121 Y116.718 F12000
G1 F6000
M204 S3000
G1 X163.106 Y116.703 E.00067
G1 X162.781 Y116.603 E.01093
G1 X137.229 Y116.602 E.82165
G1 X136.887 Y116.7 E.01143
G1 X136.702 Y116.896 E.00867
G1 X136.606 Y117.177 E.00955
G1 X136.602 Y138.771 E.69438
G1 X136.701 Y139.115 E.0115
G1 X136.896 Y139.298 E.00859
G1 X137.177 Y139.394 E.00955
G1 X162.771 Y139.398 E.82301
G1 X163.113 Y139.3 E.01144
; object ids of layer 29 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer29 end: 47,58
M625
G1 X163.298 Y139.104 E.00865
G1 X163.394 Y138.823 E.00954
G1 X163.397 Y117.195 E.69548
G1 X163.314 Y116.912 E.00947
G1 X163.163 Y116.76 E.00688
M204 S250
G1 X163.413 Y116.432 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.181 Y116.289 E.0081
G1 X162.706 Y116.211 E.01435
G1 X137.21 Y116.21 E.75944
G2 X136.683 Y116.359 I.208 J1.742 E.01637
G1 X136.449 Y116.559 E.00917
G1 X136.288 Y116.82 E.00914
G1 X136.214 Y117.257 E.0132
G1 X136.21 Y138.79 E.64137
G2 X136.36 Y139.319 I1.752 J-.212 E.01645
G1 X136.557 Y139.55 E.00903
G1 X136.82 Y139.712 E.0092
G1 X137.258 Y139.786 E.01323
G1 X162.79 Y139.79 E.7605
G2 X163.318 Y139.641 I-.214 J-1.762 E.01638
G1 X163.551 Y139.441 E.00915
G1 X163.712 Y139.18 E.00914
G1 X163.786 Y138.742 E.01324
G1 X163.789 Y117.195 E.64179
G2 X163.661 Y116.718 I-2.212 J.338 E.01474
G1 X163.458 Y116.47 E.00954
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.181 Y116.289 E-.12555
G1 X162.706 Y116.211 E-.18304
G1 X162.518 Y116.211 E-.07142
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z6.2 I-.488 J-1.115 P1  F12000
G1 X116.388 Y136.391 Z6.2
G1 Z5.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.391 Y135.227 E.03744
; LINE_WIDTH: 0.44512
G1 X116.396 Y135.021 E.00652
; LINE_WIDTH: 0.4363
G1 X116.396 Y132.979 E.06348
; LINE_WIDTH: 0.4365
G1 X116.396 Y128.979 E.12436
; LINE_WIDTH: 0.43671
G1 X116.396 Y124.979 E.12443
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.397 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I102.608 J-1.165 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.56211
; LINE_WIDTH: 0.44999
G3 X95.612 Y119.609 I-1.171 J-105.245 E.04396
G1 X95.604 Y120.978 E.04403
; LINE_WIDTH: 0.43623
G1 X95.604 Y121.021 E.00134
; LINE_WIDTH: 0.43637
G1 X95.604 Y123.021 E.06216
; LINE_WIDTH: 0.43651
G1 X95.604 Y125.021 E.06218
; LINE_WIDTH: 0.43665
G1 X95.604 Y127.021 E.0622
; LINE_WIDTH: 0.43679
G1 X95.604 Y129.021 E.06223
; LINE_WIDTH: 0.43693
G1 X95.603 Y131.021 E.06225
; LINE_WIDTH: 0.43707
G1 X95.603 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.603 Y135.021 E.06229
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-104.302 J1.157 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.328 Y136.391 I1.171 J104.913 E.04203
M204 S10000
G1 X116.72 Y136.74 F12000
G1 F6000
M204 S3000
G1 X116.796 Y136.586 E.00551
G1 X116.797 Y119.47 E.5504
G1 X116.737 Y119.271 E.00667
G1 X116.522 Y119.202 E.00726
G1 X95.452 Y119.202 E.67751
G1 X95.288 Y119.25 E.00551
G1 X95.204 Y119.414 E.00589
G1 X95.202 Y136.548 E.55097
G1 X95.251 Y136.712 E.00551
G1 X95.463 Y136.798 E.00737
G1 X116.56 Y136.798 E.67836
G1 X116.663 Y136.76 E.00354
M204 S250
G1 X116.854 Y137.113 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X116.98 Y137.045 I-.41 J-.919 E.00429
G1 X117.134 Y136.842 E.00758
G1 X117.188 Y136.545 E.009
G1 X117.189 Y119.47 E.5086
G1 X117.132 Y119.153 E.00959
G2 X116.824 Y118.858 I-.531 J.246 E.01299
G1 X116.522 Y118.81 E.00912
G1 X95.417 Y118.81 E.62861
G1 X95.114 Y118.898 E.00939
G2 X94.833 Y119.286 I.351 J.551 E.01462
G2 X94.812 Y120.583 I22.887 J1.01 E.03866
G1 X94.81 Y136.583 E.47657
G1 X94.898 Y136.886 E.0094
G2 X95.155 Y137.132 I.805 J-.585 E.01065
G1 X95.495 Y137.19 E.01028
G1 X116.587 Y137.19 E.62823
G2 X116.798 Y137.136 I-.143 J-.996 E.00652
; WIPE_START
M204 S3000
G1 X116.98 Y137.045 E-.0773
G1 X117.134 Y136.842 E-.09671
G1 X117.188 Y136.545 E-.11483
G1 X117.188 Y136.305 E-.09116
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.2 I.054 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z6.2
G1 Z5.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01244
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01907
G1 X115.992 Y135.192 E.01914
; LINE_WIDTH: 0.44512
G1 X116.002 Y135.021 E.00542
; LINE_WIDTH: 0.4363
G1 X116.002 Y132.979 E.06348
; LINE_WIDTH: 0.4365
G1 X116.002 Y128.979 E.12436
; LINE_WIDTH: 0.43671
G1 X116.002 Y124.979 E.12443
; LINE_WIDTH: 0.43681
G1 X116.003 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02424
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.56211
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.01907
G1 X95.998 Y120.979 E.02426
; LINE_WIDTH: 0.43623
G1 X95.998 Y121.021 E.00133
; LINE_WIDTH: 0.43637
G1 X95.998 Y123.021 E.06216
; LINE_WIDTH: 0.43651
G1 X95.998 Y125.021 E.06218
; LINE_WIDTH: 0.43665
G1 X95.998 Y127.021 E.0622
; LINE_WIDTH: 0.43679
G1 X95.997 Y129.021 E.06223
; LINE_WIDTH: 0.43693
G1 X95.997 Y131.021 E.06225
; LINE_WIDTH: 0.43707
G1 X95.997 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.997 Y135.021 E.06229
; LINE_WIDTH: 0.44614
G1 X96.008 Y135.192 E.00543
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00474
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.433 E.01122
G1 X115.593 Y135.122 E.01126
G2 X115.602 Y134.979 I-.818 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01428
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01122
G1 X96.398 Y120.978 E.01431
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.0043
G1 X96.979 Y135.21 E.0043
G1 X115.021 Y135.21 E.53742
G1 X115.155 Y135.155 E.00429
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.00429
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.633 Y135.21 E-.24877
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.2 I-.513 J-1.104 P1  F12000
G1 X96.026 Y135.957 Z6.2
G1 Z5.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08513
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.2 I1.217 J0 P1  F12000
G1 X96.027 Y119.961 Z6.2
G1 Z5.8
G1 E.4 F1800
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00244
G1 X96.027 Y120.042 E.00244
G1 X96.051 Y120.002 E.00141
; WIPE_START
G1 X96.027 Y120.042 E-.08513
G1 X95.957 Y120.002 E-.14743
G1 X96.027 Y119.961 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.2 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z6.2
G1 Z5.8
G1 E.4 F1800
; LINE_WIDTH: 0.42148
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
M73 P86 R2
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; WIPE_START
G1 X116.021 Y120.043 E-.08512
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.2 I-1.217 J0 P1  F12000
G1 X116.02 Y135.958 Z6.2
G1 Z5.8
G1 E.4 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y135.998 E.00244
G1 X116.02 Y136.039 E.00244
G1 X116.043 Y135.998 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.02 Y136.039 E-.08513
G1 X115.949 Y135.998 E-.14743
G1 X116.02 Y135.958 E-.14743
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L30
M991 S0 P29 ;notify layer change


M106 S76.5
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z6.2 I.464 J1.125 P1  F12000
G1 X163.412 Y116.431 Z6.2
G1 Z6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.18 Y116.289 E.00811
G1 X162.708 Y116.211 E.01424
G1 X137.213 Y116.21 E.75938
G1 X136.809 Y116.302 E.01234
G1 X136.476 Y116.528 E.01199
G1 X136.304 Y116.785 E.00921
G1 X136.214 Y117.267 E.01461
G1 X136.21 Y138.787 E.64098
G1 X136.299 Y139.183 E.01208
G2 X136.589 Y139.575 I1.521 J-.82 E.0146
G1 X136.897 Y139.74 E.01038
G1 X137.301 Y139.79 E.01215
G1 X162.787 Y139.79 E.7591
G1 X163.182 Y139.701 E.01208
; object ids of layer 30 start: 47,58
M624 AwAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer30 end: 47,58
M625
G2 X163.577 Y139.41 I-.816 J-1.516 E.01466
G1 X163.726 Y139.144 E.00907
G1 X163.79 Y138.685 E.0138
G1 X163.789 Y117.216 E.63948
G2 X163.663 Y116.72 I-1.592 J.142 E.01531
G1 X163.457 Y116.469 E.00965
; WIPE_START
M204 S3000
G1 X163.18 Y116.289 E-.12572
G1 X162.708 Y116.211 E-.1817
G1 X162.517 Y116.211 E-.07258
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I-1.018 J-.667 P1  F12000
G1 X161.172 Y118.265 Z6.4
G1 Z6
G1 E.4 F1800
G1 F3600
M204 S1500
G1 X160.801 Y118.19 E.01128
G1 X139.135 Y118.193 E.64533
G1 X138.775 Y118.287 E.01108
G1 X138.458 Y118.519 E.01169
G1 X138.254 Y118.854 E.0117
G1 X138.191 Y119.167 E.00952
G1 X138.19 Y136.801 E.52522
G1 X138.27 Y137.184 E.01168
G1 X138.516 Y137.538 E.01285
G1 X138.888 Y137.757 E.01286
G1 X139.199 Y137.81 E.00939
G1 X160.865 Y137.807 E.64533
G1 X161.191 Y137.729 E.01001
G1 X161.538 Y137.484 E.01265
G1 X161.757 Y137.112 E.01286
G1 X161.81 Y136.801 E.00939
G1 X161.81 Y119.199 E.52427
G1 X161.73 Y118.816 E.01168
G1 X161.484 Y118.462 E.01285
G1 X161.224 Y118.295 E.00921
; WIPE_START
M204 S3000
G1 X160.801 Y118.19 E-.1655
G1 X160.236 Y118.19 E-.21451
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I-1.201 J.196 P1  F12000
G1 X163.583 Y138.681 Z6.4
G1 Z6
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F3600
M204 S2000
G1 X162.681 Y139.583 E.038
G1 X162.547 Y139.716
G1 X162.014 Y139.716
G1 X162.147 Y139.583
G1 X163.583 Y138.147 E.06046
G1 X163.716 Y138.014
G1 X163.716 Y137.48
G1 X163.583 Y137.614
G1 X161.614 Y139.583 E.08293
G1 X161.48 Y139.716
G1 X160.947 Y139.716
G1 X161.081 Y139.583
G1 X163.583 Y137.081 E.10539
G1 X163.716 Y136.947
G1 X163.716 Y136.414
G1 X163.583 Y136.548
G1 X160.547 Y139.583 E.12785
G1 X160.414 Y139.716
G1 X159.881 Y139.716
G1 X160.014 Y139.583
G1 X163.583 Y136.014 E.15031
G1 X163.716 Y135.881
G1 X163.716 Y135.347
G1 X163.582 Y135.481
G1 X161.982 Y137.082 E.06743
G1 X161.848 Y137.215
G1 X161.884 Y136.647
G1 X162.017 Y136.513
G1 X163.582 Y134.948 E.06593
G1 X163.716 Y134.814
G1 X163.716 Y134.281
G1 X163.582 Y134.415
G1 X162.017 Y135.98 E.06593
G1 X161.884 Y136.113
G1 X161.884 Y135.58
G1 X162.017 Y135.446
G1 X163.582 Y133.881 E.06593
G1 X163.716 Y133.748
G1 X163.716 Y133.215
G1 X163.582 Y133.348
G1 X162.017 Y134.913 E.06593
G1 X161.884 Y135.047
G1 X161.884 Y134.514
G1 X162.017 Y134.38
G1 X163.582 Y132.815 E.06592
G1 X163.716 Y132.681
G1 X163.716 Y132.148
G1 X163.582 Y132.282
G1 X162.017 Y133.847 E.06592
G1 X161.884 Y133.98
G1 X161.884 Y133.447
G1 X162.017 Y133.313
G1 X163.582 Y131.748 E.06592
G1 X163.716 Y131.615
G1 X163.716 Y131.082
G1 X163.582 Y131.215
G1 X162.017 Y132.78 E.06592
G1 X161.884 Y132.914
G1 X161.884 Y132.381
G1 X162.017 Y132.247
G1 X163.582 Y130.682 E.06592
G1 X163.716 Y130.548
G1 X163.716 Y130.015
G1 X163.582 Y130.149
G1 X162.017 Y131.714 E.06592
G1 X161.884 Y131.847
G1 X161.884 Y131.314
G1 X162.017 Y131.18
G1 X163.582 Y129.616 E.06592
G1 X163.716 Y129.482
G1 X163.716 Y128.949
G1 X163.582 Y129.082
G1 X162.017 Y130.647 E.06592
G1 X161.884 Y130.781
G1 X161.884 Y130.248
G1 X162.017 Y130.114
G1 X163.582 Y128.549 E.06592
G1 X163.716 Y128.415
G1 X163.716 Y127.882
G1 X163.582 Y128.016
G1 X162.017 Y129.581 E.06592
G1 X161.884 Y129.714
G1 X161.884 Y129.181
G1 X162.017 Y129.047
G1 X163.582 Y127.483 E.06591
G1 X163.716 Y127.349
G1 X163.716 Y126.816
G1 X163.582 Y126.949
G1 X162.017 Y128.514 E.06591
G1 X161.884 Y128.648
G1 X161.884 Y128.114
G1 X162.017 Y127.981
G1 X163.582 Y126.416 E.06591
G1 X163.716 Y126.282
G1 X163.716 Y125.749
G1 X163.582 Y125.883
G1 X162.017 Y127.448 E.06591
G1 X161.884 Y127.581
G1 X161.884 Y127.048
G1 X162.017 Y126.914
G1 X163.582 Y125.35 E.06591
G1 X163.716 Y125.216
G1 X163.716 Y124.683
G1 X163.582 Y124.816
G1 X162.017 Y126.381 E.06591
G1 X161.884 Y126.515
G1 X161.884 Y125.981
G1 X162.017 Y125.848
G1 X163.582 Y124.283 E.06591
G1 X163.716 Y124.15
G1 X163.716 Y123.616
G1 X163.582 Y123.75
G1 X162.017 Y125.315 E.06591
G1 X161.884 Y125.448
G1 X161.884 Y124.915
G1 X162.017 Y124.781
G1 X163.582 Y123.217 E.06591
G1 X163.716 Y123.083
G1 X163.716 Y122.55
G1 X163.582 Y122.683
G1 X162.017 Y124.248 E.06591
G1 X161.884 Y124.382
G1 X161.884 Y123.848
G1 X162.017 Y123.715
G1 X163.582 Y122.15 E.06591
G1 X163.716 Y122.017
G1 X163.716 Y121.483
G1 X163.582 Y121.617
G1 X162.017 Y123.182 E.0659
G1 X161.884 Y123.315
G1 X161.884 Y122.782
G1 X162.017 Y122.648
G1 X163.582 Y121.084 E.0659
G1 X163.716 Y120.95
G1 X163.715 Y120.417
G1 X163.582 Y120.551
G1 X162.017 Y122.115 E.0659
G1 X161.884 Y122.249
G1 X161.884 Y121.715
G1 X162.017 Y121.582
G1 X163.582 Y120.017 E.0659
G1 X163.715 Y119.884
G1 X163.715 Y119.35
G1 X163.582 Y119.484
G1 X162.017 Y121.048 E.0659
G1 X161.884 Y121.182
G1 X161.884 Y120.649
G1 X162.017 Y120.515
G1 X163.582 Y118.951 E.0659
G1 X163.715 Y118.817
G1 X163.715 Y118.284
G1 X163.582 Y118.418
G1 X162.017 Y119.982 E.0659
G1 X161.884 Y120.116
G1 X161.884 Y119.582
G1 X162.017 Y119.449
G1 X163.582 Y117.884 E.0659
G1 X163.715 Y117.751
G1 X163.715 Y117.217
G1 X163.582 Y117.351
G1 X161.971 Y118.962 E.06787
G1 X161.837 Y119.096
G1 X161.694 Y118.706
G1 X161.827 Y118.572
G1 X163.506 Y116.894 E.0707
G1 X163.639 Y116.76
G1 X163.409 Y116.457
G1 X163.276 Y116.591
G1 X161.585 Y118.281 E.07121
G1 X161.452 Y118.415
G1 X161.123 Y118.211
G1 X161.256 Y118.077
G1 X162.895 Y116.438 E.06902
G1 X163.028 Y116.305
G1 X162.515 Y116.285
G1 X162.382 Y116.418
G1 X160.815 Y117.985 E.06599
G1 X160.681 Y118.118
G1 X160.15 Y118.116
G1 X160.284 Y117.983
G1 X161.848 Y116.418 E.0659
G1 X161.982 Y116.285
G1 X161.449 Y116.285
G1 X161.315 Y116.418
G1 X159.751 Y117.983 E.06591
G1 X159.617 Y118.116
G1 X159.084 Y118.116
G1 X159.217 Y117.983
G1 X160.782 Y116.418 E.06591
G1 X160.915 Y116.285
G1 X160.382 Y116.285
G1 X160.249 Y116.418
G1 X158.684 Y117.983 E.06591
G1 X158.55 Y118.117
G1 X158.017 Y118.117
G1 X158.151 Y117.983
G1 X159.715 Y116.418 E.06592
G1 X159.849 Y116.285
G1 X159.316 Y116.285
G1 X159.182 Y116.418
G1 X157.617 Y117.983 E.06592
G1 X157.484 Y118.117
G1 X156.95 Y118.117
G1 X157.084 Y117.983
G1 X158.649 Y116.418 E.06592
G1 X158.783 Y116.284
G1 X158.249 Y116.284
G1 X158.116 Y116.418
G1 X156.551 Y117.983 E.06593
G1 X156.417 Y118.117
G1 X155.884 Y118.117
G1 X156.017 Y117.983
G1 X157.582 Y116.418 E.06593
G1 X157.716 Y116.284
G1 X157.183 Y116.284
G1 X157.049 Y116.418
G1 X155.484 Y117.983 E.06593
G1 X155.35 Y118.117
G1 X154.817 Y118.117
G1 X154.951 Y117.983
G1 X156.516 Y116.418 E.06594
G1 X156.65 Y116.284
G1 X156.116 Y116.284
G1 X155.983 Y116.418
G1 X154.417 Y117.983 E.06594
G1 X154.284 Y118.117
G1 X153.75 Y118.117
G1 X153.884 Y117.983
G1 X155.449 Y116.418 E.06594
G1 X155.583 Y116.284
G1 X155.05 Y116.284
G1 X154.916 Y116.418
G1 X153.351 Y117.984 E.06595
G1 X153.217 Y118.117
G1 X152.684 Y118.117
G1 X152.817 Y117.984
G1 X154.383 Y116.418 E.06595
G1 X154.517 Y116.284
G1 X153.983 Y116.284
G1 X153.85 Y116.418
G1 X152.284 Y117.984 E.06595
G1 X152.15 Y118.117
G1 X151.617 Y118.117
G1 X151.751 Y117.984
G1 X153.316 Y116.418 E.06596
G1 X153.45 Y116.284
G1 X152.917 Y116.284
G1 X152.783 Y116.418
G1 X151.217 Y117.984 E.06596
G1 X151.084 Y118.117
G1 X150.55 Y118.117
G1 X150.684 Y117.984
G1 X152.25 Y116.418 E.06596
G1 X152.384 Y116.284
G1 X151.85 Y116.284
G1 X151.717 Y116.418
G1 X150.151 Y117.984 E.06597
G1 X150.017 Y118.118
G1 X149.484 Y118.118
G1 X149.617 Y117.984
G1 X151.184 Y116.418 E.06597
G1 X151.317 Y116.284
G1 X150.784 Y116.284
G1 X150.65 Y116.418
G1 X149.084 Y117.984 E.06597
G1 X148.951 Y118.118
G1 X148.417 Y118.118
G1 X148.551 Y117.984
G1 X150.117 Y116.418 E.06598
G1 X150.251 Y116.284
G1 X149.717 Y116.284
G1 X149.584 Y116.418
G1 X148.018 Y117.984 E.06598
G1 X147.884 Y118.118
G1 X147.351 Y118.118
G1 X147.484 Y117.984
G1 X149.051 Y116.418 E.06598
G1 X149.184 Y116.284
G1 X148.651 Y116.284
G1 X148.517 Y116.418
G1 X146.951 Y117.984 E.06599
G1 X146.817 Y118.118
G1 X146.284 Y118.118
G1 X146.418 Y117.984
G1 X147.984 Y116.418 E.06599
G1 X148.118 Y116.284
G1 X147.585 Y116.284
G1 X147.451 Y116.418
G1 X145.884 Y117.984 E.06599
G1 X145.751 Y118.118
G1 X145.217 Y118.118
G1 X145.351 Y117.984
G1 X146.918 Y116.418 E.066
G1 X147.051 Y116.284
G1 X146.518 Y116.284
G1 X146.384 Y116.418
G1 X144.818 Y117.984 E.066
G1 X144.684 Y118.118
G1 X144.151 Y118.118
G1 X144.284 Y117.985
G1 X145.851 Y116.418 E.066
G1 X145.985 Y116.284
G1 X145.452 Y116.284
G1 X145.318 Y116.418
G1 X143.751 Y117.985 E.06601
G1 X143.617 Y118.118
G1 X143.084 Y118.118
G1 X143.218 Y117.985
G1 X144.785 Y116.418 E.06601
M73 P87 R2
G1 X144.918 Y116.284
G1 X144.385 Y116.284
G1 X144.251 Y116.418
G1 X142.684 Y117.985 E.06601
G1 X142.551 Y118.118
G1 X142.017 Y118.118
G1 X142.151 Y117.985
G1 X143.718 Y116.418 E.06602
G1 X143.852 Y116.284
G1 X143.319 Y116.284
G1 X143.185 Y116.418
G1 X141.618 Y117.985 E.06602
G1 X141.484 Y118.119
G1 X140.951 Y118.119
G1 X141.084 Y117.985
G1 X142.652 Y116.418 E.06602
G1 X142.785 Y116.284
G1 X142.252 Y116.284
G1 X142.118 Y116.418
G1 X140.551 Y117.985 E.06603
G1 X140.417 Y118.119
G1 X139.884 Y118.119
G1 X140.018 Y117.985
G1 X141.585 Y116.418 E.06603
G1 X141.719 Y116.284
G1 X141.186 Y116.284
G1 X141.052 Y116.418
G1 X139.484 Y117.985 E.06603
G1 X139.351 Y118.119
G1 X138.758 Y118.178
G1 X138.892 Y118.045
G1 X140.519 Y116.417 E.06855
; WIPE_START
M204 S3000
G1 X139.812 Y117.125 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I-.851 J.87 P1  F12000
G1 X161.102 Y137.961 Z6.4
G1 Z6
G1 E.4 F1800
G1 F3600
M204 S2000
G1 X159.481 Y139.583 E.06829
G1 X159.347 Y139.716
G1 X158.814 Y139.716
G1 X158.948 Y139.583
G1 X160.515 Y138.015 E.06604
G1 X160.649 Y137.881
G1 X160.116 Y137.881
G1 X159.982 Y138.015
G1 X158.414 Y139.583 E.06604
G1 X158.281 Y139.716
G1 X157.748 Y139.716
G1 X157.881 Y139.583
G1 X159.449 Y138.015 E.06603
G1 X159.582 Y137.881
G1 X159.049 Y137.881
G1 X158.915 Y138.015
G1 X157.348 Y139.583 E.06603
G1 X157.214 Y139.716
G1 X156.681 Y139.716
G1 X156.815 Y139.583
G1 X158.382 Y138.015 E.06603
G1 X158.516 Y137.882
G1 X157.982 Y137.882
G1 X157.849 Y138.015
G1 X156.281 Y139.583 E.06603
G1 X156.148 Y139.716
G1 X155.615 Y139.716
G1 X155.748 Y139.583
G1 X157.316 Y138.015 E.06602
G1 X157.449 Y137.882
G1 X156.916 Y137.882
G1 X156.782 Y138.015
G1 X155.215 Y139.583 E.06602
G1 X155.081 Y139.716
G1 X154.548 Y139.716
G1 X154.682 Y139.583
G1 X156.249 Y138.015 E.06602
G1 X156.383 Y137.882
G1 X155.849 Y137.882
G1 X155.716 Y138.015
G1 X154.148 Y139.583 E.06602
G1 X154.015 Y139.716
G1 X153.481 Y139.716
G1 X153.615 Y139.583
G1 X155.182 Y138.016 E.06601
G1 X155.316 Y137.882
G1 X154.783 Y137.882
G1 X154.649 Y138.016
G1 X153.082 Y139.583 E.06601
G1 X152.948 Y139.716
G1 X152.415 Y139.716
G1 X152.549 Y139.583
G1 X154.116 Y138.016 E.06601
G1 X154.249 Y137.882
G1 X153.716 Y137.882
G1 X153.582 Y138.016
G1 X152.015 Y139.583 E.06601
G1 X151.882 Y139.716
G1 X151.348 Y139.716
G1 X151.482 Y139.583
G1 X153.049 Y138.016 E.066
G1 X153.183 Y137.882
G1 X152.649 Y137.882
G1 X152.516 Y138.016
G1 X150.949 Y139.583 E.066
G1 X150.815 Y139.716
G1 X150.282 Y139.716
G1 X150.416 Y139.583
G1 X151.982 Y138.016 E.066
G1 X152.116 Y137.882
G1 X151.583 Y137.882
G1 X151.449 Y138.016
G1 X149.882 Y139.583 E.066
G1 X149.749 Y139.716
G1 X149.215 Y139.716
G1 X149.349 Y139.583
G1 X150.916 Y138.016 E.06599
G1 X151.049 Y137.882
G1 X150.516 Y137.882
G1 X150.382 Y138.016
G1 X148.816 Y139.583 E.06599
G1 X148.682 Y139.716
G1 X148.149 Y139.716
G1 X148.283 Y139.583
G1 X149.849 Y138.016 E.06599
G1 X149.983 Y137.883
G1 X149.449 Y137.883
G1 X149.316 Y138.016
G1 X147.749 Y139.583 E.06598
G1 X147.616 Y139.716
G1 X147.082 Y139.716
G1 X147.216 Y139.583
G1 X148.782 Y138.016 E.06598
G1 X148.916 Y137.883
G1 X148.383 Y137.883
G1 X148.249 Y138.016
G1 X146.683 Y139.583 E.06598
G1 X146.549 Y139.716
G1 X146.016 Y139.716
G1 X146.15 Y139.583
G1 X147.716 Y138.016 E.06598
G1 X147.849 Y137.883
G1 X147.316 Y137.883
G1 X147.182 Y138.016
G1 X145.616 Y139.583 E.06597
G1 X145.483 Y139.716
G1 X144.949 Y139.716
G1 X145.083 Y139.583
G1 X146.649 Y138.017 E.06597
G1 X146.783 Y137.883
G1 X146.249 Y137.883
G1 X146.116 Y138.017
G1 X144.55 Y139.583 E.06597
G1 X144.416 Y139.716
G1 X143.883 Y139.716
G1 X144.016 Y139.583
G1 X145.582 Y138.017 E.06597
G1 X145.716 Y137.883
G1 X145.183 Y137.883
G1 X145.049 Y138.017
G1 X143.483 Y139.583 E.06596
G1 X143.35 Y139.716
G1 X142.816 Y139.716
G1 X142.95 Y139.583
G1 X144.516 Y138.017 E.06596
G1 X144.649 Y137.883
G1 X144.116 Y137.883
G1 X143.983 Y138.017
G1 X142.417 Y139.583 E.06596
G1 X142.283 Y139.716
G1 X141.75 Y139.716
G1 X141.883 Y139.583
G1 X143.449 Y138.017 E.06596
G1 X143.583 Y137.883
G1 X143.05 Y137.883
G1 X142.916 Y138.017
G1 X141.35 Y139.583 E.06595
G1 X141.217 Y139.716
G1 X140.683 Y139.716
G1 X140.817 Y139.583
G1 X142.383 Y138.017 E.06595
G1 X142.516 Y137.883
G1 X141.983 Y137.883
G1 X141.849 Y138.017
G1 X140.284 Y139.583 E.06595
G1 X140.15 Y139.716
G1 X139.617 Y139.716
G1 X139.75 Y139.583
G1 X141.316 Y138.017 E.06595
G1 X141.45 Y137.883
G1 X140.916 Y137.884
G1 X140.783 Y138.017
G1 X139.217 Y139.583 E.06594
G1 X139.084 Y139.716
G1 X138.55 Y139.716
G1 X138.684 Y139.583
G1 X140.249 Y138.017 E.06594
G1 X140.383 Y137.884
G1 X139.85 Y137.884
G1 X139.716 Y138.017
G1 X138.151 Y139.583 E.06594
G1 X138.017 Y139.716
G1 X137.484 Y139.716
G1 X137.617 Y139.583
G1 X139.184 Y138.016 E.06601
G1 X139.318 Y137.882
G1 X138.883 Y137.784
G1 X138.749 Y137.918
G1 X137.104 Y139.562 E.06929
G1 X136.971 Y139.696
G1 X136.589 Y139.545
G1 X136.722 Y139.411
G1 X138.412 Y137.722 E.07118
G1 X138.546 Y137.588
G1 X138.306 Y137.294
G1 X138.173 Y137.428
G1 X136.493 Y139.108 E.07077
G1 X136.359 Y139.241
G1 X136.284 Y138.783
G1 X136.417 Y138.65
G1 X138.029 Y137.038 E.0679
G1 X138.163 Y136.904
G1 X138.116 Y136.417
G1 X137.983 Y136.551
G1 X136.417 Y138.116 E.06593
G1 X136.284 Y138.25
G1 X136.284 Y137.717
G1 X136.418 Y137.583
G1 X137.983 Y136.018 E.06593
G1 X138.116 Y135.884
G1 X138.116 Y135.351
G1 X137.983 Y135.485
G1 X136.418 Y137.05 E.06592
G1 X136.284 Y137.183
G1 X136.284 Y136.65
G1 X136.418 Y136.516
G1 X137.983 Y134.951 E.06592
G1 X138.116 Y134.818
G1 X138.116 Y134.284
G1 X137.983 Y134.418
G1 X136.418 Y135.983 E.06592
G1 X136.284 Y136.117
G1 X136.284 Y135.583
G1 X136.418 Y135.45
G1 X137.983 Y133.885 E.06592
G1 X138.116 Y133.751
G1 X138.116 Y133.218
G1 X137.983 Y133.351
G1 X136.418 Y134.916 E.06591
G1 X136.284 Y135.05
G1 X136.284 Y134.516
G1 X136.418 Y134.383
G1 X137.983 Y132.818 E.06591
G1 X138.116 Y132.685
G1 X138.116 Y132.151
G1 X137.983 Y132.285
G1 X136.418 Y133.849 E.06591
G1 X136.285 Y133.983
G1 X136.285 Y133.45
G1 X136.418 Y133.316
G1 X137.983 Y131.752 E.0659
G1 X138.116 Y131.618
G1 X138.116 Y131.085
G1 X137.983 Y131.218
G1 X136.418 Y132.783 E.0659
G1 X136.285 Y132.916
G1 X136.285 Y132.383
G1 X136.418 Y132.249
G1 X137.983 Y130.685 E.0659
G1 X138.116 Y130.551
G1 X138.117 Y130.018
G1 X137.983 Y130.152
G1 X136.419 Y131.716 E.0659
G1 X136.285 Y131.85
G1 X136.285 Y131.316
G1 X136.419 Y131.183
G1 X137.983 Y129.619 E.06589
G1 X138.117 Y129.485
G1 X138.117 Y128.952
G1 X137.983 Y129.085
G1 X136.419 Y130.649 E.06589
G1 X136.285 Y130.783
G1 X136.285 Y130.25
G1 X136.419 Y130.116
G1 X137.983 Y128.552 E.06589
G1 X138.117 Y128.418
G1 X138.117 Y127.885
G1 X137.983 Y128.019
G1 X136.419 Y129.583 E.06588
G1 X136.285 Y129.716
G1 X136.285 Y129.183
G1 X136.419 Y129.049
G1 X137.983 Y127.485 E.06588
G1 X138.117 Y127.352
G1 X138.117 Y126.818
G1 X137.983 Y126.952
G1 X136.419 Y128.516 E.06588
G1 X136.285 Y128.65
G1 X136.286 Y128.116
G1 X136.419 Y127.983
G1 X137.983 Y126.419 E.06587
G1 X138.117 Y126.285
G1 X138.117 Y125.752
G1 X137.983 Y125.886
G1 X136.419 Y127.449 E.06587
G1 X136.286 Y127.583
G1 X136.286 Y127.05
G1 X136.419 Y126.916
G1 X137.983 Y125.352 E.06587
G1 X138.117 Y125.219
G1 X138.117 Y124.685
G1 X137.983 Y124.819
G1 X136.419 Y126.383 E.06587
G1 X136.286 Y126.516
G1 X136.286 Y125.983
G1 X136.42 Y125.849
G1 X137.983 Y124.286 E.06586
G1 X138.117 Y124.152
G1 X138.117 Y123.619
G1 X137.983 Y123.752
G1 X136.42 Y125.316 E.06586
G1 X136.286 Y125.45
G1 X136.286 Y124.916
G1 X136.42 Y124.783
G1 X137.983 Y123.219 E.06586
G1 X138.117 Y123.086
G1 X138.117 Y122.552
G1 X137.983 Y122.686
G1 X136.42 Y124.249 E.06585
G1 X136.286 Y124.383
G1 X136.286 Y123.85
G1 X136.42 Y123.716
G1 X137.983 Y122.153 E.06585
G1 X138.117 Y122.019
G1 X138.117 Y121.486
G1 X137.983 Y121.619
G1 X136.42 Y123.183 E.06585
G1 X136.286 Y123.316
G1 X136.286 Y122.783
G1 X136.42 Y122.649
G1 X137.983 Y121.086 E.06584
G1 X138.117 Y120.952
G1 X138.117 Y120.419
G1 X137.983 Y120.553
G1 X136.42 Y122.116 E.06584
G1 X136.287 Y122.249
G1 X136.287 Y121.716
G1 X136.42 Y121.582
G1 X137.983 Y120.02 E.06584
G1 X138.117 Y119.886
G1 X138.117 Y119.353
G1 X137.983 Y119.486
G1 X136.42 Y121.049 E.06584
G1 X136.287 Y121.183
G1 X136.287 Y120.649
G1 X136.42 Y120.516
G1 X138.023 Y118.913 E.06751
; WIPE_START
M204 S3000
G1 X137.316 Y119.62 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I-.456 J-1.128 P1  F12000
G1 X136.421 Y119.982 Z6.4
G1 Z6
G1 E.4 F1800
G1 F3600
M204 S2000
G1 X139.986 Y116.417 E.15017
G1 X140.119 Y116.284
G1 X139.586 Y116.284
G1 X139.452 Y116.417
G1 X136.421 Y119.449 E.12771
G1 X136.287 Y119.583
G1 X136.287 Y119.049
G1 X136.421 Y118.916
G1 X138.919 Y116.417 E.10524
G1 X139.053 Y116.284
G1 X138.519 Y116.284
G1 X138.386 Y116.417
G1 X136.421 Y118.382 E.08277
G1 X136.287 Y118.516
G1 X136.287 Y117.983
G1 X136.421 Y117.849
G1 X137.853 Y116.417 E.06031
G1 X137.986 Y116.284
G1 X137.453 Y116.284
G1 X137.319 Y116.417
G1 X136.421 Y117.316 E.03784
; WIPE_START
M204 S3000
G1 X137.128 Y116.609 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I-.901 J.818 P1  F12000
G1 X138.545 Y118.17 Z6.4
G1 Z6
G1 E.4 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0955762
G1 F15000
M204 S3000
G1 X138.408 Y118.292 E.00076
M204 S10000
G1 X138.235 Y118.462 F12000
; LINE_WIDTH: 0.109626
G1 F15000
M204 S3000
G1 X138.134 Y118.596 E.00088
; LINE_WIDTH: 0.163134
G2 X137.954 Y118.844 I2.855 J2.266 E.00291
; WIPE_START
G1 X138.134 Y118.596 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I1.076 J-.568 P1  F12000
G1 X136.998 Y116.446 Z6.4
G1 Z6
G1 E.4 F1800
; LINE_WIDTH: 0.106682
G1 F15000
M204 S3000
G1 X136.906 Y116.508 E.00056
; LINE_WIDTH: 0.143696
G1 X136.814 Y116.571 E.00088
; LINE_WIDTH: 0.163443
G2 X136.451 Y116.968 I1.157 J1.423 E.00514
; WIPE_START
G1 X136.669 Y116.703 E-.24173
G1 X136.814 Y116.571 E-.13827
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I-.789 J.926 P1  F12000
G1 X161.606 Y137.694 Z6.4
G1 Z6
G1 E.4 F1800
; LINE_WIDTH: 0.105802
G1 F15000
M204 S3000
G3 X161.389 Y137.883 I-1.985 J-2.056 E.00143
; LINE_WIDTH: 0.14912
G1 X161.268 Y137.97 E.00125
; LINE_WIDTH: 0.18556
G1 X161.167 Y138.026 E.0013
M204 S10000
G1 X161.85 Y137.423 F12000
; LINE_WIDTH: 0.100554
G1 F15000
M204 S3000
G1 X161.765 Y137.538 E.00065
; WIPE_START
G1 X161.85 Y137.423 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I-.833 J.887 P1  F12000
G1 X163.542 Y139.011 Z6.4
G1 Z6
G1 E.4 F1800
; LINE_WIDTH: 0.100587
G1 F15000
M204 S3000
G1 X163.512 Y139.067 E.00029
; LINE_WIDTH: 0.128503
G1 X163.444 Y139.158 E.00076
; LINE_WIDTH: 0.164828
G3 X163.178 Y139.434 I-.953 J-.65 E.00371
; LINE_WIDTH: 0.141359
G1 X163.09 Y139.494 E.00083
; LINE_WIDTH: 0.105903
G1 X163.002 Y139.554 E.00053
; OBJECT_ID: 47
; WIPE_START
G1 X163.09 Y139.494 E-.38
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z6.4 I.081 J-1.214 P1  F12000
G1 X116.391 Y136.391 Z6.4
G1 Z6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.469 J-1.178 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.56211
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.605 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.715 Y136.742 F12000
G1 F6000
M204 S3000
G1 X116.72 Y136.74 E.00017
G1 X116.798 Y136.537 E.00701
G1 X116.797 Y119.46 E.54911
G1 X116.732 Y119.268 E.00652
G1 X116.521 Y119.202 E.0071
G1 X95.44 Y119.202 E.67786
G1 X95.28 Y119.26 E.00547
G1 X95.202 Y119.463 E.00701
G1 X95.202 Y136.548 E.54937
G1 X95.251 Y136.712 E.00551
G1 X95.463 Y136.798 E.00737
M73 P88 R2
G1 X116.56 Y136.798 E.67837
G1 X116.658 Y136.762 E.00337
M204 S250
G1 X116.85 Y137.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X116.98 Y137.045 I-.401 J-.907 E.0044
G1 X117.132 Y136.845 E.00747
G1 X117.19 Y136.505 E.01029
G1 X117.189 Y119.46 E.5077
G2 X116.824 Y118.858 I-.656 J-.014 E.02213
G1 X116.521 Y118.81 E.00915
G1 X95.413 Y118.81 E.62871
G2 X95.02 Y118.955 I.138 J.983 E.01259
G1 X94.868 Y119.155 E.00747
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.583 E.50898
G1 X94.898 Y136.886 E.00939
G2 X95.155 Y137.132 I.804 J-.584 E.01066
G1 X95.495 Y137.19 E.01028
G1 X116.587 Y137.19 E.62823
G2 X116.795 Y137.137 I-.138 J-.982 E.0064
; WIPE_START
M204 S3000
G1 X116.98 Y137.045 E-.0788
G1 X117.132 Y136.845 E-.09528
G1 X117.19 Y136.505 E-.13129
G1 X117.19 Y136.308 E-.07464
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I.054 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z6.4
G1 Z6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.28 Y135.72 E.01243
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02424
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.56211
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00475
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01429
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I1.21 J-.128 P1  F12000
G1 X96.026 Y119.961 Z6.4
G1 Z6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I-1.217 J0 P1  F12000
G1 X96.026 Y135.957 Z6.4
G1 Z6
G1 E.4 F1800
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I0 J1.217 P1  F12000
G1 X116.021 Y135.957 Z6.4
G1 Z6
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; WIPE_START
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.4 I1.217 J0 P1  F12000
G1 X116.021 Y119.961 Z6.4
G1 Z6
G1 E.4 F1800
; LINE_WIDTH: 0.42154
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y120.043 E-.08512
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L31
M991 S0 P30 ;notify layer change


M106 S150.45
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z6.4 I-1.217 J.027 P1  F12000
G1 X116.391 Y136.391 Z6.4
G1 Z6.2
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F2905
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.471 J-1.178 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.603 E.56211
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.605 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F2905
M204 S3000
G1 X116.798 Y136.537 E.00737
G1 X116.797 Y119.45 E.54941
G1 X116.727 Y119.265 E.00639
G1 X116.52 Y119.202 E.00694
G1 X95.441 Y119.202 E.67783
G1 X95.28 Y119.26 E.00548
G1 X95.202 Y119.463 E.00701
G1 X95.202 Y136.56 E.54974
G1 X95.26 Y136.72 E.00547
G1 X95.463 Y136.798 E.00701
G1 X116.548 Y136.798 E.67799
; object ids of layer 31 start: 47
M624 AQAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer31 end: 47
M625
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2905
M204 S1500
G2 X117.132 Y136.845 I-.583 J-.804 E.01066
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.45 E.50798
G1 X117.152 Y119.202 E.00748
G1 X117.013 Y118.984 E.0077
G1 X116.824 Y118.858 E.00676
G1 X116.52 Y118.81 E.00916
G1 X95.414 Y118.81 E.62868
G2 X95.02 Y118.955 I.137 J.982 E.0126
G1 X94.868 Y119.155 E.00747
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.587 E.50909
G2 X94.955 Y136.98 I.983 J-.138 E.01259
G1 X95.155 Y137.132 E.00747
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
M73 P89 R2
G1 F3600
M204 S3000
G1 X117.054 Y136.948 E-.10774
G1 X117.132 Y136.845 E-.04887
G1 X117.19 Y136.505 E-.13117
G1 X117.19 Y136.262 E-.09223
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.6 I.05 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z6.6
G1 Z6.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2905
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02424
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43731
G1 X96.979 Y119.997 E.56211
; LINE_WIDTH: 0.44624
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F2905
M204 S3000
G1 X96.568 Y135.432 E.00745
M73 P89 R1
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01428
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2905
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.793 Y134.994 E.41618
; WIPE_START
G1 F3600
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.6 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z6.6
G1 Z6.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2905
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.6 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z6.6
G1 Z6.2
G1 E.4 F1800
G1 F2905
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.6 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z6.6
G1 Z6.2
G1 E.4 F1800
; LINE_WIDTH: 0.42156
G1 F2905
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14743
G1 X116.021 Y119.961 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.6 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z6.6
G1 Z6.2
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F2905
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L32
M991 S0 P31 ;notify layer change


; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z6.6 I-.929 J.786 P1  F12000
G1 X116.388 Y136.391 Z6.6
G1 Z6.4
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F2880
M204 S3000
G1 X116.391 Y135.227 E.03744
; LINE_WIDTH: 0.4451
G1 X116.396 Y135.021 E.00652
; LINE_WIDTH: 0.43619
G1 X116.396 Y134.979 E.00133
; LINE_WIDTH: 0.43629
G1 X116.396 Y132.979 E.06215
; LINE_WIDTH: 0.4364
G1 X116.396 Y130.979 E.06216
; LINE_WIDTH: 0.4366
G1 X116.396 Y126.979 E.12439
; LINE_WIDTH: 0.43671
G1 X116.396 Y124.979 E.06221
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.397 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I102.614 J-1.165 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.603 E.56212
; LINE_WIDTH: 0.44999
G3 X95.612 Y119.609 I-1.171 J-105.077 E.04396
G1 X95.604 Y120.978 E.04403
; LINE_WIDTH: 0.43622
G1 X95.604 Y121.021 E.00134
; LINE_WIDTH: 0.43636
G1 X95.604 Y123.021 E.06216
; LINE_WIDTH: 0.4365
G1 X95.604 Y125.021 E.06218
; LINE_WIDTH: 0.43664
G1 X95.604 Y127.021 E.0622
; LINE_WIDTH: 0.43678
G1 X95.604 Y129.021 E.06222
; LINE_WIDTH: 0.43692
G1 X95.603 Y131.021 E.06225
; LINE_WIDTH: 0.43706
G1 X95.603 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.603 Y135.021 E.06229
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-104.465 J1.157 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.328 Y136.391 I1.174 J105.488 E.04203
M204 S10000
G1 X116.72 Y136.74 F12000
G1 F2880
M204 S3000
G1 X116.796 Y136.586 E.0055
; object ids of layer 32 start: 47
M624 AQAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer32 end: 47
M625
G1 X116.797 Y119.468 E.55047
G1 X116.736 Y119.271 E.00663
G1 X116.52 Y119.202 E.00728
G1 X95.452 Y119.202 E.67745
G1 X95.288 Y119.25 E.0055
G1 X95.204 Y119.413 E.00589
G1 X95.202 Y136.56 E.55135
G1 X95.26 Y136.72 E.00546
G1 X95.463 Y136.798 E.00701
G1 X116.56 Y136.798 E.67837
G1 X116.663 Y136.76 E.00354
M204 S250
G1 X116.854 Y137.113 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2880
M204 S1500
G2 X116.981 Y137.045 I-.411 J-.921 E.00428
G1 X117.134 Y136.842 E.00758
G1 X117.188 Y136.545 E.00899
G1 X117.189 Y119.468 E.50866
G1 X117.134 Y119.158 E.00937
G2 X116.824 Y118.858 I-.533 J.241 E.01316
G1 X116.52 Y118.81 E.00917
G1 X95.417 Y118.81 E.62855
G1 X95.114 Y118.898 E.00939
G2 X94.833 Y119.285 I.351 J.551 E.01462
G2 X94.812 Y120.587 I22.951 J1.012 E.03877
G1 X94.81 Y136.587 E.47657
G2 X94.955 Y136.98 I.982 J-.138 E.01259
G1 X95.155 Y137.132 E.00748
G1 X95.495 Y137.19 E.01027
G1 X116.587 Y137.19 E.62823
G2 X116.798 Y137.135 I-.144 J-.999 E.00652
; WIPE_START
G1 F3600
M204 S3000
G1 X116.981 Y137.045 E-.07724
G1 X117.134 Y136.842 E-.09671
G1 X117.188 Y136.545 E-.11472
M73 P90 R1
G1 X117.188 Y136.305 E-.09132
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.8 I.054 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z6.8
G1 Z6.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2880
M204 S3000
G1 X96.28 Y135.72 E.01244
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01907
G1 X115.992 Y135.192 E.01914
; LINE_WIDTH: 0.4451
G1 X116.002 Y135.021 E.00542
; LINE_WIDTH: 0.43619
G1 X116.002 Y134.979 E.00133
; LINE_WIDTH: 0.43629
G1 X116.002 Y132.979 E.06215
; LINE_WIDTH: 0.4364
G1 X116.002 Y130.979 E.06216
; LINE_WIDTH: 0.4366
G1 X116.002 Y126.979 E.12439
; LINE_WIDTH: 0.43671
G1 X116.002 Y124.979 E.06221
; LINE_WIDTH: 0.43681
G1 X116.003 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02424
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.997 E.56212
; LINE_WIDTH: 0.44625
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.01907
G1 X95.998 Y120.979 E.02426
; LINE_WIDTH: 0.43622
G1 X95.998 Y121.021 E.00133
; LINE_WIDTH: 0.43636
G1 X95.998 Y123.021 E.06216
; LINE_WIDTH: 0.4365
G1 X95.998 Y125.021 E.06218
; LINE_WIDTH: 0.43664
G1 X95.998 Y127.021 E.0622
; LINE_WIDTH: 0.43678
G1 X95.997 Y129.021 E.06222
; LINE_WIDTH: 0.43692
G1 X95.997 Y131.021 E.06225
; LINE_WIDTH: 0.43706
G1 X95.997 Y133.021 E.06227
; LINE_WIDTH: 0.43721
G1 X95.997 Y135.021 E.06229
; LINE_WIDTH: 0.44614
G1 X96.008 Y135.192 E.00543
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00474
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F2880
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.433 E.01122
G1 X115.593 Y135.122 E.01126
G2 X115.602 Y134.979 I-.818 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01428
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01122
G1 X96.398 Y120.978 E.01431
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2880
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00564
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.00429
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.00429
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
G1 F3600
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.8 I-.513 J-1.104 P1  F12000
G1 X96.026 Y135.957 Z6.8
G1 Z6.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42192
G1 F2880
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y136.039 E-.08513
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.8 I1.217 J0 P1  F12000
G1 X96.027 Y119.961 Z6.8
G1 Z6.4
G1 E.4 F1800
; LINE_WIDTH: 0.42062
G1 F2880
M204 S3000
G1 X95.957 Y120.002 E.00244
G1 X96.027 Y120.042 E.00244
G1 X96.051 Y120.002 E.00141
; WIPE_START
G1 F6000
G1 X96.027 Y120.042 E-.08513
G1 X95.957 Y120.002 E-.14743
G1 X96.027 Y119.961 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.8 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z6.8
G1 Z6.4
G1 E.4 F1800
; LINE_WIDTH: 0.4215
G1 F2880
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y120.043 E-.08512
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z6.8 I-1.217 J0 P1  F12000
G1 X116.02 Y135.958 Z6.8
G1 Z6.4
G1 E.4 F1800
; LINE_WIDTH: 0.4206
G1 F2880
M204 S3000
G1 X115.949 Y135.998 E.00244
G1 X116.02 Y136.039 E.00244
G1 X116.043 Y135.998 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.02 Y136.039 E-.08513
G1 X115.949 Y135.998 E-.14743
G1 X116.02 Y135.958 E-.14743
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L33
M991 S0 P32 ;notify layer change


; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z6.8 I-.924 J.792 P1  F12000
G1 X116.391 Y136.391 Z6.8
G1 Z6.6
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F2902
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.476 J-1.178 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.603 E.56212
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.438 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F2902
M204 S3000
G1 X116.798 Y136.537 E.00737
G1 X116.797 Y119.468 E.54885
G1 X116.736 Y119.271 E.00664
G1 X116.519 Y119.202 E.00731
G1 X95.44 Y119.202 E.67781
G1 X95.28 Y119.26 E.00546
G1 X95.202 Y119.463 E.00701
G1 X95.202 Y136.548 E.54936
G1 X95.25 Y136.712 E.00551
G1 X95.463 Y136.798 E.00738
G1 X116.548 Y136.798 E.67799
; object ids of layer 33 start: 47
M624 AQAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer33 end: 47
M625
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2902
M204 S1500
G2 X117.132 Y136.845 I-.584 J-.804 E.01066
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.468 E.50746
G1 X117.134 Y119.157 E.0094
G2 X116.824 Y118.858 I-.532 J.242 E.01314
G1 X116.519 Y118.81 E.00919
G1 X95.413 Y118.81 E.62866
G2 X95.02 Y118.955 I.138 J.982 E.01259
G1 X94.868 Y119.155 E.00747
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.583 E.50896
G1 X94.898 Y136.886 E.0094
G2 X95.155 Y137.132 I.807 J-.586 E.01067
G1 X95.495 Y137.19 E.01027
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
G1 F3600
M204 S3000
G1 X117.054 Y136.948 E-.1078
G1 X117.132 Y136.845 E-.04889
G1 X117.19 Y136.505 E-.1311
M73 P91 R1
G1 X117.19 Y136.262 E-.09221
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7 I.051 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z7
G1 Z6.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2902
M204 S3000
G1 X96.28 Y135.72 E.01243
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02424
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.997 E.56212
; LINE_WIDTH: 0.44625
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00475
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F2902
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01428
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2902
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
G1 F3600
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7 I1.21 J-.128 P1  F12000
G1 X96.026 Y119.961 Z7
G1 Z6.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2902
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7 I-1.217 J0 P1  F12000
G1 X96.026 Y135.957 Z7
G1 Z6.6
G1 E.4 F1800
G1 F2902
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7 I0 J1.217 P1  F12000
G1 X116.021 Y135.957 Z7
G1 Z6.6
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F2902
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7 I1.217 J0 P1  F12000
G1 X116.021 Y119.961 Z7
G1 Z6.6
G1 E.4 F1800
; LINE_WIDTH: 0.42158
G1 F2902
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14743
G1 X116.021 Y119.961 E-.14743
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L34
M991 S0 P33 ;notify layer change


; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z7 I-1.217 J.027 P1  F12000
G1 X116.388 Y136.391 Z7
G1 Z6.8
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F2927
M204 S3000
G1 X116.391 Y135.227 E.03744
; LINE_WIDTH: 0.44512
G1 X116.396 Y135.021 E.00652
; LINE_WIDTH: 0.4363
G1 X116.396 Y132.979 E.06348
; LINE_WIDTH: 0.4365
G1 X116.396 Y128.979 E.12436
; LINE_WIDTH: 0.43671
G1 X116.396 Y124.979 E.12443
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.397 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I102.619 J-1.165 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.603 E.56212
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.438 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.328 Y136.391 I1.171 J104.913 E.04203
M204 S10000
G1 X116.718 Y136.74 F12000
G1 F2927
M204 S3000
G1 X116.72 Y136.74 E.00004
; object ids of layer 34 start: 47
M624 AQAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer34 end: 47
M625
G1 X116.796 Y136.586 E.00551
G1 X116.797 Y119.45 E.55102
G1 X116.727 Y119.265 E.00639
G1 X116.519 Y119.202 E.00699
G1 X95.452 Y119.202 E.67741
G1 X95.288 Y119.25 E.00551
G1 X95.202 Y119.463 E.00738
G1 X95.202 Y136.548 E.54937
G1 X95.25 Y136.712 E.0055
G1 X95.463 Y136.798 E.00738
G1 X116.56 Y136.798 E.67836
G1 X116.662 Y136.761 E.0035
M204 S250
G1 X116.854 Y137.113 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2927
M204 S1500
G2 X116.98 Y137.045 I-.411 J-.921 E.00429
G1 X117.134 Y136.842 E.00758
G1 X117.188 Y136.545 E.009
G1 X117.189 Y119.45 E.50917
G1 X117.152 Y119.202 E.00748
G1 X117.013 Y118.984 E.00771
G1 X116.824 Y118.858 E.00675
G1 X116.519 Y118.81 E.00921
G1 X95.417 Y118.81 E.62852
G1 X95.114 Y118.898 E.0094
G2 X94.868 Y119.155 I.586 J.806 E.01066
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.583 E.50898
G1 X94.898 Y136.886 E.0094
G2 X95.155 Y137.132 I.805 J-.585 E.01065
G1 X95.495 Y137.19 E.01028
G1 X116.587 Y137.19 E.62823
G2 X116.798 Y137.136 I-.144 J-.998 E.00652
; WIPE_START
G1 F3600
M204 S3000
G1 X116.98 Y137.045 E-.07728
G1 X117.134 Y136.842 E-.09675
G1 X117.188 Y136.545 E-.11477
M73 P92 R1
G1 X117.188 Y136.305 E-.0912
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.2 I.054 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z7.2
G1 Z6.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2927
M204 S3000
G1 X96.28 Y135.72 E.01243
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01907
G1 X115.992 Y135.192 E.01914
; LINE_WIDTH: 0.44512
G1 X116.002 Y135.021 E.00542
; LINE_WIDTH: 0.4363
G1 X116.002 Y132.979 E.06348
; LINE_WIDTH: 0.4365
G1 X116.002 Y128.979 E.12436
; LINE_WIDTH: 0.43671
G1 X116.002 Y124.979 E.12443
; LINE_WIDTH: 0.43681
G1 X116.003 Y122.979 E.06223
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02424
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.997 E.56212
; LINE_WIDTH: 0.44625
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00475
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F2927
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.433 E.01122
G1 X115.593 Y135.122 E.01126
G2 X115.602 Y134.979 I-.818 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01428
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2927
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.00429
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
G1 F3600
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.2 I1.21 J-.128 P1  F12000
G1 X96.026 Y119.961 Z7.2
G1 Z6.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2927
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.2 I-1.217 J0 P1  F12000
G1 X96.026 Y135.957 Z7.2
G1 Z6.8
G1 E.4 F1800
G1 F2927
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.2 I0 J1.217 P1  F12000
G1 X116.02 Y135.958 Z7.2
G1 Z6.8
G1 E.4 F1800
; LINE_WIDTH: 0.4206
G1 F2927
M204 S3000
G1 X115.949 Y135.998 E.00244
G1 X116.02 Y136.039 E.00244
G1 X116.043 Y135.998 E.00141
; WIPE_START
G1 F6000
G1 X116.02 Y136.039 E-.08513
G1 X115.949 Y135.998 E-.14743
G1 X116.02 Y135.958 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.2 I1.217 J0 P1  F12000
G1 X116.021 Y119.961 Z7.2
G1 Z6.8
G1 E.4 F1800
; LINE_WIDTH: 0.42152
G1 F2927
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y120.043 E-.08512
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L35
M991 S0 P34 ;notify layer change


; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z7.2 I-1.217 J.027 P1  F12000
G1 X116.391 Y136.391 Z7.2
G1 Z7
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F2927
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.481 J-1.178 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.603 E.56212
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.438 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F2927
M204 S3000
G1 X116.798 Y136.537 E.00738
G1 X116.797 Y119.469 E.54883
G1 X116.736 Y119.271 E.00666
G1 X116.518 Y119.202 E.00735
G1 X95.44 Y119.202 E.67777
G1 X95.28 Y119.26 E.00547
G1 X95.202 Y119.463 E.007
G1 X95.202 Y136.56 E.54975
G1 X95.261 Y136.72 E.00548
G1 X95.463 Y136.798 E.00698
G1 X116.548 Y136.798 E.67799
; object ids of layer 35 start: 47
M624 AQAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer35 end: 47
M625
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2927
M204 S1500
G2 X117.132 Y136.845 I-.584 J-.804 E.01065
G1 X117.19 Y136.505 E.01029
G1 X117.189 Y119.469 E.50744
G1 X117.133 Y119.156 E.00946
G2 X116.824 Y118.858 I-.532 J.243 E.01309
G1 X116.518 Y118.81 E.00924
G1 X95.413 Y118.81 E.62862
G2 X95.02 Y118.955 I.138 J.983 E.01259
G1 X94.868 Y119.155 E.00747
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.587 E.50908
G2 X94.955 Y136.98 I.994 J-.142 E.01259
G1 X95.155 Y137.132 E.00747
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
G1 F3600
M204 S3000
G1 X117.054 Y136.948 E-.10768
G1 X117.132 Y136.845 E-.04888
G1 X117.19 Y136.505 E-.13125
M73 P93 R1
G1 X117.19 Y136.262 E-.09219
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.4 I.051 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z7.4
G1 Z7
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2927
M204 S3000
G1 X96.28 Y135.72 E.01243
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02424
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.997 E.56212
; LINE_WIDTH: 0.44625
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00475
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F2927
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01428
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2927
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
G1 F3600
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.4 I1.21 J-.128 P1  F12000
G1 X96.026 Y119.961 Z7.4
G1 Z7
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2927
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.4 I-1.217 J0 P1  F12000
G1 X96.026 Y135.957 Z7.4
G1 Z7
G1 E.4 F1800
G1 F2927
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.4 I0 J1.217 P1  F12000
G1 X116.021 Y135.957 Z7.4
G1 Z7
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F2927
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.4 I1.217 J0 P1  F12000
G1 X116.021 Y119.961 Z7.4
G1 Z7
G1 E.4 F1800
; LINE_WIDTH: 0.4216
G1 F2927
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14743
G1 X116.021 Y119.961 E-.14743
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L36
M991 S0 P35 ;notify layer change


; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z7.4 I-1.217 J.027 P1  F12000
G1 X116.391 Y136.391 Z7.4
G1 Z7.2
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F2905
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.484 J-1.178 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.603 E.56212
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.438 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.715 Y136.742 F12000
G1 F2905
M204 S3000
G1 X116.719 Y136.74 E.00016
; object ids of layer 36 start: 47
M624 AQAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer36 end: 47
M625
G1 X116.798 Y136.537 E.00701
G1 X116.797 Y119.451 E.54941
G1 X116.727 Y119.265 E.00639
G1 X116.517 Y119.202 E.00704
G1 X95.441 Y119.202 E.67773
G1 X95.28 Y119.26 E.00547
G1 X95.202 Y119.463 E.00701
G1 X95.202 Y136.548 E.54937
G1 X95.251 Y136.712 E.0055
G1 X95.463 Y136.798 E.00738
G1 X116.56 Y136.798 E.67836
G1 X116.658 Y136.762 E.00337
M204 S250
G1 X116.85 Y137.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2905
M204 S1500
G2 X116.98 Y137.045 I-.401 J-.907 E.0044
G1 X117.132 Y136.845 E.00748
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.451 E.50797
G1 X117.152 Y119.202 E.00748
G1 X117.013 Y118.984 E.0077
G1 X116.824 Y118.858 E.00676
G1 X116.517 Y118.81 E.00926
G1 X95.414 Y118.81 E.62859
G2 X95.02 Y118.955 I.138 J.982 E.0126
G1 X94.868 Y119.155 E.00748
G1 X94.81 Y119.495 E.01027
G1 X94.81 Y136.583 E.50898
G1 X94.898 Y136.886 E.00939
G2 X95.155 Y137.132 I.805 J-.585 E.01065
G1 X95.495 Y137.19 E.01028
G1 X116.587 Y137.19 E.62823
G2 X116.795 Y137.137 I-.138 J-.982 E.0064
; WIPE_START
G1 F3600
M204 S3000
G1 X116.98 Y137.045 E-.07877
G1 X117.132 Y136.845 E-.09548
G1 X117.19 Y136.505 E-.13109
M73 P94 R1
G1 X117.19 Y136.308 E-.07467
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.6 I.052 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z7.6
G1 Z7.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2905
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02424
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.997 E.56212
; LINE_WIDTH: 0.44625
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F2905
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01428
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2905
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.793 Y134.994 E.41618
; WIPE_START
G1 F3600
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.6 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z7.6
G1 Z7.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2905
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.6 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z7.6
G1 Z7.2
G1 E.4 F1800
G1 F2905
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.6 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z7.6
G1 Z7.2
G1 E.4 F1800
; LINE_WIDTH: 0.4216
G1 F2905
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14743
G1 X116.021 Y119.961 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.6 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z7.6
G1 Z7.2
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F2905
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L37
M991 S0 P36 ;notify layer change


; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z7.6 I-.927 J.789 P1  F12000
G1 X116.391 Y136.391 Z7.6
G1 Z7.4
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F2881
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.486 J-1.178 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.603 E.56212
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.271 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.715 Y136.742 F12000
M73 P94 R0
G1 F2881
M204 S3000
G1 X116.719 Y136.74 E.00015
; object ids of layer 37 start: 47
M624 AQAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer37 end: 47
M625
G1 X116.798 Y136.537 E.00701
G1 X116.797 Y119.469 E.54883
G1 X116.736 Y119.271 E.00665
G1 X116.544 Y119.202 E.00656
G1 X95.452 Y119.202 E.67824
G1 X95.288 Y119.251 E.00551
G1 X95.202 Y119.463 E.00738
G1 X95.202 Y136.548 E.54937
G1 X95.25 Y136.712 E.0055
G1 X95.463 Y136.798 E.00738
G1 X116.559 Y136.798 E.67836
G1 X116.659 Y136.762 E.00339
M204 S250
G1 X116.85 Y137.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2881
M204 S1500
G2 X116.98 Y137.045 I-.401 J-.906 E.0044
G1 X117.132 Y136.845 E.00748
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.469 E.50743
G1 X117.133 Y119.155 E.00951
G2 X116.824 Y118.858 I-.531 J.244 E.01304
G1 X116.517 Y118.81 E.00928
G1 X95.417 Y118.81 E.62846
G1 X95.114 Y118.898 E.0094
G2 X94.868 Y119.155 I.586 J.806 E.01066
G1 X94.81 Y119.495 E.01028
G1 X94.81 Y136.583 E.50897
G1 X94.898 Y136.886 E.0094
G2 X95.155 Y137.132 I.807 J-.588 E.01066
G1 X95.495 Y137.19 E.01027
G1 X116.586 Y137.19 E.62822
G2 X116.795 Y137.137 I-.137 J-.981 E.00641
; WIPE_START
G1 F3600
M204 S3000
G1 X116.98 Y137.045 E-.07872
G1 X117.132 Y136.845 E-.09543
G1 X117.19 Y136.505 E-.13115
G1 X117.19 Y136.308 E-.0747
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.8 I.052 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z7.8
G1 Z7.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2881
M204 S3000
G1 X96.28 Y135.72 E.01146
M73 P95 R0
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02424
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.997 E.56212
; LINE_WIDTH: 0.44625
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F2881
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01428
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2881
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.793 Y134.994 E.41618
; WIPE_START
G1 F3600
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.8 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z7.8
G1 Z7.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2881
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.8 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z7.8
G1 Z7.4
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F2881
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.8 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z7.8
G1 Z7.4
G1 E.4 F1800
; LINE_WIDTH: 0.4216
G1 F2881
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14743
G1 X116.021 Y119.961 E-.14743
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z7.8 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z7.8
G1 Z7.4
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F2881
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L38
M991 S0 P37 ;notify layer change


; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z7.8 I-.927 J.789 P1  F12000
G1 X116.391 Y136.391 Z7.8
G1 Z7.6
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F2902
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43728
G1 X116.397 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.397 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.397 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.488 J-1.178 E.04403
G1 X115.021 Y119.603 E.04401
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.603 E.56212
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.271 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.712 Y136.749 F12000
G1 F2902
M204 S3000
G1 X116.798 Y136.537 E.00738
G1 X116.797 Y119.469 E.5488
G1 X116.737 Y119.271 E.00666
G1 X116.544 Y119.202 E.00659
G1 X95.44 Y119.202 E.67859
G1 X95.28 Y119.26 E.00548
G1 X95.202 Y119.463 E.00701
G1 X95.202 Y136.56 E.54975
G1 X95.26 Y136.72 E.00547
G1 X95.463 Y136.798 E.007
G1 X116.548 Y136.798 E.67799
; object ids of layer 38 start: 47
M624 AQAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer38 end: 47
M625
G1 X116.655 Y136.766 E.00358
M204 S250
G1 X116.886 Y137.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2902
M204 S1500
G2 X117.132 Y136.845 I-.583 J-.804 E.01066
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.469 E.50741
G1 X117.132 Y119.153 E.00958
G2 X116.824 Y118.858 I-.53 J.246 E.01299
G1 X116.516 Y118.81 E.0093
G1 X95.414 Y118.81 E.62855
G2 X95.02 Y118.955 I.138 J.982 E.0126
G1 X94.868 Y119.155 E.00747
G1 X94.81 Y119.495 E.01029
G1 X94.81 Y136.587 E.50909
G2 X94.955 Y136.98 I.988 J-.14 E.01259
G1 X95.155 Y137.132 E.00747
G1 X95.495 Y137.19 E.01028
G1 X116.583 Y137.19 E.62811
G1 X116.828 Y137.119 E.00761
; WIPE_START
G1 F3600
M204 S3000
G1 X117.054 Y136.948 E-.10776
G1 X117.132 Y136.845 E-.04888
G1 X117.19 Y136.505 E-.13118
G1 X117.19 Y136.262 E-.09218
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8 I.051 J-1.216 P1  F12000
G1 X96.103 Y135.376 Z8
G1 Z7.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2902
M204 S3000
G1 X96.28 Y135.72 E.01243
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
M73 P96 R0
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43728
G1 X116.003 Y132.979 E.06364
; LINE_WIDTH: 0.43717
G1 X116.003 Y126.979 E.18686
; LINE_WIDTH: 0.43706
G1 X116.003 Y120.979 E.18681
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02424
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.997 E.56212
; LINE_WIDTH: 0.44625
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.075 Y135.323 E.00475
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F2902
M204 S3000
G1 X96.568 Y135.432 E.00842
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01428
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.398 Y135.021 E.45156
G1 X96.407 Y135.122 E.00324
G1 X96.42 Y135.146 E.0009
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2902
M204 S1500
G1 X96.845 Y135.155 E.0043
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.961 E.41521
; WIPE_START
G1 F3600
M204 S3000
G1 X96.845 Y135.155 E-.0764
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.633 Y135.21 E-.23246
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8 I1.21 J-.128 P1  F12000
G1 X96.026 Y119.961 Z8
G1 Z7.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42196
G1 F2902
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8 I-1.217 J0 P1  F12000
G1 X96.026 Y135.957 Z8
G1 Z7.6
G1 E.4 F1800
; LINE_WIDTH: 0.42198
G1 F2902
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8 I0 J1.217 P1  F12000
G1 X116.021 Y135.957 Z8
G1 Z7.6
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F2902
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8 I1.217 J0 P1  F12000
G1 X116.021 Y119.961 Z8
G1 Z7.6
G1 E.4 F1800
; LINE_WIDTH: 0.42162
G1 F2902
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14743
G1 X116.021 Y119.961 E-.14743
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L39
M991 S0 P38 ;notify layer change


; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z8 I-1.217 J.027 P1  F12000
G1 X116.391 Y136.391 Z8
G1 Z7.8
G1 E.4 F1800
; LINE_WIDTH: 0.44999
G1 F2905
M204 S3000
G1 X116.393 Y135.227 E.03744
; LINE_WIDTH: 0.44621
G1 X116.397 Y135.021 E.00654
; LINE_WIDTH: 0.43722
G1 X116.397 Y128.979 E.18822
; LINE_WIDTH: 0.43708
G1 X116.397 Y120.979 E.24909
; LINE_WIDTH: 0.44999
G3 X116.39 Y119.609 I103.65 J-1.178 E.04403
G1 X115.021 Y119.603 E.04402
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.603 E.56212
; LINE_WIDTH: 0.44999
G3 X95.609 Y119.609 I-1.173 J-105.271 E.04403
G1 X95.603 Y120.979 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y135.021 E.4375
; LINE_WIDTH: 0.44999
G3 X95.609 Y136.391 I-105.437 J1.173 E.04403
G1 X96.979 Y136.397 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.397 E.56212
; LINE_WIDTH: 0.44999
G3 X116.331 Y136.391 I1.173 J105.269 E.04211
M204 S10000
G1 X116.715 Y136.742 F12000
G1 F2905
M204 S3000
G1 X116.72 Y136.74 E.00016
; object ids of layer 39 start: 47
M624 AQAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer39 end: 47
M625
G1 X116.798 Y136.537 E.00701
G1 X116.797 Y119.461 E.54908
G1 X116.732 Y119.268 E.00654
G1 X116.515 Y119.202 E.00728
G1 X95.452 Y119.202 E.6773
G1 X95.288 Y119.251 E.00551
G1 X95.202 Y119.464 E.00738
G1 X95.202 Y136.548 E.54937
G1 X95.251 Y136.712 E.00551
G1 X95.463 Y136.798 E.00738
G1 X116.559 Y136.798 E.67835
G1 X116.659 Y136.762 E.00339
M204 S250
G1 X116.85 Y137.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2905
M204 S1500
G2 X116.98 Y137.045 I-.401 J-.907 E.00441
G1 X117.132 Y136.845 E.00746
G1 X117.19 Y136.505 E.01029
G1 X117.189 Y119.461 E.50767
G2 X116.824 Y118.858 I-.656 J-.014 E.02214
G1 X116.515 Y118.81 E.00932
G1 X95.417 Y118.81 E.62842
G1 X95.114 Y118.898 E.00941
G2 X94.868 Y119.155 I.585 J.805 E.01064
G1 X94.81 Y119.495 E.01029
G1 X94.81 Y136.583 E.50897
G1 X94.898 Y136.886 E.00941
G2 X95.155 Y137.132 I.804 J-.585 E.01064
G1 X95.495 Y137.19 E.01029
G1 X116.586 Y137.19 E.62822
G2 X116.795 Y137.137 I-.138 J-.982 E.00641
; WIPE_START
G1 F3600
M204 S3000
G1 X116.98 Y137.045 E-.0788
G1 X117.132 Y136.845 E-.09521
G1 X117.19 Y136.505 E-.13127
G1 X117.19 Y136.308 E-.07472
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8.2 I.052 J-1.216 P1  F12000
G1 X96.117 Y135.403 Z8.2
G1 Z7.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2905
M204 S3000
G1 X96.28 Y135.72 E.01146
G1 X96.979 Y136.003 E.02423
; LINE_WIDTH: 0.43732
G1 X115.021 Y136.003 E.56212
; LINE_WIDTH: 0.44625
G1 X115.192 Y135.992 E.00544
; LINE_WIDTH: 0.44999
M73 P97 R0
G1 X115.72 Y135.72 E.01911
G1 X115.992 Y135.192 E.01911
; LINE_WIDTH: 0.44621
G1 X116.003 Y135.021 E.00543
; LINE_WIDTH: 0.43722
G1 X116.003 Y128.979 E.18822
; LINE_WIDTH: 0.43708
G1 X116.003 Y120.979 E.24909
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02424
G1 X115.021 Y119.997 E.02422
; LINE_WIDTH: 0.43732
G1 X96.979 Y119.997 E.56212
; LINE_WIDTH: 0.44625
G1 X96.808 Y120.008 E.00544
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.01911
G1 X95.997 Y120.979 E.02423
; LINE_WIDTH: 0.43732
G1 X95.997 Y135.021 E.4375
; LINE_WIDTH: 0.44625
G1 X96.008 Y135.192 E.00544
; LINE_WIDTH: 0.44999
G1 X96.089 Y135.35 E.00572
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F2905
M204 S3000
G1 X96.568 Y135.432 E.00745
G1 X96.979 Y135.602 E.01429
G1 X115.021 Y135.602 E.58018
G1 X115.122 Y135.593 E.00324
G1 X115.432 Y135.432 E.01124
G1 X115.593 Y135.122 E.01124
G2 X115.602 Y134.979 I-.82 J-.122 E.00462
G1 X115.602 Y120.979 E.45018
G1 X115.432 Y120.568 E.01429
G1 X115.021 Y120.398 E.01428
G1 X96.979 Y120.398 E.58018
G1 X96.878 Y120.407 E.00324
G1 X96.568 Y120.568 E.01124
G1 X96.398 Y120.979 E.01429
G1 X96.407 Y135.122 E.45478
G1 X96.433 Y135.173 E.00187
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2905
M204 S1500
G1 X96.845 Y135.155 E.00338
G2 X97.021 Y135.21 I.155 J-.185 E.00565
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00564
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.0043
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.793 Y134.994 E.41618
; WIPE_START
G1 F3600
M204 S3000
G1 X96.845 Y135.155 E-.06424
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.665 Y135.21 E-.24461
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8.2 I-.505 J-1.107 P1  F12000
G1 X96.026 Y135.957 Z8.2
G1 Z7.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2905
M204 S3000
G1 X95.955 Y135.998 E.00246
G1 X96.026 Y136.039 E.00246
G1 X96.05 Y135.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y136.039 E-.08512
G1 X95.955 Y135.998 E-.14744
G1 X96.026 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8.2 I1.217 J0 P1  F12000
G1 X96.026 Y119.961 Z8.2
G1 Z7.8
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F2905
M204 S3000
G1 X95.955 Y120.002 E.00246
G1 X96.026 Y120.043 E.00246
G1 X96.05 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y120.043 E-.08512
G1 X95.955 Y120.002 E-.14744
G1 X96.026 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8.2 I0 J1.217 P1  F12000
G1 X116.021 Y119.961 Z8.2
G1 Z7.8
G1 E.4 F1800
; LINE_WIDTH: 0.42164
G1 F2905
M204 S3000
G1 X115.95 Y120.002 E.00245
G1 X116.021 Y120.043 E.00245
G1 X116.045 Y120.002 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y120.043 E-.08513
G1 X115.95 Y120.002 E-.14744
G1 X116.021 Y119.961 E-.14744
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8.2 I-1.217 J0 P1  F12000
G1 X116.021 Y135.957 Z8.2
G1 Z7.8
G1 E.4 F1800
; LINE_WIDTH: 0.42196
G1 F2905
M204 S3000
G1 X115.95 Y135.998 E.00246
G1 X116.021 Y136.039 E.00246
G1 X116.045 Y135.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y136.039 E-.08512
G1 X115.95 Y135.998 E-.14744
G1 X116.021 Y135.957 E-.14744
; WIPE_END
G1 E-.02 F1800
; stop printing object, unique label id: 47
M625
;======== P2S layer_change gcode ==========
;===== 2026/05/15 ====





; update layer progress
M73 L40
M991 S0 P39 ;notify layer change


M106 S147.9
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z8.2 I-.99 J.708 P1  F12000
G1 X116.85 Y137.115 Z8.2
G1 Z8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G2 X116.98 Y137.045 I-.401 J-.908 E.00442
; object ids of layer 40 start: 47
M624 AQAAAAAAAAA=
;======== P2S timelapes gcode ==========
;===== 2025/06/16 ====
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
  M971 S11 C10 O0
  M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer40 end: 47
M625
G1 X117.132 Y136.845 E.00747
G1 X117.19 Y136.505 E.01028
G1 X117.189 Y119.451 E.50797
G1 X117.152 Y119.202 E.00749
G1 X117.012 Y118.983 E.00775
G1 X116.752 Y118.845 E.00876
G1 X116.53 Y118.811 E.0067
G1 X95.413 Y118.81 E.62898
G2 X95.02 Y118.955 I.143 J.995 E.01258
G1 X94.866 Y119.158 E.0076
G1 X94.812 Y119.455 E.009
G1 X94.81 Y136.583 E.51016
G1 X94.898 Y136.886 E.00939
G2 X95.155 Y137.132 I.804 J-.583 E.01065
G1 X95.495 Y137.19 E.01029
G1 X116.586 Y137.19 E.62821
G2 X116.794 Y137.137 I-.138 J-.984 E.0064
; WIPE_START
M204 S3000
G1 X116.98 Y137.045 E-.07899
G1 X117.132 Y136.845 E-.09525
G1 X117.19 Y136.505 E-.13121
G1 X117.19 Y136.309 E-.07456
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8.4 I.076 J-1.215 P1  F12000
G1 X96.791 Y135.024 Z8.4
G1 Z8
G1 E.4 F1800
G1 F3600
M204 S1500
G1 X96.845 Y135.155 E.00421
G2 X97.021 Y135.21 I.155 J-.185 E.00564
G1 X115.021 Y135.21 E.53614
G1 X115.155 Y135.155 E.0043
G2 X115.21 Y134.979 I-.185 J-.155 E.00565
G1 X115.21 Y120.979 E.417
G1 X115.155 Y120.845 E.0043
G2 X114.979 Y120.79 I-.155 J.185 E.00565
G1 X96.979 Y120.79 E.53614
G1 X96.845 Y120.845 E.00429
G2 X96.79 Y121.021 I.185 J.155 E.00565
G1 X96.79 Y134.964 E.4153
; WIPE_START
M204 S3000
G1 X96.845 Y135.155 E-.07537
G1 X96.979 Y135.21 E-.05483
G1 X97.021 Y135.21 E-.01631
G1 X97.636 Y135.21 E-.23348
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8.4 I-.08 J1.214 P1  F12000
G1 X116.983 Y136.481 Z8.4
G1 Z8
G1 E.4 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F3600
M204 S2000
G1 X116.481 Y136.983 E.02112
G1 X116.348 Y137.116
G1 X115.814 Y137.116
G1 X115.948 Y136.983
G1 X116.983 Y135.948 E.04358
G1 X117.116 Y135.814
G1 X117.116 Y135.281
G1 X116.983 Y135.415
G1 X115.415 Y136.983 E.06605
G1 X115.281 Y137.116
G1 X114.748 Y137.116
G1 X114.881 Y136.983
G1 X116.983 Y134.881 E.08851
G1 X117.116 Y134.748
G1 X117.116 Y134.215
G1 X116.983 Y134.348
G1 X114.348 Y136.983 E.11097
G1 X114.215 Y137.116
G1 X113.681 Y137.116
G1 X113.815 Y136.983
G1 X116.983 Y133.815 E.13343
G1 X117.116 Y133.681
G1 X117.116 Y133.148
G1 X116.983 Y133.282
G1 X115.417 Y134.847 E.06593
G1 X115.284 Y134.981
G1 X115.284 Y134.447
G1 X115.417 Y134.314
G1 X116.982 Y132.749 E.06593
G1 X117.116 Y132.615
G1 X117.116 Y132.082
G1 X116.982 Y132.215
G1 X115.417 Y133.78 E.06593
G1 X115.284 Y133.914
G1 X115.284 Y133.381
G1 X115.417 Y133.247
G1 X116.982 Y131.682 E.06593
G1 X117.116 Y131.548
G1 X117.116 Y131.015
G1 X116.982 Y131.149
G1 X115.417 Y132.714 E.06593
G1 X115.284 Y132.848
G1 X115.284 Y132.314
G1 X115.417 Y132.181
G1 X116.982 Y130.616 E.06593
G1 X117.116 Y130.482
G1 X117.116 Y129.949
G1 X116.982 Y130.082
G1 X115.417 Y131.647 E.06593
G1 X115.284 Y131.781
G1 X115.284 Y131.248
G1 X115.417 Y131.114
G1 X116.982 Y129.549 E.06592
G1 X117.116 Y129.415
G1 X117.116 Y128.882
G1 X116.982 Y129.016
G1 X115.417 Y130.581 E.06592
G1 X115.284 Y130.714
G1 X115.284 Y130.181
G1 X115.417 Y130.048
G1 X116.982 Y128.483 E.06592
G1 X117.116 Y128.349
G1 X117.116 Y127.816
G1 X116.982 Y127.949
G1 X115.417 Y129.514 E.06592
G1 X115.284 Y129.648
G1 X115.284 Y129.115
G1 X115.417 Y128.981
G1 X116.982 Y127.416 E.06592
G1 X117.116 Y127.283
G1 X117.116 Y126.749
G1 X116.982 Y126.883
G1 X115.417 Y128.448 E.06592
G1 X115.284 Y128.581
G1 X115.284 Y128.048
G1 X115.417 Y127.915
G1 X116.982 Y126.35 E.06592
G1 X117.116 Y126.216
G1 X117.116 Y125.683
G1 X116.982 Y125.816
G1 X115.417 Y127.381 E.06592
G1 X115.284 Y127.515
G1 X115.284 Y126.982
G1 X115.417 Y126.848
G1 X116.982 Y125.283 E.06592
G1 X117.116 Y125.15
G1 X117.116 Y124.616
G1 X116.982 Y124.75
G1 X115.417 Y126.315 E.06592
G1 X115.284 Y126.448
G1 X115.284 Y125.915
G1 X115.417 Y125.782
G1 X116.982 Y124.217 E.06592
G1 X117.116 Y124.083
G1 X117.116 Y123.55
G1 X116.982 Y123.683
G1 X115.417 Y125.248 E.06592
G1 X115.284 Y125.382
G1 X115.284 Y124.849
G1 X115.417 Y124.715
G1 X116.982 Y123.15 E.06592
G1 X117.116 Y123.017
G1 X117.116 Y122.483
G1 X116.982 Y122.617
G1 X115.417 Y124.182 E.06591
G1 X115.284 Y124.315
G1 X115.284 Y123.782
G1 X115.417 Y123.649
G1 X116.982 Y122.084 E.06591
G1 X117.116 Y121.95
G1 X117.116 Y121.417
G1 X116.982 Y121.551
G1 X115.417 Y123.115 E.06591
G1 X115.284 Y123.249
M73 P98 R0
G1 X115.284 Y122.716
G1 X115.417 Y122.582
G1 X116.982 Y121.017 E.06591
G1 X117.116 Y120.884
G1 X117.116 Y120.35
G1 X116.982 Y120.484
G1 X115.417 Y122.049 E.06591
G1 X115.284 Y122.182
G1 X115.284 Y121.649
G1 X115.417 Y121.515
G1 X116.982 Y119.951 E.06591
G1 X117.116 Y119.817
G1 X117.116 Y119.284
G1 X116.982 Y119.418
G1 X115.417 Y120.982 E.06591
G1 X115.284 Y121.116
G1 X115.074 Y120.792
G1 X115.208 Y120.658
G1 X116.787 Y119.079 E.06653
G1 X116.921 Y118.945
G1 X116.449 Y118.884
G1 X116.315 Y119.018
G1 X114.75 Y120.583 E.06591
G1 X114.617 Y120.716
G1 X114.084 Y120.716
G1 X114.217 Y120.583
G1 X115.782 Y119.018 E.06591
G1 X115.916 Y118.884
G1 X115.382 Y118.884
G1 X115.249 Y119.018
G1 X113.684 Y120.583 E.06591
G1 X113.55 Y120.716
G1 X113.017 Y120.716
G1 X113.151 Y120.583
G1 X114.715 Y119.018 E.06591
G1 X114.849 Y118.884
G1 X114.316 Y118.884
G1 X114.182 Y119.018
G1 X112.617 Y120.583 E.06591
G1 X112.484 Y120.716
G1 X111.951 Y120.716
G1 X112.084 Y120.583
G1 X113.649 Y119.018 E.06591
G1 X113.783 Y118.884
G1 X113.249 Y118.884
G1 X113.116 Y119.018
G1 X111.551 Y120.583 E.06591
G1 X111.417 Y120.716
G1 X110.884 Y120.716
G1 X111.018 Y120.583
G1 X112.582 Y119.018 E.06591
G1 X112.716 Y118.884
G1 X112.183 Y118.884
G1 X112.049 Y119.018
G1 X110.484 Y120.583 E.06592
G1 X110.351 Y120.716
G1 X109.817 Y120.716
G1 X109.951 Y120.583
G1 X111.516 Y119.018 E.06592
G1 X111.65 Y118.884
G1 X111.116 Y118.884
G1 X110.983 Y119.018
G1 X109.418 Y120.583 E.06592
G1 X109.284 Y120.716
G1 X108.751 Y120.716
G1 X108.885 Y120.583
G1 X110.449 Y119.018 E.06592
G1 X110.583 Y118.884
G1 X110.05 Y118.884
G1 X109.916 Y119.018
G1 X108.351 Y120.583 E.06592
G1 X108.218 Y120.716
G1 X107.684 Y120.716
G1 X107.818 Y120.583
G1 X109.383 Y119.018 E.06592
G1 X109.517 Y118.884
G1 X108.983 Y118.884
G1 X108.85 Y119.018
G1 X107.285 Y120.583 E.06592
G1 X107.151 Y120.716
G1 X106.618 Y120.716
G1 X106.752 Y120.583
G1 X108.316 Y119.018 E.06592
G1 X108.45 Y118.884
G1 X107.917 Y118.884
G1 X107.783 Y119.018
G1 X106.218 Y120.583 E.06592
G1 X106.085 Y120.716
G1 X105.551 Y120.716
G1 X105.685 Y120.583
G1 X107.25 Y119.018 E.06592
G1 X107.384 Y118.884
G1 X106.85 Y118.884
G1 X106.717 Y119.018
G1 X105.152 Y120.583 E.06592
G1 X105.018 Y120.716
G1 X104.485 Y120.716
G1 X104.619 Y120.583
G1 X106.184 Y119.018 E.06592
G1 X106.317 Y118.884
G1 X105.784 Y118.884
G1 X105.65 Y119.018
G1 X104.085 Y120.583 E.06592
G1 X103.952 Y120.716
G1 X103.418 Y120.716
G1 X103.552 Y120.583
G1 X105.117 Y119.018 E.06592
G1 X105.251 Y118.884
G1 X104.717 Y118.884
G1 X104.584 Y119.018
G1 X103.019 Y120.583 E.06592
G1 X102.885 Y120.716
G1 X102.352 Y120.716
G1 X102.486 Y120.583
G1 X104.051 Y119.018 E.06593
G1 X104.184 Y118.884
G1 X103.651 Y118.884
G1 X103.517 Y119.018
G1 X101.952 Y120.583 E.06593
G1 X101.819 Y120.716
G1 X101.285 Y120.716
G1 X101.419 Y120.583
G1 X102.984 Y119.018 E.06593
G1 X103.118 Y118.884
G1 X102.584 Y118.884
G1 X102.451 Y119.018
G1 X100.886 Y120.583 E.06593
G1 X100.752 Y120.716
G1 X100.219 Y120.716
G1 X100.352 Y120.583
G1 X101.918 Y119.018 E.06593
G1 X102.051 Y118.884
G1 X101.518 Y118.884
G1 X101.384 Y119.018
G1 X99.819 Y120.583 E.06593
G1 X99.686 Y120.716
G1 X99.152 Y120.716
G1 X99.286 Y120.583
G1 X100.851 Y119.018 E.06593
G1 X100.985 Y118.884
G1 X100.451 Y118.884
G1 X100.318 Y119.018
G1 X98.753 Y120.583 E.06593
G1 X98.619 Y120.716
G1 X98.086 Y120.716
G1 X98.219 Y120.583
G1 X99.785 Y119.018 E.06593
G1 X99.918 Y118.884
G1 X99.385 Y118.884
G1 X99.251 Y119.017
G1 X97.686 Y120.583 E.06593
G1 X97.553 Y120.716
G1 X97.019 Y120.716
G1 X97.153 Y120.583
G1 X98.718 Y119.017 E.06593
; WIPE_START
M204 S3000
G1 X98.011 Y119.725 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8.4 I-.83 J.89 P1  F12000
G1 X114.847 Y135.417 Z8.4
G1 Z8
G1 E.4 F1800
G1 F3600
M204 S2000
G1 X113.282 Y136.983 E.06594
G1 X113.148 Y137.116
G1 X112.615 Y137.116
G1 X112.748 Y136.983
G1 X114.314 Y135.417 E.06594
G1 X114.447 Y135.284
G1 X113.914 Y135.284
G1 X113.78 Y135.417
G1 X112.215 Y136.983 E.06593
G1 X112.082 Y137.116
G1 X111.548 Y137.116
G1 X111.682 Y136.983
G1 X113.247 Y135.417 E.06594
G1 X113.381 Y135.284
G1 X112.848 Y135.284
G1 X112.714 Y135.417
G1 X111.149 Y136.983 E.06594
G1 X111.015 Y137.116
G1 X110.482 Y137.116
G1 X110.615 Y136.983
G1 X112.181 Y135.417 E.06594
G1 X112.314 Y135.284
G1 X111.781 Y135.284
G1 X111.647 Y135.417
G1 X110.082 Y136.983 E.06594
G1 X109.948 Y137.116
G1 X109.415 Y137.116
G1 X109.549 Y136.983
G1 X111.114 Y135.417 E.06594
G1 X111.248 Y135.284
G1 X110.714 Y135.284
G1 X110.581 Y135.417
G1 X109.016 Y136.983 E.06594
G1 X108.882 Y137.116
G1 X108.349 Y137.116
G1 X108.482 Y136.983
G1 X110.048 Y135.417 E.06594
G1 X110.181 Y135.284
G1 X109.648 Y135.284
G1 X109.514 Y135.417
G1 X107.949 Y136.983 E.06594
G1 X107.815 Y137.116
G1 X107.282 Y137.116
G1 X107.416 Y136.983
G1 X108.981 Y135.417 E.06594
G1 X109.115 Y135.284
G1 X108.581 Y135.284
G1 X108.448 Y135.417
G1 X106.883 Y136.983 E.06594
G1 X106.749 Y137.116
G1 X106.216 Y137.116
G1 X106.349 Y136.983
G1 X107.915 Y135.417 E.06594
G1 X108.048 Y135.284
G1 X107.515 Y135.284
G1 X107.381 Y135.417
G1 X105.816 Y136.983 E.06594
G1 X105.682 Y137.116
G1 X105.149 Y137.116
G1 X105.283 Y136.983
G1 X106.848 Y135.417 E.06594
G1 X106.982 Y135.284
G1 X106.448 Y135.284
G1 X106.315 Y135.417
G1 X104.75 Y136.983 E.06594
G1 X104.616 Y137.116
G1 X104.083 Y137.116
G1 X104.216 Y136.983
G1 X105.782 Y135.417 E.06593
G1 X105.915 Y135.284
G1 X105.382 Y135.284
G1 X105.248 Y135.417
G1 X103.683 Y136.983 E.06593
G1 X103.549 Y137.116
G1 X103.016 Y137.116
G1 X103.15 Y136.983
G1 X104.715 Y135.417 E.06593
G1 X104.849 Y135.284
G1 X104.315 Y135.284
G1 X104.182 Y135.417
G1 X102.617 Y136.983 E.06593
G1 X102.483 Y137.116
G1 X101.95 Y137.116
G1 X102.083 Y136.983
G1 X103.648 Y135.417 E.06593
G1 X103.782 Y135.284
G1 X103.249 Y135.284
G1 X103.115 Y135.417
G1 X101.55 Y136.983 E.06593
G1 X101.416 Y137.116
G1 X100.883 Y137.116
G1 X101.017 Y136.983
G1 X102.582 Y135.417 E.06593
G1 X102.716 Y135.284
G1 X102.182 Y135.284
G1 X102.049 Y135.417
G1 X100.483 Y136.983 E.06594
G1 X100.35 Y137.116
G1 X99.817 Y137.116
G1 X99.95 Y136.983
G1 X101.515 Y135.417 E.06594
G1 X101.649 Y135.284
G1 X101.116 Y135.284
G1 X100.982 Y135.417
G1 X99.417 Y136.983 E.06594
G1 X99.283 Y137.116
G1 X98.75 Y137.116
G1 X98.884 Y136.983
G1 X100.449 Y135.417 E.06594
G1 X100.583 Y135.284
G1 X100.049 Y135.284
G1 X99.916 Y135.417
G1 X98.35 Y136.983 E.06594
G1 X98.217 Y137.116
G1 X97.684 Y137.116
G1 X97.817 Y136.983
G1 X99.382 Y135.417 E.06594
G1 X99.516 Y135.284
G1 X98.983 Y135.284
G1 X98.849 Y135.417
G1 X97.284 Y136.983 E.06594
G1 X97.15 Y137.116
M73 P99 R0
G1 X96.617 Y137.116
G1 X96.751 Y136.983
G1 X98.316 Y135.417 E.06594
G1 X98.45 Y135.284
G1 X97.916 Y135.284
G1 X97.783 Y135.417
G1 X96.217 Y136.983 E.06594
G1 X96.084 Y137.116
G1 X95.551 Y137.116
G1 X95.684 Y136.983
G1 X97.249 Y135.417 E.06594
G1 X97.383 Y135.284
G1 X96.926 Y135.208
G1 X96.792 Y135.342
G1 X95.216 Y136.918 E.06639
G1 X95.082 Y137.051
G1 X94.887 Y136.714
G1 X95.02 Y136.58
G1 X96.583 Y135.018 E.06582
G1 X96.716 Y134.884
G1 X96.716 Y134.351
G1 X96.583 Y134.484
G1 X95.017 Y136.05 E.06593
G1 X94.884 Y136.183
G1 X94.884 Y135.65
G1 X95.018 Y135.516
G1 X96.583 Y133.951 E.06593
G1 X96.716 Y133.817
G1 X96.716 Y133.284
G1 X96.583 Y133.418
G1 X95.018 Y134.983 E.06593
G1 X94.884 Y135.117
G1 X94.884 Y134.583
G1 X95.018 Y134.45
G1 X96.583 Y132.885 E.06592
G1 X96.716 Y132.751
G1 X96.716 Y132.218
G1 X96.583 Y132.351
G1 X95.018 Y133.916 E.06592
G1 X94.884 Y134.05
G1 X94.884 Y133.517
G1 X95.018 Y133.383
G1 X96.583 Y131.818 E.06592
G1 X96.716 Y131.684
G1 X96.716 Y131.151
G1 X96.583 Y131.285
G1 X95.018 Y132.85 E.06591
G1 X94.884 Y132.983
G1 X94.884 Y132.45
G1 X95.018 Y132.316
G1 X96.583 Y130.752 E.06591
G1 X96.716 Y130.618
G1 X96.716 Y130.085
G1 X96.583 Y130.218
G1 X95.018 Y131.783 E.06591
G1 X94.884 Y131.917
G1 X94.884 Y131.383
G1 X95.018 Y131.25
G1 X96.583 Y129.685 E.0659
G1 X96.716 Y129.551
G1 X96.716 Y129.018
G1 X96.583 Y129.152
G1 X95.018 Y130.716 E.0659
G1 X94.885 Y130.85
G1 X94.885 Y130.317
G1 X95.018 Y130.183
G1 X96.583 Y128.619 E.0659
G1 X96.716 Y128.485
G1 X96.716 Y127.952
G1 X96.583 Y128.085
G1 X95.018 Y129.65 E.06589
G1 X94.885 Y129.783
G1 X94.885 Y129.25
G1 X95.018 Y129.116
G1 X96.583 Y127.552 E.06589
G1 X96.716 Y127.418
G1 X96.716 Y126.885
G1 X96.583 Y127.019
G1 X95.019 Y128.583 E.06589
G1 X94.885 Y128.717
G1 X94.885 Y128.183
G1 X95.019 Y128.05
G1 X96.583 Y126.486 E.06589
G1 X96.716 Y126.352
G1 X96.716 Y125.819
G1 X96.583 Y125.952
G1 X95.019 Y127.516 E.06588
G1 X94.885 Y127.65
G1 X94.885 Y127.117
G1 X95.019 Y126.983
G1 X96.583 Y125.419 E.06588
G1 X96.716 Y125.285
G1 X96.716 Y124.752
G1 X96.583 Y124.886
G1 X95.019 Y126.45 E.06588
G1 X94.885 Y126.583
G1 X94.885 Y126.05
G1 X95.019 Y125.916
G1 X96.583 Y124.352 E.06587
G1 X96.716 Y124.219
G1 X96.716 Y123.686
G1 X96.583 Y123.819
G1 X95.019 Y125.383 E.06587
G1 X94.885 Y125.517
G1 X94.885 Y124.983
G1 X95.019 Y124.85
G1 X96.583 Y123.286 E.06587
G1 X96.716 Y123.152
G1 X96.716 Y122.619
G1 X96.583 Y122.753
G1 X95.019 Y124.316 E.06586
G1 X94.885 Y124.45
G1 X94.886 Y123.917
G1 X95.019 Y123.783
G1 X96.583 Y122.219 E.06586
G1 X96.716 Y122.086
G1 X96.716 Y121.553
G1 X96.583 Y121.686
G1 X95.019 Y123.25 E.06586
G1 X94.886 Y123.383
G1 X94.886 Y122.85
G1 X95.019 Y122.716
G1 X96.583 Y121.153 E.06585
; WIPE_START
M204 S3000
G1 X95.876 Y121.86 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8.4 I-.429 J-1.139 P1  F12000
G1 X95.019 Y122.183 Z8.4
G1 Z8
G1 E.4 F1800
G1 F3600
M204 S2000
G1 X98.185 Y119.017 E.13334
G1 X98.319 Y118.884
G1 X97.785 Y118.884
G1 X97.652 Y119.017
G1 X95.019 Y121.65 E.11088
G1 X94.886 Y121.783
G1 X94.886 Y121.25
G1 X95.02 Y121.116
G1 X97.118 Y119.017 E.08841
G1 X97.252 Y118.884
G1 X96.719 Y118.884
G1 X96.585 Y119.017
G1 X95.02 Y120.583 E.06595
G1 X94.886 Y120.717
G1 X94.886 Y120.183
G1 X95.02 Y120.05
G1 X96.052 Y119.017 E.04348
G1 X96.186 Y118.884
G1 X95.652 Y118.884
G1 X95.519 Y119.017
G1 X95.02 Y119.516 E.02102
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F3600
M204 S3000
G1 X95.519 Y119.017 E-.2681
G1 X95.652 Y118.884 E-.07182
G1 X95.758 Y118.884 E-.04008
; WIPE_END
G1 E-.02 F1800
M204 S10000
G17
G3 Z8.4 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 

;======== P2S end gcode ==========
;===== 2026/05/18 =====
M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
M211 Z1

G90
G1 Z8.4 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag

G90
G1 Z18 F900 ; lower z a little

M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan
M106 P10 S0 ; turn off left aux fan

; pull back filament to AMS
M620 S65535
T65535
G150.1 F8000
M621 S65535

G150.3
M104 S0 ; turn off hotend
M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    
        G1 Z84 F600
        G1 Z82
    

M400 P100
M17 R ; restore z current


M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2 R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

M1015.3 S0 ;disable clog detect
M1015.4 S0 K0 ;disable air printing detect

;=====printer finish air purification=========
M622.1 S0
M1002 judge_flag print_finish_air_filt_flag

M622 J1
M1002 gcode_claim_action : 66
M145 P1
M106 P2 S255
M400 S180
M106 P2 S0
M623

M622 J2
M1002 gcode_claim_action : 66
M145 P0
M106 P3 S255
M400 S180
M106 P3 S0
M623
;=====printer finish air purification=========

;=====printer finish  sound=========
M17
M400 S1
M1006 S1
M1006 A53 B10 L50 C53 D10 M50 E53 F10 N50 
M1006 A57 B10 L50 C57 D10 M50 E57 F10 N50 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A53 B10 L50 C53 D10 M50 E53 F10 N50 
M1006 A57 B10 L50 C57 D10 M50 E57 F10 N50 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A48 B10 L50 C48 D10 M50 E48 F10 N50 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A60 B10 L50 C60 D10 M50 E60 F10 N50 
M1006 W
;=====printer finish  sound=========
M400
M18
M73 P100 R0
; EXECUTABLE_BLOCK_END

