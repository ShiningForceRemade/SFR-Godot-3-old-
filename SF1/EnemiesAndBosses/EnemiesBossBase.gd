tool
extends Node2D

export var enemey_name: String

# group - drops
export var coins: int
## what does class mean for a monster?
export var monster_class: int

## TODO: clean me up item id and drop chance object array type
export var droppable_items_id: Dictionary

# maybe I should make this associateion enum and the corresponding array a singleton for global usage
enum weapons_and_rings { 
	ShortSword 
}

const weapons_and_rings_paths = {
	weapons_and_rings.ShortSword: "res://SF1/Items/Short Sword/ShortSword.tscn",
}

export(Array, weapons_and_rings) var equips_idssss

# const item_location_c

## Only the first 4 fields are valid everything after that is ignored!
export(Array, String, "Short Sword") var equips_id
## Only the first 4 fields are valid everything after that is ignored!
export(Array, int) var items_id
## Only the first 4 fields are valid everything after that is ignored!
export(Array, int) var spells_id

# group - textures
export var texture_sprite_map: Texture
export var texture_sprite_battle: Texture
# battle palette ? whats this
export var texture_protrait: Texture

# group - stats
export var effective_level: int
export var attack: int
export var defense: int
export var agility: int
export var move: int
export var HP_Current: int
export var HP_Total: int
export var MP_Current: int
export var MP_Total: int

export(Array, int, "Medical Herb") var magic_array
export(int, "None") var status: int = 0

export(int, 0, 100) var critical_hit_chance: int = 10
export(int, 0, 100) var double_attack_chance: int = 10
export(int, 0, 100) var dodge_chance: int = 10

# group - behaviours
export(int, "Standard", "Mounted", "Aquatic", "Forest", "Mechanical", "Flying", "Hovering") var movement_type: int = 0 # "Standard"
export var regeneration_rate: int = 0
# NOTE: shining force editor v3.4.4 has one other behaviour type that hasn't been solved yet
# action type and chance should be sub group
export(int, "Default", "Caster", "Use Items", 
			"Fire Breath", "Fire Breath 2", "Fire Breath 3", "Fire Breath 4",
			"Ice Breath", "Ice Breath 2",
			"Machine Gun", "Laser", "Demon Blaze",
			"Dark Dragon Mid", "Dark Dragon Side") var action_type: int = 0 # "Default"
export(int, 0, 100) var action_type_chance: int = 0
# special attack and chance should be sub group
export(int, "None", "150% Damage Critical", "200% Damage Critical", 
			"Steal MP", "Steal HP", "Steal HP 2",
			"Poison Chance", "Sleep Chance",
			"Sleep Chance 2", "Death Chance") var special_attack: int = 0 # "None
export(int, 0, 100) var special_attack_chance: int = 0

# group - magic resistances
# general
export(int, 0, 100) var magic_resistance: int = 0
# spell specific resistance
# NOTE: shining force editor v3.4.4 has one other resistance type that hasn't been solved yet
export(int, 0, 100) var slow_resistance: int = 0
export(int, 0, 100) var muddle_resistance: int = 0
export(int, 0, 100) var sleep_and_desoul_resistance: int = 0
export(int, 0, 100) var bolt_resistance: int = 0
export(int, 0, 100) var blaze_resistance: int = 0
export(int, 0, 100) var freeze_resistance: int = 0


# messy wait for native grouping support then subgroup
#var test = "" # We will store the value here
#func _get(property):
#	if property == "test/test":
#		return test # One can implement custom getter logic here
#
#func _set(property, value):
#	if property == "test/test":
#		test = value # One can implement custom setter logic here
#		return true
#
#func _get_property_list():
#	return [
#		{
#			"hint": PROPERTY_HINT_NONE,
#			"usage": PROPERTY_USAGE_DEFAULT,
#			"name": "test/test",
#			"type": TYPE_STRING
#		}
#	]


	
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("DownMovement")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
