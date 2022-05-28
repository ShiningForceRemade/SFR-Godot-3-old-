extends Node2D

onready var TilemapSceneRoot = $AlteroneTownTilemap
onready var TilemapRoofSceneRoot = $RoofsWrapperNode
onready var TilemapOverpassSceneRoot = $OverpassLayerNode

var using_original_tiles: bool = true

# original tilesets
var zero_tres = load("res://SF1/Chapters/1/Guardiana/Town_Tileset__0.tres")
var seven_tres = load("res://SF1/Chapters/1/Guardiana/Town_Tileset__7.tres")
var eight_tres = load("res://SF1/Chapters/1/Guardiana/Town_Tileset__8.tres")
var nine_tres = load("res://SF1/Chapters/1/Guardiana/Town_Tileset__9.tres")
var ten_tres = load("res://SF1/Chapters/1/Guardiana/Town_Tileset__10.tres")

# upgrade Ivan Cal tilesets
var zero_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/0.tres")
var seven_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/7.tres")
var eight_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/8.tres")
var nine_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/9.tres")
var ten_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/10.tres")

func _ready():
	pass


func _input(event):
	if event.is_action_released("ui_page_down"):
		print("Swap Tilesets")
		if using_original_tiles:
			TilemapSceneRoot.get_node("Tile Layer 1").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("Tile Layer 1/7").tile_set = seven_ic_tres
			TilemapSceneRoot.get_node("Tile Layer 1/8").tile_set = eight_ic_tres
			TilemapSceneRoot.get_node("Tile Layer 1/9").tile_set = nine_ic_tres
			TilemapSceneRoot.get_node("Tile Layer 1/10").tile_set = ten_ic_tres
			
			TilemapSceneRoot.get_node("Copy of Tile Layer 1").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("Copy of Tile Layer 1/9").tile_set = nine_ic_tres
			TilemapSceneRoot.get_node("Copy of Tile Layer 1/10").tile_set = ten_ic_tres
			
			TilemapSceneRoot.get_node("Roof").tile_set = zero_ic_tres
			
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
			TilemapSceneRoot.get_node("Tile Layer 1").tile_set = zero_tres
			TilemapSceneRoot.get_node("Tile Layer 1/7").tile_set = seven_tres
			TilemapSceneRoot.get_node("Tile Layer 1/8").tile_set = eight_tres
			TilemapSceneRoot.get_node("Tile Layer 1/9").tile_set = nine_tres
			TilemapSceneRoot.get_node("Tile Layer 1/10").tile_set = ten_tres
			
			TilemapSceneRoot.get_node("Copy of Tile Layer 1").tile_set = zero_tres
			TilemapSceneRoot.get_node("Copy of Tile Layer 1/9").tile_set = nine_tres
			TilemapSceneRoot.get_node("Copy of Tile Layer 1/10").tile_set = ten_tres
			
			TilemapSceneRoot.get_node("Roof").tile_set = zero_tres
			
			TilemapRoofSceneRoot.get_node("TopLeftHouse").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("TopRightHouse").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Church").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("WeaponShop").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("ItemShopAndBar").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("HouseBottom").tile_set = zero_tres
			
			TilemapOverpassSceneRoot.get_node("0").tile_set = zero_tres
			TilemapOverpassSceneRoot.get_node("Overpass").tile_set = nine_tres
			
			using_original_tiles = true

