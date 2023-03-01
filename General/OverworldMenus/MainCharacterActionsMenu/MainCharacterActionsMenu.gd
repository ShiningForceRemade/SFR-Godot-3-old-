extends Node2D

var is_menu_active: bool =  false

enum e_menu_options {
	TALK_OPTION,
	MAGIC_OPTION,
	INVENTORY_OPTION,
	SEARCH_OPTION
}
var currently_selected_option: int = e_menu_options.TALK_OPTION

@onready var animationPlayer = $AnimationPlayer
@onready var label = $NinePatchRect/Label

@onready var talk_spirte    = $TalkActionSprite
@onready var magic_spirte     = $MagicActionSprite
@onready var inventory_spirte = $InventoryActionSprite
@onready var search_spirte      = $SearchActionSprite


@onready var noValidOptionNode = get_parent().get_node("NoValidOptionWarningBoxRoot")

func _ready():
	set_sprites_to_zero_frame()
	
	# TODO: fixme
	# $AnimationPlayer.playback_speed = 2
	
	animationPlayer.play("TalkMenuOption")
	label.text = "Talk"


func set_menu_active() -> void:
	is_menu_active = true
	
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_options.TALK_OPTION
	animationPlayer.play("TalkMenuOption")
	label.text = "Talk"


func _process(_delta):
	if !is_menu_active:
		return
		
	if Input.is_action_just_pressed("ui_b_key"):
		print("Cancel Overworld Action Menu")
		is_menu_active = false
		Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
		await get_tree().create_timer(0.02).timeout
		
		# Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal().active = true
		# get_parent().get_parent().get_parent().s_show_battle_action_menu("down")
		# TODO add animation
		hide()
		
		Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
		Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
		Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
		#get_parent().get_parent().get_parent().s_hide_action_menu()
		return
			
	if Input.is_action_just_pressed("ui_a_key"):
		await get_tree().create_timer(0.02).timeout
		# event.is_action_released("ui_accept"):
		print("Accept Action - ", currently_selected_option)
		if currently_selected_option == e_menu_options.SEARCH_OPTION:
			is_menu_active = false
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
			
			Singleton_Game_GlobalCommonVariables.main_character_player_node.interaction_attempt_to_search()
			return
		elif currently_selected_option == e_menu_options.INVENTORY_OPTION:
			OpenInventoryMenu()
			return
		elif currently_selected_option == e_menu_options.MAGIC_OPTION:
			is_menu_active = false
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
			
			Singleton_Game_GlobalCommonVariables.menus_root_node.s_show_overworld_magic_menu()
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
		elif currently_selected_option == e_menu_options.TALK_OPTION:
			is_menu_active = false
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
			
			Singleton_Game_GlobalCommonVariables.main_character_player_node.interaction_attempt_to_talk()
			return
		
	if Input.is_action_just_pressed("ui_down"):
		menu_option_selected(e_menu_options.SEARCH_OPTION, "SearchMenuOption", "Search")
	elif Input.is_action_just_pressed("ui_up"):
		menu_option_selected(e_menu_options.TALK_OPTION, "TalkMenuOption", "Talk")
	elif Input.is_action_just_pressed("ui_right"):
		menu_option_selected(e_menu_options.INVENTORY_OPTION, "InventoryMenuOption", "Inventory")
	elif Input.is_action_just_pressed("ui_left"):
		menu_option_selected(e_menu_options.MAGIC_OPTION, "MagicMenuOption", "Magic")


func menu_option_selected(e_menu_option_selected, animation_name: String, label_text: String) -> void:
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_option_selected
	animationPlayer.play(animation_name)
	label.text = label_text


func set_sprites_to_zero_frame() -> void:
	talk_spirte.frame = 0
	magic_spirte.frame = 0
	inventory_spirte.frame = 0
	search_spirte.frame = 0


func OpenInventoryMenu() -> void:
	is_menu_active = false
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	hide()
	Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
	Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
	
	# disgusting remove these later but convertint to process instead of input with the just pressed action
	# await get_tree().create_timer(0.25).timeout
	await get_tree().create_timer(0.2).timeout
	
	Singleton_Game_GlobalCommonVariables.menus_root_node.s_show_overworld_inventory_menu()
	
