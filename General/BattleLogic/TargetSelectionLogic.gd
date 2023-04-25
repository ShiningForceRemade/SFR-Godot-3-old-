extends Node

var is_target_selection_active: bool = false

@onready var target_selection_wrapper: Node2D = $TargetSelectionWrapper
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var actor_root

func _ready():
	Singleton_CommonVariables.battle__logic__target_selection_node = self
	Singleton_CommonVariables.battle__logic__target_selection_wrapper_node = $TargetSelectionWrapper


func hide_movement_tiles() -> void:
	Singleton_CommonVariables.battle__movement_tiles_wrapper_node.hide()


func show_movement_tiles() -> void:
	Singleton_CommonVariables.battle__movement_tiles_wrapper_node.show()


func get_actor_root() -> void:
	actor_root = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot")
	if actor_root != null:
		return
	
	actor_root = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("EnemeyRoot")
	if actor_root != null:
		return
	
	print("BUG: Actor root not found in target selection logic node")

const center_segment = Color("7de1e1e1") # default tile color when not debugging
const white_segment = Color("FFFFFF") # actor
const tile_size: int = 24
const half_tile_size: int = 12
func draw_flashing_movement_square(acolor: Color, xpos: int, ypos: int) -> void:
	var cr = ColorRect.new()
	# cr.color = acolor
	cr.color = white_segment
	cr.size.x = tile_size
	cr.size.y = tile_size

	cr.position.x = xpos - half_tile_size
	cr.position.y = ypos - half_tile_size
	
	Singleton_CommonVariables.battle__logic__target_selection_wrapper_node.add_child(cr)


func draw_and_populate_cell_info(
	row_arg: int, col_arg: int,
	tile_pos_arg: Vector2,
) -> void:
	Singleton_CommonVariables.battle__target_use_range_array_representation[row_arg][col_arg] = {
		"on_tile": "empty",
		"position": tile_pos_arg,
		"node": null,
	}
	
	var actor_details = check_if_actor_on_tile_at_pos(tile_pos_arg)
	Singleton_CommonVariables.battle__target_use_range_array_representation[row_arg][col_arg].on_tile = actor_details.type
	Singleton_CommonVariables.battle__target_use_range_array_representation[row_arg][col_arg].node = actor_details.node
	
	draw_flashing_movement_square(white_segment, tile_pos_arg.x, tile_pos_arg.y)


func check_if_actor_on_tile_at_pos(chk_pos_arg: Vector2):
	for enemey in Singleton_CommonVariables.battle__enemies.get_children():
		if enemey.get_child(0).global_position == chk_pos_arg:
			return { "type": "enemey", "node": enemey  }
	
	for character in Singleton_CommonVariables.battle__characters.get_children():
		if character.get_child(0).global_position == chk_pos_arg:
			return { "type": "character", "node": character }
	
	return { "type": "empty", "node": null }


func set_attack_target_selection() -> void:
	get_actor_root()
	
	# TODO: move these normal_attack strings to an enum or something in the global common vars
	# cleanup later
	Singleton_CommonVariables.battle__target_selection_type = "normal_attack"
	
	for i in range(actor_root.inventory_items_id.size()):
		print(actor_root.inventory_items_id[i])
		
		if actor_root.inventory_items_id[i].item_type == "WEAPON":
			if actor_root.is_item_equipped[i] == true:
				print("get use range and target selector type")
				
				draw_use_range_from_script(actor_root.inventory_items_id[i].item_use_range_path)
				is_target_selection_active = true
				
				return
	
	# TODO: should make it possible that characters and enemies can have different 
	# default use targets ranges and selectors
	
	draw_use_range_from_script("res://General/UseAndTargetRangeResources/UseRangeResources/UseRange_1.gd")
	is_target_selection_active = true


func draw_use_range_from_script(script_path: String) -> void:
	var use_range_script = load("res://General/UseAndTargetRangeResources/UseRangeResources/UseRange_1.gd").new()
	use_range_script.draw_use_range()
	hide_movement_tiles()
	target_selection_wrapper.show()
	animation_player.play("TilesFlashing")
	attempt_to_find_first_target()


