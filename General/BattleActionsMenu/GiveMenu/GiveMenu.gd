extends Node2D

onready var emptySlotTexture = load("res://Assets/SFCD/Items/EmptyItemSlot.png")

signal signal_completed_item_give_action

onready var redSelection = $RedSelectionBorderRoot

const rs_top_pos    = Vector2(16, 0)
const rs_left_pos   = Vector2(0, 12)
const rs_right_pos  = Vector2(32, 12)
const rs_bottom_pos = Vector2(16, 24)

var is_battle_give_menu_active: bool = false
var is_target_selection_active: bool = false

enum e_give_menu_options {
	UP_OPTION,
	LEFT_OPTION,
	RIGHT_OPTION,
	DOWN_OPTION
}
var currently_selected_option: int = e_give_menu_options.UP_OPTION

# onready var animationPlayer = $AnimationPlayer

onready var up_slot_spirte = $SlotUpSprite
onready var down_slot_spirte = $SlotDownSprite
onready var left_slot_spirte = $SlotLeftSprite
onready var right_slot_spirte = $SlotRightSprite

onready var typeLabel = $ItemInfoNinePatchRect/TypeNameLabel
onready var nameLabel = $ItemInfoNinePatchRect/WeaponNameLabel

var inventory_items

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

var selected_item_idx = 0

# TODO: clean this up more messy than the usual
var cancelled_give: bool = false

func _ready():
	set_sprites_to_zero_frame()
	redSelection.position = rs_top_pos
	# $AnimationPlayer.playback_speed = 2
	# animationPlayer.play("UseMenuOption")
	# label.text = "Use"
	pass

func set_battle_give_menu_active() -> void:
	is_battle_give_menu_active = true
	
	set_sprites_to_zero_frame()
	
	var active_char_root = Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal()
	
	print("Equip Menu Current Char", active_char_root)
	print("Equip Menu ", active_char_root.inventory_items_id)
	
	## TODO: FIXME: temp setting inventroy to equipped idea while migrating to new structure and github
	
	inventory_items = active_char_root.inventory_items_id # active_char_root.is_item_equipped
	
	if inventory_items.size() == 0:
		print("No inventory items probably should print the no items skip actions imilar to magic")
		# return
	
	for i in range(inventory_items.size()):
		print(inventory_items[i])
		if i == 0:
			up_slot_spirte.texture = inventory_items[i].texture
			nameLabel.text = inventory_items[i].item_name
			typeLabel.text = inventory_items[i].get_item_type()
		if i == 1:
			left_slot_spirte.texture = inventory_items[i].texture
		if i == 2:
			right_slot_spirte.texture = inventory_items[i].texture
		if i == 3:
			down_slot_spirte.texture = inventory_items[i].texture
		# up_slot_spirte.texture = item.texture
		# item__info__weapon_name_label.text = item.item_name

