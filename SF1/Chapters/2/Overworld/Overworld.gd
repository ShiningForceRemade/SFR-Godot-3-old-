extends Node2D

@onready var TilemapSceneRoot = $OverworldTilemapNode2D

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


func _input(event):
	if event.is_action_released("ui_page_down"):
		print("Swap Tilesets")
		if using_original_tiles:
			TilemapSceneRoot.get_node("Base").tile_set = one_ic_tres
			TilemapSceneRoot.get_node("16").tile_set = sixteen_ic_tres

			using_original_tiles = false
		else:
			TilemapSceneRoot.get_node("Base").tile_set = one_tres
			TilemapSceneRoot.get_node("16").tile_set = sixteen_tres

			using_original_tiles = true

