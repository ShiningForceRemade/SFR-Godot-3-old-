extends CN_SF_UseRange

const tile_size: int = 24
const half_tile: int = tile_size / 2

func _ready():
	print("In here not base")
	pass

static func draw_use_range():
	# print("UseRange_1 - vpos - ", vposz, " FieldLogicNode - ", fieldLogicNode)
	
	for n in Singleton_Game_GlobalBattleVariables.field_logic_node.get_children():
		Singleton_Game_GlobalBattleVariables.field_logic_node.remove_child(n)
		n.queue_free()
	
	var vpos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
	vpos.x -= half_tile
	vpos.y -= half_tile
	
	# Top tile
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		Color.purple,
		vpos.x,
		vpos.y - tile_size
	)

	# Bottom tile
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		Color.purple,
		vpos.x,
		vpos.y + tile_size
	)

	# Left tile
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		Color.purple,
		vpos.x - tile_size,
		vpos.y
	)

	# Right tile
	Singleton_Game_GlobalBattleVariables.field_logic_node.draw_flashing_movement_square(
		Color.purple,
		vpos.x + tile_size,
		vpos.y
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
	

