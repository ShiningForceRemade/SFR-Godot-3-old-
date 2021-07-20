tool
extends Button


export var reset_scene: bool = false setget _on_ResetBattleAnimationSceneButton_pressed

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ResetBattleAnimationSceneButton_pressed(arg = null):
	# print("hi", arg)
	
	get_parent().get_parent().get_node("$CharacterWrapper/CharacterSprite").position = Vector2(240, 92)
	get_parent().get_parent().get_node("$CharacterWrapper/WeaponSprite").position =  Vector2(214, 108)
	#weaponSprite.rotation_degrees = 0
	
	# enemeySprite.position = Vector2(80, 86)
	
	get_parent().get_parent().internal_reset_all_actor_sprites_back_to_default_position()
	
	pass # Replace with function body.
