extends Node2D

# @onready var charRoot = $CharacterRoot


func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
	#pass


func get_actor_root_node_internal() -> Node2D:
	return $CharacterRoot
