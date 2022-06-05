extends Control

onready var animationPlayer = $AnimationPlayer

func _ready():
	hide()
	animationPlayer.playback_speed = 1.5
	# animationPlayer.play("Default")


func load_portrait(portrait_resource_path: String) -> void:
	print("here ----", portrait_resource_path)
	get_node("PortraitTextureRect").texture = load(portrait_resource_path)


func PlayDefaultAnimation() -> void:
	animationPlayer.play("Default")


func PlayTalkingAnimation() -> void:
	animationPlayer.play("Talking")


func StopAnimation() -> void:
	animationPlayer.stop()
