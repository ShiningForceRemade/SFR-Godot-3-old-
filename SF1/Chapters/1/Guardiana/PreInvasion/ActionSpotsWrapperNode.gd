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
		Singleton_Game_GlobalCommonVariables.position_location_st = "Overworld_Guardiana_Castle"
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene("res://SF1/Chapters/1/Battle2/Overworld.tscn")


func _on_KingsCastleEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene Guardiana Kings Castle")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene("res://SF1/Chapters/1/Guardiana/Castle/Castle.tscn")
		


var trolley_scene_played_out = false
func _on_TrolleyActionSpotArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		if !trolley_scene_played_out:
			var trolley_node = get_parent().get_node("NpcWrapperNode").get_node("TrolleyNPCRoot").get_child(0)
			var trolley_man_node = get_parent().get_node("NpcWrapperNode").get_node("TrolleyManNPCRoot").get_child(0)
			
			trolley_node.set_movement_speed_timer(0.1)
			trolley_man_node.set_movement_speed_timer(0.1)
			
			# TODO: FIX: trolley man doesnt move
			trolley_node.tester__move_in_direction("Left")
			trolley_man_node.tester__move_in_direction("Down")
			yield(trolley_man_node, "signal_move_direction_completed")
			trolley_node.tester__move_in_direction("Left")
			yield(trolley_node, "signal_move_direction_completed")
			trolley_node.tester__move_in_direction("Left")
			trolley_man_node.tester__move_in_direction("Down")
			yield(trolley_node, "signal_move_direction_completed")
			yield(trolley_man_node, "signal_move_direction_completed")
			trolley_node.tester__move_in_direction("Left")
			
			trolley_node.reset_movement_speed_timer()
			trolley_man_node.reset_movement_speed_timer()
			# Pause player
			# start torlley animation
			# move trolley
			# move npc
			# stop torlley animation
			# return player control
		
			trolley_scene_played_out = true
		
			# pass
	
			print("Trolley Action")
	
	pass # Replace with function body.


func _on_FamilyHouseEntranceArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("FamilyHouse").hide()

func _on_FamilyHouseExitArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("FamilyHouse").show()


func _on_SoliderHouseEntranceArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("SoldierHouse").hide()

func _on_SoliderHouseExitArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("SoldierHouse").show()


func _on_GortHouseEntranceArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("GortsHouse").hide()

func _on_GortHouseExitArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("GortsHouse").show()


func _on_InnEntranceArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Inn").hide()

func _on_InnExitArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Inn").show()


func _on_TownGuardExitCheckArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("C1 - Kings Permission - ", Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.kings_permission)
	
