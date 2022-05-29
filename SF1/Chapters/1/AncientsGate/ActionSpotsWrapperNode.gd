extends Node

func _ready():
	pass


func _on_ExitToOverworldArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene outside Guardiana Overworld")
		Singleton_Game_GlobalCommonVariables.position_location_st = "Overworld_Ancients_Gate"
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene("res://SF1/Chapters/1/Battle2/Overworld.tscn")
