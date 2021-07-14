extends Node2D

func _ready():
	pass

func _input(event):
	if event.is_action_released("ui_cancel"):
		get_tree().paused = !get_tree().paused
	
	if event.is_action_released("ui_toggle_fullscreen"):
		# print("Toggled Fullscreen")
		OS.window_fullscreen = !OS.window_fullscreen
	
	# TODO: add dev menu and perform check here
