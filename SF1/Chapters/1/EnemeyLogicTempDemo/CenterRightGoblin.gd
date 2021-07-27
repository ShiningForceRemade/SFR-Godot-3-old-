extends Node

signal signal_logic_completed

var pself

func play_turn(self_arg):
	pself = self_arg
	
	print("Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number ", Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number)
	if Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number == 1:
		for _i in range(1):
			random_move_direction(3)
			yield(pself.tween, "tween_completed")
		
		emit_signal("signal_logic_completed")
		pself.internal_call_complete()
	else:
		# yield(pself.get_tree().create_timer(0.1), "timeout")
		
		var res = is_character_actor_within_attack_range()
		if res != Vector2.ZERO:
			Singleton_Game_GlobalBattleVariables.target_selection_node.setup_use_range_and_target_range_selection_enemey_static()
			Singleton_Game_GlobalBattleVariables.target_selection_node.target_range.draw_cursor_at_position(res)
			pself.internal_attack_actor_found()
			
			emit_signal("signal_logic_completed")
			pself.internal_call_complete()
		else:
			
			yield(pself.get_tree().create_timer(0.3), "timeout")
			pself.internal_call_complete()
		# pseudo_ai_turn_determine()
	
	# yield(pself.get_tree().create_timer(0.3), "timeout")
	# pself.internal_call_complete()


func is_character_actor_within_attack_range():
	
	for character in Singleton_Game_GlobalBattleVariables.character_nodes.get_children():
		print("\n", character.position, " ", Vector2(pself.position.x - 24, pself.position.y))
		if character.position == Vector2(pself.position.x - 24, pself.position.y):
			Singleton_Game_GlobalBattleVariables.currently_selected_actor = character
			return character.position
		print(character.position, " ", Vector2(pself.position.x + 24, pself.position.y))
		if character.position == Vector2(pself.position.x + 24, pself.position.y):
			Singleton_Game_GlobalBattleVariables.currently_selected_actor = character
			return character.position
		print(character.position, " ", Vector2(pself.position.x, pself.position.y - 24))
		if character.position == Vector2(pself.position.x, pself.position.y - 24):
			Singleton_Game_GlobalBattleVariables.currently_selected_actor = character
			return character.position
		print(character.position, " ", Vector2(pself.position.x, pself.position.y + 24))
		if character.position == Vector2(pself.position.x, pself.position.y + 24):
			Singleton_Game_GlobalBattleVariables.currently_selected_actor = character
			return character.position
	
	return Vector2.ZERO


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
