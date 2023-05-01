# @tool
extends Node2D

signal signal__function_completed
signal signal__current_actor_exchange_completed

const enemey_position: Vector2 = Vector2(0, 0)
const character_position: Vector2 = Vector2(206, 160)

var rng = RandomNumberGenerator.new()

const shader_color_blend = preload("res://Shaders/ColorBlend.gdshader")
const shader_dissolve = preload("res://Shaders/Dissolve.gdshader")
const shader_texture__noise_pixelated = preload("res://Shaders/ShaderTextureImages/NoisePixelated.jpg")

@onready var background_scene = preload("res://General/BattleScene/BackgroundScene/BackgroundBattleScene.tscn")
@onready var background_wrapper = $BackgroundWrapper
@onready var characterWrapper = $CharacterWrapper
@onready var enemeyWrapper = $EnemeyWrapper
@onready var scene_transition = $BattleSceneTransitionTemp
@onready var spells_wrapper = $SpellsWrapper

const transition_screen_default_position = Vector2(448, 90)

var current_initiator_actor_parent_node
var current_initiator_actor_node
var current_initiator_actor_id
var current_target_actor_parent_node
var current_target_actor_node
var current_target_actor_id
var current_initiator_actor_battle_scene_node
var current_target_actor_battle_scene_node

var experience_points_gain: int
var coins_gain: int 

# var using_spell: bool = false
# var attack_missed = false

# TODO: clean move this somewhere else thats easier to use across scenes
var tile_name_to_frame_mapping_dictionary = {
	"SF1_SkyWithMountains": 0,
	"SF1_Town": 1,
	"SF1_Gate": 9,
	"SF1_Sky": 17,
	"SF1_Mountains": 15,
	"SF1_SeaEmpty": 14,
	"SF1_AnicentsFlat": 2,
	"SF1_AncientsStairs": 3,
	"SF1_Cave": 4,
	"SF1_Quarry": 5,
	"SF1_LandBrdige": 6,
	"SF1_Ship": 7,
	"SF1_SeaWithIsland": 8,
	"SF1_GrasslandsFlat": 10,
	"SF1_GrasslandsWithOthers": 11,
	"SF1_Forest": 12,
	"SF1_ForestDense": 13,
	"SF1_Desert": 16,
	"SF1_TownMountainSide": 18,
	"SF1_AncientsBlue": 19,
	"SF1_AncientsAbandonded": 20,
	"SF1_FortGround": 21,
	"SF1_Fort": 22,
	"SF1_Shipyard": 23,
	"SF1_Chapel1": 24,
	"SF1_Chapel2": 25,
	"SF1_Fortress": 26,
	"SF1_Tower": 27,
	"SF1_Castle": 28,
	"SF1_Circus": 29,
	"SF1_AnicentsEntrance": 30,
}

# TODO: clean move this somewhere else thats easier to use across scenes
var tile_name_stand_to_frame_mapping_dictionary = {
	"SF1_Bridge": 0,
	"SF1_Building": 1,
	"SF1_Gravel": 2,
	"SF1_Dirt": 3,
	"SF1_Grass": 4,
	"SF1_Mountain": 5,
	"SF1_Desert": 6,
	"SF1_DirtAndRocks": 7,
	"SF1_Blue": 8,
}

var first_time_mp_cost = true

func _ready():
	Singleton_CommonVariables.battle__scene_node = self
	
	current_target_actor_node = null
	experience_points_gain = 0
	coins_gain = 0
	
	current_initiator_actor_battle_scene_node = null
	current_target_actor_battle_scene_node = null
	
	cleanup_wrappers()

func cleanup_wrappers() -> void:
	# Remove all Pre-existing backgrounds
	for b in background_wrapper.get_children():
		b.queue_free()
	
	# Remove all Enemeies and Characters 
	for e in enemeyWrapper.get_children(): 
		e.queue_free()
	for c in characterWrapper.get_children(): 
		c.queue_free()
	
	# Remove any remaining spells battle animations
	for s in spells_wrapper.get_children():
		s.queue_free()



var allies
var targetables 
func set_attack_target_selection(actor_type: int) -> void:
	if actor_type == 1: #  "character":
		allies = "character"
		targetables = "enemey"
	elif actor_type == 2: # "enemey":
		allies = "enemey"
		targetables = "character"

func is_actor_type_targetable(actor_type_to_check: String) -> bool:
	# print(Singleton_CommonVariables.battle__target_actor_types, " ", target_type, " ", actor_type_to_check, " ", actor_root.actor_type)
	
	if Singleton_CommonVariables.battle__target_actor_types == "Allies":
		if allies == actor_type_to_check:
			return true
	elif Singleton_CommonVariables.battle__target_actor_types == "Opposing":
		if targetables == actor_type_to_check: 
			return true
	if Singleton_CommonVariables.battle__target_actor_types == "Self":
		if allies == actor_type_to_check:
			return true
	
	return false

