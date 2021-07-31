extends Node2D

onready var redSelection = $RedSelectionBorderRoot

const rs_top_pos    = Vector2(16, 0)
const rs_left_pos   = Vector2(0, 12)
const rs_right_pos  = Vector2(32, 12)
const rs_bottom_pos = Vector2(16, 24)

var is_battle_equip_menu_active: bool = false

enum e_equip_menu_options {
	UP_OPTION,
	LEFT_OPTION,
	RIGHT_OPTION,
	DOWN_OPTION
}
var currently_selected_option: int = e_equip_menu_options.UP_OPTION

# onready var animationPlayer = $AnimationPlayer

onready var equip_up_slot_spirte = $EquipSlotUpSprite
onready var unequip_down_slot_spirte = $UnequipSlotDownSprite
onready var equip_left_slot_spirte = $EquipSlotLeftSprite
onready var equip_right_slot_spirte = $EquipSlotRightSprite

onready var typeLabel = $ItemInfoNinePatchRect/TypeNameLabel
onready var nameLabel = $ItemInfoNinePatchRect/WeaponNameLabel
onready var equipLabel = $ItemInfoNinePatchRect/EquippedLabel

onready var stat_attack_label = $StatNinePatchRect/StatVBoxContainer/AttackStatLabel
onready var stat_defense_label = $StatNinePatchRect/StatVBoxContainer/DefenseStatLabel
onready var stat_move_label = $StatNinePatchRect/StatVBoxContainer/MoveStatLabel
onready var stat_agility_label = $StatNinePatchRect/StatVBoxContainer/AgilityStatLabel

var inventory_items
var active_char_root

var item_select_idx: int

func _ready():
	set_sprites_to_zero_frame()
	redSelection.position = rs_top_pos
	# $AnimationPlayer.playback_speed = 2
	# animationPlayer.play("UseMenuOption")
	# label.text = "Use"
	pass


func set_battle_equip_menu_active():
	is_battle_equip_menu_active = true
	
	active_char_root = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	
	print("Equip Menu Current Char", active_char_root)
	print("Equip Menu ", active_char_root.inventory_items_id)
	
	## TODO: FIXME: temp setting inventroy to equipped idea while migrating to new structure and github
	
	inventory_items = active_char_root.inventory_items_id # active_char_root.is_item_equipped
	
	if inventory_items.size() == 0:
		print("No equips default to down unequip option")
		# return
	
	# TODO: get back a stats object with all the stats pre calcuated with the attribute bonuses
	# leave direct vars to get base stats as well, naive logic for attack alone for demo
	stat_attack_label.text = str(active_char_root.get_attack()) # str(active_char_root.attack)
	stat_defense_label.text = str(active_char_root.defense)
	stat_move_label.text = str(active_char_root.move)
	stat_agility_label.text = str(active_char_root.agility)
	
	for item in inventory_items:
		if item is CN_SF1_Item_Weapon:
			print("Valid Weapon")
			print(item)
			#print(spell.name)
			#print(spell.mp_usage_cost)
			#print(spell.level)
			#print(spell.element_type)
			#print(spell.spell_range)
			#print(spell.spell_target_range)
			#print(spell.spell_texture)
			equip_up_slot_spirte.texture = item.texture
			typeLabel.text = "WEAPON"
			nameLabel.text = item.item_name
			#spell_up_slot_spirte.texture = spell.spell_texture
			#spell_name_label.text = spell.name
			#spell_cost_label.text = str(spell.mp_usage_cost)
	

