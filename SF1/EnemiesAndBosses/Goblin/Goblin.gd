extends Node2D

signal signal_completed_turn
signal signal_move_direction_completed
# TODO: refactor later signal is used false positive
# warning-ignore:unused_signal
signal signal_battle_scene_animation_completed

@export var is_npc: bool = false

@onready var body = $EnemeyRoot/CharacterBody2D
@onready var tween = $EnemeyRoot/CharacterBody2D/Tween
@onready var animationPlayer = $EnemeyRoot/AnimationPlayer
@onready var animationTree = $EnemeyRoot/AnimationTree
@onready var animationTreeState = animationTree.get("parameters/playback")
@onready var enemey_actor_root = $EnemeyRoot

const TILE_SIZE: int = 24

var _timer = null

var rng = RandomNumberGenerator.new()

@export var battle_logic_script: String

func _ready():
	animationPlayer.play("DownMovement")
	
	tween.connect("finished",Callable(self,"s_tween_completed"))
	
	if !is_npc:
		_timer = Timer.new()
		add_child(_timer)
		_timer.connect("timeout",Callable(self,"_on_Timer_timeout"))
		_timer.set_wait_time(1.0)
		_timer.set_one_shot(false) # Make sure it loops
		_timer.start()
	


func get_character_movement():
	return enemey_actor_root.move

func get_character_current_pos() -> Vector2:
	# print("here", kinematicBody)
	return enemey_actor_root.position


func _on_Timer_timeout():
	#print("Second")
	rng.randomize()
	random_move_direction(rng.randi_range(0, 3))
	
func random_move_direction(direction):
	#if tween.is_active():
	#	return
	
	# print("Direction", direction)
	# print("Position", position)
	
	if direction == 0:
		if enemey_actor_root.check_if_move_is_possible(Vector2(position.x + TILE_SIZE, position.y)):
			animationPlayer.playback_speed = 2
			Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
			animationPlayer.play("RightMovement")
			tween.interpolate_property(self, 'position', position, Vector2(position.x + TILE_SIZE, position.y), 0.2, Tween.TRANS_LINEAR)
			tween.start()
			return
	elif direction == 1:
		
		if enemey_actor_root.check_if_move_is_possible(Vector2(position.x - TILE_SIZE, position.y)):
			animationPlayer.playback_speed = 2
			Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
			animationPlayer.play("LeftMovement")
			tween.interpolate_property(self, 'position', position, Vector2(position.x - TILE_SIZE, position.y), 0.2, Tween.TRANS_LINEAR)
			tween.start()
			return
	elif direction == 2:
		
		if enemey_actor_root.check_if_move_is_possible(Vector2(position.x, position.y  - TILE_SIZE)):
			animationPlayer.playback_speed = 2
			Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
			animationPlayer.play("UpMovement")
			tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y - TILE_SIZE), 0.2, Tween.TRANS_LINEAR)
			tween.start()
			return
	elif direction == 3:
		
		if enemey_actor_root.check_if_move_is_possible(Vector2(position.x, position.y  + TILE_SIZE)):
			animationPlayer.playback_speed = 2
			Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
			animationPlayer.play("DownMovement")
			tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y + TILE_SIZE), 0.2, Tween.TRANS_LINEAR)
			tween.start()
			return
	
	# tween.start()
	
	await get_tree().create_timer(0.1).timeout
	emit_signal("signal_move_direction_completed")

func s_tween_completed(node_arg, property_arg): 
	print(node_arg, " ", property_arg)
	emit_signal("signal_move_direction_completed")
	
	
# play_turn
func play_turn():
	# Singleton_Game_GlobalBattleVariables.currently_active_character = self
	
	print("\n" + enemey_actor_root.enemey_name + " Turn Start\n")
	
	if Singleton_Game_GlobalBattleVariables.control_enemies:
		play_turn_as_character()
	# if  Control Enemies
	# play_turn_as_character
	else:
		print("battle_logic_script ", battle_logic_script)
		if not battle_logic_script.is_empty():
			var bls = load(battle_logic_script)
			bls = bls.new()
			bls.play_turn(self)
			await bls.signal_logic_completed
		else:
			# pseudo_ai_turn_determine()
			await get_tree().create_timer(0.1).timeout
			animationPlayer.play("DownMovement")
			emit_signal("signal_completed_turn")
	
		animationPlayer.play("DownMovement")
		emit_signal("signal_completed_turn")
		
		print("\n" + enemey_actor_root.enemey_name + " Turn End\n")

func internal_call_complete() -> void:
	animationPlayer.play("DownMovement")
	emit_signal("signal_completed_turn")


func internal_attack_actor_found() -> void:
	# animationPlayer.play("DownMovement")
	#emit_signal("signal_completed_turn")
	print("ATTTACKKKKKKKKKK")
	# Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro()
	
	await get_tree().create_timer(0.5).timeout
	
	get_parent().get_parent().get_node("TargetSelectionLogicNodeRoot").enemey_actor_attack_setup()

