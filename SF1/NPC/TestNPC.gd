extends Node2D

signal signal_move_direction_completed
const TILE_SIZE: int = 24

var _timer = null
var rng = RandomNumberGenerator.new()

onready var animationPlayer = $NPCBaseRoot/AnimationPlayer
onready var tween = $NPCBaseRoot/KinematicBody2D/Tween
onready var enemey_actor_root = $NPCBaseRoot
onready var raycast = $NPCBaseRoot/KinematicBody2D/RayCast2D
onready var colsh = $NPCBaseRoot/KinematicBody2D/CollisionShape2D

var area2d

var tween_animation_time: float = 0.5

enum E_RayCastRotationDirections {
	Down = 0,
	Left = 90,
	Up = 180,
	Right = 270
}

func _ready():
	area2d = get_parent().get_node("Area2D")
	
	raycast.collide_with_areas = true
	# Area2D.coll
	
	animationPlayer.play("DownMovement")
	
	tween.connect("tween_completed", self, "s_tween_completed")
	
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	
	# walk_around()
	pass

func attempt_to_interact() -> void:
	# if not moving to new square
	attempt_to_talk()

func attempt_to_talk() -> void:
	print("Trying to talk to test npc")

func walk_around() -> void:
	
	pass

# export var is_npc: bool = false
# onready var body = $EnemeyRoot/KinematicBody2D
# onready var animationTree = $EnemeyRoot/AnimationTree
# onready var animationTreeState = animationTree.get("parameters/playback")
# export var battle_logic_script: String


func _on_Timer_timeout():
	#print("Second")
	rng.randomize()
	# random_move_direction(rng.randi_range(0, 3))
	random_move_direction(rng.randi_range(0, 3))


func random_move_direction(direction):
	if tween.is_active():
		return
	
	# print("Direction", direction)
	# print("Position", position)
	
	if direction == 0:
		# if enemey_actor_root.check_if_move_is_possible(Vector2(position.x + TILE_SIZE, position.y)):
		animationPlayer.playback_speed = 2
		
		raycast.rotation_degrees = E_RayCastRotationDirections.Right
		raycast.force_raycast_update()
		if check_if_not_valid_move_in_predfined_area_or_obstacle(): return
		
		animationPlayer.play("RightMovement")
		colsh.position = Vector2(colsh.position.x + TILE_SIZE, colsh.position.y)
		tween.interpolate_property(self, 'position', position, Vector2(position.x + TILE_SIZE, position.y), tween_animation_time, Tween.TRANS_LINEAR)
		tween.start()
		return
	elif direction == 1:
		
		# if enemey_actor_root.check_if_move_is_possible(Vector2(position.x - TILE_SIZE, position.y)):
		animationPlayer.playback_speed = 2
		
		raycast.rotation_degrees = E_RayCastRotationDirections.Left
		raycast.force_raycast_update()
		if check_if_not_valid_move_in_predfined_area_or_obstacle(): return
		
		animationPlayer.play("LeftMovement")
		colsh.position = Vector2(colsh.position.x - TILE_SIZE, colsh.position.y)
		tween.interpolate_property(self, 'position', position, Vector2(position.x - TILE_SIZE, position.y), tween_animation_time, Tween.TRANS_LINEAR)
		tween.start()
		return
	elif direction == 2:
		
		# if enemey_actor_root.check_if_move_is_possible(Vector2(position.x, position.y  - TILE_SIZE)):
		animationPlayer.playback_speed = 2
		
		raycast.rotation_degrees = E_RayCastRotationDirections.Up
		if check_if_not_valid_move_in_predfined_area_or_obstacle(): return
		
		animationPlayer.play("UpMovement")
		colsh.position = Vector2(colsh.position.x, colsh.position.y - TILE_SIZE)
		tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y - TILE_SIZE), tween_animation_time, Tween.TRANS_LINEAR)
		tween.start()
		return
	elif direction == 3:
		
		#if enemey_actor_root.check_if_move_is_possible(Vector2(position.x, position.y  + TILE_SIZE)):
		animationPlayer.playback_speed = 2
		
		raycast.rotation_degrees = E_RayCastRotationDirections.Down
		if check_if_not_valid_move_in_predfined_area_or_obstacle(): return
		
		animationPlayer.play("DownMovement")
		colsh.position = Vector2(colsh.position.x, colsh.position.y + TILE_SIZE)
		tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y + TILE_SIZE), tween_animation_time, Tween.TRANS_LINEAR)
		tween.start()
		return
	
	# tween.start()
	
	# yield(get_tree().create_timer(0.1), "timeout")
	# emit_signal("signal_move_direction_completed")


func check_if_not_valid_move_in_predfined_area_or_obstacle() -> bool:
	raycast.force_raycast_update()
	if raycast.is_colliding():
		print("Test npc - collider - ", raycast.get_collider().get_name())
		return true
	
	return false

func s_tween_completed(node_arg, property_arg): 
	print(node_arg, " ", property_arg)
	colsh.position = enemey_actor_root.position
	emit_signal("signal_move_direction_completed")


func pseudo_ai_turn_determine():
	for _i in range(4):
		random_move_direction(0)
		yield(tween, "tween_completed")
	animationPlayer.play("DownMovement")
	emit_signal("signal_completed_turn")


func change_facing_direction(current_selection_pos: Vector2) -> void:
	if position.x < current_selection_pos.x:
		animationPlayer.play("RightMovement")
	elif position.x > current_selection_pos.x:
		animationPlayer.play("LeftMovement")
	elif position.y < current_selection_pos.y:
		animationPlayer.play("DownMovement")
	elif position.y > current_selection_pos.y:
		animationPlayer.play("UpMovement")

