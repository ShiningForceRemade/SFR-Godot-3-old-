extends Node2D

var is_battle_finished: bool = false
var turn_number: int = 0

signal signal_land_effect_under_tile(land_effect)
signal signal_active_character_or_enemey(name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp)

signal signal_hide_land_effect_and_active_actor_info
signal signal_show_land_effect_and_active_actor_info

signal signal_show_character_action_menu
# signal signal_hide_character_action_menu

onready var tilemap = get_parent().get_node("TilesInformationGroup/TileMapTerrianEffectInformation")
# onready var mc = get_parent().get_node("Characters/MaxCharacterRoot")
# onready var mc = get_parent().get_node("Characters/PlayerCharacterRoot")
onready var mc = get_parent().get_node("Characters/MaxRoot")

onready var enemies = get_parent().get_node("Enemies")
onready var characters = get_parent().get_node("Characters")

onready var cursor_root = get_parent().get_node("CursorRoot")

const tile_size: int = 24 # 24 by 24
const half_tile_size: int = 12 # tile_size / 2 = 12 x 12

var turn_order_array = []

enum e_grid_movement_subsection {
	CENTER,
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
}

var camera 


func _ready():
	# print(tilemap)
	
	yield(get_parent().get_parent(), "ready")
	
	# get_parent().get_parent().get_parent().connect_battle_logic_to_self()
	
	# yield(get_tree().root, "ready")
	
	camera = get_parent().get_node("Camera2D")
	
	Singleton_Game_GlobalBattleVariables.character_nodes = characters
	Singleton_Game_GlobalBattleVariables.enemey_nodes = enemies
	
	Singleton_Game_GlobalBattleVariables.field_logic_node = self
	
	# setup data for battle and turns
	fill_turn_order_array_with_all_actors()
	# start battle and turns
	generate_and_launch_new_turn_order()
	
	print("\n\n\nTurn " + str(turn_number) + " Completed\n\n\n")
	turn_number += 1
	pass # Replace with function body.

# func _input(event):
# 	pass
	
	# TODO create Singleton Event system
	# its only purpose for now will be to propagate swap graphics to all subscribed nodes
	# with the string of the graphics set to swap too
	# each node can then internally track tile and sprite swapping
	# much better than the current catch input process at the root node of the currently active scene
	
	# TODO: ask community which software they use
	# best option for map creation might be using tiled with layers
	# exporting the different layers as images and hot swapping them
	# this way original can be mainted along with all sorts of other graphics remakes
	# as long as they follow the original structure
	#
	# For completely custom maps the limitation above won't exist they can simply
	# create and export whatever they want and graphics selection can be disabled
	# good for custom maps and custom ""mods"" build on top
	
	#if event.is_action_released("ui_home"):
	#	print("Set different tile map")
	#	print(get_parent().get_node("TileMap").tile_set)
	#	print(get_parent().get_node("TileMap").tile_set.resource_name)
	#	print(get_parent().get_node("TileMap").tile_set.resource_path)
		
	#get_parent().get_node("TileMap").tile_set.resource_path = "res://Assets/SF1_Reworked_IvanCal/Tilesets/0.png"
	# get_parent().get_node("TileMap").tile_set.
	# print(event)
	#if event.is_action_pressed("ui_accept"):
		# get_char_tile_position()
		

func generate_and_launch_new_turn_order():
	generate_actor_order_for_current_turn()
	
	emit_signal("signal_hide_land_effect_and_active_actor_info")
	var t = Timer.new()
	t.set_wait_time(0.75)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	
	var previous_actor_pos
	if Singleton_Game_GlobalBattleVariables.currently_active_character != null:
		print("Cur Active Char pos - ",  Singleton_Game_GlobalBattleVariables.currently_active_character.global_position)
		previous_actor_pos = Singleton_Game_GlobalBattleVariables.currently_active_character.global_position
	else:
		print("MC pos - ",  mc.global_position)
		previous_actor_pos = mc.global_position # Vector2(205, 420)
	
	# print(turn_order_array)
	
	# var order_idx = 0
	
	for a in turn_order_array:
		print("\n", a)
		
		astar_node.clear()
					
		if a.alive == false:
			print("Dead Shouldn't be in tree")
			print(Singleton_Game_GlobalBattleVariables.character_nodes.get_children())
			continue
				
		# print("PREVIOUS ACTOR POS - ", previous_actor_pos, " ", a.node.position)
		
		emit_signal("signal_hide_land_effect_and_active_actor_info")
		
		if a.type == "enemey" && Singleton_Game_GlobalBattleVariables.control_enemies == false:
			# continue
			
			print("Enemy Turn Start")
			
			# camera.smooth_move_to_new_position(a.node.get_node("EnemeyRoot/KinematicBody2D"))
			
			cursor_move_to_next_actor(a.node, previous_actor_pos)
			yield(camera, "signal_camera_move_complete")
			cursor_root.hide()
			
			# mc.connect("signal_character_moved", self, "get_tile_info_under_character")
			
			print(a.node)
			mc = a.node
			mc.z_index = 1
			
			Singleton_Game_GlobalBattleVariables.currently_active_character = a.node
			
			active_character_or_enemey_display_info()
			emit_signal("signal_show_land_effect_and_active_actor_info")
			Singleton_Game_GlobalBattleVariables.battle_base.force_show_land_effect()
			
			# Singleton_Game_GlobalBattleVariables.battle_base.s_show_land_effect()
			show_movement_tiles()
			
			generate_enemey_movement_array_representation()
			draw_movement_tiles_from_movement_array()
			
			$AnimationPlayer.play("RandomTileFlashing")
			
			yield(get_tree().create_timer(0.3), "timeout")
			
			a.node.play_turn()
			yield(a.node, "signal_completed_turn")
			
			mc.z_index = 0
			print("Enemy Turn End")
			
			print(a.node.global_position)
			previous_actor_pos = a.node.global_position
			hide_movement_tiles()
			
