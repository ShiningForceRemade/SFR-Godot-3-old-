extends Control

@onready var background_color_rect = $BackgroundColorRect

func set_spell_blcok_state(arg: bool) -> void:
	if arg:
		background_color_rect.show()
	else:
		background_color_rect.hide()
