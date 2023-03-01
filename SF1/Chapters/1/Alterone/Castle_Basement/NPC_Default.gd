extends "res://SF1/NPC/NPC_Generic_Default_Test.gd"

@export var PostBattle4: String = ""

func attempt_to_interact():
	var script_path = ""
	if Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.battle_4_complete:
		script_path = check_if_script_exists_or_use_default(PostBattle4)
	else:
		script_path = DefaultScript
	
	self.attempt_to_interact_custom(script_path)


func check_if_script_exists_or_use_default(script_path_arg: String) -> String:
	if script_path_arg != "":
		return script_path_arg
	else:
		return DefaultScript