func attempt_to_find_first_target() -> void:
	for i in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size()):
		for j in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size()):
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j] != null && Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile != "empty":
				print("First none empty tile target")
				
				if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node == null:
					continue
				
				# show cursor at first target
				Singleton_CommonVariables.battle__cursor_node.position = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position
				Singleton_CommonVariables.battle__target_selection_actor = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node
				print(Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node)
				Singleton_CommonVariables.battle__cursor_node.show()
				
				return
			
	print("No target")
	return


func set_magic_target_selection() -> void:
	pass


func set_item_target_selection() -> void:
	pass


func _process(_delta: float) -> void:
	if !is_target_selection_active:
		return
	
	if Input.is_action_just_released("ui_b_key"):
		is_target_selection_active = false
		
		Singleton_CommonVariables.battle__target_selection_actor = null
		
		# Singleton_CommonVariables.battle_base.s_hide_target_actor_micro()
		
		Singleton_CommonVariables.battle__cursor_node.hide()
		show_movement_tiles()
		target_selection_wrapper.hide()
		
		if Singleton_CommonVariables.battle__target_selection_type == "magic":
			# Singleton_CommonVariables.battle_base.s_show_battle_magic_menu()
			pass
		else:
			Singleton_CommonVariables.ui__battle_action_menu.show_cust()
			Singleton_CommonVariables.ui__battle_action_menu.set_menu_active()
	
	if Input.is_action_just_released("ui_a_key"):
		if Singleton_CommonVariables.battle__target_selection_actor != null:
			pass
			# is_target_selection_active = false
			
#			Singleton_CommonVariables.battle_base.s_hide_target_actor_micro()
#			Singleton_CommonVariables.field_logic_node.show_movement_tiles()
#			Singleton_CommonVariables.field_logic_node.hide_use_target_tiles()
##			target_range.cleanup_cursor()
#
#			print("TODO: trigger battle action scene and play out the item use effect")
#			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
#
#			Singleton_CommonVariables.top_level_fader_node.black_fade_anim_in()
#			await Signal(get_tree().create_timer(0.325), "timeout")
#			Singleton_CommonVariables.camera_node.position_camera_for_battle_scene()
#
#			Singleton_CommonVariables.battle_base.s_hide_target_actor_micro()
#			Singleton_CommonVariables.battle_base.s_hide_land_effect()
#			Singleton_CommonVariables.battle_base.s_show_target_actor_micro_in_battle()
#			if spell_name_selected == "Heal":
#				Singleton_CommonVariables.battle_base.s_hide_target_actor_micro_in_battle()
#
#			Singleton_CommonVariables.battle_scene_node.setup_character_and_enemey_sprites_idle()
#			get_background_foreground_and_stand_for_active_character_and_target(Singleton_CommonVariables.currently_selected_actor.position)
#
#			Singleton_AudioManager.stop_music_n()
#
#			if using_spell:
#				Singleton_CommonVariables.battle_scene_node.setup_spell_usage()
#			else:
#				if Singleton_CommonVariables.currently_active_character.get_actor_root_node_internal().actor_type == "character":
#					Singleton_CommonVariables.battle_scene_node.setup_actor_attacking()
#				elif Singleton_CommonVariables.currently_active_character.get_actor_root_node_internal().actor_type == "enemey":
#					Singleton_CommonVariables.battle_scene_node.setup_enemey_actor_attacking()
#
#			await Signal(Singleton_CommonVariables.battle_scene_node, "signal_battle_scene_complete")
#
#			print("Complete")
#
#			Singleton_CommonVariables.camera_node.reset_camera_for_map()
#			Singleton_CommonVariables.top_level_fader_node.black_fade_anim_out()
#
#			Singleton_CommonVariables.field_logic_node.hide_use_target_tiles()
#			Singleton_CommonVariables.battle_base.s_hide_target_actor_micro_in_battle()
#			Singleton_CommonVariables.battle_base.s_show_land_effect()
#			target_range.cleanup_cursor()
#
#			await Signal(get_tree().create_timer(0.25), "timeout")
#
#			Singleton_CommonVariables.currently_active_character.s_complete_turn()
#
#			Singleton_AudioManager.play_music_n(Singleton_DevToolingManager.base_path + "Assets/SF1/SoundBank/Battle 1 (Standard).mp3")
#
			# Singleton_Game_GlobalBattleVariables.camera_node.reset_camera_for_map()
	
	
	if Input.is_action_just_released("ui_down") or Input.is_action_just_released("ui_left"):
		target_selection_counter_clockwise__style_naive_pass_forward()
		change_direction_based_on_position()
	elif Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_up"):
		target_selection_clockwise__style_naive_pass_forward()
		change_direction_based_on_position()


