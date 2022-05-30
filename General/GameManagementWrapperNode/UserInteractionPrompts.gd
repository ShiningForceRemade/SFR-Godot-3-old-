extends Node

const bmc_x: int = 171
const bmc_y: int = 182

onready var YesOrNoPromptRoot = $YesOrNoPromptRoot
onready var YesOrNoPromptTween = $YesOrNoPromptTween


func _ready():
	
	# tween connect on complete
	
	pass


func internal_tween_move_to_position(ox, oy, nx, ny, tweenNode, targetNode) -> void:
	print(tweenNode)
	tweenNode.interpolate_property(targetNode, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenNode.start()


func s_hide__yes_or_no_prompt():
	internal_tween_move_to_position(132, 101, -72, 101, YesOrNoPromptTween, YesOrNoPromptRoot)
	# YesOrNoPromptRoot.hide()


func s_show__yes_or_no_prompt():
	YesOrNoPromptRoot.show()
	internal_tween_move_to_position(321, 101, 132, 101, YesOrNoPromptTween, YesOrNoPromptRoot)
	YesOrNoPromptRoot.set_menu_active()
