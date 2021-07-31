tool
extends Node2D

signal signal_battle_scene_complete

signal signal_battle_complete_damage_step
signal signal_exp_phase_is_over

signal signal_attack_frame_reached
signal signal_enemey_attack_frame_reached

export var reset_scene: bool = false setget internal_reset_all_actor_sprites_back_to_default_position

var rng = RandomNumberGenerator.new()

const shader_color_blend = preload("res://Shaders/ColorBlend.shader")

const shader_dissolve = preload("res://Shaders/Dissolve.shader")
const shader_texture__noise_pixelated = preload("res://Shaders/ShaderTextureImages/NoisePixelated.jpg")

export var character_actor_animation_res: Resource
export var enemey_actor_animation_res: Resource

onready var backgroundTween = $BackgroundTween
onready var backgroundWrapper = $BackgroundWrapper

onready var characterSprite = $CharacterWrapper/CharacterSprite
onready var weaponSprite = $CharacterWrapper/WeaponSprite
onready var char_animationPlayer = $CharacterWrapper/AnimationPlayer
onready var characterWrapperTween = $CharacterWrapperTween
onready var characterWrapper = $CharacterWrapper
onready var characterSpriteTween = $CharacterWrapper/CharacterSpriteTween

onready var enemeySprite = $EnemeyWrapper/EnemeySprite
onready var enemey_animationPlayer = $EnemeyWrapper/AnimationPlayer
onready var enemeyWrapperTween = $EnemeyWrapperTween
onready var enemeyWrapper = $EnemeyWrapper
onready var enemeySpriteTween = $EnemeyWrapper/EnemeySpriteTween

onready var blackFadeTween = $CanvasLayer/BlackFadeTween

const internal_animation_name: String = "A_long_random_string_is_this_even_needed"

const ani_name_enemey_idle: String = "Enemey Idle"

var using_spell: bool = false

var attack_missed = false

# TODO: CLEAN: TEMP FOR DEMO
var heal_amount = 0

func _ready():
	# yield(get_tree().create_timer(1), "timeout")
	# Singleton_Game_GlobalBattleVariables.battle_base.topLevelFader.clear_black_fade()
	
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
	char_animationPlayer.remove_animation("AttackNormal")
	
	enemey_animationPlayer.connect("animation_finished", self, "s_cleanup_animation_enemy")
	
	self.connect("signal_attack_frame_reached", self, "s_update_ui_and_animate_damage_phase")
	self.connect("signal_enemey_attack_frame_reached", self, "s_update_ui_and_animate_damage_enemey_phase")
	# internal_signal_enemey_attack_frame_reached()
	# black_fade_anim_in()
	
	enemeySpriteTween.connect("tween_completed", self, "s_enemey_tween_completed")
	blackFadeTween.connect("tween_completed", self, "s_cleanup_black_fade_tween")
	
	internal_reset_all_actor_sprites_back_to_default_position()
	
	pass



func setup_character_and_enemey_sprites_idle() -> void:
	Singleton_Game_GlobalBattleVariables.battle_base.topLevelFader.black_fade_anim_in()
	
	var anim_aup = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").battle_animation_unpromoted_resource
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
	using_spell = false
	
	Singleton_Game_GlobalBattleVariables.is_currently_in_battle_scene = true
	
	Singleton_Game_GlobalBattleVariables.currently_active_character.z_index = 0
	enemeySprite.material.set_shader_param("dissolve_effect_amount", 0)
	enemeySprite.show()
	characterSprite.material.set_shader_param("dissolve_effect_amount", 0)
	characterSprite.show()
	characterWrapper.show()
	
	setup_sprite_textures()
	Singleton_Game_GlobalBattleVariables.battle_base.topLevelFader.black_fade_anim_out()
	move_wrappers_into_position()
	yield(get_tree().create_timer(0.45), "timeout")
	
	Singleton_Game_AudioManager.play_alt_music_n("res://Assets/SF1/SoundBank/Battle Encounter.mp3")
	
	# Singleton_Game_AudioManager.play_music("res://Assets/SF1/SoundBank/Battle Encounter.mp3")
	
	yield(get_tree().create_timer(1), "timeout")
	
	# load text box saying x is attacking or doing y to z
	print_who_is_attacking()
	
	yield(get_tree().create_timer(1.5), "timeout")
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.hide()
	setup_attacking_animation()
	
	# on the yield end
	# show the damage box exp and coins if eneemy killed
	
	
	
	# or whatever the appriotate message is
	
	# Singleton_Game_AudioManager.play("res://Assets/SF1/SoundBank/Battle Encounter.mp3")


