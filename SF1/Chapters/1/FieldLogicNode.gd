extends Node2D

var is_battle_finished: bool = false
var turn_number: int = 0

signal signal_land_effect_under_tile(land_effect)
signal signal_active_character_or_enemey(name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp)

signal signal_hide_land_effect_and_active_actor_info
signal signal_show_land_effect_and_active_actor_info

signal signal_show_character_action_menu
# signal signal_hide_character_action_menu

onready var tilemap = get_parent().get_node("TileMapTileInformation")
# onready var mc = get_parent().get_node("Characters/MaxCharacterRoot")
# onready var mc = get_parent().get_node("Characters/PlayerCharacterRoot")
onready var mc = get_parent().get_node("Characters/MaxRoot")

onready var enemies = get_parent().get_node("Enemies")
onready var characters = get_parent().get_node("Characters")

onready var cursor_root = get_parent().get_node("CursorRoot")

const tile_size: int = 24 # 24 by 24

var turn_order_array = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum e_grid_movement_subsection {
	CENTER,
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
}

var camera 

# Called when the node enters the scene tree for the first time.
func _ready():
	# print(tilemap)
	yield(get_tree().root, "ready")
	
	camera = get_parent().get_node("Camera2D")
	
	Singleton_Game_GlobalBattleVariables.character_nodes = characters
	Singleton_Game_GlobalBattleVariables.enemey_nodes = enemies
	
	Singleton_Game_GlobalBattleVariables.field_logic_node = self
	
	# setup data for battle and turns
	fill_turn_order_array_with_all_actors()
	# start battle and turns
	generate_and_launch_new_turn_order()
	
	# turn_movement_init()
	
	print("\n\n\nTurn " + str(turn_number) + " Completed\n\n\n")
	turn_number += 1
	pass # Replace with function body.

func _input(event):
	pass
	
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
	#	draw_character_movement_area()
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
	
	var previous_actor_pos = Vector2.ZERO
	
	# print(turn_order_array)
	for a in turn_order_array:
		print("\n", a)
		
		if previous_actor_pos == Vector2.ZERO:
			previous_actor_pos = a.node.position
		
		# print("PREVIOUS ACTOR POS - ", previous_actor_pos, " ", a.node.position)
		
		emit_signal("signal_hide_land_effect_and_active_actor_info")
		
		if a.type == "enemey":
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
			
			# old
			# draw_character_movement_area()
			
			# new
			generate_enemey_movement_array_representation()
			# generate_movement_array_representation()
			draw_movement_tiles_from_movement_array()
			
			$AnimationPlayer.play("RandomTileFlashing")
			
			yield(get_tree().create_timer(0.3), "timeout")
			
			a.node.play_turn()
			yield(a.node, "signal_completed_turn")
			
			mc.z_index = 0
			print("Enemy Turn End")
			previous_actor_pos = a.node.position
			hide_movement_tiles()
			
#			var t = Timer.new()
#			t.set_wait_time(0.75)
#			t.set_one_shot(true)
#			self.add_child(t)
#			t.start()
#			yield(t, "timeout")
		else:
			# continue
			
			print("Character Turn Start")
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
			# turn_movement_init()
			
			show_movement_tiles()
			
			# new
			generate_movement_array_representation()
			draw_movement_tiles_from_movement_array()
			# old
			# draw_character_movement_area()
			
			
			$AnimationPlayer.play("RandomTileFlashing")
			# play_turn will yield control until the player or enemy finishes its turn
			
			mc.z_index = 1
			
			yield(Singleton_Game_GlobalBattleVariables.self_node(), "signal_completed_turn")
			
			# yield(a.node, "signal_completed_turn_z")
			hide_movement_tiles()
			print("Character Turn End")
			
			previous_actor_pos = a.node.position
			mc.z_index = 0
			
			mc.disconnect("signal_character_moved", self, "get_tile_info_under_character")
			mc.disconnect("signal_show_character_action_menu", self, "s_show_character_action_menu")
			mc.disconnect("signal_switch_focus_to_cursor", self, "s_switch_focus_to_cursor")
			
			show_movement_tiles()
			
			yield(get_tree().create_timer(0.5), "timeout")
			Singleton_Game_GlobalBattleVariables.currently_selected_actor = null
			
	
	print("\n\n\nTurn " + str(turn_number) + " Completed\n\n\n")
	turn_number += 1
	Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number = turn_number
	generate_and_launch_new_turn_order()

func s_switch_focus_to_cursor():
	cursor_root.set_active()

func cursor_move_to_next_actor(a_node, previous_actor_pos):
	cursor_root.show()
	cursor_root.position = previous_actor_pos
	
	var distance = a_node.position.distance_to(cursor_root.position)
	#var distance = sqrt((a.node.position.x - cursor_root.position.x) * 2 + (a.node.position.y - cursor_root.position.y) * 2)
	
	# TODO: create different movement speed choices
	# also provide a fixed time choice without the distance * speed calc
	var tween_time = distance * 0.00325
	if tween_time < 0:
		tween_time = 0.1
				
	cursor_root.move_to_new_pos_battle_scene(cursor_root.position, a_node.position, tween_time)
	camera.smooth_move_to_new_position(a_node, tween_time)
	


