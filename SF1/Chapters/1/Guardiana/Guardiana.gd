extends Node2D

@onready var TilemapSceneRoot = $TownTilemap
@onready var TilemapRoofSceneRoot = $RoofsWrapperNode
@onready var TilemapWalkwaySceneRoot = $WalkwayDoors

var using_original_tiles: bool = true

# original tilesets
var zero_tres = load("res://SF1/TileSet_Resources/Original/0.tres")
var six_tres = load("res://SF1/TileSet_Resources/Original/6.tres")

# upgrade Ivan Cal tilesets
var zero_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/0.tres")
var six_ic_tres = load("res://SF1/TileSet_Resources/Ivan_Cal_Graphic_Upgrade/6.tres")


func _ready():
	if Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.battle_2_complete && !Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.entered_guardiana_post_battle_2:
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
		Singleton_Game_GlobalCommonVariables.sf_game_data_node.c1.entered_guardiana_post_battle_2 = true
		# var pn = get_parent()
		
		var luke = get_node("NpcWrapperNode/SoldierGuardLeftNPCRoot").get_child(0)
		var ken  = get_node("NpcWrapperNode/SoldierGuardRightNPCRoot").get_child(0)
		
#		luke.set_movement_speed_timer(0.1)
#		ken.set_movement_speed_timer(0.1)
		
		Singleton_Game_GlobalCommonVariables.main_character_player_node.change_facing_direction_string("DownMovement")
		
#		for i in 3:
#			luke.tester__move_in_direction("Right")
#			ken.tester__move_in_direction("Left")
#			await get_tree().create_timer(0.1).timeout
		
		Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
		Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/1/Guardiana/Scripts/GuardEntrance.json"
		Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
		
		await Singleton_Game_GlobalCommonVariables.dialogue_box_node.signal__dialogbox__finished_dialog
		Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
		Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = ""
		
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(true)
	
	pass


func _input(event):
	if event.is_action_released("ui_page_down"):
		print("Swap Tilesets")
		if using_original_tiles:
			TilemapSceneRoot.get_node("GroundAndSea").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("GroundAndSea/6").tile_set = six_ic_tres
			TilemapSceneRoot.get_node("NormalTown").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("NormalTown/6").tile_set = six_ic_tres
			TilemapSceneRoot.get_node("BrokenState-Ground").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("BrokenState-Ground/6").tile_set = six_ic_tres
			TilemapSceneRoot.get_node("BushesAndDecorations").tile_set = zero_ic_tres
			TilemapSceneRoot.get_node("BushesAndDecorations/6").tile_set = six_ic_tres
			
			TilemapRoofSceneRoot.get_node("GortsHouse").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("FamilyHome").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Inn").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Shop").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Bar").tile_set = zero_ic_tres
			TilemapRoofSceneRoot.get_node("Church").tile_set = zero_ic_tres
			
			TilemapWalkwaySceneRoot.tile_set = zero_ic_tres
			TilemapWalkwaySceneRoot.get_node("6").tile_set = six_ic_tres
			
			using_original_tiles = false
		else:
			TilemapSceneRoot.get_node("GroundAndSea").tile_set = zero_tres
			TilemapSceneRoot.get_node("GroundAndSea/6").tile_set = six_tres
			TilemapSceneRoot.get_node("NormalTown").tile_set = zero_tres
			TilemapSceneRoot.get_node("NormalTown/6").tile_set = six_tres
			TilemapSceneRoot.get_node("BrokenState-Ground").tile_set = zero_tres
			TilemapSceneRoot.get_node("BrokenState-Ground/6").tile_set = six_tres
			TilemapSceneRoot.get_node("BushesAndDecorations").tile_set = zero_tres
			TilemapSceneRoot.get_node("BushesAndDecorations/6").tile_set = six_tres
			
			TilemapRoofSceneRoot.get_node("GortsHouse").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("FamilyHome").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Inn").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Shop").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Bar").tile_set = zero_tres
			TilemapRoofSceneRoot.get_node("Church").tile_set = zero_tres
			
			TilemapWalkwaySceneRoot.tile_set = zero_tres
			TilemapWalkwaySceneRoot.get_node("6").tile_set = six_tres
			
			using_original_tiles = true