#			var t = Timer.new()
#			t.set_wait_time(0.75)
#			t.set_one_shot(true)
#			self.add_child(t)
#			t.start()
#			yield(t, "timeout")
		elif a.type == "character" || Singleton_Game_GlobalBattleVariables.control_enemies:
			# continue
			print("Character Turn Start")
			
			# check if actor is defeated
			
			# NOTE: TODO: BUG: more than likely signal for turn complete firing too quickly
			# triggers multiple turn ends forcing wiat to test following character moves for note
			# when adding the action menu that would prevent is_action_just_pressed enter from being immediately called
			# when would elimate the need for this as well
			# if the above doesnt work cause of fall through a triggers menuy menu triggers stay action
			# add a singleton when triggered set bool to triggered when released un set and check for it
			
			
			cursor_move_to_next_actor(a.node, previous_actor_pos)
			yield(camera, "signal_camera_move_complete")
			cursor_root.hide()
			
			mc = a.node
			
			
			Singleton_Game_GlobalBattleVariables.set_currently_active_character(a.node)
			a.node.play_turn()
			# mc = a.node
			#camera.smooth_move_to_new_position(a.node.get_kinematic_body())

			cursor_root.hide()
			# camera.smooth_move_to_new_position(a.node.get_kinematic_body())
			
			# camera.playerNode = a.node.get_kinematic_body()
			# camera.smooth_move_to_new_position(a.node.get_kinematic_body())
			
			active_character_or_enemey_display_info()
			emit_signal("signal_show_land_effect_and_active_actor_info")
			Singleton_Game_GlobalBattleVariables.battle_base.force_show_land_effect()
			
			mc.connect("signal_character_moved", self, "get_tile_info_under_character")
			mc.connect("signal_show_character_action_menu", self, "s_show_character_action_menu")
			mc.connect("signal_switch_focus_to_cursor", self, "s_switch_focus_to_cursor")
			
			show_movement_tiles()
			
			if a.type == "enemey":
				generate_enemey_movement_array_representation()
			else:
				generate_movement_array_representation()
			
			draw_movement_tiles_from_movement_array()
			
			$AnimationPlayer.play("RandomTileFlashing")
			# play_turn will yield control until the player or enemy finishes its turn
			
			mc.z_index = 1
			
			yield(Singleton_Game_GlobalBattleVariables.self_node(), "signal_completed_turn")
			
			# yield(a.node, "signal_completed_turn_z")
			hide_movement_tiles()
			print("Character Turn End")
			
			previous_actor_pos = a.node.global_position
			mc.z_index = 0
			
			mc.disconnect("signal_character_moved", self, "get_tile_info_under_character")
			mc.disconnect("signal_show_character_action_menu", self, "s_show_character_action_menu")
			mc.disconnect("signal_switch_focus_to_cursor", self, "s_switch_focus_to_cursor")
			
			show_movement_tiles()
			
			yield(get_tree().create_timer(0.25), "timeout")
			Singleton_Game_GlobalBattleVariables.currently_selected_actor = null
			
		if previous_actor_pos == Vector2.ZERO:
			previous_actor_pos = a.node.global_position
			
		for actor in turn_order_array:
			# if actor.node == null:
			if actor.alive:
				if actor.node.get_actor_root_node_internal().HP_Current == 0:
					actor.node.get_actor_root_node_internal().check_if_defeated()
					yield(actor.node.get_actor_root_node_internal(), "signal_check_defeat_done")
					# yield(actor.node.get_actor_root_node_internal(), "signal_check_defeat_done")
					print("TODO Clean up logic and animation")
					actor.node.queue_free()
					actor.alive = false;
					
					if actor.name == "MaxRoot":
						yield(get_tree().create_timer(0.25), "timeout")
						print_defeat_max_was_killed()
					
					if actor.name == "RuneKnightRoot":
						yield(get_tree().create_timer(0.25), "timeout")
						print_victory_defeated_rune_knight()
						
					continue
				
			pass
		
		# if not find_actor_by_node_name("MaxRoot", characters):
		# 	print_defeat_max_was_killed()
		
		# if not find_actor_by_node_name("RuneKnightRoot", enemies):
		#	print_victory_defeated_rune_knight()
			
	
	print("\n\n\nTurn " + str(turn_number) + " Completed\n\n\n")
	turn_number += 1
	Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number = turn_number
	generate_and_launch_new_turn_order()

func find_actor_by_node_name(node_namr_arg: String, actor_wrapper_node_to_check) -> bool:
	var found = false
	for actor in actor_wrapper_node_to_check.get_children():
		if actor.name == node_namr_arg:
			found = true
			break
	
	return found

func print_defeat_max_was_killed() -> void:
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.show()
	
	Singleton_Game_AudioManager.play_music(Singleton_Dev_Internal.base_path + "Assets/SF1/SoundBank/Max Died.mp3")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.play_message(
		"Max was defeated, the shining force loses the battle to Runefaust. Restart the app to try again."
		)
	# yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")


func print_victory_defeated_rune_knight() -> void:
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.show()
	
	Singleton_Game_AudioManager.play_music(Singleton_Dev_Internal.base_path + "Assets/SF1/SoundBank/Jingle - Comrades 1 (Happily).mp3")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.play_message(
		"You've defeated the forces of Runefaust. Restart the game to play again (try to break it and find bugs!)"
		)
	# yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")


func s_switch_focus_to_cursor():
	
	# print("Cursor Active - ", cursor_root.position, " ",  Singleton_Game_GlobalBattleVariables.currently_active_character.position)
	
	# cursor_root.position = Singleton_Game_GlobalBattleVariables.currently_active_character.position
	
	cursor_root.set_active()

func cursor_move_to_next_actor(a_node, previous_actor_pos):
	cursor_root.show()
	
	print("Cursor Pos - ", cursor_root.position, " ", previous_actor_pos)
	
	cursor_root.position = previous_actor_pos
	
	var distance = a_node.global_position.distance_to(cursor_root.position)
	#var distance = sqrt((a.node.position.x - cursor_root.position.x) * 2 + (a.node.position.y - cursor_root.position.y) * 2)
	
	# TODO: create different movement speed choices
	# also provide a fixed time choice without the distance * speed calc
	# var tween_time = distance * 0.00325
	var tween_time = distance * 0.002
	if tween_time < 0:
		tween_time = 0.1
				
	cursor_root.move_to_new_pos_battle_scene(cursor_root.position, a_node.global_position, tween_time)
	
	print("Camera POS - ", camera.position, " ",  a_node.global_position)
	
	camera.smooth_move_to_new_position(a_node, tween_time)
	


func s_show_character_action_menu():
	print("Show Menu")
	emit_signal("signal_show_character_action_menu")

func active_character_or_enemey_display_info():
	#emit_signal("signal_active_character_or_enemey", "name_arg", class_arg, level, current_hp, total_hp, current_mp, total_mp)
	print("Character Or Enemey Info before signal \n")
	# yield(get_tree().root, "ready")
	emit_signal("signal_active_character_or_enemey", 
	mc.cget_actor_name(), # "Max",
	mc.cget_class(), # "SWDM"
	mc.cget_level(),
	mc.cget_hp_current(),
	mc.cget_hp_total(),
	mc.cget_mp_current(),
	mc.cget_mp_total())
	print("Character Or Enemey Info after signal\n")

func get_char_tile_position() -> Vector2:
	var new_pos = mc.get_character_current_pos()
	var mc_real_pos: Vector2 = Vector2.ZERO
	mc_real_pos.x = mc.position.x + new_pos.x
	mc_real_pos.y = mc.position.y + new_pos.y
	return tilemap.world_to_map(mc_real_pos)
	
	# print("Tilemap Idxs - ", tilemap.world_to_map(mc_real_pos))
	# print(tilemap.get_cellv(tilemap.world_to_map(mc_real_pos)))

func get_tile_info_under_character(new_pos: Vector2):
	var tile_id = tilemap.get_cellv(tilemap.world_to_map(new_pos))
	if tile_id == -1:
		emit_signal("signal_land_effect_under_tile", "Bug: No Info Report")
		return
	
	var tile_name = tilemap.tile_set.tile_get_name(tile_id)
	if "30" in tile_name:
		emit_signal("signal_land_effect_under_tile", 30)
	elif "15" in tile_name:
		emit_signal("signal_land_effect_under_tile", 15)
	elif "0" in tile_name:
		emit_signal("signal_land_effect_under_tile", 0)
	else:
		# print("Bug: No Info Report")
		emit_signal("signal_land_effect_under_tile", "Bug: No Info Report")


