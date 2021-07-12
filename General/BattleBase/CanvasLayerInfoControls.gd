extends CanvasLayer

func _ready():
	pass

func update_land_effect(land_effect):
	$LandEffectPopupRoot/NinePatchRect/LandEffectPercentageLabel.text = str(land_effect) + "%"

func update_active_character_or_enemey_info(name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp):
	$ActiveActorMicroInfoRoot.update_active_info(name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp)
