extends Node

func _ready():
	pass # Replace with function body.

func StartDialogue(script_path: String) -> void:
	print("Called from cutscene aniamation player")
	print("Script", script_path)
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Scripts/WomanRedHeadChurch.json" #script_path
	Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
	
	
