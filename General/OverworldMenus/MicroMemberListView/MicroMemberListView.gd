extends Node2D

# TODO really need to move to the node process method instead of a hardcoded active variable
var active = false

var cnode = null

var EmptyItemSlotTexture = preload("res://Assets/SFCD/Items/EmptyItemSlot.png")

var MemberSelectionLine = load("res://General/OverworldMenus/MemberListView/MemberSelectionLine.tscn")

var MemberMagicLine = load("res://General/OverworldMenus/MemberListView/MemberMagicLine.tscn")
var MemberItemLine = load("res://General/OverworldMenus/MemberListView/MemberItemLine.tscn")

onready var ScollbarContainerNode = $StatNinePatchRect2/ScrollContainer

onready var portrait_sprite = $PortraitWrapperNode/PortraitSprite

onready var red_selection = $RedSelectionBorderRoot

onready var flist_vbox_container = $StatNinePatchRect2/ScrollContainer/VBoxContainer

onready var InventoryPreviewRoot = $InventoryPreviewRoot

var current_selection = null

func _ready():
	# var invisible_scrollbar_theme = Theme.new()
	# var empty_stylebox = StyleBoxEmpty.new()
	# invisible_scrollbar_theme.set_stylebox("scroll", "VScrollBar", empty_stylebox)
	# invisible_scrollbar_theme.set_stylebox("scroll", "HScrollBar", empty_stylebox)
	# ScollbarContainerNode.get_v_scrollbar().theme = invisible_scrollbar_theme
	# ScollbarContainerNode.get_h_scrollbar().theme = invisible_scrollbar_theme
	
	DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0])
	
	# Test not used node
	# var c = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0]
	# flist_vbox_container.get_node("CharacterWrapperNode/NameStaticLabel").text = c.name
	# flist_vbox_container.get_node("CharacterWrapperNode/ClassStaticLabel").text = c.class
	# flist_vbox_container.get_node("CharacterWrapperNode/LevelStaticLabel").text = str(c.level)
	
	for character in Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers:
		var CLine = MemberSelectionLine.instance()
		
		if character.active_in_force:
			CLine.get_node("ActiveForceStaticLabel").show()
		else:
			CLine.get_node("ActiveForceStaticLabel").hide()
		
		CLine.get_node("NameStaticLabel").text = character.name
		CLine.get_node("ClassStaticLabel").text = character.class
		CLine.get_node("LevelStaticLabel").text = str(character.level)
		
		flist_vbox_container.add_child(CLine)
	
	# Remove this if Godot 4 fixes this
	# fake last item to prevent godot clipping issues
	var CLine = MemberSelectionLine.instance()
	flist_vbox_container.add_child(CLine)
	
	pass


func set_menu_active() -> void:
	active = true
	red_selection.position = Vector2(63, 11)


func set_menu_inactive() -> void:
	active = false
	# red_selection.position = Vector2(63, 11)


