extends Node2D

signal signal_battle_scene_complete

export var character_actor_animation_res: Resource
export var enemey_actor_animation_res: Resource

onready var characterSprite = $CharacterWrapper/CharacterSprite
onready var weaponSprite = $CharacterWrapper/WeaponSprite
onready var char_animationPlayer = $CharacterWrapper/AnimationPlayer

onready var enemeySprite = $EnemeyWrapper/EnemeySprite
onready var enemey_animationPlayer = $EnemeyWrapper/AnimationPlayer

const internal_animation_name: String = "A_long_random_string_is_this_even_needed"

func _ready():
	# yield(get_tree().create_timer(1), "timeout")
	
	Singleton_Game_GlobalBattleVariables.battle_scene_node = self
	# char actor
	# internal_init_resource_for_actor(characterSprite, character_actor_animation_res)
	# char_animationPlayer.add_animation(internal_animation_name, character_actor_animation_res.animation_res)
	# char_animationPlayer.play(internal_animation_name)
	
	# enemey actor
	# internal_init_resource_for_actor(enemeySprite, enemey_actor_animation_res)
	# enemey_animationPlayer.add_animation(internal_animation_name, enemey_actor_animation_res.animation_res)
	# enemey_animationPlayer.play(internal_animation_name)
	
	# setup_character_and_enemey_sprites_idle()
	# setup_actor_attacking()
	
	char_animationPlayer.connect("animation_finished", self, "s_cleanup_animation")
	
	pass



func setup_character_and_enemey_sprites_idle() -> void:
	var hans_attack = load("res://SF1/Characters/Hans/BattleAnimations/AttackNormal/AttackNormal.tres")
	internal_init_resource_for_actor(characterSprite, hans_attack)
	
	# TODO: create function in chracter base to automatically pass back the equipped item
	var weapon_res = load("res://SF1/Items/Weapons/WoodenArrow.tres") # Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").inventory_items_id[0]
	internal_init_weapon_for_actor(weaponSprite, weapon_res)


func internal_init_weapon_for_actor(weaponSprite_arg, weapon_res) -> void:
	weaponSprite_arg.texture = weapon_res.battle_texture
	

func internal_init_resource_for_actor(actorSprite, actor_animation_res) -> void:
	actorSprite.texture = actor_animation_res.actor_animation_texture
	actorSprite.region_enabled = actor_animation_res.use_sub_area
	
	actorSprite.hframes = actor_animation_res.hframes
	actorSprite.vframes = actor_animation_res.vframes
	
	# print(actor_animation_res.use_sub_area)
	if actor_animation_res.use_sub_area:
		# print(actor_animation_res.use_sub_area)
		actorSprite.region_rect.position.x = actor_animation_res.rect_position_x_offset
		actorSprite.region_rect.position.y = actor_animation_res.rect_position_y_offset
		actorSprite.region_rect.size.x = actor_animation_res.rect_position_x_size
		actorSprite.region_rect.size.y = actor_animation_res.rect_position_y_size


func setup_actor_attacking() -> void:
	var ani = load("res://SF1/Characters/Hans/BattleAnimations/AttackNormal/AttackNormal.anim")
	char_animationPlayer.add_animation(internal_animation_name, ani)
	char_animationPlayer.play(internal_animation_name)


func s_cleanup_animation(animation_name_arg) -> void:
	# print("Animation Name - ", animation_name_arg)
	char_animationPlayer.remove_animation(internal_animation_name)
	emit_signal("signal_battle_scene_complete")
