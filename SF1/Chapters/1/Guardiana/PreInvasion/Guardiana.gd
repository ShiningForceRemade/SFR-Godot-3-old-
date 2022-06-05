extends Node2D

onready var TilemapSceneRoot = $TownTilemapNode2D
onready var TilemapRoofSceneRoot = $RoofsWrapperNode
onready var TilemapWalkwaySceneRoot = $WalkwayDoors

# NPCs
onready var LoweRoot = $NpcWrapperNode/LoweNPCRoot
onready var VariosRoot = $NpcWrapperNode/VariosNPCRoot
onready var GuardRoot = $NpcWrapperNode/GuardForVariosNPCRoot
# NPCs

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
			TilemapSceneRoot.get_node("GroundAndSea").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("7").tile_set = six_ic_tres
			TilemapSceneRoot.get_node("BushesAndDecorations").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("8").tile_set = six_ic_tres
			TilemapSceneRoot.get_node("NormalTown").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("WalkwayDoors").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("6").tile_set = six_ic_tres
			TilemapSceneRoot.get_node("WalkwayDoorsNormalTownExtras").tile_set = zero_ic_tres
			
			TilemapRoofSceneRoot.get_node("GortsHouse").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("FamilyHouse").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("SoldierHouse").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Inn").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Shop").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Bar").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Church").tile_set = zero_ic_tres
			
			TilemapWalkwaySceneRoot.tile_set = zero_ic_tres
			TilemapWalkwaySceneRoot.get_node("6").tile_set = six_ic_tres
			
			using_original_tiles = false
		else:
			TilemapSceneRoot.get_node("GroundAndSea").tile_set = zero_tres
			TilemapSceneRoot.get_node("7").tile_set = six_tres
			TilemapSceneRoot.get_node("BushesAndDecorations").tile_set = zero_tres
			TilemapSceneRoot.get_node("8").tile_set = six_tres
			TilemapSceneRoot.get_node("NormalTown").tile_set = zero_tres
			TilemapSceneRoot.get_node("WalkwayDoors").tile_set = zero_tres
			TilemapSceneRoot.get_node("6").tile_set = six_tres
			TilemapSceneRoot.get_node("WalkwayDoorsNormalTownExtras").tile_set = zero_tres
			
			TilemapRoofSceneRoot.get_node("GortsHouse").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("FamilyHouse").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("SoldierHouse").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Inn").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Shop").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Bar").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Church").tile_set = zero_tres
			
			TilemapWalkwaySceneRoot.tile_set = zero_tres
			TilemapWalkwaySceneRoot.get_node("6").tile_set = six_tres
			
			using_original_tiles = true

