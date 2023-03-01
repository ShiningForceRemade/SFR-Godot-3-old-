extends Node

var roof_wrapper_node = null

func _ready():
	roof_wrapper_node = get_parent().get_node("RoofsWrapperNode")
	pass


func _on_ExitGuardianaArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene outside Guardiana")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene_to_file("res://SF1/Chapters/1/Battle2/Overworld.tscn")


func _on_KingsCastleEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene Guardiana Kings Castle")



func _on_MainCastleEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Castle").hide()

func _on_MainCastleExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Castle").show()

func _on_SideCastleEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Castle").hide()

func _on_SideCastleExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Castle").show()

func _on_HQEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Castle").hide()

func _on_HQExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Castle").show()


func _on_HouseEntranceArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("House").hide()

func _on_HouseExitArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("House").show()



func _on_InsideThroneTopArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		InsideThroneRoom()

func _on_InsideThroneBottomArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		if !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.kane_cutscene_guardiana_castle_played:
			Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.kane_cutscene_guardiana_castle_played = true
			
			var pn = get_parent()
			
			var minister = pn.get_node("NpcWrapperNode/MinisterNPCRoot").get_child(0)
			var varios = pn.get_node("NpcWrapperNode/VariosNPCRoot").get_child(0)
			var king = pn.get_node("NpcWrapperNode/KingNPCRoot").get_child(0)
			var kane = pn.get_node("NpcWrapperNode/KaneNPCRoot").get_child(0)
			var mae = pn.get_node("NpcWrapperNode/MaeNPCRoot").get_child(0)
			
			minister.set_movement_speed_timer(0.1)
			varios.set_movement_speed_timer(0.1)
			king.set_movement_speed_timer(0.1)
			kane.set_movement_speed_timer(0.1)
			mae.set_movement_speed_timer(0.1)
			Singleton_Game_GlobalCommonVariables.main_character_player_node.movement_tween_speed = 0.1
			
			for i in 6:
				minister.tester__move_in_direction("Down")
				await get_tree().create_timer(0.1).timeout
			
			# Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("UpMovement")
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/PostInvasion/Minister.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			for i in 7:
				minister.tester__move_in_direction("Up")
				Singleton_Game_GlobalCommonVariables.main_character_player_node.MoveInDirection("Up")
				await get_tree().create_timer(0.1).timeout
			
			minister.tester__move_in_direction("Right")
			Singleton_Game_GlobalCommonVariables.main_character_player_node.MoveInDirection("Up")
			await get_tree().create_timer(0.1).timeout
			
			minister.tester__move_in_direction("Right")
			Singleton_Game_GlobalCommonVariables.main_character_player_node.MoveInDirection("Up")
			await get_tree().create_timer(0.1).timeout
			
			minister.change_facing_direction_string("UpMovement")
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/PostInvasion/CutscenePart1.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			
			#
			# TODO: monochrome filter for kane killing varios
			#
			
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/PostInvasion/CutscenePart2.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			# varios dies animation start
			varios.hide()
			await get_tree().create_timer(0.2).timeout
			
			varios.show()
			await get_tree().create_timer(0.2).timeout
			
			varios.hide()
			await get_tree().create_timer(0.1).timeout
			
			varios.show()
			await get_tree().create_timer(0.1).timeout
			
			varios.queue_free()
			# varios dies animation end
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/PostInvasion/CutscenePart3.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			minister.change_facing_direction_string("DownMovement")
			kane.change_facing_direction_string("DownMovement")
			Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("DownMovement")
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/PostInvasion/CutscenePart4.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			# TODO: complete Mae cutscene
			for i in 3:
				mae.tester__move_in_direction("Down")
				await get_tree().create_timer(0.1).timeout
			
			for i in 9:
				mae.tester__move_in_direction("Right")
				await get_tree().create_timer(0.1).timeout
			
			for i in 5:
				mae.tester__move_in_direction("Up")
				await get_tree().create_timer(0.1).timeout
			
			minister.change_facing_direction_string("UpMovement")
			Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("UpMovement")
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/PostInvasion/CutscenePart5.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			# kane disappears animation start
			kane.hide()
			await get_tree().create_timer(0.2).timeout
			
			kane.show()
			await get_tree().create_timer(0.2).timeout
			
			kane.hide()
			await get_tree().create_timer(0.1).timeout
			
			kane.show()
			await get_tree().create_timer(0.1).timeout
			
			kane.queue_free()
			# kane disappears animation end
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/PostInvasion/CutscenePart6.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			mae.tester__move_in_direction("Left")
			Singleton_Game_GlobalCommonVariables.main_character_player_node.MoveInDirection("Left")
			await get_tree().create_timer(0.1).timeout
			
			for i in 2:
				mae.tester__move_in_direction("Up")
				Singleton_Game_GlobalCommonVariables.main_character_player_node.MoveInDirection("Up")
				await get_tree().create_timer(0.1).timeout
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/PostInvasion/CutscenePart7.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			# king dies animation start
			king.hide()
			await get_tree().create_timer(0.2).timeout
			
			king.show()
			await get_tree().create_timer(0.2).timeout
			
			king.hide()
			await get_tree().create_timer(0.1).timeout
			
			king.show()
			await get_tree().create_timer(0.1).timeout
			
			king.queue_free()
			# king dies animation end
			
			mae.change_facing_direction_string("LeftMovement")
			Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("RightMovement")
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/PostInvasion/CutscenePart8.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			
			await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
			
			var fm_idx = Singleton_Game_GlobalCommonVariables.sf_game_data_node.E_SF1_FM.MAE
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
			Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
			
			
			for i in 15:
				mae.tester__move_in_direction("Down")
				await get_tree().create_timer(0.1).timeout
			
			Singleton_Game_GlobalCommonVariables.main_character_player_node.reset_movement_speed()
			Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
			
			for i in 4:
				mae.tester__move_in_direction("Left")
				await get_tree().create_timer(0.1).timeout
			
			mae.tester__move_in_direction("Down")
			await get_tree().create_timer(0.1).timeout
			
			for i in 4:
				mae.tester__move_in_direction("Left")
				await get_tree().create_timer(0.1).timeout
				
			for i in 4:
				mae.tester__move_in_direction("Up")
				await get_tree().create_timer(0.1).timeout
			
			mae.tester__move_in_direction("Left")
			await get_tree().create_timer(0.1).timeout
			
			mae.queue_free()










func InsideThroneRoom() -> void:
	if !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.entered_kings_throne:
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
		Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.entered_kings_throne = true
		
		var pn = get_parent()
	
		var varios = pn.get_node("NpcWrapperNode/VariosNPCRoot").get_child(0)
		
		varios.set_movement_speed_timer(0.15)
		
		
		# varios.change_facing_direction_string("RightMovement")
		# Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("LeftMovement")
		
		Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
		Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/MeetingWithTheKing.json"
		Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
		
		await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
		Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
		
		for i in 2:
			varios.tester__move_in_direction("Down")
			await varios.tween.finished
		for i in 2:
			varios.tester__move_in_direction("Right")
			await varios.tween.finished
		
		varios.change_facing_direction_string("LeftMovement")
		
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)


func _on_GuardianaTownExitArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene Guardiana")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene_to_file("res://SF1/Chapters/1/Guardiana/Guardiana.tscn")
