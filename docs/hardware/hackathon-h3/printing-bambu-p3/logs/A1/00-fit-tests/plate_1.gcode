; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 12m 43s; total estimated time: 19m 13s
; total layer number: 40
; total filament length [mm] : 1076.31
; total filament volume [cm^3] : 2588.83
; total filament weight [g] : 3.31
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
; auxiliary_fan = 0
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
; change_filament_gcode = ;===== A1 20251031 =======================\nM1007 S0 ; turn off mass estimation\nG392 S0\nM620 S[next_extruder]A\nM204 S9000\nG1 Z{max_layer_z + 3.0} F1200\n\nM400\nM106 P1 S0\nM106 P2 S0\n{if old_filament_temp > 142 && next_extruder < 255}\nM104 S[old_filament_temp]\n{endif}\n\nG1 X267 F18000\n\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E-{retraction_distances_when_cut[previous_extruder]} F1200\n{else}\nM620.11 S0\n{endif}\nM400\n\nM620.1 E F{flush_volumetric_speeds[previous_extruder]/2.4053*60} T{flush_temperatures[previous_extruder]}\nM620.10 A0 F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\nT[next_extruder]\nM620.1 E F{flush_volumetric_speeds[next_extruder]/2.4053*60} T{flush_temperatures[next_extruder]}\nM620.10 A1 F{flush_volumetric_speeds[next_extruder]/2.4053*60} L[flush_length] H[nozzle_diameter] T{flush_temperatures[next_extruder]}\n\nG1 Y128 F9000\n\n{if next_extruder < 255}\n\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E{retraction_distances_when_cut[previous_extruder]} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\nM628 S1\nG92 E0\nG1 E{retraction_distances_when_cut[previous_extruder]} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\nM400\nM629 S1\n{else}\nM620.11 S0\n{endif}\n\nM400\nG92 E0\nM628 S0\n\n{if flush_length_1 > 1}\n; FLUSH_START\n; always use highest temperature to flush\nM400\nM1002 set_filament_type:UNKNOWN\nM109 S[flush_temperatures[next_extruder]]\nM106 P1 S60\n{if flush_length_1 > 23.7}\nG1 E23.7 F{flush_volumetric_speeds[previous_extruder]/2.4053*60} ; do not need pulsatile flushing for start part\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\n{else}\nG1 E{flush_length_1} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\n{endif}\n; FLUSH_END\nG1 E-[old_retract_length_toolchange] F1800\nG1 E[old_retract_length_toolchange] F300\nM400\nM1002 set_filament_type:{filament_type[next_extruder]}\n{endif}\n\n{if flush_length_1 > 45 && flush_length_2 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_2 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_2 > 45 && flush_length_3 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_3 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_3 > 45 && flush_length_4 > 1}\n; WIPE\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nM106 P1 S0\n{endif}\n\n{if flush_length_4 > 1}\nM106 P1 S60\n; FLUSH_START\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\n; FLUSH_END\n{endif}\n\nM629\n\nM400\nM106 P1 S60\nM109 S[new_filament_temp]\nG1 E6 F{flush_volumetric_speeds[next_extruder]/2.4053*60} ;Compensate for filament spillage during waiting temperature\nM400\nG92 E0\nG1 E-[new_retract_length_toolchange] F1800\nM400\nM106 P1 S178\nM400 S3\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nG1 X-38.2 F18000\nG1 X-48.2 F3000\nM400\nG1 Z{max_layer_z + 3.0} F3000\nM106 P1 S0\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\n\nM622.1 S0\nM9833 F{outer_wall_volumetric_speed/2.4} A0.3 ; cali dynamic extrusion compensation\nM1002 judge_flag filament_need_cali_flag\nM622 J1\n  G92 E0\n  G1 E-[new_retract_length_toolchange] F1800\n  M400\n  \n  M106 P1 S178\n  M400 S4\n  G1 X-38.2 F18000\n  G1 X-48.2 F3000\n  G1 X-38.2 F18000 ;wipe and shake\n  G1 X-48.2 F3000\n  G1 X-38.2 F12000 ;wipe and shake\n  G1 X-48.2 F3000\n  M400\n  M106 P1 S0 \nM623\n\nM621 S[next_extruder]A\nG392 S0\n\nM1007 S1\n
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
; counter_coef_2 = 0.008
; counter_coef_3 = -0.041
; counter_limit_max = 0.033
; counter_limit_min = -0.035
; counterbore_hole_bridging = none
; curr_bed_type = Textured PEI Plate
; default_acceleration = 3000
; default_ams_type = -1
; default_filament_colour = ""
; default_filament_profile = "Bambu PLA Basic @BBL A1"
; default_jerk = 0
; default_nozzle_volume_type = Standard
; default_print_profile = 0.20mm Standard @BBL A1
; deretraction_speed = 30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50
; different_settings_to_system = ;;
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70
; elefant_foot_compensation = 0.075
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
; extruder_clearance_dist_to_rod = 56.5
; extruder_clearance_height_to_lid = 256
; extruder_clearance_height_to_rod = 25
; extruder_clearance_max_radius = 73
; extruder_colour = #018001
; extruder_max_nozzle_count = 1
; extruder_nozzle_stats = 
; extruder_offset = 0x0
; extruder_printable_area = 
; extruder_type = Direct Drive
; extruder_variant_list = "Direct Drive Standard"
; fan_cooling_layer_time = 15
; fan_direction = undefine
; fan_max_speed = 50
; fan_min_speed = 30
; farthest_point_timelapse = 0
; filament_adaptive_volumetric_speed = 0
; filament_adhesiveness_category = 300
; filament_bridge_speed = 25
; filament_change_length = 12
; filament_change_length_nc = 10
; filament_colour = #00AE42
; filament_cooling_before_tower = 0
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
; filament_flow_ratio = 0.94
; filament_flush_temp = 0
; filament_flush_temp_fast = 0
; filament_flush_volumetric_speed = 0
; filament_ids = GFG02
; filament_is_mixed = 0
; filament_is_support = 0
; filament_long_retractions_when_cut = 1
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
; filament_preheat_temperature_delta = 0
; filament_prime_volume = 30
; filament_prime_volume_nc = 60
; filament_printable = 3
; filament_ramming_travel_time = 0
; filament_ramming_travel_time_nc = 0
; filament_ramming_volumetric_speed = -1
; filament_ramming_volumetric_speed_nc = -1
; filament_retract_length_nc = 14
; filament_retraction_distances_when_cut = 18
; filament_scarf_gap = 0%
; filament_scarf_height = 10%
; filament_scarf_length = 10
; filament_scarf_seam_type = none
; filament_self_index = 1
; filament_settings_id = "Bambu PETG HF @BBL A1"
; filament_shrink = 100%
; filament_soluble = 0
; filament_start_gcode = "; filament start gcode\n{if (bed_temperature[current_extruder] >80)||(bed_temperature_initial_layer[current_extruder] >80)}M106 P3 S255\n{elsif (bed_temperature[current_extruder] >60)||(bed_temperature_initial_layer[current_extruder] >60)}M106 P3 S180\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}"
; filament_tower_interface_pre_extrusion_dist = 10
; filament_tower_interface_pre_extrusion_length = 0
; filament_tower_interface_print_temp = -1
; filament_tower_interface_purge_volume = 20
; filament_tower_ironing_area = 4
; filament_type = PETG
; filament_velocity_adaptation_factor = 1
; filament_vendor = "Bambu Lab"
; filament_volume_map = 0
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
; grab_length = 17.4
; group_algo_with_time = 0
; has_filament_switcher = 0
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 226x224,256x224,256x256,226x256
; hole_coef_1 = 0
; hole_coef_2 = -0.008
; hole_coef_3 = 0.23415
; hole_limit_max = 0.22
; hole_limit_min = 0.088
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
; layer_change_gcode = ; layer num/total_layer_count: {layer_num+1}/[total_layer_count]\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change
; layer_height = 0.2
; line_width = 0.42
; locked_skeleton_infill_pattern = zigzag
; locked_skin_infill_pattern = crosszag
; long_retractions_when_cut = 0
; long_retractions_when_ec = 0
; machine_bed_mass_Y = 0
; machine_end_gcode = ;===== date: 20260513 =====================\nG392 S0 ;turn off nozzle clog detect\n\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nG90\nG1 Z{max_layer_z + 0.4} F900 ; lower z a little\nG1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to safe pos\nG1 X-13.0 F3000 ; move to safe pos\n{if !spiral_mode && print_sequence != \"by object\"}\nM1002 judge_flag timelapse_record_flag\nM622 J1\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM400 P100\nM971 S11 C11 O0\nM991 S0 P-1 ;end timelapse at safe pos\nM623\n{endif}\n\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\n\n;G1 X27 F15000 ; wipe\n\n; pull back filament to AMS\nM620 S255\nG1 X267 F15000\nT255\nG1 X-28.5 F18000\nG1 X-48.2 F3000\nG1 X-28.5 F18000\nG1 X-48.2 F3000\nM621 S255\n\nM104 S0 ; turn off hotend\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (max_layer_z + 100.0) < 256}\n    G1 Z{max_layer_z + 100.0} F600\n    G1 Z{max_layer_z +98.0}\n{else}\n    G1 Z256 F600\n    G1 Z256\n{endif}\nM400 P100\nM17 R ; restore z current\n\nG90\nG1 X-48 Y180 F3600\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n\n;=====printer finish  sound=========\nM17\nM400 S1\nM1006 S1\nM1006 A0 B20 L100 C37 D20 M40 E42 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C46 D10 M80 E46 F10 N80\nM1006 A44 B20 L100 C39 D20 M60 E48 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C48 D10 M60 E44 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10  N80\nM1006 A44 B20 L100 C49 D20 M80 E41 F20 N80\nM1006 A0 B20 L100 C0 D20 M60 E0 F20 N80\nM1006 A0 B20 L100 C37 D20 M30 E37 F20 N60\nM1006 W\n;=====printer finish  sound=========\n\n;M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power\nM400\nM18 X Y Z\n\n
; machine_hotend_change_time = 0
; machine_load_filament_time = 25
; machine_max_acceleration_e = 5000,5000
; machine_max_acceleration_extruding = 12000,12000
; machine_max_acceleration_retracting = 5000,5000
; machine_max_acceleration_travel = 6000,6000
; machine_max_acceleration_x = 6000,6000
; machine_max_acceleration_y = 6000,6000
; machine_max_acceleration_z = 1500,1500
; machine_max_force_Y = 0
; machine_max_jerk_e = 3,3
; machine_max_jerk_x = 9,9
; machine_max_jerk_y = 9,9
; machine_max_jerk_z = 3,3
; machine_max_printed_mass = 0
; machine_max_speed_e = 30,30
; machine_max_speed_x = 500,200
; machine_max_speed_y = 500,200
; machine_max_speed_z = 30,30
; machine_min_extruding_rate = 0,0
; machine_min_travel_rate = 0,0
; machine_pause_gcode = M400 U1
; machine_prepare_compensation_time = 260
; machine_start_gcode = ;===== machine: A1 =========================\n;===== date: 20260513 ==================\nG392 S0\nM9833.2\n;M400\n;M73 P1.717\n\n;===== start to heat heatbead&hotend==========\nM1002 gcode_claim_action : 2\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM104 S140\nM140 S[bed_temperature_initial_layer_single]\n\n;=====start printer sound ===================\nM17\nM400 S1\nM1006 S1\nM1006 A0 B10 L100 C37 D10 M60 E37 F10 N60\nM1006 A0 B10 L100 C41 D10 M60 E41 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A43 B10 L100 C46 D10 M70 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C43 D10 M60 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C41 D10 M80 E41 F10 N80\nM1006 A0 B10 L100 C44 D10 M80 E44 F10 N80\nM1006 A0 B10 L100 C49 D10 M80 E49 F10 N80\nM1006 A0 B10 L100 C0 D10 M80 E0 F10 N80\nM1006 A44 B10 L100 C48 D10 M60 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A0 B10 L100 C44 D10 M80 E39 F10 N80\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N80\nM1006 A43 B10 L100 C46 D10 M60 E39 F10 N80\nM1006 W\nM18 \n;=====start printer sound ===================\n\n;=====avoid end stop =================\nG91\nG380 S2 Z40 F1200\nG380 S3 Z-15 F1200\nG90\n\n;===== reset machine status =================\n;M290 X39 Y39 Z8\nM204 S6000\n\nM630 S0 P0\nG91\nM17 Z0.3 ; lower the z-motor current\n\nG90\nM17 X0.65 Y1.2 Z0.6 ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\n;M211 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem\n\n;====== cog noise reduction=================\nM982.2 S1 ; turn on cog noise reduction\n\nM1002 gcode_claim_action : 13\n\nG28 X\nG91\nG1 Z5 F1200\nG90\nG0 X128 F30000\nG0 Y254 F3000\nG91\nG1 Z-5 F1200\n\nM109 S25 H140\n\nM17 E0.3\nM83\nG1 E10 F1200\nG1 E-0.5 F30\nM17 D\n\nG28 Z P0 T140; home z with low precision,permit 300deg temperature\nM104 S{nozzle_temperature_initial_layer[initial_extruder]}\n\nM1002 judge_flag build_plate_detect_flag\nM622 S1\n  G39.4\n  G90\n  G1 Z5 F1200\nM623\n\n;M400\n;M73 P1.717\n\n;===== prepare print temperature and material ==========\nM1002 gcode_claim_action : 24\n\nM400\n;G392 S1\nM211 X0 Y0 Z0 ;turn off soft endstop\nM975 S1 ; turn on\n\nG90\nG1 X-28.5 F30000\nG1 X-48.2 F3000\n\nM620 M ;enable remap\nM620 S[initial_no_support_extruder]A   ; switch material if AMS exist\n    M1002 gcode_claim_action : 4\n    M400\n    M1002 set_filament_type:UNKNOWN\n    M109 S[nozzle_temperature_initial_layer]\n{if (filament_type[initial_no_support_extruder] == \"PLA\") && (nozzle_diameter != 0.2)}\n    M104 S220\n{else}\n    M104 S250\n{endif}\n    M400\n    T[initial_no_support_extruder]\n    G1 X-48.2 F3000\n    M400\n\n{if (filament_type[initial_no_support_extruder] == \"PLA\") && (nozzle_diameter != 0.2)}\n    M620.1 E F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60} T220\n    M109 S220 ;set nozzle to common flush temp\n{else}\n    M620.1 E F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60} T{flush_temperatures[initial_no_support_extruder]}\n    M109 S250 ;set nozzle to common flush temp\n{endif}\n    M106 P1 S0\n    G92 E0\n    G1 E50 F200\n    M400\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM621 S[initial_no_support_extruder]A\n\n{if (filament_type[initial_no_support_extruder] == \"PLA\") && (nozzle_diameter != 0.2)}\n    M109 S220 H300\n{else}\n    M109 S{flush_temperatures[initial_no_support_extruder]} H300\n{endif}\nG92 E0\nG1 E50 F200 ; lower extrusion speed to avoid clog\nM400\nM106 P1 S178\nG92 E0\nG1 E5 F200\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\nG92 E0\nG1 E-0.5 F300\n\nG1 X-28.5 F30000\nG1 X-48.2 F3000\nG1 X-28.5 F30000 ;wipe and shake\nG1 X-48.2 F3000\nG1 X-28.5 F30000 ;wipe and shake\nG1 X-48.2 F3000\n\n;G392 S0\n\nM400\nM106 P1 S0\n;===== prepare print temperature and material end =====\n\n;M400\n;M73 P1.717\n\n;===== auto extrude cali start =========================\nM975 S1\n;G392 S1\n\nG90\nM83\nT1000\nG1 X-48.2 Y0 Z10 F10000\nM400\nM1002 set_filament_type:UNKNOWN\n\nM412 S1 ;  ===turn on  filament runout detection===\nM400 P10\nM620.3 W1; === turn on filament tangle detection===\nM400 S2\n\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n\n;M1002 set_flag extrude_cali_flag=1\nM1002 judge_flag extrude_cali_flag\n\nM622 J1\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_extruder]}\n    G1 E10 F{outer_wall_volumetric_speed/2.4*60}\n    M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation\n\n    M106 P1 S255\n    M400 S5\n    G1 X-28.5 F18000\n    G1 X-48.2 F3000\n    G1 X-28.5 F18000 ;wipe and shake\n    G1 X-48.2 F3000\n    G1 X-28.5 F12000 ;wipe and shake\n    G1 X-48.2 F3000\n    M400\n    M106 P1 S0\n\n    M1002 judge_last_extrude_cali_success\n    M622 J0\n        M983 F{outer_wall_volumetric_speed/2.4} A0.3 H[nozzle_diameter]; cali dynamic extrusion compensation\n        M106 P1 S255\n        M400 S5\n        G1 X-28.5 F18000\n        G1 X-48.2 F3000\n        G1 X-28.5 F18000 ;wipe and shake\n        G1 X-48.2 F3000\n        G1 X-28.5 F12000 ;wipe and shake\n        M400\n        M106 P1 S0\n    M623\n    \n    G1 X-48.2 F3000\n    M400\n    M984 A0.1 E1 S1 F{outer_wall_volumetric_speed/2.4} H[nozzle_diameter]\n    M106 P1 S178\n    M400 S7\n    G1 X-28.5 F18000\n    G1 X-48.2 F3000\n    G1 X-28.5 F18000 ;wipe and shake\n    G1 X-48.2 F3000\n    G1 X-28.5 F12000 ;wipe and shake\n    G1 X-48.2 F3000\n    M400\n    M106 P1 S0\nM623 ; end of \"draw extrinsic para cali paint\"\n\n;G392 S0\n;===== auto extrude cali end ========================\n\n;M400\n;M73 P1.717\n\nM104 S170 ; prepare to wipe nozzle\nM106 S255 ; turn on fan\n\n;===== mech mode fast check start =====================\nM1002 gcode_claim_action : 3\n\nG1 X128 Y128 F20000\nG1 Z5 F1200\nM400 P200\nM970.3 Q1 A5 K0 O3\nM974 Q1 S2 P0\n\nM970.2 Q1 K1 W58 Z0.1\nM974 S2\n\nG1 X128 Y128 F20000\nG1 Z5 F1200\nM400 P200\nM970.3 Q0 A10 K0 O1\nM974 Q0 S2 P0\n\nM970.2 Q0 K1 W78 Z0.1\nM974 S2\n\nM975 S1\nG1 F30000\nG1 X0 Y5\nG28 X ; re-home XY\n\nG1 Z4 F1200\n\n;===== mech mode fast check end =======================\n\n;M400\n;M73 P1.717\n\n;===== wipe nozzle ===============================\nM1002 gcode_claim_action : 14\n\nM975 S1\nM106 S255 ; turn on fan (G28 has turn off fan)\nM211 S; push soft endstop status\nM211 X0 Y0 Z0 ;turn off Z axis endstop\n\n;===== remove waste by touching start =====\n\nM104 S170 ; set temp down to heatbed acceptable\n\nM83\nG1 E-1 F500\nG90\nM83\n\nM109 S170\nG0 X108 Y-0.5 F30000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X110 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X112 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X114 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X116 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X118 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X120 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X122 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X124 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X126 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X128 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X130 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X132 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X134 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X136 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X138 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X140 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X142 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X144 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X146 F10000\nG380 S3 Z-5 F1200\nG1 Z2 F1200\nG1 X148 F10000\nG380 S3 Z-5 F1200\n\nG1 Z5 F30000\n;===== remove waste by touching end =====\n\nG1 Z10 F1200\nG0 X118 Y261 F30000\nG1 Z5 F1200\nM109 S{nozzle_temperature_initial_layer[initial_extruder]-50}\n\nG28 Z P0 T300; home z with low precision,permit 300deg temperature\nG29.2 S0 ; turn off ABL\nM104 S140 ; prepare to abl\nG0 Z5 F20000\n\nG0 X128 Y261 F20000  ; move to exposed steel surface\nG0 Z-1.01 F1200      ; stop the nozzle\n\nG91\nG2 I1 J0 X2 Y0 F2000.1\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\n\nG90\nG1 Z10 F1200\n\n;===== brush material wipe nozzle =====\n\nG90\nG1 Y250 F30000\nG1 X55\nG1 Z1.300 F1200\nG1 Y262.5 F6000\nG91\nG1 X-35 F30000\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Z5.000 F1200\n\nG90\nG1 X30 Y250.000 F30000\nG1 Z1.300 F1200\nG1 Y262.5 F6000\nG91\nG1 X35 F30000\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Y-0.5\nG1 X45\nG1 Y-0.5\nG1 X-45\nG1 Z10.000 F1200\n\n;===== brush material wipe nozzle end =====\n\nG90\n;G0 X128 Y261 F20000  ; move to exposed steel surface\nG1 Y250 F30000\nG1 X138\nG1 Y261\nG0 Z-1.01 F1200      ; stop the nozzle\n\nG91\nG2 I1 J0 X2 Y0 F2000.1\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\nG2 I1 J0 X2\nG2 I-0.75 J0 X-1.5\n\nM109 S140\nM106 S255 ; turn on fan (G28 has turn off fan)\n\nM211 R; pop softend status\n\n;===== wipe nozzle end ================================\n\n;M400\n;M73 P1.717\n\n;===== bed leveling ==================================\nM1002 judge_flag g29_before_print_flag\n\nG90\nG1 Z5 F1200\nG1 X0 Y0 F30000\nG29.2 S1 ; turn on ABL\n\nM190 S[bed_temperature_initial_layer_single]; ensure bed temp\nM109 S140\nM106 S0 ; turn off fan , too noisy\n\nM622 J1\n    M1002 gcode_claim_action : 1\n    G29 A1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    M400\n    M500 ; save cali data\nM623\n;===== bed leveling end ================================\n\n;===== home after wipe mouth============================\nM1002 judge_flag g29_before_print_flag\nM622 J0\n\n    M1002 gcode_claim_action : 13\n    G28\n\nM623\n\n;===== home after wipe mouth end =======================\n\n;M400\n;M73 P1.717\n\nG1 X108.000 Y-0.500 F30000\nG1 Z0.300 F1200\nM400\nG2814 Z0.32\n\nM104 S{nozzle_temperature_initial_layer[initial_extruder]} ; prepare to print\n\n;===== nozzle load line ===============================\n;G90\n;M83\n;G1 Z5 F1200\n;G1 X88 Y-0.5 F20000\n;G1 Z0.3 F1200\n\n;M109 S{nozzle_temperature_initial_layer[initial_extruder]}\n\n;G1 E2 F300\n;G1 X168 E4.989 F6000\n;G1 Z1 F1200\n;===== nozzle load line end ===========================\n\n;===== extrude cali test ===============================\n\nM400\n    M900 S\n    M900 C\n    G90\n    M83\n\n    M109 S{nozzle_temperature_initial_layer[initial_extruder]}\n    G0 X128 E8  F{outer_wall_volumetric_speed/(24/20)    * 60}\n    G0 X133 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X138 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X143 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X148 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X153 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G91\n    G1 X1 Z-0.300\n    G1 X4\n    G1 Z1 F1200\n    G90\n    M400\n\nM900 R\n\nM1002 judge_flag extrude_cali_flag\nM622 J1\n    G90\n    G1 X108.000 Y1.000 F30000\n    G91\n    G1 Z-0.700 F1200\n    G90\n    M83\n    G0 X128 E10  F{outer_wall_volumetric_speed/(24/20)    * 60}\n    G0 X133 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X138 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X143 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G0 X148 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X153 E.3742  F{outer_wall_volumetric_speed/(0.3*0.5)/4     * 60}\n    G91\n    G1 X1 Z-0.300\n    G1 X4\n    G1 Z1 F1200\n    G90\n    M400\nM623\n\nG1 Z0.2\n\n;M400\n;M73 P1.717\n\n;========turn off light and wait extrude temperature =============\nM1002 gcode_claim_action : 0\nM400\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n;curr_bed_type={curr_bed_type}\n{if curr_bed_type==\"Textured PEI Plate\"}\nG29.1 Z{-0.02} ; for Textured PEI Plate\n{endif}\n\nM960 S1 P0 ; turn off laser\nM960 S2 P0 ; turn off laser\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off big fan\nM106 P3 S0 ; turn off chamber fan\n\nM975 S1 ; turn on mech mode supression\nG90\nM83\nT1000\n\nM211 X0 Y0 Z0 ;turn off soft endstop\n;G392 S1 ; turn on clog detection\nM1007 S1 ; turn on mass estimation\nG29.4\n
; machine_switch_extruder_time = 0
; machine_unload_filament_time = 29
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
; monotonic_travel_into_wall = 0%
; no_slow_down_for_cooling_on_outwalls = 0
; nozzle_diameter = 0.4
; nozzle_flush_dataset = 0
; nozzle_height = 4.76
; nozzle_temperature = 240
; nozzle_temperature_initial_layer = 230
; nozzle_temperature_range_high = 270
; nozzle_temperature_range_low = 230
; nozzle_type = stainless_steel
; nozzle_volume = 92
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
; pre_start_fan_time = 2
; precise_outer_wall = 0
; precise_z_height = 0
; pressure_advance = 0.02
; prime_tower_brim_width = 3
; prime_tower_enable_framework = 0
; prime_tower_extra_rib_length = 0
; prime_tower_fillet_wall = 1
; prime_tower_flat_ironing = 0
; prime_tower_infill_gap = 150%
; prime_tower_lift_height = -1
; prime_tower_lift_speed = 90
; prime_tower_max_speed = 90
; prime_tower_rib_wall = 1
; prime_tower_rib_width = 8
; prime_tower_skip_points = 1
; prime_tower_width = 35
; prime_volume_mode = Default
; print_compatible_printers = "Bambu Lab A1 0.4 nozzle"
; print_extruder_id = 1
; print_extruder_variant = "Direct Drive Standard"
; print_flow_ratio = 1
; print_in_clockwise = 0
; print_sequence = by layer
; print_settings_id = 0.20mm Standard @BBL A1
; printable_area = 0x0,256x0,256x256,0x256
; printable_height = 256
; printer_extruder_id = 1
; printer_extruder_variant = "Direct Drive Standard"
; printer_model = Bambu Lab A1
; printer_notes = 
; printer_settings_id = Bambu Lab A1 0.4 nozzle
; printer_structure = i3
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
; retract_lift_below = 255
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
; slow_down_layer_time = 7
; slow_down_min_speed = 10
; slowdown_end_acc = 100000
; slowdown_end_height = 400
; slowdown_end_speed = 1000
; slowdown_start_acc = 100000
; slowdown_start_height = 0
; slowdown_start_speed = 1000
; small_perimeter_speed = 50%
; small_perimeter_threshold = 0
; smooth_coefficient = 80
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
; supertack_plate_temp = 70
; supertack_plate_temp_initial_layer = 70
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
; support_object_skip_flush = 0
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
; time_lapse_gcode = ;===================== date: 20250206 =====================\n{if !spiral_mode && print_sequence != \"by object\"}\n; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firmware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\nG92 E0\nG1 Z{max_layer_z + 0.4}\nG1 X0 Y{first_layer_center_no_wipe_tower[1]} F18000 ; move to safe pos\nG1 X-48.2 F3000 ; move to safe pos\nM400\nM1004 S5 P1  ; external shutter\nM400 P300\nM971 S11 C11 O0\nG92 E0\nG1 X0 F18000\nM623\n\n; SKIPTYPE: head_wrap_detect\nM622.1 S1\nM1002 judge_flag g39_3rd_layer_detect_flag\nM622 J1\n    ; enable nozzle clog detect at 3rd layer\n    {if layer_num == 2}\n      M400\n      G90\n      M83\n      M204 S5000\n      G0 Z2 F4000\n      G0 X261 Y250 F20000\n      M400 P200\n      G39 S1\n      G0 Z2 F4000\n    {endif}\n\n\n    M622.1 S1\n    M1002 judge_flag g39_detection_flag\n    M622 J1\n      {if !in_head_wrap_detect_zone}\n        M622.1 S0\n        M1002 judge_flag g39_mass_exceed_flag\n        M622 J1\n        {if layer_num > 2}\n            G392 S0\n            M400\n            G90\n            M83\n            M204 S5000\n            G0 Z{max_layer_z + 0.4} F4000\n            G39.3 S1\n            G0 Z{max_layer_z + 0.4} F4000\n            G392 S0\n          {endif}\n        M623\n    {endif}\n    M623\nM623\n; SKIPPABLE_END\n{endif}\n
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
; upward_compatible_machine = "Bambu Lab H2D 0.4 nozzle";"Bambu Lab H2D Pro 0.4 nozzle";"Bambu Lab H2S 0.4 nozzle";"Bambu Lab P2S 0.4 nozzle";"Bambu Lab H2C 0.4 nozzle";"Bambu Lab X2D 0.4 nozzle";"Bambu Lab A2L 0.4 nozzle"
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
; wrapping_detection_gcode = 
; wrapping_detection_layers = 20
; wrapping_exclude_area = 
; xy_contour_compensation = 0
; xy_hole_compensation = 0
; z_direction_outwall_speed_continuous = 0
; z_hop = 0.4
; z_hop_types = Auto Lift
; CONFIG_BLOCK_END

; EXECUTABLE_BLOCK_START
M73 P0 R19
M201 X6000 Y6000 Z1500 E5000
M203 X500 Y500 Z30 E30
M204 P12000 R5000 T12000
M205 X9.00 Y9.00 Z3.00 E3.00
M106 S0
; FEATURE: Custom
;===== machine: A1 =========================
;===== date: 20260513 ==================
G392 S0
M9833.2
;M400
;M73 P1.717

;===== start to heat heatbead&hotend==========
M1002 gcode_claim_action : 2
M1002 set_filament_type:PETG
M104 S140
M140 S70

;=====start printer sound ===================
M17
M400 S1
M1006 S1
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A43 B10 L100 C46 D10 M70 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C43 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C41 D10 M80 E41 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E44 F10 N80
M1006 A0 B10 L100 C49 D10 M80 E49 F10 N80
M1006 A0 B10 L100 C0 D10 M80 E0 F10 N80
M1006 A44 B10 L100 C48 D10 M60 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A0 B10 L100 C44 D10 M80 E39 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N80
M1006 A43 B10 L100 C46 D10 M60 E39 F10 N80
M1006 W
M18 
;=====start printer sound ===================

;=====avoid end stop =================
G91
G380 S2 Z40 F1200
G380 S3 Z-15 F1200
G90

;===== reset machine status =================
;M290 X39 Y39 Z8
M204 S6000

M630 S0 P0
G91
M17 Z0.3 ; lower the z-motor current

G90
M17 X0.65 Y1.2 Z0.6 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
;M211 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem

;====== cog noise reduction=================
M982.2 S1 ; turn on cog noise reduction

M1002 gcode_claim_action : 13

G28 X
G91
G1 Z5 F1200
G90
G0 X128 F30000
G0 Y254 F3000
G91
G1 Z-5 F1200

M109 S25 H140

M17 E0.3
M83
G1 E10 F1200
G1 E-0.5 F30
M17 D

G28 Z P0 T140; home z with low precision,permit 300deg temperature
M104 S230

M1002 judge_flag build_plate_detect_flag
M622 S1
  G39.4
  G90
  G1 Z5 F1200
M623

;M400
;M73 P1.717

;===== prepare print temperature and material ==========
M1002 gcode_claim_action : 24

M400
;G392 S1
M211 X0 Y0 Z0 ;turn off soft endstop
M975 S1 ; turn on

G90
G1 X-28.5 F30000
G1 X-48.2 F3000

M620 M ;enable remap
M620 S0A   ; switch material if AMS exist
    M1002 gcode_claim_action : 4
    M400
    M1002 set_filament_type:UNKNOWN
    M109 S230

    M104 S250

    M400
    T0
    G1 X-48.2 F3000
    M400


    M620.1 E F249.449 T270
    M109 S250 ;set nozzle to common flush temp

    M106 P1 S0
    G92 E0
    G1 E50 F200
    M400
    M1002 set_filament_type:PETG
M621 S0A


    M109 S270 H300

G92 E0
G1 E50 F200 ; lower extrusion speed to avoid clog
M400
M106 P1 S178
G92 E0
G1 E5 F200
M104 S230
G92 E0
M73 P2 R18
G1 E-0.5 F300

G1 X-28.5 F30000
M73 P4 R18
G1 X-48.2 F3000
M73 P5 R18
G1 X-28.5 F30000 ;wipe and shake
G1 X-48.2 F3000
G1 X-28.5 F30000 ;wipe and shake
G1 X-48.2 F3000

;G392 S0

M400
M106 P1 S0
;===== prepare print temperature and material end =====

;M400
;M73 P1.717

;===== auto extrude cali start =========================
M975 S1
;G392 S1

G90
M83
T1000
G1 X-48.2 Y0 Z10 F10000
M400
M1002 set_filament_type:UNKNOWN

M412 S1 ;  ===turn on  filament runout detection===
M400 P10
M620.3 W1; === turn on filament tangle detection===
M400 S2

M1002 set_filament_type:PETG

;M1002 set_flag extrude_cali_flag=1
M1002 judge_flag extrude_cali_flag

M622 J1
    M1002 gcode_claim_action : 8

    M109 S240
    G1 E10 F113.124
    M983 F1.8854 A0.3 H0.4; cali dynamic extrusion compensation

    M106 P1 S255
    M400 S5
    G1 X-28.5 F18000
    G1 X-48.2 F3000
    G1 X-28.5 F18000 ;wipe and shake
    G1 X-48.2 F3000
M73 P7 R17
    G1 X-28.5 F12000 ;wipe and shake
    G1 X-48.2 F3000
    M400
    M106 P1 S0

    M1002 judge_last_extrude_cali_success
    M622 J0
        M983 F1.8854 A0.3 H0.4; cali dynamic extrusion compensation
        M106 P1 S255
        M400 S5
        G1 X-28.5 F18000
        G1 X-48.2 F3000
        G1 X-28.5 F18000 ;wipe and shake
        G1 X-48.2 F3000
        G1 X-28.5 F12000 ;wipe and shake
        M400
        M106 P1 S0
    M623
    
M73 P8 R17
    G1 X-48.2 F3000
    M400
    M984 A0.1 E1 S1 F1.8854 H0.4
    M106 P1 S178
    M400 S7
    G1 X-28.5 F18000
    G1 X-48.2 F3000
    G1 X-28.5 F18000 ;wipe and shake
    G1 X-48.2 F3000
    G1 X-28.5 F12000 ;wipe and shake
    G1 X-48.2 F3000
    M400
    M106 P1 S0
M623 ; end of "draw extrinsic para cali paint"

;G392 S0
;===== auto extrude cali end ========================

;M400
;M73 P1.717

M104 S170 ; prepare to wipe nozzle
M106 S255 ; turn on fan

;===== mech mode fast check start =====================
M1002 gcode_claim_action : 3

G1 X128 Y128 F20000
G1 Z5 F1200
M400 P200
M970.3 Q1 A5 K0 O3
M974 Q1 S2 P0

M970.2 Q1 K1 W58 Z0.1
M974 S2

G1 X128 Y128 F20000
G1 Z5 F1200
M400 P200
M970.3 Q0 A10 K0 O1
M974 Q0 S2 P0

M970.2 Q0 K1 W78 Z0.1
M974 S2

M975 S1
G1 F30000
G1 X0 Y5
G28 X ; re-home XY

G1 Z4 F1200

;===== mech mode fast check end =======================

;M400
;M73 P1.717

;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14

M975 S1
M106 S255 ; turn on fan (G28 has turn off fan)
M211 S; push soft endstop status
M211 X0 Y0 Z0 ;turn off Z axis endstop

;===== remove waste by touching start =====

M104 S170 ; set temp down to heatbed acceptable

M83
G1 E-1 F500
G90
M83

M109 S170
G0 X108 Y-0.5 F30000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X110 F10000
G380 S3 Z-5 F1200
M73 P31 R13
G1 Z2 F1200
G1 X112 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X114 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X116 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X118 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X120 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X122 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X124 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X126 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X128 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X130 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X132 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X134 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X136 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X138 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X140 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X142 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X144 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X146 F10000
G380 S3 Z-5 F1200
G1 Z2 F1200
G1 X148 F10000
G380 S3 Z-5 F1200

G1 Z5 F30000
;===== remove waste by touching end =====

G1 Z10 F1200
G0 X118 Y261 F30000
G1 Z5 F1200
M109 S180

G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
M104 S140 ; prepare to abl
G0 Z5 F20000

G0 X128 Y261 F20000  ; move to exposed steel surface
G0 Z-1.01 F1200      ; stop the nozzle

G91
G2 I1 J0 X2 Y0 F2000.1
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5

G90
G1 Z10 F1200

;===== brush material wipe nozzle =====

G90
G1 Y250 F30000
G1 X55
G1 Z1.300 F1200
G1 Y262.5 F6000
G91
G1 X-35 F30000
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Z5.000 F1200

G90
G1 X30 Y250.000 F30000
G1 Z1.300 F1200
G1 Y262.5 F6000
G91
G1 X35 F30000
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Y-0.5
G1 X45
G1 Y-0.5
G1 X-45
G1 Z10.000 F1200

;===== brush material wipe nozzle end =====

G90
;G0 X128 Y261 F20000  ; move to exposed steel surface
G1 Y250 F30000
G1 X138
G1 Y261
G0 Z-1.01 F1200      ; stop the nozzle

G91
G2 I1 J0 X2 Y0 F2000.1
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
M73 P32 R13
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5
G2 I1 J0 X2
G2 I-0.75 J0 X-1.5

M109 S140
M106 S255 ; turn on fan (G28 has turn off fan)

M211 R; pop softend status

;===== wipe nozzle end ================================

;M400
;M73 P1.717

;===== bed leveling ==================================
M1002 judge_flag g29_before_print_flag

G90
G1 Z5 F1200
G1 X0 Y0 F30000
G29.2 S1 ; turn on ABL

M190 S70; ensure bed temp
M109 S140
M106 S0 ; turn off fan , too noisy

M622 J1
    M1002 gcode_claim_action : 1
    G29 A1 X94.6 Y116 I69.4 J24
    M400
    M500 ; save cali data
M623
;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag
M622 J0

    M1002 gcode_claim_action : 13
    G28

M623

;===== home after wipe mouth end =======================

;M400
;M73 P1.717

G1 X108.000 Y-0.500 F30000
G1 Z0.300 F1200
M400
G2814 Z0.32

M104 S230 ; prepare to print

;===== nozzle load line ===============================
;G90
;M83
;G1 Z5 F1200
;G1 X88 Y-0.5 F20000
;G1 Z0.3 F1200

;M109 S230

;G1 E2 F300
;G1 X168 E4.989 F6000
;G1 Z1 F1200
;===== nozzle load line end ===========================

;===== extrude cali test ===============================

M400
    M900 S
    M900 C
    G90
    M83

    M109 S230
    G0 X128 E8  F271.497
    G0 X133 E.3742  F452.496
    G0 X138 E.3742  F1809.98
    G0 X143 E.3742  F452.496
    G0 X148 E.3742  F1809.98
    G0 X153 E.3742  F452.496
    G91
    G1 X1 Z-0.300
    G1 X4
    G1 Z1 F1200
    G90
    M400

M900 R

M1002 judge_flag extrude_cali_flag
M622 J1
    G90
    G1 X108.000 Y1.000 F30000
    G91
    G1 Z-0.700 F1200
    G90
    M83
    G0 X128 E10  F271.497
    G0 X133 E.3742  F452.496
    G0 X138 E.3742  F1809.98
    G0 X143 E.3742  F452.496
    G0 X148 E.3742  F1809.98
    G0 X153 E.3742  F452.496
    G91
    G1 X1 Z-0.300
    G1 X4
    G1 Z1 F1200
    G90
    M400
M623

G1 Z0.2

;M400
;M73 P1.717

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type=Textured PEI Plate

G29.1 Z-0.02 ; for Textured PEI Plate


M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000

M211 X0 Y0 Z0 ;turn off soft endstop
;G392 S1 ; turn on clog detection
M1007 S1 ; turn on mass estimation
G29.4
; MACHINE_START_GCODE_END
; filament start gcode
M106 P3 S180


;VT0 H-1
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.8 F1800
; layer num/total_layer_count: 1/40
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X138.472 Y117.277 F12000
M204 S6000
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.57487
M73 P32 R12
G1 F1200
M204 S500
G1 X138.274 Y117.352 E.00885
G1 X137.738 Y117.726 E.02714
G1 X137.43 Y118.132 E.02119
G1 X137.28 Y118.459 E.01496
G1 X137.28 Y117.277 E.04916
G1 X138.412 Y117.277 E.04708
; WIPE_START
M73 P33 R12
G1 X138.274 Y117.352 E-.06009
G1 X137.738 Y117.726 E-.24807
G1 X137.43 Y118.132 E-.19363
G1 X137.28 Y118.459 E-.13673
G1 X137.28 Y118.139 E-.12148
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X137.26 Y125.772 Z.6 F12000
G1 X137.231 Y137.274 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.5259
G1 F1200
M204 S500
G1 X137.265 Y137.443 E.00653
; LINE_WIDTH: 0.56926
G1 X137.299 Y137.613 E.00712
; LINE_WIDTH: 0.58173
G1 X137.42 Y137.865 E.01179
G2 X137.927 Y138.433 I1.848 J-1.138 E.0322
G1 X138.445 Y138.72 E.02495
G3 X137.28 Y138.705 I-.316 J-21.071 E.04906
G2 X137.255 Y137.586 I-7.063 J-.404 E.04719
; LINE_WIDTH: 0.532135
G1 X137.235 Y137.333 E.00969
; WIPE_START
G1 X137.265 Y137.443 E-.04319
G1 X137.299 Y137.613 E-.06574
G1 X137.42 Y137.865 E-.10637
G1 X137.671 Y138.196 E-.15767
G1 X137.927 Y138.433 E-.1325
G1 X138.445 Y138.72 E-.22511
G1 X138.367 Y138.719 E-.02943
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X145.991 Y138.353 Z.6 F12000
G1 X162.72 Y137.55 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.57482
G1 F1200
M204 S500
G3 X162.717 Y138.72 I-152.106 J.168 E.04867
G3 X161.546 Y138.723 I-.716 J-49.912 E.04868
G1 X161.829 Y138.596 E.0129
G1 X162.262 Y138.274 E.02244
G1 X162.568 Y137.87 E.02108
G1 X162.694 Y137.604 E.01223
; WIPE_START
G1 X162.717 Y138.72 E-.42431
G1 X161.833 Y138.723 E-.33569
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X162.191 Y131.099 Z.6 F12000
G1 X162.771 Y118.745 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.525425
G1 F1200
M204 S500
G1 X162.737 Y118.566 E.00688
; LINE_WIDTH: 0.57247
G1 X162.703 Y118.387 E.00755
; LINE_WIDTH: 0.58064
G2 X161.553 Y117.279 I-1.898 J.82 E.06888
G3 X162.72 Y117.282 I.109 J236.782 E.04904
G1 X162.72 Y118.1 E.03439
G1 X162.737 Y118.315 E.00906
; LINE_WIDTH: 0.546554
G1 X162.754 Y118.53 E.00849
; LINE_WIDTH: 0.512467
G1 X162.766 Y118.685 E.00571
; WIPE_START
G1 X162.737 Y118.566 E-.04671
G1 X162.703 Y118.387 E-.06932
G1 X162.578 Y118.134 E-.10699
G1 X162.345 Y117.819 E-.14895
G1 X162.119 Y117.602 E-.11895
G1 X161.753 Y117.363 E-.16615
G1 X161.553 Y117.279 E-.08248
G1 X161.607 Y117.28 E-.02044
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X162.127 Y124.894 Z.6 F12000
G1 X163.094 Y139.061 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.49999
G1 F1200
M204 S500
G1 X163.016 Y139.15 E.00425
G1 X162.751 Y139.218 E.00975
G1 X137.25 Y139.218 E.91105
G1 X136.973 Y139.14 E.01028
G1 X136.855 Y139.004 E.00644
G1 X136.782 Y138.744 E.00962
G1 X136.786 Y117.263 E.76742
G1 X136.832 Y117.023 E.00874
G1 X136.974 Y116.858 E.00776
G1 X137.235 Y116.782 E.00973
G1 X162.744 Y116.782 E.9113
G1 X163.022 Y116.855 E.01027
G1 X163.161 Y117.025 E.00783
G1 X163.217 Y117.259 E.00863
G1 X163.214 Y138.72 E.7667
G1 X163.168 Y138.977 E.00932
G1 X163.134 Y139.016 E.00184
M204 S6000
G1 X163.449 Y139.379 F12000
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X163.438 Y139.395 E.00069
G1 X163.153 Y139.589 E.01232
G1 X162.783 Y139.675 E.01359
G1 X137.549 Y139.675 E.90146
G1 X136.966 Y139.64 E.02088
G3 X136.371 Y139.068 I.304 J-.912 E.03051
G1 X136.325 Y138.78 E.0104
G1 X136.329 Y117.263 E.7687
G1 X136.409 Y116.833 E.01563
M73 P34 R12
G1 X136.647 Y116.535 E.01363
G1 X136.872 Y116.407 E.00923
G1 X137.213 Y116.325 E.01254
G1 X162.78 Y116.325 E.91338
G1 X163.178 Y116.423 E.01465
G1 X163.484 Y116.659 E.01381
G1 X163.631 Y116.934 E.01113
G1 X163.674 Y117.259 E.01173
G1 X163.672 Y138.72 E.7667
G1 X163.591 Y139.167 E.01621
G1 X163.482 Y139.329 E.00695
; WIPE_START
G1 X163.438 Y139.395 E-.03016
G1 X163.153 Y139.589 E-.13108
G1 X162.783 Y139.675 E-.1446
G1 X161.587 Y139.675 E-.45416
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X161.495 Y132.043 Z.6 F12000
G1 X161.321 Y117.722 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S500
G1 X161.562 Y117.822 E.00934
G1 X161.92 Y118.101 E.01619
G1 X162.135 Y118.36 E.01206
G1 X162.33 Y118.815 E.01768
G1 X162.382 Y119.198 E.01381
G1 X162.379 Y136.871 E.63138
G1 X162.277 Y137.35 E.01747
G1 X162.169 Y137.579 E.00907
G1 X161.904 Y137.932 E.01575
G1 X161.555 Y138.185 E.01541
G1 X161.044 Y138.357 E.01924
G1 X160.871 Y138.379 E.00623
G1 X139.196 Y138.382 E.77435
G3 X138.009 Y137.83 I.045 J-1.651 E.04809
G1 X137.737 Y137.389 E.01851
G1 X137.627 Y136.911 E.01753
G1 X137.619 Y119.164 E.63404
G1 X137.719 Y118.666 E.01814
G1 X137.831 Y118.423 E.00956
G1 X138.096 Y118.068 E.01584
G1 X138.532 Y117.774 E.01877
G1 X138.768 Y117.684 E.00904
G1 X139.196 Y117.618 E.01547
G1 X160.802 Y117.618 E.77187
G1 X161.239 Y117.688 E.01581
G1 X161.265 Y117.699 E.00103
M204 S6000
G1 X161.147 Y118.148 F12000
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X161.457 Y118.29 E.01221
G1 X161.728 Y118.568 E.01386
G1 X161.878 Y118.887 E.01259
G1 X161.925 Y119.198 E.01124
G1 X161.922 Y136.871 E.63138
G1 X161.799 Y137.31 E.01629
G1 X161.535 Y137.649 E.01532
G1 X161.232 Y137.836 E.01274
G1 X160.871 Y137.922 E.01325
G1 X139.196 Y137.925 E.77435
M73 P35 R12
G1 X138.983 Y137.9 E.00767
G1 X138.575 Y137.732 E.01575
G1 X138.271 Y137.431 E.01528
G1 X138.122 Y137.114 E.01252
G1 X138.078 Y136.839 E.00995
G1 X138.076 Y119.164 E.63145
G1 X138.2 Y118.691 E.01745
G1 X138.473 Y118.346 E.01572
G1 X138.849 Y118.134 E.01544
G1 X139.196 Y118.075 E.01257
G1 X160.802 Y118.075 E.77187
G1 X161.063 Y118.11 E.00942
G1 X161.092 Y118.123 E.00113
; WIPE_START
G1 X161.457 Y118.29 E-.15268
G1 X161.728 Y118.568 E-.1474
G1 X161.878 Y118.887 E-.13391
G1 X161.925 Y119.198 E-.11954
G1 X161.925 Y119.741 E-.20646
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X155.701 Y124.16 Z.6 F12000
G1 X137.231 Y137.274 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.48254
G1 F1200
M204 S500
G1 X137.215 Y137.038 E.00811
; LINE_WIDTH: 0.45197
G1 X137.2 Y136.803 E.00754
; LINE_WIDTH: 0.4214
G1 X137.202 Y119.164 E.52181
; LINE_WIDTH: 0.44998
G1 X137.217 Y118.903 E.00831
; WIPE_START
G1 X137.202 Y119.164 E-.09927
G1 X137.202 Y120.902 E-.66073
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X138.999 Y117.209 Z.6 F12000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.43934
G1 F1200
M204 S500
G1 X139.196 Y117.2 E.00612
; LINE_WIDTH: 0.42172
G1 X160.802 Y117.2 E.63969
; LINE_WIDTH: 0.44424
G1 X161.085 Y117.211 E.00889
; WIPE_START
G1 X160.802 Y117.2 E-.10772
G1 X159.085 Y117.2 E-.65228
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X162.771 Y118.745 Z.6 F12000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.47838
G1 F1200
M204 S500
G1 X162.785 Y118.972 E.00773
; LINE_WIDTH: 0.44945
G1 X162.799 Y119.198 E.00721
; LINE_WIDTH: 0.42114
G1 X162.797 Y136.871 E.52246
; LINE_WIDTH: 0.43782
G1 X162.789 Y137.064 E.00593
; WIPE_START
G1 X162.797 Y136.871 E-.07304
G1 X162.797 Y135.064 E-.68696
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X161.064 Y138.79 Z.6 F12000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.44118
G1 F1200
M204 S500
G1 X160.871 Y138.799 E.00599
; LINE_WIDTH: 0.42442
G1 X139.196 Y138.8 E.64632
; LINE_WIDTH: 0.43576
G1 X138.974 Y138.793 E.00682
; OBJECT_ID: 47
; WIPE_START
G1 X139.196 Y138.8 E-.08436
G1 X140.974 Y138.8 E-.67564
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S6000
G1 X133.878 Y135.989 Z.6 F12000
G1 X95.801 Y120.903 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.42097
G1 F1200
M204 S500
G1 X95.802 Y119.8 E.03261
G1 X95.991 Y119.8 E.00559
; LINE_WIDTH: 0.4381
G1 X96.712 Y119.808 E.02227
G1 X96.124 Y120.123 E.02057
; LINE_WIDTH: 0.42097
G1 X95.824 Y120.848 E.0232
; WIPE_START
G1 X95.802 Y119.8 E-.39842
G1 X95.991 Y119.8 E-.07184
G1 X96.712 Y119.808 E-.27394
G1 X96.675 Y119.828 E-.01581
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X96.308 Y127.452 Z.6 F12000
G1 X95.921 Y135.5 Z.6
G1 Z.2
M73 P36 R12
G1 E.8 F1800
; LINE_WIDTH: 0.43826
G1 F1200
M204 S500
G1 X96.123 Y135.877 E.01322
; LINE_WIDTH: 0.42163
G1 X96.904 Y136.2 E.025
G1 X95.8 Y136.2 E.03267
G1 X95.8 Y136.011 E.00561
; LINE_WIDTH: 0.43826
G1 X95.808 Y135.288 E.02232
G1 X95.893 Y135.447 E.00555
; WIPE_START
G1 X96.123 Y135.877 E-.18532
G1 X96.904 Y136.2 E-.32093
G1 X96.236 Y136.2 E-.25374
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X103.868 Y136.197 Z.6 F12000
G1 X115.289 Y136.192 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.43844
G1 F1200
M204 S500
G1 X115.876 Y135.877 E.02058
; LINE_WIDTH: 0.43636
G1 X116.191 Y135.288 E.02054
G1 X116.198 Y136.2 E.02804
; LINE_WIDTH: 0.42102
G1 X116.009 Y136.2 E.00559
; LINE_WIDTH: 0.43844
G1 X115.349 Y136.192 E.02042
; WIPE_START
G1 X115.876 Y135.877 E-.23331
G1 X116.191 Y135.288 E-.2538
G1 X116.197 Y136.007 E-.27289
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X116.198 Y128.374 Z.6 F12000
G1 X116.2 Y119.804 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.42008
G1 F1200
M204 S500
G1 X116.2 Y119.992 E.00556
; LINE_WIDTH: 0.42096
G1 X116.2 Y120.904 E.02692
G1 X115.878 Y120.126 E.02488
; LINE_WIDTH: 0.42008
G1 X115.097 Y119.802 E.02492
G1 X116.14 Y119.804 E.03076
M204 S6000
G1 X116.57 Y119.391 F12000
; LINE_WIDTH: 0.49999
G1 F1200
M204 S500
G1 X116.617 Y119.481 E.00365
G1 X116.616 Y136.532 E.60915
G1 X116.566 Y136.618 E.00355
G1 X95.989 Y136.618 E.73509
G1 X95.402 Y136.602 E.02098
G1 X95.382 Y136.538 E.00241
G1 X95.384 Y119.454 E.61031
G1 X95.441 Y119.382 E.00328
G1 X116.012 Y119.387 E.73488
G1 X116.51 Y119.39 E.01779
M204 S6000
G1 X116.86 Y119.01 F12000
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X117.008 Y119.17 E.00779
G1 X117.074 Y119.481 E.01135
G1 X117.073 Y136.532 E.60915
G1 X116.998 Y136.847 E.01158
G1 X116.859 Y136.992 E.00719
G1 X116.587 Y137.075 E.01014
G1 X95.488 Y137.075 E.75378
G1 X95.204 Y137.027 E.01028
G1 X94.996 Y136.829 E.01025
G1 X94.925 Y136.578 E.0093
G1 X94.927 Y119.468 E.61127
G1 X95.002 Y119.152 E.01158
G1 X95.14 Y119.009 E.00709
G1 X95.413 Y118.925 E.0102
G1 X116.549 Y118.93 E.7551
G1 X116.802 Y118.995 E.00934
; WIPE_START
G1 X117.008 Y119.17 E-.1028
G1 X117.074 Y119.481 E-.12068
G1 X117.074 Y120.893 E-.53652
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X110.801 Y125.24 Z.6 F12000
G1 X96.275 Y135.305 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S500
G1 X96.228 Y135.215 E.00361
G1 X96.218 Y135.096 E.00424
G1 X96.218 Y120.903 E.50705
G1 X96.419 Y120.418 E.01877
G1 X96.785 Y120.228 E.01473
G1 X96.904 Y120.218 E.00424
G1 X115.097 Y120.218 E.64995
G1 X115.582 Y120.42 E.01879
G1 X115.782 Y120.904 E.0187
G1 X115.782 Y135.097 E.50705
G1 X115.772 Y135.215 E.00425
G1 X115.581 Y135.582 E.01478
G1 X115.215 Y135.772 E.01472
G1 X115.096 Y135.782 E.00425
G1 X96.904 Y135.782 E.64995
G1 X96.419 Y135.581 E.01875
G1 X96.303 Y135.358 E.009
; WIPE_START
G1 X96.228 Y135.215 E-.06121
G1 X96.218 Y135.096 E-.04515
G1 X96.218 Y133.376 E-.65365
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X103.769 Y134.491 Z.6 F12000
M73 P37 R12
G1 X115.289 Y136.192 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.43844
G1 F1200
M204 S500
G1 X115.096 Y136.2 E.00594
; LINE_WIDTH: 0.42172
G1 X96.904 Y136.2 E.53865
; WIPE_START
G1 X98.904 Y136.2 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X95.808 Y135.288 Z.6 F12000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.43826
G1 F1200
M204 S500
G1 X95.8 Y135.096 E.00594
; LINE_WIDTH: 0.42152
G1 X95.801 Y120.904 E.42
; LINE_WIDTH: 0.41966
G1 X95.801 Y120.903 E0
; WIPE_START
G1 X95.801 Y120.904 E-.00005
G1 X95.801 Y122.903 E-.75995
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X96.712 Y119.808 Z.6 F12000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.4381
G1 F1200
M204 S500
G1 X96.904 Y119.8 E.00593
; LINE_WIDTH: 0.42138
G1 X115.096 Y119.802 E.53816
; LINE_WIDTH: 0.41722
G1 X115.097 Y119.802 E.00001
; WIPE_START
G1 X115.096 Y119.802 E-.0001
G1 X113.097 Y119.802 E-.75991
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X116.2 Y120.904 Z.6 F12000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.42096
G1 F1200
M204 S500
G1 X116.199 Y135.096 E.41937
; LINE_WIDTH: 0.43636
G1 X116.191 Y135.288 E.00591
; WIPE_START
G1 X116.199 Y135.096 E-.07304
G1 X116.199 Y133.289 E-.68696
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X108.599 Y133.992 Z.6 F12000
G1 X96.675 Y135.096 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.49999
G1 F1200
M204 S500
G1 X96.675 Y120.904 E.50705
G1 X96.742 Y120.742 E.00626
G1 X96.904 Y120.675 E.00624
G1 X115.097 Y120.675 E.64995
G1 X115.258 Y120.742 E.00626
G1 X115.325 Y120.904 E.00623
G1 X115.325 Y135.096 E.50705
G1 X115.258 Y135.258 E.00626
G1 X115.096 Y135.325 E.00624
G1 X96.904 Y135.325 E.64995
G1 X96.742 Y135.258 E.00625
G1 X96.698 Y135.152 E.00411
; WIPE_START
G1 X96.695 Y133.152 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G17
G3 Z.6 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 1 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z0.6
M73 P37 R11
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer1 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 2/40
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
; open powerlost recovery
M1003 S1
M104 S240 ; set nozzle temperature
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G1 X162.62 Y118.027 F12000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.37467
G1 F6000
M204 S3000
G1 X162.416 Y117.756 E.0088
G1 X161.973 Y117.379 E.01508
G1 X162.62 Y117.379 E.01678
G1 X162.62 Y117.967 E.01525
; WIPE_START
G1 X162.416 Y117.756 E-.11164
G1 X161.973 Y117.379 E-.22097
G1 X162.62 Y117.379 E-.2459
G1 X162.62 Y117.856 E-.1815
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.489 Z.8 F12000
G1 X162.618 Y137.98 Z.8
G1 Z.4
M73 P38 R11
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.01661
G1 X161.971 Y138.622 E.01675
G1 X162.341 Y138.334 E.01213
G1 X162.581 Y138.027 E.01009
; WIPE_START
G1 X162.618 Y138.622 E-.22635
G1 X161.971 Y138.622 E-.24602
G1 X162.341 Y138.334 E-.17811
G1 X162.519 Y138.107 E-.10951
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y138.267 Z.8 F12000
G1 X138.024 Y138.621 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01684
G1 X137.667 Y138.343 E.01218
G1 X137.977 Y138.584 E.01019
; WIPE_START
G1 X137.379 Y138.621 E-.22767
G1 X137.379 Y137.972 E-.24658
G1 X137.667 Y138.343 E-.17839
G1 X137.89 Y138.517 E-.10736
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.943 Y130.884 Z.8 F12000
G1 X138.036 Y117.378 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.37271
G1 F6000
M204 S3000
G1 X137.665 Y117.657 E.01198
G1 X137.381 Y118.026 E.012
G1 X137.381 Y117.378 E.01671
G1 X137.976 Y117.378 E.01534
; WIPE_START
G1 X137.665 Y117.657 E-.15896
G1 X137.381 Y118.026 E-.17689
G1 X137.381 Y117.378 E-.24628
G1 X137.849 Y117.378 E-.17787
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.482 Y117.416 Z.8 F12000
G1 X161.367 Y117.497 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.45842
G1 F6000
M204 S3000
G1 X161.489 Y117.538 E.00416
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.0112
G1 X162.121 Y117.979 E.01347
G1 X162.333 Y118.26 E.0112
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01791
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.801 E.04916
; LINE_WIDTH: 0.44852
G1 X162.542 Y137.257 E.01461
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01104
G1 X162.092 Y138.062 E.01853
G1 X161.74 Y138.333 E.01413
G1 X161.394 Y138.502 E.01226
G1 X160.865 Y138.601 E.01713
; LINE_WIDTH: 0.43856
G1 X158.865 Y138.601 E.06185
; LINE_WIDTH: 0.43844
G1 X156.865 Y138.601 E.06183
; LINE_WIDTH: 0.43833
G1 X154.865 Y138.601 E.06181
; LINE_WIDTH: 0.43821
G1 X152.865 Y138.602 E.06179
; LINE_WIDTH: 0.4381
G1 X150.865 Y138.602 E.06178
; LINE_WIDTH: 0.43798
G1 X148.865 Y138.602 E.06176
; LINE_WIDTH: 0.43787
G1 X146.865 Y138.602 E.06174
; LINE_WIDTH: 0.43775
G1 X144.865 Y138.602 E.06172
; LINE_WIDTH: 0.43764
G1 X142.865 Y138.602 E.0617
; LINE_WIDTH: 0.43752
G1 X140.865 Y138.603 E.06168
; LINE_WIDTH: 0.43741
G1 X139.2 Y138.603 E.05134
; LINE_WIDTH: 0.44904
G1 X138.742 Y138.543 E.01464
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01103
G1 X137.939 Y138.093 E.01847
G1 X137.667 Y137.74 E.01418
G1 X137.489 Y137.356 E.01346
G1 X137.408 Y136.971 E.01253
; LINE_WIDTH: 0.44608
G1 X137.397 Y136.801 E.00537
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.398 Y119.168 E.05017
; LINE_WIDTH: 0.45045
G1 X137.493 Y118.626 E.01754
G1 X137.655 Y118.275 E.01229
; LINE_WIDTH: 0.44999
G1 X137.93 Y117.912 E.01451
G1 X138.4 Y117.587 E.01818
G1 X138.742 Y117.457 E.01164
; LINE_WIDTH: 0.44903
G1 X139.199 Y117.397 E.01463
; LINE_WIDTH: 0.43732
G1 X160.8 Y117.397 E.66589
; LINE_WIDTH: 0.45842
G3 X161.159 Y117.427 I.06 J1.455 E.01172
G1 X161.311 Y117.478 E.00518
M204 S10000
G1 X161.266 Y117.908 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01192
G3 X162.113 Y118.731 I-1.039 J1.312 E.02695
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01564
G3 X161.495 Y138.009 I-1.175 J-.892 E.01844
G1 X161.011 Y138.181 E.01633
G1 X160.864 Y138.2 E.0047
G1 X139.199 Y138.202 E.68932
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.926 E.01562
G3 X137.887 Y137.269 I1.117 J-1.335 E.02625
G1 X137.807 Y136.901 E.01198
G1 X137.799 Y119.168 E.56421
G1 X137.889 Y118.721 E.01452
G1 X137.984 Y118.515 E.00721
G1 X138.224 Y118.194 E.01273
G1 X138.613 Y117.934 E.01489
G1 X139.097 Y117.807 E.01594
G1 X139.199 Y117.798 E.00326
G1 X160.8 Y117.798 E.68728
G1 X161.103 Y117.834 E.00969
G1 X161.211 Y117.884 E.00379
M204 S250
G1 X161.113 Y118.244 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.462 E.01268
G1 X161.73 Y118.815 E.01271
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.801 E.51875
G1 X161.734 Y137.179 E.01138
G1 X161.538 Y137.484 E.01067
G1 X161.192 Y137.728 E.0125
G1 X160.864 Y137.808 E.00992
G1 X139.199 Y137.81 E.63852
G1 X138.821 Y137.734 E.01139
G1 X138.516 Y137.539 E.01065
G1 X138.27 Y137.185 E.01271
G1 X138.193 Y136.833 E.0106
G1 X138.191 Y119.168 E.52063
G1 X138.301 Y118.745 E.01288
G1 X138.544 Y118.436 E.01159
G1 X138.883 Y118.244 E.01148
G1 X139.199 Y118.19 E.00946
G1 X160.8 Y118.19 E.63663
G1 X161.054 Y118.233 E.00757
; WIPE_START
M204 S3000
G1 X161.484 Y118.462 E-.18504
G1 X161.73 Y118.815 E-.16382
G1 X161.81 Y119.199 E-.14898
G1 X161.81 Y119.889 E-.26215
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.259 Y127.508 Z.8 F12000
G1 X162.931 Y138.924 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.731 Y138.991 E.0067
G2 X160.865 Y138.997 I-.635 J97.478 E.05939
; LINE_WIDTH: 0.43856
G1 X158.865 Y138.997 E.06185
; LINE_WIDTH: 0.43844
G1 X156.865 Y138.997 E.06183
; LINE_WIDTH: 0.43833
G1 X154.865 Y138.997 E.06181
; LINE_WIDTH: 0.43821
G1 X152.865 Y138.997 E.06179
; LINE_WIDTH: 0.4381
G1 X150.865 Y138.997 E.06178
; LINE_WIDTH: 0.43798
G1 X148.865 Y138.997 E.06176
; LINE_WIDTH: 0.43787
G1 X146.865 Y138.997 E.06174
; LINE_WIDTH: 0.43775
G1 X144.865 Y138.997 E.06172
; LINE_WIDTH: 0.43764
G1 X142.865 Y138.997 E.0617
; LINE_WIDTH: 0.43752
G1 X140.865 Y138.997 E.06168
; LINE_WIDTH: 0.43741
G1 X139.2 Y138.997 E.05134
; LINE_WIDTH: 0.44657
G1 X138.991 Y138.993 E.0066
; LINE_WIDTH: 0.44999
G2 X137.301 Y138.991 I-1.209 J359.536 E.05376
G1 X137.075 Y138.93 E.00744
G1 X137.009 Y138.712 E.00723
G2 X137.003 Y136.801 I-90.415 J-.667 E.06082
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05018
; LINE_WIDTH: 0.45045
G2 X137.013 Y118.067 I-43.864 J-.837 E.03508
; LINE_WIDTH: 0.44999
G1 X137.013 Y117.258 E.02571
G1 X137.064 Y117.084 E.00579
G1 X137.248 Y117.009 E.00632
G2 X139.199 Y117.003 I.494 J-148.033 E.06207
; LINE_WIDTH: 0.43732
G1 X160.8 Y117.003 E.66589
; LINE_WIDTH: 0.45842
G2 X161.973 Y117.009 I.684 J-17.969 E.03809
; LINE_WIDTH: 0.44999
G1 X162.803 Y117.019 E.02639
G1 X162.949 Y117.104 E.0054
G1 X162.99 Y117.264 E.00526
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I88.025 J.676 E.06158
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.801 E.04916
; LINE_WIDTH: 0.44457
G1 X162.99 Y137.009 E.00655
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.716 I228.909 J1.245 E.0543
G1 X162.947 Y138.866 E.00496
M204 S10000
G1 X163.246 Y139.188 F12000
G1 F6000
M204 S3000
G1 X163.063 Y139.322 E.00721
G1 X162.759 Y139.398 E.00996
G1 X138.759 Y139.398 E.76361
G3 X137.108 Y139.376 I-.393 J-32.589 E.05256
G1 X136.848 Y139.275 E.00887
G1 X136.695 Y139.092 E.00759
G1 X136.602 Y138.748 E.01133
G1 X136.606 Y117.176 E.68635
G1 X136.701 Y116.897 E.0094
G1 X136.887 Y116.7 E.0086
G1 X137.229 Y116.602 E.01132
G1 X161.229 Y116.602 E.76361
G3 X162.955 Y116.629 I.613 J16.096 E.05495
G1 X163.194 Y116.775 E.00892
G1 X163.364 Y117.021 E.00951
G1 X163.397 Y117.264 E.00782
G1 X163.394 Y137.264 E.63634
G3 X163.376 Y138.898 I-39.894 J.376 E.05198
G1 X163.271 Y139.134 E.00822
M204 S250
G1 X163.561 Y139.425 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.55 Y139.443 E.00063
G1 X163.349 Y139.621 E.00793
G3 X162.786 Y139.79 I-.56 J-.845 E.01756
G1 X137.315 Y139.79 E.7507
G1 X136.895 Y139.739 E.01247
G1 X136.618 Y139.598 E.00916
G1 X136.425 Y139.413 E.00786
G1 X136.274 Y139.144 E.00911
G1 X136.21 Y138.783 E.0108
G1 X136.214 Y117.258 E.63437
G1 X136.288 Y116.822 E.01304
G1 X136.449 Y116.558 E.00912
G1 X136.683 Y116.359 E.00905
G3 X137.21 Y116.21 I.742 J1.617 E.01621
G1 X162.455 Y116.21 E.74403
G1 X163.066 Y116.249 E.01806
G1 X163.347 Y116.378 E.00912
G1 X163.6 Y116.621 E.01033
G1 X163.739 Y116.894 E.00905
G1 X163.789 Y117.264 E.011
G1 X163.786 Y138.716 E.63222
G1 X163.712 Y139.178 E.0138
G1 X163.593 Y139.373 E.00675
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.55 Y139.443 E-.03095
G1 X163.349 Y139.621 E-.10225
G1 X163.068 Y139.751 E-.1174
G1 X162.786 Y139.79 E-.10815
G1 X161.73 Y139.79 E-.40125
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.757 Y136.687 Z.8 F12000
G1 X116.39 Y119.614 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.706 J.19 E.0434
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
M73 P39 R11
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.223 J-103.836 E.04357
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.603 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.604 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.604 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.605 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.605 E.06146
; LINE_WIDTH: 0.43585
G1 X108.979 Y119.605 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.606 E.06138
; LINE_WIDTH: 0.43534
G1 X112.979 Y119.606 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.607 E.0613
; LINE_WIDTH: 0.43483
G1 X115.022 Y119.607 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.614 E.04163
M204 S10000
G1 X116.719 Y119.266 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.418 E.00544
G1 X116.798 Y136.537 E.54467
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.719 E.00694
G1 X95.202 Y136.56 E.00541
G1 X95.202 Y119.463 E.54396
G1 X95.288 Y119.251 E.0073
G1 X95.452 Y119.202 E.00546
G1 X116.562 Y119.207 E.67167
G1 X116.663 Y119.245 E.00342
M204 S250
G1 X116.884 Y118.888 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.075 Y119.057 E.00754
G3 X117.189 Y119.418 I-.885 J.479 E.01121
G1 X117.19 Y136.505 E.5036
G1 X117.132 Y136.845 E.01017
G3 X116.886 Y137.102 I-.831 J-.549 E.01055
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.62149
G1 X95.155 Y137.132 E.01018
G1 X94.955 Y136.98 E.00739
G3 X94.81 Y136.587 I.838 J-.531 E.01245
G1 X94.81 Y119.495 E.50373
G1 X94.868 Y119.155 E.01017
G3 X95.114 Y118.898 I.83 J.547 E.01054
G1 X95.417 Y118.81 E.00931
G1 X116.562 Y118.815 E.62319
G1 X116.825 Y118.874 E.00794
; WIPE_START
M204 S3000
G1 X117.075 Y119.057 E-.11771
G1 X117.129 Y119.174 E-.04863
G1 X117.189 Y119.418 E-.09557
G1 X117.189 Y120.729 E-.4981
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.921 Y125.083 Z.8 F12000
G1 X96.104 Y135.378 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00667
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01892
; LINE_WIDTH: 0.44605
G1 X96.979 Y119.997 E.00537
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.997 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.998 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.998 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.998 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.998 E.06146
; LINE_WIDTH: 0.43585
G1 X108.979 Y119.998 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.998 E.06138
; LINE_WIDTH: 0.43534
G1 X112.979 Y119.998 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.998 E.0613
; LINE_WIDTH: 0.43483
G1 X115.021 Y119.998 E.00132
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02403
G1 X116.003 Y120.979 E.0239
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.131 Y135.431 E.01033
M204 S10000
G1 X96.448 Y135.202 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00286
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.022 Y120.398 E.57408
G1 X115.433 Y120.569 E.01417
G1 X115.602 Y120.979 E.0141
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.476 Y135.255 E.00635
M204 S250
G1 X96.791 Y135.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y135.021 E.00007
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.846 I.021 J.24 E.0056
G1 X115.21 Y120.979 E.00424
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.814 Y135.079 E.00241
; WIPE_START
M204 S3000
G1 X96.79 Y135.021 E-.02371
G1 X96.79 Y133.084 E-.73629
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z.8 F12000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z.8 F12000
G1 X96.026 Y119.961 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17026
G1 X95.955 Y120.002 E-.29487
G1 X96.026 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.963 Z.8 F12000
G1 X116.022 Y119.965 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.41858
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00239
G1 X116.022 Y120.046 E.00239
G1 X116.046 Y120.006 E.00138
; WIPE_START
G1 X116.022 Y120.046 E-.17026
G1 X115.952 Y120.006 E-.29487
G1 X116.022 Y119.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y127.598 Z.8 F12000
G1 X116.021 Y135.957 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z.8 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 2 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z0.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer2 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 3/40
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.3747
G1 F6000
M204 S3000
G1 X162.415 Y117.756 E.00882
G1 X161.973 Y117.379 E.01507
G1 X162.621 Y117.379 E.01678
G1 X162.621 Y117.967 E.01526
; WIPE_START
G1 X162.415 Y117.756 E-.11188
G1 X161.973 Y117.379 E-.22084
G1 X162.621 Y117.379 E-.24592
G1 X162.621 Y117.856 E-.18136
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.488 Z1 F12000
G1 X162.621 Y137.976 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.37495
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01675
G1 X161.972 Y138.621 E.01684
G1 X162.343 Y138.333 E.01218
G1 X162.584 Y138.023 E.01019
; WIPE_START
G1 X162.621 Y138.621 E-.22772
G1 X161.972 Y138.621 E-.2466
G1 X162.343 Y138.333 E-.17838
G1 X162.516 Y138.11 E-.1073
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y138.269 Z1 F12000
G1 X138.023 Y138.618 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.37399
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.01669
G1 X137.378 Y137.971 E.01675
G1 X137.585 Y138.244 E.00886
G1 X137.978 Y138.579 E.01336
; WIPE_START
G1 X137.378 Y138.618 E-.22824
G1 X137.378 Y137.971 E-.24602
G1 X137.585 Y138.244 E-.13015
G1 X137.896 Y138.51 E-.15559
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.945 Y130.878 Z1 F12000
G1 X138.03 Y117.378 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.37373
G1 F6000
M204 S3000
G1 X137.663 Y117.658 E.01195
G1 X137.378 Y118.029 E.01209
G1 X137.378 Y117.378 E.01683
G1 X137.97 Y117.378 E.01532
; WIPE_START
G1 X137.663 Y117.658 E-.15812
G1 X137.378 Y118.029 E-.17762
G1 X137.378 Y117.378 E-.24733
M73 P40 R11
G1 X137.844 Y117.378 E-.17694
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.476 Y117.417 Z1 F12000
G1 X161.368 Y117.498 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.45832
G1 F6000
M204 S3000
G1 X161.488 Y117.538 E.00411
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.0112
G1 X162.121 Y117.979 E.01348
G1 X162.334 Y118.26 E.01122
G1 X162.511 Y118.644 E.01347
G1 X162.603 Y119.2 E.0179
; LINE_WIDTH: 0.43693
G1 X162.603 Y125.2 E.18478
; LINE_WIDTH: 0.43706
G1 X162.603 Y131.2 E.18484
; LINE_WIDTH: 0.43719
G1 X162.603 Y136.8 E.1726
; LINE_WIDTH: 0.44897
G1 X162.543 Y137.258 E.01464
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.584 E.01105
G1 X162.093 Y138.061 E.01847
G1 X161.74 Y138.334 E.01418
G1 X161.356 Y138.511 E.01345
G1 X160.801 Y138.603 E.01792
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.603 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.603 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.603 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.602 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.602 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.602 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.602 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.602 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.602 E.06143
; LINE_WIDTH: 0.43575
G1 X139.2 Y138.602 E.04915
; LINE_WIDTH: 0.45669
G3 X138.512 Y138.462 I-.059 J-1.47 E.02293
; LINE_WIDTH: 0.44999
G1 X138.201 Y138.296 E.0112
G1 X137.879 Y138.021 E.01347
G1 X137.667 Y137.74 E.0112
G1 X137.489 Y137.356 E.01347
G1 X137.397 Y136.8 E.01792
; LINE_WIDTH: 0.43735
G1 X137.397 Y130.8 E.18498
; LINE_WIDTH: 0.43746
G1 X137.398 Y124.8 E.18503
; LINE_WIDTH: 0.43756
G1 X137.398 Y119.168 E.17374
; LINE_WIDTH: 0.45078
G1 X137.493 Y118.626 E.01753
G1 X137.654 Y118.277 E.01224
; LINE_WIDTH: 0.44999
G1 X137.929 Y117.914 E.0145
G1 X138.352 Y117.61 E.01658
G1 X138.693 Y117.473 E.0117
; LINE_WIDTH: 0.4495
G1 X139.199 Y117.397 E.01627
; LINE_WIDTH: 0.43732
G1 X160.8 Y117.397 E.66589
; LINE_WIDTH: 0.45832
G3 X161.159 Y117.427 I.06 J1.455 E.0117
G1 X161.311 Y117.478 E.00523
M204 S10000
G1 X161.267 Y117.909 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01187
G3 X162.113 Y118.732 I-1.04 J1.313 E.02698
G1 X162.202 Y119.2 E.01515
G1 X162.202 Y136.8 E.56001
G1 X162.142 Y137.186 E.01242
G1 X161.925 Y137.627 E.01565
G3 X161.269 Y138.113 I-1.333 J-1.116 E.02622
G1 X160.801 Y138.202 E.01516
G1 X139.2 Y138.202 E.68728
G1 X138.898 Y138.166 E.00968
G1 X138.393 Y137.937 E.01763
G3 X137.887 Y137.269 I1.039 J-1.313 E.02696
G1 X137.798 Y136.8 E.01516
G1 X137.799 Y119.168 E.56102
G1 X137.889 Y118.721 E.0145
G1 X137.983 Y118.516 E.00718
G1 X138.222 Y118.196 E.0127
G1 X138.572 Y117.953 E.01357
G1 X139.086 Y117.809 E.01698
G1 X139.199 Y117.798 E.00362
G1 X160.8 Y117.798 E.68728
G1 X161.102 Y117.834 E.00967
G1 X161.212 Y117.884 E.00385
M204 S250
G1 X161.114 Y118.244 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.461 E.01264
G1 X161.73 Y118.816 E.01273
G1 X161.81 Y119.2 E.01155
G1 X161.81 Y136.8 E.51873
G1 X161.733 Y137.179 E.0114
G1 X161.538 Y137.484 E.01067
G1 X161.185 Y137.73 E.01269
G1 X160.801 Y137.81 E.01156
G1 X139.2 Y137.81 E.63663
G1 X138.888 Y137.757 E.00931
G1 X138.516 Y137.539 E.01271
G1 X138.27 Y137.185 E.01272
G1 X138.19 Y136.8 E.01156
G1 X138.191 Y119.168 E.51967
G1 X138.301 Y118.746 E.01285
G1 X138.538 Y118.44 E.01141
G1 X138.849 Y118.256 E.01064
G1 X139.199 Y118.19 E.01051
G1 X160.8 Y118.19 E.63663
G1 X161.055 Y118.233 E.00761
; WIPE_START
M204 S3000
G1 X161.484 Y118.461 E-.18448
G1 X161.73 Y118.816 E-.16409
G1 X161.81 Y119.2 E-.14894
G1 X161.81 Y119.89 E-.2625
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.257 Y127.51 Z1 F12000
G1 X162.926 Y138.923 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.712 Y138.991 E.00714
G2 X160.801 Y138.997 I-.665 J90.519 E.06083
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.997 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.997 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.996 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.996 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.996 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.996 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.995 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.995 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.995 E.06143
; LINE_WIDTH: 0.43575
G1 X139.2 Y138.995 E.04915
; LINE_WIDTH: 0.44121
G1 X139.038 Y138.992 E.00505
; LINE_WIDTH: 0.44999
G2 X137.257 Y138.987 I-1.235 J132.442 E.05664
G1 X137.084 Y138.936 E.00575
G1 X137.009 Y138.751 E.00634
G2 X137.003 Y136.8 I-93.332 J-.672 E.06207
; LINE_WIDTH: 0.43735
G1 X137.003 Y130.8 E.18498
; LINE_WIDTH: 0.43746
G1 X137.003 Y124.8 E.18503
; LINE_WIDTH: 0.43756
G1 X137.003 Y119.168 E.17374
; LINE_WIDTH: 0.45078
G2 X137.009 Y118.069 I-46.617 J-.812 E.03504
; LINE_WIDTH: 0.44999
G1 X137.009 Y117.315 E.02397
G1 X137.071 Y117.079 E.00775
G1 X137.268 Y117.009 E.00664
G1 X138.647 Y117.009 E.0439
; LINE_WIDTH: 0.4495
G1 X139.199 Y117.003 E.01755
; LINE_WIDTH: 0.43732
G1 X160.8 Y117.003 E.66589
; LINE_WIDTH: 0.45832
G2 X161.972 Y117.009 I.684 J-18.024 E.03806
; LINE_WIDTH: 0.44999
G1 X162.78 Y117.018 E.0257
G1 X162.932 Y117.081 E.00522
G1 X162.99 Y117.263 E.00608
; LINE_WIDTH: 0.45007
G2 X162.997 Y119.2 I89.032 J.663 E.06162
; LINE_WIDTH: 0.43693
G1 X162.997 Y125.2 E.18478
; LINE_WIDTH: 0.43706
G1 X162.997 Y131.2 E.18484
; LINE_WIDTH: 0.43719
G1 X162.997 Y136.8 E.1726
; LINE_WIDTH: 0.44622
G1 X162.993 Y137.009 E.00658
; LINE_WIDTH: 0.44999
G2 X162.991 Y138.722 I330.226 J1.207 E.05449
G1 X162.945 Y138.866 E.00482
M204 S10000
G1 X163.278 Y139.147 F12000
G1 F6000
M204 S3000
G1 X163.081 Y139.315 E.00823
G1 X162.748 Y139.398 E.01092
G1 X137.176 Y139.394 E.81362
G1 X136.897 Y139.299 E.0094
G1 X136.7 Y139.113 E.00862
G1 X136.602 Y138.771 E.01131
G1 X136.602 Y118.771 E.63634
G3 X136.626 Y117.118 I21.807 J-.511 E.05263
G1 X136.718 Y116.857 E.0088
G1 X136.931 Y116.687 E.00868
G1 X137.24 Y116.602 E.01018
G1 X162.455 Y116.602 E.80226
G1 X162.985 Y116.638 E.01692
G1 X163.182 Y116.758 E.00732
G1 X163.365 Y117.029 E.01041
G1 X163.397 Y117.263 E.00753
G1 X163.398 Y137.263 E.63634
G3 X163.376 Y138.892 I-32.161 J.384 E.05184
G1 X163.299 Y139.091 E.00678
M204 S250
G1 X163.575 Y139.405 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.379 Y139.6 E.00816
G1 X163.145 Y139.725 E.00781
G1 X162.783 Y139.79 E.01085
G1 X137.257 Y139.786 E.7523
G1 X136.822 Y139.713 E.013
G1 X136.559 Y139.551 E.00912
G1 X136.359 Y139.317 E.00906
G3 X136.21 Y138.79 I1.597 J-.736 E.0162
G1 X136.21 Y117.315 E.63292
G1 X136.275 Y116.854 E.01371
G1 X136.4 Y116.621 E.00781
G1 X136.618 Y116.402 E.0091
G1 X136.939 Y116.248 E.0105
G1 X137.213 Y116.21 E.00816
G1 X162.703 Y116.21 E.75125
G1 X163.104 Y116.26 E.0119
G3 X163.74 Y116.898 I-.391 J1.027 E.02738
G1 X163.789 Y117.263 E.01085
G1 X163.79 Y138.685 E.63135
G1 X163.739 Y139.105 E.01246
G1 X163.611 Y139.357 E.00835
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.379 Y139.6 E-.12762
G1 X163.145 Y139.725 E-.10068
G1 X162.783 Y139.79 E-.13987
G1 X161.752 Y139.79 E-.39183
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.778 Y136.688 Z1 F12000
G1 X116.39 Y119.614 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.713 J.19 E.0434
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-104.878 J-.21 E.04357
; LINE_WIDTH: 0.43721
G1 X95.603 Y133.021 E.06164
; LINE_WIDTH: 0.43706
G1 X95.603 Y131.021 E.06161
; LINE_WIDTH: 0.43692
G1 X95.604 Y129.021 E.06159
; LINE_WIDTH: 0.43678
G1 X95.604 Y127.021 E.06157
; LINE_WIDTH: 0.43664
G1 X95.604 Y125.021 E.06155
; LINE_WIDTH: 0.4365
G1 X95.604 Y123.021 E.06153
; LINE_WIDTH: 0.43636
G1 X95.604 Y121.021 E.0615
; LINE_WIDTH: 0.43622
G1 X95.604 Y120.978 E.00132
; LINE_WIDTH: 0.44999
G1 X95.612 Y119.609 E.04356
G2 X96.979 Y119.603 I.223 J-103.32 E.0435
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.603 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.604 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.604 E.06154
; LINE_WIDTH: 0.43636
G1 X104.979 Y119.605 E.0615
; LINE_WIDTH: 0.43611
G1 X106.979 Y119.605 E.06146
; LINE_WIDTH: 0.43586
G1 X108.979 Y119.605 E.06143
; LINE_WIDTH: 0.43561
G1 X110.979 Y119.606 E.06139
; LINE_WIDTH: 0.43535
G1 X112.979 Y119.606 E.06135
; LINE_WIDTH: 0.4351
G1 X114.979 Y119.607 E.06131
; LINE_WIDTH: 0.43485
G1 X115.022 Y119.607 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.614 E.04163
M204 S10000
G1 X116.728 Y119.27 F12000
G1 F6000
M204 S3000
G1 X116.739 Y119.274 E.00038
G1 X116.797 Y119.442 E.00565
G1 X116.798 Y136.537 E.54391
G1 X116.719 Y136.74 E.00694
G1 X116.56 Y136.798 E.0054
G1 X95.463 Y136.798 E.67122
G1 X95.25 Y136.712 E.00731
G1 X95.202 Y136.548 E.00544
G1 X95.204 Y119.414 E.54518
G1 X95.28 Y119.26 E.00545
G1 X95.44 Y119.202 E.00541
G1 X116.563 Y119.207 E.67205
G1 X116.672 Y119.249 E.00372
M204 S250
G1 X116.873 Y118.885 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.887 Y118.888 E.00043
G3 X117.189 Y119.442 I-.375 J.564 E.01933
G1 X117.19 Y136.505 E.50289
G1 X117.132 Y136.845 E.01018
G1 X116.98 Y137.045 E.0074
G3 X116.587 Y137.19 I-.532 J-.838 E.01245
G1 X95.495 Y137.19 E.62162
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.55 J-.833 E.01054
G1 X94.81 Y136.583 E.00929
G1 X94.812 Y119.455 E.5048
G1 X94.866 Y119.158 E.0089
G1 X95.02 Y118.955 E.0075
G3 X95.413 Y118.81 I.537 J.853 E.01245
G1 X116.563 Y118.815 E.62332
G1 X116.814 Y118.872 E.0076
; WIPE_START
M204 S3000
G1 X116.887 Y118.888 E-.02832
G1 X117.045 Y119.017 E-.07751
G1 X117.16 Y119.224 E-.08994
G1 X117.189 Y119.442 E-.08346
G1 X117.189 Y120.707 E-.48077
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.924 Y125.066 Z1 F12000
G1 X96.104 Y135.378 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00667
; LINE_WIDTH: 0.44614
M73 P41 R11
G1 X95.997 Y135.021 E.00537
; LINE_WIDTH: 0.43721
G1 X95.997 Y133.021 E.06164
; LINE_WIDTH: 0.43706
G1 X95.997 Y131.021 E.06161
; LINE_WIDTH: 0.43692
G1 X95.997 Y129.021 E.06159
; LINE_WIDTH: 0.43678
G1 X95.998 Y127.021 E.06157
; LINE_WIDTH: 0.43664
G1 X95.998 Y125.021 E.06155
; LINE_WIDTH: 0.4365
G1 X95.998 Y123.021 E.06153
; LINE_WIDTH: 0.43636
G1 X95.998 Y121.021 E.0615
; LINE_WIDTH: 0.43622
G1 X95.998 Y120.979 E.00132
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.024
G1 X96.808 Y120.008 E.01888
; LINE_WIDTH: 0.44605
G1 X96.979 Y119.997 E.00537
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.997 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.998 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.998 E.06154
; LINE_WIDTH: 0.43636
G1 X104.979 Y119.998 E.0615
; LINE_WIDTH: 0.43611
G1 X106.979 Y119.998 E.06146
; LINE_WIDTH: 0.43586
G1 X108.979 Y119.998 E.06143
; LINE_WIDTH: 0.43561
G1 X110.979 Y119.998 E.06139
; LINE_WIDTH: 0.43535
G1 X112.979 Y119.998 E.06135
; LINE_WIDTH: 0.4351
G1 X114.979 Y119.998 E.06131
; LINE_WIDTH: 0.43485
G1 X115.021 Y119.998 E.00132
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02403
G1 X116.003 Y120.979 E.02391
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02397
G1 X96.131 Y135.431 E.01033
M204 S10000
G1 X96.026 Y135.957 F12000
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
M204 S10000
G1 X96.448 Y135.202 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00287
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.978 E.44681
G1 X96.568 Y120.568 E.01416
G1 X96.878 Y120.407 E.01111
G1 X96.979 Y120.398 E.0032
G1 X115.022 Y120.398 E.57408
G1 X115.433 Y120.569 E.01417
G1 X115.602 Y120.979 E.0141
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.476 Y135.255 E.00635
M204 S250
G1 X96.791 Y135.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y135.021 E.00007
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.846 I.021 J.24 E.0056
G1 X115.21 Y120.979 E.00424
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.814 Y135.079 E.00241
; WIPE_START
M204 S3000
G1 X96.79 Y135.021 E-.02372
G1 X96.79 Y133.084 E-.73628
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.347 Y125.464 Z1 F12000
G1 X96.027 Y119.961 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42052
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00241
G1 X96.027 Y120.043 E.00241
G1 X96.051 Y120.002 E.00139
; WIPE_START
G1 X96.027 Y120.043 E-.17025
G1 X95.957 Y120.002 E-.29487
G1 X96.027 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.66 Y119.962 Z1 F12000
G1 X116.022 Y119.965 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.4186
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00239
G1 X116.022 Y120.046 E.00239
G1 X116.046 Y120.006 E.00138
; WIPE_START
G1 X116.022 Y120.046 E-.17025
G1 X115.952 Y120.006 E-.29488
G1 X116.022 Y119.965 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y127.597 Z1 F12000
G1 X116.021 Y135.957 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 3 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    
      M400
      G90
      M83
      M204 S5000
      G0 Z2 F4000
      G0 X261 Y250 F20000
      M400 P200
      G39 S1
      G0 Z2 F4000
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
        M623
    
    M623
M623
; SKIPPABLE_END


G1 Z1.000
; object ids of this layer3 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 4/40
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
M106 S76.5
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.37469
G1 F6000
M204 S3000
G1 X162.415 Y117.756 E.00882
G1 X161.973 Y117.379 E.01507
G1 X162.621 Y117.379 E.01678
G1 X162.621 Y117.967 E.01526
; WIPE_START
G1 X162.415 Y117.756 E-.11188
G1 X161.973 Y117.379 E-.22079
G1 X162.621 Y117.379 E-.24591
G1 X162.621 Y117.856 E-.18142
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.489 Z1.2 F12000
G1 X162.621 Y137.976 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.37496
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01675
G1 X161.972 Y138.621 E.01684
G1 X162.343 Y138.333 E.01218
G1 X162.584 Y138.023 E.01019
; WIPE_START
G1 X162.621 Y138.621 E-.22768
G1 X161.972 Y138.621 E-.24661
G1 X162.343 Y138.333 E-.1784
G1 X162.517 Y138.11 E-.10731
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y138.269 Z1.2 F12000
G1 X138.02 Y138.618 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.01661
G1 X137.378 Y137.971 E.01675
G1 X137.666 Y138.341 E.01212
G1 X137.973 Y138.581 E.01009
; WIPE_START
G1 X137.378 Y138.618 E-.22636
G1 X137.378 Y137.971 E-.24597
G1 X137.666 Y138.341 E-.17806
G1 X137.893 Y138.519 E-.1096
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.944 Y130.886 Z1.2 F12000
G1 X138.033 Y117.378 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.37264
G1 F6000
M204 S3000
G1 X137.665 Y117.657 E.01192
G1 X137.381 Y118.026 E.01199
G1 X137.381 Y117.378 E.01671
G1 X137.973 Y117.378 E.01526
; WIPE_START
G1 X137.665 Y117.657 E-.15822
G1 X137.381 Y118.026 E-.17676
G1 X137.381 Y117.378 E-.24633
G1 X137.851 Y117.378 E-.1787
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.484 Y117.417 Z1.2 F12000
G1 X161.37 Y117.498 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.45834
G1 F6000
M204 S3000
G1 X161.488 Y117.538 E.00407
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.0112
G1 X162.121 Y117.979 E.01347
G1 X162.333 Y118.26 E.01121
; LINE_WIDTH: 0.45227
G1 X162.502 Y118.604 E.01227
G1 X162.6 Y119.131 E.01716
; LINE_WIDTH: 0.43834
G1 X162.601 Y121.131 E.06181
; LINE_WIDTH: 0.43821
G1 X162.601 Y123.131 E.06179
; LINE_WIDTH: 0.43809
G1 X162.601 Y125.131 E.06177
; LINE_WIDTH: 0.43797
G1 X162.601 Y127.131 E.06176
; LINE_WIDTH: 0.43785
G1 X162.602 Y129.131 E.06174
; LINE_WIDTH: 0.43773
G1 X162.602 Y131.131 E.06172
; LINE_WIDTH: 0.43761
G1 X162.602 Y133.131 E.0617
; LINE_WIDTH: 0.43749
G1 X162.603 Y135.131 E.06168
; LINE_WIDTH: 0.43737
G1 X162.603 Y136.8 E.05145
; LINE_WIDTH: 0.44896
G1 X162.543 Y137.257 E.01463
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01104
G1 X162.093 Y138.061 E.01848
G1 X161.74 Y138.334 E.01419
G1 X161.356 Y138.511 E.01346
G1 X160.801 Y138.603 E.01791
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.603 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.603 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.603 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.602 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.602 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.602 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.602 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.602 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.602 E.06143
; LINE_WIDTH: 0.43575
G1 X139.199 Y138.602 E.04916
; LINE_WIDTH: 0.44856
G1 X138.743 Y138.543 E.0146
; LINE_WIDTH: 0.44999
G3 X138.167 Y138.277 I.448 J-1.726 E.02028
G3 X137.667 Y137.74 I1.098 J-1.526 E.0235
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.8 E.01792
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.8 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.8 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.8 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.8 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.8 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.8 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.8 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.8 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05018
; LINE_WIDTH: 0.45046
G1 X137.493 Y118.626 E.01751
G1 X137.653 Y118.278 E.01221
; LINE_WIDTH: 0.44999
G1 X137.929 Y117.913 E.01456
G1 X138.357 Y117.608 E.01671
G1 X138.698 Y117.471 E.01171
; LINE_WIDTH: 0.44945
G1 X139.199 Y117.397 E.01609
; LINE_WIDTH: 0.43732
G1 X160.8 Y117.397 E.66589
; LINE_WIDTH: 0.45834
G3 X161.159 Y117.427 I.06 J1.455 E.01171
G1 X161.313 Y117.479 E.00527
M204 S10000
G1 X161.268 Y117.909 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01183
G3 X162.009 Y118.506 I-.807 J1.137 E.01917
G1 X162.18 Y118.984 E.01616
G1 X162.199 Y119.132 E.00474
G1 X162.202 Y136.8 E.56217
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01564
G3 X161.269 Y138.113 I-1.334 J-1.117 E.02625
G1 X160.801 Y138.202 E.01516
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.0124
G1 X138.373 Y137.926 E.01565
G3 X137.887 Y137.269 I1.116 J-1.334 E.02624
G1 X137.798 Y136.8 E.01516
G1 X137.799 Y119.168 E.56103
G1 X137.889 Y118.721 E.0145
G1 X137.983 Y118.516 E.00717
G1 X138.222 Y118.196 E.01272
G1 X138.576 Y117.951 E.01371
G1 X139.087 Y117.809 E.01687
G1 X139.199 Y117.798 E.00359
G1 X160.8 Y117.798 E.68728
G1 X161.103 Y117.834 E.00968
G1 X161.214 Y117.885 E.00388
M204 S250
G1 X161.115 Y118.245 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.461 E.0126
G1 X161.728 Y118.808 E.01251
G1 X161.807 Y119.132 E.00981
G1 X161.81 Y136.8 E.52074
M73 P42 R11
G1 X161.734 Y137.179 E.01139
G1 X161.538 Y137.484 E.01067
G1 X161.184 Y137.73 E.01271
G1 X160.801 Y137.81 E.01155
G1 X139.199 Y137.81 E.63663
G1 X138.821 Y137.734 E.01138
G1 X138.571 Y137.587 E.00853
G1 X138.304 Y137.258 E.0125
G1 X138.19 Y136.801 E.01389
G1 X138.191 Y119.168 E.51968
G1 X138.301 Y118.746 E.01284
G1 X138.538 Y118.441 E.01139
G1 X138.853 Y118.255 E.01078
G1 X139.199 Y118.19 E.01039
G1 X160.8 Y118.19 E.63663
G1 X161.056 Y118.234 E.00765
; WIPE_START
M204 S3000
G1 X161.484 Y118.461 E-.18397
G1 X161.728 Y118.808 E-.16126
G1 X161.807 Y119.132 E-.12655
G1 X161.807 Y119.89 E-.28823
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.256 Y127.509 Z1.2 F12000
G1 X162.929 Y138.921 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.732 Y138.991 E.00665
G2 X160.801 Y138.997 I-.674 J91.46 E.06145
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.997 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.997 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.996 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.996 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.996 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.995 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.995 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.995 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.995 E.06143
; LINE_WIDTH: 0.43575
G1 X139.199 Y138.995 E.04916
; LINE_WIDTH: 0.44485
G1 X138.991 Y138.99 E.00655
; LINE_WIDTH: 0.44999
G2 X137.266 Y138.987 I-1.258 J242.658 E.05488
G1 X137.09 Y138.942 E.00579
G1 X137.009 Y138.751 E.00661
G2 X137.003 Y136.8 I-92.311 J-.687 E.06206
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.8 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.8 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.8 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.8 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.8 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.8 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.8 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.8 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05018
; LINE_WIDTH: 0.45241
G2 X137.013 Y118.071 I-17.669 J-.664 E.03512
; LINE_WIDTH: 0.44999
G1 X137.013 Y117.257 E.02587
G1 X137.064 Y117.084 E.00576
G1 X137.249 Y117.009 E.00633
G1 X138.653 Y117.009 E.04469
; LINE_WIDTH: 0.44945
G1 X139.199 Y117.003 E.01735
; LINE_WIDTH: 0.43732
G1 X160.8 Y117.003 E.66589
; LINE_WIDTH: 0.45834
G2 X161.973 Y117.009 I.684 J-18.016 E.03807
; LINE_WIDTH: 0.44999
G1 X162.781 Y117.018 E.02572
G1 X162.933 Y117.083 E.00526
G1 X162.99 Y117.263 E.00601
G1 X162.99 Y118.039 E.0247
; LINE_WIDTH: 0.45227
G2 X162.996 Y119.131 I38.75 J.337 E.03495
; LINE_WIDTH: 0.43834
G1 X162.996 Y121.131 E.06181
; LINE_WIDTH: 0.43821
G1 X162.996 Y123.131 E.06179
; LINE_WIDTH: 0.43809
G1 X162.996 Y125.131 E.06177
; LINE_WIDTH: 0.43797
G1 X162.996 Y127.131 E.06176
; LINE_WIDTH: 0.43785
G1 X162.997 Y129.131 E.06174
; LINE_WIDTH: 0.43773
G1 X162.997 Y131.131 E.06172
; LINE_WIDTH: 0.43761
G1 X162.997 Y133.131 E.0617
; LINE_WIDTH: 0.43749
G1 X162.997 Y135.131 E.06168
; LINE_WIDTH: 0.43737
G1 X162.997 Y136.8 E.05145
; LINE_WIDTH: 0.44622
G1 X162.993 Y137.009 E.00658
; LINE_WIDTH: 0.44999
G2 X162.991 Y138.722 I329.974 J1.207 E.05449
G1 X162.947 Y138.863 E.00472
M204 S10000
G1 X163.278 Y139.147 F12000
G1 F6000
M204 S3000
G1 X163.068 Y139.314 E.00855
G1 X162.76 Y139.398 E.01016
G1 X137.266 Y139.394 E.81114
G1 X136.946 Y139.333 E.01038
G1 X136.7 Y139.113 E.0105
G1 X136.602 Y138.771 E.01131
G1 X136.606 Y117.176 E.68708
G1 X136.701 Y116.897 E.00939
G1 X136.887 Y116.7 E.00861
G1 X137.229 Y116.602 E.01131
G1 X162.455 Y116.602 E.80261
G1 X162.988 Y116.639 E.01701
G1 X163.179 Y116.756 E.00713
G1 X163.365 Y117.028 E.0105
G1 X163.397 Y117.263 E.00754
G1 X163.398 Y137.263 E.63634
G3 X163.38 Y138.868 I-37.398 J.384 E.05106
G1 X163.299 Y139.091 E.00755
M204 S250
G1 X163.577 Y139.403 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.382 Y139.598 E.00813
G1 X163.065 Y139.752 E.01038
G1 X162.787 Y139.79 E.00827
G1 X137.266 Y139.786 E.75215
G1 X136.787 Y139.697 E.01435
G1 X136.56 Y139.552 E.00795
G1 X136.359 Y139.317 E.00912
G3 X136.21 Y138.79 I1.573 J-.729 E.01621
G1 X136.214 Y117.257 E.63462
G1 X136.287 Y116.822 E.013
G1 X136.449 Y116.558 E.00912
G1 X136.683 Y116.359 E.00905
G3 X137.21 Y116.21 I.737 J1.598 E.01621
G1 X162.703 Y116.21 E.75136
G1 X163.107 Y116.261 E.012
G1 X163.347 Y116.377 E.00786
G1 X163.574 Y116.587 E.00912
G1 X163.741 Y116.898 E.01039
G1 X163.789 Y117.263 E.01084
G1 X163.79 Y138.699 E.63176
G1 X163.739 Y139.105 E.01208
G1 X163.612 Y139.355 E.00826
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.382 Y139.598 E-.12716
G1 X163.065 Y139.752 E-.13386
G1 X162.787 Y139.79 E-.10663
G1 X161.754 Y139.79 E-.39236
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.78 Y136.688 Z1.2 F12000
G1 X116.39 Y119.614 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I101.623 J.206 E.0434
; LINE_WIDTH: 0.43691
G1 X116.396 Y122.979 E.06159
; LINE_WIDTH: 0.43679
G1 X116.396 Y124.979 E.06157
; LINE_WIDTH: 0.43667
G1 X116.396 Y126.979 E.06155
; LINE_WIDTH: 0.43655
G1 X116.396 Y128.979 E.06153
; LINE_WIDTH: 0.43643
G1 X116.396 Y130.979 E.06151
; LINE_WIDTH: 0.43631
G1 X116.396 Y132.979 E.0615
; LINE_WIDTH: 0.4362
G1 X116.395 Y134.979 E.06148
; LINE_WIDTH: 0.43608
G1 X116.395 Y135.021 E.00132
; LINE_WIDTH: 0.44498
G1 X116.391 Y135.227 E.00645
; LINE_WIDTH: 0.44999
G1 X116.388 Y136.391 E.03704
G2 X115.021 Y136.397 I-.196 J104.88 E.04349
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.223 J-103.676 E.04357
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.603 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.604 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.604 E.06154
; LINE_WIDTH: 0.43636
G1 X104.979 Y119.605 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.605 E.06146
; LINE_WIDTH: 0.43585
G1 X108.979 Y119.605 E.06142
; LINE_WIDTH: 0.4356
G1 X110.979 Y119.606 E.06138
; LINE_WIDTH: 0.43535
G1 X112.979 Y119.606 E.06135
; LINE_WIDTH: 0.43509
G1 X114.979 Y119.607 E.06131
; LINE_WIDTH: 0.43484
G1 X115.022 Y119.607 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.614 E.04163
M204 S10000
G1 X116.689 Y119.246 F12000
G1 F6000
M204 S3000
G1 X116.721 Y119.255 E.00104
G1 X116.797 Y119.451 E.0067
G1 X116.795 Y136.589 E.54528
G1 X116.712 Y136.749 E.00576
G1 X116.548 Y136.798 E.00546
G1 X95.463 Y136.798 E.67085
G1 X95.251 Y136.712 E.0073
G1 X95.202 Y136.548 E.00546
G1 X95.202 Y119.463 E.54358
G1 X95.28 Y119.26 E.00693
G1 X95.441 Y119.202 E.00542
G1 X116.554 Y119.207 E.67177
G1 X116.631 Y119.229 E.00256
M204 S250
G1 X116.796 Y118.867 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.011 Y118.981 E.00716
G1 X117.152 Y119.202 E.00774
G1 X117.189 Y119.451 E.00741
G1 X117.187 Y135.451 E.47156
G3 X117.167 Y136.717 I-22.218 J.272 E.03734
G3 X116.886 Y137.102 I-.633 J-.167 E.01438
G1 X116.583 Y137.19 E.00931
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.547 J-.829 E.01054
G1 X94.81 Y136.583 E.0093
G1 X94.81 Y119.495 E.50361
G1 X94.868 Y119.155 E.01017
G1 X95.02 Y118.955 E.0074
G3 X95.414 Y118.81 I.532 J.837 E.01247
G1 X115.414 Y118.815 E.58945
G3 X116.743 Y118.841 I.288 J19.271 E.03919
; WIPE_START
M204 S3000
G1 X117.011 Y118.981 E-.11489
G1 X117.152 Y119.202 E-.09976
G1 X117.189 Y119.451 E-.09552
G1 X117.189 Y120.635 E-.44983
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.934 Y125.008 Z1.2 F12000
G1 X96.103 Y135.376 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01892
; LINE_WIDTH: 0.44605
G1 X96.979 Y119.997 E.00537
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.997 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.998 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.998 E.06154
; LINE_WIDTH: 0.43636
M73 P42 R10
G1 X104.979 Y119.998 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.998 E.06146
; LINE_WIDTH: 0.43585
G1 X108.979 Y119.998 E.06142
; LINE_WIDTH: 0.4356
G1 X110.979 Y119.998 E.06138
; LINE_WIDTH: 0.43535
G1 X112.979 Y119.998 E.06135
; LINE_WIDTH: 0.43509
G1 X114.979 Y119.998 E.06131
; LINE_WIDTH: 0.43484
G1 X115.021 Y119.998 E.00132
; LINE_WIDTH: 0.44999
G1 X115.721 Y120.282 E.02403
G1 X116.003 Y120.979 E.02391
; LINE_WIDTH: 0.43691
G1 X116.003 Y122.979 E.06159
; LINE_WIDTH: 0.43679
G1 X116.002 Y124.979 E.06157
; LINE_WIDTH: 0.43667
G1 X116.002 Y126.979 E.06155
; LINE_WIDTH: 0.43655
G1 X116.002 Y128.979 E.06153
; LINE_WIDTH: 0.43643
G1 X116.002 Y130.979 E.06151
; LINE_WIDTH: 0.43631
G1 X116.002 Y132.979 E.0615
; LINE_WIDTH: 0.4362
G1 X116.002 Y134.979 E.06148
; LINE_WIDTH: 0.43608
G1 X116.002 Y135.021 E.00132
; LINE_WIDTH: 0.44498
G1 X115.992 Y135.192 E.00536
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01894
G1 X115.192 Y135.992 E.01887
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.13 Y135.43 E.01039
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.022 Y120.398 E.57408
G1 X115.433 Y120.569 E.01417
G1 X115.602 Y120.979 E.0141
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.828 J.022 E.00457
G1 X115.431 Y135.433 E.01115
G1 X115.122 Y135.593 E.0111
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.846 I.021 J.24 E.0056
G1 X115.21 Y120.979 E.00424
M73 P43 R10
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X104.358 Y134.209 Z1.2 F12000
G1 X116.02 Y135.958 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42046
G1 F6000
M204 S3000
G1 X115.949 Y135.999 E.00241
G1 X116.02 Y136.039 E.00241
G1 X116.043 Y135.999 E.00139
; WIPE_START
G1 X116.02 Y136.039 E-.17026
G1 X115.949 Y135.999 E-.29487
G1 X116.02 Y135.958 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y128.325 Z1.2 F12000
G1 X116.022 Y119.965 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.41852
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00239
G1 X116.022 Y120.046 E.00239
G1 X116.046 Y120.006 E.00138
; WIPE_START
G1 X116.022 Y120.046 E-.17026
G1 X115.952 Y120.006 E-.29487
G1 X116.022 Y119.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X108.39 Y119.964 Z1.2 F12000
G1 X96.026 Y119.961 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17026
G1 X95.955 Y120.002 E-.29487
G1 X96.026 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y127.594 Z1.2 F12000
G1 X96.026 Y135.957 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.2 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 4 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.2 F4000
            G39.3 S1
            G0 Z1.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer4 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 5/40
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.62 Y118.027 F12000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.37463
G1 F6000
M204 S3000
G1 X162.333 Y117.657 E.01215
G1 X161.975 Y117.379 E.01174
G1 X162.621 Y117.379 E.01673
G1 X162.62 Y117.967 E.01525
; WIPE_START
G1 X162.333 Y117.657 E-.16076
G1 X161.975 Y117.379 E-.17204
G1 X162.621 Y117.379 E-.24515
G1 X162.62 Y117.858 E-.18206
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.49 Z1.4 F12000
G1 X162.618 Y137.98 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.0166
G1 X161.971 Y138.622 E.01675
G1 X162.341 Y138.334 E.01213
G1 X162.581 Y138.027 E.01009
; WIPE_START
G1 X162.618 Y138.622 E-.22635
G1 X161.971 Y138.622 E-.246
G1 X162.341 Y138.334 E-.17809
G1 X162.519 Y138.107 E-.10957
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y138.266 Z1.4 F12000
G1 X138.02 Y138.618 Z1.4
G1 Z1
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.01661
G1 X137.378 Y137.971 E.01675
G1 X137.666 Y138.341 E.01212
G1 X137.973 Y138.581 E.01009
; WIPE_START
G1 X137.378 Y138.618 E-.22639
G1 X137.378 Y137.971 E-.24597
G1 X137.666 Y138.341 E-.17805
G1 X137.893 Y138.519 E-.10959
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y130.886 Z1.4 F12000
G1 X138.029 Y117.378 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X137.757 Y117.585 E.00884
G1 X137.382 Y118.021 E.0149
G1 X137.382 Y117.378 E.01664
G1 X137.969 Y117.378 E.0152
; WIPE_START
G1 X137.757 Y117.585 E-.11256
G1 X137.382 Y118.021 E-.21879
G1 X137.382 Y117.378 E-.24442
G1 X137.867 Y117.378 E-.18424
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.499 Y117.424 Z1.4 F12000
G1 X161.423 Y117.518 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y117.577 E.00544
G1 X162.061 Y117.907 E.01847
G1 X162.334 Y118.26 E.01419
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01791
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.801 E.04916
; LINE_WIDTH: 0.44852
G1 X162.542 Y137.258 E.01461
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01103
G1 X162.092 Y138.062 E.01853
G1 X161.74 Y138.334 E.01413
G1 X161.356 Y138.511 E.01346
G1 X160.801 Y138.603 E.01791
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.603 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.603 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.603 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.602 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.602 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.602 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.602 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.602 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.602 E.06143
; LINE_WIDTH: 0.43575
G1 X139.2 Y138.602 E.04915
; LINE_WIDTH: 0.44856
G1 X138.743 Y138.543 E.01461
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01105
G1 X137.938 Y138.092 E.01853
G1 X137.667 Y137.74 E.01413
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.8 E.01792
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.8 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.8 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.8 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.8 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.167 E.05018
; LINE_WIDTH: 0.44792
G1 X137.448 Y118.772 E.01262
; LINE_WIDTH: 0.44999
G3 X138.26 Y117.667 I1.782 J.458 E.04472
G1 X138.643 Y117.49 E.01345
G1 X139.199 Y117.397 E.01792
; LINE_WIDTH: 0.43731
G1 X160.8 Y117.397 E.66588
; LINE_WIDTH: 0.44901
G1 X161.257 Y117.457 E.01462
; LINE_WIDTH: 0.44999
G1 X161.367 Y117.497 E.0037
M204 S10000
G1 X161.316 Y117.922 F12000
G1 F6000
M204 S3000
G1 X161.627 Y118.075 E.01105
G3 X162.113 Y118.731 I-1.116 J1.333 E.02623
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.801 E.56003
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01563
G3 X161.269 Y138.113 I-1.334 J-1.117 E.02625
G1 X160.801 Y138.202 E.01516
G1 X139.2 Y138.202 E.68728
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.925 E.01565
G3 X137.887 Y137.269 I1.116 J-1.333 E.02623
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.167 E.56104
G1 X137.847 Y118.843 E.01042
G1 X138.069 Y118.382 E.01628
G3 X138.505 Y117.991 I1.154 J.849 E.01877
G1 X138.731 Y117.887 E.00791
G1 X139.199 Y117.798 E.01516
G1 X160.8 Y117.798 E.68729
G1 X161.186 Y117.858 E.01241
G1 X161.262 Y117.895 E.0027
M204 S250
G1 X161.151 Y118.261 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y118.266 E.00083
G1 X161.484 Y118.462 E.01068
G1 X161.73 Y118.815 E.01269
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.801 E.51875
G1 X161.734 Y137.179 E.01138
G1 X161.538 Y137.484 E.01066
G1 X161.184 Y137.73 E.01271
G1 X160.801 Y137.81 E.01156
G1 X139.2 Y137.81 E.63663
G1 X138.821 Y137.734 E.01139
G1 X138.516 Y137.538 E.01067
G1 X138.27 Y137.185 E.0127
G1 X138.19 Y136.801 E.01156
G1 X138.191 Y119.167 E.51969
G1 X138.254 Y118.854 E.00944
G1 X138.462 Y118.516 E.01168
G1 X138.742 Y118.304 E.01036
G1 X139.199 Y118.19 E.01388
G1 X160.8 Y118.19 E.63664
G1 X161.093 Y118.249 E.00878
; WIPE_START
M204 S3000
G1 X161.179 Y118.266 E-.03356
G1 X161.484 Y118.462 E-.13766
G1 X161.73 Y118.815 E-.16366
G1 X161.81 Y119.199 E-.14904
G1 X161.81 Y119.926 E-.27607
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.262 Y127.545 Z1.4 F12000
G1 X162.936 Y138.916 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.751 Y138.991 E.00634
G2 X160.801 Y138.997 I-.684 J92.558 E.06207
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.997 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.997 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.996 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.996 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.996 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.995 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.995 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.995 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.995 E.06143
; LINE_WIDTH: 0.43575
G1 X139.2 Y138.995 E.04915
; LINE_WIDTH: 0.44484
G1 X138.991 Y138.99 E.00655
; LINE_WIDTH: 0.44999
G2 X137.257 Y138.987 I-1.265 J244.652 E.05517
G1 X137.084 Y138.936 E.00575
G1 X137.009 Y138.751 E.00634
G2 X137.003 Y136.8 I-92.407 J-.686 E.06207
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.8 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.8 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.8 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.8 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.8 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.8 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.8 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.8 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.167 E.05018
; LINE_WIDTH: 0.44525
G1 X137.01 Y118.958 E.00658
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.225 I-233.947 J-1.228 E.05516
G1 X137.086 Y117.066 E.00556
G1 X137.267 Y117.009 E.00605
G2 X139.199 Y117.003 I.663 J-92.56 E.06147
; LINE_WIDTH: 0.43731
G1 X160.8 Y117.003 E.66588
; LINE_WIDTH: 0.44649
G1 X161.009 Y117.008 E.00658
; LINE_WIDTH: 0.44999
G2 X162.727 Y117.009 I1.223 J-357.568 E.05467
G1 X162.93 Y117.075 E.0068
G1 X162.99 Y117.291 E.00712
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I86.792 J.663 E.06073
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.801 E.04916
; LINE_WIDTH: 0.44458
G1 X162.99 Y137.01 E.00656
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.743 I232.681 J1.26 E.05513
M73 P44 R10
G1 X162.953 Y138.858 E.00384
M204 S10000
G1 X163.26 Y139.143 F12000
G1 F6000
M204 S3000
G1 X163.113 Y139.3 E.00685
G1 X162.771 Y139.398 E.0113
G1 X137.176 Y139.394 E.81435
G1 X136.897 Y139.299 E.0094
G1 X136.7 Y139.113 E.00861
G1 X136.602 Y138.771 E.01131
G1 X136.606 Y117.176 E.68708
G1 X136.703 Y116.895 E.00946
G1 X136.895 Y116.693 E.00887
G1 X137.24 Y116.602 E.01134
G1 X161.24 Y116.602 E.76361
G3 X162.815 Y116.611 I.394 J70.387 E.05012
G1 X163.129 Y116.707 E.01047
G1 X163.343 Y116.969 E.01075
G1 X163.397 Y117.291 E.01039
G1 X163.394 Y138.824 E.6851
G1 X163.3 Y139.099 E.00926
M204 S250
G1 X163.561 Y139.425 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.551 Y139.441 E.00057
G1 X163.317 Y139.641 E.00907
G3 X162.79 Y139.79 I-.737 J-1.599 E.0162
G1 X137.257 Y139.786 E.75252
G1 X136.822 Y139.713 E.01301
G1 X136.559 Y139.551 E.00911
G1 X136.359 Y139.317 E.00906
G3 X136.21 Y138.79 I1.599 J-.737 E.0162
G1 X136.214 Y117.282 E.63391
G3 X136.817 Y116.3 I1.056 J-.027 E.03591
G1 X137.213 Y116.21 E.01198
G1 X161.213 Y116.21 E.70733
G3 X162.963 Y116.238 I.621 J16.119 E.05159
G1 X163.232 Y116.321 E.0083
G1 X163.55 Y116.557 E.01167
G1 X163.712 Y116.821 E.00912
G1 X163.789 Y117.291 E.01405
G1 X163.786 Y138.743 E.63222
G1 X163.713 Y139.178 E.013
G1 X163.593 Y139.374 E.00677
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.551 Y139.441 E-.03018
G1 X163.317 Y139.641 E-.11689
G1 X163.125 Y139.716 E-.07858
G1 X162.79 Y139.79 E-.13001
G1 X161.726 Y139.79 E-.40435
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.753 Y136.687 Z1.4 F12000
G1 X116.39 Y119.614 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.708 J.19 E.0434
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-104.471 J-.212 E.04357
; LINE_WIDTH: 0.43721
G1 X95.603 Y133.021 E.06164
; LINE_WIDTH: 0.43707
G1 X95.603 Y131.021 E.06161
; LINE_WIDTH: 0.43693
G1 X95.604 Y129.021 E.06159
; LINE_WIDTH: 0.43679
G1 X95.604 Y127.021 E.06157
; LINE_WIDTH: 0.43665
G1 X95.604 Y125.021 E.06155
; LINE_WIDTH: 0.43651
G1 X95.604 Y123.021 E.06153
; LINE_WIDTH: 0.43637
G1 X95.604 Y121.021 E.06151
; LINE_WIDTH: 0.43623
G1 X95.604 Y120.978 E.00132
; LINE_WIDTH: 0.44999
G1 X95.612 Y119.609 E.04356
G2 X96.979 Y119.603 I.225 J-102.767 E.0435
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.603 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.604 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.604 E.06154
; LINE_WIDTH: 0.43636
G1 X104.979 Y119.605 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.605 E.06146
; LINE_WIDTH: 0.43585
G1 X108.979 Y119.605 E.06142
; LINE_WIDTH: 0.4356
G1 X110.979 Y119.606 E.06138
; LINE_WIDTH: 0.43535
G1 X112.979 Y119.606 E.06135
; LINE_WIDTH: 0.43509
G1 X114.979 Y119.607 E.06131
; LINE_WIDTH: 0.43484
G1 X115.022 Y119.607 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.614 E.04163
M204 S10000
G1 X116.63 Y119.222 F12000
G1 F6000
M204 S3000
G1 X116.744 Y119.278 E.00405
G1 X116.797 Y119.451 E.00575
G1 X116.798 Y136.537 E.54363
G1 X116.72 Y136.74 E.00693
G1 X116.56 Y136.798 E.00541
G1 X95.463 Y136.798 E.67123
G1 X95.25 Y136.712 E.00731
G1 X95.202 Y136.548 E.00544
G1 X95.204 Y119.414 E.54517
G1 X95.288 Y119.25 E.00583
G1 X95.452 Y119.202 E.00545
G1 X116.573 Y119.207 E.67201
M204 S250
G1 X116.802 Y118.87 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.968 Y118.955 E.0055
G1 X117.152 Y119.198 E.00899
G1 X117.189 Y119.45 E.00752
G1 X117.19 Y136.505 E.50263
G1 X117.132 Y136.845 E.01017
G1 X116.98 Y137.045 E.0074
G3 X116.587 Y137.19 I-.532 J-.839 E.01245
G1 X95.495 Y137.19 E.62162
G1 X95.155 Y137.132 E.01018
G3 X94.898 Y136.886 I.549 J-.831 E.01054
G1 X94.81 Y136.583 E.0093
G1 X94.812 Y120.583 E.47156
G3 X94.833 Y119.285 I22.894 J-.288 E.03825
G3 X95.114 Y118.898 I.632 J.163 E.01446
G1 X95.417 Y118.81 E.0093
G1 X116.554 Y118.815 E.62296
G3 X116.748 Y118.843 I0 J.684 E.00579
; WIPE_START
M204 S3000
G1 X116.968 Y118.955 E-.09362
G1 X117.152 Y119.198 E-.1159
G1 X117.189 Y119.45 E-.0969
G1 X117.189 Y120.644 E-.45358
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.933 Y125.015 Z1.4 F12000
G1 X96.103 Y135.376 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44614
G1 X95.997 Y135.021 E.00537
; LINE_WIDTH: 0.43721
G1 X95.997 Y133.021 E.06164
; LINE_WIDTH: 0.43707
G1 X95.997 Y131.021 E.06161
; LINE_WIDTH: 0.43693
G1 X95.997 Y129.021 E.06159
; LINE_WIDTH: 0.43679
G1 X95.998 Y127.021 E.06157
; LINE_WIDTH: 0.43665
G1 X95.998 Y125.021 E.06155
; LINE_WIDTH: 0.43651
G1 X95.998 Y123.021 E.06153
; LINE_WIDTH: 0.43637
G1 X95.998 Y121.021 E.06151
; LINE_WIDTH: 0.43623
G1 X95.998 Y120.979 E.00132
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.024
G1 X96.808 Y120.008 E.01888
; LINE_WIDTH: 0.44605
G1 X96.979 Y119.997 E.00537
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.997 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.998 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.998 E.06154
; LINE_WIDTH: 0.43636
G1 X104.979 Y119.998 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.998 E.06146
; LINE_WIDTH: 0.43585
G1 X108.979 Y119.998 E.06142
; LINE_WIDTH: 0.4356
G1 X110.979 Y119.998 E.06138
; LINE_WIDTH: 0.43535
G1 X112.979 Y119.998 E.06135
; LINE_WIDTH: 0.43509
G1 X114.979 Y119.998 E.06131
; LINE_WIDTH: 0.43484
G1 X115.021 Y119.998 E.00132
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02403
G1 X116.003 Y120.979 E.02391
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02397
G1 X96.13 Y135.429 E.0104
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.978 E.44681
G1 X96.568 Y120.568 E.01416
G1 X96.878 Y120.407 E.01111
G1 X115.022 Y120.398 E.57727
G1 X115.433 Y120.569 E.01417
G1 X115.602 Y120.979 E.0141
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.946 Y120.793 E.00334
G1 X114.979 Y120.79 E.53146
G3 X115.155 Y120.846 I.021 J.24 E.0056
G1 X115.21 Y120.979 E.00424
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.355 Y125.458 Z1.4 F12000
G1 X96.027 Y119.961 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42052
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00241
G1 X96.027 Y120.043 E.00241
G1 X96.051 Y120.002 E.00139
; WIPE_START
G1 X96.027 Y120.043 E-.17025
G1 X95.957 Y120.002 E-.29487
G1 X96.027 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y127.593 Z1.4 F12000
G1 X96.026 Y135.957 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17026
G1 X95.955 Y135.998 E-.29487
G1 X96.026 Y135.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y135.957 Z1.4 F12000
G1 X116.021 Y135.957 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y128.324 Z1.4 F12000
G1 X116.022 Y119.965 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.41858
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00239
G1 X116.022 Y120.046 E.00239
G1 X116.046 Y120.006 E.00138
; WIPE_START
G1 X116.022 Y120.046 E-.17026
G1 X115.952 Y120.006 E-.29487
G1 X116.022 Y119.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.4 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 5 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.4 F4000
            G39.3 S1
            G0 Z1.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer5 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 6/40
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.62 Y118.027 F12000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.37464
G1 F6000
M204 S3000
G1 X162.415 Y117.756 E.0088
G1 X161.974 Y117.379 E.01507
G1 X162.621 Y117.379 E.01677
G1 X162.62 Y117.967 E.01525
; WIPE_START
G1 X162.415 Y117.756 E-.1117
G1 X161.974 Y117.379 E-.22086
G1 X162.621 Y117.379 E-.24585
G1 X162.62 Y117.857 E-.18158
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.489 Z1.6 F12000
M73 P45 R10
G1 X162.618 Y137.98 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.0166
G1 X161.971 Y138.622 E.01675
G1 X162.341 Y138.334 E.01213
G1 X162.581 Y138.027 E.01008
; WIPE_START
G1 X162.618 Y138.622 E-.22629
G1 X161.971 Y138.622 E-.24603
G1 X162.341 Y138.334 E-.17813
G1 X162.519 Y138.107 E-.10954
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y138.267 Z1.6 F12000
G1 X138.024 Y138.621 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01684
G1 X137.667 Y138.343 E.01218
G1 X137.977 Y138.584 E.0102
; WIPE_START
G1 X137.379 Y138.621 E-.22772
G1 X137.379 Y137.972 E-.2466
G1 X137.667 Y138.343 E-.17839
G1 X137.89 Y138.517 E-.10729
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.941 Y130.884 Z1.6 F12000
G1 X138.033 Y117.378 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.37261
G1 F6000
M204 S3000
G1 X137.664 Y117.657 E.01192
G1 X137.381 Y118.026 E.01198
G1 X137.381 Y117.378 E.0167
G1 X137.973 Y117.378 E.01525
; WIPE_START
G1 X137.664 Y117.657 E-.15823
G1 X137.381 Y118.026 E-.17666
G1 X137.381 Y117.378 E-.24631
G1 X137.852 Y117.378 E-.1788
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.484 Y117.417 Z1.6 F12000
G1 X161.372 Y117.499 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.45833
G1 F6000
M204 S3000
G1 X161.489 Y117.538 E.00399
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.0112
G1 X162.121 Y117.979 E.01347
G1 X162.334 Y118.26 E.01121
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01791
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.8 E.04915
; LINE_WIDTH: 0.44852
G1 X162.542 Y137.257 E.01461
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01104
G1 X162.092 Y138.062 E.01853
G1 X161.74 Y138.333 E.01413
G1 X161.356 Y138.511 E.01346
G1 X160.801 Y138.603 E.01792
; LINE_WIDTH: 0.43732
G1 X139.2 Y138.603 E.66589
; LINE_WIDTH: 0.44904
G1 X138.742 Y138.543 E.01465
; LINE_WIDTH: 0.44999
G1 X138.416 Y138.423 E.01105
G1 X137.939 Y138.093 E.01846
G1 X137.666 Y137.74 E.01419
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.167 E.05019
; LINE_WIDTH: 0.45046
G1 X137.493 Y118.626 E.01751
G1 X137.653 Y118.279 E.01217
; LINE_WIDTH: 0.44999
G1 X137.929 Y117.913 E.01457
G1 X138.35 Y117.611 E.0165
G1 X138.693 Y117.473 E.01177
; LINE_WIDTH: 0.4495
G1 X139.199 Y117.397 E.01627
; LINE_WIDTH: 0.43731
G1 X160.8 Y117.397 E.66588
; LINE_WIDTH: 0.45833
G3 X161.159 Y117.427 I.06 J1.455 E.01172
G1 X161.316 Y117.48 E.00536
M204 S10000
G1 X161.271 Y117.911 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01174
G3 X162.113 Y118.732 I-1.039 J1.312 E.02696
G1 X162.202 Y119.199 E.01515
G1 X162.202 Y136.8 E.56001
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01563
G3 X161.269 Y138.113 I-1.334 J-1.117 E.02625
G1 X160.801 Y138.202 E.01516
G1 X139.2 Y138.202 E.68728
G1 X138.814 Y138.142 E.01242
G1 X138.373 Y137.925 E.01564
G3 X137.991 Y137.494 I.893 J-1.175 E.01844
G1 X137.887 Y137.269 E.00791
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.167 E.56104
G1 X137.889 Y118.721 E.01449
G1 X137.983 Y118.517 E.00714
G1 X138.221 Y118.197 E.0127
G1 X138.571 Y117.953 E.01357
G1 X139.086 Y117.809 E.01702
G1 X139.199 Y117.798 E.00362
G1 X160.8 Y117.798 E.68728
G1 X161.103 Y117.834 E.00969
G1 X161.216 Y117.886 E.00397
M204 S250
G1 X161.118 Y118.246 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.461 E.01251
G1 X161.73 Y118.816 E.01272
G1 X161.81 Y119.199 E.01155
G1 X161.81 Y136.8 E.51874
G1 X161.734 Y137.179 E.01139
G1 X161.539 Y137.484 E.01066
G1 X161.185 Y137.73 E.01271
G1 X160.801 Y137.81 E.01156
G1 X139.2 Y137.81 E.63663
G1 X138.821 Y137.733 E.0114
G1 X138.516 Y137.538 E.01066
G1 X138.304 Y137.258 E.01037
G1 X138.19 Y136.801 E.01388
G1 X138.191 Y119.167 E.51969
G1 X138.301 Y118.746 E.01283
G1 X138.536 Y118.443 E.01132
G1 X138.849 Y118.256 E.01075
G1 X139.199 Y118.19 E.01051
G1 X160.8 Y118.19 E.63663
G1 X161.059 Y118.234 E.00774
; WIPE_START
M204 S3000
G1 X161.484 Y118.461 E-.18296
G1 X161.73 Y118.816 E-.16395
G1 X161.81 Y119.199 E-.14897
G1 X161.81 Y119.895 E-.26412
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.259 Y127.514 Z1.6 F12000
G1 X162.932 Y138.923 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.732 Y138.991 E.00672
G2 X160.801 Y138.997 I-.661 J92.61 E.06144
; LINE_WIDTH: 0.43732
G1 X139.2 Y138.997 E.66589
; LINE_WIDTH: 0.44657
G1 X138.991 Y138.993 E.00659
; LINE_WIDTH: 0.44999
G2 X137.315 Y138.991 I-1.198 J353.309 E.05331
G1 X137.071 Y138.924 E.00805
G1 X137.009 Y138.732 E.00643
G2 X137.003 Y136.8 I-91.427 J-.676 E.06145
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.8 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.8 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.8 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.8 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.8 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.8 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.8 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.8 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.167 E.05019
; LINE_WIDTH: 0.45244
G2 X137.013 Y118.072 I-17.65 J-.663 E.03506
; LINE_WIDTH: 0.44999
G1 X137.013 Y117.26 E.02584
G1 X137.065 Y117.083 E.00588
G1 X137.249 Y117.009 E.0063
G1 X138.647 Y117.009 E.0445
; LINE_WIDTH: 0.4495
G1 X139.199 Y117.003 E.01754
; LINE_WIDTH: 0.43731
G1 X160.8 Y117.003 E.66588
; LINE_WIDTH: 0.44285
G1 X160.963 Y117.006 E.00508
; LINE_WIDTH: 0.44999
G2 X162.706 Y117.009 I1.2 J-160.209 E.05545
G1 X162.901 Y117.049 E.00633
G1 X162.99 Y117.207 E.00577
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I90.657 J.705 E.06341
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.8 E.04915
; LINE_WIDTH: 0.44457
G1 X162.99 Y137.009 E.00654
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.716 I229.105 J1.246 E.05433
G1 X162.947 Y138.865 E.00489
M204 S10000
G1 X163.247 Y139.188 F12000
G1 F6000
M204 S3000
G1 X163.057 Y139.325 E.00745
G1 X162.76 Y139.398 E.00975
G1 X138.76 Y139.398 E.76361
G3 X137.1 Y139.371 I-.394 J-26.712 E.05281
G1 X136.809 Y139.243 E.01013
G1 X136.678 Y139.062 E.00711
G1 X136.602 Y138.76 E.0099
G1 X136.606 Y117.176 E.68672
G1 X136.701 Y116.897 E.00938
G1 X136.882 Y116.704 E.00843
G1 X137.229 Y116.602 E.01151
G1 X161.229 Y116.602 E.76361
G3 X162.816 Y116.611 I.372 J75.592 E.0505
G1 X163.129 Y116.707 E.01042
G1 X163.338 Y116.952 E.01023
G1 X163.397 Y117.2 E.00812
G1 X163.394 Y137.2 E.63634
G3 X163.376 Y138.898 I-41.606 J.408 E.05402
G1 X163.271 Y139.133 E.00819
M204 S250
G1 X163.56 Y139.426 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.55 Y139.443 E.00056
G3 X162.786 Y139.79 I-.818 J-.785 E.02533
G1 X137.315 Y139.79 E.7507
G1 X136.858 Y139.726 E.0136
G1 X136.556 Y139.549 E.01031
G3 X136.21 Y138.787 I.786 J-.817 E.02527
G1 X136.214 Y117.26 E.63445
G1 X136.287 Y116.822 E.01308
G1 X136.449 Y116.558 E.00912
G1 X136.676 Y116.363 E.00882
G3 X137.21 Y116.21 I.756 J1.624 E.01643
G1 X162.706 Y116.21 E.75143
G1 X163.107 Y116.261 E.01192
G1 X163.451 Y116.469 E.01186
G1 X163.697 Y116.786 E.01182
G1 X163.789 Y117.2 E.0125
G1 X163.786 Y138.716 E.63413
G1 X163.713 Y139.178 E.01376
G1 X163.592 Y139.375 E.00683
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.55 Y139.443 E-.03007
G1 X163.344 Y139.625 E-.10452
G1 X163.066 Y139.751 E-.11596
G1 X162.786 Y139.79 E-.10738
G1 X161.728 Y139.79 E-.40207
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.755 Y136.687 Z1.6 F12000
G1 X116.39 Y119.614 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.704 J.19 E.0434
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
M73 P46 R10
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.223 J-103.836 E.04357
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.603 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.604 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.604 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.605 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.605 E.06146
; LINE_WIDTH: 0.43584
G1 X108.979 Y119.605 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.606 E.06138
; LINE_WIDTH: 0.43533
G1 X112.979 Y119.606 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.607 E.0613
; LINE_WIDTH: 0.43482
G1 X115.022 Y119.607 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.614 E.04163
M204 S10000
G1 X116.718 Y119.265 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.418 E.00546
G1 X116.798 Y136.537 E.54467
G1 X116.712 Y136.75 E.0073
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.72 E.00694
G1 X95.202 Y136.56 E.00541
G1 X95.202 Y119.463 E.54396
G1 X95.288 Y119.251 E.0073
G1 X95.452 Y119.202 E.00545
G1 X116.562 Y119.207 E.67167
G1 X116.662 Y119.245 E.00339
M204 S250
G1 X116.881 Y118.886 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.075 Y119.058 E.00763
G3 X117.189 Y119.418 I-.876 J.475 E.0112
G1 X117.19 Y136.505 E.5036
G1 X117.132 Y136.845 E.01017
G3 X116.886 Y137.102 I-.832 J-.549 E.01055
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.62149
G1 X95.155 Y137.132 E.01018
G1 X94.955 Y136.98 E.00739
G3 X94.81 Y136.587 I.838 J-.532 E.01245
G1 X94.81 Y119.495 E.50373
G1 X94.868 Y119.155 E.01018
G3 X95.114 Y118.898 I.829 J.547 E.01054
G1 X95.417 Y118.81 E.0093
G1 X116.562 Y118.815 E.62319
G1 X116.823 Y118.873 E.00786
; WIPE_START
M204 S3000
G1 X117.075 Y119.058 E-.11881
G1 X117.13 Y119.176 E-.04933
G1 X117.189 Y119.418 E-.09483
G1 X117.189 Y120.726 E-.49703
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.926 Y125.088 Z1.6 F12000
G1 X96.117 Y135.403 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01892
; LINE_WIDTH: 0.44605
G1 X96.979 Y119.997 E.00537
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.997 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.998 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.998 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.998 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.998 E.06146
; LINE_WIDTH: 0.43584
G1 X108.979 Y119.998 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.998 E.06138
; LINE_WIDTH: 0.43533
G1 X112.979 Y119.998 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.998 E.0613
; LINE_WIDTH: 0.43482
G1 X115.021 Y119.998 E.00132
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02403
G1 X116.003 Y120.979 E.0239
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.022 Y120.398 E.57408
G1 X115.433 Y120.569 E.01418
G1 X115.602 Y120.979 E.0141
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.846 I.021 J.24 E.0056
G1 X115.21 Y120.979 E.00424
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z1.6 F12000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z1.6 F12000
G1 X96.026 Y119.961 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17026
G1 X95.955 Y120.002 E-.29487
G1 X96.026 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.963 Z1.6 F12000
G1 X116.022 Y119.965 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00239
G1 X116.022 Y120.046 E.00239
G1 X116.046 Y120.006 E.00138
; WIPE_START
G1 X116.022 Y120.046 E-.17026
G1 X115.952 Y120.006 E-.29487
G1 X116.022 Y119.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y127.598 Z1.6 F12000
G1 X116.021 Y135.957 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.6 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 6 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.6 F4000
            G39.3 S1
            G0 Z1.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer6 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 7/40
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.37465
G1 F6000
M204 S3000
G1 X162.416 Y117.756 E.0088
G1 X161.974 Y117.379 E.01508
G1 X162.621 Y117.379 E.01678
G1 X162.621 Y117.967 E.01525
; WIPE_START
G1 X162.416 Y117.756 E-.11165
G1 X161.974 Y117.379 E-.22098
G1 X162.621 Y117.379 E-.24586
G1 X162.621 Y117.856 E-.18151
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.489 Z1.8 F12000
G1 X162.621 Y137.976 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01675
G1 X161.972 Y138.621 E.01685
G1 X162.343 Y138.333 E.01219
G1 X162.584 Y138.023 E.01019
; WIPE_START
G1 X162.621 Y138.621 E-.2277
G1 X161.972 Y138.621 E-.24667
G1 X162.343 Y138.333 E-.17846
G1 X162.516 Y138.111 E-.10718
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y138.27 Z1.8 F12000
G1 X138.024 Y138.621 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.37496
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01684
G1 X137.667 Y138.343 E.01218
G1 X137.977 Y138.584 E.01019
; WIPE_START
G1 X137.379 Y138.621 E-.22768
G1 X137.379 Y137.972 E-.24662
G1 X137.667 Y138.343 E-.17841
G1 X137.89 Y138.517 E-.10729
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y130.884 Z1.8 F12000
G1 X138.035 Y117.378 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X137.736 Y117.601 E.00965
G1 X137.382 Y118.021 E.01422
G1 X137.382 Y117.378 E.01664
G1 X137.975 Y117.378 E.01535
; WIPE_START
G1 X137.736 Y117.601 E-.12419
M73 P47 R10
G1 X137.382 Y118.021 E-.20888
G1 X137.382 Y117.378 E-.24441
G1 X137.862 Y117.378 E-.18253
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.494 Y117.418 Z1.8 F12000
G1 X161.374 Y117.499 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.45828
G1 F6000
M204 S3000
G1 X161.489 Y117.538 E.00394
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.01121
G1 X162.121 Y117.979 E.01347
G1 X162.333 Y118.26 E.01119
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01792
; LINE_WIDTH: 0.43693
G1 X162.603 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.603 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.603 Y136.801 E.17261
; LINE_WIDTH: 0.44897
G1 X162.543 Y137.258 E.01463
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01104
G1 X162.093 Y138.061 E.01847
G1 X161.74 Y138.334 E.01419
G1 X161.356 Y138.511 E.01345
G1 X160.801 Y138.603 E.01791
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.603 E.66589
; LINE_WIDTH: 0.44904
G1 X138.742 Y138.543 E.01465
; LINE_WIDTH: 0.44999
G1 X138.416 Y138.423 E.01104
G1 X137.939 Y138.093 E.01846
G1 X137.666 Y137.74 E.01419
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05017
; LINE_WIDTH: 0.4479
G1 X137.448 Y118.773 E.01261
; LINE_WIDTH: 0.44999
G1 X137.557 Y118.463 E.01045
G3 X138.965 Y117.409 I1.695 J.797 E.05823
; LINE_WIDTH: 0.44752
G1 X139.135 Y117.399 E.0054
; LINE_WIDTH: 0.43859
G1 X141.135 Y117.399 E.06185
; LINE_WIDTH: 0.43846
G1 X143.135 Y117.399 E.06183
; LINE_WIDTH: 0.43833
G1 X145.135 Y117.399 E.06181
; LINE_WIDTH: 0.43821
G1 X147.135 Y117.398 E.06179
; LINE_WIDTH: 0.43808
G1 X149.135 Y117.398 E.06177
; LINE_WIDTH: 0.43796
G1 X151.135 Y117.398 E.06175
; LINE_WIDTH: 0.43783
G1 X153.135 Y117.398 E.06173
; LINE_WIDTH: 0.43771
G1 X155.135 Y117.398 E.06171
; LINE_WIDTH: 0.43758
G1 X157.135 Y117.398 E.06169
; LINE_WIDTH: 0.43746
G1 X159.135 Y117.397 E.06168
; LINE_WIDTH: 0.43733
G1 X160.8 Y117.397 E.05134
; LINE_WIDTH: 0.45828
G3 X161.159 Y117.427 I.06 J1.455 E.01171
G1 X161.317 Y117.48 E.00541
M204 S10000
G1 X161.272 Y117.911 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.0117
G3 X162.113 Y118.731 I-1.038 J1.311 E.02694
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01241
G1 X161.925 Y137.627 E.01564
G3 X161.269 Y138.113 I-1.334 J-1.117 E.02624
G1 X160.801 Y138.202 E.01516
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.01242
G1 X138.373 Y137.926 E.01563
G3 X137.887 Y137.268 I1.117 J-1.335 E.02625
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.168 E.56102
G1 X137.847 Y118.844 E.01042
G1 X138.069 Y118.382 E.01629
G3 X138.669 Y117.909 I1.311 J1.046 E.02453
G1 X139.135 Y117.8 E.01522
G1 X160.8 Y117.798 E.68933
G1 X161.102 Y117.834 E.00968
G1 X161.218 Y117.887 E.00403
M204 S250
G1 X161.119 Y118.247 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.462 E.01248
G1 X161.73 Y118.815 E.0127
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.801 E.51875
G1 X161.734 Y137.179 E.01139
G1 X161.538 Y137.484 E.01067
G1 X161.184 Y137.73 E.0127
G1 X160.801 Y137.81 E.01156
G1 X139.199 Y137.81 E.63664
G1 X138.82 Y137.733 E.0114
G1 X138.516 Y137.538 E.01065
G1 X138.27 Y137.184 E.01271
G1 X138.19 Y136.801 E.01155
G1 X138.191 Y119.168 E.51968
G1 X138.254 Y118.854 E.00944
G1 X138.459 Y118.518 E.01158
G1 X138.776 Y118.287 E.01157
G1 X139.135 Y118.193 E.01095
G1 X160.8 Y118.19 E.63853
G1 X161.061 Y118.234 E.00779
; WIPE_START
M204 S3000
G1 X161.484 Y118.462 E-.18253
G1 X161.73 Y118.815 E-.16375
G1 X161.81 Y119.199 E-.14905
G1 X161.81 Y119.896 E-.26467
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.258 Y127.515 Z1.8 F12000
G1 X162.929 Y138.925 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.71 Y138.991 E.00727
G2 X160.801 Y138.997 I-.651 J91.355 E.06075
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.997 E.66589
; LINE_WIDTH: 0.44657
G1 X138.99 Y138.993 E.00659
; LINE_WIDTH: 0.44999
G2 X137.301 Y138.991 I-1.205 J358.273 E.05376
G1 X137.075 Y138.93 E.00743
G1 X137.009 Y138.712 E.00723
G2 X137.003 Y136.8 I-90.2 J-.668 E.06083
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.8 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.8 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.8 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.8 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05017
; LINE_WIDTH: 0.44519
G1 X137.01 Y118.959 E.00656
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.225 I-232.32 J-1.229 E.05519
G1 X137.086 Y117.066 E.00556
G1 X137.266 Y117.009 E.00602
G2 X139.135 Y117.003 I.612 J-105.93 E.05945
; LINE_WIDTH: 0.43859
G1 X141.135 Y117.003 E.06185
; LINE_WIDTH: 0.43846
G1 X143.135 Y117.003 E.06183
; LINE_WIDTH: 0.43833
G1 X145.135 Y117.003 E.06181
; LINE_WIDTH: 0.43821
G1 X147.135 Y117.003 E.06179
; LINE_WIDTH: 0.43808
G1 X149.135 Y117.003 E.06177
; LINE_WIDTH: 0.43796
G1 X151.135 Y117.003 E.06175
; LINE_WIDTH: 0.43783
G1 X153.135 Y117.003 E.06173
; LINE_WIDTH: 0.43771
G1 X155.135 Y117.003 E.06171
; LINE_WIDTH: 0.43758
G1 X157.135 Y117.003 E.06169
; LINE_WIDTH: 0.43746
G1 X159.135 Y117.003 E.06168
; LINE_WIDTH: 0.43733
G1 X160.8 Y117.003 E.05134
; LINE_WIDTH: 0.45828
G2 X161.973 Y117.009 I.685 J-18.08 E.03809
; LINE_WIDTH: 0.44999
G1 X162.779 Y117.017 E.02564
G1 X162.933 Y117.083 E.00532
G1 X162.99 Y117.263 E.00602
; LINE_WIDTH: 0.45008
G2 X162.997 Y119.199 I89.113 J.663 E.06162
; LINE_WIDTH: 0.43693
G1 X162.997 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.997 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.997 Y136.801 E.17261
; LINE_WIDTH: 0.44622
G1 X162.993 Y137.009 E.00658
; LINE_WIDTH: 0.44999
G2 X162.991 Y138.699 I325.362 J1.195 E.05376
G1 X162.945 Y138.867 E.00556
M204 S10000
G1 X163.275 Y139.152 F12000
G1 F6000
M204 S3000
G1 X163.104 Y139.299 E.00716
G1 X162.747 Y139.398 E.0118
G1 X138.747 Y139.398 E.76361
G3 X137.108 Y139.376 I-.387 J-32.4 E.05217
G1 X136.848 Y139.275 E.00888
G1 X136.695 Y139.092 E.00759
G1 X136.602 Y138.748 E.01132
G1 X136.606 Y117.176 E.68636
G1 X136.703 Y116.895 E.00946
G1 X136.895 Y116.693 E.00887
G1 X137.239 Y116.602 E.01133
G1 X162.455 Y116.602 E.80229
G1 X162.98 Y116.637 E.01676
G1 X163.185 Y116.761 E.00762
G1 X163.365 Y117.028 E.01027
G1 X163.397 Y117.263 E.00754
G1 X163.398 Y137.263 E.63634
G3 X163.376 Y138.893 I-32.032 J.383 E.05186
G1 X163.297 Y139.096 E.00695
M204 S250
G1 X163.574 Y139.407 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.407 Y139.567 E.00681
G3 X162.783 Y139.79 I-.667 J-.881 E.01985
G1 X137.315 Y139.79 E.75059
G1 X136.895 Y139.739 E.01246
G1 X136.618 Y139.598 E.00917
G1 X136.425 Y139.413 E.00786
G1 X136.274 Y139.144 E.00911
G1 X136.21 Y138.783 E.0108
G1 X136.214 Y117.281 E.63372
G3 X136.819 Y116.299 I1.056 J-.027 E.03595
G1 X137.213 Y116.21 E.01192
G1 X162.71 Y116.21 E.75145
G1 X163.098 Y116.258 E.01154
G1 X163.348 Y116.378 E.00815
G1 X163.574 Y116.587 E.0091
G1 X163.74 Y116.898 E.01039
G1 X163.789 Y117.263 E.01085
G1 X163.79 Y138.682 E.63125
G1 X163.739 Y139.105 E.01257
G1 X163.61 Y139.36 E.00841
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.407 Y139.567 E-.11017
G1 X163.152 Y139.722 E-.11341
G1 X162.783 Y139.79 E-.14276
G1 X161.747 Y139.79 E-.39366
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.773 Y136.688 Z1.8 F12000
G1 X116.39 Y119.614 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.704 J.19 E.0434
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.223 J-103.837 E.04357
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.603 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.604 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.604 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.605 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.605 E.06146
; LINE_WIDTH: 0.43584
G1 X108.979 Y119.605 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.606 E.06138
; LINE_WIDTH: 0.43533
G1 X112.979 Y119.606 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.607 E.0613
; LINE_WIDTH: 0.43482
G1 X115.022 Y119.607 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.614 E.04163
M204 S10000
G1 X116.715 Y119.258 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.416 E.00567
G1 X116.798 Y136.537 E.54473
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.72 E.00693
G1 X95.202 Y136.56 E.00541
G1 X95.202 Y119.463 E.54396
G1 X95.288 Y119.251 E.0073
G1 X95.452 Y119.202 E.00545
G1 X116.554 Y119.207 E.67143
G1 X116.657 Y119.24 E.00344
M204 S250
G1 X116.883 Y118.886 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.059 Y119.036 E.00683
G3 X117.189 Y119.416 I-.937 J.533 E.0119
G1 X117.19 Y136.505 E.50365
G1 X117.132 Y136.845 E.01017
G3 X116.886 Y137.102 I-.83 J-.547 E.01055
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01016
G1 X94.955 Y136.981 E.00739
G3 X94.81 Y136.587 I.838 J-.532 E.01246
G1 X94.81 Y119.495 E.50373
G1 X94.868 Y119.155 E.01017
G3 X95.114 Y118.898 I.831 J.548 E.01054
G1 X95.417 Y118.81 E.0093
G1 X116.555 Y118.815 E.62297
G1 X116.824 Y118.874 E.00812
; WIPE_START
M204 S3000
G1 X117.059 Y119.036 E-.10872
G1 X117.121 Y119.164 E-.05385
G1 X117.189 Y119.416 E-.09927
G1 X117.189 Y120.727 E-.49816
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.926 Y125.089 Z1.8 F12000
G1 X96.117 Y135.403 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01892
; LINE_WIDTH: 0.44605
G1 X96.979 Y119.997 E.00537
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.997 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.998 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.998 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.998 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.998 E.06146
; LINE_WIDTH: 0.43584
M73 P48 R10
G1 X108.979 Y119.998 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.998 E.06138
; LINE_WIDTH: 0.43533
G1 X112.979 Y119.998 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.998 E.0613
; LINE_WIDTH: 0.43482
M73 P48 R9
G1 X115.021 Y119.998 E.00132
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02403
G1 X116.003 Y120.979 E.0239
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.022 Y120.398 E.57408
G1 X115.433 Y120.569 E.01418
G1 X115.602 Y120.979 E.0141
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.846 I.021 J.24 E.0056
G1 X115.21 Y120.979 E.00424
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z1.8 F12000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z1.8 F12000
G1 X96.026 Y119.961 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17026
G1 X95.955 Y120.002 E-.29487
G1 X96.026 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.963 Z1.8 F12000
G1 X116.022 Y119.965 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00239
G1 X116.022 Y120.046 E.00239
G1 X116.046 Y120.006 E.00138
; WIPE_START
G1 X116.022 Y120.046 E-.17026
G1 X115.952 Y120.006 E-.29487
G1 X116.022 Y119.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y127.598 Z1.8 F12000
G1 X116.021 Y135.957 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z1.8 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 7 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z1.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z1.8 F4000
            G39.3 S1
            G0 Z1.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer7 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 8/40
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.37465
G1 F6000
M204 S3000
G1 X162.333 Y117.657 E.01216
G1 X161.976 Y117.379 E.01173
G1 X162.621 Y117.379 E.01672
G1 X162.621 Y117.967 E.01525
; WIPE_START
G1 X162.333 Y117.657 E-.16083
G1 X161.976 Y117.379 E-.17189
G1 X162.621 Y117.379 E-.245
G1 X162.621 Y117.858 E-.18228
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.491 Z2 F12000
G1 X162.621 Y137.974 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01681
G1 X161.972 Y138.621 E.01684
G1 X162.244 Y138.415 E.00885
G1 X162.582 Y138.019 E.01351
; WIPE_START
G1 X162.621 Y138.621 E-.2292
G1 X161.972 Y138.621 E-.2466
G1 X162.244 Y138.415 E-.12958
G1 X162.508 Y138.106 E-.15461
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.878 Y138.266 Z2 F12000
G1 X138.023 Y138.618 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.01669
G1 X137.378 Y137.971 E.01675
G1 X137.585 Y138.244 E.00886
G1 X137.978 Y138.579 E.01336
; WIPE_START
G1 X137.378 Y138.618 E-.22827
G1 X137.378 Y137.971 E-.24598
G1 X137.585 Y138.244 E-.13014
G1 X137.896 Y138.51 E-.15561
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.945 Y130.878 Z2 F12000
G1 X138.032 Y117.378 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.37271
G1 F6000
M204 S3000
G1 X137.665 Y117.657 E.01188
G1 X137.381 Y118.026 E.012
G1 X137.381 Y117.378 E.0167
G1 X137.972 Y117.378 E.01522
; WIPE_START
G1 X137.665 Y117.657 E-.15762
G1 X137.381 Y118.026 E-.17686
G1 X137.381 Y117.378 E-.24626
G1 X137.853 Y117.378 E-.17926
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.485 Y117.423 Z2 F12000
G1 X161.425 Y117.519 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y117.577 E.00535
G1 X162.061 Y117.907 E.01847
G1 X162.333 Y118.26 E.01419
G1 X162.511 Y118.644 E.01347
G1 X162.603 Y119.199 E.01791
; LINE_WIDTH: 0.43693
G1 X162.603 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.603 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.603 Y136.8 E.1726
; LINE_WIDTH: 0.46173
G1 X162.569 Y137.195 E.01295
G1 X162.296 Y137.799 E.0217
; LINE_WIDTH: 0.44999
G1 X162.021 Y138.121 E.01348
G1 X161.74 Y138.333 E.01121
G1 X161.356 Y138.511 E.01346
G1 X160.801 Y138.603 E.01791
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.603 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.603 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.603 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.602 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.602 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.602 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.602 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.602 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.602 E.06143
; LINE_WIDTH: 0.43575
G1 X139.2 Y138.602 E.04916
; LINE_WIDTH: 0.45666
G3 X138.512 Y138.462 I-.059 J-1.469 E.02291
; LINE_WIDTH: 0.44999
G1 X138.202 Y138.296 E.0112
G1 X137.879 Y138.021 E.01348
G1 X137.667 Y137.74 E.01121
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05018
; LINE_WIDTH: 0.45046
G1 X137.493 Y118.625 E.01754
G1 X137.655 Y118.275 E.01227
; LINE_WIDTH: 0.44999
G1 X137.93 Y117.912 E.0145
G1 X138.354 Y117.609 E.01656
G1 X138.693 Y117.473 E.01164
; LINE_WIDTH: 0.4495
G1 X139.199 Y117.397 E.01627
; LINE_WIDTH: 0.43731
G1 X160.801 Y117.397 E.66589
; LINE_WIDTH: 0.44901
G1 X161.258 Y117.457 E.01463
; LINE_WIDTH: 0.44999
G1 X161.369 Y117.498 E.00377
M204 S10000
G1 X161.318 Y117.923 F12000
G1 F6000
M204 S3000
G1 X161.627 Y118.074 E.01094
G3 X162.113 Y118.731 I-1.116 J1.334 E.02626
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.8 E.56001
G1 X162.163 Y137.123 E.01035
G1 X161.937 Y137.607 E.01698
G3 X161.269 Y138.113 I-1.313 J-1.04 E.02697
G1 X160.801 Y138.202 E.01516
G1 X139.199 Y138.202 E.68729
G1 X138.898 Y138.166 E.00967
G1 X138.393 Y137.937 E.01762
G3 X137.887 Y137.269 I1.039 J-1.313 E.02697
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.168 E.56103
G1 X137.89 Y118.72 E.01452
G1 X137.984 Y118.515 E.00721
G1 X138.224 Y118.194 E.01273
G1 X138.573 Y117.952 E.01352
G1 X139.086 Y117.809 E.01694
G1 X139.199 Y117.798 E.00362
G1 X160.801 Y117.798 E.6873
G1 X161.186 Y117.858 E.01241
G1 X161.264 Y117.896 E.00277
M204 S250
G1 X161.154 Y118.261 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y118.267 E.00077
G1 X161.484 Y118.461 E.01065
G1 X161.73 Y118.815 E.01271
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.8 E.51874
G1 X161.757 Y137.112 E.00931
G1 X161.539 Y137.484 E.01271
G1 X161.184 Y137.73 E.01272
G1 X160.801 Y137.81 E.01155
G1 X139.2 Y137.81 E.63663
G1 X138.888 Y137.757 E.0093
G1 X138.516 Y137.539 E.01271
G1 X138.27 Y137.184 E.01272
G1 X138.19 Y136.801 E.01156
G1 X138.191 Y119.168 E.51968
G1 X138.302 Y118.745 E.01288
G1 X138.541 Y118.438 E.01147
G1 X138.784 Y118.282 E.00852
G1 X139.199 Y118.19 E.01253
G1 X160.801 Y118.19 E.63665
G1 X161.095 Y118.249 E.00884
; WIPE_START
M204 S3000
G1 X161.179 Y118.267 E-.03269
G1 X161.484 Y118.461 E-.13734
G1 X161.73 Y118.815 E-.16392
G1 X161.81 Y119.199 E-.14903
G1 X161.81 Y119.928 E-.27702
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.248 Y127.548 Z2 F12000
G1 X162.904 Y138.938 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
M73 P49 R9
G1 X162.751 Y138.991 E.00514
G2 X160.801 Y138.997 I-.685 J92.48 E.06207
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.997 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.997 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.996 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.996 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.996 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.995 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.995 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.995 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.995 E.06143
; LINE_WIDTH: 0.43575
G1 X139.2 Y138.995 E.04916
; LINE_WIDTH: 0.44121
G1 X139.037 Y138.992 E.00505
; LINE_WIDTH: 0.44999
G2 X137.225 Y138.987 I-1.253 J135.316 E.05768
G1 X137.063 Y138.915 E.00563
G1 X137.009 Y138.722 E.00638
G2 X137.003 Y136.801 I-90.95 J-.671 E.06113
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.167 E.05018
; LINE_WIDTH: 0.45046
G2 X137.013 Y118.067 I-43.741 J-.836 E.03507
; LINE_WIDTH: 0.44999
G1 X137.013 Y117.225 E.02679
G1 X137.085 Y117.066 E.00555
G1 X137.268 Y117.009 E.00609
G1 X138.647 Y117.009 E.04388
; LINE_WIDTH: 0.4495
G1 X139.199 Y117.003 E.01754
; LINE_WIDTH: 0.43731
G1 X160.801 Y117.003 E.66589
; LINE_WIDTH: 0.44901
G1 X161.298 Y117.009 E.01577
; LINE_WIDTH: 0.44999
G3 X162.83 Y117.025 I.338 J39.634 E.04875
G1 X162.941 Y117.09 E.00408
G1 X162.99 Y117.291 E.0066
; LINE_WIDTH: 0.45008
G2 X162.997 Y119.199 I87.807 J.649 E.06072
; LINE_WIDTH: 0.43693
G1 X162.997 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.997 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.997 Y136.8 E.1726
; LINE_WIDTH: 0.46173
G2 X162.991 Y137.972 I16.122 J.673 E.03837
; LINE_WIDTH: 0.44999
G1 X162.978 Y138.791 E.02603
G1 X162.931 Y138.884 E.00333
M204 S10000
G1 X163.247 Y139.183 F12000
G1 F6000
M204 S3000
G3 X163.083 Y139.317 I-.456 J-.389 E.00676
G1 X162.771 Y139.398 E.01026
G1 X138.771 Y139.395 E.76361
G3 X137.102 Y139.377 I-.366 J-43.575 E.0531
G1 X136.813 Y139.247 E.0101
G1 X136.672 Y139.058 E.0075
G1 X136.602 Y138.754 E.00992
G1 X136.606 Y117.176 E.68653
G1 X136.703 Y116.895 E.00946
G1 X136.896 Y116.692 E.00892
G1 X137.24 Y116.602 E.01132
G1 X161.24 Y116.602 E.76361
G3 X162.819 Y116.611 I.393 J69.857 E.05023
G1 X163.124 Y116.705 E.01015
G1 X163.341 Y116.963 E.01075
G1 X163.397 Y117.291 E.01059
G1 X163.398 Y138.455 E.67337
G1 X163.355 Y138.996 E.01726
G3 X163.283 Y139.136 I-.565 J-.202 E.00502
M204 S250
G1 X163.559 Y139.426 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.55 Y139.441 E.00052
G1 X163.281 Y139.662 E.01027
G3 X162.79 Y139.79 I-.676 J-1.59 E.01499
G1 X137.297 Y139.786 E.75135
G3 X136.463 Y139.443 I.004 J-1.194 E.02727
G1 X136.261 Y139.108 E.01153
G1 X136.21 Y138.785 E.00964
G1 X136.214 Y117.283 E.63369
G3 X136.813 Y116.301 I1.058 J-.029 E.03586
G1 X137.213 Y116.21 E.0121
G1 X162.708 Y116.21 E.75138
G1 X163.107 Y116.261 E.01185
G1 X163.347 Y116.378 E.00787
G1 X163.577 Y116.59 E.00923
G1 X163.711 Y116.819 E.0078
G1 X163.789 Y117.291 E.01412
G1 X163.79 Y138.688 E.63061
G1 X163.729 Y139.132 E.0132
G1 X163.589 Y139.374 E.00825
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.55 Y139.441 E-.02946
G1 X163.281 Y139.662 E-.13238
G1 X163.124 Y139.72 E-.06376
G1 X162.79 Y139.79 E-.12933
G1 X161.724 Y139.79 E-.40507
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.751 Y136.687 Z2 F12000
G1 X116.39 Y119.614 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.706 J.19 E.0434
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.223 J-103.836 E.04357
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.603 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.604 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.604 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.605 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.605 E.06146
; LINE_WIDTH: 0.43585
G1 X108.979 Y119.605 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.606 E.06138
; LINE_WIDTH: 0.43534
G1 X112.979 Y119.606 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.607 E.0613
; LINE_WIDTH: 0.43483
G1 X115.022 Y119.607 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.614 E.04163
M204 S10000
G1 X116.706 Y119.255 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.416 E.00589
G1 X116.798 Y136.537 E.54474
G1 X116.713 Y136.749 E.00729
G1 X116.548 Y136.798 E.00546
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.719 E.00694
G1 X95.202 Y136.56 E.0054
G1 X95.202 Y119.463 E.54396
G1 X95.288 Y119.25 E.0073
G1 X95.452 Y119.202 E.00544
G1 X116.554 Y119.207 E.67142
G1 X116.649 Y119.237 E.00315
M204 S250
G1 X116.867 Y118.88 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.06 Y119.038 E.00734
G3 X117.189 Y119.416 I-.895 J.518 E.01185
G1 X117.19 Y136.505 E.50366
G1 X117.132 Y136.845 E.01018
G3 X116.886 Y137.102 I-.828 J-.546 E.01054
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01017
G1 X94.955 Y136.98 E.0074
G3 X94.81 Y136.587 I.838 J-.531 E.01245
G1 X94.81 Y119.495 E.50373
G1 X94.868 Y119.155 E.01016
G3 X95.114 Y118.898 I.832 J.549 E.01055
G1 X95.417 Y118.81 E.00928
G1 X116.554 Y118.815 E.62297
G1 X116.81 Y118.865 E.00766
; WIPE_START
M204 S3000
G1 X117.06 Y119.038 E-.11545
G1 X117.126 Y119.173 E-.05737
G1 X117.189 Y119.416 E-.09518
G1 X117.189 Y120.71 E-.49201
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.924 Y125.069 Z2 F12000
G1 X96.104 Y135.378 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00668
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01892
; LINE_WIDTH: 0.44605
G1 X96.979 Y119.997 E.00537
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.997 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.998 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.998 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.998 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.998 E.06146
; LINE_WIDTH: 0.43585
G1 X108.979 Y119.998 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.998 E.06138
; LINE_WIDTH: 0.43534
G1 X112.979 Y119.998 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.998 E.0613
; LINE_WIDTH: 0.43483
G1 X115.021 Y119.998 E.00132
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02403
G1 X116.003 Y120.979 E.0239
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.131 Y135.432 E.01032
M204 S10000
G1 X96.448 Y135.202 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00287
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.022 Y120.398 E.57408
G1 X115.433 Y120.569 E.01417
G1 X115.602 Y120.979 E.0141
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.476 Y135.255 E.00635
M204 S250
G1 X96.791 Y135.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y135.021 E.00007
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.846 I.021 J.24 E.0056
G1 X115.21 Y120.979 E.00424
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.814 Y135.079 E.00241
; WIPE_START
M204 S3000
G1 X96.79 Y135.021 E-.02375
G1 X96.79 Y133.084 E-.73625
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z2 F12000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z2 F12000
G1 X96.026 Y119.961 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
M73 P50 R9
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17026
G1 X95.955 Y120.002 E-.29487
G1 X96.026 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.963 Z2 F12000
G1 X116.022 Y119.965 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.41858
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00239
G1 X116.022 Y120.046 E.00239
G1 X116.046 Y120.006 E.00138
; WIPE_START
G1 X116.022 Y120.046 E-.17026
G1 X115.952 Y120.006 E-.29487
G1 X116.022 Y119.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y127.598 Z2 F12000
G1 X116.021 Y135.957 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 8 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2 F4000
            G39.3 S1
            G0 Z2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer8 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 9/40
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.37463
G1 F6000
M204 S3000
G1 X162.416 Y117.756 E.00881
G1 X161.974 Y117.379 E.01507
G1 X162.621 Y117.379 E.01677
G1 X162.621 Y117.967 E.01526
; WIPE_START
G1 X162.416 Y117.756 E-.11178
G1 X161.974 Y117.379 E-.22086
G1 X162.621 Y117.379 E-.24586
G1 X162.621 Y117.856 E-.1815
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.489 Z2.2 F12000
G1 X162.621 Y137.976 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.37496
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01675
G1 X161.972 Y138.621 E.01684
G1 X162.343 Y138.333 E.01218
G1 X162.584 Y138.023 E.01019
; WIPE_START
G1 X162.621 Y138.621 E-.22765
G1 X161.972 Y138.621 E-.24657
G1 X162.343 Y138.333 E-.17838
G1 X162.517 Y138.11 E-.1074
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y138.268 Z2.2 F12000
G1 X138.02 Y138.618 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.37395
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.0166
G1 X137.378 Y137.971 E.01675
G1 X137.666 Y138.341 E.01213
G1 X137.973 Y138.581 E.01009
; WIPE_START
G1 X137.378 Y138.618 E-.22635
G1 X137.378 Y137.971 E-.24602
G1 X137.666 Y138.341 E-.1781
G1 X137.893 Y138.519 E-.10952
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y130.886 Z2.2 F12000
G1 X138.029 Y117.378 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X137.659 Y117.666 E.01213
G1 X137.382 Y118.021 E.01165
G1 X137.382 Y117.378 E.01662
G1 X137.969 Y117.378 E.0152
; WIPE_START
G1 X137.659 Y117.666 E-.16072
G1 X137.382 Y118.021 E-.17115
G1 X137.382 Y117.378 E-.24411
G1 X137.866 Y117.378 E-.18403
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.498 Y117.418 Z2.2 F12000
G1 X161.377 Y117.5 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.45828
G1 F6000
M204 S3000
G1 X161.488 Y117.538 E.00383
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.0112
G1 X162.121 Y117.979 E.01348
G1 X162.334 Y118.26 E.01121
; LINE_WIDTH: 0.45259
G1 X162.502 Y118.602 E.01219
G1 X162.6 Y119.126 E.01709
; LINE_WIDTH: 0.43859
G1 X162.6 Y121.126 E.06185
; LINE_WIDTH: 0.43844
G1 X162.601 Y123.126 E.06183
; LINE_WIDTH: 0.43829
G1 X162.601 Y125.126 E.06181
; LINE_WIDTH: 0.43814
G1 X162.601 Y127.126 E.06178
; LINE_WIDTH: 0.43799
G1 X162.602 Y129.126 E.06176
; LINE_WIDTH: 0.43784
G1 X162.602 Y131.126 E.06173
; LINE_WIDTH: 0.43769
G1 X162.602 Y133.126 E.06171
; LINE_WIDTH: 0.43754
G1 X162.603 Y135.126 E.06169
; LINE_WIDTH: 0.43739
G1 X162.603 Y136.8 E.05162
; LINE_WIDTH: 0.44897
G1 X162.543 Y137.258 E.01464
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01103
G1 X162.093 Y138.061 E.01848
G1 X161.741 Y138.333 E.01417
G1 X161.357 Y138.51 E.01346
G1 X160.801 Y138.603 E.01793
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.603 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.603 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.603 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.602 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.602 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.602 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.602 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.602 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.602 E.06143
; LINE_WIDTH: 0.43575
G1 X139.199 Y138.602 E.04916
; LINE_WIDTH: 0.44856
G1 X138.742 Y138.542 E.01462
; LINE_WIDTH: 0.44999
G3 X138.167 Y138.277 I.448 J-1.725 E.02027
G3 X137.666 Y137.74 I1.098 J-1.526 E.02351
G1 X137.489 Y137.356 E.01345
G1 X137.397 Y136.801 E.0179
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05017
; LINE_WIDTH: 0.44877
G1 X137.457 Y118.737 E.0138
; LINE_WIDTH: 0.44999
G1 X137.571 Y118.43 E.01042
G1 X137.908 Y117.938 E.01898
G1 X138.26 Y117.667 E.01412
G1 X138.643 Y117.49 E.01344
G1 X139.199 Y117.397 E.01793
; LINE_WIDTH: 0.43731
G1 X159.199 Y117.397 E.61652
; LINE_WIDTH: 0.4372
G1 X160.8 Y117.397 E.04935
; LINE_WIDTH: 0.45828
G3 X161.159 Y117.427 I.06 J1.456 E.01171
G1 X161.32 Y117.481 E.00551
M204 S10000
G1 X161.275 Y117.913 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01159
G3 X162.009 Y118.506 I-.807 J1.137 E.01917
G1 X162.179 Y118.977 E.01594
G1 X162.199 Y119.126 E.00479
G1 X162.202 Y136.801 E.56234
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01563
G3 X161.269 Y138.113 I-1.334 J-1.116 E.02624
G1 X160.801 Y138.202 E.01517
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.01242
G1 X138.373 Y137.925 E.01563
G3 X137.887 Y137.268 I1.117 J-1.335 E.02625
G1 X137.798 Y136.801 E.01515
G1 X137.799 Y119.168 E.56103
G1 X137.856 Y118.814 E.0114
G1 X138.073 Y118.375 E.01557
G3 X138.731 Y117.887 I1.33 J1.104 E.02632
G1 X139.199 Y117.798 E.01517
G1 X160.8 Y117.798 E.68729
G1 X161.103 Y117.834 E.00968
G1 X161.221 Y117.888 E.00413
M204 S250
G1 X161.122 Y118.249 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.461 E.01237
G1 X161.728 Y118.808 E.01249
G1 X161.807 Y119.126 E.00967
G1 X161.81 Y136.801 E.5209
G1 X161.734 Y137.179 E.01139
G1 X161.539 Y137.484 E.01066
G1 X161.185 Y137.73 E.0127
G1 X160.801 Y137.81 E.01157
G1 X139.199 Y137.81 E.63664
G1 X138.82 Y137.733 E.01139
G1 X138.571 Y137.587 E.00852
G1 X138.304 Y137.258 E.01251
G1 X138.19 Y136.801 E.01388
G1 X138.191 Y119.168 E.51968
G1 X138.263 Y118.83 E.01018
G1 X138.462 Y118.516 E.01096
G1 X138.815 Y118.27 E.01268
G1 X139.199 Y118.19 E.01156
G1 X160.8 Y118.19 E.63664
G1 X161.064 Y118.235 E.00788
; WIPE_START
M204 S3000
G1 X161.484 Y118.461 E-.18124
G1 X161.728 Y118.808 E-.16102
G1 X161.807 Y119.126 E-.12474
G1 X161.807 Y119.897 E-.29301
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.25 Y127.517 Z2.2 F12000
G1 X162.913 Y138.916 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.88 Y138.96 E.00175
G1 X162.722 Y138.991 E.00513
G2 X160.801 Y138.997 I-.669 J91.248 E.06114
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.997 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.997 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.996 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.996 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.996 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.995 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.995 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.995 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.995 E.06143
; LINE_WIDTH: 0.43575
G1 X139.199 Y138.995 E.04916
; LINE_WIDTH: 0.44486
G1 X138.991 Y138.99 E.00656
; LINE_WIDTH: 0.44999
G2 X137.268 Y138.987 I-1.26 J245.147 E.05483
G1 X137.091 Y138.943 E.0058
G1 X137.009 Y138.751 E.00664
G2 X137.003 Y136.801 I-92.258 J-.687 E.06207
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05017
; LINE_WIDTH: 0.44677
G1 X137.011 Y118.942 E.00712
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.27 I-344.174 J-1.225 E.0532
G1 X137.051 Y117.104 E.00543
G1 X137.235 Y117.009 E.00658
G2 X139.199 Y117.003 I.679 J-94.273 E.06249
; LINE_WIDTH: 0.43731
G1 X159.199 Y117.003 E.61652
; LINE_WIDTH: 0.4372
G1 X160.8 Y117.003 E.04935
; LINE_WIDTH: 0.45828
G2 X161.973 Y117.009 I.685 J-18.025 E.03807
; LINE_WIDTH: 0.44999
G1 X162.802 Y117.018 E.02637
G1 X162.949 Y117.104 E.00543
G1 X162.99 Y117.264 E.00524
G1 X162.99 Y117.687 E.01349
; LINE_WIDTH: 0.45259
G2 X162.996 Y119.126 I53.524 J.505 E.04607
; LINE_WIDTH: 0.43859
G1 X162.996 Y121.126 E.06185
; LINE_WIDTH: 0.43844
G1 X162.996 Y123.126 E.06183
; LINE_WIDTH: 0.43829
G1 X162.996 Y125.126 E.06181
; LINE_WIDTH: 0.43814
G1 X162.996 Y127.126 E.06178
; LINE_WIDTH: 0.43799
G1 X162.997 Y129.126 E.06176
; LINE_WIDTH: 0.43784
G1 X162.997 Y131.126 E.06173
; LINE_WIDTH: 0.43769
G1 X162.997 Y133.126 E.06171
; LINE_WIDTH: 0.43754
G1 X162.997 Y135.126 E.06169
; LINE_WIDTH: 0.43739
G1 X162.997 Y136.8 E.05162
; LINE_WIDTH: 0.44897
G1 X162.991 Y137.297 E.01578
; LINE_WIDTH: 0.44999
G3 X162.973 Y138.834 I-36.022 J.341 E.04891
G1 X162.949 Y138.868 E.00131
M204 S10000
G1 X163.259 Y139.131 F12000
G1 F6000
M204 S3000
G1 X163.11 Y139.303 E.00723
G1 X162.754 Y139.398 E.01173
G1 X137.267 Y139.394 E.81091
G1 X136.942 Y139.332 E.01054
G1 X136.7 Y139.113 E.01038
G1 X136.602 Y138.771 E.01131
G1 X136.606 Y117.182 E.6869
G1 X136.712 Y116.879 E.01021
G1 X136.934 Y116.675 E.00962
G1 X137.218 Y116.602 E.00931
G1 X161.218 Y116.602 E.76361
G3 X162.954 Y116.628 I.378 J32.615 E.05524
G1 X163.195 Y116.776 E.009
G1 X163.364 Y117.023 E.00954
G1 X163.397 Y117.264 E.00773
G1 X163.398 Y138.754 E.68376
G1 X163.323 Y139.058 E.00998
G1 X163.299 Y139.086 E.00117
M204 S250
G1 X163.573 Y139.404 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.335 Y139.63 E.00964
G1 X163.108 Y139.739 E.00744
G1 X162.785 Y139.79 E.00963
G1 X137.132 Y139.786 E.75605
G1 X136.783 Y139.695 E.01062
G1 X136.56 Y139.553 E.00781
G1 X136.359 Y139.317 E.00912
G3 X136.21 Y138.79 I1.574 J-.73 E.0162
G1 X136.214 Y117.267 E.63434
G1 X136.304 Y116.784 E.01448
G1 X136.466 Y116.54 E.00863
G1 X136.752 Y116.32 E.01064
G1 X137.206 Y116.21 E.01377
G1 X162.455 Y116.21 E.74413
M73 P51 R9
G1 X163.066 Y116.248 E.01804
G1 X163.347 Y116.378 E.00913
G1 X163.6 Y116.621 E.01034
G1 X163.74 Y116.897 E.00911
G1 X163.789 Y117.264 E.01091
G1 X163.79 Y138.699 E.63175
G1 X163.739 Y139.105 E.01206
G1 X163.61 Y139.359 E.00839
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.335 Y139.63 E-.14669
G1 X163.108 Y139.739 E-.09595
G1 X162.785 Y139.79 E-.12422
G1 X161.75 Y139.79 E-.39315
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.777 Y136.688 Z2.2 F12000
G1 X116.39 Y119.614 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.704 J.19 E.0434
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.223 J-103.837 E.04357
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.603 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.604 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.604 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.605 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.605 E.06146
; LINE_WIDTH: 0.43584
G1 X108.979 Y119.605 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.606 E.06138
; LINE_WIDTH: 0.43533
G1 X112.979 Y119.606 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.607 E.0613
; LINE_WIDTH: 0.43482
G1 X115.022 Y119.607 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.614 E.04163
M204 S10000
G1 X116.706 Y119.254 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.416 E.0059
G1 X116.798 Y136.537 E.54473
G1 X116.72 Y136.74 E.00693
G1 X116.559 Y136.798 E.00542
G1 X95.463 Y136.798 E.67121
G1 X95.251 Y136.712 E.0073
G1 X95.202 Y136.548 E.00544
G1 X95.202 Y119.464 E.54359
G1 X95.288 Y119.251 E.0073
G1 X95.452 Y119.202 E.00546
G1 X116.554 Y119.207 E.67142
G1 X116.649 Y119.237 E.00314
M204 S250
G1 X116.87 Y118.882 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.06 Y119.038 E.00725
G3 X117.189 Y119.416 I-.894 J.517 E.01185
G1 X117.19 Y136.505 E.50365
G1 X117.132 Y136.845 E.01017
G1 X116.98 Y137.045 E.00739
G3 X116.586 Y137.19 I-.532 J-.837 E.01247
G1 X95.495 Y137.19 E.62161
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.547 J-.83 E.01055
G1 X94.81 Y136.583 E.00929
G1 X94.81 Y119.495 E.50361
G1 X94.868 Y119.155 E.01018
G3 X95.114 Y118.898 I.829 J.547 E.01053
G1 X95.417 Y118.81 E.00931
G1 X116.554 Y118.815 E.62296
G1 X116.813 Y118.866 E.00776
; WIPE_START
M204 S3000
G1 X117.06 Y119.038 E-.11431
G1 X117.126 Y119.173 E-.0573
G1 X117.189 Y119.416 E-.09522
G1 X117.189 Y120.714 E-.49317
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.923 Y125.071 Z2.2 F12000
G1 X96.104 Y135.378 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00668
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01892
; LINE_WIDTH: 0.44605
G1 X96.979 Y119.997 E.00537
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.997 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.998 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.998 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.998 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.998 E.06146
; LINE_WIDTH: 0.43584
G1 X108.979 Y119.998 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.998 E.06138
; LINE_WIDTH: 0.43533
G1 X112.979 Y119.998 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.998 E.0613
; LINE_WIDTH: 0.43482
G1 X115.021 Y119.998 E.00132
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02403
G1 X116.003 Y120.979 E.0239
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.131 Y135.432 E.01032
M204 S10000
G1 X96.026 Y135.957 F12000
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
M204 S10000
G1 X96.448 Y135.202 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00287
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.022 Y120.398 E.57408
G1 X115.433 Y120.569 E.01418
G1 X115.602 Y120.979 E.0141
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.476 Y135.255 E.00635
M204 S250
G1 X96.791 Y135.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y135.021 E.00007
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.846 I.021 J.24 E.0056
G1 X115.21 Y120.979 E.00424
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.814 Y135.079 E.00241
; WIPE_START
M204 S3000
G1 X96.79 Y135.021 E-.02375
G1 X96.79 Y133.084 E-.73625
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.346 Y125.464 Z2.2 F12000
G1 X96.026 Y119.961 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17026
G1 X95.955 Y120.002 E-.29487
G1 X96.026 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.963 Z2.2 F12000
G1 X116.022 Y119.965 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00239
G1 X116.022 Y120.046 E.00239
G1 X116.046 Y120.006 E.00138
; WIPE_START
G1 X116.022 Y120.046 E-.17026
G1 X115.952 Y120.006 E-.29487
G1 X116.022 Y119.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y127.598 Z2.2 F12000
G1 X116.021 Y135.957 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.2 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 9 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.2 F4000
            G39.3 S1
            G0 Z2.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer9 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 10/40
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.62 Y118.027 F12000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.3746
G1 F6000
M204 S3000
G1 X162.333 Y117.657 E.01216
G1 X161.976 Y117.379 E.01173
G1 X162.621 Y117.379 E.01672
G1 X162.62 Y117.967 E.01525
; WIPE_START
G1 X162.333 Y117.657 E-.16079
G1 X161.976 Y117.379 E-.17192
G1 X162.621 Y117.379 E-.24503
G1 X162.62 Y117.858 E-.18226
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.491 Z2.4 F12000
G1 X162.618 Y137.98 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.0166
G1 X161.971 Y138.622 E.01675
G1 X162.341 Y138.334 E.01213
G1 X162.581 Y138.027 E.01008
; WIPE_START
G1 X162.618 Y138.622 E-.22627
G1 X161.971 Y138.622 E-.24596
G1 X162.341 Y138.334 E-.17808
G1 X162.519 Y138.107 E-.10969
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y138.266 Z2.4 F12000
G1 X138.02 Y138.618 Z2.4
G1 Z2
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.0166
G1 X137.378 Y137.971 E.01675
G1 X137.666 Y138.341 E.01213
G1 X137.973 Y138.581 E.01008
; WIPE_START
G1 X137.378 Y138.618 E-.22628
M73 P52 R9
G1 X137.378 Y137.971 E-.24596
G1 X137.666 Y138.341 E-.17807
G1 X137.893 Y138.519 E-.10968
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.944 Y130.887 Z2.4 F12000
G1 X138.034 Y117.378 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.37255
G1 F6000
M204 S3000
G1 X137.664 Y117.657 E.01195
G1 X137.381 Y118.025 E.01196
G1 X137.381 Y117.378 E.01669
G1 X137.974 Y117.378 E.01527
; WIPE_START
G1 X137.664 Y117.657 E-.15863
G1 X137.381 Y118.025 E-.17642
G1 X137.381 Y117.378 E-.24622
G1 X137.851 Y117.378 E-.17872
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.484 Y117.424 Z2.4 F12000
G1 X161.427 Y117.52 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y117.577 E.00529
G1 X162.061 Y117.907 E.01847
G1 X162.334 Y118.26 E.0142
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01791
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.801 E.04916
; LINE_WIDTH: 0.44852
G1 X162.542 Y137.257 E.01461
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01103
G1 X162.092 Y138.062 E.01853
G1 X161.74 Y138.333 E.01413
G1 X161.356 Y138.511 E.01346
G1 X160.801 Y138.603 E.01792
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.603 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.603 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.603 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.602 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.602 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.602 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.602 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.602 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.602 E.06143
; LINE_WIDTH: 0.43575
G1 X139.199 Y138.602 E.04916
; LINE_WIDTH: 0.44856
G1 X138.743 Y138.543 E.0146
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01103
G1 X137.938 Y138.092 E.01854
G1 X137.667 Y137.74 E.01413
G1 X137.489 Y137.356 E.01347
G1 X137.397 Y136.801 E.01792
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05018
; LINE_WIDTH: 0.45046
G1 X137.493 Y118.625 E.01753
G1 X137.652 Y118.28 E.0121
; LINE_WIDTH: 0.44999
G1 X137.928 Y117.914 E.01458
G1 X138.348 Y117.613 E.01646
G1 X138.693 Y117.473 E.01185
; LINE_WIDTH: 0.44951
G1 X139.199 Y117.397 E.01628
; LINE_WIDTH: 0.43731
G1 X159.199 Y117.397 E.61652
; LINE_WIDTH: 0.43719
G1 X160.801 Y117.397 E.04935
; LINE_WIDTH: 0.44901
G1 X161.258 Y117.457 E.01463
; LINE_WIDTH: 0.44999
G1 X161.371 Y117.499 E.00382
M204 S10000
G1 X161.32 Y117.923 F12000
G1 F6000
M204 S3000
G1 X161.627 Y118.074 E.01088
G3 X162.113 Y118.731 I-1.116 J1.334 E.02625
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01562
G3 X161.269 Y138.113 I-1.335 J-1.117 E.02626
G1 X160.801 Y138.202 E.01516
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.0124
G1 X138.373 Y137.926 E.01562
G3 X137.887 Y137.269 I1.117 J-1.335 E.02626
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.168 E.56103
G1 X137.889 Y118.721 E.01451
G1 X137.982 Y118.518 E.0071
G1 X138.219 Y118.199 E.01264
G1 X138.569 Y117.954 E.01359
G1 X139.086 Y117.809 E.01707
G1 X139.199 Y117.798 E.00363
G1 X160.801 Y117.798 E.6873
G1 X161.186 Y117.858 E.01241
G1 X161.266 Y117.897 E.00283
M204 S250
G1 X161.156 Y118.262 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y118.267 E.00072
G1 X161.484 Y118.462 E.01066
G1 X161.73 Y118.816 E.01271
G1 X161.81 Y119.199 E.01155
G1 X161.81 Y136.801 E.51875
G1 X161.734 Y137.179 E.01138
G1 X161.539 Y137.484 E.01065
G1 X161.185 Y137.73 E.01271
G1 X160.801 Y137.81 E.01156
G1 X139.199 Y137.81 E.63664
G1 X138.821 Y137.734 E.01138
G1 X138.516 Y137.539 E.01066
G1 X138.27 Y137.185 E.01272
G1 X138.19 Y136.801 E.01156
G1 X138.191 Y119.168 E.51968
G1 X138.301 Y118.746 E.01284
G1 X138.532 Y118.446 E.01118
G1 X138.783 Y118.283 E.00881
G1 X139.199 Y118.19 E.01257
G1 X160.801 Y118.19 E.63665
G1 X161.097 Y118.25 E.00889
; WIPE_START
M204 S3000
G1 X161.179 Y118.267 E-.03204
G1 X161.484 Y118.462 E-.13744
G1 X161.73 Y118.816 E-.16386
G1 X161.81 Y119.199 E-.14898
G1 X161.81 Y119.93 E-.27769
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.253 Y127.55 Z2.4 F12000
G1 X162.915 Y138.937 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.722 Y138.991 E.00638
G2 X160.801 Y138.997 I-.669 J91.19 E.06114
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.997 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.997 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.996 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.996 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.996 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.995 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.995 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.995 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.995 E.06143
; LINE_WIDTH: 0.43575
G1 X139.199 Y138.995 E.04916
; LINE_WIDTH: 0.44485
G1 X138.991 Y138.99 E.00655
; LINE_WIDTH: 0.44999
G2 X137.225 Y138.987 I-1.283 J250.182 E.0562
G1 X137.063 Y138.915 E.00562
G1 X137.009 Y138.722 E.00639
G2 X137.003 Y136.801 I-90.961 J-.671 E.06113
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05018
; LINE_WIDTH: 0.45244
G2 X137.013 Y118.075 I-17.592 J-.662 E.03499
; LINE_WIDTH: 0.44999
G1 X137.013 Y117.225 E.02705
G1 X137.085 Y117.066 E.00555
G1 X137.268 Y117.009 E.00609
G1 X138.647 Y117.009 E.04387
; LINE_WIDTH: 0.44951
G1 X139.199 Y117.003 E.01756
; LINE_WIDTH: 0.43731
G1 X159.199 Y117.003 E.61652
; LINE_WIDTH: 0.43719
G1 X160.801 Y117.003 E.04935
; LINE_WIDTH: 0.44901
G1 X161.298 Y117.009 E.01577
; LINE_WIDTH: 0.44999
G3 X162.762 Y117.012 I.196 J244.491 E.0466
G1 X162.933 Y117.083 E.00587
G1 X162.99 Y117.264 E.00603
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I88.046 J.677 E.0616
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.801 E.04916
; LINE_WIDTH: 0.44457
G1 X162.99 Y137.009 E.00655
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.775 I237.549 J1.279 E.0562
G1 X162.94 Y138.882 E.00371
M204 S10000
G1 X163.247 Y139.187 F12000
G1 F6000
M204 S3000
G1 X163.057 Y139.329 E.00754
G1 X162.754 Y139.398 E.00988
G1 X138.754 Y139.395 E.76361
G3 X137.102 Y139.377 I-.384 J-40.665 E.05255
G1 X136.813 Y139.247 E.01008
G1 X136.671 Y139.057 E.00756
G1 X136.602 Y138.754 E.00989
G1 X136.606 Y117.176 E.68653
G1 X136.703 Y116.895 E.00946
G1 X136.896 Y116.693 E.00891
G1 X137.24 Y116.602 E.01134
G1 X161.24 Y116.602 E.76361
G3 X162.953 Y116.628 I.393 J30.585 E.05452
G1 X163.192 Y116.768 E.00879
G1 X163.365 Y117.028 E.00995
G1 X163.397 Y117.264 E.00756
G1 X163.394 Y137.264 E.63634
G3 X163.377 Y138.898 I-40.218 J.376 E.05199
G1 X163.272 Y139.132 E.00818
M204 S250
G1 X163.573 Y139.38 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.442 Y139.538 E.00603
G1 X163.108 Y139.739 E.01149
G1 X162.785 Y139.79 E.00964
G1 X137.297 Y139.786 E.75118
G3 X136.463 Y139.442 I.003 J-1.192 E.02729
G1 X136.261 Y139.108 E.0115
G1 X136.21 Y138.785 E.00964
G1 X136.214 Y117.283 E.63369
G3 X136.813 Y116.301 I1.058 J-.029 E.03585
G1 X137.213 Y116.21 E.0121
G1 X162.455 Y116.21 E.74392
G1 X163.066 Y116.248 E.01804
G1 X163.349 Y116.379 E.00919
G1 X163.574 Y116.587 E.00905
G1 X163.74 Y116.898 E.01039
G1 X163.789 Y117.264 E.01087
G1 X163.786 Y138.703 E.63187
G3 X163.622 Y139.304 I-1.192 J-.004 E.01857
G1 X163.605 Y139.33 E.00091
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.442 Y139.538 E-.10042
G1 X163.108 Y139.739 E-.14816
G1 X162.785 Y139.79 E-.12425
G1 X161.766 Y139.79 E-.38717
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.151 Y139.278 Z2.4 F12000
G1 X96.103 Y135.376 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44614
G1 X95.997 Y135.021 E.00537
; LINE_WIDTH: 0.43721
G1 X95.997 Y133.021 E.06164
; LINE_WIDTH: 0.43707
G1 X95.997 Y131.021 E.06161
; LINE_WIDTH: 0.43693
G1 X95.997 Y129.021 E.06159
; LINE_WIDTH: 0.43679
G1 X95.998 Y127.021 E.06157
; LINE_WIDTH: 0.43665
G1 X95.998 Y125.021 E.06155
; LINE_WIDTH: 0.43651
G1 X95.998 Y123.021 E.06153
; LINE_WIDTH: 0.43637
G1 X95.998 Y121.021 E.06151
; LINE_WIDTH: 0.43623
G1 X95.998 Y120.979 E.00132
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.024
G1 X96.808 Y120.008 E.01888
; LINE_WIDTH: 0.44605
G1 X96.979 Y119.997 E.00537
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.997 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.998 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.998 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.998 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.998 E.06146
; LINE_WIDTH: 0.43584
G1 X108.979 Y119.998 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.998 E.06138
; LINE_WIDTH: 0.43533
G1 X112.979 Y119.998 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.998 E.0613
; LINE_WIDTH: 0.43482
G1 X115.021 Y119.998 E.00132
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02403
G1 X116.003 Y120.979 E.0239
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02397
G1 X96.13 Y135.429 E.0104
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.978 E.44681
G1 X96.568 Y120.568 E.01416
G1 X96.878 Y120.407 E.01111
G1 X96.979 Y120.398 E.0032
G1 X115.022 Y120.398 E.57408
G1 X115.433 Y120.569 E.01418
G1 X115.602 Y120.979 E.0141
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
M73 P53 R9
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.846 I.021 J.24 E.0056
G1 X115.21 Y120.979 E.00424
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.099 Y128.753 Z2.4 F12000
G1 X116.39 Y119.614 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.704 J.19 E.0434
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-104.714 J-.21 E.04357
; LINE_WIDTH: 0.43721
G1 X95.603 Y133.021 E.06164
; LINE_WIDTH: 0.43707
G1 X95.603 Y131.021 E.06161
; LINE_WIDTH: 0.43693
G1 X95.604 Y129.021 E.06159
; LINE_WIDTH: 0.43679
G1 X95.604 Y127.021 E.06157
; LINE_WIDTH: 0.43665
G1 X95.604 Y125.021 E.06155
; LINE_WIDTH: 0.43651
G1 X95.604 Y123.021 E.06153
; LINE_WIDTH: 0.43637
G1 X95.604 Y121.021 E.06151
; LINE_WIDTH: 0.43623
G1 X95.604 Y120.978 E.00132
; LINE_WIDTH: 0.44999
G1 X95.612 Y119.609 E.04356
G2 X96.979 Y119.603 I.223 J-103.484 E.0435
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.603 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.604 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.604 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.605 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.605 E.06146
; LINE_WIDTH: 0.43584
G1 X108.979 Y119.605 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.606 E.06138
; LINE_WIDTH: 0.43533
G1 X112.979 Y119.606 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.607 E.0613
; LINE_WIDTH: 0.43482
G1 X115.022 Y119.607 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.614 E.04163
M204 S10000
M73 P53 R8
G1 X116.718 Y119.265 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.418 E.00548
G1 X116.798 Y136.537 E.54467
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.251 Y136.712 E.0073
G1 X95.202 Y136.548 E.00545
G1 X95.204 Y119.414 E.54517
G1 X95.279 Y119.261 E.00541
G1 X95.439 Y119.202 E.00542
G1 X116.562 Y119.207 E.67207
G1 X116.661 Y119.244 E.00336
M204 S250
G1 X116.879 Y118.885 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.076 Y119.058 E.00772
G3 X117.189 Y119.418 I-.868 J.472 E.0112
G1 X117.19 Y136.505 E.50359
G1 X117.132 Y136.845 E.01017
G3 X116.886 Y137.102 I-.83 J-.547 E.01055
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.549 J-.832 E.01054
G1 X94.81 Y136.583 E.0093
G1 X94.812 Y119.454 E.50484
G1 X94.866 Y119.158 E.00886
G1 X95.019 Y118.955 E.00749
G3 X95.413 Y118.81 I.55 J.886 E.01246
G1 X116.562 Y118.815 E.62332
G1 X116.82 Y118.872 E.00779
; WIPE_START
M204 S3000
G1 X117.076 Y119.058 E-.11993
G1 X117.131 Y119.178 E-.05005
G1 X117.189 Y119.418 E-.09402
G1 X117.189 Y120.723 E-.496
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y119.965 Z2.4 F12000
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00239
G1 X116.022 Y120.046 E.00239
G1 X116.046 Y120.006 E.00138
; WIPE_START
G1 X116.022 Y120.046 E-.17026
G1 X115.952 Y120.006 E-.29487
G1 X116.022 Y119.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y127.598 Z2.4 F12000
G1 X116.021 Y135.957 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X108.389 Y135.957 Z2.4 F12000
G1 X96.026 Y135.957 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17026
G1 X95.955 Y135.998 E-.29487
G1 X96.026 Y135.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y128.324 Z2.4 F12000
G1 X96.027 Y119.961 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.42054
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00241
G1 X96.027 Y120.043 E.00241
G1 X96.051 Y120.002 E.00139
; WIPE_START
G1 X96.027 Y120.043 E-.17025
G1 X95.957 Y120.002 E-.29487
G1 X96.027 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.4 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 10 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.4 F4000
            G39.3 S1
            G0 Z2.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer10 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 11/40
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.37462
G1 F6000
M204 S3000
G1 X162.416 Y117.756 E.00881
G1 X161.974 Y117.379 E.01507
G1 X162.621 Y117.379 E.01677
G1 X162.621 Y117.967 E.01525
; WIPE_START
G1 X162.416 Y117.756 E-.11179
G1 X161.974 Y117.379 E-.22083
G1 X162.621 Y117.379 E-.24585
G1 X162.621 Y117.857 E-.18154
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.489 Z2.6 F12000
G1 X162.621 Y137.976 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01675
G1 X161.972 Y138.621 E.01685
G1 X162.343 Y138.333 E.01219
G1 X162.584 Y138.023 E.01019
; WIPE_START
G1 X162.621 Y138.621 E-.22767
G1 X161.972 Y138.621 E-.24663
G1 X162.343 Y138.333 E-.17844
G1 X162.516 Y138.11 E-.10726
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y138.27 Z2.6 F12000
G1 X138.024 Y138.621 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01684
G1 X137.667 Y138.343 E.01218
G1 X137.977 Y138.584 E.01019
; WIPE_START
G1 X137.379 Y138.621 E-.22771
G1 X137.379 Y137.972 E-.2466
G1 X137.667 Y138.343 E-.1784
G1 X137.89 Y138.517 E-.1073
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y130.884 Z2.6 F12000
G1 X138.035 Y117.378 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.37399
G1 F6000
M204 S3000
G1 X137.736 Y117.601 E.00964
G1 X137.382 Y118.021 E.01421
G1 X137.382 Y117.378 E.01662
G1 X137.975 Y117.378 E.01534
; WIPE_START
G1 X137.736 Y117.601 E-.12408
G1 X137.382 Y118.021 E-.20873
G1 X137.382 Y117.378 E-.24411
G1 X137.864 Y117.378 E-.18308
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.496 Y117.418 Z2.6 F12000
G1 X161.38 Y117.501 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.45821
G1 F6000
M204 S3000
G1 X161.488 Y117.538 E.00372
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.01121
G1 X162.121 Y117.979 E.01348
G1 X162.333 Y118.26 E.0112
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01791
; LINE_WIDTH: 0.43693
G1 X162.603 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.603 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.603 Y136.801 E.17261
; LINE_WIDTH: 0.44897
G1 X162.542 Y137.258 E.01465
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.584 E.01104
G1 X162.093 Y138.061 E.01845
G1 X161.74 Y138.333 E.01418
G1 X161.356 Y138.511 E.01346
G1 X160.801 Y138.603 E.01792
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.603 E.66589
; LINE_WIDTH: 0.44904
G1 X138.742 Y138.543 E.01463
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01104
G1 X137.939 Y138.093 E.01847
G1 X137.666 Y137.74 E.01419
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.167 E.05019
; LINE_WIDTH: 0.44871
G1 X137.456 Y118.74 E.01369
; LINE_WIDTH: 0.44999
G1 X137.57 Y118.433 E.01041
G1 X137.908 Y117.938 E.01908
G3 X138.965 Y117.409 I1.442 J1.563 E.03809
; LINE_WIDTH: 0.4475
G1 X139.135 Y117.399 E.0054
; LINE_WIDTH: 0.43857
G1 X141.135 Y117.399 E.06185
; LINE_WIDTH: 0.43844
G1 X143.135 Y117.399 E.06183
; LINE_WIDTH: 0.43831
G1 X145.135 Y117.399 E.06181
; LINE_WIDTH: 0.43818
G1 X147.135 Y117.398 E.06179
; LINE_WIDTH: 0.43805
G1 X149.135 Y117.398 E.06177
; LINE_WIDTH: 0.43792
G1 X151.135 Y117.398 E.06175
; LINE_WIDTH: 0.43779
G1 X153.135 Y117.398 E.06173
; LINE_WIDTH: 0.43766
G1 X155.135 Y117.398 E.06171
; LINE_WIDTH: 0.43753
G1 X157.135 Y117.398 E.06169
; LINE_WIDTH: 0.4374
G1 X159.135 Y117.397 E.06167
; LINE_WIDTH: 0.43727
G1 X160.8 Y117.397 E.05132
; LINE_WIDTH: 0.45821
G3 X161.159 Y117.427 I.06 J1.456 E.0117
G1 X161.323 Y117.482 E.00562
M204 S10000
M73 P54 R8
G1 X161.278 Y117.914 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01149
G3 X162.113 Y118.731 I-1.038 J1.312 E.02695
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.187 E.01243
G1 X161.925 Y137.627 E.01563
G3 X161.269 Y138.113 I-1.334 J-1.117 E.02623
G1 X160.801 Y138.202 E.01516
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.926 E.01564
G3 X137.887 Y137.269 I1.117 J-1.334 E.02624
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.167 E.56104
G1 X137.855 Y118.817 E.0113
G1 X138.072 Y118.376 E.01562
G3 X138.67 Y117.909 I1.32 J1.071 E.02433
G1 X139.135 Y117.8 E.01522
G1 X160.8 Y117.798 E.68932
G1 X161.102 Y117.834 E.00968
G1 X161.224 Y117.889 E.00424
M204 S250
G1 X161.125 Y118.251 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.462 E.01227
G1 X161.73 Y118.815 E.01271
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.801 E.51875
G1 X161.733 Y137.18 E.0114
G1 X161.538 Y137.484 E.01065
G1 X161.185 Y137.73 E.0127
G1 X160.801 Y137.81 E.01156
G1 X139.199 Y137.81 E.63664
G1 X138.821 Y137.734 E.01139
G1 X138.516 Y137.538 E.01066
G1 X138.27 Y137.184 E.01271
G1 X138.19 Y136.801 E.01156
G1 X138.191 Y119.167 E.51969
G1 X138.262 Y118.832 E.0101
G1 X138.459 Y118.518 E.01092
G1 X138.776 Y118.287 E.01158
G1 X139.135 Y118.193 E.01095
G1 X160.8 Y118.19 E.63852
G1 X161.067 Y118.235 E.00798
; WIPE_START
M204 S3000
G1 X161.484 Y118.462 E-.18005
G1 X161.73 Y118.815 E-.16386
G1 X161.81 Y119.199 E-.14901
G1 X161.81 Y119.902 E-.26707
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.254 Y127.522 Z2.6 F12000
G1 X162.92 Y138.931 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.722 Y138.991 E.00658
G2 X160.801 Y138.997 I-.657 J91.945 E.06113
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.997 E.66589
; LINE_WIDTH: 0.44904
G1 X138.703 Y138.991 E.01577
; LINE_WIDTH: 0.44999
G3 X137.184 Y138.976 I-.337 J-41.654 E.04832
G1 X137.048 Y138.89 E.00512
G1 X137.009 Y138.722 E.0055
G2 X137.003 Y136.801 I-90.893 J-.672 E.06114
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.167 E.05019
; LINE_WIDTH: 0.44666
G1 X137.011 Y118.943 E.00709
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.258 I-333.566 J-1.231 E.05362
G1 X137.064 Y117.084 E.00576
G1 X137.249 Y117.009 E.00635
G2 X139.135 Y117.003 I.62 J-107.15 E.06001
; LINE_WIDTH: 0.43857
G1 X141.135 Y117.003 E.06185
; LINE_WIDTH: 0.43844
G1 X143.135 Y117.003 E.06183
; LINE_WIDTH: 0.43831
G1 X145.135 Y117.003 E.06181
; LINE_WIDTH: 0.43818
G1 X147.135 Y117.003 E.06179
; LINE_WIDTH: 0.43805
G1 X149.135 Y117.003 E.06177
; LINE_WIDTH: 0.43792
G1 X151.135 Y117.003 E.06175
; LINE_WIDTH: 0.43779
G1 X153.135 Y117.003 E.06173
; LINE_WIDTH: 0.43766
G1 X155.135 Y117.003 E.06171
; LINE_WIDTH: 0.43753
G1 X157.135 Y117.003 E.06169
; LINE_WIDTH: 0.4374
G1 X159.135 Y117.003 E.06167
; LINE_WIDTH: 0.43727
G1 X160.8 Y117.003 E.05132
; LINE_WIDTH: 0.45821
G2 X161.973 Y117.009 I.685 J-18.069 E.03807
; LINE_WIDTH: 0.44999
G1 X162.759 Y117.013 E.02503
G1 X162.938 Y117.089 E.00618
G1 X162.99 Y117.264 E.00578
; LINE_WIDTH: 0.45008
G2 X162.997 Y119.199 I89.09 J.663 E.06161
; LINE_WIDTH: 0.43693
G1 X162.997 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.997 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.997 Y136.801 E.17261
; LINE_WIDTH: 0.44897
G1 X162.991 Y137.298 E.01579
; LINE_WIDTH: 0.44999
G3 X162.987 Y138.744 I-167.457 J.254 E.04602
G1 X162.94 Y138.875 E.00441
M204 S10000
G1 X163.288 Y139.134 F12000
G1 F6000
M204 S3000
G1 X163.067 Y139.315 E.00909
G1 X162.754 Y139.398 E.0103
G1 X138.754 Y139.398 E.76361
G3 X137.12 Y139.378 I-.391 J-34.977 E.05198
G1 X136.858 Y139.28 E.00891
G1 X136.67 Y139.052 E.00943
G1 X136.602 Y138.754 E.00971
G1 X136.606 Y117.176 E.68654
G1 X136.701 Y116.897 E.00939
G1 X136.887 Y116.7 E.00861
G1 X137.229 Y116.602 E.01132
G1 X161.229 Y116.602 E.76361
G3 X162.861 Y116.617 I.372 J50.522 E.05192
G1 X163.171 Y116.742 E.01065
G1 X163.33 Y116.949 E.00831
G1 X163.397 Y117.264 E.01023
G1 X163.398 Y137.264 E.63634
G3 X163.379 Y138.876 I-35.25 J.384 E.05133
G1 X163.308 Y139.077 E.00677
M204 S250
G1 X163.577 Y139.399 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.407 Y139.566 E.00704
G3 X163.104 Y139.74 I-.686 J-.846 E.01034
G1 X162.785 Y139.79 E.00951
G1 X137.301 Y139.79 E.75106
G1 X136.895 Y139.739 E.01207
G1 X136.621 Y139.6 E.00906
G1 X136.377 Y139.346 E.01039
G1 X136.261 Y139.107 E.00781
G1 X136.21 Y138.785 E.00962
G1 X136.214 Y117.258 E.63446
G1 X136.287 Y116.822 E.01301
G1 X136.449 Y116.559 E.00911
G1 X136.683 Y116.359 E.00906
G3 X137.21 Y116.21 I.737 J1.599 E.01622
G1 X162.455 Y116.21 E.74402
G1 X163.088 Y116.256 E.01873
G1 X163.413 Y116.426 E.01081
G1 X163.622 Y116.653 E.00909
G1 X163.74 Y116.894 E.00792
G1 X163.789 Y117.264 E.01097
G1 X163.79 Y138.699 E.63174
G1 X163.739 Y139.107 E.01211
G3 X163.61 Y139.348 I-1.018 J-.386 E.0081
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.407 Y139.566 E-.11315
G1 X163.104 Y139.74 E-.13278
G1 X162.785 Y139.79 E-.12264
G1 X161.755 Y139.79 E-.39144
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.139 Y139.278 Z2.6 F12000
G1 X96.103 Y135.376 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01892
; LINE_WIDTH: 0.44605
G1 X96.979 Y119.997 E.00537
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.997 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.998 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.998 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.998 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.998 E.06146
; LINE_WIDTH: 0.43584
G1 X108.979 Y119.998 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.998 E.06138
; LINE_WIDTH: 0.43533
G1 X112.979 Y119.998 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.998 E.0613
; LINE_WIDTH: 0.43482
G1 X115.021 Y119.998 E.00132
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02403
G1 X116.003 Y120.979 E.0239
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.13 Y135.43 E.01039
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.022 Y120.398 E.57408
G1 X115.433 Y120.569 E.01418
G1 X115.602 Y120.979 E.0141
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.846 I.021 J.24 E.0056
G1 X115.21 Y120.979 E.00424
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.099 Y128.753 Z2.6 F12000
G1 X116.39 Y119.614 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.704 J.19 E.0434
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.223 J-103.837 E.04357
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.603 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.604 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.604 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.605 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.605 E.06146
; LINE_WIDTH: 0.43584
G1 X108.979 Y119.605 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.606 E.06138
; LINE_WIDTH: 0.43533
G1 X112.979 Y119.606 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.607 E.0613
; LINE_WIDTH: 0.43482
G1 X115.022 Y119.607 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.614 E.04163
M204 S10000
G1 X116.701 Y119.259 F12000
G1 F6000
M204 S3000
G1 X116.739 Y119.273 E.00129
G1 X116.797 Y119.441 E.00566
G1 X116.798 Y136.537 E.54392
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.72 E.00694
G1 X95.202 Y136.56 E.00541
G1 X95.202 Y119.463 E.54396
G1 X95.281 Y119.26 E.00694
G1 X95.44 Y119.202 E.0054
G1 X116.562 Y119.207 E.67205
M73 P55 R8
G1 X116.645 Y119.238 E.0028
M204 S250
G1 X116.839 Y118.887 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.045 Y119.017 E.00717
G3 X117.189 Y119.441 I-.461 J.394 E.01353
G1 X117.19 Y136.505 E.5029
G1 X117.132 Y136.845 E.01016
G3 X116.886 Y137.102 I-.831 J-.548 E.01056
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01017
G1 X94.955 Y136.98 E.0074
G3 X94.81 Y136.587 I.838 J-.532 E.01245
G1 X94.81 Y119.495 E.50373
G1 X94.868 Y119.155 E.01018
G1 X95.02 Y118.955 E.0074
G3 X95.413 Y118.81 I.531 J.838 E.01245
G1 X116.562 Y118.815 E.62331
G1 X116.788 Y118.857 E.00675
; WIPE_START
M204 S3000
G1 X117.045 Y119.017 E-.11513
G1 X117.16 Y119.224 E-.09005
G1 X117.189 Y119.441 E-.08334
G1 X117.189 Y120.682 E-.47148
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y119.965 Z2.6 F12000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00239
G1 X116.022 Y120.046 E.00239
G1 X116.046 Y120.006 E.00138
; WIPE_START
G1 X116.022 Y120.046 E-.17026
G1 X115.952 Y120.006 E-.29487
G1 X116.022 Y119.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y127.598 Z2.6 F12000
G1 X116.021 Y135.957 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X108.389 Y135.957 Z2.6 F12000
G1 X96.026 Y135.957 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z2.6 F12000
G1 X96.026 Y119.961 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17026
G1 X95.955 Y120.002 E-.29487
G1 X96.026 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.6 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 11 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.6 F4000
            G39.3 S1
            G0 Z2.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer11 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 12/40
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.62 Y118.027 F12000
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.37461
G1 F6000
M204 S3000
G1 X162.415 Y117.756 E.00881
G1 X161.974 Y117.379 E.01506
G1 X162.621 Y117.379 E.01677
G1 X162.62 Y117.967 E.01525
; WIPE_START
G1 X162.415 Y117.756 E-.11178
G1 X161.974 Y117.379 E-.22074
G1 X162.621 Y117.379 E-.24583
G1 X162.62 Y117.857 E-.18164
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.489 Z2.8 F12000
G1 X162.618 Y137.98 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.0166
G1 X161.971 Y138.622 E.01675
G1 X162.341 Y138.334 E.01213
G1 X162.581 Y138.027 E.01008
; WIPE_START
G1 X162.618 Y138.622 E-.22629
G1 X161.971 Y138.622 E-.24597
G1 X162.341 Y138.334 E-.17808
G1 X162.519 Y138.107 E-.10967
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y138.266 Z2.8 F12000
G1 X138.02 Y138.618 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.37394
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.01661
G1 X137.378 Y137.971 E.01675
G1 X137.666 Y138.341 E.01212
G1 X137.973 Y138.581 E.01009
; WIPE_START
G1 X137.378 Y138.618 E-.22639
G1 X137.378 Y137.971 E-.24599
G1 X137.666 Y138.341 E-.17807
G1 X137.893 Y138.519 E-.10955
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.943 Y130.886 Z2.8 F12000
G1 X138.031 Y117.378 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.744 Y117.594 E.00928
G1 X137.382 Y118.021 E.01451
G1 X137.382 Y117.378 E.01664
G1 X137.971 Y117.378 E.01525
; WIPE_START
G1 X137.744 Y117.594 E-.1189
G1 X137.382 Y118.021 E-.21307
G1 X137.382 Y117.378 E-.2444
G1 X137.865 Y117.378 E-.18363
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.497 Y117.418 Z2.8 F12000
G1 X161.381 Y117.502 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.45821
G1 F6000
M204 S3000
G1 X161.488 Y117.538 E.00367
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.0112
G1 X162.121 Y117.979 E.01347
G1 X162.334 Y118.26 E.01121
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.0179
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.801 E.04917
; LINE_WIDTH: 0.44857
G1 X162.542 Y137.258 E.01463
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.584 E.01103
G1 X162.092 Y138.062 E.01851
G1 X161.74 Y138.333 E.01413
G1 X161.356 Y138.511 E.01346
G1 X160.801 Y138.603 E.01792
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.603 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.603 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.603 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.602 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.602 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.602 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.602 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.602 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.602 E.06143
; LINE_WIDTH: 0.43575
G1 X139.199 Y138.602 E.04916
; LINE_WIDTH: 0.44856
G1 X138.743 Y138.542 E.0146
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01104
G1 X137.938 Y138.092 E.01853
G1 X137.666 Y137.74 E.01413
G1 X137.489 Y137.356 E.01345
G1 X137.397 Y136.801 E.01792
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.167 E.05019
; LINE_WIDTH: 0.44792
G1 X137.448 Y118.772 E.01262
; LINE_WIDTH: 0.44999
G3 X138.233 Y117.682 I1.787 J.46 E.04375
G3 X138.965 Y117.409 I1.006 J1.583 E.02503
; LINE_WIDTH: 0.44751
G1 X139.135 Y117.399 E.0054
; LINE_WIDTH: 0.43858
G1 X141.135 Y117.399 E.06185
; LINE_WIDTH: 0.43844
G1 X143.135 Y117.399 E.06183
; LINE_WIDTH: 0.43831
G1 X145.135 Y117.399 E.06181
; LINE_WIDTH: 0.43818
G1 X147.135 Y117.398 E.06179
; LINE_WIDTH: 0.43805
G1 X149.135 Y117.398 E.06177
; LINE_WIDTH: 0.43792
G1 X151.135 Y117.398 E.06175
; LINE_WIDTH: 0.43779
G1 X153.135 Y117.398 E.06173
; LINE_WIDTH: 0.43766
G1 X155.135 Y117.398 E.06171
; LINE_WIDTH: 0.43753
G1 X157.135 Y117.398 E.06169
; LINE_WIDTH: 0.4374
G1 X159.135 Y117.397 E.06167
; LINE_WIDTH: 0.43726
G1 X160.8 Y117.397 E.05132
; LINE_WIDTH: 0.45821
G3 X161.159 Y117.427 I.06 J1.456 E.01171
G1 X161.324 Y117.483 E.00567
M204 S10000
G1 X161.28 Y117.915 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01143
G3 X162.113 Y118.732 I-1.039 J1.313 E.02696
G1 X162.202 Y119.199 E.01515
G1 X162.202 Y136.801 E.56003
G1 X162.142 Y137.187 E.01242
G1 X161.926 Y137.627 E.01561
G3 X161.269 Y138.113 I-1.335 J-1.117 E.02625
G1 X160.801 Y138.202 E.01516
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.0124
G1 X138.373 Y137.925 E.01565
G3 X137.887 Y137.269 I1.115 J-1.333 E.02623
G1 X137.798 Y136.801 E.01517
G1 X137.799 Y119.167 E.56104
G1 X137.847 Y118.843 E.01042
G1 X138.069 Y118.382 E.01628
G3 X138.483 Y118.004 I1.14 J.83 E.01796
G1 X138.685 Y117.903 E.00719
G1 X139.135 Y117.8 E.0147
G1 X160.8 Y117.798 E.68932
G1 X161.102 Y117.834 E.00968
G1 X161.225 Y117.89 E.00429
M204 S250
G1 X161.126 Y118.252 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.461 E.01222
G1 X161.73 Y118.816 E.01272
G1 X161.81 Y119.199 E.01155
G1 X161.81 Y136.801 E.51876
G1 X161.733 Y137.18 E.01139
G1 X161.539 Y137.484 E.01064
G1 X161.185 Y137.73 E.01271
G1 X160.801 Y137.81 E.01156
G1 X139.199 Y137.81 E.63664
G1 X138.821 Y137.734 E.01138
G1 X138.516 Y137.538 E.01067
G1 X138.27 Y137.185 E.01269
G1 X138.19 Y136.801 E.01156
G1 X138.191 Y119.167 E.51969
G1 X138.254 Y118.854 E.00944
G1 X138.46 Y118.517 E.01162
G1 X138.723 Y118.314 E.0098
G1 X139.135 Y118.193 E.01267
G1 X160.8 Y118.19 E.63852
G1 X161.069 Y118.236 E.00803
; WIPE_START
M204 S3000
G1 X161.484 Y118.461 E-.17937
G1 X161.73 Y118.816 E-.16399
G1 X161.81 Y119.199 E-.14894
G1 X161.81 Y119.904 E-.2677
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.263 Y127.523 Z2.8 F12000
G1 X162.94 Y138.912 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.751 Y138.991 E.00652
G2 X160.801 Y138.997 I-.683 J92.645 E.06207
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.997 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.997 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.996 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.996 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.996 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.995 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.995 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.995 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.995 E.06143
; LINE_WIDTH: 0.43575
G1 X139.199 Y138.995 E.04916
; LINE_WIDTH: 0.44485
G1 X138.991 Y138.99 E.00655
; LINE_WIDTH: 0.44999
G2 X137.234 Y138.987 I-1.278 J249.126 E.05589
G1 X137.065 Y138.913 E.0059
G1 X137.009 Y138.742 E.00573
G2 X137.003 Y136.801 I-91.89 J-.682 E.06176
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.167 E.05019
; LINE_WIDTH: 0.44525
G1 X137.01 Y118.958 E.00658
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.253 I-229.191 J-1.21 E.05424
G1 X137.065 Y117.089 E.0055
G1 X137.239 Y117.009 E.0061
G2 X139.135 Y117.003 I.636 J-103.837 E.06033
; LINE_WIDTH: 0.43858
G1 X141.135 Y117.003 E.06185
; LINE_WIDTH: 0.43844
M73 P56 R8
G1 X143.135 Y117.003 E.06183
; LINE_WIDTH: 0.43831
G1 X145.135 Y117.003 E.06181
; LINE_WIDTH: 0.43818
G1 X147.135 Y117.003 E.06179
; LINE_WIDTH: 0.43805
G1 X149.135 Y117.003 E.06177
; LINE_WIDTH: 0.43792
G1 X151.135 Y117.003 E.06175
; LINE_WIDTH: 0.43779
G1 X153.135 Y117.003 E.06173
; LINE_WIDTH: 0.43766
G1 X155.135 Y117.003 E.06171
; LINE_WIDTH: 0.43753
G1 X157.135 Y117.003 E.06169
; LINE_WIDTH: 0.4374
G1 X159.135 Y117.003 E.06167
; LINE_WIDTH: 0.43726
G1 X160.8 Y117.003 E.05132
; LINE_WIDTH: 0.44274
G1 X160.963 Y117.006 E.00508
; LINE_WIDTH: 0.44999
G2 X162.722 Y117.009 I1.211 J-159.886 E.05596
G1 X162.923 Y117.069 E.00668
G1 X162.99 Y117.278 E.00697
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I87.367 J.67 E.06116
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.801 E.04917
; LINE_WIDTH: 0.44488
G1 X162.99 Y137.01 E.00657
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.738 I245.765 J1.259 E.05497
G1 X162.956 Y138.854 E.00384
M204 S10000
G1 X163.266 Y139.144 F12000
G1 F6000
M204 S3000
G1 X163.113 Y139.3 E.00695
G1 X162.771 Y139.398 E.01131
G1 X137.27 Y139.394 E.81138
G1 X136.942 Y139.332 E.01062
G1 X136.696 Y139.109 E.01055
G1 X136.602 Y138.766 E.01132
G1 X136.606 Y117.176 E.68691
G1 X136.704 Y116.897 E.00942
G1 X136.94 Y116.671 E.01038
G1 X137.223 Y116.602 E.00928
G1 X161.223 Y116.602 E.76361
G3 X162.953 Y116.628 I.374 J32.88 E.05506
G1 X163.186 Y116.758 E.00847
G1 X163.355 Y117.001 E.00943
G1 X163.397 Y117.278 E.0089
G1 X163.394 Y138.82 E.68541
G1 X163.3 Y139.096 E.00928
M204 S250
G1 X163.559 Y139.429 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.552 Y139.44 E.00041
G1 X163.317 Y139.641 E.0091
G3 X162.79 Y139.79 I-.731 J-1.578 E.0162
G1 X137.132 Y139.786 E.75622
G1 X136.783 Y139.695 E.01062
G1 X136.56 Y139.553 E.0078
G1 X136.358 Y139.316 E.00917
G3 X136.21 Y138.789 I1.424 J-.684 E.01623
G1 X136.214 Y117.253 E.6347
G1 X136.287 Y116.823 E.01285
G1 X136.464 Y116.542 E.0098
G1 X136.754 Y116.319 E.01077
G1 X137.208 Y116.21 E.01375
G1 X162.455 Y116.21 E.74409
G1 X163.066 Y116.248 E.01804
G1 X163.35 Y116.38 E.00924
G1 X163.548 Y116.556 E.00781
G1 X163.727 Y116.86 E.01039
G1 X163.789 Y117.278 E.01246
G1 X163.786 Y138.738 E.63247
G1 X163.702 Y139.202 E.01392
G1 X163.591 Y139.378 E.00612
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.552 Y139.44 E-.02808
G1 X163.317 Y139.641 E-.1173
G1 X163.12 Y139.718 E-.08049
G1 X162.79 Y139.79 E-.12819
G1 X161.722 Y139.79 E-.40594
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.749 Y136.686 Z2.8 F12000
G1 X116.39 Y119.614 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.704 J.19 E.0434
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.223 J-103.837 E.04357
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.603 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.604 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.604 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.605 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.605 E.06146
; LINE_WIDTH: 0.43584
G1 X108.979 Y119.605 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.606 E.06138
; LINE_WIDTH: 0.43533
G1 X112.979 Y119.606 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.607 E.0613
; LINE_WIDTH: 0.43482
G1 X115.022 Y119.607 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.614 E.04163
M204 S10000
G1 X116.716 Y119.268 F12000
G1 F6000
M204 S3000
G1 X116.742 Y119.279 E.00088
G1 X116.797 Y119.442 E.00548
G1 X116.798 Y136.537 E.54391
G1 X116.713 Y136.749 E.0073
G1 X116.548 Y136.798 E.00546
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.719 E.00694
G1 X95.202 Y136.56 E.0054
G1 X95.202 Y119.463 E.54395
G1 X95.279 Y119.262 E.00688
G1 X95.439 Y119.202 E.00543
G1 X116.573 Y119.207 E.67241
G1 X116.661 Y119.245 E.00304
M204 S250
G1 X116.878 Y118.887 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.037 Y119.026 E.00625
G3 X117.189 Y119.442 I-.518 J.425 E.0133
G1 X117.19 Y136.505 E.50289
G1 X117.132 Y136.845 E.01018
G3 X116.886 Y137.102 I-.829 J-.547 E.01054
G1 X116.583 Y137.19 E.00931
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01016
G1 X94.955 Y136.98 E.00742
G3 X94.81 Y136.587 I.837 J-.531 E.01244
G1 X94.81 Y119.495 E.50373
G1 X94.868 Y119.155 E.01017
G1 X95.019 Y118.955 E.00737
G3 X95.413 Y118.81 I.543 J.863 E.01247
G1 X116.563 Y118.815 E.62334
G1 X116.822 Y118.868 E.00778
; WIPE_START
M204 S3000
G1 X117.037 Y119.026 E-.10156
G1 X117.16 Y119.224 E-.08863
G1 X117.189 Y119.442 E-.08345
G1 X117.189 Y120.722 E-.48636
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.922 Y125.077 Z2.8 F12000
G1 X96.103 Y135.376 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01892
; LINE_WIDTH: 0.44605
G1 X96.979 Y119.997 E.00537
; LINE_WIDTH: 0.43712
G1 X98.979 Y119.997 E.06162
; LINE_WIDTH: 0.43686
G1 X100.979 Y119.998 E.06158
; LINE_WIDTH: 0.43661
G1 X102.979 Y119.998 E.06154
; LINE_WIDTH: 0.43635
G1 X104.979 Y119.998 E.0615
; LINE_WIDTH: 0.4361
G1 X106.979 Y119.998 E.06146
; LINE_WIDTH: 0.43584
G1 X108.979 Y119.998 E.06142
; LINE_WIDTH: 0.43559
G1 X110.979 Y119.998 E.06138
; LINE_WIDTH: 0.43533
G1 X112.979 Y119.998 E.06134
; LINE_WIDTH: 0.43508
G1 X114.979 Y119.998 E.0613
; LINE_WIDTH: 0.43482
G1 X115.021 Y119.998 E.00132
; LINE_WIDTH: 0.44999
G1 X115.722 Y120.282 E.02403
G1 X116.003 Y120.979 E.0239
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.13 Y135.43 E.01039
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.022 Y120.398 E.57408
G1 X115.433 Y120.569 E.01418
G1 X115.602 Y120.979 E.0141
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.846 I.021 J.24 E.0056
G1 X115.21 Y120.979 E.00424
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.354 Y125.458 Z2.8 F12000
G1 X96.026 Y119.961 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17026
G1 X95.955 Y120.002 E-.29487
G1 X96.026 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y127.594 Z2.8 F12000
G1 X96.026 Y135.957 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y135.957 Z2.8 F12000
G1 X116.021 Y135.957 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y128.324 Z2.8 F12000
G1 X116.022 Y119.965 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.41856
M73 P57 R8
G1 F6000
M204 S3000
G1 X115.952 Y120.006 E.00239
G1 X116.022 Y120.046 E.00239
G1 X116.046 Y120.006 E.00138
; WIPE_START
G1 X116.022 Y120.046 E-.17026
G1 X115.952 Y120.006 E-.29487
G1 X116.022 Y119.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z2.8 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 12 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z2.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z2.8 F4000
            G39.3 S1
            G0 Z2.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer12 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 13/40
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.62 Y118.027 F12000
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.37459
G1 F6000
M204 S3000
G1 X162.415 Y117.756 E.00881
G1 X161.974 Y117.379 E.01505
G1 X162.621 Y117.379 E.01677
G1 X162.62 Y117.967 E.01525
; WIPE_START
G1 X162.415 Y117.756 E-.11187
G1 X161.974 Y117.379 E-.22064
G1 X162.621 Y117.379 E-.24582
G1 X162.62 Y117.857 E-.18167
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.489 Z3 F12000
G1 X162.618 Y137.98 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.37395
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.0166
G1 X161.971 Y138.622 E.01675
G1 X162.341 Y138.334 E.01213
G1 X162.581 Y138.027 E.01008
; WIPE_START
G1 X162.618 Y138.622 E-.22631
G1 X161.971 Y138.622 E-.24602
G1 X162.341 Y138.334 E-.1781
G1 X162.519 Y138.107 E-.10957
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y138.266 Z3 F12000
G1 X138.02 Y138.618 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.0166
G1 X137.378 Y137.971 E.01675
G1 X137.666 Y138.341 E.01213
G1 X137.973 Y138.581 E.01009
; WIPE_START
G1 X137.378 Y138.618 E-.22635
G1 X137.378 Y137.971 E-.24601
G1 X137.666 Y138.341 E-.1781
G1 X137.893 Y138.519 E-.10954
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.944 Y130.886 Z3 F12000
G1 X138.034 Y117.378 Z3
G1 Z2.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.736 Y117.6 E.00962
G1 X137.382 Y118.021 E.01424
G1 X137.382 Y117.378 E.01664
G1 X137.974 Y117.378 E.01533
; WIPE_START
G1 X137.736 Y117.6 E-.12382
G1 X137.382 Y118.021 E-.20909
G1 X137.382 Y117.378 E-.24444
G1 X137.862 Y117.378 E-.18265
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.495 Y117.419 Z3 F12000
G1 X161.383 Y117.503 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.45822
G1 F6000
M204 S3000
G1 X161.488 Y117.538 E.00362
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.0112
G1 X162.121 Y117.979 E.01347
G1 X162.333 Y118.26 E.01121
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01792
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.801 E.04916
; LINE_WIDTH: 0.44852
G1 X162.542 Y137.258 E.01462
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.584 E.01104
G1 X162.092 Y138.062 E.01852
G1 X161.74 Y138.334 E.01414
G1 X161.404 Y138.499 E.01192
G1 X160.883 Y138.599 E.01686
; LINE_WIDTH: 0.43936
G1 X158.883 Y138.6 E.06197
; LINE_WIDTH: 0.43901
G1 X156.883 Y138.6 E.06192
; LINE_WIDTH: 0.43867
G1 X154.883 Y138.6 E.06186
; LINE_WIDTH: 0.43833
G1 X152.883 Y138.6 E.06181
; LINE_WIDTH: 0.43799
G1 X150.883 Y138.601 E.06176
; LINE_WIDTH: 0.43764
G1 X148.883 Y138.601 E.0617
; LINE_WIDTH: 0.4373
G1 X146.883 Y138.601 E.06165
; LINE_WIDTH: 0.43696
G1 X144.883 Y138.601 E.0616
; LINE_WIDTH: 0.43662
G1 X142.883 Y138.602 E.06154
; LINE_WIDTH: 0.43628
G1 X140.883 Y138.602 E.06149
; LINE_WIDTH: 0.43593
G1 X139.2 Y138.602 E.05172
; LINE_WIDTH: 0.44857
G1 X138.742 Y138.542 E.01463
; LINE_WIDTH: 0.44999
G1 X138.416 Y138.423 E.01104
G1 X137.938 Y138.092 E.01851
G1 X137.666 Y137.74 E.01413
G1 X137.489 Y137.356 E.01345
G1 X137.397 Y136.801 E.01792
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05018
; LINE_WIDTH: 0.44791
G1 X137.448 Y118.772 E.01262
; LINE_WIDTH: 0.44999
G3 X138.946 Y117.411 I1.787 J.462 E.06818
; LINE_WIDTH: 0.44842
G1 X139.117 Y117.4 E.00541
; LINE_WIDTH: 0.43949
G1 X141.117 Y117.4 E.06199
; LINE_WIDTH: 0.43927
G1 X143.117 Y117.4 E.06196
; LINE_WIDTH: 0.43905
G1 X145.117 Y117.4 E.06192
; LINE_WIDTH: 0.43883
G1 X147.117 Y117.399 E.06189
; LINE_WIDTH: 0.43862
G1 X149.117 Y117.399 E.06186
; LINE_WIDTH: 0.4384
G1 X151.117 Y117.399 E.06182
; LINE_WIDTH: 0.43818
G1 X153.117 Y117.398 E.06179
; LINE_WIDTH: 0.43797
G1 X155.117 Y117.398 E.06176
; LINE_WIDTH: 0.43775
G1 X157.117 Y117.398 E.06172
; LINE_WIDTH: 0.43753
G1 X159.117 Y117.398 E.06169
; LINE_WIDTH: 0.43732
G1 X160.8 Y117.397 E.0519
; LINE_WIDTH: 0.45822
G3 X161.159 Y117.427 I.06 J1.456 E.01172
G1 X161.326 Y117.483 E.00572
M204 S10000
G1 X161.282 Y117.915 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01137
G3 X162.113 Y118.731 I-1.039 J1.313 E.02696
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01242
G1 X161.926 Y137.627 E.01563
G3 X161.494 Y138.009 I-1.175 J-.893 E.01845
G1 X161.036 Y138.177 E.01554
G1 X160.883 Y138.198 E.0049
G1 X139.199 Y138.202 E.68992
G1 X138.814 Y138.142 E.01242
G1 X138.373 Y137.926 E.01563
G1 X138.238 Y137.817 E.00551
G1 X137.991 Y137.494 E.01292
G1 X137.887 Y137.269 E.00791
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.168 E.56103
G1 X137.847 Y118.844 E.01042
G1 X138.069 Y118.382 E.01629
G1 X138.216 Y118.21 E.0072
G1 X138.663 Y117.911 E.0171
G1 X139.117 Y117.802 E.01484
G1 X160.8 Y117.798 E.68992
G1 X161.103 Y117.834 E.00968
G1 X161.227 Y117.891 E.00434
M204 S250
G1 X161.128 Y118.252 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.461 E.01216
G1 X161.73 Y118.815 E.01272
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.801 E.51875
G1 X161.733 Y137.179 E.01139
G1 X161.538 Y137.484 E.01066
G1 X161.194 Y137.728 E.01245
G1 X160.883 Y137.806 E.00943
G1 X139.199 Y137.81 E.63907
G1 X138.82 Y137.733 E.0114
G1 X138.527 Y137.552 E.01016
G1 X138.27 Y137.184 E.01323
G1 X138.19 Y136.801 E.01156
G1 X138.191 Y119.168 E.51968
G1 X138.254 Y118.854 E.00944
G1 X138.459 Y118.518 E.01158
G1 X138.774 Y118.287 E.0115
G1 X139.117 Y118.194 E.01047
G1 X160.8 Y118.19 E.63907
G1 X161.071 Y118.236 E.00809
; WIPE_START
M204 S3000
G1 X161.484 Y118.461 E-.17867
G1 X161.73 Y118.815 E-.16395
G1 X161.81 Y119.199 E-.14902
G1 X161.81 Y119.906 E-.26835
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.252 Y127.525 Z3 F12000
G1 X162.914 Y138.936 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.732 Y138.991 E.00605
G2 X160.883 Y138.996 I-.642 J103.168 E.05881
; LINE_WIDTH: 0.43936
G1 X158.883 Y138.996 E.06197
; LINE_WIDTH: 0.43901
G1 X156.883 Y138.996 E.06192
; LINE_WIDTH: 0.43867
G1 X154.883 Y138.996 E.06186
; LINE_WIDTH: 0.43833
G1 X152.883 Y138.995 E.06181
; LINE_WIDTH: 0.43799
G1 X150.883 Y138.995 E.06176
; LINE_WIDTH: 0.43764
G1 X148.883 Y138.995 E.0617
; LINE_WIDTH: 0.4373
G1 X146.883 Y138.995 E.06165
; LINE_WIDTH: 0.43696
G1 X144.883 Y138.995 E.0616
; LINE_WIDTH: 0.43662
G1 X142.883 Y138.995 E.06154
; LINE_WIDTH: 0.43628
G1 X140.883 Y138.995 E.06149
; LINE_WIDTH: 0.43593
G1 X139.2 Y138.995 E.05172
; LINE_WIDTH: 0.44486
G1 X138.991 Y138.99 E.00656
; LINE_WIDTH: 0.44999
G2 X137.231 Y138.987 I-1.28 J249.812 E.05601
G1 X137.063 Y138.911 E.00588
G1 X137.009 Y138.732 E.00593
G2 X137.003 Y136.801 I-91.176 J-.678 E.06145
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05018
; LINE_WIDTH: 0.44522
G1 X137.01 Y118.959 E.00657
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.225 I-232.23 J-1.229 E.05518
G1 X137.086 Y117.066 E.00555
G1 X137.268 Y117.009 E.00609
G2 X139.117 Y117.004 I.604 J-113.106 E.05881
; LINE_WIDTH: 0.43949
G1 X141.117 Y117.004 E.06199
; LINE_WIDTH: 0.43927
G1 X143.117 Y117.004 E.06196
; LINE_WIDTH: 0.43905
G1 X145.117 Y117.004 E.06192
; LINE_WIDTH: 0.43883
G1 X147.117 Y117.004 E.06189
; LINE_WIDTH: 0.43862
G1 X149.117 Y117.004 E.06186
; LINE_WIDTH: 0.4384
G1 X151.117 Y117.003 E.06182
; LINE_WIDTH: 0.43818
G1 X153.117 Y117.003 E.06179
; LINE_WIDTH: 0.43797
G1 X155.117 Y117.003 E.06176
; LINE_WIDTH: 0.43775
G1 X157.117 Y117.003 E.06172
; LINE_WIDTH: 0.43753
G1 X159.117 Y117.003 E.06169
; LINE_WIDTH: 0.43732
G1 X160.8 Y117.003 E.0519
; LINE_WIDTH: 0.44275
G1 X160.963 Y117.006 E.00509
; LINE_WIDTH: 0.44999
G2 X162.747 Y117.01 I1.224 J-161.747 E.05678
G1 X162.928 Y117.076 E.00613
G1 X162.99 Y117.291 E.00711
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I86.795 J.663 E.06073
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.801 E.04916
; LINE_WIDTH: 0.44457
G1 X162.99 Y137.009 E.00655
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.769 I237.074 J1.276 E.05601
G1 X162.938 Y138.881 E.00389
M204 S10000
G1 X163.289 Y139.12 F12000
G1 F6000
M204 S3000
G1 X163.106 Y139.307 E.00831
G1 X162.76 Y139.398 E.0114
G1 X137.18 Y139.394 E.81388
G1 X136.886 Y139.294 E.00988
G1 X136.693 Y139.104 E.00862
G1 X136.602 Y138.76 E.01133
G1 X136.606 Y117.176 E.68672
G1 X136.703 Y116.895 E.00946
G1 X136.896 Y116.693 E.00891
G1 X137.24 Y116.602 E.01133
G1 X161.24 Y116.602 E.76361
G3 X162.825 Y116.609 I.365 J97.147 E.05041
G1 X163.13 Y116.71 E.01023
G1 X163.342 Y116.966 E.01058
G1 X163.397 Y117.291 E.01049
G1 X163.394 Y138.82 E.68499
G1 X163.309 Y139.063 E.00819
M204 S250
G1 X163.565 Y139.392 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.428 Y139.548 E.0061
G3 X163.189 Y139.698 I-.641 J-.755 E.00836
G1 X162.787 Y139.79 E.01216
G1 X137.283 Y139.786 E.75165
G3 X136.678 Y139.626 I-.001 J-1.219 E.01868
G3 X136.301 Y139.187 I.567 J-.867 E.01728
G1 X136.21 Y138.787 E.0121
G1 X136.214 Y117.283 E.63376
G3 X136.813 Y116.301 I1.058 J-.029 E.03586
G1 X137.213 Y116.21 E.0121
G1 X162.455 Y116.21 E.74392
G1 X163.066 Y116.248 E.01804
G1 X163.349 Y116.379 E.0092
G3 X163.711 Y116.82 I-.548 J.819 E.01705
G1 X163.789 Y117.291 E.01409
G1 X163.786 Y138.717 E.63145
G3 X163.619 Y139.331 I-1.183 J.007 E.019
G1 X163.605 Y139.347 E.00064
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.428 Y139.548 E-.10151
G1 X163.189 Y139.698 E-.10736
G1 X162.787 Y139.79 E-.1568
G1 X161.749 Y139.79 E-.39433
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.776 Y136.687 Z3 F12000
G1 X116.39 Y119.61 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.437 J.191 E.04356
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.199 J-105.199 E.04357
; LINE_WIDTH: 0.4373
G1 X106.979 Y119.603 E.30825
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.603 E.24786
; LINE_WIDTH: 0.44999
M73 P58 R8
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.716 Y119.275 F12000
G1 F6000
M204 S3000
G1 X116.75 Y119.289 E.00117
G1 X116.797 Y119.441 E.00505
G1 X116.798 Y136.537 E.54394
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00546
G1 X95.463 Y136.798 E.67085
G1 X95.251 Y136.712 E.0073
G1 X95.202 Y136.548 E.00546
G1 X95.202 Y119.463 E.54358
G1 X95.28 Y119.26 E.00694
G1 X95.441 Y119.202 E.00542
G1 X116.548 Y119.202 E.67159
G1 X116.661 Y119.251 E.00391
M204 S250
G1 X116.881 Y118.891 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.058 Y119.034 E.00669
G3 X117.189 Y119.441 I-.468 J.376 E.0129
G1 X117.19 Y136.505 E.50292
G1 X117.132 Y136.845 E.01017
G3 X116.886 Y137.102 I-.83 J-.548 E.01054
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.62149
G1 X95.155 Y137.132 E.01018
G3 X94.898 Y136.886 I.547 J-.83 E.01054
G1 X94.81 Y136.583 E.00931
G1 X94.81 Y119.495 E.5036
G1 X94.868 Y119.155 E.01017
G1 X95.02 Y118.955 E.0074
G3 X95.414 Y118.81 I.531 J.837 E.01246
G1 X116.513 Y118.81 E.62184
G1 X116.826 Y118.871 E.00941
; WIPE_START
M204 S3000
G1 X117.058 Y119.034 E-.10742
G1 X117.16 Y119.222 E-.08167
G1 X117.189 Y119.441 E-.08371
G1 X117.189 Y120.723 E-.4872
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.927 Y125.086 Z3 F12000
G1 X96.117 Y135.403 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44623
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.4373
G1 X106.979 Y119.997 E.30825
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.997 E.24786
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
M73 P58 R7
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00559
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z3 F12000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z3 F12000
G1 X96.026 Y119.961 Z3
G1 Z2.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z3 F12000
G1 X116.021 Y119.961 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.4214
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00242
G1 X116.021 Y120.043 E.00242
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z3 F12000
G1 X116.021 Y135.957 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 13 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3 F4000
            G39.3 S1
            G0 Z3 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer13 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 14/40
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.62 Y118.027 F12000
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.37457
G1 F6000
M204 S3000
G1 X162.416 Y117.756 E.0088
G1 X161.974 Y117.379 E.01507
G1 X162.621 Y117.379 E.01677
G1 X162.62 Y117.967 E.01524
; WIPE_START
G1 X162.416 Y117.756 E-.11164
G1 X161.974 Y117.379 E-.22086
G1 X162.621 Y117.379 E-.2458
G1 X162.62 Y117.857 E-.1817
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.49 Z3.2 F12000
G1 X162.618 Y137.98 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.0166
G1 X161.971 Y138.622 E.01675
G1 X162.341 Y138.334 E.01213
G1 X162.581 Y138.028 E.01008
; WIPE_START
G1 X162.618 Y138.622 E-.22625
G1 X161.971 Y138.622 E-.24602
G1 X162.341 Y138.334 E-.17812
G1 X162.519 Y138.107 E-.10961
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y138.266 Z3.2 F12000
G1 X138.02 Y138.618 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.0166
G1 X137.378 Y137.971 E.01675
G1 X137.666 Y138.341 E.01213
G1 X137.973 Y138.581 E.01008
; WIPE_START
G1 X137.378 Y138.618 E-.22627
G1 X137.378 Y137.971 E-.24597
G1 X137.666 Y138.341 E-.17808
G1 X137.893 Y138.519 E-.10968
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.943 Y130.887 Z3.2 F12000
G1 X138.031 Y117.378 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.37327
G1 F6000
M204 S3000
G1 X137.66 Y117.664 E.01209
G1 X137.381 Y118.028 E.01183
G1 X137.381 Y117.378 E.01678
M73 P59 R7
G1 X137.971 Y117.378 E.01521
; WIPE_START
G1 X137.66 Y117.664 E-.16049
G1 X137.381 Y118.028 E-.17416
G1 X137.381 Y117.378 E-.24697
G1 X137.851 Y117.378 E-.17838
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.483 Y117.418 Z3.2 F12000
G1 X161.384 Y117.503 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.45818
G1 F6000
M204 S3000
G1 X161.488 Y117.538 E.00356
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.01121
G1 X162.121 Y117.979 E.01347
G1 X162.333 Y118.26 E.01119
G1 X162.511 Y118.644 E.01345
G1 X162.603 Y119.199 E.01792
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.8 E.04916
; LINE_WIDTH: 0.44852
G1 X162.542 Y137.258 E.01461
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01103
G1 X162.092 Y138.062 E.01853
G1 X161.74 Y138.334 E.01414
G1 X161.356 Y138.511 E.01346
G1 X160.801 Y138.603 E.01791
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.603 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.603 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.603 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.602 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.602 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.602 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.602 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.602 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.602 E.06143
; LINE_WIDTH: 0.43575
G1 X139.2 Y138.602 E.04916
; LINE_WIDTH: 0.44856
G1 X138.742 Y138.542 E.01462
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01103
G1 X137.938 Y138.092 E.01853
G1 X137.667 Y137.74 E.01413
G1 X137.489 Y137.356 E.01347
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05017
; LINE_WIDTH: 0.44859
G1 X137.455 Y118.745 E.01352
; LINE_WIDTH: 0.44999
G1 X137.573 Y118.428 E.01076
G1 X137.912 Y117.933 E.0191
G3 X138.947 Y117.411 I1.439 J1.567 E.03737
; LINE_WIDTH: 0.44837
G1 X139.118 Y117.4 E.00541
; LINE_WIDTH: 0.43943
G1 X141.118 Y117.4 E.06198
; LINE_WIDTH: 0.43921
G1 X143.118 Y117.4 E.06195
; LINE_WIDTH: 0.439
G1 X145.118 Y117.4 E.06192
; LINE_WIDTH: 0.43879
G1 X147.118 Y117.399 E.06188
; LINE_WIDTH: 0.43858
G1 X149.118 Y117.399 E.06185
; LINE_WIDTH: 0.43836
G1 X151.118 Y117.399 E.06182
; LINE_WIDTH: 0.43815
G1 X153.118 Y117.398 E.06178
; LINE_WIDTH: 0.43794
G1 X155.118 Y117.398 E.06175
; LINE_WIDTH: 0.43773
G1 X157.118 Y117.398 E.06172
; LINE_WIDTH: 0.43752
G1 X159.118 Y117.398 E.06168
; LINE_WIDTH: 0.4373
G1 X160.8 Y117.397 E.05187
; LINE_WIDTH: 0.45818
G3 X161.159 Y117.427 I.06 J1.456 E.01171
G1 X161.328 Y117.484 E.00578
M204 S10000
G1 X161.283 Y117.916 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01133
G3 X162.113 Y118.731 I-1.038 J1.311 E.02694
G1 X162.202 Y119.199 E.01517
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01561
G3 X161.268 Y138.113 I-1.336 J-1.118 E.02627
G1 X160.801 Y138.202 E.01515
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.926 E.01561
G1 X138.238 Y137.817 E.00552
G1 X137.991 Y137.495 E.01293
G1 X137.887 Y137.269 E.00792
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.168 E.56102
G1 X137.854 Y118.821 E.01117
G1 X138.087 Y118.359 E.01647
G1 X138.232 Y118.194 E.007
G1 X138.663 Y117.911 E.0164
G1 X139.118 Y117.802 E.01486
G1 X160.8 Y117.798 E.68988
G1 X161.102 Y117.834 E.00968
G1 X161.229 Y117.891 E.0044
M204 S250
G1 X161.129 Y118.253 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.462 E.01212
G1 X161.73 Y118.815 E.0127
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.801 E.51874
G1 X161.734 Y137.179 E.01139
G1 X161.539 Y137.484 E.01065
G1 X161.184 Y137.73 E.01273
G1 X160.801 Y137.81 E.01155
G1 X139.199 Y137.81 E.63663
G1 X138.821 Y137.734 E.01139
G1 X138.528 Y137.552 E.01015
G1 X138.27 Y137.184 E.01324
G1 X138.19 Y136.801 E.01156
G1 X138.191 Y119.168 E.51968
G1 X138.262 Y118.834 E.01007
G1 X138.472 Y118.504 E.01152
G1 X138.774 Y118.287 E.01095
G1 X139.118 Y118.194 E.0105
G1 X160.8 Y118.19 E.63904
G1 X161.073 Y118.236 E.00814
; WIPE_START
M204 S3000
G1 X161.484 Y118.462 E-.17821
G1 X161.73 Y118.815 E-.16375
G1 X161.81 Y119.199 E-.14907
G1 X161.81 Y119.907 E-.26897
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.252 Y127.527 Z3.2 F12000
G1 X162.915 Y138.934 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.742 Y138.991 E.0058
G2 X160.801 Y138.997 I-.681 J91.791 E.06176
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.997 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.997 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.996 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.996 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.996 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.995 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.995 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.995 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.995 E.06143
; LINE_WIDTH: 0.43575
G1 X139.2 Y138.995 E.04916
; LINE_WIDTH: 0.44486
G1 X138.991 Y138.99 E.00655
; LINE_WIDTH: 0.44999
G2 X137.225 Y138.987 I-1.28 J248.713 E.0562
G1 X137.066 Y138.915 E.00554
G1 X137.009 Y138.732 E.0061
G2 X137.003 Y136.8 I-91.374 J-.677 E.06145
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.8 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.8 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.8 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.8 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05017
; LINE_WIDTH: 0.44641
G1 X137.011 Y118.946 E.007
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.225 I-323.238 J-1.251 E.05477
G1 X137.086 Y117.066 E.00555
G1 X137.268 Y117.009 E.00609
G2 X139.118 Y117.004 I.605 J-112.454 E.05884
; LINE_WIDTH: 0.43943
G1 X141.118 Y117.004 E.06198
; LINE_WIDTH: 0.43921
G1 X143.118 Y117.004 E.06195
; LINE_WIDTH: 0.439
G1 X145.118 Y117.004 E.06192
; LINE_WIDTH: 0.43879
G1 X147.118 Y117.004 E.06188
; LINE_WIDTH: 0.43858
G1 X149.118 Y117.004 E.06185
; LINE_WIDTH: 0.43836
G1 X151.118 Y117.003 E.06182
; LINE_WIDTH: 0.43815
G1 X153.118 Y117.003 E.06178
; LINE_WIDTH: 0.43794
G1 X155.118 Y117.003 E.06175
; LINE_WIDTH: 0.43773
G1 X157.118 Y117.003 E.06172
; LINE_WIDTH: 0.43752
G1 X159.118 Y117.003 E.06168
; LINE_WIDTH: 0.4373
G1 X160.8 Y117.003 E.05187
; LINE_WIDTH: 0.44271
G1 X160.963 Y117.006 E.00508
; LINE_WIDTH: 0.44999
G2 X162.749 Y117.01 I1.225 J-161.497 E.05682
G1 X162.927 Y117.075 E.00604
G1 X162.99 Y117.291 E.00716
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I86.823 J.663 E.06073
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.801 E.04916
; LINE_WIDTH: 0.44457
G1 X162.99 Y137.009 E.00655
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.775 I237.588 J1.279 E.0562
G1 X162.94 Y138.879 E.00363
M204 S10000
G1 X163.259 Y139.146 F12000
G1 F6000
M204 S3000
G1 X163.108 Y139.304 E.00694
G1 X162.766 Y139.398 E.01131
G1 X137.176 Y139.394 E.81417
G1 X136.895 Y139.298 E.00946
G1 X136.692 Y139.104 E.00892
G1 X136.602 Y138.76 E.01132
G1 X136.606 Y117.176 E.68672
G1 X136.703 Y116.895 E.00946
G1 X136.896 Y116.693 E.00891
G1 X137.24 Y116.602 E.01133
G1 X161.24 Y116.602 E.76361
G3 X162.826 Y116.609 I.365 J96.763 E.05046
G1 X163.13 Y116.71 E.0102
G1 X163.342 Y116.966 E.01057
G1 X163.397 Y117.291 E.01049
G1 X163.394 Y138.824 E.6851
G1 X163.299 Y139.102 E.00935
M204 S250
G1 X163.558 Y139.429 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.551 Y139.441 E.00041
G1 X163.316 Y139.642 E.00913
G3 X162.789 Y139.79 I-.684 J-1.428 E.01621
G1 X137.283 Y139.786 E.7517
G3 X136.301 Y139.187 I-.029 J-1.058 E.03586
G1 X136.21 Y138.787 E.0121
G1 X136.214 Y117.283 E.63375
G3 X136.813 Y116.301 I1.058 J-.029 E.03585
G1 X137.213 Y116.21 E.01211
G1 X162.455 Y116.21 E.74392
G1 X163.065 Y116.248 E.01804
G1 X163.35 Y116.379 E.00922
G3 X163.711 Y116.82 I-.548 J.819 E.01704
G1 X163.789 Y117.291 E.01409
G1 X163.786 Y138.73 E.63185
G1 X163.712 Y139.178 E.01338
G1 X163.59 Y139.378 E.00692
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.551 Y139.441 E-.0281
G1 X163.316 Y139.642 E-.11766
G1 X163.156 Y139.708 E-.06561
G1 X162.789 Y139.79 E-.14308
G1 X161.721 Y139.79 E-.40555
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.749 Y136.686 Z3.2 F12000
G1 X116.39 Y119.61 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.439 J.191 E.04356
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.199 J-105.199 E.04357
; LINE_WIDTH: 0.43731
G1 X108.979 Y119.603 E.36991
; LINE_WIDTH: 0.43719
G1 X115.021 Y119.603 E.18622
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.721 Y119.255 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.45 E.00667
G1 X116.798 Y136.537 E.54364
G1 X116.72 Y136.74 E.00693
G1 X116.559 Y136.798 E.00542
G1 X95.463 Y136.798 E.67121
G1 X95.251 Y136.712 E.0073
G1 X95.202 Y136.548 E.00546
G1 X95.202 Y119.463 E.54358
G1 X95.28 Y119.26 E.00693
G1 X95.441 Y119.202 E.00542
G1 X116.512 Y119.202 E.67044
G1 X116.662 Y119.24 E.00493
M204 S250
G1 X116.942 Y118.931 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.152 Y119.202 E.01011
G1 X117.189 Y119.45 E.00739
G1 X117.19 Y136.505 E.50264
G1 X117.132 Y136.845 E.01018
G1 X116.98 Y137.045 E.00739
G3 X116.586 Y137.19 I-.532 J-.837 E.01247
G1 X95.495 Y137.19 E.62161
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.548 J-.83 E.01055
G1 X94.81 Y136.583 E.0093
G1 X94.81 Y119.495 E.5036
G1 X94.868 Y119.155 E.01018
G1 X95.02 Y118.955 E.00739
G3 X95.414 Y118.81 I.532 J.837 E.01247
G1 X116.597 Y118.81 E.62431
G1 X116.885 Y118.911 E.00902
; WIPE_START
M204 S3000
G1 X117.152 Y119.202 E-.15001
G1 X117.189 Y119.45 E-.09527
G1 X117.189 Y120.805 E-.51472
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.915 Y125.151 Z3.2 F12000
G1 X96.117 Y135.403 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X108.979 Y119.997 E.36991
; LINE_WIDTH: 0.43719
G1 X115.021 Y119.997 E.18622
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
M73 P60 R7
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00559
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z3.2 F12000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z3.2 F12000
G1 X96.026 Y119.961 Z3.2
G1 Z2.8
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z3.2 F12000
G1 X116.021 Y119.961 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.4214
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00242
G1 X116.021 Y120.043 E.00242
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z3.2 F12000
G1 X116.021 Y135.957 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.2 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 14 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3.2 F4000
            G39.3 S1
            G0 Z3.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer14 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 15/40
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.37459
G1 F6000
M204 S3000
G1 X162.333 Y117.657 E.01216
G1 X161.976 Y117.379 E.01173
G1 X162.621 Y117.379 E.01671
G1 X162.621 Y117.967 E.01525
; WIPE_START
G1 X162.333 Y117.657 E-.16082
G1 X161.976 Y117.379 E-.17187
G1 X162.621 Y117.379 E-.24496
G1 X162.621 Y117.859 E-.18235
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.491 Z3.4 F12000
G1 X162.621 Y137.976 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01674
G1 X161.972 Y138.621 E.01684
G1 X162.343 Y138.333 E.01219
G1 X162.584 Y138.023 E.01019
; WIPE_START
G1 X162.621 Y138.621 E-.22763
G1 X161.972 Y138.621 E-.24663
G1 X162.343 Y138.333 E-.17843
G1 X162.517 Y138.11 E-.10732
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y138.269 Z3.4 F12000
G1 X138.023 Y138.618 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.37395
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.01669
G1 X137.378 Y137.971 E.01675
G1 X137.584 Y138.243 E.00884
G1 X137.978 Y138.579 E.01338
; WIPE_START
G1 X137.378 Y138.618 E-.22824
G1 X137.378 Y137.971 E-.24603
G1 X137.584 Y138.243 E-.12982
G1 X137.896 Y138.51 E-.15591
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.946 Y130.878 Z3.4 F12000
G1 X138.034 Y117.378 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.37399
G1 F6000
M204 S3000
G1 X137.736 Y117.601 E.00963
G1 X137.382 Y118.021 E.01422
G1 X137.382 Y117.378 E.01663
G1 X137.974 Y117.378 E.01533
; WIPE_START
G1 X137.736 Y117.601 E-.12389
G1 X137.382 Y118.021 E-.2088
G1 X137.382 Y117.378 E-.24418
G1 X137.864 Y117.378 E-.18313
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.496 Y117.425 Z3.4 F12000
G1 X161.432 Y117.521 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y117.577 E.00515
G1 X162.061 Y117.907 E.01846
G1 X162.333 Y118.26 E.01419
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01791
; LINE_WIDTH: 0.43693
G1 X162.603 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.603 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.603 Y136.801 E.17262
; LINE_WIDTH: 0.44897
G1 X162.542 Y137.258 E.01465
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.584 E.01103
G1 X162.093 Y138.061 E.01845
G1 X161.74 Y138.334 E.0142
G1 X161.356 Y138.511 E.01346
G1 X160.801 Y138.603 E.0179
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.603 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.603 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.603 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.602 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.602 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.602 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.602 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.602 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.602 E.06143
; LINE_WIDTH: 0.43575
G1 X139.199 Y138.602 E.04917
; LINE_WIDTH: 0.45668
G3 X138.512 Y138.462 I-.059 J-1.468 E.02291
; LINE_WIDTH: 0.44999
G1 X138.201 Y138.296 E.01121
G1 X137.879 Y138.021 E.01348
G1 X137.666 Y137.74 E.0112
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.801 E.0179
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05018
; LINE_WIDTH: 0.44856
G1 X137.455 Y118.746 E.01347
; LINE_WIDTH: 0.44999
G1 X137.567 Y118.439 E.01041
G1 X137.908 Y117.938 E.0193
G1 X138.216 Y117.692 E.01253
G3 X138.949 Y117.411 I1.033 J1.594 E.02515
; LINE_WIDTH: 0.44831
G1 X139.119 Y117.4 E.00541
; LINE_WIDTH: 0.43938
G1 X141.119 Y117.4 E.06198
; LINE_WIDTH: 0.43917
G1 X143.119 Y117.4 E.06194
; LINE_WIDTH: 0.43896
G1 X145.119 Y117.4 E.06191
; LINE_WIDTH: 0.43875
G1 X147.119 Y117.399 E.06188
; LINE_WIDTH: 0.43854
G1 X149.119 Y117.399 E.06184
; LINE_WIDTH: 0.43833
G1 X151.119 Y117.399 E.06181
; LINE_WIDTH: 0.43812
G1 X153.119 Y117.398 E.06178
; LINE_WIDTH: 0.43791
G1 X155.119 Y117.398 E.06175
; LINE_WIDTH: 0.4377
G1 X157.119 Y117.398 E.06171
; LINE_WIDTH: 0.43749
G1 X159.119 Y117.398 E.06168
; LINE_WIDTH: 0.43728
G1 X160.801 Y117.397 E.05184
; LINE_WIDTH: 0.44898
G1 X161.258 Y117.457 E.01464
; LINE_WIDTH: 0.44999
G1 X161.375 Y117.501 E.00398
M204 S10000
G1 X161.324 Y117.926 F12000
G1 F6000
M204 S3000
G1 X161.627 Y118.074 E.01073
G3 X162.113 Y118.731 I-1.117 J1.334 E.02624
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.801 E.56003
G1 X162.142 Y137.187 E.01243
G1 X161.926 Y137.627 E.01561
G3 X161.268 Y138.113 I-1.335 J-1.118 E.02626
G1 X160.801 Y138.202 E.01515
G1 X139.199 Y138.202 E.6873
G1 X138.897 Y138.166 E.00967
G1 X138.393 Y137.937 E.01763
G3 X137.887 Y137.268 I1.039 J-1.312 E.02696
G1 X137.798 Y136.801 E.01515
G1 X137.799 Y119.168 E.56103
G1 X137.854 Y118.822 E.01113
G1 X138.072 Y118.378 E.01575
G3 X138.468 Y118.012 I1.141 J.839 E.01726
G1 X138.956 Y117.825 E.01663
G1 X139.119 Y117.802 E.00523
G1 X160.801 Y117.798 E.68986
G1 X161.186 Y117.858 E.01241
G1 X161.271 Y117.899 E.00299
M204 S250
G1 X161.16 Y118.263 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y118.267 E.00059
G1 X161.484 Y118.462 E.01066
G1 X161.73 Y118.816 E.01271
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.801 E.51875
G1 X161.733 Y137.18 E.0114
G1 X161.538 Y137.484 E.01064
G1 X161.184 Y137.73 E.01272
G1 X160.801 Y137.81 E.01155
G1 X139.199 Y137.81 E.63664
G1 X138.888 Y137.757 E.00929
G1 X138.516 Y137.538 E.01272
G1 X138.27 Y137.184 E.01271
G1 X138.19 Y136.801 E.01155
G1 X138.191 Y119.168 E.51968
G1 X138.261 Y118.837 E.00997
G1 X138.459 Y118.518 E.01106
G1 X138.711 Y118.32 E.00945
G1 X139.119 Y118.194 E.01259
G1 X160.801 Y118.19 E.63902
G1 X161.101 Y118.251 E.00903
; WIPE_START
M204 S3000
G1 X161.179 Y118.267 E-.03036
G1 X161.484 Y118.462 E-.13741
G1 X161.73 Y118.816 E-.16384
G1 X161.81 Y119.199 E-.149
G1 X161.81 Y119.935 E-.2794
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.243 Y127.555 Z3.4 F12000
G1 X162.89 Y138.952 Z3.4
G1 Z3
M73 P61 R7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.722 Y138.991 E.0055
G2 X160.801 Y138.997 I-.67 J90.959 E.06114
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.997 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.997 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.996 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.996 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.996 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.995 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.995 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.995 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.995 E.06143
; LINE_WIDTH: 0.43575
G1 X139.199 Y138.995 E.04917
; LINE_WIDTH: 0.44122
G1 X139.037 Y138.992 E.00506
; LINE_WIDTH: 0.44999
G2 X137.252 Y138.987 I-1.24 J133.866 E.05677
G1 X137.07 Y138.924 E.00615
G1 X137.009 Y138.722 E.00671
G2 X137.003 Y136.801 I-90.912 J-.672 E.06114
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05018
; LINE_WIDTH: 0.44637
G1 X137.011 Y118.946 E.00698
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.224 I-311.413 J-1.241 E.05478
G1 X137.085 Y117.066 E.00555
G1 X137.268 Y117.009 E.00609
G2 X139.119 Y117.004 I.606 J-111.815 E.05888
; LINE_WIDTH: 0.43938
G1 X141.119 Y117.004 E.06198
; LINE_WIDTH: 0.43917
G1 X143.119 Y117.004 E.06194
; LINE_WIDTH: 0.43896
G1 X145.119 Y117.004 E.06191
; LINE_WIDTH: 0.43875
G1 X147.119 Y117.004 E.06188
; LINE_WIDTH: 0.43854
G1 X149.119 Y117.004 E.06184
; LINE_WIDTH: 0.43833
G1 X151.119 Y117.003 E.06181
; LINE_WIDTH: 0.43812
G1 X153.119 Y117.003 E.06178
; LINE_WIDTH: 0.43791
G1 X155.119 Y117.003 E.06175
; LINE_WIDTH: 0.4377
G1 X157.119 Y117.003 E.06171
; LINE_WIDTH: 0.43749
G1 X159.119 Y117.003 E.06168
; LINE_WIDTH: 0.43728
G1 X160.801 Y117.003 E.05184
; LINE_WIDTH: 0.44898
G1 X161.298 Y117.009 E.01578
; LINE_WIDTH: 0.44999
G3 X162.762 Y117.013 I.246 J166.535 E.0466
G1 X162.933 Y117.083 E.00587
G1 X162.99 Y117.264 E.00602
; LINE_WIDTH: 0.45008
G2 X162.997 Y119.199 I89.076 J.663 E.06161
; LINE_WIDTH: 0.43693
G1 X162.997 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.997 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.997 Y136.801 E.17262
; LINE_WIDTH: 0.44897
G1 X162.991 Y137.298 E.01579
; LINE_WIDTH: 0.44999
G3 X162.976 Y138.816 I-41.82 J.337 E.04829
G1 X162.922 Y138.902 E.00322
M204 S10000
G1 X163.281 Y139.142 F12000
G1 F6000
M204 S3000
G1 X163.051 Y139.33 E.00944
G1 X162.754 Y139.398 E.0097
G1 X138.754 Y139.395 E.76361
G3 X137.072 Y139.369 I-.359 J-32.173 E.05352
G1 X136.801 Y139.236 E.00963
G1 X136.671 Y139.057 E.00703
G1 X136.602 Y138.754 E.00988
G1 X136.606 Y117.176 E.68654
G1 X136.702 Y116.895 E.00945
G1 X136.896 Y116.693 E.00891
G1 X137.24 Y116.602 E.01133
G1 X162.455 Y116.603 E.80225
G1 X162.986 Y116.638 E.01695
G1 X163.181 Y116.758 E.00726
G1 X163.365 Y117.028 E.01043
G1 X163.397 Y117.264 E.00755
G1 X163.398 Y137.263 E.63634
G3 X163.378 Y138.879 I-34.673 J.383 E.05142
G1 X163.301 Y139.086 E.007
M204 S250
G1 X163.571 Y139.407 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.346 Y139.623 E.00919
G1 X163.107 Y139.739 E.00781
G1 X162.785 Y139.79 E.00962
G1 X137.252 Y139.786 E.7525
G1 X136.823 Y139.713 E.01283
G3 X136.45 Y139.428 I.843 J-1.495 E.01388
G1 X136.261 Y139.108 E.01096
G1 X136.21 Y138.785 E.00964
G1 X136.214 Y117.283 E.6337
G3 X136.813 Y116.301 I1.058 J-.029 E.03586
G1 X137.213 Y116.21 E.0121
G1 X162.717 Y116.21 E.75166
G1 X163.107 Y116.261 E.01157
G1 X163.347 Y116.378 E.00788
G1 X163.574 Y116.588 E.00912
G1 X163.74 Y116.898 E.01038
G1 X163.789 Y117.263 E.01086
G1 X163.79 Y138.699 E.63175
G1 X163.739 Y139.105 E.01206
G1 X163.609 Y139.362 E.00849
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.346 Y139.623 E-.14097
G1 X163.107 Y139.739 E-.10073
G1 X162.785 Y139.79 E-.12402
G1 X161.747 Y139.79 E-.39428
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.774 Y136.687 Z3.4 F12000
G1 X116.39 Y119.61 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.441 J.191 E.04356
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.199 J-105.199 E.04357
; LINE_WIDTH: 0.43731
G1 X108.979 Y119.603 E.36991
; LINE_WIDTH: 0.43719
G1 X115.021 Y119.603 E.18622
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.73 Y119.262 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.469 E.00694
G1 X116.798 Y136.537 E.54303
G1 X116.713 Y136.749 E.00729
G1 X116.548 Y136.798 E.00546
G1 X95.463 Y136.798 E.67085
G1 X95.251 Y136.712 E.0073
G1 X95.202 Y136.548 E.00544
G1 X95.202 Y119.463 E.54359
G1 X95.288 Y119.25 E.0073
G1 X95.452 Y119.202 E.00545
G1 X116.511 Y119.202 E.67005
G1 X116.672 Y119.246 E.0053
M204 S250
G1 X116.948 Y118.935 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.132 Y119.152 E.0084
G1 X117.189 Y119.469 E.00949
G1 X117.19 Y136.505 E.50208
G1 X117.132 Y136.845 E.01017
G3 X116.886 Y137.102 I-.829 J-.547 E.01054
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.548 J-.831 E.01055
G1 X94.81 Y136.583 E.00929
G1 X94.81 Y119.495 E.50362
G1 X94.868 Y119.155 E.01017
G3 X95.114 Y118.898 I.832 J.549 E.01054
G1 X95.417 Y118.81 E.00931
G1 X115.417 Y118.81 E.58945
G3 X116.678 Y118.831 I.29 J20.75 E.03715
G1 X116.892 Y118.914 E.00676
; WIPE_START
M204 S3000
G1 X117.132 Y119.152 E-.12873
G1 X117.189 Y119.469 E-.12237
G1 X117.189 Y120.809 E-.5089
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.915 Y125.154 Z3.4 F12000
G1 X96.117 Y135.403 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X108.979 Y119.997 E.36991
; LINE_WIDTH: 0.43719
G1 X115.021 Y119.997 E.18622
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00559
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z3.4 F12000
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
M73 P62 R7
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z3.4 F12000
G1 X96.026 Y119.961 Z3.4
G1 Z3
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z3.4 F12000
G1 X116.021 Y119.961 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.42142
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00242
G1 X116.021 Y120.043 E.00242
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z3.4 F12000
G1 X116.021 Y135.957 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.4 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 15 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3.4 F4000
            G39.3 S1
            G0 Z3.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer15 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 16/40
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.62 Y118.027 F12000
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.37453
G1 F6000
M204 S3000
G1 X162.416 Y117.757 E.00878
G1 X161.974 Y117.379 E.01508
G1 X162.621 Y117.379 E.01676
G1 X162.62 Y117.967 E.01524
; WIPE_START
G1 X162.416 Y117.757 E-.11135
G1 X161.974 Y117.379 E-.22112
G1 X162.621 Y117.379 E-.24577
G1 X162.62 Y117.857 E-.18177
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.49 Z3.6 F12000
G1 X162.618 Y137.98 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.0166
G1 X161.971 Y138.622 E.01676
G1 X162.341 Y138.334 E.01213
G1 X162.581 Y138.027 E.01008
; WIPE_START
G1 X162.618 Y138.622 E-.22631
G1 X161.971 Y138.622 E-.24608
G1 X162.341 Y138.334 E-.17817
G1 X162.519 Y138.107 E-.10944
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y138.268 Z3.6 F12000
G1 X138.024 Y138.621 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01684
G1 X137.667 Y138.343 E.01219
G1 X137.977 Y138.584 E.01019
; WIPE_START
G1 X137.379 Y138.621 E-.22768
G1 X137.379 Y137.972 E-.24662
G1 X137.667 Y138.343 E-.17841
G1 X137.89 Y138.517 E-.10729
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.945 Y130.884 Z3.6 F12000
G1 X138.043 Y117.378 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.374
G1 F6000
M204 S3000
G1 X137.715 Y117.618 E.01052
G1 X137.382 Y118.018 E.01346
G1 X137.382 Y117.378 E.01655
G1 X137.983 Y117.378 E.01556
; WIPE_START
G1 X137.715 Y117.618 E-.13676
G1 X137.382 Y118.018 E-.19769
G1 X137.382 Y117.378 E-.24298
G1 X137.862 Y117.378 E-.18257
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.495 Y117.419 Z3.6 F12000
G1 X161.388 Y117.504 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.45816
G1 F6000
M204 S3000
G1 X161.489 Y117.538 E.00346
; LINE_WIDTH: 0.44999
G1 X161.8 Y117.705 E.01123
G1 X162.122 Y117.98 E.01347
G1 X162.334 Y118.26 E.01118
G1 X162.511 Y118.644 E.01345
G1 X162.603 Y119.199 E.01791
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.8 E.04916
; LINE_WIDTH: 0.44856
G1 X162.542 Y137.258 E.01462
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.584 E.01104
G1 X162.092 Y138.062 E.01851
G1 X161.74 Y138.334 E.01415
G1 X161.355 Y138.511 E.01346
G1 X160.801 Y138.603 E.01789
; LINE_WIDTH: 0.43732
G1 X139.2 Y138.603 E.66589
; LINE_WIDTH: 0.44904
G1 X138.742 Y138.543 E.01465
; LINE_WIDTH: 0.44999
G1 X138.416 Y138.423 E.01105
G1 X137.939 Y138.093 E.01845
G1 X137.666 Y137.74 E.0142
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05017
; LINE_WIDTH: 0.44992
G1 X137.476 Y118.675 E.01588
G1 X137.733 Y118.151 E.01856
G3 X138.512 Y117.538 I1.547 J1.165 E.0319
G1 X138.965 Y117.409 E.01497
; LINE_WIDTH: 0.4475
G1 X139.135 Y117.399 E.0054
; LINE_WIDTH: 0.43857
G1 X141.135 Y117.399 E.06185
; LINE_WIDTH: 0.43843
G1 X143.135 Y117.399 E.06183
; LINE_WIDTH: 0.43829
G1 X145.135 Y117.399 E.06181
; LINE_WIDTH: 0.43816
G1 X147.135 Y117.398 E.06178
; LINE_WIDTH: 0.43802
G1 X149.135 Y117.398 E.06176
; LINE_WIDTH: 0.43789
G1 X151.135 Y117.398 E.06174
; LINE_WIDTH: 0.43775
G1 X153.135 Y117.398 E.06172
; LINE_WIDTH: 0.43762
G1 X155.135 Y117.398 E.0617
; LINE_WIDTH: 0.43748
G1 X157.135 Y117.398 E.06168
; LINE_WIDTH: 0.43734
G1 X159.135 Y117.397 E.06166
; LINE_WIDTH: 0.43721
G1 X160.8 Y117.397 E.05132
; LINE_WIDTH: 0.45816
G3 X161.159 Y117.427 I.06 J1.456 E.01171
G1 X161.331 Y117.485 E.00589
M204 S10000
G1 X161.286 Y117.918 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.608 Y118.064 E.01123
G3 X162.113 Y118.731 I-1.038 J1.311 E.02693
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01242
G1 X161.926 Y137.627 E.01563
G3 X161.268 Y138.113 I-1.335 J-1.118 E.02626
G1 X160.801 Y138.202 E.01514
G1 X139.2 Y138.202 E.68728
G1 X138.814 Y138.142 E.01243
G1 X138.373 Y137.926 E.01563
G3 X137.887 Y137.268 I1.118 J-1.335 E.02625
G1 X137.798 Y136.801 E.01515
G1 X137.799 Y119.168 E.56103
G1 X137.874 Y118.762 E.01314
G1 X138.08 Y118.363 E.01427
G1 X138.431 Y118.034 E.0153
G1 X138.63 Y117.927 E.00721
G1 X139.135 Y117.8 E.01656
G1 X160.8 Y117.798 E.68932
G1 X161.102 Y117.834 E.00968
G1 X161.232 Y117.893 E.00452
M204 S250
G1 X161.132 Y118.255 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.462 E.01203
G1 X161.73 Y118.815 E.01269
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.801 E.51874
G1 X161.733 Y137.18 E.0114
G1 X161.538 Y137.484 E.01065
G1 X161.184 Y137.73 E.01272
G1 X160.801 Y137.81 E.01154
G1 X139.2 Y137.81 E.63663
G1 X138.82 Y137.733 E.0114
G1 X138.516 Y137.538 E.01065
G1 X138.27 Y137.184 E.01271
G1 X138.19 Y136.801 E.01155
G1 X138.191 Y119.168 E.51968
G1 X138.28 Y118.787 E.01152
G1 X138.456 Y118.521 E.0094
G1 X138.744 Y118.303 E.01067
G1 X139.135 Y118.193 E.01197
G1 X160.8 Y118.19 E.63852
G1 X161.076 Y118.237 E.00824
; WIPE_START
M204 S3000
G1 X161.484 Y118.462 E-.1771
G1 X161.73 Y118.815 E-.16363
G1 X161.81 Y119.199 E-.14902
G1 X161.81 Y119.911 E-.27026
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.261 Y127.53 Z3.6 F12000
G1 X162.936 Y138.916 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.751 Y138.991 E.00634
G2 X160.801 Y138.997 I-.672 J93.221 E.06207
; LINE_WIDTH: 0.43732
G1 X139.2 Y138.997 E.66589
; LINE_WIDTH: 0.44656
G1 X138.991 Y138.993 E.00659
; LINE_WIDTH: 0.44999
G2 X137.315 Y138.991 I-1.202 J357.043 E.05331
G1 X137.078 Y138.928 E.00781
G1 X137.009 Y138.742 E.00633
G2 X137.003 Y136.801 I-91.667 J-.682 E.06176
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05017
; LINE_WIDTH: 0.44975
G1 X137.012 Y118.913 E.0081
; LINE_WIDTH: 0.44999
G1 X137.013 Y117.224 E.05372
G1 X137.086 Y117.066 E.00555
G1 X137.268 Y117.009 E.00609
G2 X139.135 Y117.003 I.585 J-114.407 E.0594
; LINE_WIDTH: 0.43857
G1 X141.135 Y117.003 E.06185
; LINE_WIDTH: 0.43843
G1 X143.135 Y117.003 E.06183
; LINE_WIDTH: 0.43829
G1 X145.135 Y117.003 E.06181
; LINE_WIDTH: 0.43816
G1 X147.135 Y117.003 E.06178
; LINE_WIDTH: 0.43802
G1 X149.135 Y117.003 E.06176
; LINE_WIDTH: 0.43789
G1 X151.135 Y117.003 E.06174
; LINE_WIDTH: 0.43775
G1 X153.135 Y117.003 E.06172
; LINE_WIDTH: 0.43762
G1 X155.135 Y117.003 E.0617
; LINE_WIDTH: 0.43748
G1 X157.135 Y117.003 E.06168
; LINE_WIDTH: 0.43734
G1 X159.135 Y117.003 E.06166
; LINE_WIDTH: 0.43721
G1 X160.8 Y117.003 E.05132
; LINE_WIDTH: 0.45816
G2 X161.974 Y117.01 I.687 J-18.101 E.03809
; LINE_WIDTH: 0.44999
G1 X162.822 Y117.022 E.027
G1 X162.94 Y117.09 E.00434
G1 X162.99 Y117.291 E.0066
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I86.786 J.663 E.06072
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.801 E.04916
; LINE_WIDTH: 0.44484
G1 X162.99 Y137.009 E.00655
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.742 I244.927 J1.262 E.05515
G1 X162.953 Y138.858 E.00385
M204 S10000
G1 X163.256 Y139.148 F12000
G1 F6000
M204 S3000
G1 X163.113 Y139.3 E.00664
G1 X162.771 Y139.398 E.01131
G1 X138.771 Y139.398 E.76361
G3 X137.19 Y139.387 I-.4 J-55.791 E.05032
G1 X136.905 Y139.299 E.00949
G1 X136.696 Y139.108 E.00899
G1 X136.602 Y138.766 E.01131
G1 X136.606 Y117.176 E.68691
G1 X136.703 Y116.895 E.00946
G1 X136.896 Y116.693 E.00891
G1 X137.24 Y116.602 E.01133
G1 X161.24 Y116.603 E.76361
M73 P63 R7
G3 X162.83 Y116.611 I.366 J82.793 E.05058
G1 X163.126 Y116.707 E.00992
G1 X163.341 Y116.963 E.01064
G1 X163.397 Y117.291 E.01059
G1 X163.394 Y138.824 E.68509
G1 X163.298 Y139.103 E.0094
G1 X163.297 Y139.104 E.00006
M204 S250
G1 X163.557 Y139.431 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.551 Y139.441 E.00036
G1 X163.317 Y139.641 E.00906
G3 X162.79 Y139.79 I-.737 J-1.6 E.0162
G1 X137.315 Y139.79 E.75082
G1 X136.858 Y139.726 E.01359
G1 X136.558 Y139.55 E.01027
G1 X136.358 Y139.316 E.00906
G3 X136.21 Y138.789 I1.423 J-.683 E.01622
G1 X136.214 Y117.283 E.63381
G3 X136.813 Y116.301 I1.058 J-.029 E.03586
G1 X137.213 Y116.21 E.01211
G1 X162.455 Y116.21 E.74392
G1 X163.085 Y116.254 E.01862
G1 X163.348 Y116.378 E.00858
G1 X163.577 Y116.59 E.00919
G1 X163.711 Y116.819 E.00781
G1 X163.789 Y117.291 E.01412
G1 X163.786 Y138.743 E.63221
G1 X163.712 Y139.178 E.01302
G1 X163.589 Y139.38 E.00698
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.551 Y139.441 E-.02743
G1 X163.317 Y139.641 E-.11682
G1 X163.124 Y139.716 E-.07867
G1 X162.79 Y139.79 E-.12995
G1 X161.719 Y139.79 E-.40713
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.746 Y136.686 Z3.6 F12000
G1 X116.39 Y119.61 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.445 J.191 E.04356
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.199 J-105.199 E.04357
; LINE_WIDTH: 0.43731
G1 X108.979 Y119.603 E.36991
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.603 E.18623
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.715 Y119.262 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.416 E.00555
G1 X116.798 Y136.537 E.54473
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.72 E.00693
G1 X95.202 Y136.56 E.00541
G1 X95.202 Y119.464 E.54395
G1 X95.287 Y119.251 E.0073
G1 X95.452 Y119.202 E.00546
G1 X116.511 Y119.202 E.67003
G1 X116.658 Y119.245 E.00487
M204 S250
G1 X116.891 Y118.899 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.06 Y119.038 E.00646
G3 X117.189 Y119.416 I-.886 J.515 E.01186
G1 X117.19 Y136.505 E.50365
G1 X117.132 Y136.845 E.01017
G3 X116.886 Y137.102 I-.83 J-.547 E.01055
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01017
G1 X94.955 Y136.98 E.00739
G3 X94.81 Y136.587 I.838 J-.532 E.01246
G1 X94.81 Y119.495 E.50372
G1 X94.868 Y119.155 E.01018
G3 X95.114 Y118.898 I.829 J.547 E.01053
G1 X95.417 Y118.81 E.00931
G1 X116.511 Y118.81 E.62167
G1 X116.838 Y118.873 E.00982
; WIPE_START
M204 S3000
G1 X117.06 Y119.038 E-.10488
G1 X117.127 Y119.175 E-.058
G1 X117.189 Y119.416 E-.09459
G1 X117.189 Y120.738 E-.50253
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.92 Y125.091 Z3.6 F12000
G1 X96.103 Y135.376 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X108.979 Y119.997 E.36991
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.997 E.18623
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.13 Y135.43 E.01039
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
M73 P63 R6
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00559
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X96.979 Y135.21 E.53177
G1 X96.845 Y135.155 E.00425
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z3.6 F12000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z3.6 F12000
G1 X96.026 Y119.961 Z3.6
G1 Z3.2
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z3.6 F12000
G1 X116.021 Y119.961 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.42142
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00242
G1 X116.021 Y120.043 E.00242
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z3.6 F12000
G1 X116.021 Y135.957 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.6 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 16 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3.6 F4000
            G39.3 S1
            G0 Z3.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer16 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 17/40
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.37455
G1 F6000
M204 S3000
G1 X162.333 Y117.657 E.01215
G1 X161.976 Y117.379 E.01173
G1 X162.621 Y117.379 E.01671
G1 X162.621 Y117.967 E.01525
; WIPE_START
G1 X162.333 Y117.657 E-.1608
G1 X161.976 Y117.379 E-.17191
G1 X162.621 Y117.379 E-.24499
G1 X162.621 Y117.859 E-.18231
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.491 Z3.8 F12000
G1 X162.622 Y137.974 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.37389
G1 F6000
M204 S3000
G1 X162.622 Y138.618 E.01666
G1 X161.975 Y138.618 E.01673
G1 X162.344 Y138.331 E.0121
G1 X162.585 Y138.021 E.01015
; WIPE_START
G1 X162.622 Y138.618 E-.22722
G1 X161.975 Y138.618 E-.24573
G1 X162.344 Y138.331 E-.1777
G1 X162.521 Y138.104 E-.10936
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.89 Y138.265 Z3.8 F12000
G1 X138.024 Y138.621 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01674
G1 X137.379 Y137.972 E.01684
G1 X137.667 Y138.343 E.01218
G1 X137.976 Y138.584 E.01018
; WIPE_START
G1 X137.379 Y138.621 E-.22756
G1 X137.379 Y137.972 E-.24659
M73 P64 R6
G1 X137.667 Y138.343 E-.1784
G1 X137.89 Y138.517 E-.10744
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y130.885 Z3.8 F12000
G1 X138.035 Y117.377 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.37246
G1 F6000
M204 S3000
G1 X137.663 Y117.658 E.01199
G1 X137.381 Y118.025 E.01193
G1 X137.381 Y117.377 E.01668
G1 X137.975 Y117.377 E.0153
; WIPE_START
G1 X137.663 Y117.658 E-.15931
G1 X137.381 Y118.025 E-.17604
G1 X137.381 Y117.377 E-.24612
G1 X137.851 Y117.377 E-.17852
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.483 Y117.424 Z3.8 F12000
G1 X161.433 Y117.522 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y117.577 E.00508
G1 X162.061 Y117.907 E.01847
G1 X162.334 Y118.26 E.01419
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01792
; LINE_WIDTH: 0.43693
G1 X162.603 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.603 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.603 Y136.801 E.17261
; LINE_WIDTH: 0.44897
G1 X162.543 Y137.258 E.01463
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01103
G1 X162.094 Y138.06 E.01843
G1 X161.74 Y138.334 E.01425
G1 X161.356 Y138.511 E.01346
G1 X160.801 Y138.602 E.01789
; LINE_WIDTH: 0.43578
G1 X158.801 Y138.602 E.06141
; LINE_WIDTH: 0.43592
G1 X156.801 Y138.602 E.06143
; LINE_WIDTH: 0.43606
G1 X154.801 Y138.602 E.06146
; LINE_WIDTH: 0.4362
G1 X152.801 Y138.602 E.06148
; LINE_WIDTH: 0.43634
G1 X150.801 Y138.602 E.0615
; LINE_WIDTH: 0.43648
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43663
G1 X146.801 Y138.602 E.06155
; LINE_WIDTH: 0.43677
G1 X144.801 Y138.603 E.06157
; LINE_WIDTH: 0.43691
G1 X142.801 Y138.603 E.06159
; LINE_WIDTH: 0.43705
G1 X140.801 Y138.603 E.06161
; LINE_WIDTH: 0.43717
G1 X139.2 Y138.603 E.04934
; LINE_WIDTH: 0.449
G1 X138.743 Y138.543 E.01463
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01103
G1 X137.939 Y138.093 E.01848
G1 X137.667 Y137.74 E.01419
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05018
; LINE_WIDTH: 0.45047
G1 X137.494 Y118.625 E.01755
G1 X137.649 Y118.283 E.01196
; LINE_WIDTH: 0.44999
G1 X137.926 Y117.916 E.01462
G1 X138.344 Y117.615 E.0164
G1 X138.693 Y117.473 E.01199
; LINE_WIDTH: 0.4495
G1 X139.199 Y117.397 E.01627
; LINE_WIDTH: 0.4373
G1 X149.199 Y117.397 E.30825
; LINE_WIDTH: 0.4372
G1 X160.801 Y117.397 E.35753
; LINE_WIDTH: 0.44897
G1 X161.258 Y117.457 E.01462
; LINE_WIDTH: 0.44999
G1 X161.377 Y117.501 E.00404
M204 S10000
G1 X161.326 Y117.926 F12000
G1 F6000
M204 S3000
G1 X161.627 Y118.075 E.01068
G3 X162.113 Y118.731 I-1.116 J1.333 E.02623
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01563
G3 X161.268 Y138.113 I-1.335 J-1.117 E.02626
G1 X160.801 Y138.202 E.01515
G1 X139.2 Y138.202 E.68728
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.926 E.01562
G3 X137.887 Y137.269 I1.117 J-1.335 E.02627
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.167 E.56103
G1 X137.89 Y118.72 E.01453
G1 X138.156 Y118.273 E.01657
G1 X138.311 Y118.124 E.00683
G1 X138.772 Y117.872 E.01672
G1 X139.199 Y117.798 E.01379
G1 X160.801 Y117.798 E.6873
G1 X161.186 Y117.858 E.0124
G1 X161.272 Y117.9 E.00305
M204 S250
G1 X161.162 Y118.263 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y118.266 E.00053
G1 X161.484 Y118.462 E.01067
G1 X161.73 Y118.815 E.0127
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.801 E.51874
G1 X161.734 Y137.179 E.01139
G1 X161.539 Y137.484 E.01066
G1 X161.184 Y137.73 E.01272
G1 X160.801 Y137.81 E.01155
G1 X139.2 Y137.81 E.63663
G1 X138.821 Y137.734 E.01139
G1 X138.516 Y137.539 E.01065
G1 X138.27 Y137.184 E.01272
G1 X138.19 Y136.801 E.01155
G1 X138.191 Y119.168 E.51969
G1 X138.301 Y118.746 E.01283
G1 X138.526 Y118.451 E.01095
G1 X138.849 Y118.256 E.01112
G1 X139.199 Y118.19 E.01051
G1 X160.801 Y118.19 E.63665
G1 X161.103 Y118.251 E.00908
; WIPE_START
M204 S3000
G1 X161.179 Y118.266 E-.02964
G1 X161.484 Y118.462 E-.1376
G1 X161.73 Y118.815 E-.1637
G1 X161.81 Y119.199 E-.14904
G1 X161.81 Y119.936 E-.28003
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.267 Y127.555 Z3.8 F12000
G1 X162.947 Y138.907 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.78 Y138.987 E.00591
G2 X160.801 Y138.995 I-.673 J83.784 E.06297
; LINE_WIDTH: 0.43578
G1 X158.801 Y138.995 E.06141
; LINE_WIDTH: 0.43592
G1 X156.801 Y138.995 E.06143
; LINE_WIDTH: 0.43606
G1 X154.801 Y138.995 E.06146
; LINE_WIDTH: 0.4362
G1 X152.801 Y138.996 E.06148
; LINE_WIDTH: 0.43634
G1 X150.801 Y138.996 E.0615
; LINE_WIDTH: 0.43648
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43663
G1 X146.801 Y138.996 E.06155
; LINE_WIDTH: 0.43677
G1 X144.801 Y138.996 E.06157
; LINE_WIDTH: 0.43691
G1 X142.801 Y138.997 E.06159
; LINE_WIDTH: 0.43705
G1 X140.801 Y138.997 E.06161
; LINE_WIDTH: 0.43717
G1 X139.2 Y138.997 E.04934
; LINE_WIDTH: 0.449
G1 X138.703 Y138.991 E.01577
; LINE_WIDTH: 0.44999
G3 X137.187 Y138.976 I-.341 J-43.131 E.04822
G1 X137.067 Y138.917 E.00426
G1 X137.009 Y138.722 E.00648
G2 X137.003 Y136.801 I-90.942 J-.672 E.06114
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.167 E.05018
; LINE_WIDTH: 0.4525
G2 X137.013 Y118.08 I-17.446 J-.659 E.03483
; LINE_WIDTH: 0.44999
G1 X137.013 Y117.253 E.0263
G1 X137.071 Y117.081 E.0058
G1 X137.244 Y117.009 E.00595
G1 X138.647 Y117.009 E.04464
; LINE_WIDTH: 0.4495
G1 X139.199 Y117.003 E.01755
; LINE_WIDTH: 0.4373
G1 X149.199 Y117.003 E.30825
; LINE_WIDTH: 0.4372
G1 X160.801 Y117.003 E.35753
; LINE_WIDTH: 0.44635
G1 X161.01 Y117.008 E.00659
; LINE_WIDTH: 0.44999
G2 X162.734 Y117.01 I1.236 J-346.714 E.05485
G1 X162.924 Y117.072 E.00637
G1 X162.99 Y117.291 E.00729
; LINE_WIDTH: 0.45008
G2 X162.997 Y119.199 I87.823 J.649 E.06073
; LINE_WIDTH: 0.43693
G1 X162.997 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.997 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.997 Y136.8 E.17261
; LINE_WIDTH: 0.44622
G1 X162.993 Y137.009 E.00658
; LINE_WIDTH: 0.44999
G2 X162.991 Y138.685 I322.533 J1.188 E.05332
G1 X162.959 Y138.848 E.00527
M204 S10000
G1 X163.246 Y139.176 F12000
G1 F6000
M204 S3000
G1 X163.101 Y139.302 E.0061
G1 X162.826 Y139.394 E.00924
G1 X138.826 Y139.398 E.76361
G3 X137.192 Y139.389 I-.437 J-74.137 E.05201
G1 X136.876 Y139.295 E.01047
G1 X136.685 Y139.067 E.00947
G1 X136.602 Y138.754 E.0103
G1 X136.605 Y118.754 E.63634
G3 X136.626 Y117.091 I27.876 J-.484 E.05293
G1 X136.768 Y116.8 E.01029
G1 X136.939 Y116.67 E.00684
G1 X137.226 Y116.602 E.00938
G1 X161.226 Y116.603 E.76361
G3 X162.83 Y116.61 I.399 J90.404 E.05105
G1 X163.131 Y116.71 E.01009
G1 X163.342 Y116.967 E.01057
G1 X163.397 Y117.291 E.01047
G1 X163.398 Y137.291 E.63634
G3 X163.375 Y138.874 I-29.856 J.369 E.05036
G1 X163.285 Y139.132 E.00872
M204 S250
G1 X163.497 Y139.47 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.413 Y139.575 E.00398
G3 X162.871 Y139.786 I-.62 J-.791 E.01739
G1 X137.301 Y139.79 E.7536
G1 X136.893 Y139.739 E.01213
G1 X136.653 Y139.623 E.00785
G1 X136.426 Y139.413 E.00911
G1 X136.26 Y139.104 E.01034
G1 X136.21 Y138.785 E.00951
G1 X136.214 Y117.253 E.63459
G1 X136.287 Y116.824 E.01283
G1 X136.475 Y116.53 E.0103
G1 X136.754 Y116.319 E.0103
G3 X137.209 Y116.21 I.628 J1.618 E.01382
G1 X162.455 Y116.211 E.74406
G1 X163.065 Y116.248 E.01803
G1 X163.35 Y116.379 E.00923
G3 X163.711 Y116.82 I-.549 J.819 E.01704
G1 X163.789 Y117.291 E.01408
G1 X163.79 Y138.453 E.62368
G1 X163.754 Y138.982 E.01563
G1 X163.658 Y139.271 E.00899
G1 X163.535 Y139.423 E.00577
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.413 Y139.575 E-.07411
G1 X163.162 Y139.719 E-.10984
G1 X162.871 Y139.786 E-.11353
G1 X161.654 Y139.787 E-.46252
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.682 Y136.679 Z3.8 F12000
G1 X116.39 Y119.609 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.446 J.191 E.04356
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.199 J-105.199 E.04357
; LINE_WIDTH: 0.43731
G1 X108.979 Y119.603 E.36991
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.603 E.18623
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.72 Y119.255 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.45 E.00667
G1 X116.798 Y136.537 E.54365
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.719 E.00694
G1 X95.202 Y136.56 E.00541
G1 X95.202 Y119.463 E.54396
G1 X95.279 Y119.262 E.00686
G1 X95.438 Y119.202 E.00542
G1 X116.51 Y119.202 E.67045
G1 X116.662 Y119.24 E.00498
M204 S250
G1 X116.942 Y118.931 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.152 Y119.202 E.01011
G1 X117.189 Y119.45 E.00738
G1 X117.19 Y136.505 E.50265
G1 X117.132 Y136.845 E.01017
M73 P65 R6
G3 X116.886 Y137.102 I-.83 J-.548 E.01055
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01017
G1 X94.955 Y136.98 E.0074
G3 X94.81 Y136.587 I.838 J-.532 E.01245
G1 X94.81 Y119.495 E.50373
G1 X94.868 Y119.155 E.01017
G1 X95.019 Y118.955 E.00738
G3 X95.413 Y118.81 I.546 J.873 E.01245
G1 X115.413 Y118.81 E.58945
G3 X116.676 Y118.831 I.292 J20.898 E.03723
G1 X116.886 Y118.91 E.00661
; WIPE_START
M204 S3000
G1 X117.152 Y119.202 E-.1503
G1 X117.189 Y119.45 E-.09515
G1 X117.189 Y120.804 E-.51455
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.916 Y125.15 Z3.8 F12000
G1 X96.117 Y135.403 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X108.979 Y119.997 E.36991
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.997 E.18623
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00559
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z3.8 F12000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z3.8 F12000
G1 X96.026 Y119.961 Z3.8
G1 Z3.4
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z3.8 F12000
G1 X116.021 Y119.961 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.42144
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00242
G1 X116.021 Y120.043 E.00242
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z3.8 F12000
G1 X116.021 Y135.957 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z3.8 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 17 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z3.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z3.8 F4000
            G39.3 S1
            G0 Z3.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer17 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 18/40
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.62 Y118.027 F12000
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.37455
G1 F6000
M204 S3000
G1 X162.416 Y117.757 E.00879
G1 X161.974 Y117.379 E.01507
G1 X162.621 Y117.379 E.01677
G1 X162.62 Y117.967 E.01525
; WIPE_START
G1 X162.416 Y117.757 E-.11157
G1 X161.974 Y117.379 E-.22094
G1 X162.621 Y117.379 E-.24578
G1 X162.62 Y117.857 E-.18171
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.49 Z4 F12000
G1 X162.619 Y137.978 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.37289
G1 F6000
M204 S3000
G1 X162.619 Y138.619 E.01652
G1 X161.974 Y138.619 E.01663
G1 X162.342 Y138.332 E.01204
G1 X162.582 Y138.026 E.01004
; WIPE_START
G1 X162.619 Y138.619 E-.22586
G1 X161.974 Y138.619 E-.24509
G1 X162.342 Y138.332 E-.17736
G1 X162.523 Y138.101 E-.11169
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.892 Y138.263 Z4 F12000
G1 X138.024 Y138.621 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.37496
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01674
G1 X137.379 Y137.972 E.01684
G1 X137.667 Y138.343 E.01218
G1 X137.977 Y138.584 E.01018
; WIPE_START
G1 X137.379 Y138.621 E-.22759
G1 X137.379 Y137.972 E-.2466
G1 X137.667 Y138.343 E-.17841
G1 X137.89 Y138.517 E-.1074
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.94 Y130.884 Z4 F12000
G1 X138.03 Y117.378 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.37344
G1 F6000
M204 S3000
G1 X137.659 Y117.664 E.01209
G1 X137.381 Y118.025 E.01177
G1 X137.382 Y117.378 E.01672
G1 X137.97 Y117.378 E.0152
; WIPE_START
G1 X137.659 Y117.664 E-.16042
G1 X137.381 Y118.025 E-.17311
G1 X137.382 Y117.378 E-.24588
G1 X137.857 Y117.378 E-.1806
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.489 Y117.419 Z4 F12000
G1 X161.391 Y117.505 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.45811
G1 F6000
M204 S3000
G1 X161.488 Y117.538 E.00334
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.01121
G1 X162.121 Y117.98 E.01348
G1 X162.334 Y118.26 E.01121
G1 X162.511 Y118.645 E.01346
G1 X162.603 Y119.199 E.01789
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.8 E.04916
; LINE_WIDTH: 0.44852
G1 X162.542 Y137.257 E.01461
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01103
G1 X162.093 Y138.061 E.01849
G1 X161.74 Y138.333 E.01418
G1 X161.356 Y138.511 E.01346
M73 P66 R6
G1 X160.801 Y138.602 E.01791
; LINE_WIDTH: 0.43578
G1 X158.801 Y138.602 E.06141
; LINE_WIDTH: 0.43592
G1 X156.801 Y138.602 E.06143
; LINE_WIDTH: 0.43606
G1 X154.801 Y138.602 E.06146
; LINE_WIDTH: 0.4362
G1 X152.801 Y138.602 E.06148
; LINE_WIDTH: 0.43634
G1 X150.801 Y138.602 E.0615
; LINE_WIDTH: 0.43648
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43663
G1 X146.801 Y138.602 E.06155
; LINE_WIDTH: 0.43677
G1 X144.801 Y138.603 E.06157
; LINE_WIDTH: 0.43691
G1 X142.801 Y138.603 E.06159
; LINE_WIDTH: 0.43705
G1 X140.801 Y138.603 E.06161
; LINE_WIDTH: 0.43717
G1 X139.199 Y138.603 E.04935
; LINE_WIDTH: 0.449
G1 X138.743 Y138.543 E.01462
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01103
G1 X137.939 Y138.093 E.01849
G1 X137.667 Y137.74 E.01419
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.167 E.05019
; LINE_WIDTH: 0.44906
G1 X137.461 Y118.724 E.01423
; LINE_WIDTH: 0.44999
G1 X137.581 Y118.41 E.0107
G1 X137.911 Y117.934 E.01841
G1 X138.266 Y117.662 E.01421
G1 X138.606 Y117.499 E.01203
G1 X139.136 Y117.399 E.01714
; LINE_WIDTH: 0.43856
G1 X141.136 Y117.399 E.06185
; LINE_WIDTH: 0.43842
G1 X143.136 Y117.399 E.06183
; LINE_WIDTH: 0.43828
G1 X145.136 Y117.399 E.0618
; LINE_WIDTH: 0.43814
G1 X147.136 Y117.398 E.06178
; LINE_WIDTH: 0.438
G1 X149.136 Y117.398 E.06176
; LINE_WIDTH: 0.43787
G1 X151.136 Y117.398 E.06174
; LINE_WIDTH: 0.43773
G1 X153.136 Y117.398 E.06172
; LINE_WIDTH: 0.43759
G1 X155.136 Y117.398 E.0617
; LINE_WIDTH: 0.43745
G1 X157.136 Y117.398 E.06167
; LINE_WIDTH: 0.43732
G1 X159.136 Y117.397 E.06165
; LINE_WIDTH: 0.43718
G1 X160.8 Y117.397 E.0513
; LINE_WIDTH: 0.45811
G3 X161.159 Y117.427 I.06 J1.456 E.0117
G1 X161.334 Y117.486 E.006
M204 S10000
G1 X161.29 Y117.919 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.0111
G3 X162.113 Y118.732 I-1.04 J1.313 E.02696
G1 X162.202 Y119.199 E.01514
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01563
G3 X161.269 Y138.113 I-1.335 J-1.117 E.02626
G1 X160.801 Y138.202 E.01516
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.926 E.01562
G3 X137.887 Y137.268 I1.117 J-1.335 E.02627
G1 X137.798 Y136.801 E.01515
G1 X137.799 Y119.167 E.56104
G1 X137.86 Y118.803 E.01176
G1 X138.086 Y118.359 E.01586
G3 X138.509 Y117.989 I1.144 J.881 E.01799
G1 X138.989 Y117.819 E.0162
G1 X139.136 Y117.8 E.0047
G1 X160.8 Y117.798 E.68931
G1 X161.102 Y117.834 E.00967
G1 X161.235 Y117.894 E.00463
M204 S250
G1 X161.135 Y118.257 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.462 E.01191
G1 X161.73 Y118.816 E.01272
G1 X161.81 Y119.199 E.01154
G1 X161.81 Y136.801 E.51874
G1 X161.734 Y137.179 E.01138
G1 X161.539 Y137.484 E.01066
G1 X161.185 Y137.73 E.01271
G1 X160.801 Y137.81 E.01156
G1 X139.199 Y137.81 E.63664
G1 X138.821 Y137.734 E.01138
G1 X138.516 Y137.539 E.01066
G1 X138.27 Y137.184 E.01272
G1 X138.19 Y136.801 E.01155
G1 X138.191 Y119.167 E.51969
G1 X138.267 Y118.819 E.0105
G1 X138.472 Y118.505 E.01105
G1 X138.808 Y118.272 E.01207
G1 X139.136 Y118.193 E.00993
G1 X160.8 Y118.19 E.63851
G1 X161.08 Y118.238 E.00835
; WIPE_START
M204 S3000
G1 X161.484 Y118.462 E-.17566
G1 X161.73 Y118.816 E-.16397
G1 X161.81 Y119.199 E-.14884
G1 X161.81 Y119.914 E-.27154
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.256 Y127.533 Z4 F12000
G1 X162.924 Y138.924 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.766 Y138.987 E.00542
G2 X160.801 Y138.995 I-.666 J83.258 E.06252
; LINE_WIDTH: 0.43578
G1 X158.801 Y138.995 E.06141
; LINE_WIDTH: 0.43592
G1 X156.801 Y138.995 E.06143
; LINE_WIDTH: 0.43606
G1 X154.801 Y138.995 E.06146
; LINE_WIDTH: 0.4362
G1 X152.801 Y138.996 E.06148
; LINE_WIDTH: 0.43634
G1 X150.801 Y138.996 E.0615
; LINE_WIDTH: 0.43648
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43663
G1 X146.801 Y138.996 E.06155
; LINE_WIDTH: 0.43677
G1 X144.801 Y138.996 E.06157
; LINE_WIDTH: 0.43691
G1 X142.801 Y138.997 E.06159
; LINE_WIDTH: 0.43705
G1 X140.801 Y138.997 E.06161
; LINE_WIDTH: 0.43717
G1 X139.199 Y138.997 E.04934
; LINE_WIDTH: 0.44643
G1 X138.991 Y138.992 E.00659
; LINE_WIDTH: 0.44999
G2 X137.288 Y138.991 I-1.165 J346.986 E.05417
G1 X137.075 Y138.924 E.00712
G1 X137.009 Y138.732 E.00646
G2 X137.003 Y136.801 I-91.414 J-.676 E.06145
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.167 E.05019
; LINE_WIDTH: 0.44738
G1 X137.011 Y118.936 E.00733
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.284 I-430.634 J-1.243 E.05256
G1 X137.074 Y117.071 E.00705
G1 X137.268 Y117.009 E.00647
G2 X139.136 Y117.003 I.636 J-97.68 E.05941
; LINE_WIDTH: 0.43856
G1 X141.136 Y117.003 E.06185
; LINE_WIDTH: 0.43842
G1 X143.136 Y117.003 E.06183
; LINE_WIDTH: 0.43828
G1 X145.136 Y117.003 E.0618
; LINE_WIDTH: 0.43814
G1 X147.136 Y117.003 E.06178
; LINE_WIDTH: 0.438
G1 X149.136 Y117.003 E.06176
; LINE_WIDTH: 0.43787
G1 X151.136 Y117.003 E.06174
; LINE_WIDTH: 0.43773
G1 X153.136 Y117.003 E.06172
; LINE_WIDTH: 0.43759
G1 X155.136 Y117.003 E.0617
; LINE_WIDTH: 0.43745
G1 X157.136 Y117.003 E.06167
; LINE_WIDTH: 0.43732
G1 X159.136 Y117.003 E.06165
; LINE_WIDTH: 0.43718
G1 X160.8 Y117.003 E.0513
; LINE_WIDTH: 0.44266
G1 X160.963 Y117.006 E.00508
; LINE_WIDTH: 0.44999
G2 X162.754 Y117.01 I1.227 J-160.578 E.05698
G1 X162.933 Y117.083 E.00617
G1 X162.99 Y117.264 E.00604
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I87.761 J.678 E.0616
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.801 E.04916
; LINE_WIDTH: 0.44457
G1 X162.99 Y137.009 E.00655
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.733 I231.642 J1.256 E.05486
G1 X162.943 Y138.867 E.00449
M204 S10000
G1 X163.249 Y139.154 F12000
G1 F6000
M204 S3000
G1 X163.046 Y139.335 E.00864
G1 X162.818 Y139.394 E.00752
G1 X138.818 Y139.398 E.76361
G3 X137.101 Y139.371 I-.426 J-27.781 E.05465
G1 X136.834 Y139.264 E.00913
G1 X136.671 Y139.046 E.00866
G1 X136.602 Y138.76 E.00937
G1 X136.606 Y117.283 E.68332
G1 X136.667 Y116.948 E.01085
G1 X136.89 Y116.695 E.01074
G1 X137.24 Y116.602 E.01152
G1 X161.24 Y116.603 E.76361
G3 X162.952 Y116.628 I.366 J33.394 E.05447
G1 X163.192 Y116.768 E.00884
G1 X163.365 Y117.028 E.00996
G1 X163.397 Y117.264 E.00756
G1 X163.394 Y137.264 E.63634
G3 X163.373 Y138.9 I-33.441 J.377 E.05206
G1 X163.285 Y139.108 E.00719
M204 S250
G1 X163.522 Y139.463 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.498 Y139.498 E.00127
G1 X163.213 Y139.696 E.01022
G1 X162.868 Y139.786 E.01051
G1 X137.315 Y139.79 E.75311
G1 X136.856 Y139.726 E.01365
G1 X136.589 Y139.576 E.00905
G1 X136.379 Y139.349 E.00911
G1 X136.249 Y139.067 E.00915
G1 X136.21 Y138.787 E.00832
G1 X136.214 Y117.267 E.63424
G1 X136.304 Y116.785 E.01445
G1 X136.476 Y116.528 E.00911
G1 X136.809 Y116.302 E.01187
G1 X137.213 Y116.21 E.01221
G1 X162.455 Y116.211 E.74392
G1 X163.065 Y116.248 E.01803
G1 X163.349 Y116.379 E.0092
G1 X163.574 Y116.587 E.00906
G1 X163.74 Y116.898 E.01039
G1 X163.789 Y117.264 E.01087
G1 X163.786 Y138.733 E.63274
G1 X163.696 Y139.213 E.01439
G1 X163.557 Y139.414 E.0072
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.498 Y139.498 E-.03916
G1 X163.213 Y139.696 E-.13178
G1 X162.868 Y139.786 E-.13548
G1 X161.675 Y139.787 E-.45358
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.703 Y136.68 Z4 F12000
G1 X116.39 Y119.609 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.45 J.191 E.04356
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.778 E.04357
; LINE_WIDTH: 0.43731
G1 X110.979 Y119.603 E.43156
; LINE_WIDTH: 0.43719
G1 X115.021 Y119.603 E.12459
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.737 Y119.271 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.47 E.0066
G1 X116.798 Y136.537 E.54302
G1 X116.712 Y136.75 E.0073
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.72 E.00693
G1 X95.202 Y136.56 E.00541
G1 X95.202 Y119.463 E.54395
G1 X95.281 Y119.26 E.00694
G1 X95.441 Y119.202 E.00542
G1 X116.529 Y119.202 E.67096
G1 X116.68 Y119.252 E.00506
M204 S250
G1 X117.004 Y118.978 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.016 Y118.987 E.00044
G3 X117.132 Y119.153 I-.415 J.413 E.00601
G1 X117.189 Y119.47 E.00948
G1 X117.19 Y136.505 E.50207
G1 X117.132 Y136.845 E.01017
G3 X116.886 Y137.102 I-.831 J-.549 E.01054
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.62149
G1 X95.155 Y137.132 E.01018
G1 X94.955 Y136.98 E.00738
G3 X94.81 Y136.587 I.838 J-.532 E.01246
G1 X94.81 Y119.495 E.50373
G1 X94.868 Y119.155 E.01018
G1 X95.02 Y118.955 E.0074
G3 X95.414 Y118.81 I.531 J.837 E.01246
G1 X116.529 Y118.81 E.62231
G1 X116.824 Y118.858 E.00881
G1 X116.954 Y118.945 E.00461
; WIPE_START
M204 S3000
G1 X117.016 Y118.987 E-.0285
G1 X117.132 Y119.153 E-.0771
G1 X117.189 Y119.47 E-.12228
G1 X117.189 Y120.87 E-.53213
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.906 Y125.203 Z4 F12000
G1 X96.117 Y135.403 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X110.979 Y119.997 E.43156
; LINE_WIDTH: 0.43719
G1 X115.021 Y119.997 E.12459
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
M73 P67 R6
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z4 F12000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z4 F12000
G1 X96.026 Y119.961 Z4
G1 Z3.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z4 F12000
G1 X116.021 Y119.961 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.42144
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00242
G1 X116.021 Y120.043 E.00242
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z4 F12000
G1 X116.021 Y135.957 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 18 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4 F4000
            G39.3 S1
            G0 Z4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer18 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 19/40
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.62 Y118.027 F12000
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.37453
G1 F6000
M204 S3000
G1 X162.333 Y117.657 E.01215
G1 X161.976 Y117.379 E.01172
G1 X162.621 Y117.379 E.01671
G1 X162.62 Y117.967 E.01524
; WIPE_START
G1 X162.333 Y117.657 E-.16073
G1 X161.976 Y117.379 E-.17186
G1 X162.621 Y117.379 E-.24495
G1 X162.62 Y117.859 E-.18246
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.492 Z4.2 F12000
G1 X162.618 Y137.98 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.0166
G1 X161.971 Y138.622 E.01675
G1 X162.341 Y138.334 E.01213
G1 X162.581 Y138.027 E.01009
; WIPE_START
G1 X162.618 Y138.622 E-.22633
G1 X161.971 Y138.622 E-.246
G1 X162.341 Y138.334 E-.1781
G1 X162.519 Y138.107 E-.10957
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y138.267 Z4.2 F12000
G1 X138.024 Y138.621 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01684
G1 X137.667 Y138.343 E.01218
G1 X137.977 Y138.584 E.01019
; WIPE_START
G1 X137.379 Y138.621 E-.22771
G1 X137.379 Y137.972 E-.24658
G1 X137.667 Y138.343 E-.17838
G1 X137.89 Y138.517 E-.10734
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y130.884 Z4.2 F12000
G1 X138.034 Y117.378 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.736 Y117.601 E.00965
G1 X137.382 Y118.021 E.01421
G1 X137.382 Y117.378 E.01663
G1 X137.975 Y117.378 E.01534
; WIPE_START
G1 X137.736 Y117.601 E-.12411
G1 X137.382 Y118.021 E-.2087
G1 X137.382 Y117.378 E-.24423
G1 X137.863 Y117.378 E-.18296
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.496 Y117.425 Z4.2 F12000
G1 X161.435 Y117.523 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y117.577 E.00502
G1 X162.061 Y117.907 E.01847
G1 X162.334 Y118.26 E.01419
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01791
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.8 E.04915
; LINE_WIDTH: 0.44855
G1 X162.542 Y137.257 E.01461
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01104
G1 X162.092 Y138.062 E.01853
G1 X161.741 Y138.333 E.01411
G1 X161.357 Y138.51 E.01345
G1 X160.801 Y138.603 E.01794
; LINE_WIDTH: 0.43732
G1 X139.2 Y138.603 E.66589
; LINE_WIDTH: 0.44903
G1 X138.743 Y138.543 E.01463
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01104
G1 X137.939 Y138.093 E.01848
G1 X137.667 Y137.74 E.01418
G1 X137.489 Y137.356 E.01346
G1 X137.408 Y136.971 E.01254
; LINE_WIDTH: 0.44608
G1 X137.397 Y136.801 E.00537
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05018
; LINE_WIDTH: 0.44841
G1 X137.453 Y118.753 E.01326
; LINE_WIDTH: 0.44999
G1 X137.565 Y118.446 E.0104
G1 X137.908 Y117.938 E.01951
G3 X138.953 Y117.41 I1.445 J1.562 E.03771
; LINE_WIDTH: 0.4481
G1 X139.123 Y117.4 E.0054
; LINE_WIDTH: 0.43915
G1 X141.123 Y117.4 E.06194
; LINE_WIDTH: 0.43895
G1 X143.123 Y117.4 E.06191
; LINE_WIDTH: 0.43876
G1 X145.123 Y117.399 E.06188
; LINE_WIDTH: 0.43857
G1 X147.123 Y117.399 E.06185
; LINE_WIDTH: 0.43837
G1 X149.123 Y117.399 E.06182
; LINE_WIDTH: 0.43818
G1 X151.123 Y117.399 E.06179
; LINE_WIDTH: 0.43799
G1 X153.123 Y117.398 E.06176
; LINE_WIDTH: 0.4378
G1 X155.123 Y117.398 E.06173
; LINE_WIDTH: 0.4376
G1 X157.123 Y117.398 E.0617
; LINE_WIDTH: 0.43741
G1 X159.123 Y117.398 E.06167
; LINE_WIDTH: 0.43722
G1 X160.801 Y117.397 E.05171
; LINE_WIDTH: 0.44897
G1 X161.258 Y117.457 E.01463
; LINE_WIDTH: 0.44999
G1 X161.379 Y117.502 E.0041
M204 S10000
G1 X161.328 Y117.927 F12000
G1 F6000
M204 S3000
G1 X161.627 Y118.075 E.01061
G3 X162.113 Y118.731 I-1.116 J1.333 E.02624
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01564
G3 X161.269 Y138.113 I-1.333 J-1.115 E.02623
G1 X160.801 Y138.202 E.01518
G1 X139.2 Y138.202 E.68728
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.926 E.01564
G3 X137.887 Y137.269 I1.116 J-1.334 E.02624
G1 X137.807 Y136.901 E.01198
G1 X137.799 Y119.168 E.56422
G1 X137.852 Y118.828 E.01095
G1 X138.071 Y118.379 E.01588
G3 X138.467 Y118.012 I1.138 J.832 E.01729
G1 X138.962 Y117.825 E.01681
G1 X139.123 Y117.802 E.00519
G1 X160.801 Y117.798 E.68973
G1 X161.186 Y117.858 E.0124
G1 X161.274 Y117.901 E.00312
M204 S250
G1 X161.163 Y118.263 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y118.267 E.00048
G1 X161.484 Y118.462 E.01067
G1 X161.73 Y118.816 E.0127
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.8 E.51874
G1 X161.734 Y137.179 E.01139
G1 X161.538 Y137.484 E.01066
G1 X161.185 Y137.73 E.01269
G1 X160.801 Y137.81 E.01157
G1 X139.2 Y137.81 E.63663
G1 X138.821 Y137.734 E.01139
G1 X138.516 Y137.538 E.01066
G1 X138.27 Y137.185 E.01271
G1 X138.193 Y136.833 E.0106
G1 X138.191 Y119.168 E.52064
G1 X138.259 Y118.841 E.00983
G1 X138.459 Y118.518 E.01119
G1 X138.774 Y118.287 E.01153
G1 X139.123 Y118.194 E.01064
G1 X160.801 Y118.19 E.63889
G1 X161.105 Y118.251 E.00913
; WIPE_START
M204 S3000
G1 X161.179 Y118.267 E-.02896
G1 X161.484 Y118.462 E-.13754
G1 X161.73 Y118.816 E-.16375
G1 X161.81 Y119.199 E-.14901
G1 X161.81 Y119.938 E-.28074
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.26 Y127.557 Z4.2 F12000
G1 X162.932 Y138.922 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.742 Y138.991 E.00646
G2 X160.801 Y138.997 I-.666 J93.125 E.06176
; LINE_WIDTH: 0.43732
G1 X139.2 Y138.997 E.66589
; LINE_WIDTH: 0.44655
G1 X138.991 Y138.993 E.00659
; LINE_WIDTH: 0.44999
G2 X137.288 Y138.991 I-1.212 J358.776 E.05418
G1 X137.075 Y138.925 E.00709
G1 X137.009 Y138.712 E.00708
G2 X137.003 Y136.801 I-90.378 J-.667 E.06083
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05018
; LINE_WIDTH: 0.44609
G1 X137.011 Y118.949 E.00688
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.234 I-283.358 J-1.228 E.05456
G1 X137.09 Y117.062 E.00602
G1 X137.268 Y117.009 E.0059
G2 X139.123 Y117.004 I.607 J-110.319 E.05901
; LINE_WIDTH: 0.43915
G1 X141.123 Y117.004 E.06194
; LINE_WIDTH: 0.43895
G1 X143.123 Y117.004 E.06191
; LINE_WIDTH: 0.43876
G1 X145.123 Y117.004 E.06188
; LINE_WIDTH: 0.43857
G1 X147.123 Y117.004 E.06185
; LINE_WIDTH: 0.43837
G1 X149.123 Y117.004 E.06182
; LINE_WIDTH: 0.43818
G1 X151.123 Y117.003 E.06179
; LINE_WIDTH: 0.43799
G1 X153.123 Y117.003 E.06176
; LINE_WIDTH: 0.4378
G1 X155.123 Y117.003 E.06173
; LINE_WIDTH: 0.4376
G1 X157.123 Y117.003 E.0617
; LINE_WIDTH: 0.43741
M73 P68 R6
G1 X159.123 Y117.003 E.06167
; LINE_WIDTH: 0.43722
G1 X160.801 Y117.003 E.05171
; LINE_WIDTH: 0.44633
G1 X161.01 Y117.008 E.0066
; LINE_WIDTH: 0.44999
G2 X162.694 Y117.01 I1.213 J-333.823 E.05359
G1 X162.892 Y117.05 E.00642
G1 X162.99 Y117.216 E.00614
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I90.2 J.701 E.06311
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.8 E.04915
; LINE_WIDTH: 0.44483
G1 X162.99 Y137.009 E.00655
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.73 I242.384 J1.253 E.05475
G1 X162.949 Y138.864 E.00445
M204 S10000
G1 X163.226 Y139.173 F12000
G1 F6000
M204 S3000
G1 X163.112 Y139.302 E.00548
G1 X162.765 Y139.398 E.01143
G1 X138.766 Y139.398 E.76361
G3 X137.086 Y139.368 I-.396 J-25.193 E.05345
G1 X136.857 Y139.282 E.00779
G1 X136.685 Y139.081 E.00841
G1 X136.602 Y138.748 E.01091
G1 X136.606 Y117.283 E.68295
G1 X136.668 Y116.942 E.01104
G1 X136.896 Y116.692 E.01075
G1 X137.24 Y116.602 E.01133
G1 X162.768 Y116.603 E.81221
G1 X163.105 Y116.703 E.01119
G1 X163.324 Y116.929 E.01
G1 X163.397 Y117.216 E.00945
G1 X163.394 Y138.73 E.6845
G1 X163.333 Y139.054 E.01051
G1 X163.266 Y139.129 E.00317
M204 S250
G1 X163.526 Y139.44 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.423 Y139.541 E.00425
G3 X163.155 Y139.709 I-.756 J-.91 E.00933
G1 X162.789 Y139.79 E.01107
G1 X137.315 Y139.79 E.75076
G1 X136.855 Y139.725 E.01371
G1 X136.621 Y139.6 E.00781
G1 X136.399 Y139.379 E.00923
G1 X136.275 Y139.146 E.0078
G1 X136.21 Y138.783 E.01085
G1 X136.214 Y117.283 E.63364
G3 X136.378 Y116.668 I1.274 J.011 E.01898
G1 X136.545 Y116.477 E.00747
G1 X136.813 Y116.301 E.00945
G1 X137.213 Y116.21 E.0121
G1 X162.694 Y116.211 E.75099
G1 X163.18 Y116.289 E.01451
G1 X163.439 Y116.448 E.00895
G1 X163.67 Y116.733 E.01082
G3 X163.789 Y117.216 I-1.452 J.614 E.01472
G1 X163.786 Y138.868 E.63813
G1 X163.696 Y139.216 E.01059
G3 X163.611 Y139.345 I-1.028 J-.585 E.00455
G1 X163.566 Y139.395 E.002
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.423 Y139.541 E-.0776
G1 X163.155 Y139.709 E-.12
G1 X162.789 Y139.79 E-.14274
G1 X161.684 Y139.79 E-.41968
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.712 Y136.684 Z4.2 F12000
G1 X116.39 Y119.609 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.45 J.191 E.04356
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-104.471 J-.212 E.04357
; LINE_WIDTH: 0.43721
G1 X95.603 Y133.021 E.06164
; LINE_WIDTH: 0.43706
G1 X95.603 Y131.021 E.06161
; LINE_WIDTH: 0.43692
G1 X95.604 Y129.021 E.06159
; LINE_WIDTH: 0.43678
G1 X95.604 Y127.021 E.06157
; LINE_WIDTH: 0.43664
G1 X95.604 Y125.021 E.06155
; LINE_WIDTH: 0.4365
G1 X95.604 Y123.021 E.06153
; LINE_WIDTH: 0.43636
G1 X95.604 Y121.021 E.0615
; LINE_WIDTH: 0.43622
G1 X95.604 Y120.978 E.00132
; LINE_WIDTH: 0.44999
G1 X95.612 Y119.609 E.04356
G2 X96.979 Y119.603 I.196 J-105.416 E.0435
; LINE_WIDTH: 0.43731
G1 X110.979 Y119.603 E.43156
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.603 E.12459
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.727 Y119.265 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.451 E.00632
G1 X116.798 Y136.537 E.54362
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.25 Y136.712 E.0073
G1 X95.202 Y136.548 E.00544
G1 X95.204 Y119.414 E.54518
G1 X95.279 Y119.262 E.00536
G1 X95.438 Y119.202 E.00542
G1 X116.528 Y119.202 E.67103
G1 X116.67 Y119.247 E.00472
M204 S250
G1 X117.001 Y118.977 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.013 Y118.984 E.00042
G1 X117.152 Y119.202 E.00761
G1 X117.189 Y119.451 E.00741
G1 X117.19 Y136.505 E.50262
G1 X117.132 Y136.845 E.01018
G3 X116.886 Y137.102 I-.83 J-.547 E.01054
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.62149
G1 X95.155 Y137.132 E.01018
G3 X94.898 Y136.886 I.548 J-.831 E.01054
G1 X94.81 Y136.583 E.00929
G1 X94.812 Y119.453 E.50485
G1 X94.866 Y119.158 E.00884
G1 X95.019 Y118.956 E.00749
G3 X95.413 Y118.81 I.565 J.923 E.01245
G1 X116.528 Y118.81 E.62232
G1 X116.823 Y118.858 E.0088
G1 X116.951 Y118.943 E.00454
; WIPE_START
M204 S3000
G1 X117.013 Y118.984 E-.02818
G1 X117.152 Y119.202 E-.09818
G1 X117.189 Y119.451 E-.09551
G1 X117.189 Y120.867 E-.53814
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.902 Y125.193 Z4.2 F12000
G1 X96.103 Y135.376 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44614
G1 X95.997 Y135.021 E.00537
; LINE_WIDTH: 0.43721
G1 X95.997 Y133.021 E.06164
; LINE_WIDTH: 0.43706
G1 X95.997 Y131.021 E.06161
; LINE_WIDTH: 0.43692
G1 X95.997 Y129.021 E.06159
; LINE_WIDTH: 0.43678
G1 X95.998 Y127.021 E.06157
; LINE_WIDTH: 0.43664
G1 X95.998 Y125.021 E.06155
; LINE_WIDTH: 0.4365
G1 X95.998 Y123.021 E.06153
; LINE_WIDTH: 0.43636
G1 X95.998 Y121.021 E.0615
; LINE_WIDTH: 0.43622
G1 X95.998 Y120.979 E.00132
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.024
G1 X96.808 Y120.008 E.01887
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X110.979 Y119.997 E.43156
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.997 E.12459
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02397
G1 X96.13 Y135.429 E.0104
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.978 E.44681
G1 X96.568 Y120.568 E.01416
G1 X96.878 Y120.407 E.0111
G1 X115.021 Y120.398 E.57727
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
M73 P68 R5
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.946 Y120.793 E.00334
G1 X114.979 Y120.79 E.53146
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.355 Y125.458 Z4.2 F12000
G1 X96.027 Y119.961 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00241
G1 X96.027 Y120.042 E.00241
G1 X96.051 Y120.002 E.00139
; WIPE_START
G1 X96.027 Y120.042 E-.17027
G1 X95.957 Y120.002 E-.29487
G1 X96.027 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y127.593 Z4.2 F12000
G1 X96.026 Y135.957 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17026
G1 X95.955 Y135.998 E-.29487
G1 X96.026 Y135.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y135.957 Z4.2 F12000
G1 X116.021 Y135.957 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y128.324 Z4.2 F12000
G1 X116.021 Y119.961 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.42144
M73 P69 R5
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00242
G1 X116.021 Y120.043 E.00242
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.2 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 19 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4.2 F4000
            G39.3 S1
            G0 Z4.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer19 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 20/40
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.62 Y118.027 F12000
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.37453
G1 F6000
M204 S3000
G1 X162.416 Y117.756 E.0088
G1 X161.974 Y117.379 E.01506
G1 X162.621 Y117.379 E.01676
G1 X162.62 Y117.967 E.01524
; WIPE_START
G1 X162.416 Y117.756 E-.11168
G1 X161.974 Y117.379 E-.22079
G1 X162.621 Y117.379 E-.24577
G1 X162.62 Y117.857 E-.18177
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.49 Z4.4 F12000
G1 X162.618 Y137.977 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.01669
G1 X161.971 Y138.622 E.01675
G1 X162.243 Y138.416 E.00883
G1 X162.579 Y138.022 E.01339
; WIPE_START
G1 X162.618 Y138.622 E-.22825
G1 X161.971 Y138.622 E-.24606
G1 X162.243 Y138.416 E-.12971
G1 X162.51 Y138.104 E-.15598
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.879 Y138.264 Z4.4 F12000
G1 X138.023 Y138.618 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.01669
G1 X137.378 Y137.971 E.01675
G1 X137.585 Y138.244 E.00886
G1 X137.978 Y138.579 E.01336
; WIPE_START
G1 X137.378 Y138.618 E-.22825
G1 X137.378 Y137.971 E-.24598
G1 X137.585 Y138.244 E-.13011
G1 X137.896 Y138.51 E-.15566
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.947 Y130.878 Z4.4 F12000
G1 X138.037 Y117.378 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.37399
G1 F6000
M204 S3000
G1 X137.729 Y117.606 E.00994
G1 X137.382 Y118.021 E.01399
G1 X137.382 Y117.378 E.01663
G1 X137.978 Y117.378 E.01541
; WIPE_START
G1 X137.729 Y117.606 E-.12831
G1 X137.382 Y118.021 E-.2054
G1 X137.382 Y117.378 E-.24423
G1 X137.861 Y117.378 E-.18206
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.493 Y117.42 Z4.4 F12000
G1 X161.394 Y117.506 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.45808
G1 F6000
M204 S3000
G1 X161.488 Y117.538 E.00323
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.01121
G1 X162.121 Y117.979 E.01348
G1 X162.334 Y118.26 E.01121
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.0179
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.8 E.04916
; LINE_WIDTH: 0.46001
G1 X162.568 Y137.194 E.01289
G1 X162.295 Y137.799 E.02164
; LINE_WIDTH: 0.44999
G1 X162.02 Y138.121 E.01348
G1 X161.739 Y138.334 E.0112
G1 X161.355 Y138.511 E.01346
G1 X160.801 Y138.603 E.01789
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.603 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.603 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.603 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.602 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.602 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.602 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.602 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.602 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.602 E.06143
; LINE_WIDTH: 0.43575
G1 X139.2 Y138.602 E.04916
; LINE_WIDTH: 0.45667
G3 X138.512 Y138.462 I-.059 J-1.469 E.02292
; LINE_WIDTH: 0.44999
G1 X138.201 Y138.296 E.0112
G1 X137.879 Y138.021 E.01348
G1 X137.667 Y137.74 E.01121
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05017
; LINE_WIDTH: 0.44835
G1 X137.452 Y118.755 E.0132
; LINE_WIDTH: 0.44999
G3 X137.717 Y118.178 I1.823 J.487 E.02028
G3 X138.536 Y117.527 I1.582 J1.148 E.03371
G1 X138.954 Y117.41 E.0138
; LINE_WIDTH: 0.44805
G1 X139.124 Y117.4 E.0054
; LINE_WIDTH: 0.43911
G1 X141.124 Y117.4 E.06193
; LINE_WIDTH: 0.43891
G1 X143.124 Y117.399 E.0619
; LINE_WIDTH: 0.43872
G1 X145.124 Y117.399 E.06187
; LINE_WIDTH: 0.43853
G1 X147.124 Y117.399 E.06184
; LINE_WIDTH: 0.43834
G1 X149.124 Y117.399 E.06181
; LINE_WIDTH: 0.43815
G1 X151.124 Y117.399 E.06178
; LINE_WIDTH: 0.43796
G1 X153.124 Y117.398 E.06175
; LINE_WIDTH: 0.43777
G1 X155.124 Y117.398 E.06172
; LINE_WIDTH: 0.43758
G1 X157.124 Y117.398 E.06169
; LINE_WIDTH: 0.43739
G1 X159.124 Y117.398 E.06166
; LINE_WIDTH: 0.4372
G1 X160.8 Y117.397 E.05166
; LINE_WIDTH: 0.45808
G3 X161.159 Y117.427 I.06 J1.457 E.0117
G1 X161.337 Y117.487 E.00611
M204 S10000
G1 X161.293 Y117.921 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01099
G3 X162.113 Y118.732 I-1.039 J1.313 E.02696
G1 X162.202 Y119.199 E.01515
G1 X162.202 Y136.801 E.56002
G1 X162.163 Y137.123 E.01034
G1 X161.936 Y137.607 E.01701
G3 X161.268 Y138.113 I-1.312 J-1.039 E.02696
G1 X160.801 Y138.202 E.01514
G1 X139.199 Y138.202 E.68729
G1 X138.897 Y138.166 E.00968
G1 X138.393 Y137.937 E.01762
G3 X137.887 Y137.269 I1.039 J-1.313 E.02697
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.168 E.56103
G1 X137.852 Y118.829 E.0109
G1 X138.071 Y118.379 E.01592
G1 X138.213 Y118.213 E.00697
G1 X138.652 Y117.917 E.01684
G1 X139.124 Y117.802 E.01547
G1 X160.8 Y117.798 E.68968
G1 X161.102 Y117.834 E.00968
G1 X161.238 Y117.896 E.00474
M204 S250
G1 X161.138 Y118.259 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.462 E.01181
G1 X161.73 Y118.816 E.01272
G1 X161.81 Y119.199 E.01155
G1 X161.81 Y136.8 E.51874
G1 X161.757 Y137.112 E.0093
G1 X161.538 Y137.484 E.01273
G1 X161.184 Y137.73 E.01271
G1 X160.801 Y137.81 E.01154
G1 X139.2 Y137.81 E.63663
G1 X138.888 Y137.757 E.0093
G1 X138.516 Y137.539 E.01271
G1 X138.27 Y137.184 E.01272
G1 X138.19 Y136.801 E.01155
G1 X138.191 Y119.168 E.51968
G1 X138.259 Y118.842 E.0098
G1 X138.412 Y118.573 E.00912
G1 X138.763 Y118.293 E.01326
G1 X139.124 Y118.194 E.01103
G1 X160.8 Y118.19 E.63885
G1 X161.083 Y118.238 E.00845
; WIPE_START
M204 S3000
G1 X161.484 Y118.462 E-.17434
G1 X161.73 Y118.816 E-.16398
G1 X161.81 Y119.199 E-.14888
G1 X161.81 Y119.917 E-.2728
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.26 Y127.537 Z4.4 F12000
G1 X162.932 Y138.923 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.738 Y138.991 E.00654
G2 X160.801 Y138.997 I-.678 J91.807 E.06164
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.997 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.997 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.996 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.996 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.996 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.995 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.995 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.995 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.995 E.06143
; LINE_WIDTH: 0.43575
G1 X139.2 Y138.995 E.04916
; LINE_WIDTH: 0.44121
G1 X139.037 Y138.992 E.00505
; LINE_WIDTH: 0.44999
G2 X137.225 Y138.987 I-1.254 J135.387 E.05768
G1 X137.066 Y138.914 E.00556
G1 X137.009 Y138.732 E.00608
G2 X137.003 Y136.801 I-91.347 J-.677 E.06145
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05017
; LINE_WIDTH: 0.44597
G1 X137.01 Y118.951 E.00684
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.258 I-275.939 J-1.221 E.05387
G1 X137.064 Y117.084 E.00576
G1 X137.249 Y117.009 E.00634
G2 X139.124 Y117.004 I.609 J-114.005 E.05967
; LINE_WIDTH: 0.43911
G1 X141.124 Y117.004 E.06193
; LINE_WIDTH: 0.43891
G1 X143.124 Y117.004 E.0619
; LINE_WIDTH: 0.43872
G1 X145.124 Y117.004 E.06187
; LINE_WIDTH: 0.43853
G1 X147.124 Y117.004 E.06184
; LINE_WIDTH: 0.43834
G1 X149.124 Y117.004 E.06181
; LINE_WIDTH: 0.43815
G1 X151.124 Y117.003 E.06178
; LINE_WIDTH: 0.43796
G1 X153.124 Y117.003 E.06175
; LINE_WIDTH: 0.43777
G1 X155.124 Y117.003 E.06172
; LINE_WIDTH: 0.43758
G1 X157.124 Y117.003 E.06169
; LINE_WIDTH: 0.43739
G1 X159.124 Y117.003 E.06166
; LINE_WIDTH: 0.4372
G1 X160.8 Y117.003 E.05166
; LINE_WIDTH: 0.44263
G1 X160.963 Y117.006 E.00508
; LINE_WIDTH: 0.44999
G2 X162.696 Y117.01 I1.198 J-154.56 E.05514
G1 X162.908 Y117.059 E.00692
G1 X162.99 Y117.224 E.00586
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I89.582 J.698 E.06287
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.8 E.04916
; LINE_WIDTH: 0.46001
G2 X162.987 Y137.973 I16.671 J.691 E.03822
; LINE_WIDTH: 0.44999
G1 X162.987 Y138.725 E.02393
G1 X162.948 Y138.865 E.00463
M204 S10000
G1 X163.226 Y139.174 F12000
G1 F6000
M204 S3000
G1 X163.111 Y139.303 E.0055
G1 X162.763 Y139.398 E.01145
G1 X137.176 Y139.394 E.8141
G1 X136.895 Y139.297 E.00946
G1 X136.693 Y139.104 E.00891
G1 X136.602 Y138.76 E.01133
G1 X136.606 Y117.176 E.68672
G1 X136.702 Y116.897 E.0094
G1 X136.887 Y116.7 E.0086
G1 X137.229 Y116.602 E.01132
G1 X162.769 Y116.603 E.81262
G1 X163.107 Y116.704 E.01121
G1 X163.318 Y116.918 E.00959
G1 X163.397 Y117.224 E.01004
G1 X163.394 Y138.725 E.6841
G1 X163.333 Y139.054 E.01065
G1 X163.265 Y139.129 E.00322
M204 S250
G1 X163.525 Y139.441 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.422 Y139.543 E.00427
G3 X163.167 Y139.705 I-.765 J-.919 E.00892
G1 X162.788 Y139.79 E.01146
G1 X137.283 Y139.786 E.75168
G3 X136.301 Y139.187 I-.029 J-1.058 E.03586
G1 X136.21 Y138.787 E.0121
G1 X136.214 Y117.257 E.63452
G1 X136.288 Y116.822 E.01301
G1 X136.449 Y116.559 E.00911
G1 X136.682 Y116.359 E.00905
G3 X137.21 Y116.21 I.737 J1.599 E.01621
G1 X162.696 Y116.211 E.75113
G1 X163.18 Y116.289 E.01447
G1 X163.44 Y116.448 E.00898
G1 X163.663 Y116.719 E.01035
G3 X163.789 Y117.224 I-1.394 J.617 E.0154
G1 X163.786 Y138.733 E.63392
G1 X163.696 Y139.216 E.01448
G3 X163.61 Y139.345 I-1.039 J-.592 E.00458
G1 X163.565 Y139.396 E.00201
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.422 Y139.543 E-.07787
G1 X163.167 Y139.705 E-.11469
G1 X162.788 Y139.79 E-.14773
G1 X161.683 Y139.79 E-.41971
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.712 Y136.684 Z4.4 F12000
G1 X116.39 Y119.609 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.593 J.204 E.04356
; LINE_WIDTH: 0.43692
G1 X116.396 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.396 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.396 Y126.979 E.06156
; LINE_WIDTH: 0.4366
G1 X116.396 Y130.979 E.12308
; LINE_WIDTH: 0.4364
G1 X116.396 Y132.979 E.06151
; LINE_WIDTH: 0.43629
G1 X116.396 Y134.979 E.06149
; LINE_WIDTH: 0.43619
G1 X116.396 Y135.021 E.00132
; LINE_WIDTH: 0.4451
G1 X116.391 Y135.227 E.00645
; LINE_WIDTH: 0.44999
M73 P70 R5
G1 X116.388 Y136.391 E.03704
G2 X115.021 Y136.397 I-.196 J105.081 E.0435
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.778 E.04357
; LINE_WIDTH: 0.43731
G1 X110.979 Y119.603 E.43156
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.603 E.12459
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.727 Y119.265 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.451 E.00633
G1 X116.796 Y136.587 E.54521
G1 X116.72 Y136.74 E.00545
G1 X116.56 Y136.798 E.00541
G1 X95.463 Y136.798 E.67123
G1 X95.25 Y136.712 E.0073
G1 X95.202 Y136.548 E.00545
G1 X95.202 Y119.463 E.54358
G1 X95.279 Y119.263 E.00684
G1 X95.438 Y119.202 E.00543
G1 X116.527 Y119.202 E.67101
G1 X116.67 Y119.247 E.00474
M204 S250
G1 X117.003 Y118.978 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.013 Y118.984 E.00035
G1 X117.152 Y119.202 E.00762
G1 X117.189 Y119.451 E.00741
G1 X117.188 Y136.545 E.5038
G1 X117.134 Y136.842 E.00889
G1 X116.98 Y137.045 E.00752
G3 X116.587 Y137.19 I-.538 J-.854 E.01245
G1 X95.495 Y137.19 E.62162
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.549 J-.832 E.01055
G1 X94.81 Y136.583 E.0093
G1 X94.81 Y119.495 E.50361
G1 X94.868 Y119.155 E.01017
G1 X95.019 Y118.956 E.00736
G3 X95.413 Y118.81 I.55 J.881 E.01246
G1 X116.527 Y118.81 E.6223
G1 X116.824 Y118.858 E.00885
G1 X116.953 Y118.944 E.00458
; WIPE_START
M204 S3000
G1 X117.013 Y118.984 E-.0273
G1 X117.152 Y119.202 E-.09823
G1 X117.189 Y119.451 E-.09553
G1 X117.189 Y120.869 E-.53895
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.901 Y125.195 Z4.4 F12000
G1 X96.103 Y135.376 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X110.979 Y119.997 E.43156
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.997 E.12459
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43692
G1 X116.003 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.002 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.002 Y126.979 E.06156
; LINE_WIDTH: 0.4366
G1 X116.002 Y130.979 E.12308
; LINE_WIDTH: 0.4364
G1 X116.002 Y132.979 E.06151
; LINE_WIDTH: 0.43629
G1 X116.002 Y134.979 E.06149
; LINE_WIDTH: 0.43619
G1 X116.002 Y135.021 E.00132
; LINE_WIDTH: 0.4451
G1 X115.992 Y135.192 E.00536
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01894
G1 X115.192 Y135.992 E.01887
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.13 Y135.43 E.01039
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.827 J.022 E.00457
G1 X115.432 Y135.433 E.01115
G1 X115.122 Y135.593 E.0111
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X104.358 Y134.209 Z4.4 F12000
G1 X116.02 Y135.958 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y135.998 E.00241
G1 X116.02 Y136.039 E.00241
G1 X116.043 Y135.998 E.00139
; WIPE_START
G1 X116.02 Y136.039 E-.17027
G1 X115.949 Y135.998 E-.29487
G1 X116.02 Y135.958 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y128.325 Z4.4 F12000
G1 X116.021 Y119.961 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.4214
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00242
G1 X116.021 Y120.043 E.00242
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X108.389 Y119.961 Z4.4 F12000
G1 X96.026 Y119.961 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y127.594 Z4.4 F12000
G1 X96.026 Y135.957 Z4.4
G1 Z4
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.4 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 20 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4.4 F4000
            G39.3 S1
            G0 Z4.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer20 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 21/40
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.62 Y118.027 F12000
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.37451
G1 F6000
M204 S3000
G1 X162.415 Y117.756 E.00881
G1 X161.974 Y117.379 E.01505
G1 X162.621 Y117.379 E.01676
G1 X162.62 Y117.967 E.01524
; WIPE_START
G1 X162.415 Y117.756 E-.11185
G1 X161.974 Y117.379 E-.22059
G1 X162.621 Y117.379 E-.24578
G1 X162.621 Y117.857 E-.18178
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.49 Z4.6 F12000
G1 X162.618 Y137.98 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.37394
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.0166
G1 X161.971 Y138.622 E.01675
G1 X162.341 Y138.334 E.01213
G1 X162.581 Y138.027 E.01009
; WIPE_START
G1 X162.618 Y138.622 E-.22635
G1 X161.971 Y138.622 E-.24603
G1 X162.341 Y138.334 E-.17811
G1 X162.519 Y138.107 E-.10951
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y138.266 Z4.6 F12000
G1 X138.02 Y138.618 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.0166
G1 X137.378 Y137.971 E.01675
G1 X137.666 Y138.341 E.01213
G1 X137.973 Y138.581 E.01008
; WIPE_START
G1 X137.378 Y138.618 E-.22627
G1 X137.378 Y137.971 E-.24597
G1 X137.666 Y138.341 E-.17808
G1 X137.893 Y138.519 E-.10968
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.944 Y130.887 Z4.6 F12000
G1 X138.035 Y117.378 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X137.736 Y117.6 E.00964
G1 X137.382 Y118.021 E.01423
G1 X137.382 Y117.378 E.01663
G1 X137.975 Y117.378 E.01534
; WIPE_START
G1 X137.736 Y117.6 E-.12397
G1 X137.382 Y118.021 E-.20898
G1 X137.382 Y117.378 E-.24429
G1 X137.863 Y117.378 E-.18277
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.495 Y117.42 Z4.6 F12000
G1 X161.395 Y117.507 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.45805
M73 P71 R5
G1 F6000
M204 S3000
G1 X161.488 Y117.538 E.00317
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.01121
G1 X162.121 Y117.979 E.01348
G1 X162.333 Y118.26 E.0112
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01792
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.801 E.04916
; LINE_WIDTH: 0.44856
G1 X162.542 Y137.258 E.01462
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.584 E.01104
G1 X162.092 Y138.062 E.01851
G1 X161.74 Y138.334 E.01414
G1 X161.356 Y138.511 E.01345
G1 X160.801 Y138.603 E.0179
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.603 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.603 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.603 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.602 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.602 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.602 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.602 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.602 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.602 E.06143
; LINE_WIDTH: 0.43575
G1 X139.199 Y138.602 E.04916
; LINE_WIDTH: 0.44856
G1 X138.742 Y138.542 E.01461
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01103
G1 X137.938 Y138.092 E.01853
G1 X137.667 Y137.74 E.01413
G1 X137.489 Y137.356 E.01347
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05018
; LINE_WIDTH: 0.44832
G1 X137.452 Y118.756 E.01314
; LINE_WIDTH: 0.44999
G1 X137.563 Y118.449 E.01041
G1 X137.908 Y117.938 E.01961
G3 X138.965 Y117.409 I1.442 J1.563 E.0381
; LINE_WIDTH: 0.4475
G1 X139.135 Y117.399 E.00539
; LINE_WIDTH: 0.43856
G1 X141.135 Y117.399 E.06185
; LINE_WIDTH: 0.43841
G1 X143.135 Y117.399 E.06182
; LINE_WIDTH: 0.43827
G1 X145.135 Y117.399 E.0618
; LINE_WIDTH: 0.43813
G1 X147.135 Y117.398 E.06178
; LINE_WIDTH: 0.43799
G1 X149.135 Y117.398 E.06176
; LINE_WIDTH: 0.43785
G1 X151.135 Y117.398 E.06174
; LINE_WIDTH: 0.43771
G1 X153.135 Y117.398 E.06171
; LINE_WIDTH: 0.43757
G1 X155.135 Y117.398 E.06169
; LINE_WIDTH: 0.43743
G1 X157.135 Y117.398 E.06167
; LINE_WIDTH: 0.43728
G1 X159.135 Y117.397 E.06165
; LINE_WIDTH: 0.43714
G1 X160.8 Y117.397 E.0513
; LINE_WIDTH: 0.45805
G3 X161.159 Y117.427 I.06 J1.457 E.01169
G1 X161.338 Y117.488 E.00616
M204 S10000
G1 X161.294 Y117.921 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01093
G3 X162.113 Y118.731 I-1.038 J1.312 E.02695
G1 X162.202 Y119.199 E.01517
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01242
G1 X161.925 Y137.627 E.01564
G3 X161.268 Y138.113 I-1.334 J-1.117 E.02624
G1 X160.801 Y138.202 E.01515
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.926 E.01562
G3 X137.887 Y137.269 I1.117 J-1.335 E.02627
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.168 E.56103
G1 X137.851 Y118.831 E.01085
G1 X138.071 Y118.38 E.01596
G1 X138.183 Y118.238 E.00575
G3 X138.67 Y117.909 I1.052 J1.032 E.01881
G1 X139.136 Y117.8 E.01521
G1 X160.8 Y117.798 E.68932
G1 X161.102 Y117.834 E.00967
G1 X161.239 Y117.896 E.00479
M204 S250
G1 X161.14 Y118.26 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.461 E.01175
G1 X161.73 Y118.815 E.01271
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.801 E.51875
G1 X161.733 Y137.18 E.01139
G1 X161.538 Y137.484 E.01066
G1 X161.184 Y137.73 E.0127
G1 X160.801 Y137.81 E.01155
G1 X139.199 Y137.81 E.63664
G1 X138.821 Y137.734 E.01138
G1 X138.516 Y137.539 E.01065
G1 X138.27 Y137.184 E.01272
G1 X138.19 Y136.801 E.01155
G1 X138.191 Y119.168 E.51968
G1 X138.258 Y118.843 E.00976
G1 X138.448 Y118.527 E.01087
G1 X138.776 Y118.286 E.01199
G1 X139.136 Y118.193 E.01095
G1 X160.8 Y118.19 E.63851
G1 X161.085 Y118.238 E.0085
; WIPE_START
M204 S3000
G1 X161.484 Y118.461 E-.17367
G1 X161.73 Y118.815 E-.16384
G1 X161.81 Y119.199 E-.14909
G1 X161.81 Y119.919 E-.2734
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.256 Y127.538 Z4.6 F12000
G1 X162.922 Y138.923 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.751 Y138.991 E.00587
G2 X160.801 Y138.997 I-.685 J92.456 E.06206
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.997 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.997 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.996 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.996 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.996 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.995 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.995 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.995 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.995 E.06143
; LINE_WIDTH: 0.43575
G1 X139.199 Y138.995 E.04916
; LINE_WIDTH: 0.44856
G1 X138.703 Y138.988 E.01574
; LINE_WIDTH: 0.44999
G3 X137.202 Y138.979 I-.279 J-76.19 E.04775
G1 X137.062 Y138.904 E.00507
G1 X137.009 Y138.751 E.00513
G2 X137.003 Y136.801 I-92.296 J-.687 E.06207
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05018
; LINE_WIDTH: 0.44592
G1 X137.01 Y118.951 E.00682
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.225 I-275.573 J-1.238 E.05493
G1 X137.086 Y117.066 E.00556
G1 X137.268 Y117.009 E.00608
G2 X139.135 Y117.003 I.613 J-105.19 E.05941
; LINE_WIDTH: 0.43856
G1 X141.135 Y117.003 E.06185
; LINE_WIDTH: 0.43841
G1 X143.135 Y117.003 E.06182
; LINE_WIDTH: 0.43827
G1 X145.135 Y117.003 E.0618
; LINE_WIDTH: 0.43813
G1 X147.135 Y117.003 E.06178
; LINE_WIDTH: 0.43799
G1 X149.135 Y117.003 E.06176
; LINE_WIDTH: 0.43785
G1 X151.135 Y117.003 E.06174
; LINE_WIDTH: 0.43771
G1 X153.135 Y117.003 E.06171
; LINE_WIDTH: 0.43757
G1 X155.135 Y117.003 E.06169
; LINE_WIDTH: 0.43743
G1 X157.135 Y117.003 E.06167
; LINE_WIDTH: 0.43728
G1 X159.135 Y117.003 E.06165
; LINE_WIDTH: 0.43714
G1 X160.8 Y117.003 E.0513
; LINE_WIDTH: 0.4426
G1 X160.963 Y117.006 E.00507
; LINE_WIDTH: 0.44999
G2 X162.697 Y117.01 I1.199 J-154.152 E.05518
G1 X162.908 Y117.059 E.00689
G1 X162.99 Y117.223 E.00583
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I89.939 J.698 E.0629
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.801 E.04916
; LINE_WIDTH: 0.44485
G1 X162.99 Y137.009 E.00656
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.776 I250.834 J1.281 E.05619
G1 X162.947 Y138.868 E.00321
M204 S10000
G1 X163.261 Y139.139 F12000
G1 F6000
M204 S3000
G1 X163.083 Y139.317 E.00801
G1 X162.771 Y139.398 E.01025
G1 X137.182 Y139.394 E.81417
G1 X136.884 Y139.294 E.01002
G1 X136.683 Y139.083 E.00927
G1 X136.602 Y138.771 E.01025
G1 X136.606 Y117.176 E.68709
G1 X136.703 Y116.895 E.00946
G1 X136.896 Y116.693 E.0089
G1 X137.24 Y116.602 E.01134
G1 X162.77 Y116.603 E.81229
G1 X163.107 Y116.704 E.01117
G1 X163.318 Y116.918 E.00959
G1 X163.397 Y117.223 E.01002
G1 X163.394 Y138.824 E.68727
G1 X163.302 Y139.096 E.00914
M204 S250
G1 X163.556 Y139.433 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.552 Y139.44 E.00023
G1 X163.281 Y139.662 E.01033
G3 X162.79 Y139.79 I-.673 J-1.579 E.01499
G1 X137.132 Y139.786 E.75622
G1 X136.783 Y139.695 E.01062
G1 X136.561 Y139.553 E.00776
G1 X136.338 Y139.281 E.01039
G3 X136.21 Y138.79 I1.59 J-.676 E.01499
G1 X136.214 Y117.283 E.63386
G3 X136.813 Y116.301 I1.058 J-.029 E.03585
G1 X137.213 Y116.21 E.01211
G1 X162.697 Y116.211 E.75106
G1 X163.18 Y116.289 E.01443
G1 X163.44 Y116.448 E.00898
G1 X163.663 Y116.72 E.01034
G3 X163.789 Y117.223 I-1.4 J.619 E.01537
G1 X163.786 Y138.743 E.63424
G1 X163.713 Y139.178 E.01301
G1 X163.587 Y139.382 E.00707
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.552 Y139.44 E-.02572
G1 X163.281 Y139.662 E-.13321
G1 X163.122 Y139.721 E-.06447
G1 X162.79 Y139.79 E-.1286
G1 X161.717 Y139.79 E-.408
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.744 Y136.685 Z4.6 F12000
G1 X116.39 Y119.609 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.595 J.204 E.04356
; LINE_WIDTH: 0.43692
G1 X116.396 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.396 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.396 Y128.979 E.12312
; LINE_WIDTH: 0.4365
G1 X116.396 Y132.979 E.12305
; LINE_WIDTH: 0.4363
G1 X116.396 Y135.021 E.06281
; LINE_WIDTH: 0.44512
G1 X116.391 Y135.227 E.00645
; LINE_WIDTH: 0.44999
G1 X116.388 Y136.391 E.03704
G2 X115.021 Y136.397 I-.196 J104.919 E.0435
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-104.308 J-.212 E.04357
; LINE_WIDTH: 0.43721
G1 X95.603 Y133.021 E.06164
; LINE_WIDTH: 0.43707
G1 X95.603 Y131.021 E.06161
; LINE_WIDTH: 0.43693
G1 X95.604 Y129.021 E.06159
; LINE_WIDTH: 0.43679
G1 X95.604 Y127.021 E.06157
; LINE_WIDTH: 0.43665
G1 X95.604 Y125.021 E.06155
; LINE_WIDTH: 0.43651
G1 X95.604 Y123.021 E.06153
; LINE_WIDTH: 0.43637
G1 X95.604 Y121.021 E.06151
; LINE_WIDTH: 0.43623
G1 X95.604 Y120.978 E.00132
; LINE_WIDTH: 0.44999
G1 X95.612 Y119.609 E.04356
G2 X96.979 Y119.603 I.196 J-105.252 E.0435
; LINE_WIDTH: 0.43731
G1 X110.979 Y119.603 E.43156
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.603 E.12459
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.737 Y119.271 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.47 E.0066
G1 X116.796 Y136.586 E.5446
G1 X116.72 Y136.74 E.00545
G1 X116.56 Y136.798 E.00541
G1 X95.463 Y136.798 E.67122
G1 X95.26 Y136.719 E.00694
G1 X95.202 Y136.56 E.0054
G1 X95.204 Y119.414 E.54554
G1 X95.28 Y119.26 E.00545
G1 X95.441 Y119.202 E.00542
G1 X116.527 Y119.202 E.67091
G1 X116.68 Y119.252 E.00511
M204 S250
G1 X117.008 Y118.981 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.016 Y118.986 E.00027
G3 X117.132 Y119.153 I-.415 J.413 E.00601
G1 X117.189 Y119.47 E.0095
G1 X117.188 Y136.545 E.50324
G1 X117.134 Y136.842 E.0089
G1 X116.98 Y137.045 E.00751
G3 X116.587 Y137.19 I-.537 J-.851 E.01245
G1 X95.495 Y137.19 E.62162
G1 X95.155 Y137.132 E.01017
G1 X94.955 Y136.98 E.00741
G3 X94.81 Y136.587 I.838 J-.531 E.01245
G1 X94.812 Y119.456 E.5049
G1 X94.866 Y119.158 E.00891
G1 X95.02 Y118.955 E.00751
G3 X95.414 Y118.81 I.537 J.851 E.01246
G1 X116.527 Y118.81 E.62226
G1 X116.824 Y118.858 E.00885
G1 X116.958 Y118.948 E.00477
; WIPE_START
M204 S3000
G1 X117.016 Y118.986 E-.02625
G1 X117.132 Y119.153 E-.07713
G1 X117.189 Y119.47 E-.12244
G1 X117.189 Y120.875 E-.53418
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.9 Y125.2 Z4.6 F12000
G1 X96.103 Y135.376 Z4.6
M73 P72 R5
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44614
G1 X95.997 Y135.021 E.00537
; LINE_WIDTH: 0.43721
G1 X95.997 Y133.021 E.06164
; LINE_WIDTH: 0.43707
G1 X95.997 Y131.021 E.06161
; LINE_WIDTH: 0.43693
G1 X95.997 Y129.021 E.06159
; LINE_WIDTH: 0.43679
G1 X95.998 Y127.021 E.06157
; LINE_WIDTH: 0.43665
G1 X95.998 Y125.021 E.06155
; LINE_WIDTH: 0.43651
G1 X95.998 Y123.021 E.06153
; LINE_WIDTH: 0.43637
G1 X95.998 Y121.021 E.06151
; LINE_WIDTH: 0.43623
G1 X95.998 Y120.979 E.00132
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.024
G1 X96.808 Y120.008 E.01887
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X110.979 Y119.997 E.43156
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.997 E.12459
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43692
G1 X116.003 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.002 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.002 Y128.979 E.12312
; LINE_WIDTH: 0.4365
G1 X116.002 Y132.979 E.12305
; LINE_WIDTH: 0.4363
G1 X116.002 Y135.021 E.06281
; LINE_WIDTH: 0.44512
G1 X115.992 Y135.192 E.00536
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01894
G1 X115.192 Y135.992 E.01887
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02397
G1 X96.13 Y135.429 E.0104
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.978 E.44681
G1 X96.568 Y120.568 E.01416
G1 X96.878 Y120.407 E.01111
G1 X115.021 Y120.398 E.57727
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.827 J.022 E.00457
G1 X115.432 Y135.433 E.01114
G1 X115.122 Y135.593 E.0111
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.946 Y120.793 E.00334
G1 X114.979 Y120.79 E.53146
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.355 Y125.458 Z4.6 F12000
G1 X96.027 Y119.961 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00241
G1 X96.027 Y120.042 E.00241
G1 X96.051 Y120.002 E.00139
; WIPE_START
G1 X96.027 Y120.042 E-.17027
G1 X95.957 Y120.002 E-.29487
G1 X96.027 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y127.593 Z4.6 F12000
G1 X96.026 Y135.957 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17026
G1 X95.955 Y135.998 E-.29487
G1 X96.026 Y135.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y135.957 Z4.6 F12000
G1 X116.02 Y135.958 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y135.998 E.00241
G1 X116.02 Y136.039 E.00241
G1 X116.043 Y135.998 E.00139
; WIPE_START
G1 X116.02 Y136.039 E-.17027
G1 X115.949 Y135.998 E-.29487
G1 X116.02 Y135.958 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y128.325 Z4.6 F12000
G1 X116.021 Y119.961 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.4214
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00242
G1 X116.021 Y120.043 E.00242
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.6 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 21 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4.6 F4000
            G39.3 S1
            G0 Z4.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer21 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 22/40
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X138.024 Y138.621 F12000
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01684
G1 X137.667 Y138.343 E.01218
G1 X137.977 Y138.584 E.01019
; WIPE_START
G1 X137.379 Y138.621 E-.22767
G1 X137.379 Y137.972 E-.24659
G1 X137.667 Y138.343 E-.17839
G1 X137.89 Y138.517 E-.10734
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.52 Y138.351 Z4.8 F12000
G1 X162.618 Y137.98 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.01661
G1 X161.971 Y138.622 E.01676
G1 X162.341 Y138.334 E.01213
G1 X162.581 Y138.027 E.01009
; WIPE_START
G1 X162.618 Y138.622 E-.22636
G1 X161.971 Y138.622 E-.24608
G1 X162.341 Y138.334 E-.17816
G1 X162.518 Y138.108 E-.10941
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.557 Y130.475 Z4.8 F12000
G1 X162.62 Y118.027 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.37451
G1 F6000
M204 S3000
G1 X162.333 Y117.657 E.01215
G1 X161.976 Y117.379 E.01171
G1 X162.621 Y117.379 E.0167
G1 X162.62 Y117.967 E.01524
; WIPE_START
G1 X162.333 Y117.657 E-.16076
G1 X161.976 Y117.379 E-.17176
G1 X162.621 Y117.379 E-.24483
G1 X162.621 Y117.86 E-.18265
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.738 Y125.491 Z4.8 F12000
G1 X162.943 Y138.909 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.751 Y138.991 E.00664
G2 X160.801 Y138.997 I-.671 J93.35 E.06206
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.997 E.6659
; LINE_WIDTH: 0.44656
G1 X138.991 Y138.993 E.00659
; LINE_WIDTH: 0.44999
G2 X137.301 Y138.991 I-1.205 J353.791 E.05376
G1 X137.075 Y138.93 E.00743
G1 X137.009 Y138.712 E.00723
G2 X137.003 Y136.801 I-90.411 J-.667 E.06083
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05018
; LINE_WIDTH: 0.44979
G1 X137.012 Y118.912 E.00812
; LINE_WIDTH: 0.44999
G1 X137.013 Y117.225 E.0537
G1 X137.086 Y117.066 E.00555
G1 X137.268 Y117.009 E.00609
G1 X138.647 Y117.009 E.04388
; LINE_WIDTH: 0.4495
G1 X139.199 Y117.003 E.01755
; LINE_WIDTH: 0.43729
G1 X149.199 Y117.003 E.30824
; LINE_WIDTH: 0.43716
G1 X157.199 Y117.003 E.24651
; LINE_WIDTH: 0.43706
G1 X160.801 Y117.003 E.11095
; LINE_WIDTH: 0.44631
G1 X161.01 Y117.008 E.0066
; LINE_WIDTH: 0.44999
G2 X162.698 Y117.01 I1.215 J-331.046 E.05371
G1 X162.892 Y117.05 E.0063
G1 X162.99 Y117.216 E.00614
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I89.959 J.702 E.06312
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.8 E.04916
; LINE_WIDTH: 0.44457
G1 X162.99 Y137.009 E.00655
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.733 I231.894 J1.256 E.05484
G1 X162.958 Y138.851 E.00389
M204 S10000
G1 X163.245 Y139.154 F12000
G1 F6000
M204 S3000
G1 X163.113 Y139.3 E.00627
G1 X162.771 Y139.398 E.01131
G1 X138.771 Y139.398 E.76361
G3 X137.108 Y139.376 I-.399 J-32.829 E.05294
G1 X136.848 Y139.275 E.00887
G1 X136.695 Y139.092 E.0076
G1 X136.602 Y138.748 E.01132
G1 X136.606 Y117.176 E.68636
G1 X136.703 Y116.895 E.00946
G1 X136.896 Y116.693 E.00891
G1 X137.24 Y116.602 E.01133
G1 X162.772 Y116.603 E.81234
G1 X163.105 Y116.703 E.01107
G1 X163.322 Y116.925 E.00989
G1 X163.397 Y117.216 E.00955
G1 X163.394 Y138.733 E.68459
G1 X163.332 Y139.058 E.01053
G1 X163.285 Y139.109 E.00221
M204 S250
G1 X163.556 Y139.434 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.553 Y139.44 E.0002
G1 X163.317 Y139.641 E.00911
G3 X162.79 Y139.79 I-.73 J-1.574 E.01621
G1 X137.315 Y139.79 E.75083
G1 X136.895 Y139.739 E.01247
G1 X136.618 Y139.598 E.00916
G1 X136.425 Y139.413 E.00786
G1 X136.274 Y139.144 E.00911
G1 X136.21 Y138.783 E.01079
G1 X136.214 Y117.283 E.63364
G3 X136.813 Y116.301 I1.058 J-.029 E.03586
M73 P73 R5
G1 X137.213 Y116.21 E.0121
G1 X162.698 Y116.211 E.7511
G1 X163.18 Y116.289 E.01438
G1 X163.44 Y116.448 E.00898
G1 X163.668 Y116.73 E.01069
G3 X163.789 Y117.216 I-1.476 J.625 E.01483
G1 X163.786 Y138.733 E.63414
G1 X163.695 Y139.217 E.01451
G1 X163.588 Y139.384 E.00585
; WIPE_START
M204 S3000
G1 X163.553 Y139.44 E-.02534
G1 X163.317 Y139.641 E-.11751
G1 X163.12 Y139.718 E-.08052
G1 X162.79 Y139.79 E-.1282
G1 X161.716 Y139.79 E-.40844
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.62 Y132.158 Z4.8 F12000
G1 X161.438 Y117.524 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.584 Y117.577 E.00494
G1 X162.061 Y117.907 E.01845
G1 X162.334 Y118.26 E.0142
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.0179
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.8 E.04916
; LINE_WIDTH: 0.44852
G1 X162.542 Y137.258 E.01462
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.584 E.01105
G1 X162.092 Y138.062 E.01852
G1 X161.74 Y138.334 E.01414
G1 X161.356 Y138.511 E.01345
G1 X160.801 Y138.603 E.01791
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.603 E.6659
; LINE_WIDTH: 0.44903
G1 X138.743 Y138.543 E.01463
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01104
G1 X137.939 Y138.093 E.01848
G1 X137.666 Y137.74 E.01419
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05018
; LINE_WIDTH: 0.44993
G1 X137.476 Y118.674 E.0159
G1 X137.62 Y118.337 E.01167
G1 X137.922 Y117.919 E.01638
G1 X138.337 Y117.62 E.0163
G1 X138.693 Y117.473 E.01224
; LINE_WIDTH: 0.4495
G1 X139.199 Y117.397 E.01627
; LINE_WIDTH: 0.43729
G1 X149.199 Y117.397 E.30824
; LINE_WIDTH: 0.43716
G1 X157.199 Y117.397 E.24651
; LINE_WIDTH: 0.43706
G1 X160.801 Y117.397 E.11095
; LINE_WIDTH: 0.44896
G1 X161.258 Y117.458 E.01464
; LINE_WIDTH: 0.44999
G1 X161.382 Y117.503 E.00418
M204 S10000
G1 X161.331 Y117.929 F12000
G1 F6000
M204 S3000
G1 X161.627 Y118.074 E.01051
G3 X162.113 Y118.732 I-1.118 J1.335 E.02626
G1 X162.202 Y119.199 E.01515
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01242
G1 X161.925 Y137.627 E.01564
G3 X161.268 Y138.113 I-1.334 J-1.117 E.02624
G1 X160.801 Y138.202 E.01515
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.01241
G1 X138.623 Y138.072 E.00649
G1 X138.239 Y137.818 E.01465
G1 X137.991 Y137.494 E.01296
G1 X137.887 Y137.269 E.00791
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.168 E.56103
G1 X137.874 Y118.761 E.01315
G1 X138.137 Y118.296 E.017
G3 X138.772 Y117.872 I1.225 J1.146 E.02454
G1 X139.199 Y117.798 E.01379
G1 X160.801 Y117.798 E.6873
G1 X161.187 Y117.858 E.01242
G1 X161.277 Y117.902 E.0032
M204 S250
G1 X161.166 Y118.264 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.18 Y118.267 E.00041
G1 X161.484 Y118.461 E.01065
G1 X161.73 Y118.816 E.01272
G1 X161.81 Y119.199 E.01155
G1 X161.81 Y136.8 E.51874
G1 X161.733 Y137.179 E.01139
G1 X161.538 Y137.484 E.01066
G1 X161.184 Y137.73 E.0127
G1 X160.801 Y137.81 E.01155
G1 X139.199 Y137.81 E.63664
G1 X138.821 Y137.734 E.01138
G1 X138.516 Y137.538 E.01066
G1 X138.27 Y137.184 E.01271
G1 X138.19 Y136.801 E.01155
G1 X138.191 Y119.168 E.51968
G1 X138.284 Y118.781 E.01173
G1 X138.515 Y118.462 E.01159
G1 X138.849 Y118.256 E.01157
G1 X139.199 Y118.19 E.01051
G1 X160.801 Y118.19 E.63665
G1 X161.107 Y118.252 E.00921
; WIPE_START
M204 S3000
G1 X161.18 Y118.267 E-.02803
G1 X161.484 Y118.461 E-.13727
G1 X161.73 Y118.816 E-.16398
G1 X161.81 Y119.199 E-.14892
G1 X161.81 Y119.941 E-.2818
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.217 Y119.167 Z4.8 F12000
G1 X137.587 Y117.471 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.70174
G1 F4553.596
M204 S3000
G2 X137.628 Y117.542 I-.036 J.068 E.02052
; OBJECT_ID: 47
; WIPE_START
G1 X137.587 Y117.613 E-.15201
G1 X137.504 Y117.613 E-.152
G1 X137.463 Y117.542 E-.152
G1 X137.505 Y117.471 E-.15201
G1 X137.587 Y117.471 E-.15198
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X129.993 Y118.237 Z4.8 F12000
G1 X116.39 Y119.609 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.458 J.191 E.04356
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.778 E.04357
; LINE_WIDTH: 0.43731
G1 X112.979 Y119.603 E.49322
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.603 E.06296
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.734 Y119.27 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.465 E.00654
G1 X116.798 Y136.537 E.54315
G1 X116.721 Y136.738 E.00685
G1 X116.562 Y136.798 E.00543
G1 X95.463 Y136.798 E.67129
G1 X95.262 Y136.721 E.00684
G1 X95.202 Y136.562 E.00543
G1 X95.202 Y119.463 E.54402
G1 X95.281 Y119.26 E.00694
G1 X95.441 Y119.202 E.00541
G1 X116.526 Y119.202 E.67089
G1 X116.677 Y119.251 E.00505
M204 S250
G1 X117.009 Y118.982 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.015 Y118.986 E.00023
G3 X117.137 Y119.164 I-.415 J.414 E.00639
G1 X117.189 Y119.465 E.00902
G1 X117.19 Y136.505 E.50219
G1 X117.132 Y136.845 E.01018
G1 X116.981 Y137.044 E.00736
G3 X116.587 Y137.19 I-.549 J-.879 E.01246
G1 X95.495 Y137.19 E.62163
G1 X95.155 Y137.132 E.01018
G1 X94.956 Y136.981 E.00736
G3 X94.81 Y136.587 I.879 J-.549 E.01246
G1 X94.81 Y119.495 E.50374
G1 X94.868 Y119.155 E.01017
G1 X95.02 Y118.955 E.00741
G3 X95.414 Y118.81 I.531 J.837 E.01245
G1 X116.526 Y118.81 E.62224
G1 X116.824 Y118.858 E.00888
G1 X116.959 Y118.948 E.0048
; WIPE_START
M204 S3000
G1 X117.015 Y118.986 E-.02573
G1 X117.137 Y119.164 E-.08193
G1 X117.189 Y119.465 E-.11624
G1 X117.189 Y120.876 E-.53612
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.905 Y125.208 Z4.8 F12000
G1 X96.117 Y135.403 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X112.979 Y119.997 E.49322
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.997 E.06296
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
M73 P74 R5
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z4.8 F12000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z4.8 F12000
G1 X96.026 Y119.961 Z4.8
M73 P74 R4
G1 Z4.4
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z4.8 F12000
G1 X116.021 Y119.961 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.42148
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17025
G1 X115.95 Y120.002 E-.29488
G1 X116.021 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z4.8 F12000
G1 X116.021 Y135.957 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z4.8 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 22 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z4.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z4.8 F4000
            G39.3 S1
            G0 Z4.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer22 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 23/40
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.37451
G1 F6000
M204 S3000
G1 X162.415 Y117.756 E.00881
G1 X161.974 Y117.379 E.01504
G1 X162.621 Y117.379 E.01676
G1 X162.621 Y117.967 E.01524
; WIPE_START
G1 X162.415 Y117.756 E-.11189
G1 X161.974 Y117.379 E-.22055
G1 X162.621 Y117.379 E-.2457
G1 X162.621 Y117.858 E-.18187
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.49 Z5 F12000
G1 X162.621 Y137.976 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01675
G1 X161.972 Y138.621 E.01685
G1 X162.343 Y138.333 E.01219
G1 X162.584 Y138.023 E.01019
; WIPE_START
G1 X162.621 Y138.621 E-.22762
G1 X161.972 Y138.621 E-.24672
G1 X162.343 Y138.333 E-.17852
G1 X162.516 Y138.111 E-.10714
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y138.27 Z5 F12000
G1 X138.024 Y138.621 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01684
G1 X137.667 Y138.343 E.01218
G1 X137.977 Y138.584 E.01019
; WIPE_START
G1 X137.379 Y138.621 E-.22765
G1 X137.379 Y137.972 E-.2466
G1 X137.667 Y138.343 E-.17841
G1 X137.89 Y138.517 E-.10734
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.941 Y130.884 Z5 F12000
G1 X138.033 Y117.381 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.3729
G1 F6000
M204 S3000
G1 X137.731 Y117.605 E.0097
G1 X137.381 Y118.023 E.01405
G1 X137.381 Y117.381 E.01655
G1 X137.973 Y117.381 E.01525
; WIPE_START
G1 X137.731 Y117.605 E-.1253
G1 X137.381 Y118.023 E-.20699
G1 X137.381 Y117.381 E-.24388
G1 X137.865 Y117.381 E-.18383
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.497 Y117.422 Z5 F12000
G1 X161.398 Y117.508 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.45791
G1 F6000
M204 S3000
G1 X161.488 Y117.538 E.00308
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.01121
G1 X162.121 Y117.979 E.01347
G1 X162.333 Y118.26 E.0112
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01792
; LINE_WIDTH: 0.43693
G1 X162.603 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.603 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.603 Y136.801 E.17261
; LINE_WIDTH: 0.44897
G1 X162.543 Y137.258 E.01463
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01103
G1 X162.093 Y138.061 E.01848
G1 X161.74 Y138.334 E.01421
G1 X161.355 Y138.511 E.01346
G1 X160.801 Y138.603 E.01789
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.603 E.6659
; LINE_WIDTH: 0.44903
G1 X138.742 Y138.543 E.01463
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01103
G1 X137.939 Y138.093 E.01848
G1 X137.666 Y137.74 E.01419
G1 X137.489 Y137.356 E.01346
G1 X137.408 Y136.971 E.01252
; LINE_WIDTH: 0.44608
G1 X137.397 Y136.801 E.00537
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05018
; LINE_WIDTH: 0.44824
G1 X137.451 Y118.76 E.01303
; LINE_WIDTH: 0.44999
G1 X137.562 Y118.452 E.01041
G1 X137.907 Y117.939 E.01967
G3 X138.547 Y117.523 I1.334 J1.349 E.02445
G1 X138.965 Y117.41 E.01378
; LINE_WIDTH: 0.44581
G1 X139.135 Y117.4 E.00537
; LINE_WIDTH: 0.43689
G1 X160.8 Y117.397 E.66714
; LINE_WIDTH: 0.45791
G3 X161.159 Y117.427 I.06 J1.458 E.01169
G1 X161.341 Y117.489 E.00625
M204 S10000
G1 X161.297 Y117.923 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01083
G3 X162.113 Y118.731 I-1.039 J1.312 E.02695
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01562
G3 X161.268 Y138.113 I-1.336 J-1.118 E.02628
G1 X160.801 Y138.202 E.01514
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.926 E.01562
G3 X137.887 Y137.268 I1.117 J-1.335 E.02626
G1 X137.807 Y136.901 E.01197
G1 X137.799 Y119.168 E.56422
G1 X137.85 Y118.833 E.01076
G1 X138.07 Y118.38 E.01601
G3 X138.659 Y117.914 I1.298 J1.035 E.02412
G1 X139.135 Y117.8 E.01557
G1 X160.8 Y117.798 E.68932
G1 X161.102 Y117.834 E.00968
G1 X161.243 Y117.898 E.0049
M204 S250
G1 X161.143 Y118.261 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.462 E.01165
G1 X161.73 Y118.815 E.01271
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.801 E.51875
G1 X161.734 Y137.179 E.01138
G1 X161.539 Y137.484 E.01066
G1 X161.184 Y137.73 E.01273
G1 X160.801 Y137.81 E.01154
G1 X139.199 Y137.81 E.63664
G1 X138.821 Y137.734 E.01138
G1 X138.516 Y137.539 E.01066
G1 X138.27 Y137.184 E.01272
G1 X138.193 Y136.833 E.0106
G1 X138.191 Y119.168 E.52064
G1 X138.257 Y118.846 E.00969
G1 X138.458 Y118.519 E.0113
G1 X138.768 Y118.291 E.01134
G1 X139.135 Y118.193 E.01121
G1 X160.8 Y118.19 E.63852
G1 X161.088 Y118.239 E.0086
; WIPE_START
M204 S3000
G1 X161.484 Y118.462 E-.17251
G1 X161.73 Y118.815 E-.16387
G1 X161.81 Y119.199 E-.14902
G1 X161.81 Y119.922 E-.2746
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.258 Y127.541 Z5 F12000
G1 X162.926 Y138.923 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.712 Y138.991 E.00714
G2 X160.801 Y138.997 I-.653 J91.265 E.06082
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.997 E.6659
; LINE_WIDTH: 0.44656
G1 X138.991 Y138.993 E.00659
; LINE_WIDTH: 0.44999
G2 X137.315 Y138.991 I-1.201 J356.425 E.05331
G1 X137.081 Y138.935 E.00766
G1 X137.009 Y138.732 E.00687
G2 X137.003 Y136.801 I-91.408 J-.676 E.06145
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05018
; LINE_WIDTH: 0.44579
G1 X137.01 Y118.953 E.00677
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.267 I-259.213 J-1.21 E.05363
G1 X137.076 Y117.076 E.00641
G1 X137.234 Y117.013 E.00542
G2 X139.135 Y117.006 I.609 J-95.701 E.06048
; LINE_WIDTH: 0.43689
G1 X160.8 Y117.003 E.66714
; LINE_WIDTH: 0.44246
G1 X160.963 Y117.006 E.00507
; LINE_WIDTH: 0.44999
G2 X162.699 Y117.01 I1.18 J-151.752 E.05526
G1 X162.894 Y117.05 E.00631
G1 X162.99 Y117.221 E.00624
; LINE_WIDTH: 0.45008
G2 X162.997 Y119.199 I91.038 J.684 E.06295
; LINE_WIDTH: 0.43693
G1 X162.997 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.997 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.997 Y136.801 E.17261
; LINE_WIDTH: 0.44622
G1 X162.993 Y137.009 E.00659
; LINE_WIDTH: 0.44999
G2 X162.991 Y138.722 I329.646 J1.207 E.05448
G1 X162.945 Y138.866 E.00481
M204 S10000
G1 X163.278 Y139.147 F12000
G1 F6000
M204 S3000
G1 X163.081 Y139.315 E.00823
G1 X162.748 Y139.398 E.01092
G1 X138.748 Y139.398 E.76361
G3 X137.081 Y139.367 I-.387 J-24.369 E.05308
G1 X136.829 Y139.261 E.00869
G1 X136.686 Y139.069 E.00762
G1 X136.602 Y138.76 E.01019
G1 X136.605 Y118.76 E.63634
G3 X136.627 Y117.1 I34.681 J-.377 E.05282
G1 X136.725 Y116.869 E.00799
G1 X136.954 Y116.665 E.00974
G1 X137.182 Y116.606 E.00752
G1 X162.773 Y116.603 E.81423
G1 X163.106 Y116.703 E.01107
G1 X163.314 Y116.912 E.00936
G1 X163.397 Y117.195 E.00937
G1 X163.398 Y137.195 E.63634
G3 X163.376 Y138.892 I-33.551 J.417 E.05402
G1 X163.299 Y139.091 E.00678
M204 S250
M73 P75 R4
G1 X163.567 Y139.413 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.379 Y139.6 E.00783
G1 X163.145 Y139.725 E.00781
G1 X162.783 Y139.79 E.01085
G1 X137.315 Y139.79 E.7506
G1 X136.856 Y139.726 E.01365
G1 X136.587 Y139.575 E.0091
G1 X136.403 Y139.384 E.00781
G1 X136.248 Y139.065 E.01045
G1 X136.21 Y138.787 E.00827
G1 X136.214 Y117.267 E.63424
G1 X136.304 Y116.787 E.0144
G1 X136.502 Y116.502 E.01024
G1 X136.787 Y116.304 E.01022
G1 X137.132 Y116.214 E.01051
G1 X162.699 Y116.211 E.75353
G1 X163.18 Y116.289 E.01436
G1 X163.44 Y116.448 E.00897
G1 X163.661 Y116.718 E.01028
G3 X163.789 Y117.195 I-2.09 J.816 E.01459
G1 X163.79 Y138.685 E.63337
G1 X163.739 Y139.105 E.01247
G1 X163.606 Y139.367 E.00868
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.379 Y139.6 E-.12348
G1 X163.145 Y139.725 E-.10066
G1 X162.783 Y139.79 E-.13991
G1 X161.741 Y139.79 E-.39595
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.768 Y136.687 Z5 F12000
G1 X116.39 Y119.609 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.459 J.191 E.04356
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.778 E.04357
; LINE_WIDTH: 0.43731
G1 X114.979 Y119.603 E.55487
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.603 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.727 Y119.265 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.451 E.00632
G1 X116.798 Y136.537 E.54362
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.719 E.00694
G1 X95.202 Y136.56 E.00541
G1 X95.202 Y119.463 E.54395
G1 X95.288 Y119.251 E.0073
G1 X95.452 Y119.202 E.00545
G1 X116.526 Y119.202 E.67051
G1 X116.67 Y119.247 E.0048
M204 S250
G1 X117.008 Y118.981 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.013 Y118.985 E.00019
G1 X117.152 Y119.202 E.00761
G1 X117.189 Y119.451 E.00741
G1 X117.19 Y136.505 E.50262
G1 X117.132 Y136.845 E.01017
G3 X116.886 Y137.102 I-.83 J-.548 E.01055
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01017
G1 X94.955 Y136.98 E.0074
G3 X94.81 Y136.587 I.838 J-.532 E.01245
G1 X94.81 Y119.495 E.50373
G1 X94.868 Y119.155 E.01017
G3 X95.114 Y118.898 I.83 J.547 E.01055
G1 X95.417 Y118.81 E.0093
G1 X116.526 Y118.81 E.62211
G1 X116.824 Y118.858 E.00889
G1 X116.958 Y118.948 E.00476
; WIPE_START
M204 S3000
G1 X117.013 Y118.985 E-.02521
G1 X117.152 Y119.202 E-.09813
G1 X117.189 Y119.451 E-.0956
G1 X117.189 Y120.875 E-.54106
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.906 Y125.207 Z5 F12000
G1 X96.117 Y135.403 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X114.979 Y119.997 E.55487
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.997 E.00132
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z5 F12000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z5 F12000
G1 X96.026 Y119.961 Z5
G1 Z4.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z5 F12000
G1 X116.021 Y119.961 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.42148
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17025
G1 X115.95 Y120.002 E-.29488
G1 X116.021 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z5 F12000
G1 X116.021 Y135.957 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 23 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5 F4000
            G39.3 S1
            G0 Z5 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer23 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 24/40
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.3745
G1 F6000
M204 S3000
G1 X162.333 Y117.657 E.01215
G1 X161.976 Y117.379 E.01172
G1 X162.621 Y117.379 E.0167
G1 X162.621 Y117.967 E.01525
; WIPE_START
G1 X162.333 Y117.657 E-.16083
G1 X161.976 Y117.379 E-.17183
M73 P76 R4
G1 X162.621 Y117.379 E-.2449
G1 X162.621 Y117.859 E-.18244
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.492 Z5.2 F12000
G1 X162.621 Y137.976 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01675
G1 X161.972 Y138.621 E.01685
G1 X162.343 Y138.333 E.01219
G1 X162.584 Y138.023 E.01019
; WIPE_START
G1 X162.621 Y138.621 E-.22769
G1 X161.972 Y138.621 E-.2467
G1 X162.343 Y138.333 E-.17849
G1 X162.516 Y138.111 E-.10712
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.885 Y138.27 Z5.2 F12000
G1 X138.024 Y138.621 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01684
G1 X137.667 Y138.343 E.01218
G1 X137.977 Y138.584 E.01019
; WIPE_START
G1 X137.379 Y138.621 E-.22766
G1 X137.379 Y137.972 E-.2466
G1 X137.667 Y138.343 E-.17841
G1 X137.89 Y138.517 E-.10733
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.948 Y130.884 Z5.2 F12000
G1 X138.05 Y117.381 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.37862
G1 F6000
M204 S3000
G1 X137.663 Y117.674 E.01273
G1 X137.384 Y118.036 E.01201
G1 X137.384 Y117.381 E.01721
G1 X137.99 Y117.381 E.0159
; WIPE_START
G1 X137.663 Y117.674 E-.16684
G1 X137.384 Y118.036 E-.17393
G1 X137.384 Y117.381 E-.24925
G1 X137.831 Y117.381 E-.16999
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.464 Y117.427 Z5.2 F12000
G1 X161.439 Y117.524 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y117.577 E.00488
G1 X162.061 Y117.907 E.01847
G1 X162.334 Y118.26 E.0142
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.0179
; LINE_WIDTH: 0.43693
G1 X162.603 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.603 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.603 Y136.8 E.17261
; LINE_WIDTH: 0.44897
G1 X162.543 Y137.258 E.01463
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01104
G1 X162.093 Y138.061 E.01847
G1 X161.74 Y138.334 E.0142
G1 X161.356 Y138.511 E.01345
G1 X160.801 Y138.603 E.0179
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.603 E.66589
; LINE_WIDTH: 0.44903
G1 X138.742 Y138.543 E.01463
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01103
G1 X137.939 Y138.093 E.01848
G1 X137.666 Y137.74 E.01419
G1 X137.489 Y137.356 E.01346
G1 X137.408 Y136.971 E.01253
; LINE_WIDTH: 0.44608
G1 X137.397 Y136.801 E.00537
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43662
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43649
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43636
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43609
G1 X137.398 Y119.167 E.05019
; LINE_WIDTH: 0.45269
G1 X137.422 Y118.872 E.00949
G1 X137.639 Y118.303 E.0195
; LINE_WIDTH: 0.44999
G1 X137.91 Y117.952 E.01413
G1 X138.143 Y117.745 E.00991
G1 X138.508 Y117.539 E.01334
G1 X138.958 Y117.41 E.01488
; LINE_WIDTH: 0.44783
G1 X139.128 Y117.4 E.0054
; LINE_WIDTH: 0.43889
G1 X141.128 Y117.399 E.0619
; LINE_WIDTH: 0.43871
G1 X143.128 Y117.399 E.06187
; LINE_WIDTH: 0.43853
G1 X145.128 Y117.399 E.06184
; LINE_WIDTH: 0.43836
G1 X147.128 Y117.399 E.06182
; LINE_WIDTH: 0.43818
G1 X149.128 Y117.399 E.06179
; LINE_WIDTH: 0.43801
G1 X151.128 Y117.398 E.06176
; LINE_WIDTH: 0.43783
G1 X153.128 Y117.398 E.06173
; LINE_WIDTH: 0.43766
G1 X155.128 Y117.398 E.06171
; LINE_WIDTH: 0.43748
G1 X157.128 Y117.398 E.06168
; LINE_WIDTH: 0.43731
G1 X159.128 Y117.398 E.06165
; LINE_WIDTH: 0.43713
G1 X160.801 Y117.397 E.05153
; LINE_WIDTH: 0.44895
G1 X161.258 Y117.457 E.01463
; LINE_WIDTH: 0.44999
G1 X161.383 Y117.503 E.00424
M204 S10000
G1 X161.332 Y117.929 F12000
G1 F6000
M204 S3000
G1 X161.627 Y118.075 E.01047
G3 X162.113 Y118.732 I-1.117 J1.334 E.02625
G1 X162.202 Y119.199 E.01515
G1 X162.202 Y136.8 E.56001
G1 X162.142 Y137.186 E.01241
G1 X161.925 Y137.627 E.01564
G3 X161.268 Y138.113 I-1.334 J-1.117 E.02625
G1 X160.801 Y138.202 E.01515
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.926 E.01563
G3 X137.887 Y137.269 I1.117 J-1.335 E.02626
G1 X137.807 Y136.901 E.01197
G1 X137.799 Y119.167 E.56423
G3 X138.628 Y117.928 I1.467 J.085 E.04976
G1 X139.128 Y117.801 E.01642
G1 X160.801 Y117.798 E.68956
G1 X161.186 Y117.858 E.0124
G1 X161.278 Y117.903 E.00326
M204 S250
G1 X161.168 Y118.264 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y118.267 E.00035
G1 X161.484 Y118.462 E.01067
G1 X161.73 Y118.816 E.01271
G1 X161.81 Y119.199 E.01155
G1 X161.81 Y136.8 E.51874
G1 X161.734 Y137.179 E.01139
G1 X161.538 Y137.484 E.01067
G1 X161.184 Y137.73 E.01271
G1 X160.801 Y137.81 E.01155
G1 X139.199 Y137.81 E.63664
G1 X138.821 Y137.734 E.01139
G1 X138.516 Y137.539 E.01066
G1 X138.27 Y137.184 E.01271
G1 X138.193 Y136.833 E.0106
G1 X138.191 Y119.167 E.52065
G1 X138.23 Y118.929 E.00713
G1 X138.41 Y118.576 E.01168
G1 X138.743 Y118.303 E.01269
G1 X139.128 Y118.193 E.0118
G1 X160.801 Y118.19 E.63874
G1 X161.109 Y118.252 E.00926
; WIPE_START
M204 S3000
G1 X161.179 Y118.267 E-.02734
G1 X161.484 Y118.462 E-.13756
G1 X161.73 Y118.816 E-.16386
G1 X161.81 Y119.199 E-.14887
G1 X161.81 Y119.942 E-.28236
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.259 Y127.562 Z5.2 F12000
G1 X162.928 Y138.925 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.712 Y138.991 E.00717
G2 X160.801 Y138.997 I-.652 J91.536 E.06082
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.997 E.66589
; LINE_WIDTH: 0.44656
G1 X138.991 Y138.993 E.00659
; LINE_WIDTH: 0.44999
G2 X137.301 Y138.991 I-1.201 J352.176 E.05375
G1 X137.079 Y138.932 E.00733
G1 X137.009 Y138.722 E.00702
G2 X137.003 Y136.801 I-90.943 J-.672 E.06114
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43662
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43649
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43636
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43609
G1 X137.005 Y119.167 E.05019
; LINE_WIDTH: 0.45269
G2 X137.013 Y118.166 I-18.031 J-.63 E.03209
; LINE_WIDTH: 0.44999
G1 X137.013 Y117.258 E.02889
G1 X137.064 Y117.084 E.00576
G1 X137.249 Y117.009 E.00634
G2 X139.128 Y117.004 I.593 J-118.493 E.0598
; LINE_WIDTH: 0.43889
G1 X141.128 Y117.004 E.0619
; LINE_WIDTH: 0.43871
G1 X143.128 Y117.004 E.06187
; LINE_WIDTH: 0.43853
G1 X145.128 Y117.004 E.06184
; LINE_WIDTH: 0.43836
G1 X147.128 Y117.004 E.06182
; LINE_WIDTH: 0.43818
G1 X149.128 Y117.003 E.06179
; LINE_WIDTH: 0.43801
G1 X151.128 Y117.003 E.06176
; LINE_WIDTH: 0.43783
G1 X153.128 Y117.003 E.06173
; LINE_WIDTH: 0.43766
G1 X155.128 Y117.003 E.06171
; LINE_WIDTH: 0.43748
G1 X157.128 Y117.003 E.06168
; LINE_WIDTH: 0.43731
G1 X159.128 Y117.003 E.06165
; LINE_WIDTH: 0.43713
G1 X160.801 Y117.003 E.05153
; LINE_WIDTH: 0.44626
G1 X161.01 Y117.008 E.0066
; LINE_WIDTH: 0.44999
G2 X162.701 Y117.01 I1.219 J-329.211 E.05379
G1 X162.908 Y117.059 E.00677
G1 X162.99 Y117.221 E.00576
; LINE_WIDTH: 0.45007
G2 X162.997 Y119.199 I90.974 J.685 E.06298
; LINE_WIDTH: 0.43693
G1 X162.997 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.997 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.997 Y136.8 E.17261
; LINE_WIDTH: 0.44622
G1 X162.993 Y137.009 E.00658
; LINE_WIDTH: 0.44999
G2 X162.991 Y138.722 I329.971 J1.207 E.05449
G1 X162.945 Y138.868 E.00487
M204 S10000
G1 X163.276 Y139.151 F12000
G1 F6000
M204 S3000
G1 X163.096 Y139.304 E.00751
G1 X162.748 Y139.398 E.01146
G1 X138.748 Y139.398 E.76361
G3 X137.121 Y139.378 I-.387 J-34.911 E.05179
G1 X136.849 Y139.276 E.00924
G1 X136.691 Y139.079 E.00804
G1 X136.602 Y138.754 E.01071
G1 X136.606 Y117.177 E.68654
G1 X136.701 Y116.897 E.0094
G1 X136.887 Y116.7 E.00861
G1 X137.229 Y116.602 E.01131
G1 X162.774 Y116.603 E.81279
G1 X163.106 Y116.703 E.01102
G1 X163.318 Y116.918 E.00959
G1 X163.397 Y117.221 E.00996
G1 X163.398 Y137.22 E.63634
G3 X163.376 Y138.892 I-32.959 J.405 E.05321
G1 X163.297 Y139.095 E.00692
M204 S250
G1 X163.567 Y139.414 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.4 Y139.572 E.00678
G3 X162.783 Y139.79 I-.66 J-.886 E.01958
G1 X137.301 Y139.79 E.751
G1 X136.895 Y139.739 E.01208
G1 X136.618 Y139.598 E.00914
G1 X136.421 Y139.407 E.00809
G1 X136.261 Y139.104 E.01012
G1 X136.21 Y138.785 E.00952
G1 X136.214 Y117.257 E.63446
G1 X136.287 Y116.822 E.01301
G1 X136.449 Y116.559 E.00911
G1 X136.683 Y116.359 E.00906
G3 X137.21 Y116.21 I.737 J1.599 E.0162
G1 X162.701 Y116.211 E.75128
G1 X163.18 Y116.289 E.01432
G1 X163.44 Y116.448 E.00898
G1 X163.663 Y116.719 E.01034
G3 X163.789 Y117.22 I-1.422 J.626 E.0153
G1 X163.79 Y138.685 E.63261
G1 X163.739 Y139.105 E.01247
G1 X163.605 Y139.368 E.0087
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.4 Y139.572 E-.10993
G1 X163.144 Y139.726 E-.11339
G1 X162.783 Y139.79 E-.13933
G1 X161.737 Y139.79 E-.39734
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.764 Y136.687 Z5.2 F12000
G1 X116.39 Y119.609 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.603 J.204 E.04356
; LINE_WIDTH: 0.43692
G1 X116.396 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.396 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.396 Y128.979 E.12312
; LINE_WIDTH: 0.4365
G1 X116.396 Y132.979 E.12305
; LINE_WIDTH: 0.4363
G1 X116.396 Y135.021 E.06281
; LINE_WIDTH: 0.44512
G1 X116.391 Y135.227 E.00645
; LINE_WIDTH: 0.44999
G1 X116.388 Y136.391 E.03704
G2 X115.021 Y136.397 I-.196 J104.919 E.0435
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-104.878 J-.21 E.04357
; LINE_WIDTH: 0.43721
G1 X95.603 Y133.021 E.06164
; LINE_WIDTH: 0.43706
G1 X95.603 Y131.021 E.06161
; LINE_WIDTH: 0.43692
G1 X95.604 Y129.021 E.06159
; LINE_WIDTH: 0.43678
G1 X95.604 Y127.021 E.06157
; LINE_WIDTH: 0.43664
G1 X95.604 Y125.021 E.06155
; LINE_WIDTH: 0.4365
G1 X95.604 Y123.021 E.06153
; LINE_WIDTH: 0.43636
G1 X95.604 Y121.021 E.0615
; LINE_WIDTH: 0.43622
G1 X95.604 Y120.978 E.00132
; LINE_WIDTH: 0.44999
G1 X95.612 Y119.609 E.04356
G2 X96.979 Y119.603 I.196 J-105.25 E.0435
; LINE_WIDTH: 0.43731
G1 X114.979 Y119.603 E.55487
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.603 E.00132
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.737 Y119.271 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.469 E.00659
G1 X116.796 Y136.586 E.54461
G1 X116.712 Y136.749 E.00582
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.251 Y136.712 E.0073
G1 X95.202 Y136.548 E.00545
G1 X95.204 Y119.414 E.54518
G1 X95.288 Y119.25 E.00583
G1 X95.452 Y119.202 E.00545
G1 X116.525 Y119.202 E.67048
G1 X116.68 Y119.253 E.00517
M204 S250
G1 X117.012 Y118.984 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
M73 P77 R4
G1 F3600
M204 S1500
G1 X117.016 Y118.987 E.00015
G3 X117.132 Y119.153 I-.415 J.413 E.00601
G1 X117.189 Y119.47 E.00948
G1 X117.188 Y135.469 E.47156
G3 X117.167 Y136.714 I-21.961 J.262 E.0367
G3 X116.886 Y137.102 I-.632 J-.163 E.01446
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.547 J-.829 E.01054
G1 X94.81 Y136.583 E.0093
G1 X94.812 Y120.583 E.47156
G3 X94.833 Y119.285 I22.845 J-.288 E.03826
G3 X95.114 Y118.898 I.632 J.163 E.01445
G1 X95.417 Y118.81 E.00931
G1 X116.525 Y118.81 E.62209
G1 X116.824 Y118.858 E.00892
G1 X116.962 Y118.95 E.0049
; WIPE_START
M204 S3000
G1 X117.016 Y118.987 E-.02468
G1 X117.132 Y119.153 E-.07715
G1 X117.189 Y119.47 E-.12217
G1 X117.189 Y120.88 E-.53599
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.9 Y125.204 Z5.2 F12000
G1 X96.103 Y135.376 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44614
G1 X95.997 Y135.021 E.00537
; LINE_WIDTH: 0.43721
G1 X95.997 Y133.021 E.06164
; LINE_WIDTH: 0.43706
G1 X95.997 Y131.021 E.06161
; LINE_WIDTH: 0.43692
G1 X95.997 Y129.021 E.06159
; LINE_WIDTH: 0.43678
G1 X95.998 Y127.021 E.06157
; LINE_WIDTH: 0.43664
G1 X95.998 Y125.021 E.06155
; LINE_WIDTH: 0.4365
G1 X95.998 Y123.021 E.06153
; LINE_WIDTH: 0.43636
G1 X95.998 Y121.021 E.0615
; LINE_WIDTH: 0.43622
G1 X95.998 Y120.979 E.00132
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.024
G1 X96.808 Y120.008 E.01887
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X114.979 Y119.997 E.55487
; LINE_WIDTH: 0.4372
G1 X115.021 Y119.997 E.00132
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43692
G1 X116.003 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.002 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.002 Y128.979 E.12312
; LINE_WIDTH: 0.4365
G1 X116.002 Y132.979 E.12305
; LINE_WIDTH: 0.4363
G1 X116.002 Y135.021 E.06281
; LINE_WIDTH: 0.44512
G1 X115.992 Y135.192 E.00536
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01894
G1 X115.192 Y135.992 E.01887
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02397
G1 X96.13 Y135.429 E.0104
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.978 E.44681
G1 X96.568 Y120.568 E.01416
G1 X96.878 Y120.407 E.0111
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.827 J.022 E.00457
G1 X115.432 Y135.433 E.01114
G1 X115.122 Y135.593 E.0111
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X96.979 Y135.21 E.53177
G1 X96.845 Y135.155 E.00425
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z5.2 F12000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17026
G1 X95.955 Y135.998 E-.29487
G1 X96.026 Y135.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y128.324 Z5.2 F12000
G1 X96.027 Y119.961 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00241
G1 X96.027 Y120.042 E.00241
G1 X96.051 Y120.002 E.00139
; WIPE_START
G1 X96.027 Y120.042 E-.17027
G1 X95.957 Y120.002 E-.29487
G1 X96.027 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.66 Y119.961 Z5.2 F12000
G1 X116.021 Y119.961 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.42144
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00242
G1 X116.021 Y120.043 E.00242
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y127.594 Z5.2 F12000
G1 X116.02 Y135.958 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y135.998 E.00241
G1 X116.02 Y136.039 E.00241
G1 X116.043 Y135.998 E.00139
; WIPE_START
G1 X116.02 Y136.039 E-.17027
G1 X115.949 Y135.998 E-.29487
G1 X116.02 Y135.958 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.2 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 24 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5.2 F4000
            G39.3 S1
            G0 Z5.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer24 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 25/40
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.37449
G1 F6000
M204 S3000
G1 X162.333 Y117.657 E.01215
G1 X161.976 Y117.379 E.01172
G1 X162.621 Y117.379 E.0167
G1 X162.621 Y117.967 E.01524
; WIPE_START
G1 X162.333 Y117.657 E-.16078
G1 X161.976 Y117.379 E-.1718
G1 X162.621 Y117.379 E-.24487
G1 X162.621 Y117.86 E-.18256
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.492 Z5.4 F12000
G1 X162.621 Y137.974 Z5.4
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01681
G1 X161.972 Y138.621 E.01685
G1 X162.243 Y138.416 E.00883
G1 X162.582 Y138.019 E.01354
; WIPE_START
G1 X162.621 Y138.621 E-.22921
G1 X161.972 Y138.621 E-.2467
G1 X162.243 Y138.416 E-.1293
G1 X162.508 Y138.106 E-.15479
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.877 Y138.267 Z5.4 F12000
G1 X138.024 Y138.621 Z5.4
G1 Z5
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01684
G1 X137.667 Y138.343 E.01218
G1 X137.977 Y138.584 E.01019
; WIPE_START
G1 X137.379 Y138.621 E-.22765
G1 X137.379 Y137.972 E-.24659
G1 X137.667 Y138.343 E-.1784
G1 X137.89 Y138.517 E-.10737
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.943 Y130.884 Z5.4 F12000
G1 X138.036 Y117.378 Z5.4
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.3727
G1 F6000
M204 S3000
G1 X137.665 Y117.657 E.01198
G1 X137.381 Y118.026 E.012
G1 X137.381 Y117.378 E.0167
G1 X137.976 Y117.378 E.01534
; WIPE_START
G1 X137.665 Y117.657 E-.15897
G1 X137.381 Y118.026 E-.17687
G1 X137.381 Y117.378 E-.24627
G1 X137.849 Y117.378 E-.17789
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.482 Y117.425 Z5.4 F12000
G1 X161.44 Y117.524 Z5.4
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y117.577 E.00485
G1 X162.061 Y117.907 E.01847
G1 X162.333 Y118.26 E.01418
G1 X162.511 Y118.644 E.01345
G1 X162.603 Y119.199 E.01792
; LINE_WIDTH: 0.43693
G1 X162.603 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.603 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.603 Y136.8 E.17261
; LINE_WIDTH: 0.46172
G1 X162.569 Y137.195 E.01295
G1 X162.296 Y137.799 E.02173
; LINE_WIDTH: 0.44999
G1 X162.02 Y138.121 E.01348
M73 P78 R4
G1 X161.74 Y138.334 E.01121
G1 X161.355 Y138.511 E.01346
G1 X160.801 Y138.603 E.01789
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.603 E.6659
; LINE_WIDTH: 0.44904
G1 X138.742 Y138.543 E.01463
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01102
G1 X137.939 Y138.093 E.01848
G1 X137.667 Y137.74 E.01418
G1 X137.489 Y137.356 E.01347
G1 X137.416 Y137.012 E.01119
; LINE_WIDTH: 0.44658
G1 X137.397 Y136.801 E.0067
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05017
; LINE_WIDTH: 0.45046
G1 X137.493 Y118.625 E.01754
G1 X137.655 Y118.275 E.01228
; LINE_WIDTH: 0.44999
G1 X137.93 Y117.912 E.0145
G1 X138.399 Y117.587 E.01815
G1 X138.741 Y117.458 E.01164
; LINE_WIDTH: 0.44904
G1 X139.199 Y117.397 E.01465
; LINE_WIDTH: 0.43729
G1 X147.199 Y117.397 E.2466
; LINE_WIDTH: 0.43717
G1 X155.199 Y117.397 E.24652
; LINE_WIDTH: 0.43705
G1 X160.801 Y117.397 E.17257
; LINE_WIDTH: 0.44894
G1 X161.258 Y117.457 E.01462
; LINE_WIDTH: 0.44999
G1 X161.384 Y117.504 E.00427
M204 S10000
G1 X161.333 Y117.93 F12000
G1 F6000
M204 S3000
G1 X161.627 Y118.075 E.01044
G3 X162.113 Y118.731 I-1.116 J1.333 E.02623
G1 X162.202 Y119.199 E.01517
G1 X162.202 Y136.8 E.56001
G1 X162.163 Y137.123 E.01035
G1 X161.937 Y137.607 E.017
G3 X161.268 Y138.113 I-1.313 J-1.04 E.02696
G1 X160.801 Y138.202 E.01514
G1 X139.199 Y138.202 E.6873
G1 X138.814 Y138.142 E.0124
G1 X138.373 Y137.926 E.01561
G3 X137.811 Y136.925 I.863 J-1.143 E.03758
G1 X137.798 Y136.801 E.00399
G1 X137.799 Y119.168 E.56103
G1 X137.889 Y118.72 E.01453
G1 X137.984 Y118.515 E.00721
G1 X138.224 Y118.194 E.01272
G1 X138.612 Y117.934 E.01487
G1 X139.097 Y117.807 E.01594
G1 X139.199 Y117.798 E.00327
G1 X160.801 Y117.798 E.68731
G1 X161.186 Y117.858 E.01241
G1 X161.279 Y117.903 E.00329
M204 S250
G1 X161.168 Y118.264 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y118.267 E.00033
G1 X161.484 Y118.462 E.01067
G1 X161.73 Y118.815 E.01269
G1 X161.81 Y119.199 E.01156
G1 X161.81 Y136.8 E.51874
G1 X161.757 Y137.112 E.00931
G1 X161.538 Y137.484 E.01272
G1 X161.184 Y137.73 E.01272
G1 X160.801 Y137.81 E.01154
G1 X139.199 Y137.81 E.63664
G1 X138.821 Y137.734 E.01137
G1 X138.516 Y137.539 E.01065
G1 X138.27 Y137.184 E.01272
G1 X138.194 Y136.841 E.01036
G1 X138.191 Y119.168 E.52087
G1 X138.302 Y118.745 E.01288
G1 X138.544 Y118.436 E.01158
G1 X138.882 Y118.244 E.01147
G1 X139.199 Y118.19 E.00947
G1 X160.801 Y118.19 E.63666
G1 X161.11 Y118.252 E.00928
; WIPE_START
M204 S3000
G1 X161.179 Y118.267 E-.02704
G1 X161.484 Y118.462 E-.13755
G1 X161.73 Y118.815 E-.16368
G1 X161.81 Y119.199 E-.14909
G1 X161.81 Y119.943 E-.28264
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.26 Y127.562 Z5.4 F12000
G1 X162.93 Y138.924 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.712 Y138.991 E.00725
G2 X160.801 Y138.997 I-.652 J91.353 E.06083
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.997 E.6659
; LINE_WIDTH: 0.44659
G1 X138.99 Y138.993 E.0066
; LINE_WIDTH: 0.44999
G2 X137.304 Y138.991 I-1.206 J360.42 E.05365
G1 X137.076 Y138.93 E.0075
G1 X137.009 Y138.712 E.00725
G2 X137.003 Y136.801 I-90.419 J-.667 E.06083
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05018
; LINE_WIDTH: 0.45046
G2 X137.013 Y118.066 I-43.876 J-.837 E.03508
; LINE_WIDTH: 0.44999
G1 X137.013 Y117.234 E.02647
G1 X137.09 Y117.062 E.00603
G1 X137.268 Y117.009 E.0059
G2 X139.199 Y117.003 I.489 J-146.142 E.06144
; LINE_WIDTH: 0.43729
G1 X147.199 Y117.003 E.2466
; LINE_WIDTH: 0.43717
G1 X155.199 Y117.003 E.24652
; LINE_WIDTH: 0.43705
G1 X160.801 Y117.003 E.17257
; LINE_WIDTH: 0.44625
G1 X161.01 Y117.008 E.00659
; LINE_WIDTH: 0.44999
G2 X162.702 Y117.01 I1.22 J-329.416 E.05383
G1 X162.893 Y117.05 E.00622
G1 X162.99 Y117.215 E.00609
; LINE_WIDTH: 0.45008
G2 X162.997 Y119.199 I91.352 J.687 E.06315
; LINE_WIDTH: 0.43693
G1 X162.997 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.997 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.997 Y136.8 E.17261
; LINE_WIDTH: 0.46172
G2 X162.991 Y137.973 I16.156 J.673 E.0384
; LINE_WIDTH: 0.44999
G1 X162.991 Y138.696 E.023
G1 X162.946 Y138.866 E.00559
M204 S10000
G1 X163.276 Y139.152 F12000
G1 F6000
M204 S3000
G1 X163.092 Y139.305 E.00761
G1 X162.748 Y139.398 E.01133
G1 X138.748 Y139.398 E.76361
G3 X137.1 Y139.374 I-.387 J-30.181 E.05245
G1 X136.848 Y139.276 E.00861
G1 X136.695 Y139.092 E.00761
G1 X136.602 Y138.748 E.01133
G1 X136.606 Y117.283 E.68295
G1 X136.668 Y116.942 E.01104
G1 X136.896 Y116.693 E.01074
G1 X137.24 Y116.602 E.01133
G1 X162.776 Y116.603 E.81247
G1 X163.106 Y116.703 E.01098
G1 X163.317 Y116.917 E.00956
G1 X163.397 Y117.215 E.00983
G1 X163.398 Y137.215 E.63634
G3 X163.374 Y138.9 I-32.733 J.381 E.0536
G1 X163.298 Y139.096 E.00671
M204 S250
G1 X163.567 Y139.415 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.408 Y139.568 E.00651
G3 X163.144 Y139.726 I-.676 J-.834 E.0091
G1 X162.783 Y139.79 E.01079
G1 X137.315 Y139.79 E.75061
G1 X136.887 Y139.737 E.01269
G3 X136.274 Y139.144 I.379 J-1.005 E.02585
G1 X136.21 Y138.783 E.0108
G1 X136.214 Y117.283 E.63365
G3 X136.378 Y116.668 I1.275 J.012 E.01898
G1 X136.545 Y116.477 E.00746
G1 X136.813 Y116.301 E.00946
G1 X137.213 Y116.21 E.0121
G1 X162.702 Y116.211 E.75121
G1 X163.18 Y116.289 E.01428
G1 X163.44 Y116.448 E.00898
G1 X163.662 Y116.719 E.01033
G3 X163.789 Y117.215 I-1.468 J.639 E.01516
G1 X163.79 Y138.685 E.63277
G1 X163.737 Y139.112 E.01269
G3 X163.601 Y139.365 I-1.005 J-.379 E.00849
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.408 Y139.568 E-.10632
G1 X163.144 Y139.726 E-.11696
G1 X162.783 Y139.79 E-.13917
G1 X161.737 Y139.79 E-.39756
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.764 Y136.687 Z5.4 F12000
G1 X116.39 Y119.609 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.465 J.191 E.04356
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-104.471 J-.212 E.04357
; LINE_WIDTH: 0.43721
G1 X95.603 Y133.021 E.06164
; LINE_WIDTH: 0.43706
G1 X95.603 Y131.021 E.06161
; LINE_WIDTH: 0.43692
G1 X95.604 Y129.021 E.06159
; LINE_WIDTH: 0.43678
G1 X95.604 Y127.021 E.06157
; LINE_WIDTH: 0.43664
G1 X95.604 Y125.021 E.06155
; LINE_WIDTH: 0.4365
G1 X95.604 Y123.021 E.06153
; LINE_WIDTH: 0.43636
G1 X95.604 Y121.021 E.0615
; LINE_WIDTH: 0.43622
G1 X95.604 Y120.978 E.00132
; LINE_WIDTH: 0.44999
G1 X95.612 Y119.609 E.04356
G2 X96.979 Y119.603 I.196 J-105.25 E.0435
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.603 E.55619
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.727 Y119.265 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.451 E.00632
G1 X116.798 Y136.537 E.54362
G1 X116.72 Y136.74 E.00694
G1 X116.56 Y136.798 E.00541
G1 X95.463 Y136.798 E.67123
G1 X95.26 Y136.719 E.00694
G1 X95.202 Y136.559 E.00541
G1 X95.204 Y119.414 E.54553
G1 X95.28 Y119.26 E.00545
G1 X95.44 Y119.202 E.00541
G1 X116.524 Y119.202 E.67084
G1 X116.67 Y119.247 E.00484
M204 S250
G1 X117.01 Y118.982 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.013 Y118.984 E.00011
G1 X117.152 Y119.202 E.00761
G1 X117.189 Y119.451 E.00741
G1 X117.19 Y136.505 E.50263
G1 X117.132 Y136.845 E.01018
G1 X116.98 Y137.045 E.00739
G3 X116.587 Y137.19 I-.532 J-.838 E.01245
G1 X95.495 Y137.19 E.62162
G1 X95.155 Y137.132 E.01017
G1 X94.955 Y136.98 E.00741
G3 X94.81 Y136.586 I.837 J-.531 E.01246
G1 X94.812 Y119.455 E.50489
G1 X94.866 Y119.158 E.0089
G1 X95.02 Y118.955 E.0075
G3 X95.413 Y118.81 I.538 J.853 E.01246
G1 X116.524 Y118.81 E.62219
G1 X116.824 Y118.858 E.00894
G1 X116.96 Y118.949 E.00483
; WIPE_START
M204 S3000
G1 X117.013 Y118.984 E-.02416
G1 X117.152 Y119.202 E-.09817
G1 X117.189 Y119.451 E-.09549
G1 X117.189 Y120.877 E-.54218
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.901 Y125.202 Z5.4 F12000
G1 X96.104 Y135.379 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00669
; LINE_WIDTH: 0.44614
G1 X95.997 Y135.021 E.00537
; LINE_WIDTH: 0.43721
G1 X95.997 Y133.021 E.06164
; LINE_WIDTH: 0.43706
G1 X95.997 Y131.021 E.06161
; LINE_WIDTH: 0.43692
G1 X95.997 Y129.021 E.06159
; LINE_WIDTH: 0.43678
G1 X95.998 Y127.021 E.06157
; LINE_WIDTH: 0.43664
G1 X95.998 Y125.021 E.06155
; LINE_WIDTH: 0.4365
G1 X95.998 Y123.021 E.06153
; LINE_WIDTH: 0.43636
G1 X95.998 Y121.021 E.0615
; LINE_WIDTH: 0.43622
G1 X95.998 Y120.979 E.00132
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.024
G1 X96.808 Y120.008 E.01887
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.997 E.55619
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02397
G1 X96.132 Y135.432 E.01031
M204 S10000
G1 X96.026 Y135.957 F12000
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
M204 S10000
G1 X96.448 Y135.202 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
M73 P79 R4
G1 X96.407 Y135.122 E.00288
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.978 E.44681
G1 X96.568 Y120.568 E.01416
G1 X96.878 Y120.407 E.0111
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.476 Y135.255 E.00634
M204 S250
G1 X96.791 Y135.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y135.021 E.00008
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.814 Y135.08 E.0024
; WIPE_START
M204 S3000
G1 X96.79 Y135.021 E-.02388
G1 X96.79 Y133.084 E-.73612
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.347 Y125.465 Z5.4 F12000
G1 X96.027 Y119.961 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00241
G1 X96.027 Y120.042 E.00241
G1 X96.051 Y120.002 E.00139
; WIPE_START
G1 X96.027 Y120.042 E-.17027
G1 X95.957 Y120.002 E-.29487
G1 X96.027 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.66 Y119.961 Z5.4 F12000
G1 X116.021 Y119.961 Z5.4
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.4215
M73 P79 R3
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17025
G1 X115.95 Y120.002 E-.29488
G1 X116.021 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z5.4 F12000
G1 X116.021 Y135.957 Z5.4
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.4 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 25 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5.4 F4000
            G39.3 S1
            G0 Z5.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer25 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 26/40
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.37449
G1 F6000
M204 S3000
G1 X162.416 Y117.757 E.0088
G1 X161.974 Y117.379 E.01505
G1 X162.621 Y117.379 E.01676
G1 X162.621 Y117.967 E.01524
; WIPE_START
G1 X162.416 Y117.757 E-.11171
G1 X161.974 Y117.379 E-.22075
G1 X162.621 Y117.379 E-.2457
G1 X162.621 Y117.858 E-.18184
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.49 Z5.6 F12000
G1 X162.621 Y137.976 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01675
G1 X161.972 Y138.621 E.01685
G1 X162.343 Y138.333 E.01219
G1 X162.584 Y138.023 E.01019
; WIPE_START
G1 X162.621 Y138.621 E-.22769
G1 X161.972 Y138.621 E-.24664
G1 X162.343 Y138.333 E-.17845
G1 X162.516 Y138.11 E-.10722
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y138.27 Z5.6 F12000
G1 X138.024 Y138.621 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01685
G1 X137.667 Y138.343 E.01219
G1 X137.977 Y138.584 E.0102
; WIPE_START
G1 X137.379 Y138.621 E-.22775
G1 X137.379 Y137.972 E-.24667
G1 X137.667 Y138.343 E-.17845
G1 X137.889 Y138.516 E-.10713
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.94 Y130.884 Z5.6 F12000
G1 X138.03 Y117.378 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.37376
G1 F6000
M204 S3000
G1 X137.663 Y117.658 E.01193
G1 X137.378 Y118.029 E.01209
G1 X137.378 Y117.378 E.01683
G1 X137.97 Y117.378 E.0153
; WIPE_START
G1 X137.663 Y117.658 E-.15782
G1 X137.378 Y118.029 E-.1777
G1 X137.378 Y117.378 E-.24728
G1 X137.844 Y117.378 E-.17721
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.477 Y117.421 Z5.6 F12000
G1 X161.403 Y117.509 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.45803
G1 F6000
M204 S3000
G1 X161.489 Y117.538 E.00294
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.01121
G1 X162.121 Y117.979 E.01347
G1 X162.334 Y118.26 E.01119
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01791
; LINE_WIDTH: 0.43693
G1 X162.603 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.603 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.603 Y136.8 E.17261
; LINE_WIDTH: 0.44897
G1 X162.543 Y137.257 E.01463
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01104
G1 X162.093 Y138.061 E.01847
G1 X161.74 Y138.333 E.01418
G1 X161.356 Y138.511 E.01346
G1 X160.801 Y138.603 E.01792
; LINE_WIDTH: 0.43732
G1 X139.2 Y138.603 E.66589
; LINE_WIDTH: 0.44903
G1 X138.743 Y138.543 E.01463
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01105
G1 X137.939 Y138.093 E.01848
G1 X137.666 Y137.74 E.01419
G1 X137.489 Y137.356 E.01345
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43735
G1 X137.397 Y130.801 E.18498
; LINE_WIDTH: 0.43746
G1 X137.398 Y124.801 E.18503
; LINE_WIDTH: 0.43756
G1 X137.398 Y119.168 E.17375
; LINE_WIDTH: 0.45079
G1 X137.493 Y118.625 E.01756
G1 X137.655 Y118.275 E.01229
; LINE_WIDTH: 0.44999
G1 X137.929 Y117.913 E.01446
G1 X138.353 Y117.609 E.0166
G1 X138.693 Y117.473 E.01164
; LINE_WIDTH: 0.44951
G1 X139.199 Y117.397 E.01628
; LINE_WIDTH: 0.43729
G1 X147.199 Y117.397 E.2466
; LINE_WIDTH: 0.43716
G1 X155.199 Y117.397 E.24651
; LINE_WIDTH: 0.43704
G1 X160.8 Y117.397 E.17254
; LINE_WIDTH: 0.45803
G3 X161.159 Y117.427 I.06 J1.457 E.0117
G1 X161.346 Y117.49 E.0064
M204 S10000
G1 X161.301 Y117.925 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.01069
G3 X162.113 Y118.731 I-1.039 J1.312 E.02694
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.8 E.56001
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01564
G3 X161.269 Y138.113 I-1.334 J-1.117 E.02624
G1 X160.801 Y138.202 E.01516
G1 X139.2 Y138.202 E.68728
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.925 E.01565
G3 X137.887 Y137.269 I1.116 J-1.334 E.02624
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.168 E.56103
G1 X137.889 Y118.72 E.01452
G1 X137.984 Y118.515 E.00721
G1 X138.223 Y118.195 E.0127
G1 X138.573 Y117.952 E.01354
G1 X139.086 Y117.809 E.01695
G1 X139.199 Y117.798 E.00363
G1 X160.8 Y117.798 E.68728
G1 X161.103 Y117.834 E.00968
G1 X161.247 Y117.9 E.00504
M204 S250
G1 X161.147 Y118.264 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.462 E.01152
G1 X161.73 Y118.816 E.0127
G1 X161.81 Y119.199 E.01155
G1 X161.81 Y136.8 E.51874
G1 X161.734 Y137.179 E.01139
G1 X161.538 Y137.484 E.01066
G1 X161.184 Y137.73 E.01271
G1 X160.801 Y137.81 E.01156
G1 X139.2 Y137.81 E.63663
G1 X138.821 Y137.734 E.01139
G1 X138.516 Y137.538 E.01067
G1 X138.27 Y137.184 E.0127
G1 X138.19 Y136.801 E.01156
G1 X138.191 Y119.168 E.51968
G1 X138.301 Y118.745 E.01287
G1 X138.541 Y118.438 E.01148
G1 X138.784 Y118.282 E.00851
G1 X139.199 Y118.19 E.01254
G1 X160.8 Y118.19 E.63663
G1 X161.093 Y118.24 E.00874
; WIPE_START
M204 S3000
G1 X161.484 Y118.462 E-.17093
G1 X161.73 Y118.816 E-.1638
G1 X161.81 Y119.199 E-.14898
G1 X161.81 Y119.927 E-.27629
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.253 Y127.546 Z5.6 F12000
G1 X162.915 Y138.933 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.732 Y138.991 E.00613
G2 X160.801 Y138.997 I-.661 J92.61 E.06145
; LINE_WIDTH: 0.43732
G1 X139.2 Y138.997 E.66589
; LINE_WIDTH: 0.44903
G1 X138.703 Y138.991 E.01576
; LINE_WIDTH: 0.44999
G3 X137.256 Y138.987 I-.259 J-165.416 E.04605
G1 X137.067 Y138.915 E.00643
G1 X137.009 Y138.732 E.00613
G2 X137.003 Y136.801 I-92.376 J-.662 E.06145
; LINE_WIDTH: 0.43735
G1 X137.003 Y130.801 E.18498
; LINE_WIDTH: 0.43746
G1 X137.003 Y124.801 E.18503
; LINE_WIDTH: 0.43756
G1 X137.003 Y119.168 E.17375
; LINE_WIDTH: 0.45079
G2 X137.009 Y117.745 I-62.287 J-.982 E.04536
; LINE_WIDTH: 0.44999
G1 X137.023 Y117.189 E.01769
G1 X137.09 Y117.067 E.00443
G1 X137.26 Y117.009 E.00571
G1 X138.647 Y117.009 E.04412
; LINE_WIDTH: 0.44951
G1 X139.199 Y117.003 E.01756
; LINE_WIDTH: 0.43729
G1 X147.199 Y117.003 E.2466
; LINE_WIDTH: 0.43716
G1 X155.199 Y117.003 E.24651
; LINE_WIDTH: 0.43704
G1 X160.8 Y117.003 E.17254
; LINE_WIDTH: 0.44256
G1 X160.963 Y117.006 E.00508
; LINE_WIDTH: 0.44999
G2 X162.703 Y117.01 I1.205 J-154.082 E.05537
G1 X162.908 Y117.059 E.00669
G1 X162.99 Y117.219 E.00572
; LINE_WIDTH: 0.45008
G2 X162.997 Y119.199 I91.114 J.685 E.06303
; LINE_WIDTH: 0.43693
G1 X162.997 Y125.199 E.18478
; LINE_WIDTH: 0.43706
M73 P80 R3
G1 X162.997 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.997 Y136.8 E.17261
; LINE_WIDTH: 0.44897
G1 X162.991 Y137.297 E.01577
; LINE_WIDTH: 0.44999
G3 X162.987 Y138.744 I-168.195 J.254 E.04605
G1 X162.937 Y138.877 E.00452
M204 S10000
G1 X163.26 Y139.17 F12000
G1 F6000
M204 S3000
G1 X163.049 Y139.328 E.00837
G1 X162.76 Y139.398 E.00948
G1 X138.76 Y139.398 E.76361
G3 X137.125 Y139.379 I-.394 J-36.027 E.05203
G1 X136.83 Y139.26 E.01011
G1 X136.673 Y139.049 E.00836
G1 X136.602 Y138.76 E.00948
G1 X136.602 Y118.76 E.63634
G3 X136.621 Y117.126 I26.523 J-.507 E.05201
G1 X136.738 Y116.835 E.00995
G1 X136.897 Y116.694 E.00679
G1 X137.235 Y116.602 E.01115
G1 X162.777 Y116.603 E.81266
G1 X163.106 Y116.703 E.01093
G1 X163.318 Y116.917 E.00959
G1 X163.397 Y117.219 E.00993
G1 X163.398 Y137.219 E.63634
G3 X163.379 Y138.875 I-36.545 J.406 E.05271
G1 X163.282 Y139.114 E.0082
M204 S250
G1 X163.561 Y139.425 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.349 Y139.621 E.00853
G1 X163.067 Y139.751 E.00915
G1 X162.787 Y139.79 E.00833
G1 X137.301 Y139.79 E.75112
G1 X136.897 Y139.74 E.01202
G1 X136.587 Y139.574 E.01034
G1 X136.379 Y139.349 E.00905
G1 X136.249 Y139.066 E.00916
G1 X136.21 Y138.787 E.00832
G1 X136.21 Y117.301 E.63323
G1 X136.26 Y116.897 E.01201
G1 X136.425 Y116.589 E.01029
G1 X136.686 Y116.357 E.01028
G3 X137.212 Y116.21 I.676 J1.404 E.01618
G1 X162.703 Y116.211 E.75129
G1 X163.18 Y116.289 E.01424
G1 X163.44 Y116.448 E.00899
G1 X163.662 Y116.719 E.01033
G3 X163.789 Y117.219 I-1.436 J.63 E.01527
G1 X163.79 Y138.699 E.63306
G1 X163.74 Y139.103 E.01202
G1 X163.594 Y139.375 E.00909
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.349 Y139.621 E-.13202
G1 X163.067 Y139.751 E-.11803
G1 X162.787 Y139.79 E-.10734
G1 X161.727 Y139.79 E-.4026
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.754 Y136.686 Z5.6 F12000
G1 X116.39 Y119.609 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.466 J.191 E.04356
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.611 E.04357
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.603 E.55619
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.735 Y119.27 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.467 E.00656
G1 X116.798 Y136.537 E.54312
G1 X116.72 Y136.74 E.00693
G1 X116.56 Y136.798 E.00541
G1 X95.463 Y136.798 E.67122
G1 X95.25 Y136.712 E.0073
G1 X95.202 Y136.548 E.00544
G1 X95.202 Y119.463 E.54359
G1 X95.28 Y119.26 E.00693
G1 X95.441 Y119.202 E.00542
G1 X116.524 Y119.202 E.67081
G1 X116.678 Y119.252 E.00515
M204 S250
G1 X117.013 Y118.985 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.016 Y118.986 E.00008
G3 X117.136 Y119.161 I-.415 J.414 E.0063
G1 X117.189 Y119.467 E.00913
G1 X117.19 Y136.505 E.50216
G1 X117.132 Y136.845 E.01017
G1 X116.98 Y137.045 E.00739
G3 X116.587 Y137.19 I-.532 J-.838 E.01246
G1 X95.495 Y137.19 E.62162
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.549 J-.831 E.01055
G1 X94.81 Y136.583 E.00929
G1 X94.81 Y119.495 E.50362
G1 X94.868 Y119.155 E.01017
G1 X95.02 Y118.955 E.00739
G3 X95.414 Y118.81 I.531 J.837 E.01247
G1 X116.524 Y118.81 E.62216
G1 X116.824 Y118.858 E.00896
G1 X116.963 Y118.951 E.00494
; WIPE_START
M204 S3000
G1 X117.016 Y118.986 E-.02387
G1 X117.136 Y119.161 E-.08079
G1 X117.189 Y119.467 E-.11774
G1 X117.189 Y120.881 E-.53761
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.905 Y125.212 Z5.6 F12000
G1 X96.117 Y135.403 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.997 E.55619
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z5.6 F12000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z5.6 F12000
G1 X96.026 Y119.961 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z5.6 F12000
G1 X116.021 Y119.961 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.42152
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17025
G1 X115.95 Y120.002 E-.29488
G1 X116.021 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z5.6 F12000
G1 X116.021 Y135.957 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
M73 P81 R3
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.6 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 26 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5.6 F4000
            G39.3 S1
            G0 Z5.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer26 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 27/40
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.37448
G1 F6000
M204 S3000
G1 X162.333 Y117.657 E.01215
G1 X161.976 Y117.379 E.01172
G1 X162.621 Y117.379 E.0167
G1 X162.621 Y117.967 E.01524
; WIPE_START
G1 X162.333 Y117.657 E-.16079
G1 X161.976 Y117.379 E-.17179
G1 X162.621 Y117.379 E-.24485
G1 X162.621 Y117.86 E-.18257
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.492 Z5.8 F12000
G1 X162.621 Y137.976 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01675
G1 X161.972 Y138.621 E.01685
G1 X162.343 Y138.333 E.01219
G1 X162.584 Y138.023 E.01019
; WIPE_START
G1 X162.621 Y138.621 E-.22766
G1 X161.972 Y138.621 E-.24665
G1 X162.343 Y138.333 E-.17846
G1 X162.516 Y138.11 E-.10723
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y138.27 Z5.8 F12000
G1 X138.024 Y138.621 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01685
G1 X137.667 Y138.343 E.01219
G1 X137.977 Y138.584 E.01019
; WIPE_START
G1 X137.379 Y138.621 E-.22765
G1 X137.379 Y137.972 E-.24667
G1 X137.667 Y138.343 E-.17848
G1 X137.889 Y138.516 E-.1072
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y130.884 Z5.8 F12000
G1 X138.035 Y117.379 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.37523
G1 F6000
M204 S3000
G1 X137.727 Y117.608 E.00996
G1 X137.383 Y118.007 E.01369
G1 X137.379 Y117.379 E.01632
G1 X137.975 Y117.379 E.01548
; WIPE_START
G1 X137.727 Y117.608 E-.12812
G1 X137.383 Y118.007 E-.2003
G1 X137.379 Y117.379 E-.23871
G1 X137.886 Y117.379 E-.19288
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.519 Y117.426 Z5.8 F12000
G1 X161.442 Y117.525 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y117.577 E.0048
G1 X162.061 Y117.907 E.01847
G1 X162.334 Y118.26 E.01419
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01791
; LINE_WIDTH: 0.43693
G1 X162.603 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.603 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.603 Y136.801 E.17262
; LINE_WIDTH: 0.44897
G1 X162.543 Y137.258 E.01463
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.583 E.01102
G1 X162.093 Y138.061 E.01848
G1 X161.74 Y138.333 E.01418
G1 X161.356 Y138.511 E.01346
G1 X160.801 Y138.603 E.01792
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.603 E.6659
; LINE_WIDTH: 0.44904
G1 X138.742 Y138.543 E.01464
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01102
G1 X137.939 Y138.093 E.01847
G1 X137.667 Y137.74 E.01419
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43735
G1 X137.397 Y130.801 E.18498
; LINE_WIDTH: 0.43746
G1 X137.398 Y124.801 E.18503
; LINE_WIDTH: 0.43756
G1 X137.398 Y119.167 E.17376
; LINE_WIDTH: 0.44863
G1 X137.447 Y118.773 E.01261
; LINE_WIDTH: 0.44999
G3 X137.71 Y118.189 I1.855 J.484 E.02047
G1 X137.958 Y117.897 E.01218
G3 X138.965 Y117.409 I1.386 J1.579 E.03604
; LINE_WIDTH: 0.44748
G1 X139.135 Y117.399 E.00539
; LINE_WIDTH: 0.43855
G1 X141.135 Y117.399 E.06185
; LINE_WIDTH: 0.4384
G1 X143.135 Y117.399 E.06182
; LINE_WIDTH: 0.43825
G1 X145.135 Y117.399 E.0618
; LINE_WIDTH: 0.4381
G1 X147.135 Y117.398 E.06178
; LINE_WIDTH: 0.43795
G1 X149.135 Y117.398 E.06175
; LINE_WIDTH: 0.4378
G1 X151.135 Y117.398 E.06173
; LINE_WIDTH: 0.43765
G1 X153.135 Y117.398 E.06171
; LINE_WIDTH: 0.4375
G1 X155.135 Y117.398 E.06168
; LINE_WIDTH: 0.43736
G1 X157.135 Y117.398 E.06166
; LINE_WIDTH: 0.43721
G1 X159.135 Y117.398 E.06164
; LINE_WIDTH: 0.43706
G1 X160.801 Y117.397 E.05131
; LINE_WIDTH: 0.44894
G1 X161.258 Y117.458 E.01463
; LINE_WIDTH: 0.44999
G1 X161.385 Y117.504 E.00432
M204 S10000
G1 X161.334 Y117.93 F12000
G1 F6000
M204 S3000
G1 X161.627 Y118.075 E.01038
G3 X162.113 Y118.732 I-1.117 J1.334 E.02625
G1 X162.202 Y119.199 E.01515
G1 X162.202 Y136.801 E.56003
G1 X162.142 Y137.186 E.01241
G1 X161.926 Y137.627 E.01562
G3 X161.269 Y138.113 I-1.334 J-1.117 E.02625
G1 X160.801 Y138.202 E.01516
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.926 E.01561
G3 X137.887 Y137.269 I1.117 J-1.335 E.02626
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.167 E.56103
G1 X137.847 Y118.844 E.0104
G1 X138.066 Y118.387 E.01612
G3 X138.664 Y117.912 I1.315 J1.042 E.02454
G1 X139.135 Y117.8 E.01539
G1 X160.801 Y117.798 E.68934
G1 X161.186 Y117.858 E.01241
G1 X161.28 Y117.904 E.00334
M204 S250
G1 X161.17 Y118.265 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y118.267 E.00029
G1 X161.484 Y118.462 E.01066
G1 X161.73 Y118.816 E.01271
G1 X161.81 Y119.199 E.01155
G1 X161.81 Y136.801 E.51876
G1 X161.734 Y137.179 E.01138
G1 X161.538 Y137.484 E.01066
G1 X161.184 Y137.73 E.01271
G1 X160.801 Y137.81 E.01156
G1 X139.199 Y137.81 E.63664
G1 X138.821 Y137.733 E.01138
G1 X138.516 Y137.539 E.01065
G1 X138.27 Y137.184 E.01272
G1 X138.19 Y136.801 E.01155
G1 X138.191 Y119.167 E.51969
G1 X138.254 Y118.855 E.00941
G1 X138.408 Y118.578 E.00933
G1 X138.772 Y118.289 E.0137
G1 X139.135 Y118.193 E.01108
G1 X160.801 Y118.19 E.63854
G1 X161.111 Y118.253 E.00933
; WIPE_START
M204 S3000
G1 X161.179 Y118.267 E-.02649
G1 X161.484 Y118.462 E-.13746
G1 X161.73 Y118.816 E-.16386
G1 X161.81 Y119.199 E-.14894
G1 X161.81 Y119.945 E-.28326
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.254 Y127.564 Z5.8 F12000
G1 X162.915 Y138.933 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.732 Y138.991 E.00612
G2 X160.801 Y138.997 I-.662 J92.403 E.06145
; LINE_WIDTH: 0.43732
G1 X139.199 Y138.997 E.6659
; LINE_WIDTH: 0.4466
G1 X138.99 Y138.993 E.0066
; LINE_WIDTH: 0.44999
G2 X137.301 Y138.991 I-1.208 J361.12 E.05373
G1 X137.078 Y138.93 E.00737
G1 X137.009 Y138.733 E.00665
G2 X137.003 Y136.801 I-92.353 J-.663 E.06148
; LINE_WIDTH: 0.43735
G1 X137.003 Y130.801 E.18498
; LINE_WIDTH: 0.43746
G1 X137.003 Y124.801 E.18503
; LINE_WIDTH: 0.43756
G1 X137.003 Y119.167 E.17376
; LINE_WIDTH: 0.44863
G1 X137.008 Y118.734 E.01375
; LINE_WIDTH: 0.44999
G3 X137.013 Y117.256 I191.039 J-.185 E.04703
G1 X137.083 Y117.067 E.00641
G1 X137.268 Y117.009 E.00616
G2 X139.135 Y117.003 I.609 J-106.949 E.0594
; LINE_WIDTH: 0.43855
G1 X141.135 Y117.003 E.06185
; LINE_WIDTH: 0.4384
G1 X143.135 Y117.003 E.06182
; LINE_WIDTH: 0.43825
G1 X145.135 Y117.003 E.0618
; LINE_WIDTH: 0.4381
G1 X147.135 Y117.003 E.06178
; LINE_WIDTH: 0.43795
G1 X149.135 Y117.003 E.06175
; LINE_WIDTH: 0.4378
G1 X151.135 Y117.003 E.06173
; LINE_WIDTH: 0.43765
G1 X153.135 Y117.003 E.06171
; LINE_WIDTH: 0.4375
G1 X155.135 Y117.003 E.06168
; LINE_WIDTH: 0.43736
G1 X157.135 Y117.003 E.06166
; LINE_WIDTH: 0.43721
G1 X159.135 Y117.003 E.06164
; LINE_WIDTH: 0.43706
G1 X160.801 Y117.003 E.05131
; LINE_WIDTH: 0.44622
G1 X161.01 Y117.008 E.0066
; LINE_WIDTH: 0.44999
G2 X162.704 Y117.01 I1.221 J-326.423 E.05391
G1 X162.893 Y117.05 E.00613
G1 X162.99 Y117.221 E.00626
; LINE_WIDTH: 0.45007
G2 X162.997 Y119.199 I90.981 J.684 E.06295
; LINE_WIDTH: 0.43693
G1 X162.997 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.997 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.997 Y136.801 E.17262
; LINE_WIDTH: 0.44897
G1 X162.991 Y137.298 E.01577
; LINE_WIDTH: 0.44999
G3 X162.987 Y138.744 I-168.867 J.253 E.04603
G1 X162.937 Y138.877 E.00452
M204 S10000
G1 X163.26 Y139.17 F12000
G1 F6000
M204 S3000
G1 X163.049 Y139.328 E.00837
G1 X162.76 Y139.398 E.00948
G1 X138.76 Y139.398 E.76361
G3 X137.123 Y139.378 I-.393 J-35.768 E.05207
G1 X136.825 Y139.257 E.01025
G1 X136.676 Y139.046 E.00823
G1 X136.602 Y138.76 E.00937
G1 X136.602 Y118.76 E.63634
G3 X136.621 Y117.125 I37.476 J-.377 E.05205
G1 X136.741 Y116.83 E.01013
G1 X136.945 Y116.676 E.00815
G1 X137.24 Y116.602 E.00967
G1 X162.779 Y116.603 E.81256
G1 X163.106 Y116.703 E.01088
G1 X163.314 Y116.912 E.00938
G1 X163.397 Y117.195 E.00938
G1 X163.398 Y137.195 E.63634
G3 X163.379 Y138.875 I-37.183 J.417 E.05347
G1 X163.282 Y139.114 E.00821
M204 S250
G1 X163.561 Y139.425 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.349 Y139.621 E.00852
G3 X162.787 Y139.79 I-.559 J-.842 E.01754
G1 X137.301 Y139.79 E.75111
G1 X136.897 Y139.74 E.01201
G1 X136.585 Y139.573 E.0104
G1 X136.403 Y139.384 E.00775
G1 X136.247 Y139.06 E.0106
G1 X136.21 Y138.787 E.00812
G1 X136.21 Y117.301 E.63323
G1 X136.26 Y116.897 E.01202
G1 X136.426 Y116.587 E.01035
G1 X136.647 Y116.382 E.0089
G1 X136.934 Y116.249 E.0093
G1 X137.213 Y116.21 E.00832
G1 X162.704 Y116.211 E.75128
G1 X163.18 Y116.289 E.0142
G1 X163.44 Y116.448 E.009
G1 X163.661 Y116.717 E.01026
G3 X163.789 Y117.195 I-2.091 J.817 E.0146
G1 X163.79 Y138.699 E.63377
G1 X163.74 Y139.103 E.01201
G1 X163.594 Y139.376 E.00911
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.349 Y139.621 E-.1319
G1 X163.067 Y139.751 E-.11798
G1 X162.787 Y139.79 E-.10736
G1 X161.727 Y139.79 E-.40276
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.754 Y136.686 Z5.8 F12000
G1 X116.39 Y119.609 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.61 J.204 E.04357
; LINE_WIDTH: 0.43692
G1 X116.396 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.396 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.396 Y126.979 E.06156
; LINE_WIDTH: 0.4366
G1 X116.396 Y130.979 E.12308
; LINE_WIDTH: 0.4364
G1 X116.396 Y132.979 E.06151
; LINE_WIDTH: 0.43629
G1 X116.396 Y134.979 E.06149
; LINE_WIDTH: 0.43619
G1 X116.396 Y135.021 E.00132
; LINE_WIDTH: 0.4451
M73 P82 R3
G1 X116.391 Y135.227 E.00645
; LINE_WIDTH: 0.44999
G1 X116.388 Y136.391 E.03704
G2 X115.021 Y136.397 I-.193 J105.494 E.0435
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-103.835 J-.223 E.04357
; LINE_WIDTH: 0.43712
G1 X95.603 Y133.021 E.06162
; LINE_WIDTH: 0.43686
G1 X95.604 Y131.021 E.06158
; LINE_WIDTH: 0.4366
G1 X95.604 Y129.021 E.06154
; LINE_WIDTH: 0.43635
G1 X95.605 Y127.021 E.0615
; LINE_WIDTH: 0.43609
G1 X95.605 Y125.021 E.06146
; LINE_WIDTH: 0.43583
G1 X95.605 Y123.021 E.06142
; LINE_WIDTH: 0.43558
G1 X95.606 Y121.021 E.06138
; LINE_WIDTH: 0.43532
G1 X95.606 Y120.978 E.00133
; LINE_WIDTH: 0.44999
G1 X95.614 Y119.609 E.04356
G2 X96.979 Y119.603 I.196 J-104.785 E.04343
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.603 E.55619
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.735 Y119.27 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.466 E.00655
G1 X116.796 Y136.586 E.54471
G1 X116.712 Y136.749 E.00582
G1 X116.548 Y136.798 E.00546
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.72 E.00694
G1 X95.202 Y136.56 E.00541
G1 X95.206 Y119.456 E.54418
G1 X95.25 Y119.285 E.00562
G1 X95.44 Y119.202 E.0066
G1 X116.523 Y119.202 E.6708
G1 X116.678 Y119.252 E.00517
M204 S250
G1 X117.014 Y118.985 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.016 Y118.986 E.00006
G3 X117.136 Y119.161 I-.415 J.414 E.00629
G1 X117.189 Y119.466 E.00914
G1 X117.188 Y135.466 E.47156
G3 X117.167 Y136.715 I-21.982 J.264 E.0368
G3 X116.886 Y137.102 I-.631 J-.163 E.01445
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01017
G1 X94.955 Y136.98 E.0074
G3 X94.81 Y136.587 I.838 J-.531 E.01245
G1 X94.814 Y119.35 E.50801
G1 X94.959 Y119.022 E.01056
G1 X95.15 Y118.885 E.0069
G1 X95.413 Y118.81 E.00808
G1 X116.523 Y118.81 E.62216
G1 X116.824 Y118.858 E.00898
G1 X116.964 Y118.952 E.00496
; WIPE_START
M204 S3000
G1 X117.016 Y118.986 E-.02355
G1 X117.136 Y119.161 E-.08067
G1 X117.189 Y119.466 E-.11783
G1 X117.189 Y120.882 E-.53796
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.904 Y125.213 Z5.8 F12000
G1 X96.117 Y135.403 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00756
; LINE_WIDTH: 0.44605
G1 X95.997 Y135.021 E.00537
; LINE_WIDTH: 0.43712
G1 X95.997 Y133.021 E.06162
; LINE_WIDTH: 0.43686
G1 X95.998 Y131.021 E.06158
; LINE_WIDTH: 0.4366
G1 X95.998 Y129.021 E.06154
; LINE_WIDTH: 0.43635
G1 X95.998 Y127.021 E.0615
; LINE_WIDTH: 0.43609
G1 X95.998 Y125.021 E.06146
; LINE_WIDTH: 0.43583
G1 X95.998 Y123.021 E.06142
; LINE_WIDTH: 0.43558
G1 X95.998 Y121.021 E.06138
; LINE_WIDTH: 0.43532
G1 X95.998 Y120.979 E.00132
; LINE_WIDTH: 0.44999
G1 X96.282 Y120.279 E.02403
G1 X96.808 Y120.008 E.01884
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.997 E.55619
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43692
G1 X116.003 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.002 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.002 Y126.979 E.06156
; LINE_WIDTH: 0.4366
G1 X116.002 Y130.979 E.12308
; LINE_WIDTH: 0.4364
G1 X116.002 Y132.979 E.06151
; LINE_WIDTH: 0.43629
G1 X116.002 Y134.979 E.06149
; LINE_WIDTH: 0.43619
G1 X116.002 Y135.021 E.00132
; LINE_WIDTH: 0.4451
G1 X115.992 Y135.192 E.00536
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01894
G1 X115.192 Y135.992 E.01887
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02397
G1 X96.144 Y135.456 E.00944
M204 S10000
G1 X96.461 Y135.226 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.978 E.45
G1 X96.569 Y120.567 E.01417
G1 X96.878 Y120.407 E.01109
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.827 J.022 E.00457
G1 X115.432 Y135.433 E.01115
G1 X115.122 Y135.593 E.0111
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.846 Y120.845 I.24 J-.021 E.0056
G1 X96.979 Y120.79 E.00424
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z5.8 F12000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42188
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17026
G1 X95.955 Y135.998 E-.29487
G1 X96.026 Y135.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y128.324 Z5.8 F12000
G1 X96.029 Y119.96 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.41948
G1 F6000
M204 S3000
G1 X95.958 Y120.001 E.0024
G1 X96.029 Y120.042 E.0024
G1 X96.052 Y120.001 E.00139
; WIPE_START
G1 X96.029 Y120.042 E-.17025
G1 X95.958 Y120.001 E-.29487
G1 X96.029 Y119.96 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.661 Y119.961 Z5.8 F12000
G1 X116.021 Y119.961 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.42146
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00242
G1 X116.021 Y120.043 E.00242
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y127.594 Z5.8 F12000
G1 X116.02 Y135.958 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y135.998 E.00241
G1 X116.02 Y136.039 E.00241
G1 X116.043 Y135.998 E.00139
; WIPE_START
G1 X116.02 Y136.039 E-.17027
G1 X115.949 Y135.998 E-.29487
G1 X116.02 Y135.958 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z5.8 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 27 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z5.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z5.8 F4000
            G39.3 S1
            G0 Z5.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer27 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 28/40
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.37446
G1 F6000
M204 S3000
G1 X162.416 Y117.757 E.0088
G1 X161.974 Y117.379 E.01506
G1 X162.621 Y117.379 E.01676
G1 X162.621 Y117.967 E.01524
; WIPE_START
G1 X162.416 Y117.757 E-.11165
G1 X161.974 Y117.379 E-.22083
G1 X162.621 Y117.379 E-.24572
G1 X162.621 Y117.858 E-.1818
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.621 Y125.49 Z6 F12000
G1 X162.621 Y137.976 Z6
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X162.621 Y138.621 E.01675
G1 X161.972 Y138.621 E.01685
G1 X162.343 Y138.333 E.01219
G1 X162.584 Y138.023 E.01019
; WIPE_START
G1 X162.621 Y138.621 E-.22769
G1 X161.972 Y138.621 E-.24667
G1 X162.343 Y138.333 E-.17846
G1 X162.516 Y138.111 E-.10719
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y138.27 Z6 F12000
G1 X138.024 Y138.621 Z6
G1 Z5.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.379 Y138.621 E.01675
G1 X137.379 Y137.972 E.01685
G1 X137.667 Y138.343 E.01219
G1 X137.977 Y138.584 E.0102
; WIPE_START
G1 X137.379 Y138.621 E-.22774
G1 X137.379 Y137.972 E-.24669
G1 X137.667 Y138.343 E-.17848
G1 X137.889 Y138.516 E-.10709
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.939 Y130.884 Z6 F12000
G1 X138.027 Y117.379 Z6
G1 Z5.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.755 Y117.585 E.00886
G1 X137.379 Y118.026 E.01503
G1 X137.379 Y117.379 E.01679
G1 X137.967 Y117.379 E.01527
; WIPE_START
G1 X137.755 Y117.585 E-.11248
G1 X137.379 Y118.026 E-.22008
G1 X137.379 Y117.379 E-.24584
G1 X137.857 Y117.379 E-.18159
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.489 Y117.421 Z6 F12000
G1 X161.405 Y117.51 Z6
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.45792
G1 F6000
M204 S3000
G1 X161.488 Y117.538 E.00284
; LINE_WIDTH: 0.44999
G1 X161.799 Y117.704 E.01123
G1 X162.121 Y117.98 E.01348
G1 X162.334 Y118.26 E.0112
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.0179
; LINE_WIDTH: 0.43693
G1 X162.603 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.603 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.603 Y136.801 E.17261
; LINE_WIDTH: 0.44897
G1 X162.543 Y137.258 E.01463
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.584 E.01105
G1 X162.093 Y138.061 E.01846
M73 P83 R3
G1 X161.74 Y138.334 E.01419
G1 X161.395 Y138.501 E.0122
G1 X160.868 Y138.601 E.01707
; LINE_WIDTH: 0.43872
G1 X158.868 Y138.601 E.06187
; LINE_WIDTH: 0.43858
G1 X156.868 Y138.601 E.06185
; LINE_WIDTH: 0.43845
G1 X154.868 Y138.601 E.06183
; LINE_WIDTH: 0.43832
G1 X152.868 Y138.601 E.06181
; LINE_WIDTH: 0.43819
G1 X150.868 Y138.602 E.06179
; LINE_WIDTH: 0.43806
G1 X148.868 Y138.602 E.06177
; LINE_WIDTH: 0.43793
G1 X146.868 Y138.602 E.06175
; LINE_WIDTH: 0.4378
G1 X144.868 Y138.602 E.06173
; LINE_WIDTH: 0.43767
G1 X142.868 Y138.602 E.06171
; LINE_WIDTH: 0.43754
G1 X140.868 Y138.603 E.06169
; LINE_WIDTH: 0.43741
G1 X139.2 Y138.603 E.05143
; LINE_WIDTH: 0.44903
G1 X138.743 Y138.543 E.01463
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01105
G1 X137.939 Y138.093 E.01848
G1 X137.666 Y137.74 E.0142
G1 X137.489 Y137.356 E.01345
G1 X137.397 Y136.801 E.0179
; LINE_WIDTH: 0.43735
G1 X137.397 Y130.801 E.18498
; LINE_WIDTH: 0.43746
G1 X137.398 Y124.801 E.18503
; LINE_WIDTH: 0.43756
G1 X137.398 Y119.168 E.17375
; LINE_WIDTH: 0.44864
G1 X137.447 Y118.773 E.01263
; LINE_WIDTH: 0.44999
G3 X137.907 Y117.939 I2.11 J.621 E.03053
G1 X138.256 Y117.669 E.01405
G1 X138.601 Y117.5 E.01219
G1 X139.132 Y117.399 E.01722
; LINE_WIDTH: 0.43869
G1 X141.132 Y117.399 E.06187
; LINE_WIDTH: 0.43852
G1 X143.132 Y117.399 E.06184
; LINE_WIDTH: 0.43836
G1 X145.132 Y117.399 E.06182
; LINE_WIDTH: 0.4382
G1 X147.132 Y117.399 E.06179
; LINE_WIDTH: 0.43804
G1 X149.132 Y117.398 E.06177
; LINE_WIDTH: 0.43787
G1 X151.132 Y117.398 E.06174
; LINE_WIDTH: 0.43771
G1 X153.132 Y117.398 E.06171
; LINE_WIDTH: 0.43755
G1 X155.132 Y117.398 E.06169
; LINE_WIDTH: 0.43739
G1 X157.132 Y117.398 E.06166
; LINE_WIDTH: 0.43722
G1 X159.132 Y117.398 E.06164
; LINE_WIDTH: 0.43706
G1 X160.8 Y117.397 E.05138
; LINE_WIDTH: 0.45792
G3 X161.158 Y117.427 I.06 J1.458 E.01168
G1 X161.348 Y117.491 E.0065
M204 S10000
G1 X161.304 Y117.926 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y118.063 E.0106
G3 X162.113 Y118.732 I-1.039 J1.312 E.02695
G1 X162.202 Y119.199 E.01515
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01242
G1 X161.925 Y137.627 E.01564
G3 X161.494 Y138.009 I-1.175 J-.892 E.01844
G1 X161.015 Y138.18 E.01619
G1 X160.868 Y138.199 E.00473
G1 X139.2 Y138.202 E.68941
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.925 E.01565
G3 X137.887 Y137.268 I1.117 J-1.334 E.02624
G1 X137.798 Y136.801 E.01515
G1 X137.799 Y119.168 E.56103
G1 X137.847 Y118.844 E.01041
G1 X138.069 Y118.382 E.01629
G1 X138.183 Y118.239 E.00583
G1 X138.502 Y117.993 E.01283
G1 X138.984 Y117.82 E.01628
G1 X139.132 Y117.801 E.00477
G1 X160.8 Y117.798 E.68941
G1 X161.102 Y117.834 E.00966
G1 X161.249 Y117.901 E.00514
M204 S250
G1 X161.149 Y118.265 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y118.462 E.01145
G1 X161.73 Y118.816 E.01271
G1 X161.81 Y119.199 E.01155
G1 X161.81 Y136.801 E.51875
G1 X161.733 Y137.179 E.01139
G1 X161.538 Y137.484 E.01066
G1 X161.192 Y137.728 E.01249
G1 X160.867 Y137.807 E.00984
G1 X139.2 Y137.81 E.6386
G1 X138.821 Y137.734 E.01139
G1 X138.516 Y137.538 E.01067
G1 X138.27 Y137.184 E.0127
G1 X138.19 Y136.801 E.01155
G1 X138.191 Y119.168 E.51968
G1 X138.254 Y118.854 E.00943
G1 X138.448 Y118.527 E.01119
G1 X138.805 Y118.273 E.01293
G1 X139.133 Y118.193 E.00993
G1 X160.8 Y118.19 E.6386
G1 X161.095 Y118.24 E.00882
; WIPE_START
M204 S3000
G1 X161.484 Y118.462 E-.16998
G1 X161.73 Y118.816 E-.16385
G1 X161.81 Y119.199 E-.14891
G1 X161.81 Y119.929 E-.27727
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.257 Y127.548 Z6 F12000
G1 X162.924 Y138.925 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.742 Y138.991 E.00617
G2 X160.868 Y138.997 I-.638 J99.223 E.05962
; LINE_WIDTH: 0.43872
G1 X158.868 Y138.997 E.06187
; LINE_WIDTH: 0.43858
G1 X156.868 Y138.997 E.06185
; LINE_WIDTH: 0.43845
G1 X154.868 Y138.997 E.06183
; LINE_WIDTH: 0.43832
G1 X152.868 Y138.997 E.06181
; LINE_WIDTH: 0.43819
G1 X150.868 Y138.997 E.06179
; LINE_WIDTH: 0.43806
G1 X148.868 Y138.997 E.06177
; LINE_WIDTH: 0.43793
G1 X146.868 Y138.997 E.06175
; LINE_WIDTH: 0.4378
G1 X144.868 Y138.997 E.06173
; LINE_WIDTH: 0.43767
G1 X142.868 Y138.997 E.06171
; LINE_WIDTH: 0.43754
G1 X140.868 Y138.997 E.06169
; LINE_WIDTH: 0.43741
G1 X139.2 Y138.997 E.05143
; LINE_WIDTH: 0.44655
G1 X138.991 Y138.993 E.00659
; LINE_WIDTH: 0.44999
G2 X137.288 Y138.991 I-1.215 J360.457 E.05418
G1 X137.074 Y138.924 E.00712
G1 X137.009 Y138.742 E.00617
G2 X137.003 Y136.801 I-93.087 J-.665 E.06176
; LINE_WIDTH: 0.43735
G1 X137.003 Y130.801 E.18498
; LINE_WIDTH: 0.43746
G1 X137.003 Y124.801 E.18503
; LINE_WIDTH: 0.43756
G1 X137.003 Y119.168 E.17375
; LINE_WIDTH: 0.44689
G1 X137.008 Y118.959 E.0066
; LINE_WIDTH: 0.44999
G2 X137.009 Y117.301 I-341.36 J-1.148 E.05274
G1 X137.07 Y117.078 E.00735
G1 X137.268 Y117.009 E.00669
G2 X139.132 Y117.004 I.636 J-98.807 E.05931
; LINE_WIDTH: 0.43869
G1 X141.132 Y117.004 E.06187
; LINE_WIDTH: 0.43852
G1 X143.132 Y117.004 E.06184
; LINE_WIDTH: 0.43836
G1 X145.132 Y117.004 E.06182
; LINE_WIDTH: 0.4382
G1 X147.132 Y117.004 E.06179
; LINE_WIDTH: 0.43804
G1 X149.132 Y117.003 E.06177
; LINE_WIDTH: 0.43787
G1 X151.132 Y117.003 E.06174
; LINE_WIDTH: 0.43771
G1 X153.132 Y117.003 E.06171
; LINE_WIDTH: 0.43755
G1 X155.132 Y117.003 E.06169
; LINE_WIDTH: 0.43739
G1 X157.132 Y117.003 E.06166
; LINE_WIDTH: 0.43722
G1 X159.132 Y117.003 E.06164
; LINE_WIDTH: 0.43706
G1 X160.8 Y117.003 E.05138
; LINE_WIDTH: 0.4425
G1 X160.963 Y117.006 E.00507
; LINE_WIDTH: 0.44999
G2 X162.706 Y117.01 I1.206 J-152.659 E.05546
G1 X162.907 Y117.059 E.00658
G1 X162.99 Y117.218 E.00571
; LINE_WIDTH: 0.45007
G2 X162.997 Y119.199 I91.132 J.686 E.06307
; LINE_WIDTH: 0.43693
G1 X162.997 Y125.199 E.18478
; LINE_WIDTH: 0.43706
G1 X162.997 Y131.199 E.18484
; LINE_WIDTH: 0.43719
G1 X162.997 Y136.801 E.17261
; LINE_WIDTH: 0.44622
G1 X162.993 Y137.009 E.00659
; LINE_WIDTH: 0.44999
G2 X162.991 Y138.712 I328.057 J1.202 E.05417
G1 X162.942 Y138.868 E.00521
M204 S10000
G1 X163.264 Y139.166 F12000
G1 F6000
M204 S3000
G1 X163.048 Y139.324 E.00852
G1 X162.765 Y139.398 E.00929
G1 X138.765 Y139.398 E.76361
G3 X137.081 Y139.367 I-.397 J-24.643 E.05361
G1 X136.834 Y139.264 E.00852
G1 X136.676 Y139.048 E.00852
G1 X136.602 Y138.766 E.00929
G1 X136.602 Y118.766 E.63634
G3 X136.62 Y117.133 I39.382 J-.384 E.05196
G1 X136.743 Y116.825 E.01054
G1 X136.954 Y116.675 E.00823
G1 X137.24 Y116.602 E.0094
G1 X162.78 Y116.603 E.8126
G1 X163.105 Y116.703 E.01081
G1 X163.319 Y116.92 E.00969
G1 X163.397 Y117.218 E.0098
G1 X163.398 Y137.218 E.63634
G3 X163.367 Y138.919 I-24.879 J.406 E.05415
G1 X163.287 Y139.11 E.00661
M204 S250
G1 X163.562 Y139.424 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.35 Y139.62 E.00851
G1 X163.025 Y139.762 E.01045
G1 X162.789 Y139.79 E.00702
G1 X137.315 Y139.79 E.75076
G1 X136.856 Y139.726 E.01365
G1 X136.589 Y139.576 E.00905
G1 X136.38 Y139.35 E.00905
G1 X136.238 Y139.025 E.01045
G1 X136.21 Y138.789 E.00702
G1 X136.21 Y117.301 E.63328
G1 X136.26 Y116.897 E.01201
G1 X136.427 Y116.586 E.0104
G1 X136.616 Y116.403 E.00775
G1 X136.935 Y116.248 E.01046
G1 X137.213 Y116.21 E.00827
G1 X162.706 Y116.211 E.75132
G1 X163.18 Y116.289 E.01416
G1 X163.44 Y116.448 E.00899
G1 X163.664 Y116.722 E.01044
G3 X163.789 Y117.217 I-1.498 J.642 E.01512
G1 X163.79 Y138.685 E.63269
G1 X163.726 Y139.144 E.01366
G1 X163.596 Y139.375 E.00781
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.35 Y139.62 E-.13189
G1 X163.025 Y139.762 E-.13478
G1 X162.789 Y139.79 E-.09049
G1 X161.728 Y139.79 E-.40284
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.756 Y136.686 Z6 F12000
G1 X116.39 Y119.609 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.472 J.191 E.04357
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.611 E.04357
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.603 E.55619
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.735 Y119.27 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.467 E.00656
G1 X116.798 Y136.537 E.5431
G1 X116.72 Y136.74 E.00693
G1 X116.56 Y136.798 E.00541
G1 X95.463 Y136.798 E.67123
G1 X95.251 Y136.712 E.0073
G1 X95.202 Y136.548 E.00545
G1 X95.202 Y119.463 E.54359
G1 X95.28 Y119.26 E.00694
G1 X95.441 Y119.202 E.00542
G1 X116.523 Y119.202 E.67077
G1 X116.678 Y119.252 E.0052
M204 S250
G1 X117.015 Y118.986 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.016 Y118.986 E.00004
G3 X117.135 Y119.16 I-.415 J.413 E.00626
G1 X117.189 Y119.467 E.00918
G1 X117.19 Y136.505 E.50214
G1 X117.132 Y136.845 E.01018
G1 X116.98 Y137.045 E.00738
G3 X116.587 Y137.19 I-.532 J-.838 E.01246
G1 X95.495 Y137.19 E.62162
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.548 J-.831 E.01054
G1 X94.81 Y136.583 E.0093
G1 X94.81 Y119.495 E.50362
G1 X94.868 Y119.155 E.01018
G1 X95.02 Y118.955 E.00739
G3 X95.414 Y118.81 I.531 J.837 E.01246
G1 X116.523 Y118.81 E.62213
G1 X116.824 Y118.858 E.00899
G1 X116.965 Y118.952 E.00499
; WIPE_START
M204 S3000
G1 X117.016 Y118.986 E-.0233
G1 X117.135 Y119.16 E-.08022
G1 X117.189 Y119.467 E-.11839
G1 X117.189 Y120.883 E-.5381
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.904 Y125.214 Z6 F12000
G1 X96.117 Y135.403 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
M73 P84 R3
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.997 E.55619
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01414
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z6 F12000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z6 F12000
G1 X96.026 Y119.961 Z6
G1 Z5.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z6 F12000
G1 X116.021 Y119.961 Z6
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.42152
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17025
G1 X115.95 Y120.002 E-.29488
G1 X116.021 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z6 F12000
G1 X116.021 Y135.957 Z6
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
M73 P84 R2
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z6 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 28 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6 F4000
            G39.3 S1
            G0 Z6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer28 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 29/40
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.621 Y118.027 F12000
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.37444
G1 F6000
M204 S3000
G1 X162.333 Y117.657 E.01215
G1 X161.976 Y117.379 E.01171
G1 X162.621 Y117.379 E.01669
G1 X162.621 Y117.967 E.01523
; WIPE_START
G1 X162.333 Y117.657 E-.16072
G1 X161.976 Y117.379 E-.17176
G1 X162.621 Y117.379 E-.24483
G1 X162.621 Y117.86 E-.18269
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.62 Y125.493 Z6.2 F12000
G1 X162.618 Y137.98 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.618 Y138.622 E.01661
G1 X161.971 Y138.622 E.01675
G1 X162.341 Y138.334 E.01213
G1 X162.581 Y138.027 E.01009
; WIPE_START
G1 X162.618 Y138.622 E-.22636
G1 X161.971 Y138.622 E-.24602
G1 X162.341 Y138.334 E-.1781
G1 X162.519 Y138.107 E-.10952
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y138.266 Z6.2 F12000
G1 X138.02 Y138.618 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X137.378 Y138.618 E.01661
G1 X137.378 Y137.971 E.01675
G1 X137.666 Y138.341 E.01213
G1 X137.973 Y138.581 E.01009
; WIPE_START
G1 X137.378 Y138.618 E-.22636
G1 X137.378 Y137.971 E-.24599
G1 X137.666 Y138.341 E-.17808
G1 X137.893 Y138.519 E-.10958
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y130.886 Z6.2 F12000
G1 X138.029 Y117.378 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.37392
G1 F6000
M204 S3000
G1 X137.758 Y117.583 E.00878
G1 X137.382 Y118.022 E.01497
G1 X137.382 Y117.378 E.01666
G1 X137.969 Y117.378 E.0152
; WIPE_START
G1 X137.758 Y117.583 E-.11167
G1 X137.382 Y118.022 E-.21987
G1 X137.382 Y117.378 E-.24468
G1 X137.865 Y117.378 E-.18378
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.498 Y117.426 Z6.2 F12000
G1 X161.443 Y117.525 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y117.577 E.00476
G1 X162.061 Y117.907 E.01847
G1 X162.334 Y118.26 E.01419
G1 X162.511 Y118.644 E.01346
G1 X162.603 Y119.199 E.01791
; LINE_WIDTH: 0.43672
G1 X162.602 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.602 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.602 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.602 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.602 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.602 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.602 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.602 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.602 Y136.8 E.04915
; LINE_WIDTH: 0.44852
G1 X162.542 Y137.258 E.01462
; LINE_WIDTH: 0.44999
G1 X162.423 Y137.584 E.01105
G1 X162.092 Y138.062 E.01851
G1 X161.74 Y138.334 E.01414
G1 X161.356 Y138.511 E.01345
G1 X160.801 Y138.603 E.0179
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.603 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.603 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.603 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.602 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.602 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.602 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.602 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.602 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.602 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.602 E.06143
; LINE_WIDTH: 0.43575
G1 X139.2 Y138.602 E.04916
; LINE_WIDTH: 0.44856
G1 X138.742 Y138.542 E.01462
; LINE_WIDTH: 0.44999
G1 X138.417 Y138.423 E.01104
G1 X137.938 Y138.092 E.01852
G1 X137.666 Y137.74 E.01413
G1 X137.489 Y137.356 E.01346
G1 X137.397 Y136.801 E.01791
; LINE_WIDTH: 0.43715
G1 X137.397 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.398 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.398 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.398 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.398 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.398 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.398 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.398 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.399 Y119.168 E.05017
; LINE_WIDTH: 0.4479
G1 X137.448 Y118.773 E.01261
; LINE_WIDTH: 0.44999
G3 X138.26 Y117.666 I1.783 J.458 E.04475
G1 X138.643 Y117.49 E.01343
G1 X139.199 Y117.397 E.01793
; LINE_WIDTH: 0.43729
G1 X145.199 Y117.397 E.18495
; LINE_WIDTH: 0.43718
G1 X153.199 Y117.397 E.24653
; LINE_WIDTH: 0.43705
G1 X159.199 Y117.397 E.18483
; LINE_WIDTH: 0.43694
G1 X160.8 Y117.397 E.04931
; LINE_WIDTH: 0.44892
G1 X161.258 Y117.457 E.01463
; LINE_WIDTH: 0.44999
G1 X161.386 Y117.505 E.00437
M204 S10000
G1 X161.336 Y117.931 F12000
M73 P85 R2
G1 F6000
M204 S3000
G1 X161.627 Y118.075 E.01034
G3 X162.113 Y118.731 I-1.117 J1.334 E.02624
G1 X162.202 Y119.199 E.01516
G1 X162.202 Y136.801 E.56002
G1 X162.142 Y137.186 E.01242
G1 X161.925 Y137.627 E.01564
G3 X161.268 Y138.113 I-1.335 J-1.118 E.02624
G1 X160.801 Y138.202 E.01515
G1 X139.199 Y138.202 E.68729
G1 X138.814 Y138.142 E.01241
G1 X138.373 Y137.926 E.01564
G1 X138.238 Y137.817 E.00551
G1 X137.991 Y137.494 E.01292
G1 X137.887 Y137.269 E.00791
G1 X137.798 Y136.801 E.01516
G1 X137.799 Y119.168 E.56103
G1 X137.847 Y118.844 E.01042
G1 X138.07 Y118.381 E.01635
G3 X138.731 Y117.887 I1.318 J1.075 E.0265
G1 X139.199 Y117.798 E.01517
G1 X160.8 Y117.798 E.68728
G1 X161.186 Y117.858 E.01242
G1 X161.282 Y117.905 E.00339
M204 S250
G1 X161.171 Y118.265 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y118.267 E.00025
G1 X161.484 Y118.462 E.01067
G1 X161.73 Y118.816 E.0127
G1 X161.81 Y119.199 E.01155
G1 X161.81 Y136.8 E.51874
G1 X161.733 Y137.18 E.0114
G1 X161.538 Y137.484 E.01066
G1 X161.184 Y137.73 E.01271
G1 X160.801 Y137.81 E.01155
G1 X139.2 Y137.81 E.63664
G1 X138.821 Y137.733 E.01139
G1 X138.527 Y137.552 E.01017
G1 X138.27 Y137.184 E.01323
G1 X138.19 Y136.801 E.01155
G1 X138.191 Y119.168 E.51968
G1 X138.254 Y118.854 E.00945
G1 X138.463 Y118.515 E.01172
G1 X138.815 Y118.27 E.01264
G1 X139.199 Y118.19 E.01157
G1 X160.8 Y118.19 E.63663
G1 X161.112 Y118.253 E.00938
; WIPE_START
M204 S3000
G1 X161.179 Y118.267 E-.02596
G1 X161.484 Y118.462 E-.13751
G1 X161.73 Y118.816 E-.16379
G1 X161.81 Y119.199 E-.14898
G1 X161.81 Y119.946 E-.28375
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.262 Y127.565 Z6.2 F12000
G1 X162.936 Y138.916 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.752 Y138.991 E.00634
G2 X160.801 Y138.997 I-.685 J92.314 E.06207
; LINE_WIDTH: 0.43717
G1 X158.801 Y138.997 E.06163
; LINE_WIDTH: 0.43702
G1 X156.801 Y138.997 E.06161
; LINE_WIDTH: 0.43688
G1 X154.801 Y138.996 E.06158
; LINE_WIDTH: 0.43674
G1 X152.801 Y138.996 E.06156
; LINE_WIDTH: 0.4366
G1 X150.801 Y138.996 E.06154
; LINE_WIDTH: 0.43646
G1 X148.801 Y138.996 E.06152
; LINE_WIDTH: 0.43632
G1 X146.801 Y138.995 E.0615
; LINE_WIDTH: 0.43617
G1 X144.801 Y138.995 E.06147
; LINE_WIDTH: 0.43603
G1 X142.801 Y138.995 E.06145
; LINE_WIDTH: 0.43589
G1 X140.801 Y138.995 E.06143
; LINE_WIDTH: 0.43575
G1 X139.2 Y138.995 E.04916
; LINE_WIDTH: 0.44486
G1 X138.991 Y138.99 E.00655
; LINE_WIDTH: 0.44999
G2 X137.258 Y138.987 I-1.264 J245.437 E.05513
G1 X137.083 Y138.935 E.00581
G1 X137.009 Y138.751 E.00631
G2 X137.003 Y136.801 I-92.287 J-.687 E.06206
; LINE_WIDTH: 0.43715
G1 X137.003 Y134.801 E.06163
; LINE_WIDTH: 0.43701
G1 X137.004 Y132.801 E.06161
; LINE_WIDTH: 0.43688
G1 X137.004 Y130.801 E.06158
; LINE_WIDTH: 0.43675
G1 X137.004 Y128.801 E.06156
; LINE_WIDTH: 0.43661
G1 X137.004 Y126.801 E.06154
; LINE_WIDTH: 0.43648
G1 X137.005 Y124.801 E.06152
; LINE_WIDTH: 0.43635
G1 X137.005 Y122.801 E.0615
; LINE_WIDTH: 0.43622
G1 X137.005 Y120.801 E.06148
; LINE_WIDTH: 0.43608
G1 X137.005 Y119.168 E.05017
; LINE_WIDTH: 0.4452
G1 X137.01 Y118.959 E.00656
; LINE_WIDTH: 0.44999
G2 X137.013 Y117.257 I-227.53 J-1.209 E.05415
G1 X137.064 Y117.085 E.00574
G1 X137.249 Y117.009 E.00636
G2 X139.199 Y117.003 I.674 J-93.443 E.06206
; LINE_WIDTH: 0.43729
G1 X145.199 Y117.003 E.18495
; LINE_WIDTH: 0.43718
G1 X153.199 Y117.003 E.24653
; LINE_WIDTH: 0.43705
G1 X159.199 Y117.003 E.18483
; LINE_WIDTH: 0.43694
G1 X160.8 Y117.003 E.04931
; LINE_WIDTH: 0.44616
G1 X161.009 Y117.008 E.00658
; LINE_WIDTH: 0.44999
G2 X162.706 Y117.01 I1.222 J-320.514 E.05399
G1 X162.893 Y117.05 E.00607
G1 X162.99 Y117.221 E.00626
; LINE_WIDTH: 0.45006
G2 X162.996 Y119.199 I90.008 J.698 E.06295
; LINE_WIDTH: 0.43672
G1 X162.996 Y121.199 E.06156
; LINE_WIDTH: 0.43659
G1 X162.996 Y123.199 E.06154
; LINE_WIDTH: 0.43647
G1 X162.996 Y125.199 E.06152
; LINE_WIDTH: 0.43634
G1 X162.996 Y127.199 E.0615
; LINE_WIDTH: 0.43622
G1 X162.995 Y129.199 E.06148
; LINE_WIDTH: 0.43609
G1 X162.995 Y131.199 E.06146
; LINE_WIDTH: 0.43597
G1 X162.995 Y133.199 E.06144
; LINE_WIDTH: 0.43584
G1 X162.995 Y135.199 E.06142
; LINE_WIDTH: 0.43572
G1 X162.995 Y136.8 E.04915
; LINE_WIDTH: 0.44457
G1 X162.99 Y137.009 E.00655
; LINE_WIDTH: 0.44999
G2 X162.987 Y138.742 I233.095 J1.26 E.05512
G1 X162.953 Y138.858 E.00386
M204 S10000
G1 X163.252 Y139.153 F12000
G1 F6000
M204 S3000
G1 X163.113 Y139.3 E.00642
G1 X162.771 Y139.398 E.01132
G1 X137.177 Y139.394 E.81435
G1 X136.896 Y139.298 E.00945
G1 X136.701 Y139.115 E.0085
G1 X136.602 Y138.771 E.01138
G1 X136.606 Y117.177 E.68707
G1 X136.702 Y116.896 E.00945
G1 X136.887 Y116.7 E.00858
G1 X137.229 Y116.602 E.01131
G1 X162.781 Y116.603 E.813
G1 X163.106 Y116.703 E.01081
G1 X163.314 Y116.912 E.00938
G1 X163.397 Y117.195 E.00937
G1 X163.394 Y138.823 E.68816
G1 X163.298 Y139.104 E.00944
G1 X163.293 Y139.109 E.00023
M204 S250
G1 X163.553 Y139.438 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.551 Y139.441 E.00011
G1 X163.318 Y139.641 E.00905
G3 X162.79 Y139.79 I-.741 J-1.613 E.01621
G1 X137.258 Y139.786 E.7525
G1 X136.82 Y139.712 E.01309
G1 X136.557 Y139.55 E.0091
G1 X136.36 Y139.319 E.00893
G3 X136.21 Y138.79 I1.601 J-.741 E.01628
G1 X136.214 Y117.257 E.63462
G1 X136.288 Y116.82 E.01307
G1 X136.449 Y116.559 E.00904
G1 X136.683 Y116.359 E.00907
G3 X137.21 Y116.21 I.735 J1.593 E.0162
G1 X162.706 Y116.211 E.75145
G1 X163.181 Y116.289 E.0142
G1 X163.44 Y116.448 E.00894
G1 X163.661 Y116.718 E.01028
G3 X163.789 Y117.195 I-2.085 J.815 E.01459
G1 X163.786 Y138.742 E.63503
G1 X163.712 Y139.18 E.0131
G1 X163.585 Y139.387 E.00716
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.551 Y139.441 E-.02423
G1 X163.318 Y139.641 E-.11673
G1 X163.123 Y139.717 E-.07924
G1 X162.79 Y139.79 E-.12954
G1 X161.711 Y139.79 E-.41025
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X154.738 Y136.685 Z6.2 F12000
G1 X116.39 Y119.609 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.614 J.204 E.04357
; LINE_WIDTH: 0.43692
G1 X116.396 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.396 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.396 Y128.979 E.12312
; LINE_WIDTH: 0.4365
G1 X116.396 Y132.979 E.12305
; LINE_WIDTH: 0.4363
G1 X116.396 Y135.021 E.06281
; LINE_WIDTH: 0.44512
G1 X116.391 Y135.227 E.00645
; LINE_WIDTH: 0.44999
G1 X116.388 Y136.391 E.03704
G2 X115.021 Y136.397 I-.196 J104.919 E.0435
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-104.308 J-.212 E.04357
; LINE_WIDTH: 0.43721
G1 X95.603 Y133.021 E.06164
; LINE_WIDTH: 0.43707
G1 X95.603 Y131.021 E.06161
; LINE_WIDTH: 0.43693
G1 X95.604 Y129.021 E.06159
; LINE_WIDTH: 0.43679
G1 X95.604 Y127.021 E.06157
; LINE_WIDTH: 0.43665
G1 X95.604 Y125.021 E.06155
; LINE_WIDTH: 0.43651
G1 X95.604 Y123.021 E.06153
; LINE_WIDTH: 0.43637
G1 X95.604 Y121.021 E.06151
; LINE_WIDTH: 0.43623
G1 X95.604 Y120.978 E.00132
; LINE_WIDTH: 0.44999
G1 X95.612 Y119.609 E.04357
G2 X96.979 Y119.603 I.196 J-105.252 E.0435
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.603 E.55619
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.737 Y119.271 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.47 E.0066
G1 X116.796 Y136.586 E.5446
G1 X116.72 Y136.74 E.00545
G1 X116.56 Y136.798 E.00541
G1 X95.463 Y136.798 E.67122
G1 X95.251 Y136.712 E.0073
G1 X95.202 Y136.548 E.00545
G1 X95.204 Y119.414 E.54517
G1 X95.288 Y119.25 E.00583
G1 X95.452 Y119.202 E.00545
G1 X116.522 Y119.202 E.67038
G1 X116.68 Y119.253 E.00528
M204 S250
G1 X117.016 Y118.986 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X117.132 Y119.153 I-.415 J.413 E.00601
G1 X117.189 Y119.47 E.00949
G1 X117.188 Y136.545 E.50324
G1 X117.134 Y136.842 E.00891
G1 X116.98 Y137.045 E.0075
G3 X116.587 Y137.19 I-.537 J-.851 E.01246
G1 X95.495 Y137.19 E.62162
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.548 J-.83 E.01054
G1 X94.81 Y136.583 E.0093
G1 X94.812 Y120.583 E.47156
G3 X94.833 Y119.286 I22.907 J-.288 E.03825
G3 X95.114 Y118.898 I.632 J.163 E.01447
G1 X95.417 Y118.81 E.00929
G1 X116.522 Y118.81 E.62199
G1 X116.824 Y118.858 E.00903
G3 X116.972 Y118.946 I-.223 J.541 E.00508
; WIPE_START
M204 S3000
G1 X117.132 Y119.153 E-.09939
G1 X117.189 Y119.47 E-.12232
G1 X117.189 Y120.886 E-.53829
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.899 Y125.209 Z6.2 F12000
G1 X96.103 Y135.376 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44614
G1 X95.997 Y135.021 E.00537
; LINE_WIDTH: 0.43721
G1 X95.997 Y133.021 E.06164
; LINE_WIDTH: 0.43707
G1 X95.997 Y131.021 E.06161
; LINE_WIDTH: 0.43693
G1 X95.997 Y129.021 E.06159
; LINE_WIDTH: 0.43679
G1 X95.998 Y127.021 E.06157
; LINE_WIDTH: 0.43665
G1 X95.998 Y125.021 E.06155
; LINE_WIDTH: 0.43651
G1 X95.998 Y123.021 E.06153
; LINE_WIDTH: 0.43637
G1 X95.998 Y121.021 E.06151
; LINE_WIDTH: 0.43623
G1 X95.998 Y120.979 E.00132
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.024
G1 X96.808 Y120.008 E.01887
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.997 E.55619
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43692
G1 X116.003 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.002 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.002 Y128.979 E.12312
; LINE_WIDTH: 0.4365
G1 X116.002 Y132.979 E.12305
; LINE_WIDTH: 0.4363
G1 X116.002 Y135.021 E.06281
; LINE_WIDTH: 0.44512
G1 X115.992 Y135.192 E.00536
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01894
G1 X115.192 Y135.992 E.01887
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02397
G1 X96.13 Y135.429 E.0104
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.978 E.44681
G1 X96.568 Y120.568 E.01416
G1 X96.878 Y120.407 E.0111
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.827 J.022 E.00457
G1 X115.432 Y135.433 E.01114
G1 X115.122 Y135.593 E.0111
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X96.979 Y135.21 E.53177
M73 P86 R2
G1 X96.845 Y135.155 E.00425
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z6.2 F12000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17026
G1 X95.955 Y135.998 E-.29487
G1 X96.026 Y135.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y128.324 Z6.2 F12000
G1 X96.027 Y119.961 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00241
G1 X96.027 Y120.042 E.00241
G1 X96.051 Y120.002 E.00139
; WIPE_START
G1 X96.027 Y120.042 E-.17027
G1 X95.957 Y120.002 E-.29487
G1 X96.027 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.66 Y119.961 Z6.2 F12000
G1 X116.021 Y119.961 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.42148
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17025
G1 X115.95 Y120.002 E-.29488
G1 X116.021 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y127.594 Z6.2 F12000
G1 X116.02 Y135.958 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y135.998 E.00241
G1 X116.02 Y136.039 E.00241
G1 X116.043 Y135.998 E.00139
; WIPE_START
G1 X116.02 Y136.039 E-.17027
G1 X115.949 Y135.998 E-.29487
G1 X116.02 Y135.958 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z6.2 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 29 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6.2 F4000
            G39.3 S1
            G0 Z6.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer29 end: 47,58
M625
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 30/40
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X163.559 Y139.425 F12000
G1 Z6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.44 Y139.531 E.00467
G3 X163.182 Y139.701 I-1.074 J-1.345 E.00912
G1 X162.787 Y139.79 E.01195
G1 X137.301 Y139.79 E.75111
G1 X136.897 Y139.74 E.01202
G1 X136.589 Y139.575 E.01027
G3 X136.299 Y139.183 I1.23 J-1.213 E.01444
G1 X136.21 Y138.787 E.01196
G1 X136.214 Y117.267 E.63423
G1 X136.304 Y116.785 E.01446
G1 X136.476 Y116.528 E.00911
G1 X136.809 Y116.302 E.01187
G1 X137.213 Y116.21 E.01221
G1 X162.708 Y116.211 E.75139
G1 X163.18 Y116.289 E.01409
G1 X163.44 Y116.448 E.00899
G1 X163.663 Y116.72 E.01035
G3 X163.789 Y117.216 I-1.466 J.638 E.01515
G1 X163.79 Y138.685 E.63275
G1 X163.726 Y139.144 E.01366
G1 X163.594 Y139.378 E.00791
; WIPE_START
M204 S3000
G1 X163.44 Y139.531 E-.0824
G1 X163.182 Y139.701 E-.11748
G1 X162.787 Y139.79 E-.15413
G1 X161.718 Y139.79 E-.40599
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.525 Y132.16 Z6.4 F12000
G1 X161.172 Y118.265 Z6.4
G1 Z6
G1 E.8 F1800
G1 F3600
M204 S1500
G1 X161.18 Y118.267 E.00023
G1 X161.484 Y118.462 E.01065
G1 X161.73 Y118.816 E.01271
G1 X161.81 Y119.199 E.01155
G1 X161.81 Y136.801 E.51876
G1 X161.757 Y137.112 E.00929
G1 X161.538 Y137.484 E.01272
G1 X161.191 Y137.729 E.01251
G1 X160.865 Y137.807 E.00991
G1 X139.199 Y137.81 E.63853
G1 X138.888 Y137.757 E.00929
G1 X138.516 Y137.538 E.01272
G1 X138.27 Y137.184 E.01271
G1 X138.19 Y136.801 E.01155
G1 X138.191 Y119.167 E.5197
G1 X138.254 Y118.854 E.00942
G1 X138.458 Y118.519 E.01158
G1 X138.775 Y118.287 E.01157
G1 X139.135 Y118.193 E.01097
G1 X160.801 Y118.19 E.63854
G1 X161.113 Y118.253 E.00939
; WIPE_START
M204 S3000
G1 X161.18 Y118.267 E-.0258
G1 X161.484 Y118.462 E-.13727
G1 X161.73 Y118.816 E-.16387
G1 X161.81 Y119.199 E-.14897
G1 X161.81 Y119.947 E-.28408
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z6.4 I1.217 J0 P1  F12000
; stop printing object, unique label id: 58
M625
; object ids of layer 30 start: 47,58
M624 AwAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6.4 F4000
            G39.3 S1
            G0 Z6.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer30 end: 47,58
M625
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X163.583 Y138.681 F12000
G1 Z6
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F3600
M204 S2000
G1 X162.681 Y139.583 E.0376
G1 X162.147 Y139.583
G1 X163.583 Y138.147 E.05983
G1 X163.583 Y137.614
G1 X161.614 Y139.583 E.08205
G1 X161.081 Y139.583
G1 X163.583 Y137.081 E.10428
G1 X163.583 Y136.548
G1 X160.547 Y139.583 E.1265
G1 X160.014 Y139.583
G1 X163.583 Y136.014 E.14873
G1 X163.582 Y135.481
G1 X161.982 Y137.082 E.06672
G1 X162.017 Y136.513
G1 X163.582 Y134.948 E.06523
G1 X163.582 Y134.415
G1 X162.017 Y135.98 E.06523
G1 X162.017 Y135.446
G1 X163.582 Y133.881 E.06523
G1 X163.582 Y133.348
G1 X162.017 Y134.913 E.06523
G1 X162.017 Y134.38
G1 X163.582 Y132.815 E.06523
G1 X163.582 Y132.282
G1 X162.017 Y133.847 E.06523
G1 X162.017 Y133.313
G1 X163.582 Y131.748 E.06523
G1 X163.582 Y131.215
G1 X162.017 Y132.78 E.06523
G1 X162.017 Y132.247
G1 X163.582 Y130.682 E.06523
G1 X163.582 Y130.149
G1 X162.017 Y131.714 E.06523
G1 X162.017 Y131.18
G1 X163.582 Y129.616 E.06522
G1 X163.582 Y129.082
G1 X162.017 Y130.647 E.06522
G1 X162.017 Y130.114
G1 X163.582 Y128.549 E.06522
G1 X163.582 Y128.016
G1 X162.017 Y129.581 E.06522
G1 X162.017 Y129.047
G1 X163.582 Y127.483 E.06522
G1 X163.582 Y126.949
G1 X162.017 Y128.514 E.06522
G1 X162.017 Y127.981
G1 X163.582 Y126.416 E.06522
G1 X163.582 Y125.883
G1 X162.017 Y127.448 E.06522
G1 X162.017 Y126.914
G1 X163.582 Y125.35 E.06522
G1 X163.582 Y124.816
G1 X162.017 Y126.381 E.06522
G1 X162.017 Y125.848
G1 X163.582 Y124.283 E.06522
G1 X163.582 Y123.75
G1 X162.017 Y125.315 E.06521
G1 X162.017 Y124.781
G1 X163.582 Y123.217 E.06521
G1 X163.582 Y122.683
G1 X162.017 Y124.248 E.06521
G1 X162.017 Y123.715
G1 X163.582 Y122.15 E.06521
G1 X163.582 Y121.617
G1 X162.017 Y123.182 E.06521
G1 X162.017 Y122.648
G1 X163.582 Y121.084 E.06521
G1 X163.582 Y120.551
G1 X162.017 Y122.115 E.06521
G1 X162.017 Y121.582
G1 X163.582 Y120.017 E.06521
G1 X163.582 Y119.484
G1 X162.017 Y121.048 E.06521
G1 X162.017 Y120.515
M73 P87 R2
G1 X163.582 Y118.951 E.06521
G1 X163.582 Y118.418
G1 X162.017 Y119.982 E.0652
G1 X162.017 Y119.449
G1 X163.582 Y117.884 E.0652
G1 X163.582 Y117.351
G1 X161.971 Y118.962 E.06715
G1 X161.827 Y118.572
G1 X163.506 Y116.894 E.06996
G1 X163.276 Y116.591
G1 X161.585 Y118.281 E.07046
G1 X161.256 Y118.077
G1 X162.895 Y116.438 E.06829
G1 X162.382 Y116.418
G1 X160.815 Y117.985 E.06529
G1 X160.284 Y117.983
G1 X161.848 Y116.418 E.06521
G1 X161.315 Y116.418
G1 X159.751 Y117.983 E.06521
G1 X159.217 Y117.983
G1 X160.782 Y116.418 E.06521
G1 X160.249 Y116.418
G1 X158.684 Y117.983 E.06522
G1 X158.151 Y117.983
G1 X159.715 Y116.418 E.06522
G1 X159.182 Y116.418
G1 X157.617 Y117.983 E.06523
G1 X157.084 Y117.983
G1 X158.649 Y116.418 E.06523
G1 X158.116 Y116.418
G1 X156.551 Y117.983 E.06523
G1 X156.017 Y117.983
G1 X157.582 Y116.418 E.06524
G1 X157.049 Y116.418
G1 X155.484 Y117.983 E.06524
G1 X154.951 Y117.983
G1 X156.516 Y116.418 E.06524
G1 X155.983 Y116.418
G1 X154.417 Y117.983 E.06525
G1 X153.884 Y117.983
G1 X155.449 Y116.418 E.06525
G1 X154.916 Y116.418
G1 X153.351 Y117.984 E.06525
G1 X152.817 Y117.984
G1 X154.383 Y116.418 E.06526
G1 X153.85 Y116.418
G1 X152.284 Y117.984 E.06526
G1 X151.751 Y117.984
G1 X153.316 Y116.418 E.06526
G1 X152.783 Y116.418
G1 X151.217 Y117.984 E.06527
G1 X150.684 Y117.984
G1 X152.25 Y116.418 E.06527
G1 X151.717 Y116.418
G1 X150.151 Y117.984 E.06527
G1 X149.617 Y117.984
G1 X151.184 Y116.418 E.06528
G1 X150.65 Y116.418
G1 X149.084 Y117.984 E.06528
G1 X148.551 Y117.984
G1 X150.117 Y116.418 E.06528
G1 X149.584 Y116.418
G1 X148.018 Y117.984 E.06529
G1 X147.484 Y117.984
G1 X149.051 Y116.418 E.06529
G1 X148.517 Y116.418
G1 X146.951 Y117.984 E.06529
G1 X146.418 Y117.984
G1 X147.984 Y116.418 E.0653
G1 X147.451 Y116.418
G1 X145.884 Y117.984 E.0653
G1 X145.351 Y117.984
G1 X146.918 Y116.418 E.0653
G1 X146.384 Y116.418
G1 X144.818 Y117.984 E.06531
G1 X144.284 Y117.985
G1 X145.851 Y116.418 E.06531
G1 X145.318 Y116.418
G1 X143.751 Y117.985 E.06531
G1 X143.218 Y117.985
G1 X144.785 Y116.418 E.06532
G1 X144.251 Y116.418
G1 X142.684 Y117.985 E.06532
G1 X142.151 Y117.985
G1 X143.718 Y116.418 E.06532
G1 X143.185 Y116.418
G1 X141.618 Y117.985 E.06533
G1 X141.084 Y117.985
G1 X142.652 Y116.418 E.06533
G1 X142.118 Y116.418
G1 X140.551 Y117.985 E.06533
G1 X140.018 Y117.985
G1 X141.585 Y116.418 E.06534
G1 X141.052 Y116.418
G1 X139.484 Y117.985 E.06534
G1 X138.892 Y118.045
G1 X140.519 Y116.417 E.06782
; WIPE_START
M204 S3000
G1 X139.105 Y117.832 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X144.735 Y122.984 Z6.4 F12000
G1 X161.102 Y137.961 Z6.4
G1 Z6
G1 E.8 F1800
G1 F3600
M204 S2000
G1 X159.481 Y139.583 E.06758
G1 X158.948 Y139.583
G1 X160.515 Y138.015 E.06534
G1 X159.982 Y138.015
G1 X158.414 Y139.583 E.06534
G1 X157.881 Y139.583
G1 X159.449 Y138.015 E.06534
G1 X158.915 Y138.015
G1 X157.348 Y139.583 E.06534
G1 X156.815 Y139.583
G1 X158.382 Y138.015 E.06533
G1 X157.849 Y138.015
G1 X156.281 Y139.583 E.06533
G1 X155.748 Y139.583
G1 X157.316 Y138.015 E.06533
G1 X156.782 Y138.015
G1 X155.215 Y139.583 E.06533
G1 X154.682 Y139.583
G1 X156.249 Y138.015 E.06532
G1 X155.716 Y138.015
G1 X154.148 Y139.583 E.06532
G1 X153.615 Y139.583
G1 X155.182 Y138.016 E.06532
G1 X154.649 Y138.016
G1 X153.082 Y139.583 E.06532
G1 X152.549 Y139.583
G1 X154.116 Y138.016 E.06531
G1 X153.582 Y138.016
G1 X152.015 Y139.583 E.06531
G1 X151.482 Y139.583
G1 X153.049 Y138.016 E.06531
G1 X152.516 Y138.016
G1 X150.949 Y139.583 E.06531
G1 X150.416 Y139.583
G1 X151.982 Y138.016 E.0653
G1 X151.449 Y138.016
G1 X149.882 Y139.583 E.0653
G1 X149.349 Y139.583
G1 X150.916 Y138.016 E.0653
G1 X150.382 Y138.016
G1 X148.816 Y139.583 E.0653
G1 X148.283 Y139.583
G1 X149.849 Y138.016 E.06529
G1 X149.316 Y138.016
G1 X147.749 Y139.583 E.06529
G1 X147.216 Y139.583
G1 X148.782 Y138.016 E.06529
G1 X148.249 Y138.016
G1 X146.683 Y139.583 E.06529
G1 X146.15 Y139.583
G1 X147.716 Y138.016 E.06528
G1 X147.182 Y138.016
G1 X145.616 Y139.583 E.06528
G1 X145.083 Y139.583
G1 X146.649 Y138.017 E.06528
G1 X146.116 Y138.017
G1 X144.55 Y139.583 E.06527
G1 X144.016 Y139.583
G1 X145.582 Y138.017 E.06527
G1 X145.049 Y138.017
G1 X143.483 Y139.583 E.06527
G1 X142.95 Y139.583
G1 X144.516 Y138.017 E.06527
G1 X143.983 Y138.017
G1 X142.417 Y139.583 E.06526
G1 X141.883 Y139.583
G1 X143.449 Y138.017 E.06526
G1 X142.916 Y138.017
G1 X141.35 Y139.583 E.06526
G1 X140.817 Y139.583
G1 X142.383 Y138.017 E.06526
G1 X141.849 Y138.017
G1 X140.284 Y139.583 E.06525
G1 X139.75 Y139.583
G1 X141.316 Y138.017 E.06525
G1 X140.783 Y138.017
G1 X139.217 Y139.583 E.06525
G1 X138.684 Y139.583
G1 X140.249 Y138.017 E.06525
G1 X139.716 Y138.017
G1 X138.151 Y139.583 E.06524
G1 X137.617 Y139.583
G1 X139.184 Y138.016 E.06531
G1 X138.749 Y137.918
G1 X137.104 Y139.562 E.06856
G1 X136.722 Y139.411
G1 X138.412 Y137.722 E.07043
G1 X138.173 Y137.428
G1 X136.493 Y139.108 E.07002
G1 X136.417 Y138.65
G1 X138.029 Y137.038 E.06719
G1 X137.983 Y136.551
G1 X136.417 Y138.116 E.06524
G1 X136.418 Y137.583
G1 X137.983 Y136.018 E.06523
G1 X137.983 Y135.485
G1 X136.418 Y137.05 E.06523
G1 X136.418 Y136.516
G1 X137.983 Y134.951 E.06523
G1 X137.983 Y134.418
G1 X136.418 Y135.983 E.06523
G1 X136.418 Y135.45
G1 X137.983 Y133.885 E.06522
G1 X137.983 Y133.351
G1 X136.418 Y134.916 E.06522
G1 X136.418 Y134.383
G1 X137.983 Y132.818 E.06522
G1 X137.983 Y132.285
G1 X136.418 Y133.849 E.06521
G1 X136.418 Y133.316
G1 X137.983 Y131.752 E.06521
G1 X137.983 Y131.218
G1 X136.418 Y132.783 E.06521
G1 X136.418 Y132.249
G1 X137.983 Y130.685 E.0652
G1 X137.983 Y130.152
G1 X136.419 Y131.716 E.0652
G1 X136.419 Y131.183
G1 X137.983 Y129.619 E.0652
G1 X137.983 Y129.085
G1 X136.419 Y130.649 E.0652
G1 X136.419 Y130.116
G1 X137.983 Y128.552 E.06519
G1 X137.983 Y128.019
M73 P88 R2
G1 X136.419 Y129.583 E.06519
G1 X136.419 Y129.049
G1 X137.983 Y127.485 E.06519
G1 X137.983 Y126.952
G1 X136.419 Y128.516 E.06518
G1 X136.419 Y127.983
G1 X137.983 Y126.419 E.06518
G1 X137.983 Y125.886
G1 X136.419 Y127.449 E.06518
G1 X136.419 Y126.916
G1 X137.983 Y125.352 E.06517
G1 X137.983 Y124.819
G1 X136.419 Y126.383 E.06517
G1 X136.42 Y125.849
G1 X137.983 Y124.286 E.06517
G1 X137.983 Y123.752
G1 X136.42 Y125.316 E.06517
G1 X136.42 Y124.783
G1 X137.983 Y123.219 E.06516
G1 X137.983 Y122.686
G1 X136.42 Y124.249 E.06516
G1 X136.42 Y123.716
G1 X137.983 Y122.153 E.06516
G1 X137.983 Y121.619
G1 X136.42 Y123.183 E.06515
G1 X136.42 Y122.649
G1 X137.983 Y121.086 E.06515
G1 X137.983 Y120.553
G1 X136.42 Y122.116 E.06515
G1 X136.42 Y121.582
G1 X137.983 Y120.02 E.06515
G1 X137.983 Y119.486
G1 X136.42 Y121.049 E.06514
G1 X136.42 Y120.516
G1 X138.023 Y118.913 E.0668
; WIPE_START
M204 S3000
G1 X136.609 Y120.327 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X136.421 Y119.982 Z6.4 F12000
G1 Z6
G1 E.8 F1800
G1 F3600
M204 S2000
G1 X139.986 Y116.417 E.14859
G1 X139.452 Y116.417
G1 X136.421 Y119.449 E.12636
G1 X136.421 Y118.916
G1 X138.919 Y116.417 E.10413
G1 X138.386 Y116.417
G1 X136.421 Y118.382 E.0819
G1 X136.421 Y117.849
G1 X137.853 Y116.417 E.05967
G1 X137.319 Y116.417
G1 X136.421 Y117.316 E.03744
; WIPE_START
M204 S3000
G1 X137.319 Y116.417 E-.48276
G1 X137.853 Y116.417 E-.20263
G1 X137.714 Y116.556 E-.0746
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.341 Y124.18 Z6.4 F12000
G1 X136.604 Y139.263 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0978641
G1 F15000
M204 S3000
G3 X136.512 Y139.153 I.298 J-.345 E.00062
; WIPE_START
G1 X136.604 Y139.263 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X136.736 Y131.631 Z6.4 F12000
G1 X136.998 Y116.446 Z6.4
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.106682
G1 F15000
M204 S3000
G1 X136.906 Y116.508 E.00055
; LINE_WIDTH: 0.143696
G1 X136.814 Y116.571 E.00088
; LINE_WIDTH: 0.163443
G2 X136.451 Y116.968 I1.157 J1.423 E.00509
; WIPE_START
G1 X136.669 Y116.703 E-.48346
G1 X136.814 Y116.571 E-.27654
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X142.66 Y121.479 Z6.4 F12000
G1 X163.542 Y139.011 Z6.4
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.100587
G1 F15000
M204 S3000
G1 X163.512 Y139.067 E.00029
; LINE_WIDTH: 0.128503
G1 X163.444 Y139.158 E.00076
; LINE_WIDTH: 0.164828
G3 X163.178 Y139.434 I-.953 J-.65 E.00367
; LINE_WIDTH: 0.141359
G1 X163.09 Y139.494 E.00082
; LINE_WIDTH: 0.105903
G1 X163.002 Y139.554 E.00053
; WIPE_START
G1 X163.09 Y139.494 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.046 Y137.146 Z6.4 F12000
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.198747
G1 F15000
M204 S3000
G1 X161.989 Y137.236 E.0013
; LINE_WIDTH: 0.174653
G1 X161.914 Y137.336 E.00129
; LINE_WIDTH: 0.140059
G1 X161.84 Y137.437 E.00095
; LINE_WIDTH: 0.105465
G1 X161.765 Y137.538 E.00061
M204 S10000
G1 X161.606 Y137.694 F12000
; LINE_WIDTH: 0.105802
G1 F15000
M204 S3000
G3 X161.389 Y137.883 I-1.985 J-2.056 E.00142
; LINE_WIDTH: 0.14912
G1 X161.268 Y137.97 E.00124
; LINE_WIDTH: 0.18556
G1 X161.167 Y138.026 E.00128
; WIPE_START
G1 X161.268 Y137.97 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X155.443 Y133.037 Z6.4 F12000
G1 X138.235 Y118.462 Z6.4
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.109626
G1 F15000
M204 S3000
G1 X138.134 Y118.596 E.00088
; LINE_WIDTH: 0.163134
G2 X137.954 Y118.844 I2.855 J2.266 E.00288
; WIPE_START
G1 X138.134 Y118.596 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X138.821 Y117.975 Z6.4 F12000
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.161707
G1 F15000
M204 S3000
G1 X138.698 Y118.054 E.00136
; LINE_WIDTH: 0.134396
G1 X138.572 Y118.146 E.00111
; LINE_WIDTH: 0.0994346
G1 X138.408 Y118.292 E.00097
; OBJECT_ID: 47
; WIPE_START
G1 X138.572 Y118.146 E-.76
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X130.956 Y118.648 Z6.4 F12000
G1 X116.39 Y119.609 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.476 J.191 E.04357
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.611 E.04357
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.603 E.55619
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.732 Y119.268 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.46 E.00645
G1 X116.798 Y136.537 E.54333
G1 X116.72 Y136.74 E.00694
G1 X116.56 Y136.798 E.00541
G1 X95.463 Y136.798 E.67123
G1 X95.251 Y136.712 E.0073
G1 X95.202 Y136.548 E.00545
G1 X95.202 Y119.463 E.54359
G1 X95.28 Y119.26 E.00693
G1 X95.44 Y119.202 E.00541
G1 X116.521 Y119.202 E.67073
G1 X116.675 Y119.25 E.00512
M204 S250
G1 X117.007 Y118.992 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X117.189 Y119.46 I-.474 J.454 E.01517
G1 X117.19 Y136.505 E.50235
G1 X117.132 Y136.845 E.01018
G1 X116.98 Y137.045 E.00739
G3 X116.587 Y137.19 I-.532 J-.838 E.01245
G1 X95.495 Y137.19 E.62162
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.547 J-.83 E.01054
G1 X94.81 Y136.583 E.00929
G1 X94.81 Y119.495 E.50362
G1 X94.868 Y119.155 E.01017
G1 X95.02 Y118.955 E.00739
G3 X95.413 Y118.81 I.532 J.838 E.01246
G1 X116.521 Y118.81 E.62209
G1 X116.824 Y118.858 E.00905
G3 X116.964 Y118.951 I-.291 J.588 E.00496
; WIPE_START
M204 S3000
G1 X117.143 Y119.177 E-.10948
G1 X117.189 Y119.46 E-.10892
G1 X117.189 Y120.885 E-.5416
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.899 Y125.208 Z6.4 F12000
G1 X96.103 Y135.376 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.997 E.55619
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.13 Y135.43 E.01039
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.354 Y125.458 Z6.4 F12000
G1 X96.026 Y119.961 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y127.594 Z6.4 F12000
G1 X96.026 Y135.957 Z6.4
G1 Z6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y135.957 Z6.4 F12000
G1 X116.021 Y135.957 Z6.4
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y128.324 Z6.4 F12000
G1 X116.021 Y119.961 Z6.4
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.42154
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
M73 P89 R2
G1 X116.021 Y120.043 E-.17025
G1 X115.95 Y120.002 E-.29488
G1 X116.021 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 31/40
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change
M106 S122.4
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z6.4 I.84 J.881 P1  F12000
G1 X116.39 Y119.609 Z6.4
G1 Z6.2
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.478 J.191 E.04357
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.611 E.04357
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.603 E.55619
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.727 Y119.265 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.45 E.00632
G1 X116.798 Y136.537 E.54363
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00546
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.72 E.00693
G1 X95.202 Y136.56 E.00541
G1 X95.202 Y119.463 E.54396
G1 X95.28 Y119.26 E.00693
G1 X95.441 Y119.202 E.00542
G1 X116.52 Y119.202 E.6707
G1 X116.669 Y119.247 E.00495
M204 S250
G1 X117.013 Y118.984 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.152 Y119.202 E.00762
G1 X117.189 Y119.45 E.0074
G1 X117.19 Y136.505 E.50263
G1 X117.132 Y136.845 E.01017
G3 X116.886 Y137.102 I-.829 J-.547 E.01054
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01017
G1 X94.955 Y136.98 E.0074
G3 X94.81 Y136.587 I.838 J-.532 E.01246
G1 X94.81 Y119.495 E.50373
G1 X94.868 Y119.155 E.01017
G1 X95.02 Y118.955 E.0074
G3 X95.414 Y118.81 I.532 J.837 E.01247
G1 X116.52 Y118.81 E.62206
G1 X116.824 Y118.858 E.00906
G1 X116.963 Y118.951 E.00492
; WIPE_START
M204 S3000
G1 X117.152 Y119.202 E-.11954
G1 X117.189 Y119.45 E-.09544
G1 X117.189 Y120.885 E-.54503
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.904 Y125.215 Z6.6 F12000
G1 X96.117 Y135.403 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44624
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43731
G1 X115.021 Y119.997 E.55619
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z6.6 F12000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z6.6 F12000
G1 X96.026 Y119.961 Z6.6
G1 Z6.2
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z6.6 F12000
G1 X116.021 Y119.961 Z6.6
G1 Z6.2
G1 E.8 F1800
; LINE_WIDTH: 0.42156
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z6.6 F12000
M73 P89 R1
G1 X116.021 Y135.957 Z6.6
G1 Z6.2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z6.6 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 31 start: 47
M624 AQAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6.6 F4000
            G39.3 S1
            G0 Z6.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer31 end: 47
M625
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 32/40
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change
M106 S117.3
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
G1 X116.39 Y119.609 F12000
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.621 J.204 E.04357
; LINE_WIDTH: 0.43692
G1 X116.396 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.396 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.396 Y126.979 E.06156
; LINE_WIDTH: 0.4366
G1 X116.396 Y130.979 E.12308
; LINE_WIDTH: 0.4364
G1 X116.396 Y132.979 E.06151
; LINE_WIDTH: 0.43629
G1 X116.396 Y134.979 E.06149
; LINE_WIDTH: 0.43619
G1 X116.396 Y135.021 E.00132
; LINE_WIDTH: 0.4451
G1 X116.391 Y135.227 E.00645
; LINE_WIDTH: 0.44999
G1 X116.388 Y136.391 E.03704
G2 X115.021 Y136.397 I-.193 J105.494 E.0435
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-104.471 J-.212 E.04357
; LINE_WIDTH: 0.43721
G1 X95.603 Y133.021 E.06164
; LINE_WIDTH: 0.43706
G1 X95.603 Y131.021 E.06161
; LINE_WIDTH: 0.43692
G1 X95.604 Y129.021 E.06159
; LINE_WIDTH: 0.43678
G1 X95.604 Y127.021 E.06157
; LINE_WIDTH: 0.43664
G1 X95.604 Y125.021 E.06155
; LINE_WIDTH: 0.4365
G1 X95.604 Y123.021 E.06153
; LINE_WIDTH: 0.43636
G1 X95.604 Y121.021 E.0615
; LINE_WIDTH: 0.43622
G1 X95.604 Y120.978 E.00132
; LINE_WIDTH: 0.44999
G1 X95.612 Y119.609 E.04356
G2 X96.979 Y119.603 I.196 J-105.083 E.0435
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.603 E.55621
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.736 Y119.271 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.468 E.00657
G1 X116.796 Y136.586 E.54467
G1 X116.72 Y136.74 E.00544
G1 X116.56 Y136.798 E.00541
G1 X95.463 Y136.798 E.67123
G1 X95.26 Y136.72 E.00693
G1 X95.202 Y136.56 E.00541
G1 X95.204 Y119.413 E.54555
G1 X95.288 Y119.25 E.00583
G1 X95.452 Y119.202 E.00545
G1 X116.52 Y119.202 E.67032
G1 X116.678 Y119.253 E.0053
M204 S250
G1 X117.016 Y118.986 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X117.134 Y119.158 I-.415 J.413 E.00618
G1 X117.189 Y119.468 E.00927
G1 X117.188 Y136.545 E.50331
G1 X117.134 Y136.842 E.0089
G1 X116.981 Y137.045 E.0075
G3 X116.587 Y137.19 I-.538 J-.853 E.01246
G1 X95.495 Y137.19 E.62162
G1 X95.155 Y137.132 E.01016
G1 X94.955 Y136.98 E.0074
G3 X94.81 Y136.587 I.838 J-.532 E.01245
G1 X94.812 Y120.587 E.47156
G3 X94.833 Y119.285 I22.972 J-.29 E.03837
G3 X95.114 Y118.898 I.633 J.164 E.01446
G1 X95.417 Y118.81 E.00929
G1 X116.52 Y118.81 E.62194
G1 X116.824 Y118.858 E.00908
G3 X116.971 Y118.946 I-.223 J.541 E.00508
; WIPE_START
M204 S3000
G1 X117.134 Y119.158 E-.10151
G1 X117.189 Y119.468 E-.11955
G1 X117.189 Y120.886 E-.53894
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.899 Y125.209 Z6.8 F12000
G1 X96.103 Y135.376 Z6.8
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44614
G1 X95.997 Y135.021 E.00537
; LINE_WIDTH: 0.43721
G1 X95.997 Y133.021 E.06164
; LINE_WIDTH: 0.43706
G1 X95.997 Y131.021 E.06161
; LINE_WIDTH: 0.43692
G1 X95.997 Y129.021 E.06159
; LINE_WIDTH: 0.43678
G1 X95.998 Y127.021 E.06157
; LINE_WIDTH: 0.43664
G1 X95.998 Y125.021 E.06155
; LINE_WIDTH: 0.4365
G1 X95.998 Y123.021 E.06153
; LINE_WIDTH: 0.43636
G1 X95.998 Y121.021 E.0615
; LINE_WIDTH: 0.43622
M73 P90 R1
G1 X95.998 Y120.979 E.00132
; LINE_WIDTH: 0.44999
G1 X96.281 Y120.279 E.024
G1 X96.808 Y120.008 E.01887
; LINE_WIDTH: 0.44625
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.997 E.55621
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43692
G1 X116.003 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.002 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.002 Y126.979 E.06156
; LINE_WIDTH: 0.4366
G1 X116.002 Y130.979 E.12308
; LINE_WIDTH: 0.4364
G1 X116.002 Y132.979 E.06151
; LINE_WIDTH: 0.43629
G1 X116.002 Y134.979 E.06149
; LINE_WIDTH: 0.43619
G1 X116.002 Y135.021 E.00132
; LINE_WIDTH: 0.4451
G1 X115.992 Y135.192 E.00536
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01894
G1 X115.192 Y135.992 E.01887
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02397
G1 X96.13 Y135.429 E.0104
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.978 E.44681
G1 X96.568 Y120.568 E.01416
G1 X96.878 Y120.407 E.0111
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.827 J.022 E.00457
G1 X115.432 Y135.433 E.01115
G1 X115.122 Y135.593 E.0111
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z6.8 F12000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17026
G1 X95.955 Y135.998 E-.29487
G1 X96.026 Y135.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y128.324 Z6.8 F12000
G1 X96.027 Y119.961 Z6.8
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y120.002 E.00241
G1 X96.027 Y120.042 E.00241
G1 X96.051 Y120.002 E.00139
; WIPE_START
G1 X96.027 Y120.042 E-.17027
G1 X95.957 Y120.002 E-.29487
G1 X96.027 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.66 Y119.961 Z6.8 F12000
G1 X116.021 Y119.961 Z6.8
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.4215
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17025
G1 X115.95 Y120.002 E-.29488
G1 X116.021 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y127.594 Z6.8 F12000
G1 X116.02 Y135.958 Z6.8
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y135.998 E.00241
G1 X116.02 Y136.039 E.00241
G1 X116.043 Y135.998 E.00139
; WIPE_START
G1 X116.02 Y136.039 E-.17027
G1 X115.949 Y135.998 E-.29487
G1 X116.02 Y135.958 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z6.8 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 32 start: 47
M624 AQAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z6.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z6.8 F4000
            G39.3 S1
            G0 Z6.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer32 end: 47
M625
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 33/40
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
G1 X116.39 Y119.609 F12000
G1 Z6.6
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.483 J.191 E.04357
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.445 E.04357
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.603 E.55621
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.736 Y119.271 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.468 E.00657
G1 X116.798 Y136.537 E.54307
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.25 Y136.712 E.0073
G1 X95.202 Y136.548 E.00545
G1 X95.202 Y119.463 E.54358
G1 X95.28 Y119.26 E.00694
G1 X95.44 Y119.202 E.00541
G1 X116.519 Y119.202 E.67067
G1 X116.679 Y119.253 E.00532
M204 S250
G1 X117.016 Y118.986 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X117.134 Y119.157 I-.414 J.412 E.00616
G1 X117.189 Y119.468 E.0093
G1 X117.19 Y136.505 E.50212
G1 X117.132 Y136.845 E.01017
G3 X116.886 Y137.102 I-.83 J-.547 E.01055
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01016
G3 X94.898 Y136.886 I.549 J-.832 E.01055
G1 X94.81 Y136.583 E.0093
G1 X94.81 Y119.495 E.5036
G1 X94.868 Y119.155 E.01017
G1 X95.02 Y118.955 E.00739
G3 X95.413 Y118.81 I.532 J.838 E.01245
G1 X116.519 Y118.81 E.62204
G1 X116.824 Y118.858 E.0091
G3 X116.972 Y118.946 I-.222 J.541 E.00508
; WIPE_START
M204 S3000
G1 X117.134 Y119.157 E-.1012
G1 X117.189 Y119.468 E-.11994
G1 X117.189 Y120.886 E-.53886
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.899 Y125.209 Z7 F12000
G1 X96.103 Y135.376 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44625
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.997 E.55621
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.13 Y135.43 E.01039
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
M73 P91 R1
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.354 Y125.458 Z7 F12000
G1 X96.026 Y119.961 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y127.594 Z7 F12000
G1 X96.026 Y135.957 Z7
G1 Z6.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y135.957 Z7 F12000
G1 X116.021 Y135.957 Z7
G1 Z6.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y128.324 Z7 F12000
G1 X116.021 Y119.961 Z7
G1 Z6.6
G1 E.8 F1800
; LINE_WIDTH: 0.42158
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z7 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 33 start: 47
M624 AQAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7 F4000
            G39.3 S1
            G0 Z7 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer33 end: 47
M625
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 34/40
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
G1 X116.39 Y119.609 F12000
G1 Z6.8
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I102.625 J.204 E.04357
; LINE_WIDTH: 0.43692
G1 X116.396 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.396 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.396 Y128.979 E.12312
; LINE_WIDTH: 0.4365
G1 X116.396 Y132.979 E.12305
; LINE_WIDTH: 0.4363
G1 X116.396 Y135.021 E.06281
; LINE_WIDTH: 0.44512
G1 X116.391 Y135.227 E.00645
; LINE_WIDTH: 0.44999
G1 X116.388 Y136.391 E.03704
G2 X115.021 Y136.397 I-.196 J104.919 E.0435
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.445 E.04357
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.603 E.55621
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.727 Y119.265 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.45 E.00632
G1 X116.796 Y136.586 E.54522
G1 X116.72 Y136.74 E.00545
G1 X116.56 Y136.798 E.00541
G1 X95.463 Y136.798 E.67122
G1 X95.25 Y136.712 E.0073
G1 X95.202 Y136.548 E.00544
G1 X95.202 Y119.463 E.54359
G1 X95.288 Y119.25 E.00731
G1 X95.452 Y119.202 E.00545
G1 X116.519 Y119.202 E.67028
G1 X116.669 Y119.247 E.00501
M204 S250
G1 X117.014 Y118.986 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.152 Y119.202 E.00757
G1 X117.189 Y119.45 E.0074
G1 X117.188 Y136.545 E.50381
G1 X117.134 Y136.842 E.0089
G1 X116.98 Y137.045 E.0075
G3 X116.587 Y137.19 I-.538 J-.853 E.01246
G1 X95.495 Y137.19 E.62162
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.548 J-.831 E.01054
G1 X94.81 Y136.583 E.0093
G1 X94.81 Y119.495 E.50362
G1 X94.868 Y119.155 E.01017
G3 X95.114 Y118.898 I.832 J.549 E.01055
G1 X95.417 Y118.81 E.00931
G1 X116.519 Y118.81 E.6219
G1 X116.824 Y118.858 E.00912
G1 X116.964 Y118.952 E.00497
; WIPE_START
M204 S3000
G1 X117.152 Y119.202 E-.11893
G1 X117.189 Y119.45 E-.09538
G1 X117.189 Y120.886 E-.54569
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.899 Y125.209 Z7.2 F12000
G1 X96.103 Y135.376 Z7.2
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44625
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.997 E.55621
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43692
G1 X116.003 Y122.979 E.06159
; LINE_WIDTH: 0.43681
G1 X116.002 Y124.979 E.06157
; LINE_WIDTH: 0.43671
G1 X116.002 Y128.979 E.12312
; LINE_WIDTH: 0.4365
G1 X116.002 Y132.979 E.12305
; LINE_WIDTH: 0.4363
G1 X116.002 Y135.021 E.06281
; LINE_WIDTH: 0.44512
G1 X115.992 Y135.192 E.00536
; LINE_WIDTH: 0.44999
G1 X115.719 Y135.721 E.01894
G1 X115.192 Y135.992 E.01887
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.13 Y135.43 E.01039
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.827 J.022 E.00457
G1 X115.432 Y135.433 E.01114
G1 X115.122 Y135.593 E.0111
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
M73 P92 R1
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.354 Y125.458 Z7.2 F12000
G1 X96.026 Y119.961 Z7.2
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y127.594 Z7.2 F12000
G1 X96.026 Y135.957 Z7.2
G1 Z6.8
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y135.957 Z7.2 F12000
G1 X116.02 Y135.958 Z7.2
G1 Z6.8
G1 E.8 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y135.998 E.00241
G1 X116.02 Y136.039 E.00241
G1 X116.043 Y135.998 E.00139
; WIPE_START
G1 X116.02 Y136.039 E-.17027
G1 X115.949 Y135.998 E-.29487
G1 X116.02 Y135.958 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y128.325 Z7.2 F12000
G1 X116.021 Y119.961 Z7.2
G1 Z6.8
G1 E.8 F1800
; LINE_WIDTH: 0.42152
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17025
G1 X115.95 Y120.002 E-.29488
G1 X116.021 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z7.2 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 34 start: 47
M624 AQAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7.2 F4000
            G39.3 S1
            G0 Z7.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer34 end: 47
M625
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 35/40
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
G1 X116.39 Y119.609 F12000
G1 Z7
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.487 J.191 E.04357
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.445 E.04357
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.603 E.55621
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.736 Y119.271 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.469 E.00659
G1 X116.798 Y136.537 E.54305
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00545
G1 X95.463 Y136.798 E.67085
G1 X95.261 Y136.72 E.00691
G1 X95.202 Y136.56 E.00542
G1 X95.202 Y119.463 E.54397
G1 X95.28 Y119.26 E.00693
G1 X95.44 Y119.202 E.00541
G1 X116.518 Y119.202 E.67063
G1 X116.679 Y119.253 E.00536
M204 S250
G1 X117.016 Y118.986 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X117.133 Y119.156 I-.414 J.413 E.00612
G1 X117.189 Y119.469 E.00936
G1 X117.19 Y136.505 E.5021
G1 X117.132 Y136.845 E.01018
G3 X116.886 Y137.102 I-.83 J-.547 E.01054
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.6215
G1 X95.155 Y137.132 E.01017
G1 X94.955 Y136.98 E.00739
G3 X94.81 Y136.587 I.849 J-.536 E.01246
G1 X94.81 Y119.495 E.50372
G1 X94.868 Y119.155 E.01017
G1 X95.02 Y118.955 E.00739
G3 X95.413 Y118.81 I.532 J.838 E.01246
G1 X116.518 Y118.81 E.622
G1 X116.824 Y118.858 E.00914
G3 X116.971 Y118.946 I-.223 J.541 E.00507
; WIPE_START
M204 S3000
G1 X117.133 Y119.156 E-.10078
G1 X117.189 Y119.469 E-.12067
G1 X117.189 Y120.886 E-.53856
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.899 Y125.208 Z7.4 F12000
G1 X96.103 Y135.376 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44625
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.997 E.55621
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.13 Y135.43 E.01039
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.354 Y125.458 Z7.4 F12000
G1 X96.026 Y119.961 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y127.594 Z7.4 F12000
G1 X96.026 Y135.957 Z7.4
G1 Z7
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
M73 P93 R1
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y135.957 Z7.4 F12000
G1 X116.021 Y135.957 Z7.4
G1 Z7
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y128.324 Z7.4 F12000
G1 X116.021 Y119.961 Z7.4
G1 Z7
G1 E.8 F1800
; LINE_WIDTH: 0.4216
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z7.4 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 35 start: 47
M624 AQAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7.4 F4000
            G39.3 S1
            G0 Z7.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer35 end: 47
M625
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 36/40
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
G1 X116.39 Y119.609 F12000
G1 Z7.2
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.491 J.191 E.04357
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.445 E.04357
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.603 E.55621
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.727 Y119.265 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.451 E.00632
G1 X116.798 Y136.537 E.54363
G1 X116.719 Y136.74 E.00694
G1 X116.56 Y136.798 E.00541
G1 X95.463 Y136.798 E.67122
G1 X95.251 Y136.712 E.0073
G1 X95.202 Y136.548 E.00545
G1 X95.202 Y119.463 E.54359
G1 X95.28 Y119.26 E.00693
G1 X95.441 Y119.202 E.00542
G1 X116.517 Y119.202 E.6706
G1 X116.67 Y119.248 E.00506
M204 S250
G1 X117.014 Y118.986 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.152 Y119.202 E.00755
G1 X117.189 Y119.451 E.00741
G1 X117.19 Y136.505 E.50263
G1 X117.132 Y136.845 E.01017
G1 X116.98 Y137.045 E.00741
G3 X116.587 Y137.19 I-.531 J-.837 E.01245
G1 X95.495 Y137.19 E.62162
G1 X95.155 Y137.132 E.01017
G3 X94.898 Y136.886 I.548 J-.83 E.01054
G1 X94.81 Y136.583 E.00929
G1 X94.81 Y119.495 E.50362
G1 X94.868 Y119.155 E.01017
G1 X95.02 Y118.955 E.0074
G3 X95.414 Y118.81 I.532 J.837 E.01246
G1 X116.517 Y118.81 E.62197
G1 X116.824 Y118.858 E.00916
G1 X116.965 Y118.952 E.00499
; WIPE_START
M204 S3000
G1 X117.152 Y119.202 E-.11862
G1 X117.189 Y119.451 E-.09549
G1 X117.189 Y120.887 E-.54589
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.904 Y125.217 Z7.6 F12000
G1 X96.117 Y135.403 Z7.6
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02397
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44625
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.997 E.55621
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z7.6 F12000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z7.6 F12000
G1 X96.026 Y119.961 Z7.6
G1 Z7.2
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z7.6 F12000
G1 X116.021 Y119.961 Z7.6
G1 Z7.2
G1 E.8 F1800
; LINE_WIDTH: 0.4216
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z7.6 F12000
G1 X116.021 Y135.957 Z7.6
G1 Z7.2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z7.6 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 36 start: 47
M624 AQAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7.6
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7.6 F4000
            G39.3 S1
            G0 Z7.6 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer36 end: 47
M625
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 37/40
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
G1 X116.39 Y119.609 F12000
G1 Z7.4
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
M73 P94 R1
G2 X116.397 Y120.979 I103.493 J.191 E.04357
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.277 E.04357
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.603 E.55621
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.736 Y119.271 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.469 E.00658
G1 X116.798 Y136.537 E.54305
G1 X116.719 Y136.74 E.00694
G1 X116.559 Y136.798 E.00541
G1 X95.463 Y136.798 E.67122
G1 X95.25 Y136.712 E.0073
G1 X95.202 Y136.548 E.00544
G1 X95.202 Y119.463 E.54359
G1 X95.288 Y119.251 E.0073
G1 X95.452 Y119.202 E.00545
G1 X116.544 Y119.202 E.6711
G1 X116.68 Y119.251 E.00459
M204 S250
G1 X117.016 Y118.987 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X117.133 Y119.155 I-.414 J.412 E.00606
G1 X117.189 Y119.469 E.00941
G1 X117.19 Y136.505 E.50209
G1 X117.132 Y136.845 E.01017
G1 X116.98 Y137.045 E.0074
G3 X116.586 Y137.19 I-.531 J-.837 E.01246
G1 X95.495 Y137.19 E.62161
G1 X95.155 Y137.132 E.01016
G3 X94.898 Y136.886 I.55 J-.834 E.01055
G1 X94.81 Y136.583 E.0093
G1 X94.81 Y119.495 E.50362
G1 X94.868 Y119.155 E.01017
G3 X95.114 Y118.898 I.832 J.549 E.01054
G1 X95.417 Y118.81 E.0093
G1 X116.517 Y118.81 E.62184
G1 X116.824 Y118.858 E.00918
G3 X116.972 Y118.946 I-.223 J.54 E.00508
; WIPE_START
M204 S3000
G1 X117.133 Y119.155 E-.09998
G1 X117.189 Y119.469 E-.12132
G1 X117.189 Y120.886 E-.53871
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.904 Y125.216 Z7.8 F12000
G1 X96.117 Y135.403 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02398
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44625
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.997 E.55621
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z7.8 F12000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z7.8 F12000
G1 X96.026 Y119.961 Z7.8
G1 Z7.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z7.8 F12000
G1 X116.021 Y119.961 Z7.8
G1 Z7.4
G1 E.8 F1800
; LINE_WIDTH: 0.4216
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z7.8 F12000
G1 X116.021 Y135.957 Z7.8
G1 Z7.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z7.8 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 37 start: 47
M624 AQAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z7.8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z7.8 F4000
            G39.3 S1
            G0 Z7.8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer37 end: 47
M625
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 38/40
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M73 P94 R0
G1 X116.39 Y119.609 F12000
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.495 J.191 E.04357
; LINE_WIDTH: 0.43706
G1 X116.397 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.397 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.397 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.277 E.04357
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.603 E.55621
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.737 Y119.271 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.469 E.00659
G1 X116.798 Y136.537 E.54303
G1 X116.712 Y136.749 E.0073
G1 X116.548 Y136.798 E.00546
G1 X95.463 Y136.798 E.67085
G1 X95.26 Y136.72 E.00693
G1 X95.202 Y136.56 E.00541
G1 X95.202 Y119.463 E.54396
G1 X95.28 Y119.26 E.00693
G1 X95.44 Y119.202 E.00542
G1 X116.544 Y119.202 E.67145
G1 X116.68 Y119.251 E.00461
M204 S250
G1 X117.016 Y118.986 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
M73 P95 R0
G3 X117.132 Y119.153 I-.414 J.412 E.00601
G1 X117.189 Y119.469 E.00948
G1 X117.19 Y136.505 E.50207
G1 X117.132 Y136.845 E.01017
G3 X116.886 Y137.102 I-.829 J-.547 E.01055
G1 X116.583 Y137.19 E.0093
G1 X95.495 Y137.19 E.62149
G1 X95.155 Y137.132 E.01017
G1 X94.955 Y136.98 E.00739
G3 X94.81 Y136.587 I.843 J-.534 E.01245
G1 X94.81 Y119.495 E.50373
G1 X94.868 Y119.155 E.01018
G1 X95.02 Y118.955 E.00739
G3 X95.414 Y118.81 I.532 J.837 E.01247
G1 X116.516 Y118.81 E.62194
G1 X116.824 Y118.858 E.0092
G3 X116.972 Y118.946 I-.222 J.54 E.00508
; WIPE_START
M204 S3000
G1 X117.132 Y119.153 E-.09934
G1 X117.189 Y119.469 E-.12225
G1 X117.189 Y120.886 E-.53841
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.899 Y125.209 Z8 F12000
G1 X96.103 Y135.376 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.0066
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02398
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44625
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.997 E.55621
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43706
G1 X116.003 Y126.979 E.18484
; LINE_WIDTH: 0.43717
G1 X116.003 Y132.979 E.18489
; LINE_WIDTH: 0.43728
G1 X116.003 Y135.021 E.06297
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.13 Y135.43 E.01039
M204 S10000
G1 X96.447 Y135.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.0028
G1 X96.398 Y135.021 E.0032
G1 X96.398 Y120.979 E.44681
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
G1 X96.568 Y135.432 E.01414
G1 X96.475 Y135.253 E.00642
M204 S250
G1 X96.79 Y135.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.813 Y135.077 E.00248
; WIPE_START
M204 S3000
G1 X96.81 Y133.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.354 Y125.458 Z8 F12000
G1 X96.026 Y119.961 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y127.594 Z8 F12000
G1 X96.026 Y135.957 Z8
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y135.957 Z8 F12000
G1 X116.021 Y135.957 Z8
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y128.324 Z8 F12000
G1 X116.021 Y119.961 Z8
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.42162
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17026
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z8 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 38 start: 47
M624 AQAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8 F4000
            G39.3 S1
            G0 Z8 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer38 end: 47
M625
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 39/40
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
G1 X116.39 Y119.609 F12000
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X116.397 Y120.979 I103.656 J.191 E.04357
; LINE_WIDTH: 0.43708
G1 X116.397 Y128.979 E.24646
; LINE_WIDTH: 0.43722
G1 X116.397 Y135.021 E.18624
; LINE_WIDTH: 0.44621
G1 X116.393 Y135.227 E.00647
; LINE_WIDTH: 0.44999
G1 X116.391 Y136.391 E.03704
G2 X115.021 Y136.397 I-.197 J105.276 E.04357
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.397 E.55621
; LINE_WIDTH: 0.44999
G1 X95.609 Y136.391 E.04357
G2 X95.603 Y135.021 I-105.444 J-.197 E.04357
; LINE_WIDTH: 0.43732
G1 X95.603 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X95.609 Y119.609 E.04357
G2 X96.979 Y119.603 I.197 J-105.278 E.04357
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.603 E.55621
; LINE_WIDTH: 0.44999
G1 X116.33 Y119.609 E.04164
M204 S10000
G1 X116.732 Y119.268 F12000
G1 F6000
M204 S3000
G1 X116.797 Y119.461 E.00647
G1 X116.798 Y136.537 E.54331
G1 X116.72 Y136.74 E.00693
G1 X116.559 Y136.798 E.00542
G1 X95.463 Y136.798 E.67121
G1 X95.251 Y136.712 E.0073
G1 X95.202 Y136.548 E.00545
G1 X95.202 Y119.464 E.54358
G1 X95.288 Y119.251 E.0073
G1 X95.452 Y119.202 E.00546
G1 X116.515 Y119.202 E.67017
G1 X116.674 Y119.251 E.00529
M204 S250
G1 X117.016 Y118.987 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.134 Y119.181 E.00669
G3 X117.189 Y119.461 I-.6 J.265 E.00847
G1 X117.19 Y136.505 E.50233
G1 X117.132 Y136.845 E.01018
G1 X116.98 Y137.045 E.00738
G3 X116.586 Y137.19 I-.532 J-.837 E.01247
G1 X95.495 Y137.19 E.6216
G1 X95.155 Y137.132 E.01018
G3 X94.898 Y136.886 I.547 J-.83 E.01052
G1 X94.81 Y136.583 E.00931
G1 X94.81 Y119.495 E.50361
G1 X94.868 Y119.155 E.01018
G3 X95.114 Y118.898 I.83 J.548 E.01053
G1 X95.417 Y118.81 E.00931
G1 X116.515 Y118.81 E.62181
G1 X116.824 Y118.858 E.00922
G3 X116.971 Y118.958 I-.291 J.588 E.00525
; WIPE_START
M204 S3000
G1 X117.134 Y119.181 E-.10486
G1 X117.189 Y119.461 E-.10836
G1 X117.189 Y120.9 E-.54678
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.902 Y125.227 Z8.2 F12000
G1 X96.117 Y135.403 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y135.192 E.00757
; LINE_WIDTH: 0.44625
G1 X95.997 Y135.021 E.00538
; LINE_WIDTH: 0.43732
G1 X95.997 Y120.979 E.4329
; LINE_WIDTH: 0.44999
G1 X96.28 Y120.28 E.02398
G1 X96.808 Y120.008 E.01891
; LINE_WIDTH: 0.44625
G1 X96.979 Y119.997 E.00538
; LINE_WIDTH: 0.43732
G1 X115.021 Y119.997 E.55621
; LINE_WIDTH: 0.44999
G1 X115.72 Y120.28 E.02397
G1 X116.003 Y120.979 E.02398
; LINE_WIDTH: 0.43708
G1 X116.003 Y128.979 E.24646
; LINE_WIDTH: 0.43722
G1 X116.003 Y135.021 E.18624
; LINE_WIDTH: 0.44621
G1 X115.992 Y135.192 E.00538
; LINE_WIDTH: 0.44999
G1 X115.72 Y135.72 E.01891
G1 X115.192 Y135.992 E.01891
; LINE_WIDTH: 0.44625
G1 X115.021 Y136.003 E.00538
; LINE_WIDTH: 0.43732
G1 X96.979 Y136.003 E.55621
; LINE_WIDTH: 0.44999
G1 X96.28 Y135.72 E.02398
G1 X96.144 Y135.456 E.00943
M204 S10000
G1 X96.461 Y135.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y135.122 E.00376
G1 X96.398 Y120.979 E.45
G1 X96.568 Y120.568 E.01414
G1 X96.878 Y120.407 E.01113
G1 X96.979 Y120.398 E.0032
G1 X115.021 Y120.398 E.57407
G1 X115.432 Y120.568 E.01413
G1 X115.602 Y120.979 E.01414
G1 X115.602 Y134.979 E.44544
G3 X115.593 Y135.122 I-.829 J.021 E.00457
G1 X115.432 Y135.432 E.01113
G1 X115.122 Y135.593 E.01113
G1 X115.021 Y135.602 E.0032
G1 X96.979 Y135.602 E.57407
M73 P96 R0
G1 X96.568 Y135.432 E.01414
G1 X96.489 Y135.28 E.00546
M204 S250
G1 X96.793 Y135.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y121.021 E.41357
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00558
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.821 Y135.107 E.00158
; WIPE_START
M204 S3000
G1 X96.816 Y133.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y135.957 Z8.2 F12000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y135.998 E.00243
G1 X96.026 Y136.039 E.00243
G1 X96.05 Y135.998 E.0014
; WIPE_START
G1 X96.026 Y136.039 E-.17024
G1 X95.955 Y135.998 E-.29488
G1 X96.026 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y128.324 Z8.2 F12000
G1 X96.026 Y119.961 Z8.2
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X95.955 Y120.002 E.00243
G1 X96.026 Y120.043 E.00243
G1 X96.05 Y120.002 E.0014
; WIPE_START
G1 X96.026 Y120.043 E-.17024
G1 X95.955 Y120.002 E-.29488
G1 X96.026 Y119.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y119.961 Z8.2 F12000
G1 X116.021 Y119.961 Z8.2
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.42164
G1 F6000
M204 S3000
G1 X115.95 Y120.002 E.00243
G1 X116.021 Y120.043 E.00243
G1 X116.045 Y120.002 E.0014
; WIPE_START
G1 X116.021 Y120.043 E-.17025
G1 X115.95 Y120.002 E-.29487
G1 X116.021 Y119.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y127.594 Z8.2 F12000
G1 X116.021 Y135.957 Z8.2
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y135.998 E.00243
G1 X116.021 Y136.039 E.00243
G1 X116.045 Y135.998 E.0014
; WIPE_START
G1 X116.021 Y136.039 E-.17024
G1 X115.95 Y135.998 E-.29488
G1 X116.021 Y135.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z8.2 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 39 start: 47
M624 AQAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8.2
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8.2 F4000
            G39.3 S1
            G0 Z8.2 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer39 end: 47
M625
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; layer num/total_layer_count: 40/40
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change
M106 S91.8
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
G1 X117.014 Y118.986 F12000
G1 Z8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X117.152 Y119.202 E.00757
G1 X117.189 Y119.451 E.00741
G1 X117.19 Y136.505 E.50262
G1 X117.132 Y136.845 E.01018
G1 X116.98 Y137.045 E.00739
G3 X116.586 Y137.19 I-.532 J-.839 E.01247
G1 X95.495 Y137.19 E.6216
G1 X95.155 Y137.132 E.01019
G3 X94.898 Y136.886 I.547 J-.829 E.01053
G1 X94.81 Y136.583 E.00929
G1 X94.812 Y119.455 E.50479
G1 X94.866 Y119.158 E.0089
G1 X95.02 Y118.955 E.00752
G3 X95.413 Y118.81 I.536 J.851 E.01245
G1 X116.53 Y118.811 E.62236
G1 X116.752 Y118.845 E.00663
G1 X116.962 Y118.956 E.007
; WIPE_START
M204 S3000
G1 X117.152 Y119.202 E-.11811
G1 X117.189 Y119.451 E-.09552
G1 X117.189 Y120.889 E-.54638
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X110.916 Y125.236 Z8.4 F12000
G1 X96.791 Y135.024 Z8.4
G1 Z8
G1 E.8 F1800
G1 F3600
M204 S1500
G1 X96.79 Y135.021 E.00009
G1 X96.79 Y121.021 E.41261
G3 X96.845 Y120.845 I.24 J-.021 E.00559
G1 X96.979 Y120.79 E.00425
G1 X114.979 Y120.79 E.5305
G3 X115.155 Y120.845 I.021 J.24 E.00559
G1 X115.21 Y120.979 E.00425
G1 X115.21 Y134.979 E.41261
G3 X115.155 Y135.155 I-.24 J.021 E.00559
G1 X115.021 Y135.21 E.00425
G1 X97.021 Y135.21 E.5305
G3 X96.845 Y135.155 I-.021 J-.24 E.00559
G1 X96.814 Y135.08 E.00239
; WIPE_START
M204 S3000
G1 X96.79 Y135.021 E-.02397
G1 X96.79 Y133.085 E-.73603
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z8.4 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
; object ids of layer 40 start: 47
M624 AQAAAAAAAAA=
;===================== date: 20250206 =====================

; don't support timelapse gcode in spiral_mode and by object sequence for I3 structure printer
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
G92 E0
G1 Z8.4
G1 X0 Y128 F18000 ; move to safe pos
G1 X-48.2 F3000 ; move to safe pos
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C11 O0
G92 E0
G1 X0 F18000
M623

; SKIPTYPE: head_wrap_detect
M622.1 S1
M1002 judge_flag g39_3rd_layer_detect_flag
M622 J1
    ; enable nozzle clog detect at 3rd layer
    


    M622.1 S1
    M1002 judge_flag g39_detection_flag
    M622 J1
      
        M622.1 S0
        M1002 judge_flag g39_mass_exceed_flag
        M622 J1
        
            G392 S0
            M400
            G90
            M83
            M204 S5000
            G0 Z8.4 F4000
            G39.3 S1
            G0 Z8.4 F4000
            G392 S0
          
        M623
    
    M623
M623
; SKIPPABLE_END


; object ids of this layer40 end: 47
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
G1 X116.983 Y136.481 F12000
G1 Z8
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F3600
M204 S2000
G1 X116.481 Y136.983 E.0209
G1 X115.948 Y136.983
G1 X116.983 Y135.948 E.04313
G1 X116.983 Y135.415
G1 X115.415 Y136.983 E.06535
G1 X114.881 Y136.983
G1 X116.983 Y134.881 E.08758
G1 X116.983 Y134.348
G1 X114.348 Y136.983 E.1098
G1 X113.815 Y136.983
G1 X116.983 Y133.815 E.13203
G1 X116.983 Y133.282
G1 X115.417 Y134.847 E.06524
G1 X115.417 Y134.314
G1 X116.982 Y132.749 E.06524
G1 X116.982 Y132.215
G1 X115.417 Y133.78 E.06523
G1 X115.417 Y133.247
G1 X116.982 Y131.682 E.06523
G1 X116.982 Y131.149
G1 X115.417 Y132.714 E.06523
G1 X115.417 Y132.181
G1 X116.982 Y130.616 E.06523
G1 X116.982 Y130.082
G1 X115.417 Y131.647 E.06523
G1 X115.417 Y131.114
G1 X116.982 Y129.549 E.06523
G1 X116.982 Y129.016
G1 X115.417 Y130.581 E.06523
G1 X115.417 Y130.048
G1 X116.982 Y128.483 E.06523
G1 X116.982 Y127.949
G1 X115.417 Y129.514 E.06523
G1 X115.417 Y128.981
G1 X116.982 Y127.416 E.06523
G1 X116.982 Y126.883
G1 X115.417 Y128.448 E.06523
G1 X115.417 Y127.915
G1 X116.982 Y126.35 E.06523
G1 X116.982 Y125.816
G1 X115.417 Y127.381 E.06523
G1 X115.417 Y126.848
G1 X116.982 Y125.283 E.06522
M73 P97 R0
G1 X116.982 Y124.75
G1 X115.417 Y126.315 E.06522
G1 X115.417 Y125.782
G1 X116.982 Y124.217 E.06522
G1 X116.982 Y123.683
G1 X115.417 Y125.248 E.06522
G1 X115.417 Y124.715
G1 X116.982 Y123.15 E.06522
G1 X116.982 Y122.617
G1 X115.417 Y124.182 E.06522
G1 X115.417 Y123.649
G1 X116.982 Y122.084 E.06522
G1 X116.982 Y121.551
G1 X115.417 Y123.115 E.06522
G1 X115.417 Y122.582
G1 X116.982 Y121.017 E.06522
G1 X116.982 Y120.484
G1 X115.417 Y122.049 E.06522
G1 X115.417 Y121.515
G1 X116.982 Y119.951 E.06522
G1 X116.982 Y119.418
G1 X115.417 Y120.982 E.06522
G1 X115.208 Y120.658
G1 X116.787 Y119.079 E.06583
G1 X116.315 Y119.018
G1 X114.75 Y120.583 E.06522
G1 X114.217 Y120.583
G1 X115.782 Y119.018 E.06522
G1 X115.249 Y119.018
G1 X113.684 Y120.583 E.06522
G1 X113.151 Y120.583
G1 X114.715 Y119.018 E.06522
G1 X114.182 Y119.018
G1 X112.617 Y120.583 E.06522
G1 X112.084 Y120.583
G1 X113.649 Y119.018 E.06522
G1 X113.116 Y119.018
G1 X111.551 Y120.583 E.06522
G1 X111.018 Y120.583
G1 X112.582 Y119.018 E.06522
G1 X112.049 Y119.018
G1 X110.484 Y120.583 E.06522
G1 X109.951 Y120.583
G1 X111.516 Y119.018 E.06522
G1 X110.983 Y119.018
G1 X109.418 Y120.583 E.06522
G1 X108.885 Y120.583
G1 X110.449 Y119.018 E.06522
G1 X109.916 Y119.018
G1 X108.351 Y120.583 E.06522
G1 X107.818 Y120.583
G1 X109.383 Y119.018 E.06522
G1 X108.85 Y119.018
G1 X107.285 Y120.583 E.06523
G1 X106.752 Y120.583
G1 X108.316 Y119.018 E.06523
G1 X107.783 Y119.018
G1 X106.218 Y120.583 E.06523
G1 X105.685 Y120.583
G1 X107.25 Y119.018 E.06523
G1 X106.717 Y119.018
G1 X105.152 Y120.583 E.06523
G1 X104.619 Y120.583
G1 X106.184 Y119.018 E.06523
G1 X105.65 Y119.018
G1 X104.085 Y120.583 E.06523
G1 X103.552 Y120.583
G1 X105.117 Y119.018 E.06523
G1 X104.584 Y119.018
G1 X103.019 Y120.583 E.06523
G1 X102.486 Y120.583
G1 X104.051 Y119.018 E.06523
G1 X103.517 Y119.018
G1 X101.952 Y120.583 E.06523
G1 X101.419 Y120.583
G1 X102.984 Y119.018 E.06523
G1 X102.451 Y119.018
G1 X100.886 Y120.583 E.06523
G1 X100.352 Y120.583
G1 X101.918 Y119.018 E.06523
G1 X101.384 Y119.018
G1 X99.819 Y120.583 E.06523
G1 X99.286 Y120.583
G1 X100.851 Y119.018 E.06524
G1 X100.318 Y119.018
G1 X98.753 Y120.583 E.06524
G1 X98.219 Y120.583
G1 X99.785 Y119.018 E.06524
G1 X99.251 Y119.017
G1 X97.686 Y120.583 E.06524
G1 X97.153 Y120.583
G1 X98.718 Y119.017 E.06524
; WIPE_START
M204 S3000
G1 X97.304 Y120.432 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.107 Y125.389 Z8.4 F12000
G1 X114.847 Y135.417 Z8.4
G1 Z8
G1 E.8 F1800
G1 F3600
M204 S2000
G1 X113.282 Y136.983 E.06524
G1 X112.748 Y136.983
G1 X114.314 Y135.417 E.06524
G1 X113.78 Y135.417
G1 X112.215 Y136.983 E.06524
G1 X111.682 Y136.983
G1 X113.247 Y135.417 E.06524
G1 X112.714 Y135.417
G1 X111.149 Y136.983 E.06524
G1 X110.615 Y136.983
G1 X112.181 Y135.417 E.06524
G1 X111.647 Y135.417
G1 X110.082 Y136.983 E.06524
G1 X109.549 Y136.983
G1 X111.114 Y135.417 E.06524
G1 X110.581 Y135.417
G1 X109.016 Y136.983 E.06524
G1 X108.482 Y136.983
G1 X110.048 Y135.417 E.06524
G1 X109.514 Y135.417
G1 X107.949 Y136.983 E.06524
G1 X107.416 Y136.983
G1 X108.981 Y135.417 E.06524
G1 X108.448 Y135.417
G1 X106.883 Y136.983 E.06524
G1 X106.349 Y136.983
G1 X107.915 Y135.417 E.06524
G1 X107.381 Y135.417
G1 X105.816 Y136.983 E.06524
G1 X105.283 Y136.983
G1 X106.848 Y135.417 E.06524
G1 X106.315 Y135.417
G1 X104.75 Y136.983 E.06524
G1 X104.216 Y136.983
G1 X105.782 Y135.417 E.06524
G1 X105.248 Y135.417
G1 X103.683 Y136.983 E.06524
G1 X103.15 Y136.983
G1 X104.715 Y135.417 E.06524
G1 X104.182 Y135.417
G1 X102.617 Y136.983 E.06524
G1 X102.083 Y136.983
G1 X103.648 Y135.417 E.06524
G1 X103.115 Y135.417
G1 X101.55 Y136.983 E.06524
G1 X101.017 Y136.983
G1 X102.582 Y135.417 E.06524
G1 X102.049 Y135.417
G1 X100.483 Y136.983 E.06524
G1 X99.95 Y136.983
G1 X101.515 Y135.417 E.06524
G1 X100.982 Y135.417
G1 X99.417 Y136.983 E.06524
G1 X98.884 Y136.983
G1 X100.449 Y135.417 E.06524
G1 X99.916 Y135.417
G1 X98.35 Y136.983 E.06524
G1 X97.817 Y136.983
G1 X99.382 Y135.417 E.06524
G1 X98.849 Y135.417
G1 X97.284 Y136.983 E.06524
G1 X96.751 Y136.983
G1 X98.316 Y135.417 E.06524
G1 X97.783 Y135.417
G1 X96.217 Y136.983 E.06524
G1 X95.684 Y136.983
G1 X97.249 Y135.417 E.06524
G1 X96.792 Y135.342
G1 X95.216 Y136.918 E.0657
G1 X95.02 Y136.58
G1 X96.583 Y135.018 E.06513
G1 X96.583 Y134.484
G1 X95.017 Y136.05 E.06524
G1 X95.018 Y135.516
G1 X96.583 Y133.951 E.06524
G1 X96.583 Y133.418
G1 X95.018 Y134.983 E.06523
G1 X95.018 Y134.45
G1 X96.583 Y132.885 E.06523
G1 X96.583 Y132.351
G1 X95.018 Y133.916 E.06523
G1 X95.018 Y133.383
G1 X96.583 Y131.818 E.06522
G1 X96.583 Y131.285
G1 X95.018 Y132.85 E.06522
G1 X95.018 Y132.316
G1 X96.583 Y130.752 E.06522
G1 X96.583 Y130.218
G1 X95.018 Y131.783 E.06521
G1 X95.018 Y131.25
G1 X96.583 Y129.685 E.06521
G1 X96.583 Y129.152
G1 X95.018 Y130.716 E.06521
G1 X95.018 Y130.183
M73 P98 R0
G1 X96.583 Y128.619 E.0652
G1 X96.583 Y128.085
G1 X95.018 Y129.65 E.0652
G1 X95.018 Y129.116
G1 X96.583 Y127.552 E.0652
G1 X96.583 Y127.019
G1 X95.019 Y128.583 E.0652
G1 X95.019 Y128.05
G1 X96.583 Y126.486 E.06519
G1 X96.583 Y125.952
G1 X95.019 Y127.516 E.06519
G1 X95.019 Y126.983
G1 X96.583 Y125.419 E.06519
G1 X96.583 Y124.886
G1 X95.019 Y126.45 E.06518
G1 X95.019 Y125.916
G1 X96.583 Y124.352 E.06518
G1 X96.583 Y123.819
G1 X95.019 Y125.383 E.06518
G1 X95.019 Y124.85
G1 X96.583 Y123.286 E.06517
G1 X96.583 Y122.753
G1 X95.019 Y124.316 E.06517
G1 X95.019 Y123.783
G1 X96.583 Y122.219 E.06517
G1 X96.583 Y121.686
G1 X95.019 Y123.25 E.06516
G1 X95.019 Y122.716
G1 X96.583 Y121.153 E.06516
; WIPE_START
M204 S3000
G1 X95.168 Y122.567 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X95.019 Y122.183 Z8.4 F12000
G1 Z8
G1 E.8 F1800
G1 F3600
M204 S2000
G1 X98.185 Y119.017 E.13194
G1 X97.652 Y119.017
G1 X95.019 Y121.65 E.10971
G1 X95.02 Y121.116
G1 X97.118 Y119.017 E.08748
G1 X96.585 Y119.017
G1 X95.02 Y120.583 E.06525
G1 X95.02 Y120.05
G1 X96.052 Y119.017 E.04302
G1 X95.519 Y119.017
G1 X95.02 Y119.516 E.02079
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F3600
M204 S3000
G1 X95.519 Y119.017 E-.2681
G1 X96.052 Y119.017 E-.20263
G1 X95.514 Y119.556 E-.28927
; WIPE_END
G1 E-.04 F1800
M204 S10000
G17
G3 Z8.4 I1.217 J0 P1  F12000
; stop printing object, unique label id: 47
M625
M106 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 

;===== date: 20260513 =====================
G392 S0 ;turn off nozzle clog detect

M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G90
G1 Z8.4 F900 ; lower z a little
G1 X0 Y128 F18000 ; move to safe pos
G1 X-13.0 F3000 ; move to safe pos

M1002 judge_flag timelapse_record_flag
M622 J1
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M400 P100
M971 S11 C11 O0
M991 S0 P-1 ;end timelapse at safe pos
M623


M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

;G1 X27 F15000 ; wipe

; pull back filament to AMS
M620 S255
G1 X267 F15000
T255
G1 X-28.5 F18000
G1 X-48.2 F3000
G1 X-28.5 F18000
G1 X-48.2 F3000
M621 S255

M104 S0 ; turn off hotend

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    G1 Z108 F600
    G1 Z106

M400 P100
M17 R ; restore z current

G90
G1 X-48 Y180 F3600

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

;=====printer finish  sound=========
M17
M400 S1
M1006 S1
M1006 A0 B20 L100 C37 D20 M40 E42 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C46 D10 M80 E46 F10 N80
M1006 A44 B20 L100 C39 D20 M60 E48 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C48 D10 M60 E44 F10 N80
M1006 A0 B10 L100 C0 D10 M60 E0 F10  N80
M1006 A44 B20 L100 C49 D20 M80 E41 F20 N80
M1006 A0 B20 L100 C0 D20 M60 E0 F20 N80
M1006 A0 B20 L100 C37 D20 M30 E37 F20 N60
M1006 W
;=====printer finish  sound=========

;M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M400
M18 X Y Z

M73 P100 R0
; EXECUTABLE_BLOCK_END

