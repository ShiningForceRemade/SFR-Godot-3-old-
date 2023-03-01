extends Node2D

var stationary
var facing_direction

@onready var npcBaseRoot = get_child(0)

func _ready():
	stationary = npcBaseRoot.stationary
	pass


func attempt_to_interact() -> void:
	if !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_varios:
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
	
		# get facing direction prior to talk interaction
		facing_direction = npcBaseRoot.get_facing_direction()
		var ofd = Singleton_Game_GlobalCommonVariables.main_character_player_node.GetOppositePlayerFacingDirection()
		npcBaseRoot.change_facing_direction_string(ofd)
		npcBaseRoot.stationary = true
		Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
		Singleton_Game_GlobalCommonVariables.interaction_node_reference = self
		
		# first talk
		Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/VariosOpening.json"
		# second talk
		Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/VariosOpening2.json"
		
		Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
		
	else:
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
		# Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_varios = true
		
		Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
		Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/LoweOpening2.json"
		Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
		
		await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
		
		LoweLeavesForCastle()



func interaction_completed() -> void:
	Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	
	npcBaseRoot.stationary = stationary
	npcBaseRoot.change_facing_direction_string(facing_direction)
	Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
	Singleton_Game_GlobalCommonVariables.interaction_node_reference = null


func LoweLeavesForCastle() -> void:
	var lowe = get_child(0)
	lowe.set_movement_speed_timer(0.15)
	
	lowe.tester__move_in_direction("Right")
	await get_tree().create_timer(0.15).timeout
	
	for i in 6:
		lowe.tester__move_in_direction("Down")
		await get_tree().create_timer(0.15).timeout
	for i in 4:
		lowe.tester__move_in_direction("Right")
		await get_tree().create_timer(0.15).timeout
	for i in 7:
		lowe.tester__move_in_direction("Down")
		await get_tree().create_timer(0.15).timeout
	for i in 12:
		lowe.tester__move_in_direction("Right")
		await get_tree().create_timer(0.15).timeout
	for i in 17:
		lowe.tester__move_in_direction("Up")
		await get_tree().create_timer(0.15).timeout
		# await lowe.tween.finished
	
	queue_free()
