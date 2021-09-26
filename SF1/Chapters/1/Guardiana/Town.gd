extends Node2D

func _ready():
	pass 

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("Here")
		$BrokenStateGround.tile_set = load("res://SF1/TileSet_Resources/Original/9.tres")
