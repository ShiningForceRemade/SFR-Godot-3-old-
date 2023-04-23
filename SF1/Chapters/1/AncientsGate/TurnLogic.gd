extends Node


var rng = RandomNumberGenerator.new()


func generate_actor_order_for_current_turn():
	#print("Generate Actor Order for Turn\n", turn_order_array)
	
	var ordered_turn_array = Singleton_CommonVariables.battle__turn_order_array
	
	rng.randomize()
	# ordered_turn_array.sort_custom(Callable(self, "sort_actors_by_agility"))
	
	ordered_turn_array.sort_custom(
	func(a, b): 
		return (a.speed + rng.randi_range(-1, 1)) > (b.speed + rng.randi_range(-1, 1))
	)
	
	print("\nOrdered Array\n")
	for n in ordered_turn_array:
		print(n)
	print("\n")
	
	Singleton_CommonVariables.battle__turn_order_array = ordered_turn_array

#
#func sort_actors_by_agility(a, b) -> bool:
#	# # TODO: remove the ag_a b add outisde of the sort to fix
#	# # the unguarded linear sort error
#	var ag_a = rng.randi_range(-1, 1)
#	var ag_b = rng.randi_range(-1, 1)
#
#	return (a.speed + ag_a) > (b.speed + ag_b)


func generate_and_launch_new_turn_order():
	generate_actor_order_for_current_turn()
	
# emit_signal("signal_hide_land_effect_and_active_actor_info")
	
#	var previous_actor_pos
#	if Singleton_CommonVariables.currently_active_character != null:
#		print("Cur Active Char pos - ",  Singleton_CommonVariables.currently_active_character.global_position)
#		previous_actor_pos = Singleton_CommonVariables.currently_active_character.global_position
#	else:
#		print("MC pos - ",  mc.global_position)
#		previous_actor_pos = mc.global_position # Vector2(205, 420)
#
	
	# print(turn_order_array)
	
	# var order_idx = 0
	for a in Singleton_CommonVariables.battle__turn_order_array:
		print("\n", a)
		
		# astar_node.clear()
		
		if a.alive == false:
			print("Dead Shouldn't be in tree")
			print(Singleton_CommonVariables.character_nodes.get_children())
			continue
				
		# print("PREVIOUS ACTOR POS - ", previous_actor_pos, " ", a.node.position)
		
	# emit_signal("signal_hide_land_effect_and_active_actor_info")
		
		print(a.type, " Turn Start")
		Singleton_CommonVariables.battle__currently_active_actor = a.node
		
		# Singleton_CommonVariables.main_character_player_node = a.node
		# Singleton_CommonVariables.main_character_active_kinematic_body_node = a.node
		
		# camera.smooth_move_to_new_position(a.node.get_node("EnemeyRoot/KinematicBody2D"))
		
#		cursor_move_to_next_actor(a.node, previous_actor_pos)
#		await Signal(camera, "signal_camera_move_complete")
#		cursor_root.hide()
		
		# mc.connect("signal_character_moved", self, "get_tile_info_under_character")
		
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(true)
		
		# Singleton_CommonVariables.set_currently_active_character(a.node)
		
		# active_character_or_enemey_display_info()
	#emit_signal("signal_show_land_effect_and_active_actor_info")
		Singleton_CommonVariables.ui__land_effect_popup_node.show()
		Singleton_CommonVariables.ui__actor_micro_info_box.show_cust()
		
		print(Singleton_CommonVariables.battle__currently_active_actor)
		Singleton_CommonVariables.ui__actor_micro_info_box.display_actor_info(
			Singleton_CommonVariables.battle__currently_active_actor
		)
		
		# Singleton_Game_GlobalBattleVariables.battle_base.s_show_land_effect()
#		show_movement_tiles()

		Singleton_CommonVariables.battle__logic_node.movement_logic_node.generate_movement_array_representation()
		
