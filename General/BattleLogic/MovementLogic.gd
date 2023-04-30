extends Node

@onready var animation_player: AnimationPlayer = get_parent().get_node("AnimationPlayer")

const tile_size: int = 24 # 24 by 24
const half_tile_size: int = 12 # tile_size / 2 # tile_size / 2 = 12 by 12

const center_segment = Color("7de1e1e1") # default tile color when not debugging
const white_segment = Color("FFFFFF") # actor
const red_segment = Color("ff0000") # not movedable
const yellow_segment = Color("ffff00") # terrain penalty removed
const green_segment = Color("00ff00") # terrain penalty tile that is okay to move on

var actor_type: String
var actor_info_root: Node2D
var actor_move: int
var actor_move_type: int

var astar_node: AStar2D = AStar2D.new()
var move_array: Array = []
var map_size

# Field Logic Tiles layer helper functions
func hide_movement_tiles() -> void:
	Singleton_CommonVariables.battle__movement_tiles_wrapper_node.hide()


func show_movement_tiles() -> void:
	Singleton_CommonVariables.battle__movement_tiles_wrapper_node.show()


func draw_flashing_movement_square(acolor: Color, xpos: int, ypos: int) -> void:
	var cr = ColorRect.new()
	# cr.color = acolor
	cr.color = white_segment
	cr.size.x = tile_size
	cr.size.y = tile_size

	cr.position.x = xpos - half_tile_size
	cr.position.y = ypos - half_tile_size
	
	Singleton_CommonVariables.battle__movement_tiles_wrapper_node.add_child(cr)


func draw_all_movement_tiles() -> void:
	for i_idx in range(move_array.size()):
		for j_idx in range(move_array[i_idx].size()):
			if move_array[i_idx][j_idx] != null && move_array[i_idx][j_idx].walkable != "NO_":
				draw_flashing_movement_square(
					move_array[i_idx][j_idx].color, 
					move_array[i_idx][j_idx].position.x,
					move_array[i_idx][j_idx].position.y
				)


func check_if_character_or_enemey_is_on_tile_excluding_current_actor(chk_pos_arg: Vector2, current_actor_instance_id):
	for enemey in Singleton_CommonVariables.battle__enemies.get_children():
		if enemey.get_child(0).global_position == chk_pos_arg:
			if current_actor_instance_id != enemey.get_instance_id():
				return { "actor": "enemey", "move": null, "id": enemey.get_instance_id() }
	
	for character in Singleton_CommonVariables.battle__characters.get_children():
		if character.get_child(0).global_position == chk_pos_arg:
			if current_actor_instance_id != character.get_instance_id():
				return { "actor": "character", "move": null, "id": character.get_instance_id() }
	
	return null


func check_if_character_or_enemey_is_on_tile(chk_pos_arg):
	for enemey in Singleton_CommonVariables.battle__enemies.get_children():
		if enemey.get_child(0).global_position == chk_pos_arg:
			return { "actor": "enemey", "move": null, "id": enemey.get_instance_id() }
	
	for character in Singleton_CommonVariables.battle__characters.get_children():
		if character.get_child(0).global_position == chk_pos_arg:
			return { "actor": "character", "move": null, "id": character.get_instance_id() }
	
	return null


func get_tilename_at_pos(pos_arg: Vector2) -> String:
	var current_tile_posx = Singleton_CommonVariables.battle__tilemap_info_group__terrain.get_cell_tile_data(0, pos_arg)
	
	if current_tile_posx != null:
		## TODO: see if its possible for godot to add actual custom data layer name as the getter property name this is nasty
		## land type - ie ground or mountain or sky etc...
		# print(current_tile_posx.custom_data_0)
		## land effect value - ie 0 15 or 30
		# print(current_tile_posx.custom_data_1)
	
		return current_tile_posx.custom_data_0
	
	return "INVALID_CELL"


