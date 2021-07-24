extends Node2D

var is_battle_finished: bool = false
var turn_number: int = 1

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

# Called when the node enters the scene tree for the first time.
func _ready():
	# print(tilemap)
	yield(get_tree().root, "ready")
	
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
	var camera = get_parent().get_node("Camera2D")
	
	generate_actor_order_for_current_turn()
	
	emit_signal("signal_hide_land_effect_and_active_actor_info")
	var t = Timer.new()
	t.set_wait_time(0.75)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	
	# print(turn_order_array)
	for a in turn_order_array:
		print("\n", a)
		
		emit_signal("signal_hide_land_effect_and_active_actor_info")
		
		if a.type == "enemey":
			continue
			print("Enemy Turn Start")
			
			# camera.smooth_move_to_new_position(a.node.get_node("EnemeyRoot/KinematicBody2D"))
			camera.smooth_move_to_new_position(a.node)
			yield(camera, "signal_camera_move_complete")
			
			# mc.connect("signal_character_moved", self, "get_tile_info_under_character")
			
			print(a.node)
			mc = a.node
			active_character_or_enemey_display_info()
			emit_signal("signal_show_land_effect_and_active_actor_info")
			
			a.node.play_turn()
			yield(a.node, "signal_completed_turn")
			print("Enemy Turn End")
			
#			var t = Timer.new()
#			t.set_wait_time(0.75)
#			t.set_one_shot(true)
#			self.add_child(t)
#			t.start()
#			yield(t, "timeout")
		else:
			print("Character Turn Start")
			# NOTE: TODO: BUG: more than likely signal for turn complete firing too quickly
			# triggers multiple turn ends forcing wiat to test following character moves for note
			# when adding the action menu that would prevent is_action_just_pressed enter from being immediately called
			# when would elimate the need for this as well
			# if the above doesnt work cause of fall through a triggers menuy menu triggers stay action
			# add a singleton when triggered set bool to triggered when released un set and check for it
			
			mc = a.node
			
			# Singleton_Game_GlobalBattleVariables.currently_active_character = a.node
			Singleton_Game_GlobalBattleVariables.set_currently_active_character(a.node)
			
			# camera.playerNode = a.node.get_kinematic_body()
			
			a.node.play_turn()
			# mc = a.node
			#camera.smooth_move_to_new_position(a.node.get_kinematic_body())
			camera.smooth_move_to_new_position(a.node)
			yield(camera, "signal_camera_move_complete")
			
			# camera.smooth_move_to_new_position(a.node.get_kinematic_body())
			
			# camera.playerNode = a.node.get_kinematic_body()
			# camera.smooth_move_to_new_position(a.node.get_kinematic_body())
			
			active_character_or_enemey_display_info()
			emit_signal("signal_show_land_effect_and_active_actor_info")
			
			mc.connect("signal_character_moved", self, "get_tile_info_under_character")
			mc.connect("signal_show_character_action_menu", self, "s_show_character_action_menu")
			mc.connect("signal_switch_focus_to_cursor", self, "s_switch_focus_to_cursor")
			# turn_movement_init()
			draw_character_movement_area()
			$AnimationPlayer.play("RandomTileFlashing")
			# play_turn will yield control until the player or enemy finishes its turn
			
			yield(Singleton_Game_GlobalBattleVariables.self_node(), "signal_completed_turn")
			
			# yield(a.node, "signal_completed_turn_z")
			
			print("Character Turn End")
			mc.disconnect("signal_character_moved", self, "get_tile_info_under_character")
			mc.disconnect("signal_show_character_action_menu", self, "s_show_character_action_menu")
			mc.disconnect("signal_switch_focus_to_cursor", self, "s_switch_focus_to_cursor")
			
			yield(get_tree().create_timer(0.5), "timeout")
			
	
	print("\n\n\nTurn " + str(turn_number) + " Completed\n\n\n")
	turn_number += 1
	generate_and_launch_new_turn_order()

func s_switch_focus_to_cursor():
	cursor_root.set_active()

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
	mc.cget_hp_total(),
	mc.cget_hp_current(),
	mc.cget_mp_total(),
	mc.cget_mp_current())
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
	
