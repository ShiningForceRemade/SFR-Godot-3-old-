# tool
extends Node2D

@export var actor_type: String = "character"

signal signal_check_defeat_done
signal signal_death_animation_complete

@onready var pnode = get_parent()

@export var character_name: String

# todo make a dictionary with all of these in the format of
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

# TODO: fixme
@export var character_class: int 
#(int, "Swordsman - SDMN", "Knight - KNT",
#		"Warrior - WARR", "Sky Knight - SKNT", "Mage - MAGE",
#		"Monk - MONK", "Healer - HEAL", "Archer - ACHR", "ASKT",
#		"Birdman - BDMN", "Winged Knight - WKNT", "Dragon - DRGN", 
#		"Robot - RBT", "Werewolf - WRWF", "Samurai - SMR", 
#		"Ninja - NINJ", "Hero - HERO", "Paladin - PLDN", 
#		"Galaditor - GLDR", "SBRN", "Wizard - WIZD", 
#		"Master Monk - MSMK", "Vicar - VICR", "BWMS", 
#		"Sky Knight - SKNT", "Sky Warrior - SKYW", "SKYL",
#		"GRDR", "Cyborg - CYBG", "Wolf Barron - WFBN", "Yogurt - YGRT",
#		"MGCR") var character_class: int

@export var is_promoted: bool = false

# const item_location_c

## Only the first 4 fields are valid everything after that is ignored!
@export var inventory_items_id: Array[Resource]
@export var is_item_equipped: Array[bool]

## Only the first 4 fields are valid everything after that is ignored!
@export var spells_id: Array[Resource] 

# group - textures
@export var texture_sprite_map: Texture2D
@export var texture_sprite_battle: Texture2D
# battle palette ? whats this
@export var texture_protrait: Texture2D

# group - stats
@export var level: int
@export var attack: int
@export var attack_growth: int # (int, "steady", "early", "late", "early-late")
@export var defense: int
@export var defense_growth: int # (int, "steady", "early", "late", "early-late")
@export var agility: int
@export var agility_growth: int # (int, "steady", "early", "late", "early-late")
@export var move: int
@export var HP_Current: int
@export var HP_Total: int
@export var hp_growth: int # (int, "steady", "early", "late", "early-late")
@export var MP_Current: int
@export var MP_Total: int
@export var mp_growth: int # (int, "steady", "early", "late", "early-late")
@export var magic_array: int # (Array, int, "Medical Herb")
@export var status: int = 0 # (int, "None")

@export var critical_hit_chance: int = 10 # (int, 0, 100)
@export var critical_hit_growth: int # (int, "steady", "early", "late", "early-late")

@export var double_attack_chance: int = 10 # (int, 0, 100)
@export var dodge_chance: int = 10 # (int, 0, 100)

@export var ai_target_priority: int

# group - behaviours
@export var movement_type: int = 0 # "Standard" # (int, "Standard", "Mounted", "Aquatic", "Forest", "Mechanical", "Flying", "Hovering")
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
#export var action_type_chance: int = 0 # (int, 0, 100)

# special attack and chance should be sub group
#export(int, "None", "150% Damage Critical", "200% Damage Critical", 
#			"Steal MP", "Steal HP", "Steal HP 2",
#			"Poison Chance", "Sleep Chance",
#			"Sleep Chance 2", "Death Chance") var special_attack: int = 0 # "None
#export var special_attack_chance: int = 0 # (int, 0, 100)

# group - magic resistances
# general
@export var magic_resistance: int = 0 # (int, 0, 100)
# spell specific resistance
# NOTE: shining force editor v3.4.4 has one other resistance type that hasn't been solved yet
@export var slow_resistance: int = 0 # (int, 0, 100)
@export var muddle_resistance: int = 0 # (int, 0, 100)
@export var sleep_and_desoul_resistance: int = 0 # (int, 0, 100)
@export var bolt_resistance: int = 0 # (int, 0, 100)
@export var blaze_resistance: int = 0 # (int, 0, 100)
@export var freeze_resistance: int = 0 # (int, 0, 100)

