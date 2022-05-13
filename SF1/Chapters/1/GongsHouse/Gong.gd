extends Node2D


func _ready():
	pass


func attempt_to_interact() -> void:
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/GongsHouse/Scripts/Gong.json"
	Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
