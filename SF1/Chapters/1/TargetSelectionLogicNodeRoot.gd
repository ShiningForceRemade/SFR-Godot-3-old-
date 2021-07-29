extends Node

const tile_size: int = 24

signal signal_completed_target_selection_action

var is_target_selection_active: bool = false

var target_node_children

# very messy clean this up later 
# TODO: redo global battle vars to track more of this state internally
# so there isn't so much repatition in various nodes that are mostly similar
var target_range

var item_use_range

# var spell_use_range

var using_spell: bool = false

var current_selection_vec2

	
# var active_char_root = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	

var use_range_array_rep
var ac_pos
	
# total rows and columns
var t_rows
var t_cols
	
# center column and row
var c_col
var c_row
	
var row_tiles_movement
var col_tiles_movement
	
var check_pos = Vector2(0, 0)

func _ready():
	Singleton_Game_GlobalBattleVariables.target_selection_node = self
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if is_target_selection_active:
		if event.is_action_released("ui_b_key"):
			is_target_selection_active = false
			
			Singleton_Game_GlobalBattleVariables.currently_selected_actor = null
			
			# emit_signal("signal_completed_item_use_action")
			Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro()
			Singleton_Game_GlobalBattleVariables.field_logic_node.show_movement_tiles()
			Singleton_Game_GlobalBattleVariables.field_logic_node.hide_use_target_tiles()
			target_range.cleanup_cursor()
			
			if using_spell:
				Singleton_Game_GlobalBattleVariables.battle_base.s_show_battle_magic_menu()
			else:
				Singleton_Game_GlobalBattleVariables.battle_base.s_show_character_action_menu()
		
		if event.is_action_released("ui_a_key"):
			if Singleton_Game_GlobalBattleVariables.currently_selected_actor == null:
				is_target_selection_active = false
				# emit_signal("signal_completed_item_use_action")
				Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro()
				Singleton_Game_GlobalBattleVariables.field_logic_node.show_movement_tiles()
				Singleton_Game_GlobalBattleVariables.field_logic_node.hide_use_target_tiles()
				target_range.cleanup_cursor()
				
				if using_spell:
					Singleton_Game_GlobalBattleVariables.battle_base.s_show_battle_magic_menu()
				else:
					Singleton_Game_GlobalBattleVariables.battle_base.s_show_character_action_menu()
				
				return
			
			is_target_selection_active = false
			print("Called")
			print("TODO: trigger battle action scene and play out the item use effect")
			Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro()
			
			Singleton_Game_GlobalBattleVariables.camera_node.position_camera_for_battle_scene()
			# Singleton_Game_GlobalBattleVariables
			
			Singleton_Game_GlobalBattleVariables.battle_base.s_hide_land_effect()
			Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro_in_battle()
			
			Singleton_Game_GlobalBattleVariables.battle_scene_node.setup_character_and_enemey_sprites_idle()
			
			if using_spell:
				Singleton_Game_GlobalBattleVariables.battle_scene_node.setup_spell_usage()
			else:
				Singleton_Game_GlobalBattleVariables.battle_scene_node.setup_actor_attacking()
			
			yield(Singleton_Game_GlobalBattleVariables.battle_scene_node, "signal_battle_scene_complete")
			
			print("Complete")
			
			Singleton_Game_GlobalBattleVariables.camera_node.reset_camera_for_map()
			Singleton_Game_GlobalBattleVariables.field_logic_node.hide_use_target_tiles()
			Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro_in_battle()
			Singleton_Game_GlobalBattleVariables.battle_base.s_show_land_effect()
			target_range.cleanup_cursor()
			Singleton_Game_GlobalBattleVariables.currently_active_character.s_complete_turn()
			
			# Singleton_Game_GlobalBattleVariables.camera_node.reset_camera_for_map()
		
		if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_left"):
			# target_selection_counter_clockwise_quadarnt_style()
			target_selection_counter_clockwise__style_naive_pass_forward()
		elif event.is_action_pressed("ui_right") or event.is_action_pressed("ui_up"):
			# target_selection_clockwise_quadarnt_style() 
			target_selection_clockwise__style_naive_pass_forward()
			
		