func _input(event):
	if is_battle_equip_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Equip Inventory Menu")
			is_battle_equip_menu_active = false
			
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			# Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").active = true
			# get_parent().get_parent().get_parent().s_hide_battle_inventory_menu()
			get_parent().get_parent().get_parent().s_hide_battle_equip_menu()
			
			
			# TODO: HACK: FIXME: Dirty hack need a better way to gurantee when action is completed to prevent retrigger
			# yield on signal seems busted sometimes gets double called or falls through?
			yield(get_tree().create_timer(0.1), "timeout")
			get_parent().get_parent().get_parent().s_show_battle_inventory_menu("right")
			# get_parent().get_parent().get_parent().s_show_battle_inventory_menu()
			# get_parent().get_node("BattleInventoryMenuRoot").set_battle_inventory_menu_active()
			return
			
		if event.is_action_released("ui_a_key"): # event.is_action_released("ui_accept"):
			print("Accept Action - ", currently_selected_option)
			is_battle_equip_menu_active = false
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			update_weapon_equip()
			
			get_parent().get_parent().get_parent().s_hide_battle_equip_menu()
			
			yield(get_tree().create_timer(0.1), "timeout")
			get_parent().get_parent().get_parent().s_show_battle_inventory_menu("right")
			
			#if currently_selected_option == e_menu_options.STAY_OPTION:
			#	print("Currently Active Character Node - ", Singleton_Game_GlobalBattleVariables.currently_active_character)
			#	Singleton_Game_GlobalBattleVariables.currently_active_character.s_complete_turn()
				
			#	# emit_signal("signal_completed_turn")
			#	is_battle_inventory_menu_active = false
			#	get_parent().get_parent().s_hide_action_menu()
			#	return
				
		
		if event.is_action_pressed("ui_down"):
			print("Unequip")
			redSelection.position = rs_bottom_pos
			set_sprites_to_zero_frame()
			currently_selected_option = e_equip_menu_options.DOWN_OPTION
			nameLabel.text = "" # inventory_items[3].item_name
			typeLabel.text = "REMOVE" # inventory_items[3].get_item_type()
			update_attack_stat(null)
			item_select_idx = 3
			equipLabel.hide()
		elif event.is_action_pressed("ui_up"):
			if 0 <= inventory_items.size() - 1:
				if inventory_items[0] is CN_SF1_Item_Weapon:
					redSelection.position = rs_top_pos
					set_sprites_to_zero_frame()
					currently_selected_option = e_equip_menu_options.UP_OPTION
					nameLabel.text = inventory_items[0].item_name
					typeLabel.text = inventory_items[0].get_item_type()
					update_attack_stat(inventory_items[0])
					item_select_idx = 0
					equipLabel.hide()
					if active_char_root.is_item_equipped[0]:
						equipLabel.show()
		elif event.is_action_pressed("ui_right"):
			if 2 <= inventory_items.size() - 1:
				if inventory_items[2] is CN_SF1_Item_Weapon:
					redSelection.position = rs_right_pos
					set_sprites_to_zero_frame()
					currently_selected_option = e_equip_menu_options.RIGHT_OPTION
					nameLabel.text = inventory_items[2].item_name
					typeLabel.text = inventory_items[2].get_item_type()
					update_attack_stat(inventory_items[2])
					item_select_idx = 2
					equipLabel.hide()
					if active_char_root.is_item_equipped[2]:
						equipLabel.show()
		elif event.is_action_pressed("ui_left"):
			if 1 <= inventory_items.size() - 1:
				if inventory_items[1] is CN_SF1_Item_Weapon:
					redSelection.position = rs_left_pos
					set_sprites_to_zero_frame()
					currently_selected_option = e_equip_menu_options.LEFT_OPTION
					nameLabel.text = inventory_items[1].item_name
					typeLabel.text = inventory_items[1].get_item_type()
					update_attack_stat(inventory_items[1])
					item_select_idx = 1
					equipLabel.hide()
					if active_char_root.is_item_equipped[1]:
						equipLabel.show()
	

func update_weapon_equip() -> void:
	if item_select_idx == 3: # remove
		for i in (active_char_root.is_item_equipped.size()):
			if inventory_items[i] is CN_SF1_Item_Weapon:
				active_char_root.is_item_equipped[i] = false
	else:
		for i in (active_char_root.is_item_equipped.size()):
			if inventory_items[i] is CN_SF1_Item_Weapon:
				active_char_root.is_item_equipped[i] = true


func update_attack_stat(item_arg) -> void:
	var actor = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	if item_arg == null:
		stat_attack_label.text = str(actor.attack)
	else:
		stat_attack_label.text = str(actor.attack + item_arg.attribute_bonus[0])


func set_sprites_to_zero_frame() -> void:
	equip_up_slot_spirte.frame = 0
	unequip_down_slot_spirte.frame = 0
	equip_left_slot_spirte.frame = 0
	equip_right_slot_spirte.frame = 0
