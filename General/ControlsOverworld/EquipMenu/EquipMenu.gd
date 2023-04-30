extends Node2D

@onready var redSelection = $RedSelectionBorderRoot

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

@onready var equip_up_slot_spirte = $EquipSlotUpSprite
@onready var unequip_down_slot_spirte = $UnequipSlotDownSprite
@onready var equip_left_slot_spirte = $EquipSlotLeftSprite
@onready var equip_right_slot_spirte = $EquipSlotRightSprite

@onready var typeLabel = $ItemInfoNinePatchRect/TypeNameLabel
@onready var nameLabel = $ItemInfoNinePatchRect/WeaponNameLabel
@onready var equipLabel = $ItemInfoNinePatchRect/EquippedLabel

@onready var stat_attack_label = $StatNinePatchRect/StatVBoxContainer/AttackStatLabel
@onready var stat_defense_label = $StatNinePatchRect/StatVBoxContainer/DefenseStatLabel
@onready var stat_move_label = $StatNinePatchRect/StatVBoxContainer/MoveStatLabel
@onready var stat_agility_label = $StatNinePatchRect/StatVBoxContainer/AgilityStatLabel

var inventory_items
var active_char_root

var item_select_idx: int

func _ready():
	Singleton_CommonVariables.ui__equip_menu = self
	set_sprites_to_zero_frame()
	redSelection.position = rs_top_pos
	# animationPlayer.play("UseMenuOption")


func set_menu_active():
	is_battle_equip_menu_active = true
	
	redSelection.position = rs_top_pos
	set_sprites_to_zero_frame()
	currently_selected_option = e_equip_menu_options.UP_OPTION
	
	if Singleton_CommonVariables.is_currently_in_battle_scene:
		if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1: #char
			active_char_root = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot")
		elif Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2: #enemey
			active_char_root = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("EnemeyRoot")
	else:
		active_char_root = Singleton_CommonVariables.main_character_player_node.actor
	
	print("Equip Menu Current Char", active_char_root)
	print("Equip Menu ", active_char_root.get_inventory())
	
	inventory_items = active_char_root.get_inventory()
	
	if inventory_items.size() == 0:
		print("No equips default to down unequip option")
		return
	
	stat_attack_label.text = str(active_char_root.get_attack())
	stat_defense_label.text = str(active_char_root.get_defense())
	stat_move_label.text = str(active_char_root.get_movement())
	stat_agility_label.text = str(active_char_root.get_agility())
	
	for i in inventory_items.size():
		var item_res = load(inventory_items[i].resource)
		if item_res is CN_SF1_Item_Weapon:
			print("Valid Weapon")
			print(item_res)
			
			equip_up_slot_spirte.texture = item_res.texture
			typeLabel.text = "WEAPON"
			nameLabel.text = item_res.item_name


func _input(event):
	if is_battle_equip_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Equip Inventory Menu")
			is_battle_equip_menu_active = false
			
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			hide() # hide_cust TODO:
			
			Singleton_CommonVariables.ui__battle_action_menu.show()
			
			await get_tree().create_timer(0.1).timeout
			
			Singleton_CommonVariables.ui__battle_action_menu.set_menu_active()
			return
			
		if event.is_action_released("ui_a_key"): # event.is_action_released("ui_accept"):
			print("Accept Action - ", currently_selected_option)
			is_battle_equip_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			
			update_weapon_equip()
			
			Singleton_CommonVariables.ui__equip_menu.hide()
			
			await Signal(get_tree().create_timer(0.1), "timeout")
			
			Singleton_CommonVariables.ui__inventory_menu.show()
			Singleton_CommonVariables.ui__inventory_menu.set_menu_active()
			
			return
		
		
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
				var item_res = load(inventory_items[0].resource)
				if item_res is CN_SF1_Item_Weapon:
					redSelection.position = rs_top_pos
					set_sprites_to_zero_frame()
					currently_selected_option = e_equip_menu_options.UP_OPTION
					nameLabel.text = item_res.item_name
					typeLabel.text = item_res.get_item_type()
					update_attack_stat(item_res)
					item_select_idx = 0
					equipLabel.hide()
					if active_char_root.get_inventory()[0].is_equipped:
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
		for i in (active_char_root.get_inventory().size()):
			var item_res = load(active_char_root.get_inventory()[i].resource)
			if item_res is CN_SF1_Item_Weapon:
				active_char_root.set_equip_state_inventory_item_at_idx(i, false)
	else:
		for i in (active_char_root.get_inventory().size()):
			var item_res = load(active_char_root.get_inventory()[i].resource)
			if item_res is CN_SF1_Item_Weapon:
				active_char_root.set_equip_state_inventory_item_at_idx(i, true)
				return


func update_attack_stat(item_arg) -> void:	
	if item_arg == null:
		stat_attack_label.text = str(active_char_root.get_attack_base())
	else:
		stat_attack_label.text = str(active_char_root.get_attack_base() + item_arg.attribute_bonus[0])


func set_sprites_to_zero_frame() -> void:
	equip_up_slot_spirte.frame = 0
	unequip_down_slot_spirte.frame = 0
	equip_left_slot_spirte.frame = 0
	equip_right_slot_spirte.frame = 0
