extends Node

signal top_level_fade_animation_finished

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Singleton_CommonVariables.top_level_fader_node = self


func play_fade_in() -> void:
	animationPlayer.play("FadeIn")
	await animationPlayer.animation_finished
	emit_signal("top_level_fade_animation_finished")


func play_fade_out() -> void:
	animationPlayer.play("FadeOut")
	await animationPlayer.animation_finished
	emit_signal("top_level_fade_animation_finished")
