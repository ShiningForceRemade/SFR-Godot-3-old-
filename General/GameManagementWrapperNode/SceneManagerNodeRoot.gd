extends Node

func _ready():
	
	Singleton_Game_GlobalCommonVariables.scene_manager_node = self
	
	pass


func change_scene(new_scene_resource_path: String) -> void:
	var new_scene = load(new_scene_resource_path).instance();
	
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

