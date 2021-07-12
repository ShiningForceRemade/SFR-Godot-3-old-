extends CN_SF_TargetRange

func _ready():
	pass

static func draw_cursor_and_get_targets(center_actor_target_selected):
	print(center_actor_target_selected)
	
	var sprite = Sprite.new()
	sprite.texture = load("res://Assets/SF1/ShiningForceCursor.png")
	sprite.position = Singleton_Game_GlobalBattleVariables.currently_active_character.position
	#sprite.position.x -= 12
	#sprite.position.y -= 12
	
	sprite.position.x -= 24
	
	Singleton_Game_GlobalBattleVariables.field_logic_node.add_child(sprite)	
	
	pass

