extends Node2D

# signal completed
signal signal_completed_turn

export var is_npc: bool = false

onready var kinematicBody = $EnemeyRoot/KinematicBody2D
onready var tween = $EnemeyRoot/KinematicBody2D/Tween
onready var animationPlayer = $EnemeyRoot/AnimationPlayer
onready var animationTree = $EnemeyRoot/AnimationTree
onready var animationTreeState = animationTree.get("parameters/playback")

const TILE_SIZE: int = 24

var _timer = null

var rng = RandomNumberGenerator.new()

func _ready():
	animationPlayer.play("DownMovement")
	
	if !is_npc:
		_timer = Timer.new()
		add_child(_timer)
		_timer.connect("timeout", self, "_on_Timer_timeout")
		_timer.set_wait_time(1.0)
		_timer.set_one_shot(false) # Make sure it loops
		_timer.start()
	

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
	
#	if direction == 0:
#		animationPlayer.play("RightMovement")
#		tween.interpolate_property(kinematicBody, 'position', kinematicBody.position, Vector2(kinematicBody.position.x + TILE_SIZE, kinematicBody.position.y), 0.2, Tween.TRANS_LINEAR)
#	elif direction == 1:
#		animationPlayer.play("LeftMovement")
#		tween.interpolate_property(kinematicBody, 'position', kinematicBody.position, Vector2(kinematicBody.position.x - TILE_SIZE, kinematicBody.position.y), 0.2, Tween.TRANS_LINEAR)
#	elif direction == 2:
#		animationPlayer.play("UpMovement")
#		tween.interpolate_property(kinematicBody, 'position', kinematicBody.position, Vector2(kinematicBody.position.x, kinematicBody.position.y - TILE_SIZE), 0.2, Tween.TRANS_LINEAR)
#	elif direction == 3:
#		animationPlayer.play("DownMovement")
#		tween.interpolate_property(kinematicBody, 'position', kinematicBody.position, Vector2(kinematicBody.position.x, kinematicBody.position.y + TILE_SIZE), 0.2, Tween.TRANS_LINEAR)
#
	
	tween.start()

# tween.interpolate_property(kinematicBody, 'position', kinematicBody.position, Vector2(kinematicBody.position.x + TILE_SIZE, kinematicBody.position.y), 0.2, Tween.TRANS_LINEAR)
# 			emit_signal("signal_character_moved", Vector2(kinematicBody.position.x + TILE_SIZE, kinematicBody.position.y))

# play_turn
func play_turn():
	print("\nRune Knight Turn Start\n")
	
	pseudo_ai_turn_determine()
	
	# random_move_direction(3)
	# yield(get_tree().create_timer(1.0), "timeout")
	#yield($EnemeyRoot/KinematicBody2D/Tween, "tween_completed")
	# yield(tween, "tween_completed")
	#random_move_direction(3)
	# yield(tween, "tween_completed")
	#random_move_direction(3)
	# yield(tween, "tween_completed")
	#random_move_direction(3)
	# yield(tween, "tween_completed")
	#random_move_direction(3)
	# yield(tween, "tween_completed")
	
	
	# var t = Timer.new()
	# t.set_wait_time(0.75)
	# t.set_one_shot(true)
	# self.add_child(t)
	# t.start()
	# yield(t, "timeout")
	
	# yield()
	# emit_signal("completed")
	
	# yield()
	emit_signal("signal_completed_turn")
	print("\nRune Knight Turn End\n")

func pseudo_ai_turn_determine():
	for _i in range(4):
		random_move_direction(2)
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
