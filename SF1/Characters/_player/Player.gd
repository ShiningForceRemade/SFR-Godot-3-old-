extends Node2D

var active: bool = true

# signal signal_completed_turn

signal signal_character_moved(new_pos)
# signal CharacterMoved(value, other_value)

signal signal_show_character_action_menu

onready var characterRoot = get_child(0).get_node("CharacterRoot")
onready var kinematicBody = get_child(0).get_node("CharacterRoot/KinematicBody2D")
onready var staticCharacterCollision = get_child(0).get_node("CharacterRoot/KinematicBody2D").get_node("StaticCollisionShape2D")
onready var animationPlayer = get_child(0).get_node("CharacterRoot/AnimationPlayer")
onready var animationTree = get_child(0).get_node("CharacterRoot/AnimationTree")
onready var animationTreeState = animationTree.get("parameters/playback")
onready var tween = get_child(0).get_node("CharacterRoot/KinematicBody2D/Tween")

onready var colsh = get_child(0).get_node("CharacterRoot/KinematicBody2D/CollisionShape2D")

onready var frontFacingRaycast = $RayCast2D

onready var CutscenePlayerTemp = get_parent().get_node("CutsceneAnimationPlayer")


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

const speed = 24 * 6
var last_position = Vector2()
var target_position = Vector2()
var movedir = Vector2()
# frontFacingRaycast

# var movement_tween_speed = 0.1625
var movement_tween_speed = 0.1625

func reset_movement_speed() -> void:
	movement_tween_speed = 0.1625

func _ready():
	Singleton_Game_GlobalCommonVariables.main_character_player_node = self
	
	# position = position.snapped((Vector2(TILE_SIZE, TILE_SIZE)))
	last_position = position
	target_position = position
	
	# init_player_char()
	animationPlayer.play("DownMovement")
	# Center within nearest tile increment
	#position = position.snapped(Vector2.ONE * TILE_SIZE)
	#position += Vector2.ONE * TILE_SIZE / 2
	
	tween.connect("tween_completed", self, "s_tween_completed")
	
	# use animation tree for freeform movement
	# hardcoded logic for grid based 
	# TODO: should probably pick one and unifiy
	
	frontFacingRaycast.add_exception(kinematicBody)
	
	setup_animations_types_depending_on_movement()
	
	Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node = kinematicBody


func set_active(active_arg: bool) -> void:
	active = active_arg


func set_active_processing(active_arg: bool) -> void:
	active = active_arg
	set_process(active_arg)


func s_tween_completed(_node_arg, _property_arg): 
	colsh.position = characterRoot.position
	animationPlayer.playback_speed = 1


func get_actor_name() -> String:
	return characterRoot.cget_actor_name()

# TODO pronoun he she they or it  and one for him her them

#func init_player_char():
	#print("kinematicBody - ", kinematicBody)
	#kinematicBody.connect("signal_character_moved", self, "char_moved")

func char_moved(new_pos):
	emit_signal("signal_character_moved", new_pos)


func s_show_character_action_menu():
	emit_signal("signal_show_character_action_menu")


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
		animationTree.active = false
		animationTreeState.start("Movement 4 Directions")

func get_moveDir():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	
	if movedir.x > 0:
		animationPlayer.play("RightMovement")
	elif movedir.x < 0:
		animationPlayer.play("LeftMovement")
	elif movedir.y < 0:
		animationPlayer.play("UpMovement")
	elif movedir.y > 0:
		animationPlayer.play("DownMovement")
	
	# colsh.position = Vector2(colsh.position.x + TILE_SIZE, colsh.position.y)
	# tween.interpolate_property(self, 'position', position, Vector2(position.x + TILE_SIZE, position.y), movement_tween_speed * delta, Tween.TRANS_LINEAR)
	# # frontFacingRaycast.position = Vector2(position.x + TILE_SIZE, position.y)
	# tween.start()
	
	if movedir.x != 0 && movedir.y != 0:
		movedir = Vector2.ZERO
		if animationPlayer.playback_speed != 1:
			animationPlayer.playback_speed = 1
			print("rest speed")
	
	if movedir != Vector2.ZERO:
		frontFacingRaycast.cast_to = movedir * TILE_SIZE / 2
		if animationPlayer.playback_speed != 2:
			animationPlayer.playback_speed = 2
			print("speed")
		# frontFacingRaycast.cast_to = movedir * ((TILE_SIZE / 2) - 1)

