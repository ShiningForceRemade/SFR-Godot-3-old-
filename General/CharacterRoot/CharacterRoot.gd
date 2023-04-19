extends Node2D


# signal signal_check_defeat_done
# signal signal_death_animation_complete

@export_group("Meta")
## Determines behaviour in battle - Character is force members - Enemey self explanatory - NPCs are like Peter from SF2 auto controlled force members might be expanded on in the future
@export_enum("character", "enemey", "npc") var actor_type: String = "character"
## The default name for the actor ie - main character in SF1 is called Max if no nickname is entered.
@export var character_name: String
## This should be left blank - this value will be overwritten. Ex. an actor joins the shining force and the player has the chance to give them a nickname
var nickname: String
# Which status ailment the character currently has - ex. posioned - confused etc TODO: should be an array
@export_enum("None") var status: int = 0
# Determines how likely this actor is to be targeted in battle - 0 least likely 100 attack if possible
@export var ai_target_priority: int

#
# TODO: make a dictionary with all of these in the format of
# {full: swordsman, short: sdmn
const char_class_array = ["SDMN", "KNT",
		"WARR", "SKNT", "MAGE",
		"MONK", "HEAL", "ACHR", "ASKT",
		"BDMN", "WKNT", "DRGN", 
		"RBT", "WRWF", "SMR", 
		"NINJ", "HERO", "PLDN", 
		"GLDR", "SBRN", "WIZD", 
		"MSMK", "VICR", "BWMS", 
		"SKNT", "SKYW", "SKYL",
		"GRDR", "CYBG", "WFBN", "YGRT",
		"MGCR"]

@export_enum("Swordsman - SDMN", "Knight - KNT",
		"Warrior - WARR", "Sky Knight - SKNT", "Mage - MAGE",
		"Monk - MONK", "Healer - HEAL", "Archer - ACHR", "ASKT",
		"Birdman - BDMN", "Winged Knight - WKNT", "Dragon - DRGN", 
		"Robot - RBT", "Werewolf - WRWF", "Samurai - SMR", 
		"Ninja - NINJ", "Hero - HERO", "Paladin - PLDN", 
		"Galaditor - GLDR", "SBRN", "Wizard - WIZD", 
		"Master Monk - MSMK", "Vicar - VICR", "BWMS", 
		"Sky Knight - SKNT", "Sky Warrior - SKYW", "SKYL",
		"GRDR", "Cyborg - CYBG", "Wolf Barron - WFBN", "Yogurt - YGRT",
		"MGCR") var character_class: int

## Promotion stage dictates where the character is in their promotion stage
## 0 unpromoted - 1 promoted - 2 or higher as possible options for different stages
@export var promotion_stage: int = 0

# const item_location_c

# TODO: look to see if godot 4 has custom types or export dictionary support to simplifiy this
## Only the first 4 fields are valid everything after that is ignored!
@export var inventory_items_id: Array[Resource]
## Determines if the items above are equipped or not
@export var is_item_equipped: Array[bool]

## Only the first 4 fields are valid everything after that is ignored! Place 
@export var spells_id: Array[Resource]
# @export_enum("Medical Herb") var magic_array: Array[int]
## TODO: What is this for again?
@export var magic_array: Array[int]


# group - behaviours
# export var regeneration_rate: int = 0

# NOTE: for characters this should be done on a per character basis like kiwi fire breath or other specials 
# within the character scene and script itself
# NOTE: shining force editor v3.4.4 has one other behaviour type that hasn't been solved yet
# action type and chance should be sub group
#export(int, "Default", "Caster", "Use Items", 
#			"Fire Breath", "Fire Breath 2", "Fire Breath 3", "Fire Breath 4",
#			"Ice Breath", "Ice Breath 2",
#			"Machine Gun", "Laser", "Demon Blaze",
#			"Dark Dragon Mid", "Dark Dragon Side") var action_type: int = 0 # "Default"
#export(int, 0, 100) var action_type_chance: int = 0