func _input(event):
	if active == false:
		return
	
	if event.is_action_pressed("ui_down"):
		var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
		
		for i in fm_size:
			if Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character == current_selection:
				print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
				
				red_selection.position
			
				if i + 1 >= fm_size:
					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0])
					red_selection.position = Vector2(63, 11)
					scroll_container_reset_line()
				else:
					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i + 1])
					if red_selection.position != Vector2(63, 11 + (12 * 5)):
						red_selection.position = Vector2(63, red_selection.position.y + 12)
				
					if i >= 5 && i < fm_size:
						scroll_container_move_down_line()
				
				break
	
	elif event.is_action_pressed("ui_up"):
		var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
		
		for i in fm_size:
			if Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character == current_selection:
				print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
			
				if i - 1 <= -1:
					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_size - 1])
					red_selection.position = Vector2(63, 11 + (12 * 5))
					scroll_container_wrap_to_bottom()
				else:
					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i - 1])
					if red_selection.position != Vector2(63, 11):
						red_selection.position = Vector2(63, red_selection.position.y - 12)
				
					# temp not usable
					if i < 5:
						scroll_container_move_up_line()
			
			
				break
	
	elif event.is_action_pressed("ui_a_key"):
		var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
		
		
		
		for i in fm_size:
			if Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character == current_selection:
				print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
				
				if Singleton_Game_GlobalCommonVariables.selected_item != null:
					Singleton_Game_GlobalCommonVariables.selected_target_character = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i]
				else:
					Singleton_Game_GlobalCommonVariables.selected_character = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i]
			
				yield(get_tree().create_timer(0.1), "timeout")
				match Singleton_Game_GlobalCommonVariables.action_type:
					"SHOP_BUY": CompletePurchaseAndGiveItemToSelectedCharacter()
					
					"SHOP_SELL": StartCharacterItemSelectionForSell()
					
					# "EQUIP": 
						# equipItemsControlNode.DisplayCharacterStats(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i])
						# itemsViewControlNode.hide()
						# equipItemsControlNode.set_equip_menu_active()
					#	pass
						
					# _: itemsViewControlNode.set_item_selection_menu_active()
				
				# active = false
				
		# hide()
		# active = false
		return
		
	elif event.is_action_pressed("ui_b_key"):
		# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
		hide()
		active = false
		
		match Singleton_Game_GlobalCommonVariables.action_type:
			_: GoBackToShopItemSelectionMenu()
			# pass
		
		# Singleton_Game_GlobalCommonVariables.action_type = null
		
		# Singleton_Game_GlobalCommonVariables.menus_root_node.OverworldActionMenuRoot.OpenInventoryMenu()
	
	
func scroll_container_reset_line() -> void:
	yield(get_tree(), "idle_frame")
	ScollbarContainerNode.set_v_scroll(-16)

func scroll_container_wrap_to_bottom() -> void:
	yield(get_tree(), "idle_frame")
	var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
	# NOTE due to the extra control node we need to take away 2 from the total list size to get the 
	# visible end of list - hopefully this node gets a rework in Godot 4 and this can be cleaned and simplified
	ScollbarContainerNode.set_v_scroll(16 * (fm_size - (fm_size - 4)))

func scroll_container_move_down_line() -> void:
	scroll_container_set_vertical_scroll(16)

func scroll_container_move_up_line() -> void:
	scroll_container_set_vertical_scroll(-16)

func scroll_container_set_vertical_scroll(scroll_distance_arg: int) -> void:
	yield(get_tree(), "idle_frame")
	var x = ScollbarContainerNode.scroll_vertical
	ScollbarContainerNode.set_v_scroll(x + scroll_distance_arg)


func SelectItemOrSelectItemReciever() -> void:
	if Singleton_Game_GlobalCommonVariables.selected_item == null:
		# itemsViewControlNode.set_item_selection_menu_active()
		return
	
	if Singleton_Game_GlobalCommonVariables.selected_target_character.inventory.size() >= 4:
		# TODO: display hands full message
		
		Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
		
		return
	
	Singleton_Game_GlobalCommonVariables.selected_target_character.inventory.push_back(Singleton_Game_GlobalCommonVariables.selected_item)
	
	print(Singleton_Game_GlobalCommonVariables.selected_target_character.inventory)
	
	var li = Singleton_Game_GlobalCommonVariables.selected_target_character.inventory.size()
	Singleton_Game_GlobalCommonVariables.selected_target_character.inventory[li - 1].is_equipped = false
	
	Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(Singleton_Game_GlobalCommonVariables.selected_item_idx)
	
	# DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_target_character)
	
	Singleton_Game_GlobalCommonVariables.selected_target_character = null
	Singleton_Game_GlobalCommonVariables.selected_item = null
	Singleton_Game_GlobalCommonVariables.selected_character = null
	Singleton_Game_GlobalCommonVariables.selected_item_idx = null




func GoBackToShopItemSelectionMenu() -> void:
	# is_menu_active = false
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.interaction_attempt_to_talk()
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	hide()
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
	
	Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.s_show_shop_item_selection_menu()


