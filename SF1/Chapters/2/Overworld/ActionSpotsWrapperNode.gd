extends Node


func _ready():
	pass


#func _on_ExitToOverworldArea2D_body_entered(body) -> void:
#	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
#		print("Change Scene outside Guardiana")
#		Singleton_Game_GlobalCommonVariables.position_location_st = "Overworld_Cabin"
#		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene_to_file("res://SF1/Chapters/1/Battle2/Overworld.tscn")
#
#
#func _on_EntranceCabinArea2D_body_entered(body) -> void:
#	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
#		roof_wrapper_node.hide()
#
#
#func _on_ExitCabinArea2D_body_entered(body) -> void:
#	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
#		roof_wrapper_node.show()


func _on_RindoArea2D_body_entered(body):
	pass # Replace with function body.


func _on_MagicSchoolArea2D_body_entered(body):
	pass # Replace with function body.


func _on_ShadeAbbeyArea2D_body_entered(body):
	pass # Replace with function body.