# special attack and chance should be sub group
#export(int, "None", "150% Damage Critical", "200% Damage Critical", 
#			"Steal MP", "Steal HP", "Steal HP 2",
#			"Poison Chance", "Sleep Chance",
#			"Sleep Chance 2", "Death Chance") var special_attack: int = 0 # "None
#export(int, 0, 100) var special_attack_chance: int = 0


@export_group("Sprites Textures Animations")
@export_subgroup("Unpromoted")
@export var texture_sprite_overworld_unpromoted: Texture
@export var texture_sprite_battle_unpromoted: Texture
@export var texture_sprite_portrait_unpromoted: Texture
@export var animation_battle_resource_unpromoted: Resource
@export_subgroup("Promoted")
@export var texture_sprite_overworld_promoted: Texture
@export var texture_sprite_battle_promoted: Texture
@export var texture_sprite_portrait_promoted: Texture
@export var animation_battle_resource_promoted: Resource

### Group - stats - start

@export_group("Stats Common")

@export var level: int = 1
@export var move: int
@export_enum("Standard", "Mounted", "Aquatic", "Forest", "Mechanical", "Flying", "Hovering") var movement_type: int = 0 # "Standard"
@export_range(0, 100) var double_attack_chance: int = 10
@export_range(0, 100) var dodge_chance: int = 10
@export var experience_points: int = 0

# TODO: need a way to have growth curves for different stages of promotion
@export_subgroup("HP")
var HP_Current: int
@export var HP_Total: int
@export_enum("steady", "early", "late", "early-late") var hp_growth: int

@export_subgroup("MP")
var MP_Current: int
@export var MP_Total: int
@export_enum("steady", "early", "late", "early-late") var mp_growth: int

@export_subgroup("Attack")
@export var attack: int
@export_enum("steady", "early", "late", "early-late") var attack_growth: int

@export_subgroup("Defense")
@export var defense: int
@export_enum("steady", "early", "late", "early-late") var defense_growth: int

@export_subgroup("Agility")
@export var agility: int
@export_enum("steady", "early", "late", "early-late") var agility_growth: int

@export_subgroup("Critical Hit Chance")
@export_range(0, 100) var critical_hit_chance: int = 10
@export_enum("steady", "early", "late", "early-late") var critical_hit_growth: int

### Group - stats - end

### Group - magic resistances - start

@export_group("Magoc Resistances")
# general
@export_range(0, 100) var magic_resistance: int = 0
# spell specific resistance
# NOTE: shining force editor v3.4.4 has one other resistance type that hasn't been solved yet
@export_range(0, 100) var slow_resistance: int = 0
@export_range(0, 100) var muddle_resistance: int = 0
@export_range(0, 100) var sleep_and_desoul_resistance: int = 0
@export_range(0, 100) var bolt_resistance: int = 0
@export_range(0, 100) var blaze_resistance: int = 0
@export_range(0, 100) var freeze_resistance: int = 0

### Group - magic resistances - end

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

## Actor (unit) Performance Statistics
var aps_enemey_kills: int = 0
var aps_times_defeated: int = 0 # unit deaths
var aps_dodges: int = 0 # enemey missed
var aps_misses: int = 0 # missed enemey
var aps_double_attacks: int = 0
var aps_special_attack: int = 0
var aps_critical_hits: int = 0
##



# @var movement_tween_speed = 0.1625
# var movement_tween_speed = 0.2

func _ready():
	# $AnimationPlayer.play("DownMovement")
	pass


#
#
# TODO clean up code below and integrate with character base script proper
#
#