func generate_movement_array_representation():
	print("\n\n\nGenereate Start")
	var actor_cur_pos = mc.global_position
	var vpos: Vector2 = get_char_tile_position()
	var movement = mc.get_character_movement()
	# Singleton_Game_GlobalBattleVariables.active_actor_movement_array = []
	# var xpos_character_center_tile = vpos.x * tile_size
	
	var point_array = [] # For A* path finding
	
	var move_array = []
	var total_move_array_size = (movement * 2) + 1
	for i in range(total_move_array_size):
		move_array.append([])
		move_array[i].resize(total_move_array_size)
	
	# var mid_point = movement - 1
	
	# print(vpos)
	# TOP LEFT QUADRANT
	for row in range(1, movement):
		for col in range(movement):
			if col <= movement - row - 1:
				continue
			
			# print("i and j - ", i, " asd ", j, " tile - ", (vpos.x - movement) + i, " asd ", (vpos.y - movement) + j)
			if new_check_tile(Vector2((vpos.x - movement) + col, (vpos.y - movement) + row)):
				# move_array[row][col] = 1 
				
				# valid move tile TODO: probably should create a distinction for valid tile and character (ally) under tile
				
				move_array[row][col] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2((vpos.x - movement) + col, (vpos.y - movement) + row))
				}
				
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x - ((movement - col) * tile_size),
				actor_cur_pos.y - ((movement - row) * tile_size))
			
				var res = check_if_character_or_enemey_is_on_tile(check_pos)
				if res != null:
					move_array[row][col].on_tile = 2 # enemey
				else:
					point_array.append(Vector2((vpos.x - movement) + col, (vpos.y - movement) + row))
					# print("VPOS - ", (vpos.x - movement) + col, " ", (vpos.y - movement) + row)
	
	# TOP RIGHT QUADRANT
	for row in range(1, movement):
		for col in range(movement):
			if col >= row:
				continue
			
			# print("i and j - ", i, " asd ", j, " tile - ", (vpos.x - movement) + i, " asd ", (vpos.y - movement) + j)
			if new_check_tile(Vector2(vpos.x + col + 1, (vpos.y - movement) + row)):
				# move_array[row][col + movement + 1] = 1
				move_array[row][col + movement + 1] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2(vpos.x + col + 1, (vpos.y - movement) + row))
				}
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x + ((col + 1) * tile_size),
				actor_cur_pos.y - ((movement - row) * tile_size))
			
				var res = check_if_character_or_enemey_is_on_tile(check_pos)
				if res != null:
					move_array[row][col + movement + 1].on_tile = 2 # enemey
				else:
					point_array.append(Vector2(vpos.x + col + 1, (vpos.y - movement) + row))
					# print("VPOS - ", Vector2(vpos.x + col + 1, (vpos.y - movement) + row))
	
	# BOTTOM LEFT QUADRANT
	for row in range(movement - 1):
		for col in range(1, movement):
			if col <= row:
				continue
			
			# print("i and j - ", row + movement + 1, " ", col + movement + 1)
			# print("x and y - ", col, " ", vpos.y + row + 1)
			if new_check_tile(Vector2((vpos.x - movement) + col, vpos.y + row + 1)):
				# move_array[row + movement + 1][col] = 1
				move_array[row + movement + 1][col] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2((vpos.x - movement) + col, vpos.y + row + 1))
				}
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x - ((movement - col) * tile_size),
				actor_cur_pos.y + ((row + 1) * tile_size))
			
				var res = check_if_character_or_enemey_is_on_tile(check_pos)
				if res != null:
					move_array[row + movement + 1][col].on_tile = 2 # enemey
				else:
					point_array.append(Vector2((vpos.x - movement) + col, vpos.y + row + 1))
					# print("VPOS - ", Vector2((vpos.x - movement) + col, vpos.y + row + 1))
	
	
	# BOTTOM RIGHT QUADRANT
	for row in range(movement - 1):
		for col in range(movement - 1):
			# if row == 0 and col == 
			if col >= movement - row - 1:
				continue
			
			# print("i and j - ", row + movement + 1, " ", col + movement + 1)
			# print("x and y - ", vpos.x + col + 1, " ", vpos.y + row + 1)
			if new_check_tile(Vector2(vpos.x + col + 1, vpos.y + row + 1)):
				# move_array[row + movement + 1][col + movement + 1] = 1
				move_array[row + movement + 1][col + movement + 1] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2(vpos.x + col + 1, vpos.y + row + 1))
				}
				
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x + ((col + 1) * tile_size),
				actor_cur_pos.y + ((row + 1) * tile_size))
			
				var res = check_if_character_or_enemey_is_on_tile(check_pos)
				if res != null:
					move_array[row + movement + 1][col + movement + 1].on_tile = 2 # enemey
				else:
					point_array.append(Vector2(vpos.x + col + 1, vpos.y + row + 1))
					# print("VPOS - ", Vector2(vpos.x + col + 1, vpos.y + row + 1))
	
	# Straight Across Left Side
	for col in range(movement):
		if new_check_tile(Vector2((vpos.x - movement) + col, vpos.y)):
			# move_array[movement][col] = 1
			move_array[movement][col] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2((vpos.x - movement) + col, vpos.y))
			}
				
			var check_pos = Vector2(actor_cur_pos.x - ((movement - col) * tile_size),
			actor_cur_pos.y)
			
			var res = check_if_character_or_enemey_is_on_tile(check_pos)
			if res != null:
				move_array[movement][col].on_tile = 2 # enemey
			else:
				point_array.append(Vector2((vpos.x - movement) + col, vpos.y))
				# print("VPOS - ", Vector2((vpos.x - movement) + col, vpos.y))
	
	# Straight Across Right Side
	for col in range(movement):
		if new_check_tile(Vector2(vpos.x + col + 1, vpos.y)):
			# move_array[movement][col + movement + 1] = 1
			move_array[movement][col + movement + 1] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2(vpos.x + col + 1, vpos.y))
			}
			
			var check_pos = Vector2(actor_cur_pos.x + ((col + 1) * tile_size),
			actor_cur_pos.y)
			
			var res = check_if_character_or_enemey_is_on_tile(check_pos)
			if res != null:
				move_array[movement][col + movement + 1].on_tile = 2 # enemey
			else:
				point_array.append(Vector2(vpos.x + col + 1, vpos.y))
				# print("VPOS - ", Vector2(vpos.x + col + 1, vpos.y))
	
	# Straight Down Top Portion
	for row in range(movement):
		if new_check_tile(Vector2(vpos.x, vpos.y - (movement - row))):
			# move_array[row][movement] = 1
			move_array[row][movement] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2(vpos.x, vpos.y - (movement - row)))
			}
			
			var check_pos = Vector2(actor_cur_pos.x,
			actor_cur_pos.y - ((movement - row) * tile_size))
			
			var res = check_if_character_or_enemey_is_on_tile(check_pos)
			if res != null:
				move_array[row][movement].on_tile = 2 # enemey
			else:
				point_array.append(Vector2(vpos.x, vpos.y - (movement - row)))
				# print("VPOS - ", Vector2(vpos.x, vpos.y - (movement - row)))
	
	# Straight Down Bottom Portion
	for row in range(movement):
		if new_check_tile(Vector2(vpos.x, vpos.y + (row + 1))):
			# move_array[row + movement + 1][movement] = 1
			move_array[row + movement + 1][movement] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2(vpos.x, vpos.y + (row + 1)))
			}
			
			var check_pos = Vector2(actor_cur_pos.x,
			actor_cur_pos.y + ((row + 1) * tile_size))
			
			var res = check_if_character_or_enemey_is_on_tile(check_pos)
			if res != null:
				move_array[row + movement + 1][movement].on_tile = 2 # enemey
			else:
				point_array.append(Vector2(vpos.x, vpos.y + (row + 1)))
				# print("VPOS - ", Vector2(vpos.x, vpos.y + (row + 1)))
	
	# Center Self Tile
	# move_array[movement][movement] = 1
	move_array[movement][movement] = {
		"on_tile": 1,
		"terrain": get_tilename_at_pos(Vector2(vpos.x, vpos.y))
	}
			
	point_array.append(vpos)
	
	# print(vpos)
	# print(move_array)
