extends Resource

class_name CN_SF1_Spell

## The name of the spell that will be used in game
@export var name: String
## The image icon that will be used for this spell (Drag in an image directly)
@export var spell_texture: Texture

## Self - means used only on self ex. Max casting egress
## Allies - means only friendly units (includes self) ex. heal lowe can heal max or a dark priest can heal a golbin 
## Opposing - only the oppositie unit actors can be selected ex. tao using blaze can only target enemies like golbins dwarfs and rune knights
## All - targets everything within the range - not implemented currently does nothing
@export_enum("Self", "Allies", "Opposing", "All") var usable_on_actor_type: String

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

## NOT CURRENTLY USED
@export var overworld_use_effect: Resource
# @export var overworld_use_effect: Resource

#func _ready():
#	pass
