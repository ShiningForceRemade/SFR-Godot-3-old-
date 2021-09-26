extends Node2D

var active: bool = false

signal signal_completed_turn
signal signal_character_moved(new_pos)
# signal CharacterMoved(value, other_value)

signal signal_show_character_action_menu

onready var characterRoot = get_child(0).get_node("CharacterRoot")
onready var kinematicBody = get_child(0).get_node("CharacterRoot/KinematicBody2D")
onready var animationPlayer = get_child(0).get_node("CharacterRoot/AnimationPlayer")
onready var animationTree = get_child(0).get_node("CharacterRoot/AnimationTree")
onready var animationTreeState = animationTree.get("parameters/playback")
onready var tween = get_child(0).get_node("CharacterRoot/KinematicBody2D/Tween")

onready var frontFacingRaycast = $RayCast2D

var velocity: Vector2 = Vector2.ZERO

const MAX_SPEED: int = 150
const ACCELERATION: int = 600
const FRICTION: int = 10000
const RUNNING_SPEED_RATE: float = 1.65

enum E_RayCastRotationDirections {
	Down = 0,
	Left = 90,
	Up = 180,
	Right = 270
}

# TODO finish fixing this up later cause of the move from maxroot to player->maxroot
# TODO: move this to a global settings singleton
var GRID_BASED_MOVEMENT: bool = true
const TILE_SIZE: int = 24

const movement_tween_speed = 0.1625


func _ready():
	# init_player_char()
	animationPlayer.play("DownMovement")
	# Center within nearest tile increment
	#position = position.snapped(Vector2.ONE * TILE_SIZE)
	#position += Vector2.ONE * TILE_SIZE / 2
	
	# use animation tree for freeform movement
	# hardcoded logic for grid based 
	# TODO: should probably pick one and unifiy
	
	frontFacingRaycast.add_exception(kinematicBody)
	
	setup_animations_types_depending_on_movement()

#func init_player_char():
	#print("kinematicBody - ", kinematicBody)
	#kinematicBody.connect("signal_character_moved", self, "char_moved")

func char_moved(new_pos):
	emit_signal("signal_character_moved", new_pos)

func get_character_movement():
	return characterRoot.move

func get_character_current_pos() -> Vector2:
	# print("here", kinematicBody)
	return kinematicBody.position


# play_turn
func play_turn():
	print("\nMax Turn Start\n")	
	characterRoot.play_turn()
	characterRoot.connect("signal_completed_turn", self, "s_complete_turn")
	characterRoot.connect("signal_character_moved", self, "s_char_moved")
	
	characterRoot.connect("signal_show_character_action_menu", self, "s_show_character_action_menu")
	
	# yield(self, "signal_completed_turn")

func s_show_character_action_menu():
	emit_signal("signal_show_character_action_menu")

func s_complete_turn():
	print("\nMax Turn End\n")
	characterRoot.animationPlayer.play("DownMovement")
	characterRoot.disconnect("signal_completed_turn", self, "s_complete_turn")
	characterRoot.disconnect("signal_character_moved", self, "s_char_moved")
	characterRoot.disconnect("signal_show_character_action_menu", self, "s_show_character_action_menu")
	emit_signal("signal_completed_turn")
	
func s_char_moved(new_pos):
	emit_signal("signal_character_moved", new_pos)

func get_kinematic_body():
	return kinematicBody
	

func setup_animations_types_depending_on_movement() -> void:
	if GRID_BASED_MOVEMENT:
		# animationTreeState.stop()
		animationTree.active = false
		# animationTree.active = true
	else:
		# $Sprite.flip_h = false
		animationPlayer.stop()
		animationTree.active = true
		animationTreeState.start("Movement 4 Directions")