func setup_enemey_actor_attacking() -> void:
	using_spell = false
	
	Singleton_Game_GlobalBattleVariables.is_currently_in_battle_scene = true
	
	Singleton_Game_GlobalBattleVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_active_character)
	Singleton_Game_GlobalBattleVariables.battle_base.activeActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
	
	Singleton_Game_GlobalBattleVariables.currently_active_character.z_index = 0
	enemeySprite.material.set_shader_param("dissolve_effect_amount", 0)
	enemeySprite.show()
	characterSprite.material.set_shader_param("dissolve_effect_amount", 0)
	characterSprite.show()
	characterWrapper.show()
	
	setup_sprite_textures_enemey_attack()
	# setup_sprite_textures()
	Singleton_Game_GlobalBattleVariables.battle_base.topLevelFader.black_fade_anim_out()
	
	Singleton_Game_AudioManager.play_alt_music_n("res://Assets/SF1/SoundBank/Battle Encounter.mp3")
	
	move_wrappers_into_position()
	
	# Singleton_Game_AudioManager.play_music("res://Assets/SF1/SoundBank/Battle Encounter.mp3")
	
	yield(get_tree().create_timer(0.45), "timeout")
	
	# load text box saying x is attacking or doing y to z
	print_who_is_attacking()
	
	yield(get_tree().create_timer(1.5), "timeout")
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.hide()
	setup_enemey_attacking_animation()
	
	# on the yield end
	


func setup_spell_usage() -> void:
	using_spell = true
	
	Singleton_Game_GlobalBattleVariables.is_currently_in_battle_scene = true
	
	Singleton_Game_GlobalBattleVariables.currently_active_character.z_index = 0
	enemeySprite.material.set_shader_param("dissolve_effect_amount", 0)
	enemeySprite.show()
	characterSprite.material.set_shader_param("dissolve_effect_amount", 0)
	characterSprite.show()
	characterWrapper.show()
	
	setup_sprite_textures()
	Singleton_Game_GlobalBattleVariables.battle_base.topLevelFader.black_fade_anim_out()
	Singleton_Game_AudioManager.play_alt_music_n("res://Assets/SF1/SoundBank/Battle Encounter.mp3")
	
	move_wrappers_into_position()
	
	# Singleton_Game_AudioManager.play_music("res://Assets/SF1/SoundBank/Battle Encounter.mp3")
	yield(get_tree().create_timer(0.45), "timeout")
	# load text box saying x is attacking or doing y to z
	# print_who_is_attacking()
	
	print_spell_usage()
	
	yield(get_tree().create_timer(1.5), "timeout")
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.hide()
	setup_spell_animation()


func s_cleanup_animation(animation_name_arg) -> void:
	# print("Animation Name - ", animation_name_arg)
	
	yield(self, "signal_battle_complete_damage_step")
	
	char_animationPlayer.remove_animation(internal_animation_name)
	
	# yield(get_tree().create_timer(1), "timeout")
	
	
	
	# print_damage_done_to(damage)
	
	# black_fade_anim_out()
	# yield(get_tree().create_timer(0.5), "timeout")
	# black_fade_anim_out()
	print("Complete Battle Scene")
	
	internal_reset_all_actor_sprites_back_to_default_position()
	
	Singleton_Game_GlobalBattleVariables.currently_active_character.z_index = 0
	# Singleton_Game_AudioManager.pause_all_music()
	
	Singleton_Game_AudioManager.stop_alt_music_n()
	
	Singleton_Game_GlobalBattleVariables.target_selection_node.target_range.cleanup_cursor()	
	emit_signal("signal_battle_scene_complete")
	



func s_cleanup_animation_enemy(animation_name_arg) -> void:
	# print("Animation Name - ", animation_name_arg)
	
	yield(self, "signal_battle_complete_damage_step")
	
	char_animationPlayer.remove_animation(internal_animation_name)
	
	# black_fade_anim_out()
	# yield(get_tree().create_timer(0.5), "timeout")
	# yield(get_tree().create_timer(1), "timeout")
	# black_fade_anim_out()
	print("Complete Battle Scene")
	
	internal_reset_all_actor_sprites_back_to_default_position()
	
	Singleton_Game_GlobalBattleVariables.currently_active_character.z_index = 1
	# Singleton_Game_AudioManager.pause_all_music()
	
	# Singleton_Game_GlobalBattleVariables.target_selection_node.target_range.cleanup_cursor()
	
	Singleton_Game_AudioManager.stop_alt_music_n()
	
	Singleton_Game_GlobalBattleVariables.target_selection_node.target_range.cleanup_cursor()
	emit_signal("signal_battle_scene_complete")
	


