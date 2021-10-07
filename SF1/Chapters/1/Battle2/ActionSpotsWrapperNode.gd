extends Node

var scene__guardiana = "res://SF1/Chapters/1/Guardiana/Guardiana.tscn"
var scene__alterone = "res://SF1/Chapters/1/Guardiana/Guardiana.tscn"
var scene__ancients_gate = "res://SF1/Chapters/1/Guardiana/Guardiana.tscn"
var scene__gongs_house = "res://SF1/Chapters/1/Guardiana/Guardiana.tscn"

func _ready():
	pass


func _on_AlteroneEntranceArea2D_body_entered(body) -> void:
	print("test")
	
	return
	
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene outside Guardiana")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene(scene__guardiana)


func _on_ExitGuardianaArea2D_body_entered(body) -> void:
	
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene outside Guardiana")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene(scene__guardiana)
