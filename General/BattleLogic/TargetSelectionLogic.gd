extends Node

var is_target_selection_active: bool = false

@onready var target_selection_wrapper: Node2D = $TargetSelectionWrapper
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var actor_root
var target_range_array_representation

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

var allies
var targetables 
func set_attack_target_selection() -> void:
	get_actor_root()
	
	if actor_root.actor_type == "character":
		allies = "character"
		targetables = "enemey"
	elif actor_root.actor_type == "enemey":
		allies = "enemey"
		targetables = "character"
	
	# TODO: move these normal_attack strings to an enum or something in the global common vars
	# cleanup later
	Singleton_CommonVariables.battle__target_selection_type = "normal_attack"
	
	
	var inventory = actor_root.get_inventory()
	for i in range(inventory.size()):
		print(inventory[i])
		
		var item_res = load(inventory[i].resource)
		
		if item_res.item_type == "WEAPON":
			if inventory[i].is_equipped == true:
				print("get use range and target selector type")
			
				draw_use_range_from_script(item_res.item_use_range_path)
				attempt_to_find_first_target_or_display_warning(load(item_res.item_use_target_path).new())
			
				return
	
	# TODO: should make it possible that characters and enemies can have different 
	# default use targets ranges and selectors
	
	draw_use_range_from_script("res://General/UseAndTargetRangeResources/UseRangeResources/UseRange_1.gd")
	attempt_to_find_first_target_or_display_warning(load("res://General/UseAndTargetRangeResources/TargetRangeResources/TargetRange_1.gd").new())


func is_actor_type_targetable(actor_type_to_check: String) -> bool:
	# print(Singleton_CommonVariables.battle__target_actor_types, " ", target_type, " ", actor_type_to_check, " ", actor_root.actor_type)
	
	if Singleton_CommonVariables.battle__target_actor_types == "Allies":
		if allies == actor_type_to_check:
			return true
	elif Singleton_CommonVariables.battle__target_actor_types == "Opposing":
		if targetables == actor_type_to_check: 
			return true
	if Singleton_CommonVariables.battle__target_actor_types == "Self":
		if allies == actor_type_to_check:
			return true
	
	return false


func attempt_to_find_first_target_or_display_warning(target_range_arg) -> void:
	if attempt_to_find_first_target(target_range_arg):
		is_target_selection_active = true
	else:
		print("TODO: make ui Warning no target appear")
		
		await get_tree().create_timer(0.3).timeout
		
		cancel_target_selection()


func draw_use_range_from_script(script_path: String) -> void:
	var use_range_script = load(script_path).new()
	use_range_script.draw_use_range()
	hide_movement_tiles()
	target_selection_wrapper.show()
	animation_player.play("TilesFlashing")

func draw_use_range_from_script_object(script_obj) -> void:
	var use_range_script = script_obj
	use_range_script.draw_use_range()
	hide_movement_tiles()
	target_selection_wrapper.show()
	animation_player.play("TilesFlashing")


func attempt_to_find_first_target(target_range_obj: CN_SF_TargetRange = null) -> bool:
	print(actor_root.actor_type) # character # enemey
	
	for i in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size()):
		for j in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size()):
			print(Singleton_CommonVariables.battle__target_use_range_array_representation[i][j])
			
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j] != null && Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile != "empty":
				print("First none empty tile target")
				
				if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node == null:
					continue
				
				if !is_actor_type_targetable(Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile):
					continue
				
				Singleton_CommonVariables.battle__target_selection_actor = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node
				print(Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node)
				# show cursor at first target
				if target_range_obj == null:
					target_range_array_representation = [1]
					Singleton_CommonVariables.battle__cursor_node.position = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position
					Singleton_CommonVariables.battle__cursor_node.show()
				else:
					target_range_array_representation = target_range_obj.array_representation()
					target_range_obj.draw_cursor_at_position(
						Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position
					)
				
				return true
			
	# print("No target")
	return false


func set_item_target_selection() -> void:
	pass


