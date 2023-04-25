extends Control

@onready var item_texture: TextureRect = $ItemSprite
@onready var item_name_label: Label = $ItemNameLabel
@onready var is_equipped_label: Label = $EquippedStaticLabel

var texture: Texture
var item_name: String
var is_equipped: bool
var cust_scale: Vector2 = Vector2(1.0, 1.0)

func _ready() -> void:
	item_texture.texture = texture
	item_name_label.text = item_name
	if is_equipped:
		is_equipped_label.show()
	else:
		is_equipped_label.hide()
	
	await get_tree().process_frame
	scale = cust_scale
