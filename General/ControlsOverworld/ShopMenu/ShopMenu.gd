extends Node2D

var is_menu_active: bool =  false

enum e_menu_options {
	BUY_OPTION,
	REPAIR_OPTION,
	SELL_OPTION,
	DEALS_OPTION
}
var currently_selected_option: int = e_menu_options.BUY_OPTION

@onready var animationPlayer = $AnimationPlayer
@onready var label = $NinePatchRect/Label

@onready var buy_spirte    = $BuyActionSprite
@onready var repair_spirte = $RepairActionSprite
@onready var sell_spirte   = $SellActionSprite
@onready var deals_spirte  = $DealsActionSprite


# onready var noValidOptionNode = get_parent().get_node("NoValidOptionWarningBoxRoot")

func _ready():
	Singleton_CommonVariables.ui__shop_menu = self
	set_sprites_to_zero_frame()
	# $AnimationPlayer.playback_speed = 2
	animationPlayer.play("BuyMenuOption")
	label.text = "Buy"


func set_menu_active() -> void:
	Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
	
	Singleton_CommonVariables.selected_character = null
	Singleton_CommonVariables.selected_item = null
	Singleton_CommonVariables.selected_item_idx = null
	Singleton_CommonVariables.selected_target_character = null
	Singleton_CommonVariables.action_type = null

	await Signal(get_tree().create_timer(0.02), "timeout")
	
	is_menu_active = true
	
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_options.BUY_OPTION
	animationPlayer.play("BuyMenuOption")
	label.text = "Buy"


func _process(_delta):
	if !is_menu_active:
		return
		
	if Input.is_action_just_pressed("ui_b_key"):
		CancelShopMenu()
		return
		
	if Input.is_action_just_pressed("ui_a_key"):
		await Signal(get_tree().create_timer(0.02), "timeout")
		# event.is_action_released("ui_accept"):
		print("Accept Action - ", currently_selected_option)
		if currently_selected_option == e_menu_options.DEALS_OPTION:
			is_menu_active = false
			Singleton_CommonVariables.main_character_player_node.interaction_attempt_to_search()
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			
			Singleton_CommonVariables.action_type = "SHOP_DEALS"
			
			Singleton_CommonVariables.ui__actor_micro_info_box.hide()
			
			Singleton_CommonVariables.ui__gold_info_box.show()
			Singleton_CommonVariables.ui__gold_info_box.ShopMenuPosition()
	
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
			Singleton_CommonVariables.dialogue_box_node.show()
			
			var display_str = "I'm very sorry!\nI'm out of stock!\nDo you want anything else?"
			Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
			Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
			var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
			if result == "NO":
				Singleton_CommonVariables.dialogue_box_node.hide()
				CancelShopMenu()
				return
		
			elif result == "YES":
				# Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(current_selection)
		
				# Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
				# Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_character)
				
				Singleton_CommonVariables.dialogue_box_node.hide()
				Singleton_CommonVariables.ui__gold_info_box.hide()
				show()
				await Signal(get_tree().create_timer(0.02), "timeout")
				is_menu_active = true
		
			return
		elif currently_selected_option == e_menu_options.SELL_OPTION:
			is_menu_active = false
			# Singleton_Game_GlobalCommonVariables.main_character_player_node.interaction_attempt_to_talk()
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
			
			Singleton_CommonVariables.action_type = "SHOP_SELL"
			
			Singleton_CommonVariables.ui__actor_micro_info_box.hide()
			
			Singleton_CommonVariables.ui__gold_info_box.show()
			Singleton_CommonVariables.ui__gold_info_box.ShopMenuPosition()
	
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
			Singleton_CommonVariables.dialogue_box_node.show()
			
			# Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.s_show_shop_item_selection_menu()
			
			Singleton_CommonVariables.ui__micro_member_list_view.set_menu_active()
			Singleton_CommonVariables.ui__micro_member_list_view.show()
			
			return
		elif currently_selected_option == e_menu_options.REPAIR_OPTION:
			is_menu_active = false
			Singleton_CommonVariables.main_character_player_node.interaction_attempt_to_search()
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			
			Singleton_CommonVariables.action_type = "SHOP_REPAIR"
			
			Singleton_CommonVariables.ui__actor_micro_info_box.hide()
			
			Singleton_CommonVariables.ui__gold_info_box.show()
			Singleton_CommonVariables.ui__gold_info_box.ShopMenuPosition()
	
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
			Singleton_CommonVariables.dialogue_box_node.show()
			
			var display_str = "Nothing seems to need repair!\nDo you want anything else?"
			Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
			Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
			var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
			if result == "NO":
				Singleton_CommonVariables.dialogue_box_node.hide()
				CancelShopMenu()
				return
		
			elif result == "YES":
				# Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(current_selection)
		
				# Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
				# Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_character)
				
				Singleton_CommonVariables.dialogue_box_node.hide()
				Singleton_CommonVariables.ui__gold_info_box.hide()
				show()
				await Signal(get_tree().create_timer(0.02), "timeout")
				is_menu_active = true
		
			return
		elif currently_selected_option == e_menu_options.BUY_OPTION:
			is_menu_active = false
			# Singleton_Game_GlobalCommonVariables.main_character_player_node.interaction_attempt_to_talk()
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
			
			Singleton_CommonVariables.action_type = "SHOP_BUY"
			
			Singleton_CommonVariables.ui__actor_micro_info_box.hide()
			
			Singleton_CommonVariables.ui__gold_info_box.show()
			Singleton_CommonVariables.ui__gold_info_box.ShopMenuPosition()
	
			Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
			Singleton_CommonVariables.dialogue_box_node.show()
			
			Singleton_CommonVariables.ui__shop_item_selection_menu.show_with_tween()
			
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
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_option_selected
	animationPlayer.play(animation_name)
	label.text = label_text


func set_sprites_to_zero_frame() -> void:
	buy_spirte.frame = 0
	repair_spirte.frame = 0
	sell_spirte.frame = 0
	deals_spirte.frame = 0


func CancelShopMenu() -> void:
	print("Cancel Overworld Action Menu")
	is_menu_active = false
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	
	# yield(get_tree().create_timer(0.02), "timeout")
	
	Singleton_CommonVariables.dialogue_box_node.Clean()
	
	Singleton_CommonVariables.interaction_node_reference.interaction_completed()
	
	# Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal().active = true
	# get_parent().get_parent().get_parent().s_show_battle_action_menu("down")
	# TODO add animation
	hide()
		
	Singleton_CommonVariables.main_character_player_node.set_active(false)
	Singleton_CommonVariables.ui__gold_info_box.hide()
	Singleton_CommonVariables.ui__gold_info_box.DefaultPosition()
	
	Singleton_CommonVariables.ui__actor_micro_info_box.hide()
	#get_parent().get_parent().get_parent().s_hide_action_menu()
	
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)


func s_show_shop_menu() -> void:
	show()
	set_menu_active()
	# TODO: tween this into place