func cancel_target_selection() -> void:
	is_target_selection_active = false
	
	Singleton_CommonVariables.battle__target_selection_actor = null
	
	# Singleton_CommonVariables.battle_base.s_hide_target_actor_micro()
	
	if Singleton_CommonVariables.battle__target_selection_cursor != null:
		Singleton_CommonVariables.battle__target_selection_cursor.queue_free()
	
	Singleton_CommonVariables.battle__cursor_node.hide()
	
	show_movement_tiles()
	target_selection_wrapper.hide()
	
	if Singleton_CommonVariables.battle__target_selection_type == "magic":
		Singleton_CommonVariables.ui__magic_menu.show_cust() 
	else:
		Singleton_CommonVariables.ui__battle_action_menu.show_cust()
		Singleton_CommonVariables.ui__battle_action_menu.set_menu_active()


func _process(_delta: float) -> void:
	if !is_target_selection_active:
		return
	
	if Input.is_action_just_released("ui_b_key"):
		cancel_target_selection()
	
	if Input.is_action_just_released("ui_a_key"):
		if Singleton_CommonVariables.battle__target_selection_actor != null:
			pass
			# is_target_selection_active = false
			
#			print(Singleton_CommonVariables.battle__cursor_node.position)
#
#			for e in Singleton_CommonVariables.battle__enemies.get_children():
#				if e.get_child(0).global_position == Singleton_CommonVariables.battle__cursor_node.position:
#					print(e)
#
#			print(Singleton_CommonVariables.battle__selected_actor)
			
			Singleton_CommonVariables.ui__land_effect_popup_node.hide_cust()
			Singleton_CommonVariables.ui__actor_micro_info_box.hide_cust()
			
			if target_range_array_representation.size() == 1:
				# print("One target")
				get_single_actor_at_cursor(
					Singleton_CommonVariables.battle__target_selection_cursor.position
				)
			else:
				find_actors_from_center_position(
					target_range_array_representation,
					Singleton_CommonVariables.battle__target_selection_cursor.position
				)
			
			# all actors that are in the target selection
			print("target array - ", Singleton_CommonVariables.battle__target_array)
			
			Singleton_CommonVariables.battle__cursor_node.hide()
			
			Singleton_CommonVariables.battle__scene_node.show()
			Singleton_CommonVariables.battle__scene_node.activate_battle()
			
			
			# Singleton_CommonVariables.battle__target_selection_cursor = null
			
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
#			Singleton_CommonVariables.battle_base.s_show_target_actor_micro_in_battle()
#			if spell_name_selected == "Heal":
#				Singleton_CommonVariables.battle_base.s_hide_target_actor_micro_in_battle()
#
#			Singleton_CommonVariables.battle_scene_node.setup_character_and_enemey_sprites_idle()
#			get_background_foreground_and_stand_for_active_character_and_target(Singleton_CommonVariables.currently_selected_actor.position)
#
#			await Signal(Singleton_CommonVariables.battle_scene_node, "signal_battle_scene_complete")
#			Singleton_CommonVariables.camera_node.reset_camera_for_map()
#			Singleton_CommonVariables.top_level_fader_node.black_fade_anim_out()
#
#			Singleton_CommonVariables.field_logic_node.hide_use_target_tiles()
#			Singleton_CommonVariables.battle_base.s_hide_target_actor_micro_in_battle()
#			Singleton_CommonVariables.battle_base.s_show_land_effect()
#			target_range.cleanup_cursor()
#
#			Singleton_CommonVariables.currently_active_character.s_complete_turn()
#
#			Singleton_AudioManager.play_music_n(Singleton_DevToolingManager.base_path + "Assets/SF1/SoundBank/Battle 1 (Standard).mp3")
	
	
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
			
			if !is_actor_type_targetable(Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile):
				continue
			
			if found_current:
				tween_battle_cursor_position(Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position)
				Singleton_CommonVariables.battle__target_selection_actor = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node
				return
			
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position == sgpos:
				found_current = true
	
	# not found so loop back around to first top target
	for i in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size()):
		for j in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size()):
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j] == null || Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile == "empty":
				continue
			
			if !is_actor_type_targetable(Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile):
				continue
			
			tween_battle_cursor_position(Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position)
			Singleton_CommonVariables.battle__target_selection_actor = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node
			return


