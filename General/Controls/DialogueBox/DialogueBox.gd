extends Control

signal signal_dialogue_completed

onready var dialogueRichTextLabel = $NinePatchRect/DialogueRichTextLabel
onready var dialogueTween = $DialogueTween

func _ready():
	# Singleton_Game_GlobalBattleVariables.dialogue_box_node = self
	
	dialogueTween.connect("tween_completed", self, "s_battle_message_complete")
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func battle_message_play(str_arg = "") -> void:
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.rect_position = Vector2(72, 160)
	dialogueRichTextLabel.percent_visible = 0
	dialogueRichTextLabel.show()
	
	dialogueRichTextLabel.bbcode_text = str_arg
	
	dialogueTween.interpolate_property(dialogueRichTextLabel, "percent_visible",
	0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	dialogueTween.start()


func s_battle_message_complete(node_arg, property_arg) -> void: 
	# print("Tween completed ", arg1, " ", arg2)
	yield(get_tree().create_timer(1.5), "timeout")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.rect_position = Vector2(72, 262)
	dialogueRichTextLabel.hide()
	
	emit_signal("signal_dialogue_completed")
