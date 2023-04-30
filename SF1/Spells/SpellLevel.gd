extends Resource
class_name CN_SF1_Spell_Level

## The level of the spell
@export var level: int = 1 

## What is the usage range type of the spell
@export var usage_range: Resource
## What is the target selection type of the spell
@export var target_range: Resource

## How much mp does this level of the spell cost
@export var mp_usage_cost: int

# TODO: make this a typed array something with the structure of
# attribute_type
# attribute_amount (or range)
# 
## What stats does this spell effect TODO: make this an array with min range and max range
## to get spells that can  effect multiple attributes
@export_enum("None", "Attack", "HP") var attributes: int

#export(Array, int, "Attack", "HP", "None") var attributes

# What is the lowest amount not including resistances this spell level should reach
@export var min_range: int
# What is the highest amount not including resistances this spell level should reach
@export var max_range: int

@export var battle_scene_spell_animation_scene: String

func _ready():
	pass
