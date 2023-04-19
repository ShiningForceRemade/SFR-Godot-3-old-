extends Resource

class_name CN_SF1_Spell

## The name of the spell that will be used in game
@export var name: String
## The image icon that will be used for this spell (Drag in an image directly)
@export var spell_texture: Texture

## Self - means no selection ex. egress as an example
## Enemeies - means only enemies can be targeted ex. blaze
## Characters - only allied force members ex. heal
## All - targets everything within the range - not implemented currently does nothing
@export_enum("Self", "Enemeies", "Characters", "All") var usable_on_actor_type: int

#export(Array, SpellLevelInfo) var test
# Make this a resource and have an array track it instead 
# this should be an array
#export var mp_usage_cost: int = 1
#export var level: int
#export var spell_range: int = 1
#export var spell_target_range: int = 1

## Array of spell level resource - basically the details what the spell does at what level
@export var levels: Array[Resource]

# TODO: expand on this for ROTDD type magic resistance
## The element type of the spell (Used when ROTDD conventions are enable for magic resistance)
## DEV NOTE: need to finish addding the rest of the types
@export_enum("None", "Fire") var element_type: int

# TODO: check for other features in ROTDD
# have the nagging feeling I'm missing something

@export var spell_use_range_path: String
@export var spell_use_target_path: String

@export var spell_animation_resource: Resource

func _ready():
	pass
