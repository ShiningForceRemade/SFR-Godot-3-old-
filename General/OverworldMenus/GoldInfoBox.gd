extends Control

onready var goldAmountLabel = $GoldNinePatchRect/GoldAmountLabel

func _ready():
	UpdateGoldAmountDisplay()


func UpdateGoldAmountDisplay() -> void:
	goldAmountLabel.text = str(Singleton_Game_GlobalCommonVariables.gold)


func DefaultPosition() -> void:
	rect_position.x = 4
	rect_position.y = 4


func ShopMenuPosition() -> void:
	rect_position.x = 224
	rect_position.y = 103
