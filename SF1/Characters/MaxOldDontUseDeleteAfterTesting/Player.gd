extends KinematicBody2D

signal signal_character_moved(new_pos)
# signal CharacterMoved(value, other_value)

onready var nroot = get_parent()

onready var animationPlayer = get_parent().get_node("AnimationPlayer")
onready var animationTree = get_parent().get_node("AnimationTree")
onready var animationTreeState = animationTree.get("parameters/playback")

var velocity: Vector2 = Vector2.ZERO

const MAX_SPEED: int = 150
const ACCELERATION: int = 600
const FRICTION: int = 10000
const RUNNING_SPEED_RATE: float = 1.65

# TODO: move this to a global settings singleton
var GRID_BASED_MOVEMENT: bool = true
const TILE_SIZE: int = 24

func _ready():
	animationPlayer.play("Idle Stand")
	# Center within nearest tile increment
	#position = position.snapped(Vector2.ONE * TILE_SIZE)
	#position += Vector2.ONE * TILE_SIZE / 2
	
	# use animation tree for freeform movement
	# hardcoded logic for grid based 
	# TODO: should probably pick one and unifiy
	
	setup_animations_types_depending_on_movement()

func setup_animations_types_depending_on_movement() -> void:
	if GRID_BASED_MOVEMENT:
		animationTreeState.stop()
		animationTree.active = false
	else:
		# $Sprite.flip_h = false
		animationPlayer.stop()
		animationTree.active = true
		animationTreeState.start("Movement 4 Directions")

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		GRID_BASED_MOVEMENT = !GRID_BASED_MOVEMENT
		
		setup_animations_types_depending_on_movement()
	
	# Classic Genesis styled movement and battle movement
	if GRID_BASED_MOVEMENT:
		if $Tween.is_active():
			return
				
		if Input.is_action_pressed("ui_right"):
			animationPlayer.play("RightMovement")
			$Tween.interpolate_property(self, 'position', position, Vector2(position.x + TILE_SIZE, position.y), 0.2, Tween.TRANS_LINEAR)
			emit_signal("signal_character_moved", Vector2(position.x + TILE_SIZE, position.y))
		elif Input.is_action_pressed("ui_left"):
			animationPlayer.play("LeftMovement")
			$Tween.interpolate_property(self, 'position', position, Vector2(position.x - TILE_SIZE, position.y), 0.2, Tween.TRANS_LINEAR)
			emit_signal("signal_character_moved", Vector2(position.x - TILE_SIZE, position.y))
		elif Input.is_action_pressed("ui_up"):
			animationPlayer.play("Up Movement")
			$Tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y - TILE_SIZE), 0.2, Tween.TRANS_LINEAR)
			emit_signal("signal_character_moved", Vector2(position.x, position.y - TILE_SIZE))
		elif Input.is_action_pressed("ui_down"):
			animationPlayer.play("Idle Stand")
			$Tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y + TILE_SIZE), 0.2, Tween.TRANS_LINEAR)
			emit_signal("signal_character_moved", Vector2(position.x, position.y + TILE_SIZE))
		
		#print("CharacterMoved")
		
		$Tween.start()
	
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
	
		velocity = move_and_slide(velocity)
