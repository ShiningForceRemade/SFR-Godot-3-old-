extends Node2D

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
	
	# TODO: add dev menu and perform check here
