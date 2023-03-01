extends Camera2D

signal signal_camera_move_complete

# onready var playerNode = get_parent().get_node("Characters/MaxRoot/CharacterRoot/CharacterBody2D")
@onready var playerNode = get_parent().get_node("Enemies").get_child(0) # /RuneKnightRoot")
# onready var playerNode = get_parent().get_node("Characters/MaxRoot")

# get_node("res://SF1/Character/SmallIsland.tscn")

@onready var battleAttackAnimationPlayer = get_parent().get_node("BattleAttackAnimationPlayerRoot")

# onready var displayInfoControl = get_parent().get_node("DisplayInfoControl")

# SceneTree.get_node("MAX")

var camera_smooth_moving: bool = false

const tile_size: int = 24

var old_pos
var old_zoom

var camera_active_follow: bool = true

func _ready():
	Singleton_Game_GlobalBattleVariables.camera_node = self
	pass

func _process(_delta):
	# return 
	if !camera_active_follow:
		return
	
	if camera_smooth_moving:
		return
	
	#var p = playerNode.get_child(0).get_node("CharacterBody2D")
	#playerNode = p
	
	# print(playerNode.position)
	# print(playerNode.global_position)
	
	if playerNode:
		position.x = playerNode.global_position.x 
		position.y = playerNode.global_position.y #  - 60# + (tile_size * 12)
	
	position.x = floor(position.x)
	position.y = floor(position.y)
	
	pass

func zoom():
	
	# zoom 1
	# 1.55
	# 1.95
	if Input.is_action_just_released('ui_minus'):
		if Singleton_Game_GlobalBattleVariables.is_currently_in_battle_scene:
			return
#		print("Zoom level - ", zoom)
#		if zoom.x == 1.0:
#			return
#		elif zoom.x == 1.55:
#			zoom = Vector2(1.0, 1.0)
#		elif zoom.x == 1.95:
#			zoom = Vector2(1.55, 1.55)

# TODO: fixme
		# zoom.x += 0.05
		# zoom.y += 0.05
		# if zoom.x > 2:
		# 	zoom = Vector2(2.0, 2.0)
		
		
		
		# snapped(zoom.x, 0.1)
		# snapped(zoom.y, 0.1)
	if Input.is_action_just_released('ui_plus'):
		if Singleton_Game_GlobalBattleVariables.is_currently_in_battle_scene:
			return
#		print("Zoom level - ", zoom)
#		if zoom.x == 1.95:
#			return
#		elif zoom.x == 1.55:
#			zoom = Vector2(1.95, 1.95)
#		elif zoom.x == 1.0:
#			zoom = Vector2(1.55, 1.55)
	# if Input.is_action_just_released('ui_plus') and zoom.x > 1 and zoom.y > 1:
	
	# TODO: fixme
		#zoom.x -= 0.05
		#zoom.y -= 0.05
		#if zoom.x < 1:
		#	zoom = Vector2(1.0, 1.0)
		
		
		# snapped(zoom.x, 0.1)
		# snapped(zoom.y, 0.1)
	
	# not moire zoom levels
	# TODO: set these as the defaults
	# add developer menu option to get different zooms
	# 1, 1.6, 2
	# print(zoom)


func rotate_cam():
	if Input.is_action_just_pressed("ui_end"):
		rotate(10)


func smooth_move_to_new_position(new_player_node, t = 0.25): # 0.75
	camera_smooth_moving = true
	playerNode = new_player_node #.get_child(0).get_node("CharacterBody2D")
	print(playerNode)
	
	print("Cur pos - ", position, "\nNew pos - ", playerNode.global_position)
	var npos = playerNode.global_position # check_pos_bounds(playerNode.position)
	# npos.y = new_player_node.position.y #  + (tile_size * 12)
	
	var tween_camera = $CameraTween
	tween_camera.connect("finished",Callable(self,"s_complete_smooth_move"))
	
	# tween_camera.connect("tween_all_completed",Callable(self,"s_complete_smooth_move"))
	
	print("Camera3D pos - ", position, " new pos - ", npos)
	
	#tween_camera.interpolate_property(self, "position",
			#position, Vector2(npos.x, npos.y), t, # 0.75,
			#Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	# TODO: fixme important
	# tween_camera.tween_property(self, "position", Vector2(npos.x, npos.y), t)
	
			
	# tween_camera.start()
	# camera_smooth_moving = false


func s_complete_smooth_move(obj, key):
	print("\nI was called asdasd", obj, key)
	camera_smooth_moving = false
	# playerNode = playerNode.get_child(0).get_node("CharacterBody2D")
	# position = playerNode.position
	#print("\nI was called", obj, key)
	$CameraTween.disconnect("finished",Callable(self,"s_complete_smooth_move"))
	emit_signal("signal_camera_move_complete")

func _physics_process(_delta):
	zoom()
	
	# test_an()
	# rotate_cam()

func test_an():
	if Input.is_action_just_released("ui_q_key"):
		position_camera_for_battle_scene()
	if Input.is_action_just_released("ui_w_key"):
		reset_camera_for_map()


func position_camera_for_battle_scene() -> void:
	old_pos = position
	old_zoom = zoom
	
	# TODO: fixme
	# zoom.x = 1
	#zoom.y = 1
	
	position.x = 0
	position.y = 0
	camera_active_follow = false
	battleAttackAnimationPlayer.show()


func reset_camera_for_map() -> void:
	camera_smooth_moving = false
	camera_active_follow = false
	
	# TODO: fixme
	# zoom = old_zoom
	
	position = old_pos
	
	battleAttackAnimationPlayer.hide()
	
	# _process(0)
	
	# await get_tree().create_timer(0.1).timeout
	
	camera_active_follow = true
	camera_smooth_moving = true