func target_selection_clockwise__style_naive_pass_forward() -> void:
	var sgpos = Singleton_CommonVariables.battle__target_selection_actor.get_child(0).global_position
	
	var found_current: bool = false
	# var arr_size = Singleton_CommonVariables.battle__target_use_range_array_representation.size()
	
	for i in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size() - 1, -1, -1):
		for j in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size() - 1, -1, -1):
			# print("i ", i, "j ", j)
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j] == null || Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile == "empty":
				continue
			
			if !is_actor_type_targetable(Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile):
				continue
			
			if found_current:
				tween_battle_cursor_position(Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position)
				Singleton_CommonVariables.battle__target_selection_actor = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node
				return
			
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position == sgpos:
				found_current = true
	
	# not found so loop back around to last target
	for i in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size() - 1, -1, -1):
		for j in range(Singleton_CommonVariables.battle__target_use_range_array_representation.size() - 1, -1, -1):
			# print("i ", i, "j ", j)
			if Singleton_CommonVariables.battle__target_use_range_array_representation[i][j] == null || Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile == "empty":
				continue
			
			if !is_actor_type_targetable(Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].on_tile):
				continue
			
			tween_battle_cursor_position(Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].position)
			Singleton_CommonVariables.battle__target_selection_actor = Singleton_CommonVariables.battle__target_use_range_array_representation[i][j].node
			return


func tween_battle_cursor_position(pos_arg: Vector2) -> void:
	var _t = create_tween().set_parallel(true)
	_t.tween_property(Singleton_CommonVariables.battle__cursor_node, "position", pos_arg, 0.03)
	_t.tween_property(Singleton_CommonVariables.battle__target_selection_cursor, "position", pos_arg, 0.03)
	_t.set_trans(Tween.TRANS_LINEAR)
	# _t.set_ease(Tween.EASE_IN_OUT)


#func _input(event):
#	if is_target_selection_active:

#
#



### Magic Selection


func set_magic_target_selection(spell_lvl_resource: CN_SF1_Spell_Level) -> void:
	get_actor_root()
	
	var spell__lv_use_range = spell_lvl_resource.usage_range.new() #  ).new()
	var spell_lv_target_range = spell_lvl_resource.target_range.new() # ).new()
	
#	print(spell__lv_use_range, spell_lv_target_range)
#	var x = spell__lv_use_range.get_use_range_array_representation()
#	for a in x:
#		print(a)
	
	# spell__lv_use_range.draw_use_range()
	
#	var y = spell_lv_target_range.array_representation()
#	for a in y:
#		print(a)
			
	# spell_lv_target_range.draw_cursor_and_get_targets("test")
	
	# TODO: move these normal_attack strings to an enum or something in the global common vars
	# cleanup later
	Singleton_CommonVariables.battle__target_selection_type = "magic"
	
	draw_use_range_from_script_object(spell__lv_use_range)
	
	attempt_to_find_first_target_or_display_warning(spell_lv_target_range)
	# attempt_to_find_first_target(spell_lv_target_range)
	# is_target_selection_active = true


func find_actors_from_center_position(
		tarr, # target_range_array_representation,
		position_arg# Singleton_CommonVariables.battle__target_selection_cursor.position
	) -> void:
	Singleton_CommonVariables.battle__target_array = []
	var mid_point = floori(tarr.size() / 2)
	
	for i in tarr.size():
		Singleton_CommonVariables.battle__target_array.append([])
		Singleton_CommonVariables.battle__target_array[i].resize(tarr.size())
	
	for i in Singleton_CommonVariables.battle__target_array.size():
		for j in Singleton_CommonVariables.battle__target_array.size():
			Singleton_CommonVariables.battle__target_array[i][j] = {
				"check_cell": tarr[i][j],
				"actor_type": "na",
				"position": Vector2(0, 0),
				"node": null,
				#
				"background": null,
				"foreground": null,
				"stand": null,
				#
				"land_type": null,
				"land_effect_value": null
				}
	
	# "actor_type": "na",
	Singleton_CommonVariables.battle__target_array[mid_point][mid_point].position = position_arg
	# target_array[mid_point][mid_point].node  = position_arg
	
#	 = {
#		"actor_type": "na",
#		"position": Vector2(0, 0),
#		"node": null
#	}
	
	find_actors_in_target_range(position_arg)
	
#	for x in target_array:
#		print(x)
	
	
	pass


