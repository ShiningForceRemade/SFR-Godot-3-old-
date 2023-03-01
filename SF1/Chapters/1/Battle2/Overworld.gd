extends Node2D

# Player and positions (exits)
@onready var positionsNode = $PositionsNode2D
@onready var playerNode = $PlayerCharacterRoot

# hot swapping tiles
@onready var TilemapSceneRoot = $OverworldTilemapNode2D

var using_original_tiles: bool = true

# original tilesets
var one_tres = load("res://SF1/TileSet_Resources/Original/1.tres")
var sixteen_tres = load("res://SF1/TileSet_Resources/Original/16.tres")

# upgrade Ivan Cal tilesets
var one_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/1.tres")
var sixteen_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/16.tres")

func _ready():
	match Singleton_Game_GlobalCommonVariables.position_location_st:
		"Overworld_Alterone_Castle": playerNode.transform = positionsNode.get_node("AlteronePosition2D").transform
		"Overworld_Guardiana_Castle": playerNode.transform = positionsNode.get_node("GuardianaCastlePosition2D").transform
		"Overworld_Cabin": playerNode.transform = positionsNode.get_node("CabinPosition2D").transform
		"Overworld_Ancients_Gate": playerNode.transform = positionsNode.get_node("AncientsGatePosition2D").transform
		# default is Guardiana_Castle
	
	pass


func _input(event):
	if event.is_action_released("ui_page_down"):
		print("Swap Tilesets")
		if using_original_tiles:
			TilemapSceneRoot.get_node("Tilemap").tile_set = one_ic_tres
			TilemapSceneRoot.get_node("Tilemap/16").tile_set = sixteen_ic_tres
			TilemapSceneRoot.get_node("BrokenPath").tile_set = sixteen_ic_tres
			TilemapSceneRoot.get_node("BrokenPath/1").tile_set = one_ic_tres
		else:
			TilemapSceneRoot.get_node("Tilemap").tile_set = one_tres
			TilemapSceneRoot.get_node("Tilemap/16").tile_set = sixteen_tres
			TilemapSceneRoot.get_node("BrokenPath").tile_set = sixteen_tres
			TilemapSceneRoot.get_node("BrokenPath/1").tile_set = one_tres
		
		using_original_tiles = !using_original_tiles