func s_update_ui_and_animate_damage_phase() -> void:
	print("\n\n\n Signal Recieved \n\n\n")
	
	calculate_damage_step()
	
	yield(self, "signal_battle_complete_damage_step")


func s_update_ui_and_animate_damage_enemey_phase() -> void:
	print("\n\n\n Signal Recieved \n\n\n")
	
	calculate_damage_step_enemey_attacking()
	
	yield(self, "signal_battle_complete_damage_step")

func calculate_damage_step() -> void:
	var enemeyRoot = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot")
	var characterRoot = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	
	var is_critical_hit = false
	rng.randomize()
	if rng.randi_range(0, 99) < 10:
		Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/CriticalSound.wav")
		is_critical_hit = true
		# char_animationPlayer.stop(false)
		# yield(get_tree().create_timer(1), "timeout")
		# char_animationPlayer.play()
	
	var damage = 0
	
	if using_spell:
		var damage_min = characterRoot.spells_id[0].levels[0].min_range
		var damage_max = characterRoot.spells_id[0].levels[0].max_range
		var mp_cost = characterRoot.spells_id[0].levels[0].mp_usage_cost
		
		rng.randomize()
	
		damage = rng.randi_range(damage_max, damage_min)
		if damage <= 0:
			damage = 1
		
		characterRoot.MP_Current -= mp_cost
		Singleton_Game_GlobalBattleVariables.battle_base.activeActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_active_character)
	else:
		# max attack value
		var max_damage = characterRoot.get_attack() - enemeyRoot.defense
		if max_damage <= 0:
			max_damage = 1
	
		# min attack value
		var min_damage = floor(max_damage - floor(max_damage * 0.25))
	
		rng.randomize()
		
		damage = rng.randi_range(max_damage, min_damage)
		if damage <= 0:
			damage = 1
		
		if is_critical_hit:
			damage = floor(damage * 1.5)
		
		if attack_missed:
			damage = 0
	
	
	if enemeyRoot.HP_Current - damage <= 0:
		enemeyRoot.HP_Current = 0
	else:
		enemeyRoot.HP_Current -= damage
		
	print(characterRoot.get_attack(), enemeyRoot.defense)
	
	# yield(get_tree().create_timer(1), "timeout")
	Singleton_Game_GlobalBattleVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
	
	# print("\n\n\n", enemeySprite.material.get_shader_param("color_blend_target"))
	
	if not attack_missed:
		enemeySprite.material.shader = shader_color_blend
		enemeySprite.material.set_shader_param("blend_strength_modifier", 0.35)
	
		# TODO: generate the movement and timings randomly 
		# using fixed animation to simulate the shake for the demo
		enemey_animationPlayer.add_animation("shake", load("res://General/Animations/EnemeyShake.anim"))
		enemey_animationPlayer.play("shake")
	
		yield(get_tree().create_timer(1), "timeout")
		if is_critical_hit:
			print_critical_damage_done_to(damage)
		else:
			print_damage_done_to(damage)
	else:
		yield(get_tree().create_timer(1), "timeout")
		print_enemey_actor_evaded()
	
	if characterRoot.battle_animation_unpromoted_resource.animation_res_idle != null:
		char_animationPlayer.add_animation("Character Idle", characterRoot.battle_animation_unpromoted_resource.animation_res_idle)
		char_animationPlayer.play("Character Idle")
		
	enemeySprite.material.set_shader_param("blend_strength_modifier", 0.0)
	enemey_animationPlayer.stop()
	
	if enemeyRoot.HP_Current == 0:
		enemey_defeated_play_dissolve_animation()
		yield(get_tree().create_timer(1), "timeout")
		print_actor_defeated()
	elif enemeyRoot.battle_animation_resource.animation_res_idle != null:
		enemey_animationPlayer.add_animation(ani_name_enemey_idle, enemeyRoot.battle_animation_resource.animation_res_idle)
		enemey_animationPlayer.play(ani_name_enemey_idle)
	# enemey_animationPlayer.play(ani_name_enemey_idle)
	
	yield(get_tree().create_timer(1), "timeout")
	print_exp_gain(damage)
	yield(self, "signal_exp_phase_is_over")
	
	if enemeyRoot.HP_Current == 0:
		yield(get_tree().create_timer(1), "timeout")
		print_coins_and_items_receieved() # 0 coins and no items for now
		# yield(get_tree().create_timer(1.5), "timeout")
	
	yield(get_tree().create_timer(1.5), "timeout")
	
	# Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play("Hit for " + str(damage))
	# yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	
	Singleton_Game_GlobalBattleVariables.currently_active_character.z_index = 0
	Singleton_Game_GlobalBattleVariables.currently_selected_actor.z_index = 0
	
	Singleton_Game_GlobalBattleVariables.battle_base.topLevelFader.black_fade_anim_in()
	yield(get_tree().create_timer(0.5), "timeout")
	print("Complete Damage Step")
	emit_signal("signal_battle_complete_damage_step")
	Singleton_Game_GlobalBattleVariables.battle_base.topLevelFader.black_fade_anim_out()
	
	Singleton_Game_GlobalBattleVariables.is_currently_in_battle_scene = false
	
	yield(get_tree().create_timer(0.5), "timeout")
	# return damage


