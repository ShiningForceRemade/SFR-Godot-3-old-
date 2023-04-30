extends Node2D

@onready var redSelection = $RedSelectionBorderRoot

@onready var empty_slot_texture = preload("res://Assets/SFCD/Items/EmptyItemSlot.png")

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

@onready var typeLabel = $ItemInfoNinePatchRect/TypeNameLabel
@onready var nameLabel = $ItemInfoNinePatchRect/WeaponNameLabel

@onready var up_slot_spirte = $SlotUpSprite
@onready var down_slot_spirte = $SlotDownSprite
@onready var left_slot_spirte = $SlotLeftSprite
@onready var right_slot_spirte = $SlotRightSprite

var inventory_items


func _ready():
	Singleton_CommonVariables.ui__drop_menu = self
	set_sprites_to_zero_frame()
	redSelection.position = rs_top_pos


func set_battle_drop_menu_active():
	is_battle_drop_menu_active = true
	
	set_sprites_to_zero_frame()
	
	left_slot_spirte.texture = empty_slot_texture
	right_slot_spirte.texture = empty_slot_texture
	up_slot_spirte.texture = empty_slot_texture
	down_slot_spirte.texture = empty_slot_texture
	
	redSelection.position = rs_top_pos
	currently_selected_option = e_drop_menu_options.UP_OPTION
	
	var active_char_root
	
	# TODO: HIGH PRIORITY need to add helper to get the actor root and need to collapse the way inventory and magic are handled
	# so these separate paths aren't needed
	if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1: #char
		active_char_root = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot")
	elif Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2: #enemey
		active_char_root = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("EnemeyRoot")
	
	print("Equip Menu Current Char", active_char_root)
	print("Equip Menu ", active_char_root.get_inventory())
	
	inventory_items = active_char_root.get_inventory() 
	
	if inventory_items.size() == 0:
		print("No inventory items probably should print the no items skip actions imilar to magic")
		up_slot_spirte.texture = load("res://Assets/SFCD/Items/EmptyItemSlot.png")
		nameLabel.text = "Empty"
		typeLabel.text = ""
		return
	
	for i in range(inventory_items.size()):
		print(inventory_items[i])
		var item_res = load(inventory_items[i].resource)
		if i == 0:
			up_slot_spirte.texture = item_res.texture
			nameLabel.text = item_res.item_name
			typeLabel.text = item_res.get_item_type()
		elif i == 1:
			left_slot_spirte.texture = item_res.texture
		elif i == 2:
			right_slot_spirte.texture = item_res.texture
		elif i == 3:
			down_slot_spirte.texture = item_res.texture


func _input(event):
	if is_battle_drop_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Use Inventory Menu")
			is_battle_drop_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			hide()
			
			Singleton_CommonVariables.ui__battle_action_menu.show()
			
			await get_tree().create_timer(0.1).timeout
			
			if Singleton_CommonVariables.is_currently_in_battle_scene:
				Singleton_CommonVariables.ui__battle_action_menu.set_menu_active()
			else: 
				Singleton_CommonVariables.ui__overworld_action_menu.set_menu_active()
			
			return
		
		if event.is_action_released("ui_a_key"): # event.is_action_released("ui_accept"):
			print("Accept Action - ", currently_selected_option)
			
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			
			var actor
			if Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 1: #char
				actor = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("CharacterRoot")
			elif Singleton_CommonVariables.battle__currently_active_actor.get_child(0).actor_type == 2: #enemey
				actor = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).find_child("EnemeyRoot")
			
			actor.remove_inventory_item_at_idx(currently_selected_option)
			
			set_battle_drop_menu_active()
			
			return
		
		if event.is_action_pressed("ui_down"):
			select_item(3, rs_bottom_pos, e_drop_menu_options.DOWN_OPTION)
		elif event.is_action_pressed("ui_up"):
			select_item(0, rs_top_pos, e_drop_menu_options.UP_OPTION)
		elif event.is_action_pressed("ui_right"):
			select_item(2, rs_right_pos, e_drop_menu_options.RIGHT_OPTION)
		elif event.is_action_pressed("ui_left"):
			select_item(1, rs_left_pos, e_drop_menu_options.LEFT_OPTION)


func select_item(item_select_idx, rs_pos, drop_menu_option) -> void:
	if item_select_idx <= inventory_items.size() - 1:
		redSelection.position = rs_pos
		set_sprites_to_zero_frame()
		currently_selected_option = drop_menu_option
		var item_res = load(inventory_items[item_select_idx].resource)
		nameLabel.text = item_res.item_name
		typeLabel.text = item_res.get_item_type()


func set_sprites_to_zero_frame() -> void:
	up_slot_spirte.frame = 0
	down_slot_spirte.frame = 0
	left_slot_spirte.frame = 0
	right_slot_spirte.frame = 0