# Buy (a option)
func CompletePurchaseAndGiveItemToSelectedCharacter() -> void:
	# if Singleton_Game_GlobalCommonVariables.gold < Singleton_Game_GlobalCommonVariables.selected_item.price_buy:
	# Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
	# return
	
	Singleton_Game_GlobalCommonVariables.selected_item
	
	var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
	var character = null
	
	for i in fm_size:
		if Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character == current_selection:
			print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
			character = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i]
			break
	
	if character != null:
		print(character.name, character.inventory.size())
	
	# if character != null && character.unlocked && character.inventory.size() < 4:
	if character != null && character.inventory.size() < 4:
		# if Singleton_Game_GlobalCommonVariables.main_character_player_node.name == character.name
		#
		
		character.inventory.push_back({
			"resource": Singleton_Game_GlobalCommonVariables.selected_item.resource_path,
			"is_equipped": false
		})
	else:
		Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
		return
	
	Singleton_Game_GlobalCommonVariables.gold = Singleton_Game_GlobalCommonVariables.gold - Singleton_Game_GlobalCommonVariables.selected_item.price_buy
	Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
	DisplayNewlySelectedCharacterInfo(character)
	set_menu_inactive()
	hide()
	
	# TODO: shouldn't be a new line should be two seaparate dialogue boxes per the original mega drive version
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("Here you go! Use it in good health, my friend.\nWant anything else?")
	
	Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.s_show__yes_or_no_prompt()
	var result = yield(Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.YesOrNoPromptRoot, "signal__yes_or_no_prompt__choice")
	if result == "NO":
		active = false
		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
		Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.s_show_shop_menu()
		Singleton_Game_GlobalCommonVariables.action_type = null
		
		Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
		Singleton_Game_GlobalCommonVariables.dialogue_box_node.hide()
	elif result == "YES":
		active = false
		hide()
		
		Singleton_Game_GlobalCommonVariables.action_type = "SHOP_BUY"
		
		Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
		
		Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().show()
		Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().ShopMenuPosition()
		
		Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
		Singleton_Game_GlobalCommonVariables.dialogue_box_node.show()
		
		# Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.show()
		Singleton_Game_GlobalCommonVariables.menus_root_node.ShopItemSelectionMenu.show()
		Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.s_show_shop_item_selection_menu()
		


func StartCharacterItemSelectionForSell() -> void:
	active = false
	
	$InventoryPreviewRoot.set_menu_active()
	
	pass


#func _input(event):
#	if active == false:
#		return
#
#	if event.is_action_pressed("ui_down"):
#		print("a")
#
#		var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
#
#		for i in fm_size:
#			if Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character == current_selection:
#				print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
#
#				if i + 1 >= fm_size:
#					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0])
#					red_selection.position = Vector2(21, 96)
#					scroll_container_reset_line()
#				else:
#					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i + 1])
#					if red_selection.position != Vector2(21, 96 + (12 * 5)):
#						red_selection.position = Vector2(21, red_selection.position.y + 12)
#
#					if i >= 5 && i < fm_size:
#						scroll_container_move_down_line()
#
#				break
#
#	elif event.is_action_pressed("ui_up"):
#		print("a")
#
#		var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
#
#		for i in fm_size:
#			if Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character == current_selection:
#				print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
#
#				if i - 1 <= -1:
#					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_size - 1])
#					red_selection.position = Vector2(21, 96 + (12 * 5))
#					scroll_container_wrap_to_bottom()
#				else:
#					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i - 1])
#					if red_selection.position != Vector2(21, 96):
#						red_selection.position = Vector2(21, red_selection.position.y - 12)
#
#					# temp not usable
#					if i < 5:
#						scroll_container_move_up_line()
#
#
#				break
#
#	elif event.is_action_pressed("ui_a_key"):
#		var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
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
#					"GIVE": SelectItemOrSelectItemReciever()
#
#					"EQUIP": 
#						equipItemsControlNode.DisplayCharacterStats(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i])
#						itemsViewControlNode.hide()
#						equipItemsControlNode.set_equip_menu_active()
#
#					_: itemsViewControlNode.set_item_selection_menu_active()
#
#				# active = false
#
#		# hide()
#		# active = false
#		return
#
#	elif event.is_action_pressed("ui_b_key"):
#		# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
#		hide()
#		active = false
#		Singleton_Game_GlobalCommonVariables.action_type = null
#		Singleton_Game_GlobalCommonVariables.menus_root_node.OverworldActionMenuRoot.OpenInventoryMenu()
#
#