func calculate_damage_step_enemey_attacking() -> void:
	var is_critical_hit = false
	
	rng.randomize()
	if rng.randi_range(0, 99) < 10:
		Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/CriticalSound.wav")
		is_critical_hit = true
		
		
	# Singleton_Game_GlobalBattleVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_active_character)
	
	var enemeyRoot = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("EnemeyRoot")
	var characterRoot = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("CharacterRoot")
	
	var damage = 0
	
	# max attack value
	var max_damage = enemeyRoot.get_attack() - characterRoot.defense
	if max_damage <= 0:
		max_damage = 1
	
	# min attack value
	var min_damage = floor(max_damage - floor(max_damage * 0.25))
	
	damage = rng.randi_range(max_damage, min_damage)
	if damage <= 0:
		damage = 1
	if is_critical_hit:
		damage = floor(damage * 1.5)
	
	if attack_missed:
		damage = 0
	
	if characterRoot.HP_Current - damage <= 0:
		characterRoot.HP_Current = 0
	else:
		characterRoot.HP_Current -= damage
		
	print(enemeyRoot.get_attack(), characterRoot.defense)
	
	# yield(get_tree().create_timer(1), "timeout")
	# Singleton_Game_GlobalBattleVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
	
	Singleton_Game_GlobalBattleVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_active_character)
	Singleton_Game_GlobalBattleVariables.battle_base.activeActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
	
	# print("\n\n\n", enemeySprite.material.get_shader_param("color_blend_target"))
	
	# enemeySprite.material.shader = shader_color_blend
	# enemeySprite.material.set_shader_param("blend_strength_modifier", 0.35)
	
	# TODO: generate the movement and timings randomly 
	# using fixed animation to simulate the shake for the demo
	# enemey_animationPlayer.add_animation("shake", load("res://General/Animations/EnemeyShake.anim"))
	# enemey_animationPlayer.play("shake")
	
	# yield(get_tree().create_timer(1), "timeout")
	if not attack_missed:
		characterSprite.material.shader = shader_color_blend
		characterSprite.material.set_shader_param("blend_strength_modifier", 0.35)
	
		# TODO: generate the movement and timings randomly 
		# using fixed animation to simulate the shake for the demo
		char_animationPlayer.add_animation("shake", load("res://General/Animations/EnemeyShake.anim"))
		char_animationPlayer.play("shake")
		
		if is_critical_hit:
			print_enemey_critical_damage_done_to(damage)
		else:
			print_enemey_damage_done_to(damage)
	else:
		print_character_actor_evaded()
	
	yield(get_tree().create_timer(1), "timeout")
	
	if enemeyRoot.battle_animation_resource.animation_res_idle != null:
		enemey_animationPlayer.add_animation(ani_name_enemey_idle, enemeyRoot.battle_animation_resource.animation_res_idle)
		enemey_animationPlayer.play(ani_name_enemey_idle)
		
	characterSprite.material.set_shader_param("blend_strength_modifier", 0.0)
	char_animationPlayer.stop()
	
	if characterRoot.HP_Current == 0:
		character_defeated_play_dissolve_animation()
		print_char_actor_defeated()
		yield(get_tree().create_timer(1), "timeout")
		characterWrapper.hide()
	elif characterRoot.battle_animation_unpromoted_resource.animation_res_idle != null:
		char_animationPlayer.add_animation("Character Idle", characterRoot.battle_animation_unpromoted_resource.animation_res_idle)
		char_animationPlayer.play("Character Idle")
	
	yield(get_tree().create_timer(1), "timeout")
	
	# Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play("Hit for " + str(damage))
	# yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	
	Singleton_Game_GlobalBattleVariables.currently_active_character.z_index = 0
	Singleton_Game_GlobalBattleVariables.currently_selected_actor.z_index = 0
	
	Singleton_Game_GlobalBattleVariables.battle_base.topLevelFader.black_fade_anim_in()
	print("Complete Damage Step")
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("signal_battle_complete_damage_step")
	# yield(get_tree().create_timer(0.25), "timeout")
	# Singleton_Game_GlobalBattleVariables.battle_base.topLevelFader.black_fade_anim_out()
	characterWrapper.show()
	#Singleton_Game_GlobalBattleVariables.battle_base.topLevelFader.black_fade_anim_out()
	# yield(get_tree().create_timer(0.65), "timeout")
	Singleton_Game_GlobalBattleVariables.is_currently_in_battle_scene = false
	
	# return damage





