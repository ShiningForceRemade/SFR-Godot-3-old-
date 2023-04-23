extends Node

var loader
var wait_frames
var time_max = 100 # msec
# var current_scene

# TODO: add editor resource so its easy to set the default scene to start on
# due to all the canvas, menu, and dev layers can't go through the normal godot start scene route
# ref 1

func _ready():
	Singleton_CommonVariables.scene_manager_node = self
	# call_deferred("_deferred_change_scene", "res://SF1/Chapters/1/Guardiana/PreInvasion/Guardiana.tscn")
	# call_deferred("_deferred_change_scene", "res://SF1/Chapters/HeadQuarters/Default/HeadQuarters.tscn")
	# call_deferred("_deferred_change_scene", "res://SF1/Chapters/1/Cabin/Cabin.tscn")
	
	pass

# Naive
func change_scene(new_scene_resource_path: String) -> void:
	await Singleton_CommonVariables.top_level_fader_node.play_fade_in()
	call_deferred("_deferred_change_scene", new_scene_resource_path)


func _deferred_change_scene(new_scene_resource_path: String) -> void:
	var new_scene = load(new_scene_resource_path).instantiate();
	
	for child in get_children():
		child.queue_free()
	
	add_child(new_scene)
	
	await Singleton_CommonVariables.top_level_fader_node.play_fade_out()

# TODO: when the godot 4 docs on ResourceLoader are updated retest background loading the scene while the transition fade effects play for faster loads
#func change_scene(new_scene_resource_path: String) -> void:
#	loader = ResourceLoader.load(new_scene_resource_path)
#	if loader == null: # Check for errors.
#		# show_error()
#		print("NULL")
#		return
#
#	Singleton_CommonVariables.top_level_fader_node.play_fade_in()
#
#	wait_frames = 1
#
#	# call_deferred("_deferred_change_scene", new_scene_resource_path)
#
#	# for child in get_children():
#	#	child.queue_free()
#
#	# add_child(new_scene)
#
## TODO: need to setup deferred calls for the other types as well
#
#func _deferred_change_scene(new_scene_resource_path) -> void:
#	set_process(true)
#	var new_scene = new_scene_resource_path.instantiate();
#	# var new_scene = load(new_scene_resource_path).instance();
#
#	for child in get_children():
#		child.queue_free()
#
#	add_child(new_scene)
#
#	Singleton_CommonVariables.top_level_fader_node.play_fade_out()
#
#func _process(_delta: float) -> void:
#	if loader == null:
#		# no need to process anymore
#		set_process(false)
#		return
#
#	# Wait for frames to let the "loading" animation show up.
#	if wait_frames > 0:
#		wait_frames -= 1
#		return
#
#	var t = Time.get_ticks_msec()
#	# Use "time_max" to control for how long we block this thread.
#	while Time.get_ticks_msec() < t + time_max:
#		print("TICK POLL")
#		# Poll your loader.
#		var err = loader.poll()
#
#		if err == ERR_FILE_EOF: # Finished loading.
#			var resource = loader.get_resource()
#			loader = null
#			# set_new_scene(resource)
#			call_deferred("_deferred_change_scene", resource)
#			break
##		elif err == OK:
##			update_progress()
##		else: # Error during loading.
##			show_error()
##			loader = null
##			break


func change_scene_preloaded(new_scene_preloaded) -> void:
	var new_scene = new_scene_preloaded.instantiate();
	
	for child in get_children():
		child.queue_free()
	
	add_child(new_scene)


func change_scene_preinstanced(new_scene_instance) -> void:
	for child in get_children():
		child.queue_free()
	
	add_child(new_scene_instance)