func setup_use_range_and_target_range_selection(item_arg) -> void:
	using_spell = false
	Singleton_Game_GlobalBattleVariables.field_logic_node.hide_movement_tiles()
	
	print("Setup")
	
	is_target_selection_active = true

	print(item_arg)
	print(item_arg.item_use_range_path)
	item_use_range = load(item_arg.item_use_range_path).new()
	print(item_use_range)
	item_use_range._ready()
	# TODO create cleanup function to remove the attack grid when canclled or completed
	item_use_range.draw_use_range()
	Singleton_Game_GlobalBattleVariables.field_logic_node.show_use_target_tiles()
	
	target_range = load(item_arg.item_use_target_path).new()
	# TODO create cleanup function for this to remove the curosr
	target_range.draw_cursor_and_get_targets("test arg 123")

	# target_range.draw_cursor_at_position(new_pos_arg: Vector2)
	
	print("Target Actor Type - ", item_arg.target_actor_type)
	if item_arg.target_actor_type == 4:
		print("Self and Characters", Singleton_Game_GlobalBattleVariables.character_wrapper_node)
		target_node_children = Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
		
	elif item_arg.target_actor_type == 2: # Enemeies - TODO: add enum or consts to use instead of raw numbers
		print("Enemies", Singleton_Game_GlobalBattleVariables.enemies_wrapper_node)
		target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
		set_cursor_target_on_first_found_enemey()
		
		# target_range.draw_cursor_at_position(target_node_children[0].position)
	
	elif item_arg.target_actor_type == 3: # Enemeies - TODO: add enum or consts to use instead of raw numbers
		print("Both", Singleton_Game_GlobalBattleVariables.enemies_wrapper_node)
		target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
		target_node_children += Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
		set_cursor_target_on_first_found_enemey()	
	#emit_signal("signal_completed_item_use_action")
	# return


#func setup_use_range_and_target_range_selection_defaults(actor_type_selection) -> void:
#	using_spell = false
#	Singleton_Game_GlobalBattleVariables.field_logic_node.hide_movement_tiles()
#
#	print("Setup")
#
#	is_target_selection_active = true
#
#	item_use_range = load(item_arg.item_use_range_path).new()
#	print(item_use_range)
#	item_use_range._ready()
#	# TODO create cleanup function to remove the attack grid when canclled or completed
#	item_use_range.draw_use_range()
#	Singleton_Game_GlobalBattleVariables.field_logic_node.show_use_target_tiles()
#
#	target_range = load(item_arg.item_use_target_path).new()
#	# TODO create cleanup function for this to remove the curosr
#	target_range.draw_cursor_and_get_targets("test arg 123")
#
#	# target_range.draw_cursor_at_position(new_pos_arg: Vector2)
#
#	print("Target Actor Type - ", item_arg.target_actor_type)
#	if item_arg.target_actor_type == 4:
#		print("Self and Characters", Singleton_Game_GlobalBattleVariables.character_wrapper_node)
#		target_node_children = Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
#
#	elif item_arg.target_actor_type == 2: # Enemeies - TODO: add enum or consts to use instead of raw numbers
#		print("Enemies", Singleton_Game_GlobalBattleVariables.enemies_wrapper_node)
#		target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
#		set_cursor_target_on_first_found_enemey()
#
#		# target_range.draw_cursor_at_position(target_node_children[0].position)
#
#	elif item_arg.target_actor_type == 3: # Enemeies - TODO: add enum or consts to use instead of raw numbers
#		print("Both", Singleton_Game_GlobalBattleVariables.enemies_wrapper_node)
#		target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
#		target_node_children += Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
#		set_cursor_target_on_first_found_enemey()	
#	#emit_signal("signal_completed_item_use_action")
#	# return


