extends Node2D

# TODO: both of these signals are used (temp) suppressing the warnings
# when godot4 launches refactor and clean this so the suppression is no longer needed
# warning-ignore:unused_signal
signal signal_completed_magic_level_selection_action
# warning-ignore:unused_signal
signal signal_completed_selected_target_action

@onready var spell_block_scene = preload("res://General/ControlsOverworld/MagicMenu/SpellLevelBlock.tscn")

@onready var redSelection = $RedSelectionBorderRoot

@onready var spell_wrapper = $NinePatchRect/SpellLevelWrapper
@onready var spell_level_1 = $NinePatchRect/SpellLevelWrapper/HBoxContainer/SpellLevelBlock
@onready var spell_level_2 = $NinePatchRect/SpellLevelWrapper/HBoxContainer/SpellLevelBlock2
@onready var spell_level_3 = $NinePatchRect/SpellLevelWrapper/HBoxContainer/SpellLevelBlock3
@onready var spell_level_4 = $NinePatchRect/SpellLevelWrapper/HBoxContainer/SpellLevelBlock4

const rs_top_pos    = Vector2(16, 0)
const rs_left_pos   = Vector2(0, 12)
const rs_right_pos  = Vector2(32, 12)
const rs_bottom_pos = Vector2(16, 24)

var spell_level_selected: int = 0
var is_battle_magic_menu_active: bool = false
var current_spell_res

enum e_magic_menu_options {
	UP_OPTION,
	LEFT_OPTION,
	RIGHT_OPTION,
	DOWN_OPTION
}
var currently_selected_option: int = e_magic_menu_options.UP_OPTION

# onready var animationPlayer = $AnimationPlayer
@onready var spell_name_label = $NinePatchRect/SpellNameLabel
@onready var spell_cost_label = $NinePatchRect/MpCostLabel

@onready var spell_up_slot_spirte = $SpellSlotUpSprite
@onready var spell_down_slot_spirte = $SpellSlotDownSprite
@onready var spell_left_slot_spirte = $SpellSlotLeftSprite
@onready var spell_right_slot_spirte = $SpellSlotRightSprite

var character_spells

@onready var magicLevelSelectorWrapper = $NinePatchRect/MagicLevelSelectorWrapperNode2D

var is_select_magic_level_active: bool = false

var is_target_selection_active: bool = false
var target_node_children

@onready var noValidOptionNode = get_parent().get_node("NoValidOptionWarningBoxRoot")

var spell_idx: int = 0
# var spell_level_idx

func _ready():
	Singleton_CommonVariables.ui__magic_menu = self
	redSelection.position = rs_top_pos
	magicLevelSelectorWrapper.hide()


func show_cust() -> void:
	show()
	set_battle_magic_menu_active()


