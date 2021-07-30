extends Node2D

signal signal_completed_magic_level_selection_action
signal signal_completed_selected_target_action

onready var redSelection = $RedSelectionBorderRoot

const rs_top_pos    = Vector2(16, 0)
const rs_left_pos   = Vector2(0, 12)
const rs_right_pos  = Vector2(32, 12)
const rs_bottom_pos = Vector2(16, 24)

var is_battle_magic_menu_active: bool = false

enum e_magic_menu_options {
	UP_OPTION,
	LEFT_OPTION,
	RIGHT_OPTION,
	DOWN_OPTION
}
var currently_selected_option: int = e_magic_menu_options.UP_OPTION

# onready var animationPlayer = $AnimationPlayer
onready var spell_name_label = $NinePatchRect/SpellNameLabel
onready var spell_cost_label = $NinePatchRect/MpCostLabel

onready var spell_up_slot_spirte = $SpellSlotUpSprite
onready var spell_down_slot_spirte = $SpellSlotDownSprite
onready var spell_left_slot_spirte = $SpellSlotLeftSprite
onready var spell_right_slot_spirte = $SpellSlotRightSprite

var character_spells

onready var magicLevelSelectorWrapper = $NinePatchRect/MagicLevelSelectorWrapperNode2D

var is_select_magic_level_active: bool = false

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

var spell_idx: int = 0
# var spell_level_idx

func _ready():
	redSelection.position = rs_top_pos
	magicLevelSelectorWrapper.hide()
	# $AnimationPlayer.playback_speed = 2
	# animationPlayer.play("UseMenuOption")
	# label.text = "Use"
	pass


