extends Node

signal signal_logic_completed

var pself

func play_turn(self_arg):
	pself = self_arg
	
	print("Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number ", Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number)
	if Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number == 1:
		for _i in range(4):
			pself.random_move_direction(1)
			yield(pself.tween, "tween_completed")
		
		emit_signal("signal_logic_completed")
		pself.internal_call_complete()
	else:
		# yield(pself.get_tree().create_timer(0.1), "timeout")
		
		var res = pself.is_character_actor_within_attack_range()
		if res != Vector2.ZERO:
			Singleton_Game_GlobalBattleVariables.target_selection_node.setup_use_range_and_target_range_selection_enemey_static()
			Singleton_Game_GlobalBattleVariables.target_selection_node.target_range.draw_cursor_at_position(res)
			pself.internal_attack_actor_found()
			
			emit_signal("signal_logic_completed")
			pself.internal_call_complete()
		else:
			
			yield(pself.get_tree().create_timer(0.3), "timeout")
			pself.internal_call_complete()
	
	# yield(pself.get_tree().create_timer(0.3), "timeout")
	# pself.internal_call_complete()


