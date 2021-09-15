extends Node2D

onready var TilemapSceneRoot = $TownTilemap
var using_original_tiles: bool = true

func _ready():
	pass


func _input(event):
	if event.is_action_released("ui_page_down"):
		print("Swap Tilesets")
		if using_original_tiles:
			TilemapSceneRoot.get_node("GroundAndSea").tile_set = load("res://SF1/Chapters/1/Guardiana/Town_Tileset__0__Rework_Ivan_Cal.tres")
			TilemapSceneRoot.get_node("Bushes").tile_set = load("res://SF1/Chapters/1/Guardiana/Town_Tileset__0__Rework_Ivan_Cal.tres")
			using_original_tiles = false
		else:
			TilemapSceneRoot.get_node("GroundAndSea").tile_set = load("res://SF1/Chapters/1/Guardiana/Town_Tileset__0.tres")
			TilemapSceneRoot.get_node("Bushes").tile_set = load("res://SF1/Chapters/1/Guardiana/Town_Tileset__0.tres")
			using_original_tiles = true

