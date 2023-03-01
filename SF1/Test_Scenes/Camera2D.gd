extends Camera2D

@onready var playerNode = get_node("/root/Node2D/MaxCharacterRoot/CharacterBody2D")
# get_node("res://SF1/Character/SmallIsland.tscn")

# SceneTree.get_node("MAX")

func _ready():
	print(playerNode)
	pass # Replace with function body.

func _process(delta):
	position.x = playerNode.position.x
	position.y = playerNode.position.y
	
	if position.x < 160:
		position.x = 160
	
	# 1280 max size 
	# 160 viewport horiztonal h
	if position.x > (1280 - 160):
		position.x = 1280 - 160
	
	if position.y < 90:
		position.y = 90
	
	# 720 max size vertical
	# 90 viewport vertical h
	if position.y > (720 - 90):
		position.y = 720 - 90
			
	pass
