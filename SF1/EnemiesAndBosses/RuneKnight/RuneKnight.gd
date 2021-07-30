extends Node2D

signal signal_completed_turn
signal signal_move_direction_completed
signal signal_battle_scene_animation_completed

export var is_npc: bool = false

onready var body = $EnemeyRoot/KinematicBody2D
onready var tween = $EnemeyRoot/KinematicBody2D/Tween
onready var animationPlayer = $EnemeyRoot/AnimationPlayer
onready var animationTree = $EnemeyRoot/AnimationTree
onready var animationTreeState = animationTree.get("parameters/playback")
onready var enemey_actor_root = $EnemeyRoot

const TILE_SIZE: int = 24

var _timer = null

var rng = RandomNumberGenerator.new()

export var battle_logic_script: String

func _ready():
	animationPlayer.play("DownMovement")
	
	tween.connect("tween_completed", self, "s_tween_completed")
	
	if !is_npc:
		_timer = Timer.new()
		add_child(_timer)
		_timer.connect("timeout", self, "_on_Timer_timeout")
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
	
	yield(get_tree().create_timer(0.1), "timeout")
	emit_signal("signal_move_direction_completed")

func s_tween_completed(node_arg, property_arg): 
	print(node_arg, " ", property_arg)
	emit_signal("signal_move_direction_completed")
	
	
# play_turn
func play_turn():
	# Singleton_Game_GlobalBattleVariables.currently_active_character = self
	
	print("\n" + enemey_actor_root.enemey_name + " Turn Start\n")
	
	print("battle_logic_script ", battle_logic_script)
	if not battle_logic_script.empty():
		var bls = load(battle_logic_script)
		bls = bls.new()
		bls.play_turn(self)
		yield(bls, "signal_logic_completed")
	else:
		pseudo_ai_turn_determine()
	
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
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	get_parent().get_parent().get_node("TargetSelectionLogicNodeRoot").enemey_actor_attack_setup()

func pseudo_ai_turn_determine():
	for _i in range(4):
		random_move_direction(0)
		yield(tween, "tween_completed")
	animationPlayer.play("DownMovement")
	emit_signal("signal_completed_turn")

func s_complete_turn():
	print("\n" + enemey_actor_root.enemey_name + " Turn End\n")
	# $EnemeyRoot.animationPlayer.play("DownMovement")
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