# func calculate_damage_range():
#	pass

func enemey_defeated_play_dissolve_animation() -> void:
	enemeySprite.material.shader = shader_dissolve 
	enemeySprite.material.set_shader_param("dissolve_effect_amount", 0.3)
	enemeySprite.material.set_shader_param("noise_texture", shader_texture__noise_pixelated)
	
	enemeySpriteTween.interpolate_property(enemeySprite.material, "shader_param/dissolve_effect_amount",
	0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	enemeySpriteTween.start()
	
	yield(get_tree().create_timer(1.5), "timeout")


func character_defeated_play_dissolve_animation() -> void:
	characterSprite.material.shader = shader_dissolve 
	characterSprite.material.set_shader_param("dissolve_effect_amount", 0.3)
	characterSprite.material.set_shader_param("noise_texture", shader_texture__noise_pixelated)
	
	characterSpriteTween.interpolate_property(characterSprite.material, "shader_param/dissolve_effect_amount",
	0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	characterSpriteTween.start()
	
	yield(get_tree().create_timer(1.5), "timeout")

func s_enemey_tween_completed(arg_1, arg_2) -> void:
	
	# print("\n\n\n", arg_1, " ", arg_2)
	
	enemeySprite.hide()
	
	# enemeySprite.material.set_shader_param("dissolve_effect_amount", 0)


func internal_reset_all_actor_sprites_back_to_default_position(arg = null):
	print("Reseting Scene")
	self.modulate = Color("#ffffff")
	get_node("CanvasLayerSpellWrapper").get_node("SpellWrapper").hide()
	
	get_node("BackgroundWrapper").position = Vector2(0, 0)
	
	get_node("BackgroundBlackColorRect").color = Color(0, 0, 0, 255)
	
	get_node("CharacterWrapper").position = Vector2(0, 0)
	get_node("CharacterWrapper").get_node("CharacterSprite").position = Vector2(240, 92)
	get_node("CharacterWrapper").get_node("WeaponSprite").position =  Vector2(214, 108)
	get_node("CharacterWrapper").get_node("WeaponSprite").rotation_degrees = 0
	
	get_node("EnemeyWrapper").position = Vector2(0, 0)
	get_node("EnemeyWrapper").get_node("EnemeySprite").position = Vector2(80, 86)


func setup_sprite_textures() -> void:
	var enemeyRoot = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot")
	var characterRoot = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	
	if enemeyRoot != null:
		enemeyWrapper.show()
		internal_init_resource_for_actor(enemeySprite, enemeyRoot.battle_animation_resource)
		if enemeyRoot.battle_animation_resource.animation_res_idle != null:
			enemey_animationPlayer.add_animation(ani_name_enemey_idle, enemeyRoot.battle_animation_resource.animation_res_idle)
			enemey_animationPlayer.play(ani_name_enemey_idle)
		else:
			if enemeyRoot.battle_animation_resource.animation_res_attack != null:
				enemey_animationPlayer.add_animation(ani_name_enemey_idle, enemeyRoot.battle_animation_resource.animation_res_attack)
				enemey_animationPlayer.play(ani_name_enemey_idle)
				enemey_animationPlayer.seek(0, true)
				enemey_animationPlayer.stop()
			else:
				enemey_animationPlayer.stop()
	else:
		enemeyWrapper.hide()
	
	internal_init_resource_for_actor(characterSprite, characterRoot.battle_animation_unpromoted_resource)
	if characterRoot.battle_animation_unpromoted_resource.animation_res_idle != null:
		char_animationPlayer.add_animation("Character Idle", characterRoot.battle_animation_unpromoted_resource.animation_res_idle)
		char_animationPlayer.play("Character Idle")
	else:
		char_animationPlayer.add_animation("Character Idle", characterRoot.battle_animation_unpromoted_resource.animation_res_attack)
		# seek first frame of attack to prevent odd positioning of other sprites
		char_animationPlayer.play("Character Idle")
		char_animationPlayer.seek(0.1, true)
		char_animationPlayer.stop()
	
	for i in range(characterRoot.inventory_items_id.size()):
		if characterRoot.is_item_equipped[i]:
			if characterRoot.inventory_items_id[i] is CN_SF1_Item_Weapon:
				weaponSprite.texture = characterRoot.inventory_items_id[i].battle_texture
				break
	
	pass


func setup_sprite_textures_enemey_attack() -> void:
	var enemeyRoot = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("EnemeyRoot")
	var characterRoot = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("CharacterRoot")
	
	if enemeyRoot != null:
		enemeyWrapper.show()
		internal_init_resource_for_actor(enemeySprite, enemeyRoot.battle_animation_resource)
		if enemeyRoot.battle_animation_resource.animation_res_idle != null:
			enemey_animationPlayer.add_animation(ani_name_enemey_idle, enemeyRoot.battle_animation_resource.animation_res_idle)
			enemey_animationPlayer.play(ani_name_enemey_idle)
		else:
			if enemeyRoot.battle_animation_resource.animation_res_attack != null:
				enemey_animationPlayer.add_animation(ani_name_enemey_idle, enemeyRoot.battle_animation_resource.animation_res_attack)
				enemey_animationPlayer.play(ani_name_enemey_idle)
				enemey_animationPlayer.seek(0, true)
				enemey_animationPlayer.stop()
			else:
				enemey_animationPlayer.stop()
	else:
		enemeyWrapper.hide()
	
	internal_init_resource_for_actor(characterSprite, characterRoot.battle_animation_unpromoted_resource)
	if characterRoot.battle_animation_unpromoted_resource.animation_res_idle != null:
		char_animationPlayer.add_animation("Character Idle", characterRoot.battle_animation_unpromoted_resource.animation_res_idle)
		char_animationPlayer.play("Character Idle")
	else:
		char_animationPlayer.add_animation("Character Idle", characterRoot.battle_animation_unpromoted_resource.animation_res_attack)
		# seek first frame of attack to prevent odd positioning of other sprites
		char_animationPlayer.play("Character Idle")
		char_animationPlayer.seek(0.1, true)
		char_animationPlayer.stop()
	
	for i in range(characterRoot.inventory_items_id.size()):
		if characterRoot.is_item_equipped[i]:
			if characterRoot.inventory_items_id[i] is CN_SF1_Item_Weapon:
				weaponSprite.texture = characterRoot.inventory_items_id[i].battle_texture
				break
	
	pass



func setup_attacking_animation() -> void:
	var characterRoot = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	
	# internal_init_resource_for_actor(characterSprite, characterRoot.battle_animation_unpromoted_resource)
	if characterRoot.battle_animation_unpromoted_resource.animation_res_attack != null:
		char_animationPlayer.add_animation("Character Attack", characterRoot.battle_animation_unpromoted_resource.animation_res_attack)
		char_animationPlayer.play("Character Attack")
	else:
		char_animationPlayer.stop()
	


func setup_enemey_attacking_animation() -> void:
	var activeActorRoot = Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal() # ENemeyRoot
	
	# internal_init_resource_for_actor(characterSprite, characterRoot.battle_animation_unpromoted_resource)
	if activeActorRoot.battle_animation_resource.animation_res_attack != null:
		enemey_animationPlayer.add_animation("Enemey Attack", activeActorRoot.battle_animation_resource.animation_res_attack)
		enemey_animationPlayer.play("Enemey Attack")
	else:
		enemey_animationPlayer.stop()
	


func setup_spell_animation() -> void:
	var characterRoot = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	var sar = characterRoot.spells_id[0].spell_animation_resource
	
	$CanvasLayerSpellWrapper/SpellWrapper/Sprite.texture = sar.primary_animation_texture
	$CanvasLayerSpellWrapper/SpellWrapper/Sprite.hframes = sar.hframes
	$CanvasLayerSpellWrapper/SpellWrapper.show()
	
	char_animationPlayer.add_animation("Character Attack", characterRoot.battle_animation_unpromoted_resource.animation_res_attack)
	char_animationPlayer.play("Character Attack")
	
	$CanvasLayerSpellWrapper/SpellWrapper/AnimationPlayer.add_animation("Character Spell", sar.animation_res)
	$CanvasLayerSpellWrapper/SpellWrapper/AnimationPlayer.play("Character Spell")



func print_who_is_attacking() -> void:
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.show()
	var active_actor = Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal() # get_node("CharacterRoot")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(active_actor.cget_actor_name() + " Attacks!")
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	
	pass

func print_spell_usage() -> void:
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.show()
	var active_actor = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(active_actor.cget_actor_name() + " Attacks!")
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		active_actor.cget_actor_name() + " casts " + active_actor.spells_id[0].name + " level 1."
		)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	
	pass


func print_enemey_actor_evaded() -> void:
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.show()
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		selected_actor.enemey_name + " evades the attack!"
		)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")

