extends Node2D

onready var redSelection = $RedSelectionBorderRoot

const rs_top_pos    = Vector2(16, 0)
const rs_left_pos   = Vector2(0, 12)
const rs_right_pos  = Vector2(32, 12)
const rs_bottom_pos = Vector2(16, 24)

var is_battle_drop_menu_active: bool = false

enum e_drop_menu_options {
	UP_OPTION    = 0,
	LEFT_OPTION  = 1,
	RIGHT_OPTION = 2,
	DOWN_OPTION  = 3
}
var currently_selected_option: int = e_drop_menu_options.UP_OPTION

onready var typeLabel = $ItemInfoNinePatchRect/TypeNameLabel
onready var nameLabel = $ItemInfoNinePatchRect/WeaponNameLabel

# onready var animationPlayer = $AnimationPlayer

onready var up_slot_spirte = $SlotUpSprite
onready var down_slot_spirte = $SlotDownSprite
onready var left_slot_spirte = $SlotLeftSprite
onready var right_slot_spirte = $SlotRightSprite

onready var item_info__type_name_label = $ItemInfoNinePatchRect/TypeNameLabel
onready var item__info__weapon_name_label = $ItemInfoNinePatchRect/WeaponNameLabel

var inventory_items

func _ready():
	set_sprites_to_zero_frame()
	redSelection.position = rs_top_pos
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
			
			var actor = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
			
			actor.inventory_items_id.remove(currently_selected_option)
			actor.is_item_equipped.remove(currently_selected_option)
			
			if currently_selected_option == 1:
				left_slot_spirte.texture = load("res://Assets/SFCD/Items/EmptyItemSlot.png")
			elif currently_selected_option == 2:
				right_slot_spirte.texture = load("res://Assets/SFCD/Items/EmptyItemSlot.png")
			elif currently_selected_option == 3:
				down_slot_spirte.texture = load("res://Assets/SFCD/Items/EmptyItemSlot.png")
				
			redSelection.position = rs_top_pos
			set_sprites_to_zero_frame()
			currently_selected_option = e_drop_menu_options.UP_OPTION
			
			if 0 <= inventory_items.size() - 1:
				up_slot_spirte.texture = actor.inventory_items_id[0].texture
				nameLabel.text = actor.inventory_items_id[0].item_name
				typeLabel.text = actor.inventory_items_id[0].get_item_type()
			else:
				up_slot_spirte.texture = load("res://Assets/SFCD/Items/EmptyItemSlot.png")
				nameLabel.text = "Empty"
				typeLabel.text = ""
				
				#	get_parent().get_parent().s_hide_action_menu()
				#	return
				
			
		if event.is_action_pressed("ui_down"):
			if 3 <= inventory_items.size() - 1:
				redSelection.position = rs_bottom_pos
				set_sprites_to_zero_frame()
				currently_selected_option = e_drop_menu_options.DOWN_OPTION
				nameLabel.text = inventory_items[3].item_name
				typeLabel.text = inventory_items[3].get_item_type()
		elif event.is_action_pressed("ui_up"):
			if 0 <= inventory_items.size() - 1:
				redSelection.position = rs_top_pos
				set_sprites_to_zero_frame()
				currently_selected_option = e_drop_menu_options.UP_OPTION
				nameLabel.text = inventory_items[0].item_name
				typeLabel.text = inventory_items[0].get_item_type()
		elif event.is_action_pressed("ui_right"):
			if 2 <= inventory_items.size() - 1:
				redSelection.position = rs_right_pos
				set_sprites_to_zero_frame()
				currently_selected_option = e_drop_menu_options.RIGHT_OPTION
				nameLabel.text = inventory_items[2].item_name
				typeLabel.text = inventory_items[2].get_item_type()
		elif event.is_action_pressed("ui_left"):
			if 1 <= inventory_items.size() - 1:
				redSelection.position = rs_left_pos
				set_sprites_to_zero_frame()
				currently_selected_option = e_drop_menu_options.LEFT_OPTION
				nameLabel.text = inventory_items[1].item_name
				typeLabel.text = inventory_items[1].get_item_type()

func set_sprites_to_zero_frame():
	up_slot_spirte.frame = 0
	down_slot_spirte.frame = 0
	left_slot_spirte.frame = 0
	right_slot_spirte.frame = 0