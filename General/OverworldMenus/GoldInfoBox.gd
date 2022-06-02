extends Control

onready var goldAmountLabel = $GoldNinePatchRect/GoldAmountLabel

func _ready():
	pass


func UpdateGoldAmountDisplay() -> void:
	goldAmountLabel.text = str(Singleton_Game_GlobalCommonVariables.gold)

