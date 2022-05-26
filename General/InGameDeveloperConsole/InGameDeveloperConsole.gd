extends Node2D

onready var textEdit = $TextEdit

var sceneManagerNode = null

func _ready():
	
	Singleton_Dev_DevMenu.dev_console = self
	
	sceneManagerNode = get_parent().get_parent().get_node("SceneManagerNodeRoot")
	
	pass

func _on_LineEdit_text_entered(new_text):
	var new_text_internal = new_text
	if new_text_internal == "controllable enemies":
		Singleton_Game_GlobalBattleVariables.control_enemies = !Singleton_Game_GlobalBattleVariables.control_enemies
		new_text_internal = str(new_text_internal, " - ", str(Singleton_Game_GlobalBattleVariables.control_enemies))
	
	if "change-scene" in new_text_internal || "cs" in new_text_internal:
		changeScene(new_text_internal)
		return
	
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
			
			sceneManagerNode.change_scene("res://General/BattleBase/BattleBase.tscn")
			
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
		
	elif splstr[1] == "overworld" || splstr[1] == "ow":
		if splstr[2] == "Guardiana-Normal":
			sceneManagerNode.change_scene("res://SF1/Chapters/1/Guardiana/PreInvasion/Guardiana.tscn")
		elif splstr[2] == "Guardiana-Invasion":
			sceneManagerNode.change_scene("res://SF1/Chapters/1/Guardiana/Guardiana.tscn")
		elif splstr[2] == "Guardiana-Castle":
			print("Change Scene to Guardiana Castle")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/Guardiana/Castle/Castle.tscn")
		elif splstr[2] == "Gongs-House":
			print("Change Scene to Guardiana")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/GongsHouse/GongsHouse.tscn")
		elif splstr[2] == "Ancients-Gate":
			print("Change Scene to Ancients Gate")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/AncientsGate/AncientsGate.tscn")
		elif splstr[2] == "Alterone":
			print("Change Scene to Alterone")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/Alterone/Alterone_Town.tscn")
		elif splstr[2] == "Alterone-Castle":
			print("Change Scene to Alterone")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/Alterone/Castle/Alterone_Castle.tscn")
		elif splstr[2] == "HQ":
			print("Change Scene to HQ")
			sceneManagerNode.change_scene("res://SF1/Chapters/HQ/Default/HeadQuarters.tscn")
		
	else:
		textEdit.text = str(textEdit.text, "\n", new_text_internal, "\n", "Invalid location (scene)");


# TODO:
# cutscene player
# singleton value to get cutscene node and player of the current area
# cutscene show - should list all cutscenes with a number for easy access
# cutscene play - should start it
# should also have an easy way to position player char at the start area of a cutscene

