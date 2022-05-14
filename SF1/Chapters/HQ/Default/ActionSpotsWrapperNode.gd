extends Node

# var roof_wrapper_node = null

func _ready():
	
	# roof_wrapper_node = get_parent().get_node("RoofsWrapperNode")
	
	pass


# TODO: store returning location in a global variable
# also need to include the spawn position when returning
func _on_ExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene Guardiana Kings Castle")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene("res://SF1/Chapters/1/Battle2/Overworld.tscn")