func change_direction_based_on_position() -> void:
	var cur_gp = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).global_position
	var tar_gp = Singleton_CommonVariables.battle__target_selection_actor.get_child(0).global_position
	# print(mcp, " ", current_selection_vec2)
	
	if(cur_gp.x < tar_gp.x and cur_gp.y == tar_gp.y):
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).play_facing_direction("Right")
	elif(cur_gp.x > tar_gp.x and cur_gp.x == tar_gp.x):
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).play_facing_direction("Left")
	elif(cur_gp.y > tar_gp.y):
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).play_facing_direction("Up")
	else:
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).play_facing_direction("Down")


func target_selection_counter_clockwise__style_naive_pass_forward() -> void:
	var sgpos = Singleton_CommonVariables.battle__target_selection_actor.get_child(0).global_position
	
	var found_current: bool = false
	for i in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size()):
		for j in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size()):
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j] == null || Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile == "empty":
				continue
			
			if found_current:
				Singleton_CommonVariables.battle__cursor_node.position = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position
				Singleton_CommonVariables.battle__target_selection_actor = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node
				return
			
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position == sgpos:
				found_current = true
	
	# not found so loop back around to first top target
	for i in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size()):
		for j in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size()):
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j] == null || Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile == "empty":
				continue
			
			Singleton_CommonVariables.battle__cursor_node.position = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position
			Singleton_CommonVariables.battle__target_selection_actor = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node
			return


func target_selection_clockwise__style_naive_pass_forward() -> void:
	var sgpos = Singleton_CommonVariables.battle__target_selection_actor.get_child(0).global_position
	
	var found_current: bool = false
	# var arr_size = Singleton_CommonVariables.battle__target_use_range_array_representation.size()
	
	for i in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size() - 1, -1, -1):
		for j in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size() - 1, -1, -1):
			print("i ", i, "j ", j)
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j] == null || Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile == "empty":
				continue
			
			if found_current:
				print("found")
				Singleton_CommonVariables.battle__cursor_node.position = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position
				Singleton_CommonVariables.battle__target_selection_actor = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node
				return
			
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position == sgpos:
				found_current = true
	
	# not found so loop back around to last target
	for i in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size() - 1, -1, -1):
		for j in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size() - 1, -1, -1):
			print("i ", i, "j ", j)
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j] == null || Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile == "empty":
				continue
			
			Singleton_CommonVariables.battle__cursor_node.position = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position
			Singleton_CommonVariables.battle__target_selection_actor = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node
			return


#func _input(event):
#	if is_target_selection_active:

#
#





