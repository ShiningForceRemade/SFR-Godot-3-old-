extends Node2D

onready var textEdit = $TextEdit

func _ready():
	Singleton_Dev_DevMenu.dev_console = self
	pass

func _on_LineEdit_text_entered(new_text):
	var new_text_internal = new_text
	if new_text_internal == "controllable enemies":
		Singleton_Game_GlobalBattleVariables.control_enemies = !Singleton_Game_GlobalBattleVariables.control_enemies
		new_text_internal = str(new_text_internal, " - ", str(Singleton_Game_GlobalBattleVariables.control_enemies))
	
	textEdit.text = str(textEdit.text, "\n", new_text_internal);
	pass 
