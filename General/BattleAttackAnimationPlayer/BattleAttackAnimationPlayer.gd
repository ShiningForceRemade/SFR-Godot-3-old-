tool
extends Node2D

signal signal_battle_scene_complete

export var reset_scene: bool = false setget internal_reset_all_actor_sprites_back_to_default_position

export var character_actor_animation_res: Resource
export var enemey_actor_animation_res: Resource

onready var backgroundTween = $BackgroundTween
onready var backgroundWrapper = $BackgroundWrapper

onready var characterSprite = $CharacterWrapper/CharacterSprite
onready var weaponSprite = $CharacterWrapper/WeaponSprite
onready var char_animationPlayer = $CharacterWrapper/AnimationPlayer
onready var characterWrapperTween = $CharacterWrapperTween
onready var characterWrapper = $CharacterWrapper

onready var enemeySprite = $EnemeyWrapper/EnemeySprite
onready var enemey_animationPlayer = $EnemeyWrapper/AnimationPlayer
onready var enemeyWrapperTween = $EnemeyWrapperTween
onready var enemeyWrapper = $EnemeyWrapper

const internal_animation_name: String = "A_long_random_string_is_this_even_needed"

func _ready():
	# yield(get_tree().create_timer(1), "timeout")
	clear_black_fade()
	
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
	
	# black_fade_anim_in()
	
	pass



func setup_character_and_enemey_sprites_idle() -> void:
	var anim_aup = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").attack_normal_animation_unpromoted
	var attack_anim = anim_aup # load(anim_aup)
	internal_init_resource_for_actor(characterSprite, attack_anim)
	
	# TODO: create function in chracter base to automatically pass back the equipped item
	var weapon_res = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").inventory_items_id[0] # load("res://SF1/Items/Weapons/WoodenArrow.tres") # Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").inventory_items_id[0]
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
	black_fade_anim_out()
	move_wrappers_into_position()
	
	# load text box saying x is attacking or doing y to z
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play("Rune Knight Attacks!")
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	
	var ani = load("res://SF1/Characters/Hans/BattleAnimations/AttackNormal/AttackNormal.anim")
	char_animationPlayer.add_animation(internal_animation_name, ani)
	char_animationPlayer.play(internal_animation_name)
	
	
	# on the yield end
	# show the damage box exp and coins if eneemy killed
	
	# or whatever the appriotate message is
	
	# Singleton_Game_AudioManager.play("res://Assets/SF1/SoundBank/Battle Encounter.mp3")


func s_cleanup_animation(animation_name_arg) -> void:
	# print("Animation Name - ", animation_name_arg)
	char_animationPlayer.remove_animation(internal_animation_name)
	
	Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot").HP_Current = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot").HP_Current - 5
	# Singleton_Game_GlobalBattleVariables.battle_base.
	
	Singleton_Game_GlobalBattleVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
	
	yield(get_tree().create_timer(0.3), "timeout")
	
	# test_damage()
	
	emit_signal("signal_battle_scene_complete")

func test_damage() -> void:
	pass

func internal_reset_all_actor_sprites_back_to_default_position(arg = null):
	print("Reseting Scene")
	get_node("BackgroundWrapper").position = Vector2(0, 0)
	
	get_node("CharacterWrapper").position = Vector2(0, 0)
	get_node("CharacterWrapper").get_node("CharacterSprite").position = Vector2(240, 92)
	get_node("CharacterWrapper").get_node("WeaponSprite").position =  Vector2(214, 108)
	get_node("CharacterWrapper").get_node("WeaponSprite").rotation_degrees = 0
	
	get_node("EnemeyWrapper").position = Vector2(0, 0)
	get_node("EnemeyWrapper").get_node("EnemeySprite").position = Vector2(80, 86)


###
# Black Color Fader helpers
###

func clear_black_fade() -> void:
	$CanvasLayer/BlackFadeColorRect.modulate = Color(255, 255, 255, 0)

func black_fade_anim_in() -> void:
	$CanvasLayer/BlackFadeColorRect.show()
	
	$CanvasLayer/BlackFadeTween.interpolate_property($CanvasLayer/BlackFadeColorRect, "modulate:a",
	0.0, 1.0, 
	0.75, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	$CanvasLayer/BlackFadeTween.start()


func black_fade_anim_out() -> void:
	$CanvasLayer/BlackFadeColorRect.show()
	
	$CanvasLayer/BlackFadeTween.interpolate_property($CanvasLayer/BlackFadeColorRect, "modulate:a",
	1.0, 0.0, 
	0.75, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	$CanvasLayer/BlackFadeTween.start()


###
# Move wrappers into position on battle scene start 
# helpers
###

func move_wrappers_into_position() -> void:
	setup_background_wrapper_tween()
	setup_character_wrapper_tween()
	setup_enemey_wrapper_tween()
	
	backgroundTween.start()
	characterWrapperTween.start()
	enemeyWrapperTween.start()
	

func setup_background_wrapper_tween() -> void:
	backgroundTween.interpolate_property(backgroundWrapper, "position",
	Vector2(40, 0), Vector2(0, 0), 0.625, Tween.TRANS_LINEAR, Tween.EASE_IN)

func setup_character_wrapper_tween() -> void:
	characterWrapperTween.interpolate_property(characterWrapper, "position",
	Vector2(60, 0), Vector2(0, 0), 0.625, Tween.TRANS_LINEAR, Tween.EASE_IN)

func setup_enemey_wrapper_tween() -> void:
	enemeyWrapperTween.interpolate_property(enemeyWrapper, "position",
	Vector2(-40, 0), Vector2(0, 0), 0.625, Tween.TRANS_LINEAR, Tween.EASE_IN)
