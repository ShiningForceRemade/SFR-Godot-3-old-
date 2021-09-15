extends Node2D


func _ready():
	pass


func attempt_to_interact() -> void:
	attempt_to_open_chest()


func attempt_to_open_chest() -> void:
	print("Trying to open chest")
