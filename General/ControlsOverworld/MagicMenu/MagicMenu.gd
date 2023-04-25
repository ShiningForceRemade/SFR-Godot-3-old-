extends Node2D

# TODO: both of these signals are used (temp) suppressing the warnings
# when godot4 launches refactor and clean this so the suppression is no longer needed
# warning-ignore:unused_signal
signal signal_completed_magic_level_selection_action
# warning-ignore:unused_signal
signal signal_completed_selected_target_action

@onready var redSelection = $RedSelectionBorderRoot

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
		print("Magic Menu Spells", Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot").magic_array)
		character_spells = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot").magic_array
	else:
		print("Magic Menu Current Char", Singleton_CommonVariables.main_character_player_node.actor)
		print("Magic Menu Spells", Singleton_CommonVariables.main_character_player_node.actor.magic_array)
		character_spells = Singleton_CommonVariables.main_character_player_node.actor.magic_array
	
	for idx in (character_spells.size()):
		# print("Spell - ", spell)
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
			
			is_select_magic_level_active = true
			is_battle_magic_menu_active = false
			
			var actor
			if Singleton_CommonVariables.is_currently_in_battle_scene:
				actor = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot")
			else:
				actor = Singleton_CommonVariables.main_character_player_node.actor
			
			magicLevelSelectorWrapper.show()
			select_magic_level(actor.magic_array[currently_selected_option])
			await Signal(self, "signal_completed_magic_level_selection_action")
			
			# todo if cancelled
			is_battle_magic_menu_active = true
			is_select_magic_level_active = false
			
			#	Singleton_Game_GlobalBattleVariables.currently_active_character.s_complete_turn()
			
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
				actor = Singleton_BattleVariables.currently_active_character.get_node("CharacterRoot")
			else: 
				# actor = Singleton_CommonVariables.sf_game_data_node.ForceMembers[0] # main_character_player_node.actor # Singleton_CommonVariables.main_character_player_node.actor
				actor = Singleton_CommonVariables.main_character_player_node.actor
				actor.MP_Current = actor.MP_Total
			
			# print(actor.MP_Current, actor.magic_array[currently_selected_option].levels[0].mp_usage_cost)
			if actor.MP_Current < actor.magic_array[currently_selected_option].levels[0].mp_usage_cost:
				noValidOptionNode.set_no_cant_use_text()
				noValidOptionNode.position = Vector2(165, 100)
				noValidOptionNode.start_self_clear_timer()
				noValidOptionNode.re_show_action_menu = false
				return
			
			print(actor.magic_array[currently_selected_option].name)
			if actor.magic_array[currently_selected_option].name == "Egress":
				print("Egress selected")
				return
			# if actor.spells_id[currently_selected_option].name == "Heal":
				# Singleton_Game_GlobalBattleVariables.battle_base.s_hide_target_actor_micro_in_battle()
				# return
			
			is_battle_magic_menu_active = false
			is_select_magic_level_active = false
			
			print("TODO: Logic for target selection everything below basically")
			# return
			
			get_parent().get_parent().get_parent().s_hide_battle_magic_menu()
			
			Singleton_BattleVariables.target_selection_node.setup_magic_use_range_and_target_range_selection(actor.spells_id[currently_selected_option])
			
			await Signal(self, "signal_completed_magic_level_selection_action")
			
			# todo if cancelled
			is_battle_magic_menu_active = true
			is_select_magic_level_active = false


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