func get_land_effect_value_at_pos(pos_arg: Vector2):
	var local_pos = Singleton_CommonVariables.battle__tilemap_info_group__terrain.local_to_map(pos_arg)
	var current_tile_posx = Singleton_CommonVariables.battle__tilemap_info_group__terrain.get_cell_tile_data(0, local_pos)
	
	if current_tile_posx != null:
		return {
			"type": current_tile_posx.custom_data_0,
			"value": current_tile_posx.custom_data_1
		}
	
	return null


func set_actor_type() -> void:
	actor_info_root = Singleton_CommonVariables.battle__currently_active_actor.find_child("EnemeyRoot", true)
	if actor_info_root != null:
		actor_type = "enemey"
		return
	
	actor_info_root = Singleton_CommonVariables.battle__currently_active_actor.find_child("CharacterRoot", true)
	
	if actor_info_root == null:
		print("BREAK actor should be found")
		return
	
	actor_type = "character"


func generate_movement_array_representation():
	print("\nGenerate Movement Start")
	
	for n in Singleton_CommonVariables.battle__movement_tiles_wrapper_node.get_children():
		n.queue_free()
	
	set_actor_type()
	
	# TODO: fix
	# probably should have funcs in enemeyroot and characterroot that fetches the info instead of using direct
	actor_move = actor_info_root.get_movement() # Singleton_CommonVariables.battle__currently_active_actor
	var movement = actor_move
	actor_move_type = actor_info_root.get_movement_type()
	var sfmt = Singleton_CommonVariables.sf_game_data_node.sf_movement_types
	print("Movement        - ", movement)
	print("Movement Type   - ", actor_move_type)
	print("Movement Values - ", sfmt[actor_move_type])
	
	# world space actor position
	var actor_cur_pos = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).global_position 
	
	print("Global POS- ", Singleton_CommonVariables.battle__currently_active_actor.get_child(0).global_position)
	print("POS - ", Singleton_CommonVariables.battle__currently_active_actor.get_child(0).position)
	
	# converted world space to tilemap xy cordinates use this going forward
	var current_tile_pos = Singleton_CommonVariables.battle__tilemap_info_group__terrain.local_to_map(actor_cur_pos)
	print("Self tile - map position - ", current_tile_pos)
	
	move_array = []
	var total_move_array_size = (movement * 2) + 1
	for i in range(total_move_array_size):
		move_array.append([])
		move_array[i].resize(total_move_array_size)
	
	# TOP LEFT QUADRANT
	for row in range(1, movement):
		for col in range(movement):
			if col <= movement - row - 1:
				continue
			
			determine_if_cell_is_moveable_to(
				row, 
				col,
				Vector2(current_tile_pos.x - (movement - col), current_tile_pos.y - (movement - row)),
				Vector2(
					actor_cur_pos.x - ((movement - col) * tile_size),
					actor_cur_pos.y - ((movement - row) * tile_size)
				),
				((movement - row - 1) + (movement - col)) + 1
			)
	
	# TOP RIGHT QUADRANT
	for row in range(1, movement):
		for col in range(movement):
			if col >= row:
				continue
			
			determine_if_cell_is_moveable_to(
				row, 
				col + movement + 1,
				Vector2(current_tile_pos.x + (col + 1), current_tile_pos.y - (movement - row)),
				Vector2(
					actor_cur_pos.x + ((col + 1) * tile_size),
					actor_cur_pos.y - ((movement - row) * tile_size)
				),
				((movement - row) + col) + 1
			)
	
	# BOTTOM LEFT QUADRANT
	for row in range(movement - 1):
		for col in range(1, movement):
			if col <= row:
				continue
			
			determine_if_cell_is_moveable_to(
				row + movement + 1, 
				col,
				Vector2(current_tile_pos.x - (movement - col), current_tile_pos.y + (row + 1)),
				Vector2(
					actor_cur_pos.x - ((movement - col) * tile_size),
					actor_cur_pos.y + ((row + 1) * tile_size)
				),
				(movement - col) + row + 1
			)
	
	# BOTTOM RIGHT QUADRANT
	for row in range(movement - 1):
		for col in range(movement - 1):
			if col >= movement - row - 1:
				continue
			
			determine_if_cell_is_moveable_to(
				row + movement + 1, 
				col + movement + 1,
				Vector2(current_tile_pos.x + (col + 1), current_tile_pos.y + (row + 1)),
				Vector2(
					actor_cur_pos.x + ((col + 1) * tile_size),
					actor_cur_pos.y + ((row + 1) * tile_size)
				),
				col + row + 2
			)
	
	# Straight Across Left Side
	for col in range(movement):
		determine_if_cell_is_moveable_to(
			movement, 
			col,
			Vector2(current_tile_pos.x - (movement - col), current_tile_pos.y),
			Vector2(
				actor_cur_pos.x - ((movement - col) * tile_size),
				actor_cur_pos.y
			),
			movement - col
		)
	
	# Straight Across Right Side
	for col in range(movement):
		determine_if_cell_is_moveable_to(
			movement, 
			col + movement + 1,
			Vector2(current_tile_pos.x + (col + 1), current_tile_pos.y),
			Vector2(
				actor_cur_pos.x + ((col + 1) * tile_size),
				actor_cur_pos.y
			),
			col + 1
		)
	
	# Straight Down Top Portion
	for row in range(movement):
		determine_if_cell_is_moveable_to(
			row, 
			movement,
			Vector2(current_tile_pos.x, current_tile_pos.y - (movement - row)),
			Vector2(
				actor_cur_pos.x,
				actor_cur_pos.y - ((movement - row) * tile_size)
			),
			movement - row
		)
	
	# Straight Down Bottom Portion
	for row in range(movement):
		determine_if_cell_is_moveable_to(
			row + movement + 1, 
			movement,
			Vector2(current_tile_pos.x, current_tile_pos.y + (row + 1)),
			Vector2(
				actor_cur_pos.x,
				actor_cur_pos.y + ((row + 1) * tile_size)
			),
			row + 1
		)
	
