extends Node2D


func _ready():
	move_left()
	move_left()
	move_left()
	pass 

func move_left() -> void:
	get_child(0).tester__move_in_direction("Left")
