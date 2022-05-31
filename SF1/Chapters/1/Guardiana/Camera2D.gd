extends Camera2D

signal signal_camera_move_complete

# onready var playerNode = get_parent().get_node("Characters/MaxRoot/CharacterRoot/KinematicBody2D")
onready var playerNode = get_parent().get_node("PlayerCharacterRoot")
# onready var playerNode = get_parent().get_node("Characters/MaxRoot")

# get_node("res://SF1/Character/SmallIsland.tscn")

onready var battleAttackAnimationPlayer = null # get_parent().get_node("BattleAttackAnimationPlayerRoot")

# onready var displayInfoControl = get_parent().get_node("DisplayInfoControl")

# SceneTree.get_node("MAX")

const tile_size: int = 24

var old_pos
var old_zoom

var camera_active_follow: bool = true

func _ready():
	Singleton_Game_GlobalBattleVariables.camera_node = self
	zoom = Singleton_Game_GlobalCommonVariables.sf_game_data_node.camera_zoom
	# position.x = 220
	# position.y = 160
	# print("Camera - playernode - ", playerNode)
	pass # Replace with function body.

func _process(_delta):
	# return 
	if !camera_active_follow:
		return
	
	#var p = playerNode.get_child(0).get_node("KinematicBody2D")
	#playerNode = p
	
	# print(playerNode.position)
	position.x = playerNode.position.x 
	position.y = playerNode.position.y #  - 60# + (tile_size * 12)
	
	#displayInfoControl.rect_position.x = playerNode.position.x
	#displayInfoControl.rect_position.y = playerNode.position.y
	
	# if position.x < 130:
	# 	position.x = 130
	
	# 1280 max size 
	# 160 viewport horiztonal h
	#if position.x > (1280 - 160):
	#	position.x = 1280 - 160
	
	# if position.y < 114:
	# 	position.y = 114
	
	# 720 max size vertical
	# 90 viewport vertical h
	#if position.y > (720 - 90):
	#	position.y = 720 - 90
	
	position.x = floor(position.x)
	position.y = floor(position.y)
	
	# align()
	# force_update_scroll()
	pass

func zoom():
	if Input.is_action_just_released('ui_minus'):
		zoom.x += 1
		zoom.y += 1
		
		Singleton_Game_GlobalCommonVariables.sf_game_data_node.camera_zoom = zoom
		#if zoom.x > 2:
		#	zoom = Vector2(1.95, 1.95)
		# stepify(zoom.x, 0.1)
		# stepify(zoom.y, 0.1)
	if Input.is_action_just_released('ui_plus'):
		zoom.x -= 1
		zoom.y -= 1
		
		Singleton_Game_GlobalCommonVariables.sf_game_data_node.camera_zoom = zoom
		#if zoom.x < 1:
		#	zoom = Vector2(1.0, 1.0)
		# stepify(zoom.x, 0.1)
		# stepify(zoom.y, 0.1)


func rotate_cam():
	if Input.is_action_just_pressed("ui_end"):
		rotate(10)


func _physics_process(_delta):
	zoom()
	
	# rotate_cam()