var battle__target_array_flattened = []
var a_node = null
func pre_activate_battle_setup() -> void:
	## reset all battle scene logic variables to defaults on new active battle start
	current_target_actor_node = null
	experience_points_gain = 0
	coins_gain = 0
	
	current_initiator_actor_battle_scene_node = null
	current_target_actor_battle_scene_node = null
	
	current_initiator_actor_id = -1
	current_target_actor_id = -1
	first_time_mp_cost = true
	##
	
	Singleton_CommonVariables.ui__actor_micro_info_box.hide_cust()
	Singleton_CommonVariables.ui__target_actor_micro_info_box.hide_cust_target()
	
	set_attack_target_selection(Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type)
	
	battle__target_array_flattened = []
	for i in Singleton_CommonVariables.battle__target_array.size():
		for j in Singleton_CommonVariables.battle__target_array.size():
			if Singleton_CommonVariables.battle__target_array[i][j].actor_type != "na":
				battle__target_array_flattened.append(Singleton_CommonVariables.battle__target_array[i][j])
	
	a_node = null
	for i in battle__target_array_flattened.size():
		if battle__target_array_flattened[i].actor_type == "na":
			continue
		
		if battle__target_array_flattened[i].actor_type == targetables:
			a_node = battle__target_array_flattened[i].node
	