func DisplayNewlySelectedCharacterInfo(force_member) -> void:
	DisplayItemsFullInfo(force_member)
	
	var c = force_member
	current_selection = c.character
	
	if cnode != null:
		cnode.queue_free()
	
	cnode = load(c.character_base_node).instance();
	var cnode_actor = cnode.get_actor_root_node_internal()
	# print(cnode, cnode_actor)
	
	portrait_sprite.texture = cnode_actor.texture_protrait
	# selected_character_info_name_label.text = c.name
	# selected_character_info_class_label.text = c.class
	# selected_character_info_level_label.text = str(c.level)
	
	
#
#	# Inventory
#	for child in selected_character_info_inventory_vbox.get_children():
#		child.queue_free()
#
#	# cnode_actor.inventory_items_id;
#	# cnode_actor.is_item_equipped;
#
#	if cnode_actor.inventory_items_id.size() > 0:
#		selected_character_info_inventory_nothing.hide()
#		selected_character_info_inventory_vbox.show()
#
#		for i in cnode_actor.inventory_items_id.size():
#			var mil = MemberItemLine.instance()
#
#			mil.get_node("ItemLabel").text = cnode_actor.inventory_items_id[i].item_name
#
#			if cnode_actor.is_item_equipped[i]:
#				mil.get_node("EquippedStaticLabel").show()
#			else:
#				mil.get_node("EquippedStaticLabel").hide()
#
#			selected_character_info_inventory_vbox.add_child(mil)
#
#	else:
#		selected_character_info_inventory_nothing.show()
#		selected_character_info_inventory_vbox.hide()


func DisplayItemsFullInfo(force_member) -> void:
	var c = force_member
	CleanDisplayItemsFullInfoForNextDisplay()
	
	# itemsViewControlNode
	
	var i = 0
	for item in c.inventory:
		var irl = load(item.resource)
		print(irl)
		InventoryPreviewRoot.get_child(i).texture = irl.texture
		
		# itemsView_itemNameAndEquippedControlNode.get_child(i).get_child(1).text = irl.item_name
		# if force_member.inventory[i].is_equipped:
		# itemsView_itemNameAndEquippedControlNode.get_child(i).get_child(0).show()
		
		i = i + 1

func CleanDisplayItemsFullInfoForNextDisplay() -> void:
	for i in 4:
		InventoryPreviewRoot.get_child(i).texture = EmptyItemSlotTexture
		
		# itemsView_itemNameAndEquippedControlNode.get_child(i).get_child(1).text = ""
		# itemsView_itemNameAndEquippedControlNode.get_child(i).get_child(0).hide()

#
#func SelectItemOrSelectItemReciever() -> void:
#	if Singleton_Game_GlobalCommonVariables.selected_item == null:
#		itemsViewControlNode.set_item_selection_menu_active()
#		return
#
#	if Singleton_Game_GlobalCommonVariables.selected_target_character.inventory.size() >= 4:
#		# TODO: display hands full message
#
#		Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
#
#		return
#
#	Singleton_Game_GlobalCommonVariables.selected_target_character.inventory.push_back(Singleton_Game_GlobalCommonVariables.selected_item)
#
#	print(Singleton_Game_GlobalCommonVariables.selected_target_character.inventory)
#
#	var li = Singleton_Game_GlobalCommonVariables.selected_target_character.inventory.size()
#	Singleton_Game_GlobalCommonVariables.selected_target_character.inventory[li - 1].is_equipped = false
#
#	Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(Singleton_Game_GlobalCommonVariables.selected_item_idx)
#
#	DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_target_character)
#
#	Singleton_Game_GlobalCommonVariables.selected_target_character = null
#	Singleton_Game_GlobalCommonVariables.selected_item = null
#	Singleton_Game_GlobalCommonVariables.selected_character = null
#	Singleton_Game_GlobalCommonVariables.selected_item_idx = null
