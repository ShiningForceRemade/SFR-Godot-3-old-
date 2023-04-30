extends Node2D

signal battle__animation_completed

signal attack_frame_reached
signal attack_anticapation_frame_reached
signal spell_cast_frame_reached

@onready var animation_player = $AnimationPlayer
@onready var character_sprite = $CharacterWrapper/CharacterSprite2D
@onready var weapon_sprite = $CharacterWrapper/WeaponSprite2D

func _ready() -> void:
	character_sprite.material.set("shader_parameter/dissolve_effect_amount", 0.0)
	weapon_sprite.material.set("shader_parameter/dissolve_effect_amount", 0.0)

# TODO: maybe make these exports as strings so its easy to reuse idle for mutliple types
# probably wont need more than this
func play_idle() -> void:
	animation_player.play("Idle")


func resume_animation() -> void:
	animation_player.play()

func pause_animation() -> void:
	animation_player.pause()


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

func emit_attack_anticapation_frame_reached() -> void:
	emit_signal("attack_anticapation_frame_reached")


func emit_spell_cast_frame_reached() -> void:
	emit_signal("spell_cast_frame_reached")
