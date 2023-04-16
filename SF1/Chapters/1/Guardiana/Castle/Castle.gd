extends Node

@onready var positionsNode = $MarkersWrapper
@onready var playerNode = $PlayerCharacterRoot

@onready var TilemapSceneRoot: TileMap = $GuardianaCastleTilemap

# @onready var GuardInFrontOfHQ = $NpcWrapperNode/GuardHQNPCRoot
# @onready var Nova = $NpcWrapperNode/NovaNPCRoot
# @onready var Varios = $NpcWrapperNode/VariosNPCRoot

var using_original_tiles: bool = true

var og_tres = load("res://SF1/Chapters/1/Guardiana/Castle/GuardianaCastleTileset_Original.tres")
# TODO: nasty see if its possible to just create a tileset with all 30 tilesets and have the ids on export match up from tiled
var ic_tres = load("res://SF1/Chapters/1/Guardiana/Castle/GuardianaCastleTileset_IC.tres")

func _ready():
	# Singleton_AudioManager.play_music_n(Singleton_DevToolingManager.base_path + "Assets/SF1/SoundBank/Castle (Guardiana and Others).mp3")
	
	match Singleton_CommonVariables.position_location_st:
		# "Guardiana-Castle__Entrance": playerNode.transform = positionsNode.get_node("AlteroneEntrance").transform
		"Guardiana-Castle__HQ": playerNode.transform = positionsNode.get_node("HQEntrance").transform
		"Guardiana-Castle__Storage": playerNode.transform = positionsNode.get_node("StorageEntrance").transform
		"Guardiana-Castle__Tower": playerNode.transform = positionsNode.get_node("RoomBehindKing").transform
		"Guardiana-Castle__Room": playerNode.transform = positionsNode.get_node("TowerEntrance").transform
	
#	if Singleton_CommonVariables.sf_game_data_node.c1.initial_force_joined:
#		Nova.queue_free()
#
#		GuardInFrontOfHQ.position = Vector2(GuardInFrontOfHQ.position.x - 24, GuardInFrontOfHQ.position.y)
#		GuardInFrontOfHQ.get_child(0).change_facing_direction_string("RightMovement")
#		Varios.position = Vector2(Varios.position.x + 48, Varios.position.y + 48)
#		Varios.get_child(0).change_facing_direction_string("LeftMovement")

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_end"):
		if using_original_tiles:
			TilemapSceneRoot.tile_set = ic_tres
			using_original_tiles = false
		else:
			TilemapSceneRoot.tile_set = og_tres
			using_original_tiles = true