func _input(event):
	if is_battle_give_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Use Inventory Menu")
			is_battle_give_menu_active = false
			
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			# Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").active = true
			# get_parent().get_parent().get_parent().s_hide_battle_inventory_menu()
			get_parent().get_parent().get_parent().s_hide_battle_give_menu()
			
			# TODO: HACK: FIXME: Dirty hack need a better way to gurantee when action is completed to prevent retrigger
			# yield on signal seems busted sometimes gets double called or falls through?
			yield(get_tree().create_timer(0.1), "timeout")
			get_parent().get_parent().get_parent().s_show_battle_inventory_menu("right")
			# get_parent().get_parent().get_parent().s_show_battle_inventory_menu()
			# get_parent().get_node("BattleInventoryMenuRoot").set_battle_inventory_menu_active()
			return
			
		if event.is_action_released("ui_a_key"): # event.is_action_released("ui_accept"):
			print("Accept Action - ", currently_selected_option)
			
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			
			#if currently_selected_option == e_menu_options.STAY_OPTION:
			#	print("Currently Active Character Node - ", Singleton_Game_GlobalBattleVariables.currently_active_character)
			#	Singleton_Game_GlobalBattleVariables.currently_active_character.s_complete_turn()
				
			#	# emit_signal("signal_completed_turn")
			#	is_battle_inventory_menu_active = false
			#	get_parent().get_parent().s_hide_action_menu()
			#	return
					
			var actor = Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal()
			
			print(actor.inventory_items_id[currently_selected_option].item_name)
			print(actor.is_item_equipped[currently_selected_option])
			
			# actor.inventory_items_id[currently_selected_option].item_use_range_path
			# actor.inventory_items_id[currently_selected_option].item_use_target_path
			
			is_battle_give_menu_active = false
			is_target_selection_active = true
			Singleton_Game_GlobalBattleVariables.field_logic_node.hide_movement_tiles()
			Singleton_Game_GlobalBattleVariables.field_logic_node.show_use_target_tiles()
			
			get_parent().get_parent().get_parent().s_hide_battle_give_menu()
			setup_use_range_and_target_range_selection(actor.inventory_items_id[currently_selected_option])
			yield(self, "signal_completed_item_give_action")
			
			# Todo check if cancelled cancelled
			
			if cancelled_give:
				print("I was reached")
				cancelled_give = false
				# is_battle_give_menu_active = true
				# is_target_selection_active = true
			else:
				# Else attempted to make give 
				# if failed inventory full
			
				# Else complete success end turn
				is_battle_give_menu_active = false
				is_target_selection_active = false
			
				# set_battle_give_menu_active()
				# get_parent().get_parent().get_parent().s_show_battle_give_menu()
			
				print("Complete")
				Singleton_Game_GlobalBattleVariables.currently_selected_actor = null
				Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").get_node("AnimationPlayer").play("DownMovement")
				target_range.cleanup_cursor()
				get_parent().get_parent().get_parent().s_hide_battle_give_menu()
				Singleton_Game_GlobalBattleVariables.field_logic_node.show_movement_tiles()
				Singleton_Game_GlobalBattleVariables.field_logic_node.hide_use_target_tiles()
				Singleton_Game_GlobalBattleVariables.s_completed_turn()
		
		if event.is_action_pressed("ui_down"):
			if 3 <= inventory_items.size() - 1:
				redSelection.position = rs_bottom_pos
				currently_selected_option = e_give_menu_options.DOWN_OPTION
				nameLabel.text = inventory_items[3].item_name
				typeLabel.text = inventory_items[3].get_item_type()
				selected_item_idx = 3
		elif event.is_action_pressed("ui_up"):
			if 0 <= inventory_items.size() - 1:
				redSelection.position = rs_top_pos
				currently_selected_option = e_give_menu_options.UP_OPTION
				nameLabel.text = inventory_items[0].item_name
				typeLabel.text = inventory_items[0].get_item_type()
				selected_item_idx = 0
		elif event.is_action_pressed("ui_right"):
			if 2 <= inventory_items.size() - 1:
				redSelection.position = rs_right_pos
				currently_selected_option = e_give_menu_options.RIGHT_OPTION
				nameLabel.text = inventory_items[2].item_name
				typeLabel.text = inventory_items[2].get_item_type()
				selected_item_idx = 2
		elif event.is_action_pressed("ui_left"):
			if 1 <= inventory_items.size() - 1:
				redSelection.position = rs_left_pos
				currently_selected_option = e_give_menu_options.LEFT_OPTION
				nameLabel.text = inventory_items[1].item_name
				typeLabel.text = inventory_items[1].get_item_type()
				selected_item_idx = 1
	
	if is_target_selection_active:
		if event.is_action_released("ui_b_key"):
			Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro()
			Singleton_Game_GlobalBattleVariables.battle_base.s_hide_micro_actor_inventory_view()
			Singleton_Game_GlobalBattleVariables.field_logic_node.show_movement_tiles()
			Singleton_Game_GlobalBattleVariables.field_logic_node.hide_use_target_tiles()
			target_range.cleanup_cursor()
			is_target_selection_active = false
			is_battle_give_menu_active = true
			cancelled_give = true
			get_parent().get_parent().get_parent().s_show_battle_give_menu()
			emit_signal("signal_completed_item_give_action")
			
		if event.is_action_released("ui_a_key"):
			if Singleton_Game_GlobalBattleVariables.currently_selected_actor == null:
				print("No target TODO: do this check prior")
			else:
				# emit_signal("signal_completed_item_give_action")
				# TODO: fully complete turn after give has been completed
				
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
				
				Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro()
				Singleton_Game_GlobalBattleVariables.battle_base.s_hide_micro_actor_inventory_view()
			
				var r = attempt_to_give_item_to_character_actor()
			
				if r:
					emit_signal("signal_completed_item_give_action")
				else:
					print("TODO: cant pass item inventory full")
			
			
		
		if event.is_action_pressed("ui_down"):
			var pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
			var vpos = Vector2(pos.x, pos.y + 24)
			var n = get_character_at_tile_position(vpos)
			if n != null:
				print("New Target Selection")
				Singleton_Game_GlobalBattleVariables.currently_selected_actor = n
				Singleton_Game_GlobalBattleVariables.battle_base.s_show_micro_actor_inventory_view()
				Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro()
				target_range.draw_cursor_at_position(vpos)
			
			# is_target_selection_active = false
			# emit_signal("signal_completed_item_use_action")
		elif event.is_action_pressed("ui_up"):
			var pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
			var vpos = Vector2(pos.x, pos.y - 24)
			var n = get_character_at_tile_position(vpos)
			if n != null:
				print("New Target Selection")
				Singleton_Game_GlobalBattleVariables.currently_selected_actor = n
				Singleton_Game_GlobalBattleVariables.battle_base.s_show_micro_actor_inventory_view()
				Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro()
				target_range.draw_cursor_at_position(vpos)
				
			# is_target_selection_active = false
			# emit_signal("signal_completed_item_use_action")
		elif event.is_action_pressed("ui_right"):
			var pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
			var vpos = Vector2(pos.x + 24, pos.y)
			var n = get_character_at_tile_position(vpos)
			if n != null:
				print("New Target Selection")
				Singleton_Game_GlobalBattleVariables.currently_selected_actor = n
				Singleton_Game_GlobalBattleVariables.battle_base.s_show_micro_actor_inventory_view()
				Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro()
				target_range.draw_cursor_at_position(vpos)
			
			# is_target_selection_active = false
			# emit_signal("signal_completed_item_use_action")
		elif event.is_action_pressed("ui_left"):
			var pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
			var vpos = Vector2(pos.x - 24, pos.y)
			var n = get_character_at_tile_position(vpos)
			if n != null:
				print("New Target Selection")
				Singleton_Game_GlobalBattleVariables.currently_selected_actor = n
				Singleton_Game_GlobalBattleVariables.battle_base.s_show_micro_actor_inventory_view()
				Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro()
				target_range.draw_cursor_at_position(vpos)
			# is_target_selection_active = false
			# emit_signal("signal_completed_item_use_action")