#	# Center Self Tile
#	determine_if_cell_is_moveable_to(
#		movement, movement, current_tile_pos, 
#		Vector2(actor_cur_pos.x, actor_cur_pos.y),
#		0 # Always allow this cell regardless of any other logic
#	)

	# Center Self Tile doesn't need checks its always valid
	move_array[actor_move][actor_move] = {
		# "on_tile": 1,
		"terrain": get_tilename_at_pos(current_tile_pos),
		"position": actor_cur_pos,
		"tile_position": current_tile_pos,
		"walkable": "YES",
		"color": white_segment
	}
	
	
	# astar_connect_walkable_cells()
	# Singleton_CommonVariables.active_actor_move_array_representation = move_array
	
#	for a in move_array:
#		print(a)
#	print("End")
	
#	var x = []
#	for i in range(total_move_array_size):
#		x.append([])
#		x[i].resize(total_move_array_size)
#
#	for i in range(move_array.size()):
#		for j in range(move_array[i].size()):
#			if move_array[i][j] != null:
#				x[i][j] = move_array[i][j].walkable
#			else:
#				x[i][j] = "NUL"
#
#	x[actor_move][actor_move] = "SEL"
#	for xi in x:
#		print(xi)
	
	astar_connect_walkable_cells()
	
	Singleton_CommonVariables.active_actor_move_point_representation = move_array
	draw_all_movement_tiles()
	animation_player.play("TileFlashing")
	
	print("Generate Movement End\n\n")
	
	return 


