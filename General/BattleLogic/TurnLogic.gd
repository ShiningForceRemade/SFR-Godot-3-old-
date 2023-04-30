extends Node

# TODO: astar node for entire tilemap
# should be used for enemey ai pathfinding
# will need to disable certain points depending on movement type
# ie none flying units cant go over water or high mountains etc..

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


#func sort_actors_by_agility(a, b) -> bool:
#	# # TODO: remove the ag_a b add outisde of the sort to fix
#	# # the unguarded linear sort error
#	var ag_a = rng.randi_range(-1, 1)
#	var ag_b = rng.randi_range(-1, 1)
#
#	return (a.speed + ag_a) > (b.speed + ag_b)


func generate_and_launch_new_turn_order():
	generate_actor_order_for_current_turn()
	
	# print(turn_order_array)
	
	for actor in Singleton_CommonVariables.battle__turn_order_array:
		print("\n", actor)
		
		# astar_node.clear()
		
		if actor.alive == false:
			print("Dead Shouldn't be in tree")
			# print(Singleton_CommonVariables.character_nodes.get_children())
			continue
		
		# print("PREVIOUS ACTOR POS - ", previous_actor_pos, " ", a.node.position)
		
		print(actor.type, " Turn Start")
		Singleton_CommonVariables.battle__currently_active_actor = actor.node
		
		# camera.smooth_move_to_new_position(a.node.get_node("EnemeyRoot/KinematicBody2D"))
		# await cursor_move_to_next_actor(a.node, previous_actor_pos)
		## await Signal(camera, "signal_camera_move_complete")
		# cursor_root.hide()
		
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(true)
		
		Singleton_CommonVariables.ui__land_effect_popup_node.show_cust()
		Singleton_CommonVariables.ui__actor_micro_info_box.show_cust()
		
		print(Singleton_CommonVariables.battle__currently_active_actor)
		Singleton_CommonVariables.ui__actor_micro_info_box.display_actor_info(
			Singleton_CommonVariables.battle__currently_active_actor
		)
		
		Singleton_CommonVariables.battle__logic_node.movement_logic_node.generate_movement_array_representation()
		Singleton_CommonVariables.battle__logic_node.movement_logic_node.show_movement_tiles()
		
		# update land effect after new move generated
		var tile_info = Singleton_CommonVariables.battle__logic_node.movement_logic_node.get_land_effect_value_at_pos(Singleton_CommonVariables.battle__currently_active_actor.get_child(0).global_position)
		if tile_info != null:
			Singleton_CommonVariables.ui__land_effect_popup_node.set_land_effect_value_text(str(tile_info.value) + "%")
		else:
			Singleton_CommonVariables.ui__land_effect_popup_node.set_land_effect_value_text("BUG")
		
		
		if actor.type == "character" || Singleton_CommonVariables.battle__control_enemies:
			Singleton_CommonVariables.battle__currently_active_actor.play_turn()
		else:
			print("Enemy turn")
			# play ai turn for enemey actor
			Singleton_CommonVariables.battle__currently_active_actor.play_turn()
		
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).z_index = 1
		await Signal(Singleton_CommonVariables.battle__currently_active_actor, "signal_completed_turn")
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).z_index = 0
		
		print(actor.type, " Turn End")
		
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(false)
		
		play_death_animation_for_all_defeated_actors()
		
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).play_facing_direction("Down")
		
		Singleton_CommonVariables.battle__logic_node.movement_logic_node.hide_movement_tiles()
		Singleton_CommonVariables.ui__land_effect_popup_node.hide_cust()
		Singleton_CommonVariables.ui__actor_micro_info_box.hide_cust()
		
		# await Signal(get_tree().create_timer(0.25), "timeout")
		# Singleton_CommonVariables.currently_selected_actor = null
	
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
	
#	print("\n\n\nTurn " + str(turn_number) + " Completed\n\n\n")
	Singleton_CommonVariables.battle__turn_number += 1
	generate_and_launch_new_turn_order()


func play_death_animation_for_all_defeated_actors() -> void:
	for b_idx in Singleton_CommonVariables.battle__turn_order_array.size():
		if Singleton_CommonVariables.battle__turn_order_array[b_idx].alive == false:
			# play death animations then delete them when complete
			
			if Singleton_CommonVariables.battle__turn_order_array[b_idx].id != null:
				Singleton_CommonVariables.battle__turn_order_array[b_idx].node.queue_free()
				Singleton_CommonVariables.battle__turn_order_array[b_idx].id = null
			
			# Singleton_CommonVariables.battle__turn_order_array.remove_at(b_idx)