func print_damage_done_to(damage_arg) -> void:
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.show()
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		"Inflicts " + str(damage_arg) + " points of damage on the " + selected_actor.enemey_name + "."
		)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")


func print_critical_damage_done_to(damage_arg) -> void:
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.show()
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		"A stunning attack! " + selected_actor.enemey_name + " suffers " + str(damage_arg) + " points of damage."
		)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")


func print_character_actor_evaded() -> void:
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.show()
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("CharacterRoot")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		selected_actor.cget_actor_name() + " evaded the attack!"
		)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")


func print_enemey_damage_done_to(damage_arg) -> void:
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.show()
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("CharacterRoot")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		"Inflicts " + str(damage_arg) + " points of damage to " + selected_actor.cget_actor_name() + "."
		)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")

func print_enemey_critical_damage_done_to(damage_arg) -> void:
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.show()
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("CharacterRoot")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		"A stunning attack! " + selected_actor.cget_actor_name() + " suffers " + str(damage_arg) + " points of damage."
		)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")




func print_exp_gain(damage_arg) -> void:
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.show()
	var active_actor = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot")
	
	var x = 2 * ((selected_actor.effective_level - active_actor.level) + 3)
	var y = (x * damage_arg) / selected_actor.HP_Total
	if y <= 1:
		y = 1
	elif y >= 48:
		y = 48
	
	if selected_actor.HP_Current == 0:
		x += (x * 3) + 1 # bonus exp for kill based on x max
	
	var exp_gain = floor(x + y)
	if damage_arg == 0:
		exp_gain = 1
	
	if exp_gain >= 48:
		exp_gain = 48
	elif exp_gain <= 1:
		exp_gain = 1
	
	print("EXP Gain numbers ", x, " ", y, " ", exp_gain)
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		active_actor.cget_actor_name() + " gains " + str(exp_gain) + " experience points."
		)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	yield(get_tree().create_timer(1), "timeout")
	
	active_actor.experience_points += exp_gain
	if active_actor.experience_points >= 100:
		active_actor.experience_points = 0
		active_actor.level += 1
		
		Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		active_actor.cget_actor_name() + "'s level increases to " + str(active_actor.level) + "!"
		)
		yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
		yield(get_tree().create_timer(1), "timeout")
		print("TODO: generate stat gain and print based on character stat curves")
	
	emit_signal("signal_exp_phase_is_over")
	pass

