extends CN_SF_UseRange

const tile_size: int = 24
const half_tile: int = tile_size / 2

func _ready():
	print("In here not base")
	pass

func draw_use_range():
	# print("UseRange_1 - vpos - ", vposz, " FieldLogicNode - ", fieldLogicNode)
	var uttwn = Singleton_Game_GlobalBattleVariables.field_logic_node.get_node("UseTargetTilesWrapperNode")
	
	for n in uttwn.get_children():
		uttwn.remove_child(n)
		n.queue_free()
	
	var vpos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
	vpos.x -= half_tile
	vpos.y -= half_tile
	
	# center tile
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		center_segment,
		vpos.x,
		vpos.y,
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

	# X 1 X
	# 1 X 1
	# X 1 X
#	return [
#		[null, 1,    null],
#		[1,    null, 1],
#		[null, 1,    null],
#		]
	
	print("\n")
	

func get_use_range_array_representation() -> Array:
	return [
		[null,    1, null],
		[1,       1,    1],
		[null,    1, null],
	]