func _process(delta):
	# func _physics_process(delta):
	if !active: 
		return
	
	# if Input.is_action_just_pressed("ui_c_key"):
	#	GRID_BASED_MOVEMENT = !GRID_BASED_MOVEMENT
	#	setup_animations_types_depending_on_movement()	
	
	if !Singleton_Game_GlobalCommonVariables.is_currently_in_battle_scene:
		if Input.is_action_just_pressed("ui_a_key"):
			active = false
			Singleton_Game_GlobalCommonVariables.menus_root_node.overworld_action_menu_node().show()
			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().show()
			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().show()
			
			# TODO: add get character from player to help support different main character option
			# var mcan = Singleton_Game_GlobalCommonVariables.main_character_player_node
			var mcan = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0]
			Singleton_Game_GlobalCommonVariables.menus_root_node.CharacterInfoBox.update_active_info(
				mcan.name, 
				mcan.class_short, 
				mcan.level, 
				mcan.stats.hp, 
				mcan.stats.hp, 
				mcan.stats.mp, 
				mcan.stats.mp
				)
			
			yield(get_tree().create_timer(0.1), "timeout")
			Singleton_Game_GlobalCommonVariables.menus_root_node.overworld_action_menu_node().set_menu_active()
			return
			
		if Input.is_action_just_pressed("ui_c_key"):
			print("talk")
			interaction_attempt_to_talk()
			print("talk")
			return
		
		if Input.is_action_just_pressed("test_key_z"):
			# CutscenePlayerTemp.play("Opening")
			return
		
		if Input.is_action_just_pressed("test_key_x"):
			active = false
			Singleton_Game_GlobalCommonVariables.menus_root_node.member_list_node().show()
			Singleton_Game_GlobalCommonVariables.menus_root_node.member_list_node().set_overvview_view_active()
			Singleton_Game_GlobalCommonVariables.menus_root_node.member_list_node().load_character_lines()
			Singleton_Game_GlobalCommonVariables.menus_root_node.member_list_node().active = true
			return
	
	
	# Classic Genesis styled movement and battle movement
	if GRID_BASED_MOVEMENT:
		#if is_instance_valid(tween):
#		pass
#TODO: add toggle for this movement
#		if frontFacingRaycast.is_colliding():
#			position = last_position
#			target_position = last_position
#		else:
#			position += speed * movedir * delta
#
#			if position.distance_to(last_position) >= TILE_SIZE - speed * delta:
#				position = target_position
#
#		# idle
#		if position == target_position:
#			get_moveDir()
#			last_position = position
#			target_position += movedir * TILE_SIZE
#
#	# colsh.position = Vector2(colsh.position.x + TILE_SIZE, colsh.position.y)
#
#		pass
		
		if tween.is_active():
			return

		# print("Here")
		# animationPlayer.playback_speed = 4

		if Input.is_action_pressed("ui_right"):
			frontFacingRaycast.rotation_degrees = E_RayCastRotationDirections.Right

			if animationPlayer.current_animation != "RightMovement":
				animationPlayer.play("RightMovement")

			frontFacingRaycast.force_raycast_update()
			if frontFacingRaycast.is_colliding():
				# print("colliding")
				return

			animationPlayer.playback_speed = 2

			colsh.position = Vector2(colsh.position.x + TILE_SIZE, colsh.position.y)
			tween.interpolate_property(self, 'position', position, Vector2(position.x + TILE_SIZE, position.y), movement_tween_speed, Tween.TRANS_LINEAR)
			# frontFacingRaycast.position = Vector2(position.x + TILE_SIZE, position.y)
			tween.start()
		elif Input.is_action_pressed("ui_left"):
			# frontFacingRaycast.position = Vector2(position.x - TILE_SIZE, position.y)
			frontFacingRaycast.rotation_degrees = E_RayCastRotationDirections.Left

			if animationPlayer.current_animation != "LeftMovement":
				animationPlayer.play("LeftMovement")

			frontFacingRaycast.force_raycast_update()
			if frontFacingRaycast.is_colliding():
				# print("colliding")
				return

			animationPlayer.playback_speed = 2

			colsh.position = Vector2(colsh.position.x - TILE_SIZE, colsh.position.y)
			tween.interpolate_property(self, 'position', position, Vector2(position.x - TILE_SIZE, position.y), movement_tween_speed, Tween.TRANS_LINEAR)
			tween.start()
		elif Input.is_action_pressed("ui_up"):
			# frontFacingRaycast.position = Vector2(position.x, position.y - TILE_SIZE)
			frontFacingRaycast.rotation_degrees = E_RayCastRotationDirections.Up

			if animationPlayer.current_animation != "UpMovement":
				animationPlayer.play("UpMovement")

			#if check_if_move_is_possible(Vector2(pnode.position.x, pnode.position.y - TILE_SIZE)):

			frontFacingRaycast.force_raycast_update()
			if frontFacingRaycast.is_colliding():
				# print("colliding")
				return

			animationPlayer.playback_speed = 2

			colsh.position = Vector2(colsh.position.x, colsh.position.y - TILE_SIZE)
			# Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
			tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y - TILE_SIZE), movement_tween_speed, Tween.TRANS_LINEAR)
			tween.start()
		elif Input.is_action_pressed("ui_down"):
			# frontFacingRaycast.position = Vector2(position.x, position.y + TILE_SIZE)
			frontFacingRaycast.rotation_degrees = E_RayCastRotationDirections.Down

			if animationPlayer.current_animation != "DownMovement":
				animationPlayer.play("DownMovement")

			frontFacingRaycast.force_raycast_update()
			if frontFacingRaycast.is_colliding():
				# print("colliding")
				return

			animationPlayer.playback_speed = 2

			colsh.position = Vector2(colsh.position.x, colsh.position.y + TILE_SIZE)
			tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y + TILE_SIZE), movement_tween_speed, Tween.TRANS_LINEAR)
			tween.start()
		#print("CharacterMoved")
		
		#if is_instance_valid(tween):
		
	
	# TODO: ROTDD styled movement
	# TODO: godot 3.4.x has better movement handling code 
	# this is grossly outdated and should be replaced 
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
		colsh.disabled = true


