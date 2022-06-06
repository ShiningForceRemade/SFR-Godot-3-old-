extends Node2D

export var DefaultScript: String = ""
export var PostSpokenToKingScript: String = ""
export var PostForceHasJoinedScript: String = ""
export var PostInvasionScript: String = ""
export var PostKingsDeathScript: String = ""

var stationary
var facing_direction
var interacting: bool = false

onready var npcBaseRoot = get_child(0)

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
	
	
	print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.kings_permission)
	print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.initial_force_joined)
	
	var script_path = ""
	if !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_the_king:
		script_path = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/Planning.json"
		Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_the_king = true
	elif Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_the_king && !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.accepted_kings_plan:
		script_path = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/KingRejected.json"
		# Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.accepted_kings_plan = true
	elif !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.initial_force_joined && Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_the_king && Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.accepted_kings_plan:
		script_path = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/KingAfterAcceptingPlan.json"
	elif Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.kings_permission:
		script_path = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/KingPostForceJoinTalk.json"
	elif !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.kings_permission && Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.initial_force_joined:
		script_path = "res://SF1/Chapters/1/Guardiana/Castle/Scripts/KingPostForceJoin.json"
		Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.kings_permission = true
		Singleton_Game_GlobalCommonVariables.gold += 100
	
	# script_path += DefaultScript
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = script_path
	Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
	
	yield(Singleton_Game_GlobalCommonVariables.dialogue_box_node, "signal__dialogbox__finished_dialog")
	
	if Singleton_Game_GlobalCommonVariables.interaction_yes_or_no_selection != null:
		match Singleton_Game_GlobalCommonVariables.interaction_yes_or_no_selection:
			"YES": Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.accepted_kings_plan = true
		
		Singleton_Game_GlobalCommonVariables.interaction_yes_or_no_selection = null
	
	Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false


func interaction_completed() -> void:
	Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	
	npcBaseRoot.stationary = stationary
	npcBaseRoot.change_facing_direction_string(facing_direction)
	Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
	Singleton_Game_GlobalCommonVariables.interaction_node_reference = null

