# @tool
extends Node2D

@export var enemey_battle_scene: PackedScene #  = "res://SF1/EnemiesAndBosses/RuneKnight/RuneKnightBattleScene.tscn"

signal signal_check_defeat_done
signal signal_death_animation_complete
signal signal_completed_turn
signal signal_character_moved(new_pos)
signal signal_show_character_action_menu
signal signal_switch_focus_to_cursor

# @onready var pnode = get_parent()

# @onready var characterRoot = self
# @onready var kinematicBody = $KinematicBody2D
# @onready var animationPlayer = $AnimationPlayer
# @onready var animationTree = $AnimationTree
# @onready var animationTreeState = animationTree.get("parameters/playback")
# @onready var tween = $KinematicBody2D/Tween

# const TILE_SIZE: int = 24
# var movement_tween_speed = 0.1625
# var movement_tween_speed = 0.125
var active: bool = false


@export_group("Meta")
@export_enum("character", "enemey", "npc") var actor_type: String = "enemey"
@export var enemey_name: String

## Minimum amount of coints to drop - used in conjuction with coins_max - to remove variability set both values to same amount
@export var coins_min: int
## Maximum amount of coints to drop - used in conjuction with coins_min - to remove variability set both values to same amount
@export var coins_max: int

## NOT USED CURRENTLY - what does class mean for a monster?
@export var monster_class: String

## Only the first 4 fields are valid everything after that is ignored!
@export var magic_array: Array[Resource]
## Only the first 4 fields are valid everything after that is ignored!
@export var inventory_items_id: Array[Resource]
## Only the first 4 fields are valid everything after that is ignored!
@export var is_item_equipped: Array[bool]
## TODO: clean me up item id and drop chance object array type
@export var droppable_items_id: Dictionary


@export_group("Sprites Textures Animations")
@export var texture_sprite_overworld: Texture
@export var texture_sprite_battle: Texture
@export var texture_sprite_portrait: Texture
@export var battle_normal_attack_animation_resource: Resource
@export var battle_special_attack_animation_resource: Resource
@export var battle_cast_magic_animation_resource: Resource


@export_group("Stats Common")
@export var effective_level: int
@export var move: int
var move_boost: int

@export_enum("Standard", "Mounted", "Aquatic", "Forest", "Mechanical", "Flying", "Hovering") var movement_type: int = 0 # "Standard"
@export_range(0, 100) var critical_hit_chance: int = 10
@export_range(0, 100) var double_attack_chance: int = 10
@export_range(0, 100) var dodge_chance: int = 10
## TODO: why does this exist again if dodge exists?
@export var evasion_chance: float = 1/32 * 100

@export var attack: int
@export var defense: int
@export var agility: int
@export var HP_Current: int
@export var HP_Total: int
@export var MP_Current: int
@export var MP_Total: int

@export_group("Behaviour")
@export_enum("None") var status: int = 0
## Percent amount to heal on the turn rotation - mainly used for bosses
@export var regeneration_rate: int = 0

## NOTE: shining force editor v3.4.4 has one other behaviour type that hasn't been solved yet
## action type and chance should be sub group
@export_enum("Default", "Caster", "Use Items", 
			"Fire Breath", "Fire Breath 2", "Fire Breath 3", "Fire Breath 4",
			"Ice Breath", "Ice Breath 2",
			"Machine Gun", "Laser", "Demon Blaze",
			"Dark Dragon Mid", "Dark Dragon Side") var action_type: int = 0 # "Default"
@export_range(0, 100) var action_type_chance: int = 0

## special attack and chance should be sub group
@export_enum("None", "150% Damage Critical", "200% Damage Critical", 
			"Steal MP", "Steal HP", "Steal HP 2",
			"Poison Chance", "Sleep Chance",
			"Sleep Chance 2", "Death Chance") var special_attack: int = 0 # "None
@export_range(0, 100) var special_attack_chance: int = 0


@export_group("Magic Resistance")
@export_range(0, 100) var magic_resistance: int = 0
# spell specific resistance
# NOTE: shining force editor v3.4.4 has one other resistance type that hasn't been solved yet
@export_range(0, 100) var slow_resistance: int = 0
@export_range(0, 100) var muddle_resistance: int = 0
@export_range(0, 100) var sleep_and_desoul_resistance: int = 0
@export_range(0, 100) var bolt_resistance: int = 0
@export_range(0, 100) var blaze_resistance: int = 0
@export_range(0, 100) var freeze_resistance: int = 0


func _ready():
	# $AnimationPlayer.play("DownMovement")
	pass


func get_actor_name() -> String:
	return enemey_name


func get_class_full() -> String:
	return ""

func get_class_short() -> String:
	return ""


func get_level() -> int:
	return effective_level


func get_hp_total() -> int:
	return HP_Total # sfnode_data.stats.hp + sfnode_data.stats.hp_boost + sfnode_data.stats.hp_permanent_increase

func get_hp_current() -> int:
	return HP_Current

func set_hp_current(new_hp_target: int) -> void:
	HP_Current = new_hp_target


func get_mp_total() -> int:
	return MP_Total # sfnode_data.stats.mp + sfnode_data.stats.mp_boost + sfnode_data.stats.mp_permanent_increase

func get_mp_current() -> int:
	return MP_Current # sfnode_data.stats.mp_current

func set_mp_current(new_mp_target: int) -> void:
	MP_Current = new_mp_target


func get_movement_type() -> int:
	return movement_type

func get_movement() -> int:
	return move + move_boost


func get_exp() -> int:
	return 0


#func get_attack_base() -> int:
#	return sfnode_data.stats.attack

func get_attack() -> int:
	var attack_attribute_bonus_total: int = 0
	for i in range(inventory_items_id.size()):
		if is_item_equipped[i]:
			var item_res = inventory_items_id[i]
			for j in (item_res.attribute_bonus.size()):
				if item_res.attribute == 0: #TODO: should have a better way to refer to the attack attribute than if equal 0
					attack_attribute_bonus_total += item_res.attribute_bonus[j]
	
	return attack + attack_attribute_bonus_total


func get_defense() -> int:
	# TODO: support for items to increase this like attack
	return defense # + sfnode_data.stats.defense_boost + sfnode_data.stats.defense_permanent_increase


func get_agility() -> int:
	# TODO: support for items to increase this like attack
	return agility # + sfnode_data.stats.agility_boost + sfnode_data.stats.agility_permanent_increase


func get_inventory():
	return inventory_items_id


func get_magic():
	return magic_array

func get_magic_array():
	if 0 == magic_array.size():
		return null
	
	return magic_array


func get_coins() -> int:
	return coins_min
