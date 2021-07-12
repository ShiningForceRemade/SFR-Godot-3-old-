extends Node2D

var movement: int = 6

signal signal_character_moved(new_pos)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$KinematicBody2D.connect("signal_character_moved", self, "char_moved")
	pass # Replace with function body.


func char_moved(new_pos):
	emit_signal("signal_character_moved", new_pos)

func get_character_movement():
	return movement

func get_character_current_pos() -> Vector2:
	return $KinematicBody2D.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Getters
func cget_agility():
	return 8