@export var experience_points: int = 0

@export var battle_animation_unpromoted_resource: Resource

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

var movement_tween_speed = 0.1625
# var movement_tween_speed = 0.2

func _ready():
	$AnimationPlayer.play("DownMovement")
	pass


#
#
# TODO clean up code below and integrate with character base script proper
#
#


signal signal_completed_turn
signal signal_character_moved(new_pos)

signal signal_show_character_action_menu

signal signal_switch_focus_to_cursor

var active: bool = false


# play_turn
func play_turn():
	print("Inner Play turn called")
	
	if active:
		active = !active
		emit_signal("signal_completed_turn")
	else:
		active = !active
	
	# self.connect("signal_completed_turn",Callable(self,"play_turn"))
	# await self.signal_completed_turn
	

# Getters
func cget_agility() -> int: return agility
func cget_actor_name() -> String: return character_name
func cget_level() -> int: return level
func cget_hp_total() -> int: return HP_Total
func cget_hp_current() -> int: return HP_Current
func cget_mp_total() -> int: return MP_Total
func cget_mp_current() -> int: return MP_Current
func cget_class() -> String: return char_class_array[character_class]

# signal CharacterMoved(value, other_value)

@onready var characterRoot = self
@onready var kinematicBody = $CharacterBody2D
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationTreeState = animationTree.get("parameters/playback")
@onready var tween = $CharacterBody2D/Tween

var velocity: Vector2 = Vector2.ZERO

const TILE_SIZE: int = 24

func char_moved(new_pos):
	emit_signal("signal_character_moved", new_pos)

func get_character_movement():
	return characterRoot.move

func get_character_current_pos() -> Vector2:
	# print("here", kinematicBody)
	return kinematicBody.global_position

func get_attack() -> int:
	var attack_attribute_bonus_total: int = 0
	for i in range(inventory_items_id.size()):
		if is_item_equipped[i]:
			for j in (inventory_items_id[i].attribute.size()):
				if inventory_items_id[i].attribute[j] == 1:
					attack_attribute_bonus_total += inventory_items_id[i].attribute_bonus[j]
	
	return attack + attack_attribute_bonus_total

func _physics_process(_delta):
	
	# Classic Genesis styled movement and battle movement
	if active:
		if tween.is_active():
			return
		
		animationPlayer.playback_speed = 1
		
		if Input.is_action_just_released("ui_a_key"):
			if is_character_actor_underneath():
				Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
				return
				
			active = !active
			await get_tree().create_timer(0.03).timeout
			
			# emit_signal("signal_completed_turn")
			# print("Emit signal player turn end")
			# emit_signal("signal_completed_turn")
			
			emit_signal("signal_show_character_action_menu")
		
		if Input.is_action_just_released("ui_b_key"):
			active = !active
			await get_tree().create_timer(0.03).timeout
			emit_signal("signal_switch_focus_to_cursor")
		
		# animationPlayer.playback_speed = 4
		
		if Input.is_action_pressed("ui_right"):
			animationPlayer.play("RightMovement")
			
			if check_if_move_is_possible(Vector2(pnode.global_position.x + TILE_SIZE, pnode.global_position.y)):
				animationPlayer.playback_speed = 2
				Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
				tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x + TILE_SIZE, pnode.position.y), movement_tween_speed, Tween.TRANS_LINEAR)
				emit_signal("signal_character_moved", Vector2(pnode.position.x + TILE_SIZE, pnode.position.y))
		elif Input.is_action_pressed("ui_left"):
			animationPlayer.play("LeftMovement")
			
			if check_if_move_is_possible(Vector2(pnode.global_position.x - TILE_SIZE, pnode.global_position.y)):
				animationPlayer.playback_speed = 2
				Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
				tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x - TILE_SIZE, pnode.position.y), movement_tween_speed, Tween.TRANS_LINEAR)
				emit_signal("signal_character_moved", Vector2(pnode.position.x - TILE_SIZE, pnode.position.y))
		elif Input.is_action_pressed("ui_up"):
			animationPlayer.play("UpMovement")
			
			if check_if_move_is_possible(Vector2(pnode.global_position.x, pnode.global_position.y - TILE_SIZE)):
				animationPlayer.playback_speed = 2
				Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
				tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x, pnode.position.y - TILE_SIZE), movement_tween_speed, Tween.TRANS_LINEAR)
				emit_signal("signal_character_moved", Vector2(pnode.position.x, pnode.position.y - TILE_SIZE))
		elif Input.is_action_pressed("ui_down"):
			animationPlayer.play("DownMovement")
			
			if check_if_move_is_possible(Vector2(pnode.global_position.x, pnode.global_position.y + TILE_SIZE)):
				animationPlayer.playback_speed = 2
				Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
				tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x, pnode.position.y + TILE_SIZE), movement_tween_speed, Tween.TRANS_LINEAR)
				emit_signal("signal_character_moved", Vector2(pnode.position.x, pnode.position.y + TILE_SIZE))
		
		
		tween.start()