#signal signal_completed_turn
#signal signal_character_moved(new_pos)
#
#signal signal_show_character_action_menu
#
#signal signal_switch_focus_to_cursor
#
#var active: bool = false
#
#
## play_turn
#func play_turn():
#	print("Inner Play turn called")
#
#	if active:
#		active = !active
#		emit_signal("signal_completed_turn")
#	else:
#		active = !active
#
#	# self.connect("signal_completed_turn", self, "play_turn")
#	# yield(self, "signal_completed_turn")
#
#
## Getters
#func cget_agility() -> int: return agility
#func cget_actor_name() -> String: return character_name
#func cget_level() -> int: return level
#func cget_hp_total() -> int: return HP_Total
#func cget_hp_current() -> int: return HP_Current
#func cget_mp_total() -> int: return MP_Total
#func cget_mp_current() -> int: return MP_Current
#func cget_class() -> String: return char_class_array[character_class]
#
## signal CharacterMoved(value, other_value)
#
#onready var characterRoot = self
#onready var kinematicBody = $KinematicBody2D
#onready var animationPlayer = $AnimationPlayer
#onready var animationTree = $AnimationTree
#onready var animationTreeState = animationTree.get("parameters/playback")
#onready var tween = $KinematicBody2D/Tween
#
#var velocity: Vector2 = Vector2.ZERO
#
#const TILE_SIZE: int = 24
#
#func char_moved(new_pos):
#	emit_signal("signal_character_moved", new_pos)
#
#func get_character_movement():
#	return characterRoot.move
#
#func get_character_current_pos() -> Vector2:
#	# print("here", kinematicBody)
#	return kinematicBody.global_position
#
#func get_attack() -> int:
#	var attack_attribute_bonus_total: int = 0
#	for i in range(inventory_items_id.size()):
#		if is_item_equipped[i]:
#			for j in (inventory_items_id[i].attribute.size()):
#				if inventory_items_id[i].attribute[j] == 1:
#					attack_attribute_bonus_total += inventory_items_id[i].attribute_bonus[j]
#
#	return attack + attack_attribute_bonus_total
#
#func _physics_process(_delta):
#
#	# Classic Genesis styled movement and battle movement
#	if active:
#		if tween.is_active():
#			return
#
#		animationPlayer.playback_speed = 1
#
#		if Input.is_action_just_released("ui_a_key"):
#			if is_character_actor_underneath():
#				Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
#				return
#
#			active = !active
#			yield(get_tree().create_timer(0.03), "timeout")
#
#			# emit_signal("signal_completed_turn")
#			# print("Emit signal player turn end")
#			# emit_signal("signal_completed_turn")
#
#			emit_signal("signal_show_character_action_menu")
#
#		if Input.is_action_just_released("ui_b_key"):
#			active = !active
#			yield(get_tree().create_timer(0.03), "timeout")
#			emit_signal("signal_switch_focus_to_cursor")
#
#		# animationPlayer.playback_speed = 4
#
#		if Input.is_action_pressed("ui_right"):
#			animationPlayer.play("RightMovement")
#
#			if check_if_move_is_possible(Vector2(pnode.global_position.x + TILE_SIZE, pnode.global_position.y)):
#				animationPlayer.playback_speed = 2
#				Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
#				tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x + TILE_SIZE, pnode.position.y), movement_tween_speed, Tween.TRANS_LINEAR)
#				emit_signal("signal_character_moved", Vector2(pnode.position.x + TILE_SIZE, pnode.position.y))
#		elif Input.is_action_pressed("ui_left"):
#			animationPlayer.play("LeftMovement")
#
#			if check_if_move_is_possible(Vector2(pnode.global_position.x - TILE_SIZE, pnode.global_position.y)):
#				animationPlayer.playback_speed = 2
#				Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
#				tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x - TILE_SIZE, pnode.position.y), movement_tween_speed, Tween.TRANS_LINEAR)
#				emit_signal("signal_character_moved", Vector2(pnode.position.x - TILE_SIZE, pnode.position.y))
#		elif Input.is_action_pressed("ui_up"):
#			animationPlayer.play("UpMovement")
#
#			if check_if_move_is_possible(Vector2(pnode.global_position.x, pnode.global_position.y - TILE_SIZE)):
#				animationPlayer.playback_speed = 2
#				Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
#				tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x, pnode.position.y - TILE_SIZE), movement_tween_speed, Tween.TRANS_LINEAR)
#				emit_signal("signal_character_moved", Vector2(pnode.position.x, pnode.position.y - TILE_SIZE))
#		elif Input.is_action_pressed("ui_down"):
#			animationPlayer.play("DownMovement")
#
#			if check_if_move_is_possible(Vector2(pnode.global_position.x, pnode.global_position.y + TILE_SIZE)):
#				animationPlayer.playback_speed = 2
#				Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
#				tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x, pnode.position.y + TILE_SIZE), movement_tween_speed, Tween.TRANS_LINEAR)
#				emit_signal("signal_character_moved", Vector2(pnode.position.x, pnode.position.y + TILE_SIZE))
#
#
#		tween.start()
#
#func check_if_move_is_possible(new_pos_arg) -> bool:
#	var enemey_children = Singleton_Game_GlobalBattleVariables.enemey_nodes.get_children()
#	for enemey in enemey_children:
#		# print(new_pos_arg,  enemey.global_position)
#		if new_pos_arg == enemey.global_position:
#			return false
#
#	var check_pos = new_pos_arg
#	check_pos.x -= 12
#	check_pos.y -= 12
#	for sub_array in Singleton_Game_GlobalBattleVariables.active_actor_movement_array:
#		# print("Sub_array", sub_array)
#		for move_pos in sub_array:
#			if move_pos != null:
#
#				# print("move pos ", move_pos, check_pos)
#
#				# print(new_pos_arg, " ", check_pos, " ", move_pos)
#				if check_pos == move_pos:
#					return true
#
#	# print("False")
#	return false
#
#func is_character_actor_underneath() -> bool:
#	var character_children = Singleton_Game_GlobalBattleVariables.character_nodes.get_children()
#	for character in character_children:
#		if pnode == character:
#			continue
#
#		if pnode.global_position == character.global_position:
#			return true
#
#	return false
#
#
#func check_if_defeated() -> void:
#	if HP_Current == 0:
#		print("\n\n\n\nI was defeated play death animation and update turn order array\n\n\n\n")
#
#		# yield(get_tree().create_timer(1), "timeout")
#		pseudo_death_animation(0.2)
#		yield(self, "signal_death_animation_complete")
#		pseudo_death_animation(0.1)
#		yield(self, "signal_death_animation_complete")
#		# yield(get_tree().create_timer(1), "timeout")
#
#		Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/HitSoundCut.wav")
#		get_parent().hide()
#
#
#		yield(get_tree().create_timer(0.1), "timeout")
#		emit_signal("signal_check_defeat_done")
#		get_parent().queue_free()
#		return
#
#	yield(get_tree().create_timer(0.1), "timeout")
#	emit_signal("signal_check_defeat_done")
#	pass
#
#
#func pseudo_death_animation(time_arg: float) -> void:
#	$AnimationPlayer.play("RightMovement")
#	yield(get_tree().create_timer(time_arg), "timeout")
#	$AnimationPlayer.play("UpMovement")
#	yield(get_tree().create_timer(time_arg), "timeout")
#	$AnimationPlayer.play("LeftMovement")
#	yield(get_tree().create_timer(time_arg), "timeout")
#	$AnimationPlayer.play("DownMovement")
#	yield(get_tree().create_timer(time_arg), "timeout")
#
#	emit_signal("signal_death_animation_complete")
#	# TODO: check order array and remove if found by name
#
#
#func change_facing_direction(direction) -> void:
#	if direction == "Left":
#		animationPlayer.play("LeftMovement")
#	if direction == "Right":
#		animationPlayer.play("RightMovement")
#	if direction == "Up":
#		animationPlayer.play("UpMovement")
#	if direction == "Down":
#		animationPlayer.play("DownMovement")