func activate_battle() -> void:
	pre_activate_battle_setup()
	
	await Singleton_CommonVariables.top_level_fader_node.play_fade_in_quick()
	
	Singleton_CommonVariables.battle__scene_node.show()
	
	
	# display
	if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1: # character
		Singleton_CommonVariables.ui__actor_micro_info_box.display_actor_info(Singleton_CommonVariables.battle__currently_active_actor)
		if a_node != null:
			Singleton_CommonVariables.ui__target_actor_micro_info_box.display_actor_info(a_node)
			Singleton_CommonVariables.ui__target_actor_micro_info_box.show_cust_target_battle_scene()
		
		Singleton_CommonVariables.ui__actor_micro_info_box.show_cust()
		
	if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2: # enemey
		if a_node != null:
			Singleton_CommonVariables.ui__actor_micro_info_box.display_actor_info(a_node)
			Singleton_CommonVariables.ui__actor_micro_info_box.show_cust()
		Singleton_CommonVariables.ui__target_actor_micro_info_box.display_actor_info(Singleton_CommonVariables.battle__currently_active_actor)
		Singleton_CommonVariables.ui__target_actor_micro_info_box.show_cust_target_battle_scene()
	
	print("Battle Target Selection Type - ", Singleton_CommonVariables.battle__target_selection_type)
	
	# Singleton_AudioManager.play_alt_music_n(Singleton_DevToolingManager.base_path + "Assets/SF1/SoundBank/Battle Encounter.mp3")
	

	
	var cur_actor_node
	var caa_bs
	# Setup currently active actor 
	print(Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type)
	if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2: # enemey
		var a = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("EnemeyRoot")
		current_initiator_actor_node = a
		current_initiator_actor_parent_node = Singleton_CommonVariables.battle__currently_active_actor
		cur_actor_node = a
		caa_bs = a.enemey_battle_scene.instantiate()
		# caa_bs.position = Vector2(216, 152) # spot where all actor stands should reach to
		
		var bs = background_scene.instantiate()
		background_wrapper.add_child(bs)
		bs.set_foreground_frame(tile_name_to_frame_mapping_dictionary[
			get_foreground_value_at_cell_at_pos(
				Singleton_CommonVariables.battle__currently_active_actor.get_child(0).global_position
			)
		])
		bs.set_background_frame(tile_name_to_frame_mapping_dictionary[
			get_background_value_at_cell_at_pos(
				Singleton_CommonVariables.battle__currently_active_actor.get_child(0).global_position
			)
		])
		
		enemeyWrapper.add_child(caa_bs)
		current_initiator_actor_battle_scene_node = caa_bs
	elif Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1: # character
		var a = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot")
		current_initiator_actor_node = a
		current_initiator_actor_parent_node = Singleton_CommonVariables.battle__currently_active_actor
		cur_actor_node = a
		caa_bs = a.battle__scene_unpromoted.instantiate()
		caa_bs.position = character_position # spot where all actor stands should reach to
		
		caa_bs.get_child(0).frame = tile_name_stand_to_frame_mapping_dictionary[
			get_stand_value_at_cell_at_pos(
				Singleton_CommonVariables.battle__currently_active_actor.get_child(0).global_position
			)
		]
		
		#	# TODO: create function in chracter base to automatically pass back the equipped item
		#	var weapon_res = char_actor_rn.inventory_items_id[0] 
		#	# load("res://SF1/Items/Weapons/WoodenArrow.tres") # Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").inventory_items_id[0]
		#	internal_init_weapon_for_actor(weaponSprite, weapon_res)
		
		characterWrapper.add_child(caa_bs)
		current_initiator_actor_battle_scene_node = caa_bs
	
	var cur_idx = -1 
	var first_cast = true
	for i in battle__target_array_flattened.size():
		# if enemey actor
		if battle__target_array_flattened[i].actor_type == "na":
			continue
		
		if battle__target_array_flattened[i].actor_type == "enemey":
			cur_idx = i
			var bs = background_scene.instantiate()
			
			var a = battle__target_array_flattened[i].node.get_child(0).find_child("EnemeyRoot")
			current_target_actor_id = battle__target_array_flattened[i].node.get_instance_id()
			
			current_target_actor_parent_node = battle__target_array_flattened[i].node
			
			var ebs = a.enemey_battle_scene.instantiate()
			current_target_actor_battle_scene_node = ebs
			
			current_target_actor_node = a
			
			background_wrapper.add_child(bs)
			bs.set_foreground_frame(tile_name_to_frame_mapping_dictionary[battle__target_array_flattened[i].foreground])
			bs.set_background_frame(tile_name_to_frame_mapping_dictionary[battle__target_array_flattened[i].background])
			# after tween hide
			bs.hide_extra_backgrounds()
			
			enemeyWrapper.add_child(ebs)
			break
		elif battle__target_array_flattened[i].actor_type == "character":
			cur_idx = i
			var a = battle__target_array_flattened[i].node.get_child(0).find_child("CharacterRoot")
			current_target_actor_id = battle__target_array_flattened[i].node.get_instance_id()
			current_target_actor_parent_node = battle__target_array_flattened[i].node
			
			var a_bs = a.battle__scene_unpromoted.instantiate()
			a_bs.position = character_position
			
			current_target_actor_battle_scene_node = a_bs
			
			a_bs.get_child(0).frame = tile_name_stand_to_frame_mapping_dictionary[
				get_stand_value_at_cell_at_pos(
					a.global_position
				)
			]
			
			#	# TODO: create function in chracter base to automatically pass back the equipped item
			#	var weapon_res = char_actor_rn.inventory_items_id[0] 
			#	# load("res://SF1/Items/Weapons/WoodenArrow.tres") # Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").inventory_items_id[0]
			#	internal_init_weapon_for_actor(weaponSprite, weapon_res)
			
			current_target_actor_node = a
			
			characterWrapper.add_child(a_bs)
			
			break
	
	
	# as fade out is playing should also tween background character and enemey
	await Singleton_CommonVariables.top_level_fader_node.play_fade_out_quick()
	
	if battle__target_array_flattened[cur_idx].actor_type == "enemey":
		# Do Battle Scene for current actors
		await get_tree().create_timer(0.5).timeout
		
		if Singleton_CommonVariables.battle__resource_animation_scene_path == null:
			await display_battle_message(cur_actor_node.get_actor_name() + " Attacks!")
			# await Signal(self, "signal__function_completed")
			await get_tree().create_timer(0.2).timeout
			
		# play animation for attack or spell or use item here
			# await 
			
			print("attack normal")
			caa_bs.connect("attack_frame_reached", Callable(attack_frame_reached))
			caa_bs.connect("attack_anticapation_frame_reached", Callable(attack_anticapation_frame_reached))
			caa_bs.connect("spell_cast_frame_reached", Callable(cast_anticapation_frame_reached))
			
			if Singleton_CommonVariables.battle__target_selection_type == "magic":
				caa_bs.play_cast()
			else:
				caa_bs.play_attack_normal()
			
			# await Signal(caa_bs, "battle__animation_completed")
			await Signal(self, "signal__current_actor_exchange_completed")
			print("play Idle")
			caa_bs.play_idle()
		else:
			print("spell animation")
			
			
			if first_cast:
				first_cast = false
				await display_battle_message(cur_actor_node.get_actor_name() + " casts!")
				
				caa_bs.connect("spell_cast_frame_reached", Callable(cast_anticapation_frame_reached))
				caa_bs.play_cast()
				await get_tree().create_timer(0.5).timeout
				
				# await Signal(self, "signal__function_completed")
				await get_tree().create_timer(0.2).timeout
				
				var spell_bs = load(Singleton_CommonVariables.battle__resource_animation_scene_path).instantiate()
				spells_wrapper.add_child(spell_bs)
			
			
			
			await get_tree().create_timer(0.5).timeout
			attack_frame_reached()
			await Signal(self, "signal__current_actor_exchange_completed")
		
		await get_tree().create_timer(0.5).timeout
		
	elif battle__target_array_flattened[cur_idx].actor_type == "character":
			# Do Battle Scene for current actors
			await get_tree().create_timer(0.5).timeout
			await display_battle_message(cur_actor_node.get_actor_name() + " Attacks!") # print_who_is_attacking
			# await Signal(self, "signal__function_completed")
			await get_tree().create_timer(0.2).timeout
			
			# play animation for attack or spell or use item here
			# await 
			
			print("attack normal")
			caa_bs.connect("attack_frame_reached", Callable(attack_frame_reached))
			caa_bs.connect("attack_anticapation_frame_reached", Callable(attack_anticapation_frame_reached))
			caa_bs.connect("spell_cast_frame_reached", Callable(cast_anticapation_frame_reached))
				
			if Singleton_CommonVariables.battle__target_selection_type == "magic":
				caa_bs.play_cast()
			else:
				caa_bs.play_attack_normal()
			
			await Signal(self, "signal__current_actor_exchange_completed")
			# await Signal(caa_bs, "battle__animation_completed")
			print("play Idle")
			caa_bs.play_idle()
			
			await get_tree().create_timer(0.5).timeout
			
			print("Next Actor")
			
	
	# var btaf_size = battle__target_array_flattened.size()
	
	# setup first target
	for i in range(cur_idx + 1, battle__target_array_flattened.size()):
		# if enemey actor
		if battle__target_array_flattened[i].actor_type == "na":
			continue
		
		if battle__target_array_flattened[i].actor_type == "enemey":
			var bs = background_scene.instantiate()
			
			var a = battle__target_array_flattened[i].node.get_child(0).find_child("EnemeyRoot")
			current_target_actor_id = battle__target_array_flattened[i].node.get_instance_id()
			
			current_target_actor_parent_node = battle__target_array_flattened[i].node
			
			var ebs = a.enemey_battle_scene.instantiate()
			current_target_actor_battle_scene_node = ebs
			
			current_target_actor_node = a
			
			
			# do transition
			bs.position = Vector2(640, 0)
			ebs.position = Vector2(640, 0)
			
			var bc = background_wrapper.get_child(0)
			var ec = enemeyWrapper.get_child(0)
			
			scene_transition.position = transition_screen_default_position
			
			background_wrapper.add_child(bs)
			bs.set_foreground_frame(tile_name_to_frame_mapping_dictionary[battle__target_array_flattened[i].foreground])
			bs.set_background_frame(tile_name_to_frame_mapping_dictionary[battle__target_array_flattened[i].background])
			# after tween hide
			bs.hide_extra_backgrounds()
			
			enemeyWrapper.add_child(ebs)
			
			var tween_tim = 0.25
			var _t = create_tween().set_parallel(true)
			_t.tween_property(bc, "position", Vector2(bc.position.x -320, bc.position.y), tween_tim)
			_t.tween_property(ec, "position", Vector2(ec.position.x -320, ec.position.y), tween_tim)
			_t.tween_property(scene_transition, "position", Vector2(transition_screen_default_position.x - 448, transition_screen_default_position.y), tween_tim)
			_t.tween_property(bs, "position", Vector2(bs.position.x -640, bs.position.y), tween_tim)
			_t.tween_property(ebs, "position", Vector2(ebs.position.x -640, ebs.position.y), tween_tim)
			
			await _t.finished
			bc.queue_free()
			ec.queue_free()
			
			# await get_tree().create_timer(5.0).timeout
			bs.position = Vector2(0, 0)
			ebs.position = Vector2(0, 0)
			
			
			# check if spell or something
			
			# Do Battle Scene for current actors
			await get_tree().create_timer(0.5).timeout
			
			if Singleton_CommonVariables.battle__resource_animation_scene_path == null:
				await display_battle_message(cur_actor_node.get_actor_name() + " Attacks!")
				# await Signal(self, "signal__function_completed")
				await get_tree().create_timer(0.2).timeout
				
				# play animation for attack or spell or use item here
				# await 
				
				print("attack normal")
				caa_bs.connect("attack_frame_reached", Callable(attack_frame_reached))
				caa_bs.connect("attack_anticapation_frame_reached", Callable(attack_anticapation_frame_reached))
				caa_bs.connect("spell_cast_frame_reached", Callable(cast_anticapation_frame_reached))
				
				if Singleton_CommonVariables.battle__target_selection_type == "magic":
					caa_bs.play_cast()
				else:
					caa_bs.play_attack_normal()
				
				# await Signal(caa_bs, "battle__animation_completed")
				await Signal(self, "signal__current_actor_exchange_completed")
				print("play Idle")
				caa_bs.play_idle()
			else:
				print("spell animation")
				
