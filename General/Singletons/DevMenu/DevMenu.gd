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
	
	if event.is_action_pressed("ui_tilda"):
		print("Saving Screenshot")
		
		var time = OS.get_datetime()
		var time_string = str(time["year"]) + "-" + str(time["month"]) + "-" + str(time["day"]) + "_H" + str(time["hour"]) + "M" + str(time["minute"]) + "S" + str(time["second"])
		
		var img = get_viewport().get_texture().get_data()
		
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		
		img.flip_y()
		
		var save_path = "res://Screenshots/" + time_string + ".png"
		
		img.save_png(str(save_path))
		
		# TODO: add some kind of ingame message or popup to notify a screenshot was saved

