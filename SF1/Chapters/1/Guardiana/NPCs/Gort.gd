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
	
	var fm_idx = Singleton_Game_GlobalCommonVariables.sf_game_data_node.E_SF1_FM.GORT
	Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].unlocked = true
	Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_idx].active_in_force = true
	
	var gort = get_child(0)
	gort.set_movement_speed_timer(0.15)
	
	Singleton_Game_GlobalCommonVariables.main_character_player_node.MoveInDirection("Left")
	Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("RightMovement")
	
	gort.tester__move_in_direction("Left")
	await gort.tween.finished
	
	Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false
	
	for i in 10:
		gort.tester__move_in_direction("Down")
		await gort.tween.finished
	
	gort.tester__move_in_direction("Left")
	await gort.tween.finished
	
	for i in 3:
		gort.tester__move_in_direction("Down")
		await gort.tween.finished
	
	gort.tester__move_in_direction("Left")
	await gort.tween.finished
	gort.tester__move_in_direction("Left")
	await gort.tween.finished
	gort.tester__move_in_direction("Down")
	await gort.tween.finished
	
	for i in 7:
		gort.tester__move_in_direction("Left")
		await gort.tween.finished
	
	for i in 8:
		gort.tester__move_in_direction("Up")
		await gort.tween.finished
	
	for i in 2:
		gort.tester__move_in_direction("Left")
		await gort.tween.finished
	
	for i in 17:
		gort.tester__move_in_direction("Up")
		await gort.tween.finished
	
	queue_free()



func interaction_completed() -> void:
	Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	interacting = false
	npcBaseRoot.stationary = stationary
	npcBaseRoot.change_facing_direction_string(facing_direction)
	Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
	Singleton_Game_GlobalCommonVariables.interaction_node_reference = null
