extends Node


func _ready():
	# roof_wrapper_node = get_parent().get_node("RoofsWrapperNode")
	pass


func _on_HQEntranceArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene HQ")
		Singleton_Game_GlobalCommonVariables.position_location_st = "Alterone-Castle-Basement__HQ"
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene_to_file("res://SF1/Chapters/HQ/Default/HeadQuarters.tscn")

