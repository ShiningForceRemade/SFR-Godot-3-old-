# tool
# NOTE: tool is only enabled for testing
# don't leave it on or the console output will spam ui_{X}_key not defined when it actually is during 
# the game running

extends Node2D

@export var item_list: Array[Resource]

var is_menu_active: bool = false

var current_item_selected: int = 0

@onready var shop_item_scene = load("res://General/ControlsOverworld/ShopMenu/ItemSelectionMenu/ShopItem.tscn")

@onready var shop_items_container_node = $ShopItemsStatNinePatchRect/HBoxContainer

@onready var item_info_node = $ItemInfoStatNinePatchRect
@onready var item_info_item_name_node = $ItemInfoStatNinePatchRect/ItemNameLabel
@onready var item_info__gold_node = $ItemInfoStatNinePatchRect/GoldLabel

@onready var selection_node = $SelectionControl


func _ready():
	Singleton_CommonVariables.ui__shop_item_selection_menu = self
	
	load_shop_items()
	
	display_item_info(item_list[0])
	
	pass


func show_with_tween() -> void:
	show()
	set_menu_active()
	

func set_menu_active():
	is_menu_active = true
	display_item_info(item_list[0])
	current_item_selected = 0
	selection_node.position = Vector2(0, selection_node.position.y)
	move_info_box(current_item_selected, 21)


func _process(_delta):
	if !is_menu_active:
		return
	
	
	if Input.is_action_just_pressed("ui_a_key"):
		
		match Singleton_CommonVariables.action_type:
			"SHOP_BUY":
				
				if Singleton_CommonVariables.gold < item_list[current_item_selected].price_buy:
					Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
					return
				
				print("Attempt to buy item")
				
				is_menu_active = false
				
				Singleton_CommonVariables.selected_item = item_list[current_item_selected]
				
				Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
				
				var display_str = ""
				display_str = item_list[current_item_selected].item_name + ", right?\n"
				display_str = display_str + "That comes to " + str(item_list[current_item_selected].price_buy) + " coins.\nOK?"
				
				Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
				
				var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
				# yield(get_tree().create_timer(0.02), "timeout")
			
				print("\n Result - ", result, "\n")
		
				if result == "NO":
					is_menu_active = true
				elif result == "YES":
					hide()
					Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable("Who do you wish to have it?")
					Singleton_CommonVariables.ui__micro_member_list_view.set_menu_active()
					Singleton_CommonVariables.ui__micro_member_list_view.show()
			
				print("Show New Menu")
			
		
		return
		
	elif Input.is_action_just_pressed("ui_b_key"):
		print("Cancel")
		is_menu_active = false
		hide()
		Singleton_CommonVariables.dialogue_box_node.hide()
		Singleton_CommonVariables.ui__gold_info_box.hide()
		
		Singleton_CommonVariables.ui__shop_menu.s_show_shop_menu()
	
	elif Input.is_action_just_pressed("ui_left"):
		print("Left")
		
		if check_if_next_or_prev_item_exists(current_item_selected - 1):
			selection_node.position = Vector2(selection_node.position.x - 21, selection_node.position.y)
			current_item_selected -= 1
			display_item_info(item_list[current_item_selected])
			move_info_box(current_item_selected, -21)
		
	elif Input.is_action_just_pressed("ui_right"):
		print("Right")
		
		if check_if_next_or_prev_item_exists(current_item_selected + 1):
			selection_node.position = Vector2(selection_node.position.x + 21, selection_node.position.y)
			current_item_selected += 1
			display_item_info(item_list[current_item_selected])
			move_info_box(current_item_selected, 21)


func check_if_next_or_prev_item_exists(idx) -> bool:
	if idx < 0:
		return false
	elif idx >= item_list.size():
		return false
	else:
		return true


func load_shop_items() -> void:
	for child in shop_items_container_node.get_children():
		child.queue_free()
	
	for item in item_list:
		var si = shop_item_scene.instantiate()
		
		si.item_resource = item
		
		shop_items_container_node.add_child(si)


func display_item_info(item) -> void:
	item_info_item_name_node.text = str(item.item_name)
	item_info__gold_node.text = str(item.price_buy)


func move_info_box(idx: int, move_amount: int) -> void:
	if idx == 0:
		item_info_node.position = Vector2(14, item_info_node.position.y)
	elif idx >= 9:
		item_info_node.position = Vector2(203, item_info_node.position.y)
	elif idx == 8:
		item_info_node.position = Vector2(182, item_info_node.position.y)
	else:
		item_info_node.position = Vector2(item_info_node.position.x + move_amount, item_info_node.position.y)
	
	# print(item_info_node.rect_position)


func insert_item_list(item_list_arg):
	item_list = item_list_arg
	
	load_shop_items()
	
	display_item_info(item_list[0])
