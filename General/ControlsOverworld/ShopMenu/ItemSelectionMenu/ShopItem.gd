#tool
extends Control

@export var item_resource: Resource

@onready var item_spirte = $ItemSprite

func _ready():
	
	item_spirte.texture = item_resource.texture
	
	# item_spirte.texture = item_resource.texture
	
	pass
