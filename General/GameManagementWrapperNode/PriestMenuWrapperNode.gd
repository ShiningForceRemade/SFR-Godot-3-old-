extends Node

const bmc_x: int = 171
const bmc_y: int = 182

onready var PriestMenuRoot = $PriestMenuRoot
onready var PriestMenuTween = $PriestMenuTween

func _ready():
	pass


func internal_tween_move_to_position(ox, oy, nx, ny, tweenNode, targetNode) -> void:
	print(tweenNode)
	tweenNode.interpolate_property(targetNode, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenNode.start()

func s_hide_priest_menu():
	internal_tween_move_to_position(139, 134, 139, 134 + 80, PriestMenuTween, PriestMenuRoot)

func s_show_priest_menu():
	internal_tween_move_to_position(139, 134 + 80, 139, 134, PriestMenuTween, PriestMenuRoot)
	PriestMenuRoot.set_menu_active()
