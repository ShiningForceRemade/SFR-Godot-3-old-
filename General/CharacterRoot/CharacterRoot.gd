extends Node2D

## Index for the SF1NODE.gd forcemembers array TOOD: clean abd better document these things
@export var SF1_MEMBER_INDEX: int

@export_group("Meta")
## Determines behaviour in battle - Character is force members - Enemey self explanatory - NPCs are like Peter from SF2 auto controlled force members might be expanded on in the future
@export_enum("character", "enemey", "npc") var actor_type: String = "character"

# signal signal_check_defeat_done
# signal signal_death_animation_complete



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
# @export_subgroup("Unpromoted")
@export var texture_sprite_overworld_unpromoted: Texture
@export var texture_sprite_battle_unpromoted: Texture
@export var texture_sprite_portrait_unpromoted: Texture
@export var animation_battle_resource_unpromoted: Resource
# @export_subgroup("Promoted")
@export var texture_sprite_overworld_promoted: Texture
@export var texture_sprite_battle_promoted: Texture
@export var texture_sprite_portrait_promoted: Texture
@export var animation_battle_resource_promoted: Resource

@export var battle__scene_unpromoted: PackedScene
@export var battle__scene_promoted: PackedScene


var sfnode_data

# @var movement_tween_speed = 0.1625
# var movement_tween_speed = 0.2

func _ready():
	sfnode_data = Singleton_CommonVariables.sf_game_data_node.ForceMembers[SF1_MEMBER_INDEX]
	# print("\n", sfnode_data, "\n")
	# $AnimationPlayer.play("DownMovement")


func get_magic_array():
	if 0 == sfnode_data.magic.size():
		return null
	
	return sfnode_data.magic


func get_actor_name() -> String:
	if sfnode_data.nickname != null:
		return sfnode_data.nickname
		
	return sfnode_data.name


func get_class_full() -> String:
	return sfnode_data.class_full

func get_class_short() -> String:
	return sfnode_data.class_short


func get_level() -> int:
	return sfnode_data.level


func get_hp_total() -> int:
	return sfnode_data.stats.hp + sfnode_data.stats.hp_boost + sfnode_data.stats.hp_permanent_increase

func get_hp_current() -> int:
	return sfnode_data.stats.hp_current

func set_hp_current(new_hp_target: int) -> void:
	Singleton_CommonVariables.sf_game_data_node.ForceMembers[SF1_MEMBER_INDEX].stats.hp_current = new_hp_target

func get_mp_total() -> int:
	return sfnode_data.stats.mp + sfnode_data.stats.mp_boost + sfnode_data.stats.mp_permanent_increase

func get_mp_current() -> int:
	return sfnode_data.stats.mp_current

func set_mp_current(new_mp_target: int) -> void:
	Singleton_CommonVariables.sf_game_data_node.ForceMembers[SF1_MEMBER_INDEX].stats.mp_current = new_mp_target


func get_movement_type() -> int:
	return sfnode_data.movement_type
#	for mt in Singleton_CommonVariables.sf_game_data_node.movement_types.size():
#		if Singleton_CommonVariables.sf_game_data_node.movement_types[mt] == sfnode_data.movement_type:
#			return mt

#func get_movement_type_string() -> String:
#	return sfnode_data.movement_type

func get_movement() -> int:
	return sfnode_data.stats.move + sfnode_data.stats.move_boost + sfnode_data.stats.move_permanent_increase


func get_exp() -> int:
	return sfnode_data.experience

func set_exp(exp_arg: int) -> void:
	Singleton_CommonVariables.sf_game_data_node.ForceMembers[SF1_MEMBER_INDEX].experience = exp_arg


func get_ai_target_priority() -> int:
	return sfnode_data.ai_target_priority


func get_attack_base() -> int:
	return sfnode_data.stats.attack

func get_attack() -> int:
	var attack_attribute_bonus_total: int = 0
	for i in range(sfnode_data.inventory.size()):
		if sfnode_data.inventory[i].is_equipped:
			var item_res = load(sfnode_data.inventory[i].resource)
			for j in (item_res.attribute_bonus.size()):
				if item_res.attribute == 0: #TODO: should have a better way to refer to the attack attribute than if equal 0
					attack_attribute_bonus_total += item_res.attribute_bonus[j]
	
	return sfnode_data.stats.attack + attack_attribute_bonus_total


func get_defense() -> int:
	# TODO: support for items to increase this like attack
	return sfnode_data.stats.defense + sfnode_data.stats.defense_boost + sfnode_data.stats.defense_permanent_increase


func get_agility() -> int:
	# TODO: support for items to increase this like attack
	return sfnode_data.stats.agility + sfnode_data.stats.agility_boost + sfnode_data.stats.agility_permanent_increase


func get_magic():
	return sfnode_data.magic


func get_inventory():
	return sfnode_data.inventory


func remove_inventory_item_at_idx(currently_selected_option: int) -> void:
	Singleton_CommonVariables.sf_game_data_node.ForceMembers[SF1_MEMBER_INDEX].inventory.remove_at(currently_selected_option)

func set_equip_state_inventory_item_at_idx(item_idx: int, equip_state: bool) -> void:
	Singleton_CommonVariables.sf_game_data_node.ForceMembers[SF1_MEMBER_INDEX].inventory[item_idx].is_equipped = equip_state

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
