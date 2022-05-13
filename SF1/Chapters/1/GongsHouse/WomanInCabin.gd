extends Node2D


func _ready():
	pass


func attempt_to_interact() -> void:
	
	get_child(0).change_facing_direction_string("RightMovement")
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GongsHouse/Scripts/WomanInCabin.json"
	Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()

