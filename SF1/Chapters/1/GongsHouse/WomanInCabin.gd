extends Node2D

var stationary

func _ready():
	stationary = get_child(0).stationary
	pass


func attempt_to_interact() -> void:
	var ofd = Singleton_Game_GlobalCommonVariables.main_character_player_node.GetOppositePlayerFacingDirection()
	get_child(0).change_facing_direction_string(ofd)
	
	get_child(0).stationary = true
	Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
	Singleton_Game_GlobalCommonVariables.interaction_node_reference = self
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GongsHouse/Scripts/WomanInCabin.json"
	Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()


func interaction_completed() -> void:
	get_child(0).stationary = stationary
	Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
	Singleton_Game_GlobalCommonVariables.interaction_node_reference = null
