extends Node2D

var is_menu_active: bool =  false

enum e_menu_options {
	ADVICE_OPTION,
	JOIN_OPTION,
	INVENTORY_OPTION,
	STATS_OPTION
}
var currently_selected_option: int = e_menu_options.ADVICE_OPTION

@onready var animationPlayer = $AnimationPlayer
@onready var label = $NinePatchRect/Label

@onready var advice_spirte    = $AdviceActionSprite
@onready var join_spirte     = $JoinActionSprite
@onready var inventory_spirte = $InventoryActionSprite
@onready var stats_spirte      = $StatsActionSprite

@onready var noValidOptionNode = Singleton_CommonVariables.ui__not_valid_box

func _ready():
	Singleton_CommonVariables.ui__hq_menu = self
	set_sprites_to_zero_frame()
	#$AnimationPlayer.playback_speed = 2
	animationPlayer.play("AdviceMenuOption")
	label.text = "Advice"


func show_with_tween() -> void:
	show()
	set_menu_active()

func set_menu_active() -> void:
	await Signal(get_tree().create_timer(0.02), "timeout")
	is_menu_active = true
	
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_options.ADVICE_OPTION
	animationPlayer.play("AdviceMenuOption")
	label.text = "Advice"


func _process(_delta):
	if !is_menu_active:
		return
	
	if Input.is_action_just_pressed("ui_b_key"):
		CancelHQMenu()
		return
		
	if Input.is_action_just_pressed("ui_a_key"):
		# event.is_action_released("ui_accept"):
		print("Accept Action - ", currently_selected_option)
		if currently_selected_option == e_menu_options.STATS_OPTION:
			is_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			hide()
			
			Singleton_CommonVariables.action_type = "HQ_STATS"
			
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
			Singleton_CommonVariables.dialogue_box_node.show()
			
			var display_str = "DEV NOTE - Use overworld inventory menu to check stats.\nDo you need anything else?"
			Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
			Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
			var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
			if result == "NO":
				Singleton_CommonVariables.dialogue_box_node.hide()
				CancelHQMenu()
				return
			elif result == "YES":
				Singleton_CommonVariables.dialogue_box_node.hide()
				Singleton_CommonVariables.ui__gold_info_box.hide()
				show()
				await Signal(get_tree().create_timer(0.1), "timeout")
				is_menu_active = true
			
			return
		elif currently_selected_option == e_menu_options.INVENTORY_OPTION:
			is_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			hide()
			
			Singleton_CommonVariables.action_type = "HQ_STATS"
			
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
			Singleton_CommonVariables.dialogue_box_node.show()
			
			var display_str = "DEV NOTE - Use overworld inventory menu to check stats.\nDo you need anything else?"
			Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
			Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
			var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
			if result == "NO":
				Singleton_CommonVariables.dialogue_box_node.hide()
				CancelHQMenu()
				return
			elif result == "YES":
				Singleton_CommonVariables.dialogue_box_node.hide()
				Singleton_CommonVariables.ui__gold_info_box.hide()
				show()
				await Signal(get_tree().create_timer(0.1), "timeout")
				is_menu_active = true
			return
		elif currently_selected_option == e_menu_options.JOIN_OPTION:
			is_menu_active = false
			# Singleton_Game_GlobalCommonVariables.main_character_player_node.interaction_attempt_to_talk()
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
			
			Singleton_CommonVariables.action_type = "HQ_JOIN_OR_LEAVE"
			
			# Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
			
			# Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().show()
			# Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().ShopMenuPosition()
	
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
			Singleton_CommonVariables.dialogue_box_node.show()
			
			# Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.s_show_shop_item_selection_menu()
			
			Singleton_CommonVariables.ui__micro_member_list_view.set_menu_active()
			Singleton_CommonVariables.ui__micro_member_list_view.show()
			
			return
		elif currently_selected_option == e_menu_options.ADVICE_OPTION:
			is_menu_active = false
			hide()
			
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			await Signal(get_tree().create_timer(0.2), "timeout")
			
			# TODO: refactor should have this more predictable and just pass the number in the path param
			match Singleton_CommonVariables.upcoming_battle_number:
				1: Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/HeadQuarters/Scripts Nova/Battle1_Advice.json"
				# no advice for battle 2 - 2: Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/HQ/Default/Scripts/ActiveForceQuotes/Tao.json"
				3: Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/HeadQuarters/Scripts Nova/Battle3_Advice.json"
				4: Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/HeadQuarters/Scripts Nova/Battle4_Advice.json"
				# 5: Singleton_CommonVariables.dialogue_box_node.external_file = "res://SF1/Chapters/HQ/Default/Scripts/ActiveForceQuotes/Tao.json"
				_: pass # TODO: create generic good luck in battle message to have as a fallback in case of no advice present
			
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.active = false
			Singleton_CommonVariables.dialogue_box_node._process_new_resource_file()
			return
	
	if Input.is_action_just_pressed("ui_down"):
		menu_option_selected(e_menu_options.STATS_OPTION, "StatsMenuOption", "Stats")
	elif Input.is_action_just_pressed("ui_up"):
		menu_option_selected(e_menu_options.ADVICE_OPTION, "AdviceMenuOption", "Advice")
	elif Input.is_action_just_pressed("ui_right"):
		menu_option_selected(e_menu_options.INVENTORY_OPTION, "InventoryMenuOption", "Inventory")
	elif Input.is_action_just_pressed("ui_left"):
		menu_option_selected(e_menu_options.JOIN_OPTION, "JoinMenuOption", "Join")