func draw_character_movement_area():
#	print("\nMC POS", mc.position)
#	print(mc.get_character_movement())
#
#	# check character movement type
#	# float fly or ground type
#	# assuming ground type for now
#
#	var cr = ColorRect.new()
#	cr.color = Color.aliceblue
#	cr.rect_size.x = 24
#	cr.rect_size.y = 24
#	cr.rect_position.x = mc.position.x - 12 
#	cr.rect_position.y = mc.position.y - 12
#	self.add_child(cr)
#
#	print("SSSSS -", tilemap.world_to_map(mc.position))
#	var current_tile_pos = tilemap.get_cellv(tilemap.world_to_map(mc.position))
#	print(current_tile_pos)
#	print(tilemap.tile_set.tile_get_name(current_tile_pos))
#	print("SSSSS -")
#
#	#current_tile_pos = (5, 30)
#	#current_tile_pos.x = 5
#	#current_tile_pos.y = 30
	var vpos: Vector2
	# vpos.x = 5
	# vpos.y = 19
	vpos = get_char_tile_position()
	
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
		
		# straight line down the middle
		# ard[i][mcmt / 2] = 1
		#print("Center - ", i, " - ", mcmt / 2)
		if check_if_cell_is_navigatable(i, mcmt / 2, e_grid_movement_subsection.CENTER):
			draw_flashing_movement_square(center_segment,
			xpos_character_center_tile,  # x pos
			(vpos.y - movement + i) * tile_size
			# total_movement_tile_space + (i * tile_size)  + tile_size # y pos
			)
		
		if i <= (mcmt / 2): 
			for j in squares_to_draw_in_row / 2:
				# print(j)
				# ard[i][(mcmt / 2) + j] = 1
				var yy = (mcmt / 2) + (j + 1)
				# top right side of array pyr
				if yy < mcmt:
					# ard[i][yy] = 1
					#print("Top Right ", i, " - ", yy)
					if check_if_cell_is_navigatable(i, yy, e_grid_movement_subsection.TOP_RIGHT):
						var t = vpos # center character tile
						t.x = t.x + (yy - movement)
						t.y = (t.y - movement) + i
						draw_flashing_movement_square(top_right_segment, 
						t.x * tile_size, # x pos   # add left padding for when tilemap isnt at 0, 0
						t.y * tile_size # y pos   # add top padding for when tilemap isnt at 0, 0
						)
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
						var t = vpos # center character tile
						t.x = t.x - (movement - yyy)
						t.y = (t.y - movement) + i
						draw_flashing_movement_square(top_left_segment, 
							t.x * tile_size, # x pos
							t.y * tile_size # y pos
						)
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
				var yy = (mcmt / 2) + (j + 1)
				
				# bottom right side of array pyr
				if yy < mcmt:
					# ard[i][yy] = 1
					if check_if_cell_is_navigatable(i, yy, e_grid_movement_subsection.BOTTOM_RIGHT):
						var t = vpos # center character tile
						t.x = t.x + (yy - movement)
						t.y = (t.y - movement) + i
						draw_flashing_movement_square(bottom_right_segment, 
							t.x * tile_size, # x pos
							t.y * tile_size # y pos
						)
						# draw_flashing_movement_square(Color.blue, 
						#	xpos_character_center_tile + (j * tile_size) + tile_size, # x pos
						#	i * tile_size + total_movement_tile_space + tile_size   # y pos
						# )
				
				# bottom left side of array pyr	
				var yyy = (mcmt / 2) - (j + 1)
				if yyy > -1:
					# ard[i][yyy] = 1
					
					if check_if_cell_is_navigatable(i, yyy, e_grid_movement_subsection.BOTTOM_LEFT):
						var t = vpos # center character tile
						t.x = t.x - (movement - yyy)
						t.y = (t.y - movement) + i
						draw_flashing_movement_square(bottom_left_segment, 
							t.x * tile_size, # x pos
							t.y * tile_size  # y pos
						)
						#draw_flashing_movement_square(Color.yellow, 
						#	xpos_character_center_tile - (j * tile_size) - tile_size, # x pos
						#	yyy * tile_size + (2 * tile_size) + (total_movement_tile_space * 2) - (i * tile_size)   # y pos
						#)
	
	# print("Start")
	# for a in ard:
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

#func draw_flashing_movement_square(acolor: Color, xpos: int, ypos: int) -> void:
#	var cr = ColorRect.new()
#	cr.color = Color("#9c000000")
#	# 5f9f9f9f
#
#	cr.rect_size.x = 24
#	cr.rect_size.y = 24
#
#	cr.rect_position.x = xpos
#	cr.rect_position.y = ypos
#
#	#print(cr.rect_position)
#	self.add_child(cr)

#func tween_all_movement_squares():
#	var twn = Tween.new()
#	self.add_child(twn)

# 
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
	ordered_turn_array.sort_custom(self, "sort_actors_by_agility")
	print("\nOrdered Array\n")
	for n in ordered_turn_array:
		print(n)
	print("\n")
	

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
