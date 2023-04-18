extends Node2D

@onready var TilemapSceneRoot = $HeadQuartersTilemap

var NpcBaseScene = preload("res://General/NPC/NPC.tscn") # preload("res://SF1/General/NPC/NPCBase.tscn")
@onready var NpcRootNode = $NPCs

@onready var ActivePositionsRootNode = $ActiveForcePositionsNode2D
@onready var InactivePositionsRootNode = $InactiveForcePositionsNode2D
# TODO for inactive positions when Godot 4 comes out put facing direction in the metadata
# Refactor - disgusting right now but good enough for demo release

var using_original_tiles: bool = true

# original tilesets
#var zero_tres = load("res://SF1/TileSet_Resources/Original/0.tres")
#var eight_tres = load("res://SF1/TileSet_Resources/Original/8.tres")
#var ten_tres = load("res://SF1/TileSet_Resources/Original/10.tres")

# upgrade Ivan Cal tilesets
#var zero_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/0.tres")
#var eight_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/8.tres")
#var ten_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/10.tres")

func _ready():
	Singleton_AudioManager.play_music_n(Singleton_DevToolingManager.base_path + "Assets/SF1/SoundBank/Headquarters.mp3")
	
	var active_pos = ActivePositionsRootNode.get_children()
	var inactive_pos = InactivePositionsRootNode.get_children()
	
	# Singleton_Game_GlobalCommonVariables.sf_game_data_node.E_SF1_FM 
	
	var npc_fm
	var npc_fm_chr
	var i = 0
	var apn
	for fm in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
		if fm.leader:
			continue
		
		npc_fm = load(fm.character_npc_scene).instance()
		npc_fm_chr = npc_fm.get_child(0)
		npc_fm_chr.stationary = true
		
		
		# TODO: when there's more than 12 characters in total need to add checks 
		# to not overflow the active_pos
		
		if fm.active_in_force:
			npc_fm.position = active_pos[i].position
		else:
			npc_fm.position = inactive_pos[i].position
			
			apn = inactive_pos[i].name
			if "Facing-Down" in apn:
				print("Down")
				npc_fm_chr.default_facing_direction = 0
			elif "Facing-Left" in apn:
				print("Left")
				npc_fm_chr.default_facing_direction = 1
			elif "Facing-Right" in apn:
				print("Right")
				npc_fm_chr.default_facing_direction = 2
			elif "Facing-Up" in apn:
				print("Up")
				npc_fm_chr.default_facing_direction = 3
			
			print(npc_fm_chr.default_facing_direction, " ", apn)
			
			# npc_fm.default_facing_direction_setup()
		
		NpcRootNode.add_child(npc_fm)
		i = i + 1
	
# TODO move this into a test function to easily be able to confirm all active and inactive positions
#		for fm in Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers:
#		npc_fm = NpcBaseScene.instance()
#		npc_fm.get_child(0).stationary = true
#
#		if fm.active_in_force:
#			npc_fm.position = active_pos[i].position
#		else: #!fm.active_in_force:
#			npc_fm.position = inactive_pos[i].position
#
#		var npc_fm_sprite = npc_fm.get_child(0).get_child(0).get_node("Sprite")	
#		npc_fm_sprite.texture = load("res://Assets/SF1/PlayableCharacters/Arthur/Unpromoted_Map_Sprites.png")
#		npc_fm_sprite.hframes = 6
#
#		NpcRootNode.add_child(npc_fm)
#		i = i + 1
	
	pass

#
#func _input(event):
#	if event.is_action_released("ui_page_down"):
#		print("Swap Tilesets")
#		if using_original_tiles:
#			TilemapSceneRoot.get_node("Tile Layer 1").tile_set = zero_ic_tres
#			TilemapSceneRoot.get_node("8").tile_set = eight_ic_tres
#			TilemapSceneRoot.get_node("10").tile_set = ten_ic_tres
#
#			using_original_tiles = false
#		else:
#			TilemapSceneRoot.get_node("Tile Layer 1").tile_set = zero_tres
#			TilemapSceneRoot.get_node("8").tile_set = eight_tres
#			TilemapSceneRoot.get_node("10").tile_set = ten_tres
#
#			using_original_tiles = true

