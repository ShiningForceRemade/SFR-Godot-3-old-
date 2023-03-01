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
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene_to_file("res://SF1/Chapters/1/Battle2/Overworld.tscn")


func _on_KingsCastleEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene Guardiana Kings Castle")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene_to_file("res://SF1/Chapters/1/Guardiana/Castle/Castle.tscn")


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


var entered: bool = false
func _on_TownGuardExitCheckArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("C1 - Kings Permission - ", Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.kings_permission)
		if !entered:
			entered = true
			if !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.kings_permission:
				# Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.kings_permission = true
				Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
				var guard_left_node = get_parent().get_node("NpcWrapperNode/SoldierGuardLeftNPCRoot").get_child(0)
				var guard_right_node = get_parent().get_node("NpcWrapperNode/SoldierGuardRightNPCRoot").get_child(0)
			
				guard_left_node.set_movement_speed_timer(0.1)
				guard_right_node.set_movement_speed_timer(0.1)
			
				for i in 3:
					guard_left_node.tester__move_in_direction("Right")
					guard_right_node.tester__move_in_direction("Left")
					await get_tree().create_timer(0.1).timeout
				
				guard_left_node.change_facing_direction_string("UpMovement")
				guard_right_node.change_facing_direction_string("UpMovement")
				
				Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
			
			else:
				Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
				var guard_left_node = get_parent().get_node("NpcWrapperNode/SoldierGuardLeftNPCRoot").get_child(0)
				var guard_right_node = get_parent().get_node("NpcWrapperNode/SoldierGuardRightNPCRoot").get_child(0)
			
				guard_left_node.set_movement_speed_timer(0.1)
				guard_right_node.set_movement_speed_timer(0.1)
			
				for i in 2:
					guard_left_node.tester__move_in_direction("Right")
					guard_right_node.tester__move_in_direction("Left")
					await get_tree().create_timer(0.1).timeout
				
				guard_left_node.change_facing_direction_string("UpMovement")
				guard_right_node.change_facing_direction_string("UpMovement")
				
				Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
			



func _on_TrolleyActionSpotArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		if !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.guardiana_trolley_pushed:
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.guardiana_trolley_pushed = true
			var trolley_node = get_parent().get_node("NpcWrapperNode").get_node("TrolleyNPCRoot").get_child(0)
			var trolley_man_node = get_parent().get_node("NpcWrapperNode/ManRunFromTrolleyNPCRoot").get_child(0)
			
			trolley_node.set_movement_speed_timer(0.1)
			trolley_man_node.set_movement_speed_timer(0.1)
			
			trolley_node.tester__move_in_direction("Left")
			await get_tree().create_timer(0.1).timeout
	
			trolley_node.tester__move_in_direction("Left")
			await get_tree().create_timer(0.1).timeout
	
			trolley_node.tester__move_in_direction("Left")
			trolley_man_node.tester__move_in_direction("Down")
			await get_tree().create_timer(0.1).timeout
			
			trolley_node.tester__move_in_direction("Left")
			trolley_man_node.tester__move_in_direction("Down")
			await get_tree().create_timer(0.1).timeout
			
			trolley_node.reset_movement_speed_timer()
			trolley_man_node.reset_movement_speed_timer()


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
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			for i in 5:
				guard.tester__move_in_direction("Left")
				await guard.tween.finished
			for i in 4:
				guard.tester__move_in_direction("Down")
				await guard.tween.finished
			
			Singleton_Game_GlobalCommonVariables.main_character_player_node.MoveInDirection("Down")
			guard.tester__move_in_direction("Down")
			await guard.tween.finished
			
			guard.change_facing_direction_string("LeftMovement")
			Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("UpMovement")
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/VariosOpening3.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			
			guard.tester__move_in_direction("Up")
			varios.tester__move_in_direction("Right")
			# await guard.tween.finished
			await varios.tween.finished
			
			# for i in 4:
			for i in 6:
				guard.tester__move_in_direction("Up")
				varios.tester__move_in_direction("Up")
				# await guard.tween.finished
				await varios.tween.finished
			
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
			await lowe.tween.finished
			lowe.tester__move_in_direction("Left")
			await lowe.tween.finished
			lowe.tester__move_in_direction("Down")
			await lowe.tween.finished
			lowe.tester__move_in_direction("Left")
			await lowe.tween.finished
			lowe.tester__move_in_direction("Left")
			await lowe.tween.finished
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			# Singleton_Game_GlobalCommonVariables.interaction_node_reference = self
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/LoweOpening.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
			
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_lowe = true
			# lowe.reset_movement_speed_timer()



func _on_ForceJoinsArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		if Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.accepted_kings_plan && !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.initial_force_joined:
			Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.initial_force_joined = true
			
			var pn = get_parent()
			
			var luke = pn.get_node("NpcWrapperNode/LukeNPCRoot").get_child(0)
			var ken  = pn.get_node("NpcWrapperNode/KenNPCRoot").get_child(0)
			var tao  = pn.get_node("NpcWrapperNode/TaoNPCRoot").get_child(0)
			var hans = pn.get_node("NpcWrapperNode/HansNPCRoot").get_child(0)
			var lowe = pn.get_node("NpcWrapperNode/LoweNPCRoot2").get_child(0)
			var nova = pn.get_node("NpcWrapperNode/NovaNPCRoot").get_child(0)
			
			luke.set_movement_speed_timer(0.1)
			ken.set_movement_speed_timer(0.1)
			tao.set_movement_speed_timer(0.1)
			hans.set_movement_speed_timer(0.1)
			lowe.set_movement_speed_timer(0.1)
			nova.set_movement_speed_timer(0.1)
			
			Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("UpMovement")
			
			for i in 14:
				luke.tester__move_in_direction("Down")
				ken.tester__move_in_direction("Down")
				tao.tester__move_in_direction("Down")
				hans.tester__move_in_direction("Down")
				await get_tree().create_timer(0.1).timeout
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/InitialForceJoinsPart1.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			for i in 14:
				luke.tester__move_in_direction("Up")
				ken.tester__move_in_direction("Up")
				tao.tester__move_in_direction("Up")
				hans.tester__move_in_direction("Up")
				await get_tree().create_timer(0.1).timeout
			
			for i in 14:
				lowe.tester__move_in_direction("Down")
				await get_tree().create_timer(0.1).timeout
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/InitialForceJoinsPart2.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			for i in 16:
				nova.tester__move_in_direction("Down")
				await get_tree().create_timer(0.1).timeout
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/InitialForceJoinsPart3.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			for i in 16:
				nova.tester__move_in_direction("Up")
				lowe.tester__move_in_direction("Up")
				await get_tree().create_timer(0.1).timeout
			
			var fm_idx = Singleton_Game_GlobalCommonVariables.sf_game_data_node.E_SF1_FM.LUKE
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
			fm_idx = Singleton_Game_GlobalCommonVariables.sf_game_data_node.E_SF1_FM.KEN
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
			fm_idx = Singleton_Game_GlobalCommonVariables.sf_game_data_node.E_SF1_FM.TAO
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
			fm_idx = Singleton_Game_GlobalCommonVariables.sf_game_data_node.E_SF1_FM.HANS
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
			fm_idx = Singleton_Game_GlobalCommonVariables.sf_game_data_node.E_SF1_FM.LOWE
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
			
			Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)

