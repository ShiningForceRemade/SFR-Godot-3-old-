extends CN_SF_UseRange

const tile_size: int = 24
const half_tile: int = tile_size / 2


func _ready():
	pass


func draw_use_range():
	var uttwn = Singleton_Game_GlobalBattleVariables.field_logic_node.get_node("UseTargetTilesWrapperNode")
	
	for n in uttwn.get_children():
		uttwn.remove_child(n)
		n.queue_free()
	
	var vpos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
	vpos.x -= half_tile
	vpos.y -= half_tile
	
	# TODO: generic func in the base class that takes in an array of position sqaures and draws the use range
	# shouldn't be doing this manual by hand draw for each use range for testing for now its fine
	
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x,
		vpos.y - (tile_size * 2),
		uttwn
	)

	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x,
		vpos.y + (tile_size * 2),
		uttwn
	)

	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x - (tile_size * 2),
		vpos.y,
		uttwn
	)

	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x + (tile_size * 2),
		vpos.y,
		uttwn
	)

	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x + tile_size,
		vpos.y - tile_size,
		uttwn
	)
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x - tile_size,
		vpos.y - tile_size,
		uttwn
	)
	
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x + tile_size,
		vpos.y + tile_size,
		uttwn
	)
	
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x - tile_size,
		vpos.y + tile_size,
		uttwn
	)
	
		# Top tile
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x,
		vpos.y - tile_size,
		uttwn
	)

	# Bottom tile
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x,
		vpos.y + tile_size,
		uttwn
	)

	# Left tile
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x - tile_size,
		vpos.y,
		uttwn
	)

	# Right tile
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x + tile_size,
		vpos.y,
		uttwn
	)
	
	print("1 to 2 usage range")
	


func get_use_range_array_representation() -> Array:
	return [
		[null, null,    1, null, null],
		[null,    1,    1,    1, null],
		[   1,    1, null,    1,    1],
		[null,    1,    1,    1, null],
		[null, null,    1, null, null],
	]
	
