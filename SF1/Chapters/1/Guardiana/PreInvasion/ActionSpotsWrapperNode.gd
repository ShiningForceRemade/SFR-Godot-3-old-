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
	



func _on_VariosArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		if !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_varios && Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_lowe:
			Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_varios = true
			
			var pn = get_parent()
		
			var varios = pn.VariosRoot.get_child(0)
			var guard = pn.GuardRoot.get_child(0)
			pn.GuardRoot.show()
			varios.set_movement_speed_timer(0.15)
			guard.set_movement_speed_timer(0.15)
			guard.show()
			
			varios.change_facing_direction_string("RightMovement")
			Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("LeftMovement")
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/VariosOpening2.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			yield(Singleton_Game_GlobalCommonVariables.dialogue_box_node, "signal__dialogbox__finished_dialog")
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			for i in 5:
				guard.tester__move_in_direction("Left")
				yield(guard.tween, "tween_completed")
			for i in 4:
				guard.tester__move_in_direction("Down")
				yield(guard.tween, "tween_completed")
			
			Singleton_Game_GlobalCommonVariables.main_character_player_node.MoveInDirection("Down")
			guard.tester__move_in_direction("Down")
			yield(guard.tween, "tween_completed")
			
			guard.change_facing_direction_string("LeftMovement")
			Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("UpMovement")
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/VariosOpening3.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			yield(Singleton_Game_GlobalCommonVariables.dialogue_box_node, "signal__dialogbox__finished_dialog")
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			
			guard.tester__move_in_direction("Up")
			varios.tester__move_in_direction("Right")
			# yield(guard.tween, "tween_completed")
			yield(varios.tween, "tween_completed")
			
			# for i in 4:
			for i in 6:
				guard.tester__move_in_direction("Up")
				varios.tester__move_in_direction("Up")
				# yield(guard.tween, "tween_completed")
				yield(varios.tween, "tween_completed")
			
			# pn.VariosRoot.queue_free()
			# pn.GuardRoot.queue_free()
			
			pn.VariosRoot.hide()
			pn.GuardRoot.hide()
			
			Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)


func _on_LoweTalkSpotArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		if !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_lowe:
			Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
			var pn = get_parent()
		
			var lowe = pn.LoweRoot.get_child(0)
			lowe.set_movement_speed_timer(0.15)
	
			lowe.tester__move_in_direction("Left")
			yield(lowe.tween, "tween_completed")
			lowe.tester__move_in_direction("Left")
			yield(lowe.tween, "tween_completed")
			lowe.tester__move_in_direction("Down")
			yield(lowe.tween, "tween_completed")
			lowe.tester__move_in_direction("Left")
			yield(lowe.tween, "tween_completed")
			lowe.tester__move_in_direction("Left")
			yield(lowe.tween, "tween_completed")
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			# Singleton_Game_GlobalCommonVariables.interaction_node_reference = self
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/LoweOpening.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			yield(Singleton_Game_GlobalCommonVariables.dialogue_box_node, "signal__dialogbox__finished_dialog")
			Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
			
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_lowe = true
			# lowe.reset_movement_speed_timer()

