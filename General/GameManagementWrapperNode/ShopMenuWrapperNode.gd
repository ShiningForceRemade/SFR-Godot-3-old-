extends Node

const bmc_x: int = 171
const bmc_y: int = 182

onready var ShopMenuRoot = $ShopMenuRoot
onready var ShopMenuTween = $ShopMenuTween
onready var ShopItemSelectionMenu = $ShopItemSelectionMenuNode

func _ready():
	pass


func internal_tween_move_to_position(ox, oy, nx, ny, tweenNode, targetNode) -> void:
	print(tweenNode)
	tweenNode.interpolate_property(targetNode, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenNode.start()


func s_hide_shop_menu():
	# internal_tween_move_to_position(139, 134, 139, 134 + 80, PriestMenuTween, PriestMenuRoot)
	ShopMenuRoot.hide()
	pass


func s_show_shop_menu():
	# internal_tween_move_to_position(139, 134 + 80, 139, 134, PriestMenuTween, PriestMenuRoot)
	ShopMenuRoot.show()
	ShopMenuRoot.set_menu_active()


func s_hide_shop_item_selection_menu() -> void:
	ShopItemSelectionMenu.hide()


func s_show_shop_item_selection_menu() -> void:
	ShopItemSelectionMenu.show()
	ShopItemSelectionMenu.set_menu_active()