func _process(delta):
# func _physics_process(delta):
	# if !active: 
	# 	return
	
	#if Input.is_action_just_pressed("ui_cancel"):
	#	GRID_BASED_MOVEMENT = !GRID_BASED_MOVEMENT
		
		# setup_animations_types_depending_on_movement()	
	animationPlayer.playback_speed = 1
	
	# Classic Genesis styled movement and battle movement
	if GRID_BASED_MOVEMENT:
		if tween.is_active():
			return
		
		if Input.is_action_just_pressed("ui_a_key"):
			if frontFacingRaycast.is_colliding():
				print(frontFacingRaycast.get_collider())
				frontFacingRaycast.get_collider().get_parent().attempt_to_interact()
			
		# print("Here")
		# animationPlayer.playback_speed = 4
		
		if Input.is_action_pressed("ui_right"):
			frontFacingRaycast.rotation_degrees = E_RayCastRotationDirections.Right
			animationPlayer.play("RightMovement")
			animationPlayer.playback_speed = 2
			
			frontFacingRaycast.force_raycast_update()
			if frontFacingRaycast.is_colliding():
				print("colliding")
				return
			
			tween.interpolate_property(self, 'position', position, Vector2(position.x + TILE_SIZE, position.y), movement_tween_speed, Tween.TRANS_LINEAR)
			# frontFacingRaycast.position = Vector2(position.x + TILE_SIZE, position.y)
		elif Input.is_action_pressed("ui_left"):
			# frontFacingRaycast.position = Vector2(position.x - TILE_SIZE, position.y)
			frontFacingRaycast.rotation_degrees = E_RayCastRotationDirections.Left
			animationPlayer.play("LeftMovement")
			animationPlayer.playback_speed = 2
			
			frontFacingRaycast.force_raycast_update()
			if frontFacingRaycast.is_colliding():
				print("colliding")
				return
			
			tween.interpolate_property(self, 'position', position, Vector2(position.x - TILE_SIZE, position.y), movement_tween_speed, Tween.TRANS_LINEAR)
			
		elif Input.is_action_pressed("ui_up"):
			# frontFacingRaycast.position = Vector2(position.x, position.y - TILE_SIZE)
			frontFacingRaycast.rotation_degrees = E_RayCastRotationDirections.Up
			animationPlayer.play("UpMovement")
			#if check_if_move_is_possible(Vector2(pnode.position.x, pnode.position.y - TILE_SIZE)):
			animationPlayer.playback_speed = 2
			
			frontFacingRaycast.force_raycast_update()
			if frontFacingRaycast.is_colliding():
				print("colliding")
				return
			
			# Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
			tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y - TILE_SIZE), movement_tween_speed, Tween.TRANS_LINEAR)
		elif Input.is_action_pressed("ui_down"):
			# frontFacingRaycast.position = Vector2(position.x, position.y + TILE_SIZE)
			frontFacingRaycast.rotation_degrees = E_RayCastRotationDirections.Down
			animationPlayer.play("DownMovement")
			animationPlayer.playback_speed = 2
			
			frontFacingRaycast.force_raycast_update()
			if frontFacingRaycast.is_colliding():
				print("colliding")
				return
			
			tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y + TILE_SIZE), movement_tween_speed, Tween.TRANS_LINEAR)
		
		#print("CharacterMoved")
		
		tween.start()
	
	# ROTDD styled movement
	else:
		var input_vector: Vector2 = Vector2.ZERO
	
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		
		if input_vector != Vector2.ZERO:
			animationTree.set("parameters/Movement 4 Directions/blend_position", input_vector)
			
			#velocity += input_vector * ACCELERATION * delta
			# Running
			if Input.is_action_pressed("ui_accept"):	
				# velocity = velocity.clamped(MAX_SPEED * RUNNING_SPEED_RATE * delta)
				velocity = velocity.move_toward(input_vector * MAX_SPEED * RUNNING_SPEED_RATE, ACCELERATION * delta)
			else:
				#velocity = velocity.clamped(MAX_SPEED * delta)
				velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
		velocity = kinematicBody.move_and_slide(velocity)


# Getters
func cget_agility() -> int:
	return get_child(0).get_node("CharacterRoot").agility
	
func cget_actor_name() -> String: return characterRoot.character_name
func cget_level() -> int: return characterRoot.level
func cget_hp_total() -> int: return characterRoot.HP_Total
func cget_hp_current() -> int: return characterRoot.HP_Current
func cget_mp_total() -> int: return characterRoot.MP_Total
func cget_mp_current() -> int: return characterRoot.MP_Current
func cget_class() -> String: return characterRoot.cget_class()