func pseudo_ai_turn_determine():
	for _i in range(4):
		random_move_direction(0)
		await tween.finished
	animationPlayer.play("DownMovement")
	emit_signal("signal_completed_turn")

func s_complete_turn():
	print("\n" + enemey_actor_root.enemey_name + " Turn End\n")
	# $EnemeyRoot.animationPlayer.play("DownMovement")
	
	if Singleton_Game_GlobalBattleVariables.control_enemies:
		s_complete_turn_as_character()
	
	emit_signal("signal_completed_turn")

# Getters
func cget_agility() -> int:
	return enemey_actor_root.agility

func cget_actor_name() -> String: return enemey_actor_root.enemey_name
func cget_class(): return null
func cget_level(): return null
func cget_hp_total() -> int: return enemey_actor_root.HP_Total
func cget_hp_current() -> int: return enemey_actor_root.HP_Current
func cget_mp_total() -> int: return enemey_actor_root.MP_Total
func cget_mp_current() -> int: return enemey_actor_root.MP_Current

func cget_movement_type() -> int: return enemey_actor_root.movement_type

func get_actor_root_node_internal():
	return get_node("EnemeyRoot")


func is_character_actor_within_attack_range():
	for character in Singleton_Game_GlobalBattleVariables.character_nodes.get_children():
		# print("\n", character.position, " ", Vector2(pself.position.x - 24, pself.position.y))
		if character.position == Vector2(position.x - 24, position.y):
			Singleton_Game_GlobalBattleVariables.currently_selected_actor = character
			return character.position
		# print(character.position, " ", Vector2(pself.position.x + 24, pself.position.y))
		if character.position == Vector2(position.x + 24, position.y):
			Singleton_Game_GlobalBattleVariables.currently_selected_actor = character
			return character.position
		# print(character.position, " ", Vector2(pself.position.x, pself.position.y - 24))
		if character.position == Vector2(position.x, position.y - 24):
			Singleton_Game_GlobalBattleVariables.currently_selected_actor = character
			return character.position
		# print(character.position, " ", Vector2(pself.position.x, pself.position.y + 24))
		if character.position == Vector2(position.x, position.y + 24):
			Singleton_Game_GlobalBattleVariables.currently_selected_actor = character
			return character.position
	
	return Vector2.ZERO

func change_facing_direction(current_selection_pos: Vector2) -> void:
	if position.x < current_selection_pos.x:
		animationPlayer.play("RightMovement")
	elif position.x > current_selection_pos.x:
		animationPlayer.play("LeftMovement")
	elif position.y < current_selection_pos.y:
		animationPlayer.play("DownMovement")
	elif position.y > current_selection_pos.y:
		animationPlayer.play("UpMovement")



# Character Func Starting merge to one actor type core

signal signal_character_moved(new_pos)
signal signal_show_character_action_menu
signal signal_switch_focus_to_cursor

# play_turn
func play_turn_as_character():
	print("\n" + enemey_actor_root.enemey_name + " Turn Start\n")	
	enemey_actor_root.play_turn()
	if enemey_actor_root.connect("signal_completed_turn",Callable(self,"s_complete_turn")) != OK:
		print(enemey_actor_root.enemey_name + " - signal_completed_turn failed to connect")
		
	if enemey_actor_root.connect("signal_character_moved",Callable(self,"s_char_moved"))  != OK:
		print(enemey_actor_root.enemey_name + " - signal_character_moved failed to connect")
		
	if enemey_actor_root.connect("signal_show_character_action_menu",Callable(self,"s_show_character_action_menu")) != OK:
		print(enemey_actor_root.enemey_name + " - signal_show_character_action_menu failed to connect")
	# await self.signal_completed_turn
	
	if enemey_actor_root.connect("signal_switch_focus_to_cursor",Callable(self,"s_switch_focus_to_cursor")) != OK:
		print(enemey_actor_root.enemey_name + " - signal_switch_focus_to_cursor failed to connect")

func s_switch_focus_to_cursor():
	print(enemey_actor_root.enemey_name + " Switch to cursor - \'b\' was pressed\n")
	emit_signal("signal_switch_focus_to_cursor")

func s_complete_turn_as_character():
	print("\n" + enemey_actor_root.enemey_name + " Turn End\n")
	enemey_actor_root.animationPlayer.play("DownMovement")
	enemey_actor_root.disconnect("signal_completed_turn",Callable(self,"s_complete_turn"))
	enemey_actor_root.disconnect("signal_character_moved",Callable(self,"s_char_moved"))
	enemey_actor_root.disconnect("signal_show_character_action_menu",Callable(self,"s_show_character_action_menu"))
	enemey_actor_root.disconnect("signal_switch_focus_to_cursor",Callable(self,"s_switch_focus_to_cursor"))
	emit_signal("signal_completed_turn")

func s_char_moved(new_pos):
	emit_signal("signal_character_moved", new_pos)

func s_show_character_action_menu():
	print("Show Enemey Action Menu")
	emit_signal("signal_show_character_action_menu")

func get_kinematic_body():
	return $CharacterRoot/CharacterBody2D
