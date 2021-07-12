extends Control

func _ready():
	pass

func init_item_micro_info(texture, item_name, is_equipped):
	$ItemTextureRect.texture = texture
	$ItemNameLabel.text = item_name
	if is_equipped:
		$EquippedLabel.show()
	else:
		$EquippedLabel.hide()
