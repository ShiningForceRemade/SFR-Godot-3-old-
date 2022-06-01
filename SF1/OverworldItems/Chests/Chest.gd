extends Node2D

export var preopend_chest: bool = false
export var hidden_chest: bool = false
export var item_resource: Resource 
export var gold: int = 0

onready var textureRectNode = $TextureRect

const TILE_SIZE: int = 24

var opened: bool = false
var retrieved_chest_resources: bool = false

func _ready():
	if hidden_chest:
		hide()
	
	if preopend_chest:
		textureRectNode.region_rect.position.x = TILE_SIZE
		opened = true


func attempt_to_interact() -> void:
	attempt_to_open_chest()


func attempt_to_open_chest() -> void:
	if !preopend_chest && !opened:
		Singleton_Game_GlobalCommonVariables.interaction_node_reference = self
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
		opened = true
		print("Trying to open chest")
		Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message(Singleton_Game_GlobalCommonVariables.main_character_player_node.get_actor_name() + " opens the treasure chest!")
		textureRectNode.region_rect.position.x = TILE_SIZE
		show()
	# else: 
	#	print("Chest was already opened")

func interaction_completed() -> void:
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	if opened && !retrieved_chest_resources:
		retrieve_chest_contents()
	else:
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)


func retrieve_chest_contents() -> void:
	var ma = Singleton_Game_GlobalCommonVariables.main_character_player_node.get_actor_name()
	var display_str = ""
	
	if item_resource == null && gold == 0:
		display_str = "Nothing is found."
	else:
		if item_resource != null:
			display_str += ma + " discovered: " + str(item_resource.item_name) + "!"
			# TDOO for item_resource check if inventory full then move to next character
			# display_str += ma + " passes it to " + next_character_with_open_slot_name + "!"
	
		if gold != 0:
			display_str += ma + " gains " + str(gold) + " coins."
	
	retrieved_chest_resources = true
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message(display_str)
