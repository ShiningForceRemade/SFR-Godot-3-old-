extends Node


func _ready():
	pass


# TODO: store returning location in a global variable
# also need to include the spawn position when returning
func _on_hq_exit_area_2d_body_entered(body: Node2D) -> void:
	if body == Singleton_CommonVariables.main_character_active_kinematic_body_node:
		
		match Singleton_CommonVariables.position_location_st:
			"Alterone-Castle-Basement__HQ":
				print("Change Scene Alterone Town HQ Entrance")
				Singleton_CommonVariables.scene_manager_node.change_scene("res://SF1/Chapters/1/Alterone/Castle_Basement/Alterone_Castle_Basement.tscn")
			
			_:
				print("Change Scene Guardiana Kings Castle HQ Entrance")
				Singleton_CommonVariables.scene_manager_node.change_scene("res://SF1/Chapters/1/Guardiana/Castle/Castle.tscn")