var actors_array = []
func find_actors_in_target_range(actor_cur_pos: Vector2) -> void:
	actors_array = []
	find_all_enemey_actors_and_append_to_actors_array()
	find_all_character_actors_and_append_to_actors_array()
	
	var movement = Singleton_CommonVariables.battle__target_array.size() / 2
	
	# TOP LEFT QUADRANT
	for row in range(movement):
		for col in range(movement):
			if Singleton_CommonVariables.battle__target_array[row][col].check_cell == 1:
				check_if_actor_exists_at_position(
					row, 
					col,
					Vector2(
						actor_cur_pos.x - ((movement - col) * tile_size),
						actor_cur_pos.y - ((movement - row) * tile_size)
					)
				)
	
	# TOP RIGHT QUADRANT
	for row in range(movement):
		for col in range(movement):
			if Singleton_CommonVariables.battle__target_array[row][col + movement + 1].check_cell == 1:
				check_if_actor_exists_at_position(
					row, 
					col + movement + 1,
					Vector2(
						actor_cur_pos.x + ((col + 1) * tile_size),
						actor_cur_pos.y - ((movement - row) * tile_size)
					)
				)
	
	# BOTTOM LEFT QUADRANT
	for row in range(movement):
		for col in range(movement):
			if Singleton_CommonVariables.battle__target_array[row + movement + 1][col].check_cell == 1:
				check_if_actor_exists_at_position(
					row + movement + 1, 
					col,
					Vector2(
						actor_cur_pos.x - ((movement - col) * tile_size),
						actor_cur_pos.y + ((row + 1) * tile_size)
					)
				)
	
	# BOTTOM RIGHT QUADRANT
	for row in range(movement):
		for col in range(movement):
			if Singleton_CommonVariables.battle__target_array[row + movement + 1][col + movement + 1].check_cell == 1:
				check_if_actor_exists_at_position(
					row + movement + 1, 
					col + movement + 1,
					Vector2(
						actor_cur_pos.x + ((col + 1) * tile_size),
						actor_cur_pos.y + ((row + 1) * tile_size)
					)
				)
	
	# Straight Down Top Porition
	for row in range(movement):
		if Singleton_CommonVariables.battle__target_array[row][movement].check_cell == 1:
			check_if_actor_exists_at_position(
				row, 
				movement,
				Vector2(
					actor_cur_pos.x,
					actor_cur_pos.y - ((movement - row) * tile_size)
				)
			)
	
	# Straight Down Top Porition
	for row in range(movement):
		if Singleton_CommonVariables.battle__target_array[row + movement + 1][movement].check_cell == 1:
			check_if_actor_exists_at_position(
				row + movement + 1, 
				movement,
				Vector2(
					actor_cur_pos.x,
					actor_cur_pos.y + ((row + 1) * tile_size)
				)
			)
	
	# Straight Across Right Porition
	for col in range(movement):
		if Singleton_CommonVariables.battle__target_array[movement][col].check_cell == 1:
			check_if_actor_exists_at_position(
				movement, 
				col,
				Vector2(
					actor_cur_pos.x - ((movement - col) * tile_size),
					actor_cur_pos.y
				)
			)
	
	# Straight Across Right Porition
	for col in range(movement):
		if Singleton_CommonVariables.battle__target_array[movement][col + movement + 1].check_cell == 1:
			check_if_actor_exists_at_position(
				movement, 
				col + movement + 1,
				Vector2(
					actor_cur_pos.x + ((col + 1) * tile_size),
					actor_cur_pos.y
				)
			)
	
	# Center Self Tile
	if Singleton_CommonVariables.battle__target_array[movement][movement].check_cell == 1:
		check_if_actor_exists_at_position(
			movement, 
			movement,
			Vector2(
				actor_cur_pos.x, 
				actor_cur_pos.y
			)
		)


func check_if_actor_exists_at_position(i: int, j: int, pos_arg: Vector2) -> void:
	for a in actors_array:
		if a.position == pos_arg:
			Singleton_CommonVariables.battle__target_array[i][j].actor_type = a.type 
			Singleton_CommonVariables.battle__target_array[i][j].position = a.position
			Singleton_CommonVariables.battle__target_array[i][j].node = a.node
			# 
			Singleton_CommonVariables.battle__target_array[i][j].background = a.background
			Singleton_CommonVariables.battle__target_array[i][j].foreground = a.foreground
			Singleton_CommonVariables.battle__target_array[i][j].stand = a.stand
			# 
			Singleton_CommonVariables.battle__target_array[i][j].land_type = a.land_type
			Singleton_CommonVariables.battle__target_array[i][j].land_effect_value = a.land_effect_value
			return


