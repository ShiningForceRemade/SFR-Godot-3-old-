# tool
extends Node2D

onready var pnode = get_parent()

export var character_name: String

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

export(int, "Swordsman - SDMN", "Knight - KNT",
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

export var is_promoted: bool = false

# maybe I should make this associateion enum and the corresponding array a singleton for global usage
#enum weapons_and_rings { 
#	ShortSword 
#}

#const weapons_and_rings_paths = {
	#weapons_and_rings.ShortSword: "res://SF1/Items/Short Sword/ShortSword.tscn",
#}

# export(Array, weapons_and_rings) var equips_idssss

# const item_location_c

## Only the first 4 fields are valid everything after that is ignored!
## export(Array, Resource) var equips_id
## Only the first 4 fields are valid everything after that is ignored!
## export(Array, Resource) var items_id

export(Array, Resource) var inventory_items_id
export(Array, bool) var is_item_equipped

## Only the first 4 fields are valid everything after that is ignored!
export(Array, Resource) var spells_id

# group - textures
export var texture_sprite_map: Texture
export var texture_sprite_battle: Texture
# battle palette ? whats this
export var texture_protrait: Texture

# group - stats
export var level: int
export var attack: int
export(int, "steady", "early", "late", "early-late") var attack_growth
export var defense: int
export(int, "steady", "early", "late", "early-late") var defense_growth
export var agility: int
export(int, "steady", "early", "late", "early-late") var agility_growth
export var move: int
export var HP_Current: int
export var HP_Total: int
export(int, "steady", "early", "late", "early-late") var hp_growth
export var MP_Current: int
export var MP_Total: int
export(int, "steady", "early", "late", "early-late") var mp_growth
export(Array, int, "Medical Herb") var magic_array
export(int, "None") var status: int = 0

export(int, 0, 100) var critical_hit_chance: int = 10
export(int, "steady", "early", "late", "early-late") var critical_hit_growth

export(int, 0, 100) var double_attack_chance: int = 10
export(int, 0, 100) var dodge_chance: int = 10

export var ai_target_priority: int

# group - behaviours
export(int, "Standard", "Mounted", "Aquatic", "Forest", "Mechanical", "Flying", "Hovering") var movement_type: int = 0 # "Standard"
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

export var enemey_kills: int = 0
export var times_defeated: int = 0

export var experience_points: int = 0

export var battle_animation_unpromoted_resource: Resource

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

func _ready():
	$AnimationPlayer.play("DownMovement")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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
	
	# self.connect("signal_completed_turn", self, "play_turn")
	# yield(self, "signal_completed_turn")
	

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

onready var characterRoot = self
onready var kinematicBody = $KinematicBody2D
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationTreeState = animationTree.get("parameters/playback")
onready var tween = $KinematicBody2D/Tween

var velocity: Vector2 = Vector2.ZERO

const TILE_SIZE: int = 24

func char_moved(new_pos):
	emit_signal("signal_character_moved", new_pos)

func get_character_movement():
	return characterRoot.move

func get_character_current_pos() -> Vector2:
	# print("here", kinematicBody)
	return kinematicBody.position

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
		
		if Input.is_action_just_released("ui_page_down"):
			active = !active
			# emit_signal("signal_completed_turn")
			# print("Emit signal player turn end")
			# emit_signal("signal_completed_turn")
			emit_signal("signal_show_character_action_menu")
		
		if Input.is_action_just_released("ui_b_key"):
			active = !active
			emit_signal("signal_switch_focus_to_cursor")
		
		# animationPlayer.playback_speed = 4
		
		if Input.is_action_pressed("ui_right"):
			animationPlayer.play("RightMovement")
			# Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/StepSound.wav")
			tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x + TILE_SIZE, pnode.position.y), 0.15, Tween.TRANS_LINEAR)
			emit_signal("signal_character_moved", Vector2(pnode.position.x + TILE_SIZE, pnode.position.y))
		elif Input.is_action_pressed("ui_left"):
			animationPlayer.play("LeftMovement")
			# Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/StepSound.wav")
			tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x - TILE_SIZE, pnode.position.y), 0.15, Tween.TRANS_LINEAR)
			emit_signal("signal_character_moved", Vector2(pnode.position.x - TILE_SIZE, pnode.position.y))
		elif Input.is_action_pressed("ui_up"):
			animationPlayer.play("UpMovement")
			# Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/StepSound.wav")
			tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x, pnode.position.y - TILE_SIZE), 0.15, Tween.TRANS_LINEAR)
			emit_signal("signal_character_moved", Vector2(pnode.position.x, pnode.position.y - TILE_SIZE))
		elif Input.is_action_pressed("ui_down"):
			animationPlayer.play("DownMovement")
			# Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/StepSound.wav")
			tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x, pnode.position.y + TILE_SIZE), 0.15, Tween.TRANS_LINEAR)
			emit_signal("signal_character_moved", Vector2(pnode.position.x, pnode.position.y + TILE_SIZE))
			
			
#		if Input.is_action_pressed("ui_right"):
#			animationPlayer.play("RightMovement")
#			tween.interpolate_property(kinematicBody, 'position', kinematicBody.position, Vector2(kinematicBody.position.x + TILE_SIZE, kinematicBody.position.y), 0.15, Tween.TRANS_LINEAR)
#			emit_signal("signal_character_moved", Vector2(kinematicBody.position.x + TILE_SIZE, kinematicBody.position.y))
#		elif Input.is_action_pressed("ui_left"):
#			animationPlayer.play("LeftMovement")
#			tween.interpolate_property(kinematicBody, 'position', kinematicBody.position, Vector2(kinematicBody.position.x - TILE_SIZE, kinematicBody.position.y), 0.15, Tween.TRANS_LINEAR)
#			emit_signal("signal_character_moved", Vector2(kinematicBody.position.x - TILE_SIZE, kinematicBody.position.y))
#		elif Input.is_action_pressed("ui_up"):
#			animationPlayer.play("UpMovement")
#			tween.interpolate_property(kinematicBody, 'position', kinematicBody.position, Vector2(kinematicBody.position.x, kinematicBody.position.y - TILE_SIZE), 0.15, Tween.TRANS_LINEAR)
#			emit_signal("signal_character_moved", Vector2(kinematicBody.position.x, kinematicBody.position.y - TILE_SIZE))
#		elif Input.is_action_pressed("ui_down"):
#			animationPlayer.play("DownMovement")
#			tween.interpolate_property(kinematicBody, 'position', kinematicBody.position, Vector2(kinematicBody.position.x, kinematicBody.position.y + TILE_SIZE), 0.15, Tween.TRANS_LINEAR)
#			emit_signal("signal_character_moved", Vector2(kinematicBody.position.x, kinematicBody.position.y + TILE_SIZE))
#
		#print("CharacterMoved")
		
		tween.start()
	