#	print("Move Array")
#	for i in move_array:
#		print(i)
#
#	var mt = Singleton_Game_GlobalBattleVariables.currently_active_character.cget_movement_type()
#	print("Movement Type - ", mt)
	
	# if mounted  (horses / centaurs) 2.5 / for mountain terrain


	
	# 
	
	# var copy_penalty = move_array.duplicate(true)
	
	# print("\n\n\nCharacter Movement Array ") #, Singleton_Game_GlobalBattleVariables.active_actor_movement_array)

	Singleton_Game_GlobalBattleVariables.active_actor_move_array_representation = move_array

	
	
	# print(point_array)
	Singleton_Game_GlobalBattleVariables.active_actor_move_point_representation = point_array
	# generate_point_array_for_a_start()
	
	print("Genereate End\n\n\n")
	
	#astar_connect_walkable_cells()
	
	# print(Singleton_Game_GlobalBattleVariables.active_actor_move_array_representation)
#	var copy_penalty = Singleton_Game_GlobalBattleVariables.active_actor_move_array_representation.duplicate(true)
#	for i in range(copy_penalty.size()):
#		for j in range(copy_penalty[i].size()):
#			if copy_penalty[i][j] == null:
#				copy_penalty[i][j] = "________"
#			else:
#				copy_penalty[i][j] = copy_penalty[i][j].terrain.substr(0, 8)
#	copy_penalty[movement][movement] = "__SELF__"
#	for a in copy_penalty:
#		print(a)
#	print("End")
	
	move_array = apply_movement_cost_per_terrain(move_array)
	astar_connect_walkable_cells()
	var copy = move_array.duplicate(true)	
	for i in range(copy.size()):
		for j in range(copy[i].size()):
			if copy[i][j] == null:
				copy[i][j] = "_______"
			elif typeof(copy[i][j]) == TYPE_STRING:
				copy[i][j] = copy[i][j]
			else:
				copy[i][j] = copy[i][j].terrain.substr(0, 7)
	copy[movement][movement] = "__SELF_"
	for a in copy:
		print(a)
	print("End")

	return # move_array

func apply_movement_cost_per_terrain(move_array):
	var move_array_c = move_array
	var movement = mc.get_character_movement()
	print(movement)
	var movement_type = mc.cget_movement_type()
	print(movement_type)
	var sfmt = Singleton_Game_GlobalCommonVariables.sf_game_data_node.sf_movement_types
	print(sfmt[movement_type])
	
	# if mounted  (horses / centaurs) 2.5 / for mountain terrain
	# var penalty_max = ceil(movement / 2.5)
	# var penalty_max = ceil(movement / 2)
	
	var temp_penalty = 4 # penalty_max
	var terrain_penalty_float
	# center tile (self)
	# move_array_c[movement][movement]
	
	# TODO: IMPORTANT: PRIORITY: really should refactor and compress these quadrant loops
	# 8 per func x 4 functions is getting too annoying, refactor priority - don't wait for godot 4 gdscript 2
	
	# DONE - TOP LEFT QUADRANT
	for row in range(1, movement):
		for col in range(movement):
			if col <= movement - row - 1:
				continue
			
			if move_array_c[row][col] != null:
				if move_array_c[row][col].terrain != "INVALID_CELL":
					terrain_penalty_float = sfmt[movement_type][move_array_c[row][col].terrain]
					if terrain_penalty_float == 1.0:
						continue
					
					temp_penalty = int(round(movement / terrain_penalty_float))
					if ((movement - row - 1) + (movement - col - 1)) >= (temp_penalty - 1):
						move_array_c[row][col].on_tile = 3
						move_array_c[row][col].terrain = "REMOVMED"
	
	# DONE - BOTTOM RIGHT QUADRANT
	for row in range(movement - 1):
		for col in range(movement - 1):
			if col >= movement - row - 1:
				continue
			
			if move_array_c[row + movement + 1][col + movement + 1] != null:
				if move_array_c[row + movement + 1][col + movement + 1].terrain != "INVALID_CELL":
					terrain_penalty_float = sfmt[movement_type][move_array_c[row + movement + 1][col + movement + 1].terrain]
					if terrain_penalty_float == 1.0:
						continue
					
					temp_penalty = int(round(movement / terrain_penalty_float))
					if col + row >= (temp_penalty - 1):
						move_array_c[row + movement + 1][col + movement + 1].on_tile = 3
						move_array_c[row + movement + 1][col + movement + 1].terrain = "REMOVMED"
	
	# DONE test more - TOP RIGHT QUADRANT
	for row in range(1, movement):
		for col in range(movement):
			if col >= row:
				continue

			if move_array_c[row][col + movement + 1] != null:
				if move_array_c[row][col + movement + 1].terrain != "INVALID_CELL":
					terrain_penalty_float = sfmt[movement_type][move_array_c[row][col + movement + 1].terrain]
					if terrain_penalty_float == 1.0:
						continue
					
					temp_penalty = int(round(movement / terrain_penalty_float))
					if ((movement - row - 1) + col) >= (temp_penalty - 1):
						move_array_c[row][col + movement + 1].on_tile = 3
						move_array_c[row][col + movement + 1].terrain = "REMOVME"
	
	# DONE - BOTTOM LEFT QUADRANT
	for row in range(movement - 1):
		for col in range(1, movement):
			if col <= row:
				continue
			
			if move_array_c[row + movement + 1][col] != null:
				if move_array_c[row + movement + 1][col].terrain != "INVALID_CELL":
					terrain_penalty_float = sfmt[movement_type][move_array_c[row + movement + 1][col].terrain]
					if terrain_penalty_float == 1.0:
						move_array_c[row + movement + 1][col].terrain = "T-" + String((movement - col - 1) + row) + " P-" + String(temp_penalty - 1)
						continue
					
					temp_penalty = int(round(movement / terrain_penalty_float))
					if (movement - col - 1) + row >= (temp_penalty - 1):
						move_array_c[row + movement + 1][col].on_tile = 3
						move_array_c[row + movement + 1][col].terrain = "REMOVME"
	
	# DONE Straight Across Left Side
	for col in range(movement):
		if move_array_c[movement][col] != null:
			if move_array_c[movement][col].terrain != "INVALID_CELL":
				terrain_penalty_float = sfmt[movement_type][move_array_c[movement][col].terrain]
				if terrain_penalty_float == 1.0:
					continue
				temp_penalty = int(round(movement / terrain_penalty_float))
				if movement - col > (temp_penalty - 1):
					move_array_c[movement][col].on_tile = 3
					move_array_c[movement][col].terrain = "REMOVME"

	# DONE - Straight Across Right Side
	for col in range(movement):
		if move_array_c[movement][col + movement + 1] != null:
			if move_array_c[movement][col + movement + 1].terrain != "INVALID_CELL":
				terrain_penalty_float = sfmt[movement_type][move_array_c[movement][col + movement + 1].terrain]
				if terrain_penalty_float == 1.0:
					continue
				temp_penalty = int(round(movement / terrain_penalty_float))
				if col > (temp_penalty - 1):
					move_array_c[movement][col + movement + 1].on_tile = 3
					move_array_c[movement][col + movement + 1].terrain = "REMOVME"

	# DONE - Straight Down Top Portion
	for row in range(movement):
		if move_array_c[row][movement] != null:
			if move_array_c[row][movement].terrain != "INVALID_CELL":
				terrain_penalty_float = sfmt[movement_type][move_array_c[row][movement].terrain]
				if terrain_penalty_float == 1.0:
					continue
				temp_penalty = int(round(movement / terrain_penalty_float))
				if movement - row > (temp_penalty - 1):
					move_array_c[row][movement].on_tile = 3
					move_array_c[row][movement].terrain = "REMOVME"

	# DONE - Straight Down Bottom Portion
	for row in range(movement):
		if move_array_c[row + movement + 1][movement] != null:
			if move_array_c[row + movement + 1][movement].terrain != "INVALID_CELL":
				terrain_penalty_float = sfmt[movement_type][move_array_c[row + movement + 1][movement].terrain]
				if terrain_penalty_float == 1.0:
					continue
				temp_penalty = int(round(movement / terrain_penalty_float))
				print("Stra - ", row, " ", (temp_penalty - 1))
				if row >= (temp_penalty - 1):
					move_array_c[row + movement + 1][movement].on_tile = 3
					move_array_c[row + movement + 1][movement].terrain = "REMOVME"
	
	return move_array_c


