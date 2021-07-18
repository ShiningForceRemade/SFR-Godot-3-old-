extends Node

const tile_size: int = 24

signal signal_completed_target_selection_action

var is_target_selection_active: bool = false

var target_node_children

# NOTE: testing with fixed use case
# TODO: create a generic logic node higher up in the tree to handle target range type and  use range type
# save the following function logic in the battle singleton and let that handle the following actions the the logic node completes its selection after
# 
var use_range = [
	[null, 1, null],
	[1,    1,    1],
	[null, 1, null]
	]

# very messy clean this up later 
# TODO: redo global battle vars to track more of this state internally
# so there isn't so much repatition in various nodes that are mostly similar
var target_range

var item_use_range

	
# var active_char_root = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	


func _ready():
	Singleton_Game_GlobalBattleVariables.target_selection_node = self
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
#	if is_battle_use_menu_active:
#		if event.is_action_released("ui_b_key"):
#			print("Cancel Use Inventory Menu")
#			is_battle_use_menu_active = false
#			# Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").active = true
#			# get_parent().get_parent().get_parent().s_hide_battle_inventory_menu()
#			get_parent().get_parent().get_parent().s_hide_battle_use_menu()
#
#			# TODO: HACK: FIXME: Dirty hack need a better way to gurantee when action is completed to prevent retrigger
#			# yield on signal seems busted sometimes gets double called or falls through?
#			yield(get_tree().create_timer(0.1), "timeout")
#			get_parent().get_parent().get_parent().s_show_battle_inventory_menu("right")
#			# get_parent().get_parent().get_parent().s_show_battle_inventory_menu()
#			# get_parent().get_node("BattleInventoryMenuRoot").set_battle_inventory_menu_active()
#			return
#
#		if event.is_action_released("ui_accept"):
#			print("Accept Action - ", currently_selected_option)
#
#			var actor = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
#
#			print(actor.inventory_items_id[currently_selected_option].item_name)
#			print(actor.is_item_equipped[currently_selected_option])
#
#			# actor.inventory_items_id[currently_selected_option].item_use_range_path
#			# actor.inventory_items_id[currently_selected_option].item_use_target_path
#
#			is_battle_use_menu_active = false
#			is_target_selection_active = true
#			Singleton_Game_GlobalBattleVariables.field_logic_node.hide_movement_tiles()
#			Singleton_Game_GlobalBattleVariables.field_logic_node.show_use_target_tiles()
#
#			get_parent().get_parent().get_parent().s_hide_battle_use_menu()
#			setup_use_range_and_target_range_selection(actor.inventory_items_id[currently_selected_option])
#			yield(self, "signal_completed_item_use_action")
#
#			# todo if cancelled
#			is_battle_use_menu_active = true
#			is_target_selection_active = false
#			get_parent().get_parent().get_parent().s_show_battle_use_menu()
#			# if completed action
#			# emit turn completed to field logic node
#			# Singleton_Game_GlobalBattleVariables.field_logic_node
#
#			print("Complete")
#			#if currently_selected_option == e_menu_options.STAY_OPTION:
#			#	print("Currently Active Character Node - ", Singleton_Game_GlobalBattleVariables.currently_active_character)
#			#	Singleton_Game_GlobalBattleVariables.currently_active_character.s_complete_turn()
#
#			#	# emit_signal("signal_completed_turn")
#			#	return

	if is_target_selection_active:
		if event.is_action_released("ui_b_key"):
			is_target_selection_active = false
			emit_signal("signal_completed_item_use_action")
			Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro()
			Singleton_Game_GlobalBattleVariables.field_logic_node.show_movement_tiles()
			Singleton_Game_GlobalBattleVariables.field_logic_node.hide_use_target_tiles()
			target_range.cleanup_cursor()
			
		if event.is_action_released("ui_a_key"):
			is_target_selection_active = false
			print("Called")
			print("TODO: trigger battle action scene and play out the item use effect")
			Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro()
		
		if event.is_action_pressed("ui_down"):
			print("Called")
			
			var pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
			var vpos = Vector2(pos.x, pos.y + 24)
			var n = get_character_at_tile_position(vpos)
			if n != null:
				print("New Target Selection")
				Singleton_Game_GlobalBattleVariables.currently_selected_actor = n
				Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro()
				target_range.draw_cursor_at_position(vpos)
			
			# is_target_selection_active = false
			# emit_signal("signal_completed_item_use_action")
		elif event.is_action_pressed("ui_up"):
			var pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
			get_character_at_tile_position(Vector2(pos.x, pos.y - 24))
			
			# is_target_selection_active = false
			# emit_signal("signal_completed_item_use_action")
		elif event.is_action_pressed("ui_right"):
			var pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
			var vpos = Vector2(pos.x + 24, pos.y)
			var n = get_character_at_tile_position(vpos)
			if n != null:
				print("New Target Selection")
				Singleton_Game_GlobalBattleVariables.currently_selected_actor = n
				Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro()
				target_range.draw_cursor_at_position(vpos)
			
			# is_target_selection_active = false
			# emit_signal("signal_completed_item_use_action")
		elif event.is_action_pressed("ui_left"):
			var pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
			get_character_at_tile_position(Vector2(pos.x - 24, pos.y))
			
			# is_target_selection_active = false
			# emit_signal("signal_completed_item_use_action")
		

