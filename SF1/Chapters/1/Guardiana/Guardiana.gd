extends Node2D

onready var TilemapSceneRoot = $TownTilemap
onready var TilemapRoofSceneRoot = $RoofsWrapperNode
onready var TilemapWalkwaySceneRoot = $WalkwayDoors

var using_original_tiles: bool = true

# original tilesets
var zero_tres = load("res://SF1/TileSet_Resources/Original/0.tres")
var six_tres = load("res://SF1/TileSet_Resources/Original/6.tres")

# upgrade Ivan Cal tilesets
var zero_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/0.tres")
var six_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/6.tres")


func _ready():
	pass


func _input(event):
	if event.is_action_released("ui_page_down"):
		print("Swap Tilesets")
		if using_original_tiles:
			TilemapSceneRoot.get_node("GroundAndSea").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("GroundAndSea/6").tile_set = six_ic_tres
			TilemapSceneRoot.get_node("NormalTown").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("NormalTown/6").tile_set = six_ic_tres
			TilemapSceneRoot.get_node("BrokenState-Ground").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("BrokenState-Ground/6").tile_set = six_ic_tres
			TilemapSceneRoot.get_node("BushesAndDecorations").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("BushesAndDecorations/6").tile_set = six_ic_tres
			
			TilemapRoofSceneRoot.get_node("GortsHouse").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("FamilyHome").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Inn").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Shop").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Bar").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Church").tile_set = zero_ic_tres
			
			TilemapWalkwaySceneRoot.tile_set = zero_ic_tres
			TilemapWalkwaySceneRoot.get_node("6").tile_set = six_ic_tres
			
			using_original_tiles = false
		else:
			TilemapSceneRoot.get_node("GroundAndSea").tile_set = zero_tres
			TilemapSceneRoot.get_node("GroundAndSea/6").tile_set = six_tres
			TilemapSceneRoot.get_node("NormalTown").tile_set = zero_tres
			TilemapSceneRoot.get_node("NormalTown/6").tile_set = six_tres
			TilemapSceneRoot.get_node("BrokenState-Ground").tile_set = zero_tres
			TilemapSceneRoot.get_node("BrokenState-Ground/6").tile_set = six_tres
			TilemapSceneRoot.get_node("BushesAndDecorations").tile_set = zero_tres
			TilemapSceneRoot.get_node("BushesAndDecorations/6").tile_set = six_tres
			
			TilemapRoofSceneRoot.get_node("GortsHouse").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("FamilyHome").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Inn").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Shop").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Bar").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Church").tile_set = zero_tres
			
			TilemapWalkwaySceneRoot.tile_set = zero_tres
			TilemapWalkwaySceneRoot.get_node("6").tile_set = six_tres
			
			using_original_tiles = true

