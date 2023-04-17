extends Node2D

signal signal_action_finished

# 
# @export var is_npc: bool = true
var is_npc: bool = true
## If true npc won't move away from their current spot.
@export var stationary: bool

## Which direction the npc should be facing when the scene loads.
@export var FacingDirection: EFacingDirection
enum EFacingDirection { DOWN, UP, LEFT, RIGHT }

#
@onready var ray: RayCast2D = $RayCast2D
@onready var _timer: Timer = $Timer

@onready var collision_shape_cell_block: CollisionShape2D = $CollisionShape2D2
@onready var chracter_animation_player: AnimationPlayer = $CharacterRoot/AnimationPlayer


#
var GRID_BASED_MOVEMENT:bool = true
var is_currently_moving:bool = false

var animation_speed = 4
var tween_animation_time: float = 0.5
var tween_animation_time_speed_const: float = 0.5
# var tween = null

var rng = RandomNumberGenerator.new()

var parent_node = null

#
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent_node = get_parent()
	
	if is_npc && !stationary:
		npc_move()
		
	match FacingDirection:
		EFacingDirection.DOWN:  play_animation("DownMovement")
		EFacingDirection.UP:    play_animation("UpMovement")
		EFacingDirection.LEFT:  play_animation("LeftMovement")
		EFacingDirection.RIGHT: play_animation("RightMovement")
	
	pass


func attempt_interaction_talk() -> void:
	# TODO: check if move in progress 
	if parent_node.has_meta("attempt_interaction_talk"):
		parent_node.attempt_interaction_talk()
	else:
		attempt_to_talk()

func attempt_interaction_search() -> void:
	# TODO: check if move in progress 
	if parent_node.has_meta("attempt_interaction_search"):
		parent_node.attempt_interaction_search()
	else:
		attempt_to_search()

func attempt_to_talk() -> void:
	print("Trying to talk to npc")

func attempt_to_search() -> void:
	print("Trying to search the npc")


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
	if is_currently_moving || is_npc:
		# if actively moving don't allow for any additional processing until complete
		return
	
#
#	# if Input.is_action_just_pressed("ui_c_key"):
#	#	GRID_BASED_MOVEMENT = !GRID_BASED_MOVEMENT
#	#	setup_animations_types_depending_on_movement()	
#
#	if !Singleton_Game_GlobalCommonVariables.is_currently_in_battle_scene:
#		if Input.is_action_just_pressed("ui_a_key"):
#			active = false
#			Singleton_Game_GlobalCommonVariables.menus_root_node.overworld_action_menu_node().show()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().show()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().show()
#
#			# TODO: add get character from player to help support different main character option
#			# var mcan = Singleton_Game_GlobalCommonVariables.main_character_player_node
#			var mcan = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0]
#			Singleton_Game_GlobalCommonVariables.menus_root_node.CharacterInfoBox.update_active_info(
#				mcan.name, 
#				mcan.class_short, 
#				mcan.level, 
#				mcan.stats.hp, 
#				mcan.stats.hp, 
#				mcan.stats.mp, 
#				mcan.stats.mp
#				)
#
#			yield(get_tree().create_timer(0.1), "timeout")
#			Singleton_Game_GlobalCommonVariables.menus_root_node.overworld_action_menu_node().set_menu_active()
#			return
#
#		if Input.is_action_just_pressed("ui_c_key"):
#			interaction_attempt_to_talk()
#			return
#
#		if Input.is_action_just_pressed("test_key_z"):
#			# CutscenePlayerTemp.play("Opening")
#			return
#
#		if Input.is_action_just_pressed("test_key_x"):
#			active = false
#			Singleton_Game_GlobalCommonVariables.menus_root_node.member_list_node().show()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.member_list_node().set_overvview_view_active()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.member_list_node().load_character_lines()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.member_list_node().active = true
#			return
#
	
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


func play_animation(animation_name: String) ->  void:
	if chracter_animation_player.current_animation != animation_name:
		chracter_animation_player.play(animation_name)


### Facing Direction Helpers

func change_facing_direction(current_selection_pos: Vector2) -> void:
	if position.x < current_selection_pos.x:
		play_animation("RightMovement")
	elif position.x > current_selection_pos.x:
		play_animation("LeftMovement")
	elif position.y < current_selection_pos.y:
		play_animation("DownMovement")
	elif position.y > current_selection_pos.y:
		play_animation("UpMovement")


func change_facing_direction_string(direction: String) -> void:
	play_animation(direction)


func get_facing_direction() -> String:
	return chracter_animation_player.current_animation


###

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
		action_move(new_position_target)
		collision_shape_cell_block.position = Vector2.ZERO

func action_move(new_position_target: Vector2) -> void:
	var tween = create_tween()
	tween.connect("finished", Callable(self, "emit_action_finished"))
	tween.tween_property(self, "position",
		new_position_target,
		1.0 / animation_speed
	).set_trans(Tween.TRANS_LINEAR)
	
	is_currently_moving = true
	await tween.finished
	is_currently_moving = false
	chracter_animation_player.speed_scale = 1

func emit_action_finished() -> void:
	emit_signal("signal_action_finished")

func set_movement_speed_timer(speed_arg: float) -> void:
	tween_animation_time = speed_arg

func reset_movement_speed_timer() -> void:
	chracter_animation_player.speed_scale = 1
	tween_animation_time = tween_animation_time_speed_const


# TODO: CLEAN: this code can be refactored to be simpler - should also move vector arrays in a dict
func MoveInDirection(move_direction_arg: String, ignore_collision: bool = false) -> void:
	if move_direction_arg == "Right":
		play_animation("RightMovement")
		if ignore_collision:
			action_move(Vector2(position.x + 24, position.y))
		else:
			attempt_to_move(Vector2(position.x + 24, position.y), e_directions.RIGHT)
	elif move_direction_arg == "Left":
		play_animation("LeftMovement")
		if ignore_collision:
			action_move(Vector2(position.x - 24, position.y))
		else:
			attempt_to_move(Vector2(position.x - 24, position.y), e_directions.LEFT)
	elif move_direction_arg == "Up":
		play_animation("UpMovement")
		if ignore_collision:
			action_move(Vector2(position.x, position.y - 24))
		else:
			attempt_to_move(Vector2(position.x, position.y - 24), e_directions.UP)
	elif move_direction_arg == "Down":
		play_animation("DownMovement")
		if ignore_collision:
			action_move(Vector2(position.x, position.y + 24))
		else:
			attempt_to_move(Vector2(position.x, position.y + 24), e_directions.DOWN)
