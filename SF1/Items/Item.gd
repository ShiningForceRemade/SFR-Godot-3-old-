extends Resource
# NOTE: Base Class for all other SF1 items
class_name CN_SF1_Item

@export var item_name: String

@export var texture: Texture2D

@export var target_actor_type: int # (int, "None", "Characters", "Enemies", "Both")

# ? - attribute that isn't known in sfedit (maybe crit since this seems to be modifiy in the original sf1 chances)
# YGRT is this yogurt?
# NOTE: hp mp and critical are custom and not in the original SF1
# IMPORTANT: TODO: when newer versions of godot come out simply attribute and attribute bonus
# to be in the same object group instead of having them as two separate arrays

## The attributes this item will effect
@export var attribute: Array[int] 
# ("None", "Attack", "Defense", 
#			"Agility", "Move", 
#			"Critcal", "HP", "MP",
#			"YGRT")

## The attribute bonus for the attributes selected above, make sure to match index number on the left side between the two
@export var attribute_bonus: Array[int]

# NOTE: IMPORTANT:
# Ensures can't be sold dropped or anything else that might lock the game progress
@export var key_item: bool = false

@export var price_buy: int
@export var price_sell: int

# maybe convert this to a status with a list of options for easy extending
# export var cursed: bool = false

# ? [NONE]
# export var usage_range: int = 255

# export var use_effect: int = 0 # (int, "None")

# ? [1]
#export var item_range: int = 16
# 0 stuff like shower cure used on everyone 
# after 0 normal movement styled targeting
# should add spell type of target
# export var item_use_range: int # (int, "0", "1", "2", "3")
@export var item_use_range: Resource
@export var item_use_range_path: String
# use on only one person
# should add cross like blaze 2 and other tpyes of selection combos
# export var item_use_target_type: int # (int, "1")
@export var item_use_target_type: Resource
@export var item_use_target_path: String

# export var attack_effect: int = 0

@export var sell_to_deals: bool = false


# export var cant_drop: bool = false

# weapons rings and armor (TODO: going to use american spelling check for none american spellings later)
#export var chance_to_crack: bool = false
@export var usable: bool = false

# seems redundant cause of curse
# export var cannot_unequip: bool = false

# probably only needed for generic items
# export var lose_after_use: bool = false

# export var ring: bool = false

# export var weapon: bool = true

# ? what is this used for internally in SF - when item types are above as well?
# export var item_type: int = 0

# two question makrs under item type in sf edit v3.4.4

func _ready():
	pass

func get_item_type() -> String:
	return "Item"