# TEMP: for demo
# TODO: IMPORTANT:
# Originally I used raycasts and kinematic bodys since I started with using the rotdd movement style
# but since I've disabled that behind a flag in the dev console and there's no immediate plans to change this
# it might be better to migrate to a tilemap based collision.
# Think about this more and clean this up and refine it much more
func interaction_attempt_to_talk() -> void:
	if !Singleton_Game_GlobalCommonVariables.is_currently_in_battle_scene:
		
		print("Start")
		var objects_collide = [] 
		
		if frontFacingRaycast.is_colliding():
			if frontFacingRaycast.get_collider().is_in_group("Collisions"):
				print("Collisions")
				var obj = frontFacingRaycast.get_collider() # get the next object that is colliding.
				objects_collide.append(obj) # add it to the array.
				frontFacingRaycast.add_exception(obj) # add to ray's exception. That way it could detect something being behind it.
				frontFacingRaycast.force_raycast_update()
				#return
		
		while frontFacingRaycast.is_colliding():
			# if frontFacingRaycast.get_collider().is_in_group("Collisions"):
			#	break
			
			print(frontFacingRaycast.get_collider())
			
			var obj = frontFacingRaycast.get_collider() # get the next object that is colliding.
			objects_collide.append(obj) # add it to the array.
			frontFacingRaycast.add_exception(obj) # add to ray's exception. That way it could detect something being behind it.
			frontFacingRaycast.force_raycast_update() # update the ray's collision query.

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
			frontFacingRaycast.remove_exception(obj)
			
		print("End\n")


func interaction_attempt_to_search() -> void:
	# if !Singleton_Game_GlobalCommonVariables.is_currently_in_battle_scene:
	if frontFacingRaycast.is_colliding():
		
		print("attempt to search")
		
		# TODO: probably should add a helper function to get the parent element
		# where the custom logic will live instead of going up for build v0.0.2 its fine
		# print(frontFacingRaycast.get_collider())
		# print(frontFacingRaycast.get_collider().get_parent().get_name())
		print(frontFacingRaycast.get_collider().get_parent().get_parent(), frontFacingRaycast.get_collider().get_parent().get_parent().has_method("attempt_to_interact"))
		
		if frontFacingRaycast.get_collider().get_parent().get_parent().has_method("attempt_to_interact_search"):
			frontFacingRaycast.get_collider().get_parent().get_parent().attempt_to_interact()
		elif frontFacingRaycast.get_collider().get_parent().has_method("attempt_to_interact_search"):
			frontFacingRaycast.get_collider().get_parent().attempt_to_interact()


func PlayerFacingDirection() -> String:
	return animationPlayer.current_animation


func change_facing_direction_string(direction: String) -> void:
	animationPlayer.play(direction)


func GetOppositePlayerFacingDirection() -> String:
	var facing_direction = PlayerFacingDirection()
	
	match facing_direction:
		"UpMovement": return "DownMovement"
		"DownMovement": return "UpMovement"
		"LeftMovement": return "RightMovement"
		"RightMovement": return "LeftMovement"
		_: return "DownMovement"
	

