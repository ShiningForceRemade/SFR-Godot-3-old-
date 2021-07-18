extends CN_SF_UseRange

const tile_size: int = 24
const half_tile: int = tile_size / 2

func _ready():
	pass

static func draw_use_range():
	# print("UseRange_1 - vpos - ", vposz, " FieldLogicNode - ", fieldLogicNode)
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
		Color.purple,
		vpos.x,
		vpos.y - (tile_size * 2),
		uttwn
	)

	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		Color.purple,
		vpos.x,
		vpos.y + (tile_size * 2),
		uttwn
	)

	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		Color.purple,
		vpos.x - (tile_size * 2),
		vpos.y,
		uttwn
	)

	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		Color.purple,
		vpos.x + (tile_size * 2),
		vpos.y,
		uttwn
	)

	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		Color.purple,
		vpos.x + tile_size,
		vpos.y - tile_size,
		uttwn
	)
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		Color.purple,
		vpos.x - tile_size,
		vpos.y - tile_size,
		uttwn
	)
	
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		Color.purple,
		vpos.x + tile_size,
		vpos.y + tile_size,
		uttwn
	)
	
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		Color.purple,
		vpos.x - tile_size,
		vpos.y + tile_size,
		uttwn
	)
	
	# X X 1 X X 
	# X 1 X 1 X
	# 1 X S X 1
	# X 1 X 1 X
	# X X 1 X X
#	return [
#		[null, null, 1, null, null],
#		[null, 1,    null, 1, null],
#		[1, null, 1,    null, 1],
#		[null, 1,    null, 1, null],
#		[null, null, 1, null, null],
#		]
	print("\n")
	

func get_use_range_array_representation() -> Array:
	return [
		[null, null,    1, null, null],
		[null,    1, null,    1, null],
		[   1, null, null, null,    1],
		[null,    1, null,    1, null],
		[null, null,    1, null, null],
	]
	
