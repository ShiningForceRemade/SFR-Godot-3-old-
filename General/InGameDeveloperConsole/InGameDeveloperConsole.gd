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
	
	if "change-scene" in new_text_internal:
		changeScene(new_text_internal)
		return
	
	textEdit.text = str(textEdit.text, "\n", new_text_internal);
	pass 


func changeScene(new_text_internal) -> void:
	var splstr = new_text_internal.split(" ")
	
	print(splstr)
	
	if splstr[1] == "battle":
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
		
	elif splstr[1] == "overworld":
		if splstr[2] == "Guardiana":
			print("Change Scene to Guardiana")
			# sceneManagerNode.change_scene("res://General/BattleBase/BattleBase.tscn")
		elif splstr[2] == "Gongs-House":
			print("Change Scene to Guardiana")
			sceneManagerNode.change_scene("res://SF1/Chapters/1/GongsHouse/GongsHouse.tscn")
	
	else:
		textEdit.text = str(textEdit.text, "\n", new_text_internal, "\n", "Invalid location (scene)");



