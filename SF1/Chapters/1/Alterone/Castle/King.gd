extends Node2D

@export var DefaultScript: String = ""
#export var PostSpokenToKingScript: String = ""
#export var PostForceHasJoinedScript: String = ""
#export var PostInvasionScript: String = ""
#export var PostKingsDeathScript: String = ""

var stationary
var facing_direction
var interacting: bool = false

@onready var pn = get_parent().get_parent()
@onready var npcBaseRoot = get_child(0)

func _ready():
	stationary = npcBaseRoot.stationary
	pass


func attempt_to_interact() -> void:
	if interacting:
		return
	
	interacting = true
	
	Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
	
	# get facing direction prior to talk interaction
	facing_direction = npcBaseRoot.get_facing_direction()
	var ofd = Singleton_Game_GlobalCommonVariables.main_character_player_node.GetOppositePlayerFacingDirection()
	npcBaseRoot.change_facing_direction_string(ofd)
	npcBaseRoot.stationary = true
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
	Singleton_Game_GlobalCommonVariables.interaction_node_reference = self
	
	# pn
	
	var script_path = DefaultScript
	if !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_alterone_king_post_guardiana_invasion:
		Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_alterone_king_post_guardiana_invasion = true
		script_path = "res://SF1/Chapters/1/Alterone/Castle/Scripts/KingInitial.json"
	else:
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
		interacting = false
		return
	# elif !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.battle_4_complete:
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = script_path
	Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	
	if !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_kane_alterone:
		var move_time = 0.125
		npcBaseRoot.set_movement_speed_timer(move_time)
		Singleton_Game_GlobalCommonVariables.main_character_player_node.movement_tween_speed = 0.1
		
		Singleton_Game_GlobalCommonVariables.main_character_player_node.MoveInDirection("Left")
		# Singleton_Game_GlobalCommonVariables.main_character_player_node.
		await get_tree().create_timer(move_time).timeout
		
		for i in 3:
			npcBaseRoot.tester__move_in_direction("Down")
			await get_tree().create_timer(move_time).timeout
		
		
		npcBaseRoot.tester__move_in_direction("Right")
		pn.SoliderDoor.get_child(0).tester__move_in_direction("Right")
		await get_tree().create_timer(move_time).timeout
		pn.SoliderDoor.get_child(0).change_facing_direction_string("LeftMovement")
		
		Singleton_Game_GlobalCommonVariables.main_character_player_node.reset_movement_speed()
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
		interacting = false
		
		for i in 7:
			npcBaseRoot.tester__move_in_direction("Right")
			await get_tree().create_timer(move_time).timeout
		
		for i in 6:
			npcBaseRoot.tester__move_in_direction("Up")
			await get_tree().create_timer(move_time).timeout
		
		npcBaseRoot.tester__move_in_direction("Right")
		await get_tree().create_timer(move_time).timeout
		
		npcBaseRoot.queue_free()
	
	Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false


func interaction_completed() -> void:
	Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	
	npcBaseRoot.stationary = stationary
	npcBaseRoot.change_facing_direction_string(facing_direction)
	Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
	Singleton_Game_GlobalCommonVariables.interaction_node_reference = null

