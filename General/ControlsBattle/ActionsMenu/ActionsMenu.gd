extends Node2D

var is_menu_active: bool =  false
var _tween: Tween

# TODO: look into something better - hard coding position values doesnt seem like the best that can be done
const default_position: Vector2 = Vector2(131, 136)
const hidden_position: Vector2 = Vector2(131, 184)

enum e_menu_options {
	ATTACK_OPTION,
	MAGIC_OPTION,
	INVENTORY_OPTION,
	STAY_OPTION,
	SEARCH_OPTION
}
var currently_selected_option: int = e_menu_options.ATTACK_OPTION

@onready var animationPlayer = $AnimationPlayer
@onready var label = $NinePatchRect/Label

@onready var attack_spirte = $AttackAction
@onready var magic_spirte = $MagicAction
@onready var inventory_spirte = $InventoryAction
@onready var stay_spirte = $StayAction
@onready var search_spirte = $SearchAction


# @onready var noValidOptionNode = get_parent().get_node("NoValidOptionWarningBoxRoot")

func _ready():
	Singleton_CommonVariables.ui__battle_action_menu = self
	set_sprites_to_zero_frame()
	# animationPlayer.speed_scale = 2
	animationPlayer.play("Attack")
	label.text = "Attack"


func set_menu_active() -> void:
	is_menu_active = true
	
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_options.ATTACK_OPTION
	animationPlayer.play("Attack")
	label.text = "Attack"

## Show Hide Normal Position

func show_cust() -> void: 
	position = hidden_position
	show()
	
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", default_position, Singleton_CommonVariables.menu_tween_time)
	_tween.set_trans(Tween.TRANS_LINEAR)


func hide_cust() -> void: 
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", hidden_position, Singleton_CommonVariables.menu_tween_time)
	_tween.set_trans(Tween.TRANS_LINEAR)
	_tween.tween_callback(hide)

##

# TODO: convert  to input when updateing to use process on and off states 
# refactor after migration
func _process(_delta):
	if !is_menu_active:
		return
		
	if Input.is_action_just_released("ui_b_key"):
		print("Cancel Battle Action Menu")
		is_menu_active = false
		Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
		await Signal(get_tree().create_timer(0.02), "timeout")
		
		# get_parent().get_parent().get_parent().s_show_battle_action_menu("down")
		hide_cust()
		
		Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(true)
		# Singleton_CommonVariables.ui__gold_info_box.hide()
		# Singleton_CommonVariables.ui__actor_micro_info_box.hide()
		#get_parent().get_parent().get_parent().s_hide_action_menu()
		return
			
	if Input.is_action_just_released("ui_a_key"):
		await Signal(get_tree().create_timer(0.02), "timeout")
		# event.is_action_released("ui_accept"):
		print("Accept Action - ", currently_selected_option)
		
		if currently_selected_option == e_menu_options.STAY_OPTION:
			is_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			
			Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(true)
			
			# Singleton_CommonVariables.ui__gold_info_box.hide()
			# Singleton_CommonVariables.ui__actor_micro_info_box.hide()
			
			Singleton_CommonVariables.battle__currently_active_actor.end_turn()
			
			# Singleton_CommonVariables.main_character_player_node.interaction_attempt_to_search()
			return
		elif currently_selected_option == e_menu_options.INVENTORY_OPTION:
			await get_tree().create_timer(0.03).timeout
			
			OpenInventoryMenu()
			return
		elif currently_selected_option == e_menu_options.MAGIC_OPTION:
			is_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			# Singleton_CommonVariables.ui__gold_info_box.hide()
			# Singleton_CommonVariables.ui__actor_micro_info_box.hide()
			
			await get_tree().create_timer(0.1).timeout
			
			Singleton_CommonVariables.ui__magic_menu.show_cust()
			
#			if Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal().spells_id.size() == 0:
#				noValidOptionNode.re_show_action_menu = true
#				noValidOptionNode.set_no_maigc_text()
#				# get_parent().get_parent().get_parent().s_hide_action_menu()
#				get_parent().get_parent().get_parent().s_hide_character_action_menu()
#				get_parent().get_parent().get_parent().s_show_no_valid_option_warning_box()
#			else:
#				get_parent().get_parent().get_parent().s_hide_action_menu()
#				get_parent().get_parent().get_parent().s_show_battle_magic_menu()
				
			return
		elif currently_selected_option == e_menu_options.ATTACK_OPTION:
			is_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			
			await get_tree().create_timer(0.1).timeout
			
			Singleton_CommonVariables.battle__logic__target_selection_node.set_attack_target_selection()
			
			# Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(true)
			
			
			# Singleton_CommonVariables.ui__gold_info_box.hide()
			# Singleton_CommonVariables.ui__actor_micro_info_box.hide()
			
			# Singleton_CommonVariables.battle__currently_active_actor.get_child(0).interaction_attempt_to_talk()
			return
		
	if Input.is_action_just_released("ui_down"):
		# menu_option_selected(e_menu_options.SEARCH_OPTION, "Search", "Search")
		menu_option_selected(e_menu_options.STAY_OPTION, "Stay", "Stay")
	elif Input.is_action_just_released("ui_up"):
		menu_option_selected(e_menu_options.ATTACK_OPTION, "Attack", "Attack")
	elif Input.is_action_just_released("ui_right"):
		menu_option_selected(e_menu_options.INVENTORY_OPTION, "Inventory", "Inventory")
	elif Input.is_action_just_released("ui_left"):
		menu_option_selected(e_menu_options.MAGIC_OPTION, "Magic", "Magic")


func menu_option_selected(e_menu_option_selected, animation_name: String, label_text: String) -> void:
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_option_selected
	animationPlayer.play(animation_name)
	label.text = label_text


func set_sprites_to_zero_frame() -> void:
	attack_spirte.frame = 0
	magic_spirte.frame = 0
	inventory_spirte.frame = 0
	stay_spirte.frame = 0
	search_spirte.frame = 0


func OpenInventoryMenu() -> void:
	is_menu_active = false
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	hide()
	Singleton_CommonVariables.ui__gold_info_box.hide()
	Singleton_CommonVariables.ui__actor_micro_info_box.hide()
	
	# disgusting remove these later but convertint to process instead of input with the just pressed action
	await Signal(get_tree().create_timer(0.2), "timeout")
	
	Singleton_CommonVariables.ui__inventory_menu.show_with_tween()
	
