extends Node

@onready var char_positions = $CharacterPositions
@onready var characters_wrapper_node = $Characters

@onready var player_scene = preload("res://General/CharacterRoot/PlayerCharacter/PlayerCharacter.tscn")

func _ready() -> void:
	Singleton_CommonVariables.battle__tilemap_info_group__background = $TilesInformationGroup/TileMapBackgroundInformation
	Singleton_CommonVariables.battle__tilemap_info_group__foreground = $TilesInformationGroup/TileMapForegroundInformation
	Singleton_CommonVariables.battle__tilemap_info_group__stand = $TilesInformationGroup/TileMapStandInformation
	Singleton_CommonVariables.battle__tilemap_info_group__terrain = $TilesInformationGroup/TileMapTerrianEffectInformation
	
	Singleton_CommonVariables.battle__enemies = $Enemies
	Singleton_CommonVariables.battle__characters = $Characters
	
	Singleton_CommonVariables.battle__movement_tiles_wrapper_node = $BattleLogic/MovementWrapper
	
	# TODO: check if first time play cutscene
	
	# TODO: add rotdd menu before start battle at this point
	# otherwise start battle if not cleared
	Singleton_CommonVariables.is_currently_in_battle_scene = true
	start_battle()
	# end_battle()
	
	# if cleared do nothing with battle state
	# place_leader()
	
	pass


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func end_battle() -> void:
	Singleton_CommonVariables.is_currently_in_battle_scene = false


func place_leader() -> void:
	for c in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
		if c.leader:
			var x = load(c.character_base_node).instantiate()
			# x.position = char_positions.get_child(0).position
			x.get_child(0).position = char_positions.get_child(0).position
			x.get_child(0).set_active_processing(false)
			x.get_child(0).set_collision_shape_disabled_state(true)
			characters_wrapper_node.add_child(x)
			return


func start_battle() -> void:
	Singleton_CommonVariables.battle__turn_number = 1
	
	# add all force members first
	var cp_idx: int = 1
	for c in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
		if c.active_in_force && !c.leader:
			var x = load(c.character_base_node).instantiate()
			# x.position = char_positions.get_child(cp_idx).position
			x.get_child(0).position = char_positions.get_child(cp_idx).position
			x.get_child(0).set_active_processing(false)
			x.get_child(0).set_collision_shape_disabled_state(true)
			characters_wrapper_node.add_child(x)
			cp_idx += 1
	
	place_leader()
	
	# NOTE: IMPORTANT: set all root nodes of the actor at ZERO and the first child kinemataic body at the actual position
	# look into resolving this seems wayyyy to prone to issues down the line
	var e_pos: Vector2
	for e in Singleton_CommonVariables.battle__enemies.get_children():
		e_pos = e.position
		e.get_child(0).set_collision_shape_disabled_state(true)
		e.position = Vector2.ZERO
		e.get_child(0).position = e_pos
	
	fill_turn_order_array_with_all_actors()
	# Singleton_CommonVariables.battle__logic_node.turn_logic_node.generate_actor_order_for_current_turn()
	Singleton_CommonVariables.battle__logic_node.turn_logic_node.generate_and_launch_new_turn_order()
	
	# TODO: create turn order


func fill_turn_order_array_with_all_actors():
	print("Turn Queue\n")
	
	Singleton_CommonVariables.battle__turn_order_array = []
	
	# 1. Get all Enemies and Characters in the battle
	#print("Enemies - ", enemies)
	var enemies_c = $Enemies.get_children()
	for enemey in enemies_c:
		#print(enemey.get_name(), " - ",  enemey.cget_agility())
		Singleton_CommonVariables.battle__turn_order_array.append({
			# "name": enemey.get_name(), 
			"type": "enemey", 
			"speed": 5, # enemey.cget_agility(), 
			"node": enemey, 
			"alive": true
		})
		
	#print("\nCharacters - ",characters)
	var characters_c = $Characters.get_children()
	for character in characters_c:
		#print(character.get_name(), " - ",  character.cget_agility())
		Singleton_CommonVariables.battle__turn_order_array.append({
			# "name": character.get_name(), 
			"type": "character", 
			"speed": 6, # character.cget_agility(), 
			"node": character, 
			"alive": true
		})
	
	#print(turn_order_array)