#				if first_cast:
#					first_cast = false
#					await display_battle_message(cur_actor_node.get_actor_name() + " casts!")
#					# await Signal(self, "signal__function_completed")
#					await get_tree().create_timer(0.2).timeout
#
#					var spell_bs = load(Singleton_CommonVariables.battle__resource_animation_scene_path).instantiate()
#					spells_wrapper.add_child(spell_bs)
				
				await get_tree().create_timer(0.5).timeout
				attack_frame_reached()
				await Signal(self, "signal__current_actor_exchange_completed")
			
			await get_tree().create_timer(0.5).timeout
			
			print("Next Actor")
			
		elif battle__target_array_flattened[i].actor_type == "character":
			var a = battle__target_array_flattened[i].node.get_child(0).find_child("CharacterRoot")
			current_target_actor_id = battle__target_array_flattened[i].node.get_instance_id()
			current_target_actor_parent_node = battle__target_array_flattened[i].node
			
			var a_bs = a.battle__scene_unpromoted.instantiate()
			a_bs.position = character_position
			
			current_target_actor_battle_scene_node = a_bs
			
			a_bs.get_child(0).frame = tile_name_stand_to_frame_mapping_dictionary[
				get_stand_value_at_cell_at_pos(
					a.global_position
				)
			]
			
			#	# TODO: create function in chracter base to automatically pass back the equipped item
			#	var weapon_res = char_actor_rn.inventory_items_id[0] 
			#	# load("res://SF1/Items/Weapons/WoodenArrow.tres") # Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").inventory_items_id[0]
			#	internal_init_weapon_for_actor(weaponSprite, weapon_res)
			
			current_target_actor_node = a
			
			
			# do transition
			a_bs.position = Vector2(640, 0)
			
			var cc = characterWrapper.get_child(0)
			scene_transition.position = transition_screen_default_position
			characterWrapper.add_child(a_bs)
			
			var tween_tim = 0.25
			var _t = create_tween().set_parallel(true)
			_t.tween_property(cc, "position", Vector2(cc.position.x -320, cc.position.y), tween_tim)
			_t.tween_property(scene_transition, "position", Vector2(transition_screen_default_position.x - 448, transition_screen_default_position.y), tween_tim)
			_t.tween_property(a_bs, "position", character_position, tween_tim)
			
			await _t.finished
			cc.queue_free()
			
			
			# check if spell or something
			
			# Do Battle Scene for current actors
			await get_tree().create_timer(0.5).timeout
			await display_battle_message(cur_actor_node.get_actor_name() + " Attacks!") # print_who_is_attacking
			# await Signal(self, "signal__function_completed")
			await get_tree().create_timer(0.2).timeout
			
			# play animation for attack or spell or use item here
			# await 
			
			print("attack normal")
			caa_bs.connect("attack_frame_reached", Callable(attack_frame_reached))
			caa_bs.connect("attack_anticapation_frame_reached", Callable(attack_anticapation_frame_reached))
			caa_bs.connect("spell_cast_frame_reached", Callable(cast_anticapation_frame_reached))
			
			if Singleton_CommonVariables.battle__target_selection_type == "magic":
				caa_bs.play_cast()
			else:
				caa_bs.play_attack_normal()
			
			await Signal(self, "signal__current_actor_exchange_completed")
			# await Signal(caa_bs, "battle__animation_completed")
			print("play Idle")
			caa_bs.play_idle()
			
			await get_tree().create_timer(0.5).timeout
			
			print("Next Actor")
			
			
		
		# if character
		# Singleton_CommonVariables.battle__target_array[0][0].stand
	
	# do battle scene
	
	# return to currently active actor and do exp lvl calcs etcs now
	# exp level
	# print("TODO: generate stat gain and print based on character stat curves")
	# print(Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type)
	if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1: # character
		if experience_points_gain > 48:
			experience_points_gain = 48 # limit exp gain main to 48 for cases like blaze 2
		
		current_initiator_actor_node.set_exp(current_initiator_actor_node.get_exp() + experience_points_gain)
		print("Current EXP - ", current_initiator_actor_node.get_exp())
		
		# exp
		await display_battle_message(current_initiator_actor_node.get_actor_name() + " gains " + str(experience_points_gain) + " experience points.")
		
		if coins_gain > 0:
			await display_battle_message(current_initiator_actor_node.get_actor_name() + " gains " + str(coins_gain) + " coins.")
		
		# TODO: level up
		if current_initiator_actor_node.get_exp() >= 100:
			current_initiator_actor_node.set_exp(0)
			# initator_actor.level += 1
		
			await display_battle_message(
				current_initiator_actor_node.get_actor_name() + "'s level increases to " + str(current_initiator_actor_node.get_level()) + "!"
			)
			# await Signal(get_tree().create_timer(1), "timeout")
	
	
	# cleanup
	
	await Singleton_CommonVariables.top_level_fader_node.play_fade_in_quick()
	cleanup_wrappers()
	
	Singleton_CommonVariables.ui__actor_micro_info_box.hide_cust()
	Singleton_CommonVariables.ui__target_actor_micro_info_box.hide_cust_target_battle_scene()
	
	hide()
	await Singleton_CommonVariables.top_level_fader_node.play_fade_out_quick()