func generate_point_array_for_a_start(): 
	var vpos: Vector2 = get_char_tile_position()
	var point_array = []
	
	var mvr = Singleton_Game_GlobalBattleVariables.active_actor_move_array_representation
	
	for col in range(mvr.size()):
		for row in range(mvr[0].size()):
			if mvr[row][col] == 1:
				point_array.append(vpos)
	
	print(point_array)
	
	pass



onready var astar_node = AStar.new()
var map_size

#func astar_connect_walkable_cells() -> void:
#	# astar_node = AStar.new()
#	var _point_path = []
#
#	var mpr = Singleton_Game_GlobalBattleVariables.active_actor_move_point_representation
#	var temp_point_index
#
#	var actor_movement = mc.get_character_movement()
#	map_size = Vector2(actor_movement * 2, actor_movement * 2)
#
#	for v in mpr:
#		temp_point_index = calculate_point_index(v)
#		astar_node.add_point(temp_point_index, Vector3(v.x, v.y, 0))
#
#	for point in mpr:
#		var point_index = calculate_point_index(point)
#
#		var points_relative = PoolVector2Array([
#			Vector2(point.x + 1, point.y),
#			Vector2(point.x - 1, point.y),
#			Vector2(point.x, point.y + 1),
#			Vector2(point.x, point.y - 1)])
#		for point_relative in points_relative:
#			var point_relative_index = calculate_point_index(point_relative)
#
#			if is_outside_map_bounds(point_relative):
#				continue
#			if not astar_node.has_point(point_relative_index):
#				continue
#
#			astar_node.connect_points(point_index, point_relative_index, false)
#
#	var path_start_position = Singleton_Game_GlobalBattleVariables.field_logic_node.tilemap.world_to_map(mc.position)
#
#	for p in astar_node.get_points():
#		print(p)
#
#	# Start self tile from active actor movement grid
#	var start_point_index = calculate_point_index(path_start_position)
#
#	var end_point_index
#
#	for tpv in mpr:
#		var path_end_position = Vector2(tpv.x * 24 + 13, tpv.y * 24 + 12)# Singleton_Game_GlobalBattleVariables.field_logic_node.tilemap.world_to_map(target_node_arg.position)
#
#		# Target Actor Tile Above
#		end_point_index = calculate_point_index(Vector2(path_end_position.x, path_end_position.y - 1))
#		_point_path = astar_node.get_point_path(start_point_index, end_point_index) # astar_node.get_point_path(start_point_index, end_point_index)
#		if _point_path.size() != 0:
#			print("Valid ", path_start_position, " ", path_end_position)
#
#	pass

# Rename Function
# Checks array representation paths, unreachable tiles are marked as null and not drawn as a result
func astar_connect_walkable_cells() -> void:
	# astar_node = AStar.new()
	var _point_path = []
	
	var mar = Singleton_Game_GlobalBattleVariables.active_actor_move_array_representation
	var temp_point_index
	
	var actor_movement = mc.get_character_movement()
	map_size = Vector2(actor_movement * 2 + 1, actor_movement * 2 + 1)
	
	for row in range(mar.size()):
		for col in range(mar[0].size()):
			if mar[row][col] != null && mar[row][col].on_tile == 1:
				temp_point_index = calculate_point_index(Vector2(row, col))
				astar_node.add_point(temp_point_index, Vector3(row, col, 0))
	
	for row in range(mar.size()):
		for col in range(mar[0].size()):
			if mar[row][col] != null && mar[row][col].on_tile == 1:
				var point_index = calculate_point_index(Vector2(row, col))

				var points_relative = PoolVector2Array([
					Vector2(row + 1, col),
					Vector2(row - 1, col),
					Vector2(row, col + 1),
					Vector2(row, col - 1)])
				for point_relative in points_relative:
					var point_relative_index = calculate_point_index(point_relative)

					if is_outside_map_bounds(point_relative):
						continue
					if not astar_node.has_point(point_relative_index):
						continue
			
					astar_node.connect_points(point_index, point_relative_index, false)
	
	var path_start_position = Vector2(actor_movement, actor_movement) # Singleton_Game_GlobalBattleVariables.field_logic_node.tilemap.world_to_map(mc.position)
	
	# for p in astar_node.get_points():
	#	print(p)
	
	# Start self tile from active actor movement grid
	var start_point_index = calculate_point_index(path_start_position)
	
	var end_point_index
	
	for row in range(mar.size()):
		for col in range(mar[0].size()):
			if mar[row][col] != null && mar[row][col].on_tile == 1:
				end_point_index = calculate_point_index(Vector2(row, col))
				_point_path = astar_node.get_point_path(start_point_index, end_point_index) # astar_node.get_point_path(start_point_index, end_point_index)
				if _point_path.size() != 0:
					# print("Valid - ", Vector2(row, col))
					pass
				else:
					#print("Invalid - ", Vector2(row, col))
					mar[row][col] = null
	
#	print("New Move Array")
#	for a in mar:
#		print(a)
# For debugging
#	var copy = mar.duplicate(true)
#	for i in range(copy.size()):
#		for j in range(copy[i].size()):
#			if copy[i][j] == 1:
#				copy[i][j] = "___1"
#			elif copy[i][j] == 2:
#				copy[i][j] = "ENEM"
#			elif copy[i][j] == null:
#				copy[i][j] = "____"
#	copy[actor_movement][actor_movement] = "SELF"
#	for a in copy:
#		print(a)
#	print("End")

	Singleton_Game_GlobalBattleVariables.active_actor_move_array_representation = mar
	pass

func is_outside_map_bounds(point) -> bool:
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y


func calculate_point_index(point) -> int:
	return point.x + map_size.x * point.y







