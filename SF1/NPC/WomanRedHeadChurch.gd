extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func attempt_to_interact():
	print("Called from parent unique")
	print("res://SF1/Chapters/1/Guardiana/Scripts/WomanRedHeadChurch.json")
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Scripts/WomanRedHeadChurch.json"
	Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
