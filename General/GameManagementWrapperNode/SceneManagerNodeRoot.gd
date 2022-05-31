extends Node

# TODO: add editor resource so its easy to set the default scene to start on
# due to all the canvas, menu, and dev layers can't go through the normal godot start scene route
# ref 1

func _ready():
	
	Singleton_Game_GlobalCommonVariables.scene_manager_node = self
	
	# ref 1
	# change_scene("res://SF1/Chapters/1/GongsHouse/GongsHouse.tscn")
	change_scene("res://SF1/Chapters/1/Alterone/Alterone_Town.tscn")
	
	pass


func change_scene(new_scene_resource_path: String) -> void:
	var new_scene = load(new_scene_resource_path).instance();
	
	call_deferred("_deferred_change_scene", new_scene)
	
	# for child in get_children():
	#	child.queue_free()
	
	# add_child(new_scene)

# TODO: need to setup deferred calls for the other types as well

func _deferred_change_scene(new_scene) -> void:
	# var new_scene = load(new_scene_resource_path).instance();
	
	for child in get_children():
		child.queue_free()
	
	add_child(new_scene)




func change_scene_preloaded(new_scene_preloaded) -> void:
	var new_scene = new_scene_preloaded.instance();
	
	for child in get_children():
		child.queue_free()
	
	add_child(new_scene)


func change_scene_preinstanced(new_scene_instance) -> void:
	for child in get_children():
		child.queue_free()
	
	add_child(new_scene_instance)