func draw_movement_tiles_from_movement_array() -> void:
	var move_array = Singleton_Game_GlobalBattleVariables.active_actor_move_array_representation
	
	for n in $MovementTilesWrapperNode.get_children():
		$MovementTilesWrapperNode.remove_child(n)
		n.queue_free()
	
	var actor_cur_pos = mc.global_position
	var movement = mc.get_character_movement()
	# var mid_point = movement - 1
	
	var center_segment = Color("7de1e1e1")
	
	Singleton_Game_GlobalBattleVariables.active_actor_movement_array = []
	var total_move_array_size = (movement * 2) + 1
	for i in range(total_move_array_size):
		Singleton_Game_GlobalBattleVariables.active_actor_movement_array.append([])
		Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i].resize(total_move_array_size)
	
	
	# TOP LEFT QUADRANT
	for row in range(movement):
		for col in range(movement):
			# if col <= movement - row - 1:
			# 	continue
			
			if move_array[row][col] != null && move_array[row][col].on_tile == 1:
				
				print(
					actor_cur_pos,
					
					Vector2(actor_cur_pos.x - ((movement - col) * tile_size) - half_tile_size,
					actor_cur_pos.y - ((movement - row) * tile_size) - half_tile_size)
				)
				
				Singleton_Game_GlobalBattleVariables.active_actor_movement_array[row][col] = Vector2(actor_cur_pos.x - ((movement - col) * tile_size) - half_tile_size,
				actor_cur_pos.y - ((movement - row) * tile_size) - half_tile_size)
				
				draw_flashing_movement_square(center_segment,
				actor_cur_pos.x - ((movement - col) * tile_size) - half_tile_size,
				actor_cur_pos.y - ((movement - row) * tile_size) - half_tile_size
				)
	
	# TOP RIGHT QUADRANT
	for row in range(movement):
		for col in range(movement):
			# if col <= movement - row - 1:
			# 	continue
			
			if move_array[row][col + movement + 1] != null && move_array[row][col + movement + 1].on_tile == 1:
				Singleton_Game_GlobalBattleVariables.active_actor_movement_array[row][col + movement + 1] = Vector2(
				actor_cur_pos.x + ((col + 1) * tile_size) - half_tile_size,
				actor_cur_pos.y - ((movement - row) * tile_size) - half_tile_size
				)
				
				draw_flashing_movement_square(center_segment,
				actor_cur_pos.x + ((col + 1) * tile_size) - half_tile_size,
				actor_cur_pos.y - ((movement - row) * tile_size) - half_tile_size
				)
	
	# BOTTOM LEFT QUADRANT
	for row in range(movement):
		for col in range(movement):
			# if col <= movement - row - 1:
			# 	continue
			
			if move_array[row + movement + 1][col] != null && move_array[row + movement + 1][col].on_tile == 1:
				Singleton_Game_GlobalBattleVariables.active_actor_movement_array[row + movement + 1][col] = Vector2(
				actor_cur_pos.x - ((movement - col) * tile_size) - half_tile_size,
				actor_cur_pos.y + ((row + 1) * tile_size) - half_tile_size
				)
				
				draw_flashing_movement_square(center_segment,
				actor_cur_pos.x - ((movement - col) * tile_size) - half_tile_size,
				actor_cur_pos.y + ((row + 1) * tile_size) - half_tile_size
				)
				pass
	
	# BOTTOM RIGHT QUADRANT
	for row in range(movement):
		for col in range(movement):
			# if col <= movement - row - 1:
			# 	continue
			
			if move_array[row + movement + 1][col + movement + 1] != null && move_array[row + movement + 1][col + movement + 1].on_tile == 1:
				Singleton_Game_GlobalBattleVariables.active_actor_movement_array[row + movement + 1][col + movement + 1] = Vector2(
				actor_cur_pos.x + ((col + 1) * tile_size) - half_tile_size,
				actor_cur_pos.y + ((row + 1) * tile_size) - half_tile_size
				)
				draw_flashing_movement_square(center_segment,
				actor_cur_pos.x + ((col + 1) * tile_size) - half_tile_size,
				actor_cur_pos.y + ((row + 1) * tile_size) - half_tile_size
				)
	
	# Straight Down Top Porition
	for row in range(movement):
		if move_array[row][movement] != null && move_array[row][movement].on_tile == 1:
			Singleton_Game_GlobalBattleVariables.active_actor_movement_array[row][movement] = Vector2(
			actor_cur_pos.x - half_tile_size,
			actor_cur_pos.y - ((movement - row) * tile_size) - half_tile_size
			)
			draw_flashing_movement_square(center_segment,
			actor_cur_pos.x - half_tile_size,
			actor_cur_pos.y - ((movement - row) * tile_size) - half_tile_size
			)
	
	# Straight Down Top Porition
	for row in range(movement):
		if move_array[row + movement + 1][movement] != null && move_array[row + movement + 1][movement].on_tile == 1:
			Singleton_Game_GlobalBattleVariables.active_actor_movement_array[row + movement + 1][movement] = Vector2(
			actor_cur_pos.x - half_tile_size,
			actor_cur_pos.y + ((row + 1) * tile_size) - half_tile_size
			)
			draw_flashing_movement_square(center_segment,
			actor_cur_pos.x - half_tile_size,
			actor_cur_pos.y + ((row + 1) * tile_size) - half_tile_size
			)
	
	# Straight Across Right Porition
	for col in range(movement):
		if move_array[movement][col] != null && move_array[movement][col].on_tile == 1:
			Singleton_Game_GlobalBattleVariables.active_actor_movement_array[movement][col] = Vector2(
			actor_cur_pos.x - ((movement - col) * tile_size) - half_tile_size,
			actor_cur_pos.y - half_tile_size
			)
			draw_flashing_movement_square(center_segment,
			actor_cur_pos.x - ((movement - col) * tile_size) - half_tile_size,
			actor_cur_pos.y - half_tile_size
			)
	
	# Straight Across Right Porition
	for col in range(movement):
		if move_array[movement][col + movement + 1] != null && move_array[movement][col + movement + 1].on_tile == 1:
			Singleton_Game_GlobalBattleVariables.active_actor_movement_array[movement][col + movement + 1] = Vector2(
			actor_cur_pos.x + ((col + 1) * tile_size) - half_tile_size,
			actor_cur_pos.y - half_tile_size
			)
			draw_flashing_movement_square(center_segment,
			actor_cur_pos.x + ((col + 1) * tile_size) - half_tile_size,
			actor_cur_pos.y - half_tile_size
			)
	
	draw_flashing_movement_square(center_segment, actor_cur_pos.x - half_tile_size, actor_cur_pos.y - half_tile_size)
	Singleton_Game_GlobalBattleVariables.active_actor_movement_array[movement][movement] = Vector2(
			actor_cur_pos.x - half_tile_size, 
			actor_cur_pos.y - half_tile_size
			)
	
	return


func check_if_character_or_enemey_is_on_tile(chk_pos_arg):
	for enemey in enemies.get_children():
		# print("POS CHECK - ", enemey.position, " ", chk_pos_arg)
		if enemey.global_position == chk_pos_arg:
			return { "actor": "enemey", "move": null }
	
	return null


# TODO: check if refrenced calls are possible if they are
# compress these duplicate sets into one