#const tile_size: int = 24
#
#
#var is_target_selection_active: bool = false
#
#var target_node_children
#
## very messy clean this up later 
## TODO: redo global battle vars to track more of this state internally
## so there isn't so much repatition in various nodes that are mostly similar
#var target_range
#
#var item_use_range
#
#var spell_name_selected: String
#
## var spell_use_range
#
#var using_spell: bool = false
#
#var current_selection_vec2
#
#
## var active_char_root = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
#
#
#var use_range_array_rep
#var ac_pos
#
## total rows and columns
#var t_rows
#var t_cols
#
## center column and row
#var c_col
#var c_row
#
#var row_tiles_movement
#var col_tiles_movement
#
#var check_pos = Vector2(0, 0)
#
#
#
#
#
#func get_background_foreground_and_stand_for_active_character_and_target(new_pos: Vector2):
#	var f = Singleton_CommonVariables.tilemap_foreground
#	var tile_id = f.get_cellv(f.world_to_map(new_pos))
#	if tile_id == -1:
#		print("Bug: no foreground tile underneath")
#		return
#
#	var foreground_tile_name = f.tile_set.tile_get_name(tile_id)
#	print(foreground_tile_name)
#
#	var b = Singleton_CommonVariables.tilemap_background
#	tile_id = b.get_cellv(b.world_to_map(new_pos))
#	if tile_id == -1:
#		print("Bug: no background tile underneath")
#		return
#
#	var background_tile_name = b.tile_set.tile_get_name(tile_id)
#	print(background_tile_name)
#
#	var s = Singleton_CommonVariables.tilemap_stand
#	tile_id = s.get_cellv(s.world_to_map(new_pos))
#	if tile_id == -1:
#		print("Bug: no stand tile underneath")
#		return
#
#	var stand_tile_name = s.tile_set.tile_get_name(tile_id)
#	print(stand_tile_name)
#
#	Singleton_CommonVariables.battle_scene_node.setup_foreground_background_and_stand(foreground_tile_name, background_tile_name, stand_tile_name)
#
#	print("")
##	if "30" in tile_name:
##		emit_signal("signal_land_effect_under_tile", 30)
##	elif "15" in tile_name:
##		emit_signal("signal_land_effect_under_tile", 15)
##	elif "0" in tile_name:
##		emit_signal("signal_land_effect_under_tile", 0)
##	else:
##		# print("Bug: No Info Report")
##		emit_signal("signal_land_effect_under_tile", "Bug: No Info Report")
#
#
#func setup_use_range_and_target_range_selection(item_arg, actor_target_type = "enemey") -> void:
#	spell_name_selected = ""
#
#	using_spell = false
#	Singleton_CommonVariables.field_logic_node.hide_movement_tiles()
#
#	print("Setup")
#
#	is_target_selection_active = true
#
#	print(item_arg)
#	print(item_arg.item_use_range_path)
#	item_use_range = load(item_arg.item_use_range_path).new()
#	print(item_use_range)
#	item_use_range._ready()
#	# TODO create cleanup function to remove the attack grid when canclled or completed
#	item_use_range.draw_use_range()
#	Singleton_CommonVariables.field_logic_node.show_use_target_tiles()
#
#	target_range = load(item_arg.item_use_target_path).new()
#	# TODO create cleanup function for this to remove the curosr
#	target_range.draw_cursor_and_get_targets("test arg 123")
#
#	# target_range.draw_cursor_at_position(new_pos_arg: Vector2)
#
#	print("Target Actor Type - ", item_arg.target_actor_type)
#	if item_arg.target_actor_type == 4 || actor_target_type == "character":
#		print("Self and Characters", Singleton_CommonVariables.character_wrapper_node)
#		target_node_children = Singleton_CommonVariables.character_wrapper_node.get_children()
#
#	elif item_arg.target_actor_type == 2: # Enemeies - TODO: add enum or consts to use instead of raw numbers
#		print("Enemies", Singleton_CommonVariables.enemies_wrapper_node)
#		target_node_children = Singleton_CommonVariables.enemies_wrapper_node.get_children()
#		set_cursor_target_on_first_found_enemey()
#
#		# target_range.draw_cursor_at_position(target_node_children[0].position)
#
#	elif item_arg.target_actor_type == 3: # Enemeies - TODO: add enum or consts to use instead of raw numbers
#		print("Both", Singleton_CommonVariables.enemies_wrapper_node)
#		target_node_children = Singleton_CommonVariables.enemies_wrapper_node.get_children()
#		target_node_children += Singleton_CommonVariables.character_wrapper_node.get_children()
#		set_cursor_target_on_first_found_enemey()	
#	#emit_signal("signal_completed_item_use_action")
#	# return
#
#
##func setup_use_range_and_target_range_selection_defaults(actor_type_selection) -> void:
##	using_spell = false
##	Singleton_Game_GlobalBattleVariables.field_logic_node.hide_movement_tiles()
##
##	print("Setup")
##
##	is_target_selection_active = true
##
##	item_use_range = load(item_arg.item_use_range_path).new()
##	print(item_use_range)
##	item_use_range._ready()
##	# TODO create cleanup function to remove the attack grid when canclled or completed
##	item_use_range.draw_use_range()
##	Singleton_Game_GlobalBattleVariables.field_logic_node.show_use_target_tiles()
##
##	target_range = load(item_arg.item_use_target_path).new()
##	# TODO create cleanup function for this to remove the curosr
##	target_range.draw_cursor_and_get_targets("test arg 123")
##
##	# target_range.draw_cursor_at_position(new_pos_arg: Vector2)
##
##	print("Target Actor Type - ", item_arg.target_actor_type)
##	if item_arg.target_actor_type == 4:
##		print("Self and Characters", Singleton_Game_GlobalBattleVariables.character_wrapper_node)
##		target_node_children = Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
##
##	elif item_arg.target_actor_type == 2: # Enemeies - TODO: add enum or consts to use instead of raw numbers
##		print("Enemies", Singleton_Game_GlobalBattleVariables.enemies_wrapper_node)
##		target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
##		set_cursor_target_on_first_found_enemey()
##
##		# target_range.draw_cursor_at_position(target_node_children[0].position)
##
##	elif item_arg.target_actor_type == 3: # Enemeies - TODO: add enum or consts to use instead of raw numbers
##		print("Both", Singleton_Game_GlobalBattleVariables.enemies_wrapper_node)
##		target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
##		target_node_children += Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
##		set_cursor_target_on_first_found_enemey()	
##	#emit_signal("signal_completed_item_use_action")
##	# return
#
#
#func setup_magic_use_range_and_target_range_selection(spell_arg) -> void:
#	spell_name_selected = spell_arg.name
#
#	if spell_arg.name == "Egress":
#		await Signal(get_tree().create_timer(0.02), "timeout")
#		emit_signal("signal_completed_magic_level_selection_action")
#		return
##	if spell_arg.name == "Heal":
##		Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro_in_battle()
##		yield(get_tree().create_timer(0.02), "timeout")
##		emit_signal("signal_completed_magic_level_selection_action")
##		return
#
#	using_spell = true
#	Singleton_CommonVariables.field_logic_node.hide_movement_tiles()
#
#	print("Setup")
#
#
#	is_target_selection_active = true
#
#	print(spell_arg)
#	print(spell_arg.spell_use_range_path)
#	# spell_use_range = load(spell_arg.spell_use_range_path).new()
#	item_use_range = load(spell_arg.spell_use_range_path).new()
#	print(item_use_range)
#	item_use_range._ready()
#	# TODO create cleanup function to remove the attack grid when canclled or completed
#	item_use_range.draw_use_range()
#	Singleton_CommonVariables.field_logic_node.show_use_target_tiles()
#
#	target_range = load(spell_arg.spell_use_target_path).new()
#	# TODO create cleanup function for this to remove the curosr
#	target_range.draw_cursor_and_get_targets("test arg 123")
#
#	# target_range.draw_cursor_at_position(new_pos_arg: Vector2)
#
#	print("Target Actor Type - ", spell_arg.usable_on_actor_type)
#	if spell_arg.usable_on_actor_type == 2:
#		print("Self and Characters", Singleton_CommonVariables.character_wrapper_node)
#		target_node_children = Singleton_CommonVariables.character_wrapper_node.get_children()
#		set_cursor_target_on_first_found_enemey()
#
#	elif spell_arg.usable_on_actor_type == 1: # Enemeies - TODO: add enum or consts to use instead of raw numbers
#		print("Enemies", Singleton_CommonVariables.enemies_wrapper_node)
#		target_node_children = Singleton_CommonVariables.enemies_wrapper_node.get_children()
#		set_cursor_target_on_first_found_enemey()
#
#		# target_range.draw_cursor_at_position(target_node_children[0].position)
#
#	#emit_signal("signal_completed_item_use_action")
#	# return
#
#func get_character_at_tile_position(pos_arg):
#	for child in target_node_children:
#		if child.global_position == pos_arg:
#			print(child.name)
#			return child
#
#	return null
#
#
## TODO: allow for swapping to different selection methods
## should have smarter ones than a simple select next in array layout
## for demo and inital builds use naive pass same as SF1 for naive cases
## 
## smart heal ai priorty style
## damage finish off enemey ai
## directional based targeting (if character is looking left target left section first triangle cut square range
## 
## for generic target selection use shoulder buttons to swap selection logic
## have a ui popup update as well so its clear so style is being used
## might be nice to have a skull identifer to clearly show next target 
## 
#
#func target_selection_clockwise__style_naive_pass_forward():
#	# print("Clockwise")
#	setup_quadrant_vars()
#	# TODO: FIXME above when doing auto target selection and no target if not found
#	if current_selection_vec2 == null:
#		current_selection_vec2 = Vector2(0, 0)
#
#	# print(c_row, current_selection_vec2.x, c_col, current_selection_vec2.y)
#
#	if forward_pass_naive(current_selection_vec2.x, current_selection_vec2.y):
#		return
#	if forward_pass_naive(0, 0):
#		return
#
#	# print("End nothing found")
#	pass
#
#func target_selection_counter_clockwise__style_naive_pass_forward():
#	# print("Clockwise")
#	setup_quadrant_vars()
#
#	# TODO: FIXME above when doing auto target selection and no target if not found
#	if current_selection_vec2 == null:
#		current_selection_vec2 = Vector2(0, 0)
#
#	# print(c_row, current_selection_vec2.x, c_col, current_selection_vec2.y)
#
#	if backwards_pass_naive(current_selection_vec2.x, current_selection_vec2.y):
#		return
#	if backwards_pass_naive(t_rows - 1, t_cols - 1):
#		return
#
#	# print("End nothing found")
#	pass
#
#func forward_pass_naive(start_row, start_col) -> bool:
#	setup_quadrant_vars()
#
#	var r = start_row
#	var c = start_col
#
#	# print(use_range_array_rep, "\n")
#	var check_pos_internal
#
#	while r < t_rows:
#		while c < t_cols:
#			if use_range_array_rep[r][c] == 1:
#				if current_selection_vec2 == Vector2(r, c):
#					# print("Currently Selected - Skip - ", current_selection_vec2)
#					c += 1
#					continue
#
#				# print("row ", r, " col ",  c)
#
#				check_pos_internal = get_tile_adjustment(r, c_row, c, c_col)
#				# print(check_pos)
#
#				for child in target_node_children:
#					# print(check_pos, " ", Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y), " ", child.position)
#					if Vector2(ac_pos.x + check_pos_internal.x, ac_pos.y + check_pos_internal.y) == child.global_position:
#						set_and_save_new_target_selection(r, c, child)
#						return true
#
#			c += 1
#
#		c = 0
#		r += 1
#
#	# print("escape")
#	return false
#
#func backwards_pass_naive(start_row, start_col) -> bool:
#	setup_quadrant_vars()
#
#	var r = start_row
#	var c = start_col
#
#	# print(use_range_array_rep, "\n")
#	var check_pos_internal
#
#	while r >= 0:
#		while c >= 0:
#			if use_range_array_rep[r][c] == 1:
#				if current_selection_vec2 == Vector2(r, c):
#					# print("Currently Selected - Skip - ", current_selection_vec2)
#					c -= 1
#					continue
#
#				# print("row ", r, " col ",  c)
#
#				check_pos_internal = get_tile_adjustment(r, c_row, c, c_col)
#				# print(check_pos)
#
#				for child in target_node_children:
#					# print(check_pos, " ", Vector2(ac_pos.x + check_pos.x, ac_pos.y + check_pos.y), " ", child.position)
#					if Vector2(ac_pos.x + check_pos_internal.x, ac_pos.y + check_pos_internal.y) == child.global_position:
#						set_and_save_new_target_selection(r, c, child)
#						return true
#
#			c -= 1
#
#		c = t_cols - 1
#		r -= 1
#
#	# print("escape")
#	return false
#
#
#
#
#
#func enemey_actor_attack_setup():
#	print("In Here")
#
#	# Singleton_Game_GlobalCommonVariables.top_level_fader_node.black_fade_anim_in()
#	# yield(get_tree().create_timer(0.3), "timeout")
#
#	# setup_use_range_and_target_range_selection_enemey_static()
#
#	Singleton_CommonVariables.battle_base.landEffectPopupRoot.hide()
#	Singleton_CommonVariables.battle_base.s_hide_land_effect()
#
#	Singleton_CommonVariables.battle_base.s_hide_target_actor_micro()
#
#	Singleton_CommonVariables.top_level_fader_node.black_fade_anim_in()
#	await Signal(get_tree().create_timer(0.325), "timeout")
#
#	Singleton_CommonVariables.camera_node.position_camera_for_battle_scene()
#
#	# Singleton_Game_GlobalBattleVariables
#
#	# Singleton_Game_GlobalBattleVariables.battle_base.activeActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
#	# Singleton_Game_GlobalBattleVariables.battle_base.s_show_active_actor_micro_in_battle()
#
#	# Singleton_Game_GlobalBattleVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_active_character)
#	Singleton_CommonVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_CommonVariables.currently_active_character)
#
#	Singleton_CommonVariables.battle_base.s_show_target_actor_micro_in_battle()
#
#	# Singleton_Game_GlobalBattleVariables.battle_scene_node.setup_character_and_enemey_sprites_idle()
#
#	#if using_spell:
#	#	Singleton_Game_GlobalBattleVariables.battle_scene_node.setup_spell_usage()
#	#else:
#
#	Singleton_AudioManager.stop_music_n()
#
#	Singleton_CommonVariables.battle_scene_node.setup_enemey_actor_attacking()
#	await Signal(Singleton_CommonVariables.battle_scene_node, "signal_battle_scene_complete")
#
#	print("Complete")
#
#	Singleton_CommonVariables.top_level_fader_node.black_fade_anim_out()
#	Singleton_CommonVariables.camera_node.reset_camera_for_map()
#	Singleton_CommonVariables.battle_base.s_hide_target_actor_micro_in_battle()
#	Singleton_CommonVariables.battle_base.landEffectPopupRoot.show()
#	Singleton_CommonVariables.battle_base.s_show_land_effect()
#	Singleton_CommonVariables.field_logic_node.hide_use_target_tiles()
#
#	await Signal(get_tree().create_timer(0.45), "timeout")
#
#	# Singleton_Game_GlobalCommonVariables.top_level_fader_node.black_fade_anim_out()
#
#	# yield(get_tree().create_timer(0.5), "timeout")
#
#	Singleton_AudioManager.play_music_n("res://Assets/SF1/SoundBank/Battle 1 (Standard).mp3")
#
#	# target_range.cleanup_cursor()
#	Singleton_CommonVariables.currently_active_character.s_complete_turn()
#
#
#
#func setup_use_range_and_target_range_selection_enemey_static() -> void:
#	using_spell = false
#	Singleton_CommonVariables.field_logic_node.hide_movement_tiles()
#	print("Setup Enemey Target Select")
#
#	item_use_range = load("res://General/UseAndTargetRangeResources/UseRangeResources/UseRange_1.gd").new()
#	print(item_use_range)
#	item_use_range._ready()
#	# TODO create cleanup function to remove the attack grid when canclled or completed
#	item_use_range.draw_use_range()
#	Singleton_CommonVariables.field_logic_node.show_use_target_tiles()
#
#	target_range = load("res://General/UseAndTargetRangeResources/TargetRangeResources/TargetRange_1.gd").new()
#	# TODO create cleanup function for this to remove the curosr
#	target_range.draw_cursor_and_get_targets("test arg 123")
#	# target_range.draw_cursor_at_position(new_pos_arg: Vector2)
#
#	# print("Target Actor Type - ", item_arg.target_actor_type)
#	# if item_arg.target_actor_type == 4:
#	#	print("Self and Characters", Singleton_Game_GlobalBattleVariables.character_wrapper_node)
#	#	target_node_children = Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
#
#	#elif item_arg.target_actor_type == 2: # Enemeies - TODO: add enum or consts to use instead of raw numbers
#	#	print("Enemies", Singleton_Game_GlobalBattleVariables.enemies_wrapper_node)
#	#	target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
#	#	set_cursor_target_on_first_found_enemey()
#
#		# target_range.draw_cursor_at_position(target_node_children[0].position)
#
#	#elif item_arg.target_actor_type == 3: # Enemeies - TODO: add enum or consts to use instead of raw numbers
#	#	print("Both", Singleton_Game_GlobalBattleVariables.enemies_wrapper_node)
#	#	target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
#	#	target_node_children += Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
#	#	set_cursor_target_on_first_found_enemey()	
#	#emit_signal("signal_completed_item_use_action")
#	# return
#