func check_if_move_is_possible(new_pos_arg) -> bool:
	var enemey_children = Singleton_Game_GlobalBattleVariables.enemey_nodes.get_children()
	for enemey in enemey_children:
		# print(new_pos_arg,  enemey.global_position)
		if new_pos_arg == enemey.global_position:
			return false
	
	var check_pos = new_pos_arg
	check_pos.x -= 12
	check_pos.y -= 12
	for sub_array in Singleton_Game_GlobalBattleVariables.active_actor_movement_array:
		# print("Sub_array", sub_array)
		for move_pos in sub_array:
			if move_pos != null:
				
				# print("move pos ", move_pos, check_pos)
				
				# print(new_pos_arg, " ", check_pos, " ", move_pos)
				if check_pos == move_pos:
					return true
	
	# print("False")
	return false

func is_character_actor_underneath() -> bool:
	var character_children = Singleton_Game_GlobalBattleVariables.character_nodes.get_children()
	for character in character_children:
		if pnode == character:
			continue
		
		if pnode.global_position == character.global_position:
			return true
		
	return false


func check_if_defeated() -> void:
	if HP_Current == 0:
		print("\n\n\n\nI was defeated play death animation and update turn order array\n\n\n\n")
		
		# await get_tree().create_timer(1).timeout
		pseudo_death_animation(0.2)
		await self.signal_death_animation_complete
		pseudo_death_animation(0.1)
		await self.signal_death_animation_complete
		# await get_tree().create_timer(1).timeout
		
		Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/HitSoundCut.wav")
		get_parent().hide()
		
		
		await get_tree().create_timer(0.1).timeout
		emit_signal("signal_check_defeat_done")
		get_parent().queue_free()
		return
	
	await get_tree().create_timer(0.1).timeout
	emit_signal("signal_check_defeat_done")
	pass


func pseudo_death_animation(time_arg: float) -> void:
	$AnimationPlayer.play("RightMovement")
	await get_tree().create_timer(time_arg).timeout
	$AnimationPlayer.play("UpMovement")
	await get_tree().create_timer(time_arg).timeout
	$AnimationPlayer.play("LeftMovement")
	await get_tree().create_timer(time_arg).timeout
	$AnimationPlayer.play("DownMovement")
	await get_tree().create_timer(time_arg).timeout
	
	emit_signal("signal_death_animation_complete")
	# TODO: check order array and remove if found by name


func change_facing_direction(direction) -> void:
	if direction == "Left":
		animationPlayer.play("LeftMovement")
	if direction == "Right":
		animationPlayer.play("RightMovement")
	if direction == "Up":
		animationPlayer.play("UpMovement")
	if direction == "Down":
		animationPlayer.play("DownMovement")