# BROKEN fix later
func ChangeActor(new_actor_arg) -> void:
	set_process(false)
	tween.remove_all()
	tween = null
	
	get_child(0).call_deferred("free")
	# get_child(0).queue_free()
	
	add_child(new_actor_arg)
	yield(new_actor_arg, "_ready")
	

func RestartAfterActorChange() -> void:
	characterRoot = get_child(0).get_node("CharacterRoot")
	kinematicBody = get_child(0).get_node("CharacterRoot/KinematicBody2D")
	animationPlayer = get_child(0).get_node("CharacterRoot/AnimationPlayer")
	animationPlayer.play("DownMovement")
	animationTree = get_child(0).get_node("CharacterRoot/AnimationTree")
	animationTreeState = animationTree.get("parameters/playback")
	tween = get_child(0).get_node("CharacterRoot/KinematicBody2D/Tween")
	
	colsh = get_child(0).get_node("CharacterRoot/KinematicBody2D/CollisionShape2D")
	
	frontFacingRaycast = get_parent().get_node("RayCast2D")
	
	CutscenePlayerTemp = get_parent().get_node("CutsceneAnimationPlayer")
	
	self._ready()
	
	set_process(true)


func MoveInDirection(move_direction_arg: String) -> void:
	match move_direction_arg:
		"Right":
			frontFacingRaycast.rotation_degrees = E_RayCastRotationDirections.Right
			
			if animationPlayer.current_animation != "RightMovement":
				animationPlayer.play("RightMovement")
			
			animationPlayer.playback_speed = 2
			
			frontFacingRaycast.force_raycast_update()
			if frontFacingRaycast.is_colliding():
				# print("colliding")
				return
			colsh.position = Vector2(colsh.position.x + TILE_SIZE, colsh.position.y)
			tween.interpolate_property(self, 'position', position, Vector2(position.x + TILE_SIZE, position.y), movement_tween_speed, Tween.TRANS_LINEAR)
			# frontFacingRaycast.position = Vector2(position.x + TILE_SIZE, position.y)
		"Left":
			# frontFacingRaycast.position = Vector2(position.x - TILE_SIZE, position.y)
			frontFacingRaycast.rotation_degrees = E_RayCastRotationDirections.Left
			
			if animationPlayer.current_animation != "LeftMovement":
				animationPlayer.play("LeftMovement")
				
			animationPlayer.playback_speed = 2
			
			frontFacingRaycast.force_raycast_update()
			if frontFacingRaycast.is_colliding():
				# print("colliding")
				return
			
			colsh.position = Vector2(colsh.position.x - TILE_SIZE, colsh.position.y)
			tween.interpolate_property(self, 'position', position, Vector2(position.x - TILE_SIZE, position.y), movement_tween_speed, Tween.TRANS_LINEAR)
			
		"Up":
			# frontFacingRaycast.position = Vector2(position.x, position.y - TILE_SIZE)
			frontFacingRaycast.rotation_degrees = E_RayCastRotationDirections.Up
			
			if animationPlayer.current_animation != "UpMovement":
				animationPlayer.play("UpMovement")
			
			#if check_if_move_is_possible(Vector2(pnode.position.x, pnode.position.y - TILE_SIZE)):
			animationPlayer.playback_speed = 2
			
			frontFacingRaycast.force_raycast_update()
			if frontFacingRaycast.is_colliding():
				# print("colliding")
				return
			
			colsh.position = Vector2(colsh.position.x, colsh.position.y - TILE_SIZE)
			# Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
			tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y - TILE_SIZE), movement_tween_speed, Tween.TRANS_LINEAR)
		"Down":
			# frontFacingRaycast.position = Vector2(position.x, position.y + TILE_SIZE)
			frontFacingRaycast.rotation_degrees = E_RayCastRotationDirections.Down
			
			if animationPlayer.current_animation != "DownMovement":
				animationPlayer.play("DownMovement")
			
			animationPlayer.playback_speed = 2
			
			frontFacingRaycast.force_raycast_update()
			if frontFacingRaycast.is_colliding():
				# print("colliding")
				return
				
			colsh.position = Vector2(colsh.position.x, colsh.position.y + TILE_SIZE)
			tween.interpolate_property(self, 'position', position, Vector2(position.x, position.y + TILE_SIZE), movement_tween_speed, Tween.TRANS_LINEAR)
		
	tween.start()
