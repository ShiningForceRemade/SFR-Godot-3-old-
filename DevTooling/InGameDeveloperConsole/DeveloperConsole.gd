extends Control

@onready var textEdit = $TextEdit

var sceneManagerNode = null
var shaderCanvasNode = null

func _ready():
	
	Singleton_DevToolingManager.dev_console = self
	
	sceneManagerNode = get_parent().get_parent().get_node("SceneManager")
	shaderCanvasNode = get_parent().get_parent().get_node("ShadersCanvasLayer")
	
	pass

func _on_line_edit_text_submitted(new_text: String) -> void:
	var new_text_internal = new_text
	
	if new_text_internal == "q" || new_text_internal == "esc":
		Singleton_DevToolingManager.dev_console.hide()
		# get_tree().paused = !get_tree().paused
	
	if new_text_internal == "controllable enemies":
		Singleton_BattleVariables.control_enemies = !Singleton_BattleVariables.control_enemies
		new_text_internal = str(new_text_internal, " - ", str(Singleton_BattleVariables.control_enemies))
	
	if "change-scene" in new_text_internal || "cs" in new_text_internal:
		changeScene(new_text_internal)
		return

# TODO: need to update to godot 4 movement code then enable this	
#	if "toggle_move_rotdd" in new_text_internal:
#		Singleton_CommonVariables.main_character_player_node.GRID_BASED_MOVEMENT = !Singleton_CommonVariables.main_character_player_node.GRID_BASED_MOVEMENT
#		return
	
	if "modify" in new_text_internal:
		modify(new_text_internal)
		return
	
	if "shader" in new_text_internal:
		setShader(new_text_internal)
		return

# TODO: need to re attempt impl - new node structure for player
# Change main character broken - changing the child of a node with an active process seems to be completely broken
# if no good solution can be found replace entire PlayerRoot and replace child then add the scene back to the current space	
#	if "change" in new_text_internal:
#		var splstr = new_text_internal.split(" ")
#		if splstr[1] == "main-actor":
#			if splstr[2] != "":
#				print("teststestst")
#				var new_actor = load("res://SF1/Characters/Tao/Tao.tscn").instance()
#				Singleton_Game_GlobalCommonVariables.main_character_player_node.ChangeActor(new_actor)
	
	
	textEdit.text = str(textEdit.text, "\n", new_text_internal);
	pass 


