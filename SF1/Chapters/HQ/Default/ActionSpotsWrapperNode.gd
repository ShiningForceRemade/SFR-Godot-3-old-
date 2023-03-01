extends Node

# var roof_wrapper_node = null

func _ready():
	
	# roof_wrapper_node = get_parent().get_node("RoofsWrapperNode")
	
	pass


# TODO: store returning location in a global variable
# also need to include the spawn position when returning
func _on_ExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		match Singleton_Game_GlobalCommonVariables.position_location_st:
			"Alterone-Castle-Basement__HQ":
				print("Change Scene Alterone Town HQ Entrance")
				Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene_to_file("res://SF1/Chapters/1/Alterone/Castle_Basement/Alterone_Castle_Basement.tscn")
			
			_:
				print("Change Scene Guardiana Kings Castle HQ Entrance")
				Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene_to_file("res://SF1/Chapters/1/Guardiana/Castle/Castle.tscn")
