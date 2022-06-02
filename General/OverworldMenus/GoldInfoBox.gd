extends Control

onready var goldAmountLabel = $GoldNinePatchRect/GoldAmountLabel

func _ready():
	UpdateGoldAmountDisplay()


func UpdateGoldAmountDisplay() -> void:
	goldAmountLabel.text = str(Singleton_Game_GlobalCommonVariables.gold)

