extends Node2D

@onready var defaultItemSlotTexture = load("res://Assets/SFCD/Items/EmptyItemSlot.png")

@onready var item_up_slot_spirte     = $ItemSlotUpSprite
@onready var item_down_slot_spirte   = $ItemSlotDownSprite
@onready var item_left_slot_spirte   = $ItemSlotLeftSprite
@onready var item_right_slot_spirte  = $ItemSlotRightSprite

var inventory_items
var selected_actor

func _ready():
	reset_item_slot_textures_to_default_empty()

func show_selected_actor_inventory_items():
	if Singleton_Game_GlobalBattleVariables.currently_selected_actor == null:
		return
	
	selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("CharacterRoot")
	
	# print("Equip Menu Selected Actor", selected_actor)
	# print("Equip Menu ", selected_actor.inventory_items_id)
	
	inventory_items = selected_actor.inventory_items_id # active_char_root.is_item_equipped
	
	for i in range(inventory_items.size()):
		if i == 0:
			item_up_slot_spirte.texture = inventory_items[0].texture
		elif i == 1:
			item_left_slot_spirte.texture = inventory_items[1].texture
		elif i == 2:
			item_right_slot_spirte.texture = inventory_items[2].texture
		elif i == 3:
			item_down_slot_spirte.texture = inventory_items[3].texture	
	

func reset_item_slot_textures_to_default_empty() -> void:
	item_up_slot_spirte.texture = defaultItemSlotTexture
	item_down_slot_spirte.texture = defaultItemSlotTexture
	item_left_slot_spirte.texture = defaultItemSlotTexture
	item_right_slot_spirte.texture = defaultItemSlotTexture
