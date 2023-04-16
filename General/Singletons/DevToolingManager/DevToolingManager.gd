extends Node2D

var is_debug_build: bool
var base_path: String

# This value is set from the DevMenu running in the Game Manager Scene
var dev_console

func _ready():
	if OS.is_debug_build():
		base_path = "res://"
		is_debug_build = true
	else:
		base_path = OS.get_executable_path().get_base_dir() + "/"
		is_debug_build = false
	
	# base_path = OS.get_executable_path().get_base_dir() + "/"
	# base_path = "res://"
	
	print("Is debug build - ", is_debug_build)
	print("BasePath - ", base_path)
	
	pass

func _input(event: InputEvent) -> void:
# TODO: what was this for?
#	if event.is_action_released("ui_cancel"):
#		#TODO: fixme this doesnt work in the overworld only in battles
#
#		if get_tree().paused:
#			Singleton_CommonVariables.top_level_fader_node.clear_black_fade()
#			Singleton_BattleVariables.battle_base.noValidOptionWarningBoxRoot.position = Vector2(-90, 100)
#			get_tree().paused = !get_tree().paused
#		else:
#			Singleton_CommonVariables.top_level_fader_node.dim_screen()
#			Singleton_BattleVariables.battle_base.noValidOptionWarningBoxRoot.set_paused_text()
#			Singleton_BattleVariables.battle_base.noValidOptionWarningBoxRoot.position = Vector2(165, 100)
#
#			Singleton_DevToolingManager.dev_console.hide()
#
#			get_tree().paused = !get_tree().paused
			
	
	if event.is_action_released("ui_toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			# TODO: check docs on whats better fullscreen or exclusive fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		
	
	# TODO: add dev menu and perform check here
	
	if event.is_action_pressed("ui_dev_console"):
		print("here")
		
		if Singleton_DevToolingManager.dev_console.is_visible_in_tree():
			Singleton_DevToolingManager.dev_console.hide()
			# get_tree().paused = !get_tree().paused
		else:
			Singleton_DevToolingManager.dev_console.show()
			# get_tree().paused = !get_tree().paused
	
	
	if event.is_action_pressed("ui_tilda"):
		print("Attempting to save screenshot")
		
		var unix_time: float = Time.get_unix_time_from_system()
		var datetime_dict: Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
		var time_string = str(datetime_dict["year"]) + "-" + str(datetime_dict["month"]) + "-" + str(datetime_dict["day"]) + "_H" + str(datetime_dict["hour"]) + "M" + str(datetime_dict["minute"]) + "S" + str(datetime_dict["second"])
		
		var img = get_viewport().get_texture().get_image()
		
		# TODO: test are these even needed anymore in Godot 4
		await get_tree().process_frame
		await get_tree().process_frame
		
		var dir = DirAccess.open(base_path + "Screenshots")
		if !dir:
			print("Screenshots folder doesnt exist, attempt to create it.")
			dir.make_dir(base_path + "Screenshots")
		
		var save_path = base_path + "Screenshots/" + time_string + ".png"
		
		img.save_png(str(save_path))
		
		# TODO: add some kind of ingame message or popup to notify a screenshot was saved