func print_actor_defeated() -> void:
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot")
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		selected_actor.enemey_name + " is defeated!"
	)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	


func print_char_actor_defeated() -> void:
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("CharacterRoot")
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		selected_actor.cget_actor_name() + " can fight no longer."
	)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	

func print_coins_and_items_receieved() -> void:
	var active_actor = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot")
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		# active_actor.cget_actor_name() + " gains " + str(exp_gain) + " experience points."
		active_actor.cget_actor_name() + " gains " + str(selected_actor.coins) + " coins."
	)
	
	Singleton_Game_GlobalOverworldVariables.coins += selected_actor.coins
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	


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


func play_spell_cast_sound_effect() -> void:
	if using_spell:
		Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Cast_Spell.wav")

func internal_signal_attack_frame_reached() -> void:
	print("\n\n\n Signal Reached - signal_attack_frame_reached\n\n\n")
	
	if using_spell:
		Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/HitSoundCut.wav")
	#	Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Cast_Spell.wav")
		char_animationPlayer.stop(false)
	else:
		rng.randomize()
		if rng.randi_range(0, 99) < 5:
			attack_missed = true
		else:
			attack_missed = false
			
		if attack_missed:
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/DodgeSound.wav")
			emit_signal("signal_attack_frame_reached")
		else:
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/HitSoundCut.wav")
			emit_signal("signal_attack_frame_reached")
	

func internal_signal_enemey_attack_frame_reached() -> void:
	print("\n\n\n Signal Reached - signal_attack_frame_reached\n\n\n")
	
	if using_spell:
		Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Cast_Spell.wav")
		char_animationPlayer.stop(false)
	else:
		rng.randomize()
		if rng.randi_range(0, 99) < 5:
			attack_missed = true
		else:
			attack_missed = false
		
		if attack_missed:
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/DodgeSound.wav")
			emit_signal("signal_enemey_attack_frame_reached")
		else:
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/HitSoundCut.wav")
			emit_signal("signal_enemey_attack_frame_reached")
	

