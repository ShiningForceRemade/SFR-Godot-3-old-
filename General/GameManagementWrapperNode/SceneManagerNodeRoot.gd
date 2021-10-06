extends Node

func _ready():
	
	Singleton_Game_GlobalCommonVariables.scene_manager_node = self
	
	pass


func change_scene(new_scene_resource_path: String) -> void:
	var new_scene = load(new_scene_resource_path).instance();
	
	for child  in get_children():
		remove_child(child)
	
	add_child(new_scene)


## TODO: add preloaded method
