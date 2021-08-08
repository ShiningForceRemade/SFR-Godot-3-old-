extends Node

var is_debug_build: bool
var base_path: String

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
