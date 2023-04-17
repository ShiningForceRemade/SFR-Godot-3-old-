extends Node2D

signal signal_action_finished

#
@onready var ray: RayCast2D = $RayCast2D
@onready var _timer: Timer = $Timer

@onready var collision_shape_cell_block: CollisionShape2D = $CollisionShape2D2
@onready var chracter_animation_player: AnimationPlayer = $CharacterRoot/AnimationPlayer


#
var GRID_BASED_MOVEMENT:bool = true
var is_currently_moving:bool = false
var is_active: bool = false # menu or interacting with an node

var animation_speed = 4

var rng = RandomNumberGenerator.new()


#
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Singleton_CommonVariables.main_character_active_kinematic_body_node = self
	Singleton_CommonVariables.main_character_player_node = self
	
	pass


func npc_move() -> void:
	if !is_currently_moving:
		rng.randomize()
	
		# animationPlayer.playback_speed = 1
		_timer.set_wait_time(rng.randf_range(1.5, 4))
		# _timer.set_wait_time(0.15)
		_timer.start()
		# random_move_direction(rng.randi_range(0, 3))
		random_move_direction(rng.randi_range(0, 3))
		# _timer.set_wait_time(1)
		# _timer.set_one_shot(false) # Make sure it loops
		_timer.start()
		await _timer.timeout
		npc_move()


