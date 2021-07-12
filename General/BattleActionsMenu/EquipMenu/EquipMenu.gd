extends Node2D

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

onready var item_info__type_name_label = $ItemInfoNinePatchRect/TypeNameLabel
onready var item__info__weapon_name_label = $ItemInfoNinePatchRect/WeaponNameLabel

onready var stat_attack_label = $StatNinePatchRect/StatVBoxContainer/AttackStatLabel
onready var stat_defense_label = $StatNinePatchRect/StatVBoxContainer/DefenseStatLabel
onready var stat_move_label = $StatNinePatchRect/StatVBoxContainer/MoveStatLabel
onready var stat_agility_label = $StatNinePatchRect/StatVBoxContainer/AgilityStatLabel

func _ready():
	set_sprites_to_zero_frame()
	# $AnimationPlayer.playback_speed = 2
	# animationPlayer.play("UseMenuOption")
	# label.text = "Use"
	pass

func set_battle_equip_menu_active():
	is_battle_equip_menu_active = true
	
	var active_char_root = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	
	print("Equip Menu Current Char", active_char_root)
	print("Equip Menu ", active_char_root.inventory_items_id)
	
	## TODO: FIXME: temp setting inventroy to equipped idea while migrating to new structure and github
	
	var character_equips = active_char_root.inventory_items_id # active_char_root.is_item_equipped
	
	if character_equips.size() == 0:
		print("No equips default to down unequip option")
		# return
	
	stat_attack_label.text = str(active_char_root.attack)
	stat_defense_label.text = str(active_char_root.defense)
	stat_move_label.text = str(active_char_root.move)
	stat_agility_label.text = str(active_char_root.agility)
	
	for item in character_equips:
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
			item_info__type_name_label.text = "WEAPON"
			item__info__weapon_name_label.text = item.item_name
			#spell_up_slot_spirte.texture = spell.spell_texture
			#spell_name_label.text = spell.name
			#spell_cost_label.text = str(spell.mp_usage_cost)
	

func _input(event):
	if is_battle_equip_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Equip Inventory Menu")
			is_battle_equip_menu_active = false
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
			print("Unequip")
			set_sprites_to_zero_frame()
			currently_selected_option = e_equip_menu_options.DOWN_OPTION
			# animationPlayer.play("DropMenuOption")
			# label.text = "Drop"
		elif event.is_action_pressed("ui_up"):
			print("Up need to check if weapon is there or no")
			set_sprites_to_zero_frame()
			currently_selected_option = e_equip_menu_options.UP_OPTION
			# animationPlayer.play("UseMenuOption")
			#label.text = "Use"
		elif event.is_action_pressed("ui_right"):
			print("Right need to check if weapon is there or no")
			set_sprites_to_zero_frame()
			currently_selected_option = e_equip_menu_options.RIGHT_OPTION
			# animationPlayer.play("EquipMenuOption")
			#label.text = "Equip"
		elif event.is_action_pressed("ui_left"):
			print("Left need to check if weapon is there or no")
			set_sprites_to_zero_frame()
			currently_selected_option = e_equip_menu_options.LEFT_OPTION
			# animationPlayer.play("GiveMenuOption")
			#label.text = "Give"
			
func set_sprites_to_zero_frame():
	equip_up_slot_spirte.frame = 0
	unequip_down_slot_spirte.frame = 0
	equip_left_slot_spirte.frame = 0
	equip_right_slot_spirte.frame = 0
