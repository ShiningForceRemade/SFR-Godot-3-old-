extends Node2D

onready var TilemapSceneRoot = $GongsHouseTilemapRoot
onready var Walkway = $Walkway
onready var Roof = $Roof

var using_original_tiles: bool = true

# original tilesets
var one_tres = load("res://SF1/TileSet_Resources/Original/1.tres")
var sixteen_tres = load("res://SF1/TileSet_Resources/Original/16.tres")

# upgrade Ivan Cal tilesets
var one_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/1.tres")
var sixteen_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/16.tres")


func _ready():
	Singleton_Game_AudioManager.play_music_n(Singleton_Dev_Internal.base_path + "Assets/SF1/SoundBank/Town Theme.mp3")
	pass


#func _input(event):
#	if event.is_action_released("ui_page_down"):
#		print("Swap Tilesets")
#		if using_original_tiles:
#			TilemapSceneRoot.get_node("BaseLayer").tile_set = seven_ic_tres
#			TilemapSceneRoot.get_node("BaseLayer/10").tile_set = ten_ic_tres
#			TilemapSceneRoot.get_node("BaseLayer/0").tile_set = zero_ic_tres
#
#			TilemapSceneRoot.get_node("AdditionalMap").tile_set = zero_ic_tres
#
#			TilemapSceneRoot.get_node("Walkway").tile_set = zero_ic_tres
#			TilemapSceneRoot.get_node("Walkway/10").tile_set = ten_ic_tres
#
#			TilemapSceneRoot.get_node("Roof").tile_set = zero_ic_tres
#
#			Walkway.tile_set = zero_ic_tres
#			Walkway.get_node("10").tile_set = ten_ic_tres
#
#			Roof.tile_set = zero_ic_tres
#
#			using_original_tiles = false
#		else:
#			TilemapSceneRoot.get_node("BaseLayer").tile_set = seven_tres
#			TilemapSceneRoot.get_node("BaseLayer/10").tile_set = ten_tres
#			TilemapSceneRoot.get_node("BaseLayer/0").tile_set = zero_tres
#
#			TilemapSceneRoot.get_node("AdditionalMap").tile_set = zero_tres
#
#			TilemapSceneRoot.get_node("Walkway").tile_set = zero_tres
#			TilemapSceneRoot.get_node("Walkway/10").tile_set = ten_tres
#
#			TilemapSceneRoot.get_node("Roof").tile_set = zero_tres
#
#			Walkway.tile_set = zero_tres
#			Walkway.get_node("10").tile_set = ten_tres
#
#			Roof.tile_set = zero_tres
#
#			using_original_tiles = true