func s_show_character_action_menu():
	print("Show Menu")
	emit_signal("signal_show_character_action_menu")

func turn_movement_init():
	yield(get_tree().root, "ready")
	print("here connecting")
	mc.connect("signal_character_moved", self, "get_tile_info_under_character")
	
#	for cell in tilemap.get_used_cells():
#		print(cell) 
#		# tile_id  = tilemap.get_cellv(cell)
#		print(tilemap.get_cellv(cell))
#		print(tilemap.tile_set.tile_get_name(tilemap.get_cellv(cell)))
	
	#get_tile_info_under_character(Vector2.ZERO)
	draw_character_movement_area()
	# NOTE: Wait for everything to be ready otherwise signal fires before the rest of the tree is ready to catch the emit
	#yield(get_tree(), "idle_frame")
	# TODO: when turn order is created pull the active character or enemuy
	active_character_or_enemey_display_info()
	# get_tile_info_under_character(mc.get_character_current_pos())
	

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
	#print("XY pos - ", mc_real_pos)
	#print("Tilemap Idxs - ", tilemap.world_to_map(mc_real_pos))
	# print(tilemap.get_cellv(tilemap.world_to_map(mc_real_pos)))

func get_tile_info_under_character(new_pos: Vector2):
	#print("New Pos", new_pos)
	#print("Mc", mc.position)
	#print("MC Kinematic", mc.get_node("CharacterRoot/KinematicBody2D").position)
	
	# print(mc.get_character_movement())
	# print(mc.get_node("KinematicBody2D").position)
	
	#var mc_real_pos: Vector2 = Vector2.ZERO
	#mc_real_pos.x = mc.position.x + new_pos.x
	#mc_real_pos.y = mc.position.y + new_pos.y
	
	#mc_real_pos.x = new_pos.x
	#mc_real_pos.y = new_pos.y
	
	# print(tilemap.world_to_map(mc.position))
	# print(tilemap.get_cellv(tilemap.world_to_map(mc.position)))
	# print(tilemap.tile_set.tile_get_name(tilemap.get_cellv(tilemap.world_to_map(mc.position))))
	
	# print(tilemap.world_to_map(mc_real_pos))
	# print(tilemap.get_cellv(tilemap.world_to_map(mc_real_pos)))
	# print(tilemap.tile_set.tile_get_name(tilemap.get_cellv(tilemap.world_to_map(mc_real_pos))))
	var tile_id = tilemap.get_cellv(tilemap.world_to_map(new_pos))
	if tile_id == -1:
		emit_signal("signal_land_effect_under_tile", "Bug: No Info Report")
		return
	
	var tile_name = tilemap.tile_set.tile_get_name(tile_id)
	# print(tile_name)
	if "30" in tile_name:
		# print("30")
		emit_signal("signal_land_effect_under_tile", 30)
	elif "15" in tile_name:
		# print("15")
		emit_signal("signal_land_effect_under_tile", 15)
	elif "0" in tile_name:
		# print("0")
		emit_signal("signal_land_effect_under_tile", 0)
	else:
		# print("Bug: No Info Report")
		emit_signal("signal_land_effect_under_tile", "Bug: No Info Report")
		
	# print("\n")