### 

# TODO: make TilesInformationGroup its own scene and move a lot of this logic into it directly 
func get_background_value_at_cell_at_pos(pos_arg: Vector2):
	var local_pos = Singleton_CommonVariables.battle__tilemap_info_group__background.local_to_map(pos_arg)
	var current_tile_posx = Singleton_CommonVariables.battle__tilemap_info_group__background.get_cell_tile_data(0, local_pos)
	
	if current_tile_posx != null:
		return current_tile_posx.custom_data_0
	
	return null

func get_foreground_value_at_cell_at_pos(pos_arg: Vector2):
	var local_pos = Singleton_CommonVariables.battle__tilemap_info_group__foreground.local_to_map(pos_arg)
	var current_tile_posx = Singleton_CommonVariables.battle__tilemap_info_group__foreground.get_cell_tile_data(0, local_pos)
	
	if current_tile_posx != null:
		return current_tile_posx.custom_data_0
	
	return null

func get_stand_value_at_cell_at_pos(pos_arg: Vector2):
	var local_pos = Singleton_CommonVariables.battle__tilemap_info_group__stand.local_to_map(pos_arg)
	var current_tile_posx = Singleton_CommonVariables.battle__tilemap_info_group__stand.get_cell_tile_data(0, local_pos)
	
	if current_tile_posx != null:
		return current_tile_posx.custom_data_0
	
	return null

