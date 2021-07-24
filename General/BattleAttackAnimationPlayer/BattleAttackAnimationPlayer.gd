tool
extends Node2D

signal signal_battle_scene_complete

signal signal_battle_complete_damage_step

signal signal_attack_frame_reached

export var reset_scene: bool = false setget internal_reset_all_actor_sprites_back_to_default_position

var rng = RandomNumberGenerator.new()

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
	char_animationPlayer.remove_animation("AttackNormal")
	
	self.connect("signal_attack_frame_reached", self, "s_update_ui_and_animate_damage_phase")
	# black_fade_anim_in()
	
	internal_reset_all_actor_sprites_back_to_default_position()
	
	pass



func setup_character_and_enemey_sprites_idle() -> void:
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
	setup_sprite_textures()
	black_fade_anim_out()
	move_wrappers_into_position()
	
	Singleton_Game_AudioManager.play_music("res://Assets/SF1/SoundBank/Battle Encounter.mp3")
	yield(get_tree().create_timer(1), "timeout")
	
	# load text box saying x is attacking or doing y to z
	print_who_is_attacking()
	
	yield(get_tree().create_timer(1), "timeout")
	
	setup_attacking_animation()
	
	# on the yield end
	# show the damage box exp and coins if eneemy killed
	
	
	
	# or whatever the appriotate message is
	
	# Singleton_Game_AudioManager.play("res://Assets/SF1/SoundBank/Battle Encounter.mp3")


func s_cleanup_animation(animation_name_arg) -> void:
	# print("Animation Name - ", animation_name_arg)
	
	yield(self, "signal_battle_complete_damage_step")
	
	char_animationPlayer.remove_animation(internal_animation_name)
	
	# yield(get_tree().create_timer(1), "timeout")
	
	
	
	# print_damage_done_to(damage)
	
	yield(get_tree().create_timer(1), "timeout")
	black_fade_anim_out()
	print("Complete Battle Scene")
	
	internal_reset_all_actor_sprites_back_to_default_position()
	
	emit_signal("signal_battle_scene_complete")

func s_update_ui_and_animate_damage_phase() -> void:
	print("\n\n\n Signal Recieved \n\n\n")
	
	calculate_damage_step()
	# yield(self, "signal_battle_complete_damage_step")

func calculate_damage_step() -> void:
	var enemeyRoot = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot")
	var characterRoot = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	
	# max attack value
	var max_damage = characterRoot.get_attack() - enemeyRoot.defense
	if max_damage <= 0:
		max_damage = 1
	
	# min attack value
	var min_damage = floor(max_damage - floor(max_damage * 0.25))
	
	rng.randomize()
	
	var damage = rng.randi_range(max_damage, min_damage)
	if damage <= 0:
		damage = 1
	
	if enemeyRoot.HP_Current - damage <= 0:
		enemeyRoot.HP_Current = 0
	else:
		enemeyRoot.HP_Current -= damage
		
	print(characterRoot.get_attack(), enemeyRoot.defense)
	
	# yield(get_tree().create_timer(1), "timeout")
	Singleton_Game_GlobalBattleVariables.battle_base.targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_selected_actor)
	print_damage_done_to(damage)
	
	yield(get_tree().create_timer(1), "timeout")
	print_exp_gain(damage)
	
	# Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play("Hit for " + str(damage))
	# yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	
	
	print("Complete Damage Step")
	emit_signal("signal_battle_complete_damage_step")
	# return damage

# func calculate_damage_range():
#	pass


func internal_reset_all_actor_sprites_back_to_default_position(arg = null):
	print("Reseting Scene")
	get_node("BackgroundWrapper").position = Vector2(0, 0)
	
	get_node("CharacterWrapper").position = Vector2(0, 0)
	get_node("CharacterWrapper").get_node("CharacterSprite").position = Vector2(240, 92)
	get_node("CharacterWrapper").get_node("WeaponSprite").position =  Vector2(214, 108)
	get_node("CharacterWrapper").get_node("WeaponSprite").rotation_degrees = 0
	
	get_node("EnemeyWrapper").position = Vector2(0, 0)
	get_node("EnemeyWrapper").get_node("EnemeySprite").position = Vector2(80, 86)


func setup_sprite_textures() -> void:
	var enemeyRoot = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot")
	var characterRoot = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	
	internal_init_resource_for_actor(enemeySprite, enemeyRoot.battle_animation_resource)
	if enemeyRoot.battle_animation_resource.animation_res_idle != null:
		enemey_animationPlayer.add_animation("Enemey Idle", enemeyRoot.battle_animation_resource.animation_res_idle)
		enemey_animationPlayer.play("Enemey Idle")
	else:
		enemey_animationPlayer.stop()
	
	internal_init_resource_for_actor(characterSprite, characterRoot.battle_animation_unpromoted_resource)
	if characterRoot.battle_animation_unpromoted_resource.animation_res_idle != null:
		char_animationPlayer.add_animation("Character Idle", characterRoot.battle_animation_unpromoted_resource.animation_res_idle)
		char_animationPlayer.play("Character Idle")
	else:
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
	

func print_who_is_attacking() -> void:
	var active_actor = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(active_actor.cget_actor_name() + " Attacks!")
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	
	pass


func print_damage_done_to(damage_arg) -> void:
	var selected_actor = Singleton_Game_GlobalBattleVariables.currently_selected_actor.get_node("EnemeyRoot")
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		"Inflicts " + str(damage_arg) + " points of damage on the " + selected_actor.enemey_name
		)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	
	pass


func print_exp_gain(damage_arg) -> void:
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
	
	var exp_gain = x + y
	if exp_gain >= 48:
		exp_gain = 48
	elif exp_gain <= 1:
		exp_gain = 1
	
	print("EXP Gain numbers ", x, " ", y, " ", exp_gain)
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.battle_message_play(
		active_actor.cget_actor_name() + " gains " + str(exp_gain) + " experience points."
		)
	yield(Singleton_Game_GlobalBattleVariables.dialogue_box_node, "signal_dialogue_completed")
	
	active_actor.experience_points += exp_gain
	if active_actor.experience_points >= 100:
		active_actor.experience_points = 0
		active_actor.level += 1
		
		print("TODO print level up and stat gain")
	
	pass

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


func internal_signal_attack_frame_reached() -> void:
	print("\n\n\n Signal Reached - signal_attack_frame_reached\n\n\n")
	emit_signal("signal_attack_frame_reached")
	
func print_lots() -> void:
	print("hi")
	print("hi")
	print("hi")
	print("hi")
	print("hi")
	print("hi")
	print("hi")
	print("hi")
	print("hi")