##			generate_enemey_movement_array_representation()
#		draw_movement_tiles_from_movement_array()
		
		# $AnimationPlayer.play("RandomTileFlashing")
		# await Signal(get_tree().create_timer(0.3), "timeout")
		
		
		
		if a.type == "character" || Singleton_CommonVariables.battle__control_enemies:
			Singleton_CommonVariables.battle__currently_active_actor.play_turn()
		else:
			print("Enemy turn")
			# play ai turn for enemey actor
			Singleton_CommonVariables.battle__currently_active_actor.play_turn()
		
		await Signal(Singleton_CommonVariables.battle__currently_active_actor, "signal_completed_turn")
	# await Signal(Singleton_CommonVariables.self_node(), "signal_completed_turn")
		
		# mc.z_index = 0
		print(a.type, " Turn End")
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(false)
		
		# print(Singleton_CommonVariables.battle__currently_active_actor.global_position)
#		previous_actor_pos = a.node.global_position
#		hide_movement_tiles()
					
		# await Signal(get_tree().create_timer(0.25), "timeout")
		# Singleton_CommonVariables.currently_selected_actor = null
		
	#		if a.type == "enemey":
#			generate_enemey_movement_array_representation()
#		else:
#			generate_movement_array_representation()
#
#		draw_movement_tiles_from_movement_array()
#


