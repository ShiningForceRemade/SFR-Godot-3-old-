extends Node

var roof_wrapper_node = null

func _ready():
	roof_wrapper_node = get_parent().get_node("RoofsWrapperNode")
	pass


func _on_LeftEntranceChurchArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		roof_wrapper_node.get_node("Church").hide()




func _on_ExitGuardianaArea2D_body_entered(body) -> void:
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene outside Guardiana")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene("res://SF1/Chapters/1/Battle2/Overworld.tscn")


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
		InsideThroneRoom()

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
		
		yield(Singleton_Game_GlobalCommonVariables.dialogue_box_node, "signal__dialogbox__finished_dialog")
		Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
		Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
		
		for i in 2:
			varios.tester__move_in_direction("Down")
			yield(varios.tween, "tween_completed")
		for i in 2:
			varios.tester__move_in_direction("Right")
			yield(varios.tween, "tween_completed")
		
		varios.change_facing_direction_string("LeftMovement")
		
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)


func _on_GuardianaTownExitArea2D_body_entered(body):
	if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
		print("Change Scene outside Guardiana")
		Singleton_Game_GlobalCommonVariables.scene_manager_node.change_scene("res://SF1/Chapters/1/Guardiana/PreInvasion/Guardiana.tscn")
