extends Node2D

var stationary
var facing_direction

@onready var npcBaseRoot = get_child(0).get_child(0)

var actor_name_pulled_from_node: String

func _ready():
	actor_name_pulled_from_node = name.substr(0, name.length() - 3)
	stationary = npcBaseRoot.stationary
	pass


func attempt_to_interact() -> void:
	Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	
	# get facing direction prior to talk interaction
	facing_direction = npcBaseRoot.get_facing_direction()
	var ofd = Singleton_CommonVariables.main_character_player_node.GetOppositePlayerFacingDirection()
	npcBaseRoot.change_facing_direction_string(ofd)
	npcBaseRoot.stationary = true
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	Singleton_CommonVariables.interaction_node_reference = self
	
	var idx = Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.HANS
	if Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx].active_in_force:
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/HeadQuarters/Scripts/ActiveForceQuotes/" + actor_name_pulled_from_node + ".json"
	else:
		Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/HeadQuarters/Scripts/InactiveForceQuotes/" + actor_name_pulled_from_node + ".json"
	
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()


func interaction_completed() -> void:
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	
	npcBaseRoot.stationary = stationary
	npcBaseRoot.change_facing_direction_string(facing_direction)
	Singleton_CommonVariables.dialogue_box_is_currently_active = false
	Singleton_CommonVariables.interaction_node_reference = null
