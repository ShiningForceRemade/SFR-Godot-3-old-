extends Node2D

@onready var positionsNode = $PositionsNode2D
@onready var playerNode = $PlayerCharacterRoot

@onready var TilemapSceneRoot = $AlteroneCastleBasementTilemap
@onready var TilemapOverpassSceneRoot = $Overpass

var using_original_tiles: bool = true

# original tilesets
var zero_tres = load("res://SF1/TileSet_Resources/Original/0.tres")
var seven_tres = load("res://SF1/TileSet_Resources/Original/7.tres")
var eight_tres = load("res://SF1/TileSet_Resources/Original/8.tres")
var nine_tres = load("res://SF1/TileSet_Resources/Original/9.tres")
var ten_tres = load("res://SF1/TileSet_Resources/Original/10.tres")
# var ten_tres = load("res://SF1/Chapters/1/Guardiana/Town_Tileset__10.tres")

# upgrade Ivan Cal tilesets
var zero_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/0.tres")
var seven_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/7.tres")
var eight_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/8.tres")
var nine_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/9.tres")
var ten_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/10.tres")

# npcs
@onready var King = $NpcWrapperNode/KingNPCRoot
# npcs

func _ready():
	match Singleton_Game_GlobalCommonVariables.position_location_st:
		"Alterone-Town__HQ": playerNode.transform = positionsNode.get_node("HQHallHallEntrancePosition2D").transform
		# "Alterone-Castle__MainEntrance": playerNode.transform = positionsNode.get_node("CastleEntrancePosition2D").transform
		# "Alterone-Town__HQ": playerNode.transform = positionsNode.get_node("HQEntrancePosition2D").transform
		# "Alterone-Town__Castle": playerNode.transform = positionsNode.get_node("CabinPosition2D").transform

	# if Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.spoken_to_guardiana_man_in_alterone_bar:
	#	SoliderEntrance.get_child(0).tester__move_in_direction("Right")
	#	SoliderEntrance.get_child(0).change_facing_direction_string("LeftMovement")
	
	pass


func _input(event):
	if event.is_action_released("ui_page_down"):
		print("Swap Tilesets")
		if using_original_tiles:
			TilemapSceneRoot.get_node("Tile Layer 1").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("7").tile_set = seven_ic_tres
			TilemapSceneRoot.get_node("8").tile_set = eight_ic_tres
			TilemapSceneRoot.get_node("9").tile_set = nine_ic_tres
			TilemapSceneRoot.get_node("10").tile_set = ten_ic_tres
			TilemapSceneRoot.get_node("Overpass").tile_set = zero_ic_tres
			
			TilemapOverpassSceneRoot.tile_set = zero_ic_tres
			
			using_original_tiles = false
		else:
			TilemapSceneRoot.get_node("Tile Layer 1").tile_set = zero_tres
			TilemapSceneRoot.get_node("7").tile_set = seven_tres
			TilemapSceneRoot.get_node("8").tile_set = eight_tres
			TilemapSceneRoot.get_node("9").tile_set = nine_tres
			TilemapSceneRoot.get_node("10").tile_set = ten_tres
			TilemapSceneRoot.get_node("Overpass").tile_set = zero_tres
			
			TilemapOverpassSceneRoot.tile_set = zero_tres
			
			using_original_tiles = true

