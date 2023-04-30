extends CN_SF_TargetRange

func _ready():
	pass

func draw_cursor_at_position(position_arg: Vector2):
	print(position_arg)
	
	bc_cursor_ref = load("res://General/BattleLogic/Cursor/Cursor/Cursor.tscn").instantiate()
	bc_cursor_ref.position = position_arg # Singleton_CommonVariables.battle__currently_active_actor.get_child(0).global_position
	
	Singleton_CommonVariables.battle__target_selection_cursor = bc_cursor_ref
	Singleton_CommonVariables.battle__logic_node.add_child(bc_cursor_ref)


func cleanup_cursor() -> void:
	# if bc_cursor_ref.get_ref():
	bc_cursor_ref.queue_free()


func array_representation():
	return [
		[ 1 ]
	]