func set_sprites_to_zero_frame() -> void:
	up_slot_spirte.texture    = emptySlotTexture
	down_slot_spirte.texture  = emptySlotTexture
	left_slot_spirte.texture  = emptySlotTexture
	right_slot_spirte.texture = emptySlotTexture

func setup_use_range_and_target_range_selection(item_arg) -> void:
	print(item_arg)
	print(item_arg.item_use_range_path)
	var item_use_range = load("res://General/UseAndTargetRangeResources/UseRangeResources/UseRange_1.gd").new()
	print(item_use_range)
	item_use_range._ready()
	# TODO create cleanup function to remove the attack grid when canclled or completed
	item_use_range.draw_use_range()
	target_range = load("res://General/UseAndTargetRangeResources/TargetRangeResources/TargetRange_1.gd").new()
	# TODO create cleanup function for this to remove the curosr
	target_range.draw_cursor_and_get_targets("test arg 123")
	
	target_node_children = Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
	#for child in target_node_children:
	#	print(child)
	#	print(child.position)
		
	#emit_signal("signal_completed_item_use_action")
	# return

func get_character_at_tile_position(pos_arg):
	for child in target_node_children:
		if child.position == pos_arg:
			print(child.name)
			return child
			
	return null


func attempt_to_give_item_to_character_actor() -> bool:
	# if Singleton_Game_GlobalBattleVariables.currently_selected_actor == null:
	# 	return false
	
	var cac = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	var csa = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("CharacterRoot")
	
	if csa.inventory_items_id.size() < 4:
		print("Give Item")
		
		print(csa.inventory_items_id)
		for i in csa.inventory_items_id:
			print(i)
		print(selected_item_idx)
		for i in cac.inventory_items_id:
			print(i)
		print(cac.inventory_items_id[selected_item_idx])
		
		csa.inventory_items_id.append(cac.inventory_items_id[selected_item_idx])
		csa.is_item_equipped.append(false)
		
		cac.inventory_items_id.remove(selected_item_idx)
		cac.is_item_equipped.remove(selected_item_idx)
		
		return true
	else:
		print("Full Inventory can't give Item")
		return false
	
