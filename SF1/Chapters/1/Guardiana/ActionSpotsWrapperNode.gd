extends Node

var roof_wrapper_node = null

func _ready():
	
	roof_wrapper_node = get_parent().get_node("RoofsWrapperNode")
	
	pass


func _on_LeftEntranceChurchArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Church").hide()


func _on_LeftExitChurchArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Church").show()


func _on_MainEntranceChurchArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Church").hide()


func _on_MainExitChurchArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Church").show()


func _on_BarEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Bar").hide()


func _on_BarExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Bar").show()


func _on_ShopEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Shop").hide()


func _on_ShopExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Shop").show()


func _on_ExitGuardianaArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene outside Guardiana")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene("res://SF1/Chapters/1/Battle2/Overworld.tscn")


func _on_KingsCastleEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene Guardiana Kings Castle")
