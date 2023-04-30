extends Node2D

signal battle__animation_completed

signal attack_frame_reached
signal spell_cast_frame_reached

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	# play_attack_normal()
	pass

# TODO: maybe make these exports as strings so its easy to reuse idle for mutliple types
# probably wont need more than this
func play_idle() -> void:
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

func emit_attack_frame_reached() -> void:
	emit_signal("attack_frame_reached")


func emit_spell_cast_frame_reached() -> void:
	emit_signal("spell_cast_frame_reached")
