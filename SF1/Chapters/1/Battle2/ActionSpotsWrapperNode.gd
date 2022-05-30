extends Node

var scene__guardiana = "res://SF1/Chapters/1/Guardiana/Guardiana.tscn"
var scene__alterone = "res://SF1/Chapters/1/Alterone/Alterone_Town.tscn"
var scene__ancients_gate = "res://SF1/Chapters/1/AncientsGate/AncientsGate.tscn"

# TODO: probably should rename gongs_house to cabin to be consistent with the naming used ingame
var scene__gongs_house = "res://SF1/Chapters/1/GongsHouse/GongsHouse.tscn"

func _ready():
	pass


func _on_AlteroneEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene - SF1 C1 - Alterone")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene(scene__alterone)


func _on_GuardianaEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene - SF1 C1 - Guardiana")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene(scene__guardiana)


func _on_AncientsGateEntranceArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene - SF1 C1 - Ancients Gate")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene(scene__ancients_gate)


func _on_CabinEntranceArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene - SF1 C1 - Cabin (Gong Location)")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene(scene__gongs_house)

