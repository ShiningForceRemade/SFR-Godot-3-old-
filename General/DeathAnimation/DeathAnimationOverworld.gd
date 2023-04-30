extends Node2D

@onready var sprite = $BattleSpriteDeath
@onready var animation_palyer = $AnimationPlayer

func play() -> void:
	animation_palyer.play("Default")