func set_battle_magic_menu_active() -> void:
	is_battle_magic_menu_active = true
	
	print("Magic Menu Current Char", Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot"))
	print("Magic Menu Spells", Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").spells_id)
	character_spells = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").spells_id
	
	# Handled in battle action menu before this would even appear
	# TODO: check for other places I might have done this
	# if character_spells.size() == 0:
	# 	print("No Spells TODO NO MAGIC BOX and emit")
	#	return
	
	for idx in (character_spells.size()):
		# print(spell)
		if idx == 0:
			spell_up_slot_spirte.texture = character_spells[idx].spell_texture
			spell_name_label.text = character_spells[idx].name
			spell_cost_label.text = str(character_spells[idx].levels[0].mp_usage_cost)
		elif idx == 1:
			spell_left_slot_spirte.texture = character_spells[idx].spell_texture
		elif idx == 2:
			spell_right_slot_spirte.texture = character_spells[idx].spell_texture
		elif idx == 3:
			spell_down_slot_spirte.texture = character_spells[idx].spell_texture

func _input(event):
	if is_battle_magic_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Magic Inventory Menu")
			is_battle_magic_menu_active = false
			# Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").active = true
			# get_parent().get_parent().get_parent().s_hide_battle_inventory_menu()
			get_parent().get_parent().get_parent().s_hide_battle_magic_menu()
			get_parent().get_parent().get_parent().s_show_battle_action_menu("right")
			
			# TODO: HACK: FIXME: Dirty hack need a better way to gurantee when action is completed to prevent retrigger
			# yield on signal seems busted sometimes gets double called or falls through?
			yield(get_tree().create_timer(0.1), "timeout")
			get_parent().get_node("BattleActionsMenuRoot").set_menu_active()
			return
			
		if event.is_action_released("ui_a_key"): # event.is_action_released("ui_accept"):
			print("Accept Action - ", currently_selected_option)
			
			yield(get_tree().create_timer(0.001), "timeout")
			
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			# Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			is_select_magic_level_active = true
			is_battle_magic_menu_active = false
			
			var actor = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
			
			magicLevelSelectorWrapper.show()
			select_magic_level(actor.spells_id[currently_selected_option])
			yield(self, "signal_completed_magic_level_selection_action")
			
			# todo if cancelled
			is_battle_magic_menu_active = true
			is_select_magic_level_active = false
			
			#if currently_selected_option == e_menu_options.STAY_OPTION:
			#	print("Currently Active Character Node - ", Singleton_Game_GlobalBattleVariables.currently_active_character)
			#	Singleton_Game_GlobalBattleVariables.currently_active_character.s_complete_turn()
				
			#	# emit_signal("signal_completed_turn")
			#	is_battle_inventory_menu_active = false
			#	get_parent().get_parent().s_hide_action_menu()
			#	return
				
			
		if event.is_action_pressed("ui_down"):
			if 3 <= character_spells.size() - 1:
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
				currently_selected_option = e_magic_menu_options.DOWN_OPTION
				redSelection.position = rs_bottom_pos
				spell_name_label.text = character_spells[3].item_name
				spell_idx = 3
				# TODO: Create Func to show Magic Levels, and hide the extra magic level nodes
		elif event.is_action_pressed("ui_up"):
			if 0 <= character_spells.size() - 1:
				if currently_selected_option != e_magic_menu_options.UP_OPTION:
					Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
				currently_selected_option = e_magic_menu_options.UP_OPTION
				redSelection.position = rs_top_pos
				spell_idx = 0
		elif event.is_action_pressed("ui_right"):
			if 2 <= character_spells.size() - 1:
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
				currently_selected_option = e_magic_menu_options.RIGHT_OPTION
				redSelection.position = rs_right_pos
				spell_idx = 2
		elif event.is_action_pressed("ui_left"):
			if 1 <= character_spells.size() - 1:
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
				currently_selected_option = e_magic_menu_options.LEFT_OPTION
				redSelection.position = rs_left_pos
				spell_idx = 1
	
	if is_select_magic_level_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Magic Level Selection")
			is_battle_magic_menu_active = true
			is_select_magic_level_active = false
			magicLevelSelectorWrapper.hide()
			return
			
		if event.is_action_released("ui_a_key"): #event.is_action_released("ui_accept"):
			print("Selected Magic Level - ", currently_selected_option)
			
			yield(get_tree().create_timer(0.001), "timeout")

			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			is_battle_magic_menu_active = false
			is_select_magic_level_active = false
			
			print("TODO: Logic for target selection everything below basically")
			# return
			
			get_parent().get_parent().get_parent().s_hide_battle_magic_menu()
			
			# var equip_arg = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").inventory_items_id[0]
			# Singleton_Game_GlobalBattleVariables.target_selection_node.setup_use_range_and_target_range_selection(equip_arg)
				
			
			var actor = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
			
			# setup_use_range_and_target_range_selection(actor.spells_id[currently_selected_option]) # [spell_idx]
			
			Singleton_Game_GlobalBattleVariables.target_selection_node.setup_magic_use_range_and_target_range_selection(actor.spells_id[currently_selected_option])
			
			yield(self, "signal_completed_magic_level_selection_action")
			
			# todo if cancelled
			is_battle_magic_menu_active = true
			is_select_magic_level_active = false

func select_magic_level(spell_arg):
	pass

# Select Target logic below TODO: setup func and split it in the input func above
# if accept
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
#			#	is_battle_inventory_menu_active = false
#			#	get_parent().get_parent().s_hide_action_menu()
#			#	return
#
#
#
#
#	if is_target_selection_active:
#		if event.is_action_released("ui_b_key"):
#			emit_signal("signal_completed_item_use_action")
#			Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro()
#			Singleton_Game_GlobalBattleVariables.field_logic_node.show_movement_tiles()
#			Singleton_Game_GlobalBattleVariables.field_logic_node.hide_use_target_tiles()
#			target_range.cleanup_cursor()
#
#		if event.is_action_released("ui_a_key"):
#			print("TODO: trigger battle action scene and play out the item use effect")
#			Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro()
#
#		if event.is_action_pressed("ui_down"):
#			var pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
#			var vpos = Vector2(pos.x, pos.y + 24)
#			var n = get_character_at_tile_position(vpos)
#			if n != null:
#				print("New Target Selection")
#				Singleton_Game_GlobalBattleVariables.currently_selected_actor = n
#				Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro()
#				target_range.draw_cursor_at_position(vpos)
#
#			# is_target_selection_active = false
#			# emit_signal("signal_completed_item_use_action")
#		elif event.is_action_pressed("ui_up"):
#			var pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
#			get_character_at_tile_position(Vector2(pos.x, pos.y - 24))
#
#			# is_target_selection_active = false
#			# emit_signal("signal_completed_item_use_action")
#		elif event.is_action_pressed("ui_right"):
#			var pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
#			var vpos = Vector2(pos.x + 24, pos.y)
#			var n = get_character_at_tile_position(vpos)
#			if n != null:
#				print("New Target Selection")
#				Singleton_Game_GlobalBattleVariables.currently_selected_actor = n
#				Singleton_Game_GlobalBattleVariables.battle_base.s_show_target_actor_micro()
#				target_range.draw_cursor_at_position(vpos)
#
#			# is_target_selection_active = false
#			# emit_signal("signal_completed_item_use_action")
#		elif event.is_action_pressed("ui_left"):
#			var pos = Singleton_Game_GlobalBattleVariables.currently_active_character.position
#			get_character_at_tile_position(Vector2(pos.x - 24, pos.y))
#
#			# is_target_selection_active = false
#			# emit_signal("signal_completed_item_use_action")


# TODO: convert this to use spells instead of items
func setup_use_range_and_target_range_selection(item_arg) -> void:
	print(item_arg)
	print(item_arg.spell_use_range_path)
	var item_use_range = load(item_arg.spell_use_range_path).new()
	print(item_use_range)
	item_use_range._ready()
	# TODO create cleanup function to remove the attack grid when canclled or completed
	item_use_range.draw_use_range()
	target_range = load(item_arg.spell_use_target_path).new()
	# TODO create cleanup function for this to remove the curosr
	target_range.draw_cursor_and_get_targets("test arg 123")
	
	print(item_arg.usable_on_actor_type)
	if item_arg.usable_on_actor_type == 2:
		print("Self and Characters")
		print(Singleton_Game_GlobalBattleVariables.character_wrapper_node)
		
		print(Singleton_Game_GlobalBattleVariables.currently_active_character)
		print(Singleton_Game_GlobalBattleVariables.currently_active_character.position)
		
		print(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
		
		target_node_children = Singleton_Game_GlobalBattleVariables.character_wrapper_node.get_children()
		for child in target_node_children:
			print(child)
			print(child.position)
	elif item_arg.usable_on_actor_type == 1:
		print("Enemies")
		print(Singleton_Game_GlobalBattleVariables.character_wrapper_node)
		
		print(Singleton_Game_GlobalBattleVariables.currently_active_character)
		print(Singleton_Game_GlobalBattleVariables.currently_active_character.position)
		
		print(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
		
		target_node_children = Singleton_Game_GlobalBattleVariables.enemies_wrapper_node.get_children()
		for child in target_node_children:
			print(child)
			print(child.position)
	#emit_signal("signal_completed_item_use_action")
	# return

func get_character_at_tile_position(pos_arg):
	for child in target_node_children:
		# print(child)
		# print(child.position, pos_arg)
		if child.position == pos_arg:
			# print("Found - ", child)
			print(child.name)
			return child
			
	return null
