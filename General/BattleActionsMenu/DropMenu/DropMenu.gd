extends Node2D

var is_battle_drop_menu_active: bool = false

enum e_drop_menu_options {
	UP_OPTION,
	LEFT_OPTION,
	RIGHT_OPTION,
	DOWN_OPTION
}
var currently_selected_option: int = e_drop_menu_options.UP_OPTION

# onready var animationPlayer = $AnimationPlayer

onready var up_slot_spirte = $SlotUpSprite
onready var down_slot_spirte = $SlotDownSprite
onready var left_slot_spirte = $SlotLeftSprite
onready var right_slot_spirte = $SlotRightSprite

onready var item_info__type_name_label = $ItemInfoNinePatchRect/TypeNameLabel
onready var item__info__weapon_name_label = $ItemInfoNinePatchRect/WeaponNameLabel

func _ready():
	set_sprites_to_zero_frame()
	# $AnimationPlayer.playback_speed = 2
	# animationPlayer.play("UseMenuOption")
	# label.text = "Use"
	pass

func set_battle_drop_menu_active():
	is_battle_drop_menu_active = true
	
	var active_char_root = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	
	print("Equip Menu Current Char", active_char_root)
	print("Equip Menu ", active_char_root.inventory_items_id)
	
	## TODO: FIXME: temp setting inventroy to equipped idea while migrating to new structure and github
	
	var inventory_items = active_char_root.inventory_items_id # active_char_root.is_item_equipped
	
	if inventory_items.size() == 0:
		print("No inventory items probably should print the no items skip actions imilar to magic")
		# return
	
	for i in range(inventory_items.size()):
		print(inventory_items[i])
		if i == 0:
			up_slot_spirte.texture = inventory_items[i].texture
		if i == 1:
			left_slot_spirte.texture = inventory_items[i].texture
		if i == 2:
			right_slot_spirte.texture = inventory_items[i].texture
		if i == 3:
			down_slot_spirte.texture = inventory_items[i].texture
		# up_slot_spirte.texture = item.texture
		# item__info__weapon_name_label.text = item.item_name
	

func _input(event):
	if is_battle_drop_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Use Inventory Menu")
			is_battle_drop_menu_active = false
			# Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").active = true
			# get_parent().get_parent().get_parent().s_hide_battle_inventory_menu()
			get_parent().get_parent().get_parent().s_hide_battle_drop_menu()
			
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
			currently_selected_option = e_drop_menu_options.DOWN_OPTION
			# animationPlayer.play("DropMenuOption")
			# label.text = "Drop"
		elif event.is_action_pressed("ui_up"):
			print("Up need to check if weapon is there or no")
			set_sprites_to_zero_frame()
			currently_selected_option = e_drop_menu_options.UP_OPTION
			# animationPlayer.play("UseMenuOption")
			#label.text = "Use"
		elif event.is_action_pressed("ui_right"):
			print("Right need to check if weapon is there or no")
			set_sprites_to_zero_frame()
			currently_selected_option = e_drop_menu_options.RIGHT_OPTION
			# animationPlayer.play("EquipMenuOption")
			#label.text = "Equip"
		elif event.is_action_pressed("ui_left"):
			print("Left need to check if weapon is there or no")
			set_sprites_to_zero_frame()
			currently_selected_option = e_drop_menu_options.LEFT_OPTION
			# animationPlayer.play("GiveMenuOption")
			#label.text = "Give"
			
func set_sprites_to_zero_frame():
	up_slot_spirte.frame = 0
	down_slot_spirte.frame = 0
	left_slot_spirte.frame = 0
	right_slot_spirte.frame = 0