func determine_if_cell_is_moveable_to(
	row_arg: int, col_arg: int,
	tile_local_pos_arg: Vector2, 
	tile_pos_arg: Vector2,
	cell_distance_from_center_value: int
) -> void:
	var tile = get_tilename_at_pos(tile_local_pos_arg)
	
	move_array[row_arg][col_arg] = {
		# "on_tile": 1,
		"terrain": tile,
		"position": tile_pos_arg,
		"tile_position": tile_local_pos_arg,
		"walkable": "YES",
		"color": white_segment
	}
	
	if tile != "INVALID_CELL":
		var check_pos = tile_pos_arg
		var res = check_if_character_or_enemey_is_on_tile(check_pos)
		if res != null:
			move_array[row_arg][col_arg].on_tile = res.actor # enemey or character
			move_array[row_arg][col_arg].color = white_segment
			
			if res.actor == actor_type:
				move_array[row_arg][col_arg].walkable = "YES"
			else:
				move_array[row_arg][col_arg].walkable = "NO_"
			
			return
		
		var terrain_penalty_float = Singleton_CommonVariables.sf_game_data_node.sf_movement_types[actor_move_type][tile]
		# print("Terrain Penalty Float - ", terrain_penalty_float, " ", Singleton_CommonVariables.sf_game_data_node.sf_movement_types[actor_move_type][tile])
		if terrain_penalty_float == 0:
			# this movement type cant go over this cell type so update
			move_array[row_arg][col_arg].terrain = "TERRAIN_PENALTY"
			move_array[row_arg][col_arg].walkable = "NO_"
			move_array[row_arg][col_arg].color = red_segment
		elif terrain_penalty_float == 1.0:
			move_array[row_arg][col_arg].color = center_segment
		else: # terrain_penalty above 1 determine if within moveable distance
			var temp_penalty = int(round(actor_move / terrain_penalty_float))
			if cell_distance_from_center_value > (temp_penalty - 1):	
				# move_array[row_arg][col_arg].on_tile = 3
				move_array[row_arg][col_arg].terrain = "REMOVME"
				move_array[row_arg][col_arg].walkable = "NO_"
				move_array[row_arg][col_arg].color = yellow_segment
			else:
				move_array[row_arg][col_arg].color = green_segment
	else:
		move_array[row_arg][col_arg].walkable = "NO_"


### AStar

func astar_connect_walkable_cells() -> void:
	astar_node.clear()
	
	var point_index
	map_size = Vector2(actor_move * 2, actor_move * 2)
	
	# 1. Create points from all tiles that are walkable = "YES"
	for i_idx in range(move_array.size()):
		for j_idx in range(move_array[i_idx].size()):
			if move_array[i_idx][j_idx] != null && move_array[i_idx][j_idx].walkable != "NO_":
				point_index = calculate_point_index(move_array[i_idx][j_idx].tile_position)
				astar_node.add_point(point_index, move_array[i_idx][j_idx].tile_position)
				move_array[i_idx][j_idx].point_index = point_index
				# print(move_array[i_idx][j_idx])
	
	# 2. Connect all walkable tiles with their respective point idxs
	var point
	for i_idx in range(move_array.size()):
		for j_idx in range(move_array[i_idx].size()):
			if move_array[i_idx][j_idx] != null && move_array[i_idx][j_idx].walkable != "NO_":
				point = move_array[i_idx][j_idx].tile_position
				point_index = move_array[i_idx][j_idx].point_index
				
				var points_relative = PackedVector2Array([
					Vector2(point.x + 1, point.y),
					Vector2(point.x - 1, point.y),
					Vector2(point.x, point.y + 1),
					Vector2(point.x, point.y - 1)
				])
				
				for point_relative in points_relative:
					var point_relative_index = calculate_point_index(point_relative)
					# print(point_relative_index, " ", point_relative)
					
#					if is_outside_map_bounds(point_relative):
#						continue
					if not astar_node.has_point(point_relative_index):
						continue
					
					astar_node.connect_points(point_index, point_relative_index, false)
	
	# 3. Remove any move array tiles that arent connected to the self center cell
	var start_center_point_idx = move_array[actor_move][actor_move].point_index
	for i_idx in range(move_array.size()):
		for j_idx in range(move_array[i_idx].size()):
			if move_array[i_idx][j_idx] != null && move_array[i_idx][j_idx].walkable != "NO_":
				if astar_node.get_point_path(start_center_point_idx, move_array[i_idx][j_idx].point_index).size() != 0:
					pass
				else:
					move_array[i_idx][j_idx].walkable = "NO_"


#func is_outside_map_bounds(point) -> bool:
#	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y


func calculate_point_index(point: Vector2) -> int:
	return point.x + map_size.x * point.y