###

func display_battle_message(display_str: String) -> Signal:
	Singleton_CommonVariables.dialogue_box_node.show()
	
	Singleton_CommonVariables.dialogue_box_node.battle_message_play(display_str)
	await Signal(Singleton_CommonVariables.dialogue_box_node, "signal_dialogue_completed")
	
	return signal__function_completed

# TODO: print item recieved
# TODO: if items check if actor has empty slot and add it
# otherwise add it to item box
# TODO: also make item box

func print_spell_usage() -> void:
	var active_actor = Singleton_CommonVariables.currently_active_character.get_node("CharacterRoot")

	# Singleton_CommonVariables.dialogue_box_node.battle_message_play(active_actor.cget_actor_name() + " Attacks!")
	Singleton_CommonVariables.dialogue_box_node.battle_message_play(
		active_actor.cget_actor_name() + " casts " + active_actor.spells_id[0].name + " level 1."
		)

var is_critical_hit = false
func attack_anticapation_frame_reached() -> void:
	is_critical_hit = false
	
	rng.randomize()
	
	# if rng.randi_range(0, 99) < 99:
	if rng.randi_range(0, 99) < 10:
		current_initiator_actor_battle_scene_node.pause_animation()
		
		Singleton_AudioManager.play_sfx("res://Assets/Sounds/CriticalSound.wav")
		
		is_critical_hit = true
		
		await get_tree().create_timer(0.5).timeout
		
		current_initiator_actor_battle_scene_node.resume_animation()


func attack_frame_reached() -> void:
	print("attack frame reached ahh yaa")
	
#	if using_spell:
#		Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Cast_Spell.wav")
#		char_animationPlayer.stop(false)
#	else:
#		if attack_missed:
#			Singleton_AudioManager.play_sfx("res://Assets/Sounds/DodgeSound.wav")
#			emit_signal("signal_attack_frame_reached")
#		else:
#			Singleton_AudioManager.play_sfx("res://Assets/Sounds/HitSoundCut.wav")
#			emit_signal("signal_attack_frame_reached")
	
	calculate_damage_step()

func cast_anticapation_frame_reached() -> void:
	current_initiator_actor_battle_scene_node.pause_animation()
	
	Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Cast_Spell.wav")
	
	await get_tree().create_timer(0.3).timeout
	
	current_initiator_actor_battle_scene_node.resume_animation()
	
	# TODO: clean up called after play_cast is called
	# calculate_damage_step()

func calculate_damage_step() -> void:
	var initator_actor = current_initiator_actor_node # Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot") # current_target_actor_node
	var targeted_actor = current_target_actor_node # Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot")
	
	# TODO: should display actor boxes earlier than damage step
	#	# Singleton_Game_GlobalBattleVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_active_character)
	#	# Singleton_Game_GlobalBattleVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_active_character)
	
	# var using_spell = false
	var attack_missed = false
	
	var damage = 0
	
	if Singleton_CommonVariables.battle__target_selection_type == "magic":
		# TODO: redo this entire section
		# print(initator_actor.get_magic())
		
		var spell_res = load(initator_actor.get_magic()[0].resource)
		
		var damage_min = spell_res.levels[Singleton_CommonVariables.battle__magic_spell_level_selected].min_range
		var damage_max = spell_res.levels[Singleton_CommonVariables.battle__magic_spell_level_selected].max_range
		var mp_cost = spell_res.levels[Singleton_CommonVariables.battle__magic_spell_level_selected].mp_usage_cost
		
		rng.randomize()
		
		# TODO: probably should do something like 60% chance of hitting a 6 and 20% for a 5 or 7 for blaze
		# that seems to be closer to the actual odds vs a blind random chance of 5-7
		damage = rng.randi_range(damage_max, damage_min)
		if damage <= 0:
			damage = 1
		
		# TODO: only detract mg once
		if first_time_mp_cost:
			initator_actor.set_mp_current(initator_actor.get_mp_current() - mp_cost)
			first_time_mp_cost = false
		
		Singleton_CommonVariables.ui__actor_micro_info_box.display_actor_info(current_target_actor_parent_node)
		# Singleton_CommonVariables.battle_base.activeActorMicroInfoRoot.display_micro_info_for_actor(Singleton_CommonVariables.currently_active_character)
	else:
		# max attack value
		var max_damage = initator_actor.get_attack() - targeted_actor.get_defense()
		if max_damage <= 0:
			max_damage = 1
		
		# min attack value
		var min_damage = floor(max_damage - floor(max_damage * 0.25))
		
		rng.randomize()
		
		damage = rng.randi_range(max_damage, min_damage)
		if damage <= 0:
			damage = 1
		
		if is_critical_hit:
			damage = floor(damage * 1.5)
		
		if attack_missed:
			damage = 0
		
		
	if targeted_actor.get_hp_current() - damage <= 0:
		targeted_actor.set_hp_current(0)
	else:
		targeted_actor.set_hp_current(targeted_actor.get_hp_current() - damage)
	
	print(initator_actor.get_attack(), targeted_actor.get_defense())
	