func get_single_actor_at_cursor(cursor_pos: Vector2) -> void:
	Singleton_CommonVariables.battle__target_array = []
	Singleton_CommonVariables.battle__target_array.append([])
	Singleton_CommonVariables.battle__target_array[0].append({
		"check_cell": 1,  # tarr[i][j],
		"actor_type": "na",
		"position": Vector2(0, 0),
		"node": null,
		#
		"background": null,
		"foreground": null,
		"stand": null,
		#
		"land_type": null,
		"land_effect_value": null
	})
	
	actors_array = []
	find_all_enemey_actors_and_append_to_actors_array()
	find_all_character_actors_and_append_to_actors_array()
	
	check_if_actor_exists_at_position(0, 0, cursor_pos)


func find_all_enemey_actors_and_append_to_actors_array() -> void:
	var tile_land_effect_data
	var background_name
	var foreground_name
	var stand_name
	var g_pos
	
	# print("Enemey")
	for e in Singleton_CommonVariables.battle__enemies.get_children():
		g_pos = e.get_child(0).global_position
		tile_land_effect_data = get_land_effect_value_at_pos(g_pos)
		background_name = get_background_value_at_cell_at_pos(g_pos)
		foreground_name = get_foreground_value_at_cell_at_pos(g_pos)
		stand_name = get_stand_value_at_cell_at_pos(g_pos)
		
		actors_array.append({
			"type": "enemey",
			"node": e,
			"position": g_pos,
			# 
			"background": background_name,
			"foreground": foreground_name,
			"stand": stand_name,
			# 
			"land_type": tile_land_effect_data.type,
			"land_effect_value": tile_land_effect_data.value
		})

func find_all_character_actors_and_append_to_actors_array() -> void:
	var tile_land_effect_data
	var background_name
	var foreground_name
	var stand_name
	var g_pos
	
	# print("Character")
	for e in Singleton_CommonVariables.battle__characters.get_children():
		g_pos = e.get_child(0).global_position
		tile_land_effect_data = get_land_effect_value_at_pos(g_pos)
		background_name = get_background_value_at_cell_at_pos(g_pos)
		foreground_name = get_foreground_value_at_cell_at_pos(g_pos)
		stand_name = get_stand_value_at_cell_at_pos(g_pos)
		
		actors_array.append({
			"type": "character",
			"node": e,
			"position": g_pos,
			# 
			"background": background_name,
			"foreground": foreground_name,
			"stand": stand_name,
			# 
			"land_type": tile_land_effect_data.type,
			"land_effect_value": tile_land_effect_data.value
		})

func get_land_effect_value_at_pos(pos_arg: Vector2):
	var local_pos = Singleton_CommonVariables.battle__tilemap_info_group__terrain.local_to_map(pos_arg)
	var current_tile_posx = Singleton_CommonVariables.battle__tilemap_info_group__terrain.get_cell_tile_data(0, local_pos)
	
	if current_tile_posx != null:
		return {
			"type": current_tile_posx.custom_data_0,
			"value": current_tile_posx.custom_data_1
		}
	
	return null

# TODO: make TilesInformationGroup its own scene and move a lot of this logic into it directly 
# TODO: copied over in one other place remember to global replace
func get_background_value_at_cell_at_pos(pos_arg: Vector2):
	var local_pos = Singleton_CommonVariables.battle__tilemap_info_group__background.local_to_map(pos_arg)
	var current_tile_posx = Singleton_CommonVariables.battle__tilemap_info_group__background.get_cell_tile_data(0, local_pos)
	
	if current_tile_posx != null:
		return current_tile_posx.custom_data_0
	
	return null

func get_foreground_value_at_cell_at_pos(pos_arg: Vector2):
	var local_pos = Singleton_CommonVariables.battle__tilemap_info_group__foreground.local_to_map(pos_arg)
	var current_tile_posx = Singleton_CommonVariables.battle__tilemap_info_group__foreground.get_cell_tile_data(0, local_pos)
	
	if current_tile_posx != null:
		return current_tile_posx.custom_data_0
	
	return null

func get_stand_value_at_cell_at_pos(pos_arg: Vector2):
	var local_pos = Singleton_CommonVariables.battle__tilemap_info_group__stand.local_to_map(pos_arg)
	var current_tile_posx = Singleton_CommonVariables.battle__tilemap_info_group__stand.get_cell_tile_data(0, local_pos)
	
	if current_tile_posx != null:
		return current_tile_posx.custom_data_0
	
	return null



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
