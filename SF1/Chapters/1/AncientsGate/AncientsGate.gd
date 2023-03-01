extends Node2D

@onready var TilemapSceneRoot = $AncientsGateTilemap
# onready var Walkway = $Walkway
# onready var Roof = $Roof

var using_original_tiles: bool = true

# original tilesets
var zero_tres = load("res://SF1/TileSet_Resources/Original/0.tres")
var twelve_tres = load("res://SF1/TileSet_Resources/Original/12.tres")

# upgrade Ivan Cal tilesets
var zero_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/0.tres")
var twelve_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/12.tres")


func _ready():
	pass


func _input(event):
	if event.is_action_released("ui_page_down"):
		print("Swap Tilesets")
		if using_original_tiles:
			TilemapSceneRoot.get_node("Original Map").tile_set = twelve_ic_tres
			TilemapSceneRoot.get_node("Original Map/0").tile_set = zero_ic_tres
			
			TilemapSceneRoot.get_node("Pillars").tile_set = twelve_ic_tres
			
			TilemapSceneRoot.get_node("Extended Map").tile_set = twelve_ic_tres
			TilemapSceneRoot.get_node("Extended Map/0").tile_set = zero_ic_tres
			
			using_original_tiles = false
		else:
			TilemapSceneRoot.get_node("Original Map").tile_set = twelve_tres
			TilemapSceneRoot.get_node("Original Map/0").tile_set = zero_tres
			
			TilemapSceneRoot.get_node("Pillars").tile_set = twelve_tres
			
			TilemapSceneRoot.get_node("Extended Map").tile_set = twelve_tres
			TilemapSceneRoot.get_node("Extended Map/0").tile_set = zero_tres
			
			using_original_tiles = true

