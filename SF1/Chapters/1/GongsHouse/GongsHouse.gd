extends Node2D

onready var TilemapSceneRoot = $GongsHouseTilemapRoot
onready var Walkway = $Walkway
onready var Roof = $Roof

var using_original_tiles: bool = true

# original tilesets
var zero_tres = load("res://SF1/TileSet_Resources/Original/0.tres")
var seven_tres = load("res://SF1/TileSet_Resources/Original/7.tres")
var ten_tres = load("res://SF1/TileSet_Resources/Original/10.tres")

# upgrade Ivan Cal tilesets
var zero_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/0.tres")
var seven_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/7.tres")
var ten_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/10.tres")


func _ready():
	
	Singleton_Game_AudioManager.play_music_n(Singleton_Dev_Internal.base_path + "Assets/SF1/SoundBank/Town Theme.mp3")
	
	pass


func _input(event):
	if event.is_action_released("ui_page_down"):
		print("Swap Tilesets")
		if using_original_tiles:
			TilemapSceneRoot.get_node("BaseLayer").tile_set = seven_ic_tres
			TilemapSceneRoot.get_node("BaseLayer/10").tile_set = ten_ic_tres
			TilemapSceneRoot.get_node("BaseLayer/0").tile_set = zero_ic_tres
			
			TilemapSceneRoot.get_node("AdditionalMap").tile_set = zero_ic_tres
			
			TilemapSceneRoot.get_node("Walkway").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("Walkway/10").tile_set = ten_ic_tres
			
			TilemapSceneRoot.get_node("Roof").tile_set = zero_ic_tres
			
			Walkway.tile_set = zero_ic_tres
			Walkway.get_node("10").tile_set = ten_ic_tres
			
			Roof.tile_set = zero_ic_tres
			
			using_original_tiles = false
		else:
			TilemapSceneRoot.get_node("BaseLayer").tile_set = seven_tres
			TilemapSceneRoot.get_node("BaseLayer/10").tile_set = ten_tres
			TilemapSceneRoot.get_node("BaseLayer/0").tile_set = zero_tres
			
			TilemapSceneRoot.get_node("AdditionalMap").tile_set = zero_tres
			
			TilemapSceneRoot.get_node("Walkway").tile_set = zero_tres
			TilemapSceneRoot.get_node("Walkway/10").tile_set = ten_tres
			
			TilemapSceneRoot.get_node("Roof").tile_set = zero_tres
			
			Walkway.tile_set = zero_tres
			Walkway.get_node("10").tile_set = ten_tres
			
			Roof.tile_set = zero_tres
			
			using_original_tiles = true