# 	TODO: update micro actors boxes after attack hp current set
#	Singleton_CommonVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_CommonVariables.currently_active_character)
#	Singleton_CommonVariables.battle_base.activeActorMicroInfoRoot.display_micro_info_for_actor(Singleton_CommonVariables.currently_selected_actor)
	
	if current_initiator_actor_parent_node.get_child(0).actor_type == 1: # character
		Singleton_CommonVariables.ui__actor_micro_info_box.display_actor_info(current_initiator_actor_parent_node)
		Singleton_CommonVariables.ui__target_actor_micro_info_box.display_actor_info(current_target_actor_parent_node)
	if current_initiator_actor_parent_node.get_child(0).actor_type == 2: # enemey
		Singleton_CommonVariables.ui__actor_micro_info_box.display_actor_info(current_target_actor_parent_node)
		Singleton_CommonVariables.ui__target_actor_micro_info_box.display_actor_info(current_initiator_actor_parent_node)
	
#
#	# enemeySprite.material.shader = shader_color_blend
#	# enemeySprite.material.set_shader_param("blend_strength_modifier", 0.35)
	
	if not attack_missed:
#		if using_spell:
		Singleton_AudioManager.play_sfx("res://Assets/Sounds/HitSoundCut.wav")
#
# 		target_actor Sprite.material.shader = shader_color_blend
#		target_actor Sprite.material.set_shader_param("blend_strength_modifier", 0.35)
		
		current_target_actor_battle_scene_node.play_shake()
		await get_tree().create_timer(0.3).timeout
		if targeted_actor.get_hp_current() <= 0:
			current_target_actor_battle_scene_node.play_death()
		
		if is_critical_hit:
			var _ignore = await display_battle_message("A stunning attack! " + targeted_actor.get_actor_name() + " suffers " + str(damage) + " points of damage.")
		else:
			if initator_actor.actor_type == "character":
				var _ignore = await display_battle_message("Inflicts " + str(damage) + " points of damage on the " + targeted_actor.get_actor_name() + ".")
			else:
				var _ignore = await display_battle_message("Inflicts " + str(damage) + " points of damage to " + targeted_actor.get_actor_name() + ".")
	else:
		var _ignore = await display_battle_message(initator_actor.get_actor_name() + " evades the attack!")
	
	
	if initator_actor.actor_type == "character":
		accumulate_exp_gain(damage)
	
	if targeted_actor.get_hp_current() <= 0:
		# current_target_actor_battle_scene_node.play_death()
		if targeted_actor.actor_type == "character":
			await display_battle_message(targeted_actor.get_actor_name() + " can no longer fight.")
		elif targeted_actor.actor_type == "enemey":
			await display_battle_message(targeted_actor.get_actor_name() + " is defeated!")
		
		for b_idx in Singleton_CommonVariables.battle__turn_order_array.size():
			if current_target_actor_id == Singleton_CommonVariables.battle__turn_order_array[b_idx].id:
				Singleton_CommonVariables.battle__turn_order_array[b_idx].alive = false
				break
	
	#	enemeySprite.material.set_shader_param("blend_strength_modifier", 0.0)
	# TODO: play idle for both actors 
	
	if initator_actor.actor_type == "character":
		if targeted_actor.get_hp_current() <= 0:
			coins_gain += targeted_actor.get_coins()
			# todo accumlate coins and items here
			# await accumlate exp and coints # print_coins_and_items_receieved() # 0 coins and no items for now
			pass
	
	Singleton_CommonVariables.dialogue_box_node.hide()
	
	await Signal(get_tree().create_timer(0.5), "timeout")
	
	emit_signal("signal__current_actor_exchange_completed")
	# return damage