func generate_movement_array_representation():
	print("\n\n\nGenereate Start")
	var actor_cur_pos = mc.position
	var vpos: Vector2 = get_char_tile_position()
	var movement = mc.get_character_movement()
	# Singleton_Game_GlobalBattleVariables.active_actor_movement_array = []
	# var xpos_character_center_tile = vpos.x * tile_size
	
	var move_array = []
	var total_move_array_size = (movement * 2) + 1
	for i in range(total_move_array_size):
		move_array.append([])
		move_array[i].resize(total_move_array_size)
	
	var mid_point = movement - 1
	
	print(vpos)
	# TOP LEFT QUADRANT
	for row in range(1, movement):
		for col in range(movement):
			if col <= movement - row - 1:
				continue
			
			# print("i and j - ", i, " asd ", j, " tile - ", (vpos.x - movement) + i, " asd ", (vpos.y - movement) + j)
			if new_check_tile(Vector2((vpos.x - movement) + col, (vpos.y - movement) + row)):
				move_array[row][col] = 1
			
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x - ((movement - col) * tile_size),
				actor_cur_pos.y - ((movement - row) * tile_size))
			
				var res = check_if_character_or_enemey_is_on_tile(check_pos)
				if res != null:
					move_array[row][col] = 2 # enemey
	
	# TOP RIGHT QUADRANT
	for row in range(1, movement):
		for col in range(movement):
			if col >= row:
				continue
			
			# print("i and j - ", i, " asd ", j, " tile - ", (vpos.x - movement) + i, " asd ", (vpos.y - movement) + j)
			if new_check_tile(Vector2(vpos.x + col + 1, (vpos.y - movement) + row)):
				move_array[row][col + movement + 1] = 1
			
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x + ((col + 1) * tile_size),
				actor_cur_pos.y - ((movement - row) * tile_size))
			
				var res = check_if_character_or_enemey_is_on_tile(check_pos)
				if res != null:
					move_array[row][col + movement + 1] = 2 # enemey
	
	# BOTTOM LEFT QUADRANT
	for row in range(movement - 1):
		for col in range(1, movement):
			if col <= row:
				continue
			
			# print("i and j - ", row + movement + 1, " ", col + movement + 1)
			# print("x and y - ", col, " ", vpos.y + row + 1)
			if new_check_tile(Vector2((vpos.x - movement) + col, vpos.y + row + 1)):
				move_array[row + movement + 1][col] = 1
			
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x - ((movement - col) * tile_size),
				actor_cur_pos.y + ((row + 1) * tile_size))
			
				var res = check_if_character_or_enemey_is_on_tile(check_pos)
				if res != null:
					move_array[row + movement + 1][col] = 2 # enemey
	
	
	# BOTTOM RIGHT QUADRANT
	for row in range(movement - 1):
		for col in range(movement - 1):
			# if row == 0 and col == 
			if col >= movement - row - 1:
				continue
			
			# print("i and j - ", row + movement + 1, " ", col + movement + 1)
			# print("x and y - ", vpos.x + col + 1, " ", vpos.y + row + 1)
			if new_check_tile(Vector2(vpos.x + col + 1, vpos.y + row + 1)):
				move_array[row + movement + 1][col + movement + 1] = 1
			
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x + ((col + 1) * tile_size),
				actor_cur_pos.y + ((row + 1) * tile_size))
			
				var res = check_if_character_or_enemey_is_on_tile(check_pos)
				if res != null:
					move_array[row + movement + 1][col + movement + 1] = 2 # enemey
	
	# Straight Across Left Side
	for col in range(movement):
		if new_check_tile(Vector2((vpos.x - movement) + col, vpos.y)):
			move_array[movement][col] = 1
			
			var check_pos = Vector2(actor_cur_pos.x - ((movement - col) * tile_size),
			actor_cur_pos.y)
			
			var res = check_if_character_or_enemey_is_on_tile(check_pos)
			if res != null:
				move_array[movement][col] = 2 # enemey
	
	# Straight Across Right Side
	for col in range(movement):
		if new_check_tile(Vector2(vpos.x + col + 1, vpos.y)):
			move_array[movement][col + movement + 1] = 1
			
			var check_pos = Vector2(actor_cur_pos.x + ((col + 1) * tile_size),
			actor_cur_pos.y)
			
			var res = check_if_character_or_enemey_is_on_tile(check_pos)
			if res != null:
				move_array[movement][col + movement + 1] = 2 # enemey
	
	# Straight Down Top Portion
	for row in range(movement):
		if new_check_tile(Vector2(vpos.x, vpos.y - (movement - row))):
			move_array[row][movement] = 1
			
			var check_pos = Vector2(actor_cur_pos.x,
			actor_cur_pos.y - ((movement - row) * tile_size))
			
			var res = check_if_character_or_enemey_is_on_tile(check_pos)
			if res != null:
				move_array[row][movement] = 2 # enemey
	
	# Straight Down Bottom Portion
	for row in range(movement):
		if new_check_tile(Vector2(vpos.x, vpos.y + (row + 1))):
			move_array[row + movement + 1][movement] = 1
			
			var check_pos = Vector2(actor_cur_pos.x,
			actor_cur_pos.y + ((row + 1) * tile_size))
			
			var res = check_if_character_or_enemey_is_on_tile(check_pos)
			if res != null:
				move_array[row + movement + 1][movement] = 2 # enemey
	
	# Center Self Tile
	move_array[movement][movement] = 1
	
	print(vpos)
	# print(move_array)
	print("Move Array")
	#for i in move_array:
	#	print(i)
	
	# print("\n\n\nCharacter Movement Array ") #, Singleton_Game_GlobalBattleVariables.active_actor_movement_array)
	var copy = move_array.duplicate(true)
	Singleton_Game_GlobalBattleVariables.active_actor_move_array_representation = move_array
	
	for i in range(copy.size()):
		for j in range(copy[i].size()):
			if copy[i][j] == 1:
				copy[i][j] = "___1"
			elif copy[i][j] == 2:
				copy[i][j] = "ENEM"
			elif copy[i][j] == null:
				copy[i][j] = "____"
	copy[movement][movement] = "SELF"
	for a in copy:
		print(a)
	print("End")
	
	print("Genereate End\n\n\n")
	return # move_array


