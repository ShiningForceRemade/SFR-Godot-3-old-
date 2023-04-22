extends Node2D

@onready var goldAmountLabel = $NinePatchRect/GoldAmount
@onready var _tween: Tween # = create_tween()

# TODO: look into something better - hard coding position values doesnt seem like the best that can be done
const default_position: Vector2 = Vector2(8, 8)
const hidden_position: Vector2 = Vector2(-80, 8)

func _ready():
	UpdateGoldAmountDisplay()
	Singleton_CommonVariables.ui__gold_info_box = self


func UpdateGoldAmountDisplay() -> void:
	goldAmountLabel.text = str(Singleton_CommonVariables.gold)


func DefaultPosition() -> void:
	position = default_position


func ShopMenuPosition() -> void:
	# TODO: CLEAN: do something better than magic numbers for positioning
	position.x = 202
	position.y = 91


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