func setup_magic_use_range_and_target_range_selection(spell_arg) -> void:
	using_spell = true
	Singleton_Game_GlobalBattleVariables.field_logic_node.hide_movement_tiles()
	
	print("Setup")
	
	is_target_selection_active = true
	
	print(spell_arg)
	print(spell_arg.spell_use_range_path)
	# spell_use_range = load(spell_arg.spell_use_range_path).new()
	item_use_range = load(spell_arg.spell_use_range_path).new()
	print(item_use_range)
	item_use_range._ready()
	# TODO create cleanup function to remove the attack grid when canclled or completed
	item_use_range.draw_use_range()
	Singleton_Game_GlobalBattleVariables.field_logic_node.show_use_target_tiles()
	
	target_range = load(spell_arg.spell_use_target_path).new()
	# TODO create cleanup function for this to remove the curosr
	target_range.draw_cursor_and_get_targets("test arg 123")

	# target_range.draw_cursor_at_position(new_pos_arg: Vector2)
	
	print("Target Actor Type - ", spell_arg.usable_on_actor_type)
	if spell_arg.usable_on_actor_type == 2:
		print("Self and Characters", Singleton_Game_GlobalBattleVariables.character_wrapper_node)
		target_node_children = Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
		
	elif spell_arg.usable_on_actor_type == 1: # Enemeies - TODO: add enum or consts to use instead of raw numbers
		print("Enemies", Singleton_Game_GlobalBattleVariables.enemies_wrapper_node)
		target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
		set_cursor_target_on_first_found_enemey()
		
		# target_range.draw_cursor_at_position(target_node_children[0].position)
		
	#emit_signal("signal_completed_item_use_action")
	# return

func get_character_at_tile_position(pos_arg):
	for child in target_node_children:
		if child.position == pos_arg:
			print(child.name)
			return child
			
	return null

# TODO: this can be simplified soooo much clean this up and remove a lot of the redundant elements later
func set_cursor_target_on_first_found_enemey() -> void:
	setup_quadrant_vars()
	
	for child in target_node_children:
		print("Target Child", child)
		print(child.position)
		
		for c in range(t_cols):
			for r in range(t_rows):
				if use_range_array_rep[r][c] != null:
					print(use_range_array_rep[r][c])
					
					print(child.position, " ", Vector2(ac_pos.x + get_tile_position_adjustment(r, c_row), ac_pos.y + get_tile_position_adjustment(c, c_col)))
					if child.position == Vector2(ac_pos.x + get_tile_position_adjustment(r, c_row), ac_pos.y + get_tile_position_adjustment(c, c_col)):
						set_and_save_new_target_selection(r, c, child)
						backwards_pass_naive(current_selection_vec2.x, current_selection_vec2.y)
						forward_pass_naive(current_selection_vec2.x, current_selection_vec2.y)
						# Found inital target no need to continue searching
						return
	
	# if reached here no enemeies
	# print no target and cancel out of attack
	# TODO: probably should do this check much earlier
	
	# Singleton_Game_AudioManager.
	
	Singleton_Game_GlobalBattleVariables.battle_base.noValidOptionWarningBoxRoot.set_no_target_text()
	Singleton_Game_GlobalBattleVariables.battle_base.noValidOptionWarningBoxRoot.re_show_action_menu = false
	Singleton_Game_GlobalBattleVariables.battle_base.s_show_no_valid_option_warning_box()
	
	target_range.bc_cursor_ref.hide() # cleanup_cursor()
	
	yield(get_tree().create_timer(1.5), "timeout")
	
	# ui_b_key cancel
	is_target_selection_active = false
	# emit_signal("signal_completed_item_use_action")
	# Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro()
	Singleton_Game_GlobalBattleVariables.field_logic_node.show_movement_tiles()
	Singleton_Game_GlobalBattleVariables.field_logic_node.hide_use_target_tiles()
	
	Singleton_Game_GlobalBattleVariables.battle_base.noValidOptionWarningBoxRoot.re_show_action_menu = true
	
	# target_range.cleanup_cursor()
			
	# if using_spell:
	# 	Singleton_Game_GlobalBattleVariables.battle_base.s_show_battle_magic_menu()
	# else:
	# 	Singleton_Game_GlobalBattleVariables.battle_base.s_show_character_action_menu()
	
	return