#
#	for a in Singleton_CommonVariables.battle__turn_order_array:
#		print("\n", a)
#
#		# astar_node.clear()
#
#		if a.alive == false:
#			print("Dead Shouldn't be in tree")
#			print(Singleton_CommonVariables.character_nodes.get_children())
#			continue
#
#		# print("PREVIOUS ACTOR POS - ", previous_actor_pos, " ", a.node.position)
#
#		emit_signal("signal_hide_land_effect_and_active_actor_info")
#
#		if a.type == "enemey" && Singleton_CommonVariables.battle__control_enemies == false:
#			# continue
#
#			print("Enemy Turn Start")
#
#			# camera.smooth_move_to_new_position(a.node.get_node("EnemeyRoot/KinematicBody2D"))
#
##			cursor_move_to_next_actor(a.node, previous_actor_pos)
##			await Signal(camera, "signal_camera_move_complete")
##			cursor_root.hide()
#
#			# mc.connect("signal_character_moved", self, "get_tile_info_under_character")
#
#			print(a.node)
##			mc = a.node
##			mc.z_index = 1
#
#			Singleton_CommonVariables.currently_active_character = a.node
#
#			# active_character_or_enemey_display_info()
#			emit_signal("signal_show_land_effect_and_active_actor_info")
#			Singleton_CommonVariables.battle_base.force_show_land_effect()
#
#			# Singleton_Game_GlobalBattleVariables.battle_base.s_show_land_effect()
##			show_movement_tiles()
##
##			generate_enemey_movement_array_representation()
##			draw_movement_tiles_from_movement_array()
#
#			$AnimationPlayer.play("RandomTileFlashing")
#
#			await Signal(get_tree().create_timer(0.3), "timeout")
#
#			a.node.play_turn()
#			await Signal(a.node, "signal_completed_turn")
#
#			# mc.z_index = 0
#			print("Enemy Turn End")
#
#			print(a.node.global_position)
##			previous_actor_pos = a.node.global_position
##			hide_movement_tiles()
#
##			var t = Timer.new()
##			t.set_wait_time(0.75)
##			t.set_one_shot(true)
##			self.add_child(t)
##			t.start()
##			yield(t, "timeout")
#		elif a.type == "character" || Singleton_CommonVariables.battle__control_enemies:
#			# continue
#			print("Character Turn Start")
#
#			# check if actor is defeated
#
#			# NOTE: TODO: BUG: more than likely signal for turn complete firing too quickly
#			# triggers multiple turn ends forcing wiat to test following character moves for note
#			# when adding the action menu that would prevent is_action_just_pressed enter from being immediately called
#			# when would elimate the need for this as well
#			# if the above doesnt work cause of fall through a triggers menuy menu triggers stay action
#			# add a singleton when triggered set bool to triggered when released un set and check for it
#
#
##			cursor_move_to_next_actor(a.node, previous_actor_pos)
##			await Signal(camera, "signal_camera_move_complete")
##			cursor_root.hide()
##
##			mc = a.node
#
#
#			Singleton_CommonVariables.set_currently_active_character(a.node)
#			a.node.play_turn()
#			# mc = a.node
#			#camera.smooth_move_to_new_position(a.node.get_kinematic_body())
#
#			# cursor_root.hide()
#			# camera.smooth_move_to_new_position(a.node.get_kinematic_body())
#
#			# camera.playerNode = a.node.get_kinematic_body()
#			# camera.smooth_move_to_new_position(a.node.get_kinematic_body())
#
#			# active_character_or_enemey_display_info()
#			emit_signal("signal_show_land_effect_and_active_actor_info")
#			Singleton_CommonVariables.battle_base.force_show_land_effect()
#
##			mc.connect("signal_character_moved", self, "get_tile_info_under_character")
##			mc.connect("signal_show_character_action_menu", self, "s_show_character_action_menu")
##			mc.connect("signal_switch_focus_to_cursor", self, "s_switch_focus_to_cursor")
##
##			show_movement_tiles()
#
##			if a.type == "enemey":
##				generate_enemey_movement_array_representation()
##			else:
##				generate_movement_array_representation()
##
##			draw_movement_tiles_from_movement_array()
##
#			# $AnimationPlayer.play("RandomTileFlashing")
#			# play_turn will yield control until the player or enemy finishes its turn
#
#			# mc.z_index = 1
#
#			await Signal(Singleton_CommonVariables.self_node(), "signal_completed_turn")
#
#			# yield(a.node, "signal_completed_turn_z")
#			# hide_movement_tiles()
#			print("Character Turn End")
#
##			previous_actor_pos = a.node.global_position
##			mc.z_index = 0
##
##			mc.disconnect("signal_character_moved", self, "get_tile_info_under_character")
##			mc.disconnect("signal_show_character_action_menu", self, "s_show_character_action_menu")
##			mc.disconnect("signal_switch_focus_to_cursor", self, "s_switch_focus_to_cursor")
##
##			show_movement_tiles()
#
#			await Signal(get_tree().create_timer(0.25), "timeout")
#			Singleton_CommonVariables.currently_selected_actor = null
#
##		if previous_actor_pos == Vector2.ZERO:
##			previous_actor_pos = a.node.global_position
##
##
##		for actor in Singleton_CommonVariables.turn_order_array:
##			# if actor.node == null:
##			if actor.alive:
##				if actor.node.get_actor_root_node_internal().HP_Current == 0:
##					actor.node.get_actor_root_node_internal().check_if_defeated()
##					await Signal(actor.node.get_actor_root_node_internal(), "signal_check_defeat_done")
##					# yield(actor.node.get_actor_root_node_internal(), "signal_check_defeat_done")
##					print("TODO Clean up logic and animation")
##					actor.node.queue_free()
##					actor.alive = false;
##
##					if actor.name == "MaxRoot":
##						await Signal(get_tree().create_timer(0.25), "timeout")
##						# print_defeat_max_was_killed()
##
##					if actor.name == "RuneKnightRoot":
##						await Signal(get_tree().create_timer(0.25), "timeout")
##						# print_victory_defeated_rune_knight()
##
##					continue
##
##			pass
#
#		# if not find_actor_by_node_name("MaxRoot", characters):
#		# 	print_defeat_max_was_killed()
#
#		# if not find_actor_by_node_name("RuneKnightRoot", enemies):
#		#	print_victory_defeated_rune_knight()
#


#	print("\n\n\nTurn " + str(turn_number) + " Completed\n\n\n")
#	turn_number += 1
#	Singleton_CommonVariables.field_logic_node.turn_number = turn_number
	generate_and_launch_new_turn_order()