func draw_movement_tiles_from_movement_array() -> void:
	var move_array = Singleton_Game_GlobalBattleVariables.active_actor_move_array_representation
	
	for n in $MovementTilesWrapperNode.get_children():
		$MovementTilesWrapperNode.remove_child(n)
		n.queue_free()
	
	var actor_cur_pos = mc.position
	var movement = mc.get_character_movement()
	var mid_point = movement - 1
	
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
			
			if move_array[row][col] == 1:
				
				Singleton_Game_GlobalBattleVariables.active_actor_movement_array[row][col] = Vector2(actor_cur_pos.x - ((movement - col) * tile_size) - (tile_size / 2),
				actor_cur_pos.y - ((movement - row) * tile_size) - (tile_size / 2))
				
				draw_flashing_movement_square(center_segment,
				actor_cur_pos.x - ((movement - col) * tile_size) - (tile_size / 2),
				actor_cur_pos.y - ((movement - row) * tile_size) - (tile_size / 2)
				)
	
	# TOP RIGHT QUADRANT
	for row in range(movement):
		for col in range(movement):
			# if col <= movement - row - 1:
			# 	continue
			
			if move_array[row][col + movement + 1] == 1:
				Singleton_Game_GlobalBattleVariables.active_actor_movement_array[row][col + movement + 1] = Vector2(
				actor_cur_pos.x + ((col + 1) * tile_size) - (tile_size / 2),
				actor_cur_pos.y - ((movement - row) * tile_size) - (tile_size / 2)
				)
				
				draw_flashing_movement_square(center_segment,
				actor_cur_pos.x + ((col + 1) * tile_size) - (tile_size / 2),
				actor_cur_pos.y - ((movement - row) * tile_size) - (tile_size / 2)
				)
	
	# BOTTOM LEFT QUADRANT
	for row in range(movement):
		for col in range(movement):
			# if col <= movement - row - 1:
			# 	continue
			
			if move_array[row + movement + 1][col] == 1:
				Singleton_Game_GlobalBattleVariables.active_actor_movement_array[row + movement + 1][col] = Vector2(
				actor_cur_pos.x - ((movement - col) * tile_size) - (tile_size / 2),
				actor_cur_pos.y + ((row + 1) * tile_size) - (tile_size / 2)
				)
				
				draw_flashing_movement_square(center_segment,
				actor_cur_pos.x - ((movement - col) * tile_size) - (tile_size / 2),
				actor_cur_pos.y + ((row + 1) * tile_size) - (tile_size / 2)
				)
				pass
	
	# BOTTOM RIGHT QUADRANT
	for row in range(movement):
		for col in range(movement):
			# if col <= movement - row - 1:
			# 	continue
			
			if move_array[row + movement + 1][col + movement + 1] == 1:
				Singleton_Game_GlobalBattleVariables.active_actor_movement_array[row + movement + 1][col + movement + 1] = Vector2(
				actor_cur_pos.x + ((col + 1) * tile_size) - (tile_size / 2),
				actor_cur_pos.y + ((row + 1) * tile_size) - (tile_size / 2)
				)
				draw_flashing_movement_square(center_segment,
				actor_cur_pos.x + ((col + 1) * tile_size) - (tile_size / 2),
				actor_cur_pos.y + ((row + 1) * tile_size) - (tile_size / 2)
				)
	
	# Straight Down Top Porition
	for row in range(movement):
		if move_array[row][movement] == 1:
			Singleton_Game_GlobalBattleVariables.active_actor_movement_array[row][movement] = Vector2(
			actor_cur_pos.x - (tile_size / 2),
			actor_cur_pos.y - ((movement - row) * tile_size) - (tile_size / 2)
			)
			draw_flashing_movement_square(center_segment,
			actor_cur_pos.x - (tile_size / 2),
			actor_cur_pos.y - ((movement - row) * tile_size) - (tile_size / 2)
			)
	
	# Straight Down Top Porition
	for row in range(movement):
		if move_array[row + movement + 1][movement] == 1:
			Singleton_Game_GlobalBattleVariables.active_actor_movement_array[row + movement + 1][movement] = Vector2(
			actor_cur_pos.x - (tile_size / 2),
			actor_cur_pos.y + ((row + 1) * tile_size) - (tile_size / 2)
			)
			draw_flashing_movement_square(center_segment,
			actor_cur_pos.x - (tile_size / 2),
			actor_cur_pos.y + ((row + 1) * tile_size) - (tile_size / 2)
			)
	
	# Straight Across Right Porition
	for col in range(movement):
		if move_array[movement][col] == 1:
			Singleton_Game_GlobalBattleVariables.active_actor_movement_array[movement][col] = Vector2(
			actor_cur_pos.x - ((movement - col) * tile_size) - (tile_size / 2),
			actor_cur_pos.y - (tile_size / 2)
			)
			draw_flashing_movement_square(center_segment,
			actor_cur_pos.x - ((movement - col) * tile_size) - (tile_size / 2),
			actor_cur_pos.y - (tile_size / 2)
			)
	
	# Straight Across Right Porition
	for col in range(movement):
		if move_array[movement][col + movement + 1] == 1:
			Singleton_Game_GlobalBattleVariables.active_actor_movement_array[movement][col + movement + 1] = Vector2(
			actor_cur_pos.x + ((col + 1) * tile_size) - (tile_size / 2),
			actor_cur_pos.y - (tile_size / 2)
			)
			draw_flashing_movement_square(center_segment,
			actor_cur_pos.x + ((col + 1) * tile_size) - (tile_size / 2),
			actor_cur_pos.y - (tile_size / 2)
			)
	
	draw_flashing_movement_square(center_segment, actor_cur_pos.x - (tile_size / 2), actor_cur_pos.y - (tile_size / 2))
	Singleton_Game_GlobalBattleVariables.active_actor_movement_array[movement][movement] = Vector2(
			actor_cur_pos.x - (tile_size / 2), 
			actor_cur_pos.y - (tile_size / 2)
			)
	
	return


