extends Node2D

@onready var goldAmountLabel = $NinePatchRect/GoldAmount

func _ready():
	UpdateGoldAmountDisplay()
	Singleton_CommonVariables.ui__gold_info_box = self


func UpdateGoldAmountDisplay() -> void:
	goldAmountLabel.text = str(Singleton_CommonVariables.gold)


func DefaultPosition() -> void:
	position.x = 4
	position.y = 4


func ShopMenuPosition() -> void:
	# TODO: CLEAN: do something better than magic numbers for positioning
	position.x = 227
	position.y = 105
