extends Node2D

signal battle__animation_completed

signal attack_frame_reached
signal spell_cast_frame_reached

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

var dissolve_shader_path = "res://Shaders/Dissolve.gdshader"


func _ready() -> void:
	sprite.material.set("shader_parameter/dissolve_effect_amount", 0.0)
	pass


# TODO: maybe make these exports as strings so its easy to reuse idle for mutliple types
# probably wont need more than this
func play_idle() -> void:
	# reseting this since lots of scenes re-use the shader and godot doesnt make them scene unique
	# so as a safety mesaure always reseting dissolve so there's never blank sprites
	# TODO: check godot docs there's probably a better way to do this
	sprite.material.set("shader_parameter/dissolve_effect_amount", 0.0)
	animation_player.play("Idle")


func play_attack_normal() -> void:
	animation_player.play("Attack")
	await animation_player.animation_finished
	play_idle()
	emit_signal("battle__animation_completed")


func play_attack_special() -> void:
	animation_player.play("Attack")
	await animation_player.animation_finished
	emit_signal("battle__animation_completed")


func play_cast() -> void:
	animation_player.play("Attack")
	await animation_player.animation_finished
	emit_signal("battle__animation_completed")


func play_use() -> void:
	animation_player.play("Attack")
	await animation_player.animation_finished
	emit_signal("battle__animation_completed")


func play_shake() -> void:
	animation_player.play("Shake")


func play_death() -> void:
	animation_player.play("Death")


func emit_attack_frame_reached() -> void:
	emit_signal("attack_frame_reached")


func emit_spell_cast_frame_reached() -> void:
	emit_signal("spell_cast_frame_reached")