func random_move_direction(n: int) -> void:
	match n:
		0: attempt_to_move(Vector2(position.x + 24, position.y), e_directions.RIGHT)
		1: attempt_to_move(Vector2(position.x - 24, position.y), e_directions.LEFT)
		2: attempt_to_move(Vector2(position.x, position.y - 24), e_directions.UP)
		3: attempt_to_move(Vector2(position.x, position.y + 24), e_directions.DOWN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_currently_moving || is_active:
		# if actively moving don't allow for any additional processing until complete
		return
	
	
#	# if Input.is_action_just_pressed("ui_c_key"):
#	#	GRID_BASED_MOVEMENT = !GRID_BASED_MOVEMENT
#	#	setup_animations_types_depending_on_movement()	
	
	
	if !Singleton_CommonVariables.is_currently_in_battle_scene:
		if Input.is_action_just_pressed("ui_a_key"):
			is_active = false
			Singleton_CommonVariables.menus_root_node.overworld_action_menu_node().show()
			Singleton_CommonVariables.menus_root_node.gold_info_box_node().show()
			Singleton_CommonVariables.menus_root_node.character_info_box_node().show()
			
			# TODO: add get character from player to help support different main character option
			# var mcan = Singleton_Game_GlobalCommonVariables.main_character_player_node
			var mcan = Singleton_CommonVariables.sf_game_data_node.ForceMembers[0]
			Singleton_CommonVariables.menus_root_node.CharacterInfoBox.update_active_info(
				mcan.name, 
				mcan.class_short, 
				mcan.level, 
				mcan.stats.hp, 
				mcan.stats.hp, 
				mcan.stats.mp, 
				mcan.stats.mp
				)
			
			await Signal(get_tree().create_timer(0.1), "timeout")
			Singleton_CommonVariables.menus_root_node.overworld_action_menu_node().set_menu_active()
			return
			
		if Input.is_action_just_pressed("ui_c_key"):
			interaction_attempt_to_talk()
			return
		
		if Input.is_action_just_pressed("ui_z_key"):
			# CutscenePlayerTemp.play("Opening")
			return
		
		if Input.is_action_just_pressed("ui_x_key"):
			is_active = false
			Singleton_CommonVariables.menus_root_node.member_list_node().show()
			Singleton_CommonVariables.menus_root_node.member_list_node().set_overvview_view_active()
			Singleton_CommonVariables.menus_root_node.member_list_node().load_character_lines()
			Singleton_CommonVariables.menus_root_node.member_list_node().active = true
			return
	
	# Classic Genesis styled movement and battle movement
	if GRID_BASED_MOVEMENT:
		if Input.is_action_pressed("ui_right"):
			play_animation("RightMovement")
			attempt_to_move(Vector2(position.x + 24, position.y), e_directions.RIGHT)
		elif Input.is_action_pressed("ui_left"):
			play_animation("LeftMovement")
			attempt_to_move(Vector2(position.x - 24, position.y), e_directions.LEFT)
		elif Input.is_action_pressed("ui_up"):
			play_animation("UpMovement")
			attempt_to_move(Vector2(position.x, position.y - 24), e_directions.UP)
		elif Input.is_action_pressed("ui_down"):
			play_animation("DownMovement")
			attempt_to_move(Vector2(position.x, position.y + 24), e_directions.DOWN)
	
	
	# TODO: ROTDD styled movement
	# TODO: godot 3.4.x has better movement handling code 
	# this is grossly outdated and should be replaced 
#	else:
#		var input_vector: Vector2 = Vector2.ZERO
#
#		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#		input_vector = input_vector.normalized()
#
#		if input_vector != Vector2.ZERO:
#			animationTree.set("parameters/Movement 4 Directions/blend_position", input_vector)
#
#			#velocity += input_vector * ACCELERATION * delta
#			# Running
#			if Input.is_action_pressed("ui_accept"):	
#				# velocity = velocity.clamped(MAX_SPEED * RUNNING_SPEED_RATE * delta)
#				velocity = velocity.move_toward(input_vector * MAX_SPEED * RUNNING_SPEED_RATE, ACCELERATION * delta)
#			else:
#				#velocity = velocity.clamped(MAX_SPEED * delta)
#				velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
#		else:
#			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#
#		velocity = kinematicBody.move_and_slide(velocity)
#		colsh.disabled = true

### Helpers

func set_active(active_arg: bool) -> void:
	is_active = active_arg


func set_active_processing(active_arg: bool) -> void:
	is_active = !active_arg
	set_process(active_arg)


### Interactions


# TEMP: for demo
# TODO: IMPORTANT:
# Originally I used raycasts and kinematic bodys since I started with using the rotdd movement style
# but since I've disabled that behind a flag in the dev console and there's no immediate plans to change this
# it might be better to migrate to a tilemap based collision.
# Think about this more and clean this up and refine it much more
func interaction_attempt_to_talk() -> void:
	if !Singleton_CommonVariables.is_currently_in_battle_scene:
		
		print("Start")
		var objects_collide = [] 
		while ray.is_colliding():
			var obj = ray.get_collider() # get the next object that is colliding.
			objects_collide.append(obj) # add it to the array.
			ray.add_exception(obj) # add to ray's exception. That way it could detect something being behind it.
			ray.force_raycast_update() # update the ray's collision query.

		#after all is done, remove the objects from ray's exception.
#		for obj in objects_collide:
#			# print(obj)
#			# print(obj.get_parent().get_parent().has_method("attempt_to_interact"))
#			frontFacingRaycast.remove_exception( obj )
		# print("End")
	
		for obj in objects_collide:
			# print(obj.get_parent().get_parent().has_method("attempt_to_interact"))
			
			if obj.get_parent().get_parent().has_method("attempt_to_interact"):
				obj.get_parent().get_parent().attempt_to_interact()
			elif obj.get_parent().has_method("attempt_to_interact"):
				obj.get_parent().attempt_to_interact()
		
		# if frontFacingRaycast.is_colliding():
			
			# print(frontFacingRaycast.collide_with_bodies())
			
			# TODO: probably should add a helper function to get the parent element
			# where the custom logic will live instead of going up for build v0.0.2 its fine
			# print(frontFacingRaycast.get_collider())
			# print(frontFacingRaycast.get_collider().get_parent().get_name())
			# print(frontFacingRaycast.get_collider().get_parent().get_parent(), frontFacingRaycast.get_collider().get_parent().get_parent().has_method("attempt_to_interact"))
			# print(frontFacingRaycast.get_collider().get_parent().get_parent())
			# print(frontFacingRaycast.get_collider().get_parent().get_name())
			# print("\n")
		# if frontFacingRaycast.is_colliding():
#			if frontFacingRaycast.get_collider().get_parent().get_parent().has_method("attempt_to_interact"):
#				frontFacingRaycast.get_collider().get_parent().get_parent().attempt_to_interact()
#			elif frontFacingRaycast.get_collider().get_parent().has_method("attempt_to_interact"):
#				frontFacingRaycast.get_collider().get_parent().attempt_to_interact()
		
		for obj in objects_collide:
			ray.remove_exception(obj)
			
		print("End\n")


func interaction_attempt_to_search() -> void:
	# if !Singleton_Game_GlobalCommonVariables.is_currently_in_battle_scene:
	if ray.is_colliding():
		# TODO: probably should add a helper function to get the parent element
		# where the custom logic will live instead of going up for build v0.0.2 its fine
		# print(frontFacingRaycast.get_collider())
		# print(frontFacingRaycast.get_collider().get_parent().get_name())
		print(ray.get_collider().get_parent().get_parent(), ray.get_collider().get_parent().get_parent().has_method("attempt_to_interact"))
		
		if ray.get_collider().get_parent().get_parent().has_method("attempt_to_interact_search"):
			ray.get_collider().get_parent().get_parent().attempt_to_interact()
		elif ray.get_collider().get_parent().has_method("attempt_to_interact_search"):
			ray.get_collider().get_parent().attempt_to_interact()


func PlayerFacingDirection() -> String:
	return chracter_animation_player.current_animation


func GetOppositePlayerFacingDirection() -> String:
	var facing_direction = PlayerFacingDirection()
	
	match facing_direction:
		"UpMovement": return "DownMovement"
		"DownMovement": return "UpMovement"
		"LeftMovement": return "RightMovement"
		"RightMovement": return "LeftMovement"
		_: return "DownMovement"


func get_actor_name() -> String:
	# TODO: FIXME: IMPL later
	return "MAX"


### Movement

func play_animation(animation_name: String) ->  void:
	if chracter_animation_player.current_animation != animation_name:
		chracter_animation_player.play(animation_name)


enum e_directions {
	LEFT,
	RIGHT,
	DOWN,
	UP
}

const ray_target_positions = {
	e_directions.LEFT:  Vector2(-20, 0),
	e_directions.RIGHT: Vector2(20, 0),
	e_directions.UP:    Vector2(0, -20),
	e_directions.DOWN:  Vector2(0, 20)
}

const collision_cell_blocker_positions = {
	e_directions.LEFT:  Vector2(-24, 0),
	e_directions.RIGHT: Vector2(24, 0),
	e_directions.UP:    Vector2(0, -24),
	e_directions.DOWN:  Vector2(0, 24)
}

func attempt_to_move(new_position_target: Vector2, direction: e_directions) -> void:
	ray.target_position = ray_target_positions[direction] # inputs[dir] * tile_size
	ray.force_raycast_update()
	chracter_animation_player.speed_scale = 2
	
	if !ray.is_colliding():
		collision_shape_cell_block.position = collision_cell_blocker_positions[direction]
		
		var tween: Tween = create_tween()
		tween.connect("finished", Callable(self, "emit_action_finished"))
		tween.tween_property(self, "position",
			new_position_target,
			1.0 / animation_speed
		).set_trans(Tween.TRANS_LINEAR)
	
		is_currently_moving = true
		await tween.finished
		is_currently_moving = false
		chracter_animation_player.speed_scale = 1
		
		collision_shape_cell_block.position = Vector2.ZERO


func emit_action_finished() -> void:
	emit_signal("signal_action_finished")


func MoveInDirection(move_direction_arg: String) -> void:
	if move_direction_arg == "Right":
		play_animation("RightMovement")
		attempt_to_move(Vector2(position.x + 24, position.y), e_directions.RIGHT)
	elif move_direction_arg == "Left":
		play_animation("LeftMovement")
		attempt_to_move(Vector2(position.x - 24, position.y), e_directions.LEFT)
	elif move_direction_arg == "Up":
		play_animation("UpMovement")
		attempt_to_move(Vector2(position.x, position.y - 24), e_directions.UP)
	elif move_direction_arg == "Down":
		play_animation("DownMovement")
		attempt_to_move(Vector2(position.x, position.y + 24), e_directions.DOWN)
