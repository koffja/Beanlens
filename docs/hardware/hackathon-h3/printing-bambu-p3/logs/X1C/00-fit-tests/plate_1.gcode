; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 11m 14s; total estimated time: 19m 34s
; total layer number: 40
; total filament length [mm] : 1173.31
; total filament volume [cm^3] : 2822.13
; total filament weight [g] : 3.61
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
; bed_exclude_area = 0x0,18x0,18x28,0x28
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
; change_filament_gcode = ;=X1 20251031=\nM620 S[next_extruder]A\nM204 S9000\nG1 Z{max_layer_z + 3.0} F1200\n\nG1 X70 F21000\nG1 Y245\nG1 Y265 F3000\nM400\nM106 P1 S0\nM106 P2 S0\n{if old_filament_temp > 142 && next_extruder < 255}\nM104 S[old_filament_temp]\n{endif}\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E-{retraction_distances_when_cut[previous_extruder]} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\n{else}\nM620.11 S0\n{endif}\nM400\nG1 X90 F3000\nG1 Y255 F4000\nG1 X100 F5000\nG1 X120 F15000\nG1 X20 Y50 F21000\nG1 Y-3\n{if toolchange_count == 2}\n; get travel path for change filament\nM620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0\nM620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1\nM620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2\n{endif}\nM620.1 E F{flush_volumetric_speeds[previous_extruder]/2.4053*60} T{flush_temperatures[previous_extruder]}\nT[next_extruder]\nM620.1 E F{flush_volumetric_speeds[next_extruder]/2.4053*60} T{flush_temperatures[next_extruder]}\n\n{if next_extruder < 255}\n{if long_retractions_when_cut[previous_extruder]}\nM620.11 S1 I[previous_extruder] E{retraction_distances_when_cut[previous_extruder]} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\nM628 S1\nG92 E0\nG1 E{retraction_distances_when_cut[previous_extruder]} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\nM400\nM629 S1\n{else}\nM620.11 S0\n{endif}\nG92 E0\n{if flush_length_1 > 1}\nM83\n; FLUSH_START\n; always use highest temperature to flush\nM400\n{if filament_type[next_extruder] == \"PETG\"}\nM109 S260\n{elsif filament_type[next_extruder] == \"PVA\"}\nM109 S210\n{else}\nM109 S{flush_temperatures[next_extruder]}\n{endif}\n{if flush_length_1 > 23.7}\nG1 E23.7 F{flush_volumetric_speeds[previous_extruder]/2.4053*60} ; do not need pulsatile flushing for start part\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\n{else}\nG1 E{flush_length_1} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\n{endif}\n; FLUSH_END\nG1 E-[old_retract_length_toolchange] F1800\nG1 E[old_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_2 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_3 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_4 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\n; FLUSH_END\n{endif}\n; FLUSH_START\nM400\nM109 S[new_filament_temp]\nG1 E2 F{flush_volumetric_speeds[next_extruder]/2.4053*60} ;Compensate for filament spillage during waiting temperature\n; FLUSH_END\nM400\nG92 E0\nG1 E-[new_retract_length_toolchange] F1800\nM106 P1 S255\nM400 S3\n\nG1 X70 F5000\nG1 X90 F3000\nG1 Y255 F4000\nG1 X105 F5000\nG1 Y265 F5000\nG1 X70 F10000\nG1 X100 F5000\nG1 X70 F10000\nG1 X100 F5000\n\nG1 X70 F10000\nG1 X80 F15000\nG1 X60\nG1 X80\nG1 X60\nG1 X80 ; shake to put down garbage\nG1 X100 F5000\nG1 X165 F15000; wipe and shake\nG1 Y256 ; move Y to aside, prevent collision\nM400\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\nM621 S[next_extruder]A\n
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
; default_filament_profile = "Bambu PLA Basic @BBL X1C"
; default_jerk = 0
; default_nozzle_volume_type = Standard
; default_print_profile = 0.20mm Standard @BBL X1C
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
; extruder_clearance_dist_to_rod = 33
; extruder_clearance_height_to_lid = 90
; extruder_clearance_height_to_rod = 34
; extruder_clearance_max_radius = 68
; extruder_colour = #018001
; extruder_max_nozzle_count = 1
; extruder_nozzle_stats = 
; extruder_offset = 0x2
; extruder_printable_area = 
; extruder_type = Direct Drive
; extruder_variant_list = "Direct Drive Standard,Direct Drive High Flow"
; fan_cooling_layer_time = 20
; fan_direction = left
; fan_max_speed = 40
; fan_min_speed = 20
; farthest_point_timelapse = 1
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
; filament_flow_ratio = 0.95
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
; filament_preheat_temperature_delta = 10
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
; filament_settings_id = "Bambu PETG HF @BBL X1C"
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
; grab_length = 0
; group_algo_with_time = 0
; has_filament_switcher = 0
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 
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
; machine_end_gcode = ;===== date: 20240528 =====================\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nG1 E-0.8 F1800 ; retract\nG1 Z{max_layer_z + 0.5} F900 ; lower z a little\nG1 X65 Y245 F12000 ; move to safe pos\nG1 Y265 F3000\n\nG1 X65 Y245 F12000\nG1 Y265 F3000\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\n\nG1 X100 F12000 ; wipe\n; pull back filament to AMS\nM620 S255\nG1 X20 Y50 F12000\nG1 Y-3\nT255\nG1 X65 F12000\nG1 Y265\nG1 X100 F12000 ; wipe\nM621 S255\nM104 S0 ; turn off hotend\n\nM622.1 S1 ; for prev firware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    M400 ; wait all motion done\n    M991 S0 P-1 ;end smooth timelapse at safe pos\n    M400 S3 ;wait for last picture to be taken\nM623; end of \"timelapse_record_flag\"\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (max_layer_z + 100.0) < 250}\n    G1 Z{max_layer_z + 100.0} F600\n    G1 Z{max_layer_z +98.0}\n{else}\n    G1 Z250 F600\n    G1 Z248\n{endif}\nM400 P100\nM17 R ; restore z current\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n;=====printer finish  sound=========\nM17\nM400 S1\nM1006 S1\nM1006 A0 B20 L100 C37 D20 M40 E42 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C46 D10 M80 E46 F10 N80\nM1006 A44 B20 L100 C39 D20 M60 E48 F20 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C39 D10 M60 E39 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A0 B10 L100 C48 D10 M60 E44 F10 N100\nM1006 A0 B10 L100 C0 D10 M60 E0 F10  N100\nM1006 A49 B20 L100 C44 D20 M100 E41 F20 N100\nM1006 A0 B20 L100 C0 D20 M60 E0 F20 N100\nM1006 A0 B20 L100 C37 D20 M30 E37 F20 N60\nM1006 W\n\nM17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power\nM960 S5 P0 ; turn off logo lamp\n
; machine_hotend_change_time = 0
; machine_load_filament_time = 29
; machine_max_acceleration_e = 5000,5000
; machine_max_acceleration_extruding = 20000,20000
; machine_max_acceleration_retracting = 5000,5000
; machine_max_acceleration_travel = 9000,9000
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
; machine_max_speed_x = 500,500
; machine_max_speed_y = 500,500
; machine_max_speed_z = 20,20
; machine_min_extruding_rate = 0
; machine_min_travel_rate = 0
; machine_pause_gcode = M400 U1
; machine_prepare_compensation_time = 260
; machine_start_gcode = ;===== machine: X1-0.4 ====================\n;===== date: 20251031 ==================\n;===== start printer sound ================\nM17\nM400 S1\nM1006 S1\nM1006 A0 B10 L100 C37 D10 M60 E37 F10 N60\nM1006 A0 B10 L100 C41 D10 M60 E41 F10 N60\nM1006 A0 B10 L100 C44 D10 M60 E44 F10 N60\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N60\nM1006 A46 B10 L100 C43 D10 M70 E39 F10 N100\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N100\nM1006 A43 B10 L100 C0 D10 M60 E39 F10 N100\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N100\nM1006 A41 B10 L100 C0 D10 M100 E41 F10 N100\nM1006 A44 B10 L100 C0 D10 M100 E44 F10 N100\nM1006 A49 B10 L100 C0 D10 M100 E49 F10 N100\nM1006 A0 B10 L100 C0 D10 M100 E0 F10 N100\nM1006 A48 B10 L100 C44 D10 M60 E39 F10 N100\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N100\nM1006 A44 B10 L100 C0 D10 M90 E39 F10 N100\nM1006 A0 B10 L100 C0 D10 M60 E0 F10 N100\nM1006 A46 B10 L100 C43 D10 M60 E39 F10 N100\nM1006 W\n;===== turn on the HB fan =================\nM104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle\n;===== reset machine status =================\nM290 X40 Y40 Z2.6666666\nG91\nM17 Z0.4 ; lower the z-motor current\nG380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed\nG380 S2 Z-25 F300 ;\nG1 Z5 F300;\nG90\nM17 X1.2 Y1.2 Z0.75 ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 5\nM221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem\nG29.1 Z{+0.0} ; clear z-trim value first\nM204 S10000 ; init ACC set to 10m/s^2\n\n;===== heatbed preheat ====================\nM1002 gcode_claim_action:54\nM140 S[bed_temperature_initial_layer_single] ;set bed temp\nM190 S[bed_temperature_initial_layer_single] ;wait for bed temp\n\n{if scan_first_layer}\n;=========register first layer scan=====\nM977 S1 P60\n{endif}\n\n;=============turn on fans to prevent PLA jamming=================\n{if filament_type[initial_no_support_extruder]==\"PLA\"}\n    {if (bed_temperature[initial_no_support_extruder] >45)||(bed_temperature_initial_layer[initial_no_support_extruder] >45)}\n    M106 P3 S180\n    {endif};Prevent PLA from jamming\n    M142 P1 R35 S40\n{endif}\nM106 P2 S100 ; turn on big fan ,to cool down toolhead\n\n;===== prepare print temperature and material ==========\nM104 S[nozzle_temperature_initial_layer] ;set extruder temp\nG91\nG0 Z10 F1200\nG90\nG28 X\nM975 S1 ; turn on\nG1 X60 F12000\nG1 Y245\nG1 Y265 F3000\nM620 M\nM620 S[initial_no_support_extruder]A   ; switch material if AMS exist\n    M109 S[nozzle_temperature_initial_layer]\n    G1 X120 F12000\n\n    G1 X20 Y50 F12000\n    G1 Y-3\n    T[initial_no_support_extruder]\n    G1 X54 F12000\n    G1 Y265\n    M400\nM621 S[initial_no_support_extruder]A\nM620.1 E F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60} T{flush_temperatures[initial_no_support_extruder]}\n\nM412 S1 ; ===turn on filament runout detection===\n\nM109 S250 ;set nozzle to common flush temp\nM106 P1 S0\nG92 E0\nG1 E50 F200\nM400\nM104 S[nozzle_temperature_initial_layer]\nG92 E0\nG1 E50 F200\nM400\nM106 P1 S255\nG92 E0\nG1 E5 F300\nM109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-20} ; drop nozzle temp, make filament shink a bit\nG92 E0\nG1 E-0.5 F300\n\nG1 X70 F9000\nG1 X76 F15000\nG1 X65 F15000\nG1 X76 F15000\nG1 X65 F15000; shake to put down garbage\nG1 X80 F6000\nG1 X95 F15000\nG1 X80 F15000\nG1 X165 F15000; wipe and shake\nM400\nM106 P1 S0\n;===== prepare print temperature and material end =====\n\n\n;===== wipe nozzle ===============================\nM1002 gcode_claim_action : 14\nM975 S1\nM106 S255\nG1 X65 Y230 F18000\nG1 Y264 F6000\nM109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-20}\nG1 X100 F18000 ; first wipe mouth\n\nG0 X135 Y253 F20000  ; move to exposed steel surface edge\nG28 Z P0 T300; home z with low precision,permit 300deg temperature\nG29.2 S0 ; turn off ABL\nG0 Z5 F20000\n\nG1 X60 Y265\nG92 E0\nG1 E-0.5 F300 ; retrack more\nG1 X100 F5000; second wipe mouth\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X90 F5000\nG0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle\nM104 S140 ; set temp down to heatbed acceptable\nM106 S255 ; turn on fan (G28 has turn off fan)\n\nM221 S; push soft endstop status\nM221 Z0 ;turn off Z axis endstop\nG0 Z0.5 F20000\nG0 X125 Y259.5 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y262.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y260.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y262.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y260.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y261.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y261.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 X128\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\n\nM109 S140 ; wait nozzle temp down to heatbed acceptable\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\n\nM221 R; pop softend status\nG1 Z10 F1200\nM400\nG1 Z10\nG1 F30000\nG1 X128 Y128\nG29.2 S1 ; turn on ABL\n;G28 ; home again after hard wipe mouth\nM106 S0 ; turn off fan , too noisy\n;===== wipe nozzle end ================================\n\n;===== check scanner clarity ===========================\nG1 X128 Y128 F24000\nG28 Z P0\nM972 S5 P0\nG1 X230 Y15 F24000\n;===== check scanner clarity end =======================\n\n;===== bed leveling ==================================\nM1002 judge_flag g29_before_print_flag\nM622 J1\n\n    M1002 gcode_claim_action : 1\n    G29 A X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    M400\n    M500 ; save cali data\n\nM623\n;===== bed leveling end ================================\n\n;===== home after wipe mouth============================\nM1002 judge_flag g29_before_print_flag\nM622 J0\n\n    M1002 gcode_claim_action : 13\n    G28\n\nM623\n;===== home after wipe mouth end =======================\n\nM975 S1 ; turn on vibration supression\n\n;=============turn on fans to prevent PLA jamming=================\n{if filament_type[initial_no_support_extruder]==\"PLA\"}\n    {if (bed_temperature[initial_no_support_extruder] >45)||(bed_temperature_initial_layer[initial_no_support_extruder] >45)}\n    M106 P3 S180\n    {endif};Prevent PLA from jamming\n    M142 P1 R35 S40\n{endif}\nM106 P2 S100 ; turn on big fan ,to cool down toolhead\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]} ; set extrude temp earlier, to reduce wait time\n\n;===== mech mode fast check============================\nG1 X128 Y128 Z10 F20000\nM400 P200\nM970.3 Q1 A7 B30 C80  H15 K0\nM974 Q1 S2 P0\n\nG1 X128 Y128 Z10 F20000\nM400 P200\nM970.3 Q0 A7 B30 C90 Q0 H15 K0\nM974 Q0 S2 P0\n\nM975 S1\nG1 F30000\nG1 X230 Y15\nG28 X ; re-home XY\n;===== mech mode fast check============================\n\n{if scan_first_layer}\n;start heatbed  scan====================================\nM976 S2 P1\nG90\nG1 X128 Y128 F20000\nM976 S3 P2  ;register void printing detection\n{endif}\n\n;===== nozzle load line ===============================\nM975 S1\nG90\nM83\nT1000\nG1 X18.0 Y1.0 Z0.8 F18000;Move to start position\nM109 S{nozzle_temperature[initial_no_support_extruder]}\nG1 Z0.2\nG0 E2 F300\nG0 X240 E15 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nG0 Y11 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\nG0 X239.5\nG0 E0.2\nG0 Y1.5 E0.700\nG0 X231 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nM400\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n;curr_bed_type={curr_bed_type}\n{if curr_bed_type==\"Textured PEI Plate\"}\nG29.1 Z{-0.04} ; for Textured PEI Plate\n{endif}\n\n;===== draw extrinsic para cali paint =================\nM1002 judge_flag extrude_cali_flag\nM622 J1\n\n    M1002 gcode_claim_action : 8\n\n    T1000\n\n    G0 F1200.0 X231 Y12   Z0.2 E0.577\n    G0 F1200.0 X226 Y12   Z0.2 E0.275\n    G0 F1200.0 X226 Y1.5  Z0.2 E0.577\n    G0 F1200.0 X220 Y1.5  Z0.2 E0.330\n    G0 F1200.0 X220 Y8    Z0.2 E0.358\n    G0 F1200.0 X210 Y8    Z0.2 E0.549\n    G0 F1200.0 X210 Y1.5  Z0.2 E0.357\n\n    G0 X48.0 E11.9 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X48.0 Y12 E0.772 F1200.0\n    G0 X45.0 E0.22 F1200.0\n    G0 X35.0 Y6.0 E0.86 F1200.0\n\n    ;=========== extruder cali extrusion ==================\n    T1000\n    M83\n    {if default_acceleration > 0}\n        {if outer_wall_acceleration > 0}\n            M204 S[outer_wall_acceleration]\n        {else}\n            M204 S[default_acceleration]\n        {endif}\n    {endif}\n    G0 X35.000 Y6.000 Z0.300 F30000 E0\n    G1 F1500.000 E0.800\n    M106 S0 ; turn off fan\n    G0 X185.000 E9.35441 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G0 X187 Z0\n    G1 F1500.000 E-0.800\n    G0 Z1\n    G0 X180 Z0.3 F18000\n\n    M900 L1000.0 M1.0\n    M900 K0.040\n    G0 X45.000 F30000\n    G0 Y8.000 F30000\n    G1 F1500.000 E0.800\n    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 F1500.000 E-0.800\n    G1 X183 Z0.15 F30000\n    G1 X185\n    G1 Z1.0\n    G0 Y6.000 F30000 ; move y to clear pos\n    G1 Z0.3\n    M400\n\n    G0 X45.000 F30000\n    M900 K0.020\n    G0 X45.000 F30000\n    G0 Y10.000 F30000\n    G1 F1500.000 E0.800\n    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 F1500.000 E-0.800\n    G1 X183 Z0.15 F30000\n    G1 X185\n    G1 Z1.0\n    G0 Y6.000 F30000 ; move y to clear pos\n    G1 Z0.3\n    M400\n\n    G0 X45.000 F30000\n    M900 K0.000\n    G0 X45.000 F30000\n    G0 Y12.000 F30000\n    G1 F1500.000 E0.800\n    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 F1500.000 E-0.800\n    G1 X183 Z0.15 F30000\n    G1 X185\n    G1 Z1.0\n    G0 Y6.000 F30000 ; move y to clear pos\n    G1 Z0.3\n\n    G0 X45.000 F30000 ; move to start point\n\nM623 ; end of \"draw extrinsic para cali paint\"\n\n\nM1002 judge_flag extrude_cali_flag\nM622 J0\n    G0 X231 Y1.5 F30000\n    G0 X18 E14.3 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nM623\n\nM104 S140\n\n\n;=========== laser and rgb calibration ===========\nM400\nM18 E\nM500 R\n\nM973 S3 P14\n\nG1 X120 Y1.0 Z0.3 F18000.0;Move to first extrude line pos\nT1100\nG1 X235.0 Y1.0 Z0.3 F18000.0;Move to first extrude line pos\nM400 P100\nM960 S1 P1\nM400 P100\nM973 S6 P0; use auto exposure for horizontal laser by xcam\nM960 S0 P0\n\nG1 X240.0 Y6.0 Z0.3 F18000.0;Move to vertical extrude line pos\nM960 S2 P1\nM400 P100\nM973 S6 P1; use auto exposure for vertical laser by xcam\nM960 S0 P0\n\n;=========== handeye calibration ======================\nM1002 judge_flag extrude_cali_flag\nM622 J1\n\n    M973 S3 P1 ; camera start stream\n    M400 P500\n    M973 S1\n    G0 F6000 X228.500 Y4.750 Z0.000\n    M960 S0 P1\n    M973 S1\n    M400 P800\n    M971 S6 P0\n    M973 S2 P0\n    M400 P500\n    G0 Z0.000 F12000\n    M960 S0 P0\n    M960 S1 P1\n    G0 X215.00 Y4.750\n    M400 P200\n    M971 S5 P1\n    M973 S2 P1\n    M400 P500\n    M960 S0 P0\n    M960 S2 P1\n    G0 X228.5 Y6.75\n    M400 P200\n    M971 S5 P3\n    G0 Z0.500 F12000\n    M960 S0 P0\n    M960 S2 P1\n    G0 X228.5 Y6.75\n    M400 P200\n    M971 S5 P4\n    M973 S2 P0\n    M400 P500\n    M960 S0 P0\n    M960 S1 P1\n    G0 X215.00 Y4.750\n    M400 P500\n    M971 S5 P2\n    M963 S1\n    M400 P1500\n    M964\n    T1100\n    G1 Z3 F3000\n\n    M400\n    M500 ; save cali data\n\n    M104 S{nozzle_temperature[initial_no_support_extruder]} ; rise nozzle temp now ,to reduce temp waiting time.\n\n    T1100\n    M400 P400\n    M960 S0 P0\n    G0 F30000.000 Y10.000 X65.000 Z0.000\n    M400 P400\n    M960 S1 P1\n    M400 P50\n\n    M969 S1 N3 A2000\n    G0 F360.000 X181.000 Z0.000\n    M980.3 A70.000 B{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*60/4} C5.000 D{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*60} E5.000 F175.000 H1.000 I0.000 J0.020 K0.040\n    M400 P100\n    G0 F20000\n    G0 Z1 ; rise nozzle up\n    T1000 ; change to nozzle space\n    G0 X45.000 Y4.000 F30000 ; move to test line pos\n    M969 S0 ; turn off scanning\n    M960 S0 P0\n\n\n    G1 Z2 F20000\n    T1000\n    G0 X45.000 Y4.000 F30000 E0\n    M109 S{nozzle_temperature[initial_no_support_extruder]}\n    G0 Z0.3\n    G1 F1500.000 E3.600\n    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n\n    ; see if extrude cali success, if not ,use default value\n    M1002 judge_last_extrude_cali_success\n    M622 J0\n        M400\n        M900 K0.02 M{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*0.02}\n    M623\n\n    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X185.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X190.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X195.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X200.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X205.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X210.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X215.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X220.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X225.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    M973 S4\n\nM623\n\n;========turn off light and wait extrude temperature =============\nM1002 gcode_claim_action : 0\nM973 S4 ; turn off scanner\nM400 ; wait all motion done before implement the emprical L parameters\n;M900 L500.0 ; Empirical parameters\nM109 S[nozzle_temperature_initial_layer]\nM960 S1 P0 ; turn off laser\nM960 S2 P0 ; turn off laser\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off big fan\nM106 P3 S0 ; turn off chamber fan\n\nM975 S1 ; turn on mech mode supression\nG90\nM83\nT1000\n;===== purge line to wipe the nozzle ============================\nG1 E{-retraction_length[initial_no_support_extruder]} F1800\nG1 X18.0 Y2.5 Z0.8 F18000.0;Move to start position\nG1 E{retraction_length[initial_no_support_extruder]} F1800\nM109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\nG1 Z0.2\nG0 X239 E15 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\nG0 Y12 E0.7 F{outer_wall_volumetric_speed/(0.3*0.5)/4* 60}\n
; machine_switch_extruder_time = 0
; machine_unload_filament_time = 28
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
; nozzle_height = 4.2
; nozzle_temperature = 245
; nozzle_temperature_initial_layer = 230
; nozzle_temperature_range_high = 270
; nozzle_temperature_range_low = 230
; nozzle_type = hardened_steel
; nozzle_volume = 107
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
; print_compatible_printers = "Bambu Lab X1 Carbon 0.4 nozzle";"Bambu Lab X1 0.4 nozzle";"Bambu Lab P1S 0.4 nozzle";"Bambu Lab X1E 0.4 nozzle"
; print_extruder_id = 1
; print_extruder_variant = "Direct Drive Standard"
; print_flow_ratio = 1
; print_in_clockwise = 0
; print_sequence = by layer
; print_settings_id = 0.20mm Standard @BBL X1C
; printable_area = 0x0,256x0,256x256,0x256
; printable_height = 250
; printer_extruder_id = 1
; printer_extruder_variant = "Direct Drive Standard"
; printer_model = Bambu Lab X1 Carbon
; printer_notes = 
; printer_settings_id = Bambu Lab X1 Carbon 0.4 nozzle
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
; scan_first_layer = 1
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
; smooth_coefficient = 150
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
; time_lapse_gcode = ;========Date 20250206========\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firmware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\n{if timelapse_type == 0} ; timelapse without wipe tower\nM971 S11 C10 O0\nM1004 S5 P1  ; external shutter\n{elsif timelapse_type == 1} ; timelapse with wipe tower\nG92 E0\nG1 X65 Y245 F20000 ; move to safe pos\nG17\nG2 Z{layer_z} I0.86 J0.86 P1 F20000\nG1 Y265 F3000\nM400\nM1004 S5 P1  ; external shutter\nM400 P300\nM971 S11 C10 O0\nG92 E0\nG1 X100 F5000\nG1 Y255 F20000\n{endif}\nM623\n; SKIPPABLE_END\n
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
; upward_compatible_machine = "Bambu Lab P1S 0.4 nozzle";"Bambu Lab P1P 0.4 nozzle";"Bambu Lab X1 0.4 nozzle";"Bambu Lab X1E 0.4 nozzle";"Bambu Lab A1 0.4 nozzle";"Bambu Lab H2D 0.4 nozzle";"Bambu Lab H2D Pro 0.4 nozzle";"Bambu Lab H2S 0.4 nozzle";"Bambu Lab P2S 0.4 nozzle";"Bambu Lab H2C 0.4 nozzle";"Bambu Lab X2D 0.4 nozzle";"Bambu Lab A2L 0.4 nozzle"
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
M201 X20000 Y20000 Z500 E5000
M203 X500 Y500 Z20 E30
M204 P20000 R5000 T20000
M205 X9.00 Y9.00 Z3.00 E2.50
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: X1-0.4 ====================
;===== date: 20251031 ==================
;===== start printer sound ================
M17
M400 S1
M1006 S1
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A46 B10 L100 C43 D10 M70 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A43 B10 L100 C0 D10 M60 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A41 B10 L100 C0 D10 M100 E41 F10 N100
M1006 A44 B10 L100 C0 D10 M100 E44 F10 N100
M1006 A49 B10 L100 C0 D10 M100 E49 F10 N100
M1006 A0 B10 L100 C0 D10 M100 E0 F10 N100
M1006 A48 B10 L100 C44 D10 M60 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A44 B10 L100 C0 D10 M90 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A46 B10 L100 C43 D10 M60 E39 F10 N100
M1006 W
;===== turn on the HB fan =================
M104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle
;===== reset machine status =================
M290 X40 Y40 Z2.6666666
G91
M17 Z0.4 ; lower the z-motor current
G380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed
G380 S2 Z-25 F300 ;
G1 Z5 F300;
G90
M17 X1.2 Y1.2 Z0.75 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 5
M221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem
G29.1 Z0 ; clear z-trim value first
M204 S10000 ; init ACC set to 10m/s^2

;===== heatbed preheat ====================
M1002 gcode_claim_action:54
M140 S70 ;set bed temp
M190 S70 ;wait for bed temp


;=========register first layer scan=====
M977 S1 P60


;=============turn on fans to prevent PLA jamming=================

M106 P2 S100 ; turn on big fan ,to cool down toolhead

;===== prepare print temperature and material ==========
M104 S230 ;set extruder temp
G91
G0 Z10 F1200
G90
G28 X
M975 S1 ; turn on
G1 X60 F12000
G1 Y245
G1 Y265 F3000
M620 M
M620 S0A   ; switch material if AMS exist
    M109 S230
    G1 X120 F12000

    G1 X20 Y50 F12000
    G1 Y-3
    T0
    G1 X54 F12000
    G1 Y265
    M400
M621 S0A
M620.1 E F249.449 T270

M412 S1 ; ===turn on filament runout detection===

M109 S250 ;set nozzle to common flush temp
M106 P1 S0
G92 E0
M73 P3 R18
G1 E50 F200
M400
M104 S230
G92 E0
M73 P25 R14
G1 E50 F200
M400
M106 P1 S255
G92 E0
G1 E5 F300
M109 S210 ; drop nozzle temp, make filament shink a bit
G92 E0
M73 P26 R14
G1 E-0.5 F300

M73 P27 R14
G1 X70 F9000
G1 X76 F15000
G1 X65 F15000
G1 X76 F15000
G1 X65 F15000; shake to put down garbage
G1 X80 F6000
G1 X95 F15000
G1 X80 F15000
G1 X165 F15000; wipe and shake
M400
M106 P1 S0
;===== prepare print temperature and material end =====


;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14
M975 S1
M106 S255
G1 X65 Y230 F18000
G1 Y264 F6000
M109 S210
M73 P28 R14
G1 X100 F18000 ; first wipe mouth

G0 X135 Y253 F20000  ; move to exposed steel surface edge
G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
G0 Z5 F20000

G1 X60 Y265
G92 E0
G1 E-0.5 F300 ; retrack more
G1 X100 F5000; second wipe mouth
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X90 F5000
G0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle
M104 S140 ; set temp down to heatbed acceptable
M106 S255 ; turn on fan (G28 has turn off fan)

M221 S; push soft endstop status
M221 Z0 ;turn off Z axis endstop
G0 Z0.5 F20000
G0 X125 Y259.5 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 X128
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300

M109 S140 ; wait nozzle temp down to heatbed acceptable
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000

M221 R; pop softend status
G1 Z10 F1200
M400
M73 P28 R13
G1 Z10
G1 F30000
G1 X128 Y128
G29.2 S1 ; turn on ABL
;G28 ; home again after hard wipe mouth
M106 S0 ; turn off fan , too noisy
;===== wipe nozzle end ================================

;===== check scanner clarity ===========================
G1 X128 Y128 F24000
G28 Z P0
M972 S5 P0
G1 X230 Y15 F24000
;===== check scanner clarity end =======================

;===== bed leveling ==================================
M1002 judge_flag g29_before_print_flag
M622 J1

    M1002 gcode_claim_action : 1
    G29 A X94.6 Y116 I69.4 J24
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

M975 S1 ; turn on vibration supression

;=============turn on fans to prevent PLA jamming=================

M106 P2 S100 ; turn on big fan ,to cool down toolhead

M104 S230 ; set extrude temp earlier, to reduce wait time

;===== mech mode fast check============================
G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q1 A7 B30 C80  H15 K0
M974 Q1 S2 P0

M73 P29 R13
G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q0 A7 B30 C90 Q0 H15 K0
M974 Q0 S2 P0

M975 S1
G1 F30000
G1 X230 Y15
G28 X ; re-home XY
;===== mech mode fast check============================


;start heatbed  scan====================================
M976 S2 P1
G90
G1 X128 Y128 F20000
M976 S3 P2  ;register void printing detection


;===== nozzle load line ===============================
M975 S1
G90
M83
T1000
G1 X18.0 Y1.0 Z0.8 F18000;Move to start position
M109 S245
G1 Z0.2
G0 E2 F300
G0 X240 E15 F1809.98
G0 Y11 E0.700 F452.496
G0 X239.5
G0 E0.2
G0 Y1.5 E0.700
G0 X231 E0.700 F1809.98
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type=Textured PEI Plate

G29.1 Z-0.04 ; for Textured PEI Plate


;===== draw extrinsic para cali paint =================
M1002 judge_flag extrude_cali_flag
M622 J1

    M1002 gcode_claim_action : 8

    T1000

    G0 F1200.0 X231 Y12   Z0.2 E0.577
    G0 F1200.0 X226 Y12   Z0.2 E0.275
    G0 F1200.0 X226 Y1.5  Z0.2 E0.577
    G0 F1200.0 X220 Y1.5  Z0.2 E0.330
    G0 F1200.0 X220 Y8    Z0.2 E0.358
    G0 F1200.0 X210 Y8    Z0.2 E0.549
    G0 F1200.0 X210 Y1.5  Z0.2 E0.357

    G0 X48.0 E11.9 F1809.98
    G0 X48.0 Y12 E0.772 F1200.0
    G0 X45.0 E0.22 F1200.0
    G0 X35.0 Y6.0 E0.86 F1200.0

    ;=========== extruder cali extrusion ==================
    T1000
    M83
    
        
            M204 S1500
        
    
    G0 X35.000 Y6.000 Z0.300 F30000 E0
    G1 F1500.000 E0.800
    M106 S0 ; turn off fan
    G0 X185.000 E9.35441 F1809.98
    G0 X187 Z0
    G1 F1500.000 E-0.800
    G0 Z1
    G0 X180 Z0.3 F18000

    M900 L1000.0 M1.0
    M900 K0.040
    G0 X45.000 F30000
    G0 Y8.000 F30000
    G1 F1500.000 E0.800
    G1 X65.000 E1.24726 F452.496
    G1 X70.000 E0.31181 F452.496
    G1 X75.000 E0.31181 F1809.98
    G1 X80.000 E0.31181 F452.496
    G1 X85.000 E0.31181 F1809.98
    G1 X90.000 E0.31181 F452.496
M73 P30 R13
    G1 X95.000 E0.31181 F1809.98
    G1 X100.000 E0.31181 F452.496
    G1 X105.000 E0.31181 F1809.98
    G1 X110.000 E0.31181 F452.496
    G1 X115.000 E0.31181 F1809.98
    G1 X120.000 E0.31181 F452.496
    G1 X125.000 E0.31181 F1809.98
    G1 X130.000 E0.31181 F452.496
    G1 X135.000 E0.31181 F1809.98
    G1 X140.000 E0.31181 F452.496
    G1 X145.000 E0.31181 F1809.98
    G1 X150.000 E0.31181 F452.496
    G1 X155.000 E0.31181 F1809.98
    G1 X160.000 E0.31181 F452.496
M73 P31 R13
    G1 X165.000 E0.31181 F1809.98
    G1 X170.000 E0.31181 F452.496
    G1 X175.000 E0.31181 F1809.98
    G1 X180.000 E0.31181 F1809.98
    G1 F1500.000 E-0.800
    G1 X183 Z0.15 F30000
    G1 X185
    G1 Z1.0
    G0 Y6.000 F30000 ; move y to clear pos
    G1 Z0.3
    M400

    G0 X45.000 F30000
    M900 K0.020
    G0 X45.000 F30000
    G0 Y10.000 F30000
    G1 F1500.000 E0.800
    G1 X65.000 E1.24726 F452.496
    G1 X70.000 E0.31181 F452.496
    G1 X75.000 E0.31181 F1809.98
    G1 X80.000 E0.31181 F452.496
    G1 X85.000 E0.31181 F1809.98
    G1 X90.000 E0.31181 F452.496
    G1 X95.000 E0.31181 F1809.98
    G1 X100.000 E0.31181 F452.496
    G1 X105.000 E0.31181 F1809.98
    G1 X110.000 E0.31181 F452.496
    G1 X115.000 E0.31181 F1809.98
    G1 X120.000 E0.31181 F452.496
    G1 X125.000 E0.31181 F1809.98
M73 P32 R13
    G1 X130.000 E0.31181 F452.496
    G1 X135.000 E0.31181 F1809.98
    G1 X140.000 E0.31181 F452.496
    G1 X145.000 E0.31181 F1809.98
    G1 X150.000 E0.31181 F452.496
    G1 X155.000 E0.31181 F1809.98
    G1 X160.000 E0.31181 F452.496
    G1 X165.000 E0.31181 F1809.98
    G1 X170.000 E0.31181 F452.496
    G1 X175.000 E0.31181 F1809.98
    G1 X180.000 E0.31181 F1809.98
    G1 F1500.000 E-0.800
    G1 X183 Z0.15 F30000
M73 P33 R13
    G1 X185
    G1 Z1.0
    G0 Y6.000 F30000 ; move y to clear pos
    G1 Z0.3
    M400

    G0 X45.000 F30000
    M900 K0.000
    G0 X45.000 F30000
    G0 Y12.000 F30000
    G1 F1500.000 E0.800
    G1 X65.000 E1.24726 F452.496
    G1 X70.000 E0.31181 F452.496
M73 P33 R12
    G1 X75.000 E0.31181 F1809.98
    G1 X80.000 E0.31181 F452.496
    G1 X85.000 E0.31181 F1809.98
    G1 X90.000 E0.31181 F452.496
    G1 X95.000 E0.31181 F1809.98
    G1 X100.000 E0.31181 F452.496
    G1 X105.000 E0.31181 F1809.98
    G1 X110.000 E0.31181 F452.496
M73 P34 R12
    G1 X115.000 E0.31181 F1809.98
    G1 X120.000 E0.31181 F452.496
    G1 X125.000 E0.31181 F1809.98
    G1 X130.000 E0.31181 F452.496
    G1 X135.000 E0.31181 F1809.98
    G1 X140.000 E0.31181 F452.496
    G1 X145.000 E0.31181 F1809.98
    G1 X150.000 E0.31181 F452.496
    G1 X155.000 E0.31181 F1809.98
    G1 X160.000 E0.31181 F452.496
    G1 X165.000 E0.31181 F1809.98
    G1 X170.000 E0.31181 F452.496
    G1 X175.000 E0.31181 F1809.98
    G1 X180.000 E0.31181 F1809.98
    G1 F1500.000 E-0.800
    G1 X183 Z0.15 F30000
    G1 X185
    G1 Z1.0
    G0 Y6.000 F30000 ; move y to clear pos
    G1 Z0.3

    G0 X45.000 F30000 ; move to start point

M623 ; end of "draw extrinsic para cali paint"


M1002 judge_flag extrude_cali_flag
M622 J0
    G0 X231 Y1.5 F30000
    G0 X18 E14.3 F1809.98
M623

M104 S140


;=========== laser and rgb calibration ===========
M400
M18 E
M500 R

M973 S3 P14

G1 X120 Y1.0 Z0.3 F18000.0;Move to first extrude line pos
T1100
G1 X235.0 Y1.0 Z0.3 F18000.0;Move to first extrude line pos
M400 P100
M960 S1 P1
M400 P100
M973 S6 P0; use auto exposure for horizontal laser by xcam
M960 S0 P0

G1 X240.0 Y6.0 Z0.3 F18000.0;Move to vertical extrude line pos
M960 S2 P1
M400 P100
M973 S6 P1; use auto exposure for vertical laser by xcam
M960 S0 P0

;=========== handeye calibration ======================
M1002 judge_flag extrude_cali_flag
M622 J1

    M973 S3 P1 ; camera start stream
    M400 P500
    M973 S1
    G0 F6000 X228.500 Y4.750 Z0.000
    M960 S0 P1
    M973 S1
    M400 P800
    M971 S6 P0
    M973 S2 P0
    M400 P500
    G0 Z0.000 F12000
    M960 S0 P0
    M960 S1 P1
    G0 X215.00 Y4.750
    M400 P200
    M971 S5 P1
    M973 S2 P1
    M400 P500
    M960 S0 P0
    M960 S2 P1
    G0 X228.5 Y6.75
    M400 P200
    M971 S5 P3
    G0 Z0.500 F12000
    M960 S0 P0
    M960 S2 P1
    G0 X228.5 Y6.75
    M400 P200
    M971 S5 P4
    M973 S2 P0
    M400 P500
    M960 S0 P0
    M960 S1 P1
    G0 X215.00 Y4.750
    M400 P500
    M971 S5 P2
    M963 S1
    M400 P1500
    M964
    T1100
    G1 Z3 F3000

    M400
    M500 ; save cali data

    M104 S245 ; rise nozzle temp now ,to reduce temp waiting time.

    T1100
    M400 P400
    M960 S0 P0
    G0 F30000.000 Y10.000 X65.000 Z0.000
    M400 P400
    M960 S1 P1
    M400 P50

    M969 S1 N3 A2000
    G0 F360.000 X181.000 Z0.000
    M980.3 A70.000 B28.2332 C5.000 D112.933 E5.000 F175.000 H1.000 I0.000 J0.020 K0.040
    M400 P100
    G0 F20000
    G0 Z1 ; rise nozzle up
    T1000 ; change to nozzle space
    G0 X45.000 Y4.000 F30000 ; move to test line pos
    M969 S0 ; turn off scanning
    M960 S0 P0


    G1 Z2 F20000
    T1000
    G0 X45.000 Y4.000 F30000 E0
    M109 S245
    G0 Z0.3
    G1 F1500.000 E3.600
    G1 X65.000 E1.24726 F452.496
    G1 X70.000 E0.31181 F452.496
    G1 X75.000 E0.31181 F1809.98
    G1 X80.000 E0.31181 F452.496
    G1 X85.000 E0.31181 F1809.98
    G1 X90.000 E0.31181 F452.496
    G1 X95.000 E0.31181 F1809.98
    G1 X100.000 E0.31181 F452.496
    G1 X105.000 E0.31181 F1809.98
M73 P35 R12
    G1 X110.000 E0.31181 F452.496
    G1 X115.000 E0.31181 F1809.98
    G1 X120.000 E0.31181 F452.496
    G1 X125.000 E0.31181 F1809.98
    G1 X130.000 E0.31181 F452.496
    G1 X135.000 E0.31181 F1809.98

    ; see if extrude cali success, if not ,use default value
    M1002 judge_last_extrude_cali_success
    M622 J0
        M400
        M900 K0.02 M0.0376442
    M623

    G1 X140.000 E0.31181 F452.496
    G1 X145.000 E0.31181 F1809.98
    G1 X150.000 E0.31181 F452.496
    G1 X155.000 E0.31181 F1809.98
    G1 X160.000 E0.31181 F452.496
    G1 X165.000 E0.31181 F1809.98
    G1 X170.000 E0.31181 F452.496
    G1 X175.000 E0.31181 F1809.98
    G1 X180.000 E0.31181 F452.496
    G1 X185.000 E0.31181 F1809.98
    G1 X190.000 E0.31181 F452.496
    G1 X195.000 E0.31181 F1809.98
    G1 X200.000 E0.31181 F452.496
    G1 X205.000 E0.31181 F1809.98
    G1 X210.000 E0.31181 F452.496
    G1 X215.000 E0.31181 F1809.98
    G1 X220.000 E0.31181 F452.496
    G1 X225.000 E0.31181 F1809.98
    M973 S4

M623

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M973 S4 ; turn off scanner
M400 ; wait all motion done before implement the emprical L parameters
;M900 L500.0 ; Empirical parameters
M109 S230
M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000
;===== purge line to wipe the nozzle ============================
G1 E-0.8 F1800
G1 X18.0 Y2.5 Z0.8 F18000.0;Move to start position
G1 E0.8 F1800
M109 S230
G1 Z0.2
G0 X239 E15 F1809.98
G0 Y12 E0.7 F452.496
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
M106 P2 S0
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
G1 X162.682 Y115.317 F12000
M204 S6000
M73 P36 R12
G1 Z.4
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.50604
G1 F1200
M204 S500
G1 X162.682 Y116.256 E.03434
G1 X162.379 Y115.801 E.01997
G1 X162.135 Y115.567 E.01237
G1 X161.738 Y115.317 E.01718
G1 X162.622 Y115.317 E.03234
; WIPE_START
G1 X162.682 Y116.256 E-.35742
G1 X162.379 Y115.801 E-.20747
G1 X162.135 Y115.567 E-.12845
G1 X161.987 Y115.474 E-.06666
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X162.249 Y123.102 Z.6 F12000
G1 X162.683 Y135.718 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.49989
G1 F1200
M204 S500
G1 X162.683 Y136.686 E.03493
G1 X161.723 Y136.686 E.03464
G1 X162.093 Y136.465 E.01557
G1 X162.384 Y136.186 E.01453
G1 X162.65 Y135.769 E.01787
; WIPE_START
G1 X162.683 Y136.686 E-.34876
M73 P37 R12
G1 X161.723 Y136.686 E-.36464
G1 X161.828 Y136.623 E-.0466
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X154.196 Y136.642 Z.6 F12000
G1 X138.26 Y136.682 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.50726
G1 F1200
M204 S500
G1 X137.318 Y136.682 E.03457
G1 X137.318 Y135.745 E.03436
G1 X137.635 Y136.212 E.02069
G2 X138.207 Y136.656 I1.487 J-1.327 E.02669
; WIPE_START
G1 X137.318 Y136.682 E-.33794
G1 X137.318 Y135.745 E-.35597
M73 P38 R12
G1 X137.416 Y135.889 E-.06609
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X137.731 Y128.263 Z.6 F12000
G1 X138.266 Y115.314 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.49997
G1 F1200
M204 S500
G2 X137.617 Y115.814 I.929 J1.879 E.02977
G1 X137.317 Y116.286 E.0202
G1 X137.317 Y115.314 E.03509
M73 P40 R11
G1 X138.206 Y115.314 E.0321
; WIPE_START
G1 X137.945 Y115.511 E-.12418
G1 X137.617 Y115.814 E-.16977
G1 X137.317 Y116.286 E-.21264
G1 X137.317 Y115.619 E-.25341
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X144.95 Y115.63 Z.6 F12000
G1 X161.381 Y115.653 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.584124
G1 F1200
M204 S500
G1 X161.425 Y115.674 E.00208
; LINE_WIDTH: 0.542057
G1 X161.605 Y115.76 E.00787
; LINE_WIDTH: 0.49999
G1 X161.971 Y116.047 E.01679
G1 X162.195 Y116.315 E.01262
; LINE_WIDTH: 0.548014
G1 X162.288 Y116.47 E.0072
; LINE_WIDTH: 0.596037
G1 X162.38 Y116.625 E.00788
; LINE_WIDTH: 0.64406
G1 X162.472 Y116.78 E.00857
G1 X162.514 Y117.197 E.01986
; LINE_WIDTH: 0.6143
G1 X162.511 Y134.878 E.79805
G1 X162.478 Y135.064 E.00854
; LINE_WIDTH: 0.59555
M73 P41 R11
G1 X162.357 Y135.338 E.01305
; LINE_WIDTH: 0.54777
G1 X162.236 Y135.611 E.01193
; LINE_WIDTH: 0.49999
G1 X161.957 Y135.986 E.01686
G1 X161.585 Y136.254 E.01655
; LINE_WIDTH: 0.54861
G1 X161.324 Y136.366 E.01136
; LINE_WIDTH: 0.59723
G1 X161.063 Y136.479 E.01245
; LINE_WIDTH: 0.61585
G1 X160.878 Y136.512 E.00851
G1 X139.193 Y136.514 E.98139
; LINE_WIDTH: 0.62158
G3 X138.813 Y136.427 I-.073 J-.55 E.01822
; LINE_WIDTH: 0.58105
G1 X138.634 Y136.349 E.00832
; LINE_WIDTH: 0.54052
G1 X138.454 Y136.271 E.00769
; LINE_WIDTH: 0.49999
G3 X137.948 Y135.874 I.739 J-1.463 E.02338
; LINE_WIDTH: 0.52655
G1 X137.654 Y135.42 E.02069
; LINE_WIDTH: 0.56601
G1 X137.612 Y135.354 E.00322
; LINE_WIDTH: 0.60547
G1 X137.57 Y135.288 E.00346
; LINE_WIDTH: 0.64493
G1 X137.528 Y135.222 E.00371
G1 X137.486 Y134.805 E.01995
; LINE_WIDTH: 0.61424
G1 X137.487 Y117.16 E.79632
; LINE_WIDTH: 0.62757
G3 X137.588 Y116.787 I.58 J-.043 E.01817
; LINE_WIDTH: 0.585044
G1 X137.675 Y116.59 E.00925
; LINE_WIDTH: 0.542517
G1 X137.762 Y116.392 E.00853
; LINE_WIDTH: 0.49999
G1 X138.044 Y116.014 E.01702
G1 X138.506 Y115.703 E.0201
; LINE_WIDTH: 0.54011
G1 X138.691 Y115.634 E.00775
; LINE_WIDTH: 0.58023
M73 P42 R11
G1 X138.875 Y115.564 E.00838
; LINE_WIDTH: 0.62035
G3 X139.193 Y115.486 I.289 J.488 E.01515
; LINE_WIDTH: 0.61439
G1 X160.803 Y115.486 E.97553
; LINE_WIDTH: 0.62619
G1 X161.065 Y115.502 E.01207
G1 X161.245 Y115.588 E.0092
; LINE_WIDTH: 0.584124
G1 X161.327 Y115.627 E.00389
M204 S6000
G1 X161.175 Y116.08 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.49999
G1 F1200
M204 S500
G1 X161.5 Y116.228 E.01291
G1 X161.788 Y116.523 E.0149
G1 X161.95 Y116.864 E.0136
G1 X162 Y117.197 E.01216
G1 X161.997 Y134.878 E.63839
G1 X161.867 Y135.342 E.01742
G1 X161.586 Y135.704 E.01651
G1 X161.263 Y135.904 E.01374
G1 X160.878 Y135.997 E.01429
G1 X139.193 Y136 E.78294
G1 X138.973 Y135.975 E.00802
G1 X138.535 Y135.795 E.01706
G1 X138.259 Y135.539 E.01362
G1 X138.051 Y135.138 E.0163
G1 X138 Y134.805 E.01217
G1 X138.001 Y117.16 E.63708
G1 X138.132 Y116.661 E.01864
G1 X138.422 Y116.29 E.01699
G1 X138.823 Y116.063 E.01662
G1 X139.193 Y116 E.01356
G1 X160.803 Y116 E.78024
G1 X161.079 Y116.036 E.01003
G1 X161.12 Y116.055 E.00163
; WIPE_START
G1 X161.5 Y116.228 E-.15863
G1 X161.788 Y116.523 E-.15686
G1 X161.95 Y116.864 E-.14314
G1 X162 Y117.197 E-.12794
G1 X162 Y117.653 E-.17343
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X162.987 Y114.94 Z.6 F12000
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S500
G1 X163.109 Y115.081 E.00673
G1 X163.142 Y115.278 E.00721
G1 X163.142 Y116.087 E.02922
; LINE_WIDTH: 0.548014
G1 X163.118 Y116.303 E.00864
; LINE_WIDTH: 0.596037
G1 X163.094 Y116.518 E.00946
; LINE_WIDTH: 0.64406
G2 X163.085 Y117.197 I2.341 J.37 E.03235
; LINE_WIDTH: 0.6143
G1 X163.083 Y134.878 E.79805
G1 X163.102 Y135.08 E.00917
; LINE_WIDTH: 0.576197
G1 X163.121 Y135.283 E.00856
; LINE_WIDTH: 0.538094
G1 X163.14 Y135.485 E.00795
; LINE_WIDTH: 0.49999
G1 X163.14 Y136.701 E.0439
G1 X163.103 Y136.932 E.00847
G1 X162.965 Y137.078 E.00724
; object ids of layer 1 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer1 end: 47,58
M625
G1 X162.736 Y137.143 E.00858
G1 X161.48 Y137.143 E.04535
; LINE_WIDTH: 0.53861
G1 X161.28 Y137.124 E.0079
; LINE_WIDTH: 0.57723
G1 X161.079 Y137.104 E.00851
; LINE_WIDTH: 0.61585
G1 X160.878 Y137.085 E.00913
G1 X139.193 Y137.086 E.9814
; LINE_WIDTH: 0.61439
G1 X138.938 Y137.106 E.01154
; LINE_WIDTH: 0.574165
G1 X138.683 Y137.126 E.01073
; LINE_WIDTH: 0.53394
G1 X137.828 Y137.143 E.03319
; LINE_WIDTH: 0.49999
G1 X137.116 Y137.125 E.02572
G1 X136.943 Y137.012 E.00744
G1 X136.857 Y136.743 E.0102
G1 X136.857 Y135.91 E.03006
; LINE_WIDTH: 0.54871
G1 X136.882 Y135.702 E.00839
; LINE_WIDTH: 0.59743
G1 X136.906 Y135.493 E.0092
; LINE_WIDTH: 0.64615
G1 X136.93 Y135.285 E.01
G1 X136.915 Y134.805 E.02288
; LINE_WIDTH: 0.61424
G1 X136.917 Y117.16 E.79632
; LINE_WIDTH: 0.62757
G2 X136.904 Y116.792 I-.971 J-.15 E.01712
; LINE_WIDTH: 0.587377
G1 X136.884 Y116.667 E.00545
; LINE_WIDTH: 0.547184
G1 X136.864 Y116.541 E.00505
; LINE_WIDTH: 0.50699
G1 X136.86 Y116.099 E.01622
; LINE_WIDTH: 0.49999
G1 X136.86 Y115.299 E.02888
G1 X136.897 Y115.068 E.00846
G1 X137.035 Y114.922 E.00723
G1 X137.264 Y114.857 E.00858
G1 X137.89 Y114.857 E.02262
; LINE_WIDTH: 0.51766
G1 X138.673 Y114.866 E.02938
; LINE_WIDTH: 0.566025
G1 X138.933 Y114.89 E.01079
; LINE_WIDTH: 0.61439
G1 X139.193 Y114.914 E.01178
G1 X160.803 Y114.914 E.97553
; LINE_WIDTH: 0.62619
G2 X161.324 Y114.899 I.193 J-2.339 E.02406
; LINE_WIDTH: 0.584124
G1 X161.555 Y114.878 E.00991
; LINE_WIDTH: 0.542057
G1 X161.786 Y114.857 E.00914
; LINE_WIDTH: 0.49999
G1 X162.729 Y114.857 E.03404
G1 X162.933 Y114.917 E.0077
M204 S6000
G1 X163.357 Y114.634 F12000
; FEATURE: Outer wall
M73 P43 R11
G1 F1200
M204 S500
G1 X163.361 Y114.636 E.00016
G1 X163.537 Y114.899 E.01141
G1 X163.599 Y115.278 E.01387
G1 X163.597 Y136.741 E.77493
G1 X163.523 Y137.131 E.01432
G1 X163.34 Y137.384 E.01126
G1 X163.073 Y137.547 E.01131
G1 X162.777 Y137.6 E.01088
G1 X137.828 Y137.6 E.90078
G1 X137.111 Y137.585 E.02589
G1 X136.758 Y137.463 E.01349
G1 X136.577 Y137.296 E.0089
G1 X136.442 Y137.045 E.01028
G1 X136.4 Y136.779 E.00973
G1 X136.403 Y115.259 E.777
G1 X136.476 Y114.869 E.01431
G1 X136.659 Y114.617 E.01126
G1 X136.927 Y114.453 E.01132
G1 X137.223 Y114.4 E.01088
G1 X162.684 Y114.4 E.91926
G1 X163.105 Y114.465 E.01538
G1 X163.308 Y114.601 E.0088
; OBJECT_ID: 47
; WIPE_START
G1 X163.361 Y114.636 E-.0245
G1 X163.537 Y114.899 E-.12013
G1 X163.599 Y115.278 E-.14593
G1 X163.599 Y116.514 E-.46944
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S6000
G1 X156.471 Y119.244 Z.6 F12000
G1 X116.533 Y134.541 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S500
G1 X116.023 Y134.541 E.01843
; LINE_WIDTH: 0.53781
G1 X115.739 Y134.522 E.01112
; LINE_WIDTH: 0.57563
G1 X115.455 Y134.503 E.01197
; LINE_WIDTH: 0.61345
G1 X115.171 Y134.484 E.01282
; LINE_WIDTH: 0.61432
G1 X96.829 Y134.486 E.82794
G1 X96.545 Y134.505 E.01285
; LINE_WIDTH: 0.57621
G1 X96.261 Y134.524 E.01199
; LINE_WIDTH: 0.5381
G1 X95.977 Y134.543 E.01113
; LINE_WIDTH: 0.49999
G1 X95.46 Y134.536 E.01863
G1 X95.457 Y134.023 E.0185
; LINE_WIDTH: 0.538094
G1 X95.476 Y133.739 E.01113
; LINE_WIDTH: 0.576197
G1 X95.495 Y133.455 E.01199
; LINE_WIDTH: 0.6143
G1 X95.514 Y133.171 E.01285
G1 X95.516 Y118.829 E.64737
; LINE_WIDTH: 0.61344
G1 X95.497 Y118.544 E.01284
; LINE_WIDTH: 0.575624
G1 X95.478 Y118.26 E.01199
; LINE_WIDTH: 0.537807
G1 X95.459 Y117.976 E.01113
; LINE_WIDTH: 0.49999
G1 X95.463 Y117.461 E.01858
G1 X95.978 Y117.457 E.01858
; LINE_WIDTH: 0.538074
G1 X96.262 Y117.476 E.01112
; LINE_WIDTH: 0.576157
G1 X96.545 Y117.495 E.01197
; LINE_WIDTH: 0.61424
G1 X96.829 Y117.514 E.01283
G1 X115.172 Y117.517 E.82783
; LINE_WIDTH: 0.61237
G1 X115.456 Y117.499 E.01281
; LINE_WIDTH: 0.57491
G1 X115.74 Y117.48 E.01197
; LINE_WIDTH: 0.53745
G1 X116.024 Y117.461 E.01113
; LINE_WIDTH: 0.49999
G1 X116.542 Y117.473 E.0187
G1 X116.542 Y117.979 E.01826
; LINE_WIDTH: 0.538
G1 X116.523 Y118.262 E.0111
; LINE_WIDTH: 0.57601
G1 X116.504 Y118.545 E.01195
; LINE_WIDTH: 0.61402
G1 X116.485 Y118.829 E.0128
G1 X116.484 Y133.171 E.64705
; LINE_WIDTH: 0.62122
G2 X116.501 Y133.575 I1.806 J.129 E.01847
; LINE_WIDTH: 0.58081
G1 X116.521 Y133.799 E.00956
; LINE_WIDTH: 0.5404
G1 X116.541 Y134.023 E.00884
; LINE_WIDTH: 0.49999
G1 X116.534 Y134.481 E.01654
M204 S6000
G1 X116.821 Y134.925 F12000
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X116.61 Y134.998 E.00808
G1 X95.48 Y135 E.76288
G1 X95.236 Y134.959 E.00894
G1 X95.06 Y134.792 E.00874
G1 X95 Y134.576 E.00808
G1 X95.002 Y117.461 E.61795
G1 X95.066 Y117.191 E.01003
G1 X95.182 Y117.071 E.00601
G1 X95.416 Y117 E.00882
G1 X116.53 Y117.004 E.76236
G1 X116.818 Y117.073 E.01068
G1 X116.942 Y117.207 E.0066
G1 X116.999 Y117.473 E.00985
G1 X116.998 Y134.532 E.61589
G1 X116.959 Y134.732 E.00738
G1 X116.856 Y134.876 E.00639
; WIPE_START
G1 X116.61 Y134.998 E-.10446
G1 X114.884 Y134.998 E-.65554
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X107.278 Y134.368 Z.6 F12000
M73 P43 R10
G1 X96.199 Y133.451 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.58139
G1 F1200
M204 S500
G1 X96.177 Y133.419 E.00169
; LINE_WIDTH: 0.62209
G3 X96.086 Y133.171 I.153 J-.197 E.01271
; LINE_WIDTH: 0.6143
G1 X96.086 Y118.829 E.64737
; LINE_WIDTH: 0.61344
G1 X96.172 Y118.667 E.00826
; LINE_WIDTH: 0.575624
G1 X96.258 Y118.505 E.00771
; LINE_WIDTH: 0.537807
G1 X96.344 Y118.343 E.00716
; LINE_WIDTH: 0.54067
G1 X96.463 Y118.26 E.0057
; LINE_WIDTH: 0.58135
M73 P44 R10
G1 X96.581 Y118.176 E.00616
; LINE_WIDTH: 0.62203
G3 X96.829 Y118.086 I.197 J.153 E.0127
; LINE_WIDTH: 0.61424
G1 X115.171 Y118.087 E.82782
; LINE_WIDTH: 0.61237
G1 X115.333 Y118.173 E.00825
; LINE_WIDTH: 0.57491
G1 X115.495 Y118.259 E.00771
; LINE_WIDTH: 0.53745
G1 X115.657 Y118.345 E.00716
; LINE_WIDTH: 0.538
G1 X115.743 Y118.506 E.00714
; LINE_WIDTH: 0.57601
G1 X115.828 Y118.667 E.00769
; LINE_WIDTH: 0.61402
G1 X115.914 Y118.829 E.00824
G1 X115.914 Y133.171 E.64705
; LINE_WIDTH: 0.62122
G3 X115.823 Y133.419 I-.245 J.051 E.01269
; LINE_WIDTH: 0.58081
G1 X115.74 Y133.538 E.00616
; LINE_WIDTH: 0.5404
G3 X115.538 Y133.74 I-.382 J-.18 E.01145
; LINE_WIDTH: 0.580817
G1 X115.419 Y133.823 E.00616
; LINE_WIDTH: 0.62123
G3 X115.171 Y133.914 I-.197 J-.154 E.01269
; LINE_WIDTH: 0.61432
G1 X96.829 Y133.914 E.82794
G1 X96.667 Y133.828 E.00826
; LINE_WIDTH: 0.57621
G1 X96.505 Y133.742 E.00771
; LINE_WIDTH: 0.5381
G1 X96.344 Y133.656 E.00716
; LINE_WIDTH: 0.54069
G1 X96.26 Y133.538 E.00571
; LINE_WIDTH: 0.58139
G1 X96.234 Y133.5 E.00193
M204 S6000
G1 X96.013 Y133.961 F12000
; LINE_WIDTH: 0.62458
G1 F1200
M204 S500
G2 X96.049 Y134.024 I-.032 J.06 E.01617
; WIPE_START
G1 X96.013 Y134.086 E-.152
G1 X95.94 Y134.086 E-.152
G1 X95.904 Y134.024 E-.152
G1 X95.94 Y133.961 E-.152
G1 X96.013 Y133.961 E-.152
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X96.6 Y133.113 Z.6 F12000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.49999
G1 F1200
M204 S500
G1 X96.6 Y118.829 E.51576
G1 X96.667 Y118.667 E.00632
G1 X96.829 Y118.6 E.00631
G1 X115.172 Y118.6 E.66228
G1 X115.333 Y118.667 E.00633
G1 X115.4 Y118.829 E.0063
G1 X115.4 Y133.171 E.51786
G1 X115.333 Y133.333 E.00631
G1 X115.171 Y133.4 E.00632
G1 X96.829 Y133.4 E.66228
G1 X96.667 Y133.333 E.00632
G1 X96.601 Y133.173 E.00624
; WIPE_START
G1 X96.601 Y131.173 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X96.263 Y123.548 Z.6 F12000
G1 X96.014 Y117.913 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.6234
G1 F1200
M204 S500
G2 X96.05 Y117.976 I-.032 J.06 E.0161
; WIPE_START
G1 X96.014 Y118.039 E-.152
G1 X95.942 Y118.039 E-.152
G1 X95.905 Y117.976 E-.152
G1 X95.942 Y117.913 E-.152
G1 X96.014 Y117.913 E-.152
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X103.647 Y117.914 Z.6 F12000
G1 X116.06 Y117.917 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.6218
G1 F1200
M204 S500
G2 X116.097 Y117.979 I-.032 J.06 E.01602
; WIPE_START
G1 X116.06 Y118.042 E-.152
G1 X115.988 Y118.042 E-.152
G1 X115.952 Y117.979 E-.152
G1 X115.988 Y117.917 E-.152
G1 X116.06 Y117.917 E-.152
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X116.06 Y125.549 Z.6 F12000
G1 X116.059 Y133.96 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.62236
M73 P45 R10
G1 F1200
M204 S500
G2 X116.095 Y134.023 I-.032 J.06 E.01605
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F1200
G1 X116.059 Y134.085 E-.15201
G1 X115.987 Y134.085 E-.152
G1 X115.95 Y134.023 E-.152
G1 X115.987 Y133.96 E-.15201
G1 X116.059 Y133.96 E-.15198
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 2/40
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
; open powerlost recovery
M1003 S1
M976 S1 P1 ; scan model before printing 2nd layer
M400 P100
G1 E.8
M104 S245 ; set nozzle temperature
; OBJECT_ID: 58
G1 E-.8
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G1 X123.148 Y131.131 Z.6 F12000
G1 X162.62 Y115.379 Z.6
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.37467
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01699
G1 X162.416 Y115.756 E.00889
G1 X161.973 Y115.379 E.01524
G1 X162.56 Y115.379 E.01539
; WIPE_START
G1 X162.62 Y116.027 E-.24737
G1 X162.416 Y115.756 E-.12896
G1 X161.973 Y115.379 E-.22097
G1 X162.402 Y115.379 E-.16271
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.482 Y123.011 Z.8 F12000
G1 X162.618 Y135.98 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01678
G1 X161.971 Y136.622 E.01693
G1 X162.341 Y136.334 E.01226
G1 X162.581 Y136.027 E.0102
; WIPE_START
G1 X162.618 Y136.622 E-.22635
G1 X161.971 Y136.622 E-.24602
G1 X162.341 Y136.334 E-.17811
G1 X162.519 Y136.107 E-.10951
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y136.267 Z.8 F12000
G1 X138.024 Y136.621 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01693
G1 X137.379 Y135.972 E.01702
G1 X137.667 Y136.343 E.01231
G1 X137.977 Y136.584 E.0103
; WIPE_START
G1 X137.379 Y136.621 E-.22767
G1 X137.379 Y135.972 E-.24658
G1 X137.667 Y136.343 E-.17839
G1 X137.89 Y136.517 E-.10736
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.943 Y128.884 Z.8 F12000
G1 X138.036 Y115.378 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.37271
G1 F6000
M204 S3000
G1 X137.665 Y115.657 E.01211
G1 X137.381 Y116.026 E.01213
G1 X137.381 Y115.378 E.01688
G1 X137.976 Y115.378 E.01551
; WIPE_START
G1 X137.665 Y115.657 E-.15896
G1 X137.381 Y116.026 E-.17689
G1 X137.381 Y115.378 E-.24628
G1 X137.849 Y115.378 E-.17787
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.482 Y115.416 Z.8 F12000
G1 X161.367 Y115.497 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.45842
G1 F6000
M204 S3000
G1 X161.489 Y115.538 E.00422
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01132
G1 X162.121 Y115.979 E.01361
G1 X162.333 Y116.26 E.01132
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.0181
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.801 E.04969
; LINE_WIDTH: 0.44852
G1 X162.542 Y135.257 E.01476
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01116
G1 X162.092 Y136.062 E.01873
G1 X161.74 Y136.333 E.01428
G1 X161.394 Y136.502 E.01239
G1 X160.865 Y136.601 E.01731
; LINE_WIDTH: 0.43856
G1 X158.865 Y136.601 E.06251
; LINE_WIDTH: 0.43844
G1 X156.865 Y136.601 E.06249
; LINE_WIDTH: 0.43833
G1 X154.865 Y136.601 E.06247
; LINE_WIDTH: 0.43821
G1 X152.865 Y136.602 E.06245
; LINE_WIDTH: 0.4381
G1 X150.865 Y136.602 E.06243
; LINE_WIDTH: 0.43798
G1 X148.865 Y136.602 E.06241
; LINE_WIDTH: 0.43787
G1 X146.865 Y136.602 E.0624
; LINE_WIDTH: 0.43775
G1 X144.865 Y136.602 E.06238
; LINE_WIDTH: 0.43764
G1 X142.865 Y136.602 E.06236
; LINE_WIDTH: 0.43752
G1 X140.865 Y136.603 E.06234
; LINE_WIDTH: 0.43741
G1 X139.2 Y136.603 E.05188
; LINE_WIDTH: 0.44904
G1 X138.742 Y136.543 E.01479
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01115
G1 X137.939 Y136.093 E.01867
G1 X137.667 Y135.74 E.01433
G1 X137.489 Y135.356 E.01361
G1 X137.408 Y134.971 E.01266
; LINE_WIDTH: 0.44608
G1 X137.397 Y134.801 E.00543
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.398 Y117.168 E.0507
; LINE_WIDTH: 0.45045
G1 X137.493 Y116.626 E.01773
G1 X137.655 Y116.275 E.01242
; LINE_WIDTH: 0.44999
G1 X137.93 Y115.912 E.01466
G1 X138.4 Y115.587 E.01837
G1 X138.742 Y115.457 E.01177
; LINE_WIDTH: 0.44903
G1 X139.199 Y115.397 E.01479
; LINE_WIDTH: 0.43732
G1 X160.8 Y115.397 E.67298
; LINE_WIDTH: 0.45842
G3 X161.159 Y115.427 I.06 J1.455 E.01185
G1 X161.31 Y115.478 E.00521
M204 S10000
G1 X161.265 Y115.908 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01209
G3 X162.113 Y116.731 I-1.039 J1.312 E.02723
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.186 E.01254
G1 X161.926 Y135.627 E.01581
G3 X161.495 Y136.009 I-1.175 J-.892 E.01863
G1 X161.011 Y136.181 E.0165
G1 X160.864 Y136.2 E.00475
G1 X139.199 Y136.202 E.69665
G1 X138.814 Y136.142 E.01255
G1 X138.373 Y135.926 E.01579
G3 X137.887 Y135.269 I1.117 J-1.335 E.02653
G1 X137.807 Y134.901 E.0121
G1 X137.799 Y117.168 E.57021
G1 X137.889 Y116.721 E.01468
G1 X137.984 Y116.515 E.00729
G1 X138.224 Y116.194 E.01287
G1 X138.613 Y115.934 E.01504
G1 X139.097 Y115.807 E.01611
G1 X139.199 Y115.798 E.00329
G1 X160.8 Y115.798 E.6946
G1 X161.103 Y115.834 E.00979
G1 X161.21 Y115.883 E.00379
M204 S250
G1 X161.112 Y116.243 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.462 E.01285
G1 X161.73 Y116.815 E.01284
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.801 E.52427
G1 X161.734 Y135.179 E.01151
G1 X161.538 Y135.484 E.01078
G1 X161.192 Y135.728 E.01263
G1 X160.864 Y135.808 E.01003
G1 X139.199 Y135.81 E.64531
G1 X138.821 Y135.734 E.01151
G1 X138.516 Y135.539 E.01077
G1 X138.27 Y135.185 E.01285
G1 X138.193 Y134.833 E.01071
G1 X138.191 Y117.168 E.52617
G1 X138.301 Y116.745 E.01302
G1 X138.544 Y116.436 E.01171
G1 X138.883 Y116.244 E.0116
G1 X139.199 Y116.19 E.00956
G1 X160.8 Y116.19 E.64341
G1 X161.053 Y116.233 E.00762
; WIPE_START
M204 S3000
G1 X161.484 Y116.462 E-.18541
G1 X161.73 Y116.815 E-.16382
G1 X161.81 Y117.199 E-.14898
G1 X161.81 Y117.888 E-.26178
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.949 Y115.104 Z.8 F12000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.264 E.00532
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I88.025 J.676 E.06223
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.801 E.04969
; LINE_WIDTH: 0.44457
G1 X162.99 Y135.009 E.00662
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.716 I228.909 J1.245 E.05488
G1 X162.931 Y136.924 E.00694
G1 X162.731 Y136.991 E.00678
G2 X160.865 Y136.997 I-.635 J97.478 E.06002
; LINE_WIDTH: 0.43856
G1 X158.865 Y136.997 E.06251
; LINE_WIDTH: 0.43844
G1 X156.865 Y136.997 E.06249
; LINE_WIDTH: 0.43833
G1 X154.865 Y136.997 E.06247
; LINE_WIDTH: 0.43821
M73 P46 R10
G1 X152.865 Y136.997 E.06245
; LINE_WIDTH: 0.4381
G1 X150.865 Y136.997 E.06243
; LINE_WIDTH: 0.43798
G1 X148.865 Y136.997 E.06241
; LINE_WIDTH: 0.43787
G1 X146.865 Y136.997 E.0624
; LINE_WIDTH: 0.43775
G1 X144.865 Y136.997 E.06238
; LINE_WIDTH: 0.43764
G1 X142.865 Y136.997 E.06236
; LINE_WIDTH: 0.43752
G1 X140.865 Y136.997 E.06234
; LINE_WIDTH: 0.43741
G1 X139.2 Y136.997 E.05188
; LINE_WIDTH: 0.44657
G1 X138.991 Y136.993 E.00667
; LINE_WIDTH: 0.44999
G2 X137.301 Y136.991 I-1.209 J359.536 E.05433
G1 X137.075 Y136.93 E.00752
G1 X137.009 Y136.712 E.00731
G2 X137.003 Y134.801 I-90.415 J-.667 E.06147
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.45045
G2 X137.013 Y116.067 I-43.864 J-.837 E.03545
; LINE_WIDTH: 0.44999
G1 X137.013 Y115.258 E.02599
G1 X137.064 Y115.084 E.00585
G1 X137.248 Y115.009 E.00639
G2 X139.199 Y115.003 I.494 J-148.033 E.06274
; LINE_WIDTH: 0.43732
G1 X160.8 Y115.003 E.67298
; LINE_WIDTH: 0.45842
G2 X161.973 Y115.009 I.684 J-17.969 E.0385
; LINE_WIDTH: 0.44999
G1 X162.803 Y115.019 E.02667
G1 X162.897 Y115.074 E.00353
M204 S10000
G1 X163.194 Y114.775 F12000
G1 F6000
M204 S3000
G1 X163.364 Y115.021 E.00962
G1 X163.397 Y115.264 E.0079
G1 X163.394 Y135.264 E.64311
G3 X163.376 Y136.898 I-39.894 J.376 E.05253
G1 X163.246 Y137.188 E.01023
; object ids of layer 2 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer2 end: 47,58
M625
G1 X163.063 Y137.322 E.00729
G1 X162.759 Y137.398 E.01007
G1 X138.759 Y137.398 E.77173
G3 X137.108 Y137.376 I-.393 J-32.589 E.05312
G1 X136.848 Y137.275 E.00897
G1 X136.695 Y137.092 E.00768
G1 X136.602 Y136.748 E.01145
G1 X136.606 Y115.176 E.69365
G1 X136.701 Y114.897 E.0095
G1 X136.887 Y114.7 E.00869
G1 X137.229 Y114.602 E.01144
G1 X161.229 Y114.602 E.77173
G3 X162.955 Y114.629 I.613 J16.096 E.05554
G1 X163.143 Y114.744 E.00708
M204 S250
G1 X163.501 Y114.526 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.6 Y114.621 E.0041
G1 X163.739 Y114.894 E.00914
G1 X163.789 Y115.264 E.01112
G1 X163.786 Y136.716 E.63894
G1 X163.712 Y137.178 E.01395
G1 X163.55 Y137.443 E.00925
G1 X163.349 Y137.621 E.00802
G3 X162.786 Y137.79 I-.56 J-.845 E.01774
G1 X137.315 Y137.79 E.75869
G1 X136.895 Y137.739 E.01261
G1 X136.618 Y137.598 E.00926
G1 X136.425 Y137.413 E.00794
G1 X136.274 Y137.144 E.00921
G1 X136.21 Y136.783 E.01092
G1 X136.214 Y115.258 E.64112
G1 X136.288 Y114.822 E.01318
G1 X136.449 Y114.558 E.00921
G1 X136.683 Y114.359 E.00914
G3 X137.21 Y114.21 I.742 J1.617 E.01638
G1 X162.455 Y114.21 E.75195
G1 X163.066 Y114.249 E.01825
G1 X163.347 Y114.378 E.00921
G1 X163.457 Y114.484 E.00456
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.6 Y114.621 E-.07505
G1 X163.739 Y114.894 E-.11662
G1 X163.789 Y115.264 E-.14185
G1 X163.789 Y116.387 E-.42647
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.654 Y119.097 Z.8 F12000
G1 X116.391 Y134.391 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.223 J-103.836 E.04404
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.603 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.604 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.604 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.605 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.605 E.06212
; LINE_WIDTH: 0.43585
G1 X108.979 Y117.605 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.606 E.06204
; LINE_WIDTH: 0.43534
G1 X112.979 Y117.606 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.607 E.06196
; LINE_WIDTH: 0.43483
G1 X115.022 Y117.607 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.614 E.044
G2 X116.397 Y118.979 I102.706 J.19 E.04386
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67798
G1 X95.26 Y134.719 E.00701
G1 X95.202 Y134.56 E.00546
G1 X95.202 Y117.463 E.54974
G1 X95.288 Y117.251 E.00737
G1 X95.452 Y117.202 E.00552
G1 X116.562 Y117.207 E.67882
G1 X116.719 Y117.266 E.00538
G1 X116.797 Y117.418 E.0055
G1 X116.798 Y134.537 E.55047
G1 X116.735 Y134.694 E.00545
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.6281
G1 X95.155 Y135.132 E.01029
G1 X94.955 Y134.98 E.00747
G3 X94.81 Y134.587 I.838 J-.531 E.01258
G1 X94.81 Y117.495 E.50909
G1 X94.868 Y117.155 E.01028
G3 X95.114 Y116.898 I.83 J.547 E.01065
G1 X95.417 Y116.81 E.00941
G1 X116.562 Y116.815 E.62982
G1 X116.884 Y116.888 E.00982
G1 X117.075 Y117.057 E.00762
G3 X117.189 Y117.418 I-.885 J.479 E.01132
G1 X117.19 Y134.505 E.50895
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.831 J-.549 E.00887
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14138
G1 X114.955 Y135.19 E-.61862
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.357 Y134.46 Z.8 F12000
G1 X96.104 Y133.379 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00676
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01912
; LINE_WIDTH: 0.44605
G1 X96.979 Y117.997 E.00543
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.997 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.998 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.998 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.998 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.998 E.06212
; LINE_WIDTH: 0.43585
G1 X108.979 Y117.998 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.998 E.06204
; LINE_WIDTH: 0.43534
G1 X112.979 Y117.998 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.998 E.06196
; LINE_WIDTH: 0.43483
G1 X115.021 Y117.998 E.00133
; LINE_WIDTH: 0.44999
G1 X115.722 Y118.282 E.02428
G1 X116.003 Y118.979 E.02416
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.132 Y133.432 E.01042
M204 S10000
G1 X96.448 Y133.202 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00291
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01125
G1 X96.979 Y118.398 E.00323
G1 X115.022 Y118.398 E.58019
G1 X115.433 Y118.569 E.01433
G1 X115.602 Y118.979 E.01425
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.476 Y133.255 E.0064
M204 S250
G1 X96.791 Y133.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y133.021 E.00009
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00564
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.846 I.021 J.24 E.00566
G1 X115.21 Y118.979 E.00429
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.814 Y133.08 E.00242
; WIPE_START
M204 S3000
G1 X96.79 Y133.021 E-.02396
G1 X96.79 Y131.085 E-.73604
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z.8 F12000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z.8 F12000
G1 X96.026 Y117.961 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17026
G1 X95.955 Y118.002 E-.29487
G1 X96.026 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.963 Z.8 F12000
G1 X116.022 Y117.965 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.41858
G1 F6000
M204 S3000
G1 X115.952 Y118.006 E.00241
G1 X116.022 Y118.046 E.00241
G1 X116.046 Y118.006 E.00139
; WIPE_START
G1 X116.022 Y118.046 E-.17026
G1 X115.952 Y118.006 E-.29487
G1 X116.022 Y117.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y125.598 Z.8 F12000
G1 X116.021 Y133.957 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 3/40
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z.8 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z.8
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.3747
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01699
G1 X162.415 Y115.756 E.00891
G1 X161.973 Y115.379 E.01523
G1 X162.561 Y115.379 E.01539
; WIPE_START
G1 X162.621 Y116.027 E-.24746
M73 P47 R10
G1 X162.415 Y115.756 E-.12921
G1 X161.973 Y115.379 E-.22084
G1 X162.401 Y115.379 E-.16249
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.483 Y123.011 Z1 F12000
G1 X162.621 Y135.976 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.37495
G1 F6000
M204 S3000
G1 X162.621 Y136.621 E.01693
G1 X161.972 Y136.621 E.01702
G1 X162.343 Y136.333 E.01231
G1 X162.584 Y136.023 E.0103
; WIPE_START
G1 X162.621 Y136.621 E-.22772
G1 X161.972 Y136.621 E-.2466
G1 X162.343 Y136.333 E-.17838
G1 X162.516 Y136.11 E-.1073
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y136.269 Z1 F12000
G1 X138.023 Y136.618 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.37399
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01687
G1 X137.378 Y135.971 E.01693
G1 X137.585 Y136.244 E.00896
G1 X137.978 Y136.579 E.01351
; WIPE_START
G1 X137.378 Y136.618 E-.22824
G1 X137.378 Y135.971 E-.24602
G1 X137.585 Y136.244 E-.13015
G1 X137.896 Y136.51 E-.15559
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.945 Y128.878 Z1 F12000
G1 X138.03 Y115.378 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.37373
G1 F6000
M204 S3000
G1 X137.663 Y115.658 E.01208
G1 X137.378 Y116.029 E.01221
G1 X137.378 Y115.378 E.01701
G1 X137.97 Y115.378 E.01548
; WIPE_START
G1 X137.663 Y115.658 E-.15812
G1 X137.378 Y116.029 E-.17762
G1 X137.378 Y115.378 E-.24733
G1 X137.844 Y115.378 E-.17694
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.476 Y115.417 Z1 F12000
G1 X161.368 Y115.497 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.45832
G1 F6000
M204 S3000
G1 X161.488 Y115.538 E.00417
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01132
G1 X162.121 Y115.979 E.01362
G1 X162.334 Y116.26 E.01134
G1 X162.511 Y116.644 E.01361
G1 X162.603 Y117.2 E.01809
; LINE_WIDTH: 0.43693
G1 X162.603 Y123.2 E.18674
; LINE_WIDTH: 0.43706
G1 X162.603 Y129.2 E.18681
; LINE_WIDTH: 0.43719
G1 X162.603 Y134.8 E.17443
; LINE_WIDTH: 0.44897
G1 X162.543 Y135.258 E.01479
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.584 E.01117
G1 X162.093 Y136.061 E.01866
G1 X161.74 Y136.334 E.01433
G1 X161.356 Y136.511 E.01359
G1 X160.801 Y136.603 E.01811
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.603 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.603 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.603 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.602 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.602 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.602 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.602 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.602 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.602 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.602 E.06208
; LINE_WIDTH: 0.43575
G1 X139.2 Y136.602 E.04968
; LINE_WIDTH: 0.45669
G3 X138.512 Y136.462 I-.059 J-1.47 E.02317
; LINE_WIDTH: 0.44999
G1 X138.201 Y136.296 E.01132
G1 X137.879 Y136.021 E.01362
G1 X137.667 Y135.74 E.01132
G1 X137.489 Y135.356 E.01361
G1 X137.397 Y134.8 E.01811
; LINE_WIDTH: 0.43735
G1 X137.397 Y128.8 E.18694
; LINE_WIDTH: 0.43746
G1 X137.398 Y122.8 E.18699
; LINE_WIDTH: 0.43756
G1 X137.398 Y117.168 E.17559
; LINE_WIDTH: 0.45078
G1 X137.493 Y116.626 E.01772
G1 X137.654 Y116.277 E.01238
; LINE_WIDTH: 0.44999
G1 X137.929 Y115.914 E.01465
G1 X138.352 Y115.61 E.01676
G1 X138.693 Y115.473 E.01183
; LINE_WIDTH: 0.4495
G1 X139.199 Y115.397 E.01644
; LINE_WIDTH: 0.43732
G1 X160.8 Y115.397 E.67298
; LINE_WIDTH: 0.45832
G3 X161.159 Y115.427 I.06 J1.455 E.01183
G1 X161.311 Y115.478 E.00526
M204 S10000
G1 X161.266 Y115.908 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01204
G3 X162.113 Y116.732 I-1.04 J1.313 E.02726
G1 X162.202 Y117.2 E.01531
G1 X162.202 Y134.8 E.56596
G1 X162.142 Y135.186 E.01255
G1 X161.925 Y135.627 E.01581
G3 X161.269 Y136.113 I-1.333 J-1.116 E.0265
G1 X160.801 Y136.202 E.01533
G1 X139.2 Y136.202 E.69459
G1 X138.898 Y136.166 E.00978
G1 X138.393 Y135.937 E.01781
G3 X137.887 Y135.269 I1.039 J-1.313 E.02725
G1 X137.798 Y134.8 E.01532
G1 X137.799 Y117.168 E.56699
G1 X137.889 Y116.721 E.01466
G1 X137.983 Y116.516 E.00726
G1 X138.222 Y116.196 E.01283
G1 X138.572 Y115.953 E.01371
G1 X139.086 Y115.809 E.01716
G1 X139.199 Y115.798 E.00366
G1 X160.8 Y115.798 E.6946
G1 X161.102 Y115.834 E.00978
G1 X161.211 Y115.884 E.00385
M204 S250
G1 X161.112 Y116.243 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.461 E.01283
G1 X161.73 Y116.816 E.01286
G1 X161.81 Y117.2 E.01167
G1 X161.81 Y134.8 E.52425
G1 X161.733 Y135.179 E.01152
G1 X161.538 Y135.484 E.01078
G1 X161.185 Y135.73 E.01283
G1 X160.801 Y135.81 E.01168
G1 X139.2 Y135.81 E.6434
G1 X138.888 Y135.757 E.00941
G1 X138.516 Y135.539 E.01285
G1 X138.27 Y135.185 E.01285
G1 X138.19 Y134.8 E.01168
G1 X138.191 Y117.168 E.5252
G1 X138.301 Y116.746 E.01299
G1 X138.538 Y116.44 E.01153
G1 X138.849 Y116.256 E.01075
G1 X139.199 Y116.19 E.01062
G1 X160.8 Y116.19 E.64341
G1 X161.053 Y116.233 E.00764
; WIPE_START
M204 S3000
G1 X161.484 Y116.461 E-.18515
G1 X161.73 Y116.816 E-.16409
G1 X161.81 Y117.2 E-.14894
G1 X161.81 Y117.889 E-.26183
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.932 Y115.081 Z1 F12000
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.263 E.00615
; LINE_WIDTH: 0.45007
G2 X162.997 Y117.2 I89.032 J.663 E.06227
; LINE_WIDTH: 0.43693
G1 X162.997 Y123.2 E.18674
; LINE_WIDTH: 0.43706
G1 X162.997 Y129.2 E.18681
; LINE_WIDTH: 0.43719
G1 X162.997 Y134.8 E.17443
; LINE_WIDTH: 0.44622
G1 X162.993 Y135.009 E.00665
; LINE_WIDTH: 0.44999
G2 X162.991 Y136.722 I330.226 J1.207 E.05507
G1 X162.926 Y136.923 E.0068
G1 X162.712 Y136.991 E.00722
G2 X160.801 Y136.997 I-.665 J90.519 E.06148
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.997 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.997 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.996 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.996 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.996 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.996 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.996 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.995 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.995 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.995 E.06208
; LINE_WIDTH: 0.43575
G1 X139.2 Y136.995 E.04968
; LINE_WIDTH: 0.44121
G1 X139.038 Y136.992 E.0051
; LINE_WIDTH: 0.44999
G2 X137.257 Y136.987 I-1.235 J132.442 E.05724
G1 X137.084 Y136.936 E.00582
G1 X137.009 Y136.751 E.00641
G2 X137.003 Y134.8 I-93.332 J-.672 E.06273
; LINE_WIDTH: 0.43735
G1 X137.003 Y128.8 E.18694
; LINE_WIDTH: 0.43746
G1 X137.003 Y122.8 E.18699
; LINE_WIDTH: 0.43756
G1 X137.003 Y117.168 E.17559
; LINE_WIDTH: 0.45078
G2 X137.009 Y116.069 I-46.617 J-.812 E.03542
; LINE_WIDTH: 0.44999
G1 X137.009 Y115.315 E.02423
G1 X137.071 Y115.079 E.00784
G1 X137.268 Y115.009 E.00671
G1 X138.647 Y115.009 E.04437
; LINE_WIDTH: 0.4495
G1 X139.199 Y115.003 E.01773
; LINE_WIDTH: 0.43732
G1 X160.8 Y115.003 E.67298
; LINE_WIDTH: 0.45832
G2 X161.972 Y115.009 I.684 J-18.024 E.03846
; LINE_WIDTH: 0.44999
G1 X162.78 Y115.018 E.02598
G1 X162.876 Y115.058 E.00335
M204 S10000
G1 X163.182 Y114.758 F12000
G1 F6000
M204 S3000
G1 X163.365 Y115.029 E.01052
G1 X163.397 Y115.263 E.00761
G1 X163.398 Y135.263 E.64311
G3 X163.376 Y136.892 I-32.161 J.384 E.05239
G1 X163.278 Y137.147 E.00878
; object ids of layer 3 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer3 end: 47,58
M625
G1 X163.081 Y137.315 E.00831
G1 X162.748 Y137.398 E.01103
G1 X137.176 Y137.394 E.82228
G1 X136.897 Y137.299 E.0095
G1 X136.7 Y137.113 E.00871
G1 X136.602 Y136.771 E.01143
G1 X136.602 Y116.771 E.64311
G3 X136.626 Y115.118 I21.807 J-.511 E.05319
G1 X136.718 Y114.857 E.00889
G1 X136.931 Y114.687 E.00877
G1 X137.24 Y114.602 E.01029
G1 X162.455 Y114.602 E.8108
G1 X162.985 Y114.638 E.0171
G1 X163.13 Y114.727 E.00547
M204 S250
G1 X163.488 Y114.507 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.564 Y114.592 E.0034
G3 X163.74 Y114.898 I-.851 J.695 E.01059
G1 X163.789 Y115.263 E.01097
G1 X163.79 Y136.685 E.63807
G1 X163.739 Y137.105 E.0126
G1 X163.599 Y137.381 E.00921
G1 X163.379 Y137.6 E.00927
G1 X163.145 Y137.725 E.00789
G1 X162.783 Y137.79 E.01096
G1 X137.257 Y137.786 E.7603
G1 X136.822 Y137.713 E.01314
G1 X136.559 Y137.551 E.00921
G1 X136.359 Y137.317 E.00916
G3 X136.21 Y136.79 I1.597 J-.736 E.01637
G1 X136.21 Y115.315 E.63966
G1 X136.275 Y114.854 E.01386
G1 X136.4 Y114.621 E.0079
G1 X136.618 Y114.402 E.0092
G1 X136.939 Y114.248 E.01061
G1 X137.213 Y114.21 E.00825
G1 X162.703 Y114.21 E.75924
G1 X163.104 Y114.26 E.01202
G3 X163.342 Y114.386 I-.391 J1.027 E.00804
G1 X163.441 Y114.469 E.00385
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.564 Y114.592 E-.06596
G1 X163.74 Y114.898 E-.13447
G1 X163.789 Y115.263 E-.13993
G1 X163.789 Y116.368 E-.41965
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.655 Y119.08 Z1 F12000
G1 X116.391 Y134.391 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-104.878 J-.21 E.04403
; LINE_WIDTH: 0.43721
G1 X95.603 Y131.021 E.06229
; LINE_WIDTH: 0.43706
G1 X95.603 Y129.021 E.06227
; LINE_WIDTH: 0.43692
G1 X95.604 Y127.021 E.06225
; LINE_WIDTH: 0.43678
G1 X95.604 Y125.021 E.06222
; LINE_WIDTH: 0.43664
G1 X95.604 Y123.021 E.0622
; LINE_WIDTH: 0.4365
G1 X95.604 Y121.021 E.06218
; LINE_WIDTH: 0.43636
G1 X95.604 Y119.021 E.06216
; LINE_WIDTH: 0.43622
G1 X95.604 Y118.978 E.00134
; LINE_WIDTH: 0.44999
G1 X95.612 Y117.609 E.04403
G2 X96.979 Y117.603 I.223 J-103.32 E.04396
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.603 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.604 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.604 E.0622
; LINE_WIDTH: 0.43636
G1 X104.979 Y117.605 E.06216
; LINE_WIDTH: 0.43611
G1 X106.979 Y117.605 E.06212
; LINE_WIDTH: 0.43586
G1 X108.979 Y117.605 E.06208
; LINE_WIDTH: 0.43561
G1 X110.979 Y117.606 E.06204
; LINE_WIDTH: 0.43535
G1 X112.979 Y117.606 E.062
; LINE_WIDTH: 0.4351
G1 X114.979 Y117.607 E.06196
; LINE_WIDTH: 0.43485
G1 X115.022 Y117.607 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.614 E.044
G2 X116.397 Y118.979 I102.713 J.19 E.04386
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.715 Y134.742 F12000
G1 F6000
M204 S3000
G1 X116.56 Y134.798 E.0053
G1 X95.463 Y134.798 E.67837
G1 X95.25 Y134.712 E.00739
G1 X95.202 Y134.548 E.00549
G1 X95.204 Y117.414 E.55098
G1 X95.28 Y117.26 E.00551
G1 X95.44 Y117.202 E.00547
G1 X116.563 Y117.207 E.6792
G1 X116.739 Y117.274 E.00606
G1 X116.797 Y117.442 E.00571
G1 X116.798 Y134.537 E.5497
G1 X116.739 Y134.689 E.00525
M204 S250
G1 X116.85 Y135.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X116.587 Y135.19 I-.401 J-.908 E.00817
G1 X95.495 Y135.19 E.62823
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.55 J-.833 E.01066
G1 X94.81 Y134.583 E.00939
G1 X94.812 Y117.455 E.51017
G1 X94.866 Y117.158 E.009
G1 X95.02 Y116.955 E.00758
G3 X95.413 Y116.81 I.537 J.853 E.01258
G1 X116.563 Y116.815 E.62995
G1 X116.887 Y116.888 E.0099
G3 X117.189 Y117.442 I-.375 J.564 E.01954
G1 X117.19 Y134.505 E.50824
G1 X117.132 Y134.845 E.01028
G1 X116.98 Y135.045 E.00748
G3 X116.904 Y135.089 I-.532 J-.838 E.00262
; WIPE_START
M204 S3000
G1 X116.587 Y135.19 E-.1265
G1 X114.92 Y135.19 E-.6335
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.322 Y134.459 Z1 F12000
G1 X96.104 Y133.378 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00676
; LINE_WIDTH: 0.44614
G1 X95.997 Y133.021 E.00543
; LINE_WIDTH: 0.43721
G1 X95.997 Y131.021 E.06229
; LINE_WIDTH: 0.43706
G1 X95.997 Y129.021 E.06227
; LINE_WIDTH: 0.43692
G1 X95.997 Y127.021 E.06225
; LINE_WIDTH: 0.43678
G1 X95.998 Y125.021 E.06222
; LINE_WIDTH: 0.43664
G1 X95.998 Y123.021 E.0622
; LINE_WIDTH: 0.4365
M73 P48 R10
G1 X95.998 Y121.021 E.06218
; LINE_WIDTH: 0.43636
G1 X95.998 Y119.021 E.06216
; LINE_WIDTH: 0.43622
G1 X95.998 Y118.979 E.00133
; LINE_WIDTH: 0.44999
G1 X96.281 Y118.279 E.02426
G1 X96.808 Y118.008 E.01908
; LINE_WIDTH: 0.44605
G1 X96.979 Y117.997 E.00543
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.997 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.998 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.998 E.0622
; LINE_WIDTH: 0.43636
G1 X104.979 Y117.998 E.06216
; LINE_WIDTH: 0.43611
G1 X106.979 Y117.998 E.06212
; LINE_WIDTH: 0.43586
G1 X108.979 Y117.998 E.06208
; LINE_WIDTH: 0.43561
G1 X110.979 Y117.998 E.06204
; LINE_WIDTH: 0.43535
G1 X112.979 Y117.998 E.062
; LINE_WIDTH: 0.4351
G1 X114.979 Y117.998 E.06196
; LINE_WIDTH: 0.43485
G1 X115.021 Y117.998 E.00133
; LINE_WIDTH: 0.44999
G1 X115.722 Y118.282 E.02428
G1 X116.003 Y118.979 E.02416
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.132 Y133.432 E.01043
M204 S10000
G1 X96.026 Y133.957 F12000
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
M204 S10000
G1 X96.448 Y133.202 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00291
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.978 E.45156
G1 X96.568 Y118.568 E.01431
G1 X96.878 Y118.407 E.01123
G1 X96.979 Y118.398 E.00323
G1 X115.022 Y118.398 E.58019
G1 X115.433 Y118.569 E.01433
G1 X115.602 Y118.979 E.01425
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.476 Y133.255 E.00641
M204 S250
G1 X96.791 Y133.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y133.021 E.00009
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.00429
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.846 I.021 J.24 E.00566
G1 X115.21 Y118.979 E.00429
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00564
G1 X96.814 Y133.08 E.00242
; WIPE_START
M204 S3000
G1 X96.79 Y133.021 E-.02395
G1 X96.79 Y131.084 E-.73606
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.347 Y123.465 Z1 F12000
G1 X96.027 Y117.961 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42052
G1 F6000
M204 S3000
G1 X95.957 Y118.002 E.00244
G1 X96.027 Y118.043 E.00244
G1 X96.051 Y118.002 E.00141
; WIPE_START
G1 X96.027 Y118.043 E-.17025
G1 X95.957 Y118.002 E-.29487
G1 X96.027 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.66 Y117.962 Z1 F12000
G1 X116.022 Y117.965 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.4186
G1 F6000
M204 S3000
G1 X115.952 Y118.006 E.00241
G1 X116.022 Y118.046 E.00241
G1 X116.046 Y118.006 E.00139
; WIPE_START
G1 X116.022 Y118.046 E-.17025
G1 X115.952 Y118.006 E-.29488
G1 X116.022 Y117.965 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y125.597 Z1 F12000
G1 X116.021 Y133.957 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 4/40
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
M106 S79.05
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z1
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.37469
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01699
G1 X162.415 Y115.756 E.00891
G1 X161.973 Y115.379 E.01523
G1 X162.561 Y115.379 E.01539
; WIPE_START
G1 X162.621 Y116.027 E-.24743
G1 X162.415 Y115.756 E-.12921
G1 X161.973 Y115.379 E-.2208
G1 X162.401 Y115.379 E-.16256
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.483 Y123.011 Z1.2 F12000
G1 X162.621 Y135.976 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.37496
G1 F6000
M204 S3000
G1 X162.621 Y136.621 E.01693
G1 X161.972 Y136.621 E.01702
G1 X162.343 Y136.333 E.01231
G1 X162.584 Y136.023 E.0103
; WIPE_START
G1 X162.621 Y136.621 E-.22768
G1 X161.972 Y136.621 E-.24661
G1 X162.343 Y136.333 E-.1784
G1 X162.517 Y136.11 E-.10731
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y136.269 Z1.2 F12000
G1 X138.02 Y136.618 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01678
G1 X137.378 Y135.971 E.01693
G1 X137.666 Y136.341 E.01225
G1 X137.973 Y136.581 E.01019
; WIPE_START
G1 X137.378 Y136.618 E-.22636
G1 X137.378 Y135.971 E-.24597
G1 X137.666 Y136.341 E-.17806
G1 X137.893 Y136.519 E-.1096
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.944 Y128.886 Z1.2 F12000
G1 X138.033 Y115.378 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.37264
G1 F6000
M204 S3000
G1 X137.665 Y115.657 E.01205
G1 X137.381 Y116.026 E.01212
G1 X137.381 Y115.378 E.01688
G1 X137.973 Y115.378 E.01542
; WIPE_START
G1 X137.665 Y115.657 E-.15822
G1 X137.381 Y116.026 E-.17676
G1 X137.381 Y115.378 E-.24633
G1 X137.851 Y115.378 E-.1787
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.484 Y115.417 Z1.2 F12000
G1 X161.369 Y115.498 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.45834
G1 F6000
M204 S3000
G1 X161.488 Y115.538 E.00413
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01132
G1 X162.121 Y115.979 E.01362
G1 X162.333 Y116.26 E.01133
; LINE_WIDTH: 0.45227
G1 X162.502 Y116.604 E.0124
G1 X162.6 Y117.131 E.01734
; LINE_WIDTH: 0.43834
G1 X162.601 Y119.131 E.06247
; LINE_WIDTH: 0.43821
G1 X162.601 Y121.131 E.06245
; LINE_WIDTH: 0.43809
G1 X162.601 Y123.131 E.06243
; LINE_WIDTH: 0.43797
G1 X162.601 Y125.131 E.06241
; LINE_WIDTH: 0.43785
G1 X162.602 Y127.131 E.06239
; LINE_WIDTH: 0.43773
G1 X162.602 Y129.131 E.06237
; LINE_WIDTH: 0.43761
G1 X162.602 Y131.131 E.06236
; LINE_WIDTH: 0.43749
G1 X162.603 Y133.131 E.06234
; LINE_WIDTH: 0.43737
G1 X162.603 Y134.8 E.052
; LINE_WIDTH: 0.44896
G1 X162.543 Y135.257 E.01479
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01116
G1 X162.093 Y136.061 E.01868
G1 X161.74 Y136.334 E.01434
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.603 E.0181
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.603 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.603 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.603 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.602 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.602 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.602 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.602 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.602 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.602 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.602 E.06208
; LINE_WIDTH: 0.43575
G1 X139.199 Y136.602 E.04968
; LINE_WIDTH: 0.44856
G1 X138.743 Y136.543 E.01476
; LINE_WIDTH: 0.44999
G3 X138.167 Y136.277 I.448 J-1.726 E.0205
G3 X137.667 Y135.74 I1.098 J-1.526 E.02375
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.8 E.01811
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.8 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.8 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.8 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.8 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.8 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.8 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.8 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.8 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.45046
G1 X137.493 Y116.626 E.0177
G1 X137.653 Y116.278 E.01234
; LINE_WIDTH: 0.44999
G1 X137.929 Y115.913 E.01471
G1 X138.357 Y115.608 E.01689
G1 X138.698 Y115.471 E.01184
; LINE_WIDTH: 0.44945
G1 X139.199 Y115.397 E.01626
; LINE_WIDTH: 0.43732
G1 X160.8 Y115.397 E.67298
; LINE_WIDTH: 0.45834
G3 X161.159 Y115.427 I.06 J1.455 E.01184
G1 X161.312 Y115.479 E.0053
M204 S10000
G1 X161.267 Y115.909 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01199
G3 X162.009 Y116.506 I-.807 J1.137 E.01938
G1 X162.18 Y116.984 E.01633
G1 X162.199 Y117.132 E.00479
G1 X162.202 Y134.8 E.56815
G1 X162.142 Y135.186 E.01254
G1 X161.926 Y135.627 E.01581
G3 X161.269 Y136.113 I-1.334 J-1.117 E.02653
G1 X160.801 Y136.202 E.01532
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01254
G1 X138.373 Y135.926 E.01581
G3 X137.887 Y135.269 I1.116 J-1.334 E.02652
G1 X137.798 Y134.8 E.01532
G1 X137.799 Y117.168 E.567
G1 X137.889 Y116.721 E.01465
G1 X137.983 Y116.516 E.00724
G1 X138.222 Y116.196 E.01285
G1 X138.576 Y115.951 E.01385
G1 X139.087 Y115.809 E.01705
G1 X139.199 Y115.798 E.00362
G1 X160.8 Y115.798 E.6946
G1 X161.103 Y115.834 E.00978
G1 X161.213 Y115.884 E.00389
M204 S250
G1 X161.114 Y116.244 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.461 E.01278
G1 X161.728 Y116.808 E.01264
G1 X161.807 Y117.132 E.00992
G1 X161.81 Y134.8 E.52628
G1 X161.734 Y135.179 E.01151
G1 X161.538 Y135.484 E.01078
G1 X161.184 Y135.73 E.01284
G1 X160.801 Y135.81 E.01168
G1 X139.199 Y135.81 E.64341
G1 X138.821 Y135.734 E.0115
G1 X138.571 Y135.587 E.00862
G1 X138.304 Y135.258 E.01264
G1 X138.19 Y134.801 E.01404
G1 X138.191 Y117.168 E.52521
G1 X138.301 Y116.746 E.01298
G1 X138.538 Y116.441 E.01151
G1 X138.853 Y116.255 E.0109
G1 X139.199 Y116.19 E.0105
G1 X160.8 Y116.19 E.64341
G1 X161.055 Y116.233 E.00768
; WIPE_START
M204 S3000
G1 X161.484 Y116.461 E-.18461
G1 X161.728 Y116.808 E-.16126
G1 X161.807 Y117.132 E-.12655
G1 X161.807 Y117.888 E-.28759
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.933 Y115.083 Z1.2 F12000
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.263 E.00608
G1 X162.99 Y116.039 E.02496
; LINE_WIDTH: 0.45227
G2 X162.996 Y117.131 I38.75 J.337 E.03532
; LINE_WIDTH: 0.43834
G1 X162.996 Y119.131 E.06247
; LINE_WIDTH: 0.43821
G1 X162.996 Y121.131 E.06245
; LINE_WIDTH: 0.43809
G1 X162.996 Y123.131 E.06243
; LINE_WIDTH: 0.43797
G1 X162.996 Y125.131 E.06241
; LINE_WIDTH: 0.43785
G1 X162.997 Y127.131 E.06239
; LINE_WIDTH: 0.43773
G1 X162.997 Y129.131 E.06237
; LINE_WIDTH: 0.43761
G1 X162.997 Y131.131 E.06236
; LINE_WIDTH: 0.43749
G1 X162.997 Y133.131 E.06234
; LINE_WIDTH: 0.43737
G1 X162.997 Y134.8 E.052
; LINE_WIDTH: 0.44622
G1 X162.993 Y135.009 E.00665
; LINE_WIDTH: 0.44999
G2 X162.991 Y136.722 I329.974 J1.207 E.05507
G1 X162.929 Y136.921 E.0067
G1 X162.732 Y136.991 E.00672
G2 X160.801 Y136.997 I-.674 J91.46 E.0621
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.997 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.997 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.996 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.996 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.996 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.996 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.995 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.995 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.995 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.995 E.06208
; LINE_WIDTH: 0.43575
G1 X139.199 Y136.995 E.04968
; LINE_WIDTH: 0.44485
G1 X138.991 Y136.99 E.00662
; LINE_WIDTH: 0.44999
G2 X137.266 Y136.987 I-1.258 J242.658 E.05547
G1 X137.09 Y136.942 E.00585
G1 X137.009 Y136.751 E.00668
G2 X137.003 Y134.8 I-92.311 J-.687 E.06272
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.8 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.8 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.8 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.8 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.8 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.8 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.8 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.8 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.45241
G2 X137.013 Y116.071 I-17.669 J-.664 E.03549
; LINE_WIDTH: 0.44999
G1 X137.013 Y115.257 E.02615
G1 X137.064 Y115.084 E.00582
G1 X137.249 Y115.009 E.0064
G1 X138.653 Y115.009 E.04516
; LINE_WIDTH: 0.44945
G1 X139.199 Y115.003 E.01754
; LINE_WIDTH: 0.43732
M73 P48 R9
G1 X160.8 Y115.003 E.67298
; LINE_WIDTH: 0.45834
G2 X161.973 Y115.009 I.684 J-18.016 E.03847
; LINE_WIDTH: 0.44999
G1 X162.781 Y115.018 E.026
G1 X162.878 Y115.059 E.00338
M204 S10000
G1 X163.179 Y114.756 F12000
G1 F6000
M204 S3000
G1 X163.365 Y115.028 E.01061
G1 X163.397 Y115.263 E.00762
G1 X163.398 Y135.263 E.64311
M73 P49 R9
G3 X163.38 Y136.868 I-37.398 J.384 E.0516
G1 X163.278 Y137.147 E.00956
; object ids of layer 4 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer4 end: 47,58
M625
G1 X163.068 Y137.314 E.00864
G1 X162.76 Y137.398 E.01027
G1 X137.266 Y137.394 E.81976
G1 X136.946 Y137.333 E.01049
G1 X136.7 Y137.113 E.01061
G1 X136.602 Y136.771 E.01143
G1 X136.606 Y115.176 E.69439
G1 X136.701 Y114.897 E.00949
G1 X136.887 Y114.7 E.0087
G1 X137.229 Y114.602 E.01143
G1 X162.455 Y114.602 E.81115
G1 X162.988 Y114.639 E.01719
G1 X163.128 Y114.725 E.00528
M204 S250
G1 X163.487 Y114.506 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.574 Y114.587 E.00356
G1 X163.741 Y114.898 E.0105
G1 X163.789 Y115.263 E.01096
G1 X163.79 Y136.699 E.63848
G1 X163.739 Y137.105 E.01221
G1 X163.599 Y137.38 E.00919
G1 X163.382 Y137.598 E.00916
G1 X163.065 Y137.752 E.01049
G1 X162.787 Y137.79 E.00836
G1 X137.266 Y137.786 E.76015
G1 X136.787 Y137.697 E.0145
G1 X136.56 Y137.552 E.00803
G1 X136.359 Y137.317 E.00921
G3 X136.21 Y136.79 I1.573 J-.729 E.01638
G1 X136.214 Y115.257 E.64137
G1 X136.287 Y114.822 E.01314
G1 X136.449 Y114.558 E.00922
G1 X136.683 Y114.359 E.00914
G3 X137.21 Y114.21 I.737 J1.598 E.01638
G1 X162.703 Y114.21 E.75935
G1 X163.107 Y114.261 E.01212
G1 X163.347 Y114.377 E.00794
G1 X163.443 Y114.466 E.00387
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.574 Y114.587 E-.06818
G1 X163.741 Y114.898 E-.13398
G1 X163.789 Y115.263 E-.13983
G1 X163.789 Y116.363 E-.41802
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.655 Y119.076 Z1.2 F12000
G1 X116.388 Y134.391 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.196 J104.88 E.04395
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.223 J-103.676 E.04404
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.603 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.604 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.604 E.0622
; LINE_WIDTH: 0.43636
G1 X104.979 Y117.605 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.605 E.06212
; LINE_WIDTH: 0.43585
G1 X108.979 Y117.605 E.06208
; LINE_WIDTH: 0.4356
G1 X110.979 Y117.606 E.06204
; LINE_WIDTH: 0.43535
G1 X112.979 Y117.606 E.062
; LINE_WIDTH: 0.43509
G1 X114.979 Y117.607 E.06196
; LINE_WIDTH: 0.43484
G1 X115.022 Y117.607 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.614 E.044
G2 X116.397 Y118.979 I101.623 J.206 E.04386
; LINE_WIDTH: 0.43691
G1 X116.396 Y120.979 E.06224
; LINE_WIDTH: 0.43679
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43667
G1 X116.396 Y124.979 E.06221
; LINE_WIDTH: 0.43655
G1 X116.396 Y126.979 E.06219
; LINE_WIDTH: 0.43643
G1 X116.396 Y128.979 E.06217
; LINE_WIDTH: 0.43631
G1 X116.396 Y130.979 E.06215
; LINE_WIDTH: 0.4362
G1 X116.395 Y132.979 E.06213
; LINE_WIDTH: 0.43608
G1 X116.395 Y133.021 E.00133
; LINE_WIDTH: 0.44498
G1 X116.391 Y133.227 E.00651
; LINE_WIDTH: 0.44999
G1 X116.388 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67798
G1 X95.251 Y134.712 E.00737
G1 X95.202 Y134.548 E.00552
G1 X95.202 Y117.463 E.54936
G1 X95.28 Y117.26 E.00701
G1 X95.441 Y117.202 E.00548
G1 X116.554 Y117.207 E.67892
G1 X116.721 Y117.255 E.00556
G1 X116.797 Y117.451 E.00677
G1 X116.795 Y134.589 E.55108
G1 X116.74 Y134.696 E.00389
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.547 J-.829 E.01065
G1 X94.81 Y134.583 E.0094
G1 X94.81 Y117.495 E.50897
G1 X94.868 Y117.155 E.01028
G1 X95.02 Y116.955 E.00747
G3 X95.414 Y116.81 I.532 J.837 E.0126
G1 X115.414 Y116.815 E.59572
G3 X116.749 Y116.841 I.288 J19.271 E.0398
G1 X117.011 Y116.981 E.00883
G1 X117.152 Y117.202 E.00782
G1 X117.189 Y117.451 E.00749
G1 X117.187 Y133.451 E.47657
G3 X117.167 Y134.717 I-22.218 J.272 E.03773
G3 X116.935 Y135.068 I-.633 J-.167 E.01275
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14165
G1 X114.955 Y135.19 E-.61835
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.358 Y134.459 Z1.2 F12000
G1 X96.103 Y133.376 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01912
; LINE_WIDTH: 0.44605
G1 X96.979 Y117.997 E.00543
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.997 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.998 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.998 E.0622
; LINE_WIDTH: 0.43636
G1 X104.979 Y117.998 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.998 E.06212
; LINE_WIDTH: 0.43585
G1 X108.979 Y117.998 E.06208
; LINE_WIDTH: 0.4356
G1 X110.979 Y117.998 E.06204
; LINE_WIDTH: 0.43535
G1 X112.979 Y117.998 E.062
; LINE_WIDTH: 0.43509
G1 X114.979 Y117.998 E.06196
; LINE_WIDTH: 0.43484
G1 X115.021 Y117.998 E.00133
; LINE_WIDTH: 0.44999
G1 X115.721 Y118.282 E.02428
G1 X116.003 Y118.979 E.02416
; LINE_WIDTH: 0.43691
G1 X116.003 Y120.979 E.06224
; LINE_WIDTH: 0.43679
G1 X116.002 Y122.979 E.06223
; LINE_WIDTH: 0.43667
G1 X116.002 Y124.979 E.06221
; LINE_WIDTH: 0.43655
G1 X116.002 Y126.979 E.06219
; LINE_WIDTH: 0.43643
G1 X116.002 Y128.979 E.06217
; LINE_WIDTH: 0.43631
G1 X116.002 Y130.979 E.06215
; LINE_WIDTH: 0.4362
G1 X116.002 Y132.979 E.06213
; LINE_WIDTH: 0.43608
G1 X116.002 Y133.021 E.00133
; LINE_WIDTH: 0.44498
G1 X115.992 Y133.192 E.00542
; LINE_WIDTH: 0.44999
G1 X115.719 Y133.721 E.01914
G1 X115.192 Y133.992 E.01907
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.43 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00282
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01125
G1 X96.979 Y118.398 E.00323
G1 X115.022 Y118.398 E.58019
G1 X115.433 Y118.569 E.01432
G1 X115.602 Y118.979 E.01425
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.828 J.022 E.00462
G1 X115.431 Y133.433 E.01127
G1 X115.122 Y133.593 E.01122
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00564
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.846 I.021 J.24 E.00566
G1 X115.21 Y118.979 E.00429
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.00429
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.813 Y133.077 E.00251
; WIPE_START
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X104.358 Y132.209 Z1.2 F12000
G1 X116.02 Y133.958 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42046
G1 F6000
M204 S3000
G1 X115.949 Y133.999 E.00244
G1 X116.02 Y134.039 E.00244
G1 X116.043 Y133.999 E.00141
; WIPE_START
G1 X116.02 Y134.039 E-.17026
G1 X115.949 Y133.999 E-.29487
G1 X116.02 Y133.958 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y126.325 Z1.2 F12000
G1 X116.022 Y117.965 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.41852
G1 F6000
M204 S3000
G1 X115.952 Y118.006 E.00241
G1 X116.022 Y118.046 E.00241
G1 X116.046 Y118.006 E.00139
; WIPE_START
G1 X116.022 Y118.046 E-.17026
G1 X115.952 Y118.006 E-.29487
G1 X116.022 Y117.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X108.39 Y117.964 Z1.2 F12000
G1 X96.026 Y117.961 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17026
G1 X95.955 Y118.002 E-.29487
G1 X96.026 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y125.594 Z1.2 F12000
G1 X96.026 Y133.957 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 5/40
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
M106 S76.5
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1.2 I.327 J1.172 P1  F12000
G1 X162.621 Y115.379 Z1.2
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.37463
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01698
G1 X162.333 Y115.657 E.01228
G1 X161.975 Y115.379 E.01186
G1 X162.561 Y115.379 E.01533
; WIPE_START
G1 X162.62 Y116.027 E-.24736
G1 X162.333 Y115.657 E-.17814
G1 X161.975 Y115.379 E-.17204
G1 X162.403 Y115.379 E-.16247
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.483 Y123.011 Z1.4 F12000
G1 X162.618 Y135.98 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01678
G1 X161.971 Y136.622 E.01693
G1 X162.341 Y136.334 E.01226
G1 X162.581 Y136.027 E.01019
; WIPE_START
G1 X162.618 Y136.622 E-.22635
G1 X161.971 Y136.622 E-.246
G1 X162.341 Y136.334 E-.17809
G1 X162.519 Y136.107 E-.10957
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y136.266 Z1.4 F12000
G1 X138.02 Y136.618 Z1.4
G1 Z1
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01678
G1 X137.378 Y135.971 E.01693
M73 P50 R9
G1 X137.666 Y136.341 E.01225
G1 X137.973 Y136.581 E.0102
; WIPE_START
G1 X137.378 Y136.618 E-.22639
G1 X137.378 Y135.971 E-.24597
G1 X137.666 Y136.341 E-.17805
G1 X137.893 Y136.519 E-.10959
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y128.886 Z1.4 F12000
G1 X138.029 Y115.378 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X137.757 Y115.585 E.00894
G1 X137.382 Y116.021 E.01506
G1 X137.382 Y115.378 E.01682
G1 X137.969 Y115.378 E.01536
; WIPE_START
G1 X137.757 Y115.585 E-.11256
G1 X137.382 Y116.021 E-.21879
G1 X137.382 Y115.378 E-.24442
G1 X137.867 Y115.378 E-.18424
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.499 Y115.423 Z1.4 F12000
G1 X161.422 Y115.518 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y115.577 E.00551
G1 X162.061 Y115.907 E.01866
G1 X162.334 Y116.26 E.01435
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.0181
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.801 E.04969
; LINE_WIDTH: 0.44852
G1 X162.542 Y135.258 E.01476
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01115
G1 X162.092 Y136.062 E.01872
G1 X161.74 Y136.334 E.01428
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.603 E.0181
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.603 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.603 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.603 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.602 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.602 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.602 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.602 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.602 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.602 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.602 E.06208
; LINE_WIDTH: 0.43575
G1 X139.2 Y136.602 E.04968
; LINE_WIDTH: 0.44856
G1 X138.743 Y136.543 E.01476
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01116
G1 X137.938 Y136.092 E.01873
G1 X137.667 Y135.74 E.01428
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.8 E.01811
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.8 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.8 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.8 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.8 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.167 E.05072
; LINE_WIDTH: 0.44792
G1 X137.448 Y116.772 E.01275
; LINE_WIDTH: 0.44999
G3 X138.26 Y115.667 I1.782 J.458 E.04519
G1 X138.643 Y115.49 E.01359
G1 X139.199 Y115.397 E.01811
; LINE_WIDTH: 0.43731
G1 X160.8 Y115.397 E.67297
; LINE_WIDTH: 0.44901
G1 X161.257 Y115.457 E.01478
; LINE_WIDTH: 0.44999
G1 X161.366 Y115.497 E.00373
M204 S10000
G1 X161.315 Y115.921 F12000
G1 F6000
M204 S3000
G1 X161.627 Y116.075 E.01119
G3 X162.113 Y116.731 I-1.116 J1.333 E.02651
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.186 E.01254
G1 X161.926 Y135.627 E.0158
G3 X161.269 Y136.113 I-1.334 J-1.117 E.02652
G1 X160.801 Y136.202 E.01532
G1 X139.2 Y136.202 E.69459
G1 X138.814 Y136.142 E.01254
G1 X138.373 Y135.925 E.01582
G3 X137.887 Y135.269 I1.116 J-1.333 E.02651
G1 X137.798 Y134.801 E.01533
G1 X137.799 Y117.167 E.567
G1 X137.847 Y116.843 E.01053
G1 X138.069 Y116.382 E.01645
G3 X138.505 Y115.991 I1.154 J.849 E.01897
G1 X138.731 Y115.887 E.00799
G1 X139.199 Y115.798 E.01532
G1 X160.8 Y115.798 E.6946
G1 X161.186 Y115.858 E.01254
G1 X161.261 Y115.895 E.00271
M204 S250
G1 X161.151 Y116.261 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y116.266 E.00084
G1 X161.484 Y116.462 E.01079
G1 X161.73 Y116.815 E.01283
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.801 E.52427
G1 X161.734 Y135.179 E.0115
G1 X161.538 Y135.484 E.01078
G1 X161.184 Y135.73 E.01284
G1 X160.801 Y135.81 E.01168
G1 X139.2 Y135.81 E.6434
G1 X138.821 Y135.734 E.01151
G1 X138.516 Y135.538 E.01079
G1 X138.27 Y135.185 E.01283
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.167 E.52522
G1 X138.254 Y116.854 E.00954
G1 X138.462 Y116.516 E.0118
G1 X138.742 Y116.304 E.01047
G1 X139.199 Y116.19 E.01403
G1 X160.8 Y116.19 E.64341
G1 X161.093 Y116.249 E.00888
; WIPE_START
M204 S3000
G1 X161.179 Y116.266 E-.03355
G1 X161.484 Y116.462 E-.13766
G1 X161.73 Y116.815 E-.16366
G1 X161.81 Y117.199 E-.14904
G1 X161.81 Y117.926 E-.27608
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.93 Y115.075 Z1.4 F12000
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.291 E.0072
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I86.792 J.663 E.06138
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.801 E.04969
; LINE_WIDTH: 0.44458
G1 X162.99 Y135.01 E.00663
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.743 I232.681 J1.26 E.05572
G1 X162.936 Y136.916 E.00581
G1 X162.751 Y136.991 E.0064
G2 X160.801 Y136.997 I-.684 J92.558 E.06273
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.997 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.997 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.996 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.996 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.996 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.996 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.995 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.995 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.995 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.995 E.06208
; LINE_WIDTH: 0.43575
G1 X139.2 Y136.995 E.04968
; LINE_WIDTH: 0.44484
G1 X138.991 Y136.99 E.00662
; LINE_WIDTH: 0.44999
G2 X137.257 Y136.987 I-1.265 J244.652 E.05575
G1 X137.084 Y136.936 E.00581
G1 X137.009 Y136.751 E.00641
G2 X137.003 Y134.8 I-92.407 J-.686 E.06273
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.8 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.8 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.8 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.8 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.8 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.8 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.8 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.8 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.167 E.05072
; LINE_WIDTH: 0.44525
G1 X137.01 Y116.958 E.00665
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.225 I-233.947 J-1.228 E.05575
G1 X137.086 Y115.066 E.00562
G1 X137.267 Y115.009 E.00611
G2 X139.199 Y115.003 I.663 J-92.56 E.06213
; LINE_WIDTH: 0.43731
G1 X160.8 Y115.003 E.67297
; LINE_WIDTH: 0.44649
G1 X161.009 Y115.008 E.00665
; LINE_WIDTH: 0.44999
G2 X162.727 Y115.009 I1.223 J-357.568 E.05525
G1 X162.873 Y115.057 E.00494
M204 S10000
G1 X163.181 Y114.771 F12000
G1 F6000
M204 S3000
G1 X163.343 Y114.969 E.00823
G1 X163.397 Y115.291 E.0105
G1 X163.394 Y136.824 E.69239
G1 X163.299 Y137.103 E.00949
; object ids of layer 5 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer5 end: 47,58
M625
G1 X163.113 Y137.3 E.00871
G1 X162.771 Y137.398 E.01142
G1 X137.176 Y137.394 E.82302
G1 X136.897 Y137.299 E.0095
G1 X136.7 Y137.113 E.0087
G1 X136.602 Y136.771 E.01143
G1 X136.606 Y115.176 E.69439
G1 X136.703 Y114.895 E.00956
G1 X136.895 Y114.693 E.00897
G1 X137.24 Y114.602 E.01147
G1 X161.24 Y114.602 E.77173
G3 X162.815 Y114.611 I.394 J70.387 E.05065
G1 X163.129 Y114.707 E.01058
G1 X163.143 Y114.724 E.0007
M204 S250
G1 X163.493 Y114.515 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.55 Y114.557 E.00212
G1 X163.712 Y114.821 E.00922
G1 X163.789 Y115.291 E.0142
G1 X163.786 Y136.743 E.63895
G1 X163.713 Y137.178 E.01314
G1 X163.551 Y137.441 E.00921
G1 X163.317 Y137.641 E.00916
G3 X162.79 Y137.79 I-.737 J-1.599 E.01637
G1 X137.257 Y137.786 E.76052
G1 X136.822 Y137.713 E.01314
G1 X136.559 Y137.551 E.00921
G1 X136.359 Y137.317 E.00916
G3 X136.21 Y136.79 I1.599 J-.737 E.01637
G1 X136.214 Y115.282 E.64066
G3 X136.817 Y114.3 I1.056 J-.027 E.03629
G1 X137.213 Y114.21 E.01211
G1 X161.213 Y114.21 E.71486
G3 X162.963 Y114.238 I.621 J16.119 E.05214
G1 X163.232 Y114.321 E.00839
G1 X163.444 Y114.479 E.00789
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.55 Y114.557 E-.04982
G1 X163.712 Y114.821 E-.11762
G1 X163.789 Y115.291 E-.18122
G1 X163.789 Y116.374 E-.41134
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.655 Y119.086 Z1.4 F12000
G1 X116.391 Y134.391 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-104.471 J-.212 E.04403
; LINE_WIDTH: 0.43721
G1 X95.603 Y131.021 E.06229
; LINE_WIDTH: 0.43707
G1 X95.603 Y129.021 E.06227
; LINE_WIDTH: 0.43693
G1 X95.604 Y127.021 E.06225
; LINE_WIDTH: 0.43679
G1 X95.604 Y125.021 E.06223
; LINE_WIDTH: 0.43665
G1 X95.604 Y123.021 E.0622
; LINE_WIDTH: 0.43651
G1 X95.604 Y121.021 E.06218
; LINE_WIDTH: 0.43637
G1 X95.604 Y119.021 E.06216
; LINE_WIDTH: 0.43623
G1 X95.604 Y118.978 E.00134
; LINE_WIDTH: 0.44999
G1 X95.612 Y117.609 E.04403
G2 X96.979 Y117.603 I.225 J-102.767 E.04396
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.603 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.604 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.604 E.0622
; LINE_WIDTH: 0.43636
G1 X104.979 Y117.605 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.605 E.06212
; LINE_WIDTH: 0.43585
G1 X108.979 Y117.605 E.06208
; LINE_WIDTH: 0.4356
G1 X110.979 Y117.606 E.06204
; LINE_WIDTH: 0.43535
G1 X112.979 Y117.606 E.062
; LINE_WIDTH: 0.43509
G1 X114.979 Y117.607 E.06196
; LINE_WIDTH: 0.43484
G1 X115.022 Y117.607 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.614 E.044
G2 X116.397 Y118.979 I102.708 J.19 E.04386
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.714 Y134.742 F12000
G1 F6000
M204 S3000
G1 X116.56 Y134.798 E.00528
G1 X95.463 Y134.798 E.67837
G1 X95.25 Y134.712 E.00738
G1 X95.202 Y134.548 E.0055
G1 X95.204 Y117.414 E.55097
G1 X95.288 Y117.25 E.00589
G1 X95.452 Y117.202 E.0055
G1 X116.6 Y117.207 E.68003
G1 X116.744 Y117.278 E.00515
G1 X116.797 Y117.451 E.00581
G1 X116.798 Y134.537 E.54941
G1 X116.739 Y134.689 E.00526
M204 S250
G1 X116.85 Y135.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X116.587 Y135.19 I-.401 J-.908 E.00817
G1 X95.495 Y135.19 E.62823
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.549 J-.831 E.01065
G1 X94.81 Y134.583 E.00939
G1 X94.812 Y118.583 E.47657
G3 X94.833 Y117.285 I22.894 J-.288 E.03866
G3 X95.114 Y116.898 I.632 J.163 E.01462
G1 X95.417 Y116.81 E.00939
G1 X116.554 Y116.815 E.62958
G3 X116.968 Y116.955 I0 J.684 E.01323
G1 X117.152 Y117.198 E.00908
G1 X117.189 Y117.45 E.0076
G1 X117.19 Y134.505 E.50798
G1 X117.132 Y134.845 E.01028
G1 X116.98 Y135.045 E.00748
G3 X116.904 Y135.089 I-.532 J-.839 E.00263
; WIPE_START
M204 S3000
G1 X116.587 Y135.19 E-.12645
G1 X114.92 Y135.19 E-.63356
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.322 Y134.458 Z1.4 F12000
G1 X96.103 Y133.376 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44614
G1 X95.997 Y133.021 E.00543
; LINE_WIDTH: 0.43721
G1 X95.997 Y131.021 E.06229
; LINE_WIDTH: 0.43707
G1 X95.997 Y129.021 E.06227
; LINE_WIDTH: 0.43693
G1 X95.997 Y127.021 E.06225
; LINE_WIDTH: 0.43679
G1 X95.998 Y125.021 E.06223
; LINE_WIDTH: 0.43665
G1 X95.998 Y123.021 E.0622
; LINE_WIDTH: 0.43651
G1 X95.998 Y121.021 E.06218
; LINE_WIDTH: 0.43637
G1 X95.998 Y119.021 E.06216
; LINE_WIDTH: 0.43623
G1 X95.998 Y118.979 E.00133
; LINE_WIDTH: 0.44999
G1 X96.281 Y118.279 E.02426
G1 X96.808 Y118.008 E.01908
; LINE_WIDTH: 0.44605
G1 X96.979 Y117.997 E.00543
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.997 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.998 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.998 E.0622
; LINE_WIDTH: 0.43636
G1 X104.979 Y117.998 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.998 E.06212
; LINE_WIDTH: 0.43585
G1 X108.979 Y117.998 E.06208
; LINE_WIDTH: 0.4356
G1 X110.979 Y117.998 E.06204
; LINE_WIDTH: 0.43535
G1 X112.979 Y117.998 E.062
; LINE_WIDTH: 0.43509
G1 X114.979 Y117.998 E.06196
; LINE_WIDTH: 0.43484
M73 P51 R9
G1 X115.021 Y117.998 E.00133
; LINE_WIDTH: 0.44999
G1 X115.722 Y118.282 E.02428
G1 X116.003 Y118.979 E.02416
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.429 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00283
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.978 E.45156
G1 X96.568 Y118.568 E.01431
G1 X96.878 Y118.407 E.01123
G1 X115.022 Y118.398 E.58341
G1 X115.433 Y118.569 E.01433
G1 X115.602 Y118.979 E.01425
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.946 Y118.793 E.00338
G1 X114.979 Y118.79 E.53711
G3 X115.155 Y118.846 I.021 J.24 E.00566
G1 X115.21 Y118.979 E.00429
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00564
G1 X96.813 Y133.077 E.00251
; WIPE_START
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.355 Y123.458 Z1.4 F12000
G1 X96.027 Y117.961 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42052
G1 F6000
M204 S3000
G1 X95.957 Y118.002 E.00244
G1 X96.027 Y118.043 E.00244
G1 X96.051 Y118.002 E.00141
; WIPE_START
G1 X96.027 Y118.043 E-.17025
G1 X95.957 Y118.002 E-.29487
G1 X96.027 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y125.593 Z1.4 F12000
G1 X96.026 Y133.957 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17026
G1 X95.955 Y133.998 E-.29487
G1 X96.026 Y133.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y133.957 Z1.4 F12000
G1 X116.021 Y133.957 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; WIPE_START
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y126.324 Z1.4 F12000
G1 X116.022 Y117.965 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.41858
G1 F6000
M204 S3000
G1 X115.952 Y118.006 E.00241
G1 X116.022 Y118.046 E.00241
G1 X116.046 Y118.006 E.00139
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.022 Y118.046 E-.17026
G1 X115.952 Y118.006 E-.29487
G1 X116.022 Y117.965 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 6/40
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
M106 S79.05
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1.4 I.067 J1.215 P1  F12000
G1 X162.621 Y115.379 Z1.4
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.37464
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01699
G1 X162.415 Y115.756 E.0089
G1 X161.974 Y115.379 E.01523
G1 X162.561 Y115.379 E.01538
; WIPE_START
G1 X162.62 Y116.027 E-.24737
G1 X162.415 Y115.756 E-.12903
G1 X161.974 Y115.379 E-.22086
G1 X162.402 Y115.379 E-.16274
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.482 Y123.011 Z1.6 F12000
G1 X162.618 Y135.98 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01678
G1 X161.971 Y136.622 E.01693
G1 X162.341 Y136.334 E.01226
G1 X162.581 Y136.027 E.01019
; WIPE_START
G1 X162.618 Y136.622 E-.22629
G1 X161.971 Y136.622 E-.24603
G1 X162.341 Y136.334 E-.17813
G1 X162.519 Y136.107 E-.10954
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y136.267 Z1.6 F12000
G1 X138.024 Y136.621 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01693
G1 X137.379 Y135.972 E.01702
G1 X137.667 Y136.343 E.01231
G1 X137.977 Y136.584 E.0103
; WIPE_START
G1 X137.379 Y136.621 E-.22772
G1 X137.379 Y135.972 E-.2466
G1 X137.667 Y136.343 E-.17839
G1 X137.89 Y136.517 E-.10729
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.941 Y128.884 Z1.6 F12000
G1 X138.033 Y115.378 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.37261
G1 F6000
M204 S3000
G1 X137.664 Y115.657 E.01205
G1 X137.381 Y116.026 E.01211
G1 X137.381 Y115.378 E.01688
G1 X137.973 Y115.378 E.01541
; WIPE_START
G1 X137.664 Y115.657 E-.15823
G1 X137.381 Y116.026 E-.17666
G1 X137.381 Y115.378 E-.24631
G1 X137.852 Y115.378 E-.1788
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.484 Y115.417 Z1.6 F12000
G1 X161.372 Y115.499 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.45833
G1 F6000
M204 S3000
G1 X161.489 Y115.538 E.00405
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01132
G1 X162.121 Y115.979 E.01361
G1 X162.334 Y116.26 E.01133
G1 X162.511 Y116.644 E.01361
G1 X162.603 Y117.199 E.0181
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.8 E.04967
; LINE_WIDTH: 0.44852
G1 X162.542 Y135.257 E.01477
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01115
G1 X162.092 Y136.062 E.01873
G1 X161.74 Y136.333 E.01428
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.603 E.01811
; LINE_WIDTH: 0.43732
G1 X139.2 Y136.603 E.67297
; LINE_WIDTH: 0.44904
G1 X138.742 Y136.543 E.0148
; LINE_WIDTH: 0.44999
G1 X138.416 Y136.423 E.01116
G1 X137.939 Y136.093 E.01866
G1 X137.666 Y135.74 E.01434
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.167 E.05072
; LINE_WIDTH: 0.45046
G1 X137.493 Y116.626 E.01769
G1 X137.653 Y116.279 E.0123
; LINE_WIDTH: 0.44999
G1 X137.929 Y115.913 E.01473
G1 X138.35 Y115.611 E.01668
G1 X138.693 Y115.473 E.01189
; LINE_WIDTH: 0.4495
G1 X139.199 Y115.397 E.01644
; LINE_WIDTH: 0.43731
G1 X160.8 Y115.397 E.67296
; LINE_WIDTH: 0.45833
G3 X161.159 Y115.427 I.06 J1.455 E.01184
G1 X161.315 Y115.48 E.0054
M204 S10000
G1 X161.27 Y115.91 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.0119
G3 X162.113 Y116.732 I-1.039 J1.312 E.02724
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.8 E.56597
G1 X162.142 Y135.186 E.01255
G1 X161.926 Y135.627 E.0158
G3 X161.269 Y136.113 I-1.334 J-1.117 E.02653
G1 X160.801 Y136.202 E.01532
G1 X139.2 Y136.202 E.69459
G1 X138.814 Y136.142 E.01256
G1 X138.373 Y135.925 E.0158
G3 X137.991 Y135.494 I.893 J-1.175 E.01863
G1 X137.887 Y135.269 E.008
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.167 E.56701
G1 X137.889 Y116.721 E.01464
G1 X137.983 Y116.517 E.00722
G1 X138.221 Y116.197 E.01283
G1 X138.571 Y115.953 E.01371
G1 X139.086 Y115.809 E.0172
G1 X139.199 Y115.798 E.00366
G1 X160.8 Y115.798 E.6946
G1 X161.103 Y115.834 E.00979
G1 X161.216 Y115.885 E.00398
M204 S250
G1 X161.116 Y116.246 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.461 E.01269
G1 X161.73 Y116.816 E.01285
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.8 E.52426
G1 X161.734 Y135.179 E.01151
G1 X161.539 Y135.484 E.01077
G1 X161.185 Y135.73 E.01284
G1 X160.801 Y135.81 E.01168
G1 X139.2 Y135.81 E.6434
G1 X138.821 Y135.733 E.01152
G1 X138.516 Y135.538 E.01077
G1 X138.304 Y135.258 E.01048
G1 X138.19 Y134.801 E.01403
G1 X138.191 Y117.167 E.52522
G1 X138.301 Y116.746 E.01297
G1 X138.536 Y116.443 E.01144
G1 X138.849 Y116.256 E.01086
G1 X139.199 Y116.19 E.01062
G1 X160.8 Y116.19 E.64341
G1 X161.058 Y116.234 E.00777
; WIPE_START
M204 S3000
G1 X161.484 Y116.461 E-.18353
G1 X161.73 Y116.816 E-.16395
G1 X161.81 Y117.199 E-.14897
G1 X161.81 Y117.893 E-.26355
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.901 Y115.049 Z1.6 F12000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.207 E.00583
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I90.657 J.705 E.06408
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.8 E.04967
; LINE_WIDTH: 0.44457
G1 X162.99 Y135.009 E.00661
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.716 I229.105 J1.246 E.05491
G1 X162.932 Y136.923 E.00687
G1 X162.732 Y136.991 E.0068
G2 X160.801 Y136.997 I-.661 J92.61 E.06209
; LINE_WIDTH: 0.43732
G1 X139.2 Y136.997 E.67297
; LINE_WIDTH: 0.44657
G1 X138.991 Y136.993 E.00666
; LINE_WIDTH: 0.44999
G2 X137.315 Y136.991 I-1.198 J353.309 E.05388
G1 X137.071 Y136.924 E.00814
G1 X137.009 Y136.732 E.0065
G2 X137.003 Y134.8 I-91.427 J-.676 E.06211
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.8 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.8 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.8 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.8 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.8 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.8 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.8 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.8 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.167 E.05072
; LINE_WIDTH: 0.45244
G2 X137.013 Y116.072 I-17.65 J-.663 E.03543
; LINE_WIDTH: 0.44999
G1 X137.013 Y115.26 E.02612
G1 X137.065 Y115.083 E.00594
G1 X137.249 Y115.009 E.00636
G1 X138.647 Y115.009 E.04497
; LINE_WIDTH: 0.4495
G1 X139.199 Y115.003 E.01773
; LINE_WIDTH: 0.43731
G1 X160.8 Y115.003 E.67296
; LINE_WIDTH: 0.44285
G1 X160.963 Y115.006 E.00513
; LINE_WIDTH: 0.44999
G2 X162.706 Y115.009 I1.2 J-160.209 E.05604
G1 X162.842 Y115.037 E.00447
M204 S10000
G1 X163.144 Y114.724 F12000
G1 F6000
M204 S3000
G1 X163.338 Y114.952 E.00962
G1 X163.397 Y115.2 E.00821
G1 X163.394 Y135.2 E.64311
G3 X163.376 Y136.898 I-41.606 J.408 E.0546
G1 X163.247 Y137.188 E.01021
; object ids of layer 6 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer6 end: 47,58
M625
G1 X163.057 Y137.325 E.00753
G1 X162.76 Y137.398 E.00985
G1 X138.76 Y137.398 E.77173
G3 X137.1 Y137.371 I-.394 J-26.712 E.05337
G1 X136.809 Y137.243 E.01024
G1 X136.678 Y137.062 E.00719
G1 X136.602 Y136.76 E.01
G1 X136.606 Y115.176 E.69403
G1 X136.701 Y114.897 E.00948
G1 X136.882 Y114.704 E.00852
G1 X137.229 Y114.602 E.01163
G1 X161.229 Y114.602 E.77173
G3 X162.816 Y114.611 I.372 J75.592 E.05104
G1 X163.093 Y114.696 E.00932
M204 S250
G1 X163.441 Y114.463 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.451 Y114.469 E.00038
G1 X163.697 Y114.786 E.01195
G1 X163.789 Y115.2 E.01264
G1 X163.786 Y136.716 E.64088
G1 X163.713 Y137.178 E.01391
G1 X163.55 Y137.443 E.00926
G3 X162.786 Y137.79 I-.818 J-.785 E.0256
G1 X137.315 Y137.79 E.75868
G1 X136.858 Y137.726 E.01375
G1 X136.556 Y137.549 E.01042
G3 X136.21 Y136.787 I.786 J-.817 E.02554
G1 X136.214 Y115.26 E.6412
G1 X136.287 Y114.822 E.01322
M73 P52 R9
G1 X136.449 Y114.558 E.00922
G1 X136.676 Y114.363 E.00891
G3 X137.21 Y114.21 I.756 J1.624 E.0166
G1 X162.706 Y114.21 E.75942
G1 X163.107 Y114.261 E.01205
G1 X163.389 Y114.432 E.00982
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.451 Y114.469 E-.02759
G1 X163.697 Y114.786 E-.1524
G1 X163.789 Y115.2 E-.16122
G1 X163.789 Y116.302 E-.41879
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.658 Y119.024 Z1.6 F12000
G1 X116.391 Y134.391 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.223 J-103.836 E.04404
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.603 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.604 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.604 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.605 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.605 E.06212
; LINE_WIDTH: 0.43584
G1 X108.979 Y117.605 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.606 E.06204
; LINE_WIDTH: 0.43533
G1 X112.979 Y117.606 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.607 E.06196
; LINE_WIDTH: 0.43482
G1 X115.022 Y117.607 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.614 E.044
G2 X116.397 Y118.979 I102.704 J.19 E.04386
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.75 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67798
G1 X95.26 Y134.72 E.00701
G1 X95.202 Y134.56 E.00546
G1 X95.202 Y117.463 E.54974
G1 X95.288 Y117.251 E.00738
G1 X95.452 Y117.202 E.00551
G1 X116.562 Y117.207 E.67882
G1 X116.718 Y117.265 E.00535
G1 X116.797 Y117.418 E.00552
G1 X116.798 Y134.537 E.55046
G1 X116.735 Y134.694 E.00545
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01029
G1 X94.955 Y134.98 E.00747
G3 X94.81 Y134.587 I.838 J-.532 E.01258
G1 X94.81 Y117.495 E.50909
G1 X94.868 Y117.155 E.01028
G3 X95.114 Y116.898 I.829 J.547 E.01065
G1 X95.417 Y116.81 E.0094
G1 X116.562 Y116.815 E.62982
G1 X116.881 Y116.886 E.00973
G1 X117.075 Y117.058 E.00771
G3 X117.189 Y117.418 I-.876 J.475 E.01132
G1 X117.19 Y134.505 E.50895
G1 X117.132 Y134.845 E.01027
G3 X116.933 Y135.066 I-.832 J-.549 E.00888
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14136
G1 X114.955 Y135.19 E-.61864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.356 Y134.469 Z1.6 F12000
G1 X96.117 Y133.403 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01912
; LINE_WIDTH: 0.44605
G1 X96.979 Y117.997 E.00543
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.997 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.998 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.998 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.998 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.998 E.06212
; LINE_WIDTH: 0.43584
G1 X108.979 Y117.998 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.998 E.06204
; LINE_WIDTH: 0.43533
G1 X112.979 Y117.998 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.998 E.06196
; LINE_WIDTH: 0.43482
G1 X115.021 Y117.998 E.00133
; LINE_WIDTH: 0.44999
G1 X115.722 Y118.282 E.02428
G1 X116.003 Y118.979 E.02416
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01125
G1 X96.979 Y118.398 E.00323
G1 X115.022 Y118.398 E.58019
G1 X115.433 Y118.569 E.01433
G1 X115.602 Y118.979 E.01425
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00564
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.846 I.021 J.24 E.00566
G1 X115.21 Y118.979 E.00429
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z1.6 F12000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z1.6 F12000
G1 X96.026 Y117.961 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17026
G1 X95.955 Y118.002 E-.29487
G1 X96.026 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.963 Z1.6 F12000
G1 X116.022 Y117.965 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y118.006 E.00241
G1 X116.022 Y118.046 E.00241
G1 X116.046 Y118.006 E.00139
; WIPE_START
G1 X116.022 Y118.046 E-.17026
G1 X115.952 Y118.006 E-.29487
G1 X116.022 Y117.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y125.598 Z1.6 F12000
G1 X116.021 Y133.957 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 7/40
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1.6 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z1.6
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.37465
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01699
G1 X162.416 Y115.756 E.00889
G1 X161.974 Y115.379 E.01524
G1 X162.561 Y115.379 E.01538
; WIPE_START
G1 X162.621 Y116.027 E-.2474
G1 X162.416 Y115.756 E-.12898
G1 X161.974 Y115.379 E-.22098
G1 X162.402 Y115.379 E-.16264
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.483 Y123.011 Z1.8 F12000
G1 X162.621 Y135.976 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.621 Y136.621 E.01693
G1 X161.972 Y136.621 E.01703
G1 X162.343 Y136.333 E.01232
G1 X162.584 Y136.023 E.0103
; WIPE_START
G1 X162.621 Y136.621 E-.2277
G1 X161.972 Y136.621 E-.24667
G1 X162.343 Y136.333 E-.17846
G1 X162.516 Y136.111 E-.10718
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y136.27 Z1.8 F12000
G1 X138.024 Y136.621 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.37496
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01693
G1 X137.379 Y135.972 E.01702
G1 X137.667 Y136.343 E.01231
G1 X137.977 Y136.584 E.0103
; WIPE_START
G1 X137.379 Y136.621 E-.22768
G1 X137.379 Y135.972 E-.24662
G1 X137.667 Y136.343 E-.17841
G1 X137.89 Y136.517 E-.10729
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y128.884 Z1.8 F12000
G1 X138.035 Y115.378 Z1.8
G1 Z1.4
M73 P53 R9
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X137.736 Y115.601 E.00975
G1 X137.382 Y116.021 E.01437
G1 X137.382 Y115.378 E.01682
G1 X137.975 Y115.378 E.01551
; WIPE_START
G1 X137.736 Y115.601 E-.12419
G1 X137.382 Y116.021 E-.20888
G1 X137.382 Y115.378 E-.24441
G1 X137.862 Y115.378 E-.18253
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.494 Y115.418 Z1.8 F12000
G1 X161.373 Y115.499 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.45828
G1 F6000
M204 S3000
G1 X161.489 Y115.538 E.004
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01133
G1 X162.121 Y115.979 E.01361
G1 X162.333 Y116.26 E.01131
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.01811
; LINE_WIDTH: 0.43693
G1 X162.603 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.603 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.603 Y134.801 E.17444
; LINE_WIDTH: 0.44897
G1 X162.543 Y135.258 E.01478
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01116
G1 X162.093 Y136.061 E.01867
G1 X161.74 Y136.334 E.01434
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.603 E.01811
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.603 E.67298
; LINE_WIDTH: 0.44904
G1 X138.742 Y136.543 E.0148
; LINE_WIDTH: 0.44999
G1 X138.416 Y136.423 E.01116
G1 X137.939 Y136.093 E.01865
G1 X137.666 Y135.74 E.01434
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.4479
G1 X137.448 Y116.773 E.01274
; LINE_WIDTH: 0.44999
G1 X137.557 Y116.463 E.01056
G3 X138.965 Y115.409 I1.695 J.797 E.05885
; LINE_WIDTH: 0.44752
G1 X139.135 Y115.399 E.00545
; LINE_WIDTH: 0.43859
G1 X141.135 Y115.399 E.06251
; LINE_WIDTH: 0.43846
G1 X143.135 Y115.399 E.06249
; LINE_WIDTH: 0.43833
G1 X145.135 Y115.399 E.06247
; LINE_WIDTH: 0.43821
G1 X147.135 Y115.398 E.06245
; LINE_WIDTH: 0.43808
G1 X149.135 Y115.398 E.06243
; LINE_WIDTH: 0.43796
G1 X151.135 Y115.398 E.06241
; LINE_WIDTH: 0.43783
G1 X153.135 Y115.398 E.06239
; LINE_WIDTH: 0.43771
G1 X155.135 Y115.398 E.06237
; LINE_WIDTH: 0.43758
G1 X157.135 Y115.398 E.06235
; LINE_WIDTH: 0.43746
G1 X159.135 Y115.397 E.06233
; LINE_WIDTH: 0.43733
G1 X160.8 Y115.397 E.05189
; LINE_WIDTH: 0.45828
G3 X161.159 Y115.427 I.06 J1.455 E.01183
G1 X161.316 Y115.48 E.00545
M204 S10000
G1 X161.272 Y115.911 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01186
G3 X162.113 Y116.731 I-1.038 J1.311 E.02722
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.186 E.01254
G1 X161.925 Y135.627 E.01581
G3 X161.269 Y136.113 I-1.334 J-1.117 E.02652
G1 X160.801 Y136.202 E.01532
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01256
G1 X138.373 Y135.926 E.01579
G3 X137.887 Y135.268 I1.117 J-1.335 E.02653
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.168 E.56699
G1 X137.847 Y116.844 E.01053
G1 X138.069 Y116.382 E.01646
G3 X138.669 Y115.909 I1.311 J1.046 E.02479
G1 X139.135 Y115.8 E.01538
G1 X160.8 Y115.798 E.69667
G1 X161.102 Y115.834 E.00978
G1 X161.217 Y115.886 E.00404
M204 S250
G1 X161.118 Y116.247 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.462 E.01265
G1 X161.73 Y116.815 E.01284
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.801 E.52426
G1 X161.734 Y135.179 E.01151
G1 X161.538 Y135.484 E.01078
G1 X161.184 Y135.73 E.01284
G1 X160.801 Y135.81 E.01168
G1 X139.199 Y135.81 E.64341
G1 X138.82 Y135.733 E.01152
G1 X138.516 Y135.538 E.01076
G1 X138.27 Y135.184 E.01285
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.168 E.52521
G1 X138.254 Y116.854 E.00954
G1 X138.459 Y116.518 E.0117
G1 X138.776 Y116.287 E.01169
G1 X139.135 Y116.193 E.01106
G1 X160.8 Y116.19 E.64532
G1 X161.059 Y116.234 E.00782
; WIPE_START
M204 S3000
G1 X161.484 Y116.462 E-.18307
G1 X161.73 Y116.815 E-.16375
G1 X161.81 Y117.199 E-.14905
G1 X161.81 Y117.895 E-.26414
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.933 Y115.083 Z1.8 F12000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.263 E.00609
; LINE_WIDTH: 0.45008
G2 X162.997 Y117.199 I89.113 J.663 E.06227
; LINE_WIDTH: 0.43693
G1 X162.997 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.997 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.997 Y134.801 E.17444
; LINE_WIDTH: 0.44622
G1 X162.993 Y135.009 E.00665
; LINE_WIDTH: 0.44999
G2 X162.991 Y136.699 I325.362 J1.195 E.05433
G1 X162.929 Y136.925 E.00754
G1 X162.71 Y136.991 E.00735
G2 X160.801 Y136.997 I-.651 J91.355 E.0614
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.997 E.67298
; LINE_WIDTH: 0.44657
G1 X138.99 Y136.993 E.00666
; LINE_WIDTH: 0.44999
G2 X137.301 Y136.991 I-1.205 J358.273 E.05433
G1 X137.075 Y136.93 E.00751
G1 X137.009 Y136.712 E.00731
G2 X137.003 Y134.8 I-90.2 J-.668 E.06148
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.8 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.8 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.8 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.8 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.44519
G1 X137.01 Y116.959 E.00663
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.225 I-232.32 J-1.229 E.05578
G1 X137.086 Y115.066 E.00562
G1 X137.266 Y115.009 E.00609
G2 X139.135 Y115.003 I.612 J-105.93 E.06008
; LINE_WIDTH: 0.43859
G1 X141.135 Y115.003 E.06251
; LINE_WIDTH: 0.43846
G1 X143.135 Y115.003 E.06249
; LINE_WIDTH: 0.43833
G1 X145.135 Y115.003 E.06247
; LINE_WIDTH: 0.43821
G1 X147.135 Y115.003 E.06245
; LINE_WIDTH: 0.43808
G1 X149.135 Y115.003 E.06243
; LINE_WIDTH: 0.43796
G1 X151.135 Y115.003 E.06241
; LINE_WIDTH: 0.43783
G1 X153.135 Y115.003 E.06239
; LINE_WIDTH: 0.43771
G1 X155.135 Y115.003 E.06237
; LINE_WIDTH: 0.43758
G1 X157.135 Y115.003 E.06235
; LINE_WIDTH: 0.43746
G1 X159.135 Y115.003 E.06233
; LINE_WIDTH: 0.43733
G1 X160.8 Y115.003 E.05189
; LINE_WIDTH: 0.45828
G2 X161.973 Y115.009 I.685 J-18.08 E.0385
; LINE_WIDTH: 0.44999
G1 X162.779 Y115.017 E.02592
G1 X162.878 Y115.059 E.00344
M204 S10000
G1 X163.185 Y114.761 F12000
G1 F6000
M204 S3000
G1 X163.365 Y115.028 E.01038
G1 X163.397 Y115.263 E.00762
G1 X163.398 Y135.263 E.64311
G3 X163.376 Y136.893 I-32.032 J.383 E.05241
G1 X163.275 Y137.152 E.00895
; object ids of layer 7 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer7 end: 47,58
M625
G1 X163.104 Y137.299 E.00724
G1 X162.747 Y137.398 E.01193
G1 X138.747 Y137.398 E.77173
G3 X137.108 Y137.376 I-.387 J-32.4 E.05272
G1 X136.848 Y137.275 E.00897
G1 X136.695 Y137.092 E.00768
G1 X136.602 Y136.748 E.01144
G1 X136.606 Y115.176 E.69366
G1 X136.703 Y114.895 E.00956
G1 X136.895 Y114.693 E.00897
G1 X137.239 Y114.602 E.01145
G1 X162.455 Y114.602 E.81082
G1 X162.98 Y114.637 E.01694
G1 X163.133 Y114.73 E.00577
M204 S250
G1 X163.409 Y114.435 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.574 Y114.587 E.00669
G1 X163.74 Y114.898 E.0105
G1 X163.789 Y115.263 E.01097
G1 X163.79 Y136.682 E.63797
G1 X163.739 Y137.105 E.0127
G1 X163.598 Y137.382 E.00926
G3 X162.783 Y137.79 I-.858 J-.696 E.028
G1 X137.315 Y137.79 E.75858
G1 X136.895 Y137.739 E.0126
G1 X136.618 Y137.598 E.00927
G1 X136.425 Y137.413 E.00794
G1 X136.274 Y137.144 E.00921
G1 X136.21 Y136.783 E.01091
G1 X136.214 Y115.281 E.64046
G3 X136.819 Y114.299 I1.056 J-.027 E.03633
G1 X137.213 Y114.21 E.01204
G1 X162.71 Y114.21 E.75944
G1 X163.098 Y114.258 E.01166
G1 X163.348 Y114.378 E.00824
G1 X163.365 Y114.394 E.00071
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.574 Y114.587 E-.10818
G1 X163.74 Y114.898 E-.13399
G1 X163.789 Y115.263 E-.13991
G1 X163.789 Y116.258 E-.37793
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.661 Y118.985 Z1.8 F12000
G1 X116.391 Y134.391 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.223 J-103.837 E.04404
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.603 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.604 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.604 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.605 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.605 E.06212
; LINE_WIDTH: 0.43584
G1 X108.979 Y117.605 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.606 E.06204
; LINE_WIDTH: 0.43533
G1 X112.979 Y117.606 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.607 E.06196
; LINE_WIDTH: 0.43482
G1 X115.022 Y117.607 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.614 E.044
G2 X116.397 Y118.979 I102.704 J.19 E.04386
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67799
G1 X95.26 Y134.72 E.007
G1 X95.202 Y134.56 E.00547
G1 X95.202 Y117.463 E.54974
G1 X95.288 Y117.251 E.00738
G1 X95.452 Y117.202 E.0055
G1 X116.554 Y117.207 E.67857
G1 X116.715 Y117.258 E.0054
G1 X116.797 Y117.416 E.00573
G1 X116.798 Y134.537 E.55052
G1 X116.735 Y134.694 E.00545
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01027
G1 X94.955 Y134.981 E.00747
G3 X94.81 Y134.587 I.838 J-.532 E.0126
G1 X94.81 Y117.495 E.50909
G1 X94.868 Y117.155 E.01028
G3 X95.114 Y116.898 I.831 J.548 E.01065
G1 X95.417 Y116.81 E.0094
G1 X116.555 Y116.815 E.6296
G1 X116.883 Y116.886 E.01
G1 X117.059 Y117.036 E.0069
G3 X117.189 Y117.416 I-.937 J.533 E.01202
G1 X117.19 Y134.505 E.509
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.83 J-.547 E.00887
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14136
G1 X114.955 Y135.19 E-.61864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.356 Y134.469 Z1.8 F12000
G1 X96.117 Y133.403 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01912
; LINE_WIDTH: 0.44605
G1 X96.979 Y117.997 E.00543
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.997 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.998 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.998 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.998 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.998 E.06212
; LINE_WIDTH: 0.43584
G1 X108.979 Y117.998 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.998 E.06204
; LINE_WIDTH: 0.43533
G1 X112.979 Y117.998 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.998 E.06196
; LINE_WIDTH: 0.43482
G1 X115.021 Y117.998 E.00133
; LINE_WIDTH: 0.44999
G1 X115.722 Y118.282 E.02428
G1 X116.003 Y118.979 E.02416
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01125
G1 X96.979 Y118.398 E.00323
G1 X115.022 Y118.398 E.58019
G1 X115.433 Y118.569 E.01433
G1 X115.602 Y118.979 E.01425
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00564
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.846 I.021 J.24 E.00566
M73 P54 R9
G1 X115.21 Y118.979 E.00429
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z1.8 F12000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
M73 P54 R8
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z1.8 F12000
G1 X96.026 Y117.961 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17026
G1 X95.955 Y118.002 E-.29487
G1 X96.026 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.963 Z1.8 F12000
G1 X116.022 Y117.965 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y118.006 E.00241
G1 X116.022 Y118.046 E.00241
G1 X116.046 Y118.006 E.00139
; WIPE_START
G1 X116.022 Y118.046 E-.17026
G1 X115.952 Y118.006 E-.29487
G1 X116.022 Y117.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y125.598 Z1.8 F12000
G1 X116.021 Y133.957 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 8/40
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z1.8 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z1.8
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.37465
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01699
G1 X162.333 Y115.657 E.01229
G1 X161.976 Y115.379 E.01185
G1 X162.561 Y115.379 E.01532
; WIPE_START
G1 X162.621 Y116.027 E-.24739
G1 X162.333 Y115.657 E-.17822
G1 X161.976 Y115.379 E-.17189
G1 X162.403 Y115.379 E-.1625
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.484 Y123.011 Z2 F12000
G1 X162.621 Y135.974 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X162.621 Y136.621 E.01698
G1 X161.972 Y136.621 E.01702
G1 X162.244 Y136.415 E.00894
G1 X162.582 Y136.019 E.01366
; WIPE_START
G1 X162.621 Y136.621 E-.2292
G1 X161.972 Y136.621 E-.2466
G1 X162.244 Y136.415 E-.12958
G1 X162.508 Y136.106 E-.15461
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.878 Y136.266 Z2 F12000
G1 X138.023 Y136.618 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01687
G1 X137.378 Y135.971 E.01693
G1 X137.585 Y136.244 E.00896
G1 X137.978 Y136.579 E.0135
; WIPE_START
G1 X137.378 Y136.618 E-.22827
G1 X137.378 Y135.971 E-.24598
G1 X137.585 Y136.244 E-.13014
G1 X137.896 Y136.51 E-.15561
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.945 Y128.878 Z2 F12000
G1 X138.032 Y115.378 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.37271
G1 F6000
M204 S3000
G1 X137.665 Y115.657 E.01201
G1 X137.381 Y116.026 E.01212
G1 X137.381 Y115.378 E.01688
G1 X137.972 Y115.378 E.01538
; WIPE_START
G1 X137.665 Y115.657 E-.15762
G1 X137.381 Y116.026 E-.17686
G1 X137.381 Y115.378 E-.24626
G1 X137.853 Y115.378 E-.17926
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.485 Y115.423 Z2 F12000
G1 X161.425 Y115.519 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y115.577 E.00542
G1 X162.061 Y115.907 E.01866
G1 X162.333 Y116.26 E.01434
G1 X162.511 Y116.644 E.01361
G1 X162.603 Y117.199 E.0181
; LINE_WIDTH: 0.43693
G1 X162.603 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.603 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.603 Y134.8 E.17444
; LINE_WIDTH: 0.46173
G1 X162.569 Y135.195 E.01309
G1 X162.296 Y135.799 E.02193
; LINE_WIDTH: 0.44999
G1 X162.021 Y136.121 E.01362
G1 X161.74 Y136.333 E.01133
G1 X161.356 Y136.511 E.01361
G1 X160.801 Y136.603 E.0181
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.603 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.603 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.603 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.602 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.602 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.602 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.602 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.602 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.602 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.602 E.06208
; LINE_WIDTH: 0.43575
G1 X139.2 Y136.602 E.04968
; LINE_WIDTH: 0.45666
G3 X138.512 Y136.462 I-.059 J-1.469 E.02315
; LINE_WIDTH: 0.44999
G1 X138.202 Y136.296 E.01132
G1 X137.879 Y136.021 E.01362
G1 X137.667 Y135.74 E.01133
G1 X137.489 Y135.356 E.01361
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.45046
G1 X137.493 Y116.625 E.01773
G1 X137.655 Y116.275 E.0124
; LINE_WIDTH: 0.44999
G1 X137.93 Y115.912 E.01466
G1 X138.354 Y115.609 E.01674
G1 X138.693 Y115.473 E.01177
; LINE_WIDTH: 0.4495
G1 X139.199 Y115.397 E.01644
; LINE_WIDTH: 0.43731
G1 X160.801 Y115.397 E.67297
; LINE_WIDTH: 0.44901
G1 X161.258 Y115.457 E.01479
; LINE_WIDTH: 0.44999
G1 X161.369 Y115.498 E.0038
M204 S10000
G1 X161.318 Y115.922 F12000
G1 F6000
M204 S3000
G1 X161.627 Y116.074 E.01107
G3 X162.113 Y116.731 I-1.116 J1.334 E.02653
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.8 E.56597
G1 X162.163 Y135.123 E.01046
G1 X161.937 Y135.607 E.01716
G3 X161.269 Y136.113 I-1.313 J-1.04 E.02726
G1 X160.801 Y136.202 E.01532
G1 X139.199 Y136.202 E.6946
G1 X138.898 Y136.166 E.00978
G1 X138.393 Y135.937 E.01781
G3 X137.887 Y135.269 I1.039 J-1.313 E.02726
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.168 E.567
G1 X137.89 Y116.72 E.01468
G1 X137.984 Y116.515 E.00728
G1 X138.224 Y116.194 E.01286
G1 X138.573 Y115.952 E.01367
G1 X139.086 Y115.809 E.01712
G1 X139.199 Y115.798 E.00366
G1 X160.801 Y115.798 E.69461
G1 X161.186 Y115.858 E.01254
G1 X161.264 Y115.896 E.00278
M204 S250
G1 X161.154 Y116.261 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y116.267 E.00077
G1 X161.484 Y116.461 E.01077
G1 X161.73 Y116.815 E.01285
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.8 E.52426
G1 X161.757 Y135.112 E.00941
G1 X161.539 Y135.484 E.01284
G1 X161.184 Y135.73 E.01286
G1 X160.801 Y135.81 E.01168
G1 X139.2 Y135.81 E.64341
G1 X138.888 Y135.757 E.0094
G1 X138.516 Y135.539 E.01285
G1 X138.27 Y135.184 E.01286
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.168 E.52521
G1 X138.302 Y116.745 E.01301
G1 X138.541 Y116.438 E.0116
G1 X138.784 Y116.282 E.00861
G1 X139.199 Y116.19 E.01267
G1 X160.801 Y116.19 E.64342
G1 X161.095 Y116.249 E.00894
; WIPE_START
M204 S3000
G1 X161.179 Y116.267 E-.03268
G1 X161.484 Y116.461 E-.13734
G1 X161.73 Y116.815 E-.16392
G1 X161.81 Y117.199 E-.14903
G1 X161.81 Y117.928 E-.27703
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.941 Y115.09 Z2 F12000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.291 E.00667
; LINE_WIDTH: 0.45008
G2 X162.997 Y117.199 I87.807 J.649 E.06137
; LINE_WIDTH: 0.43693
G1 X162.997 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.997 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.997 Y134.8 E.17444
; LINE_WIDTH: 0.46173
G2 X162.991 Y135.972 I16.122 J.673 E.03878
; LINE_WIDTH: 0.44999
G1 X162.978 Y136.791 E.02631
G1 X162.904 Y136.938 E.0053
G1 X162.751 Y136.991 E.00519
G2 X160.801 Y136.997 I-.685 J92.48 E.06273
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.997 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.997 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.996 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.996 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.996 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.996 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.995 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.995 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.995 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.995 E.06208
; LINE_WIDTH: 0.43575
G1 X139.2 Y136.995 E.04968
; LINE_WIDTH: 0.44121
G1 X139.037 Y136.992 E.0051
; LINE_WIDTH: 0.44999
G2 X137.225 Y136.987 I-1.253 J135.316 E.05829
G1 X137.063 Y136.915 E.00569
G1 X137.009 Y136.722 E.00645
G2 X137.003 Y134.801 I-90.95 J-.671 E.06178
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.167 E.05072
; LINE_WIDTH: 0.45046
G2 X137.013 Y116.067 I-43.741 J-.836 E.03544
; LINE_WIDTH: 0.44999
G1 X137.013 Y115.225 E.02707
G1 X137.085 Y115.066 E.00561
G1 X137.268 Y115.009 E.00615
G1 X138.647 Y115.009 E.04435
; LINE_WIDTH: 0.4495
G1 X139.199 Y115.003 E.01773
; LINE_WIDTH: 0.43731
G1 X160.801 Y115.003 E.67297
; LINE_WIDTH: 0.44901
G1 X161.298 Y115.009 E.01594
; LINE_WIDTH: 0.44999
G3 X162.83 Y115.025 I.338 J39.634 E.04927
G1 X162.889 Y115.06 E.00219
M204 S10000
G1 X163.124 Y114.705 F12000
G1 F6000
M204 S3000
G1 X163.341 Y114.963 E.01086
G1 X163.397 Y115.291 E.0107
G1 X163.398 Y136.455 E.68053
G1 X163.355 Y136.996 E.01744
; object ids of layer 8 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer8 end: 47,58
M625
G3 X163.083 Y137.317 I-.565 J-.202 E.01383
G1 X162.771 Y137.398 E.01036
G1 X138.771 Y137.395 E.77173
G3 X137.102 Y137.377 I-.366 J-43.575 E.05367
G1 X136.813 Y137.247 E.01021
G1 X136.672 Y137.058 E.00758
G1 X136.602 Y136.754 E.01003
G1 X136.606 Y115.176 E.69384
G1 X136.703 Y114.895 E.00956
G1 X136.896 Y114.692 E.00901
G1 X137.24 Y114.602 E.01144
G1 X161.24 Y114.602 E.77173
G3 X162.819 Y114.611 I.393 J69.857 E.05077
G1 X163.066 Y114.687 E.00833
M204 S250
G1 X163.413 Y114.439 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.577 Y114.59 E.00665
G1 X163.711 Y114.819 E.00789
G1 X163.789 Y115.291 E.01428
G1 X163.79 Y136.688 E.63732
G1 X163.729 Y137.132 E.01334
G1 X163.55 Y137.441 E.01065
G1 X163.281 Y137.662 E.01038
G3 X162.79 Y137.79 I-.676 J-1.59 E.01515
G1 X137.297 Y137.786 E.75934
G3 X136.463 Y137.443 I.004 J-1.194 E.02756
G1 X136.261 Y137.108 E.01165
G1 X136.21 Y136.785 E.00974
G1 X136.214 Y115.283 E.64043
G3 X136.813 Y114.301 I1.058 J-.029 E.03624
G1 X137.213 Y114.21 E.01222
G1 X162.708 Y114.21 E.75938
G1 X163.107 Y114.261 E.01198
G1 X163.347 Y114.378 E.00796
G1 X163.369 Y114.398 E.00089
; OBJECT_ID: 47
; WIPE_START
M204 S3000
M73 P55 R8
G1 X163.577 Y114.59 E-.10763
G1 X163.711 Y114.819 E-.10063
G1 X163.789 Y115.291 E-.18212
G1 X163.789 Y116.264 E-.36962
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.66 Y118.99 Z2 F12000
G1 X116.391 Y134.391 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.223 J-103.836 E.04404
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.603 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.604 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.604 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.605 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.605 E.06212
; LINE_WIDTH: 0.43585
G1 X108.979 Y117.605 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.606 E.06204
; LINE_WIDTH: 0.43534
G1 X112.979 Y117.606 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.607 E.06196
; LINE_WIDTH: 0.43483
G1 X115.022 Y117.607 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.614 E.044
G2 X116.397 Y118.979 I102.706 J.19 E.04386
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.713 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00552
G1 X95.463 Y134.798 E.67799
G1 X95.26 Y134.719 E.00701
G1 X95.202 Y134.56 E.00546
G1 X95.202 Y117.463 E.54975
G1 X95.288 Y117.25 E.00738
G1 X95.452 Y117.202 E.00549
G1 X116.554 Y117.207 E.67857
G1 X116.706 Y117.255 E.00511
G1 X116.797 Y117.416 E.00595
G1 X116.798 Y134.537 E.55053
G1 X116.735 Y134.694 E.00544
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G1 X94.955 Y134.98 E.00748
G3 X94.81 Y134.587 I.838 J-.531 E.01258
G1 X94.81 Y117.495 E.50909
G1 X94.868 Y117.155 E.01027
G3 X95.114 Y116.898 I.832 J.549 E.01067
G1 X95.417 Y116.81 E.00938
G1 X116.554 Y116.815 E.62959
G1 X116.863 Y116.876 E.00936
G1 X117.06 Y117.038 E.0076
G3 X117.189 Y117.416 I-.895 J.518 E.01198
G1 X117.19 Y134.505 E.50901
G1 X117.132 Y134.845 E.01029
G3 X116.933 Y135.066 I-.828 J-.546 E.00887
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14137
G1 X114.955 Y135.19 E-.61863
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.357 Y134.46 Z2 F12000
G1 X96.104 Y133.379 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00676
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01912
; LINE_WIDTH: 0.44605
G1 X96.979 Y117.997 E.00543
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.997 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.998 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.998 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.998 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.998 E.06212
; LINE_WIDTH: 0.43585
G1 X108.979 Y117.998 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.998 E.06204
; LINE_WIDTH: 0.43534
G1 X112.979 Y117.998 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.998 E.06196
; LINE_WIDTH: 0.43483
G1 X115.021 Y117.998 E.00133
; LINE_WIDTH: 0.44999
G1 X115.722 Y118.282 E.02428
G1 X116.003 Y118.979 E.02416
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.132 Y133.432 E.01042
M204 S10000
G1 X96.448 Y133.202 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00291
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01125
G1 X96.979 Y118.398 E.00323
G1 X115.022 Y118.398 E.58019
G1 X115.433 Y118.569 E.01433
G1 X115.602 Y118.979 E.01425
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.476 Y133.255 E.0064
M204 S250
G1 X96.791 Y133.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y133.021 E.00009
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00564
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.846 I.021 J.24 E.00566
G1 X115.21 Y118.979 E.00429
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.814 Y133.08 E.00242
; WIPE_START
M204 S3000
G1 X96.79 Y133.021 E-.02394
G1 X96.79 Y131.084 E-.73606
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z2 F12000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z2 F12000
G1 X96.026 Y117.961 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17026
G1 X95.955 Y118.002 E-.29487
G1 X96.026 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.963 Z2 F12000
G1 X116.022 Y117.965 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.41858
G1 F6000
M204 S3000
G1 X115.952 Y118.006 E.00241
G1 X116.022 Y118.046 E.00241
G1 X116.046 Y118.006 E.00139
; WIPE_START
G1 X116.022 Y118.046 E-.17026
G1 X115.952 Y118.006 E-.29487
G1 X116.022 Y117.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y125.598 Z2 F12000
G1 X116.021 Y133.957 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 9/40
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z2 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.37463
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01699
G1 X162.416 Y115.756 E.0089
G1 X161.974 Y115.379 E.01523
G1 X162.561 Y115.379 E.01538
; WIPE_START
G1 X162.621 Y116.027 E-.24744
G1 X162.416 Y115.756 E-.12911
G1 X161.974 Y115.379 E-.22086
G1 X162.401 Y115.379 E-.16259
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.483 Y123.011 Z2.2 F12000
G1 X162.621 Y135.976 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.37496
G1 F6000
M204 S3000
G1 X162.621 Y136.621 E.01692
G1 X161.972 Y136.621 E.01702
G1 X162.343 Y136.333 E.01231
G1 X162.584 Y136.023 E.0103
; WIPE_START
G1 X162.621 Y136.621 E-.22765
G1 X161.972 Y136.621 E-.24657
G1 X162.343 Y136.333 E-.17838
G1 X162.517 Y136.11 E-.1074
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y136.268 Z2.2 F12000
G1 X138.02 Y136.618 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.37395
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01678
G1 X137.378 Y135.971 E.01693
G1 X137.666 Y136.341 E.01226
G1 X137.973 Y136.581 E.01019
; WIPE_START
G1 X137.378 Y136.618 E-.22635
G1 X137.378 Y135.971 E-.24602
G1 X137.666 Y136.341 E-.1781
G1 X137.893 Y136.519 E-.10952
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y128.886 Z2.2 F12000
G1 X138.029 Y115.378 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X137.659 Y115.666 E.01226
G1 X137.382 Y116.021 E.01178
G1 X137.382 Y115.378 E.0168
G1 X137.969 Y115.378 E.01536
; WIPE_START
G1 X137.659 Y115.666 E-.16072
G1 X137.382 Y116.021 E-.17115
G1 X137.382 Y115.378 E-.24411
G1 X137.866 Y115.378 E-.18403
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.498 Y115.418 Z2.2 F12000
G1 X161.376 Y115.5 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.45828
G1 F6000
M204 S3000
G1 X161.488 Y115.538 E.00389
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01132
G1 X162.121 Y115.979 E.01362
G1 X162.334 Y116.26 E.01133
; LINE_WIDTH: 0.45259
G1 X162.502 Y116.602 E.01232
G1 X162.6 Y117.126 E.01727
; LINE_WIDTH: 0.43859
G1 X162.6 Y119.126 E.06251
; LINE_WIDTH: 0.43844
G1 X162.601 Y121.126 E.06249
; LINE_WIDTH: 0.43829
G1 X162.601 Y123.126 E.06246
; LINE_WIDTH: 0.43814
G1 X162.601 Y125.126 E.06244
; LINE_WIDTH: 0.43799
G1 X162.602 Y127.126 E.06242
; LINE_WIDTH: 0.43784
G1 X162.602 Y129.126 E.06239
; LINE_WIDTH: 0.43769
G1 X162.602 Y131.126 E.06237
; LINE_WIDTH: 0.43754
G1 X162.603 Y133.126 E.06234
; LINE_WIDTH: 0.43739
G1 X162.603 Y134.8 E.05217
; LINE_WIDTH: 0.44897
G1 X162.543 Y135.258 E.01479
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01115
G1 X162.093 Y136.061 E.01867
G1 X161.741 Y136.333 E.01432
G1 X161.357 Y136.51 E.0136
G1 X160.801 Y136.603 E.01812
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.603 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.603 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.603 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.602 E.06222
; LINE_WIDTH: 0.4366
M73 P56 R8
G1 X150.801 Y136.602 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.602 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.602 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.602 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.602 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.602 E.06208
; LINE_WIDTH: 0.43575
G1 X139.199 Y136.602 E.04969
; LINE_WIDTH: 0.44856
G1 X138.742 Y136.542 E.01478
; LINE_WIDTH: 0.44999
G3 X138.167 Y136.277 I.448 J-1.725 E.02049
G3 X137.666 Y135.74 I1.098 J-1.526 E.02376
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.801 E.01809
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.44877
G1 X137.457 Y116.737 E.01394
; LINE_WIDTH: 0.44999
G1 X137.571 Y116.43 E.01053
G1 X137.908 Y115.938 E.01918
G1 X138.26 Y115.667 E.01427
G1 X138.643 Y115.49 E.01359
G1 X139.199 Y115.397 E.01812
; LINE_WIDTH: 0.43731
G1 X159.199 Y115.397 E.62308
; LINE_WIDTH: 0.4372
G1 X160.8 Y115.397 E.04987
; LINE_WIDTH: 0.45828
G3 X161.159 Y115.427 I.06 J1.456 E.01184
G1 X161.319 Y115.481 E.00555
M204 S10000
G1 X161.275 Y115.912 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01174
G3 X162.009 Y116.506 I-.807 J1.137 E.01937
G1 X162.179 Y116.977 E.01611
G1 X162.199 Y117.126 E.00484
G1 X162.202 Y134.801 E.56833
G1 X162.142 Y135.186 E.01255
G1 X161.926 Y135.627 E.0158
G3 X161.269 Y136.113 I-1.334 J-1.116 E.02652
G1 X160.801 Y136.202 E.01534
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01255
G1 X138.373 Y135.925 E.0158
G3 X137.887 Y135.268 I1.117 J-1.335 E.02653
G1 X137.798 Y134.801 E.01531
G1 X137.799 Y117.168 E.56699
G1 X137.856 Y116.814 E.01152
G1 X138.073 Y116.375 E.01573
G3 X138.731 Y115.887 I1.33 J1.104 E.0266
G1 X139.199 Y115.798 E.01533
G1 X160.8 Y115.798 E.6946
G1 X161.103 Y115.834 E.00979
G1 X161.22 Y115.887 E.00414
M204 S250
G1 X161.121 Y116.248 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.461 E.01254
G1 X161.728 Y116.808 E.01262
G1 X161.807 Y117.126 E.00978
G1 X161.81 Y134.801 E.52644
G1 X161.734 Y135.179 E.01151
G1 X161.539 Y135.484 E.01077
G1 X161.185 Y135.73 E.01284
G1 X160.801 Y135.81 E.01169
G1 X139.199 Y135.81 E.64341
G1 X138.82 Y135.733 E.01152
G1 X138.571 Y135.587 E.00861
G1 X138.304 Y135.258 E.01264
G1 X138.19 Y134.801 E.01403
G1 X138.191 Y117.168 E.52521
G1 X138.263 Y116.83 E.01029
G1 X138.462 Y116.516 E.01107
G1 X138.815 Y116.27 E.01282
G1 X139.199 Y116.19 E.01168
G1 X160.8 Y116.19 E.64341
G1 X161.063 Y116.235 E.00793
; WIPE_START
M204 S3000
G1 X161.484 Y116.461 E-.18171
G1 X161.728 Y116.808 E-.16102
G1 X161.807 Y117.126 E-.12474
G1 X161.807 Y117.896 E-.29254
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.949 Y115.104 Z2.2 F12000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.264 E.0053
G1 X162.99 Y115.687 E.01363
; LINE_WIDTH: 0.45259
G2 X162.996 Y117.126 I53.524 J.505 E.04656
; LINE_WIDTH: 0.43859
G1 X162.996 Y119.126 E.06251
; LINE_WIDTH: 0.43844
G1 X162.996 Y121.126 E.06249
; LINE_WIDTH: 0.43829
G1 X162.996 Y123.126 E.06246
; LINE_WIDTH: 0.43814
G1 X162.996 Y125.126 E.06244
; LINE_WIDTH: 0.43799
G1 X162.997 Y127.126 E.06242
; LINE_WIDTH: 0.43784
G1 X162.997 Y129.126 E.06239
; LINE_WIDTH: 0.43769
G1 X162.997 Y131.126 E.06237
; LINE_WIDTH: 0.43754
G1 X162.997 Y133.126 E.06234
; LINE_WIDTH: 0.43739
G1 X162.997 Y134.8 E.05217
; LINE_WIDTH: 0.44897
G1 X162.991 Y135.297 E.01594
; LINE_WIDTH: 0.44999
G3 X162.973 Y136.834 I-36.022 J.341 E.04943
G1 X162.88 Y136.96 E.00502
G1 X162.722 Y136.991 E.00518
G2 X160.801 Y136.997 I-.669 J91.248 E.06179
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.997 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.997 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.996 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.996 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.996 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.996 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.995 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.995 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.995 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.995 E.06208
; LINE_WIDTH: 0.43575
G1 X139.199 Y136.995 E.04969
; LINE_WIDTH: 0.44486
G1 X138.991 Y136.99 E.00663
; LINE_WIDTH: 0.44999
G2 X137.268 Y136.987 I-1.26 J245.147 E.05541
G1 X137.091 Y136.943 E.00586
G1 X137.009 Y136.751 E.00671
G2 X137.003 Y134.801 I-92.258 J-.687 E.06273
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.44677
G1 X137.011 Y116.942 E.0072
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.27 I-344.174 J-1.225 E.05377
G1 X137.051 Y115.104 E.00549
G1 X137.235 Y115.009 E.00665
G2 X139.199 Y115.003 I.679 J-94.273 E.06316
; LINE_WIDTH: 0.43731
G1 X159.199 Y115.003 E.62308
; LINE_WIDTH: 0.4372
G1 X160.8 Y115.003 E.04987
; LINE_WIDTH: 0.45828
G2 X161.973 Y115.009 I.685 J-18.025 E.03847
; LINE_WIDTH: 0.44999
G1 X162.802 Y115.018 E.02665
G1 X162.897 Y115.074 E.00356
M204 S10000
G1 X163.183 Y114.769 F12000
G1 F6000
M204 S3000
G1 X163.195 Y114.776 E.00044
G1 X163.364 Y115.023 E.00964
G1 X163.397 Y115.264 E.00781
G1 X163.398 Y136.754 E.69103
G1 X163.323 Y137.058 E.01009
; object ids of layer 9 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer9 end: 47,58
M625
G1 X163.11 Y137.303 E.01042
G1 X162.754 Y137.398 E.01186
G1 X137.267 Y137.394 E.81954
G1 X136.942 Y137.332 E.01065
G1 X136.7 Y137.113 E.0105
G1 X136.602 Y136.771 E.01143
G1 X136.606 Y115.182 E.69421
G1 X136.712 Y114.879 E.01032
G1 X136.934 Y114.675 E.00972
G1 X137.218 Y114.602 E.00941
G1 X161.218 Y114.602 E.77173
G3 X162.954 Y114.628 I.378 J32.615 E.05583
G1 X163.132 Y114.737 E.00672
M204 S250
G1 X163.395 Y114.424 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.6 Y114.621 E.00847
G1 X163.74 Y114.897 E.00921
G1 X163.789 Y115.264 E.01102
G1 X163.79 Y136.699 E.63847
G1 X163.739 Y137.105 E.01219
G1 X163.6 Y137.379 E.00915
G1 X163.335 Y137.63 E.01086
G1 X163.108 Y137.739 E.00752
G1 X162.785 Y137.79 E.00974
G1 X137.132 Y137.786 E.7641
G1 X136.783 Y137.695 E.01073
G1 X136.56 Y137.553 E.00789
G1 X136.359 Y137.317 E.00922
G3 X136.21 Y136.79 I1.574 J-.73 E.01637
G1 X136.214 Y115.267 E.64108
G1 X136.304 Y114.784 E.01464
G1 X136.466 Y114.54 E.00872
G1 X136.752 Y114.32 E.01076
G1 X137.206 Y114.21 E.01391
G1 X162.455 Y114.21 E.75205
G1 X163.066 Y114.248 E.01824
G1 X163.347 Y114.378 E.00922
G1 X163.352 Y114.383 E.0002
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.6 Y114.621 E-.13082
G1 X163.74 Y114.897 E-.11747
G1 X163.789 Y115.264 E-.14061
G1 X163.789 Y116.24 E-.3711
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.661 Y118.97 Z2.2 F12000
G1 X116.391 Y134.391 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.223 J-103.837 E.04404
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.603 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.604 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.604 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.605 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.605 E.06212
; LINE_WIDTH: 0.43584
G1 X108.979 Y117.605 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.606 E.06204
; LINE_WIDTH: 0.43533
G1 X112.979 Y117.606 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.607 E.06196
; LINE_WIDTH: 0.43482
G1 X115.022 Y117.607 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.614 E.044
G2 X116.397 Y118.979 I102.704 J.19 E.04386
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.715 Y134.742 F12000
G1 F6000
M204 S3000
G1 X116.559 Y134.798 E.00532
G1 X95.463 Y134.798 E.67835
G1 X95.251 Y134.712 E.00738
G1 X95.202 Y134.548 E.0055
G1 X95.202 Y117.464 E.54937
G1 X95.288 Y117.251 E.00738
G1 X95.452 Y117.202 E.00551
G1 X116.554 Y117.207 E.67856
G1 X116.706 Y117.254 E.00511
G1 X116.797 Y117.416 E.00596
G1 X116.798 Y134.537 E.55053
G1 X116.739 Y134.688 E.00523
M204 S250
G1 X116.85 Y135.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X116.586 Y135.19 I-.401 J-.907 E.0082
G1 X95.495 Y135.19 E.62822
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.547 J-.83 E.01066
G1 X94.81 Y134.583 E.00939
G1 X94.81 Y117.495 E.50897
G1 X94.868 Y117.155 E.01029
G3 X95.114 Y116.898 I.829 J.547 E.01064
G1 X95.417 Y116.81 E.00941
G1 X116.554 Y116.815 E.62959
G1 X116.863 Y116.876 E.00935
G1 X117.06 Y117.038 E.0076
G3 X117.189 Y117.416 I-.894 J.517 E.01198
G1 X117.19 Y134.505 E.50901
G1 X117.132 Y134.845 E.01028
G1 X116.98 Y135.045 E.00747
G3 X116.904 Y135.089 I-.532 J-.837 E.00262
; WIPE_START
M204 S3000
G1 X116.586 Y135.19 E-.12681
G1 X114.92 Y135.19 E-.6332
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.323 Y134.459 Z2.2 F12000
G1 X96.104 Y133.379 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00676
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01912
; LINE_WIDTH: 0.44605
G1 X96.979 Y117.997 E.00543
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.997 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.998 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.998 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.998 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.998 E.06212
; LINE_WIDTH: 0.43584
G1 X108.979 Y117.998 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.998 E.06204
; LINE_WIDTH: 0.43533
G1 X112.979 Y117.998 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.998 E.06196
; LINE_WIDTH: 0.43482
G1 X115.021 Y117.998 E.00133
; LINE_WIDTH: 0.44999
G1 X115.722 Y118.282 E.02428
G1 X116.003 Y118.979 E.02416
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.132 Y133.432 E.01042
M204 S10000
G1 X96.026 Y133.957 F12000
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
M204 S10000
G1 X96.448 Y133.202 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00291
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01125
G1 X96.979 Y118.398 E.00323
G1 X115.022 Y118.398 E.58019
G1 X115.433 Y118.569 E.01433
G1 X115.602 Y118.979 E.01425
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.476 Y133.255 E.0064
M204 S250
G1 X96.791 Y133.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y133.021 E.00009
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00564
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.846 I.021 J.24 E.00566
G1 X115.21 Y118.979 E.00429
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.814 Y133.08 E.00242
; WIPE_START
M204 S3000
G1 X96.79 Y133.021 E-.02394
G1 X96.79 Y131.084 E-.73606
; WIPE_END
M73 P57 R8
G1 E-.04 F1800
M204 S10000
G1 X96.346 Y123.465 Z2.2 F12000
G1 X96.026 Y117.961 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17026
G1 X95.955 Y118.002 E-.29487
G1 X96.026 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.963 Z2.2 F12000
G1 X116.022 Y117.965 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y118.006 E.00241
G1 X116.022 Y118.046 E.00241
G1 X116.046 Y118.006 E.00139
; WIPE_START
G1 X116.022 Y118.046 E-.17026
G1 X115.952 Y118.006 E-.29487
G1 X116.022 Y117.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y125.598 Z2.2 F12000
G1 X116.021 Y133.957 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 10/40
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
M106 S76.5
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z2.2 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z2.2
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.3746
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01698
G1 X162.333 Y115.657 E.01228
G1 X161.976 Y115.379 E.01185
G1 X162.561 Y115.379 E.01532
; WIPE_START
G1 X162.62 Y116.027 E-.24736
G1 X162.333 Y115.657 E-.17817
G1 X161.976 Y115.379 E-.17192
G1 X162.403 Y115.379 E-.16254
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.483 Y123.011 Z2.4 F12000
G1 X162.618 Y135.98 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01678
G1 X161.971 Y136.622 E.01693
G1 X162.341 Y136.334 E.01225
G1 X162.581 Y136.027 E.01019
; WIPE_START
G1 X162.618 Y136.622 E-.22627
G1 X161.971 Y136.622 E-.24596
G1 X162.341 Y136.334 E-.17808
G1 X162.519 Y136.107 E-.10969
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y136.266 Z2.4 F12000
G1 X138.02 Y136.618 Z2.4
G1 Z2
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01678
G1 X137.378 Y135.971 E.01693
G1 X137.666 Y136.341 E.01225
G1 X137.973 Y136.581 E.01019
; WIPE_START
G1 X137.378 Y136.618 E-.22628
G1 X137.378 Y135.971 E-.24596
G1 X137.666 Y136.341 E-.17807
G1 X137.893 Y136.519 E-.10968
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.944 Y128.887 Z2.4 F12000
G1 X138.034 Y115.378 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.37255
G1 F6000
M204 S3000
G1 X137.664 Y115.657 E.01207
G1 X137.381 Y116.025 E.01209
G1 X137.381 Y115.378 E.01687
G1 X137.974 Y115.378 E.01543
; WIPE_START
G1 X137.664 Y115.657 E-.15863
G1 X137.381 Y116.025 E-.17642
G1 X137.381 Y115.378 E-.24622
G1 X137.851 Y115.378 E-.17872
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.484 Y115.423 Z2.4 F12000
G1 X161.427 Y115.52 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y115.577 E.00536
G1 X162.061 Y115.907 E.01866
G1 X162.334 Y116.26 E.01435
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.0181
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.801 E.04968
; LINE_WIDTH: 0.44852
G1 X162.542 Y135.257 E.01476
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01114
G1 X162.092 Y136.062 E.01873
G1 X161.74 Y136.333 E.01428
G1 X161.356 Y136.511 E.01361
G1 X160.801 Y136.603 E.01811
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.603 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.603 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.603 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.602 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.602 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.602 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.602 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.602 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.602 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.602 E.06208
; LINE_WIDTH: 0.43575
G1 X139.199 Y136.602 E.04969
; LINE_WIDTH: 0.44856
G1 X138.743 Y136.543 E.01476
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01114
G1 X137.938 Y136.092 E.01874
G1 X137.667 Y135.74 E.01428
G1 X137.489 Y135.356 E.01361
G1 X137.397 Y134.801 E.01811
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.45046
G1 X137.493 Y116.625 E.01772
G1 X137.652 Y116.28 E.01223
; LINE_WIDTH: 0.44999
G1 X137.928 Y115.914 E.01474
G1 X138.348 Y115.613 E.01663
G1 X138.693 Y115.473 E.01197
; LINE_WIDTH: 0.44951
G1 X139.199 Y115.397 E.01645
; LINE_WIDTH: 0.43731
G1 X159.199 Y115.397 E.62308
; LINE_WIDTH: 0.43719
G1 X160.801 Y115.397 E.04988
; LINE_WIDTH: 0.44901
G1 X161.258 Y115.457 E.01479
; LINE_WIDTH: 0.44999
G1 X161.371 Y115.499 E.00386
M204 S10000
G1 X161.32 Y115.923 F12000
G1 F6000
M204 S3000
G1 X161.627 Y116.074 E.01102
G3 X162.113 Y116.731 I-1.116 J1.334 E.02653
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.186 E.01254
G1 X161.926 Y135.627 E.01579
G3 X161.269 Y136.113 I-1.335 J-1.117 E.02653
G1 X160.801 Y136.202 E.01533
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01253
G1 X138.373 Y135.926 E.01579
G3 X137.887 Y135.269 I1.117 J-1.335 E.02654
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.168 E.567
G1 X137.889 Y116.721 E.01467
G1 X137.982 Y116.518 E.00718
G1 X138.219 Y116.199 E.01277
G1 X138.569 Y115.954 E.01374
G1 X139.086 Y115.809 E.01725
G1 X139.199 Y115.798 E.00367
G1 X160.801 Y115.798 E.69461
G1 X161.186 Y115.858 E.01254
G1 X161.266 Y115.897 E.00284
M204 S250
G1 X161.156 Y116.262 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y116.267 E.00072
G1 X161.484 Y116.462 E.01077
G1 X161.73 Y116.816 E.01284
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.801 E.52427
G1 X161.734 Y135.179 E.0115
G1 X161.539 Y135.484 E.01077
G1 X161.185 Y135.73 E.01285
G1 X160.801 Y135.81 E.01168
G1 X139.199 Y135.81 E.64341
G1 X138.821 Y135.734 E.0115
G1 X138.516 Y135.539 E.01077
G1 X138.27 Y135.185 E.01285
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.168 E.52521
G1 X138.301 Y116.746 E.01298
G1 X138.532 Y116.446 E.01129
G1 X138.783 Y116.283 E.00891
G1 X139.199 Y116.19 E.01271
G1 X160.801 Y116.19 E.64342
G1 X161.097 Y116.25 E.00899
; WIPE_START
M204 S3000
G1 X161.179 Y116.267 E-.03203
G1 X161.484 Y116.462 E-.13744
G1 X161.73 Y116.816 E-.16386
G1 X161.81 Y117.199 E-.14898
G1 X161.81 Y117.93 E-.2777
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.933 Y115.083 Z2.4 F12000
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.264 E.00609
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I88.046 J.677 E.06226
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.801 E.04968
; LINE_WIDTH: 0.44457
G1 X162.99 Y135.009 E.00662
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.775 I237.549 J1.279 E.0568
G1 X162.915 Y136.937 E.00568
G1 X162.722 Y136.991 E.00645
G2 X160.801 Y136.997 I-.669 J91.19 E.06179
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.997 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.997 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.996 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.996 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.996 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.996 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.995 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.995 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.995 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.995 E.06208
; LINE_WIDTH: 0.43575
G1 X139.199 Y136.995 E.04969
; LINE_WIDTH: 0.44485
G1 X138.991 Y136.99 E.00662
; LINE_WIDTH: 0.44999
G2 X137.225 Y136.987 I-1.283 J250.182 E.0568
G1 X137.063 Y136.915 E.00568
G1 X137.009 Y136.722 E.00646
G2 X137.003 Y134.801 I-90.961 J-.671 E.06178
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.45244
G2 X137.013 Y116.075 I-17.592 J-.662 E.03536
; LINE_WIDTH: 0.44999
G1 X137.013 Y115.225 E.02733
G1 X137.085 Y115.066 E.00561
G1 X137.268 Y115.009 E.00615
G1 X138.647 Y115.009 E.04433
; LINE_WIDTH: 0.44951
G1 X139.199 Y115.003 E.01774
; LINE_WIDTH: 0.43731
G1 X159.199 Y115.003 E.62308
; LINE_WIDTH: 0.43719
G1 X160.801 Y115.003 E.04988
; LINE_WIDTH: 0.44901
G1 X161.298 Y115.009 E.01594
; LINE_WIDTH: 0.44999
G3 X162.762 Y115.012 I.196 J244.491 E.0471
G1 X162.878 Y115.06 E.00401
M204 S10000
G1 X163.192 Y114.768 F12000
G1 F6000
M204 S3000
G1 X163.365 Y115.028 E.01006
G1 X163.397 Y115.264 E.00764
G1 X163.394 Y135.264 E.64311
G3 X163.377 Y136.898 I-40.218 J.376 E.05254
G1 X163.247 Y137.187 E.0102
; object ids of layer 10 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer10 end: 47,58
M625
G1 X163.057 Y137.329 E.00762
G1 X162.754 Y137.398 E.00999
G1 X138.754 Y137.395 E.77173
G3 X137.102 Y137.377 I-.384 J-40.665 E.05311
G1 X136.813 Y137.247 E.01019
G1 X136.671 Y137.057 E.00764
G1 X136.602 Y136.754 E.00999
G1 X136.606 Y115.176 E.69384
G1 X136.703 Y114.895 E.00956
G1 X136.896 Y114.693 E.009
G1 X137.24 Y114.602 E.01146
G1 X161.24 Y114.602 E.77173
G3 X162.953 Y114.628 I.393 J30.585 E.0551
G1 X163.14 Y114.738 E.00696
M204 S250
G1 X163.395 Y114.422 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.574 Y114.587 E.00726
G1 X163.74 Y114.898 E.0105
G1 X163.789 Y115.264 E.01099
G1 X163.786 Y136.703 E.63859
G3 X163.442 Y137.538 I-1.192 J-.004 E.02758
G1 X163.108 Y137.739 E.01161
G1 X162.785 Y137.79 E.00974
G1 X137.297 Y137.786 E.75918
G3 X136.463 Y137.442 I.003 J-1.192 E.02758
G1 X136.261 Y137.108 E.01163
G1 X136.21 Y136.785 E.00974
G1 X136.214 Y115.283 E.64043
G3 X136.813 Y114.301 I1.058 J-.029 E.03624
G1 X137.213 Y114.21 E.01223
G1 X162.455 Y114.21 E.75184
G1 X163.066 Y114.248 E.01823
G1 X163.349 Y114.379 E.00929
G1 X163.351 Y114.381 E.0001
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.574 Y114.587 E-.11542
G1 X163.74 Y114.898 E-.1339
G1 X163.789 Y115.264 E-.14014
G1 X163.789 Y116.239 E-.37054
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.39 Y118.112 Z2.4 F12000
G1 X96.103 Y133.376 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44614
G1 X95.997 Y133.021 E.00543
; LINE_WIDTH: 0.43721
G1 X95.997 Y131.021 E.06229
; LINE_WIDTH: 0.43707
G1 X95.997 Y129.021 E.06227
; LINE_WIDTH: 0.43693
G1 X95.997 Y127.021 E.06225
; LINE_WIDTH: 0.43679
G1 X95.998 Y125.021 E.06223
; LINE_WIDTH: 0.43665
G1 X95.998 Y123.021 E.0622
; LINE_WIDTH: 0.43651
G1 X95.998 Y121.021 E.06218
; LINE_WIDTH: 0.43637
G1 X95.998 Y119.021 E.06216
; LINE_WIDTH: 0.43623
G1 X95.998 Y118.979 E.00133
; LINE_WIDTH: 0.44999
G1 X96.281 Y118.279 E.02426
G1 X96.808 Y118.008 E.01908
; LINE_WIDTH: 0.44605
G1 X96.979 Y117.997 E.00543
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.997 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.998 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.998 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.998 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.998 E.06212
; LINE_WIDTH: 0.43584
G1 X108.979 Y117.998 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.998 E.06204
; LINE_WIDTH: 0.43533
G1 X112.979 Y117.998 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.998 E.06196
; LINE_WIDTH: 0.43482
G1 X115.021 Y117.998 E.00133
; LINE_WIDTH: 0.44999
G1 X115.722 Y118.282 E.02428
G1 X116.003 Y118.979 E.02416
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.429 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00283
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.978 E.45156
G1 X96.568 Y118.568 E.01431
G1 X96.878 Y118.407 E.01123
M73 P58 R8
G1 X96.979 Y118.398 E.00323
G1 X115.022 Y118.398 E.58019
G1 X115.433 Y118.569 E.01433
G1 X115.602 Y118.979 E.01425
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.00429
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.846 I.021 J.24 E.00566
G1 X115.21 Y118.979 E.00429
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00564
G1 X96.813 Y133.077 E.00251
; WIPE_START
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X104.335 Y132.351 Z2.4 F12000
G1 X116.391 Y134.391 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-104.714 J-.21 E.04403
; LINE_WIDTH: 0.43721
G1 X95.603 Y131.021 E.06229
; LINE_WIDTH: 0.43707
G1 X95.603 Y129.021 E.06227
; LINE_WIDTH: 0.43693
G1 X95.604 Y127.021 E.06225
; LINE_WIDTH: 0.43679
G1 X95.604 Y125.021 E.06223
; LINE_WIDTH: 0.43665
G1 X95.604 Y123.021 E.0622
; LINE_WIDTH: 0.43651
G1 X95.604 Y121.021 E.06218
; LINE_WIDTH: 0.43637
G1 X95.604 Y119.021 E.06216
; LINE_WIDTH: 0.43623
G1 X95.604 Y118.978 E.00134
; LINE_WIDTH: 0.44999
G1 X95.612 Y117.609 E.04403
G2 X96.979 Y117.603 I.223 J-103.484 E.04396
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.603 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.604 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.604 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.605 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.605 E.06212
; LINE_WIDTH: 0.43584
G1 X108.979 Y117.605 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.606 E.06204
; LINE_WIDTH: 0.43533
G1 X112.979 Y117.606 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.607 E.06196
; LINE_WIDTH: 0.43482
G1 X115.022 Y117.607 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.614 E.044
G2 X116.397 Y118.979 I102.704 J.19 E.04386
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67799
G1 X95.251 Y134.712 E.00738
G1 X95.202 Y134.548 E.0055
G1 X95.204 Y117.414 E.55097
G1 X95.279 Y117.261 E.00546
G1 X95.439 Y117.202 E.00548
G1 X116.562 Y117.207 E.67922
G1 X116.718 Y117.265 E.00533
G1 X116.797 Y117.418 E.00554
G1 X116.798 Y134.537 E.55046
G1 X116.735 Y134.694 E.00545
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.549 J-.832 E.01065
G1 X94.81 Y134.583 E.0094
G1 X94.812 Y117.454 E.51021
G1 X94.866 Y117.158 E.00895
G1 X95.019 Y116.955 E.00757
G3 X95.413 Y116.81 I.55 J.886 E.01259
G1 X116.562 Y116.815 E.62995
G1 X116.879 Y116.885 E.00966
G1 X117.076 Y117.058 E.0078
G3 X117.189 Y117.418 I-.868 J.472 E.01132
G1 X117.19 Y134.505 E.50895
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.83 J-.547 E.00887
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14137
G1 X114.955 Y135.19 E-.61864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X115.427 Y127.572 Z2.4 F12000
G1 X116.022 Y117.965 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y118.006 E.00241
G1 X116.022 Y118.046 E.00241
G1 X116.046 Y118.006 E.00139
; WIPE_START
G1 X116.022 Y118.046 E-.17026
G1 X115.952 Y118.006 E-.29487
G1 X116.022 Y117.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y125.598 Z2.4 F12000
G1 X116.021 Y133.957 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; WIPE_START
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X108.389 Y133.957 Z2.4 F12000
G1 X96.026 Y133.957 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17026
G1 X95.955 Y133.998 E-.29487
G1 X96.026 Y133.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y126.324 Z2.4 F12000
G1 X96.027 Y117.961 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.42054
G1 F6000
M204 S3000
G1 X95.957 Y118.002 E.00244
G1 X96.027 Y118.043 E.00244
G1 X96.051 Y118.002 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X96.027 Y118.043 E-.17025
G1 X95.957 Y118.002 E-.29487
G1 X96.027 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 11/40
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z2.4 I.047 J1.216 P1  F12000
G1 X162.621 Y115.379 Z2.4
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.37462
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01699
G1 X162.416 Y115.756 E.0089
G1 X161.974 Y115.379 E.01523
G1 X162.561 Y115.379 E.01538
; WIPE_START
G1 X162.621 Y116.027 E-.24741
G1 X162.416 Y115.756 E-.12912
G1 X161.974 Y115.379 E-.22083
G1 X162.402 Y115.379 E-.16264
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.483 Y123.011 Z2.6 F12000
G1 X162.621 Y135.976 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.621 Y136.621 E.01693
G1 X161.972 Y136.621 E.01702
G1 X162.343 Y136.333 E.01232
G1 X162.584 Y136.023 E.0103
; WIPE_START
G1 X162.621 Y136.621 E-.22767
G1 X161.972 Y136.621 E-.24663
G1 X162.343 Y136.333 E-.17844
G1 X162.516 Y136.11 E-.10726
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y136.27 Z2.6 F12000
G1 X138.024 Y136.621 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01693
G1 X137.379 Y135.972 E.01702
G1 X137.667 Y136.343 E.01231
G1 X137.977 Y136.584 E.0103
; WIPE_START
G1 X137.379 Y136.621 E-.22771
G1 X137.379 Y135.972 E-.2466
G1 X137.667 Y136.343 E-.1784
G1 X137.89 Y136.517 E-.1073
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y128.884 Z2.6 F12000
G1 X138.035 Y115.378 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.37399
G1 F6000
M204 S3000
G1 X137.736 Y115.601 E.00975
G1 X137.382 Y116.021 E.01437
G1 X137.382 Y115.378 E.0168
G1 X137.975 Y115.378 E.01551
; WIPE_START
G1 X137.736 Y115.601 E-.12408
G1 X137.382 Y116.021 E-.20873
G1 X137.382 Y115.378 E-.24411
G1 X137.864 Y115.378 E-.18308
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.496 Y115.418 Z2.6 F12000
G1 X161.379 Y115.501 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.45821
G1 F6000
M204 S3000
G1 X161.488 Y115.538 E.00378
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01133
G1 X162.121 Y115.979 E.01362
G1 X162.333 Y116.26 E.01132
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.0181
; LINE_WIDTH: 0.43693
G1 X162.603 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.603 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.603 Y134.801 E.17445
; LINE_WIDTH: 0.44897
G1 X162.542 Y135.258 E.0148
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.584 E.01116
G1 X162.093 Y136.061 E.01865
G1 X161.74 Y136.333 E.01433
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.603 E.01811
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.603 E.67298
; LINE_WIDTH: 0.44904
G1 X138.742 Y136.543 E.01479
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01116
G1 X137.939 Y136.093 E.01867
G1 X137.666 Y135.74 E.01434
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.167 E.05072
; LINE_WIDTH: 0.44871
G1 X137.456 Y116.74 E.01383
; LINE_WIDTH: 0.44999
G1 X137.57 Y116.433 E.01052
G1 X137.908 Y115.938 E.01929
G3 X138.965 Y115.409 I1.442 J1.563 E.03849
; LINE_WIDTH: 0.4475
G1 X139.135 Y115.399 E.00545
; LINE_WIDTH: 0.43857
G1 X141.135 Y115.399 E.06251
; LINE_WIDTH: 0.43844
G1 X143.135 Y115.399 E.06249
; LINE_WIDTH: 0.43831
G1 X145.135 Y115.399 E.06247
; LINE_WIDTH: 0.43818
G1 X147.135 Y115.398 E.06245
; LINE_WIDTH: 0.43805
G1 X149.135 Y115.398 E.06242
; LINE_WIDTH: 0.43792
G1 X151.135 Y115.398 E.0624
; LINE_WIDTH: 0.43779
G1 X153.135 Y115.398 E.06238
; LINE_WIDTH: 0.43766
G1 X155.135 Y115.398 E.06236
; LINE_WIDTH: 0.43753
G1 X157.135 Y115.398 E.06234
; LINE_WIDTH: 0.4374
G1 X159.135 Y115.397 E.06232
; LINE_WIDTH: 0.43727
G1 X160.8 Y115.397 E.05187
; LINE_WIDTH: 0.45821
G3 X161.159 Y115.427 I.06 J1.456 E.01183
G1 X161.322 Y115.482 E.00566
M204 S10000
G1 X161.278 Y115.914 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01163
G3 X162.113 Y116.731 I-1.038 J1.312 E.02724
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.187 E.01256
G1 X161.925 Y135.627 E.01579
G3 X161.269 Y136.113 I-1.334 J-1.117 E.02651
M73 P59 R8
G1 X160.801 Y136.202 E.01532
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01255
G1 X138.373 Y135.926 E.0158
G3 X137.887 Y135.269 I1.117 J-1.334 E.02652
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.167 E.56701
G1 X137.855 Y116.817 E.01142
G1 X138.072 Y116.376 E.01579
G3 X138.67 Y115.909 I1.32 J1.071 E.02458
G1 X139.135 Y115.8 E.01538
G1 X160.8 Y115.798 E.69666
G1 X161.102 Y115.834 E.00978
G1 X161.223 Y115.889 E.00426
M204 S250
G1 X161.124 Y116.25 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.462 E.01244
G1 X161.73 Y116.815 E.01284
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.801 E.52426
G1 X161.733 Y135.18 E.01152
G1 X161.538 Y135.484 E.01076
G1 X161.185 Y135.73 E.01284
G1 X160.801 Y135.81 E.01168
G1 X139.199 Y135.81 E.64341
G1 X138.821 Y135.734 E.01151
G1 X138.516 Y135.538 E.01078
G1 X138.27 Y135.184 E.01284
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.167 E.52522
G1 X138.262 Y116.832 E.01021
G1 X138.459 Y116.518 E.01103
G1 X138.776 Y116.287 E.0117
G1 X139.135 Y116.193 E.01106
G1 X160.8 Y116.19 E.64531
G1 X161.066 Y116.235 E.00803
; WIPE_START
M204 S3000
G1 X161.484 Y116.462 E-.18045
G1 X161.73 Y116.815 E-.16386
G1 X161.81 Y117.199 E-.14901
G1 X161.81 Y117.901 E-.26668
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.938 Y115.089 Z2.6 F12000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.264 E.00584
; LINE_WIDTH: 0.45008
G2 X162.997 Y117.199 I89.09 J.663 E.06226
; LINE_WIDTH: 0.43693
G1 X162.997 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.997 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.997 Y134.801 E.17445
; LINE_WIDTH: 0.44897
G1 X162.991 Y135.298 E.01595
; LINE_WIDTH: 0.44999
G3 X162.987 Y136.744 I-167.457 J.254 E.04651
G1 X162.92 Y136.931 E.00639
G1 X162.722 Y136.991 E.00665
G2 X160.801 Y136.997 I-.657 J91.945 E.06178
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.997 E.67298
; LINE_WIDTH: 0.44904
G1 X138.703 Y136.991 E.01594
; LINE_WIDTH: 0.44999
G3 X137.184 Y136.976 I-.337 J-41.654 E.04884
G1 X137.048 Y136.89 E.00518
G1 X137.009 Y136.722 E.00555
G2 X137.003 Y134.801 I-90.893 J-.672 E.06179
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.167 E.05072
; LINE_WIDTH: 0.44666
G1 X137.011 Y116.943 E.00716
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.258 I-333.566 J-1.231 E.05419
G1 X137.064 Y115.084 E.00582
G1 X137.249 Y115.009 E.00641
G2 X139.135 Y115.003 I.62 J-107.15 E.06065
; LINE_WIDTH: 0.43857
G1 X141.135 Y115.003 E.06251
; LINE_WIDTH: 0.43844
G1 X143.135 Y115.003 E.06249
; LINE_WIDTH: 0.43831
G1 X145.135 Y115.003 E.06247
; LINE_WIDTH: 0.43818
G1 X147.135 Y115.003 E.06245
; LINE_WIDTH: 0.43805
G1 X149.135 Y115.003 E.06242
; LINE_WIDTH: 0.43792
G1 X151.135 Y115.003 E.0624
; LINE_WIDTH: 0.43779
G1 X153.135 Y115.003 E.06238
; LINE_WIDTH: 0.43766
G1 X155.135 Y115.003 E.06236
; LINE_WIDTH: 0.43753
G1 X157.135 Y115.003 E.06234
; LINE_WIDTH: 0.4374
G1 X159.135 Y115.003 E.06232
; LINE_WIDTH: 0.43727
G1 X160.8 Y115.003 E.05187
; LINE_WIDTH: 0.45821
G2 X161.973 Y115.009 I.685 J-18.069 E.03847
; LINE_WIDTH: 0.44999
G1 X162.759 Y115.013 E.02529
G1 X162.883 Y115.066 E.00432
M204 S10000
G1 X163.171 Y114.742 F12000
G1 F6000
M204 S3000
G1 X163.33 Y114.949 E.0084
G1 X163.397 Y115.264 E.01034
G1 X163.398 Y135.264 E.64311
M73 P59 R7
G3 X163.379 Y136.876 I-35.25 J.384 E.05187
; object ids of layer 11 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer11 end: 47,58
M625
G1 X163.288 Y137.134 E.00877
G1 X163.067 Y137.315 E.00919
G1 X162.754 Y137.398 E.01041
G1 X138.754 Y137.398 E.77173
G3 X137.12 Y137.378 I-.391 J-34.977 E.05254
G1 X136.858 Y137.28 E.00901
G1 X136.67 Y137.052 E.00953
G1 X136.602 Y136.754 E.00981
G1 X136.606 Y115.176 E.69384
G1 X136.701 Y114.897 E.00949
G1 X136.887 Y114.7 E.0087
G1 X137.229 Y114.602 E.01144
G1 X161.229 Y114.602 E.77173
G3 X162.861 Y114.617 I.372 J50.522 E.05247
G1 X163.115 Y114.72 E.00883
M204 S250
G1 X163.426 Y114.44 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.622 Y114.653 E.00862
G1 X163.74 Y114.894 E.008
G1 X163.789 Y115.264 E.01109
G1 X163.79 Y136.699 E.63847
G1 X163.739 Y137.107 E.01224
G3 X163.104 Y137.74 I-1.018 J-.386 E.02753
G1 X162.785 Y137.79 E.00961
G1 X137.301 Y137.79 E.75905
G1 X136.895 Y137.739 E.0122
G1 X136.621 Y137.6 E.00916
G1 X136.377 Y137.346 E.0105
G1 X136.261 Y137.107 E.00789
G1 X136.21 Y136.785 E.00973
G1 X136.214 Y115.258 E.64121
G1 X136.287 Y114.822 E.01315
G1 X136.449 Y114.559 E.00921
G1 X136.683 Y114.359 E.00915
G3 X137.21 Y114.21 I.737 J1.599 E.01639
G1 X162.455 Y114.21 E.75194
G1 X163.088 Y114.256 E.01893
G1 X163.377 Y114.407 E.0097
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.622 Y114.653 E-.13194
G1 X163.74 Y114.894 E-.1021
G1 X163.789 Y115.264 E-.14149
G1 X163.789 Y116.275 E-.38447
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.389 Y118.145 Z2.6 F12000
G1 X96.103 Y133.376 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01912
; LINE_WIDTH: 0.44605
G1 X96.979 Y117.997 E.00543
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.997 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.998 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.998 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.998 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.998 E.06212
; LINE_WIDTH: 0.43584
G1 X108.979 Y117.998 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.998 E.06204
; LINE_WIDTH: 0.43533
G1 X112.979 Y117.998 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.998 E.06196
; LINE_WIDTH: 0.43482
G1 X115.021 Y117.998 E.00133
; LINE_WIDTH: 0.44999
G1 X115.722 Y118.282 E.02428
G1 X116.003 Y118.979 E.02416
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.43 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00282
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01125
G1 X96.979 Y118.398 E.00323
G1 X115.022 Y118.398 E.58019
G1 X115.433 Y118.569 E.01433
G1 X115.602 Y118.979 E.01425
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00564
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.846 I.021 J.24 E.00566
G1 X115.21 Y118.979 E.00429
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.813 Y133.077 E.00251
; WIPE_START
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X104.335 Y132.351 Z2.6 F12000
G1 X116.391 Y134.391 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.223 J-103.837 E.04404
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.603 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.604 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.604 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.605 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.605 E.06212
; LINE_WIDTH: 0.43584
G1 X108.979 Y117.605 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.606 E.06204
; LINE_WIDTH: 0.43533
G1 X112.979 Y117.606 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.607 E.06196
; LINE_WIDTH: 0.43482
G1 X115.022 Y117.607 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.614 E.044
G2 X116.397 Y118.979 I102.704 J.19 E.04386
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67799
G1 X95.26 Y134.72 E.00701
G1 X95.202 Y134.56 E.00546
G1 X95.202 Y117.463 E.54974
G1 X95.281 Y117.26 E.00701
G1 X95.44 Y117.202 E.00546
G1 X116.562 Y117.207 E.6792
G1 X116.739 Y117.273 E.00606
G1 X116.797 Y117.441 E.00572
G1 X116.798 Y134.537 E.54971
G1 X116.735 Y134.694 E.00544
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G1 X94.955 Y134.98 E.00748
G3 X94.81 Y134.587 I.838 J-.532 E.01259
G1 X94.81 Y117.495 E.50909
G1 X94.868 Y117.155 E.01028
G1 X95.02 Y116.955 E.00748
G3 X95.413 Y116.81 I.531 J.838 E.01258
G1 X116.562 Y116.815 E.62994
G1 X116.792 Y116.858 E.00697
G1 X117.045 Y117.017 E.00889
G3 X117.189 Y117.441 I-.461 J.394 E.01367
G1 X117.19 Y134.505 E.50825
G1 X117.132 Y134.845 E.01027
G3 X116.933 Y135.066 I-.831 J-.548 E.00888
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14132
G1 X114.955 Y135.19 E-.61868
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X115.427 Y127.572 Z2.6 F12000
G1 X116.022 Y117.965 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y118.006 E.00241
G1 X116.022 Y118.046 E.00241
G1 X116.046 Y118.006 E.00139
; WIPE_START
G1 X116.022 Y118.046 E-.17026
G1 X115.952 Y118.006 E-.29487
G1 X116.022 Y117.965 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y125.598 Z2.6 F12000
G1 X116.021 Y133.957 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; WIPE_START
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X108.389 Y133.957 Z2.6 F12000
G1 X96.026 Y133.957 Z2.6
M73 P60 R7
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z2.6 F12000
G1 X96.026 Y117.961 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X96.026 Y118.043 E-.17026
G1 X95.955 Y118.002 E-.29487
G1 X96.026 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 12/40
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z2.6 I.047 J1.216 P1  F12000
G1 X162.621 Y115.379 Z2.6
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.37461
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01698
G1 X162.415 Y115.756 E.0089
G1 X161.974 Y115.379 E.01522
G1 X162.561 Y115.379 E.01538
; WIPE_START
G1 X162.62 Y116.027 E-.24733
G1 X162.415 Y115.756 E-.12911
G1 X161.974 Y115.379 E-.22075
G1 X162.402 Y115.379 E-.16282
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.482 Y123.011 Z2.8 F12000
G1 X162.618 Y135.98 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01678
G1 X161.971 Y136.622 E.01693
G1 X162.341 Y136.334 E.01225
G1 X162.581 Y136.027 E.01019
; WIPE_START
G1 X162.618 Y136.622 E-.22629
G1 X161.971 Y136.622 E-.24597
G1 X162.341 Y136.334 E-.17808
G1 X162.519 Y136.107 E-.10967
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y136.266 Z2.8 F12000
G1 X138.02 Y136.618 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.37394
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01678
G1 X137.378 Y135.971 E.01693
G1 X137.666 Y136.341 E.01225
G1 X137.973 Y136.581 E.0102
; WIPE_START
G1 X137.378 Y136.618 E-.22639
G1 X137.378 Y135.971 E-.24599
G1 X137.666 Y136.341 E-.17807
G1 X137.893 Y136.519 E-.10955
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.943 Y128.886 Z2.8 F12000
G1 X138.031 Y115.378 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.744 Y115.594 E.00938
G1 X137.382 Y116.021 E.01466
G1 X137.382 Y115.378 E.01682
G1 X137.971 Y115.378 E.01541
; WIPE_START
G1 X137.744 Y115.594 E-.1189
G1 X137.382 Y116.021 E-.21307
G1 X137.382 Y115.378 E-.2444
G1 X137.865 Y115.378 E-.18363
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.497 Y115.418 Z2.8 F12000
G1 X161.381 Y115.502 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.45821
G1 F6000
M204 S3000
G1 X161.488 Y115.538 E.00372
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01132
G1 X162.121 Y115.979 E.01362
G1 X162.334 Y116.26 E.01133
G1 X162.511 Y116.644 E.01361
G1 X162.603 Y117.199 E.01809
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.801 E.04969
; LINE_WIDTH: 0.44857
G1 X162.542 Y135.258 E.01478
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.584 E.01115
G1 X162.092 Y136.062 E.0187
G1 X161.74 Y136.333 E.01428
G1 X161.356 Y136.511 E.01361
G1 X160.801 Y136.603 E.01811
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.603 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.603 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.603 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.602 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.602 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.602 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.602 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.602 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.602 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.602 E.06208
; LINE_WIDTH: 0.43575
G1 X139.199 Y136.602 E.04968
; LINE_WIDTH: 0.44856
G1 X138.743 Y136.542 E.01476
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01116
G1 X137.938 Y136.092 E.01873
G1 X137.666 Y135.74 E.01428
G1 X137.489 Y135.356 E.01359
G1 X137.397 Y134.801 E.01811
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.167 E.05072
; LINE_WIDTH: 0.44792
G1 X137.448 Y116.772 E.01275
; LINE_WIDTH: 0.44999
G3 X138.233 Y115.682 I1.787 J.46 E.04422
G3 X138.965 Y115.409 I1.006 J1.583 E.02529
; LINE_WIDTH: 0.44751
G1 X139.135 Y115.399 E.00545
; LINE_WIDTH: 0.43858
G1 X141.135 Y115.399 E.06251
; LINE_WIDTH: 0.43844
G1 X143.135 Y115.399 E.06249
; LINE_WIDTH: 0.43831
G1 X145.135 Y115.399 E.06247
; LINE_WIDTH: 0.43818
G1 X147.135 Y115.398 E.06245
; LINE_WIDTH: 0.43805
G1 X149.135 Y115.398 E.06242
; LINE_WIDTH: 0.43792
G1 X151.135 Y115.398 E.0624
; LINE_WIDTH: 0.43779
G1 X153.135 Y115.398 E.06238
; LINE_WIDTH: 0.43766
G1 X155.135 Y115.398 E.06236
; LINE_WIDTH: 0.43753
G1 X157.135 Y115.398 E.06234
; LINE_WIDTH: 0.4374
G1 X159.135 Y115.397 E.06232
; LINE_WIDTH: 0.43726
G1 X160.8 Y115.397 E.05187
; LINE_WIDTH: 0.45821
G3 X161.159 Y115.427 I.06 J1.456 E.01183
G1 X161.324 Y115.483 E.00572
M204 S10000
G1 X161.279 Y115.914 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01157
G3 X162.113 Y116.732 I-1.039 J1.313 E.02725
G1 X162.202 Y117.199 E.01531
G1 X162.202 Y134.801 E.56599
G1 X162.142 Y135.187 E.01255
G1 X161.926 Y135.627 E.01578
G3 X161.269 Y136.113 I-1.335 J-1.117 E.02653
G1 X160.801 Y136.202 E.01532
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01254
G1 X138.373 Y135.925 E.01582
G3 X137.887 Y135.269 I1.115 J-1.333 E.02651
G1 X137.798 Y134.801 E.01533
G1 X137.799 Y117.167 E.56701
G1 X137.847 Y116.843 E.01053
G1 X138.069 Y116.382 E.01645
G3 X138.483 Y116.004 I1.14 J.83 E.01815
G1 X138.685 Y115.903 E.00726
G1 X139.135 Y115.8 E.01486
G1 X160.8 Y115.798 E.69666
G1 X161.102 Y115.834 E.00978
G1 X161.225 Y115.89 E.00432
M204 S250
G1 X161.125 Y116.251 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.461 E.01238
G1 X161.73 Y116.816 E.01285
G1 X161.81 Y117.199 E.01167
G1 X161.81 Y134.801 E.52427
G1 X161.733 Y135.18 E.01151
G1 X161.539 Y135.484 E.01076
G1 X161.185 Y135.73 E.01285
G1 X160.801 Y135.81 E.01168
G1 X139.199 Y135.81 E.64341
G1 X138.821 Y135.734 E.0115
G1 X138.516 Y135.538 E.01079
G1 X138.27 Y135.185 E.01283
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.167 E.52522
G1 X138.254 Y116.854 E.00954
G1 X138.46 Y116.517 E.01174
G1 X138.723 Y116.314 E.0099
G1 X139.135 Y116.193 E.01281
G1 X160.8 Y116.19 E.64531
G1 X161.068 Y116.236 E.00809
; WIPE_START
M204 S3000
G1 X161.484 Y116.461 E-.17972
G1 X161.73 Y116.816 E-.16399
G1 X161.81 Y117.199 E-.14894
G1 X161.81 Y117.903 E-.26735
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.923 Y115.069 Z2.8 F12000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.278 E.00705
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I87.367 J.67 E.06181
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.801 E.04969
; LINE_WIDTH: 0.44488
G1 X162.99 Y135.01 E.00664
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.738 I245.765 J1.259 E.05555
G1 X162.94 Y136.912 E.00581
G1 X162.751 Y136.991 E.00659
G2 X160.801 Y136.997 I-.683 J92.645 E.06273
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.997 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.997 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.996 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.996 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.996 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.996 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.995 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.995 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.995 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.995 E.06208
; LINE_WIDTH: 0.43575
G1 X139.199 Y136.995 E.04968
; LINE_WIDTH: 0.44485
G1 X138.991 Y136.99 E.00662
; LINE_WIDTH: 0.44999
G2 X137.234 Y136.987 I-1.278 J249.126 E.05648
G1 X137.065 Y136.913 E.00596
G1 X137.009 Y136.742 E.00579
G2 X137.003 Y134.801 I-91.89 J-.682 E.06242
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.167 E.05072
; LINE_WIDTH: 0.44525
G1 X137.01 Y116.958 E.00665
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.253 I-229.191 J-1.21 E.05482
G1 X137.065 Y115.089 E.00556
G1 X137.239 Y115.009 E.00616
G2 X139.135 Y115.003 I.636 J-103.837 E.06098
; LINE_WIDTH: 0.43858
G1 X141.135 Y115.003 E.06251
; LINE_WIDTH: 0.43844
G1 X143.135 Y115.003 E.06249
; LINE_WIDTH: 0.43831
G1 X145.135 Y115.003 E.06247
; LINE_WIDTH: 0.43818
G1 X147.135 Y115.003 E.06245
; LINE_WIDTH: 0.43805
G1 X149.135 Y115.003 E.06242
; LINE_WIDTH: 0.43792
G1 X151.135 Y115.003 E.0624
; LINE_WIDTH: 0.43779
G1 X153.135 Y115.003 E.06238
; LINE_WIDTH: 0.43766
G1 X155.135 Y115.003 E.06236
; LINE_WIDTH: 0.43753
G1 X157.135 Y115.003 E.06234
; LINE_WIDTH: 0.4374
G1 X159.135 Y115.003 E.06232
; LINE_WIDTH: 0.43726
G1 X160.8 Y115.003 E.05187
; LINE_WIDTH: 0.44274
G1 X160.963 Y115.006 E.00513
; LINE_WIDTH: 0.44999
G2 X162.722 Y115.009 I1.211 J-159.886 E.05656
G1 X162.866 Y115.052 E.00482
M204 S10000
G1 X163.186 Y114.758 F12000
G1 F6000
M204 S3000
G1 X163.355 Y115.001 E.00953
G1 X163.397 Y115.278 E.009
G1 X163.394 Y136.82 E.6927
G1 X163.294 Y137.115 E.01001
; object ids of layer 12 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer12 end: 47,58
M625
G1 X163.113 Y137.3 E.00833
G1 X162.771 Y137.398 E.01143
G1 X137.27 Y137.394 E.82001
G1 X136.942 Y137.332 E.01073
G1 X136.696 Y137.109 E.01067
G1 X136.602 Y136.766 E.01144
G1 X136.606 Y115.176 E.69422
G1 X136.704 Y114.897 E.00952
G1 X136.94 Y114.671 E.01049
G1 X137.223 Y114.602 E.00938
G1 X161.223 Y114.602 E.77173
G3 X162.953 Y114.628 I.374 J32.88 E.05565
G1 X163.133 Y114.729 E.00663
M204 S250
G1 X163.397 Y114.421 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.548 Y114.556 E.00602
G1 X163.727 Y114.86 E.0105
G1 X163.789 Y115.278 E.01259
G1 X163.786 Y136.738 E.6392
G1 X163.702 Y137.202 E.01406
G1 X163.552 Y137.44 E.00839
G1 X163.317 Y137.641 E.00919
G3 X162.79 Y137.79 I-.731 J-1.578 E.01638
G1 X137.132 Y137.786 E.76426
G1 X136.783 Y137.695 E.01074
G1 X136.56 Y137.553 E.00789
G1 X136.358 Y137.316 E.00926
G3 X136.21 Y136.789 I1.424 J-.684 E.0164
G1 X136.214 Y115.253 E.64145
G1 X136.287 Y114.823 E.01299
G1 X136.464 Y114.542 E.00991
G1 X136.754 Y114.319 E.01088
G1 X137.208 Y114.21 E.0139
G1 X162.455 Y114.21 E.752
G1 X163.066 Y114.248 E.01824
G1 X163.35 Y114.38 E.00934
G1 X163.353 Y114.381 E.00008
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.548 Y114.556 E-.09961
G1 X163.727 Y114.86 E-.13398
G1 X163.789 Y115.278 E-.16062
G1 X163.789 Y116.24 E-.3658
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.661 Y118.97 Z2.8 F12000
G1 X116.391 Y134.391 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.223 J-103.837 E.04404
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.603 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.604 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.604 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.605 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.605 E.06212
; LINE_WIDTH: 0.43584
G1 X108.979 Y117.605 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.606 E.06204
; LINE_WIDTH: 0.43533
G1 X112.979 Y117.606 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.607 E.06196
; LINE_WIDTH: 0.43482
G1 X115.022 Y117.607 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.614 E.044
G2 X116.397 Y118.979 I102.704 J.19 E.04386
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.713 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00552
G1 X95.463 Y134.798 E.67799
G1 X95.26 Y134.719 E.00702
G1 X95.202 Y134.56 E.00546
G1 X95.202 Y117.463 E.54974
G1 X95.279 Y117.262 E.00695
G1 X95.439 Y117.202 E.00548
G1 X116.573 Y117.207 E.67957
G1 X116.742 Y117.279 E.0059
G1 X116.797 Y117.442 E.00553
G1 X116.798 Y134.537 E.5497
G1 X116.735 Y134.694 E.00544
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01027
G1 X94.955 Y134.98 E.00749
G3 X94.81 Y134.587 I.837 J-.531 E.01258
G1 X94.81 Y117.495 E.50909
G1 X94.868 Y117.155 E.01028
G1 X95.019 Y116.955 E.00745
G3 X95.413 Y116.81 I.543 J.863 E.0126
G1 X116.563 Y116.815 E.62997
G1 X116.864 Y116.876 E.00915
G3 X117.189 Y117.442 I-.345 J.574 E.02028
G1 X117.19 Y134.505 E.50824
M73 P61 R7
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.829 J-.547 E.00887
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14141
G1 X114.955 Y135.19 E-.61859
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.357 Y134.459 Z2.8 F12000
G1 X96.103 Y133.376 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01912
; LINE_WIDTH: 0.44605
G1 X96.979 Y117.997 E.00543
; LINE_WIDTH: 0.43712
G1 X98.979 Y117.997 E.06228
; LINE_WIDTH: 0.43686
G1 X100.979 Y117.998 E.06224
; LINE_WIDTH: 0.43661
G1 X102.979 Y117.998 E.0622
; LINE_WIDTH: 0.43635
G1 X104.979 Y117.998 E.06216
; LINE_WIDTH: 0.4361
G1 X106.979 Y117.998 E.06212
; LINE_WIDTH: 0.43584
G1 X108.979 Y117.998 E.06208
; LINE_WIDTH: 0.43559
G1 X110.979 Y117.998 E.06204
; LINE_WIDTH: 0.43533
G1 X112.979 Y117.998 E.062
; LINE_WIDTH: 0.43508
G1 X114.979 Y117.998 E.06196
; LINE_WIDTH: 0.43482
G1 X115.021 Y117.998 E.00133
; LINE_WIDTH: 0.44999
G1 X115.722 Y118.282 E.02428
G1 X116.003 Y118.979 E.02416
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.43 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00282
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01125
G1 X96.979 Y118.398 E.00323
G1 X115.022 Y118.398 E.58019
G1 X115.433 Y118.569 E.01433
G1 X115.602 Y118.979 E.01425
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00564
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.846 I.021 J.24 E.00566
G1 X115.21 Y118.979 E.00429
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.813 Y133.077 E.00251
; WIPE_START
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.354 Y123.458 Z2.8 F12000
G1 X96.026 Y117.961 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.4219
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17026
G1 X95.955 Y118.002 E-.29487
G1 X96.026 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y125.594 Z2.8 F12000
G1 X96.026 Y133.957 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y133.957 Z2.8 F12000
G1 X116.021 Y133.957 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; WIPE_START
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.022 Y126.324 Z2.8 F12000
G1 X116.022 Y117.965 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.41856
G1 F6000
M204 S3000
G1 X115.952 Y118.006 E.00241
G1 X116.022 Y118.046 E.00241
G1 X116.046 Y118.006 E.00139
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.022 Y118.046 E-.17026
G1 X115.952 Y118.006 E-.29487
G1 X116.022 Y117.965 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 13/40
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
M106 S79.05
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z2.8 I.067 J1.215 P1  F12000
G1 X162.621 Y115.379 Z2.8
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.37459
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01698
G1 X162.415 Y115.756 E.00891
G1 X161.974 Y115.379 E.01521
G1 X162.561 Y115.379 E.01538
; WIPE_START
G1 X162.62 Y116.027 E-.24733
G1 X162.415 Y115.756 E-.1292
G1 X161.974 Y115.379 E-.22064
G1 X162.402 Y115.379 E-.16283
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.482 Y123.011 Z3 F12000
G1 X162.618 Y135.98 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.37395
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01678
G1 X161.971 Y136.622 E.01693
G1 X162.341 Y136.334 E.01226
G1 X162.581 Y136.027 E.01019
; WIPE_START
G1 X162.618 Y136.622 E-.22631
G1 X161.971 Y136.622 E-.24602
G1 X162.341 Y136.334 E-.1781
G1 X162.519 Y136.107 E-.10957
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y136.266 Z3 F12000
G1 X138.02 Y136.618 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01678
G1 X137.378 Y135.971 E.01693
G1 X137.666 Y136.341 E.01226
G1 X137.973 Y136.581 E.01019
; WIPE_START
G1 X137.378 Y136.618 E-.22635
G1 X137.378 Y135.971 E-.24601
G1 X137.666 Y136.341 E-.1781
G1 X137.893 Y136.519 E-.10954
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.944 Y128.886 Z3 F12000
G1 X138.034 Y115.378 Z3
G1 Z2.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.736 Y115.6 E.00973
G1 X137.382 Y116.021 E.01439
G1 X137.382 Y115.378 E.01682
G1 X137.974 Y115.378 E.01549
; WIPE_START
G1 X137.736 Y115.6 E-.12382
G1 X137.382 Y116.021 E-.20909
G1 X137.382 Y115.378 E-.24444
G1 X137.862 Y115.378 E-.18265
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.495 Y115.419 Z3 F12000
G1 X161.382 Y115.502 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.45822
G1 F6000
M204 S3000
G1 X161.488 Y115.538 E.00367
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01132
G1 X162.121 Y115.979 E.01362
G1 X162.333 Y116.26 E.01133
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.01811
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.801 E.04968
; LINE_WIDTH: 0.44852
G1 X162.542 Y135.258 E.01477
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.584 E.01116
G1 X162.092 Y136.062 E.01871
G1 X161.74 Y136.334 E.01429
G1 X161.404 Y136.499 E.01205
G1 X160.883 Y136.599 E.01704
; LINE_WIDTH: 0.43936
G1 X158.883 Y136.6 E.06263
; LINE_WIDTH: 0.43901
G1 X156.883 Y136.6 E.06258
; LINE_WIDTH: 0.43867
G1 X154.883 Y136.6 E.06252
; LINE_WIDTH: 0.43833
G1 X152.883 Y136.6 E.06247
; LINE_WIDTH: 0.43799
G1 X150.883 Y136.601 E.06242
; LINE_WIDTH: 0.43764
G1 X148.883 Y136.601 E.06236
; LINE_WIDTH: 0.4373
G1 X146.883 Y136.601 E.06231
; LINE_WIDTH: 0.43696
G1 X144.883 Y136.601 E.06225
; LINE_WIDTH: 0.43662
G1 X142.883 Y136.602 E.0622
; LINE_WIDTH: 0.43628
G1 X140.883 Y136.602 E.06215
; LINE_WIDTH: 0.43593
G1 X139.2 Y136.602 E.05227
; LINE_WIDTH: 0.44857
G1 X138.742 Y136.542 E.01478
; LINE_WIDTH: 0.44999
G1 X138.416 Y136.423 E.01116
G1 X137.938 Y136.092 E.01871
G1 X137.666 Y135.74 E.01429
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.801 E.01811
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.44791
G1 X137.448 Y116.772 E.01275
; LINE_WIDTH: 0.44999
G3 X138.946 Y115.411 I1.787 J.462 E.06891
; LINE_WIDTH: 0.44842
G1 X139.117 Y115.4 E.00547
; LINE_WIDTH: 0.43949
G1 X141.117 Y115.4 E.06265
; LINE_WIDTH: 0.43927
G1 X143.117 Y115.4 E.06262
; LINE_WIDTH: 0.43905
G1 X145.117 Y115.4 E.06258
; LINE_WIDTH: 0.43883
G1 X147.117 Y115.399 E.06255
; LINE_WIDTH: 0.43862
G1 X149.117 Y115.399 E.06251
; LINE_WIDTH: 0.4384
G1 X151.117 Y115.399 E.06248
; LINE_WIDTH: 0.43818
G1 X153.117 Y115.398 E.06245
; LINE_WIDTH: 0.43797
G1 X155.117 Y115.398 E.06241
; LINE_WIDTH: 0.43775
G1 X157.117 Y115.398 E.06238
; LINE_WIDTH: 0.43753
G1 X159.117 Y115.398 E.06234
; LINE_WIDTH: 0.43732
G1 X160.8 Y115.397 E.05245
; LINE_WIDTH: 0.45822
G3 X161.159 Y115.427 I.06 J1.456 E.01184
G1 X161.326 Y115.483 E.00577
M204 S10000
G1 X161.281 Y115.915 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01151
G3 X162.113 Y116.731 I-1.039 J1.313 E.02725
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.186 E.01255
G1 X161.926 Y135.627 E.0158
G3 X161.494 Y136.009 I-1.175 J-.893 E.01864
G1 X161.036 Y136.177 E.0157
G1 X160.883 Y136.198 E.00495
G1 X139.199 Y136.202 E.69726
G1 X138.814 Y136.142 E.01255
G1 X138.373 Y135.926 E.0158
G1 X138.238 Y135.817 E.00556
G1 X137.991 Y135.494 E.01306
G1 X137.887 Y135.269 E.00799
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.168 E.567
G1 X137.847 Y116.844 E.01053
G1 X138.069 Y116.382 E.01647
G1 X138.216 Y116.21 E.00728
G1 X138.663 Y115.911 E.01729
G1 X139.117 Y115.802 E.015
M73 P62 R7
G1 X160.8 Y115.798 E.69726
G1 X161.103 Y115.834 E.00979
G1 X161.226 Y115.89 E.00437
M204 S250
G1 X161.127 Y116.252 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.461 E.01232
G1 X161.73 Y116.815 E.01285
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.801 E.52427
G1 X161.733 Y135.179 E.01151
G1 X161.538 Y135.484 E.01077
G1 X161.194 Y135.728 E.01258
G1 X160.883 Y135.806 E.00953
G1 X139.199 Y135.81 E.64587
G1 X138.82 Y135.733 E.01152
G1 X138.527 Y135.552 E.01027
G1 X138.27 Y135.184 E.01337
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.168 E.52521
G1 X138.254 Y116.854 E.00954
G1 X138.459 Y116.518 E.01171
G1 X138.774 Y116.287 E.01162
G1 X139.117 Y116.194 E.01059
G1 X160.8 Y116.19 E.64587
G1 X161.07 Y116.236 E.00815
; WIPE_START
M204 S3000
G1 X161.484 Y116.461 E-.17899
G1 X161.73 Y116.815 E-.16395
G1 X161.81 Y117.199 E-.14902
G1 X161.81 Y117.905 E-.26804
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.928 Y115.076 Z3 F12000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.291 E.00719
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I86.795 J.663 E.06137
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.801 E.04968
; LINE_WIDTH: 0.44457
G1 X162.99 Y135.009 E.00662
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.769 I237.074 J1.276 E.05661
G1 X162.914 Y136.936 E.00586
G1 X162.732 Y136.991 E.00611
G2 X160.883 Y136.996 I-.642 J103.168 E.05944
; LINE_WIDTH: 0.43936
G1 X158.883 Y136.996 E.06263
; LINE_WIDTH: 0.43901
G1 X156.883 Y136.996 E.06258
; LINE_WIDTH: 0.43867
G1 X154.883 Y136.996 E.06252
; LINE_WIDTH: 0.43833
G1 X152.883 Y136.995 E.06247
; LINE_WIDTH: 0.43799
G1 X150.883 Y136.995 E.06242
; LINE_WIDTH: 0.43764
G1 X148.883 Y136.995 E.06236
; LINE_WIDTH: 0.4373
G1 X146.883 Y136.995 E.06231
; LINE_WIDTH: 0.43696
G1 X144.883 Y136.995 E.06225
; LINE_WIDTH: 0.43662
G1 X142.883 Y136.995 E.0622
; LINE_WIDTH: 0.43628
G1 X140.883 Y136.995 E.06215
; LINE_WIDTH: 0.43593
G1 X139.2 Y136.995 E.05227
; LINE_WIDTH: 0.44486
G1 X138.991 Y136.99 E.00663
; LINE_WIDTH: 0.44999
G2 X137.231 Y136.987 I-1.28 J249.812 E.0566
G1 X137.063 Y136.911 E.00594
G1 X137.009 Y136.732 E.006
G2 X137.003 Y134.801 I-91.176 J-.678 E.0621
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.44522
G1 X137.01 Y116.959 E.00664
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.225 I-232.23 J-1.229 E.05577
G1 X137.086 Y115.066 E.00561
G1 X137.268 Y115.009 E.00615
G2 X139.117 Y115.004 I.604 J-113.106 E.05944
; LINE_WIDTH: 0.43949
G1 X141.117 Y115.004 E.06265
; LINE_WIDTH: 0.43927
G1 X143.117 Y115.004 E.06262
; LINE_WIDTH: 0.43905
G1 X145.117 Y115.004 E.06258
; LINE_WIDTH: 0.43883
G1 X147.117 Y115.004 E.06255
; LINE_WIDTH: 0.43862
G1 X149.117 Y115.004 E.06251
; LINE_WIDTH: 0.4384
G1 X151.117 Y115.003 E.06248
; LINE_WIDTH: 0.43818
G1 X153.117 Y115.003 E.06245
; LINE_WIDTH: 0.43797
G1 X155.117 Y115.003 E.06241
; LINE_WIDTH: 0.43775
G1 X157.117 Y115.003 E.06238
; LINE_WIDTH: 0.43753
G1 X159.117 Y115.003 E.06234
; LINE_WIDTH: 0.43732
G1 X160.8 Y115.003 E.05245
; LINE_WIDTH: 0.44275
G1 X160.963 Y115.006 E.00514
; LINE_WIDTH: 0.44999
G2 X162.747 Y115.01 I1.224 J-161.747 E.05738
G1 X162.872 Y115.056 E.00426
M204 S10000
G1 X163.13 Y114.71 F12000
G1 F6000
M204 S3000
G1 X163.342 Y114.966 E.01069
G1 X163.397 Y115.291 E.01061
G1 X163.394 Y136.82 E.69227
G1 X163.289 Y137.12 E.01021
; object ids of layer 13 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer13 end: 47,58
M625
G1 X163.106 Y137.307 E.0084
G1 X162.76 Y137.398 E.01152
G1 X137.18 Y137.394 E.82254
G1 X136.886 Y137.294 E.00999
G1 X136.693 Y137.104 E.00871
G1 X136.602 Y136.76 E.01145
G1 X136.606 Y115.176 E.69403
G1 X136.703 Y114.895 E.00956
G1 X136.896 Y114.693 E.009
G1 X137.24 Y114.602 E.01145
G1 X161.24 Y114.602 E.77173
G3 X162.825 Y114.609 I.365 J97.147 E.05095
G1 X163.073 Y114.691 E.00841
M204 S250
G1 X163.398 Y114.423 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.566 Y114.576 E.00676
G3 X163.711 Y114.82 I-.764 J.622 E.00848
G1 X163.789 Y115.291 E.01424
G1 X163.786 Y136.717 E.63817
G3 X163.619 Y137.331 I-1.183 J.007 E.0192
G3 X163.189 Y137.698 I-.832 J-.538 E.01708
G1 X162.787 Y137.79 E.01229
G1 X137.283 Y137.786 E.75964
G3 X136.678 Y137.626 I-.001 J-1.219 E.01888
G3 X136.301 Y137.187 I.567 J-.867 E.01746
G1 X136.21 Y136.787 E.01223
G1 X136.214 Y115.283 E.6405
G3 X136.813 Y114.301 I1.058 J-.029 E.03624
G1 X137.213 Y114.21 E.01223
G1 X162.455 Y114.21 E.75184
G1 X163.066 Y114.248 E.01823
G1 X163.349 Y114.379 E.0093
G1 X163.354 Y114.383 E.00018
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.566 Y114.576 E-.10906
G1 X163.711 Y114.82 E-.1078
G1 X163.789 Y115.291 E-.18162
G1 X163.789 Y116.243 E-.36153
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.661 Y118.972 Z3 F12000
G1 X116.391 Y134.391 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.199 J-105.199 E.04403
; LINE_WIDTH: 0.4373
G1 X106.979 Y117.603 E.31153
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.603 E.2505
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.61 E.04401
G2 X116.397 Y118.979 I103.437 J.191 E.04402
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67799
G1 X95.251 Y134.712 E.00737
G1 X95.202 Y134.548 E.00552
G1 X95.202 Y117.463 E.54936
G1 X95.28 Y117.26 E.00701
G1 X95.441 Y117.202 E.00548
G1 X116.548 Y117.202 E.67873
G1 X116.75 Y117.289 E.00707
G1 X116.797 Y117.441 E.00511
G1 X116.798 Y134.537 E.54972
G1 X116.735 Y134.694 E.00545
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.547 J-.83 E.01065
G1 X94.81 Y134.583 E.00941
G1 X94.81 Y117.495 E.50896
G1 X94.868 Y117.155 E.01028
G1 X95.02 Y116.955 E.00748
G3 X95.414 Y116.81 I.531 J.837 E.0126
G1 X116.513 Y116.81 E.62845
G1 X116.867 Y116.879 E.01073
G1 X117.058 Y117.034 E.00732
G3 X117.189 Y117.441 I-.468 J.376 E.01304
G1 X117.19 Y134.505 E.50827
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.83 J-.548 E.00887
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.1414
G1 X114.955 Y135.19 E-.6186
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.356 Y134.469 Z3 F12000
G1 X96.117 Y133.403 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44623
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.4373
G1 X106.979 Y117.997 E.31153
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.997 E.2505
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02423
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z3 F12000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z3 F12000
G1 X96.026 Y117.961 Z3
G1 Z2.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z3 F12000
G1 X116.021 Y117.961 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.4214
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00141
; WIPE_START
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z3 F12000
G1 X116.021 Y133.957 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
M73 P63 R7
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 14/40
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z3 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z3
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.37457
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01698
G1 X162.416 Y115.756 E.00889
G1 X161.974 Y115.379 E.01523
G1 X162.561 Y115.379 E.01537
; WIPE_START
G1 X162.62 Y116.027 E-.24732
G1 X162.416 Y115.756 E-.12896
G1 X161.974 Y115.379 E-.22086
G1 X162.402 Y115.379 E-.16286
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.482 Y123.011 Z3.2 F12000
G1 X162.618 Y135.98 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01677
G1 X161.971 Y136.622 E.01693
G1 X162.341 Y136.334 E.01226
G1 X162.581 Y136.028 E.01019
; WIPE_START
G1 X162.618 Y136.622 E-.22625
G1 X161.971 Y136.622 E-.24602
G1 X162.341 Y136.334 E-.17812
G1 X162.519 Y136.107 E-.10961
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y136.266 Z3.2 F12000
G1 X138.02 Y136.618 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01678
G1 X137.378 Y135.971 E.01693
G1 X137.666 Y136.341 E.01226
G1 X137.973 Y136.581 E.01019
; WIPE_START
G1 X137.378 Y136.618 E-.22627
G1 X137.378 Y135.971 E-.24597
G1 X137.666 Y136.341 E-.17808
G1 X137.893 Y136.519 E-.10968
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.943 Y128.887 Z3.2 F12000
G1 X138.031 Y115.378 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.37327
G1 F6000
M204 S3000
G1 X137.66 Y115.664 E.01222
G1 X137.381 Y116.028 E.01196
G1 X137.381 Y115.378 E.01696
G1 X137.971 Y115.378 E.01537
; WIPE_START
G1 X137.66 Y115.664 E-.16049
G1 X137.381 Y116.028 E-.17416
G1 X137.381 Y115.378 E-.24697
G1 X137.851 Y115.378 E-.17838
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.483 Y115.418 Z3.2 F12000
G1 X161.384 Y115.503 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.45818
G1 F6000
M204 S3000
G1 X161.488 Y115.538 E.00361
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01133
G1 X162.121 Y115.979 E.01361
G1 X162.333 Y116.26 E.01131
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.01811
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.8 E.04968
; LINE_WIDTH: 0.44852
G1 X162.542 Y135.258 E.01477
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01114
G1 X162.092 Y136.062 E.01873
G1 X161.74 Y136.334 E.01429
G1 X161.356 Y136.511 E.01361
G1 X160.801 Y136.603 E.0181
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.603 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.603 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.603 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.602 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.602 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.602 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.602 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.602 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.602 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.602 E.06208
; LINE_WIDTH: 0.43575
G1 X139.2 Y136.602 E.04968
; LINE_WIDTH: 0.44856
G1 X138.742 Y136.542 E.01477
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01115
G1 X137.938 Y136.092 E.01872
G1 X137.667 Y135.74 E.01428
G1 X137.489 Y135.356 E.01361
G1 X137.397 Y134.801 E.01811
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.44859
G1 X137.455 Y116.745 E.01367
; LINE_WIDTH: 0.44999
G1 X137.573 Y116.428 E.01087
G1 X137.912 Y115.933 E.0193
G3 X138.947 Y115.411 I1.439 J1.567 E.03777
; LINE_WIDTH: 0.44837
G1 X139.118 Y115.4 E.00546
; LINE_WIDTH: 0.43943
G1 X141.118 Y115.4 E.06264
; LINE_WIDTH: 0.43921
G1 X143.118 Y115.4 E.06261
; LINE_WIDTH: 0.439
G1 X145.118 Y115.4 E.06257
; LINE_WIDTH: 0.43879
G1 X147.118 Y115.399 E.06254
; LINE_WIDTH: 0.43858
G1 X149.118 Y115.399 E.06251
; LINE_WIDTH: 0.43836
G1 X151.118 Y115.399 E.06247
; LINE_WIDTH: 0.43815
G1 X153.118 Y115.398 E.06244
; LINE_WIDTH: 0.43794
G1 X155.118 Y115.398 E.06241
; LINE_WIDTH: 0.43773
G1 X157.118 Y115.398 E.06237
; LINE_WIDTH: 0.43752
G1 X159.118 Y115.398 E.06234
; LINE_WIDTH: 0.4373
G1 X160.8 Y115.397 E.05242
; LINE_WIDTH: 0.45818
G3 X161.159 Y115.427 I.06 J1.456 E.01183
G1 X161.327 Y115.484 E.00583
M204 S10000
G1 X161.283 Y115.916 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01146
G3 X162.113 Y116.731 I-1.038 J1.311 E.02723
G1 X162.202 Y117.199 E.01533
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.186 E.01254
G1 X161.926 Y135.627 E.01578
G3 X161.268 Y136.113 I-1.336 J-1.118 E.02655
G1 X160.801 Y136.202 E.01531
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01255
G1 X138.373 Y135.926 E.01578
G1 X138.238 Y135.817 E.00558
G1 X137.991 Y135.495 E.01307
G1 X137.887 Y135.269 E.008
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.168 E.56699
G1 X137.854 Y116.821 E.01129
G1 X138.087 Y116.359 E.01664
G1 X138.232 Y116.194 E.00708
G1 X138.663 Y115.911 E.01658
G1 X139.118 Y115.802 E.01502
G1 X160.8 Y115.798 E.69722
G1 X161.102 Y115.834 E.00978
G1 X161.228 Y115.891 E.00444
M204 S250
G1 X161.129 Y116.253 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.462 E.01227
G1 X161.73 Y116.815 E.01284
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.801 E.52426
G1 X161.734 Y135.179 E.01151
G1 X161.539 Y135.484 E.01076
G1 X161.184 Y135.73 E.01286
G1 X160.801 Y135.81 E.01167
G1 X139.199 Y135.81 E.64341
G1 X138.821 Y135.734 E.01151
G1 X138.528 Y135.552 E.01026
G1 X138.27 Y135.184 E.01338
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.168 E.52521
G1 X138.262 Y116.834 E.01017
G1 X138.472 Y116.504 E.01164
G1 X138.774 Y116.287 E.01107
G1 X139.118 Y116.194 E.01062
G1 X160.8 Y116.19 E.64584
G1 X161.072 Y116.236 E.0082
; WIPE_START
M204 S3000
G1 X161.484 Y116.462 E-.17847
G1 X161.73 Y116.815 E-.16375
G1 X161.81 Y117.199 E-.14907
G1 X161.81 Y117.907 E-.26871
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.927 Y115.075 Z3.2 F12000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.291 E.00724
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I86.823 J.663 E.06137
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.801 E.04968
; LINE_WIDTH: 0.44457
G1 X162.99 Y135.009 E.00662
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.775 I237.588 J1.279 E.0568
G1 X162.915 Y136.934 E.0056
G1 X162.742 Y136.991 E.00586
G2 X160.801 Y136.997 I-.681 J91.791 E.06242
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.997 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.997 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.996 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.996 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.996 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.996 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.995 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.995 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.995 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.995 E.06208
; LINE_WIDTH: 0.43575
G1 X139.2 Y136.995 E.04968
; LINE_WIDTH: 0.44486
G1 X138.991 Y136.99 E.00662
; LINE_WIDTH: 0.44999
G2 X137.225 Y136.987 I-1.28 J248.713 E.0568
G1 X137.066 Y136.915 E.0056
G1 X137.009 Y136.732 E.00616
G2 X137.003 Y134.8 I-91.374 J-.677 E.0621
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.8 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.8 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.8 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.8 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.44641
G1 X137.011 Y116.946 E.00707
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.225 I-323.238 J-1.251 E.05535
G1 X137.086 Y115.066 E.00561
G1 X137.268 Y115.009 E.00615
G2 X139.118 Y115.004 I.605 J-112.454 E.05947
; LINE_WIDTH: 0.43943
G1 X141.118 Y115.004 E.06264
; LINE_WIDTH: 0.43921
G1 X143.118 Y115.004 E.06261
; LINE_WIDTH: 0.439
G1 X145.118 Y115.004 E.06257
; LINE_WIDTH: 0.43879
G1 X147.118 Y115.004 E.06254
; LINE_WIDTH: 0.43858
G1 X149.118 Y115.004 E.06251
; LINE_WIDTH: 0.43836
G1 X151.118 Y115.003 E.06247
; LINE_WIDTH: 0.43815
G1 X153.118 Y115.003 E.06244
; LINE_WIDTH: 0.43794
G1 X155.118 Y115.003 E.06241
; LINE_WIDTH: 0.43773
G1 X157.118 Y115.003 E.06237
; LINE_WIDTH: 0.43752
G1 X159.118 Y115.003 E.06234
; LINE_WIDTH: 0.4373
G1 X160.8 Y115.003 E.05242
; LINE_WIDTH: 0.44271
G1 X160.963 Y115.006 E.00514
; LINE_WIDTH: 0.44999
G2 X162.749 Y115.01 I1.225 J-161.497 E.05743
G1 X162.871 Y115.054 E.00418
M204 S10000
G1 X163.13 Y114.71 F12000
G1 F6000
M204 S3000
G1 X163.342 Y114.966 E.01068
G1 X163.397 Y115.291 E.0106
G1 X163.394 Y136.824 E.69239
G1 X163.298 Y137.105 E.00956
; object ids of layer 14 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer14 end: 47,58
M625
G1 X163.108 Y137.304 E.00883
G1 X162.766 Y137.398 E.01143
G1 X137.176 Y137.394 E.82284
G1 X136.895 Y137.298 E.00956
G1 X136.692 Y137.104 E.00902
G1 X136.602 Y136.76 E.01144
G1 X136.606 Y115.176 E.69403
G1 X136.703 Y114.895 E.00956
G1 X136.896 Y114.693 E.009
G1 X137.24 Y114.602 E.01145
G1 X161.24 Y114.602 E.77173
G3 X162.826 Y114.609 I.365 J96.763 E.05099
G1 X163.074 Y114.691 E.00838
M204 S250
G1 X163.397 Y114.422 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.565 Y114.575 E.00677
G3 X163.711 Y114.82 I-.763 J.623 E.00852
G1 X163.789 Y115.291 E.01424
G1 X163.786 Y136.73 E.63857
G1 X163.712 Y137.178 E.01352
G1 X163.551 Y137.441 E.0092
G1 X163.316 Y137.642 E.00922
G3 X162.789 Y137.79 I-.684 J-1.428 E.01639
G1 X137.283 Y137.786 E.7597
G3 X136.301 Y137.187 I-.029 J-1.058 E.03624
G1 X136.21 Y136.787 E.01223
G1 X136.214 Y115.283 E.64049
G3 X136.813 Y114.301 I1.058 J-.029 E.03623
G1 X137.213 Y114.21 E.01224
G1 X162.455 Y114.21 E.75184
G1 X163.065 Y114.248 E.01823
G1 X163.35 Y114.379 E.00932
G1 X163.352 Y114.382 E.00011
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.565 Y114.575 E-.10913
G1 X163.711 Y114.82 E-.10836
G1 X163.789 Y115.291 E-.18167
G1 X163.789 Y116.241 E-.36084
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.661 Y118.97 Z3.2 F12000
G1 X116.391 Y134.391 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.199 J-105.199 E.04403
; LINE_WIDTH: 0.43731
G1 X108.979 Y117.603 E.37385
; LINE_WIDTH: 0.43719
G1 X115.021 Y117.603 E.1882
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.61 E.04401
G2 X116.397 Y118.979 I103.439 J.191 E.04402
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.715 Y134.742 F12000
G1 F6000
M204 S3000
G1 X116.559 Y134.798 E.00532
G1 X95.463 Y134.798 E.67835
G1 X95.251 Y134.712 E.00738
G1 X95.202 Y134.548 E.00551
G1 X95.202 Y117.463 E.54936
G1 X95.28 Y117.26 E.00701
G1 X95.441 Y117.202 E.00548
G1 X116.512 Y117.202 E.67757
G1 X116.721 Y117.255 E.00691
G1 X116.797 Y117.45 E.00674
G1 X116.798 Y134.537 E.54943
G1 X116.739 Y134.688 E.00524
M204 S250
G1 X116.85 Y135.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X116.586 Y135.19 I-.401 J-.907 E.0082
G1 X95.495 Y135.19 E.62822
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.548 J-.83 E.01066
G1 X94.81 Y134.583 E.0094
G1 X94.81 Y117.495 E.50896
G1 X94.868 Y117.155 E.01028
G1 X95.02 Y116.955 E.00747
G3 X95.414 Y116.81 I.532 J.837 E.0126
G1 X116.597 Y116.81 E.63095
G1 X116.942 Y116.931 E.0109
G1 X117.152 Y117.202 E.01022
G1 X117.189 Y117.45 E.00747
G1 X117.19 Y134.505 E.50799
G1 X117.132 Y134.845 E.01029
G1 X116.98 Y135.045 E.00746
G3 X116.904 Y135.089 I-.532 J-.837 E.00262
; WIPE_START
M204 S3000
G1 X116.586 Y135.19 E-.12679
G1 X114.92 Y135.19 E-.63321
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.322 Y134.468 Z3.2 F12000
G1 X96.117 Y133.403 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X108.979 Y117.997 E.37385
; LINE_WIDTH: 0.43719
G1 X115.021 Y117.997 E.1882
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02423
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
M73 P64 R7
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z3.2 F12000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
M73 P64 R6
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z3.2 F12000
G1 X96.026 Y117.961 Z3.2
G1 Z2.8
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z3.2 F12000
G1 X116.021 Y117.961 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.4214
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00141
; WIPE_START
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z3.2 F12000
G1 X116.021 Y133.957 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 15/40
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z3.2 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z3.2
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.37459
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01698
G1 X162.333 Y115.657 E.01229
G1 X161.976 Y115.379 E.01185
G1 X162.561 Y115.379 E.01532
; WIPE_START
G1 X162.621 Y116.027 E-.24738
G1 X162.333 Y115.657 E-.1782
G1 X161.976 Y115.379 E-.17188
G1 X162.404 Y115.379 E-.16254
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.484 Y123.011 Z3.4 F12000
G1 X162.621 Y135.976 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X162.621 Y136.621 E.01692
G1 X161.972 Y136.621 E.01702
G1 X162.343 Y136.333 E.01232
G1 X162.584 Y136.023 E.0103
; WIPE_START
G1 X162.621 Y136.621 E-.22763
G1 X161.972 Y136.621 E-.24663
G1 X162.343 Y136.333 E-.17843
G1 X162.517 Y136.11 E-.10732
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y136.269 Z3.4 F12000
G1 X138.023 Y136.618 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.37395
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01687
G1 X137.378 Y135.971 E.01693
G1 X137.584 Y136.243 E.00893
G1 X137.978 Y136.579 E.01353
; WIPE_START
G1 X137.378 Y136.618 E-.22824
G1 X137.378 Y135.971 E-.24603
G1 X137.584 Y136.243 E-.12982
G1 X137.896 Y136.51 E-.15591
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.946 Y128.878 Z3.4 F12000
G1 X138.034 Y115.378 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.37399
G1 F6000
M204 S3000
G1 X137.736 Y115.601 E.00973
G1 X137.382 Y116.021 E.01437
G1 X137.382 Y115.378 E.0168
G1 X137.974 Y115.378 E.01549
; WIPE_START
G1 X137.736 Y115.601 E-.12389
G1 X137.382 Y116.021 E-.2088
G1 X137.382 Y115.378 E-.24418
G1 X137.864 Y115.378 E-.18313
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.496 Y115.425 Z3.4 F12000
G1 X161.431 Y115.521 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y115.577 E.00521
G1 X162.061 Y115.907 E.01866
G1 X162.333 Y116.26 E.01434
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.0181
; LINE_WIDTH: 0.43693
G1 X162.603 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.603 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.603 Y134.801 E.17445
; LINE_WIDTH: 0.44897
G1 X162.542 Y135.258 E.0148
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.584 E.01115
G1 X162.093 Y136.061 E.01865
G1 X161.74 Y136.334 E.01435
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.603 E.01809
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.603 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.603 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.603 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.602 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.602 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.602 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.602 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.602 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.602 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.602 E.06208
; LINE_WIDTH: 0.43575
G1 X139.199 Y136.602 E.04969
; LINE_WIDTH: 0.45668
G3 X138.512 Y136.462 I-.059 J-1.468 E.02316
; LINE_WIDTH: 0.44999
G1 X138.201 Y136.296 E.01133
G1 X137.879 Y136.021 E.01362
G1 X137.666 Y135.74 E.01132
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.801 E.01809
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.44856
G1 X137.455 Y116.746 E.01361
; LINE_WIDTH: 0.44999
G1 X137.567 Y116.439 E.01052
G1 X137.908 Y115.938 E.0195
G1 X138.216 Y115.692 E.01266
G3 X138.949 Y115.411 I1.033 J1.594 E.02542
; LINE_WIDTH: 0.44831
G1 X139.119 Y115.4 E.00546
; LINE_WIDTH: 0.43938
G1 X141.119 Y115.4 E.06263
; LINE_WIDTH: 0.43917
G1 X143.119 Y115.4 E.0626
; LINE_WIDTH: 0.43896
G1 X145.119 Y115.4 E.06257
; LINE_WIDTH: 0.43875
G1 X147.119 Y115.399 E.06254
; LINE_WIDTH: 0.43854
G1 X149.119 Y115.399 E.0625
; LINE_WIDTH: 0.43833
G1 X151.119 Y115.399 E.06247
; LINE_WIDTH: 0.43812
G1 X153.119 Y115.398 E.06244
; LINE_WIDTH: 0.43791
G1 X155.119 Y115.398 E.0624
; LINE_WIDTH: 0.4377
G1 X157.119 Y115.398 E.06237
; LINE_WIDTH: 0.43749
G1 X159.119 Y115.398 E.06234
; LINE_WIDTH: 0.43728
G1 X160.801 Y115.397 E.05239
; LINE_WIDTH: 0.44898
G1 X161.258 Y115.457 E.01479
; LINE_WIDTH: 0.44999
G1 X161.375 Y115.501 E.00401
M204 S10000
G1 X161.324 Y115.925 F12000
G1 F6000
M204 S3000
G1 X161.627 Y116.074 E.01086
G3 X162.113 Y116.731 I-1.117 J1.334 E.02652
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.187 E.01256
G1 X161.926 Y135.627 E.01578
G3 X161.268 Y136.113 I-1.335 J-1.118 E.02653
G1 X160.801 Y136.202 E.01531
G1 X139.199 Y136.202 E.69461
G1 X138.897 Y136.166 E.00977
G1 X138.393 Y135.937 E.01782
G3 X137.887 Y135.268 I1.039 J-1.312 E.02724
G1 X137.798 Y134.801 E.01531
G1 X137.799 Y117.168 E.567
G1 X137.854 Y116.822 E.01125
G1 X138.072 Y116.378 E.01592
G3 X138.468 Y116.012 I1.141 J.839 E.01744
G1 X138.956 Y115.825 E.01681
G1 X139.119 Y115.802 E.00529
G1 X160.801 Y115.798 E.6972
G1 X161.186 Y115.858 E.01254
G1 X161.27 Y115.899 E.00301
M204 S250
G1 X161.16 Y116.263 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y116.267 E.00059
G1 X161.484 Y116.462 E.01077
G1 X161.73 Y116.816 E.01284
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.801 E.52427
G1 X161.733 Y135.18 E.01152
G1 X161.538 Y135.484 E.01076
G1 X161.184 Y135.73 E.01285
G1 X160.801 Y135.81 E.01167
G1 X139.199 Y135.81 E.64342
G1 X138.888 Y135.757 E.00939
G1 X138.516 Y135.538 E.01286
G1 X138.27 Y135.184 E.01285
G1 X138.19 Y134.801 E.01167
G1 X138.191 Y117.168 E.52521
G1 X138.261 Y116.837 E.01008
G1 X138.459 Y116.518 E.01117
G1 X138.711 Y116.32 E.00955
G1 X139.119 Y116.194 E.01273
G1 X160.801 Y116.19 E.64581
G1 X161.101 Y116.251 E.00912
; WIPE_START
M204 S3000
G1 X161.179 Y116.267 E-.03035
G1 X161.484 Y116.462 E-.13741
G1 X161.73 Y116.816 E-.16384
G1 X161.81 Y117.199 E-.149
G1 X161.81 Y117.935 E-.2794
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.933 Y115.083 Z3.4 F12000
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.264 E.00609
; LINE_WIDTH: 0.45008
G2 X162.997 Y117.199 I89.076 J.663 E.06227
; LINE_WIDTH: 0.43693
G1 X162.997 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.997 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.997 Y134.801 E.17445
; LINE_WIDTH: 0.44897
G1 X162.991 Y135.298 E.01596
; LINE_WIDTH: 0.44999
G3 X162.976 Y136.816 I-41.82 J.337 E.0488
G1 X162.89 Y136.952 E.00518
G1 X162.722 Y136.991 E.00556
G2 X160.801 Y136.997 I-.67 J90.959 E.06179
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.997 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.997 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.996 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.996 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.996 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.996 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.995 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.995 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.995 E.06211
; LINE_WIDTH: 0.43589
M73 P65 R6
G1 X140.801 Y136.995 E.06208
; LINE_WIDTH: 0.43575
G1 X139.199 Y136.995 E.04969
; LINE_WIDTH: 0.44122
G1 X139.037 Y136.992 E.00511
; LINE_WIDTH: 0.44999
G2 X137.252 Y136.987 I-1.24 J133.866 E.05738
G1 X137.07 Y136.924 E.00622
G1 X137.009 Y136.722 E.00678
G2 X137.003 Y134.801 I-90.912 J-.672 E.06179
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.44637
G1 X137.011 Y116.946 E.00706
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.224 I-311.413 J-1.241 E.05537
G1 X137.085 Y115.066 E.00561
G1 X137.268 Y115.009 E.00616
G2 X139.119 Y115.004 I.606 J-111.815 E.05951
; LINE_WIDTH: 0.43938
G1 X141.119 Y115.004 E.06263
; LINE_WIDTH: 0.43917
G1 X143.119 Y115.004 E.0626
; LINE_WIDTH: 0.43896
G1 X145.119 Y115.004 E.06257
; LINE_WIDTH: 0.43875
G1 X147.119 Y115.004 E.06254
; LINE_WIDTH: 0.43854
G1 X149.119 Y115.004 E.0625
; LINE_WIDTH: 0.43833
G1 X151.119 Y115.003 E.06247
; LINE_WIDTH: 0.43812
G1 X153.119 Y115.003 E.06244
; LINE_WIDTH: 0.43791
G1 X155.119 Y115.003 E.0624
; LINE_WIDTH: 0.4377
G1 X157.119 Y115.003 E.06237
; LINE_WIDTH: 0.43749
G1 X159.119 Y115.003 E.06234
; LINE_WIDTH: 0.43728
G1 X160.801 Y115.003 E.05239
; LINE_WIDTH: 0.44898
G1 X161.298 Y115.009 E.01595
; LINE_WIDTH: 0.44999
G3 X162.762 Y115.013 I.246 J166.535 E.0471
G1 X162.878 Y115.06 E.004
M204 S10000
G1 X163.181 Y114.758 F12000
G1 F6000
M204 S3000
G1 X163.365 Y115.028 E.01054
G1 X163.397 Y115.264 E.00763
G1 X163.398 Y135.263 E.64311
G3 X163.378 Y136.879 I-34.673 J.383 E.05197
G1 X163.281 Y137.142 E.009
; object ids of layer 15 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer15 end: 47,58
M625
G1 X163.051 Y137.33 E.00954
G1 X162.754 Y137.398 E.00981
G1 X138.754 Y137.395 E.77173
G3 X137.072 Y137.369 I-.359 J-32.173 E.05409
G1 X136.801 Y137.236 E.00974
G1 X136.671 Y137.057 E.00711
G1 X136.602 Y136.754 E.00998
G1 X136.606 Y115.176 E.69384
G1 X136.702 Y114.895 E.00956
G1 X136.896 Y114.693 E.00901
G1 X137.24 Y114.602 E.01145
G1 X162.455 Y114.603 E.81079
G1 X162.986 Y114.638 E.01713
G1 X163.13 Y114.726 E.00541
M204 S250
G1 X163.398 Y114.424 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.574 Y114.588 E.00717
G1 X163.74 Y114.898 E.01049
G1 X163.789 Y115.263 E.01098
G1 X163.79 Y136.699 E.63847
G1 X163.739 Y137.105 E.01219
G1 X163.6 Y137.379 E.00915
G1 X163.346 Y137.623 E.01051
G1 X163.107 Y137.739 E.0079
G1 X162.785 Y137.79 E.00972
G1 X137.252 Y137.786 E.76051
G1 X136.823 Y137.713 E.01297
G3 X136.45 Y137.428 I.843 J-1.495 E.01403
G1 X136.261 Y137.108 E.01107
G1 X136.21 Y136.785 E.00975
G1 X136.214 Y115.283 E.64044
G3 X136.813 Y114.301 I1.058 J-.029 E.03624
G1 X137.213 Y114.21 E.01223
G1 X162.717 Y114.21 E.75966
G1 X163.107 Y114.261 E.01169
G1 X163.347 Y114.378 E.00797
G1 X163.354 Y114.383 E.00026
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.574 Y114.588 E-.11422
G1 X163.74 Y114.898 E-.13384
G1 X163.789 Y115.263 E-.14005
G1 X163.789 Y116.242 E-.37189
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.661 Y118.971 Z3.4 F12000
G1 X116.391 Y134.391 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.199 J-105.199 E.04403
; LINE_WIDTH: 0.43731
G1 X108.979 Y117.603 E.37385
; LINE_WIDTH: 0.43719
G1 X115.021 Y117.603 E.1882
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.61 E.04401
G2 X116.397 Y118.979 I103.441 J.191 E.04402
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.713 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00552
G1 X95.463 Y134.798 E.67799
G1 X95.251 Y134.712 E.00738
G1 X95.202 Y134.548 E.0055
G1 X95.202 Y117.463 E.54937
G1 X95.288 Y117.25 E.00738
G1 X95.452 Y117.202 E.00551
G1 X116.511 Y117.202 E.67718
G1 X116.73 Y117.262 E.00728
G1 X116.797 Y117.469 E.00702
G1 X116.798 Y134.537 E.54881
G1 X116.735 Y134.694 E.00544
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.548 J-.831 E.01066
G1 X94.81 Y134.583 E.00939
G1 X94.81 Y117.495 E.50897
G1 X94.868 Y117.155 E.01028
G3 X95.114 Y116.898 I.832 J.549 E.01065
G1 X95.417 Y116.81 E.0094
G1 X115.417 Y116.81 E.59572
G3 X116.678 Y116.831 I.29 J20.75 E.03754
G1 X116.948 Y116.935 E.00862
G1 X117.132 Y117.152 E.00849
G1 X117.189 Y117.469 E.00959
G1 X117.19 Y134.505 E.50742
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.829 J-.547 E.00887
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14139
G1 X114.955 Y135.19 E-.61861
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.356 Y134.469 Z3.4 F12000
G1 X96.117 Y133.403 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X108.979 Y117.997 E.37385
; LINE_WIDTH: 0.43719
G1 X115.021 Y117.997 E.1882
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02423
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z3.4 F12000
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z3.4 F12000
G1 X96.026 Y117.961 Z3.4
G1 Z3
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z3.4 F12000
G1 X116.021 Y117.961 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.42142
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00141
; WIPE_START
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z3.4 F12000
G1 X116.021 Y133.957 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 16/40
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z3.4 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z3.4
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.37453
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01698
G1 X162.416 Y115.757 E.00887
G1 X161.974 Y115.379 E.01524
G1 X162.561 Y115.379 E.01537
; WIPE_START
G1 X162.62 Y116.027 E-.24731
G1 X162.416 Y115.757 E-.12867
G1 X161.974 Y115.379 E-.22112
G1 X162.402 Y115.379 E-.1629
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P66 R6
G1 X162.482 Y123.011 Z3.6 F12000
G1 X162.618 Y135.98 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01678
G1 X161.971 Y136.622 E.01694
G1 X162.341 Y136.334 E.01226
G1 X162.581 Y136.027 E.01019
; WIPE_START
G1 X162.618 Y136.622 E-.22631
G1 X161.971 Y136.622 E-.24608
G1 X162.341 Y136.334 E-.17817
G1 X162.519 Y136.107 E-.10944
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y136.268 Z3.6 F12000
G1 X138.024 Y136.621 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01693
G1 X137.379 Y135.972 E.01702
G1 X137.667 Y136.343 E.01232
G1 X137.977 Y136.584 E.0103
; WIPE_START
G1 X137.379 Y136.621 E-.22768
G1 X137.379 Y135.972 E-.24662
G1 X137.667 Y136.343 E-.17841
G1 X137.89 Y136.517 E-.10729
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.945 Y128.884 Z3.6 F12000
G1 X138.043 Y115.378 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.374
G1 F6000
M204 S3000
G1 X137.715 Y115.618 E.01063
G1 X137.382 Y116.018 E.01361
G1 X137.382 Y115.378 E.01672
G1 X137.983 Y115.378 E.01573
; WIPE_START
G1 X137.715 Y115.618 E-.13676
G1 X137.382 Y116.018 E-.19769
G1 X137.382 Y115.378 E-.24298
G1 X137.862 Y115.378 E-.18257
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.495 Y115.419 Z3.6 F12000
G1 X161.387 Y115.504 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.45816
G1 F6000
M204 S3000
G1 X161.489 Y115.538 E.0035
; LINE_WIDTH: 0.44999
G1 X161.8 Y115.705 E.01135
G1 X162.122 Y115.98 E.01362
G1 X162.334 Y116.26 E.0113
G1 X162.511 Y116.644 E.01359
G1 X162.603 Y117.199 E.0181
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.8 E.04968
; LINE_WIDTH: 0.44856
G1 X162.542 Y135.258 E.01478
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.584 E.01116
G1 X162.092 Y136.062 E.01871
G1 X161.74 Y136.334 E.0143
G1 X161.355 Y136.511 E.0136
G1 X160.801 Y136.603 E.01808
; LINE_WIDTH: 0.43732
G1 X139.2 Y136.603 E.67297
; LINE_WIDTH: 0.44904
G1 X138.742 Y136.543 E.0148
; LINE_WIDTH: 0.44999
G1 X138.416 Y136.423 E.01117
G1 X137.939 Y136.093 E.01865
G1 X137.666 Y135.74 E.01435
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.44992
G1 X137.476 Y116.675 E.01605
G1 X137.733 Y116.151 E.01875
G3 X138.512 Y115.538 I1.547 J1.165 E.03224
G1 X138.965 Y115.409 E.01513
; LINE_WIDTH: 0.4475
G1 X139.135 Y115.399 E.00545
; LINE_WIDTH: 0.43857
G1 X141.135 Y115.399 E.06251
; LINE_WIDTH: 0.43843
G1 X143.135 Y115.399 E.06248
; LINE_WIDTH: 0.43829
G1 X145.135 Y115.399 E.06246
; LINE_WIDTH: 0.43816
G1 X147.135 Y115.398 E.06244
; LINE_WIDTH: 0.43802
G1 X149.135 Y115.398 E.06242
; LINE_WIDTH: 0.43789
G1 X151.135 Y115.398 E.0624
; LINE_WIDTH: 0.43775
G1 X153.135 Y115.398 E.06238
; LINE_WIDTH: 0.43762
G1 X155.135 Y115.398 E.06236
; LINE_WIDTH: 0.43748
G1 X157.135 Y115.398 E.06233
; LINE_WIDTH: 0.43734
G1 X159.135 Y115.397 E.06231
; LINE_WIDTH: 0.43721
G1 X160.8 Y115.397 E.05186
; LINE_WIDTH: 0.45816
G3 X161.159 Y115.427 I.06 J1.456 E.01183
G1 X161.331 Y115.485 E.00595
M204 S10000
G1 X161.286 Y115.918 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.608 Y116.064 E.01136
G3 X162.113 Y116.731 I-1.038 J1.311 E.02721
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.186 E.01255
G1 X161.926 Y135.627 E.01579
G3 X161.268 Y136.113 I-1.335 J-1.118 E.02654
G1 X160.801 Y136.202 E.0153
G1 X139.2 Y136.202 E.69459
G1 X138.814 Y136.142 E.01256
G1 X138.373 Y135.926 E.0158
G3 X137.887 Y135.268 I1.118 J-1.335 E.02653
G1 X137.798 Y134.801 E.01531
G1 X137.799 Y117.168 E.56699
G1 X137.874 Y116.762 E.01328
G1 X138.08 Y116.363 E.01442
G1 X138.431 Y116.034 E.01546
G1 X138.63 Y115.927 E.00728
G1 X139.135 Y115.8 E.01674
G1 X160.8 Y115.798 E.69666
G1 X161.102 Y115.834 E.00978
G1 X161.231 Y115.893 E.00455
M204 S250
G1 X161.132 Y116.255 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.462 E.01217
G1 X161.73 Y116.815 E.01283
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.801 E.52426
G1 X161.733 Y135.18 E.01152
G1 X161.538 Y135.484 E.01076
G1 X161.184 Y135.73 E.01286
G1 X160.801 Y135.81 E.01167
G1 X139.2 Y135.81 E.6434
G1 X138.82 Y135.733 E.01152
G1 X138.516 Y135.538 E.01076
G1 X138.27 Y135.184 E.01285
G1 X138.19 Y134.801 E.01167
G1 X138.191 Y117.168 E.52521
G1 X138.28 Y116.787 E.01164
G1 X138.456 Y116.521 E.0095
G1 X138.744 Y116.303 E.01078
G1 X139.135 Y116.193 E.0121
G1 X160.8 Y116.19 E.64531
G1 X161.076 Y116.237 E.00831
; WIPE_START
M204 S3000
G1 X161.484 Y116.462 E-.17728
G1 X161.73 Y116.815 E-.16363
G1 X161.81 Y117.199 E-.14902
G1 X161.81 Y117.91 E-.27007
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.94 Y115.09 Z3.6 F12000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.291 E.00667
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I86.786 J.663 E.06137
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.801 E.04968
; LINE_WIDTH: 0.44484
G1 X162.99 Y135.009 E.00662
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.742 I244.927 J1.262 E.05574
G1 X162.936 Y136.916 E.00582
G1 X162.751 Y136.991 E.0064
G2 X160.801 Y136.997 I-.672 J93.221 E.06273
; LINE_WIDTH: 0.43732
G1 X139.2 Y136.997 E.67297
; LINE_WIDTH: 0.44656
G1 X138.991 Y136.993 E.00666
; LINE_WIDTH: 0.44999
G2 X137.315 Y136.991 I-1.202 J357.043 E.05388
G1 X137.078 Y136.928 E.00789
G1 X137.009 Y136.742 E.0064
G2 X137.003 Y134.801 I-91.667 J-.682 E.06242
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.44975
G1 X137.012 Y116.913 E.00819
; LINE_WIDTH: 0.44999
G1 X137.013 Y115.224 E.05429
G1 X137.086 Y115.066 E.00561
G1 X137.268 Y115.009 E.00615
G2 X139.135 Y115.003 I.585 J-114.407 E.06003
; LINE_WIDTH: 0.43857
G1 X141.135 Y115.003 E.06251
; LINE_WIDTH: 0.43843
G1 X143.135 Y115.003 E.06248
; LINE_WIDTH: 0.43829
G1 X145.135 Y115.003 E.06246
; LINE_WIDTH: 0.43816
G1 X147.135 Y115.003 E.06244
; LINE_WIDTH: 0.43802
G1 X149.135 Y115.003 E.06242
; LINE_WIDTH: 0.43789
G1 X151.135 Y115.003 E.0624
; LINE_WIDTH: 0.43775
G1 X153.135 Y115.003 E.06238
; LINE_WIDTH: 0.43762
G1 X155.135 Y115.003 E.06236
; LINE_WIDTH: 0.43748
G1 X157.135 Y115.003 E.06233
; LINE_WIDTH: 0.43734
G1 X159.135 Y115.003 E.06231
; LINE_WIDTH: 0.43721
G1 X160.8 Y115.003 E.05186
; LINE_WIDTH: 0.45816
G2 X161.974 Y115.01 I.687 J-18.101 E.0385
; LINE_WIDTH: 0.44999
G1 X162.822 Y115.022 E.02729
G1 X162.888 Y115.06 E.00245
M204 S10000
G1 X163.126 Y114.707 F12000
G1 F6000
M204 S3000
G1 X163.341 Y114.963 E.01075
G1 X163.397 Y115.291 E.0107
G1 X163.394 Y136.824 E.69238
G1 X163.298 Y137.103 E.0095
; object ids of layer 16 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer16 end: 47,58
M625
G1 X163.113 Y137.3 E.0087
G1 X162.771 Y137.398 E.01143
G1 X138.771 Y137.398 E.77173
G3 X137.19 Y137.387 I-.4 J-55.791 E.05085
G1 X136.905 Y137.299 E.00959
G1 X136.696 Y137.108 E.00908
G1 X136.602 Y136.766 E.01143
G1 X136.606 Y115.176 E.69421
G1 X136.703 Y114.895 E.00956
G1 X136.896 Y114.693 E.00901
G1 X137.24 Y114.602 E.01145
G1 X161.24 Y114.603 E.77173
G3 X162.83 Y114.611 I.366 J82.793 E.05112
G1 X163.069 Y114.689 E.0081
M204 S250
G1 X163.393 Y114.42 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.577 Y114.59 E.00747
G1 X163.711 Y114.819 E.00789
G1 X163.789 Y115.291 E.01427
G1 X163.786 Y136.743 E.63894
G1 X163.712 Y137.178 E.01316
G1 X163.551 Y137.441 E.0092
G1 X163.317 Y137.641 E.00916
G3 X162.79 Y137.79 I-.737 J-1.6 E.01637
G1 X137.315 Y137.79 E.7588
G1 X136.858 Y137.726 E.01374
G1 X136.558 Y137.55 E.01038
G1 X136.358 Y137.316 E.00916
G3 X136.21 Y136.789 I1.423 J-.683 E.01639
G1 X136.214 Y115.283 E.64055
G3 X136.813 Y114.301 I1.058 J-.029 E.03624
G1 X137.213 Y114.21 E.01224
G1 X162.455 Y114.21 E.75184
G1 X163.085 Y114.254 E.01882
G1 X163.348 Y114.378 E.00867
G1 X163.349 Y114.379 E.00003
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.577 Y114.59 E-.11808
G1 X163.711 Y114.819 E-.10065
G1 X163.789 Y115.291 E-.1821
G1 X163.789 Y116.237 E-.35916
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.661 Y118.967 Z3.6 F12000
G1 X116.391 Y134.391 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.199 J-105.199 E.04403
; LINE_WIDTH: 0.43731
G1 X108.979 Y117.603 E.37385
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.603 E.18821
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.61 E.04401
G2 X116.397 Y118.979 I103.445 J.191 E.04402
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67799
G1 X95.26 Y134.72 E.007
G1 X95.202 Y134.56 E.00547
G1 X95.202 Y117.464 E.54974
G1 X95.287 Y117.251 E.00738
G1 X95.452 Y117.202 E.00552
G1 X116.511 Y117.202 E.67716
G1 X116.715 Y117.262 E.00685
G1 X116.797 Y117.416 E.0056
G1 X116.798 Y134.537 E.55053
G1 X116.735 Y134.694 E.00545
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01027
G1 X94.955 Y134.98 E.00747
G3 X94.81 Y134.587 I.838 J-.532 E.01259
G1 X94.81 Y117.495 E.50908
G1 X94.868 Y117.155 E.01029
G3 X95.114 Y116.898 I.829 J.547 E.01064
G1 X95.417 Y116.81 E.00941
G1 X116.511 Y116.81 E.62829
G1 X116.866 Y116.879 E.01078
G1 X117.06 Y117.038 E.00746
G3 X117.189 Y117.416 I-.886 J.515 E.01198
G1 X117.19 Y134.505 E.50901
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.83 J-.547 E.00887
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14135
G1 X114.955 Y135.19 E-.61866
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.357 Y134.459 Z3.6 F12000
G1 X96.103 Y133.376 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X108.979 Y117.997 E.37385
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.997 E.18821
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02423
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.43 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00282
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
M73 P67 R6
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X96.979 Y133.21 E.53742
G1 X96.845 Y133.155 E.0043
G1 X96.813 Y133.077 E.00251
; WIPE_START
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z3.6 F12000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z3.6 F12000
G1 X96.026 Y117.961 Z3.6
G1 Z3.2
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z3.6 F12000
G1 X116.021 Y117.961 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.42142
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00141
; WIPE_START
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z3.6 F12000
G1 X116.021 Y133.957 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 17/40
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z3.6 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z3.6
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.37455
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01698
G1 X162.333 Y115.657 E.01228
G1 X161.976 Y115.379 E.01185
G1 X162.561 Y115.379 E.01532
; WIPE_START
G1 X162.621 Y116.027 E-.24736
G1 X162.333 Y115.657 E-.17819
G1 X161.976 Y115.379 E-.17191
G1 X162.404 Y115.379 E-.16255
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.484 Y123.011 Z3.8 F12000
G1 X162.622 Y135.974 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.37389
G1 F6000
M204 S3000
G1 X162.622 Y136.618 E.01684
G1 X161.975 Y136.618 E.01691
G1 X162.344 Y136.331 E.01223
G1 X162.585 Y136.021 E.01025
; WIPE_START
G1 X162.622 Y136.618 E-.22722
G1 X161.975 Y136.618 E-.24573
G1 X162.344 Y136.331 E-.1777
G1 X162.521 Y136.104 E-.10936
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.89 Y136.265 Z3.8 F12000
G1 X138.024 Y136.621 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01692
G1 X137.379 Y135.972 E.01702
G1 X137.667 Y136.343 E.01231
G1 X137.976 Y136.584 E.01029
; WIPE_START
G1 X137.379 Y136.621 E-.22756
G1 X137.379 Y135.972 E-.24659
G1 X137.667 Y136.343 E-.1784
G1 X137.89 Y136.517 E-.10744
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y128.885 Z3.8 F12000
G1 X138.035 Y115.377 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.37246
G1 F6000
M204 S3000
G1 X137.663 Y115.658 E.01212
G1 X137.381 Y116.025 E.01206
G1 X137.381 Y115.377 E.01686
G1 X137.975 Y115.377 E.01546
; WIPE_START
G1 X137.663 Y115.658 E-.15931
G1 X137.381 Y116.025 E-.17604
G1 X137.381 Y115.377 E-.24612
G1 X137.851 Y115.377 E-.17852
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.483 Y115.424 Z3.8 F12000
G1 X161.433 Y115.522 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y115.577 E.00514
G1 X162.061 Y115.907 E.01867
G1 X162.334 Y116.26 E.01434
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.01811
; LINE_WIDTH: 0.43693
G1 X162.603 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.603 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.603 Y134.801 E.17444
; LINE_WIDTH: 0.44897
G1 X162.543 Y135.258 E.01478
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01115
G1 X162.094 Y136.06 E.01863
G1 X161.74 Y136.334 E.0144
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.602 E.01808
; LINE_WIDTH: 0.43578
G1 X158.801 Y136.602 E.06207
; LINE_WIDTH: 0.43592
G1 X156.801 Y136.602 E.06209
; LINE_WIDTH: 0.43606
G1 X154.801 Y136.602 E.06211
; LINE_WIDTH: 0.4362
G1 X152.801 Y136.602 E.06213
; LINE_WIDTH: 0.43634
G1 X150.801 Y136.602 E.06215
; LINE_WIDTH: 0.43648
G1 X148.801 Y136.602 E.06218
; LINE_WIDTH: 0.43663
G1 X146.801 Y136.602 E.0622
; LINE_WIDTH: 0.43677
G1 X144.801 Y136.603 E.06222
; LINE_WIDTH: 0.43691
G1 X142.801 Y136.603 E.06224
; LINE_WIDTH: 0.43705
G1 X140.801 Y136.603 E.06227
; LINE_WIDTH: 0.43717
G1 X139.2 Y136.603 E.04987
; LINE_WIDTH: 0.449
G1 X138.743 Y136.543 E.01478
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01115
G1 X137.939 Y136.093 E.01868
G1 X137.667 Y135.74 E.01434
G1 X137.489 Y135.356 E.01361
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05072
; LINE_WIDTH: 0.45047
G1 X137.494 Y116.625 E.01774
G1 X137.649 Y116.283 E.01208
; LINE_WIDTH: 0.44999
G1 X137.926 Y115.916 E.01477
G1 X138.344 Y115.615 E.01657
G1 X138.693 Y115.473 E.01212
; LINE_WIDTH: 0.4495
G1 X139.199 Y115.397 E.01645
; LINE_WIDTH: 0.4373
G1 X149.199 Y115.397 E.31153
; LINE_WIDTH: 0.4372
G1 X160.801 Y115.397 E.36133
; LINE_WIDTH: 0.44897
G1 X161.258 Y115.457 E.01478
; LINE_WIDTH: 0.44999
G1 X161.377 Y115.501 E.00408
M204 S10000
G1 X161.326 Y115.926 F12000
G1 F6000
M204 S3000
G1 X161.627 Y116.075 E.0108
G3 X162.113 Y116.731 I-1.116 J1.333 E.02651
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.801 E.56597
G1 X162.142 Y135.186 E.01254
G1 X161.926 Y135.627 E.01579
G3 X161.268 Y136.113 I-1.335 J-1.117 E.02654
G1 X160.801 Y136.202 E.01531
G1 X139.2 Y136.202 E.69459
G1 X138.814 Y136.142 E.01254
G1 X138.373 Y135.926 E.01579
G3 X137.887 Y135.269 I1.117 J-1.335 E.02655
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.167 E.567
G1 X137.89 Y116.72 E.01468
G1 X138.156 Y116.273 E.01675
G1 X138.311 Y116.124 E.0069
G1 X138.772 Y115.872 E.0169
G1 X139.199 Y115.798 E.01394
G1 X160.801 Y115.798 E.69461
G1 X161.186 Y115.858 E.01253
G1 X161.272 Y115.9 E.00308
M204 S250
G1 X161.162 Y116.263 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y116.266 E.00054
G1 X161.484 Y116.462 E.01079
G1 X161.73 Y116.815 E.01283
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.801 E.52426
G1 X161.734 Y135.179 E.01151
G1 X161.539 Y135.484 E.01077
G1 X161.184 Y135.73 E.01285
G1 X160.801 Y135.81 E.01167
G1 X139.2 Y135.81 E.6434
G1 X138.821 Y135.734 E.01151
G1 X138.516 Y135.539 E.01077
G1 X138.27 Y135.184 E.01286
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.168 E.52521
G1 X138.301 Y116.746 E.01296
G1 X138.526 Y116.451 E.01106
G1 X138.849 Y116.256 E.01124
G1 X139.199 Y116.19 E.01062
G1 X160.801 Y116.19 E.64342
G1 X161.103 Y116.251 E.00917
; WIPE_START
M204 S3000
G1 X161.179 Y116.266 E-.02964
G1 X161.484 Y116.462 E-.1376
G1 X161.73 Y116.815 E-.1637
G1 X161.81 Y117.199 E-.14904
G1 X161.81 Y117.936 E-.28003
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.924 Y115.072 Z3.8 F12000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.291 E.00736
; LINE_WIDTH: 0.45008
G2 X162.997 Y117.199 I87.823 J.649 E.06137
; LINE_WIDTH: 0.43693
G1 X162.997 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.997 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.997 Y134.8 E.17444
; LINE_WIDTH: 0.44622
G1 X162.993 Y135.009 E.00665
; LINE_WIDTH: 0.44999
G2 X162.991 Y136.685 I322.533 J1.188 E.05389
G1 X162.947 Y136.907 E.00726
G1 X162.78 Y136.987 E.00597
G2 X160.801 Y136.995 I-.673 J83.784 E.06364
; LINE_WIDTH: 0.43578
G1 X158.801 Y136.995 E.06207
; LINE_WIDTH: 0.43592
G1 X156.801 Y136.995 E.06209
; LINE_WIDTH: 0.43606
G1 X154.801 Y136.995 E.06211
; LINE_WIDTH: 0.4362
G1 X152.801 Y136.996 E.06213
; LINE_WIDTH: 0.43634
G1 X150.801 Y136.996 E.06215
; LINE_WIDTH: 0.43648
G1 X148.801 Y136.996 E.06218
; LINE_WIDTH: 0.43663
G1 X146.801 Y136.996 E.0622
; LINE_WIDTH: 0.43677
G1 X144.801 Y136.996 E.06222
; LINE_WIDTH: 0.43691
G1 X142.801 Y136.997 E.06224
; LINE_WIDTH: 0.43705
G1 X140.801 Y136.997 E.06227
; LINE_WIDTH: 0.43717
G1 X139.2 Y136.997 E.04986
; LINE_WIDTH: 0.449
G1 X138.703 Y136.991 E.01593
; LINE_WIDTH: 0.44999
G3 X137.187 Y136.976 I-.341 J-43.131 E.04874
G1 X137.067 Y136.917 E.00431
G1 X137.009 Y136.722 E.00655
G2 X137.003 Y134.801 I-90.942 J-.672 E.06179
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.167 E.05072
; LINE_WIDTH: 0.4525
G2 X137.013 Y116.08 I-17.446 J-.659 E.0352
; LINE_WIDTH: 0.44999
G1 X137.013 Y115.253 E.02658
G1 X137.071 Y115.081 E.00586
G1 X137.244 Y115.009 E.00601
G1 X138.647 Y115.009 E.04512
; LINE_WIDTH: 0.4495
G1 X139.199 Y115.003 E.01774
; LINE_WIDTH: 0.4373
G1 X149.199 Y115.003 E.31153
; LINE_WIDTH: 0.4372
G1 X160.801 Y115.003 E.36133
; LINE_WIDTH: 0.44635
G1 X161.01 Y115.008 E.00666
; LINE_WIDTH: 0.44999
G2 X162.734 Y115.01 I1.236 J-346.714 E.05544
G1 X162.867 Y115.053 E.00451
M204 S10000
G1 X163.131 Y114.71 F12000
G1 F6000
M204 S3000
G1 X163.342 Y114.967 E.01069
G1 X163.397 Y115.291 E.01058
G1 X163.398 Y135.291 E.64311
G3 X163.375 Y136.874 I-29.856 J.369 E.0509
G1 X163.279 Y137.148 E.00935
; object ids of layer 17 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer17 end: 47,58
M625
G1 X163.101 Y137.302 E.00756
G1 X162.826 Y137.394 E.00933
G1 X138.826 Y137.398 E.77173
M73 P68 R6
G3 X137.192 Y137.389 I-.437 J-74.137 E.05256
G1 X136.876 Y137.295 E.01058
G1 X136.685 Y137.067 E.00958
G1 X136.602 Y136.754 E.01041
G1 X136.605 Y116.754 E.64311
G3 X136.626 Y115.091 I27.876 J-.484 E.05349
G1 X136.768 Y114.8 E.0104
G1 X136.939 Y114.67 E.00691
G1 X137.226 Y114.602 E.00948
G1 X161.226 Y114.603 E.77173
G3 X162.83 Y114.61 I.399 J90.404 E.05159
G1 X163.074 Y114.691 E.00826
M204 S250
G1 X163.393 Y114.418 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.562 Y114.572 E.00681
G3 X163.711 Y114.82 I-.761 J.627 E.00866
G1 X163.789 Y115.291 E.01423
G1 X163.79 Y136.453 E.63031
G1 X163.754 Y136.982 E.01579
G1 X163.658 Y137.271 E.00909
G1 X163.413 Y137.575 E.01164
G3 X162.871 Y137.786 I-.62 J-.791 E.01757
G1 X137.301 Y137.79 E.76162
G1 X136.893 Y137.739 E.01226
G1 X136.653 Y137.623 E.00794
G1 X136.426 Y137.413 E.00921
G1 X136.26 Y137.104 E.01045
G1 X136.21 Y136.785 E.00961
G1 X136.214 Y115.253 E.64134
G1 X136.287 Y114.824 E.01296
G1 X136.475 Y114.53 E.01041
G1 X136.754 Y114.319 E.01041
G3 X137.209 Y114.21 I.628 J1.618 E.01397
G1 X162.455 Y114.211 E.75198
G1 X163.065 Y114.248 E.01822
G1 X163.348 Y114.378 E.00926
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.562 Y114.572 E-.10969
G1 X163.711 Y114.82 E-.11004
G1 X163.789 Y115.291 E-.18154
G1 X163.789 Y116.235 E-.35872
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.662 Y118.965 Z3.8 F12000
G1 X116.391 Y134.391 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.199 J-105.199 E.04403
; LINE_WIDTH: 0.43731
G1 X108.979 Y117.603 E.37385
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.603 E.18821
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.446 J.191 E.04402
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67799
G1 X95.26 Y134.719 E.00701
G1 X95.202 Y134.56 E.00546
G1 X95.202 Y117.463 E.54974
G1 X95.279 Y117.262 E.00693
G1 X95.438 Y117.202 E.00548
G1 X116.51 Y117.202 E.67758
G1 X116.72 Y117.255 E.00696
G1 X116.797 Y117.45 E.00674
G1 X116.798 Y134.537 E.54943
G1 X116.735 Y134.694 E.00545
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01027
G1 X94.955 Y134.98 E.00748
G3 X94.81 Y134.587 I.838 J-.532 E.01258
G1 X94.81 Y117.495 E.50909
G1 X94.868 Y117.155 E.01028
G1 X95.019 Y116.955 E.00746
G3 X95.413 Y116.81 I.546 J.873 E.01259
G1 X115.413 Y116.81 E.59572
G3 X116.676 Y116.831 I.292 J20.898 E.03763
G1 X116.942 Y116.931 E.00847
G1 X117.152 Y117.202 E.01022
G1 X117.189 Y117.45 E.00746
G1 X117.19 Y134.505 E.508
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.83 J-.548 E.00887
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14136
G1 X114.955 Y135.19 E-.61864
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.356 Y134.469 Z3.8 F12000
G1 X96.117 Y133.403 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X108.979 Y117.997 E.37385
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.997 E.18821
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02423
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z3.8 F12000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z3.8 F12000
G1 X96.026 Y117.961 Z3.8
G1 Z3.4
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z3.8 F12000
G1 X116.021 Y117.961 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.42144
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00141
; WIPE_START
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z3.8 F12000
G1 X116.021 Y133.957 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 18/40
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z3.8 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z3.8
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.37455
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01698
G1 X162.416 Y115.757 E.00889
G1 X161.974 Y115.379 E.01523
G1 X162.561 Y115.379 E.01537
; WIPE_START
G1 X162.62 Y116.027 E-.24735
G1 X162.416 Y115.757 E-.1289
G1 X161.974 Y115.379 E-.22094
G1 X162.402 Y115.379 E-.16281
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.482 Y123.011 Z4 F12000
G1 X162.619 Y135.978 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.37289
G1 F6000
M204 S3000
G1 X162.619 Y136.619 E.01669
G1 X161.974 Y136.619 E.01681
G1 X162.342 Y136.332 E.01217
G1 X162.582 Y136.026 E.01015
; WIPE_START
G1 X162.619 Y136.619 E-.22586
G1 X161.974 Y136.619 E-.24509
G1 X162.342 Y136.332 E-.17736
G1 X162.523 Y136.101 E-.11169
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.892 Y136.263 Z4 F12000
G1 X138.024 Y136.621 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.37496
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01692
G1 X137.379 Y135.972 E.01702
G1 X137.667 Y136.343 E.01231
M73 P69 R6
G1 X137.977 Y136.584 E.01029
; WIPE_START
G1 X137.379 Y136.621 E-.22759
G1 X137.379 Y135.972 E-.2466
G1 X137.667 Y136.343 E-.17841
G1 X137.89 Y136.517 E-.1074
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.94 Y128.884 Z4 F12000
G1 X138.03 Y115.378 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.37344
G1 F6000
M204 S3000
G1 X137.659 Y115.664 E.01222
G1 X137.381 Y116.025 E.01189
G1 X137.382 Y115.378 E.01689
G1 X137.97 Y115.378 E.01536
; WIPE_START
G1 X137.659 Y115.664 E-.16042
G1 X137.381 Y116.025 E-.17311
G1 X137.382 Y115.378 E-.24588
G1 X137.857 Y115.378 E-.1806
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.489 Y115.419 Z4 F12000
G1 X161.391 Y115.505 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.45811
G1 F6000
M204 S3000
G1 X161.488 Y115.538 E.00338
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01133
G1 X162.121 Y115.98 E.01362
G1 X162.334 Y116.26 E.01133
G1 X162.511 Y116.645 E.0136
G1 X162.603 Y117.199 E.01808
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.8 E.04968
; LINE_WIDTH: 0.44852
G1 X162.542 Y135.257 E.01476
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01115
G1 X162.093 Y136.061 E.01868
G1 X161.74 Y136.333 E.01433
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.602 E.0181
; LINE_WIDTH: 0.43578
G1 X158.801 Y136.602 E.06207
; LINE_WIDTH: 0.43592
G1 X156.801 Y136.602 E.06209
; LINE_WIDTH: 0.43606
G1 X154.801 Y136.602 E.06211
; LINE_WIDTH: 0.4362
G1 X152.801 Y136.602 E.06213
; LINE_WIDTH: 0.43634
G1 X150.801 Y136.602 E.06215
; LINE_WIDTH: 0.43648
G1 X148.801 Y136.602 E.06218
; LINE_WIDTH: 0.43663
G1 X146.801 Y136.602 E.0622
; LINE_WIDTH: 0.43677
G1 X144.801 Y136.603 E.06222
; LINE_WIDTH: 0.43691
G1 X142.801 Y136.603 E.06224
; LINE_WIDTH: 0.43705
G1 X140.801 Y136.603 E.06227
; LINE_WIDTH: 0.43717
G1 X139.199 Y136.603 E.04987
; LINE_WIDTH: 0.449
G1 X138.743 Y136.543 E.01478
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01115
G1 X137.939 Y136.093 E.01868
G1 X137.667 Y135.74 E.01434
G1 X137.489 Y135.356 E.01361
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.167 E.05072
; LINE_WIDTH: 0.44906
G1 X137.461 Y116.724 E.01438
; LINE_WIDTH: 0.44999
G1 X137.581 Y116.41 E.01081
G1 X137.911 Y115.934 E.01861
G1 X138.266 Y115.662 E.01437
G1 X138.606 Y115.499 E.01215
G1 X139.136 Y115.399 E.01732
; LINE_WIDTH: 0.43856
G1 X141.136 Y115.399 E.06251
; LINE_WIDTH: 0.43842
G1 X143.136 Y115.399 E.06248
; LINE_WIDTH: 0.43828
G1 X145.136 Y115.399 E.06246
; LINE_WIDTH: 0.43814
G1 X147.136 Y115.398 E.06244
; LINE_WIDTH: 0.438
G1 X149.136 Y115.398 E.06242
; LINE_WIDTH: 0.43787
G1 X151.136 Y115.398 E.0624
; LINE_WIDTH: 0.43773
G1 X153.136 Y115.398 E.06237
; LINE_WIDTH: 0.43759
G1 X155.136 Y115.398 E.06235
; LINE_WIDTH: 0.43745
G1 X157.136 Y115.398 E.06233
; LINE_WIDTH: 0.43732
G1 X159.136 Y115.397 E.06231
; LINE_WIDTH: 0.43718
G1 X160.8 Y115.397 E.05185
; LINE_WIDTH: 0.45811
G3 X161.159 Y115.427 I.06 J1.456 E.01182
G1 X161.334 Y115.486 E.00606
M204 S10000
G1 X161.289 Y115.919 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01123
G3 X162.113 Y116.732 I-1.04 J1.313 E.02725
G1 X162.202 Y117.199 E.0153
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.186 E.01254
G1 X161.926 Y135.627 E.01579
G3 X161.269 Y136.113 I-1.335 J-1.117 E.02654
G1 X160.801 Y136.202 E.01532
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01254
G1 X138.373 Y135.926 E.01579
G3 X137.887 Y135.268 I1.117 J-1.335 E.02655
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.167 E.56701
G1 X137.86 Y116.803 E.01188
G1 X138.086 Y116.359 E.01603
G3 X138.509 Y115.989 I1.144 J.881 E.01819
G1 X138.989 Y115.819 E.01638
G1 X139.136 Y115.8 E.00475
G1 X160.8 Y115.798 E.69665
G1 X161.102 Y115.834 E.00978
G1 X161.235 Y115.894 E.00467
M204 S250
G1 X161.135 Y116.257 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.462 E.01205
G1 X161.73 Y116.816 E.01285
G1 X161.81 Y117.199 E.01167
G1 X161.81 Y134.801 E.52426
G1 X161.734 Y135.179 E.0115
G1 X161.539 Y135.484 E.01077
G1 X161.185 Y135.73 E.01285
G1 X160.801 Y135.81 E.01168
G1 X139.199 Y135.81 E.64341
G1 X138.821 Y135.734 E.0115
G1 X138.516 Y135.539 E.01077
G1 X138.27 Y135.184 E.01286
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.167 E.52522
G1 X138.267 Y116.819 E.01061
G1 X138.472 Y116.505 E.01116
G1 X138.808 Y116.272 E.0122
G1 X139.136 Y116.193 E.01004
G1 X160.8 Y116.19 E.6453
G1 X161.079 Y116.238 E.00843
; WIPE_START
M204 S3000
G1 X161.484 Y116.462 E-.17577
G1 X161.73 Y116.816 E-.16397
G1 X161.81 Y117.199 E-.14884
G1 X161.81 Y117.914 E-.27143
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.933 Y115.083 Z4 F12000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.264 E.0061
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I87.761 J.678 E.06225
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.801 E.04968
; LINE_WIDTH: 0.44457
G1 X162.99 Y135.009 E.00661
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.733 I231.642 J1.256 E.05544
G1 X162.924 Y136.924 E.00647
G1 X162.766 Y136.987 E.00548
G2 X160.801 Y136.995 I-.666 J83.258 E.06319
; LINE_WIDTH: 0.43578
G1 X158.801 Y136.995 E.06207
; LINE_WIDTH: 0.43592
G1 X156.801 Y136.995 E.06209
; LINE_WIDTH: 0.43606
G1 X154.801 Y136.995 E.06211
; LINE_WIDTH: 0.4362
G1 X152.801 Y136.996 E.06213
; LINE_WIDTH: 0.43634
G1 X150.801 Y136.996 E.06215
; LINE_WIDTH: 0.43648
G1 X148.801 Y136.996 E.06218
; LINE_WIDTH: 0.43663
G1 X146.801 Y136.996 E.0622
; LINE_WIDTH: 0.43677
G1 X144.801 Y136.996 E.06222
; LINE_WIDTH: 0.43691
G1 X142.801 Y136.997 E.06224
; LINE_WIDTH: 0.43705
G1 X140.801 Y136.997 E.06227
; LINE_WIDTH: 0.43717
G1 X139.199 Y136.997 E.04987
; LINE_WIDTH: 0.44643
G1 X138.991 Y136.992 E.00666
; LINE_WIDTH: 0.44999
G2 X137.288 Y136.991 I-1.165 J346.986 E.05475
G1 X137.075 Y136.924 E.00719
G1 X137.009 Y136.732 E.00653
G2 X137.003 Y134.801 I-91.414 J-.676 E.0621
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
M73 P69 R5
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.167 E.05072
; LINE_WIDTH: 0.44738
G1 X137.011 Y116.936 E.00741
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.284 I-430.634 J-1.243 E.05312
G1 X137.074 Y115.071 E.00713
G1 X137.268 Y115.009 E.00654
G2 X139.136 Y115.003 I.636 J-97.68 E.06005
; LINE_WIDTH: 0.43856
G1 X141.136 Y115.003 E.06251
; LINE_WIDTH: 0.43842
G1 X143.136 Y115.003 E.06248
; LINE_WIDTH: 0.43828
G1 X145.136 Y115.003 E.06246
; LINE_WIDTH: 0.43814
G1 X147.136 Y115.003 E.06244
; LINE_WIDTH: 0.438
G1 X149.136 Y115.003 E.06242
; LINE_WIDTH: 0.43787
G1 X151.136 Y115.003 E.0624
; LINE_WIDTH: 0.43773
G1 X153.136 Y115.003 E.06237
; LINE_WIDTH: 0.43759
G1 X155.136 Y115.003 E.06235
; LINE_WIDTH: 0.43745
G1 X157.136 Y115.003 E.06233
; LINE_WIDTH: 0.43732
G1 X159.136 Y115.003 E.06231
; LINE_WIDTH: 0.43718
G1 X160.8 Y115.003 E.05185
; LINE_WIDTH: 0.44266
G1 X160.963 Y115.006 E.00513
; LINE_WIDTH: 0.44999
G2 X162.754 Y115.01 I1.227 J-160.578 E.05758
G1 X162.877 Y115.06 E.0043
M204 S10000
G1 X163.182 Y114.762 F12000
G1 F6000
M204 S3000
G1 X163.192 Y114.768 E.00038
G1 X163.365 Y115.028 E.01006
G1 X163.397 Y115.264 E.00764
G1 X163.394 Y135.264 E.64311
G3 X163.373 Y136.9 I-33.441 J.377 E.05262
G1 X163.275 Y137.131 E.00807
; object ids of layer 18 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer18 end: 47,58
M625
G1 X163.046 Y137.335 E.00985
G1 X162.818 Y137.394 E.0076
G1 X138.818 Y137.398 E.77173
G3 X137.101 Y137.371 I-.426 J-27.781 E.05523
G1 X136.834 Y137.264 E.00923
G1 X136.671 Y137.046 E.00876
G1 X136.602 Y136.76 E.00947
G1 X136.606 Y115.283 E.69059
G1 X136.667 Y114.948 E.01096
G1 X136.89 Y114.695 E.01086
G1 X137.24 Y114.602 E.01164
G1 X161.24 Y114.603 E.77173
G3 X162.952 Y114.628 I.366 J33.394 E.05505
G1 X163.13 Y114.732 E.00663
M204 S250
G1 X163.385 Y114.413 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.574 Y114.587 E.00767
G1 X163.74 Y114.898 E.0105
G1 X163.789 Y115.264 E.01099
G1 X163.786 Y136.733 E.63948
G1 X163.696 Y137.213 E.01455
G1 X163.498 Y137.498 E.01035
G1 X163.213 Y137.696 E.01033
G1 X162.868 Y137.786 E.01062
G1 X137.315 Y137.79 E.76112
G1 X136.856 Y137.726 E.0138
G1 X136.589 Y137.576 E.00914
G1 X136.379 Y137.349 E.00921
G1 X136.249 Y137.067 E.00925
G1 X136.21 Y136.787 E.00841
G1 X136.214 Y115.267 E.64098
G1 X136.304 Y114.785 E.0146
G1 X136.476 Y114.528 E.00921
G1 X136.809 Y114.302 E.012
G1 X137.213 Y114.21 E.01234
G1 X162.455 Y114.211 E.75184
G1 X163.065 Y114.248 E.01822
G1 X163.34 Y114.375 E.009
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.574 Y114.587 E-.12042
G1 X163.74 Y114.898 E-.13394
G1 X163.789 Y115.264 E-.14018
G1 X163.789 Y116.226 E-.36547
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.662 Y118.957 Z4 F12000
G1 X116.391 Y134.391 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.778 E.04403
; LINE_WIDTH: 0.43731
G1 X110.979 Y117.603 E.43616
; LINE_WIDTH: 0.43719
G1 X115.021 Y117.603 E.12592
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.45 J.191 E.04402
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.75 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67798
G1 X95.26 Y134.72 E.00701
G1 X95.202 Y134.56 E.00547
G1 X95.202 Y117.463 E.54974
G1 X95.281 Y117.26 E.00701
G1 X95.441 Y117.202 E.00547
G1 X116.529 Y117.202 E.6781
G1 X116.737 Y117.271 E.00704
G1 X116.797 Y117.47 E.00667
G1 X116.798 Y134.537 E.5488
G1 X116.735 Y134.694 E.00545
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01029
G1 X94.955 Y134.98 E.00746
G3 X94.81 Y134.587 I.838 J-.532 E.01259
G1 X94.81 Y117.495 E.50908
G1 X94.868 Y117.155 E.01029
G1 X95.02 Y116.955 E.00748
G3 X95.414 Y116.81 I.531 J.837 E.01259
G1 X116.529 Y116.81 E.62893
G1 X116.824 Y116.858 E.0089
G3 X117.132 Y117.153 I-.223 J.542 E.01301
G1 X117.189 Y117.47 E.00958
G1 X117.19 Y134.505 E.50741
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.831 J-.549 E.00887
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14138
G1 X114.955 Y135.19 E-.61862
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.356 Y134.469 Z4 F12000
G1 X96.117 Y133.403 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X110.979 Y117.997 E.43616
; LINE_WIDTH: 0.43719
G1 X115.021 Y117.997 E.12592
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02423
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
M73 P70 R5
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z4 F12000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z4 F12000
G1 X96.026 Y117.961 Z4
G1 Z3.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z4 F12000
G1 X116.021 Y117.961 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.42144
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00141
; WIPE_START
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z4 F12000
G1 X116.021 Y133.957 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 19/40
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z4 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z4
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.37453
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01697
G1 X162.333 Y115.657 E.01228
G1 X161.976 Y115.379 E.01185
G1 X162.561 Y115.379 E.01531
; WIPE_START
G1 X162.62 Y116.027 E-.24729
G1 X162.333 Y115.657 E-.17812
G1 X161.976 Y115.379 E-.17186
G1 X162.404 Y115.379 E-.16273
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.484 Y123.011 Z4.2 F12000
G1 X162.618 Y135.98 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01678
G1 X161.971 Y136.622 E.01693
G1 X162.341 Y136.334 E.01226
G1 X162.581 Y136.027 E.01019
; WIPE_START
G1 X162.618 Y136.622 E-.22633
G1 X161.971 Y136.622 E-.246
G1 X162.341 Y136.334 E-.1781
G1 X162.519 Y136.107 E-.10957
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y136.267 Z4.2 F12000
G1 X138.024 Y136.621 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01693
G1 X137.379 Y135.972 E.01702
G1 X137.667 Y136.343 E.01231
G1 X137.977 Y136.584 E.0103
; WIPE_START
G1 X137.379 Y136.621 E-.22771
G1 X137.379 Y135.972 E-.24658
G1 X137.667 Y136.343 E-.17838
G1 X137.89 Y136.517 E-.10734
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y128.884 Z4.2 F12000
G1 X138.034 Y115.378 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.736 Y115.601 E.00975
G1 X137.382 Y116.021 E.01436
G1 X137.382 Y115.378 E.01681
G1 X137.975 Y115.378 E.0155
; WIPE_START
G1 X137.736 Y115.601 E-.12411
G1 X137.382 Y116.021 E-.2087
G1 X137.382 Y115.378 E-.24423
G1 X137.863 Y115.378 E-.18296
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.496 Y115.425 Z4.2 F12000
G1 X161.435 Y115.523 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y115.577 E.00508
G1 X162.061 Y115.907 E.01866
G1 X162.334 Y116.26 E.01434
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.0181
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.8 E.04968
; LINE_WIDTH: 0.44855
G1 X162.542 Y135.257 E.01477
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01116
G1 X162.092 Y136.062 E.01873
G1 X161.741 Y136.333 E.01426
G1 X161.357 Y136.51 E.0136
G1 X160.801 Y136.603 E.01813
; LINE_WIDTH: 0.43732
G1 X139.2 Y136.603 E.67298
; LINE_WIDTH: 0.44903
G1 X138.743 Y136.543 E.01478
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01116
G1 X137.939 Y136.093 E.01868
G1 X137.667 Y135.74 E.01433
G1 X137.489 Y135.356 E.0136
G1 X137.408 Y134.971 E.01267
; LINE_WIDTH: 0.44608
G1 X137.397 Y134.801 E.00543
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.44841
G1 X137.453 Y116.753 E.0134
; LINE_WIDTH: 0.44999
G1 X137.565 Y116.446 E.01051
G1 X137.908 Y115.938 E.01972
G3 X138.953 Y115.41 I1.445 J1.562 E.03811
; LINE_WIDTH: 0.4481
G1 X139.123 Y115.4 E.00546
; LINE_WIDTH: 0.43915
G1 X141.123 Y115.4 E.0626
; LINE_WIDTH: 0.43895
G1 X143.123 Y115.4 E.06257
; LINE_WIDTH: 0.43876
G1 X145.123 Y115.399 E.06254
; LINE_WIDTH: 0.43857
G1 X147.123 Y115.399 E.06251
; LINE_WIDTH: 0.43837
G1 X149.123 Y115.399 E.06248
; LINE_WIDTH: 0.43818
G1 X151.123 Y115.399 E.06245
; LINE_WIDTH: 0.43799
G1 X153.123 Y115.398 E.06242
; LINE_WIDTH: 0.4378
G1 X155.123 Y115.398 E.06239
; LINE_WIDTH: 0.4376
G1 X157.123 Y115.398 E.06235
; LINE_WIDTH: 0.43741
G1 X159.123 Y115.398 E.06232
; LINE_WIDTH: 0.43722
G1 X160.801 Y115.397 E.05226
; LINE_WIDTH: 0.44897
G1 X161.258 Y115.457 E.01479
; LINE_WIDTH: 0.44999
G1 X161.379 Y115.502 E.00414
M204 S10000
G1 X161.328 Y115.927 F12000
G1 F6000
M204 S3000
G1 X161.627 Y116.075 E.01073
G3 X162.113 Y116.731 I-1.116 J1.333 E.02652
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.801 E.56597
G1 X162.142 Y135.186 E.01254
G1 X161.926 Y135.627 E.01581
G3 X161.269 Y136.113 I-1.333 J-1.115 E.0265
G1 X160.801 Y136.202 E.01534
G1 X139.2 Y136.202 E.69459
G1 X138.814 Y136.142 E.01254
G1 X138.373 Y135.926 E.01581
G3 X137.887 Y135.269 I1.116 J-1.334 E.02652
G1 X137.807 Y134.901 E.01211
G1 X137.799 Y117.168 E.57022
G1 X137.852 Y116.828 E.01107
G1 X138.071 Y116.379 E.01605
G3 X138.467 Y116.012 I1.138 J.832 E.01748
G1 X138.962 Y115.825 E.01699
G1 X139.123 Y115.802 E.00525
G1 X160.801 Y115.798 E.69706
G1 X161.186 Y115.858 E.01254
G1 X161.274 Y115.901 E.00315
M204 S250
G1 X161.163 Y116.263 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y116.267 E.00048
G1 X161.484 Y116.462 E.01078
G1 X161.73 Y116.816 E.01284
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.8 E.52426
G1 X161.734 Y135.179 E.01151
G1 X161.538 Y135.484 E.01078
G1 X161.185 Y135.73 E.01283
G1 X160.801 Y135.81 E.01169
G1 X139.2 Y135.81 E.6434
G1 X138.821 Y135.734 E.01151
G1 X138.516 Y135.538 E.01078
G1 X138.27 Y135.185 E.01284
G1 X138.193 Y134.833 E.01072
G1 X138.191 Y117.168 E.52618
G1 X138.259 Y116.841 E.00994
G1 X138.459 Y116.518 E.01131
G1 X138.774 Y116.287 E.01165
G1 X139.123 Y116.194 E.01075
G1 X160.801 Y116.19 E.64569
G1 X161.105 Y116.251 E.00923
; WIPE_START
M204 S3000
G1 X161.179 Y116.267 E-.02896
G1 X161.484 Y116.462 E-.13754
G1 X161.73 Y116.816 E-.16375
G1 X161.81 Y117.199 E-.14901
G1 X161.81 Y117.938 E-.28074
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.892 Y115.05 Z4.2 F12000
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.216 E.00621
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I90.2 J.701 E.06378
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.8 E.04968
; LINE_WIDTH: 0.44483
G1 X162.99 Y135.009 E.00662
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.73 I242.384 J1.253 E.05534
G1 X162.932 Y136.922 E.00642
G1 X162.742 Y136.991 E.00653
G2 X160.801 Y136.997 I-.666 J93.125 E.06241
; LINE_WIDTH: 0.43732
G1 X139.2 Y136.997 E.67298
; LINE_WIDTH: 0.44655
G1 X138.991 Y136.993 E.00666
; LINE_WIDTH: 0.44999
G2 X137.288 Y136.991 I-1.212 J358.776 E.05476
G1 X137.075 Y136.925 E.00716
G1 X137.009 Y136.712 E.00715
G2 X137.003 Y134.801 I-90.378 J-.667 E.06148
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.44609
G1 X137.011 Y116.949 E.00695
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.234 I-283.358 J-1.228 E.05515
G1 X137.09 Y115.062 E.00609
G1 X137.268 Y115.009 E.00596
G2 X139.123 Y115.004 I.607 J-110.319 E.05964
; LINE_WIDTH: 0.43915
G1 X141.123 Y115.004 E.0626
; LINE_WIDTH: 0.43895
G1 X143.123 Y115.004 E.06257
; LINE_WIDTH: 0.43876
G1 X145.123 Y115.004 E.06254
; LINE_WIDTH: 0.43857
G1 X147.123 Y115.004 E.06251
; LINE_WIDTH: 0.43837
G1 X149.123 Y115.004 E.06248
; LINE_WIDTH: 0.43818
G1 X151.123 Y115.003 E.06245
; LINE_WIDTH: 0.43799
G1 X153.123 Y115.003 E.06242
; LINE_WIDTH: 0.4378
G1 X155.123 Y115.003 E.06239
; LINE_WIDTH: 0.4376
G1 X157.123 Y115.003 E.06235
; LINE_WIDTH: 0.43741
G1 X159.123 Y115.003 E.06232
; LINE_WIDTH: 0.43722
G1 X160.801 Y115.003 E.05226
; LINE_WIDTH: 0.44633
G1 X161.01 Y115.008 E.00667
; LINE_WIDTH: 0.44999
G2 X162.694 Y115.01 I1.213 J-333.823 E.05416
G1 X162.833 Y115.038 E.00456
M204 S10000
G1 X163.129 Y114.727 F12000
G1 F6000
M204 S3000
G1 X163.324 Y114.929 E.00902
G1 X163.397 Y115.216 E.00955
G1 X163.394 Y136.73 E.69178
G1 X163.333 Y137.054 E.01062
; object ids of layer 19 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer19 end: 47,58
M625
G1 X163.112 Y137.302 E.01068
G1 X162.765 Y137.398 E.01155
G1 X138.766 Y137.398 E.77173
G3 X137.086 Y137.368 I-.396 J-25.193 E.05402
G1 X136.857 Y137.282 E.00788
G1 X136.685 Y137.081 E.0085
G1 X136.602 Y136.748 E.01103
G1 X136.606 Y115.283 E.69022
G1 X136.668 Y114.942 E.01115
G1 X136.896 Y114.692 E.01087
G1 X137.24 Y114.602 E.01145
G1 X162.768 Y114.603 E.82085
G1 X163.08 Y114.695 E.01047
M204 S250
G1 X163.426 Y114.439 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.439 Y114.448 E.00048
G1 X163.67 Y114.733 E.01094
G3 X163.789 Y115.216 I-1.452 J.614 E.01488
G1 X163.786 Y136.868 E.64492
G1 X163.696 Y137.216 E.0107
M73 P71 R5
G3 X163.155 Y137.709 I-1.028 J-.585 E.02214
G1 X162.789 Y137.79 E.01119
G1 X137.315 Y137.79 E.75875
G1 X136.855 Y137.725 E.01385
G1 X136.621 Y137.6 E.00789
G1 X136.399 Y137.379 E.00933
G1 X136.275 Y137.146 E.00788
G1 X136.21 Y136.783 E.01097
G1 X136.214 Y115.283 E.64039
G3 X136.378 Y114.668 I1.274 J.011 E.01918
G1 X136.545 Y114.477 E.00755
G1 X136.813 Y114.301 E.00955
G1 X137.213 Y114.21 E.01223
G1 X162.694 Y114.211 E.75898
G1 X163.18 Y114.289 E.01467
G1 X163.374 Y114.408 E.00678
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.439 Y114.448 E-.02891
G1 X163.67 Y114.733 E-.13955
G1 X163.727 Y114.893 E-.06437
G1 X163.789 Y115.216 E-.1252
G1 X163.789 Y116.274 E-.40197
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.66 Y118.999 Z4.2 F12000
G1 X116.391 Y134.391 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-104.471 J-.212 E.04403
; LINE_WIDTH: 0.43721
G1 X95.603 Y131.021 E.06229
; LINE_WIDTH: 0.43706
G1 X95.603 Y129.021 E.06227
; LINE_WIDTH: 0.43692
G1 X95.604 Y127.021 E.06225
; LINE_WIDTH: 0.43678
G1 X95.604 Y125.021 E.06222
; LINE_WIDTH: 0.43664
G1 X95.604 Y123.021 E.0622
; LINE_WIDTH: 0.4365
G1 X95.604 Y121.021 E.06218
; LINE_WIDTH: 0.43636
G1 X95.604 Y119.021 E.06216
; LINE_WIDTH: 0.43622
G1 X95.604 Y118.978 E.00134
; LINE_WIDTH: 0.44999
G1 X95.612 Y117.609 E.04403
G2 X96.979 Y117.603 I.196 J-105.416 E.04396
; LINE_WIDTH: 0.43731
G1 X110.979 Y117.603 E.43616
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.603 E.12592
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.45 J.191 E.04402
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67798
G1 X95.25 Y134.712 E.00738
G1 X95.202 Y134.548 E.0055
G1 X95.204 Y117.414 E.55098
G1 X95.279 Y117.262 E.00542
G1 X95.438 Y117.202 E.00548
G1 X116.528 Y117.202 E.67817
G1 X116.727 Y117.265 E.0067
G1 X116.797 Y117.451 E.00638
G1 X116.798 Y134.537 E.54941
G1 X116.735 Y134.694 E.00545
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.548 J-.831 E.01065
G1 X94.81 Y134.583 E.00939
G1 X94.812 Y117.453 E.51022
G1 X94.866 Y117.158 E.00893
G1 X95.019 Y116.956 E.00757
G3 X95.413 Y116.81 I.565 J.923 E.01258
G1 X116.528 Y116.81 E.62894
G1 X116.823 Y116.858 E.0089
G1 X117.013 Y116.984 E.0068
G1 X117.152 Y117.202 E.0077
G1 X117.189 Y117.451 E.00749
G1 X117.19 Y134.505 E.50797
G1 X117.132 Y134.845 E.01029
G3 X116.933 Y135.066 I-.83 J-.547 E.00887
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14138
G1 X114.955 Y135.19 E-.61862
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.357 Y134.459 Z4.2 F12000
G1 X96.103 Y133.376 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44614
G1 X95.997 Y133.021 E.00543
; LINE_WIDTH: 0.43721
G1 X95.997 Y131.021 E.06229
; LINE_WIDTH: 0.43706
G1 X95.997 Y129.021 E.06227
; LINE_WIDTH: 0.43692
G1 X95.997 Y127.021 E.06225
; LINE_WIDTH: 0.43678
G1 X95.998 Y125.021 E.06222
; LINE_WIDTH: 0.43664
G1 X95.998 Y123.021 E.0622
; LINE_WIDTH: 0.4365
G1 X95.998 Y121.021 E.06218
; LINE_WIDTH: 0.43636
G1 X95.998 Y119.021 E.06216
; LINE_WIDTH: 0.43622
G1 X95.998 Y118.979 E.00133
; LINE_WIDTH: 0.44999
G1 X96.281 Y118.279 E.02426
G1 X96.808 Y118.008 E.01907
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X110.979 Y117.997 E.43616
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.997 E.12592
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02423
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.429 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00283
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.978 E.45156
G1 X96.568 Y118.568 E.01431
G1 X96.878 Y118.407 E.01122
G1 X115.021 Y118.398 E.58341
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.946 Y118.793 E.00338
G1 X114.979 Y118.79 E.53711
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00564
G1 X96.813 Y133.077 E.00251
; WIPE_START
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.355 Y123.458 Z4.2 F12000
G1 X96.027 Y117.961 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y118.002 E.00244
G1 X96.027 Y118.042 E.00244
G1 X96.051 Y118.002 E.00141
; WIPE_START
G1 X96.027 Y118.042 E-.17027
G1 X95.957 Y118.002 E-.29487
G1 X96.027 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y125.593 Z4.2 F12000
G1 X96.026 Y133.957 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17026
G1 X95.955 Y133.998 E-.29487
G1 X96.026 Y133.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y133.957 Z4.2 F12000
G1 X116.021 Y133.957 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; WIPE_START
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y126.324 Z4.2 F12000
G1 X116.021 Y117.961 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.42144
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 20/40
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z4.2 I.067 J1.215 P1  F12000
G1 X162.621 Y115.379 Z4.2
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.37453
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01698
G1 X162.416 Y115.756 E.00889
G1 X161.974 Y115.379 E.01522
G1 X162.561 Y115.379 E.01537
; WIPE_START
G1 X162.62 Y116.027 E-.24732
G1 X162.416 Y115.756 E-.12901
G1 X161.974 Y115.379 E-.22079
G1 X162.402 Y115.379 E-.16288
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.482 Y123.011 Z4.4 F12000
G1 X162.618 Y135.977 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01687
G1 X161.971 Y136.622 E.01693
G1 X162.243 Y136.416 E.00893
G1 X162.579 Y136.022 E.01353
; WIPE_START
G1 X162.618 Y136.622 E-.22825
G1 X161.971 Y136.622 E-.24606
G1 X162.243 Y136.416 E-.12971
G1 X162.51 Y136.104 E-.15598
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.879 Y136.264 Z4.4 F12000
G1 X138.023 Y136.618 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01687
G1 X137.378 Y135.971 E.01693
G1 X137.585 Y136.244 E.00895
G1 X137.978 Y136.579 E.0135
; WIPE_START
G1 X137.378 Y136.618 E-.22825
G1 X137.378 Y135.971 E-.24598
G1 X137.585 Y136.244 E-.13011
G1 X137.896 Y136.51 E-.15566
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.947 Y128.878 Z4.4 F12000
G1 X138.037 Y115.378 Z4.4
M73 P72 R5
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.37399
G1 F6000
M204 S3000
G1 X137.729 Y115.606 E.01004
G1 X137.382 Y116.021 E.01414
G1 X137.382 Y115.378 E.01681
G1 X137.978 Y115.378 E.01558
; WIPE_START
G1 X137.729 Y115.606 E-.12831
G1 X137.382 Y116.021 E-.2054
G1 X137.382 Y115.378 E-.24423
G1 X137.861 Y115.378 E-.18206
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.493 Y115.42 Z4.4 F12000
G1 X161.394 Y115.506 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.45808
G1 F6000
M204 S3000
G1 X161.488 Y115.538 E.00327
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01133
G1 X162.121 Y115.979 E.01362
G1 X162.334 Y116.26 E.01133
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.01809
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.8 E.04968
; LINE_WIDTH: 0.46001
G1 X162.568 Y135.194 E.01302
G1 X162.295 Y135.799 E.02187
; LINE_WIDTH: 0.44999
G1 X162.02 Y136.121 E.01362
G1 X161.739 Y136.334 E.01132
G1 X161.355 Y136.511 E.0136
G1 X160.801 Y136.603 E.01808
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.603 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.603 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.603 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.602 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.602 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.602 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.602 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.602 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.602 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.602 E.06208
; LINE_WIDTH: 0.43575
G1 X139.2 Y136.602 E.04968
; LINE_WIDTH: 0.45667
G3 X138.512 Y136.462 I-.059 J-1.469 E.02316
; LINE_WIDTH: 0.44999
G1 X138.201 Y136.296 E.01132
G1 X137.879 Y136.021 E.01362
G1 X137.667 Y135.74 E.01133
G1 X137.489 Y135.356 E.01361
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.44835
G1 X137.452 Y116.755 E.01334
; LINE_WIDTH: 0.44999
G3 X137.717 Y116.178 I1.823 J.487 E.0205
G3 X138.536 Y115.527 I1.582 J1.148 E.03407
G1 X138.954 Y115.41 E.01395
; LINE_WIDTH: 0.44805
G1 X139.124 Y115.4 E.00546
; LINE_WIDTH: 0.43911
G1 X141.124 Y115.4 E.06259
; LINE_WIDTH: 0.43891
G1 X143.124 Y115.399 E.06256
; LINE_WIDTH: 0.43872
G1 X145.124 Y115.399 E.06253
; LINE_WIDTH: 0.43853
G1 X147.124 Y115.399 E.0625
; LINE_WIDTH: 0.43834
G1 X149.124 Y115.399 E.06247
; LINE_WIDTH: 0.43815
G1 X151.124 Y115.399 E.06244
; LINE_WIDTH: 0.43796
G1 X153.124 Y115.398 E.06241
; LINE_WIDTH: 0.43777
G1 X155.124 Y115.398 E.06238
; LINE_WIDTH: 0.43758
G1 X157.124 Y115.398 E.06235
; LINE_WIDTH: 0.43739
G1 X159.124 Y115.398 E.06232
; LINE_WIDTH: 0.4372
G1 X160.8 Y115.397 E.05221
; LINE_WIDTH: 0.45808
G3 X161.159 Y115.427 I.06 J1.457 E.01183
G1 X161.337 Y115.487 E.00617
M204 S10000
G1 X161.293 Y115.921 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01111
G3 X162.113 Y116.732 I-1.039 J1.313 E.02725
G1 X162.202 Y117.199 E.01531
G1 X162.202 Y134.801 E.56598
G1 X162.163 Y135.123 E.01045
G1 X161.936 Y135.607 E.01719
G3 X161.268 Y136.113 I-1.312 J-1.039 E.02724
G1 X160.801 Y136.202 E.0153
G1 X139.199 Y136.202 E.6946
G1 X138.897 Y136.166 E.00978
G1 X138.393 Y135.937 E.01781
G3 X137.887 Y135.269 I1.039 J-1.313 E.02725
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.168 E.56699
G1 X137.852 Y116.829 E.01102
G1 X138.071 Y116.379 E.01609
G1 X138.213 Y116.213 E.00705
G1 X138.652 Y115.917 E.01702
G1 X139.124 Y115.802 E.01564
G1 X160.8 Y115.798 E.69701
G1 X161.102 Y115.834 E.00978
G1 X161.238 Y115.896 E.00479
M204 S250
G1 X161.138 Y116.259 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.462 E.01193
G1 X161.73 Y116.816 E.01285
G1 X161.81 Y117.199 E.01167
G1 X161.81 Y134.8 E.52426
G1 X161.757 Y135.112 E.0094
G1 X161.538 Y135.484 E.01287
G1 X161.184 Y135.73 E.01285
G1 X160.801 Y135.81 E.01166
G1 X139.2 Y135.81 E.64341
G1 X138.888 Y135.757 E.0094
G1 X138.516 Y135.539 E.01285
G1 X138.27 Y135.184 E.01286
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.168 E.52521
G1 X138.259 Y116.842 E.00991
G1 X138.412 Y116.573 E.00922
G1 X138.763 Y116.293 E.01341
G1 X139.124 Y116.194 E.01115
G1 X160.8 Y116.19 E.64564
G1 X161.083 Y116.238 E.00854
; WIPE_START
M204 S3000
G1 X161.484 Y116.462 E-.17437
G1 X161.73 Y116.816 E-.16398
G1 X161.81 Y117.199 E-.14888
G1 X161.81 Y117.917 E-.27277
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.908 Y115.059 Z4.4 F12000
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.224 E.00592
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I89.582 J.698 E.06354
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.8 E.04968
; LINE_WIDTH: 0.46001
G2 X162.987 Y135.973 I16.671 J.691 E.03863
; LINE_WIDTH: 0.44999
G1 X162.987 Y136.725 E.02418
G1 X162.932 Y136.923 E.00661
G1 X162.738 Y136.991 E.00661
G2 X160.801 Y136.997 I-.678 J91.807 E.06229
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.997 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.997 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.996 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.996 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.996 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.996 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.995 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.995 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.995 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.995 E.06208
; LINE_WIDTH: 0.43575
G1 X139.2 Y136.995 E.04968
; LINE_WIDTH: 0.44121
G1 X139.037 Y136.992 E.0051
; LINE_WIDTH: 0.44999
G2 X137.225 Y136.987 I-1.254 J135.387 E.05829
G1 X137.066 Y136.914 E.00562
G1 X137.009 Y136.732 E.00614
G2 X137.003 Y134.801 I-91.347 J-.677 E.0621
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.44597
G1 X137.01 Y116.951 E.00692
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.258 I-275.939 J-1.221 E.05444
G1 X137.064 Y115.084 E.00582
G1 X137.249 Y115.009 E.0064
G2 X139.124 Y115.004 I.609 J-114.005 E.0603
; LINE_WIDTH: 0.43911
G1 X141.124 Y115.004 E.06259
; LINE_WIDTH: 0.43891
G1 X143.124 Y115.004 E.06256
; LINE_WIDTH: 0.43872
G1 X145.124 Y115.004 E.06253
; LINE_WIDTH: 0.43853
G1 X147.124 Y115.004 E.0625
; LINE_WIDTH: 0.43834
G1 X149.124 Y115.004 E.06247
; LINE_WIDTH: 0.43815
G1 X151.124 Y115.003 E.06244
; LINE_WIDTH: 0.43796
G1 X153.124 Y115.003 E.06241
; LINE_WIDTH: 0.43777
G1 X155.124 Y115.003 E.06238
; LINE_WIDTH: 0.43758
G1 X157.124 Y115.003 E.06235
; LINE_WIDTH: 0.43739
G1 X159.124 Y115.003 E.06232
; LINE_WIDTH: 0.4372
G1 X160.8 Y115.003 E.05221
; LINE_WIDTH: 0.44263
G1 X160.963 Y115.006 E.00513
; LINE_WIDTH: 0.44999
G2 X162.696 Y115.01 I1.198 J-154.56 E.05572
G1 X162.849 Y115.045 E.00507
M204 S10000
G1 X163.131 Y114.728 F12000
G1 F6000
M204 S3000
G1 X163.318 Y114.918 E.00859
G1 X163.397 Y115.224 E.01015
G1 X163.394 Y136.725 E.69138
G1 X163.333 Y137.054 E.01077
; object ids of layer 20 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer20 end: 47,58
M625
G1 X163.111 Y137.303 E.01074
G1 X162.763 Y137.398 E.01157
G1 X137.176 Y137.394 E.82276
G1 X136.895 Y137.297 E.00956
G1 X136.693 Y137.104 E.009
G1 X136.602 Y136.76 E.01145
G1 X136.606 Y115.176 E.69403
G1 X136.702 Y114.897 E.0095
G1 X136.887 Y114.7 E.00869
G1 X137.229 Y114.602 E.01144
G1 X162.769 Y114.603 E.82126
G1 X163.082 Y114.696 E.0105
M204 S250
G1 X163.424 Y114.438 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.44 Y114.448 E.00055
G1 X163.663 Y114.719 E.01046
G3 X163.789 Y115.224 I-1.394 J.617 E.01556
G1 X163.786 Y136.733 E.64066
G1 X163.696 Y137.216 E.01463
G3 X163.167 Y137.705 I-1.039 J-.592 E.0218
G1 X162.788 Y137.79 E.01158
G1 X137.283 Y137.786 E.75967
G3 X136.301 Y137.187 I-.029 J-1.058 E.03624
G1 X136.21 Y136.787 E.01223
G1 X136.214 Y115.257 E.64127
G1 X136.288 Y114.822 E.01315
G1 X136.449 Y114.559 E.00921
G1 X136.682 Y114.359 E.00914
G3 X137.21 Y114.21 I.737 J1.599 E.01638
G1 X162.696 Y114.211 E.75912
G1 X163.18 Y114.289 E.01462
G1 X163.373 Y114.407 E.00674
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.44 Y114.448 E-.02981
G1 X163.663 Y114.719 E-.1334
G1 X163.724 Y114.883 E-.06636
G1 X163.789 Y115.224 E-.13187
G1 X163.789 Y116.273 E-.39855
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.66 Y118.998 Z4.4 F12000
G1 X116.388 Y134.391 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.196 J105.081 E.04396
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.778 E.04403
; LINE_WIDTH: 0.43731
G1 X110.979 Y117.603 E.43616
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.603 E.12592
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I102.593 J.204 E.04403
; LINE_WIDTH: 0.43692
G1 X116.396 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.396 Y124.979 E.06221
; LINE_WIDTH: 0.4366
G1 X116.396 Y128.979 E.12439
; LINE_WIDTH: 0.4364
G1 X116.396 Y130.979 E.06216
; LINE_WIDTH: 0.43629
G1 X116.396 Y132.979 E.06215
; LINE_WIDTH: 0.43619
G1 X116.396 Y133.021 E.00133
; LINE_WIDTH: 0.4451
G1 X116.391 Y133.227 E.00652
; LINE_WIDTH: 0.44999
G1 X116.389 Y134.331 E.03551
M204 S10000
G1 X116.72 Y134.74 F12000
G1 F6000
M204 S3000
G1 X116.56 Y134.798 E.00546
G1 X95.463 Y134.798 E.67837
G1 X95.25 Y134.712 E.00738
G1 X95.202 Y134.548 E.00551
G1 X95.202 Y117.463 E.54936
G1 X95.279 Y117.263 E.00691
G1 X95.438 Y117.202 E.00548
G1 X116.527 Y117.202 E.67815
G1 X116.727 Y117.265 E.00672
G1 X116.797 Y117.451 E.00639
G1 X116.796 Y134.587 E.55101
G1 X116.746 Y134.686 E.00358
M204 S250
G1 X116.854 Y135.113 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X116.587 Y135.19 I-.411 J-.921 E.0083
G1 X95.495 Y135.19 E.62823
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.549 J-.832 E.01066
G1 X94.81 Y134.583 E.0094
G1 X94.81 Y117.495 E.50896
G1 X94.868 Y117.155 E.01028
G1 X95.019 Y116.956 E.00744
G3 X95.413 Y116.81 I.55 J.881 E.0126
G1 X116.527 Y116.81 E.62892
G1 X116.824 Y116.858 E.00895
G1 X117.013 Y116.984 E.00677
G1 X117.152 Y117.202 E.0077
G1 X117.189 Y117.451 E.00749
G1 X117.188 Y134.545 E.50916
G1 X117.134 Y134.842 E.00899
G1 X116.98 Y135.045 E.0076
G3 X116.908 Y135.087 I-.538 J-.854 E.00249
; WIPE_START
M204 S3000
G1 X116.587 Y135.19 E-.12814
G1 X114.924 Y135.19 E-.63186
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.327 Y134.458 Z4.4 F12000
G1 X96.103 Y133.376 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X110.979 Y117.997 E.43616
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.997 E.12592
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.002 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.002 Y124.979 E.06221
; LINE_WIDTH: 0.4366
G1 X116.002 Y128.979 E.12439
; LINE_WIDTH: 0.4364
G1 X116.002 Y130.979 E.06216
; LINE_WIDTH: 0.43629
G1 X116.002 Y132.979 E.06215
; LINE_WIDTH: 0.43619
G1 X116.002 Y133.021 E.00133
; LINE_WIDTH: 0.4451
G1 X115.992 Y133.192 E.00542
; LINE_WIDTH: 0.44999
G1 X115.719 Y133.721 E.01914
G1 X115.192 Y133.992 E.01907
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.43 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00282
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.827 J.022 E.00462
G1 X115.432 Y133.433 E.01126
G1 X115.122 Y133.593 E.01122
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.00429
G1 X97.021 Y133.21 E.53614
M73 P73 R5
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.813 Y133.077 E.00251
; WIPE_START
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X104.358 Y132.209 Z4.4 F12000
G1 X116.02 Y133.958 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y133.998 E.00244
G1 X116.02 Y134.039 E.00244
G1 X116.043 Y133.998 E.00141
; WIPE_START
G1 X116.02 Y134.039 E-.17027
G1 X115.949 Y133.998 E-.29487
G1 X116.02 Y133.958 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y126.325 Z4.4 F12000
G1 X116.021 Y117.961 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.4214
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00141
; WIPE_START
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X108.389 Y117.961 Z4.4 F12000
G1 X96.026 Y117.961 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y125.594 Z4.4 F12000
G1 X96.026 Y133.957 Z4.4
G1 Z4
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 21/40
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
M106 S76.5
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z4.4 I.327 J1.172 P1  F12000
G1 X162.621 Y115.379 Z4.4
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.37451
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01697
G1 X162.415 Y115.756 E.0089
G1 X161.974 Y115.379 E.01521
G1 X162.561 Y115.379 E.01537
; WIPE_START
G1 X162.62 Y116.027 E-.24726
G1 X162.415 Y115.756 E-.12917
G1 X161.974 Y115.379 E-.22059
G1 X162.403 Y115.379 E-.16297
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.483 Y123.011 Z4.6 F12000
G1 X162.618 Y135.98 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.37394
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01678
G1 X161.971 Y136.622 E.01693
G1 X162.341 Y136.334 E.01226
G1 X162.581 Y136.027 E.01019
; WIPE_START
G1 X162.618 Y136.622 E-.22635
G1 X161.971 Y136.622 E-.24603
G1 X162.341 Y136.334 E-.17811
G1 X162.519 Y136.107 E-.10951
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y136.266 Z4.6 F12000
G1 X138.02 Y136.618 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01678
G1 X137.378 Y135.971 E.01693
G1 X137.666 Y136.341 E.01225
G1 X137.973 Y136.581 E.01019
; WIPE_START
G1 X137.378 Y136.618 E-.22627
G1 X137.378 Y135.971 E-.24597
G1 X137.666 Y136.341 E-.17808
G1 X137.893 Y136.519 E-.10968
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.944 Y128.887 Z4.6 F12000
G1 X138.035 Y115.378 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.37398
G1 F6000
M204 S3000
G1 X137.736 Y115.6 E.00974
G1 X137.382 Y116.021 E.01438
G1 X137.382 Y115.378 E.01681
G1 X137.975 Y115.378 E.01551
; WIPE_START
G1 X137.736 Y115.6 E-.12397
G1 X137.382 Y116.021 E-.20898
G1 X137.382 Y115.378 E-.24429
G1 X137.863 Y115.378 E-.18277
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.495 Y115.42 Z4.6 F12000
G1 X161.395 Y115.507 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.45805
G1 F6000
M204 S3000
G1 X161.488 Y115.538 E.00321
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01133
G1 X162.121 Y115.979 E.01362
G1 X162.333 Y116.26 E.01132
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.01811
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.801 E.04968
; LINE_WIDTH: 0.44856
G1 X162.542 Y135.258 E.01478
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.584 E.01116
G1 X162.092 Y136.062 E.01871
G1 X161.74 Y136.334 E.01429
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.603 E.0181
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.603 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.603 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.603 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.602 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.602 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.602 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.602 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.602 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.602 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.602 E.06208
; LINE_WIDTH: 0.43575
G1 X139.199 Y136.602 E.04969
; LINE_WIDTH: 0.44856
G1 X138.742 Y136.542 E.01477
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01115
G1 X137.938 Y136.092 E.01873
G1 X137.667 Y135.74 E.01428
G1 X137.489 Y135.356 E.01361
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.44832
G1 X137.452 Y116.756 E.01328
; LINE_WIDTH: 0.44999
G1 X137.563 Y116.449 E.01053
G1 X137.908 Y115.938 E.01982
G3 X138.965 Y115.409 I1.442 J1.563 E.0385
; LINE_WIDTH: 0.4475
G1 X139.135 Y115.399 E.00545
; LINE_WIDTH: 0.43856
G1 X141.135 Y115.399 E.06251
; LINE_WIDTH: 0.43841
G1 X143.135 Y115.399 E.06248
; LINE_WIDTH: 0.43827
G1 X145.135 Y115.399 E.06246
; LINE_WIDTH: 0.43813
G1 X147.135 Y115.398 E.06244
; LINE_WIDTH: 0.43799
G1 X149.135 Y115.398 E.06242
; LINE_WIDTH: 0.43785
G1 X151.135 Y115.398 E.06239
; LINE_WIDTH: 0.43771
G1 X153.135 Y115.398 E.06237
; LINE_WIDTH: 0.43757
G1 X155.135 Y115.398 E.06235
; LINE_WIDTH: 0.43743
G1 X157.135 Y115.398 E.06233
; LINE_WIDTH: 0.43728
G1 X159.135 Y115.397 E.0623
; LINE_WIDTH: 0.43714
G1 X160.8 Y115.397 E.05184
; LINE_WIDTH: 0.45805
G3 X161.159 Y115.427 I.06 J1.457 E.01182
G1 X161.338 Y115.488 E.00622
M204 S10000
G1 X161.294 Y115.921 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01104
G3 X162.113 Y116.731 I-1.038 J1.312 E.02724
G1 X162.202 Y117.199 E.01533
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.186 E.01255
G1 X161.925 Y135.627 E.0158
G3 X161.268 Y136.113 I-1.334 J-1.117 E.02652
G1 X160.801 Y136.202 E.01531
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01254
G1 X138.373 Y135.926 E.01578
G3 X137.887 Y135.269 I1.117 J-1.335 E.02654
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.168 E.567
G1 X137.851 Y116.831 E.01097
G1 X138.071 Y116.38 E.01613
G1 X138.183 Y116.238 E.00581
G3 X138.67 Y115.909 I1.052 J1.032 E.01901
G1 X139.136 Y115.8 E.01538
G1 X160.8 Y115.798 E.69665
G1 X161.102 Y115.834 E.00977
G1 X161.24 Y115.896 E.00485
M204 S250
G1 X161.14 Y116.26 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.461 E.01187
G1 X161.73 Y116.815 E.01284
G1 X161.81 Y117.199 E.01169
G1 X161.81 Y134.801 E.52427
G1 X161.733 Y135.18 E.01151
G1 X161.538 Y135.484 E.01077
G1 X161.184 Y135.73 E.01284
G1 X160.801 Y135.81 E.01167
G1 X139.199 Y135.81 E.64341
G1 X138.821 Y135.734 E.01151
G1 X138.516 Y135.539 E.01076
G1 X138.27 Y135.184 E.01286
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.168 E.52521
G1 X138.258 Y116.843 E.00987
G1 X138.448 Y116.527 E.01099
G1 X138.776 Y116.286 E.01212
G1 X139.136 Y116.193 E.01106
G1 X160.8 Y116.19 E.64531
G1 X161.085 Y116.238 E.00859
; WIPE_START
M204 S3000
G1 X161.484 Y116.461 E-.17366
G1 X161.73 Y116.815 E-.16384
G1 X161.81 Y117.199 E-.14909
G1 X161.81 Y117.919 E-.27341
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.908 Y115.059 Z4.6 F12000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.223 E.00589
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I89.939 J.698 E.06357
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.801 E.04968
; LINE_WIDTH: 0.44485
G1 X162.99 Y135.009 E.00663
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.776 I250.834 J1.281 E.05679
G1 X162.922 Y136.923 E.00517
G1 X162.751 Y136.991 E.00593
G2 X160.801 Y136.997 I-.685 J92.456 E.06272
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.997 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.997 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.996 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.996 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.996 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.996 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.995 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.995 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.995 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.995 E.06208
; LINE_WIDTH: 0.43575
G1 X139.199 Y136.995 E.04969
; LINE_WIDTH: 0.44856
G1 X138.703 Y136.988 E.01591
; LINE_WIDTH: 0.44999
G3 X137.202 Y136.979 I-.279 J-76.19 E.04825
G1 X137.062 Y136.904 E.00513
G1 X137.009 Y136.751 E.00518
G2 X137.003 Y134.801 I-92.296 J-.687 E.06273
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.44592
G1 X137.01 Y116.951 E.0069
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.225 I-275.573 J-1.238 E.05552
G1 X137.086 Y115.066 E.00562
G1 X137.268 Y115.009 E.00615
G2 X139.135 Y115.003 I.613 J-105.19 E.06004
; LINE_WIDTH: 0.43856
G1 X141.135 Y115.003 E.06251
; LINE_WIDTH: 0.43841
G1 X143.135 Y115.003 E.06248
; LINE_WIDTH: 0.43827
G1 X145.135 Y115.003 E.06246
; LINE_WIDTH: 0.43813
G1 X147.135 Y115.003 E.06244
; LINE_WIDTH: 0.43799
G1 X149.135 Y115.003 E.06242
; LINE_WIDTH: 0.43785
G1 X151.135 Y115.003 E.06239
; LINE_WIDTH: 0.43771
G1 X153.135 Y115.003 E.06237
; LINE_WIDTH: 0.43757
G1 X155.135 Y115.003 E.06235
; LINE_WIDTH: 0.43743
G1 X157.135 Y115.003 E.06233
; LINE_WIDTH: 0.43728
G1 X159.135 Y115.003 E.0623
; LINE_WIDTH: 0.43714
G1 X160.8 Y115.003 E.05184
; LINE_WIDTH: 0.4426
G1 X160.963 Y115.006 E.00513
; LINE_WIDTH: 0.44999
G2 X162.697 Y115.01 I1.199 J-154.152 E.05576
G1 X162.849 Y115.045 E.00503
M204 S10000
G1 X163.129 Y114.727 F12000
G1 F6000
M204 S3000
G1 X163.318 Y114.918 E.00865
G1 X163.397 Y115.223 E.01012
G1 X163.394 Y136.824 E.69459
G1 X163.3 Y137.1 E.00938
; object ids of layer 21 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer21 end: 47,58
M625
G1 X163.083 Y137.317 E.00988
G1 X162.771 Y137.398 E.01036
G1 X137.182 Y137.394 E.82283
G1 X136.884 Y137.294 E.01012
G1 X136.683 Y137.083 E.00937
G1 X136.602 Y136.771 E.01036
G1 X136.606 Y115.176 E.6944
G1 X136.703 Y114.895 E.00956
G1 X136.896 Y114.693 E.009
G1 X137.24 Y114.602 E.01146
G1 X162.77 Y114.603 E.82094
G1 X163.08 Y114.696 E.0104
M204 S250
G1 X163.423 Y114.438 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.44 Y114.448 E.0006
G1 X163.663 Y114.72 E.01045
G3 X163.789 Y115.223 I-1.4 J.619 E.01554
G1 X163.786 Y136.743 E.64098
G1 X163.713 Y137.178 E.01314
G1 X163.552 Y137.44 E.00916
G1 X163.281 Y137.662 E.01044
M73 P74 R5
G3 X162.79 Y137.79 I-.673 J-1.579 E.01515
G1 X137.132 Y137.786 E.76426
G1 X136.783 Y137.695 E.01073
G1 X136.561 Y137.553 E.00784
G1 X136.338 Y137.281 E.0105
G3 X136.21 Y136.79 I1.59 J-.676 E.01515
G1 X136.214 Y115.283 E.64061
G3 X136.813 Y114.301 I1.058 J-.029 E.03623
G1 X137.213 Y114.21 E.01224
G1 X162.697 Y114.211 E.75905
G1 X163.18 Y114.289 E.01459
G1 X163.372 Y114.406 E.00669
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.44 Y114.448 E-.03047
G1 X163.663 Y114.72 E-.13337
G1 X163.724 Y114.884 E-.06665
G1 X163.789 Y115.223 E-.13125
G1 X163.789 Y116.271 E-.39827
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.66 Y118.996 Z4.6 F12000
G1 X116.388 Y134.391 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.196 J104.919 E.04396
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-104.308 J-.212 E.04403
; LINE_WIDTH: 0.43721
G1 X95.603 Y131.021 E.06229
; LINE_WIDTH: 0.43707
G1 X95.603 Y129.021 E.06227
; LINE_WIDTH: 0.43693
G1 X95.604 Y127.021 E.06225
; LINE_WIDTH: 0.43679
G1 X95.604 Y125.021 E.06223
; LINE_WIDTH: 0.43665
G1 X95.604 Y123.021 E.0622
; LINE_WIDTH: 0.43651
G1 X95.604 Y121.021 E.06218
; LINE_WIDTH: 0.43637
G1 X95.604 Y119.021 E.06216
; LINE_WIDTH: 0.43623
G1 X95.604 Y118.978 E.00134
; LINE_WIDTH: 0.44999
G1 X95.612 Y117.609 E.04403
G2 X96.979 Y117.603 I.196 J-105.252 E.04396
; LINE_WIDTH: 0.43731
G1 X110.979 Y117.603 E.43616
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.603 E.12592
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I102.595 J.204 E.04403
; LINE_WIDTH: 0.43692
G1 X116.396 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.396 Y126.979 E.12443
; LINE_WIDTH: 0.4365
G1 X116.396 Y130.979 E.12436
; LINE_WIDTH: 0.4363
G1 X116.396 Y133.021 E.06348
; LINE_WIDTH: 0.44512
G1 X116.391 Y133.227 E.00652
; LINE_WIDTH: 0.44999
G1 X116.389 Y134.331 E.03551
M204 S10000
G1 X116.72 Y134.74 F12000
G1 F6000
M204 S3000
G1 X116.56 Y134.798 E.00547
G1 X95.463 Y134.798 E.67836
G1 X95.26 Y134.719 E.00702
G1 X95.202 Y134.56 E.00546
G1 X95.204 Y117.414 E.55134
G1 X95.28 Y117.26 E.00551
G1 X95.441 Y117.202 E.00548
G1 X116.527 Y117.202 E.67805
G1 X116.737 Y117.271 E.00709
G1 X116.797 Y117.47 E.00668
G1 X116.796 Y134.586 E.5504
G1 X116.746 Y134.686 E.00358
M204 S250
G1 X116.854 Y135.113 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X116.587 Y135.19 I-.41 J-.919 E.0083
G1 X95.495 Y135.19 E.62823
G1 X95.155 Y135.132 E.01028
G1 X94.955 Y134.98 E.00748
G3 X94.81 Y134.587 I.838 J-.531 E.01258
G1 X94.812 Y117.456 E.51027
G1 X94.866 Y117.158 E.009
G1 X95.02 Y116.955 E.00759
G3 X95.414 Y116.81 I.537 J.851 E.0126
G1 X116.527 Y116.81 E.62888
G1 X116.824 Y116.858 E.00895
G3 X117.132 Y117.153 I-.223 J.542 E.013
G1 X117.189 Y117.47 E.0096
G1 X117.188 Y134.545 E.50859
G1 X117.134 Y134.842 E.00899
G1 X116.98 Y135.045 E.00759
G3 X116.908 Y135.087 I-.537 J-.851 E.00249
; WIPE_START
M204 S3000
G1 X116.587 Y135.19 E-.12815
G1 X114.924 Y135.19 E-.63185
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.327 Y134.458 Z4.6 F12000
G1 X96.103 Y133.376 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44614
G1 X95.997 Y133.021 E.00543
; LINE_WIDTH: 0.43721
G1 X95.997 Y131.021 E.06229
; LINE_WIDTH: 0.43707
G1 X95.997 Y129.021 E.06227
; LINE_WIDTH: 0.43693
G1 X95.997 Y127.021 E.06225
; LINE_WIDTH: 0.43679
G1 X95.998 Y125.021 E.06223
; LINE_WIDTH: 0.43665
G1 X95.998 Y123.021 E.0622
; LINE_WIDTH: 0.43651
G1 X95.998 Y121.021 E.06218
; LINE_WIDTH: 0.43637
G1 X95.998 Y119.021 E.06216
; LINE_WIDTH: 0.43623
G1 X95.998 Y118.979 E.00133
; LINE_WIDTH: 0.44999
G1 X96.281 Y118.279 E.02426
G1 X96.808 Y118.008 E.01907
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X110.979 Y117.997 E.43616
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.997 E.12592
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.002 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.002 Y126.979 E.12443
; LINE_WIDTH: 0.4365
G1 X116.002 Y130.979 E.12436
; LINE_WIDTH: 0.4363
G1 X116.002 Y133.021 E.06348
; LINE_WIDTH: 0.44512
G1 X115.992 Y133.192 E.00542
; LINE_WIDTH: 0.44999
G1 X115.719 Y133.721 E.01914
G1 X115.192 Y133.992 E.01907
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.429 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00283
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.978 E.45156
G1 X96.568 Y118.568 E.01431
G1 X96.878 Y118.407 E.01122
G1 X115.021 Y118.398 E.58341
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.827 J.022 E.00462
G1 X115.432 Y133.433 E.01126
G1 X115.122 Y133.593 E.01122
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.946 Y118.793 E.00338
G1 X114.979 Y118.79 E.53711
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.00429
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00564
G1 X96.813 Y133.077 E.00251
; WIPE_START
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P74 R4
G1 X96.355 Y123.458 Z4.6 F12000
G1 X96.027 Y117.961 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y118.002 E.00244
G1 X96.027 Y118.042 E.00244
G1 X96.051 Y118.002 E.00141
; WIPE_START
G1 X96.027 Y118.042 E-.17027
G1 X95.957 Y118.002 E-.29487
G1 X96.027 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y125.593 Z4.6 F12000
G1 X96.026 Y133.957 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17026
G1 X95.955 Y133.998 E-.29487
G1 X96.026 Y133.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y133.957 Z4.6 F12000
G1 X116.02 Y133.958 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y133.998 E.00244
G1 X116.02 Y134.039 E.00244
G1 X116.043 Y133.998 E.00141
; WIPE_START
G1 X116.02 Y134.039 E-.17027
G1 X115.949 Y133.998 E-.29487
G1 X116.02 Y133.958 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y126.325 Z4.6 F12000
G1 X116.021 Y117.961 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.4214
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 22/40
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
M106 S81.6
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z4.6 I-.787 J.928 P1  F12000
G1 X138.024 Y136.621 Z4.6
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01693
G1 X137.379 Y135.972 E.01702
G1 X137.667 Y136.343 E.01231
G1 X137.977 Y136.584 E.0103
; WIPE_START
G1 X137.379 Y136.621 E-.22767
G1 X137.379 Y135.972 E-.24659
G1 X137.667 Y136.343 E-.17839
G1 X137.89 Y136.517 E-.10734
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.52 Y136.351 Z4.8 F12000
G1 X162.618 Y135.98 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01678
G1 X161.971 Y136.622 E.01693
G1 X162.341 Y136.334 E.01226
G1 X162.581 Y136.027 E.0102
; WIPE_START
G1 X162.618 Y136.622 E-.22636
G1 X161.971 Y136.622 E-.24608
G1 X162.341 Y136.334 E-.17816
G1 X162.518 Y136.108 E-.10941
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.556 Y128.475 Z4.8 F12000
G1 X162.621 Y115.379 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.37451
G1 F6000
M204 S3000
G1 X162.62 Y116.027 E.01697
G1 X162.333 Y115.657 E.01228
G1 X161.976 Y115.379 E.01184
G1 X162.561 Y115.379 E.0153
M204 S10000
G1 X162.892 Y115.05 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.216 E.0062
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I89.959 J.702 E.06379
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.8 E.04968
; LINE_WIDTH: 0.44457
G1 X162.99 Y135.009 E.00662
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.733 I231.894 J1.256 E.05542
G1 X162.943 Y136.909 E.00586
G1 X162.751 Y136.991 E.00671
G2 X160.801 Y136.997 I-.671 J93.35 E.06272
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.997 E.67298
; LINE_WIDTH: 0.44656
G1 X138.991 Y136.993 E.00666
; LINE_WIDTH: 0.44999
G2 X137.301 Y136.991 I-1.205 J353.791 E.05433
G1 X137.075 Y136.93 E.00751
G1 X137.009 Y136.712 E.00731
G2 X137.003 Y134.801 I-90.411 J-.667 E.06148
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.44979
G1 X137.012 Y116.912 E.0082
; LINE_WIDTH: 0.44999
G1 X137.013 Y115.225 E.05428
G1 X137.086 Y115.066 E.00561
G1 X137.268 Y115.009 E.00615
G1 X138.647 Y115.009 E.04434
; LINE_WIDTH: 0.4495
G1 X139.199 Y115.003 E.01773
; LINE_WIDTH: 0.43729
G1 X149.199 Y115.003 E.31152
; LINE_WIDTH: 0.43716
G1 X157.199 Y115.003 E.24914
; LINE_WIDTH: 0.43706
G1 X160.801 Y115.003 E.11213
; LINE_WIDTH: 0.44631
G1 X161.01 Y115.008 E.00667
; LINE_WIDTH: 0.44999
G2 X162.698 Y115.01 I1.215 J-331.046 E.05428
G1 X162.833 Y115.038 E.00444
M204 S10000
G1 X163.126 Y114.724 F12000
G1 F6000
M204 S3000
G1 X163.322 Y114.925 E.00905
M73 P75 R4
G1 X163.397 Y115.216 E.00965
G1 X163.394 Y136.733 E.69187
G1 X163.332 Y137.058 E.01064
; object ids of layer 22 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer22 end: 47,58
M625
G1 X163.113 Y137.3 E.0105
G1 X162.771 Y137.398 E.01143
G1 X138.771 Y137.398 E.77173
G3 X137.108 Y137.376 I-.399 J-32.829 E.0535
G1 X136.848 Y137.275 E.00897
G1 X136.695 Y137.092 E.00768
G1 X136.602 Y136.748 E.01144
G1 X136.606 Y115.176 E.69366
G1 X136.703 Y114.895 E.00957
G1 X136.896 Y114.693 E.00901
G1 X137.24 Y114.602 E.01145
G1 X162.772 Y114.603 E.82098
G1 X163.076 Y114.694 E.01021
M204 S250
G1 X163.421 Y114.437 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.44 Y114.448 E.00064
G1 X163.668 Y114.73 E.0108
G3 X163.789 Y115.216 I-1.476 J.625 E.01499
G1 X163.786 Y136.733 E.64088
G1 X163.695 Y137.217 E.01467
G1 X163.553 Y137.44 E.0079
G1 X163.317 Y137.641 E.00921
G3 X162.79 Y137.79 I-.73 J-1.574 E.01638
G1 X137.315 Y137.79 E.75881
G1 X136.895 Y137.739 E.0126
G1 X136.618 Y137.598 E.00926
G1 X136.425 Y137.413 E.00795
G1 X136.274 Y137.144 E.00921
G1 X136.21 Y136.783 E.01091
G1 X136.214 Y115.283 E.64038
G3 X136.813 Y114.301 I1.058 J-.029 E.03624
G1 X137.213 Y114.21 E.01223
G1 X162.698 Y114.211 E.75909
G1 X163.18 Y114.289 E.01454
G1 X163.37 Y114.406 E.00665
; WIPE_START
M204 S3000
G1 X163.44 Y114.448 E-.03098
G1 X163.668 Y114.73 E-.13778
G1 X163.726 Y114.888 E-.06413
G1 X163.789 Y115.216 E-.12686
G1 X163.789 Y116.269 E-.40024
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.438 Y115.524 Z4.8 F12000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.584 Y115.577 E.00499
G1 X162.061 Y115.907 E.01865
G1 X162.334 Y116.26 E.01435
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.01809
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.8 E.04968
; LINE_WIDTH: 0.44852
G1 X162.542 Y135.258 E.01477
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.584 E.01116
G1 X162.092 Y136.062 E.01871
G1 X161.74 Y136.334 E.01429
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.603 E.0181
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.603 E.67298
; LINE_WIDTH: 0.44903
G1 X138.743 Y136.543 E.01478
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01115
G1 X137.939 Y136.093 E.01868
G1 X137.666 Y135.74 E.01434
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.44993
G1 X137.476 Y116.674 E.01607
G1 X137.62 Y116.337 E.01179
G1 X137.922 Y115.919 E.01656
G1 X138.337 Y115.62 E.01647
G1 X138.693 Y115.473 E.01237
; LINE_WIDTH: 0.4495
G1 X139.199 Y115.397 E.01644
; LINE_WIDTH: 0.43729
G1 X149.199 Y115.397 E.31152
; LINE_WIDTH: 0.43716
G1 X157.199 Y115.397 E.24914
; LINE_WIDTH: 0.43706
G1 X160.801 Y115.397 E.11213
; LINE_WIDTH: 0.44896
G1 X161.258 Y115.458 E.01479
; LINE_WIDTH: 0.44999
G1 X161.382 Y115.503 E.00423
M204 S10000
G1 X161.331 Y115.929 F12000
G1 F6000
M204 S3000
G1 X161.627 Y116.074 E.01062
G3 X162.113 Y116.732 I-1.118 J1.335 E.02654
G1 X162.202 Y117.199 E.01531
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.186 E.01255
G1 X161.925 Y135.627 E.01581
G3 X161.268 Y136.113 I-1.334 J-1.117 E.02652
G1 X160.801 Y136.202 E.01531
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01254
G1 X138.623 Y136.072 E.00656
G1 X138.239 Y135.818 E.01481
G1 X137.991 Y135.494 E.0131
G1 X137.887 Y135.269 E.008
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.168 E.567
G1 X137.874 Y116.761 E.01329
G1 X138.137 Y116.296 E.01718
G3 X138.772 Y115.872 I1.225 J1.146 E.0248
G1 X139.199 Y115.798 E.01393
G1 X160.801 Y115.798 E.69461
G1 X161.187 Y115.858 E.01255
G1 X161.277 Y115.902 E.00323
M204 S250
G1 X161.166 Y116.264 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.18 Y116.267 E.00041
G1 X161.484 Y116.461 E.01076
G1 X161.73 Y116.816 E.01285
G1 X161.81 Y117.199 E.01167
G1 X161.81 Y134.8 E.52426
G1 X161.733 Y135.179 E.01152
G1 X161.538 Y135.484 E.01078
G1 X161.184 Y135.73 E.01284
G1 X160.801 Y135.81 E.01168
G1 X139.199 Y135.81 E.64341
G1 X138.821 Y135.734 E.0115
G1 X138.516 Y135.538 E.01078
G1 X138.27 Y135.184 E.01285
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.168 E.52521
G1 X138.284 Y116.781 E.01185
G1 X138.515 Y116.462 E.01171
G1 X138.849 Y116.256 E.0117
G1 X139.199 Y116.19 E.01062
G1 X160.801 Y116.19 E.64342
G1 X161.107 Y116.252 E.00931
; WIPE_START
M204 S3000
G1 X161.18 Y116.267 E-.02803
G1 X161.484 Y116.461 E-.13727
G1 X161.73 Y116.816 E-.16398
G1 X161.81 Y117.199 E-.14892
G1 X161.81 Y117.941 E-.2818
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.217 Y117.167 Z4.8 F12000
G1 X137.587 Y115.471 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.70174
G1 F4553.596
M204 S3000
G2 X137.628 Y115.542 I-.036 J.068 E.02074
; OBJECT_ID: 47
; WIPE_START
G1 X137.587 Y115.613 E-.15201
G1 X137.504 Y115.613 E-.152
G1 X137.463 Y115.542 E-.152
G1 X137.505 Y115.471 E-.15201
G1 X137.587 Y115.471 E-.15198
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X131.893 Y120.553 Z4.8 F12000
G1 X116.391 Y134.391 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.778 E.04403
; LINE_WIDTH: 0.43731
G1 X112.979 Y117.603 E.49846
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.603 E.06363
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.458 J.191 E.04403
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.715 Y134.74 F12000
G1 F6000
M204 S3000
G1 X116.562 Y134.798 E.00525
G1 X95.463 Y134.798 E.67843
G1 X95.262 Y134.721 E.00692
G1 X95.202 Y134.562 E.00549
G1 X95.202 Y117.463 E.54981
G1 X95.281 Y117.26 E.00702
G1 X95.441 Y117.202 E.00547
G1 X116.526 Y117.202 E.67803
G1 X116.734 Y117.27 E.00703
G1 X116.797 Y117.465 E.00661
G1 X116.798 Y134.537 E.54893
G1 X116.74 Y134.688 E.00522
M204 S250
G1 X116.854 Y135.11 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.84 Y135.118 E.00048
G3 X116.587 Y135.19 I-.408 J-.952 E.00785
G1 X95.495 Y135.19 E.62824
G1 X95.155 Y135.132 E.01028
G1 X94.956 Y134.981 E.00744
G3 X94.81 Y134.587 I.879 J-.549 E.0126
G1 X94.81 Y117.495 E.5091
G1 X94.868 Y117.155 E.01028
G1 X95.02 Y116.955 E.00749
G3 X95.414 Y116.81 I.531 J.837 E.01259
G1 X116.526 Y116.81 E.62886
G1 X116.824 Y116.858 E.00897
G3 X117.137 Y117.164 I-.224 J.542 E.01337
G1 X117.189 Y117.465 E.00911
G1 X117.19 Y134.505 E.50753
G1 X117.132 Y134.845 E.01029
G1 X116.981 Y135.044 E.00744
G1 X116.908 Y135.083 E.00246
; WIPE_START
M204 S3000
G1 X116.84 Y135.118 E-.02897
G1 X116.587 Y135.19 E-.09994
G1 X114.926 Y135.19 E-.6311
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.328 Y134.468 Z4.8 F12000
G1 X96.117 Y133.403 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X112.979 Y117.997 E.49846
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.997 E.06363
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z4.8 F12000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z4.8 F12000
G1 X96.026 Y117.961 Z4.8
G1 Z4.4
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
M73 P76 R4
G1 X103.658 Y117.961 Z4.8 F12000
G1 X116.021 Y117.961 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.42148
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; WIPE_START
G1 X116.021 Y118.043 E-.17025
G1 X115.95 Y118.002 E-.29488
G1 X116.021 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z4.8 F12000
G1 X116.021 Y133.957 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 23/40
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
M106 S79.05
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z4.8 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z4.8
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.37451
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01698
G1 X162.415 Y115.756 E.00891
G1 X161.974 Y115.379 E.0152
G1 X162.561 Y115.379 E.01536
; WIPE_START
G1 X162.621 Y116.027 E-.24733
G1 X162.415 Y115.756 E-.12922
G1 X161.974 Y115.379 E-.22055
G1 X162.403 Y115.379 E-.16291
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.484 Y123.011 Z5 F12000
G1 X162.621 Y135.976 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.621 Y136.621 E.01692
G1 X161.972 Y136.621 E.01703
G1 X162.343 Y136.333 E.01232
G1 X162.584 Y136.023 E.0103
; WIPE_START
G1 X162.621 Y136.621 E-.22762
G1 X161.972 Y136.621 E-.24672
G1 X162.343 Y136.333 E-.17852
G1 X162.516 Y136.111 E-.10714
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y136.27 Z5 F12000
G1 X138.024 Y136.621 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01692
G1 X137.379 Y135.972 E.01702
G1 X137.667 Y136.343 E.01231
G1 X137.977 Y136.584 E.0103
; WIPE_START
G1 X137.379 Y136.621 E-.22765
G1 X137.379 Y135.972 E-.2466
G1 X137.667 Y136.343 E-.17841
G1 X137.89 Y136.517 E-.10734
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.941 Y128.884 Z5 F12000
G1 X138.033 Y115.381 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.3729
G1 F6000
M204 S3000
G1 X137.731 Y115.605 E.0098
G1 X137.381 Y116.023 E.0142
G1 X137.381 Y115.381 E.01673
G1 X137.973 Y115.381 E.01541
; WIPE_START
G1 X137.731 Y115.605 E-.1253
G1 X137.381 Y116.023 E-.20699
G1 X137.381 Y115.381 E-.24388
G1 X137.865 Y115.381 E-.18383
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.497 Y115.422 Z5 F12000
G1 X161.398 Y115.508 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.45791
G1 F6000
M204 S3000
G1 X161.488 Y115.538 E.00311
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01133
G1 X162.121 Y115.979 E.01362
G1 X162.333 Y116.26 E.01132
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.01811
; LINE_WIDTH: 0.43693
G1 X162.603 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.603 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.603 Y134.801 E.17445
; LINE_WIDTH: 0.44897
G1 X162.543 Y135.258 E.01478
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01115
G1 X162.093 Y136.061 E.01868
G1 X161.74 Y136.334 E.01436
G1 X161.355 Y136.511 E.0136
G1 X160.801 Y136.603 E.01808
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.603 E.67298
; LINE_WIDTH: 0.44903
G1 X138.742 Y136.543 E.01479
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01115
G1 X137.939 Y136.093 E.01867
G1 X137.666 Y135.74 E.01434
G1 X137.489 Y135.356 E.0136
G1 X137.408 Y134.971 E.01266
; LINE_WIDTH: 0.44608
G1 X137.397 Y134.801 E.00543
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.44824
G1 X137.451 Y116.76 E.01317
; LINE_WIDTH: 0.44999
G1 X137.562 Y116.452 E.01052
G1 X137.907 Y115.939 E.01988
G3 X138.547 Y115.523 I1.334 J1.349 E.02471
G1 X138.965 Y115.41 E.01393
; LINE_WIDTH: 0.44581
G1 X139.135 Y115.4 E.00543
; LINE_WIDTH: 0.43689
G1 X160.8 Y115.397 E.67424
; LINE_WIDTH: 0.45791
G3 X161.159 Y115.427 I.06 J1.458 E.01182
G1 X161.341 Y115.489 E.00632
M204 S10000
G1 X161.297 Y115.923 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01094
G3 X162.113 Y116.731 I-1.039 J1.312 E.02724
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.186 E.01254
G1 X161.926 Y135.627 E.01579
G3 X161.268 Y136.113 I-1.336 J-1.118 E.02656
G1 X160.801 Y136.202 E.0153
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01254
G1 X138.373 Y135.926 E.01579
G3 X137.887 Y135.268 I1.117 J-1.335 E.02654
G1 X137.807 Y134.901 E.0121
G1 X137.799 Y117.168 E.57022
G1 X137.85 Y116.833 E.01088
G1 X138.07 Y116.38 E.01618
G3 X138.659 Y115.914 I1.298 J1.035 E.02438
G1 X139.135 Y115.8 E.01574
G1 X160.8 Y115.798 E.69666
G1 X161.102 Y115.834 E.00978
G1 X161.243 Y115.898 E.00496
M204 S250
G1 X161.143 Y116.261 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.462 E.01177
G1 X161.73 Y116.815 E.01284
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.801 E.52427
G1 X161.734 Y135.179 E.01151
G1 X161.539 Y135.484 E.01077
G1 X161.184 Y135.73 E.01287
G1 X160.801 Y135.81 E.01166
G1 X139.199 Y135.81 E.64341
G1 X138.821 Y135.734 E.01151
G1 X138.516 Y135.539 E.01077
G1 X138.27 Y135.184 E.01285
G1 X138.193 Y134.833 E.01071
G1 X138.191 Y117.168 E.52618
G1 X138.257 Y116.846 E.0098
G1 X138.458 Y116.519 E.01142
G1 X138.768 Y116.291 E.01146
G1 X139.135 Y116.193 E.01133
G1 X160.8 Y116.19 E.64531
G1 X161.088 Y116.239 E.0087
; WIPE_START
M204 S3000
G1 X161.484 Y116.462 E-.17242
G1 X161.73 Y116.815 E-.16387
G1 X161.81 Y117.199 E-.14902
G1 X161.81 Y117.922 E-.27469
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.894 Y115.05 Z5 F12000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.221 E.00631
; LINE_WIDTH: 0.45008
G2 X162.997 Y117.199 I91.038 J.684 E.06362
; LINE_WIDTH: 0.43693
G1 X162.997 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.997 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.997 Y134.801 E.17445
; LINE_WIDTH: 0.44622
G1 X162.993 Y135.009 E.00666
; LINE_WIDTH: 0.44999
G2 X162.991 Y136.722 I329.646 J1.207 E.05506
G1 X162.926 Y136.923 E.0068
G1 X162.712 Y136.991 E.00722
G2 X160.801 Y136.997 I-.653 J91.265 E.06147
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.997 E.67298
; LINE_WIDTH: 0.44656
G1 X138.991 Y136.993 E.00666
; LINE_WIDTH: 0.44999
G2 X137.315 Y136.991 I-1.201 J356.425 E.05387
G1 X137.081 Y136.935 E.00774
G1 X137.009 Y136.732 E.00694
G2 X137.003 Y134.801 I-91.408 J-.676 E.0621
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.44579
G1 X137.01 Y116.953 E.00685
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.267 I-259.213 J-1.21 E.0542
G1 X137.076 Y115.076 E.00647
G1 X137.234 Y115.013 E.00548
G2 X139.135 Y115.006 I.609 J-95.701 E.06112
; LINE_WIDTH: 0.43689
G1 X160.8 Y115.003 E.67424
; LINE_WIDTH: 0.44246
G1 X160.963 Y115.006 E.00513
; LINE_WIDTH: 0.44999
G2 X162.699 Y115.01 I1.18 J-151.752 E.05584
G1 X162.835 Y115.038 E.00445
M204 S10000
G1 X163.128 Y114.725 F12000
G1 F6000
M204 S3000
G1 X163.314 Y114.912 E.00849
G1 X163.397 Y115.195 E.00947
G1 X163.398 Y135.195 E.64311
G3 X163.376 Y136.892 I-33.551 J.417 E.05459
G1 X163.278 Y137.147 E.00878
; object ids of layer 23 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer23 end: 47,58
M625
G1 X163.081 Y137.315 E.00831
G1 X162.748 Y137.398 E.01103
G1 X138.748 Y137.398 E.77173
G3 X137.081 Y137.367 I-.387 J-24.369 E.05364
G1 X136.829 Y137.261 E.00878
G1 X136.686 Y137.069 E.0077
G1 X136.602 Y136.76 E.0103
G1 X136.605 Y116.76 E.64311
G3 X136.627 Y115.1 I34.681 J-.377 E.05338
G1 X136.725 Y114.869 E.00808
G1 X136.954 Y114.665 E.00984
G1 X137.182 Y114.606 E.0076
G1 X162.773 Y114.603 E.8229
G1 X163.078 Y114.695 E.01024
M204 S250
G1 X163.42 Y114.436 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.44 Y114.448 E.00068
G1 X163.661 Y114.718 E.01039
G3 X163.789 Y115.195 I-2.09 J.816 E.01474
G1 X163.79 Y136.685 E.64011
G1 X163.739 Y137.105 E.0126
G1 X163.599 Y137.38 E.00921
G1 X163.379 Y137.6 E.00927
G1 X163.145 Y137.725 E.00789
G1 X162.783 Y137.79 E.01097
G1 X137.315 Y137.79 E.75858
G1 X136.856 Y137.726 E.0138
G1 X136.587 Y137.575 E.0092
G1 X136.403 Y137.384 E.00789
G1 X136.248 Y137.065 E.01056
G1 X136.21 Y136.787 E.00836
G1 X136.214 Y115.267 E.64099
G1 X136.304 Y114.787 E.01455
G1 X136.502 Y114.502 E.01035
G1 X136.787 Y114.304 E.01033
G1 X137.132 Y114.214 E.01062
G1 X162.699 Y114.211 E.76155
G1 X163.18 Y114.289 E.01452
G1 X163.369 Y114.405 E.0066
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.44 Y114.448 E-.03152
G1 X163.661 Y114.718 E-.13252
G1 X163.718 Y114.881 E-.06565
G1 X163.789 Y115.195 E-.12233
G1 X163.789 Y116.268 E-.40798
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.66 Y118.994 Z5 F12000
G1 X116.391 Y134.391 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.778 E.04403
; LINE_WIDTH: 0.43731
G1 X114.979 Y117.603 E.56077
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.603 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.459 J.191 E.04403
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67799
G1 X95.26 Y134.719 E.00701
G1 X95.202 Y134.56 E.00546
G1 X95.202 Y117.463 E.54974
G1 X95.288 Y117.251 E.00738
G1 X95.452 Y117.202 E.00551
G1 X116.526 Y117.202 E.67764
G1 X116.727 Y117.265 E.00678
G1 X116.797 Y117.451 E.00639
G1 X116.798 Y134.537 E.5494
G1 X116.735 Y134.694 E.00545
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G1 X94.955 Y134.98 E.00748
G3 X94.81 Y134.587 I.838 J-.532 E.01258
G1 X94.81 Y117.495 E.50909
G1 X94.868 Y117.155 E.01028
G3 X95.114 Y116.898 I.83 J.547 E.01066
G1 X95.417 Y116.81 E.0094
G1 X116.526 Y116.81 E.62873
G1 X116.824 Y116.858 E.00898
G1 X117.013 Y116.985 E.00679
G1 X117.152 Y117.202 E.00769
M73 P77 R4
G1 X117.189 Y117.451 E.00749
G1 X117.19 Y134.505 E.50797
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.83 J-.548 E.00887
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14135
G1 X114.955 Y135.19 E-.61866
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.356 Y134.469 Z5 F12000
G1 X96.117 Y133.403 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X114.979 Y117.997 E.56077
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.997 E.00134
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z5 F12000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z5 F12000
G1 X96.026 Y117.961 Z5
G1 Z4.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z5 F12000
G1 X116.021 Y117.961 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.42148
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; WIPE_START
G1 X116.021 Y118.043 E-.17025
G1 X115.95 Y118.002 E-.29488
G1 X116.021 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z5 F12000
G1 X116.021 Y133.957 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 24/40
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z5 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z5
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.3745
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01698
G1 X162.333 Y115.657 E.01228
G1 X161.976 Y115.379 E.01184
G1 X162.561 Y115.379 E.01531
; WIPE_START
G1 X162.621 Y116.027 E-.24738
G1 X162.333 Y115.657 E-.17821
G1 X161.976 Y115.379 E-.17183
G1 X162.404 Y115.379 E-.16257
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.484 Y123.011 Z5.2 F12000
G1 X162.621 Y135.976 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X162.621 Y136.621 E.01693
G1 X161.972 Y136.621 E.01703
G1 X162.343 Y136.333 E.01232
G1 X162.584 Y136.023 E.0103
; WIPE_START
G1 X162.621 Y136.621 E-.22769
G1 X161.972 Y136.621 E-.2467
G1 X162.343 Y136.333 E-.17849
G1 X162.516 Y136.111 E-.10712
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.885 Y136.27 Z5.2 F12000
G1 X138.024 Y136.621 Z5.2
G1 Z4.8
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01693
G1 X137.379 Y135.972 E.01702
G1 X137.667 Y136.343 E.01231
G1 X137.977 Y136.584 E.0103
; WIPE_START
G1 X137.379 Y136.621 E-.22766
G1 X137.379 Y135.972 E-.2466
G1 X137.667 Y136.343 E-.17841
G1 X137.89 Y136.517 E-.10733
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.948 Y128.884 Z5.2 F12000
G1 X138.05 Y115.381 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.37862
G1 F6000
M204 S3000
G1 X137.663 Y115.674 E.01287
G1 X137.384 Y116.036 E.01214
G1 X137.384 Y115.381 E.01739
G1 X137.99 Y115.381 E.01607
; WIPE_START
G1 X137.663 Y115.674 E-.16684
G1 X137.384 Y116.036 E-.17393
G1 X137.384 Y115.381 E-.24925
G1 X137.831 Y115.381 E-.16999
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.464 Y115.427 Z5.2 F12000
G1 X161.439 Y115.524 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y115.577 E.00493
G1 X162.061 Y115.907 E.01867
G1 X162.334 Y116.26 E.01436
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.01809
; LINE_WIDTH: 0.43693
G1 X162.603 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.603 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.603 Y134.8 E.17444
; LINE_WIDTH: 0.44897
G1 X162.543 Y135.258 E.01479
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01116
G1 X162.093 Y136.061 E.01867
G1 X161.74 Y136.334 E.01435
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.603 E.01809
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.603 E.67298
; LINE_WIDTH: 0.44903
G1 X138.742 Y136.543 E.01479
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01115
G1 X137.939 Y136.093 E.01867
G1 X137.666 Y135.74 E.01434
G1 X137.489 Y135.356 E.0136
G1 X137.408 Y134.971 E.01266
; LINE_WIDTH: 0.44608
G1 X137.397 Y134.801 E.00543
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43662
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43649
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43636
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43609
G1 X137.398 Y117.167 E.05072
; LINE_WIDTH: 0.45269
G1 X137.422 Y116.872 E.00959
G1 X137.639 Y116.303 E.0197
; LINE_WIDTH: 0.44999
G1 X137.91 Y115.952 E.01428
G1 X138.143 Y115.745 E.01002
G1 X138.508 Y115.539 E.01348
G1 X138.958 Y115.41 E.01504
; LINE_WIDTH: 0.44783
G1 X139.128 Y115.4 E.00546
; LINE_WIDTH: 0.43889
G1 X141.128 Y115.399 E.06256
; LINE_WIDTH: 0.43871
G1 X143.128 Y115.399 E.06253
; LINE_WIDTH: 0.43853
G1 X145.128 Y115.399 E.0625
; LINE_WIDTH: 0.43836
G1 X147.128 Y115.399 E.06247
; LINE_WIDTH: 0.43818
G1 X149.128 Y115.399 E.06245
; LINE_WIDTH: 0.43801
G1 X151.128 Y115.398 E.06242
; LINE_WIDTH: 0.43783
G1 X153.128 Y115.398 E.06239
; LINE_WIDTH: 0.43766
G1 X155.128 Y115.398 E.06236
; LINE_WIDTH: 0.43748
G1 X157.128 Y115.398 E.06233
; LINE_WIDTH: 0.43731
G1 X159.128 Y115.398 E.06231
; LINE_WIDTH: 0.43713
G1 X160.801 Y115.397 E.05208
; LINE_WIDTH: 0.44895
G1 X161.258 Y115.457 E.01478
; LINE_WIDTH: 0.44999
G1 X161.383 Y115.503 E.00429
M204 S10000
G1 X161.332 Y115.929 F12000
G1 F6000
M204 S3000
G1 X161.627 Y116.075 E.01058
G3 X162.113 Y116.732 I-1.117 J1.334 E.02653
G1 X162.202 Y117.199 E.01531
G1 X162.202 Y134.8 E.56597
G1 X162.142 Y135.186 E.01255
G1 X161.925 Y135.627 E.01581
G3 X161.268 Y136.113 I-1.334 J-1.117 E.02653
G1 X160.801 Y136.202 E.01531
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01254
G1 X138.373 Y135.926 E.0158
G3 X137.887 Y135.269 I1.117 J-1.335 E.02654
G1 X137.807 Y134.901 E.0121
G1 X137.799 Y117.167 E.57023
G3 X138.628 Y115.928 I1.467 J.085 E.05029
G1 X139.128 Y115.801 E.0166
G1 X160.801 Y115.798 E.69689
G1 X161.186 Y115.858 E.01254
G1 X161.278 Y115.903 E.0033
M204 S250
G1 X161.168 Y116.264 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y116.267 E.00036
G1 X161.484 Y116.462 E.01078
G1 X161.73 Y116.816 E.01284
G1 X161.81 Y117.199 E.01167
G1 X161.81 Y134.8 E.52426
G1 X161.734 Y135.179 E.01151
G1 X161.538 Y135.484 E.01078
M73 P78 R4
G1 X161.184 Y135.73 E.01285
G1 X160.801 Y135.81 E.01167
G1 X139.199 Y135.81 E.64341
G1 X138.821 Y135.734 E.01151
G1 X138.516 Y135.539 E.01077
G1 X138.27 Y135.184 E.01285
G1 X138.193 Y134.833 E.01071
G1 X138.191 Y117.167 E.52619
G1 X138.23 Y116.929 E.0072
G1 X138.41 Y116.576 E.0118
G1 X138.743 Y116.303 E.01283
G1 X139.128 Y116.193 E.01193
G1 X160.801 Y116.19 E.64553
G1 X161.109 Y116.252 E.00936
; WIPE_START
M204 S3000
G1 X161.179 Y116.267 E-.02734
G1 X161.484 Y116.462 E-.13756
G1 X161.73 Y116.816 E-.16386
G1 X161.81 Y117.199 E-.14887
G1 X161.81 Y117.942 E-.28236
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.908 Y115.059 Z5.2 F12000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.221 E.00583
; LINE_WIDTH: 0.45007
G2 X162.997 Y117.199 I90.974 J.685 E.06365
; LINE_WIDTH: 0.43693
G1 X162.997 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.997 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.997 Y134.8 E.17444
; LINE_WIDTH: 0.44622
G1 X162.993 Y135.009 E.00665
; LINE_WIDTH: 0.44999
G2 X162.991 Y136.722 I329.971 J1.207 E.05507
G1 X162.928 Y136.925 E.00686
G1 X162.712 Y136.991 E.00724
G2 X160.801 Y136.997 I-.652 J91.536 E.06147
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.997 E.67298
; LINE_WIDTH: 0.44656
G1 X138.991 Y136.993 E.00666
; LINE_WIDTH: 0.44999
G2 X137.301 Y136.991 I-1.201 J352.176 E.05432
G1 X137.079 Y136.932 E.00741
G1 X137.009 Y136.722 E.0071
G2 X137.003 Y134.801 I-90.943 J-.672 E.06179
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43662
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43649
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43636
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43609
G1 X137.005 Y117.167 E.05072
; LINE_WIDTH: 0.45269
G2 X137.013 Y116.166 I-18.031 J-.63 E.03243
; LINE_WIDTH: 0.44999
G1 X137.013 Y115.258 E.0292
G1 X137.064 Y115.084 E.00582
G1 X137.249 Y115.009 E.00641
G2 X139.128 Y115.004 I.593 J-118.493 E.06044
; LINE_WIDTH: 0.43889
G1 X141.128 Y115.004 E.06256
; LINE_WIDTH: 0.43871
G1 X143.128 Y115.004 E.06253
; LINE_WIDTH: 0.43853
G1 X145.128 Y115.004 E.0625
; LINE_WIDTH: 0.43836
G1 X147.128 Y115.004 E.06247
; LINE_WIDTH: 0.43818
G1 X149.128 Y115.003 E.06245
; LINE_WIDTH: 0.43801
G1 X151.128 Y115.003 E.06242
; LINE_WIDTH: 0.43783
G1 X153.128 Y115.003 E.06239
; LINE_WIDTH: 0.43766
G1 X155.128 Y115.003 E.06236
; LINE_WIDTH: 0.43748
G1 X157.128 Y115.003 E.06233
; LINE_WIDTH: 0.43731
G1 X159.128 Y115.003 E.06231
; LINE_WIDTH: 0.43713
G1 X160.801 Y115.003 E.05208
; LINE_WIDTH: 0.44626
G1 X161.01 Y115.008 E.00667
; LINE_WIDTH: 0.44999
G2 X162.701 Y115.01 I1.219 J-329.211 E.05436
G1 X162.849 Y115.045 E.00491
M204 S10000
G1 X163.126 Y114.723 F12000
G1 F6000
M204 S3000
G1 X163.318 Y114.918 E.0088
G1 X163.397 Y115.221 E.01007
G1 X163.398 Y135.22 E.64311
G3 X163.376 Y136.892 I-32.959 J.405 E.05377
G1 X163.276 Y137.151 E.00892
; object ids of layer 24 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer24 end: 47,58
M625
G1 X163.096 Y137.304 E.00759
G1 X162.748 Y137.398 E.01158
G1 X138.748 Y137.398 E.77173
G3 X137.121 Y137.378 I-.387 J-34.911 E.05234
G1 X136.849 Y137.276 E.00934
G1 X136.691 Y137.079 E.00813
G1 X136.602 Y136.754 E.01082
G1 X136.606 Y115.177 E.69384
G1 X136.701 Y114.897 E.0095
G1 X136.887 Y114.7 E.0087
G1 X137.229 Y114.602 E.01143
G1 X162.774 Y114.603 E.82143
G1 X163.075 Y114.694 E.0101
M204 S250
G1 X163.419 Y114.435 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.44 Y114.448 E.00074
G1 X163.663 Y114.719 E.01045
G3 X163.789 Y115.22 I-1.422 J.626 E.01547
G1 X163.79 Y136.685 E.63934
G1 X163.739 Y137.105 E.01261
G1 X163.598 Y137.382 E.00925
G3 X162.783 Y137.79 I-.858 J-.695 E.02799
G1 X137.301 Y137.79 E.75899
G1 X136.895 Y137.739 E.0122
G1 X136.618 Y137.598 E.00924
G1 X136.421 Y137.407 E.00818
G1 X136.261 Y137.104 E.01023
G1 X136.21 Y136.785 E.00962
G1 X136.214 Y115.257 E.64121
G1 X136.287 Y114.822 E.01315
G1 X136.449 Y114.559 E.00921
G1 X136.683 Y114.359 E.00916
G3 X137.21 Y114.21 I.737 J1.599 E.01637
G1 X162.701 Y114.211 E.75927
G1 X163.18 Y114.289 E.01447
G1 X163.368 Y114.404 E.00655
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.44 Y114.448 E-.03224
G1 X163.663 Y114.719 E-.13333
G1 X163.725 Y114.886 E-.06771
G1 X163.789 Y115.22 E-.12932
G1 X163.789 Y116.266 E-.3974
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.66 Y118.992 Z5.2 F12000
G1 X116.388 Y134.391 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.196 J104.919 E.04396
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-104.878 J-.21 E.04403
; LINE_WIDTH: 0.43721
G1 X95.603 Y131.021 E.06229
; LINE_WIDTH: 0.43706
G1 X95.603 Y129.021 E.06227
; LINE_WIDTH: 0.43692
G1 X95.604 Y127.021 E.06225
; LINE_WIDTH: 0.43678
G1 X95.604 Y125.021 E.06222
; LINE_WIDTH: 0.43664
G1 X95.604 Y123.021 E.0622
; LINE_WIDTH: 0.4365
G1 X95.604 Y121.021 E.06218
; LINE_WIDTH: 0.43636
G1 X95.604 Y119.021 E.06216
; LINE_WIDTH: 0.43622
G1 X95.604 Y118.978 E.00134
; LINE_WIDTH: 0.44999
G1 X95.612 Y117.609 E.04403
G2 X96.979 Y117.603 I.196 J-105.25 E.04396
; LINE_WIDTH: 0.43731
G1 X114.979 Y117.603 E.56077
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.603 E.00134
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I102.603 J.204 E.04403
; LINE_WIDTH: 0.43692
G1 X116.396 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.396 Y126.979 E.12443
; LINE_WIDTH: 0.4365
G1 X116.396 Y130.979 E.12436
; LINE_WIDTH: 0.4363
G1 X116.396 Y133.021 E.06348
; LINE_WIDTH: 0.44512
G1 X116.391 Y133.227 E.00652
; LINE_WIDTH: 0.44999
G1 X116.389 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67799
G1 X95.251 Y134.712 E.00737
G1 X95.202 Y134.548 E.0055
G1 X95.204 Y117.414 E.55098
G1 X95.288 Y117.25 E.00589
G1 X95.452 Y117.202 E.00551
G1 X116.525 Y117.202 E.67762
G1 X116.737 Y117.271 E.00716
G1 X116.797 Y117.469 E.00666
G1 X116.796 Y134.586 E.5504
G1 X116.74 Y134.696 E.00396
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.547 J-.829 E.01065
G1 X94.81 Y134.583 E.0094
G1 X94.812 Y118.583 E.47657
G3 X94.833 Y117.285 I22.845 J-.288 E.03867
G3 X95.114 Y116.898 I.632 J.163 E.0146
G1 X95.417 Y116.81 E.0094
G1 X116.525 Y116.81 E.62871
G1 X116.824 Y116.858 E.00901
G3 X117.132 Y117.153 I-.223 J.541 E.01301
G1 X117.189 Y117.47 E.00958
G1 X117.188 Y133.469 E.47657
G3 X117.167 Y134.714 I-21.961 J.262 E.03709
G3 X116.935 Y135.068 I-.632 J-.163 E.01283
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14162
G1 X114.955 Y135.19 E-.61839
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.358 Y134.459 Z5.2 F12000
G1 X96.103 Y133.376 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44614
G1 X95.997 Y133.021 E.00543
; LINE_WIDTH: 0.43721
G1 X95.997 Y131.021 E.06229
; LINE_WIDTH: 0.43706
G1 X95.997 Y129.021 E.06227
; LINE_WIDTH: 0.43692
G1 X95.997 Y127.021 E.06225
; LINE_WIDTH: 0.43678
G1 X95.998 Y125.021 E.06222
; LINE_WIDTH: 0.43664
G1 X95.998 Y123.021 E.0622
; LINE_WIDTH: 0.4365
G1 X95.998 Y121.021 E.06218
; LINE_WIDTH: 0.43636
G1 X95.998 Y119.021 E.06216
; LINE_WIDTH: 0.43622
G1 X95.998 Y118.979 E.00133
; LINE_WIDTH: 0.44999
G1 X96.281 Y118.279 E.02426
G1 X96.808 Y118.008 E.01907
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X114.979 Y117.997 E.56077
; LINE_WIDTH: 0.4372
G1 X115.021 Y117.997 E.00134
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.002 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.002 Y126.979 E.12443
; LINE_WIDTH: 0.4365
G1 X116.002 Y130.979 E.12436
; LINE_WIDTH: 0.4363
G1 X116.002 Y133.021 E.06348
; LINE_WIDTH: 0.44512
G1 X115.992 Y133.192 E.00542
; LINE_WIDTH: 0.44999
G1 X115.719 Y133.721 E.01914
G1 X115.192 Y133.992 E.01907
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.429 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00283
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.978 E.45156
G1 X96.568 Y118.568 E.01431
G1 X96.878 Y118.407 E.01122
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.827 J.022 E.00462
G1 X115.432 Y133.433 E.01126
G1 X115.122 Y133.593 E.01122
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.00429
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.00429
G1 X96.979 Y133.21 E.53742
G1 X96.845 Y133.155 E.0043
G1 X96.813 Y133.077 E.00251
; WIPE_START
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z5.2 F12000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17026
G1 X95.955 Y133.998 E-.29487
G1 X96.026 Y133.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y126.324 Z5.2 F12000
G1 X96.027 Y117.961 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y118.002 E.00244
G1 X96.027 Y118.042 E.00244
G1 X96.051 Y118.002 E.00141
; WIPE_START
G1 X96.027 Y118.042 E-.17027
G1 X95.957 Y118.002 E-.29487
G1 X96.027 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.66 Y117.961 Z5.2 F12000
G1 X116.021 Y117.961 Z5.2
M73 P79 R4
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.42144
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00141
; WIPE_START
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y125.594 Z5.2 F12000
G1 X116.02 Y133.958 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y133.998 E.00244
G1 X116.02 Y134.039 E.00244
G1 X116.043 Y133.998 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.02 Y134.039 E-.17027
G1 X115.949 Y133.998 E-.29487
G1 X116.02 Y133.958 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 25/40
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z5.2 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z5.2
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.37449
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01697
G1 X162.333 Y115.657 E.01228
G1 X161.976 Y115.379 E.01184
G1 X162.561 Y115.379 E.01531
; WIPE_START
G1 X162.621 Y116.027 E-.24731
G1 X162.333 Y115.657 E-.17816
G1 X161.976 Y115.379 E-.1718
G1 X162.404 Y115.379 E-.16272
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.485 Y123.011 Z5.4 F12000
G1 X162.621 Y135.974 Z5.4
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.621 Y136.621 E.01698
G1 X161.972 Y136.621 E.01703
G1 X162.243 Y136.416 E.00892
G1 X162.582 Y136.019 E.01368
; WIPE_START
G1 X162.621 Y136.621 E-.22921
G1 X161.972 Y136.621 E-.2467
G1 X162.243 Y136.416 E-.1293
G1 X162.508 Y136.106 E-.15479
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.877 Y136.267 Z5.4 F12000
G1 X138.024 Y136.621 Z5.4
G1 Z5
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01692
G1 X137.379 Y135.972 E.01702
G1 X137.667 Y136.343 E.01231
G1 X137.977 Y136.584 E.0103
; WIPE_START
G1 X137.379 Y136.621 E-.22765
G1 X137.379 Y135.972 E-.24659
G1 X137.667 Y136.343 E-.1784
G1 X137.89 Y136.517 E-.10737
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.943 Y128.884 Z5.4 F12000
G1 X138.036 Y115.378 Z5.4
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.3727
G1 F6000
M204 S3000
G1 X137.665 Y115.657 E.01211
G1 X137.381 Y116.026 E.01213
G1 X137.381 Y115.378 E.01688
G1 X137.976 Y115.378 E.01551
; WIPE_START
G1 X137.665 Y115.657 E-.15897
G1 X137.381 Y116.026 E-.17687
G1 X137.381 Y115.378 E-.24627
G1 X137.849 Y115.378 E-.17789
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.482 Y115.425 Z5.4 F12000
G1 X161.44 Y115.524 Z5.4
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y115.577 E.0049
G1 X162.061 Y115.907 E.01867
G1 X162.333 Y116.26 E.01433
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.01811
; LINE_WIDTH: 0.43693
G1 X162.603 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.603 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.603 Y134.8 E.17444
; LINE_WIDTH: 0.46172
G1 X162.569 Y135.195 E.01308
G1 X162.296 Y135.799 E.02196
; LINE_WIDTH: 0.44999
G1 X162.02 Y136.121 E.01362
G1 X161.74 Y136.334 E.01133
G1 X161.355 Y136.511 E.0136
G1 X160.801 Y136.603 E.01808
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.603 E.67299
; LINE_WIDTH: 0.44904
G1 X138.742 Y136.543 E.01478
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01114
G1 X137.939 Y136.093 E.01868
G1 X137.667 Y135.74 E.01434
G1 X137.489 Y135.356 E.01361
G1 X137.416 Y135.012 E.01131
; LINE_WIDTH: 0.44658
G1 X137.397 Y134.801 E.00677
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.45046
G1 X137.493 Y116.625 E.01773
G1 X137.655 Y116.275 E.01241
; LINE_WIDTH: 0.44999
G1 X137.93 Y115.912 E.01465
G1 X138.399 Y115.587 E.01835
G1 X138.741 Y115.458 E.01176
; LINE_WIDTH: 0.44904
G1 X139.199 Y115.397 E.01481
; LINE_WIDTH: 0.43729
G1 X147.199 Y115.397 E.24922
; LINE_WIDTH: 0.43717
G1 X155.199 Y115.397 E.24914
; LINE_WIDTH: 0.43705
G1 X160.801 Y115.397 E.1744
; LINE_WIDTH: 0.44894
G1 X161.258 Y115.457 E.01478
; LINE_WIDTH: 0.44999
G1 X161.384 Y115.504 E.00432
M204 S10000
G1 X161.333 Y115.93 F12000
G1 F6000
M204 S3000
G1 X161.627 Y116.075 E.01055
G3 X162.113 Y116.731 I-1.116 J1.333 E.02651
G1 X162.202 Y117.199 E.01533
G1 X162.202 Y134.8 E.56597
G1 X162.163 Y135.123 E.01046
G1 X161.937 Y135.607 E.01718
G3 X161.268 Y136.113 I-1.313 J-1.04 E.02725
G1 X160.801 Y136.202 E.0153
G1 X139.199 Y136.202 E.69461
G1 X138.814 Y136.142 E.01254
G1 X138.373 Y135.926 E.01578
G3 X137.811 Y134.925 I.863 J-1.143 E.03798
G1 X137.798 Y134.801 E.00403
G1 X137.799 Y117.168 E.56699
G1 X137.889 Y116.72 E.01468
G1 X137.984 Y116.515 E.00729
G1 X138.224 Y116.194 E.01286
G1 X138.612 Y115.934 E.01503
G1 X139.097 Y115.807 E.01611
G1 X139.199 Y115.798 E.0033
G1 X160.801 Y115.798 E.69462
G1 X161.186 Y115.858 E.01254
G1 X161.279 Y115.903 E.00333
M204 S250
G1 X161.168 Y116.264 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y116.267 E.00033
G1 X161.484 Y116.462 E.01078
G1 X161.73 Y116.815 E.01283
G1 X161.81 Y117.199 E.01169
G1 X161.81 Y134.8 E.52426
G1 X161.757 Y135.112 E.00941
G1 X161.538 Y135.484 E.01286
G1 X161.184 Y135.73 E.01285
G1 X160.801 Y135.81 E.01167
G1 X139.199 Y135.81 E.64342
G1 X138.821 Y135.734 E.01149
G1 X138.516 Y135.539 E.01077
G1 X138.27 Y135.184 E.01286
G1 X138.194 Y134.841 E.01047
G1 X138.191 Y117.168 E.52641
G1 X138.302 Y116.745 E.01302
G1 X138.544 Y116.436 E.0117
G1 X138.882 Y116.244 E.01159
G1 X139.199 Y116.19 E.00957
G1 X160.801 Y116.19 E.64343
G1 X161.11 Y116.252 E.00938
; WIPE_START
M204 S3000
G1 X161.179 Y116.267 E-.02705
G1 X161.484 Y116.462 E-.13755
G1 X161.73 Y116.815 E-.16368
G1 X161.81 Y117.199 E-.14909
G1 X161.81 Y117.943 E-.28264
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.893 Y115.05 Z5.4 F12000
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.215 E.00615
; LINE_WIDTH: 0.45008
G2 X162.997 Y117.199 I91.352 J.687 E.06382
; LINE_WIDTH: 0.43693
G1 X162.997 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.997 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.997 Y134.8 E.17444
; LINE_WIDTH: 0.46172
G2 X162.991 Y135.973 I16.156 J.673 E.03881
; LINE_WIDTH: 0.44999
G1 X162.991 Y136.696 E.02325
G1 X162.93 Y136.924 E.00758
G1 X162.712 Y136.991 E.00733
G2 X160.801 Y136.997 I-.652 J91.353 E.06147
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.997 E.67299
; LINE_WIDTH: 0.44659
G1 X138.99 Y136.993 E.00667
; LINE_WIDTH: 0.44999
G2 X137.304 Y136.991 I-1.206 J360.42 E.05422
G1 X137.076 Y136.93 E.00758
G1 X137.009 Y136.712 E.00733
G2 X137.003 Y134.801 I-90.419 J-.667 E.06148
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.45046
G2 X137.013 Y116.066 I-43.876 J-.837 E.03545
; LINE_WIDTH: 0.44999
G1 X137.013 Y115.234 E.02675
G1 X137.09 Y115.062 E.00609
G1 X137.268 Y115.009 E.00596
G2 X139.199 Y115.003 I.489 J-146.142 E.06209
; LINE_WIDTH: 0.43729
G1 X147.199 Y115.003 E.24922
; LINE_WIDTH: 0.43717
G1 X155.199 Y115.003 E.24914
; LINE_WIDTH: 0.43705
G1 X160.801 Y115.003 E.1744
; LINE_WIDTH: 0.44625
G1 X161.01 Y115.008 E.00666
; LINE_WIDTH: 0.44999
G2 X162.702 Y115.01 I1.22 J-329.416 E.0544
G1 X162.834 Y115.038 E.00436
M204 S10000
G1 X163.125 Y114.722 F12000
G1 F6000
M204 S3000
G1 X163.317 Y114.917 E.00881
G1 X163.397 Y115.215 E.00994
G1 X163.398 Y135.215 E.64311
G3 X163.374 Y136.9 I-32.733 J.381 E.05417
; object ids of layer 25 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer25 end: 47,58
M625
G1 X163.276 Y137.152 E.00871
G1 X163.092 Y137.305 E.00769
G1 X162.748 Y137.398 E.01145
G1 X138.748 Y137.398 E.77173
G3 X137.1 Y137.374 I-.387 J-30.181 E.053
G1 X136.848 Y137.276 E.0087
G1 X136.695 Y137.092 E.00769
G1 X136.602 Y136.748 E.01145
M73 P79 R3
G1 X136.606 Y115.283 E.69022
G1 X136.668 Y114.942 E.01116
G1 X136.896 Y114.693 E.01086
G1 X137.24 Y114.602 E.01145
G1 X162.776 Y114.603 E.82111
G1 X163.074 Y114.693 E.01002
M204 S250
G1 X163.418 Y114.434 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.44 Y114.448 E.00078
G1 X163.662 Y114.719 E.01044
G3 X163.789 Y115.215 I-1.468 J.639 E.01532
G1 X163.79 Y136.685 E.6395
G1 X163.737 Y137.112 E.01283
G3 X163.144 Y137.726 I-1.005 J-.379 E.02613
G1 X162.783 Y137.79 E.01091
G1 X137.315 Y137.79 E.75859
G1 X136.887 Y137.737 E.01283
G3 X136.274 Y137.144 I.379 J-1.005 E.02613
G1 X136.21 Y136.783 E.01091
G1 X136.214 Y115.283 E.64039
G3 X136.378 Y114.668 I1.275 J.012 E.01918
G1 X136.545 Y114.477 E.00754
G1 X136.813 Y114.301 E.00956
G1 X137.213 Y114.21 E.01223
G1 X162.702 Y114.211 E.7592
G1 X163.18 Y114.289 E.01443
G1 X163.366 Y114.403 E.00652
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.44 Y114.448 E-.03271
G1 X163.662 Y114.719 E-.13319
G1 X163.726 Y114.891 E-.06985
G1 X163.789 Y115.215 E-.12536
G1 X163.789 Y116.265 E-.39889
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.66 Y118.991 Z5.4 F12000
G1 X116.391 Y134.391 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-104.471 J-.212 E.04403
; LINE_WIDTH: 0.43721
G1 X95.603 Y131.021 E.06229
; LINE_WIDTH: 0.43706
G1 X95.603 Y129.021 E.06227
; LINE_WIDTH: 0.43692
G1 X95.604 Y127.021 E.06225
; LINE_WIDTH: 0.43678
G1 X95.604 Y125.021 E.06222
; LINE_WIDTH: 0.43664
G1 X95.604 Y123.021 E.0622
; LINE_WIDTH: 0.4365
G1 X95.604 Y121.021 E.06218
; LINE_WIDTH: 0.43636
G1 X95.604 Y119.021 E.06216
; LINE_WIDTH: 0.43622
G1 X95.604 Y118.978 E.00134
; LINE_WIDTH: 0.44999
G1 X95.612 Y117.609 E.04403
G2 X96.979 Y117.603 I.196 J-105.25 E.04396
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.603 E.56211
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.465 J.191 E.04403
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.715 Y134.742 F12000
G1 F6000
M204 S3000
G1 X116.56 Y134.798 E.0053
G1 X95.463 Y134.798 E.67837
G1 X95.26 Y134.719 E.00701
G1 X95.202 Y134.559 E.00547
G1 X95.204 Y117.414 E.55133
G1 X95.28 Y117.26 E.0055
G1 X95.44 Y117.202 E.00547
G1 X116.524 Y117.202 E.67797
G1 X116.727 Y117.265 E.00682
G1 X116.797 Y117.451 E.00639
G1 X116.798 Y134.537 E.54941
G1 X116.739 Y134.689 E.00525
M204 S250
G1 X116.85 Y135.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X116.587 Y135.19 I-.401 J-.908 E.00818
G1 X95.495 Y135.19 E.62823
G1 X95.155 Y135.132 E.01028
G1 X94.955 Y134.98 E.00748
G3 X94.81 Y134.586 I.837 J-.531 E.01259
G1 X94.812 Y117.455 E.51027
G1 X94.866 Y117.158 E.009
G1 X95.02 Y116.955 E.00758
G3 X95.413 Y116.81 I.538 J.853 E.01259
G1 X116.524 Y116.81 E.62881
G1 X116.824 Y116.858 E.00903
G1 X117.013 Y116.984 E.00678
G1 X117.152 Y117.202 E.00769
G1 X117.189 Y117.451 E.00749
G1 X117.19 Y134.505 E.50797
G1 X117.132 Y134.845 E.01029
G1 X116.98 Y135.045 E.00747
G3 X116.904 Y135.089 I-.532 J-.838 E.00262
; WIPE_START
M204 S3000
G1 X116.587 Y135.19 E-.12653
G1 X114.92 Y135.19 E-.63347
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.322 Y134.459 Z5.4 F12000
G1 X96.104 Y133.379 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00676
; LINE_WIDTH: 0.44614
G1 X95.997 Y133.021 E.00543
; LINE_WIDTH: 0.43721
M73 P80 R3
G1 X95.997 Y131.021 E.06229
; LINE_WIDTH: 0.43706
G1 X95.997 Y129.021 E.06227
; LINE_WIDTH: 0.43692
G1 X95.997 Y127.021 E.06225
; LINE_WIDTH: 0.43678
G1 X95.998 Y125.021 E.06222
; LINE_WIDTH: 0.43664
G1 X95.998 Y123.021 E.0622
; LINE_WIDTH: 0.4365
G1 X95.998 Y121.021 E.06218
; LINE_WIDTH: 0.43636
G1 X95.998 Y119.021 E.06216
; LINE_WIDTH: 0.43622
G1 X95.998 Y118.979 E.00133
; LINE_WIDTH: 0.44999
G1 X96.281 Y118.279 E.02426
G1 X96.808 Y118.008 E.01907
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.997 E.56211
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.132 Y133.432 E.01042
M204 S10000
G1 X96.026 Y133.957 F12000
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
M204 S10000
G1 X96.448 Y133.202 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00292
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.978 E.45156
G1 X96.568 Y118.568 E.01431
G1 X96.878 Y118.407 E.01122
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.476 Y133.255 E.0064
M204 S250
G1 X96.791 Y133.024 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y133.021 E.00009
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.00429
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00564
G1 X96.814 Y133.08 E.00243
; WIPE_START
M204 S3000
G1 X96.79 Y133.021 E-.0239
G1 X96.79 Y131.084 E-.73611
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.347 Y123.465 Z5.4 F12000
G1 X96.027 Y117.961 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y118.002 E.00244
G1 X96.027 Y118.042 E.00244
G1 X96.051 Y118.002 E.00141
; WIPE_START
G1 X96.027 Y118.042 E-.17027
G1 X95.957 Y118.002 E-.29487
G1 X96.027 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.66 Y117.961 Z5.4 F12000
G1 X116.021 Y117.961 Z5.4
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.4215
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; WIPE_START
G1 X116.021 Y118.043 E-.17025
G1 X115.95 Y118.002 E-.29488
G1 X116.021 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z5.4 F12000
G1 X116.021 Y133.957 Z5.4
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 26/40
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z5.4 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z5.4
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.37449
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01697
G1 X162.416 Y115.757 E.00889
G1 X161.974 Y115.379 E.01522
G1 X162.561 Y115.379 E.01536
; WIPE_START
G1 X162.621 Y116.027 E-.24733
G1 X162.416 Y115.757 E-.12904
G1 X161.974 Y115.379 E-.22075
G1 X162.403 Y115.379 E-.16289
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.484 Y123.011 Z5.6 F12000
G1 X162.621 Y135.976 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
G1 X162.621 Y136.621 E.01693
G1 X161.972 Y136.621 E.01703
G1 X162.343 Y136.333 E.01232
G1 X162.584 Y136.023 E.0103
; WIPE_START
G1 X162.621 Y136.621 E-.22769
G1 X161.972 Y136.621 E-.24664
G1 X162.343 Y136.333 E-.17845
G1 X162.516 Y136.11 E-.10722
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y136.27 Z5.6 F12000
G1 X138.024 Y136.621 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01693
G1 X137.379 Y135.972 E.01703
G1 X137.667 Y136.343 E.01232
G1 X137.977 Y136.584 E.01031
; WIPE_START
G1 X137.379 Y136.621 E-.22775
G1 X137.379 Y135.972 E-.24667
G1 X137.667 Y136.343 E-.17845
G1 X137.889 Y136.516 E-.10713
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.94 Y128.884 Z5.6 F12000
G1 X138.03 Y115.378 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.37376
G1 F6000
M204 S3000
G1 X137.663 Y115.658 E.01206
G1 X137.378 Y116.029 E.01222
G1 X137.378 Y115.378 E.01701
G1 X137.97 Y115.378 E.01546
; WIPE_START
G1 X137.663 Y115.658 E-.15782
G1 X137.378 Y116.029 E-.1777
G1 X137.378 Y115.378 E-.24728
G1 X137.844 Y115.378 E-.17721
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.477 Y115.421 Z5.6 F12000
G1 X161.403 Y115.509 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.45803
G1 F6000
M204 S3000
G1 X161.489 Y115.538 E.00296
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01133
G1 X162.121 Y115.979 E.01361
G1 X162.334 Y116.26 E.01131
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.0181
; LINE_WIDTH: 0.43693
G1 X162.603 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.603 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.603 Y134.8 E.17444
; LINE_WIDTH: 0.44897
G1 X162.543 Y135.257 E.01478
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01116
G1 X162.093 Y136.061 E.01867
G1 X161.74 Y136.333 E.01433
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.603 E.01811
; LINE_WIDTH: 0.43732
G1 X139.2 Y136.603 E.67297
; LINE_WIDTH: 0.44903
G1 X138.743 Y136.543 E.01478
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01117
G1 X137.939 Y136.093 E.01867
G1 X137.666 Y135.74 E.01434
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43735
G1 X137.397 Y128.801 E.18694
; LINE_WIDTH: 0.43746
G1 X137.398 Y122.801 E.18699
; LINE_WIDTH: 0.43756
G1 X137.398 Y117.168 E.1756
; LINE_WIDTH: 0.45079
G1 X137.493 Y116.625 E.01774
G1 X137.655 Y116.275 E.01242
; LINE_WIDTH: 0.44999
G1 X137.929 Y115.913 E.01461
G1 X138.353 Y115.609 E.01678
G1 X138.693 Y115.473 E.01176
; LINE_WIDTH: 0.44951
G1 X139.199 Y115.397 E.01645
; LINE_WIDTH: 0.43729
G1 X147.199 Y115.397 E.24922
; LINE_WIDTH: 0.43716
G1 X155.199 Y115.397 E.24914
; LINE_WIDTH: 0.43704
G1 X160.8 Y115.397 E.17438
; LINE_WIDTH: 0.45803
G3 X161.159 Y115.427 I.06 J1.457 E.01183
G1 X161.346 Y115.49 E.00648
M204 S10000
G1 X161.302 Y115.925 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.01079
G3 X162.113 Y116.731 I-1.039 J1.312 E.02723
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.8 E.56597
G1 X162.142 Y135.186 E.01254
G1 X161.926 Y135.627 E.01581
G3 X161.269 Y136.113 I-1.334 J-1.117 E.02652
G1 X160.801 Y136.202 E.01532
G1 X139.2 Y136.202 E.69459
G1 X138.814 Y136.142 E.01254
G1 X138.373 Y135.925 E.01582
G3 X137.887 Y135.269 I1.116 J-1.334 E.02651
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.168 E.567
G1 X137.889 Y116.72 E.01467
G1 X137.984 Y116.515 E.00729
G1 X138.223 Y116.195 E.01284
G1 X138.573 Y115.952 E.01369
G1 X139.086 Y115.809 E.01713
G1 X139.199 Y115.798 E.00367
G1 X160.8 Y115.798 E.6946
G1 X161.103 Y115.834 E.00979
G1 X161.247 Y115.9 E.00511
M204 S250
G1 X161.147 Y116.264 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.462 E.01163
G1 X161.73 Y116.816 E.01284
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.8 E.52426
G1 X161.734 Y135.179 E.01151
G1 X161.538 Y135.484 E.01078
G1 X161.184 Y135.73 E.01284
G1 X160.801 Y135.81 E.01168
G1 X139.2 Y135.81 E.6434
G1 X138.821 Y135.734 E.01151
G1 X138.516 Y135.538 E.01079
G1 X138.27 Y135.184 E.01283
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.168 E.52521
G1 X138.301 Y116.745 E.01301
G1 X138.541 Y116.438 E.0116
G1 X138.784 Y116.282 E.0086
G1 X139.199 Y116.19 E.01267
G1 X160.8 Y116.19 E.64341
G1 X161.093 Y116.24 E.00885
; WIPE_START
M204 S3000
G1 X161.484 Y116.462 E-.17074
G1 X161.73 Y116.816 E-.1638
G1 X161.81 Y117.199 E-.14898
G1 X161.81 Y117.927 E-.27648
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.908 Y115.059 Z5.6 F12000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.219 E.00578
; LINE_WIDTH: 0.45008
G2 X162.997 Y117.199 I91.114 J.685 E.0637
; LINE_WIDTH: 0.43693
G1 X162.997 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.997 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.997 Y134.8 E.17444
; LINE_WIDTH: 0.44897
G1 X162.991 Y135.297 E.01593
; LINE_WIDTH: 0.44999
G3 X162.987 Y136.744 I-168.195 J.254 E.04654
G1 X162.915 Y136.933 E.0065
G1 X162.732 Y136.991 E.00619
G2 X160.801 Y136.997 I-.661 J92.61 E.0621
; LINE_WIDTH: 0.43732
G1 X139.2 Y136.997 E.67297
; LINE_WIDTH: 0.44903
G1 X138.703 Y136.991 E.01593
; LINE_WIDTH: 0.44999
G3 X137.256 Y136.987 I-.259 J-165.416 E.04654
G1 X137.067 Y136.915 E.0065
G1 X137.009 Y136.732 E.00619
G2 X137.003 Y134.801 I-92.376 J-.662 E.0621
; LINE_WIDTH: 0.43735
G1 X137.003 Y128.801 E.18694
; LINE_WIDTH: 0.43746
G1 X137.003 Y122.801 E.18699
; LINE_WIDTH: 0.43756
G1 X137.003 Y117.168 E.1756
; LINE_WIDTH: 0.45079
G2 X137.009 Y115.745 I-62.287 J-.982 E.04584
; LINE_WIDTH: 0.44999
G1 X137.023 Y115.189 E.01788
G1 X137.09 Y115.067 E.00448
G1 X137.26 Y115.009 E.00578
G1 X138.647 Y115.009 E.04459
; LINE_WIDTH: 0.44951
G1 X139.199 Y115.003 E.01774
; LINE_WIDTH: 0.43729
G1 X147.199 Y115.003 E.24922
; LINE_WIDTH: 0.43716
G1 X155.199 Y115.003 E.24914
; LINE_WIDTH: 0.43704
G1 X160.8 Y115.003 E.17438
; LINE_WIDTH: 0.44256
G1 X160.963 Y115.006 E.00513
; LINE_WIDTH: 0.44999
G2 X162.703 Y115.01 I1.205 J-154.082 E.05596
G1 X162.849 Y115.045 E.00483
M204 S10000
G1 X163.123 Y114.721 F12000
G1 F6000
M204 S3000
G1 X163.318 Y114.917 E.00889
M73 P81 R3
G1 X163.397 Y115.219 E.01003
G1 X163.398 Y135.219 E.64311
G3 X163.379 Y136.875 I-36.545 J.406 E.05327
G1 X163.26 Y137.17 E.01021
; object ids of layer 26 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer26 end: 47,58
M625
G1 X163.049 Y137.328 E.00845
G1 X162.76 Y137.398 E.00958
G1 X138.76 Y137.398 E.77173
G3 X137.125 Y137.379 I-.394 J-36.027 E.05258
G1 X136.83 Y137.26 E.01021
G1 X136.673 Y137.049 E.00845
G1 X136.602 Y136.76 E.00958
G1 X136.602 Y116.76 E.64311
G3 X136.621 Y115.126 I26.523 J-.507 E.05256
G1 X136.738 Y114.835 E.01005
G1 X136.897 Y114.694 E.00686
G1 X137.235 Y114.602 E.01127
G1 X162.777 Y114.603 E.82131
G1 X163.072 Y114.693 E.00991
M204 S250
G1 X163.416 Y114.434 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.44 Y114.448 E.00083
G1 X163.662 Y114.719 E.01044
G3 X163.789 Y115.219 I-1.436 J.63 E.01543
G1 X163.79 Y136.699 E.63979
G1 X163.74 Y137.103 E.01214
G1 X163.574 Y137.413 E.01045
G1 X163.349 Y137.621 E.00915
G1 X163.067 Y137.751 E.00925
G1 X162.787 Y137.79 E.00841
G1 X137.301 Y137.79 E.75911
G1 X136.897 Y137.74 E.01215
G1 X136.587 Y137.574 E.01045
G1 X136.379 Y137.349 E.00915
G1 X136.249 Y137.066 E.00926
G1 X136.21 Y136.787 E.00841
G1 X136.21 Y115.301 E.63996
G1 X136.26 Y114.897 E.01214
G1 X136.425 Y114.589 E.0104
G1 X136.686 Y114.357 E.01039
G3 X137.212 Y114.21 I.676 J1.404 E.01635
G1 X162.703 Y114.211 E.75928
G1 X163.18 Y114.289 E.01439
G1 X163.365 Y114.402 E.00647
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.44 Y114.448 E-.03336
G1 X163.662 Y114.719 E-.13321
G1 X163.725 Y114.888 E-.06838
G1 X163.789 Y115.219 E-.12818
G1 X163.789 Y116.263 E-.39687
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.66 Y118.99 Z5.6 F12000
G1 X116.391 Y134.391 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.611 E.04403
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.603 E.56211
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.466 J.191 E.04403
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.714 Y134.742 F12000
G1 F6000
M204 S3000
G1 X116.56 Y134.798 E.00529
G1 X95.463 Y134.798 E.67836
G1 X95.25 Y134.712 E.00738
G1 X95.202 Y134.548 E.0055
G1 X95.202 Y117.463 E.54937
G1 X95.28 Y117.26 E.00701
G1 X95.441 Y117.202 E.00548
G1 X116.524 Y117.202 E.67794
G1 X116.735 Y117.27 E.00713
G1 X116.797 Y117.467 E.00663
G1 X116.798 Y134.537 E.54889
G1 X116.739 Y134.689 E.00526
M204 S250
G1 X116.85 Y135.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X116.587 Y135.19 I-.402 J-.908 E.00818
G1 X95.495 Y135.19 E.62823
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.549 J-.831 E.01066
G1 X94.81 Y134.583 E.00939
G1 X94.81 Y117.495 E.50898
G1 X94.868 Y117.155 E.01028
G1 X95.02 Y116.955 E.00747
G3 X95.414 Y116.81 I.531 J.837 E.0126
G1 X116.524 Y116.81 E.62878
G1 X116.824 Y116.858 E.00905
G3 X117.136 Y117.161 I-.223 J.542 E.01328
G1 X117.189 Y117.467 E.00923
G1 X117.19 Y134.505 E.5075
G1 X117.132 Y134.845 E.01028
G1 X116.98 Y135.045 E.00747
G3 X116.904 Y135.089 I-.532 J-.838 E.00263
; WIPE_START
M204 S3000
G1 X116.587 Y135.19 E-.12654
G1 X114.92 Y135.19 E-.63346
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.322 Y134.468 Z5.6 F12000
G1 X96.117 Y133.403 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.997 E.56211
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z5.6 F12000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z5.6 F12000
G1 X96.026 Y117.961 Z5.6
G1 Z5.2
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z5.6 F12000
G1 X116.021 Y117.961 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.42152
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; WIPE_START
G1 X116.021 Y118.043 E-.17025
G1 X115.95 Y118.002 E-.29488
G1 X116.021 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z5.6 F12000
G1 X116.021 Y133.957 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 27/40
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z5.6 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z5.6
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.37448
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01697
G1 X162.333 Y115.657 E.01228
G1 X161.976 Y115.379 E.01184
G1 X162.561 Y115.379 E.0153
; WIPE_START
G1 X162.621 Y116.027 E-.24733
G1 X162.333 Y115.657 E-.17818
G1 X161.976 Y115.379 E-.17179
G1 X162.404 Y115.379 E-.1627
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.485 Y123.011 Z5.8 F12000
G1 X162.621 Y135.976 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.37498
G1 F6000
M204 S3000
M73 P82 R3
G1 X162.621 Y136.621 E.01693
G1 X161.972 Y136.621 E.01703
G1 X162.343 Y136.333 E.01232
G1 X162.584 Y136.023 E.0103
; WIPE_START
G1 X162.621 Y136.621 E-.22766
G1 X161.972 Y136.621 E-.24665
G1 X162.343 Y136.333 E-.17846
G1 X162.516 Y136.11 E-.10723
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y136.27 Z5.8 F12000
G1 X138.024 Y136.621 Z5.8
G1 Z5.4
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01693
G1 X137.379 Y135.972 E.01703
G1 X137.667 Y136.343 E.01232
G1 X137.977 Y136.584 E.0103
; WIPE_START
G1 X137.379 Y136.621 E-.22765
G1 X137.379 Y135.972 E-.24667
G1 X137.667 Y136.343 E-.17848
G1 X137.889 Y136.516 E-.1072
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y128.884 Z5.8 F12000
G1 X138.035 Y115.379 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.37523
G1 F6000
M204 S3000
G1 X137.727 Y115.608 E.01006
G1 X137.383 Y116.007 E.01384
G1 X137.379 Y115.379 E.01649
G1 X137.975 Y115.379 E.01565
; WIPE_START
G1 X137.727 Y115.608 E-.12812
G1 X137.383 Y116.007 E-.2003
G1 X137.379 Y115.379 E-.23871
G1 X137.886 Y115.379 E-.19288
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.519 Y115.426 Z5.8 F12000
G1 X161.442 Y115.525 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y115.577 E.00485
G1 X162.061 Y115.907 E.01867
G1 X162.334 Y116.26 E.01434
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.0181
; LINE_WIDTH: 0.43693
G1 X162.603 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.603 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.603 Y134.801 E.17445
; LINE_WIDTH: 0.44897
G1 X162.543 Y135.258 E.01478
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.583 E.01114
G1 X162.093 Y136.061 E.01868
G1 X161.74 Y136.333 E.01434
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.603 E.01811
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.603 E.67299
; LINE_WIDTH: 0.44904
G1 X138.742 Y136.543 E.01479
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01114
G1 X137.939 Y136.093 E.01867
G1 X137.667 Y135.74 E.01434
G1 X137.489 Y135.356 E.01361
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43735
G1 X137.397 Y128.801 E.18694
; LINE_WIDTH: 0.43746
G1 X137.398 Y122.801 E.18699
; LINE_WIDTH: 0.43756
G1 X137.398 Y117.167 E.17561
; LINE_WIDTH: 0.44863
G1 X137.447 Y116.773 E.01275
; LINE_WIDTH: 0.44999
G3 X137.71 Y116.189 I1.855 J.484 E.02068
G1 X137.958 Y115.897 E.01231
G3 X138.965 Y115.409 I1.386 J1.579 E.03642
; LINE_WIDTH: 0.44748
G1 X139.135 Y115.399 E.00545
; LINE_WIDTH: 0.43855
G1 X141.135 Y115.399 E.0625
; LINE_WIDTH: 0.4384
G1 X143.135 Y115.399 E.06248
; LINE_WIDTH: 0.43825
G1 X145.135 Y115.399 E.06246
; LINE_WIDTH: 0.4381
G1 X147.135 Y115.398 E.06243
; LINE_WIDTH: 0.43795
G1 X149.135 Y115.398 E.06241
; LINE_WIDTH: 0.4378
G1 X151.135 Y115.398 E.06239
; LINE_WIDTH: 0.43765
G1 X153.135 Y115.398 E.06236
; LINE_WIDTH: 0.4375
G1 X155.135 Y115.398 E.06234
; LINE_WIDTH: 0.43736
G1 X157.135 Y115.398 E.06232
; LINE_WIDTH: 0.43721
G1 X159.135 Y115.398 E.06229
; LINE_WIDTH: 0.43706
G1 X160.801 Y115.397 E.05186
; LINE_WIDTH: 0.44894
G1 X161.258 Y115.458 E.01479
; LINE_WIDTH: 0.44999
G1 X161.385 Y115.504 E.00437
M204 S10000
G1 X161.335 Y115.931 F12000
G1 F6000
M204 S3000
G1 X161.627 Y116.075 E.01049
G3 X162.113 Y116.732 I-1.117 J1.334 E.02653
G1 X162.202 Y117.199 E.01531
G1 X162.202 Y134.801 E.56599
G1 X162.142 Y135.186 E.01254
G1 X161.926 Y135.627 E.01579
G3 X161.269 Y136.113 I-1.334 J-1.117 E.02653
G1 X160.801 Y136.202 E.01532
G1 X139.199 Y136.202 E.69461
G1 X138.814 Y136.142 E.01255
G1 X138.373 Y135.926 E.01578
G3 X137.887 Y135.269 I1.117 J-1.335 E.02654
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.167 E.567
G1 X137.847 Y116.844 E.01051
G1 X138.066 Y116.387 E.01629
G3 X138.664 Y115.912 I1.315 J1.042 E.02481
G1 X139.135 Y115.8 E.01556
G1 X160.801 Y115.798 E.69667
G1 X161.186 Y115.858 E.01254
G1 X161.281 Y115.904 E.00338
M204 S250
G1 X161.17 Y116.265 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y116.267 E.00029
G1 X161.484 Y116.462 E.01077
G1 X161.73 Y116.816 E.01284
G1 X161.81 Y117.199 E.01167
G1 X161.81 Y134.801 E.52427
G1 X161.734 Y135.179 E.0115
G1 X161.538 Y135.484 E.01077
G1 X161.184 Y135.73 E.01284
G1 X160.801 Y135.81 E.01168
G1 X139.199 Y135.81 E.64341
G1 X138.821 Y135.733 E.0115
G1 X138.516 Y135.539 E.01076
G1 X138.27 Y135.184 E.01285
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.167 E.52522
G1 X138.254 Y116.855 E.00951
G1 X138.408 Y116.578 E.00943
G1 X138.772 Y116.289 E.01384
G1 X139.135 Y116.193 E.0112
G1 X160.801 Y116.19 E.64533
G1 X161.111 Y116.253 E.00943
; WIPE_START
M204 S3000
G1 X161.179 Y116.267 E-.02649
G1 X161.484 Y116.462 E-.13746
G1 X161.73 Y116.816 E-.16386
G1 X161.81 Y117.199 E-.14894
G1 X161.81 Y117.945 E-.28325
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.893 Y115.05 Z5.8 F12000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.221 E.00633
; LINE_WIDTH: 0.45007
G2 X162.997 Y117.199 I90.981 J.684 E.06362
; LINE_WIDTH: 0.43693
G1 X162.997 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.997 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.997 Y134.801 E.17445
; LINE_WIDTH: 0.44897
G1 X162.991 Y135.298 E.01594
; LINE_WIDTH: 0.44999
G3 X162.987 Y136.744 I-168.867 J.253 E.04652
G1 X162.915 Y136.933 E.0065
G1 X162.732 Y136.991 E.00619
G2 X160.801 Y136.997 I-.662 J92.403 E.0621
; LINE_WIDTH: 0.43732
G1 X139.199 Y136.997 E.67299
; LINE_WIDTH: 0.4466
G1 X138.99 Y136.993 E.00667
; LINE_WIDTH: 0.44999
G2 X137.301 Y136.991 I-1.208 J361.12 E.0543
G1 X137.078 Y136.93 E.00745
G1 X137.009 Y136.733 E.00672
G2 X137.003 Y134.801 I-92.353 J-.663 E.06213
; LINE_WIDTH: 0.43735
G1 X137.003 Y128.801 E.18694
; LINE_WIDTH: 0.43746
G1 X137.003 Y122.801 E.18699
; LINE_WIDTH: 0.43756
G1 X137.003 Y117.167 E.17561
; LINE_WIDTH: 0.44863
G1 X137.008 Y116.734 E.0139
; LINE_WIDTH: 0.44999
G3 X137.013 Y115.256 I191.039 J-.185 E.04753
G1 X137.083 Y115.067 E.00647
G1 X137.268 Y115.009 E.00623
G2 X139.135 Y115.003 I.609 J-106.949 E.06003
; LINE_WIDTH: 0.43855
G1 X141.135 Y115.003 E.0625
; LINE_WIDTH: 0.4384
G1 X143.135 Y115.003 E.06248
; LINE_WIDTH: 0.43825
G1 X145.135 Y115.003 E.06246
; LINE_WIDTH: 0.4381
G1 X147.135 Y115.003 E.06243
; LINE_WIDTH: 0.43795
G1 X149.135 Y115.003 E.06241
; LINE_WIDTH: 0.4378
G1 X151.135 Y115.003 E.06239
; LINE_WIDTH: 0.43765
G1 X153.135 Y115.003 E.06236
; LINE_WIDTH: 0.4375
G1 X155.135 Y115.003 E.06234
; LINE_WIDTH: 0.43736
G1 X157.135 Y115.003 E.06232
; LINE_WIDTH: 0.43721
G1 X159.135 Y115.003 E.06229
; LINE_WIDTH: 0.43706
G1 X160.801 Y115.003 E.05186
; LINE_WIDTH: 0.44622
G1 X161.01 Y115.008 E.00667
; LINE_WIDTH: 0.44999
G2 X162.704 Y115.01 I1.221 J-326.423 E.05448
G1 X162.834 Y115.038 E.00426
M204 S10000
G1 X163.123 Y114.721 F12000
G1 F6000
M204 S3000
G1 X163.314 Y114.912 E.00869
G1 X163.397 Y115.195 E.00948
G1 X163.398 Y135.195 E.64311
G3 X163.379 Y136.875 I-37.183 J.417 E.05404
G1 X163.26 Y137.17 E.01022
; object ids of layer 27 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer27 end: 47,58
M625
G1 X163.049 Y137.328 E.00846
G1 X162.76 Y137.398 E.00958
G1 X138.76 Y137.398 E.77173
G3 X137.123 Y137.378 I-.393 J-35.768 E.05262
G1 X136.825 Y137.257 E.01036
G1 X136.676 Y137.046 E.00832
G1 X136.602 Y136.76 E.00947
G1 X136.602 Y116.76 E.64311
G3 X136.621 Y115.125 I37.476 J-.377 E.0526
G1 X136.741 Y114.83 E.01023
G1 X136.945 Y114.676 E.00824
G1 X137.24 Y114.602 E.00977
G1 X162.779 Y114.603 E.8212
G1 X163.072 Y114.693 E.00986
M204 S250
G1 X163.415 Y114.433 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.44 Y114.448 E.00086
G1 X163.661 Y114.717 E.01037
G3 X163.789 Y115.195 I-2.091 J.817 E.01475
G1 X163.79 Y136.699 E.64052
G1 X163.74 Y137.103 E.01213
G1 X163.574 Y137.413 E.01046
G1 X163.349 Y137.621 E.00915
G3 X162.787 Y137.79 I-.559 J-.842 E.01773
G1 X137.301 Y137.79 E.75911
G1 X136.897 Y137.74 E.01214
G1 X136.585 Y137.573 E.01051
G1 X136.403 Y137.384 E.00783
G1 X136.247 Y137.06 E.01071
G1 X136.21 Y136.787 E.0082
G1 X136.21 Y115.301 E.63997
G1 X136.26 Y114.897 E.01215
G1 X136.426 Y114.587 E.01046
G1 X136.647 Y114.382 E.00899
G1 X136.934 Y114.249 E.0094
G1 X137.213 Y114.21 E.00841
G1 X162.704 Y114.211 E.75928
G1 X163.18 Y114.289 E.01435
G1 X163.364 Y114.402 E.00644
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.44 Y114.448 E-.03381
G1 X163.661 Y114.717 E-.13233
G1 X163.718 Y114.881 E-.06574
G1 X163.789 Y115.195 E-.12234
G1 X163.789 Y116.263 E-.40578
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.66 Y118.989 Z5.8 F12000
G1 X116.388 Y134.391 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.193 J105.494 E.04396
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-103.835 J-.223 E.04404
; LINE_WIDTH: 0.43712
G1 X95.603 Y131.021 E.06228
; LINE_WIDTH: 0.43686
G1 X95.604 Y129.021 E.06224
; LINE_WIDTH: 0.4366
G1 X95.604 Y127.021 E.0622
; LINE_WIDTH: 0.43635
G1 X95.605 Y125.021 E.06216
; LINE_WIDTH: 0.43609
G1 X95.605 Y123.021 E.06212
; LINE_WIDTH: 0.43583
G1 X95.605 Y121.021 E.06207
; LINE_WIDTH: 0.43558
G1 X95.606 Y119.021 E.06203
; LINE_WIDTH: 0.43532
G1 X95.606 Y118.978 E.00134
; LINE_WIDTH: 0.44999
G1 X95.614 Y117.609 E.04402
G2 X96.979 Y117.603 I.196 J-104.785 E.04389
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.603 E.56211
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I102.61 J.204 E.04403
; LINE_WIDTH: 0.43692
G1 X116.396 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.396 Y124.979 E.06221
; LINE_WIDTH: 0.4366
G1 X116.396 Y128.979 E.12439
; LINE_WIDTH: 0.4364
G1 X116.396 Y130.979 E.06216
; LINE_WIDTH: 0.43629
G1 X116.396 Y132.979 E.06215
; LINE_WIDTH: 0.43619
G1 X116.396 Y133.021 E.00133
; LINE_WIDTH: 0.4451
G1 X116.391 Y133.227 E.00652
; LINE_WIDTH: 0.44999
G1 X116.389 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F6000
M204 S3000
G1 X116.548 Y134.798 E.00551
G1 X95.463 Y134.798 E.67799
G1 X95.26 Y134.72 E.00701
G1 X95.202 Y134.56 E.00546
G1 X95.206 Y117.456 E.54997
G1 X95.25 Y117.285 E.00568
G1 X95.44 Y117.202 E.00667
G1 X116.523 Y117.202 E.67793
G1 X116.735 Y117.27 E.00715
G1 X116.797 Y117.466 E.00662
G1 X116.796 Y134.586 E.5505
G1 X116.74 Y134.696 E.00395
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G1 X94.955 Y134.98 E.00748
G3 X94.81 Y134.587 I.838 J-.531 E.01258
G1 X94.814 Y117.35 E.51342
G1 X94.959 Y117.022 E.01067
G1 X95.15 Y116.885 E.00698
G1 X95.413 Y116.81 E.00817
G1 X116.523 Y116.81 E.62878
G1 X116.824 Y116.858 E.00907
G3 X117.136 Y117.161 I-.223 J.542 E.01327
G1 X117.189 Y117.466 E.00924
G1 X117.188 Y133.466 E.47657
G3 X117.167 Y134.715 I-21.982 J.264 E.03719
G3 X116.935 Y135.068 I-.631 J-.163 E.01282
; WIPE_START
M204 S3000
G1 X116.583 Y135.19 E-.14164
G1 X114.955 Y135.19 E-.61836
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.357 Y134.469 Z5.8 F12000
G1 X96.117 Y133.403 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44605
G1 X95.997 Y133.021 E.00543
; LINE_WIDTH: 0.43712
G1 X95.997 Y131.021 E.06228
; LINE_WIDTH: 0.43686
G1 X95.998 Y129.021 E.06224
; LINE_WIDTH: 0.4366
G1 X95.998 Y127.021 E.0622
; LINE_WIDTH: 0.43635
G1 X95.998 Y125.021 E.06216
; LINE_WIDTH: 0.43609
G1 X95.998 Y123.021 E.06212
; LINE_WIDTH: 0.43583
G1 X95.998 Y121.021 E.06207
; LINE_WIDTH: 0.43558
G1 X95.998 Y119.021 E.06203
; LINE_WIDTH: 0.43532
G1 X95.998 Y118.979 E.00133
; LINE_WIDTH: 0.44999
G1 X96.282 Y118.279 E.02428
G1 X96.808 Y118.008 E.01904
; LINE_WIDTH: 0.44624
M73 P83 R3
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.997 E.56211
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02424
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.002 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.002 Y124.979 E.06221
; LINE_WIDTH: 0.4366
G1 X116.002 Y128.979 E.12439
; LINE_WIDTH: 0.4364
G1 X116.002 Y130.979 E.06216
; LINE_WIDTH: 0.43629
G1 X116.002 Y132.979 E.06215
; LINE_WIDTH: 0.43619
G1 X116.002 Y133.021 E.00133
; LINE_WIDTH: 0.4451
G1 X115.992 Y133.192 E.00542
; LINE_WIDTH: 0.44999
G1 X115.719 Y133.721 E.01914
G1 X115.192 Y133.992 E.01907
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00954
M204 S10000
G1 X96.461 Y133.226 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.978 E.45478
G1 X96.569 Y118.567 E.01432
G1 X96.878 Y118.407 E.01121
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01428
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.827 J.022 E.00462
G1 X115.432 Y133.433 E.01126
G1 X115.122 Y133.593 E.01122
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.846 Y118.845 I.24 J-.021 E.00566
G1 X96.979 Y118.79 E.00429
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.00429
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00564
G1 X96.821 Y133.107 E.0016
; WIPE_START
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z5.8 F12000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42188
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17026
G1 X95.955 Y133.998 E-.29487
G1 X96.026 Y133.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y126.324 Z5.8 F12000
G1 X96.029 Y117.96 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.41948
G1 F6000
M204 S3000
G1 X95.958 Y118.001 E.00242
G1 X96.029 Y118.042 E.00242
G1 X96.052 Y118.001 E.0014
; WIPE_START
G1 X96.029 Y118.042 E-.17025
G1 X95.958 Y118.001 E-.29487
G1 X96.029 Y117.96 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.661 Y117.961 Z5.8 F12000
G1 X116.021 Y117.961 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.42146
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00141
; WIPE_START
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y125.594 Z5.8 F12000
G1 X116.02 Y133.958 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y133.998 E.00244
G1 X116.02 Y134.039 E.00244
G1 X116.043 Y133.998 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.02 Y134.039 E-.17027
G1 X115.949 Y133.998 E-.29487
G1 X116.02 Y133.958 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 28/40
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z5.8 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z5.8
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.37446
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01697
G1 X162.416 Y115.757 E.00889
G1 X161.974 Y115.379 E.01522
G1 X162.561 Y115.379 E.01536
; WIPE_START
G1 X162.621 Y116.027 E-.24734
G1 X162.416 Y115.757 E-.12898
G1 X161.974 Y115.379 E-.22083
G1 X162.403 Y115.379 E-.16284
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.484 Y123.011 Z6 F12000
G1 X162.621 Y135.976 Z6
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.37497
G1 F6000
M204 S3000
G1 X162.621 Y136.621 E.01693
G1 X161.972 Y136.621 E.01703
G1 X162.343 Y136.333 E.01232
G1 X162.584 Y136.023 E.0103
; WIPE_START
G1 X162.621 Y136.621 E-.22769
G1 X161.972 Y136.621 E-.24667
G1 X162.343 Y136.333 E-.17846
G1 X162.516 Y136.111 E-.10719
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.886 Y136.27 Z6 F12000
G1 X138.024 Y136.621 Z6
G1 Z5.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.379 Y136.621 E.01693
G1 X137.379 Y135.972 E.01703
G1 X137.667 Y136.343 E.01232
G1 X137.977 Y136.584 E.01031
; WIPE_START
G1 X137.379 Y136.621 E-.22774
G1 X137.379 Y135.972 E-.24669
G1 X137.667 Y136.343 E-.17848
G1 X137.889 Y136.516 E-.10709
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.939 Y128.884 Z6 F12000
G1 X138.027 Y115.379 Z6
G1 Z5.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X137.755 Y115.585 E.00896
G1 X137.379 Y116.026 E.01519
G1 X137.379 Y115.379 E.01697
G1 X137.967 Y115.379 E.01543
; WIPE_START
G1 X137.755 Y115.585 E-.11248
G1 X137.379 Y116.026 E-.22008
G1 X137.379 Y115.379 E-.24584
G1 X137.857 Y115.379 E-.18159
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.489 Y115.421 Z6 F12000
G1 X161.405 Y115.51 Z6
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.45792
G1 F6000
M204 S3000
G1 X161.488 Y115.538 E.00287
; LINE_WIDTH: 0.44999
G1 X161.799 Y115.704 E.01134
G1 X162.121 Y115.98 E.01362
G1 X162.334 Y116.26 E.01132
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.01809
; LINE_WIDTH: 0.43693
G1 X162.603 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.603 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.603 Y134.801 E.17445
; LINE_WIDTH: 0.44897
G1 X162.543 Y135.258 E.01479
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.584 E.01116
G1 X162.093 Y136.061 E.01866
G1 X161.74 Y136.334 E.01434
G1 X161.395 Y136.501 E.01233
G1 X160.868 Y136.601 E.01726
; LINE_WIDTH: 0.43872
G1 X158.868 Y136.601 E.06253
; LINE_WIDTH: 0.43858
G1 X156.868 Y136.601 E.06251
; LINE_WIDTH: 0.43845
G1 X154.868 Y136.601 E.06249
; LINE_WIDTH: 0.43832
G1 X152.868 Y136.601 E.06247
; LINE_WIDTH: 0.43819
G1 X150.868 Y136.602 E.06245
; LINE_WIDTH: 0.43806
G1 X148.868 Y136.602 E.06243
; LINE_WIDTH: 0.43793
G1 X146.868 Y136.602 E.06241
; LINE_WIDTH: 0.4378
G1 X144.868 Y136.602 E.06239
; LINE_WIDTH: 0.43767
G1 X142.868 Y136.602 E.06236
; LINE_WIDTH: 0.43754
G1 X140.868 Y136.603 E.06234
; LINE_WIDTH: 0.43741
G1 X139.2 Y136.603 E.05198
; LINE_WIDTH: 0.44903
G1 X138.743 Y136.543 E.01479
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01116
G1 X137.939 Y136.093 E.01867
G1 X137.666 Y135.74 E.01435
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.801 E.01809
; LINE_WIDTH: 0.43735
G1 X137.397 Y128.801 E.18694
; LINE_WIDTH: 0.43746
G1 X137.398 Y122.801 E.18699
; LINE_WIDTH: 0.43756
G1 X137.398 Y117.168 E.1756
; LINE_WIDTH: 0.44864
G1 X137.447 Y116.773 E.01276
; LINE_WIDTH: 0.44999
G3 X137.907 Y115.939 I2.11 J.621 E.03086
G1 X138.256 Y115.669 E.0142
G1 X138.601 Y115.5 E.01232
G1 X139.132 Y115.399 E.01741
; LINE_WIDTH: 0.43869
G1 X141.132 Y115.399 E.06253
; LINE_WIDTH: 0.43852
G1 X143.132 Y115.399 E.0625
; LINE_WIDTH: 0.43836
G1 X145.132 Y115.399 E.06247
; LINE_WIDTH: 0.4382
G1 X147.132 Y115.399 E.06245
; LINE_WIDTH: 0.43804
G1 X149.132 Y115.398 E.06242
; LINE_WIDTH: 0.43787
G1 X151.132 Y115.398 E.0624
; LINE_WIDTH: 0.43771
G1 X153.132 Y115.398 E.06237
; LINE_WIDTH: 0.43755
G1 X155.132 Y115.398 E.06235
; LINE_WIDTH: 0.43739
G1 X157.132 Y115.398 E.06232
; LINE_WIDTH: 0.43722
G1 X159.132 Y115.398 E.06229
; LINE_WIDTH: 0.43706
G1 X160.8 Y115.397 E.05193
; LINE_WIDTH: 0.45792
G3 X161.158 Y115.427 I.06 J1.458 E.01181
G1 X161.348 Y115.491 E.00657
M204 S10000
G1 X161.304 Y115.926 F12000
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.607 Y116.063 E.0107
G3 X162.113 Y116.732 I-1.039 J1.312 E.02724
G1 X162.202 Y117.199 E.01531
G1 X162.202 Y134.801 E.56598
G1 X162.142 Y135.186 E.01255
G1 X161.925 Y135.627 E.01581
G3 X161.494 Y136.009 I-1.175 J-.892 E.01863
G1 X161.015 Y136.18 E.01637
G1 X160.868 Y136.199 E.00478
G1 X139.2 Y136.202 E.69675
G1 X138.814 Y136.142 E.01254
G1 X138.373 Y135.925 E.01582
G3 X137.887 Y135.268 I1.117 J-1.334 E.02652
G1 X137.798 Y134.801 E.01531
G1 X137.799 Y117.168 E.567
G1 X137.847 Y116.844 E.01052
G1 X138.069 Y116.382 E.01647
G1 X138.183 Y116.239 E.00589
G1 X138.502 Y115.993 E.01297
G1 X138.984 Y115.82 E.01645
G1 X139.132 Y115.801 E.00482
G1 X160.8 Y115.798 E.69675
G1 X161.102 Y115.834 E.00977
G1 X161.25 Y115.901 E.00521
M204 S250
G1 X161.15 Y116.266 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.484 Y116.462 E.01155
G1 X161.73 Y116.816 E.01284
G1 X161.81 Y117.199 E.01167
G1 X161.81 Y134.801 E.52427
G1 X161.733 Y135.179 E.01151
G1 X161.538 Y135.484 E.01078
G1 X161.192 Y135.728 E.01262
G1 X160.867 Y135.807 E.00994
G1 X139.2 Y135.81 E.6454
G1 X138.821 Y135.734 E.01151
G1 X138.516 Y135.538 E.01079
G1 X138.27 Y135.184 E.01284
G1 X138.19 Y134.801 E.01167
G1 X138.191 Y117.168 E.52521
G1 X138.254 Y116.854 E.00953
G1 X138.448 Y116.527 E.01131
G1 X138.805 Y116.273 E.01306
G1 X139.133 Y116.193 E.01004
G1 X160.8 Y116.19 E.6454
G1 X161.096 Y116.24 E.00893
; WIPE_START
M204 S3000
G1 X161.484 Y116.462 E-.16973
G1 X161.73 Y116.816 E-.16385
G1 X161.81 Y117.199 E-.14891
G1 X161.81 Y117.93 E-.27751
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.907 Y115.059 Z6 F12000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.218 E.00577
; LINE_WIDTH: 0.45007
G2 X162.997 Y117.199 I91.132 J.686 E.06374
; LINE_WIDTH: 0.43693
G1 X162.997 Y123.199 E.18674
; LINE_WIDTH: 0.43706
G1 X162.997 Y129.199 E.18681
; LINE_WIDTH: 0.43719
G1 X162.997 Y134.801 E.17445
; LINE_WIDTH: 0.44622
G1 X162.993 Y135.009 E.00666
; LINE_WIDTH: 0.44999
G2 X162.991 Y136.712 I328.057 J1.202 E.05475
G1 X162.924 Y136.925 E.00719
G1 X162.742 Y136.991 E.00623
G2 X160.868 Y136.997 I-.638 J99.223 E.06026
; LINE_WIDTH: 0.43872
G1 X158.868 Y136.997 E.06253
; LINE_WIDTH: 0.43858
G1 X156.868 Y136.997 E.06251
; LINE_WIDTH: 0.43845
G1 X154.868 Y136.997 E.06249
; LINE_WIDTH: 0.43832
G1 X152.868 Y136.997 E.06247
; LINE_WIDTH: 0.43819
G1 X150.868 Y136.997 E.06245
; LINE_WIDTH: 0.43806
G1 X148.868 Y136.997 E.06243
; LINE_WIDTH: 0.43793
G1 X146.868 Y136.997 E.06241
; LINE_WIDTH: 0.4378
G1 X144.868 Y136.997 E.06239
; LINE_WIDTH: 0.43767
G1 X142.868 Y136.997 E.06236
; LINE_WIDTH: 0.43754
G1 X140.868 Y136.997 E.06234
; LINE_WIDTH: 0.43741
G1 X139.2 Y136.997 E.05198
; LINE_WIDTH: 0.44655
G1 X138.991 Y136.993 E.00666
; LINE_WIDTH: 0.44999
G2 X137.288 Y136.991 I-1.215 J360.457 E.05475
G1 X137.074 Y136.924 E.0072
G1 X137.009 Y136.742 E.00623
G2 X137.003 Y134.801 I-93.087 J-.665 E.06241
; LINE_WIDTH: 0.43735
G1 X137.003 Y128.801 E.18694
; LINE_WIDTH: 0.43746
G1 X137.003 Y122.801 E.18699
; LINE_WIDTH: 0.43756
G1 X137.003 Y117.168 E.1756
; LINE_WIDTH: 0.44689
G1 X137.008 Y116.959 E.00667
; LINE_WIDTH: 0.44999
G2 X137.009 Y115.301 I-341.36 J-1.148 E.0533
G1 X137.07 Y115.078 E.00743
G1 X137.268 Y115.009 E.00677
G2 X139.132 Y115.004 I.636 J-98.807 E.05994
; LINE_WIDTH: 0.43869
G1 X141.132 Y115.004 E.06253
; LINE_WIDTH: 0.43852
G1 X143.132 Y115.004 E.0625
; LINE_WIDTH: 0.43836
G1 X145.132 Y115.004 E.06247
; LINE_WIDTH: 0.4382
G1 X147.132 Y115.004 E.06245
; LINE_WIDTH: 0.43804
G1 X149.132 Y115.003 E.06242
; LINE_WIDTH: 0.43787
G1 X151.132 Y115.003 E.0624
; LINE_WIDTH: 0.43771
G1 X153.132 Y115.003 E.06237
; LINE_WIDTH: 0.43755
G1 X155.132 Y115.003 E.06235
; LINE_WIDTH: 0.43739
G1 X157.132 Y115.003 E.06232
; LINE_WIDTH: 0.43722
G1 X159.132 Y115.003 E.06229
; LINE_WIDTH: 0.43706
G1 X160.8 Y115.003 E.05193
; LINE_WIDTH: 0.4425
G1 X160.963 Y115.006 E.00512
; LINE_WIDTH: 0.44999
G2 X162.706 Y115.01 I1.206 J-152.659 E.05605
G1 X162.848 Y115.045 E.00472
M204 S10000
G1 X163.12 Y114.718 F12000
G1 F6000
M204 S3000
G1 X163.319 Y114.92 E.00912
G1 X163.397 Y115.218 E.0099
G1 X163.398 Y135.218 E.64311
G3 X163.367 Y136.919 I-24.879 J.406 E.05472
G1 X163.264 Y137.166 E.00861
; object ids of layer 28 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer28 end: 47,58
M625
G1 X163.048 Y137.324 E.00862
G1 X162.765 Y137.398 E.00939
G1 X138.765 Y137.398 E.77173
G3 X137.081 Y137.367 I-.397 J-24.643 E.05418
M73 P84 R3
G1 X136.834 Y137.264 E.00861
G1 X136.676 Y137.048 E.00861
G1 X136.602 Y136.766 E.00938
G1 X136.602 Y116.766 E.64311
G3 X136.62 Y115.133 I39.382 J-.384 E.05251
G1 X136.743 Y114.825 E.01066
G1 X136.954 Y114.675 E.00831
G1 X137.24 Y114.602 E.0095
G1 X162.78 Y114.603 E.82125
G1 X163.068 Y114.691 E.00968
M204 S250
G1 X163.414 Y114.432 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.44 Y114.448 E.00092
G1 X163.664 Y114.722 E.01055
G3 X163.789 Y115.217 I-1.498 J.642 E.01528
G1 X163.79 Y136.685 E.63942
G1 X163.726 Y137.144 E.0138
G1 X163.576 Y137.411 E.00914
G1 X163.35 Y137.62 E.00915
G1 X163.025 Y137.762 E.01056
G1 X162.789 Y137.79 E.00709
G1 X137.315 Y137.79 E.75875
G1 X136.856 Y137.726 E.0138
G1 X136.589 Y137.576 E.00914
G1 X136.38 Y137.35 E.00915
G1 X136.238 Y137.025 E.01056
G1 X136.21 Y136.789 E.00709
G1 X136.21 Y115.301 E.64002
G1 X136.26 Y114.897 E.01214
G1 X136.427 Y114.586 E.01051
G1 X136.616 Y114.403 E.00783
G1 X136.935 Y114.248 E.01057
G1 X137.213 Y114.21 E.00836
G1 X162.706 Y114.211 E.75931
G1 X163.18 Y114.289 E.01431
G1 X163.362 Y114.401 E.00638
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.44 Y114.448 E-.0345
G1 X163.664 Y114.722 E-.13458
G1 X163.722 Y114.879 E-.06358
G1 X163.789 Y115.217 E-.13106
G1 X163.789 Y116.26 E-.39628
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.66 Y118.987 Z6 F12000
G1 X116.391 Y134.391 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.611 E.04403
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.603 E.56211
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.472 J.191 E.04403
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.715 Y134.742 F12000
G1 F6000
M204 S3000
G1 X116.56 Y134.798 E.0053
G1 X95.463 Y134.798 E.67837
G1 X95.251 Y134.712 E.00738
G1 X95.202 Y134.548 E.0055
G1 X95.202 Y117.463 E.54937
G1 X95.28 Y117.26 E.00701
G1 X95.441 Y117.202 E.00548
G1 X116.523 Y117.202 E.6779
G1 X116.735 Y117.27 E.00718
G1 X116.797 Y117.467 E.00663
G1 X116.798 Y134.537 E.54888
G1 X116.739 Y134.689 E.00525
M204 S250
G1 X116.85 Y135.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X116.587 Y135.19 I-.401 J-.907 E.00818
G1 X95.495 Y135.19 E.62823
G1 X95.155 Y135.132 E.01027
G3 X94.898 Y134.886 I.548 J-.831 E.01066
G1 X94.81 Y134.583 E.0094
G1 X94.81 Y117.495 E.50897
G1 X94.868 Y117.155 E.01029
G1 X95.02 Y116.955 E.00747
G3 X95.414 Y116.81 I.531 J.837 E.0126
G1 X116.523 Y116.81 E.62875
G1 X116.824 Y116.858 E.00909
G3 X117.135 Y117.16 I-.223 J.542 E.01324
G1 X117.189 Y117.467 E.00928
G1 X117.19 Y134.505 E.50748
G1 X117.132 Y134.845 E.01029
G1 X116.98 Y135.045 E.00746
G3 X116.904 Y135.089 I-.532 J-.838 E.00262
; WIPE_START
M204 S3000
G1 X116.587 Y135.19 E-.12659
G1 X114.92 Y135.19 E-.63342
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.322 Y134.468 Z6 F12000
G1 X96.117 Y133.403 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.997 E.56211
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02423
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z6 F12000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z6 F12000
G1 X96.026 Y117.961 Z6
G1 Z5.6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
M73 P84 R2
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z6 F12000
G1 X116.021 Y117.961 Z6
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.42152
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; WIPE_START
G1 X116.021 Y118.043 E-.17025
G1 X115.95 Y118.002 E-.29488
G1 X116.021 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z6 F12000
G1 X116.021 Y133.957 Z6
G1 Z5.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 29/40
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z6 I.451 J1.13 P1  F12000
G1 X162.621 Y115.379 Z6
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.37444
G1 F6000
M204 S3000
G1 X162.621 Y116.027 E.01697
G1 X162.333 Y115.657 E.01227
G1 X161.976 Y115.379 E.01184
G1 X162.561 Y115.379 E.0153
; WIPE_START
G1 X162.621 Y116.027 E-.24726
G1 X162.333 Y115.657 E-.17811
G1 X161.976 Y115.379 E-.17176
G1 X162.405 Y115.379 E-.16287
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.484 Y123.011 Z6.2 F12000
G1 X162.618 Y135.98 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.37397
G1 F6000
M204 S3000
G1 X162.618 Y136.622 E.01678
G1 X161.971 Y136.622 E.01693
G1 X162.341 Y136.334 E.01226
G1 X162.581 Y136.027 E.01019
; WIPE_START
G1 X162.618 Y136.622 E-.22636
G1 X161.971 Y136.622 E-.24602
G1 X162.341 Y136.334 E-.1781
G1 X162.519 Y136.107 E-.10952
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X154.888 Y136.266 Z6.2 F12000
G1 X138.02 Y136.618 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.37396
G1 F6000
M204 S3000
G1 X137.378 Y136.618 E.01678
G1 X137.378 Y135.971 E.01693
G1 X137.666 Y136.341 E.01225
M73 P85 R2
G1 X137.973 Y136.581 E.01019
; WIPE_START
G1 X137.378 Y136.618 E-.22636
G1 X137.378 Y135.971 E-.24599
G1 X137.666 Y136.341 E-.17808
G1 X137.893 Y136.519 E-.10958
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.942 Y128.886 Z6.2 F12000
G1 X138.029 Y115.378 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.37392
G1 F6000
M204 S3000
G1 X137.758 Y115.583 E.00888
G1 X137.382 Y116.022 E.01513
G1 X137.382 Y115.378 E.01684
G1 X137.969 Y115.378 E.01536
; WIPE_START
G1 X137.758 Y115.583 E-.11167
G1 X137.382 Y116.022 E-.21987
G1 X137.382 Y115.378 E-.24468
G1 X137.865 Y115.378 E-.18378
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X145.498 Y115.426 Z6.2 F12000
G1 X161.443 Y115.526 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X161.583 Y115.577 E.00481
G1 X162.061 Y115.907 E.01867
G1 X162.334 Y116.26 E.01434
G1 X162.511 Y116.644 E.0136
G1 X162.603 Y117.199 E.0181
; LINE_WIDTH: 0.43672
G1 X162.602 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.602 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.602 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.602 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.602 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.602 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.602 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.602 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.602 Y134.8 E.04968
; LINE_WIDTH: 0.44852
G1 X162.542 Y135.258 E.01478
; LINE_WIDTH: 0.44999
G1 X162.423 Y135.584 E.01117
G1 X162.092 Y136.062 E.0187
G1 X161.74 Y136.334 E.01429
G1 X161.356 Y136.511 E.0136
G1 X160.801 Y136.603 E.01809
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.603 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.603 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.603 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.602 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.602 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.602 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.602 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.602 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.602 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.602 E.06208
; LINE_WIDTH: 0.43575
G1 X139.2 Y136.602 E.04969
; LINE_WIDTH: 0.44856
G1 X138.742 Y136.542 E.01477
; LINE_WIDTH: 0.44999
G1 X138.417 Y136.423 E.01116
G1 X137.938 Y136.092 E.01872
G1 X137.666 Y135.74 E.01429
G1 X137.489 Y135.356 E.0136
G1 X137.397 Y134.801 E.0181
; LINE_WIDTH: 0.43715
G1 X137.397 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.398 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.398 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.398 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.398 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.398 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.398 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.398 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.399 Y117.168 E.05071
; LINE_WIDTH: 0.4479
G1 X137.448 Y116.773 E.01274
; LINE_WIDTH: 0.44999
G3 X138.26 Y115.666 I1.783 J.458 E.04523
G1 X138.643 Y115.49 E.01357
G1 X139.199 Y115.397 E.01812
; LINE_WIDTH: 0.43729
G1 X145.199 Y115.397 E.18691
; LINE_WIDTH: 0.43718
G1 X153.199 Y115.397 E.24915
; LINE_WIDTH: 0.43705
G1 X159.199 Y115.397 E.1868
; LINE_WIDTH: 0.43694
G1 X160.8 Y115.397 E.04983
; LINE_WIDTH: 0.44892
G1 X161.258 Y115.457 E.01479
; LINE_WIDTH: 0.44999
G1 X161.387 Y115.505 E.00442
M204 S10000
G1 X161.336 Y115.931 F12000
G1 F6000
M204 S3000
G1 X161.627 Y116.075 E.01044
G3 X162.113 Y116.731 I-1.117 J1.334 E.02652
G1 X162.202 Y117.199 E.01532
G1 X162.202 Y134.801 E.56597
G1 X162.142 Y135.186 E.01255
G1 X161.925 Y135.627 E.0158
G3 X161.268 Y136.113 I-1.335 J-1.118 E.02652
G1 X160.801 Y136.202 E.01531
G1 X139.199 Y136.202 E.6946
G1 X138.814 Y136.142 E.01255
G1 X138.373 Y135.926 E.0158
G1 X138.238 Y135.817 E.00557
G1 X137.991 Y135.494 E.01306
G1 X137.887 Y135.269 E.008
G1 X137.798 Y134.801 E.01532
G1 X137.799 Y117.168 E.56699
G1 X137.847 Y116.844 E.01053
G1 X138.07 Y116.381 E.01653
G3 X138.731 Y115.887 I1.318 J1.075 E.02679
G1 X139.199 Y115.798 E.01534
G1 X160.8 Y115.798 E.6946
G1 X161.186 Y115.858 E.01255
G1 X161.282 Y115.905 E.00344
M204 S250
G1 X161.171 Y116.265 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X161.179 Y116.267 E.00025
G1 X161.484 Y116.462 E.01078
G1 X161.73 Y116.816 E.01284
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.8 E.52426
G1 X161.733 Y135.18 E.01152
G1 X161.538 Y135.484 E.01077
G1 X161.184 Y135.73 E.01284
G1 X160.801 Y135.81 E.01167
G1 X139.2 Y135.81 E.64341
G1 X138.821 Y135.733 E.01151
G1 X138.527 Y135.552 E.01027
G1 X138.27 Y135.184 E.01337
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.168 E.52521
G1 X138.254 Y116.854 E.00955
G1 X138.463 Y116.515 E.01185
G1 X138.815 Y116.27 E.01278
G1 X139.199 Y116.19 E.01169
G1 X160.8 Y116.19 E.64341
G1 X161.112 Y116.253 E.00948
; WIPE_START
M204 S3000
G1 X161.179 Y116.267 E-.02597
G1 X161.484 Y116.462 E-.13751
G1 X161.73 Y116.816 E-.16379
G1 X161.81 Y117.199 E-.14898
G1 X161.81 Y117.946 E-.28375
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.893 Y115.05 Z6.2 F12000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X162.99 Y115.221 E.00633
; LINE_WIDTH: 0.45006
G2 X162.996 Y117.199 I90.008 J.698 E.06362
; LINE_WIDTH: 0.43672
G1 X162.996 Y119.199 E.06221
; LINE_WIDTH: 0.43659
G1 X162.996 Y121.199 E.06219
; LINE_WIDTH: 0.43647
G1 X162.996 Y123.199 E.06218
; LINE_WIDTH: 0.43634
G1 X162.996 Y125.199 E.06215
; LINE_WIDTH: 0.43622
G1 X162.995 Y127.199 E.06214
; LINE_WIDTH: 0.43609
G1 X162.995 Y129.199 E.06212
; LINE_WIDTH: 0.43597
G1 X162.995 Y131.199 E.0621
; LINE_WIDTH: 0.43584
G1 X162.995 Y133.199 E.06208
; LINE_WIDTH: 0.43572
G1 X162.995 Y134.8 E.04968
; LINE_WIDTH: 0.44457
G1 X162.99 Y135.009 E.00662
; LINE_WIDTH: 0.44999
G2 X162.987 Y136.742 I233.095 J1.26 E.05571
G1 X162.936 Y136.916 E.00583
G1 X162.752 Y136.991 E.00641
G2 X160.801 Y136.997 I-.685 J92.314 E.06273
; LINE_WIDTH: 0.43717
G1 X158.801 Y136.997 E.06229
; LINE_WIDTH: 0.43702
G1 X156.801 Y136.997 E.06226
; LINE_WIDTH: 0.43688
G1 X154.801 Y136.996 E.06224
; LINE_WIDTH: 0.43674
G1 X152.801 Y136.996 E.06222
; LINE_WIDTH: 0.4366
G1 X150.801 Y136.996 E.0622
; LINE_WIDTH: 0.43646
G1 X148.801 Y136.996 E.06217
; LINE_WIDTH: 0.43632
G1 X146.801 Y136.995 E.06215
; LINE_WIDTH: 0.43617
G1 X144.801 Y136.995 E.06213
; LINE_WIDTH: 0.43603
G1 X142.801 Y136.995 E.06211
; LINE_WIDTH: 0.43589
G1 X140.801 Y136.995 E.06208
; LINE_WIDTH: 0.43575
G1 X139.2 Y136.995 E.04969
; LINE_WIDTH: 0.44486
G1 X138.991 Y136.99 E.00662
; LINE_WIDTH: 0.44999
G2 X137.258 Y136.987 I-1.264 J245.437 E.05572
G1 X137.083 Y136.935 E.00587
G1 X137.009 Y136.751 E.00638
G2 X137.003 Y134.801 I-92.287 J-.687 E.06272
; LINE_WIDTH: 0.43715
G1 X137.003 Y132.801 E.06228
; LINE_WIDTH: 0.43701
G1 X137.004 Y130.801 E.06226
; LINE_WIDTH: 0.43688
G1 X137.004 Y128.801 E.06224
; LINE_WIDTH: 0.43675
G1 X137.004 Y126.801 E.06222
; LINE_WIDTH: 0.43661
G1 X137.004 Y124.801 E.0622
; LINE_WIDTH: 0.43648
G1 X137.005 Y122.801 E.06218
; LINE_WIDTH: 0.43635
G1 X137.005 Y120.801 E.06216
; LINE_WIDTH: 0.43622
G1 X137.005 Y118.801 E.06214
; LINE_WIDTH: 0.43608
G1 X137.005 Y117.168 E.05071
; LINE_WIDTH: 0.4452
G1 X137.01 Y116.959 E.00663
; LINE_WIDTH: 0.44999
G2 X137.013 Y115.257 I-227.53 J-1.209 E.05472
G1 X137.064 Y115.085 E.0058
G1 X137.249 Y115.009 E.00643
G2 X139.199 Y115.003 I.674 J-93.443 E.06272
; LINE_WIDTH: 0.43729
G1 X145.199 Y115.003 E.18691
; LINE_WIDTH: 0.43718
G1 X153.199 Y115.003 E.24915
; LINE_WIDTH: 0.43705
G1 X159.199 Y115.003 E.1868
; LINE_WIDTH: 0.43694
G1 X160.8 Y115.003 E.04983
; LINE_WIDTH: 0.44616
G1 X161.009 Y115.008 E.00665
; LINE_WIDTH: 0.44999
G2 X162.706 Y115.01 I1.222 J-320.514 E.05457
G1 X162.834 Y115.037 E.00421
M204 S10000
G1 X163.121 Y114.718 F12000
G1 F6000
M204 S3000
G1 X163.314 Y114.912 E.00881
G1 X163.397 Y115.195 E.00947
G1 X163.394 Y136.823 E.69548
G1 X163.298 Y137.104 E.00954
; object ids of layer 29 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer29 end: 47,58
M625
G1 X163.113 Y137.3 E.00865
G1 X162.771 Y137.398 E.01144
G1 X137.177 Y137.394 E.82301
G1 X136.896 Y137.298 E.00955
G1 X136.701 Y137.115 E.00859
G1 X136.602 Y136.771 E.0115
G1 X136.606 Y115.177 E.69438
G1 X136.702 Y114.896 E.00955
G1 X136.887 Y114.7 E.00867
G1 X137.229 Y114.602 E.01143
G1 X162.781 Y114.603 E.82165
G1 X163.068 Y114.692 E.00967
M204 S250
G1 X163.413 Y114.432 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.44 Y114.448 E.00094
G1 X163.661 Y114.718 E.01039
G3 X163.789 Y115.195 I-2.085 J.815 E.01474
G1 X163.786 Y136.742 E.64179
G1 X163.712 Y137.18 E.01324
G1 X163.551 Y137.441 E.00914
G1 X163.318 Y137.641 E.00915
G3 X162.79 Y137.79 I-.741 J-1.613 E.01638
G1 X137.258 Y137.786 E.7605
G1 X136.82 Y137.712 E.01323
G1 X136.557 Y137.55 E.0092
G1 X136.36 Y137.319 E.00903
G3 X136.21 Y136.79 I1.601 J-.741 E.01645
G1 X136.214 Y115.257 E.64137
G1 X136.288 Y114.82 E.0132
G1 X136.449 Y114.559 E.00914
G1 X136.683 Y114.359 E.00917
G3 X137.21 Y114.21 I.735 J1.593 E.01637
G1 X162.706 Y114.211 E.75944
G1 X163.181 Y114.289 E.01435
G1 X163.362 Y114.4 E.00631
; OBJECT_ID: 47
; WIPE_START
M204 S3000
G1 X163.44 Y114.448 E-.03475
G1 X163.661 Y114.718 E-.13254
G1 X163.718 Y114.881 E-.06578
G1 X163.789 Y115.195 E-.1222
G1 X163.789 Y116.26 E-.40473
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X156.66 Y118.987 Z6.2 F12000
G1 X116.388 Y134.391 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.196 J104.919 E.04396
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-104.308 J-.212 E.04403
; LINE_WIDTH: 0.43721
G1 X95.603 Y131.021 E.06229
; LINE_WIDTH: 0.43707
G1 X95.603 Y129.021 E.06227
; LINE_WIDTH: 0.43693
G1 X95.604 Y127.021 E.06225
; LINE_WIDTH: 0.43679
G1 X95.604 Y125.021 E.06223
; LINE_WIDTH: 0.43665
G1 X95.604 Y123.021 E.0622
; LINE_WIDTH: 0.43651
G1 X95.604 Y121.021 E.06218
; LINE_WIDTH: 0.43637
G1 X95.604 Y119.021 E.06216
; LINE_WIDTH: 0.43623
G1 X95.604 Y118.978 E.00134
; LINE_WIDTH: 0.44999
G1 X95.612 Y117.609 E.04403
G2 X96.979 Y117.603 I.196 J-105.252 E.04396
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.603 E.56211
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I102.614 J.204 E.04403
; LINE_WIDTH: 0.43692
G1 X116.396 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.396 Y126.979 E.12443
; LINE_WIDTH: 0.4365
G1 X116.396 Y130.979 E.12436
; LINE_WIDTH: 0.4363
G1 X116.396 Y133.021 E.06348
; LINE_WIDTH: 0.44512
G1 X116.391 Y133.227 E.00652
; LINE_WIDTH: 0.44999
G1 X116.389 Y134.331 E.03551
M204 S10000
G1 X116.72 Y134.74 F12000
G1 F6000
M204 S3000
G1 X116.56 Y134.798 E.00547
G1 X95.463 Y134.798 E.67836
G1 X95.251 Y134.712 E.00737
G1 X95.202 Y134.548 E.00551
G1 X95.204 Y117.414 E.55097
G1 X95.288 Y117.25 E.00589
G1 X95.452 Y117.202 E.00551
G1 X116.522 Y117.202 E.67751
G1 X116.737 Y117.271 E.00726
G1 X116.797 Y117.47 E.00667
G1 X116.796 Y134.586 E.5504
G1 X116.746 Y134.686 E.00358
M204 S250
G1 X116.854 Y135.113 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X116.587 Y135.19 I-.41 J-.919 E.0083
G1 X95.495 Y135.19 E.62823
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.548 J-.83 E.01065
G1 X94.81 Y134.583 E.0094
G1 X94.812 Y118.583 E.47657
G3 X94.833 Y117.286 I22.907 J-.288 E.03866
G3 X95.114 Y116.898 I.632 J.163 E.01462
G1 X95.417 Y116.81 E.00939
G1 X116.522 Y116.81 E.62861
G1 X116.824 Y116.858 E.00912
G3 X117.132 Y117.153 I-.223 J.541 E.01299
G1 X117.189 Y117.47 E.00959
G1 X117.188 Y134.545 E.5086
G1 X117.134 Y134.842 E.009
G1 X116.98 Y135.045 E.00758
G3 X116.908 Y135.087 I-.537 J-.851 E.0025
; WIPE_START
M204 S3000
G1 X116.587 Y135.19 E-.12812
G1 X114.924 Y135.19 E-.63189
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.327 Y134.458 Z6.2 F12000
G1 X96.103 Y133.376 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44614
G1 X95.997 Y133.021 E.00543
; LINE_WIDTH: 0.43721
G1 X95.997 Y131.021 E.06229
; LINE_WIDTH: 0.43707
G1 X95.997 Y129.021 E.06227
; LINE_WIDTH: 0.43693
G1 X95.997 Y127.021 E.06225
; LINE_WIDTH: 0.43679
G1 X95.998 Y125.021 E.06223
; LINE_WIDTH: 0.43665
G1 X95.998 Y123.021 E.0622
; LINE_WIDTH: 0.43651
G1 X95.998 Y121.021 E.06218
; LINE_WIDTH: 0.43637
G1 X95.998 Y119.021 E.06216
; LINE_WIDTH: 0.43623
G1 X95.998 Y118.979 E.00133
; LINE_WIDTH: 0.44999
G1 X96.281 Y118.279 E.02426
G1 X96.808 Y118.008 E.01907
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.997 E.56211
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02424
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.002 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.002 Y126.979 E.12443
; LINE_WIDTH: 0.4365
G1 X116.002 Y130.979 E.12436
; LINE_WIDTH: 0.4363
G1 X116.002 Y133.021 E.06348
; LINE_WIDTH: 0.44512
G1 X115.992 Y133.192 E.00542
; LINE_WIDTH: 0.44999
G1 X115.719 Y133.721 E.01914
G1 X115.192 Y133.992 E.01907
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.429 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00283
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.978 E.45156
M73 P86 R2
G1 X96.568 Y118.568 E.01431
G1 X96.878 Y118.407 E.01122
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01428
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.827 J.022 E.00462
G1 X115.432 Y133.433 E.01126
G1 X115.122 Y133.593 E.01122
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.00429
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.00429
G1 X96.979 Y133.21 E.53742
G1 X96.845 Y133.155 E.0043
G1 X96.813 Y133.077 E.00251
; WIPE_START
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z6.2 F12000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42192
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17026
G1 X95.955 Y133.998 E-.29487
G1 X96.026 Y133.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y126.324 Z6.2 F12000
G1 X96.027 Y117.961 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.42062
G1 F6000
M204 S3000
G1 X95.957 Y118.002 E.00244
G1 X96.027 Y118.042 E.00244
G1 X96.051 Y118.002 E.00141
; WIPE_START
G1 X96.027 Y118.042 E-.17027
G1 X95.957 Y118.002 E-.29487
G1 X96.027 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.66 Y117.961 Z6.2 F12000
G1 X116.021 Y117.961 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.42148
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; WIPE_START
G1 X116.021 Y118.043 E-.17025
G1 X115.95 Y118.002 E-.29488
G1 X116.021 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y125.594 Z6.2 F12000
G1 X116.02 Y133.958 Z6.2
G1 Z5.8
G1 E.8 F1800
; LINE_WIDTH: 0.4206
G1 F6000
M204 S3000
G1 X115.949 Y133.998 E.00244
G1 X116.02 Y134.039 E.00244
G1 X116.043 Y133.998 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.02 Y134.039 E-.17027
G1 X115.949 Y133.998 E-.29487
G1 X116.02 Y133.958 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 30/40
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change
M106 S51
; OBJECT_ID: 58
; start printing object, unique label id: 58
M624 AgAAAAAAAAA=
M204 S10000
G17
G3 Z6.2 I.464 J1.125 P1  F12000
G1 X163.412 Y114.431 Z6.2
G1 Z6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X163.44 Y114.448 E.00098
G1 X163.663 Y114.72 E.01046
G3 X163.789 Y115.216 I-1.466 J.638 E.01531
G1 X163.79 Y136.685 E.63948
G1 X163.726 Y137.144 E.0138
; object ids of layer 30 start: 47,58
M624 AwAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer30 end: 47,58
M625
G1 X163.577 Y137.41 E.00907
G3 X163.182 Y137.701 I-1.21 J-1.224 E.01466
G1 X162.787 Y137.79 E.01208
G1 X137.301 Y137.79 E.7591
G1 X136.897 Y137.74 E.01215
G1 X136.589 Y137.575 E.01038
G3 X136.299 Y137.183 I1.23 J-1.213 E.0146
G1 X136.21 Y136.787 E.01208
G1 X136.214 Y115.267 E.64098
G1 X136.304 Y114.785 E.01461
G1 X136.476 Y114.528 E.00921
G1 X136.809 Y114.302 E.01199
G1 X137.213 Y114.21 E.01234
G1 X162.708 Y114.211 E.75938
G1 X163.18 Y114.289 E.01424
G1 X163.361 Y114.4 E.00632
; WIPE_START
M204 S3000
G1 X163.44 Y114.448 E-.03528
G1 X163.663 Y114.72 E-.13343
G1 X163.726 Y114.891 E-.06955
G1 X163.789 Y115.216 E-.12554
G1 X163.789 Y116.258 E-.3962
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X161.172 Y116.265 Z6.4 F12000
G1 Z6
G1 E.8 F1800
G1 F3600
M204 S1500
G1 X161.18 Y116.267 E.00024
G1 X161.484 Y116.462 E.01076
G1 X161.73 Y116.816 E.01285
G1 X161.81 Y117.199 E.01168
G1 X161.81 Y134.801 E.52427
G1 X161.757 Y135.112 E.00939
G1 X161.538 Y135.484 E.01286
G1 X161.191 Y135.729 E.01265
G1 X160.865 Y135.807 E.01001
G1 X139.199 Y135.81 E.64533
G1 X138.888 Y135.757 E.00939
G1 X138.516 Y135.538 E.01286
G1 X138.27 Y135.184 E.01285
G1 X138.19 Y134.801 E.01168
G1 X138.191 Y117.167 E.52522
G1 X138.254 Y116.854 E.00952
G1 X138.458 Y116.519 E.0117
G1 X138.775 Y116.287 E.01169
G1 X139.135 Y116.193 E.01108
G1 X160.801 Y116.19 E.64533
G1 X161.113 Y116.253 E.00949
; WIPE_START
M204 S3000
G1 X161.18 Y116.267 E-.02581
G1 X161.484 Y116.462 E-.13727
G1 X161.73 Y116.816 E-.16387
G1 X161.81 Y117.199 E-.14897
G1 X161.81 Y117.947 E-.28408
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.529 Y125.546 Z6.4 F12000
G1 X163.583 Y136.681 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F3600
M204 S2000
G1 X162.681 Y137.583 E.038
G1 X162.147 Y137.583
G1 X163.583 Y136.147 E.06046
G1 X163.583 Y135.614
G1 X161.614 Y137.583 E.08293
G1 X161.081 Y137.583
G1 X163.583 Y135.081 E.10539
G1 X163.583 Y134.548
G1 X160.547 Y137.583 E.12785
G1 X160.014 Y137.583
G1 X163.583 Y134.014 E.15031
G1 X163.582 Y133.481
G1 X161.982 Y135.082 E.06743
G1 X162.017 Y134.513
G1 X163.582 Y132.948 E.06593
G1 X163.582 Y132.415
G1 X162.017 Y133.98 E.06593
G1 X162.017 Y133.446
G1 X163.582 Y131.881 E.06593
G1 X163.582 Y131.348
G1 X162.017 Y132.913 E.06593
G1 X162.017 Y132.38
G1 X163.582 Y130.815 E.06592
G1 X163.582 Y130.282
G1 X162.017 Y131.847 E.06592
G1 X162.017 Y131.313
G1 X163.582 Y129.748 E.06592
G1 X163.582 Y129.215
G1 X162.017 Y130.78 E.06592
G1 X162.017 Y130.247
G1 X163.582 Y128.682 E.06592
G1 X163.582 Y128.149
G1 X162.017 Y129.714 E.06592
G1 X162.017 Y129.18
G1 X163.582 Y127.616 E.06592
G1 X163.582 Y127.082
G1 X162.017 Y128.647 E.06592
G1 X162.017 Y128.114
G1 X163.582 Y126.549 E.06592
G1 X163.582 Y126.016
G1 X162.017 Y127.581 E.06592
G1 X162.017 Y127.047
G1 X163.582 Y125.483 E.06591
G1 X163.582 Y124.949
G1 X162.017 Y126.514 E.06591
G1 X162.017 Y125.981
G1 X163.582 Y124.416 E.06591
G1 X163.582 Y123.883
G1 X162.017 Y125.448 E.06591
G1 X162.017 Y124.914
G1 X163.582 Y123.35 E.06591
G1 X163.582 Y122.816
G1 X162.017 Y124.381 E.06591
G1 X162.017 Y123.848
G1 X163.582 Y122.283 E.06591
G1 X163.582 Y121.75
G1 X162.017 Y123.315 E.06591
G1 X162.017 Y122.781
G1 X163.582 Y121.217 E.06591
G1 X163.582 Y120.683
G1 X162.017 Y122.248 E.06591
G1 X162.017 Y121.715
G1 X163.582 Y120.15 E.06591
G1 X163.582 Y119.617
G1 X162.017 Y121.182 E.0659
G1 X162.017 Y120.648
G1 X163.582 Y119.084 E.0659
G1 X163.582 Y118.551
G1 X162.017 Y120.115 E.0659
G1 X162.017 Y119.582
G1 X163.582 Y118.017 E.0659
G1 X163.582 Y117.484
G1 X162.017 Y119.048 E.0659
G1 X162.017 Y118.515
G1 X163.582 Y116.951 E.0659
G1 X163.582 Y116.418
G1 X162.017 Y117.982 E.0659
G1 X162.017 Y117.449
G1 X163.582 Y115.884 E.0659
G1 X163.582 Y115.351
G1 X161.971 Y116.962 E.06787
G1 X161.827 Y116.572
G1 X163.506 Y114.894 E.0707
G1 X163.276 Y114.591
G1 X161.585 Y116.281 E.07121
G1 X161.256 Y116.077
G1 X162.895 Y114.438 E.06902
G1 X162.382 Y114.418
G1 X160.815 Y115.985 E.06599
G1 X160.284 Y115.983
G1 X161.848 Y114.418 E.0659
G1 X161.315 Y114.418
G1 X159.751 Y115.983 E.06591
G1 X159.217 Y115.983
G1 X160.782 Y114.418 E.06591
G1 X160.249 Y114.418
G1 X158.684 Y115.983 E.06591
G1 X158.151 Y115.983
G1 X159.715 Y114.418 E.06592
G1 X159.182 Y114.418
G1 X157.617 Y115.983 E.06592
G1 X157.084 Y115.983
G1 X158.649 Y114.418 E.06592
G1 X158.116 Y114.418
G1 X156.551 Y115.983 E.06593
G1 X156.017 Y115.983
G1 X157.582 Y114.418 E.06593
G1 X157.049 Y114.418
M73 P87 R2
G1 X155.484 Y115.983 E.06593
G1 X154.951 Y115.983
G1 X156.516 Y114.418 E.06594
G1 X155.983 Y114.418
G1 X154.417 Y115.983 E.06594
G1 X153.884 Y115.983
G1 X155.449 Y114.418 E.06594
G1 X154.916 Y114.418
G1 X153.351 Y115.984 E.06595
G1 X152.817 Y115.984
G1 X154.383 Y114.418 E.06595
G1 X153.85 Y114.418
G1 X152.284 Y115.984 E.06595
G1 X151.751 Y115.984
G1 X153.316 Y114.418 E.06596
G1 X152.783 Y114.418
G1 X151.217 Y115.984 E.06596
G1 X150.684 Y115.984
G1 X152.25 Y114.418 E.06596
G1 X151.717 Y114.418
G1 X150.151 Y115.984 E.06597
G1 X149.617 Y115.984
G1 X151.184 Y114.418 E.06597
G1 X150.65 Y114.418
G1 X149.084 Y115.984 E.06597
G1 X148.551 Y115.984
G1 X150.117 Y114.418 E.06598
G1 X149.584 Y114.418
G1 X148.018 Y115.984 E.06598
G1 X147.484 Y115.984
G1 X149.051 Y114.418 E.06598
G1 X148.517 Y114.418
G1 X146.951 Y115.984 E.06599
G1 X146.418 Y115.984
G1 X147.984 Y114.418 E.06599
G1 X147.451 Y114.418
G1 X145.884 Y115.984 E.06599
G1 X145.351 Y115.984
G1 X146.918 Y114.418 E.066
G1 X146.384 Y114.418
G1 X144.818 Y115.984 E.066
G1 X144.284 Y115.985
G1 X145.851 Y114.418 E.066
G1 X145.318 Y114.418
G1 X143.751 Y115.985 E.06601
G1 X143.218 Y115.985
G1 X144.785 Y114.418 E.06601
G1 X144.251 Y114.418
G1 X142.684 Y115.985 E.06601
G1 X142.151 Y115.985
G1 X143.718 Y114.418 E.06602
G1 X143.185 Y114.418
G1 X141.618 Y115.985 E.06602
G1 X141.084 Y115.985
G1 X142.652 Y114.418 E.06602
G1 X142.118 Y114.418
G1 X140.551 Y115.985 E.06603
G1 X140.018 Y115.985
G1 X141.585 Y114.418 E.06603
G1 X141.052 Y114.418
G1 X139.484 Y115.985 E.06603
G1 X138.892 Y116.045
G1 X140.519 Y114.417 E.06855
; WIPE_START
M204 S3000
G1 X139.105 Y115.832 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X144.735 Y120.984 Z6.4 F12000
G1 X161.102 Y135.961 Z6.4
G1 Z6
G1 E.8 F1800
G1 F3600
M204 S2000
G1 X159.481 Y137.583 E.06829
G1 X158.948 Y137.583
G1 X160.515 Y136.015 E.06604
G1 X159.982 Y136.015
G1 X158.414 Y137.583 E.06604
G1 X157.881 Y137.583
G1 X159.449 Y136.015 E.06603
G1 X158.915 Y136.015
G1 X157.348 Y137.583 E.06603
G1 X156.815 Y137.583
G1 X158.382 Y136.015 E.06603
G1 X157.849 Y136.015
G1 X156.281 Y137.583 E.06603
G1 X155.748 Y137.583
G1 X157.316 Y136.015 E.06602
G1 X156.782 Y136.015
G1 X155.215 Y137.583 E.06602
G1 X154.682 Y137.583
G1 X156.249 Y136.015 E.06602
G1 X155.716 Y136.015
G1 X154.148 Y137.583 E.06602
G1 X153.615 Y137.583
G1 X155.182 Y136.016 E.06601
G1 X154.649 Y136.016
G1 X153.082 Y137.583 E.06601
G1 X152.549 Y137.583
G1 X154.116 Y136.016 E.06601
G1 X153.582 Y136.016
G1 X152.015 Y137.583 E.06601
G1 X151.482 Y137.583
G1 X153.049 Y136.016 E.066
G1 X152.516 Y136.016
G1 X150.949 Y137.583 E.066
G1 X150.416 Y137.583
G1 X151.982 Y136.016 E.066
G1 X151.449 Y136.016
G1 X149.882 Y137.583 E.066
G1 X149.349 Y137.583
G1 X150.916 Y136.016 E.06599
G1 X150.382 Y136.016
G1 X148.816 Y137.583 E.06599
G1 X148.283 Y137.583
G1 X149.849 Y136.016 E.06599
G1 X149.316 Y136.016
G1 X147.749 Y137.583 E.06598
G1 X147.216 Y137.583
G1 X148.782 Y136.016 E.06598
G1 X148.249 Y136.016
G1 X146.683 Y137.583 E.06598
G1 X146.15 Y137.583
G1 X147.716 Y136.016 E.06598
G1 X147.182 Y136.016
G1 X145.616 Y137.583 E.06597
G1 X145.083 Y137.583
G1 X146.649 Y136.017 E.06597
G1 X146.116 Y136.017
G1 X144.55 Y137.583 E.06597
G1 X144.016 Y137.583
G1 X145.582 Y136.017 E.06597
G1 X145.049 Y136.017
G1 X143.483 Y137.583 E.06596
G1 X142.95 Y137.583
G1 X144.516 Y136.017 E.06596
G1 X143.983 Y136.017
G1 X142.417 Y137.583 E.06596
G1 X141.883 Y137.583
G1 X143.449 Y136.017 E.06596
G1 X142.916 Y136.017
G1 X141.35 Y137.583 E.06595
G1 X140.817 Y137.583
G1 X142.383 Y136.017 E.06595
G1 X141.849 Y136.017
G1 X140.284 Y137.583 E.06595
G1 X139.75 Y137.583
G1 X141.316 Y136.017 E.06595
G1 X140.783 Y136.017
G1 X139.217 Y137.583 E.06594
G1 X138.684 Y137.583
G1 X140.249 Y136.017 E.06594
G1 X139.716 Y136.017
G1 X138.151 Y137.583 E.06594
G1 X137.617 Y137.583
G1 X139.184 Y136.016 E.06601
G1 X138.749 Y135.918
G1 X137.104 Y137.562 E.06929
G1 X136.722 Y137.411
G1 X138.412 Y135.722 E.07118
G1 X138.173 Y135.428
G1 X136.493 Y137.108 E.07077
G1 X136.417 Y136.65
G1 X138.029 Y135.038 E.0679
G1 X137.983 Y134.551
G1 X136.417 Y136.116 E.06593
G1 X136.418 Y135.583
G1 X137.983 Y134.018 E.06593
G1 X137.983 Y133.485
G1 X136.418 Y135.05 E.06592
G1 X136.418 Y134.516
G1 X137.983 Y132.951 E.06592
G1 X137.983 Y132.418
G1 X136.418 Y133.983 E.06592
G1 X136.418 Y133.45
G1 X137.983 Y131.885 E.06592
G1 X137.983 Y131.351
G1 X136.418 Y132.916 E.06591
G1 X136.418 Y132.383
G1 X137.983 Y130.818 E.06591
G1 X137.983 Y130.285
G1 X136.418 Y131.849 E.06591
G1 X136.418 Y131.316
G1 X137.983 Y129.752 E.0659
G1 X137.983 Y129.218
G1 X136.418 Y130.783 E.0659
G1 X136.418 Y130.249
G1 X137.983 Y128.685 E.0659
G1 X137.983 Y128.152
G1 X136.419 Y129.716 E.0659
G1 X136.419 Y129.183
G1 X137.983 Y127.619 E.06589
G1 X137.983 Y127.085
G1 X136.419 Y128.649 E.06589
G1 X136.419 Y128.116
G1 X137.983 Y126.552 E.06589
G1 X137.983 Y126.019
G1 X136.419 Y127.583 E.06588
G1 X136.419 Y127.049
G1 X137.983 Y125.485 E.06588
G1 X137.983 Y124.952
G1 X136.419 Y126.516 E.06588
G1 X136.419 Y125.983
G1 X137.983 Y124.419 E.06587
G1 X137.983 Y123.886
G1 X136.419 Y125.449 E.06587
G1 X136.419 Y124.916
G1 X137.983 Y123.352 E.06587
G1 X137.983 Y122.819
G1 X136.419 Y124.383 E.06587
G1 X136.42 Y123.849
G1 X137.983 Y122.286 E.06586
G1 X137.983 Y121.752
G1 X136.42 Y123.316 E.06586
G1 X136.42 Y122.783
G1 X137.983 Y121.219 E.06586
G1 X137.983 Y120.686
G1 X136.42 Y122.249 E.06585
G1 X136.42 Y121.716
G1 X137.983 Y120.153 E.06585
G1 X137.983 Y119.619
G1 X136.42 Y121.183 E.06585
G1 X136.42 Y120.649
G1 X137.983 Y119.086 E.06584
G1 X137.983 Y118.553
G1 X136.42 Y120.116 E.06584
G1 X136.42 Y119.582
G1 X137.983 Y118.02 E.06584
G1 X137.983 Y117.486
G1 X136.42 Y119.049 E.06584
G1 X136.42 Y118.516
G1 X138.023 Y116.913 E.06751
; WIPE_START
M204 S3000
G1 X136.609 Y118.327 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X136.421 Y117.982 Z6.4 F12000
G1 Z6
G1 E.8 F1800
G1 F3600
M204 S2000
G1 X139.986 Y114.417 E.15017
G1 X139.452 Y114.417
G1 X136.421 Y117.449 E.12771
G1 X136.421 Y116.916
G1 X138.919 Y114.417 E.10524
G1 X138.386 Y114.417
G1 X136.421 Y116.382 E.08277
G1 X136.421 Y115.849
G1 X137.853 Y114.417 E.06031
G1 X137.319 Y114.417
G1 X136.421 Y115.316 E.03784
; WIPE_START
M204 S3000
G1 X137.319 Y114.417 E-.48276
G1 X137.853 Y114.417 E-.20263
G1 X137.714 Y114.556 E-.0746
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X137.341 Y122.18 Z6.4 F12000
G1 X136.604 Y137.263 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0978641
G1 F15000
M204 S3000
G3 X136.512 Y137.153 I.298 J-.345 E.00062
; WIPE_START
G1 X136.604 Y137.263 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X136.736 Y129.631 Z6.4 F12000
G1 X136.998 Y114.446 Z6.4
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.106682
G1 F15000
M204 S3000
G1 X136.906 Y114.508 E.00056
; LINE_WIDTH: 0.143696
G1 X136.814 Y114.571 E.00088
; LINE_WIDTH: 0.163443
G2 X136.451 Y114.968 I1.157 J1.423 E.00514
; WIPE_START
G1 X136.669 Y114.703 E-.48346
G1 X136.814 Y114.571 E-.27654
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X142.66 Y119.479 Z6.4 F12000
G1 X163.542 Y137.011 Z6.4
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.100587
G1 F15000
M204 S3000
G1 X163.512 Y137.067 E.00029
; LINE_WIDTH: 0.128503
G1 X163.444 Y137.158 E.00076
; LINE_WIDTH: 0.164828
G3 X163.178 Y137.434 I-.953 J-.65 E.00371
; LINE_WIDTH: 0.141359
G1 X163.09 Y137.494 E.00083
; LINE_WIDTH: 0.105903
G1 X163.002 Y137.554 E.00053
; WIPE_START
G1 X163.09 Y137.494 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X162.046 Y135.146 Z6.4 F12000
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.198747
G1 F15000
M204 S3000
G1 X161.989 Y135.236 E.00131
; LINE_WIDTH: 0.174653
G1 X161.914 Y135.336 E.0013
; LINE_WIDTH: 0.140059
G1 X161.84 Y135.437 E.00096
; LINE_WIDTH: 0.105465
G1 X161.765 Y135.538 E.00062
M204 S10000
G1 X161.606 Y135.694 F12000
; LINE_WIDTH: 0.105802
M73 P88 R2
G1 F15000
M204 S3000
G3 X161.389 Y135.883 I-1.985 J-2.056 E.00143
; LINE_WIDTH: 0.14912
G1 X161.268 Y135.97 E.00125
; LINE_WIDTH: 0.18556
G1 X161.167 Y136.026 E.0013
; WIPE_START
G1 X161.268 Y135.97 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X155.443 Y131.037 Z6.4 F12000
G1 X138.235 Y116.462 Z6.4
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.109626
G1 F15000
M204 S3000
G1 X138.134 Y116.596 E.00088
; LINE_WIDTH: 0.163134
G2 X137.954 Y116.844 I2.855 J2.266 E.00291
; WIPE_START
G1 X138.134 Y116.596 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X138.821 Y115.975 Z6.4 F12000
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.161707
G1 F15000
M204 S3000
G1 X138.698 Y116.054 E.00138
; LINE_WIDTH: 0.134396
G1 X138.572 Y116.146 E.00113
; LINE_WIDTH: 0.0994346
G1 X138.408 Y116.292 E.00098
; OBJECT_ID: 47
; WIPE_START
G1 X138.572 Y116.146 E-.76
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 58
M625
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G1 X132.677 Y120.994 Z6.4 F12000
G1 X116.391 Y134.391 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.611 E.04403
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.603 E.56211
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.476 J.191 E.04403
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.715 Y134.742 F12000
G1 F6000
M204 S3000
G1 X116.56 Y134.798 E.0053
G1 X95.463 Y134.798 E.67837
G1 X95.251 Y134.712 E.00737
G1 X95.202 Y134.548 E.00551
G1 X95.202 Y117.463 E.54937
G1 X95.28 Y117.26 E.00701
G1 X95.44 Y117.202 E.00547
G1 X116.521 Y117.202 E.67786
G1 X116.732 Y117.268 E.0071
G1 X116.797 Y117.46 E.00652
G1 X116.798 Y134.537 E.54911
G1 X116.739 Y134.689 E.00525
M204 S250
G1 X116.85 Y135.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G3 X116.587 Y135.19 I-.401 J-.907 E.00818
G1 X95.495 Y135.19 E.62823
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.547 J-.83 E.01066
G1 X94.81 Y134.583 E.00939
G1 X94.81 Y117.495 E.50898
G1 X94.868 Y117.155 E.01028
G1 X95.02 Y116.955 E.00747
G3 X95.413 Y116.81 I.532 J.838 E.01259
G1 X116.521 Y116.81 E.62871
G1 X116.824 Y116.858 E.00915
G3 X117.189 Y117.46 I-.291 J.588 E.02213
G1 X117.19 Y134.505 E.5077
G1 X117.132 Y134.845 E.01029
G1 X116.98 Y135.045 E.00747
G3 X116.904 Y135.089 I-.532 J-.838 E.00262
; WIPE_START
M204 S3000
G1 X116.587 Y135.19 E-.12657
G1 X114.92 Y135.19 E-.63343
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.323 Y134.458 Z6.4 F12000
G1 X96.103 Y133.376 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F6000
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.997 E.56211
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02424
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.43 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F6000
M204 S3000
G1 X96.407 Y133.122 E.00282
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01429
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3600
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.813 Y133.077 E.00251
; WIPE_START
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.354 Y123.458 Z6.4 F12000
G1 X96.026 Y117.961 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F6000
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y125.594 Z6.4 F12000
G1 X96.026 Y133.957 Z6.4
G1 Z6
G1 E.8 F1800
G1 F6000
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y133.957 Z6.4 F12000
G1 X116.021 Y133.957 Z6.4
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F6000
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; WIPE_START
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y126.324 Z6.4 F12000
G1 X116.021 Y117.961 Z6.4
G1 Z6
G1 E.8 F1800
; LINE_WIDTH: 0.42154
G1 F6000
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y118.043 E-.17025
G1 X115.95 Y118.002 E-.29488
G1 X116.021 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 31/40
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change
M106 S99.45
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z6.4 I-1.217 J.027 P1  F12000
G1 X116.391 Y134.391 Z6.4
G1 Z6.2
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F2894
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.611 E.04403
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.603 E.56211
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.478 J.191 E.04403
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F2894
M204 S3000
G1 X116.548 Y134.798 E.00551
; object ids of layer 31 start: 47
M624 AQAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer31 end: 47
M625
G1 X95.463 Y134.798 E.67799
G1 X95.26 Y134.72 E.00701
G1 X95.202 Y134.56 E.00547
G1 X95.202 Y117.463 E.54974
G1 X95.28 Y117.26 E.00701
G1 X95.441 Y117.202 E.00548
G1 X116.52 Y117.202 E.67783
G1 X116.727 Y117.265 E.00694
G1 X116.797 Y117.45 E.00639
G1 X116.798 Y134.537 E.54941
G1 X116.735 Y134.694 E.00544
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2894
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G1 X94.955 Y134.98 E.00747
G3 X94.81 Y134.587 I.838 J-.532 E.01259
G1 X94.81 Y117.495 E.50909
G1 X94.868 Y117.155 E.01028
G1 X95.02 Y116.955 E.00747
G3 X95.414 Y116.81 I.532 J.837 E.0126
G1 X116.52 Y116.81 E.62868
G1 X116.824 Y116.858 E.00916
G1 X117.013 Y116.984 E.00676
G1 X117.152 Y117.202 E.0077
G1 X117.189 Y117.45 E.00748
G1 X117.19 Y134.505 E.50798
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.829 J-.547 E.00887
; WIPE_START
G1 F3600
M204 S3000
G1 X116.583 Y135.19 E-.14137
G1 X114.955 Y135.19 E-.61863
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.356 Y134.469 Z6.6 F12000
G1 X96.117 Y133.403 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2894
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44624
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43731
G1 X115.021 Y117.997 E.56211
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02424
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F2894
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01428
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2894
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
M73 P89 R2
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
G1 F3600
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z6.6 F12000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2894
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z6.6 F12000
G1 X96.026 Y117.961 Z6.6
G1 Z6.2
G1 E.8 F1800
G1 F2894
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z6.6 F12000
G1 X116.021 Y117.961 Z6.6
G1 Z6.2
G1 E.8 F1800
; LINE_WIDTH: 0.42156
G1 F2894
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z6.6 F12000
G1 X116.021 Y133.957 Z6.6
G1 Z6.2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F2894
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 32/40
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z6.6 I-.929 J.786 P1  F12000
G1 X116.388 Y134.391 Z6.6
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F2869
M204 S3000
G2 X115.021 Y134.397 I-.193 J105.494 E.04396
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-104.471 J-.212 E.04403
; LINE_WIDTH: 0.43721
G1 X95.603 Y131.021 E.06229
; LINE_WIDTH: 0.43706
G1 X95.603 Y129.021 E.06227
; LINE_WIDTH: 0.43692
G1 X95.604 Y127.021 E.06225
; LINE_WIDTH: 0.43678
G1 X95.604 Y125.021 E.06222
; LINE_WIDTH: 0.43664
G1 X95.604 Y123.021 E.0622
; LINE_WIDTH: 0.4365
G1 X95.604 Y121.021 E.06218
; LINE_WIDTH: 0.43636
G1 X95.604 Y119.021 E.06216
; LINE_WIDTH: 0.43622
G1 X95.604 Y118.978 E.00134
; LINE_WIDTH: 0.44999
G1 X95.612 Y117.609 E.04403
G2 X96.979 Y117.603 I.196 J-105.083 E.04396
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.603 E.56212
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I102.621 J.204 E.04403
; LINE_WIDTH: 0.43692
G1 X116.396 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.396 Y124.979 E.06221
; LINE_WIDTH: 0.4366
G1 X116.396 Y128.979 E.12439
; LINE_WIDTH: 0.4364
G1 X116.396 Y130.979 E.06216
; LINE_WIDTH: 0.43629
G1 X116.396 Y132.979 E.06215
; LINE_WIDTH: 0.43619
G1 X116.396 Y133.021 E.00133
; LINE_WIDTH: 0.4451
G1 X116.391 Y133.227 E.00652
; LINE_WIDTH: 0.44999
G1 X116.389 Y134.331 E.03551
M204 S10000
G1 X116.72 Y134.74 F12000
G1 F2869
M204 S3000
G1 X116.56 Y134.798 E.00547
; object ids of layer 32 start: 47
M624 AQAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer32 end: 47
M625
G1 X95.463 Y134.798 E.67837
G1 X95.26 Y134.72 E.00701
G1 X95.202 Y134.56 E.00546
G1 X95.204 Y117.413 E.55135
G1 X95.288 Y117.25 E.00589
G1 X95.452 Y117.202 E.0055
G1 X116.52 Y117.202 E.67745
G1 X116.736 Y117.271 E.00728
G1 X116.797 Y117.468 E.00663
G1 X116.796 Y134.586 E.55047
G1 X116.746 Y134.686 E.00357
M204 S250
G1 X116.854 Y135.113 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2869
M204 S1500
G3 X116.587 Y135.19 I-.411 J-.921 E.00831
G1 X95.495 Y135.19 E.62823
G1 X95.155 Y135.132 E.01027
G1 X94.955 Y134.98 E.00748
G3 X94.81 Y134.587 I.838 J-.532 E.01259
G1 X94.812 Y118.587 E.47657
G3 X94.833 Y117.285 I22.972 J-.29 E.03877
G3 X95.114 Y116.898 I.633 J.164 E.01462
G1 X95.417 Y116.81 E.00939
G1 X116.52 Y116.81 E.62855
G1 X116.824 Y116.858 E.00917
G3 X117.134 Y117.158 I-.223 J.541 E.01316
G1 X117.189 Y117.468 E.00937
G1 X117.188 Y134.545 E.50866
G1 X117.134 Y134.842 E.00899
G1 X116.981 Y135.045 E.00758
G3 X116.908 Y135.087 I-.538 J-.853 E.00249
; WIPE_START
G1 F3600
M204 S3000
G1 X116.587 Y135.19 E-.12819
G1 X114.924 Y135.19 E-.63181
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.327 Y134.458 Z6.8 F12000
G1 X96.103 Y133.376 Z6.8
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2869
M204 S3000
M73 P89 R1
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44614
G1 X95.997 Y133.021 E.00543
; LINE_WIDTH: 0.43721
G1 X95.997 Y131.021 E.06229
; LINE_WIDTH: 0.43706
G1 X95.997 Y129.021 E.06227
; LINE_WIDTH: 0.43692
G1 X95.997 Y127.021 E.06225
; LINE_WIDTH: 0.43678
G1 X95.998 Y125.021 E.06222
; LINE_WIDTH: 0.43664
G1 X95.998 Y123.021 E.0622
; LINE_WIDTH: 0.4365
G1 X95.998 Y121.021 E.06218
; LINE_WIDTH: 0.43636
G1 X95.998 Y119.021 E.06216
; LINE_WIDTH: 0.43622
G1 X95.998 Y118.979 E.00133
; LINE_WIDTH: 0.44999
G1 X96.281 Y118.279 E.02426
G1 X96.808 Y118.008 E.01907
; LINE_WIDTH: 0.44625
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.997 E.56212
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02424
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.002 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.002 Y124.979 E.06221
; LINE_WIDTH: 0.4366
G1 X116.002 Y128.979 E.12439
; LINE_WIDTH: 0.4364
G1 X116.002 Y130.979 E.06216
; LINE_WIDTH: 0.43629
G1 X116.002 Y132.979 E.06215
; LINE_WIDTH: 0.43619
G1 X116.002 Y133.021 E.00133
; LINE_WIDTH: 0.4451
G1 X115.992 Y133.192 E.00542
; LINE_WIDTH: 0.44999
G1 X115.719 Y133.721 E.01914
G1 X115.192 Y133.992 E.01907
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.429 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F2869
M204 S3000
G1 X96.407 Y133.122 E.00283
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.978 E.45156
G1 X96.568 Y118.568 E.01431
G1 X96.878 Y118.407 E.01122
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01428
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.827 J.022 E.00462
G1 X115.432 Y133.433 E.01126
G1 X115.122 Y133.593 E.01122
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2869
M204 S1500
M73 P90 R1
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.00429
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.00429
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00564
G1 X96.813 Y133.077 E.00251
; WIPE_START
G1 F3600
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z6.8 F12000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42192
G1 F2869
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y134.039 E-.17026
G1 X95.955 Y133.998 E-.29487
G1 X96.026 Y133.957 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.027 Y126.324 Z6.8 F12000
G1 X96.027 Y117.961 Z6.8
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.42062
G1 F2869
M204 S3000
G1 X95.957 Y118.002 E.00244
G1 X96.027 Y118.042 E.00244
G1 X96.051 Y118.002 E.00141
; WIPE_START
G1 F6000
G1 X96.027 Y118.042 E-.17027
G1 X95.957 Y118.002 E-.29487
G1 X96.027 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.66 Y117.961 Z6.8 F12000
G1 X116.021 Y117.961 Z6.8
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.4215
G1 F2869
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y118.043 E-.17025
G1 X115.95 Y118.002 E-.29488
G1 X116.021 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y125.594 Z6.8 F12000
G1 X116.02 Y133.958 Z6.8
G1 Z6.4
G1 E.8 F1800
; LINE_WIDTH: 0.4206
G1 F2869
M204 S3000
G1 X115.949 Y133.998 E.00244
G1 X116.02 Y134.039 E.00244
G1 X116.043 Y133.998 E.00141
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.02 Y134.039 E-.17027
G1 X115.949 Y133.998 E-.29487
G1 X116.02 Y133.958 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 33/40
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z6.8 I-.924 J.792 P1  F12000
G1 X116.391 Y134.391 Z6.8
G1 Z6.6
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F2885
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.445 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.603 E.56212
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.483 J.191 E.04403
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F2885
M204 S3000
G1 X116.548 Y134.798 E.00551
; object ids of layer 33 start: 47
M624 AQAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer33 end: 47
M625
G1 X95.463 Y134.798 E.67799
G1 X95.25 Y134.712 E.00738
G1 X95.202 Y134.548 E.00551
G1 X95.202 Y117.463 E.54936
G1 X95.28 Y117.26 E.00701
G1 X95.44 Y117.202 E.00546
G1 X116.519 Y117.202 E.67781
G1 X116.736 Y117.271 E.00731
G1 X116.797 Y117.468 E.00664
G1 X116.798 Y134.537 E.54885
G1 X116.735 Y134.694 E.00544
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2885
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01027
G3 X94.898 Y134.886 I.549 J-.832 E.01067
G1 X94.81 Y134.583 E.0094
G1 X94.81 Y117.495 E.50896
G1 X94.868 Y117.155 E.01028
G1 X95.02 Y116.955 E.00747
G3 X95.413 Y116.81 I.532 J.838 E.01259
G1 X116.519 Y116.81 E.62866
G1 X116.824 Y116.858 E.00919
G3 X117.134 Y117.157 I-.222 J.541 E.01314
G1 X117.189 Y117.468 E.0094
G1 X117.19 Y134.505 E.50746
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.83 J-.547 E.00888
; WIPE_START
G1 F3600
M204 S3000
G1 X116.583 Y135.19 E-.14133
G1 X114.955 Y135.19 E-.61867
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.357 Y134.459 Z7 F12000
G1 X96.103 Y133.376 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2885
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44625
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.997 E.56212
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02424
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.43 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F2885
M204 S3000
G1 X96.407 Y133.122 E.00282
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01428
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2885
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.813 Y133.077 E.00251
; WIPE_START
G1 F3600
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.354 Y123.458 Z7 F12000
G1 X96.026 Y117.961 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2885
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
M73 P91 R1
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y125.594 Z7 F12000
G1 X96.026 Y133.957 Z7
G1 Z6.6
G1 E.8 F1800
G1 F2885
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y133.957 Z7 F12000
G1 X116.021 Y133.957 Z7
G1 Z6.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F2885
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y126.324 Z7 F12000
G1 X116.021 Y117.961 Z7
G1 Z6.6
G1 E.8 F1800
; LINE_WIDTH: 0.42158
G1 F2885
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 34/40
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z7 I-1.217 J.027 P1  F12000
G1 X116.388 Y134.391 Z7
G1 Z6.8
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F2910
M204 S3000
G2 X115.021 Y134.397 I-.196 J104.919 E.04396
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.445 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.603 E.56212
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I102.625 J.204 E.04403
; LINE_WIDTH: 0.43692
G1 X116.396 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.396 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.396 Y126.979 E.12443
; LINE_WIDTH: 0.4365
G1 X116.396 Y130.979 E.12436
; LINE_WIDTH: 0.4363
G1 X116.396 Y133.021 E.06348
; LINE_WIDTH: 0.44512
G1 X116.391 Y133.227 E.00652
; LINE_WIDTH: 0.44999
G1 X116.389 Y134.331 E.03551
M204 S10000
G1 X116.718 Y134.74 F12000
G1 F2910
M204 S3000
G1 X116.56 Y134.798 E.00543
; object ids of layer 34 start: 47
M624 AQAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer34 end: 47
M625
G1 X95.463 Y134.798 E.67836
G1 X95.25 Y134.712 E.00738
G1 X95.202 Y134.548 E.0055
G1 X95.202 Y117.463 E.54937
G1 X95.288 Y117.25 E.00738
G1 X95.452 Y117.202 E.00551
G1 X116.519 Y117.202 E.67741
G1 X116.727 Y117.265 E.00699
G1 X116.797 Y117.45 E.00639
G1 X116.796 Y134.586 E.55102
G1 X116.746 Y134.687 E.00362
M204 S250
G1 X116.854 Y135.113 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2910
M204 S1500
G3 X116.587 Y135.19 I-.411 J-.921 E.0083
G1 X95.495 Y135.19 E.62823
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.548 J-.831 E.01065
G1 X94.81 Y134.583 E.0094
G1 X94.81 Y117.495 E.50898
G1 X94.868 Y117.155 E.01028
G3 X95.114 Y116.898 I.832 J.549 E.01066
G1 X95.417 Y116.81 E.0094
G1 X116.519 Y116.81 E.62852
G1 X116.824 Y116.858 E.00921
G1 X117.013 Y116.984 E.00675
G1 X117.152 Y117.202 E.00771
G1 X117.189 Y117.45 E.00748
G1 X117.188 Y134.545 E.50917
G1 X117.134 Y134.842 E.009
G1 X116.98 Y135.045 E.00758
G3 X116.908 Y135.087 I-.538 J-.853 E.0025
; WIPE_START
G1 F3600
M204 S3000
G1 X116.587 Y135.19 E-.12814
G1 X114.924 Y135.19 E-.63186
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.327 Y134.458 Z7.2 F12000
G1 X96.103 Y133.376 Z7.2
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2910
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44625
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.997 E.56212
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02424
; LINE_WIDTH: 0.43692
G1 X116.003 Y120.979 E.06225
; LINE_WIDTH: 0.43681
G1 X116.002 Y122.979 E.06223
; LINE_WIDTH: 0.43671
G1 X116.002 Y126.979 E.12443
; LINE_WIDTH: 0.4365
G1 X116.002 Y130.979 E.12436
; LINE_WIDTH: 0.4363
G1 X116.002 Y133.021 E.06348
; LINE_WIDTH: 0.44512
G1 X115.992 Y133.192 E.00542
; LINE_WIDTH: 0.44999
G1 X115.719 Y133.721 E.01914
G1 X115.192 Y133.992 E.01907
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.43 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F2910
M204 S3000
G1 X96.407 Y133.122 E.00282
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01428
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.827 J.022 E.00462
G1 X115.432 Y133.433 E.01126
G1 X115.122 Y133.593 E.01122
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2910
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.00429
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.813 Y133.077 E.00251
; WIPE_START
G1 F3600
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.354 Y123.458 Z7.2 F12000
G1 X96.026 Y117.961 Z7.2
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2910
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y125.594 Z7.2 F12000
G1 X96.026 Y133.957 Z7.2
M73 P92 R1
G1 Z6.8
G1 E.8 F1800
G1 F2910
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y133.957 Z7.2 F12000
G1 X116.02 Y133.958 Z7.2
G1 Z6.8
G1 E.8 F1800
; LINE_WIDTH: 0.4206
G1 F2910
M204 S3000
G1 X115.949 Y133.998 E.00244
G1 X116.02 Y134.039 E.00244
G1 X116.043 Y133.998 E.00141
; WIPE_START
G1 F6000
G1 X116.02 Y134.039 E-.17027
G1 X115.949 Y133.998 E-.29487
G1 X116.02 Y133.958 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.02 Y126.325 Z7.2 F12000
G1 X116.021 Y117.961 Z7.2
G1 Z6.8
G1 E.8 F1800
; LINE_WIDTH: 0.42152
G1 F2910
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y118.043 E-.17025
G1 X115.95 Y118.002 E-.29488
G1 X116.021 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 35/40
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z7.2 I-1.217 J.027 P1  F12000
G1 X116.391 Y134.391 Z7.2
G1 Z7
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F2910
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.445 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.603 E.56212
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.487 J.191 E.04403
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F2910
M204 S3000
G1 X116.548 Y134.798 E.00551
; object ids of layer 35 start: 47
M624 AQAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer35 end: 47
M625
G1 X95.463 Y134.798 E.67799
G1 X95.261 Y134.72 E.00698
G1 X95.202 Y134.56 E.00548
G1 X95.202 Y117.463 E.54975
G1 X95.28 Y117.26 E.007
G1 X95.44 Y117.202 E.00547
G1 X116.518 Y117.202 E.67777
G1 X116.736 Y117.271 E.00735
G1 X116.797 Y117.469 E.00666
G1 X116.798 Y134.537 E.54883
G1 X116.735 Y134.694 E.00545
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2910
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G1 X94.955 Y134.98 E.00747
G3 X94.81 Y134.587 I.849 J-.536 E.01259
G1 X94.81 Y117.495 E.50908
G1 X94.868 Y117.155 E.01028
G1 X95.02 Y116.955 E.00747
G3 X95.413 Y116.81 I.532 J.838 E.01259
G1 X116.518 Y116.81 E.62862
G1 X116.824 Y116.858 E.00924
G3 X117.133 Y117.156 I-.223 J.541 E.01309
G1 X117.189 Y117.469 E.00946
G1 X117.19 Y134.505 E.50744
G1 X117.132 Y134.845 E.01029
G3 X116.933 Y135.066 I-.83 J-.547 E.00887
; WIPE_START
G1 F3600
M204 S3000
G1 X116.583 Y135.19 E-.14137
G1 X114.955 Y135.19 E-.61863
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.357 Y134.459 Z7.4 F12000
G1 X96.103 Y133.376 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2910
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44625
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.997 E.56212
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02424
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.43 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F2910
M204 S3000
G1 X96.407 Y133.122 E.00282
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01428
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2910
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.813 Y133.077 E.00251
; WIPE_START
G1 F3600
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.354 Y123.458 Z7.4 F12000
G1 X96.026 Y117.961 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2910
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y125.594 Z7.4 F12000
G1 X96.026 Y133.957 Z7.4
G1 Z7
G1 E.8 F1800
G1 F2910
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y133.957 Z7.4 F12000
M73 P93 R1
G1 X116.021 Y133.957 Z7.4
G1 Z7
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F2910
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y126.324 Z7.4 F12000
G1 X116.021 Y117.961 Z7.4
G1 Z7
G1 E.8 F1800
; LINE_WIDTH: 0.4216
G1 F2910
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 36/40
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z7.4 I-1.217 J.027 P1  F12000
G1 X116.391 Y134.391 Z7.4
G1 Z7.2
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F2894
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.445 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.603 E.56212
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.491 J.191 E.04403
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.715 Y134.742 F12000
G1 F2894
M204 S3000
G1 X116.56 Y134.798 E.0053
; object ids of layer 36 start: 47
M624 AQAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer36 end: 47
M625
G1 X95.463 Y134.798 E.67836
G1 X95.251 Y134.712 E.00738
G1 X95.202 Y134.548 E.0055
G1 X95.202 Y117.463 E.54937
G1 X95.28 Y117.26 E.00701
G1 X95.441 Y117.202 E.00547
G1 X116.517 Y117.202 E.67773
G1 X116.727 Y117.265 E.00704
G1 X116.797 Y117.451 E.00639
G1 X116.798 Y134.537 E.54941
G1 X116.739 Y134.689 E.00524
M204 S250
G1 X116.85 Y135.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2894
M204 S1500
G3 X116.587 Y135.19 I-.401 J-.907 E.00818
G1 X95.495 Y135.19 E.62823
G1 X95.155 Y135.132 E.01028
G3 X94.898 Y134.886 I.548 J-.83 E.01065
G1 X94.81 Y134.583 E.00939
G1 X94.81 Y117.495 E.50898
G1 X94.868 Y117.155 E.01027
G1 X95.02 Y116.955 E.00748
G3 X95.414 Y116.81 I.532 J.837 E.0126
G1 X116.517 Y116.81 E.62859
G1 X116.824 Y116.858 E.00926
G1 X117.013 Y116.984 E.00676
G1 X117.152 Y117.202 E.0077
G1 X117.189 Y117.451 E.00748
G1 X117.19 Y134.505 E.50797
G1 X117.132 Y134.845 E.01028
G1 X116.98 Y135.045 E.00748
G3 X116.904 Y135.089 I-.531 J-.837 E.00261
; WIPE_START
G1 F3600
M204 S3000
G1 X116.587 Y135.19 E-.12656
G1 X114.92 Y135.19 E-.63344
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.322 Y134.468 Z7.6 F12000
G1 X96.117 Y133.403 Z7.6
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2894
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44625
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.997 E.56212
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02424
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F2894
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01428
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2894
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
G1 F3600
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z7.6 F12000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2894
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z7.6 F12000
G1 X96.026 Y117.961 Z7.6
G1 Z7.2
G1 E.8 F1800
G1 F2894
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z7.6 F12000
G1 X116.021 Y117.961 Z7.6
G1 Z7.2
G1 E.8 F1800
; LINE_WIDTH: 0.4216
G1 F2894
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z7.6 F12000
G1 X116.021 Y133.957 Z7.6
G1 Z7.2
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F2894
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.2
; WIPE_START
M73 P94 R1
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 37/40
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z7.6 I-.927 J.789 P1  F12000
G1 X116.391 Y134.391 Z7.6
G1 Z7.4
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F2869
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.277 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.603 E.56212
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.493 J.191 E.04403
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.715 Y134.742 F12000
G1 F2869
M204 S3000
G1 X116.559 Y134.798 E.00532
; object ids of layer 37 start: 47
M624 AQAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer37 end: 47
M625
G1 X95.463 Y134.798 E.67836
G1 X95.25 Y134.712 E.00738
G1 X95.202 Y134.548 E.0055
G1 X95.202 Y117.463 E.54937
G1 X95.288 Y117.251 E.00738
G1 X95.452 Y117.202 E.00551
G1 X116.544 Y117.202 E.67824
G1 X116.736 Y117.271 E.00656
G1 X116.797 Y117.469 E.00665
G1 X116.798 Y134.537 E.54883
G1 X116.739 Y134.688 E.00523
M204 S250
G1 X116.85 Y135.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2869
M204 S1500
G3 X116.586 Y135.19 I-.401 J-.906 E.00819
G1 X95.495 Y135.19 E.62822
G1 X95.155 Y135.132 E.01027
G3 X94.898 Y134.886 I.55 J-.834 E.01066
G1 X94.81 Y134.583 E.0094
G1 X94.81 Y117.495 E.50897
G1 X94.868 Y117.155 E.01028
G3 X95.114 Y116.898 I.832 J.549 E.01066
G1 X95.417 Y116.81 E.0094
G1 X116.517 Y116.81 E.62846
G1 X116.824 Y116.858 E.00928
G3 X117.133 Y117.155 I-.223 J.54 E.01304
G1 X117.189 Y117.469 E.00951
G1 X117.19 Y134.505 E.50743
G1 X117.132 Y134.845 E.01028
G1 X116.98 Y135.045 E.00748
G3 X116.904 Y135.089 I-.531 J-.837 E.00261
; WIPE_START
G1 F3600
M204 S3000
G1 X116.586 Y135.19 E-.12674
G1 X114.92 Y135.19 E-.63327
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.322 Y134.468 Z7.8 F12000
G1 X96.117 Y133.403 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2869
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44625
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.997 E.56212
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02424
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F2869
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01428
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2869
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
G1 F3600
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z7.8 F12000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2869
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z7.8 F12000
G1 X96.026 Y117.961 Z7.8
G1 Z7.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F2869
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z7.8 F12000
G1 X116.021 Y117.961 Z7.8
G1 Z7.4
G1 E.8 F1800
; LINE_WIDTH: 0.4216
G1 F2869
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z7.8 F12000
G1 X116.021 Y133.957 Z7.8
G1 Z7.4
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F2869
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
M73 P94 R0
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 38/40
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z7.8 I-.927 J.789 P1  F12000
G1 X116.391 Y134.391 Z7.8
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F2885
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
M73 P95 R0
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.277 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.603 E.56212
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04401
G2 X116.397 Y118.979 I103.495 J.191 E.04403
; LINE_WIDTH: 0.43706
G1 X116.397 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.397 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.397 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.712 Y134.749 F12000
G1 F2885
M204 S3000
G1 X116.548 Y134.798 E.00551
; object ids of layer 38 start: 47
M624 AQAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer38 end: 47
M625
G1 X95.463 Y134.798 E.67799
G1 X95.26 Y134.72 E.007
G1 X95.202 Y134.56 E.00547
G1 X95.202 Y117.463 E.54975
G1 X95.28 Y117.26 E.00701
G1 X95.44 Y117.202 E.00548
G1 X116.544 Y117.202 E.67859
G1 X116.737 Y117.271 E.00659
G1 X116.797 Y117.469 E.00666
G1 X116.798 Y134.537 E.5488
G1 X116.735 Y134.694 E.00545
M204 S250
G1 X116.886 Y135.102 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2885
M204 S1500
G1 X116.583 Y135.19 E.0094
G1 X95.495 Y135.19 E.62811
G1 X95.155 Y135.132 E.01028
G1 X94.955 Y134.98 E.00747
G3 X94.81 Y134.587 I.843 J-.534 E.01259
G1 X94.81 Y117.495 E.50909
G1 X94.868 Y117.155 E.01029
G1 X95.02 Y116.955 E.00747
G3 X95.414 Y116.81 I.532 J.837 E.0126
G1 X116.516 Y116.81 E.62855
G1 X116.824 Y116.858 E.0093
G3 X117.132 Y117.153 I-.222 J.54 E.01299
G1 X117.189 Y117.469 E.00958
G1 X117.19 Y134.505 E.50741
G1 X117.132 Y134.845 E.01028
G3 X116.933 Y135.066 I-.829 J-.547 E.00887
; WIPE_START
G1 F3600
M204 S3000
G1 X116.583 Y135.19 E-.14135
G1 X114.955 Y135.19 E-.61865
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.357 Y134.459 Z8 F12000
G1 X96.103 Y133.376 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2885
M204 S3000
G1 X96.008 Y133.192 E.00667
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44625
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.997 E.56212
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02424
; LINE_WIDTH: 0.43706
G1 X116.003 Y124.979 E.18681
; LINE_WIDTH: 0.43717
G1 X116.003 Y130.979 E.18686
; LINE_WIDTH: 0.43728
G1 X116.003 Y133.021 E.06364
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.13 Y133.43 E.01051
M204 S10000
G1 X96.447 Y133.2 F12000
G1 F2885
M204 S3000
G1 X96.407 Y133.122 E.00282
G1 X96.398 Y133.021 E.00324
G1 X96.398 Y118.979 E.45156
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01428
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.475 Y133.253 E.00649
M204 S250
G1 X96.79 Y133.021 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2885
M204 S1500
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.813 Y133.077 E.00251
; WIPE_START
G1 F3600
M204 S3000
G1 X96.81 Y131.077 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.354 Y123.458 Z8 F12000
G1 X96.026 Y117.961 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42196
G1 F2885
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y125.594 Z8 F12000
G1 X96.026 Y133.957 Z8
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.42198
G1 F2885
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y133.957 Z8 F12000
G1 X116.021 Y133.957 Z8
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F2885
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y126.324 Z8 F12000
G1 X116.021 Y117.961 Z8
G1 Z7.6
G1 E.8 F1800
; LINE_WIDTH: 0.42162
G1 F2885
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y118.043 E-.17026
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 39/40
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z8 I-1.217 J.027 P1  F12000
G1 X116.391 Y134.391 Z8
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.44999
G1 F2894
M204 S3000
G2 X115.021 Y134.397 I-.197 J105.276 E.04403
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.397 E.56212
; LINE_WIDTH: 0.44999
G1 X95.609 Y134.391 E.04403
G2 X95.603 Y133.021 I-105.444 J-.197 E.04403
; LINE_WIDTH: 0.43732
G1 X95.603 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X95.609 Y117.609 E.04403
G2 X96.979 Y117.603 I.197 J-105.278 E.04403
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.603 E.56212
; LINE_WIDTH: 0.44999
G1 X116.39 Y117.609 E.04402
G2 X116.397 Y118.979 I103.656 J.191 E.04403
; LINE_WIDTH: 0.43708
G1 X116.397 Y126.979 E.24909
; LINE_WIDTH: 0.43722
G1 X116.397 Y133.021 E.18822
; LINE_WIDTH: 0.44621
G1 X116.393 Y133.227 E.00654
; LINE_WIDTH: 0.44999
G1 X116.391 Y134.331 E.03551
M204 S10000
G1 X116.715 Y134.742 F12000
M73 P96 R0
G1 F2894
M204 S3000
G1 X116.559 Y134.798 E.00532
; object ids of layer 39 start: 47
M624 AQAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer39 end: 47
M625
G1 X95.463 Y134.798 E.67835
G1 X95.251 Y134.712 E.00738
G1 X95.202 Y134.548 E.00551
G1 X95.202 Y117.464 E.54937
G1 X95.288 Y117.251 E.00738
G1 X95.452 Y117.202 E.00551
G1 X116.515 Y117.202 E.6773
G1 X116.732 Y117.268 E.00728
G1 X116.797 Y117.461 E.00654
G1 X116.798 Y134.537 E.54908
G1 X116.739 Y134.689 E.00524
M204 S250
G1 X116.85 Y135.115 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2894
M204 S1500
G3 X116.586 Y135.19 I-.401 J-.907 E.0082
G1 X95.495 Y135.19 E.62822
G1 X95.155 Y135.132 E.01029
G3 X94.898 Y134.886 I.547 J-.83 E.01064
G1 X94.81 Y134.583 E.00941
G1 X94.81 Y117.495 E.50897
G1 X94.868 Y117.155 E.01029
G3 X95.114 Y116.898 I.83 J.548 E.01064
G1 X95.417 Y116.81 E.00941
G1 X116.515 Y116.81 E.62842
G1 X116.824 Y116.858 E.00932
G3 X117.189 Y117.461 I-.291 J.588 E.02214
G1 X117.19 Y134.505 E.50767
G1 X117.132 Y134.845 E.01029
G1 X116.98 Y135.045 E.00746
G3 X116.904 Y135.089 I-.532 J-.837 E.00262
; WIPE_START
G1 F3600
M204 S3000
G1 X116.586 Y135.19 E-.12677
G1 X114.92 Y135.19 E-.63323
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.322 Y134.468 Z8.2 F12000
G1 X96.117 Y133.403 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.44999
G1 F2894
M204 S3000
G1 X96.008 Y133.192 E.00765
; LINE_WIDTH: 0.44625
G1 X95.997 Y133.021 E.00544
; LINE_WIDTH: 0.43732
G1 X95.997 Y118.979 E.4375
; LINE_WIDTH: 0.44999
G1 X96.28 Y118.28 E.02423
G1 X96.808 Y118.008 E.01911
; LINE_WIDTH: 0.44625
G1 X96.979 Y117.997 E.00544
; LINE_WIDTH: 0.43732
G1 X115.021 Y117.997 E.56212
; LINE_WIDTH: 0.44999
G1 X115.72 Y118.28 E.02422
G1 X116.003 Y118.979 E.02424
; LINE_WIDTH: 0.43708
G1 X116.003 Y126.979 E.24909
; LINE_WIDTH: 0.43722
G1 X116.003 Y133.021 E.18822
; LINE_WIDTH: 0.44621
G1 X115.992 Y133.192 E.00543
; LINE_WIDTH: 0.44999
G1 X115.72 Y133.72 E.01911
G1 X115.192 Y133.992 E.01911
; LINE_WIDTH: 0.44625
G1 X115.021 Y134.003 E.00544
; LINE_WIDTH: 0.43732
G1 X96.979 Y134.003 E.56212
; LINE_WIDTH: 0.44999
G1 X96.28 Y133.72 E.02423
G1 X96.144 Y133.456 E.00953
M204 S10000
G1 X96.461 Y133.227 F12000
G1 F2894
M204 S3000
G1 X96.407 Y133.122 E.0038
G1 X96.398 Y118.979 E.45478
G1 X96.568 Y118.568 E.01429
G1 X96.878 Y118.407 E.01124
G1 X96.979 Y118.398 E.00324
G1 X115.021 Y118.398 E.58018
G1 X115.432 Y118.568 E.01428
G1 X115.602 Y118.979 E.01429
G1 X115.602 Y132.979 E.45018
G3 X115.593 Y133.122 I-.829 J.021 E.00462
G1 X115.432 Y133.432 E.01124
G1 X115.122 Y133.593 E.01124
G1 X115.021 Y133.602 E.00324
G1 X96.979 Y133.602 E.58018
G1 X96.568 Y133.432 E.01429
G1 X96.489 Y133.28 E.00552
M204 S250
G1 X96.793 Y133.054 F12000
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F2894
M204 S1500
G1 X96.79 Y119.021 E.41797
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.0043
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00564
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00565
G1 X96.821 Y133.107 E.00159
; WIPE_START
G1 F3600
M204 S3000
G1 X96.816 Y131.107 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y133.957 Z8.2 F12000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.42198
G1 F2894
M204 S3000
G1 X95.955 Y133.998 E.00246
G1 X96.026 Y134.039 E.00246
G1 X96.05 Y133.998 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y134.039 E-.17024
G1 X95.955 Y133.998 E-.29488
G1 X96.026 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X96.026 Y126.324 Z8.2 F12000
G1 X96.026 Y117.961 Z8.2
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F2894
M204 S3000
G1 X95.955 Y118.002 E.00246
G1 X96.026 Y118.043 E.00246
G1 X96.05 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X96.026 Y118.043 E-.17024
G1 X95.955 Y118.002 E-.29488
G1 X96.026 Y117.961 E-.29488
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.658 Y117.961 Z8.2 F12000
G1 X116.021 Y117.961 Z8.2
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.42164
G1 F2894
M204 S3000
G1 X115.95 Y118.002 E.00245
G1 X116.021 Y118.043 E.00245
G1 X116.045 Y118.002 E.00142
; WIPE_START
G1 F6000
G1 X116.021 Y118.043 E-.17025
G1 X115.95 Y118.002 E-.29487
G1 X116.021 Y117.961 E-.29487
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X116.021 Y125.594 Z8.2 F12000
G1 X116.021 Y133.957 Z8.2
G1 Z7.8
G1 E.8 F1800
; LINE_WIDTH: 0.42196
G1 F2894
M204 S3000
G1 X115.95 Y133.998 E.00246
G1 X116.021 Y134.039 E.00246
G1 X116.045 Y133.998 E.00142
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6000
G1 X116.021 Y134.039 E-.17024
G1 X115.95 Y133.998 E-.29488
G1 X116.021 Y133.957 E-.29488
; WIPE_END
G1 E-.04 F1800
; stop printing object, unique label id: 47
M625
; layer num/total_layer_count: 40/40
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change
; OBJECT_ID: 47
; start printing object, unique label id: 47
M624 AQAAAAAAAAA=
M204 S10000
G17
G3 Z8.2 I-.99 J.708 P1  F12000
G1 X116.85 Y135.115 Z8.2
G1 Z8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.41999
G1 F3483
M204 S1500
G3 X116.586 Y135.19 I-.401 J-.908 E.00819
; object ids of layer 40 start: 47
M624 AQAAAAAAAAA=
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END

; object ids of this layer40 end: 47
M625
G1 X95.495 Y135.19 E.62821
G1 X95.155 Y135.132 E.01029
G3 X94.898 Y134.886 I.547 J-.829 E.01065
G1 X94.81 Y134.583 E.00939
G1 X94.812 Y117.455 E.51016
G1 X94.866 Y117.158 E.009
G1 X95.02 Y116.955 E.0076
G3 X95.413 Y116.81 I.536 J.851 E.01258
G1 X116.53 Y116.811 E.62898
G1 X116.752 Y116.845 E.0067
G1 X117.012 Y116.983 E.00876
G1 X117.152 Y117.202 E.00775
G1 X117.189 Y117.451 E.00749
G1 X117.19 Y134.505 E.50797
G1 X117.132 Y134.845 E.01028
G1 X116.98 Y135.045 E.00747
G3 X116.904 Y135.089 I-.532 J-.839 E.00263
; WIPE_START
G1 F3600
M204 S3000
G1 X116.586 Y135.19 E-.12667
G1 X114.92 Y135.19 E-.63333
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X107.341 Y134.285 Z8.4 F12000
G1 X96.791 Y133.024 Z8.4
G1 Z8
G1 E.8 F1800
G1 F3483
M204 S1500
M73 P97 R0
G1 X96.79 Y133.021 E.00008
G1 X96.79 Y119.021 E.417
G3 X96.845 Y118.845 I.24 J-.021 E.00565
G1 X96.979 Y118.79 E.00429
G1 X114.979 Y118.79 E.53614
G3 X115.155 Y118.845 I.021 J.24 E.00565
G1 X115.21 Y118.979 E.0043
G1 X115.21 Y132.979 E.417
G3 X115.155 Y133.155 I-.24 J.021 E.00565
G1 X115.021 Y133.21 E.0043
G1 X97.021 Y133.21 E.53614
G3 X96.845 Y133.155 I-.021 J-.24 E.00564
G1 X96.814 Y133.079 E.00243
; WIPE_START
G1 F3600
M204 S3000
G1 X96.79 Y133.021 E-.02387
G1 X96.79 Y131.084 E-.73613
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X104.317 Y132.35 Z8.4 F12000
G1 X116.983 Y134.481 Z8.4
G1 Z8
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F3483
M204 S2000
G1 X116.481 Y134.983 E.02112
G1 X115.948 Y134.983
G1 X116.983 Y133.948 E.04358
G1 X116.983 Y133.415
G1 X115.415 Y134.983 E.06605
G1 X114.881 Y134.983
G1 X116.983 Y132.881 E.08851
G1 X116.983 Y132.348
G1 X114.348 Y134.983 E.11097
G1 X113.815 Y134.983
G1 X116.983 Y131.815 E.13343
G1 X116.983 Y131.282
G1 X115.417 Y132.847 E.06593
G1 X115.417 Y132.314
G1 X116.982 Y130.749 E.06593
G1 X116.982 Y130.215
G1 X115.417 Y131.78 E.06593
G1 X115.417 Y131.247
G1 X116.982 Y129.682 E.06593
G1 X116.982 Y129.149
G1 X115.417 Y130.714 E.06593
G1 X115.417 Y130.181
G1 X116.982 Y128.616 E.06593
G1 X116.982 Y128.082
G1 X115.417 Y129.647 E.06593
G1 X115.417 Y129.114
G1 X116.982 Y127.549 E.06592
G1 X116.982 Y127.016
G1 X115.417 Y128.581 E.06592
G1 X115.417 Y128.048
G1 X116.982 Y126.483 E.06592
G1 X116.982 Y125.949
G1 X115.417 Y127.514 E.06592
G1 X115.417 Y126.981
G1 X116.982 Y125.416 E.06592
G1 X116.982 Y124.883
G1 X115.417 Y126.448 E.06592
G1 X115.417 Y125.915
G1 X116.982 Y124.35 E.06592
G1 X116.982 Y123.816
G1 X115.417 Y125.381 E.06592
G1 X115.417 Y124.848
G1 X116.982 Y123.283 E.06592
G1 X116.982 Y122.75
G1 X115.417 Y124.315 E.06592
G1 X115.417 Y123.782
G1 X116.982 Y122.217 E.06592
G1 X116.982 Y121.683
G1 X115.417 Y123.248 E.06592
G1 X115.417 Y122.715
G1 X116.982 Y121.15 E.06592
G1 X116.982 Y120.617
G1 X115.417 Y122.182 E.06591
G1 X115.417 Y121.649
G1 X116.982 Y120.084 E.06591
G1 X116.982 Y119.551
G1 X115.417 Y121.115 E.06591
G1 X115.417 Y120.582
G1 X116.982 Y119.017 E.06591
G1 X116.982 Y118.484
G1 X115.417 Y120.049 E.06591
G1 X115.417 Y119.515
G1 X116.982 Y117.951 E.06591
G1 X116.982 Y117.418
G1 X115.417 Y118.982 E.06591
G1 X115.208 Y118.658
G1 X116.787 Y117.079 E.06653
G1 X116.315 Y117.018
G1 X114.75 Y118.583 E.06591
G1 X114.217 Y118.583
G1 X115.782 Y117.018 E.06591
G1 X115.249 Y117.018
G1 X113.684 Y118.583 E.06591
G1 X113.151 Y118.583
G1 X114.715 Y117.018 E.06591
G1 X114.182 Y117.018
G1 X112.617 Y118.583 E.06591
G1 X112.084 Y118.583
G1 X113.649 Y117.018 E.06591
G1 X113.116 Y117.018
G1 X111.551 Y118.583 E.06591
G1 X111.018 Y118.583
G1 X112.582 Y117.018 E.06591
G1 X112.049 Y117.018
G1 X110.484 Y118.583 E.06592
G1 X109.951 Y118.583
G1 X111.516 Y117.018 E.06592
G1 X110.983 Y117.018
G1 X109.418 Y118.583 E.06592
G1 X108.885 Y118.583
G1 X110.449 Y117.018 E.06592
G1 X109.916 Y117.018
G1 X108.351 Y118.583 E.06592
G1 X107.818 Y118.583
G1 X109.383 Y117.018 E.06592
G1 X108.85 Y117.018
G1 X107.285 Y118.583 E.06592
G1 X106.752 Y118.583
G1 X108.316 Y117.018 E.06592
G1 X107.783 Y117.018
G1 X106.218 Y118.583 E.06592
G1 X105.685 Y118.583
G1 X107.25 Y117.018 E.06592
G1 X106.717 Y117.018
G1 X105.152 Y118.583 E.06592
G1 X104.619 Y118.583
G1 X106.184 Y117.018 E.06592
G1 X105.65 Y117.018
G1 X104.085 Y118.583 E.06592
G1 X103.552 Y118.583
G1 X105.117 Y117.018 E.06592
G1 X104.584 Y117.018
G1 X103.019 Y118.583 E.06592
G1 X102.486 Y118.583
G1 X104.051 Y117.018 E.06593
G1 X103.517 Y117.018
G1 X101.952 Y118.583 E.06593
G1 X101.419 Y118.583
G1 X102.984 Y117.018 E.06593
G1 X102.451 Y117.018
G1 X100.886 Y118.583 E.06593
G1 X100.352 Y118.583
G1 X101.918 Y117.018 E.06593
G1 X101.384 Y117.018
G1 X99.819 Y118.583 E.06593
G1 X99.286 Y118.583
G1 X100.851 Y117.018 E.06593
G1 X100.318 Y117.018
G1 X98.753 Y118.583 E.06593
G1 X98.219 Y118.583
G1 X99.785 Y117.018 E.06593
G1 X99.251 Y117.017
G1 X97.686 Y118.583 E.06593
G1 X97.153 Y118.583
G1 X98.718 Y117.017 E.06593
; WIPE_START
G1 F3600
M204 S3000
G1 X97.304 Y118.432 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X103.107 Y123.389 Z8.4 F12000
G1 X114.847 Y133.417 Z8.4
G1 Z8
G1 E.8 F1800
G1 F3483
M204 S2000
G1 X113.282 Y134.983 E.06594
G1 X112.748 Y134.983
G1 X114.314 Y133.417 E.06594
G1 X113.78 Y133.417
G1 X112.215 Y134.983 E.06593
G1 X111.682 Y134.983
G1 X113.247 Y133.417 E.06594
G1 X112.714 Y133.417
G1 X111.149 Y134.983 E.06594
G1 X110.615 Y134.983
G1 X112.181 Y133.417 E.06594
G1 X111.647 Y133.417
G1 X110.082 Y134.983 E.06594
G1 X109.549 Y134.983
G1 X111.114 Y133.417 E.06594
G1 X110.581 Y133.417
G1 X109.016 Y134.983 E.06594
G1 X108.482 Y134.983
G1 X110.048 Y133.417 E.06594
G1 X109.514 Y133.417
G1 X107.949 Y134.983 E.06594
G1 X107.416 Y134.983
G1 X108.981 Y133.417 E.06594
G1 X108.448 Y133.417
G1 X106.883 Y134.983 E.06594
G1 X106.349 Y134.983
G1 X107.915 Y133.417 E.06594
G1 X107.381 Y133.417
G1 X105.816 Y134.983 E.06594
G1 X105.283 Y134.983
G1 X106.848 Y133.417 E.06594
G1 X106.315 Y133.417
G1 X104.75 Y134.983 E.06594
G1 X104.216 Y134.983
G1 X105.782 Y133.417 E.06593
G1 X105.248 Y133.417
G1 X103.683 Y134.983 E.06593
G1 X103.15 Y134.983
G1 X104.715 Y133.417 E.06593
G1 X104.182 Y133.417
G1 X102.617 Y134.983 E.06593
G1 X102.083 Y134.983
G1 X103.648 Y133.417 E.06593
G1 X103.115 Y133.417
G1 X101.55 Y134.983 E.06593
G1 X101.017 Y134.983
G1 X102.582 Y133.417 E.06593
G1 X102.049 Y133.417
G1 X100.483 Y134.983 E.06594
G1 X99.95 Y134.983
G1 X101.515 Y133.417 E.06594
G1 X100.982 Y133.417
G1 X99.417 Y134.983 E.06594
G1 X98.884 Y134.983
G1 X100.449 Y133.417 E.06594
G1 X99.916 Y133.417
G1 X98.35 Y134.983 E.06594
G1 X97.817 Y134.983
G1 X99.382 Y133.417 E.06594
G1 X98.849 Y133.417
G1 X97.284 Y134.983 E.06594
G1 X96.751 Y134.983
G1 X98.316 Y133.417 E.06594
G1 X97.783 Y133.417
G1 X96.217 Y134.983 E.06594
G1 X95.684 Y134.983
G1 X97.249 Y133.417 E.06594
G1 X96.792 Y133.342
G1 X95.216 Y134.918 E.06639
G1 X95.02 Y134.58
G1 X96.583 Y133.018 E.06582
G1 X96.583 Y132.484
G1 X95.017 Y134.05 E.06593
G1 X95.018 Y133.516
G1 X96.583 Y131.951 E.06593
G1 X96.583 Y131.418
G1 X95.018 Y132.983 E.06593
G1 X95.018 Y132.45
G1 X96.583 Y130.885 E.06592
G1 X96.583 Y130.351
G1 X95.018 Y131.916 E.06592
G1 X95.018 Y131.383
G1 X96.583 Y129.818 E.06592
G1 X96.583 Y129.285
G1 X95.018 Y130.85 E.06591
G1 X95.018 Y130.316
G1 X96.583 Y128.752 E.06591
G1 X96.583 Y128.218
G1 X95.018 Y129.783 E.06591
G1 X95.018 Y129.25
G1 X96.583 Y127.685 E.0659
G1 X96.583 Y127.152
G1 X95.018 Y128.716 E.0659
G1 X95.018 Y128.183
G1 X96.583 Y126.619 E.0659
G1 X96.583 Y126.085
G1 X95.018 Y127.65 E.06589
G1 X95.018 Y127.116
G1 X96.583 Y125.552 E.06589
G1 X96.583 Y125.019
G1 X95.019 Y126.583 E.06589
G1 X95.019 Y126.05
G1 X96.583 Y124.486 E.06589
G1 X96.583 Y123.952
G1 X95.019 Y125.516 E.06588
G1 X95.019 Y124.983
G1 X96.583 Y123.419 E.06588
G1 X96.583 Y122.886
G1 X95.019 Y124.45 E.06588
G1 X95.019 Y123.916
G1 X96.583 Y122.352 E.06587
G1 X96.583 Y121.819
G1 X95.019 Y123.383 E.06587
G1 X95.019 Y122.85
M73 P98 R0
G1 X96.583 Y121.286 E.06587
G1 X96.583 Y120.753
G1 X95.019 Y122.316 E.06586
G1 X95.019 Y121.783
G1 X96.583 Y120.219 E.06586
G1 X96.583 Y119.686
G1 X95.019 Y121.25 E.06586
G1 X95.019 Y120.716
G1 X96.583 Y119.153 E.06585
; WIPE_START
G1 F3600
M204 S3000
G1 X95.168 Y120.567 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S10000
G1 X95.019 Y120.183 Z8.4 F12000
G1 Z8
G1 E.8 F1800
G1 F3483
M204 S2000
G1 X98.185 Y117.017 E.13334
G1 X97.652 Y117.017
G1 X95.019 Y119.65 E.11088
G1 X95.02 Y119.116
G1 X97.118 Y117.017 E.08841
G1 X96.585 Y117.017
G1 X95.02 Y118.583 E.06595
G1 X95.02 Y118.05
G1 X96.052 Y117.017 E.04348
G1 X95.519 Y117.017
G1 X95.02 Y117.516 E.02102
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F3600
M204 S3000
G1 X95.519 Y117.017 E-.2681
G1 X96.052 Y117.017 E-.20263
G1 X95.514 Y117.556 E-.28927
; WIPE_END
G1 E-.04 F1800
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

;===== date: 20240528 =====================
M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z8.5 F900 ; lower z a little
G1 X65 Y245 F12000 ; move to safe pos
G1 Y265 F3000

G1 X65 Y245 F12000
G1 Y265 F3000
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

G1 X100 F12000 ; wipe
; pull back filament to AMS
M620 S255
G1 X20 Y50 F12000
G1 Y-3
T255
G1 X65 F12000
G1 Y265
G1 X100 F12000 ; wipe
M621 S255
M104 S0 ; turn off hotend

M622.1 S1 ; for prev firware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S3 ;wait for last picture to be taken
M623; end of "timelapse_record_flag"

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    G1 Z108 F600
    G1 Z106

M400 P100
M17 R ; restore z current

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
M1006 A0 B10 L100 C48 D10 M60 E44 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10  N100
M1006 A49 B20 L100 C44 D20 M100 E41 F20 N100
M1006 A0 B20 L100 C0 D20 M60 E0 F20 N100
M1006 A0 B20 L100 C37 D20 M30 E37 F20 N60
M1006 W

M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M960 S5 P0 ; turn off logo lamp
M73 P100 R0
; EXECUTABLE_BLOCK_END