func check_if_character_or_enemey_is_on_tile(chk_pos_arg):
	for enemey in enemies.get_children():
		# print("POS CHECK - ", enemey.position, " ", chk_pos_arg)
		if enemey.position == chk_pos_arg:
			return { "actor": "enemey", "move": null }
	
	return null


# TODO: check if refrenced calls are possible if they are
# compress these duplicate sets into one

func check_if_character_is_on_tile(chk_pos_arg):
	for character in characters.get_children():
		# print("POS CHECK - ", enemey.position, " ", chk_pos_arg)
		if character.position == chk_pos_arg:
			return { "actor": "character", "move": null }
	
	return null

func generate_enemey_movement_array_representation():
	print("\n\n\nGenereate Start")
	var actor_cur_pos = mc.position
	var vpos: Vector2 = get_char_tile_position()
	var movement = mc.get_character_movement()
	# Singleton_Game_GlobalBattleVariables.active_actor_movement_array = []
	# var xpos_character_center_tile = vpos.x * tile_size
	
	var move_array = []
	var total_move_array_size = (movement * 2) + 1
	for i in range(total_move_array_size):
		move_array.append([])
		move_array[i].resize(total_move_array_size)
	
	var mid_point = movement - 1
	
	print(vpos)
	# TOP LEFT QUADRANT
	for row in range(1, movement):
		for col in range(movement):
			if col <= movement - row - 1:
				continue
			
			# print("i and j - ", i, " asd ", j, " tile - ", (vpos.x - movement) + i, " asd ", (vpos.y - movement) + j)
			if new_check_tile(Vector2((vpos.x - movement) + col, (vpos.y - movement) + row)):
				move_array[row][col] = 1
			
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x - ((movement - col) * tile_size),
				actor_cur_pos.y - ((movement - row) * tile_size))
			
				var res = check_if_character_is_on_tile(check_pos)
				if res != null:
					move_array[row][col] = 2 # enemey
	
	# TOP RIGHT QUADRANT
	for row in range(1, movement):
		for col in range(movement):
			if col >= row:
				continue
			
			# print("i and j - ", i, " asd ", j, " tile - ", (vpos.x - movement) + i, " asd ", (vpos.y - movement) + j)
			if new_check_tile(Vector2(vpos.x + col + 1, (vpos.y - movement) + row)):
				move_array[row][col + movement + 1] = 1
			
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x + ((col + 1) * tile_size),
				actor_cur_pos.y - ((movement - row) * tile_size))
			
				var res = check_if_character_is_on_tile(check_pos)
				if res != null:
					move_array[row][col + movement + 1] = 2 # enemey
	
	# BOTTOM LEFT QUADRANT
	for row in range(movement - 1):
		for col in range(1, movement):
			if col <= row:
				continue
			
			# print("i and j - ", row + movement + 1, " ", col + movement + 1)
			# print("x and y - ", col, " ", vpos.y + row + 1)
			if new_check_tile(Vector2((vpos.x - movement) + col, vpos.y + row + 1)):
				move_array[row + movement + 1][col] = 1
			
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x - ((movement - col) * tile_size),
				actor_cur_pos.y + ((row + 1) * tile_size))
			
				var res = check_if_character_is_on_tile(check_pos)
				if res != null:
					move_array[row + movement + 1][col] = 2 # enemey
	
	
	# BOTTOM RIGHT QUADRANT
	for row in range(movement - 1):
		for col in range(movement - 1):
			# if row == 0 and col == 
			if col >= movement - row - 1:
				continue
			
			# print("i and j - ", row + movement + 1, " ", col + movement + 1)
			# print("x and y - ", vpos.x + col + 1, " ", vpos.y + row + 1)
			if new_check_tile(Vector2(vpos.x + col + 1, vpos.y + row + 1)):
				move_array[row + movement + 1][col + movement + 1] = 1
			
				# check if character or enemey actor is on this tile position
			
				var check_pos = Vector2(actor_cur_pos.x + ((col + 1) * tile_size),
				actor_cur_pos.y + ((row + 1) * tile_size))
			
				var res = check_if_character_is_on_tile(check_pos)
				if res != null:
					move_array[row + movement + 1][col + movement + 1] = 2 # enemey
	
	# Straight Across Left Side
	for col in range(movement):
		if new_check_tile(Vector2((vpos.x - movement) + col, vpos.y)):
			move_array[movement][col] = 1
			
			var check_pos = Vector2(actor_cur_pos.x - ((movement - col) * tile_size),
			actor_cur_pos.y)
			
			var res = check_if_character_is_on_tile(check_pos)
			if res != null:
				move_array[movement][col] = 2 # enemey
	
	# Straight Across Right Side
	for col in range(movement):
		if new_check_tile(Vector2(vpos.x + col + 1, vpos.y)):
			move_array[movement][col + movement + 1] = 1
			
			var check_pos = Vector2(actor_cur_pos.x + ((col + 1) * tile_size),
			actor_cur_pos.y)
			
			var res = check_if_character_is_on_tile(check_pos)
			if res != null:
				move_array[movement][col + movement + 1] = 2 # enemey
	
	# Straight Down Top Portion
	for row in range(movement):
		if new_check_tile(Vector2(vpos.x, vpos.y - (movement - row))):
			move_array[row][movement] = 1
			
			var check_pos = Vector2(actor_cur_pos.x,
			actor_cur_pos.y - ((movement - row) * tile_size))
			
			var res = check_if_character_is_on_tile(check_pos)
			if res != null:
				move_array[row][movement] = 2 # enemey
	
	# Straight Down Bottom Portion
	for row in range(movement):
		if new_check_tile(Vector2(vpos.x, vpos.y + (row + 1))):
			move_array[row + movement + 1][movement] = 1
			
			var check_pos = Vector2(actor_cur_pos.x,
			actor_cur_pos.y + ((row + 1) * tile_size))
			
			var res = check_if_character_is_on_tile(check_pos)
			if res != null:
				move_array[row + movement + 1][movement] = 2 # enemey
	
	# Center Self Tile
	move_array[movement][movement] = 1
	
	print(vpos)
	# print(move_array)
	print("Move Array")
	#for i in move_array:
	#	print(i)
	
	# print("\n\n\nCharacter Movement Array ") #, Singleton_Game_GlobalBattleVariables.active_actor_movement_array)
	var copy = move_array.duplicate(true)
	Singleton_Game_GlobalBattleVariables.active_actor_move_array_representation = move_array
	
	for i in range(copy.size()):
		for j in range(copy[i].size()):
			if copy[i][j] == 1:
				copy[i][j] = "___1"
			elif copy[i][j] == 2:
				copy[i][j] = "ENEM"
			elif copy[i][j] == null:
				copy[i][j] = "____"
	copy[movement][movement] = "SELF"
	for a in copy:
		print(a)
	print("End")
	
	print("Genereate End\n\n\n")
	return # move_array











