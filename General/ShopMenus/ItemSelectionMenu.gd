tool
extends Node2D

export(Array, Resource) var item_list

var is_active: bool = true

var current_item_selected: int = 0

onready var shop_item_scene = load("res://General/ShopMenus/ShopItem.tscn")

onready var shop_items_container_node = $ShopItemsStatNinePatchRect/HBoxContainer

onready var item_info_node = $ItemInfoStatNinePatchRect
onready var item_info_item_name_node = $ItemInfoStatNinePatchRect/ItemNameLabel
onready var item_info__gold_node = $ItemInfoStatNinePatchRect/GoldLabel

onready var selection_node = $SelectionControl


func _ready():
	
	load_shop_items()
	
	display_item_info(item_list[0])
	
	pass


func _input(event):
	if event.is_action_pressed("ui_a_key"):
		print("Attempt to buy item")
	elif event.is_action_pressed("ui_b_key"):
		print("Cancel")
	
	elif event.is_action_pressed("ui_left"):
		print("Left")
		
		if check_if_next_or_prev_item_exists(current_item_selected - 1):
			selection_node.position = Vector2(selection_node.position.x - 21, selection_node.position.y)
			current_item_selected -= 1
			display_item_info(item_list[current_item_selected])
			move_info_box(current_item_selected, -21)
		
	elif event.is_action_pressed("ui_right"):
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
		var si = shop_item_scene.instance()
		
		si.item_resource = item
		
		shop_items_container_node.add_child(si)


func display_item_info(item) -> void:
	item_info_item_name_node.text = str(item.item_name)
	item_info__gold_node.text = str(item.price_buy)


func move_info_box(idx, move_amount: int) -> void:
	if idx == 0:
		item_info_node.rect_position = Vector2(14, item_info_node.rect_position.y)
	elif idx >= 9:
		item_info_node.rect_position = Vector2(203, item_info_node.rect_position.y)
	elif idx == 8:
		item_info_node.rect_position = Vector2(182, item_info_node.rect_position.y)
	else:
		item_info_node.rect_position = Vector2(item_info_node.rect_position.x + move_amount, item_info_node.rect_position.y)
	
	# print(item_info_node.rect_position)