# TODO: allow for swapping to different selection methods
# should have smarter ones than a simple select next in array layout
# for demo and inital builds use naive pass same as SF1 for naive cases
# 
# smart heal ai priorty style
# damage finish off enemey ai
# directional based targeting (if character is looking left target left section first triangle cut square range
# 
# for generic target selection use shoulder buttons to swap selection logic
# have a ui popup update as well so its clear so style is being used
# might be nice to have a skull identifer to clearly show next target 
# 

func target_selection_clockwise__style_naive_pass_forward():
	print("Clockwise")
	setup_quadrant_vars()
	# TODO: FIXME above when doing auto target selection and no target if not found
	if current_selection_vec2 == null:
		current_selection_vec2 = Vector2(0, 0)
		
	print(c_row, current_selection_vec2.x, c_col, current_selection_vec2.y)
	
	if forward_pass_naive(current_selection_vec2.x, current_selection_vec2.y):
		return
	if forward_pass_naive(0, 0):
		return
	
	print("End nothing found")
	pass

func target_selection_counter_clockwise__style_naive_pass_forward():
	print("Clockwise")
	setup_quadrant_vars()
	
	# TODO: FIXME above when doing auto target selection and no target if not found
	if current_selection_vec2 == null:
		current_selection_vec2 = Vector2(0, 0)
	
	print(c_row, current_selection_vec2.x, c_col, current_selection_vec2.y)
	
	if backwards_pass_naive(current_selection_vec2.x, current_selection_vec2.y):
		return
	if backwards_pass_naive(t_rows - 1, t_cols - 1):
		return
	
	print("End nothing found")
	pass

func forward_pass_naive(start_row, start_col) -> bool:
	setup_quadrant_vars()
	
	var r = start_row
	var c = start_col
	
	print(use_range_array_rep, "\n")
	var check_pos
	
	while r < t_rows:
		while c < t_cols:
			if use_range_array_rep[r][c] == 1:
				if current_selection_vec2 == Vector2(r, c):
					print("Currently Selected - Skip - ", current_selection_vec2)
					c += 1
					continue
				
				print("row ", r, " col ",  c)
				
				check_pos = get_tile_adjustment(r, c_row, c, c_col)
				print(check_pos)
				
				for child in target_node_children:
					print(check_pos, " ", Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y), " ", child.position)
					if Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y) == child.position:
						set_and_save_new_target_selection(r, c, child)
						return true
				
			c += 1
			
		c = 0
		r += 1
	
	print("escape")
	return false

func backwards_pass_naive(start_row, start_col) -> bool:
	setup_quadrant_vars()
	
	var r = start_row
	var c = start_col
	
	print(use_range_array_rep, "\n")
	var check_pos
	
	while r >= 0:
		while c >= 0:
			if use_range_array_rep[r][c] == 1:
				if current_selection_vec2 == Vector2(r, c):
					print("Currently Selected - Skip - ", current_selection_vec2)
					c -= 1
					continue
				
				print("row ", r, " col ",  c)
				
				check_pos = get_tile_adjustment(r, c_row, c, c_col)
				print(check_pos)
				
				for child in target_node_children:
					print(check_pos, " ", Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y), " ", child.position)
					if Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y) == child.position:
						set_and_save_new_target_selection(r, c, child)
						return true
				
			c -= 1
			
		c = t_cols - 1
		r -= 1
	
	print("escape")
	return false