func new_check_tile(vpos: Vector2) -> bool:
	var current_tile_pos = tilemap.get_cellv(vpos)
	# print(current_tile_pos)
	if current_tile_pos != tilemap.INVALID_CELL:
		var tile_name = tilemap.tile_set.tile_get_name(current_tile_pos)
		# print("tile_name: ", tile_name, " tile_pos - ", vpos)
		if tile_name == "Ground30":
			return true
		if tile_name == "Ground15":
			return true
		if tile_name == "Ground0":
			return true	
		if tile_name == "Float0":
			return false
		if tile_name == "Float15":
			return false
		if tile_name == "Float30":
			return false
			
		return false
	else:
		# print("invalid - no tile at position")
		return false








func draw_character_movement_area():
#	print("\nMC POS", mc.position)
#	print(mc.get_character_movement())
#
#	# check character movement type
#	# float fly or ground type
#	# assuming ground type for now
#
#	print("SSSSS -", tilemap.world_to_map(mc.position))
#	var current_tile_pos = tilemap.get_cellv(tilemap.world_to_map(mc.position))
#	print(current_tile_pos)
#	print(tilemap.tile_set.tile_get_name(current_tile_pos))
#	print("SSSSS -")

	var vpos: Vector2 = get_char_tile_position()
	
	# Remove previous drawn grid movement if any
	for n in $MovementTilesWrapperNode.get_children():
		$MovementTilesWrapperNode.remove_child(n)
		n.queue_free()
	
	vpos = get_char_tile_position()
