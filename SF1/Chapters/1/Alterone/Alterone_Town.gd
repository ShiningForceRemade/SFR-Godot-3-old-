extends Node2D

@onready var positionsNode = $PositionsNode2D
@onready var playerNode = $PlayerCharacterRoot

@onready var TilemapSceneRoot = $AlteroneTownTilemap
@onready var TilemapRoofSceneRoot = $RoofsWrapperNode
@onready var TilemapOverpassSceneRoot = $OverpassLayerNode

var using_original_tiles: bool = true

# original tilesets
var zero_tres = load("res://SF1/TileSet_Resources/Original/0.tres")
var nine_tres = load("res://SF1/TileSet_Resources/Original/9.tres")
var ten_tres = load("res://SF1/TileSet_Resources/Original/10.tres")

# upgrade Ivan Cal tilesets
var zero_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/0.tres")
var nine_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/9.tres")
var ten_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/10.tres")

func _ready():
	match Singleton_Game_GlobalCommonVariables.position_location_st:
		"Alterone-Town__Entrance": playerNode.transform = positionsNode.get_node("AlteroneEntrancePosition2D").transform
		"Alterone-Town__HQ": playerNode.transform = positionsNode.get_node("HQEntrancePosition2D").transform
		"Alterone-Town__Castle": playerNode.transform = positionsNode.get_node("CabinPosition2D").transform
	
	pass


func _input(event):
	if event.is_action_released("ui_page_down"):
		print("Swap Tilesets")
		if using_original_tiles:
			TilemapSceneRoot.get_node("Copy of Tile Layer 1").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("Copy of Tile Layer 1/9").tile_set = nine_ic_tres
			TilemapSceneRoot.get_node("Copy of Tile Layer 1/10").tile_set = ten_ic_tres
			
			TilemapRoofSceneRoot.get_node("TopLeftHouse").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("TopRightHouse").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Church").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("WeaponShop").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("ItemShopAndBar").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("HouseBottom").tile_set = zero_ic_tres
			
			TilemapOverpassSceneRoot.get_node("0").tile_set = zero_ic_tres
			TilemapOverpassSceneRoot.get_node("Overpass").tile_set = nine_ic_tres
			
			using_original_tiles = false
		else:
			TilemapSceneRoot.get_node("Copy of Tile Layer 1").tile_set = zero_tres
			TilemapSceneRoot.get_node("Copy of Tile Layer 1/9").tile_set = nine_tres
			TilemapSceneRoot.get_node("Copy of Tile Layer 1/10").tile_set = ten_tres
			
			TilemapRoofSceneRoot.get_node("TopLeftHouse").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("TopRightHouse").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Church").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("WeaponShop").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("ItemShopAndBar").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("HouseBottom").tile_set = zero_tres
			
			TilemapOverpassSceneRoot.get_node("0").tile_set = zero_tres
			TilemapOverpassSceneRoot.get_node("Overpass").tile_set = nine_tres
			
			using_original_tiles = true

