extends Node2D

func _ready():
	pass


func attempt_to_interact() -> void:
	var ofd = Singleton_Game_GlobalCommonVariables.main_character_player_node.GetOppositePlayerFacingDirection()
	get_child(0).change_facing_direction_string(ofd)
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
	Singleton_Game_GlobalCommonVariables.interaction_node_reference = self
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GongsHouse/Scripts/Gong.json"
	Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()


func interaction_completed() -> void:
	Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
	Singleton_Game_GlobalCommonVariables.interaction_node_reference = null
		
	Singleton_Game_GlobalCommonVariables.main_character_player_node.MoveInDirection("Left")
	
	var gong = self.get_child(0)
	gong.set_movement_speed_timer(0.2)
	
	for i in 5:
		gong.tester__move_in_direction("Down")
		yield(gong.tween, "tween_completed")
	for i in 4:
		gong.tester__move_in_direction("Right")
		yield(gong.tween, "tween_completed")
	for i in 4:
		gong.tester__move_in_direction("Down")
		yield(gong.tween, "tween_completed")
	
	for i in 5:
		gong.tester__move_in_direction("Left")
		yield(gong.tween, "tween_completed")
		gong.tester__move_in_direction("Down")
		yield(gong.tween, "tween_completed")
		
	gong.tester__move_in_direction("Down")
	yield(gong.tween, "tween_completed")
