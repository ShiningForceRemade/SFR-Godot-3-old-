extends Node2D

signal signal_completed_turn

export var is_npc: bool = false

onready var body = $EnemeyRoot/KinematicBody2D
onready var tween = $EnemeyRoot/KinematicBody2D/Tween
onready var animationPlayer = $EnemeyRoot/AnimationPlayer
onready var animationTree = $EnemeyRoot/AnimationTree
onready var animationTreeState = animationTree.get("parameters/playback")

const TILE_SIZE: int = 24

var _timer = null

var rng = RandomNumberGenerator.new()

# TODO: should preload this instead of doing it on each enemey actor ai turn
export var battle_logic_script: String

func _ready():
	animationPlayer.play("DownMovement")
	
	if !is_npc:
		_timer = Timer.new()
		add_child(_timer)
		_timer.connect("timeout", self, "_on_Timer_timeout")
		_timer.set_wait_time(1.0)
		_timer.set_one_shot(false) # Make sure it loops
		_timer.start()
	



func get_character_movement():
	return $EnemeyRoot.move

func get_character_current_pos() -> Vector2:
	# print("here", kinematicBody)
	return $EnemeyRoot.position



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
		animationPlayer.play("RightMovement")
		tween.interpolate_property(self, 'position', position, Vector2(position.x + TILE_SIZE, position.y), 0.2, Tween.TRANS_LINEAR)
	elif direction == 1:
		animationPlayer.play("LeftMovement")
		tween.interpolate_property(self, 'position', position, Vector2(position.x - TILE_SIZE, position.y), 0.2, Tween.TRANS_LINEAR)
	elif direction == 2:
		animationPlayer.play("UpMovement")
		tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y - TILE_SIZE), 0.2, Tween.TRANS_LINEAR)
	elif direction == 3:
		animationPlayer.play("DownMovement")
		tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y + TILE_SIZE), 0.2, Tween.TRANS_LINEAR)
	
	tween.start()

# play_turn
func play_turn():
	print("\nDark Dwarf Turn Start\n")
	
	print("battle_logic_script ", battle_logic_script)
	if not battle_logic_script.empty():
		var bls = load(battle_logic_script)
		bls = bls.new()
		bls.play_turn(self)
		# yield(bls, "signal_logic_completed")
	else:
		pseudo_ai_turn_determine()
		
	# pseudo_ai_turn_determine()
	
	animationPlayer.play("DownMovement")
	emit_signal("signal_completed_turn")
	print("\nDark Dwarf Turn End\n")

func internal_call_complete() -> void:
	animationPlayer.play("DownMovement")
	emit_signal("signal_completed_turn")

func pseudo_ai_turn_determine():
	for _i in range(2):
		random_move_direction(0)
		yield(tween, "tween_completed")
	animationPlayer.play("DownMovement")
	emit_signal("signal_completed_turn")

# Getters
func cget_agility() -> int:
	return $EnemeyRoot.agility

func cget_actor_name() -> String: return $EnemeyRoot.enemey_name
func cget_class(): return null
func cget_level(): return null
func cget_hp_total() -> int: return $EnemeyRoot.HP_Total
func cget_hp_current() -> int: return $EnemeyRoot.HP_Current
func cget_mp_total() -> int: return $EnemeyRoot.MP_Total
func cget_mp_current() -> int: return $EnemeyRoot.MP_Current
