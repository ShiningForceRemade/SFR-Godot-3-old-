extends Node2D

var is_menu_active: bool =  false

enum e_menu_options {
	BUY_OPTION,
	REPAIR_OPTION,
	SELL_OPTION,
	DEALS_OPTION
}
var currently_selected_option: int = e_menu_options.BUY_OPTION

onready var animationPlayer = $AnimationPlayer
onready var label = $NinePatchRect/Label

onready var buy_spirte    = $BuyActionSprite
onready var repair_spirte = $RepairActionSprite
onready var sell_spirte   = $SellActionSprite
onready var deals_spirte  = $DealsActionSprite


# onready var noValidOptionNode = get_parent().get_node("NoValidOptionWarningBoxRoot")

func _ready():
	set_sprites_to_zero_frame()
	$AnimationPlayer.playback_speed = 2
	animationPlayer.play("BuyMenuOption")
	label.text = "Buy"


func set_menu_active() -> void:
	Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
	
	yield(get_tree().create_timer(0.02), "timeout")
	
	is_menu_active = true
	
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_options.BUY_OPTION
	animationPlayer.play("BuyMenuOption")
	label.text = "Buy"


func _process(_delta):
	if !is_menu_active:
		return
		
	if Input.is_action_just_pressed("ui_b_key"):
		print("Cancel Overworld Action Menu")
		is_menu_active = false
		Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
		yield(get_tree().create_timer(0.02), "timeout")
			
		# Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal().active = true
		# get_parent().get_parent().get_parent().s_show_battle_action_menu("down")
		# TODO add animation
		hide()
			
		Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
		Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
		Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
		#get_parent().get_parent().get_parent().s_hide_action_menu()
		
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_processing(true)
		
		return
		
	if Input.is_action_just_pressed("ui_a_key"):
		yield(get_tree().create_timer(0.02), "timeout")
		# event.is_action_released("ui_accept"):
		print("Accept Action - ", currently_selected_option)
		if currently_selected_option == e_menu_options.DEALS_OPTION:
			is_menu_active = false
			Singleton_Game_GlobalCommonVariables.main_character_player_node.interaction_attempt_to_search()
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
			return
		elif currently_selected_option == e_menu_options.SELL_OPTION:
			is_menu_active = false
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			Singleton_Game_GlobalCommonVariables.menus_root_node.PriestMenuWrapperRoot.s_hide_priest_menu()
			
			Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://General/PriestMenu/Scripts/AttemptToRaiseDead.json"
			Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			# get_parent().get_parent().get_parent().s_show_battle_inventory_menu()
			
			return
		elif currently_selected_option == e_menu_options.REPAIR_OPTION:
			is_menu_active = false
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
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
		elif currently_selected_option == e_menu_options.BUY_OPTION:
			is_menu_active = false
			# Singleton_Game_GlobalCommonVariables.main_character_player_node.interaction_attempt_to_talk()
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
			
			Singleton_Game_GlobalCommonVariables.action_type = "SHOP_BUY"
			
			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
			
			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().show()
			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().ShopMenuPosition()
	
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
			Singleton_Game_GlobalCommonVariables.dialogue_box_node.show()
			
			Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.s_show_shop_item_selection_menu()
			
			return
	
	if Input.is_action_just_pressed("ui_down"):
		menu_option_selected(e_menu_options.DEALS_OPTION, "DealsMenuOption", "Deals")
	elif Input.is_action_just_pressed("ui_up"):
		menu_option_selected(e_menu_options.BUY_OPTION, "BuyMenuOption", "Buy")
	elif Input.is_action_just_pressed("ui_right"):
		menu_option_selected(e_menu_options.SELL_OPTION, "SellMenuOption", "Sell")
	elif Input.is_action_just_pressed("ui_left"):
		menu_option_selected(e_menu_options.REPAIR_OPTION, "RepairMenuOption", "Repair")


func menu_option_selected(e_menu_option_selected, animation_name: String, label_text: String) -> void:
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_option_selected
	animationPlayer.play(animation_name)
	label.text = label_text


func set_sprites_to_zero_frame() -> void:
	buy_spirte.frame = 0
	repair_spirte.frame = 0
	sell_spirte.frame = 0
	deals_spirte.frame = 0

