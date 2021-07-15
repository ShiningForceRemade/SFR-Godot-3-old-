extends CN_SF_TargetRange

func _ready():
	pass

func draw_cursor_and_get_targets(center_actor_target_selected):
	print(center_actor_target_selected)
	
	bc_cursor_ref = Sprite.new()
	bc_cursor_ref.texture = load("res://Assets/SF1/ShiningForceCursor.png")
	bc_cursor_ref.position = Singleton_Game_GlobalBattleVariables.currently_active_character.position
	#sprite.position.x -= 12
	#sprite.position.y -= 12
	
	bc_cursor_ref.position.x -= 24
	
	Singleton_Game_GlobalBattleVariables.field_logic_node.add_child(bc_cursor_ref)	
	
	pass

func draw_cursor_at_position(new_pos_arg: Vector2) -> void:
	bc_cursor_ref.position = new_pos_arg

func cleanup_cursor() -> void:
	bc_cursor_ref.queue_free()
