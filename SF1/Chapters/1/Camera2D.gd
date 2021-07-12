extends Camera2D

signal signal_camera_move_complete

#onready var playerNode = get_parent().get_node("Characters/MaxCharacterRoot/KinematicBody2D")
# onready var playerNode = get_parent().get_node("Characters/PlayerCharacterRoot/MaxRoot/CharacterRoot/KinematicBody2D")
onready var playerNode = get_parent().get_node("Characters/MaxRoot/CharacterRoot/KinematicBody2D")

# get_node("res://SF1/Character/SmallIsland.tscn")

onready var battleAttackAnimationPlayer = get_parent().get_node("BattleAttackAnimationPlayerRoot")

# onready var displayInfoControl = get_parent().get_node("DisplayInfoControl")

# SceneTree.get_node("MAX")

var camera_smooth_moving: bool = false

const tile_size: int = 24

var old_pos
var old_zoom

var camera_active_follow: bool = true

func _ready():
	#position.x = 180
	# position.y = 405
	# print("Camera - playernode - ", playerNode)
	pass # Replace with function body.

func _process(_delta):
	# return 
	if !camera_active_follow:
		return
	
	if camera_smooth_moving:
		return
	
	#var p = playerNode.get_child(0).get_node("KinematicBody2D")
	#playerNode = p
	
	
	# print(playerNode.position)
	position.x = playerNode.position.x 
	position.y = playerNode.position.y - 60# + (tile_size * 12)
	
	#displayInfoControl.rect_position.x = playerNode.position.x
	#displayInfoControl.rect_position.y = playerNode.position.y
	
	if position.x < 200:
		position.x = 200
	
	# 1280 max size 
	# 160 viewport horiztonal h
	#if position.x > (1280 - 160):
	#	position.x = 1280 - 160
	
	if position.y < 114:
		position.y = 114
	
	# 720 max size vertical
	# 90 viewport vertical h
	#if position.y > (720 - 90):
	#	position.y = 720 - 90
			
	pass

func zoom():
	if Input.is_action_just_released('ui_minus'):
		zoom.x += 0.05
		zoom.y += 0.05
	if Input.is_action_just_released('ui_plus'):
	# if Input.is_action_just_released('ui_plus') and zoom.x > 1 and zoom.y > 1:
		zoom.x -= 0.05
		zoom.y -= 0.05

func rotate_cam():
	if Input.is_action_just_pressed("ui_end"):
		rotate(90)
		
func smooth_move_to_new_position(new_player_node):
	camera_smooth_moving = true
	playerNode = new_player_node #.get_child(0).get_node("KinematicBody2D")
	print(playerNode)
	
	print("Cur pos - ", position, "\nNew pos - ", playerNode.position)
	var npos = check_pos_bounds(playerNode.position)
	# npos.y = new_player_node.position.y #  + (tile_size * 12)
	var tween_camera = $CameraTween
	tween_camera.connect("tween_completed", self, "s_complete_smooth_move")
	# tween_camera.connect("tween_all_completed", self, "s_complete_smooth_move")
	
	tween_camera.interpolate_property(self, "position",
			position, Vector2(npos.x, npos.y), 0.75,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_camera.start()
	# camera_smooth_moving = false

func check_pos_bounds(npos) -> Vector2:
	var new_pos: Vector2 = npos
	
	if npos.x < 200:
		new_pos.x = 200
	if npos.y < 114:
		new_pos.y = 114
	
	# new_pos.y += 160
	return new_pos

func s_complete_smooth_move(obj, key):
	print("\nI was called asdasd", obj, key)
	camera_smooth_moving = false
	# playerNode = playerNode.get_child(0).get_node("KinematicBody2D")
	# position = playerNode.position
	#print("\nI was called", obj, key)
	$CameraTween.disconnect("tween_completed", self, "s_complete_smooth_move")
	emit_signal("signal_camera_move_complete")

func _physics_process(_delta):
	zoom()
	
	# test_an()
	# rotate_cam()

func test_an():
	if Input.is_action_just_released("ui_q_key"):
		print("hiohio")
		old_pos = position
		old_zoom = zoom
		zoom.x = 1
		zoom.y = 1
		position.x = 0
		position.y = 0
		camera_active_follow = false
		battleAttackAnimationPlayer.show()
	if Input.is_action_just_released("ui_w_key"):
		zoom = old_zoom
		position = old_pos
		camera_active_follow = true
		battleAttackAnimationPlayer.hide()
