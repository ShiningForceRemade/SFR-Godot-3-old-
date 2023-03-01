extends Control

@onready var goldAmountLabel = $GoldNinePatchRect/GoldAmountLabel

func _ready():
	UpdateGoldAmountDisplay()


func UpdateGoldAmountDisplay() -> void:
	goldAmountLabel.text = str(Singleton_Game_GlobalCommonVariables.gold)


func DefaultPosition() -> void:
	position.x = 4
	position.y = 4


func ShopMenuPosition() -> void:
	position.x = 227
	position.y = 105
