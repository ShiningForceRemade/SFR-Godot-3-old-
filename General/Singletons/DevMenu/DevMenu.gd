extends Node2D

var dev_console # gets the node from ingame developer console

func _ready():
	pass

func _input(event):
	if event.is_action_released("ui_cancel"):
		#TODO: fixme this doesnt work in the overworld only in battles
		
		if get_tree().paused:
			Singleton_Game_GlobalCommonVariables.top_level_fader_node.clear_black_fade()
			Singleton_Game_GlobalBattleVariables.battle_base.noValidOptionWarningBoxRoot.position = Vector2(-90, 100)
			get_tree().paused = !get_tree().paused
		else:
			Singleton_Game_GlobalCommonVariables.top_level_fader_node.dim_screen()
			Singleton_Game_GlobalBattleVariables.battle_base.noValidOptionWarningBoxRoot.set_paused_text()
			Singleton_Game_GlobalBattleVariables.battle_base.noValidOptionWarningBoxRoot.position = Vector2(165, 100)
			
			Singleton_Dev_DevMenu.dev_console.hide()
			
			get_tree().paused = !get_tree().paused
			
	
	if event.is_action_released("ui_toggle_fullscreen"):
		# print("Toggled Fullscreen")
		OS.window_fullscreen = !OS.window_fullscreen
	
	# TODO: add dev menu and perform check here
	
	if event.is_action_pressed("ui_dev_console"):
		if get_tree().paused:
			Singleton_Dev_DevMenu.dev_console.hide()
			get_tree().paused = !get_tree().paused
		else:
			Singleton_Dev_DevMenu.dev_console.show()
			get_tree().paused = !get_tree().paused
	
	if event.is_action_pressed("ui_tilda"):
		print("Saving Screenshot")
		
		var time = OS.get_datetime()
		var time_string = str(time["year"]) + "-" + str(time["month"]) + "-" + str(time["day"]) + "_H" + str(time["hour"]) + "M" + str(time["minute"]) + "S" + str(time["second"])
		
		var img = get_viewport().get_texture().get_data()
		
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		
		img.flip_y()
		
		var d = Directory.new()
		if !(d.dir_exists(Singleton_Dev_Internal.base_path + "Screenshots")):
			print("Screenshots folder doesnt exist, attempt to create it.")
			d.open(Singleton_Dev_Internal.base_path)
			d.make_dir(Singleton_Dev_Internal.base_path + "Screenshots")
			
		# var save_path = "res://Screenshots/" + time_string + ".png"
		var save_path = Singleton_Dev_Internal.base_path + "Screenshots/" + time_string + ".png"
		
		img.save_png(str(save_path))
		
		# TODO: add some kind of ingame message or popup to notify a screenshot was saved

