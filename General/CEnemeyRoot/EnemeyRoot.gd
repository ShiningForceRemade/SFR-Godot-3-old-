# @tool
extends Node2D

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
## Called every frame. 'delta' is the elapsed time since the previous frame.
## func _process(delta):
##	pass
#
#func check_if_defeated() -> void:
#	if HP_Current == 0:
#		print("\n\n\n\nI was defeated play death animation and update turn order array\n\n\n\n")
#
#		# yield(get_tree().create_timer(1), "timeout")
#		pseudo_death_animation(0.1)
#		await Signal(self, "signal_death_animation_complete")
#		pseudo_death_animation(0.05)
#		await Signal(self, "signal_death_animation_complete")
#		# yield(get_tree().create_timer(1), "timeout")
#
#		Singleton_AudioManager.play_sfx("res://Assets/Sounds/HitSoundCut.wav")
#		get_parent().hide()
#
#		await Signal(get_tree().create_timer(0.05), "timeout")
#		emit_signal("signal_check_defeat_done")
#
#		get_parent().queue_free()
#		return
#
#	await Signal(get_tree().create_timer(0.05), "timeout")
#	emit_signal("signal_check_defeat_done")
#	return
#
#func pseudo_death_animation(time_arg: float) -> void:
#	$AnimationPlayer.play("RightMovement")
#	await Signal(get_tree().create_timer(time_arg), "timeout")
#	$AnimationPlayer.play("UpMovement")
#	await Signal(get_tree().create_timer(time_arg), "timeout")
#	$AnimationPlayer.play("LeftMovement")
#	await Signal(get_tree().create_timer(time_arg), "timeout")
#	$AnimationPlayer.play("DownMovement")
#	await Signal(get_tree().create_timer(time_arg), "timeout")
#
#
#	emit_signal("signal_death_animation_complete")
#	# TODO: check order array and remove if found by name
#
#
#
#func cget_actor_name() -> String:
#	return enemey_name
#
#
#
#
#func check_if_move_is_possible(new_pos_arg) -> bool:
#	var character_children = Singleton_BattleVariables.character_nodes.get_children()
#	for character in character_children:
#		if new_pos_arg == character.global_position:
#			return false
#
#	var check_pos = new_pos_arg
#	check_pos.x -= 12 # FIXME why is this now +11 off?
#	check_pos.y -= 12
#	for sub_array in Singleton_BattleVariables.active_actor_movement_array:
#		for move_pos in sub_array:
#			if move_pos != null:
#				# print(new_pos_arg, " ", check_pos, " ", move_pos)
#				if check_pos == move_pos:
#					return true
#
#	return false
#
#
#
#func play_turn():
#	print("Inner Play turn called")
#
#	if active:
#		active = !active
#		emit_signal("signal_completed_turn")
#	else:
#		active = !active
#
#
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
#				Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
#				return
#
#			active = !active
#			await Signal(get_tree().create_timer(0.03), "timeout")
#
#			# emit_signal("signal_completed_turn")
#			# print("Emit signal player turn end")
#			# emit_signal("signal_completed_turn")
#
#			emit_signal("signal_show_character_action_menu")
#
#		if Input.is_action_just_released("ui_b_key"):
#			active = !active
#			await Signal(get_tree().create_timer(0.03), "timeout")
#			emit_signal("signal_switch_focus_to_cursor")
#
#		# animationPlayer.playback_speed = 4
#
#		if Input.is_action_pressed("ui_right"):
#			animationPlayer.play("RightMovement")
#
#			if check_if_move_is_possible(Vector2(pnode.global_position.x + TILE_SIZE, pnode.global_position.y)):
#				animationPlayer.playback_speed = 2
#				Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
#				tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x + TILE_SIZE, pnode.position.y), movement_tween_speed, Tween.TRANS_LINEAR)
#				emit_signal("signal_character_moved", Vector2(pnode.position.x + TILE_SIZE, pnode.position.y))
#		elif Input.is_action_pressed("ui_left"):
#			animationPlayer.play("LeftMovement")
#
#			if check_if_move_is_possible(Vector2(pnode.global_position.x - TILE_SIZE, pnode.global_position.y)):
#				animationPlayer.playback_speed = 2
#				Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
#				tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x - TILE_SIZE, pnode.position.y), movement_tween_speed, Tween.TRANS_LINEAR)
#				emit_signal("signal_character_moved", Vector2(pnode.position.x - TILE_SIZE, pnode.position.y))
#		elif Input.is_action_pressed("ui_up"):
#			animationPlayer.play("UpMovement")
#
#			if check_if_move_is_possible(Vector2(pnode.global_position.x, pnode.global_position.y - TILE_SIZE)):
#				animationPlayer.playback_speed = 2
#				Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
#				tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x, pnode.position.y - TILE_SIZE), movement_tween_speed, Tween.TRANS_LINEAR)
#				emit_signal("signal_character_moved", Vector2(pnode.position.x, pnode.position.y - TILE_SIZE))
#		elif Input.is_action_pressed("ui_down"):
#			animationPlayer.play("DownMovement")
#
#			if check_if_move_is_possible(Vector2(pnode.global_position.x, pnode.global_position.y + TILE_SIZE)):
#				animationPlayer.playback_speed = 2
#				Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Walk.wav")
#				tween.interpolate_property(pnode, 'position', pnode.position, Vector2(pnode.position.x, pnode.position.y + TILE_SIZE), movement_tween_speed, Tween.TRANS_LINEAR)
#				emit_signal("signal_character_moved", Vector2(pnode.position.x, pnode.position.y + TILE_SIZE))
#
#
#		tween.start()
#
#
#func is_character_actor_underneath() -> bool:
#	var character_children = Singleton_BattleVariables.enemey_nodes.get_children()
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
#func change_facing_direction(direction) -> void:
#	if direction == "Left":
#		animationPlayer.play("LeftMovement")
#	if direction == "Right":
#		animationPlayer.play("RightMovement")
#	if direction == "Up":
#		animationPlayer.play("UpMovement")
#	if direction == "Down":
#		animationPlayer.play("DownMovement")