func enemey_actor_attack_setup():
	print("In Here")
	
	# setup_use_range_and_target_range_selection_enemey_static()
	
	Singleton_Game_GlobalBattleVariables.battle_base.landEffectPopupRoot.hide()
	Singleton_Game_GlobalBattleVariables.battle_base.s_hide_land_effect()
	
	Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro()
	
	Singleton_Game_GlobalBattleVariables.camera_node.position_camera_for_battle_scene()
	# Singleton_Game_GlobalBattleVariables
	
	# Singleton_Game_GlobalBattleVariables.battle_base.activeActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
	# Singleton_Game_GlobalBattleVariables.battle_base.s_show_active_actor_micro_in_battle()
	
	# Singleton_Game_GlobalBattleVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_active_character)
	Singleton_Game_GlobalBattleVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_active_character)
	
	Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro_in_battle()
	
	# Singleton_Game_GlobalBattleVariables.battle_scene_node.setup_character_and_enemey_sprites_idle()
	
	#if using_spell:
	#	Singleton_Game_GlobalBattleVariables.battle_scene_node.setup_spell_usage()
	#else:
	Singleton_Game_GlobalBattleVariables.battle_scene_node.setup_enemey_actor_attacking()
	
	yield(Singleton_Game_GlobalBattleVariables.battle_scene_node, "signal_battle_scene_complete")
	
	print("Complete")
			
	Singleton_Game_GlobalBattleVariables.camera_node.reset_camera_for_map()
	Singleton_Game_GlobalBattleVariables.field_logic_node.hide_use_target_tiles()
	Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro_in_battle()
	Singleton_Game_GlobalBattleVariables.battle_base.landEffectPopupRoot.show()
	Singleton_Game_GlobalBattleVariables.battle_base.s_show_land_effect()
	
	# target_range.cleanup_cursor()
	Singleton_Game_GlobalBattleVariables.currently_active_character.s_complete_turn()
	# yield(get_tree().create_timer(0.3), "timeout")


func setup_use_range_and_target_range_selection_enemey_static() -> void:
	using_spell = false
	Singleton_Game_GlobalBattleVariables.field_logic_node.hide_movement_tiles()
	print("Setup Enemey Target Select")
	
	item_use_range = load("res://General/UseAndTargetRangeResources/UseRangeResources/UseRange_1.gd").new()
	print(item_use_range)
	item_use_range._ready()
	# TODO create cleanup function to remove the attack grid when canclled or completed
	item_use_range.draw_use_range()
	Singleton_Game_GlobalBattleVariables.field_logic_node.show_use_target_tiles()
	
	target_range = load("res://General/UseAndTargetRangeResources/TargetRangeResources/TargetRange_1.gd").new()
	# TODO create cleanup function for this to remove the curosr
	target_range.draw_cursor_and_get_targets("test arg 123")
	# target_range.draw_cursor_at_position(new_pos_arg: Vector2)
	
	# print("Target Actor Type - ", item_arg.target_actor_type)
	# if item_arg.target_actor_type == 4:
	#	print("Self and Characters", Singleton_Game_GlobalBattleVariables.character_wrapper_node)
	#	target_node_children = Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
		
	#elif item_arg.target_actor_type == 2: # Enemeies - TODO: add enum or consts to use instead of raw numbers
	#	print("Enemies", Singleton_Game_GlobalBattleVariables.enemies_wrapper_node)
	#	target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
	#	set_cursor_target_on_first_found_enemey()
		
		# target_range.draw_cursor_at_position(target_node_children[0].position)
	
	#elif item_arg.target_actor_type == 3: # Enemeies - TODO: add enum or consts to use instead of raw numbers
	#	print("Both", Singleton_Game_GlobalBattleVariables.enemies_wrapper_node)
	#	target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
	#	target_node_children += Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
	#	set_cursor_target_on_first_found_enemey()	
	#emit_signal("signal_completed_item_use_action")
	# return


