func accumulate_exp_gain(damage_arg: int) -> void:
	var initator_actor = current_initiator_actor_node # Character
	var targeted_actor = current_target_actor_node # Enemey
	
	var x = 2 * ((targeted_actor.get_level() - initator_actor.get_level()) + 3)
	var y = (x * damage_arg) / initator_actor.get_hp_total()
	if y <= 1:
		y = 1
	elif y >= 48:
		y = 48

	if targeted_actor.get_hp_current() <= 0:
		x += (x * 3) + 1 # bonus exp for kill based on x max

	var exp_gain = floor(x + y)
	if damage_arg <= 0:
		exp_gain = 1

	if exp_gain >= 48:
		exp_gain = 48
	elif exp_gain <= 1:
		exp_gain = 1
	
	experience_points_gain += exp_gain
	
	# print("EXP Gain numbers ", x, " ", y, " ", exp_gain)


#func internal_signal_print_recover_amount() -> void:
#	var active_actor = Singleton_CommonVariables.currently_selected_actor.get_node("CharacterRoot")
#	Singleton_AudioManager.play_sfx("res://Assets/Sounds/HealSound.wav")
#
#	heal_amount = 10
#
#	if heal_amount + active_actor.HP_Current >= active_actor.HP_Total:
#		heal_amount = active_actor.HP_Total - active_actor.HP_Current
#	else:
#		heal_amount = 10
#
#	active_actor.HP_Current += heal_amount
#
#	# active_actor.HP_Current
#	# active_actor.HP_Total
#
#	Singleton_CommonVariables.battle_base.activeActorMicroInfoRoot.display_micro_info_for_actor(Singleton_CommonVariables.currently_selected_actor)
#
#	Singleton_CommonVariables.dialogue_box_node.show()
#	Singleton_CommonVariables.dialogue_box_node.battle_message_play(
#		# active_actor.cget_actor_name() + " gains " + str(exp_gain) + " experience points."
#		active_actor.cget_actor_name() + " regains " + str(heal_amount) + " hit points."
#	)
#	await Signal(Singleton_CommonVariables.dialogue_box_node, "signal_dialogue_completed")
#
#
#	print("Print Recover amount")


#func internal_signal_switch_back_to_active_actor() -> void:
#	print("Go back to lowe")
#
#	# print_exp_gain(0)
#	var exp_gain = 0
#	if heal_amount == 0:
#		exp_gain = 1
#	else:
#		exp_gain = 10
#
#	Singleton_CommonVariables.dialogue_box_node.battle_message_play(
#		active_actor.cget_actor_name() + " gains " + str(exp_gain) + " experience points."
#	)
#	await Signal(Singleton_CommonVariables.dialogue_box_node, "signal_dialogue_completed")
#
#	active_actor.MP_Current -= active_actor.spells_id[0].levels[0].mp_usage_cost
#
#	active_actor.experience_points += exp_gain
#	if active_actor.experience_points >= 100:
#		active_actor.experience_points = 0
#		active_actor.level += 1
#
#		print("TODO print level up and stat gain")
# 	
#	print("Complete Heal Step")
#
#	$CharacterTargetWrapper/AnimationPlayer.remove_animation("Target Idle")
#
#	await Signal(get_tree().create_timer(1.5), "timeout")
#	Singleton_CommonVariables.currently_active_character.z_index = 1
#	# Singleton_Game_AudioManager.pause_all_music()
#	$CanvasLayerSpellWrapper/SpellWrapper/AnimationPlayer.playback_speed = 1
#
#	# let the fairy fly off 
#	# TODO: redo the structure for the heal animation
#	# having different timings for the animation calls vs the function yields causes too many time differences
#	# when doing multi target selection (for blaze 2) refine these along with that development
#	await Signal(get_tree().create_timer(0.75), "timeout")
#
#	Singleton_CommonVariables.top_level_fader_node.black_fade_anim_in()
#	await Signal(get_tree().create_timer(0.4), "timeout")
#	Singleton_CommonVariables.camera_node.reset_camera_for_map()
#	await Signal(get_tree().create_timer(0.25), "timeout")
#	print("Complete Battle Scene")
#	internal_reset_all_actor_sprites_back_to_default_position()
#
#	Singleton_CommonVariables.camera_node.reset_camera_for_map()
#	emit_signal("signal_battle_scene_complete")
#	Singleton_AudioManager.stop_alt_music_n()
#
#	Singleton_CommonVariables.top_level_fader_node.black_fade_anim_out()
#
#	Singleton_CommonVariables.is_currently_in_battle_scene = false
#
#	await Signal(get_tree().create_timer(0.5), "timeout")
#
#	# Singleton_Game_GlobalBattleVariables.camera_node.playerNode = Singleton_Game_GlobalBattleVariables.currently_active_character
#
#	Singleton_AudioManager.play_music_n(Singleton_DevToolingManager.base_path + "Assets/SF1/SoundBank/Battle 1 (Standard).mp3")
