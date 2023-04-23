extends Node2D

var is_menu_active: bool =  false

enum e_menu_options {
	SAVE_OPTION,
	CURE_OPTION,
	DEAD_OPTION,
	PROMOTION_OPTION
}
var currently_selected_option: int = e_menu_options.SAVE_OPTION

@onready var animationPlayer = $AnimationPlayer
@onready var label = $NinePatchRect/Label

@onready var save_spirte = $SaveAction
@onready var cure_spirte = $CureAction
@onready var dead_spirte = $DeadAction
@onready var promotion_spirte = $PromotionAction

const bmc_x: int = 171
const bmc_y: int = 182

# onready var PriestMenuRoot = $PriestMenuRoot
# onready var PriestMenuTween = $PriestMenuTween

func internal_tween_move_to_position(ox, oy, nx, ny, tweenNode, targetNode) -> void:
	print(tweenNode)
	tweenNode.interpolate_property(targetNode, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenNode.start()

func s_hide_priest_menu():
	# internal_tween_move_to_position(139, 134, 139, 134 + 80, PriestMenuTween, PriestMenuRoot)
	hide()

func s_show_priest_menu():
	# internal_tween_move_to_position(139, 134 + 80, 139, 134, PriestMenuTween, PriestMenuRoot)
	show()
	set_menu_active()

# onready var noValidOptionNode = get_parent().get_node("NoValidOptionWarningBoxRoot")

func _ready():
	Singleton_CommonVariables.ui__priest_menu = self
	set_sprites_to_zero_frame()
	# animationPlayer.speed_scale = 2
	animationPlayer.play("Save")
	label.text = "Save"


func set_menu_active() -> void:
	await Signal(get_tree().create_timer(0.02), "timeout")
	
	is_menu_active = true
	
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_options.SAVE_OPTION
	animationPlayer.play("Save")
	label.text = "Save"


func _process(_delta):
	if !is_menu_active:
		return
		
	if Input.is_action_just_pressed("ui_b_key"):
		CancelPriestMenu()
		return
		
	if Input.is_action_just_pressed("ui_a_key"):
		await Signal(get_tree().create_timer(0.02), "timeout")
		# event.is_action_released("ui_accept"):
		print("Accept Action - ", currently_selected_option)
		if currently_selected_option == e_menu_options.PROMOTION_OPTION:
			is_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			hide()
			
			Singleton_CommonVariables.action_type = "PRIEST_PROMOTION"
			
			Singleton_CommonVariables.ui__actor_micro_info_box.hide()
			Singleton_CommonVariables.ui__gold_info_box.hide()
	
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
			Singleton_CommonVariables.dialogue_box_node.show()
			
			var display_str = "No one seems to deserve a promotion.\nDo you need anything else?"
			Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
			Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
			var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
			if result == "NO":
				Singleton_CommonVariables.dialogue_box_node.hide()
				CancelPriestMenu()
				return
		
			elif result == "YES":
				# Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(current_selection)
		
				# Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
				# Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_character)
				
				Singleton_CommonVariables.dialogue_box_node.hide()
				Singleton_CommonVariables.ui__gold_info_box.hide()
				show()
				
				is_menu_active = true
		
			return
		elif currently_selected_option == e_menu_options.DEAD_OPTION:
			is_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			hide()
			
			Singleton_CommonVariables.action_type = "PRIEST_DEAD"
			
			Singleton_CommonVariables.ui__actor_micro_info_box.hide()
			Singleton_CommonVariables.ui__gold_info_box.hide()
			
			Singleton_CommonVariables.dialogue_box_node.show()
			
			Singleton_CommonVariables.ui__micro_member_list_view.set_menu_active()
			Singleton_CommonVariables.ui__micro_member_list_view.HideInventoryPreview()
			Singleton_CommonVariables.ui__micro_member_list_view.show()
			
			return
		elif currently_selected_option == e_menu_options.CURE_OPTION:
			is_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			hide()
			
			Singleton_CommonVariables.action_type = "PRIEST_CURE"
			
			Singleton_CommonVariables.ui__actor_micro_info_box.hide()
			Singleton_CommonVariables.ui__gold_info_box.hide()
	
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
			Singleton_CommonVariables.dialogue_box_node.show()
			
			var display_str = "No one seems to need my help.\nDo you need anything else?"
			Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
			Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
			var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
			if result == "NO":
				Singleton_CommonVariables.dialogue_box_node.hide()
				CancelPriestMenu()
				return
		
			elif result == "YES":
				# Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(current_selection)
		
				# Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
				# Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_character)
				
				Singleton_CommonVariables.dialogue_box_node.hide()
				Singleton_CommonVariables.ui__gold_info_box.hide()
				show()
				
				is_menu_active = true
		
			return
		elif currently_selected_option == e_menu_options.SAVE_OPTION:
			is_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			hide()
			
			Singleton_CommonVariables.action_type = "PRIEST_PROMOTION"
			
			Singleton_CommonVariables.ui__actor_micro_info_box.hide()
			Singleton_CommonVariables.ui__gold_info_box.hide()
	
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
			Singleton_CommonVariables.dialogue_box_node.show()
			
			var display_str = "DISABLED FOR DEMO!\nDo you need anything else?"
			Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
			Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
			var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
			if result == "NO":
				Singleton_CommonVariables.dialogue_box_node.hide()
				CancelPriestMenu()
				return
		
			elif result == "YES":
				# Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(current_selection)
		
				# Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
				# Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_character)
				
				Singleton_CommonVariables.dialogue_box_node.hide()
				Singleton_CommonVariables.ui__gold_info_box.hide()
				show()
				
				is_menu_active = true
		
			return
		
		
		
#		elif currently_selected_option == e_menu_options.SELL_OPTION:
#			is_menu_active = false
#			# Singleton_Game_GlobalCommonVariables.main_character_player_node.interaction_attempt_to_talk()
#			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
#			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
#			hide()
#			# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
#
#			Singleton_Game_GlobalCommonVariables.action_type = "SHOP_SELL"
#
#			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
#
#			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().show()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().ShopMenuPosition()
#
#			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
#			Singleton_Game_GlobalCommonVariables.dialogue_box_node.show()
#
#			# Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.s_show_shop_item_selection_menu()
#
#			Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.set_menu_active()
#			Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.show()
#
#			return
		
		
		
	if Input.is_action_just_pressed("ui_down"):
		menu_option_selected(e_menu_options.PROMOTION_OPTION, "Promotion", "Promotion")
	elif Input.is_action_just_pressed("ui_up"):
		menu_option_selected(e_menu_options.SAVE_OPTION, "Save", "Save")
	elif Input.is_action_just_pressed("ui_right"):
		menu_option_selected(e_menu_options.DEAD_OPTION, "Dead", "Raise Dead")
	elif Input.is_action_just_pressed("ui_left"):
		menu_option_selected(e_menu_options.CURE_OPTION, "Cure", "Cure")


func menu_option_selected(e_menu_option_selected, animation_name: String, label_text: String) -> void:
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_option_selected
	animationPlayer.play(animation_name)
	label.text = label_text


func set_sprites_to_zero_frame() -> void:
	save_spirte.frame = 0
	cure_spirte.frame = 0
	dead_spirte.frame = 0
	promotion_spirte.frame = 0


func CancelPriestMenu() -> void:
	print("Cancel Overworld Action Menu")
	is_menu_active = false
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	await Signal(get_tree().create_timer(0.02), "timeout")
	
	Singleton_CommonVariables.action_type = null
	
	Singleton_CommonVariables.interaction_node_reference.interaction_completed()
	
	# Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal().active = true
	# get_parent().get_parent().get_parent().s_show_battle_action_menu("down")
	# TODO add animation
	hide()
	
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
	Singleton_CommonVariables.main_character_player_node.set_active_processing(true)
	Singleton_CommonVariables.ui__gold_info_box.hide()
	Singleton_CommonVariables.ui__actor_micro_info_box.hide()
	#get_parent().get_parent().get_parent().s_hide_action_menu()
