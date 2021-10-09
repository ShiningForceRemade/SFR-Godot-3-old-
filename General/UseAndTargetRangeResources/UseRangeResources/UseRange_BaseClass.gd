extends Resource

class_name CN_SF_UseRange

var center_segment = Color("7de1e1e1")
# var top_left_segment = center_segment
# var top_right_segment = center_segment
# var bottom_left_segment = center_segment
# var bottom_right_segment = center_segment

const tile_size: int = 24
const half_tile: int = tile_size / 2


func _ready():
	pass


func draw_use_range() -> void:
	print("\n\nBase Class\n\n")
	pass


func draw_use_range_tiles(move_array) -> void:
	# print("\n\nBase Class Test Draw Call with Array Rep \n\n")
	# for a in move_array:
	# 	print(a)
	
	var uttwn = Singleton_Game_GlobalBattleVariables.field_logic_node.get_node("UseTargetTilesWrapperNode")
	
	for n in uttwn.get_children():
		uttwn.remove_child(n)
		n.queue_free()
	
	var actor_cur_pos = Singleton_Game_GlobalBattleVariables.currently_active_character.global_position
	var movement = move_array.size() / 2
	
	# TOP LEFT QUADRANT
	for row in range(movement):
		for col in range(movement):
			if move_array[row][col] == 1:
				Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(center_segment,
				actor_cur_pos.x - ((movement - col) * tile_size) - (tile_size / 2),
				actor_cur_pos.y - ((movement - row) * tile_size) - (tile_size / 2),
				uttwn
				)
	
	# TOP RIGHT QUADRANT
	for row in range(movement):
		for col in range(movement):
			if move_array[row][col + movement + 1] == 1:
				Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(center_segment,
				actor_cur_pos.x + ((col + 1) * tile_size) - (tile_size / 2),
				actor_cur_pos.y - ((movement - row) * tile_size) - (tile_size / 2),
				uttwn
				)
	
	# BOTTOM LEFT QUADRANT
	for row in range(movement):
		for col in range(movement):
			if move_array[row + movement + 1][col] == 1:
				Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(center_segment,
				actor_cur_pos.x - ((movement - col) * tile_size) - (tile_size / 2),
				actor_cur_pos.y + ((row + 1) * tile_size) - (tile_size / 2),
				uttwn
				)
				pass
	
	# BOTTOM RIGHT QUADRANT
	for row in range(movement):
		for col in range(movement):
			if move_array[row + movement + 1][col + movement + 1] == 1:
				Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(center_segment,
				actor_cur_pos.x + ((col + 1) * tile_size) - (tile_size / 2),
				actor_cur_pos.y + ((row + 1) * tile_size) - (tile_size / 2),
				uttwn
				)
	
	# Straight Down Top Porition
	for row in range(movement):
		if move_array[row][movement] == 1:
			Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(center_segment,
			actor_cur_pos.x - (tile_size / 2),
			actor_cur_pos.y - ((movement - row) * tile_size) - (tile_size / 2),
			uttwn
			)
	
	# Straight Down Top Porition
	for row in range(movement):
		if move_array[row + movement + 1][movement] == 1:
			Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(center_segment,
			actor_cur_pos.x - (tile_size / 2),
			actor_cur_pos.y + ((row + 1) * tile_size) - (tile_size / 2),
			uttwn
			)
	
	# Straight Across Right Porition
	for col in range(movement):
		if move_array[movement][col] == 1:
			Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(center_segment,
			actor_cur_pos.x - ((movement - col) * tile_size) - (tile_size / 2),
			actor_cur_pos.y - (tile_size / 2),
			uttwn
			)
	
	# Straight Across Right Porition
	for col in range(movement):
		if move_array[movement][col + movement + 1] == 1:
			Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(center_segment,
			actor_cur_pos.x + ((col + 1) * tile_size) - (tile_size / 2),
			actor_cur_pos.y - (tile_size / 2),
			uttwn
			)
	
	# Center Self Tile
	if move_array[movement][movement] == 1:
		Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(center_segment, 
		actor_cur_pos.x - (tile_size / 2), 
		actor_cur_pos.y - (tile_size / 2),
		uttwn
		)
	
	pass


# TODO: probably should add a helper func that just calls these two funcs together
# probably won't need this separation down the line

func get_use_range_array_representation() -> Array:
	return [[null]]