func check_if_character_is_on_tile(chk_pos_arg):
	for character in characters.get_children():
		# print("POS CHECK - ", enemey.position, " ", chk_pos_arg)
		if character.global_position == chk_pos_arg:
			return { "actor": "character", "move": null }
	
	return null

func generate_enemey_movement_array_representation():
	print("\n\n\nGenereate Start")
	var actor_cur_pos = mc.global_position
	var vpos: Vector2 = get_char_tile_position()
	var movement = mc.get_character_movement()
	# Singleton_Game_GlobalBattleVariables.active_actor_movement_array = []
	# var xpos_character_center_tile = vpos.x * tile_size
	
	var point_array = [] # For A* path finding
	
	var move_array = []
	var total_move_array_size = (movement * 2) + 1
	for i in range(total_move_array_size):
		move_array.append([])
		move_array[i].resize(total_move_array_size)
	
	# var mid_point = movement - 1
	
	print(vpos)
	# TOP LEFT QUADRANT
	for row in range(1, movement):
		for col in range(movement):
			if col <= movement - row - 1:
				continue
			
			# print("i and j - ", i, " asd ", j, " tile - ", (vpos.x - movement) + i, " asd ", (vpos.y - movement) + j)
			if new_check_tile(Vector2((vpos.x - movement) + col, (vpos.y - movement) + row)):
				# move_array[row][col] = 1
				move_array[row][col] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2((vpos.x - movement) + col, (vpos.y - movement) + row))
				}
				
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x - ((movement - col) * tile_size),
				actor_cur_pos.y - ((movement - row) * tile_size))
			
				var res = check_if_character_is_on_tile(check_pos)
				if res != null:
					move_array[row][col].on_tile = 2 # enemey
				else:
					point_array.append(Vector2((vpos.x - movement) + col, (vpos.y - movement) + row))
					# print("VPOS - ", Vector2((vpos.x - movement) + col, (vpos.y - movement) + row))
	
	# TOP RIGHT QUADRANT
	for row in range(1, movement):
		for col in range(movement):
			if col >= row:
				continue
			
			# print("i and j - ", i, " asd ", j, " tile - ", (vpos.x - movement) + i, " asd ", (vpos.y - movement) + j)
			if new_check_tile(Vector2(vpos.x + col + 1, (vpos.y - movement) + row)):
				# move_array[row][col + movement + 1] = 1
				move_array[row][col + movement + 1] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2(vpos.x + col + 1, (vpos.y - movement) + row))
				}
				
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x + ((col + 1) * tile_size),
				actor_cur_pos.y - ((movement - row) * tile_size))
			
				var res = check_if_character_is_on_tile(check_pos)
				if res != null:
					move_array[row][col + movement + 1].on_tile = 2 # enemey
				else:
					point_array.append(Vector2(vpos.x + col + 1, (vpos.y - movement) + row))
					# print("VPOS - ", Vector2(vpos.x + col + 1, (vpos.y - movement) + row))
	
	# BOTTOM LEFT QUADRANT
	for row in range(movement - 1):
		for col in range(1, movement):
			if col <= row:
				continue
			
			# print("i and j - ", row + movement + 1, " ", col + movement + 1)
			# print("x and y - ", col, " ", vpos.y + row + 1)
			if new_check_tile(Vector2((vpos.x - movement) + col, vpos.y + row + 1)):
				# move_array[row + movement + 1][col] = 1
				move_array[row + movement + 1][col] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2((vpos.x - movement) + col, vpos.y + row + 1))
				}
				
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x - ((movement - col) * tile_size),
				actor_cur_pos.y + ((row + 1) * tile_size))
			
				var res = check_if_character_is_on_tile(check_pos)
				if res != null:
					move_array[row + movement + 1][col].on_tile = 2 # enemey
				else:
					point_array.append(Vector2((vpos.x - movement) + col, vpos.y + row + 1))
					# print("VPOS - ", Vector2((vpos.x - movement) + col, vpos.y + row + 1))
	
	
	# BOTTOM RIGHT QUADRANT
	for row in range(movement - 1):
		for col in range(movement - 1):
			# if row == 0 and col == 
			if col >= movement - row - 1:
				continue
			
			# print("i and j - ", row + movement + 1, " ", col + movement + 1)
			# print("x and y - ", vpos.x + col + 1, " ", vpos.y + row + 1)
			if new_check_tile(Vector2(vpos.x + col + 1, vpos.y + row + 1)):
				# move_array[row + movement + 1][col + movement + 1] = 1
				move_array[row + movement + 1][col + movement + 1] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2(vpos.x + col + 1, vpos.y + row + 1))
				}
				
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x + ((col + 1) * tile_size),
				actor_cur_pos.y + ((row + 1) * tile_size))
			
				var res = check_if_character_is_on_tile(check_pos)
				if res != null:
					move_array[row + movement + 1][col + movement + 1].on_tile = 2 # enemey
				else:
					point_array.append(Vector2(vpos.x + col + 1, vpos.y + row + 1))
					# print("VPOS - ", Vector2(vpos.x + col + 1, vpos.y + row + 1))
	
	# Straight Across Left Side
	for col in range(movement):
		if new_check_tile(Vector2((vpos.x - movement) + col, vpos.y)):
			# move_array[movement][col] = 1
			move_array[movement][col] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2((vpos.x - movement) + col, vpos.y))
			}
				
			var check_pos = Vector2(actor_cur_pos.x - ((movement - col) * tile_size),
			actor_cur_pos.y)
			
			var res = check_if_character_is_on_tile(check_pos)
			if res != null:
				move_array[movement][col].on_tile = 2 # enemey
			else:
				point_array.append(Vector2((vpos.x - movement) + col, vpos.y))
				# print("VPOS - ", Vector2((vpos.x - movement) + col, vpos.y))
	
	# Straight Across Right Side
	for col in range(movement):
		if new_check_tile(Vector2(vpos.x + col + 1, vpos.y)):
			# move_array[movement][col + movement + 1] = 1
			move_array[movement][col + movement + 1] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2(vpos.x + col + 1, vpos.y))
			}
			
			var check_pos = Vector2(actor_cur_pos.x + ((col + 1) * tile_size),
			actor_cur_pos.y)
			
			var res = check_if_character_is_on_tile(check_pos)
			if res != null:
				move_array[movement][col + movement + 1].on_tile = 2 # enemey
			else:
				point_array.append(Vector2(vpos.x + col + 1, vpos.y))
				# print("VPOS - ", Vector2(vpos.x + col + 1, vpos.y))
	
	# Straight Down Top Portion
	for row in range(movement):
		if new_check_tile(Vector2(vpos.x, vpos.y - (movement - row))):
			# move_array[row][movement] = 1
			move_array[row][movement] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2(vpos.x, vpos.y - (movement - row)))
			}
			
			var check_pos = Vector2(actor_cur_pos.x,
			actor_cur_pos.y - ((movement - row) * tile_size))
			
			var res = check_if_character_is_on_tile(check_pos)
			if res != null:
				move_array[row][movement].on_tile = 2 # enemey
			else:
				point_array.append(Vector2(vpos.x, vpos.y - (movement - row)))
				# print("VPOS - ", Vector2(vpos.x, vpos.y - (movement - row)))
	
	# Straight Down Bottom Portion
	for row in range(movement):
		if new_check_tile(Vector2(vpos.x, vpos.y + (row + 1))):
			# move_array[row + movement + 1][movement] = 1
			move_array[row + movement + 1][movement] = {
					"on_tile": 1,
					"terrain": get_tilename_at_pos(Vector2(vpos.x, vpos.y + (row + 1)))
			}
			
			var check_pos = Vector2(actor_cur_pos.x,
			actor_cur_pos.y + ((row + 1) * tile_size))
			
			var res = check_if_character_is_on_tile(check_pos)
			if res != null:
				move_array[row + movement + 1][movement].on_tile = 2 # enemey
			else:
				point_array.append(Vector2(vpos.x, vpos.y + (row + 1)))
				# print("VPOS - ", Vector2(vpos.x, vpos.y + (row + 1)))
	
	# Center Self Tile
	# move_array[movement][movement] = 1
	move_array[movement][movement] = {
		"on_tile": 1,
		"terrain": get_tilename_at_pos(Vector2(vpos.x, vpos.y))
	}
	
	point_array.append(vpos)
	
	# print(vpos)
	# print(move_array)
	# print("Move Array")
	#for i in move_array:
	#	print(i)
	
	# print("\n\n\nCharacter Movement Array ") #, Singleton_Game_GlobalBattleVariables.active_actor_movement_array)