func internal_signal_spell_completed() -> void:
	char_animationPlayer.play()
	emit_signal("signal_attack_frame_reached")
	
	pass
	

func internal_signal_switch_to_next_character_actor() -> void:
	$CanvasLayerSpellWrapper/SpellWrapper/AnimationPlayer.playback_speed = 1.5
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("CharacterRoot")
	
	characterWrapperTween.interpolate_property(characterWrapper, "position", 
	characterWrapper.position, Vector2(characterWrapper.position.x + 160, characterWrapper.position.y), 0.3, Tween.TRANS_LINEAR)
	characterWrapperTween.start()
	
	$CharacterTargetWrapper/CharacterSprite.texture = selected_actor.battle_animation_unpromoted_resource.actor_animation_texture
	$CharacterTargetWrapper/CharacterSprite.hframes = selected_actor.battle_animation_unpromoted_resource.hframes
	
	$CharacterTargetWrapper/WeaponSprite.texture = selected_actor.inventory_items_id[0].battle_texture
	
	$CharacterTargetWrapper/AnimationPlayer.add_animation("Target Idle", selected_actor.battle_animation_unpromoted_resource.animation_res_idle)
	$CharacterTargetWrapper/AnimationPlayer.play("Target Idle")
	
	$CharacterTargetTween.interpolate_property($CharacterTargetWrapper, "position", 
	$CharacterTargetWrapper.position, Vector2($CharacterTargetWrapper.position.x - 160, $CharacterTargetWrapper.position.y), 0.3, Tween.TRANS_LINEAR)
	$CharacterTargetTween.start()
	
	print("Switching to next cahracter Actor")
	

func internal_signal_print_recover_amount() -> void:
	var active_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("CharacterRoot")
	
	heal_amount = 10
	
	if heal_amount + active_actor.HP_Current >= active_actor.HP_Total:
		heal_amount = active_actor.HP_Total - active_actor.HP_Current
	else:
		heal_amount = 10
		
	active_actor.HP_Current += heal_amount
	
	Singleton_Game_GlobalBattleVariables.battle_base.activeActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
	
	# active_actor.HP_Current
	# active_actor.HP_Total
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.show()
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		# active_actor.cget_actor_name() + " gains " + str(exp_gain) + " experience points."
		active_actor.cget_actor_name() + " regains " + str(heal_amount) + " hit points."
	)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	
	
	print("Print Recover amount")

func internal_signal_switch_back_to_active_actor() -> void:
	var active_actor = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("CharacterRoot")
	
	characterWrapperTween.interpolate_property(characterWrapper, "position", 
	characterWrapper.position, Vector2(characterWrapper.position.x - 160, characterWrapper.position.y), 0.3, Tween.TRANS_LINEAR)
	characterWrapperTween.start()
	
	$CharacterTargetTween.interpolate_property($CharacterTargetWrapper, "position", 
	$CharacterTargetWrapper.position, Vector2($CharacterTargetWrapper.position.x + 160, $CharacterTargetWrapper.position.y), 0.3, Tween.TRANS_LINEAR)
	$CharacterTargetTween.start()
	
	print("Go back to lowe")
	
	# print_exp_gain(0)
	var exp_gain = 0
	if heal_amount == 0:
		exp_gain = 1
	else:
		exp_gain = 10
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		active_actor.cget_actor_name() + " gains " + str(exp_gain) + " experience points."
		)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	
	active_actor.MP_Current -= active_actor.spells_id[0].levels[0].mp_usage_cost
	Singleton_Game_GlobalBattleVariables.battle_base.activeActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_active_character)
	
	active_actor.experience_points += exp_gain
	if active_actor.experience_points >= 100:
		active_actor.experience_points = 0
		active_actor.level += 1
		
		print("TODO print level up and stat gain")
		
		
	print("Complete Heal Step")
	
	char_animationPlayer.remove_animation(internal_animation_name)
	$CharacterTargetWrapper/AnimationPlayer.remove_animation("Target Idle")
	
	yield(get_tree().create_timer(1.5), "timeout")
	Singleton_Game_GlobalBattleVariables.battle_base.topLevelFader.black_fade_anim_out()
	print("Complete Battle Scene")
	
	internal_reset_all_actor_sprites_back_to_default_position()
	
	Singleton_Game_GlobalBattleVariables.currently_active_character.z_index = 1
	# Singleton_Game_AudioManager.pause_all_music()
	$CanvasLayerSpellWrapper/SpellWrapper/AnimationPlayer.playback_speed = 1
	
	emit_signal("signal_battle_scene_complete")
