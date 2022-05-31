extends Node2D

onready var TilemapSceneRoot = $CastleTilemapNode
onready var TilemapRoofSceneRoot = $RoofsWrapperNode
onready var TilemapWalkwaySceneRoot = $OverpassNode

var using_original_tiles: bool = true

# original tilesets
var zero_tres = load("res://SF1/TileSet_Resources/Original/0.tres")
var six_tres = load("res://SF1/TileSet_Resources/Original/6.tres")
var seven_tres = load("res://SF1/TileSet_Resources/Original/7.tres")
var eight_tres = load("res://SF1/TileSet_Resources/Original/8.tres")

# upgrade Ivan Cal tilesets
var zero_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/0.tres")
var six_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/6.tres")
var seven_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/7.tres")
var eight_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/8.tres")

func _ready():
	pass


func _input(event):
	if event.is_action_released("ui_page_down"):
		print("Swap Tilesets")
		if using_original_tiles:
			TilemapSceneRoot.get_node("Ground").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("7").tile_set = seven_ic_tres
			TilemapSceneRoot.get_node("8").tile_set = six_ic_tres
			TilemapSceneRoot.get_node("BehindMountains").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("Bushes").tile_set = seven_ic_tres
			TilemapSceneRoot.get_node("1").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("6").tile_set = six_ic_tres
			
			TilemapRoofSceneRoot.get_node("Castle").tile_set = seven_ic_tres
			TilemapRoofSceneRoot.get_node("House").tile_set = zero_ic_tres
			
			TilemapWalkwaySceneRoot.get_node("2").tile_set = zero_ic_tres
			TilemapWalkwaySceneRoot.get_node("OverpassLayer").tile_set = seven_ic_tres
			
			using_original_tiles = false
		else:
			TilemapSceneRoot.get_node("Ground").tile_set = zero_tres
			TilemapSceneRoot.get_node("7").tile_set = seven_tres
			TilemapSceneRoot.get_node("8").tile_set = six_tres
			TilemapSceneRoot.get_node("BehindMountains").tile_set = zero_tres
			TilemapSceneRoot.get_node("Bushes").tile_set = seven_tres
			TilemapSceneRoot.get_node("1").tile_set = zero_tres
			TilemapSceneRoot.get_node("6").tile_set = six_tres
			
			TilemapRoofSceneRoot.get_node("Castle").tile_set = seven_tres
			TilemapRoofSceneRoot.get_node("House").tile_set = zero_tres
			
			TilemapWalkwaySceneRoot.get_node("2").tile_set = zero_tres
			TilemapWalkwaySceneRoot.get_node("OverpassLayer").tile_set = seven_tres
			
			using_original_tiles = true

