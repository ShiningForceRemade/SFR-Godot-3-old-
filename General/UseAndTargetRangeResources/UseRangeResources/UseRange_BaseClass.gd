extends Resource

class_name CN_SF_UseRange

var center_segment = Color("7de1e1e1")
# var top_left_segment = center_segment
# var top_right_segment = center_segment
# var bottom_left_segment = center_segment
# var bottom_right_segment = center_segment

const tile_size: int = 24
const half_tile: int = 12 # tile_size / 2


func _ready():
	pass


func draw_use_range() -> void:
	print("\n\nBase Class\n\n")
	pass


func draw_use_range_tiles(move_array) -> void:
	print("\n\nDrawing use range\n\n")
	# print("\n\nBase Class Test Draw Call with Array Rep \n\n")
	# for a in move_array:
	# 	print(a)
	
	var uttwn = Singleton_CommonVariables.battle__logic__target_selection_wrapper_node
	
	for n in uttwn.get_children():
		uttwn.remove_child(n)
		n.queue_free()
	
	var actor_cur_pos = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).global_position
	var movement = move_array.size() / 2
	
	Singleton_CommonVariables.battle__target_use_range_array_representation = []
	for i in range(move_array.size()):
		Singleton_CommonVariables.battle__target_use_range_array_representation.append([])
		Singleton_CommonVariables.battle__target_use_range_array_representation[i].resize(move_array.size())
	
	# TOP LEFT QUADRANT
	for row in range(movement):
		for col in range(movement):
			if move_array[row][col] == 1:
				Singleton_CommonVariables.battle__logic__target_selection_node.draw_and_populate_cell_info(
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
			if move_array[row][col + movement + 1] == 1:
				Singleton_CommonVariables.battle__logic__target_selection_node.draw_and_populate_cell_info(
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
			if move_array[row + movement + 1][col] == 1:
				Singleton_CommonVariables.battle__logic__target_selection_node.draw_and_populate_cell_info(
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
			if move_array[row + movement + 1][col + movement + 1] == 1:
				Singleton_CommonVariables.battle__logic__target_selection_node.draw_and_populate_cell_info(
					row + movement + 1, 
					col + movement + 1,
					Vector2(
						actor_cur_pos.x + ((col + 1) * tile_size),
						actor_cur_pos.y + ((row + 1) * tile_size)
					)
				)
	
	# Straight Down Top Porition
	for row in range(movement):
		if move_array[row][movement] == 1:
			Singleton_CommonVariables.battle__logic__target_selection_node.draw_and_populate_cell_info(
				row, 
				movement,
				Vector2(
					actor_cur_pos.x,
					actor_cur_pos.y - ((movement - row) * tile_size)
				)
			)
	
	# Straight Down Top Porition
	for row in range(movement):
		if move_array[row + movement + 1][movement] == 1:
			Singleton_CommonVariables.battle__logic__target_selection_node.draw_and_populate_cell_info(
				row + movement + 1, 
				movement,
				Vector2(
					actor_cur_pos.x,
					actor_cur_pos.y + ((row + 1) * tile_size)
				)
			)
	
	# Straight Across Right Porition
	for col in range(movement):
		if move_array[movement][col] == 1:
			Singleton_CommonVariables.battle__logic__target_selection_node.draw_and_populate_cell_info(
				movement, 
				col,
				Vector2(
					actor_cur_pos.x - ((movement - col) * tile_size),
					actor_cur_pos.y
				)
			)
	
	# Straight Across Right Porition
	for col in range(movement):
		if move_array[movement][col + movement + 1] == 1:
			Singleton_CommonVariables.battle__logic__target_selection_node.draw_and_populate_cell_info(
				movement, 
				col + movement + 1,
				Vector2(
					actor_cur_pos.x + ((col + 1) * tile_size),
					actor_cur_pos.y
				)
			)
	
	# Center Self Tile
	if move_array[movement][movement] == 1:
		Singleton_CommonVariables.battle__logic__target_selection_node.draw_and_populate_cell_info(
			movement, 
			movement,
			Vector2(
				actor_cur_pos.x, 
				actor_cur_pos.y
			)
		)


# TODO: probably should add a helper func that just calls these two funcs together
# probably won't need this separation down the line

func get_use_range_array_representation() -> Array:
	return [[null]]
