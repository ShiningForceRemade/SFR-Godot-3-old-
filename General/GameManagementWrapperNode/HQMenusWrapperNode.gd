extends Node

const bmc_x: int = 171
const bmc_y: int = 182

onready var HQMenuRoot = $HQMenuRoot
onready var HQMenuTween = $HQMenuTween

func _ready():
	pass


func internal_tween_move_to_position(ox, oy, nx, ny, tweenNode, targetNode) -> void:
	print(tweenNode)
	tweenNode.interpolate_property(targetNode, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenNode.start()

func s_hide_hq_menu():
	# internal_tween_move_to_position(139, 134, 139, 134 + 80, HQMenuTween, HQMenuRoot)
	HQMenuRoot.hide()

func s_show_hq_menu():
	# internal_tween_move_to_position(139, 134 + 80, 139, 134, HQMenuTween, HQMenuRoot)
	HQMenuRoot.show()
	HQMenuRoot.set_menu_active()



