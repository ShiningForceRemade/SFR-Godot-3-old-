extends Node2D

@onready var animationPlayer = $AnimationPlayer
@onready var portraitTextureRect = $Sprite2D

func _ready():
	Singleton_CommonVariables.ui__portrait_popup = self
	hide()
	animationPlayer.speed_scale = 1.5
	# animationPlayer.play("Default")


func load_portrait(portrait_resource_path: String) -> void:
	print("here ----", portrait_resource_path)
	portraitTextureRect.texture = load(portrait_resource_path)


func PlayDefaultAnimation() -> void:
	# animationPlayer.play("Default")
	pass


func PlayTalkingAnimation() -> void:
	# animationPlayer.play("Talking")
	pass


func StopAnimation() -> void:
	animationPlayer.stop()