func target_selection_clockwise_quadarnt_style():
	print("Clockwise")
	setup_quadrant_vars()
	print(c_row, current_selection_vec2.x, c_col, current_selection_vec2.y)
	
	if c_col <= current_selection_vec2.y:
		if right_side_pass_vt(current_selection_vec2.x, current_selection_vec2.y):
			return
		if left_side_pass_upwards(t_rows - 1, c_col):
			return
		if right_side_pass_vt(0, c_row):
			return
	else:
		if left_side_pass_upwards(current_selection_vec2.x, current_selection_vec2.y):
			return
		if right_side_pass_vt(0, c_col):
			return
		if left_side_pass_upwards(t_rows - 1, t_cols - 1):
			return
		# if left_side_pass_vt(0, c_row):
		# 	return
	
	print("End nothing found")
	pass

func target_selection_counter_clockwise_quadarnt_style():
	print("Counter Clockwise")
	setup_quadrant_vars()
	# print(c_row, current_selection_vec2.x, c_col, current_selection_vec2.y)
	
	if c_col <= current_selection_vec2.y:
		print("Right")
		if right_side_pass_upwards(current_selection_vec2.x, t_cols - 1):
		# if right_side_pass_upwards(current_selection_vec2.x, current_selection_vec2.y):
			return
		# print_debug("Left Down")
		if left_side_pass_vt(0, c_col):
			return
		if right_side_pass_upwards(t_rows - 1, t_cols - 1):
			return
	else:
		print("Left")
		if left_side_pass_vt(current_selection_vec2.x, current_selection_vec2.y):
			return
		if right_side_pass_upwards(t_rows - 1, t_cols - 1):
			return
		if left_side_pass_vt(0, 0):
			return
	
	print("End nothing found")
	pass

func right_side_clockwise_check():
	pass

func sort_actors_by_position(a, b) -> bool:
	print("Sort - ", a.position < b.position)
	if a.position < b.position:
		return true
		
	return false

func right_side_pass_vt(start_row, start_col) -> bool:
	setup_quadrant_vars()
	
	var r = start_row
	var c = start_col
	
	print(use_range_array_rep, "\n")
	var check_pos
	
	while r < t_rows:
		while c < t_cols:
			if use_range_array_rep[r][c] == 1:
				if current_selection_vec2 == Vector2(r, c):
					print("Currently Selected - Skip - ", current_selection_vec2)
					c += 1
					continue
				
				print("row ", r, " col ",  c)
				
				check_pos = get_tile_adjustment(r, c_row, c, c_col)
				print(check_pos)
				
				for child in target_node_children:
					print(check_pos, " ", Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y), " ", child.position)
					if Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y) == child.position:
						set_and_save_new_target_selection(r, c, child)
						return true
				
			c += 1
			
		if start_col >= c_col:
			c = c_col
		else:
			c = 0
		
		r += 1
	
	print("escape")
	return false

func left_side_pass_vt(start_row, start_col) -> bool:
	setup_quadrant_vars()
	
	var r = start_row
	var c = start_col
	
	print(use_range_array_rep, "\n")
	var check_pos
	
	while r < t_rows:
		while c >= 0:
			if use_range_array_rep[r][c] == 1:
				if current_selection_vec2 == Vector2(r, c):
					print("Currently Selected - Skip - ", current_selection_vec2)
					c -= 1
					continue
				
				print("row ", r, " col ",  c)
				
				check_pos = get_tile_adjustment(r, c_row, c, c_col)
				print(check_pos)
				
				for child in target_node_children:
					print(check_pos, " ", Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y), " ", child.position)
					if Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y) == child.position:
						set_and_save_new_target_selection(r, c, child)
						return true
				
			c -= 1
			
		
		c = c_col
		r += 1
	
	print("escape")
	return false