func set_battle_magic_menu_active() -> void:
	is_battle_magic_menu_active = true
	
	if Singleton_CommonVariables.is_currently_in_battle_scene:
		print("Magic Menu Current Char", Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot"))
		print("Magic Menu Spells", Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot").get_magic())
		character_spells = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot").get_magic()
	else:
		print("Magic Menu Current Char", Singleton_CommonVariables.main_character_player_node.actor)
		print("Magic Menu Spells", Singleton_CommonVariables.main_character_player_node.actor.magic_array)
		character_spells = Singleton_CommonVariables.main_character_player_node.actor.magic_array
	
	for idx in (character_spells.size()):
		# print("Spell - ", spell)
		var spell_res = load(character_spells[idx].resource)
		if idx == 0:
			spell_up_slot_spirte.texture = spell_res.spell_texture
			spell_name_label.text = spell_res.name
			spell_cost_label.text = str(spell_res.levels[0].mp_usage_cost)
		elif idx == 1:
			spell_left_slot_spirte.texture = spell_res.spell_texture
		elif idx == 2:
			spell_right_slot_spirte.texture = spell_res.spell_texture
		elif idx == 3:
			spell_down_slot_spirte.texture = spell_res.spell_texture


func _input(event):
	if is_battle_magic_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Magic Inventory Menu")
			is_battle_magic_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			# Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").active = true
			# get_parent().get_parent().get_parent().s_hide_battle_inventory_menu()
			
			Singleton_CommonVariables.ui__magic_menu.hide()
			
			if Singleton_CommonVariables.is_currently_in_battle_scene:
				Singleton_CommonVariables.ui__battle_action_menu.show()
			else: 
				Singleton_CommonVariables.ui__overworld_action_menu.show()
				
			# get_parent().get_parent().get_parent().s_show_battle_action_menu("right")
			
			# TODO: HACK: FIXME: Dirty hack need a better way to gurantee when action is completed to prevent retrigger
			# yield on signal seems busted sometimes gets double called or falls through?
			await Signal(get_tree().create_timer(0.1), "timeout")
			
			if Singleton_CommonVariables.is_currently_in_battle_scene:
				Singleton_CommonVariables.ui__battle_action_menu.set_menu_active()
			else: 
				Singleton_CommonVariables.ui__overworld_action_menu.set_menu_active()
			
			return
			
		if event.is_action_released("ui_a_key"): # event.is_action_released("ui_accept"):
			print("Accept Action - ", currently_selected_option)
			
			await Signal(get_tree().create_timer(0.001), "timeout")
			
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			# Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			is_battle_magic_menu_active = false
			
			var actor
			if Singleton_CommonVariables.is_currently_in_battle_scene:
				actor = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot")
			else:
				actor = Singleton_CommonVariables.main_character_player_node.actor
			
			magicLevelSelectorWrapper.show()
			
			print(actor.get_magic_array())
			display_magic_from_magic_array(actor.get_magic_array())
			
			# await Signal(get_tree().create_timer(0.1), "timeout")
			spell_level_selected = 0
			is_select_magic_level_active = true
			return
			
			# select_magic_level(actor.get_magic_array()[currently_selected_option])
			# await Signal(self, "signal_completed_magic_level_selection_action")
			# Singleton_Game_GlobalBattleVariables.currently_active_character.s_complete_turn()
		if event.is_action_pressed("ui_down"):
			select_spell(3, rs_bottom_pos, e_magic_menu_options.DOWN_OPTION)
		elif event.is_action_pressed("ui_up"):
			select_spell(0, rs_top_pos, e_magic_menu_options.UP_OPTION)
		elif event.is_action_pressed("ui_right"):
			select_spell(2, rs_right_pos, e_magic_menu_options.RIGHT_OPTION)
		elif event.is_action_pressed("ui_left"):
			select_spell(1, rs_left_pos, e_magic_menu_options.LEFT_OPTION)
	
	if is_select_magic_level_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Magic Level Selection")
			is_battle_magic_menu_active = true
			is_select_magic_level_active = false
			magicLevelSelectorWrapper.hide()
			return
			
		if event.is_action_released("ui_a_key"): #event.is_action_released("ui_accept"):
			print("Selected Magic Level - ", currently_selected_option)
			
			await Signal(get_tree().create_timer(0.001), "timeout")
			
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			var actor
			if Singleton_CommonVariables.is_currently_in_battle_scene:
				if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1: # Character
					actor = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot")
			else: 
				# actor = Singleton_CommonVariables.sf_game_data_node.ForceMembers[0] # main_character_player_node.actor # Singleton_CommonVariables.main_character_player_node.actor
				actor = Singleton_CommonVariables.main_character_player_node.actor
				# actor.MP_Current = actor.MP_Total
				actor.set_mp_current(actor.MP_Total)
			
			print(actor.get_mp_current(), " ", actor.get_magic_array(), " ",  spell_idx, " ",  spell_level_selected)
			var spell_res_l = load(actor.get_magic_array()[spell_idx].resource)
			
			if actor.get_mp_current() < spell_res_l.levels[spell_level_selected].mp_usage_cost:
				print("No Use")
				# TODO: play error sound and return
				
#				noValidOptionNode.set_no_cant_use_text()
#				noValidOptionNode.position = Vector2(165, 100)
#				noValidOptionNode.start_self_clear_timer()
#				noValidOptionNode.re_show_action_menu = false
				# return
			
#			print(actor.magic_array[currently_selected_option].name)
#			if actor.magic_array[currently_selected_option].name == "Egress":
#				print("Egress selected")
#				return
				
			# if actor.spells_id[currently_selected_option].name == "Heal":
				# Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro_in_battle()
				# return
			
			is_battle_magic_menu_active = false
			is_select_magic_level_active = false
			
			print("TODO: Logic for target selection everything below basically")
			
			Singleton_CommonVariables.ui__magic_menu.hide()
			
			Singleton_CommonVariables.battle__logic__target_selection_node.set_magic_target_selection(spell_res_l.levels[spell_level_selected])
			
			return
		if event.is_action_pressed("ui_right"):
			if spell_level_selected < 4:
				spell_level_selected += 1
				display_spell_level_selection(spell_level_selected)
		elif event.is_action_pressed("ui_left"):
			if spell_level_selected > 0:
				spell_level_selected -= 1
				display_spell_level_selection(spell_level_selected)


func select_spell(spell_select_idx, rs_pos, magic_menu_option) -> void:
	if spell_select_idx <= character_spells.size() - 1:
		Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
		currently_selected_option = magic_menu_option
		redSelection.position = rs_pos
		spell_name_label.text = character_spells[spell_select_idx].name
		spell_idx = spell_select_idx


# TODO: Create Func to show Magic Levels, and hide the extra magic level nodes
func select_magic_level(_spell_arg):
	pass


func display_magic_from_magic_array(magic_arr) -> void:
	for spell_idx_local in magic_arr.size():
		var spell_resource = load(magic_arr[spell_idx_local].resource)
		print(spell_resource)
		
		match spell_idx_local:
			0:
				current_spell_res = spell_resource
				spell_up_slot_spirte.texture = spell_resource.spell_texture
				spell_name_label.text = spell_resource.name
				spell_cost_label.text = str(spell_resource.levels[0].mp_usage_cost)
				display_spell_levels(spell_resource.levels, magic_arr[spell_idx_local])
			1:
				spell_left_slot_spirte.texture = spell_resource.spell_texture
			2:
				spell_right_slot_spirte.texture = spell_resource.spell_texture
			3:
				spell_down_slot_spirte.texture = spell_resource.spell_texture

func display_spell_levels(spell_levels, magic_char_levels) -> void:
	spell_level_1.hide()
	spell_level_2.hide()
	spell_level_3.hide()
	spell_level_4.hide()
	
	print(spell_levels, magic_char_levels)
	
	for idx in magic_char_levels.levels.size():
		print("LEVEL -- ", magic_char_levels.levels[idx])
		
		match idx:
			0: 
				if magic_char_levels.levels[idx].unlocked:
					spell_level_1.show()
				spell_level_1.set_spell_blcok_state(true)
			1: 
				if magic_char_levels.levels[idx].unlocked:
					spell_level_2.show()
				spell_level_2.set_spell_blcok_state(false)
			2: 
				if magic_char_levels.levels[idx].unlocked:
					spell_level_3.show()
				spell_level_3.set_spell_blcok_state(false)
			3: 
				if magic_char_levels.levels[idx].unlocked:
					spell_level_4.show()
				spell_level_4.set_spell_blcok_state(false)


func display_spell_level_selection(spell_level_selected_arg: int) -> void:
	spell_cost_label.text = str(current_spell_res.levels[spell_level_selected_arg].mp_usage_cost)
	
	if spell_level_selected_arg == 0:
		spell_level_1.set_spell_blcok_state(true)
		spell_level_2.set_spell_blcok_state(false)
		spell_level_3.set_spell_blcok_state(false)
		spell_level_4.set_spell_blcok_state(false)
	elif spell_level_selected_arg == 1:
		spell_level_1.set_spell_blcok_state(true)
		spell_level_2.set_spell_blcok_state(true)
		spell_level_3.set_spell_blcok_state(false)
		spell_level_4.set_spell_blcok_state(false)
	elif spell_level_selected_arg == 2:
		spell_level_1.set_spell_blcok_state(true)
		spell_level_2.set_spell_blcok_state(true)
		spell_level_3.set_spell_blcok_state(true)
		spell_level_4.set_spell_blcok_state(false)
	elif spell_level_selected_arg == 3:
		spell_level_1.set_spell_blcok_state(true)
		spell_level_2.set_spell_blcok_state(true)
		spell_level_3.set_spell_blcok_state(true)
		spell_level_4.set_spell_blcok_state(true)