func changeScene(new_text_internal) -> void:
	var splstr = new_text_internal.split(" ")
	
	print(splstr)
	
	if splstr[1] == "battle" || splstr[1] == "b":
		if splstr[2] == "1":
			print("Change Scene to Battle 1")
			
			# Disgusting
			#
			# copying over the battles into battlebase scene copies per battle
			# need to refactor battle base to be loaded by default and change its subscene battle, instead
			# of loading entirely new battle base scenes 
			
			sceneManagerNode.change_scene("res://General/BattleBase/BattleBase-B1.tscn")
			
		elif splstr[2] == "2":
			print("Change Scene to Battle 2")
			sceneManagerNode.change_scene("res://General/BattleBase/BattleBase-B2.tscn")
			# sceneManagerNode.get_child(1).change_battle_scene("res://SF1/Chapters/1/Battle2/Battle2.tscn")
		elif splstr[2] == "3":
			print("Change Scene to Battle 3")
			sceneManagerNode.change_scene("res://General/BattleBase/BattleBase-B3.tscn")
		elif splstr[2] == "4":
			print("Change Scene to Battle 4")
			sceneManagerNode.change_scene("res://General/BattleBase/BattleBase-B4.tscn")
		
	elif splstr[1] == "battle-test" || splstr[1] == "bt":
		if splstr[2] == "terrain" || splstr[2] == "t":
			print("Change Scene to Battle Test Terrain")
			sceneManagerNode.change_scene("res://General/BattleBase/BattleBase-T-Terrain.tscn")
		
		elif splstr[2] == "background" || splstr[2] == "b":
			print("Change Scene to Battle Test Backgrounds and Stands")
			sceneManagerNode.change_scene("res://General/BattleBase/BattleBase-T-Backgrounds.tscn")
		
		elif splstr[2] == "movement-standard" || splstr[2] == "m-standard":
			print("Change Scene to Battle Test Backgrounds and Stands")
			sceneManagerNode.change_scene("res://General/BattleBase/Movement/BattleBase-T-Movement-Standard.tscn")
		
		elif splstr[2] == "movement-mounted" || splstr[2] == "m-mounted":
			print("Change Scene to Battle Test Scene movement mounted")
			sceneManagerNode.change_scene("res://General/BattleBase/Movement/BattleBase-T-Movement-Mounted.tscn")
			
	elif splstr[1] == "overworld" || splstr[1] == "ow":
		if splstr[2] == "Guardiana-Normal":
			sceneManagerNode.change_scene("res://SF1/Chapters/1/Guardiana/PreInvasion/Guardiana.tscn")
		elif splstr[2] == "Guardiana-Invasion":
			sceneManagerNode.change_scene("res://SF1/Chapters/1/Guardiana/Guardiana.tscn")
		elif splstr[2] == "Guardiana-Castle":
			print("Change Scene to Guardiana Castle")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/Guardiana/Castle/Castle.tscn")
		elif splstr[2] == "Guardiana-Castle-Invasion":
			print("Change Scene to Guardiana Castle Invasion")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/Guardiana/Castle/CastleInvasion.tscn")
		elif splstr[2] == "Gongs-House":
			print("Change Scene to Guardiana")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/GongsHouse/GongsHouse.tscn")
		elif splstr[2] == "Ancients-Gate":
			print("Change Scene to Ancients Gate")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/AncientsGate/AncientsGate.tscn")
		elif splstr[2] == "Alterone":
			print("Change Scene to Alterone")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/Alterone/Alterone_Town.tscn")
		elif splstr[2] == "Alterone-Castle-Basement":
			print("Change Scene to Alterone Castle Basement")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/Alterone/Castle_Basement/Alterone_Castle_Basement.tscn")
		elif splstr[2] == "Alterone-Castle":
			print("Change Scene to Alterone")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/Alterone/Castle/Alterone_Castle.tscn")
		elif splstr[2] == "HQ":
			print("Change Scene to HQ")
			sceneManagerNode.change_scene("res://SF1/Chapters/HQ/Default/HeadQuarters.tscn")
		elif splstr[2] == "C2-Overworld":
			print("Change Scene to Chapter 2 Overworld")
			sceneManagerNode.change_scene("res://SF1/Chapters/2/Overworld/Overworld.tscn")
	
	elif splstr[1] == "test" || splstr[1] == "t":
		if splstr[2] == "Chest":
			sceneManagerNode.change_scene("res://SF1/Test_Scenes/Functionality/Chest.tscn")
		
	else:
		textEdit.text = str(textEdit.text, "\n", new_text_internal, "\n", "Invalid location (scene)");


# TODO:
# cutscene player
# singleton value to get cutscene node and player of the current area
# cutscene show - should list all cutscenes with a number for easy access
# cutscene play - should start it
# should also have an easy way to position player char at the start area of a cutscene



func modify(new_text_internal) -> void:
	var splstr = new_text_internal.split(" ")
	
	print(splstr)
	
	if splstr[1] == "force-member" || splstr[1] == "fm":
		# if splstr[2] != "":
		
		if splstr[2] == "all":
			var fm_size = Singleton_CommonVariables.sf_game_data_node.ForceMembers.size()
			for i in fm_size:
				force_member_modifcation_commands(splstr[3], i)
		else:
			var idx = find_character_index(splstr[2])
			force_member_modifcation_commands(splstr[3], idx)
		


func find_character_index(character_name: String) -> int:
	var idx = 0
	for character in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
		if character_name == character.name:
			return idx
		idx += 1
		
	return -1


func force_member_modifcation_commands(command: String, idx: int) -> void:
	match command:
		"active-in-force":
			print(Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx].name, " - active-in-force - ", !Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx].active_in_force)
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx].active_in_force = !Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx].active_in_force
		
		"unlock":
			# print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[idx].name, " - active-in-force - ", !Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[idx].active_in_force)
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx].unlocked = true
			
			print(Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx].unlocked)
		
		"lock":
			# print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[idx].name, " - active-in-force - ", !Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[idx].active_in_force)
			Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx].unlocked = false


func setShader(new_text_internal: String) -> void:
	var splstr = new_text_internal.split(" ")
	
	print(splstr)
	
	for n in shaderCanvasNode.get_children():
		n.hide()
	
#	if splstr[1] == "hq4x" || splstr[1] == "HQ4x":
#		shaderCanvasNode.get_node("HQ4x").show()
	if splstr[1] == "CRT" || splstr[1] == "crt":
		shaderCanvasNode.get_node("CRTShader").show()
#	if splstr[1] == "CRT-AGGRO" || splstr[1] == "crt-aggro":
#		shaderCanvasNode.get_node("CRTShader2").show()
#	if splstr[1] == "off" || splstr[1] == "OFF":
#		pass