func left_side_pass_upwards(start_row, start_col) -> bool:
	setup_quadrant_vars()
	
	var r = start_row
	var c = start_col
	
	print(use_range_array_rep, "\n")
	var check_pos
	
	while r >= 0:
		while c >= 0:
			print(r," ", c)
			if use_range_array_rep[r][c] == 1:
				if current_selection_vec2 == Vector2(r, c):
					print("Currently Selected - Skip - ", current_selection_vec2)
					c -= 1
					continue
				
				print("row ", r, " col ",  c)
				
				check_pos = get_tile_adjustment(r, c_row, c, c_col)
				print(check_pos)
				
				for child in target_node_children:
					print(check_pos, " ", Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y), " ", child.position)
					if Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y) == child.position:
						set_and_save_new_target_selection(r, c, child)
						return true
				
			c -= 1
			
		
		c = c_col
		r -= 1
		print(r, " ", c, " asd ", 0)
	
	print("escape")
	return false

func right_side_pass_upwards(start_row, start_col) -> bool:
	setup_quadrant_vars()
	
	var r = start_row
	var c = start_col
	
	print(use_range_array_rep, "\n")
	var check_pos
	
	while r >= 0:
		while c >= c_col:
			print(r," ", c)
			if use_range_array_rep[r][c] == 1:
				if current_selection_vec2 == Vector2(r, c):
					print("Currently Selected - Skip - ", current_selection_vec2)
					c -= 1
					continue
				
				print("row ", r, " col ",  c)
				
				check_pos = get_tile_adjustment(r, c_row, c, c_col)
				print(check_pos)
				
				for child in target_node_children:
					print(check_pos, " ", Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y), " ", child.position)
					if Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y) == child.position:
						set_and_save_new_target_selection(r, c, child)
						return true
				
			c -= 1
		
		c = start_col
		r -= 1
		print(r, " ", c, " asd ", 0)
	
	print("escape")
	return false

func right_side_pass_vt_old() -> bool:
	setup_quadrant_vars()
	
	var r = 0
	var c = 0
	
	print(use_range_array_rep, "\n")
	var check_pos
	
	while r < t_rows:
		while c < t_cols:
			if use_range_array_rep[r][c] == 1:
				if current_selection_vec2 == Vector2(r, c):
					print("Currently Selected - Skip - ", current_selection_vec2)
					c += 1
					continue
				
				print("row ", r, " col ",  c)
				
				check_pos = get_tile_adjustment(r, c_row, c, c_col)
				print(check_pos)
				
				for child in target_node_children:
					print(check_pos, " ", Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y), " ", child.position)
					if Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y) == child.position:
						set_and_save_new_target_selection(r, c, child)
						return true
				
			c += 1
			
		c = 0
		r += 1
	
	print("escape")
	return false

func get_tile_adjustment(current_row, center_row, current_col, center_col) -> Vector2:
	return Vector2(get_tile_position_adjustment(current_col, center_col), get_tile_position_adjustment(current_row, center_row))

func get_tile_position_adjustment(cur_rc, center_rc) -> int:
	print(cur_rc, " ", center_rc)
	if cur_rc < center_rc:
		return ((center_rc - cur_rc) * tile_size) * -1
	elif cur_rc > center_rc:
		return (cur_rc - center_rc) * tile_size
	else:
		return 0 * tile_size


func setup_quadrant_vars() -> void:
	use_range_array_rep = item_use_range.get_use_range_array_representation()
	ac_pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
	
	# total rows and columns
	t_rows = use_range_array_rep.size()
	t_cols = use_range_array_rep[0].size()
	
	# center column and row
	c_col = floor(t_cols / 2)
	c_row = floor(t_rows / 2)
	
	row_tiles_movement = 0
	col_tiles_movement = 0
	
	check_pos = Vector2(0, 0)

func set_and_save_new_target_selection(current_row, current_col, child) -> void: 
	current_selection_vec2 = Vector2(current_row, current_col)
	print("Found - Current Select - ", current_selection_vec2)
	print(child, "  -   ", child.position)
	target_range.draw_cursor_at_position(child.position)
	Singleton_Game_GlobalBattleVariables.currently_selected_actor = child
	Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro()
