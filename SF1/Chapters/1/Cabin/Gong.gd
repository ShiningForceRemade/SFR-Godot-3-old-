extends Node2D

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
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	
	# get facing direction prior to talk interaction
	facing_direction = npcBaseRoot.get_facing_direction()
	var ofd = Singleton_CommonVariables.main_character_player_node.GetOppositePlayerFacingDirection()
	npcBaseRoot.change_facing_direction_string(ofd)
	npcBaseRoot.stationary = true
	Singleton_CommonVariables.dialogue_box_is_currently_active = true
	Singleton_CommonVariables.interaction_node_reference = self
	
	Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Cabin/Scripts/Gong.json"
	Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
	
	await Signal(Singleton_CommonVariables.dialogue_box_node, "signal__dialogbox__finished_dialog")
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false


func interaction_completed() -> void:
	Singleton_CommonVariables.dialogue_box_is_currently_active = false
	Singleton_CommonVariables.interaction_node_reference = null
		
	Singleton_CommonVariables.main_character_player_node.MoveInDirection("Left")
	await Signal(Singleton_CommonVariables.main_character_player_node, "signal_action_finished")
	
	var gong = self.get_child(0)
	gong.set_movement_speed_timer(0.15)
	
	gong.MoveInDirection("Down")
	await Signal(gong, "signal_action_finished")
	
	var fm_idx = Singleton_CommonVariables.sf_game_data_node.E_SF1_FM.GONG
	Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
	Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false
	
	for i in 4:
		gong.MoveInDirection("Down")
		await Signal(gong, "signal_action_finished")
	for i in 4:
		gong.MoveInDirection("Right")
		await Signal(gong, "signal_action_finished")
	for i in 4:
		gong.MoveInDirection("Down")
		await Signal(gong, "signal_action_finished")
	
	for i in 7:
		gong.MoveInDirection("Left", true)
		await Signal(gong, "signal_action_finished")
		gong.MoveInDirection("Down", true)
		await Signal(gong, "signal_action_finished")
		
	gong.MoveInDirection("Down", true)
	await Signal(gong, "signal_action_finished")
