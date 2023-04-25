extends Node2D

@onready var land_effect_value_label: Label = $NinePatchRect/LandEffectValueLabel

var _tween: Tween 

# TODO: look into something better - hard coding position values doesnt seem like the best that can be done
const default_position: Vector2 = Vector2(8, 8)
const hidden_position: Vector2 = Vector2(-80, 8)


func _ready() -> void:
	Singleton_CommonVariables.ui__land_effect_popup_node = self


func set_land_effect_value_text(str_arg: String) -> void:
	land_effect_value_label.text = str_arg

## Show Hide Normal Position

func show_cust() -> void: 
	position = hidden_position
	show()
	
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", default_position, Singleton_CommonVariables.menu_tween_time)
	_tween.set_trans(Tween.TRANS_LINEAR)


func hide_cust() -> void: 
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", hidden_position, Singleton_CommonVariables.menu_tween_time)
	_tween.set_trans(Tween.TRANS_LINEAR)
	_tween.tween_callback(hide)