#	print(vpos)
#	current_tile_pos = tilemap.get_cellv(tilemap.world_to_map(vpos))
#	print(current_tile_pos)
#	if current_tile_pos != -1:
#		print("", tilemap.tile_set.tile_get_name(current_tile_pos))
#	else:
#		print("invalid - no tile at position")
#	print("VVVVV -")
#
	
	# NOTE a probably smarter and better method would probably be to 
	# loop through get all the titles in a 2d array
	# then check if theirs dead paths and other special cases
	# remove them (or set them as unusable tiles) then draw on whats left in the validated 
	# var total_sub_area: Rect2 = Rect2(vpos.x - 6, vpos.y - 6,
	# 								vpos.x + 6, vpos.y + 6)
	# print(total_sub_area)
	
	# if debug
	#var center_segment = Color.purple
	#var top_left_segment = Color.green
	#var top_right_segment = Color.red
	#var bottom_left_segment = Color.yellow
	#var bottom_right_segment = Color.blue
	# else 
	# var tile_to_be_flashed_color = Color("7de1e1e1")
	var center_segment = Color("7de1e1e1")
	var top_left_segment = center_segment
	var top_right_segment = center_segment
	var bottom_left_segment = center_segment
	var bottom_right_segment = center_segment
	
	var movement = mc.get_character_movement()
	var mcmt = (movement * 2) + 1
	# var ard: Array = []
	
	Singleton_Game_GlobalBattleVariables.active_actor_movement_array = []
	
	var squares_to_draw_in_row = 1
	
	var half_way_pass: bool = false
	
	# NOTE: this gets the x position of the tile the character is currently standing on
	# this assumes the map has terrain (tilemap) info from the left most and top most edges of the screen
	# TODO: should add a way to define size paddings on the top and from the left to ensure
	# grid movement is drawn at the right spot and not offset by the terrain tilemap position movement
	var xpos_character_center_tile = vpos.x * tile_size
	
	# var total_movement_tile_space = movement * tile_size * 2
	
	for i in mcmt:
		# ard.append([])
		# ard[i].resize(mcmt)
		Singleton_Game_GlobalBattleVariables.active_actor_movement_array.append([])
		Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i].resize(mcmt)
		
		# straight line down the middle
		# Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i][mcmt / 2] = 1
		
		if check_if_cell_is_navigatable(i, mcmt / 2, e_grid_movement_subsection.CENTER):
			
			Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i][mcmt / 2] = Vector2(xpos_character_center_tile, (vpos.y - movement + i) * tile_size)
			
			draw_flashing_movement_square(center_segment,
			xpos_character_center_tile,  # x pos
			(vpos.y - movement + i) * tile_size
			# total_movement_tile_space + (i * tile_size)  + tile_size # y pos
			)
		
		if i <= (mcmt / 2): 
			for j in squares_to_draw_in_row / 2:
				# print(j)
				# ard[i][(mcmt / 2) + j] = 1
				# Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i][(mcmt / 2) + j] = 1
				var yy = (mcmt / 2) + (j + 1)
				# top right side of array pyr
				if yy < mcmt:
					# ard[i][yy] = 1
					
					#print("Top Right ", i, " - ", yy)
					if check_if_cell_is_navigatable(i, yy, e_grid_movement_subsection.TOP_RIGHT):
						# Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i][yy] = 1
						
						var t = vpos # center character tile
						t.x = t.x + (yy - movement)
						t.y = (t.y - movement) + i
						draw_flashing_movement_square(top_right_segment, 
						t.x * tile_size, # x pos   # add left padding for when tilemap isnt at 0, 0
						t.y * tile_size # y pos   # add top padding for when tilemap isnt at 0, 0
						)
						Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i][yy] = Vector2(t.x * tile_size, t.y * tile_size)
						#draw_flashing_movement_square(Color.red, 
						#xpos_character_center_tile + (j * tile_size) + tile_size, # x pos 
						#yy * tile_size + total_movement_tile_space - (i * tile_size) + tile_size # y pos
						#)
					
				var yyy = (mcmt / 2) - (j + 1)
				# top left side of array pyr
				if yyy > -1:
					# ard[i][yyy] = 1
					
					#print("Top Left ", i, " - ", yyy)
					if check_if_cell_is_navigatable(i, yyy, e_grid_movement_subsection.TOP_LEFT):
						#Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i][yyy] = 1
						var t = vpos # center character tile
						t.x = t.x - (movement - yyy)
						t.y = (t.y - movement) + i
						draw_flashing_movement_square(top_left_segment, 
							t.x * tile_size, # x pos
							t.y * tile_size # y pos
						)
						Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i][yyy] = Vector2(t.x * tile_size, t.y * tile_size)
						#draw_flashing_movement_square(Color.green, 
						#	xpos_character_center_tile - (j * tile_size) - tile_size, # x pos
						#	yy * tile_size + total_movement_tile_space - (i * tile_size) + tile_size # y pos
						#)
		
			squares_to_draw_in_row = squares_to_draw_in_row + 2
		else:
			if !half_way_pass:
				half_way_pass = true
				squares_to_draw_in_row = squares_to_draw_in_row - 2
				
			squares_to_draw_in_row = squares_to_draw_in_row - 2
			# print("\n\n\n")
			for j in squares_to_draw_in_row / 2:
				# print(j)
				# ard[i][(mcmt / 2) + j] = 1
				# Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i][(mcmt / 2) + j] = 1
				var yy = (mcmt / 2) + (j + 1)
				
				# bottom right side of array pyr
				if yy < mcmt:
					# ard[i][yy] = 1
					
					if check_if_cell_is_navigatable(i, yy, e_grid_movement_subsection.BOTTOM_RIGHT):
						#Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i][yy] = 1
						var t = vpos # center character tile
						t.x = t.x + (yy - movement)
						t.y = (t.y - movement) + i
						draw_flashing_movement_square(bottom_right_segment, 
							t.x * tile_size, # x pos
							t.y * tile_size # y pos
						)
						Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i][yy] = Vector2(t.x * tile_size, t.y * tile_size)
						# draw_flashing_movement_square(Color.blue, 
						#	xpos_character_center_tile + (j * tile_size) + tile_size, # x pos
						#	i * tile_size + total_movement_tile_space + tile_size   # y pos
						# )
				
				# bottom left side of array pyr	
				var yyy = (mcmt / 2) - (j + 1)
				if yyy > -1:
					# ard[i][yyy] = 1
					
					
					if check_if_cell_is_navigatable(i, yyy, e_grid_movement_subsection.BOTTOM_LEFT):
						#Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i][yyy] = 1
						var t = vpos # center character tile
						t.x = t.x - (movement - yyy)
						t.y = (t.y - movement) + i
						draw_flashing_movement_square(bottom_left_segment, 
							t.x * tile_size, # x pos
							t.y * tile_size  # y pos
						)
						Singleton_Game_GlobalBattleVariables.active_actor_movement_array[i][yyy] = Vector2(t.x * tile_size, t.y * tile_size)
						#draw_flashing_movement_square(Color.yellow, 
						#	xpos_character_center_tile - (j * tile_size) - tile_size, # x pos
						#	yyy * tile_size + (2 * tile_size) + (total_movement_tile_space * 2) - (i * tile_size)   # y pos
						#)
	
	# print("Start")
	# for a in ard:
	# 	print(a)
	# print("End")
		
	
	# print("\n\n\nCharacter Movement Array ") #, Singleton_Game_GlobalBattleVariables.active_actor_movement_array)
	var copy = Singleton_Game_GlobalBattleVariables.active_actor_movement_array.duplicate(true)