#	var copy = move_array.duplicate(true)
	Singleton_Game_GlobalBattleVariables.active_actor_move_array_representation = move_array
# For debugging	
#	for i in range(copy.size()):
#		for j in range(copy[i].size()):
#			if copy[i][j] == 1:
#				copy[i][j] = "___1"
#			elif copy[i][j] == 2:
#				copy[i][j] = "ENEM"
#			elif copy[i][j] == null:
#				copy[i][j] = "____"
#	copy[movement][movement] = "SELF"
#	for a in copy:
#		print(a)
#	print("End")
	
	# print(point_array)
	Singleton_Game_GlobalBattleVariables.active_actor_move_point_representation = point_array
	
	print("Genereate End\n\n\n")
	
	astar_connect_walkable_cells()
	
	return # move_array

func get_tilename_at_pos(vpos: Vector2) -> String:
	var current_tile_pos = tilemap.get_cellv(vpos)
	
	# print(current_tile_pos)
	if current_tile_pos != tilemap.INVALID_CELL:
		# Valid tile - Tile name
		var tn = tilemap.tile_set.tile_get_name(current_tile_pos)
		
		return terrain_type_from_tile_name(tn)
	
	return "INVALID_CELL"

func terrain_type_from_tile_name(tile_name: String) -> String:
	if "Mountain" in tile_name:
		return "MOUNTAIN"
	elif "Forest" in tile_name:
		return "FOREST"
	elif "Ground" in tile_name:
		return "GROUND"
	elif "Path" in tile_name:
		return "PATH_AND_BRIDGE"
	
	return "INVALID_CELL"

func new_check_tile(vpos: Vector2) -> bool:
	var current_tile_pos = tilemap.get_cellv(vpos)
	
	var mt = Singleton_Game_GlobalBattleVariables.currently_active_character.cget_movement_type()
	# print("Movement Type - ", mt)
	
	# print(current_tile_pos)
	if current_tile_pos != tilemap.INVALID_CELL:
		var tile_name = tilemap.tile_set.tile_get_name(current_tile_pos)
		if mt == 5:
			return movement_type_tile_check_flying(tile_name)
		
		# TODO: cleanup later disgusting
		
		# print("tile_name: ", tile_name, " tile_pos - ", vpos)
		if tile_name == "Ground30":
			return true
		elif tile_name == "Ground15":
			return true
		elif tile_name == "Ground0":
			return true	
		elif tile_name == "Float0":
			return false
		elif tile_name == "Float15":
			return false
		elif tile_name == "Float30":
			return false
		elif tile_name == "Forest0":
			return true
		elif tile_name == "Forest15":
			return true
		elif tile_name == "Forest30":
			return true
		elif tile_name == "PathAndBridges0":
			return true
		elif tile_name == "PathAndBridges15":
			return true
		elif tile_name == "PathAndBridges30":
			return true
		elif tile_name == "Mountain0":
			return true
		elif tile_name == "Mountain15":
			return true
		elif tile_name == "Mountain30":
			return true
			
		return false
	else:
		# print("invalid - no tile at position")
		return false

## TODO: IMPORTANT: REFACTOR: 
## when godot 4 comes out and you can assign functions to vars move to assigning the 
## movement check functions to the start of the move array representation
#
# export(int, "Standard", "Mounted", "Aquatic", "Forest", "Mechanical", "Flying", "Hovering") var movement_type: int = 0 # "Standard"

func movement_type_tile_check_flying(_tile_name: String) -> bool:
	return true


func draw_flashing_movement_square(acolor: Color, xpos: int, ypos: int, node_arg = null) -> void:
	var cr = ColorRect.new()
	cr.color = acolor
	cr.rect_size.x = 24
	cr.rect_size.y = 24

	cr.rect_position.x = xpos
	cr.rect_position.y = ypos

	#print(cr.rect_position)
	
	# TODO: CLEAN: node_arg using to test having movement and use tiles on different layers to avoid redrawing
	# just going to hide and show as needed with a fresh clean when new action or character turn for the respective layer
	if node_arg == null:
		$MovementTilesWrapperNode.add_child(cr)
	else:
		node_arg.add_child(cr)

# Turn Order Queue Start

func fill_turn_order_array_with_all_actors():
	print("Turn Queue\n")
	
	turn_order_array = []
	
	# 1. Get all Enemies and Characters in the battle
	#print("Enemies - ", enemies)
	var enemies_c = enemies.get_children()
	for enemey in enemies_c:
		#print(enemey.get_name(), " - ",  enemey.cget_agility())
		turn_order_array.append({"name": enemey.get_name(), "type": "enemey", "speed": enemey.cget_agility(), "node": enemey, "alive": true})
		
	#print("\nCharacters - ",characters)
	var characters_c = characters.get_children()
	for character in characters_c:
		#print(character.get_name(), " - ",  character.cget_agility())
		turn_order_array.append({"name": character.get_name(), "type": "character", "speed": character.cget_agility(), "node": character, "alive": true})
	
	#print(turn_order_array)

var rng = RandomNumberGenerator.new()
func generate_actor_order_for_current_turn():
	#print("Generate Actor Order for Turn\n", turn_order_array)
	
	var ordered_turn_array = turn_order_array
		
	rng.randomize()
	ordered_turn_array.sort_custom(self, "sort_actors_by_agility")
	# print("\nOrdered Array\n")
	# for n in ordered_turn_array:
	#	print(n)
	# print("\n")
	
	turn_order_array = ordered_turn_array

func sort_actors_by_agility(a, b) -> bool:
	
	# TODO: remove the ag_a b add outisde of the sort to fix
	# the unguarded linear sort error
	var ag_a = rng.randi_range(-1, 1)
	var ag_b = rng.randi_range(-1, 1)
	
	return (a.speed + ag_a) > (b.speed + ag_b)


# Turn Order Queue End


# Field Logic Tiles layer helper functions
func hide_movement_tiles() -> void:
	$MovementTilesWrapperNode.hide()

func show_movement_tiles() -> void:
	$MovementTilesWrapperNode.show()

func hide_use_target_tiles() -> void:
	$UseTargetTilesWrapperNode.hide()

func show_use_target_tiles() -> void:
	$UseTargetTilesWrapperNode.show()
