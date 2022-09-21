extends Node2D

onready var positionsNode = $PositionsNode2D
onready var playerNode = $PlayerCharacterRoot

onready var TilemapSceneRoot = $CastleTilemapNode
onready var TilemapRoofSceneRoot = $RoofsWrapperNode
onready var TilemapWalkwaySceneRoot = $OverpassNode

onready var GuardInFrontOfHQ = $NpcWrapperNode/GuardHQNPCRoot
onready var Nova = $NpcWrapperNode/NovaNPCRoot
onready var Varios = $NpcWrapperNode/VariosNPCRoot

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
	Singleton_Game_AudioManager.play_music_n(Singleton_Dev_Internal.base_path + "Assets/SF1/SoundBank/Castle (Guardiana and Others).mp3")
	
	match Singleton_Game_GlobalCommonVariables.position_location_st:
		# "Guardiana-Castle__Entrance": playerNode.transform = positionsNode.get_node("AlteroneEntrancePosition2D").transform
		"Guardiana-Castle__HQ": playerNode.transform = positionsNode.get_node("HQEntrancePosition2D").transform
		"Guardiana-Castle__Storage": playerNode.transform = positionsNode.get_node("StorageEntrancePosition2D").transform
		"Guardiana-Castle__Tower": playerNode.transform = positionsNode.get_node("RoomBehindKingPosition2D").transform
		"Guardiana-Castle__Room": playerNode.transform = positionsNode.get_node("TowerEntrancePosition2D").transform
	
	if Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.initial_force_joined:
		Nova.queue_free()
		
		GuardInFrontOfHQ.position = Vector2(GuardInFrontOfHQ.position.x - 24, GuardInFrontOfHQ.position.y)
		GuardInFrontOfHQ.get_child(0).change_facing_direction_string("RightMovement")
		Varios.position = Vector2(Varios.position.x + 48, Varios.position.y + 48)
		Varios.get_child(0).change_facing_direction_string("LeftMovement")


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

