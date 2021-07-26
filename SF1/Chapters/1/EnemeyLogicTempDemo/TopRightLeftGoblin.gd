extends Node

signal signal_logic_completed

var pself

func play_turn(self_arg):
	pself = self_arg
	
	print("Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number ", Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number)
	if Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number == 1:
		random_move_direction(1)
		yield(pself.tween, "tween_completed")
		
		for _i in range(3):
			random_move_direction(3)
			yield(pself.tween, "tween_completed")
	else:
		pself.internal_call_complete()
		# pseudo_ai_turn_determine()
	
	pself.internal_call_complete()

func pseudo_ai_turn_determine():
	for _i in range(4):
		random_move_direction(0)
		yield(pself.tween, "tween_completed")
	pself.animationPlayer.play("DownMovement")
	
	pself.internal_call_complete()
	# emit_signal("signal_logic_completed")

func random_move_direction(direction):
	#if tween.is_active():
	#	return
	
	# print("Direction", direction)
	# print("Position", position)
	
	if direction == 0:
		pself.animationPlayer.play("RightMovement")
		pself.tween.interpolate_property(pself, 'position', pself.position, Vector2(pself.position.x + pself.TILE_SIZE, pself.position.y), 0.2, Tween.TRANS_LINEAR)
	elif direction == 1:
		pself.animationPlayer.play("LeftMovement")
		pself.tween.interpolate_property(pself, 'position', pself.position, Vector2(pself.position.x - pself.TILE_SIZE, pself.position.y), 0.2, Tween.TRANS_LINEAR)
	elif direction == 2:
		pself.animationPlayer.play("UpMovement")
		pself.tween.interpolate_property(pself, 'position', pself.position, Vector2(pself.position.x, pself.position.y - pself.TILE_SIZE), 0.2, Tween.TRANS_LINEAR)
	elif direction == 3:
		pself.animationPlayer.play("DownMovement")
		pself.tween.interpolate_property(pself, 'position', pself.position, Vector2(pself.position.x, pself.position.y + pself.TILE_SIZE), 0.2, Tween.TRANS_LINEAR)
	
	pself.tween.start()