#	for i in range(copy.size()):
#		for j in range(copy[i].size()):
#			if copy[i][j] == 1:
#				copy[i][j] = "___1"
	# for a in copy:
	# 	print(a)
	# print("End")
	
	print("\n")

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


func check_if_cell_is_navigatable(x: int, y: int, gss) -> bool:
	#print("Cell Additions - ", x, " ", y)
	
	#print("SSSSS - ", tilemap.world_to_map(mc.position))
	var current_tile_pos = tilemap.get_cellv(tilemap.world_to_map(mc.position))
	#print(current_tile_pos)
	#print(tilemap.tile_set.tile_get_name(current_tile_pos))
	#print("SSSSS -")
	
	#current_tile_pos = tilemap.get_cell(5, 19)
	#print("AAA tile at pos - ", current_tile_pos)
	# print(tilemap.tile_set.tile_get_name(current_tile_pos))
	var vpos: Vector2
	# vpos.x = 5
	# vpos.y = 19
	vpos = get_char_tile_position()
	# print("VPOS - ", vpos)
	
	var movement = mc.get_character_movement()
	
	if gss == e_grid_movement_subsection.TOP_RIGHT:
		vpos.x = vpos.x + (y - movement)
		vpos.y = (vpos.y - movement) + x
	elif gss == e_grid_movement_subsection.CENTER:
		# vpos.x = vpos.x + (y - 6)
		vpos.y = (vpos.y - movement) + x
	elif gss == e_grid_movement_subsection.TOP_LEFT:
		vpos.x = vpos.x - (movement - y)
		vpos.y = (vpos.y - movement) + x
	elif gss == e_grid_movement_subsection.BOTTOM_RIGHT:
		# Least tested might be bugged
		#print("VPOS - ", vpos)
		#print("RIGHTT - ", x, " ", y)
		vpos.x = vpos.x - (movement - y)
		vpos.y = (vpos.y - movement) + x
		#print("VPOS - ", vpos, "\n")
	elif gss == e_grid_movement_subsection.BOTTOM_LEFT:
		# Least tested might be bugged
		#print("VPOS - ", vpos)
		#print("Left - ", x, " ", y)
		vpos.x = vpos.x - (movement - y)
		vpos.y = (vpos.y - movement) + x
		#print("VPOS - ", vpos, "\n")
				
	#print("VPOS - ", vpos)
	current_tile_pos = tilemap.get_cellv(vpos)
	#print(current_tile_pos)
	if current_tile_pos != tilemap.INVALID_CELL:
		var tile_name = tilemap.tile_set.tile_get_name(current_tile_pos)
		# print("tile_name: ", tile_name, " tile_pos - ", vpos)
		if tile_name == "Ground30":
			return true
		if tile_name == "Ground15":
			return true
		if tile_name == "Ground0":
			return true	
		if tile_name == "Float0":
			return false
		if tile_name == "Float15":
			return false
		if tile_name == "Float30":
			return false
			
		return true
	else:
		# print("invalid - no tile at position")
		return false
		
	# return false


# Turn Order Queue Start

func fill_turn_order_array_with_all_actors():
	print("Turn Queue\n")
	
	# 1. Get all Enemies and Characters in the battle
	#print("Enemies - ", enemies)
	var enemies_c = enemies.get_children()
	for enemey in enemies_c:
		#print(enemey.get_name(), " - ",  enemey.cget_agility())
		turn_order_array.append({"name": enemey.get_name(), "type": "enemey", "speed": enemey.cget_agility(), "node": enemey})
		
	#print("\nCharacters - ",characters)
	var characters_c = characters.get_children()
	for character in characters_c:
		#print(character.get_name(), " - ",  character.cget_agility())
		turn_order_array.append({"name": character.get_name(), "type": "character", "speed": character.cget_agility(), "node": character})
	
	#print(turn_order_array)

func generate_actor_order_for_current_turn():
	#print("Generate Actor Order for Turn\n", turn_order_array)
	
	var ordered_turn_array = turn_order_array
#	if ordered_turn_array[0].name == "GoblinRoot6":
#		return
#	ordered_turn_array.remove(0)
#	ordered_turn_array.remove(0)
#	ordered_turn_array.remove(1)
#	ordered_turn_array.remove(1)
#	ordered_turn_array.remove(1)
#	ordered_turn_array.remove(1)
#	ordered_turn_array.remove(1)
#	ordered_turn_array.remove(1)
#	ordered_turn_array.remove(1)
#	ordered_turn_array.remove(1)
#	ordered_turn_array.remove(1)
#	ordered_turn_array.remove(1)
	
	
	
	ordered_turn_array.sort_custom(self, "sort_actors_by_agility")
	print("\nOrdered Array\n")
	for n in ordered_turn_array:
		print(n)
	print("\n")
	
	turn_order_array = ordered_turn_array

func sort_actors_by_agility(a, b) -> bool:
	return a.speed > b.speed
	

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
