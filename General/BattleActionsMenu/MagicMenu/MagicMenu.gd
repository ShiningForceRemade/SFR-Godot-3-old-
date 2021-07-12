extends Node2D

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

func _ready():
	set_sprites_to_zero_frame()
	# $AnimationPlayer.playback_speed = 2
	# animationPlayer.play("UseMenuOption")
	# label.text = "Use"
	pass

func set_battle_magic_menu_active():
	is_battle_magic_menu_active = true
	
	print("Magic Menu Current Char", Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot"))
	print("Magic Menu Spells", Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").spells_id)
	var character_spells = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").spells_id
	
	if character_spells.size() == 0:
		print("No Spells TODO NO MAGIC BOX and emit")
		return
	
	for spell in character_spells:
		if spell is CN_SF1_Spell:
			print("Valid Spell")
			print(spell)
			print(spell.name)
			#print(spell.mp_usage_cost)
			#print(spell.level)
			
			print(spell.levels)
			
			print(spell.element_type)
			#print(spell.spell_range)
			#print(spell.spell_target_range)
			print(spell.spell_texture)
			spell_up_slot_spirte.texture = spell.spell_texture
			spell_name_label.text = spell.name
			spell_cost_label.text = str(spell.levels[0].mp_usage_cost)
	

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
			
		if event.is_action_released("ui_accept"):
			print("Accept Action - ", currently_selected_option)
			#if currently_selected_option == e_menu_options.STAY_OPTION:
			#	print("Currently Active Character Node - ", Singleton_Game_GlobalBattleVariables.currently_active_character)
			#	Singleton_Game_GlobalBattleVariables.currently_active_character.s_complete_turn()
				
			#	# emit_signal("signal_completed_turn")
			#	is_battle_inventory_menu_active = false
			#	get_parent().get_parent().s_hide_action_menu()
			#	return
				
			
		if event.is_action_pressed("ui_down"):
			print("Drop")
			set_sprites_to_zero_frame()
			currently_selected_option = e_magic_menu_options.DOWN_OPTION
			# animationPlayer.play("DropMenuOption")
			# label.text = "Drop"
		elif event.is_action_pressed("ui_up"):
			print("Use")
			set_sprites_to_zero_frame()
			currently_selected_option = e_magic_menu_options.UP_OPTION
			# animationPlayer.play("UseMenuOption")
			#label.text = "Use"
		elif event.is_action_pressed("ui_right"):
			print("Equip")
			set_sprites_to_zero_frame()
			currently_selected_option = e_magic_menu_options.RIGHT_OPTION
			# animationPlayer.play("EquipMenuOption")
			#label.text = "Equip"
		elif event.is_action_pressed("ui_left"):
			print("Give")
			set_sprites_to_zero_frame()
			currently_selected_option = e_magic_menu_options.LEFT_OPTION
			# animationPlayer.play("GiveMenuOption")
			#label.text = "Give"
			
func set_sprites_to_zero_frame():
	spell_up_slot_spirte.frame = 0
	spell_down_slot_spirte.frame = 0
	spell_left_slot_spirte.frame = 0
	spell_right_slot_spirte.frame = 0
