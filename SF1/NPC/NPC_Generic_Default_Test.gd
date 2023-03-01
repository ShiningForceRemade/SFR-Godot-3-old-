extends Node2D

@export var DefaultScript: String

var stationary
var facing_direction
var interacting: bool = false

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
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = DefaultScript # "res://SF1/Chapters/1/Guardiana/PreInvasion/Scripts/OldManAtTheChurch.json"
	Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	# interacting = false


func attempt_to_interact_custom(script_path_arg: String) -> void:
	if script_path_arg == "":
		return
	
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
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = script_path_arg
	Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
	
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	# interacting = false


func interaction_completed() -> void:
	Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false
	npcBaseRoot.stationary = stationary
	npcBaseRoot.change_facing_direction_string(facing_direction)
	Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
	Singleton_Game_GlobalCommonVariables.interaction_node_reference = null
