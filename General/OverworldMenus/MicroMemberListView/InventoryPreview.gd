extends Node2D

onready var SlotUpSprite = $SlotUpSprite
onready var SlotLeftSprite = $SlotLeftSprite
onready var SlotRightSprite = $SlotRightSprite
onready var SlotDownSprite = $SlotDownSprite
onready var RedSelectionBorderRoot = $RedSelectionBorderRoot

enum E_ItemSelection {
	UP,
	LEFT,
	RIGHT,
	DOWN
}

const RedSelectionPositions = [
	Vector2(16, 0),
	Vector2(0, 12),
	Vector2(32, 12),
	Vector2(16, 24)
]

var active = false
var current_selection = E_ItemSelection.UP

func _ready():	
	pass


func set_menu_active() -> void:
	active = true
	current_selection = E_ItemSelection.UP
	RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
	RedSelectionBorderRoot.show()


func set_menu_inactive() -> void:
	active = false
	RedSelectionBorderRoot.hide()


func _process(_delta):
	if active == false:
		return
	
	if Input.is_action_just_pressed("ui_down"):
		if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() >= 4:
			current_selection = E_ItemSelection.DOWN
			RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
	elif Input.is_action_just_pressed("ui_up"):
		if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() >= 1:
			current_selection = E_ItemSelection.UP
			RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
	elif Input.is_action_just_pressed("ui_left"):
		if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() >= 2:
			current_selection = E_ItemSelection.LEFT
			RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
	elif Input.is_action_just_pressed("ui_right"):
		if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() >= 3:
			current_selection = E_ItemSelection.RIGHT
			RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
	
	elif Input.is_action_just_pressed("ui_a_key"):
#		var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
#
#
#
#		for i in fm_size:
#			if Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character == current_selection:
#				print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
#
#				if Singleton_Game_GlobalCommonVariables.selected_item != null:
#					Singleton_Game_GlobalCommonVariables.selected_target_character = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i]
#				else:
#					Singleton_Game_GlobalCommonVariables.selected_character = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i]
#
#				yield(get_tree().create_timer(0.1), "timeout")
#				match Singleton_Game_GlobalCommonVariables.action_type:
#					"SHOP_BUY": CompletePurchaseAndGiveItemToSelectedCharacter()
#
#					"EQUIP": 
#						# equipItemsControlNode.DisplayCharacterStats(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i])
#						# itemsViewControlNode.hide()
#						# equipItemsControlNode.set_equip_menu_active()
#						pass
#
#					# _: itemsViewControlNode.set_item_selection_menu_active()
#
#				# active = false
#
		# hide()
		# active = false
		
		print(current_selection)
		
		match Singleton_Game_GlobalCommonVariables.action_type:
			"SHOP_SELL": ConfirmSellOfItem()
			_:  pass
			
		return
		
	elif Input.is_action_just_pressed("ui_b_key"):
		# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
		# hide()
		active = false
		
		match Singleton_Game_GlobalCommonVariables.action_type:
			"SHOP_SELL": CancelShopSellAction()
			_:  pass
			# GoBackToShopItemSelectionMenu()
			# pass

# Accept Actions

func ConfirmSellOfItem() -> void:
	active = false
	
	# defenesive check
	if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() == 0:
		active = true
		return
	
	var irl = load(Singleton_Game_GlobalCommonVariables.selected_character.inventory[current_selection].resource)
	
	var display_str = "I'll pay " + str(irl.price_sell) + " gold coins for it. OK?"
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable(display_str)
	Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.s_show__yes_or_no_prompt()
	var result = yield(Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.YesOrNoPromptRoot, "signal__yes_or_no_prompt__choice")
	if result == "NO":
		active = true
		return
		
	elif result == "YES":
		Singleton_Game_GlobalCommonVariables.gold = Singleton_Game_GlobalCommonVariables.gold + irl.price_sell
		
		# Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
		# Singleton_Game_GlobalCommonVariables.dialogue_box_node.show()
		current_selection = E_ItemSelection.UP
		RedSelectionBorderRoot.position = RedSelectionPositions[current_selection]
		
		Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(current_selection)
		
		Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
		Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_character)
		
		active = true
		return
	
	# CancelShopSellAction()

# Cancels

func CancelShopSellAction() -> void:
	set_menu_inactive()
	
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	
	# Singleton_Game_GlobalCommonVariables.action_type = "SHOP_SELL"
	
	Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.set_menu_active()
	Singleton_Game_GlobalCommonVariables.menus_root_node.MicroMemberListViewMenu.show()
