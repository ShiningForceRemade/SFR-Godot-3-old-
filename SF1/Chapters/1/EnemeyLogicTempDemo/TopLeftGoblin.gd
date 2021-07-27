extends Node

signal signal_logic_completed

var pself

func play_turn(self_arg):
	pself = self_arg
	
	if Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number == 1:
		for _i in range(4):
			pself.random_move_direction(0)
			yield(pself.tween, "tween_completed")
	else:
		yield(pself.get_tree().create_timer(0.1), "timeout")
		pself.internal_call_complete()
		# pseudo_ai_turn_determine()
	
	pself.internal_call_complete()

func pseudo_ai_turn_determine():
	for _i in range(4):
		pself.random_move_direction(0)
		yield(pself.tween, "tween_completed")
	pself.animationPlayer.play("DownMovement")
	
	pself.internal_call_complete()
	# emit_signal("signal_logic_completed")
