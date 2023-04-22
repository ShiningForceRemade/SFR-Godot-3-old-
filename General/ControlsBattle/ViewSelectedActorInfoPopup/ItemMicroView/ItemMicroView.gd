extends Control

@onready var item_texture: TextureRect = $ItemSprite
@onready var item_name_label: Label = $ItemNameLabel
@onready var is_equipped_label: Label = $EquippedStaticLabel

func _ready() -> void:
	pass


func init_item_micro_info(texture: Texture, item_name: String, is_equipped: bool) -> void:
	item_texture.texture = texture
	item_name_label.text = item_name
	if is_equipped:
		is_equipped_label.show()
	else:
		is_equipped_label.hide()