func setup_use_range_and_target_range_selection(item_arg) -> void:
	is_target_selection_active = true
	
	print("Called")
	
	print(item_arg)
	print(item_arg.item_use_range_path)
	item_use_range = load(item_arg.item_use_range_path).new()
	print(item_use_range)
	item_use_range._ready()
	# TODO create cleanup function to remove the attack grid when canclled or completed
	item_use_range.draw_use_range()
	target_range = load(item_arg.item_use_target_path).new()
	# TODO create cleanup function for this to remove the curosr
	target_range.draw_cursor_and_get_targets("test arg 123")

	# target_range.draw_cursor_at_position(new_pos_arg: Vector2)
	
	print("Target Actor Type - ", item_arg.target_actor_type)
	if item_arg.target_actor_type == 4:
		print("Self and Characters")
		print(Singleton_Game_GlobalBattleVariables.character_wrapper_node)
		
		print(Singleton_Game_GlobalBattleVariables.currently_active_character)
		print(Singleton_Game_GlobalBattleVariables.currently_active_character.position)
		
		print(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
		
		target_node_children = Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
		for child in target_node_children:
			print(child)
			print(child.position)
	elif item_arg.target_actor_type == 2: # Enemeies - TODO: add enum or consts to use instead of raw numbers
		print("Enemies")
		print(Singleton_Game_GlobalBattleVariables.enemies_wrapper_node)
		
		print(Singleton_Game_GlobalBattleVariables.currently_active_character)
		print(Singleton_Game_GlobalBattleVariables.currently_active_character.position)
		
		print(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
		
		target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
		#for child in target_node_children:
		#	print(child)
		#	print(child.position)
		
		set_cursor_target_on_first_found_enemey()
		# target_range.draw_cursor_at_position(target_node_children[0].position)
	#emit_signal("signal_completed_item_use_action")
	# return

func get_character_at_tile_position(pos_arg):
	for child in target_node_children:
		if child.position == pos_arg:
			print(child.name)
			return child
			
	return null

# TODO: this can be simplified soooo much clean this up and remove a lot of the redundant elements later

func set_cursor_target_on_first_found_enemey() -> void:
	var use_range_array_rep = item_use_range.get_use_range_array_representation()
	var ac_pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
	
	# total rows and columns
	var t_rows = use_range_array_rep.size()
	var t_cols = use_range_array_rep[0].size()
	
	# center column and row
	var c_col = floor(t_cols / 2)
	var c_row = floor(t_rows / 2)
	
	var row_tiles_movement = 0
	var col_tiles_movement = 0
	
	var subtract_tiles_row = false
	var subtract_tiles_col = false
	
	var check_pos = Vector2(0, 0)
	var x 
	var y
	
	for child in target_node_children:
		print(child)
		print(child.position)
		
		for r in range(t_rows):
			for c in range(t_cols):
				if use_range_array_rep[r][c] != null:
					print(use_range_array_rep[r][c])
					
					if r < c_row:
						row_tiles_movement = c_row - r
						subtract_tiles_row = true
					elif r > c_row:
						row_tiles_movement = r - c_row
						subtract_tiles_row = false
					else:
						row_tiles_movement = 0
						subtract_tiles_row = false
					
					if c < c_col:
						col_tiles_movement = c_col - c
						subtract_tiles_col = true
					elif c > c_col:
						col_tiles_movement = c - c_col
						subtract_tiles_col = false
					else:
						col_tiles_movement = 0
						subtract_tiles_col = false
					
					if subtract_tiles_row:
						y = row_tiles_movement * tile_size
						y = y * -1
					else:
						y = row_tiles_movement * tile_size
					
					if subtract_tiles_col:
						x = col_tiles_movement * tile_size
						x = x * -1
					else:
						x = col_tiles_movement * tile_size
							
					if child.position == Vector2(ac_pos.x + x, ac_pos.y + y):
						target_range.draw_cursor_at_position(child.position)
						Singleton_Game_GlobalBattleVariables.currently_selected_actor = child
						Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro()
						# Found inital target no need to continue searching
						return
	
	# if reached here no enemeies
	# print no target and cancel out of attack
	# TODO: probably should do this check much earlier
	
	return