func menu_option_selected(e_menu_option_selected, animation_name: String, label_text: String) -> void:
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_option_selected
	animationPlayer.play(animation_name)
	label.text = label_text


func set_sprites_to_zero_frame() -> void:
	advice_spirte.frame = 0
	join_spirte.frame = 0
	inventory_spirte.frame = 0
	stats_spirte.frame = 0





#
#func _process(_delta):
#	if !is_menu_active:
#		return
#
#	if Input.is_action_just_pressed("ui_b_key"):
#		CancelPriestMenu()
#		return
#
#	if Input.is_action_just_pressed("ui_a_key"):
#		yield(get_tree().create_timer(0.02), "timeout")
#		# event.is_action_released("ui_accept"):
#		print("Accept Action - ", currently_selected_option)
#		if currently_selected_option == e_menu_options.PROMOTION_OPTION:
#			is_menu_active = false
#			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
#			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
#
#			hide()
#
#			Singleton_Game_GlobalCommonVariables.action_type = "PRIEST_PROMOTION"
#
#			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
#
#			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
#			Singleton_Game_GlobalCommonVariables.dialogue_box_node.show()
#
#			var display_str = "No one seems to deserve a promotion.\nDo you need anything else?"
#			Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
#			Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.s_show__yes_or_no_prompt()
#			var result = yield(Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.YesOrNoPromptRoot, "signal__yes_or_no_prompt__choice")
#			if result == "NO":
#				Singleton_Game_GlobalCommonVariables.dialogue_box_node.hide()
#				CancelPriestMenu()
#				return
#
#			elif result == "YES":
#				# Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(current_selection)
#
#				# Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
#				# Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_character)
#
#				Singleton_Game_GlobalCommonVariables.dialogue_box_node.hide()
#				Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.hide()
#				show()
#
#				is_menu_active = true
#
#			return
#		elif currently_selected_option == e_menu_options.DEAD_OPTION:
#			is_menu_active = false
#			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
#			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
#			hide()
#
#			Singleton_Game_GlobalCommonVariables.action_type = "PRIEST_DEAD"
#
#			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
#
#			Singleton_Game_GlobalCommonVariables.dialogue_box_node.show()
#
#			Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.set_menu_active()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.HideInventoryPreview()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.show()
#
#			return
#		elif currently_selected_option == e_menu_options.CURE_OPTION:
#			is_menu_active = false
#			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
#			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
#
#			hide()
#
#			Singleton_Game_GlobalCommonVariables.action_type = "PRIEST_CURE"
#
#			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
#
#			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
#			Singleton_Game_GlobalCommonVariables.dialogue_box_node.show()
#
#			var display_str = "No one seems to need my help.\nDo you need anything else?"
#			Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
#			Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.s_show__yes_or_no_prompt()
#			var result = yield(Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.YesOrNoPromptRoot, "signal__yes_or_no_prompt__choice")
#			if result == "NO":
#				Singleton_Game_GlobalCommonVariables.dialogue_box_node.hide()
#				CancelPriestMenu()
#				return
#
#			elif result == "YES":
#				# Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(current_selection)
#
#				# Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
#				# Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_character)
#
#				Singleton_Game_GlobalCommonVariables.dialogue_box_node.hide()
#				Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.hide()
#				show()
#
#				is_menu_active = true
#
#			return
#		elif currently_selected_option == e_menu_options.SAVE_OPTION:
#			is_menu_active = false
#			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
#			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
#
#			hide()
#
#			Singleton_Game_GlobalCommonVariables.action_type = "PRIEST_PROMOTION"
#
#			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
#
#			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
#			Singleton_Game_GlobalCommonVariables.dialogue_box_node.show()
#
#			var display_str = "DISABLED FOR DEMO!\nDo you need anything else?"
#			Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
#			Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.s_show__yes_or_no_prompt()
#			var result = yield(Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.YesOrNoPromptRoot, "signal__yes_or_no_prompt__choice")
#			if result == "NO":
#				Singleton_Game_GlobalCommonVariables.dialogue_box_node.hide()
#				CancelPriestMenu()
#				return
#
#			elif result == "YES":
#				# Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(current_selection)
#
#				# Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
#				# Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_character)
#
#				Singleton_Game_GlobalCommonVariables.dialogue_box_node.hide()
#				Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.hide()
#				show()
#
#				is_menu_active = true
#
#			return
#
#
#
##		elif currently_selected_option == e_menu_options.SELL_OPTION:
##			is_menu_active = false
##			# Singleton_Game_GlobalCommonVariables.main_character_player_node.interaction_attempt_to_talk()
##			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
##			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
##			hide()
##			# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
##
##			Singleton_Game_GlobalCommonVariables.action_type = "SHOP_SELL"
##
##			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
##
##			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().show()
##			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().ShopMenuPosition()
##
##			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
##			Singleton_Game_GlobalCommonVariables.dialogue_box_node.show()
##
##			# Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.s_show_shop_item_selection_menu()
##
##			Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.set_menu_active()
##			Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.show()
##
##			return
#
#
#
#	if Input.is_action_just_pressed("ui_down"):
#		menu_option_selected(e_menu_options.PROMOTION_OPTION, "StayMenuOption", "Promotion")
#	elif Input.is_action_just_pressed("ui_up"):
#		menu_option_selected(e_menu_options.SAVE_OPTION, "AttackMenuOption", "Save")
#	elif Input.is_action_just_pressed("ui_right"):
#		menu_option_selected(e_menu_options.DEAD_OPTION, "InventoryMenuOption", "Raise Dead")
#	elif Input.is_action_just_pressed("ui_left"):
#		menu_option_selected(e_menu_options.CURE_OPTION, "MagicMenuOption", "Cure")
#
#

func CancelHQMenu() -> void:
	print("Cancel HQ Menu")
	is_menu_active = false
	await Signal(get_tree().create_timer(0.02), "timeout")
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	
	Singleton_CommonVariables.interaction_node_reference.interaction_completed()
	
	Singleton_CommonVariables.ui__portrait_popup.hide()
	
	# Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal().active = true
	# get_parent().get_parent().get_parent().s_show_battle_action_menu("down")
	# TODO add animation
	hide()

	# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	#get_parent().get_parent().get_parent().s_hide_action_menu()

