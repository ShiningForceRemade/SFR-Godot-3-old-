extends Node2D

# TODO really need to move to the node process method instead of a hardcoded active variable
var active = false

var cnode = null

var EmptyItemSlotTexture = preload("res://Assets/SFCD/Items/EmptyItemSlot.png")

var MemberSelectionLine = load("res://General/ControlsOverworld/MicroMemberListView/MemberSelectionLine.tscn")

var MemberMagicLine = load("res://General/ControlsOverworld/MicroMemberListView/MemberMagicLine.tscn")
var MemberItemLine = load("res://General/ControlsOverworld/MicroMemberListView/MemberItemLine.tscn")

@onready var ScollbarContainerNode = $StatNinePatchRect2/ScrollContainer

@onready var portrait_sprite = $PortraitWrapperNode/PortraitSprite

@onready var red_selection = $RedSelectionBorderRoot

@onready var flist_vbox_container = $StatNinePatchRect2/ScrollContainer/VBoxContainer

@onready var InventoryPreviewRoot = $InventoryPreviewRoot

var current_selection = null

const default_position: Vector2 = Vector2(68, 17)
const vertical_offset: int = 10

var internal_sfgdn_force_members_array: Array = []

func _ready():
	Singleton_CommonVariables.ui__micro_member_list_view = self
	var invisible_scrollbar_theme = Theme.new()
	var empty_stylebox = StyleBoxEmpty.new()
	invisible_scrollbar_theme.set_stylebox("scroll", "VScrollBar", empty_stylebox)
	invisible_scrollbar_theme.set_stylebox("scroll", "HScrollBar", empty_stylebox)
	ScollbarContainerNode.get_v_scroll_bar().theme = invisible_scrollbar_theme
	ScollbarContainerNode.get_h_scroll_bar().theme = invisible_scrollbar_theme
	
	DisplayNewlySelectedCharacterInfo(Singleton_CommonVariables.sf_game_data_node.ForceMembers[0])
	
	load_force_members()
	
	pass


func load_force_members() -> void:
	for child in flist_vbox_container.get_children():
		child.queue_free()
	
	internal_sfgdn_force_members_array = []
	
	for character in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
		if !character.unlocked:
			continue
		
		internal_sfgdn_force_members_array.push_back(character)
		
		var CLine = MemberSelectionLine.instantiate()
		
		if character.active_in_force:
			CLine.get_node("ActiveForceStaticLabel").show()
		else:
			CLine.get_node("ActiveForceStaticLabel").hide()
		
		if character.alive:
			CLine.get_node("DeadStaticLabel").hide()
		else:
			CLine.get_node("DeadStaticLabel").show()
		
		CLine.get_node("NameStaticLabel").text = character.name
		CLine.get_node("ClassStaticLabel").text = character.class_full
		CLine.get_node("LevelStaticLabel").text = str(character.level)
		
		flist_vbox_container.add_child(CLine)
	
	# Remove this if Godot 4 fixes this
	# fake last item to prevent godot clipping issues
	var CLine = MemberSelectionLine.instantiate()
	CLine.hide()
	flist_vbox_container.add_child(CLine)


func set_menu_active() -> void:
	active = true
	InventoryPreviewRoot.show()


func HideInventoryPreview() -> void:
	InventoryPreviewRoot.hide()

# DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0])
	
#	if current_selection == null:
#		current_selection == Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0].character
#		Singleton_Game_GlobalCommonVariables.selected_character = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0]
#	else:
#		var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
#
#		for i in fm_size:
#			if Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character == current_selection:
#				current_selection = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character
#				Singleton_Game_GlobalCommonVariables.selected_character = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i]
#
	# red_selection.position = Vector2(63, 11)
	# scroll_container_reset_line()
	# Singleton_Game_GlobalCommonVariables.selected_character = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0]
	# DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0])


func set_menu_inactive() -> void:
	active = false
	# InventoryPreviewRoot.CleanItemSlots()
	# red_selection.position = Vector2(63, 11)


func _input(event):
	if active == false:
		return
	
	if event.is_action_pressed("ui_down"):
		var fm_size = internal_sfgdn_force_members_array.size()
		
		for i in fm_size:
			if internal_sfgdn_force_members_array[i].character == current_selection:
				# print(Singleton_CommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
				
				# red_selection.position
			
				if i + 1 >= fm_size:
					DisplayNewlySelectedCharacterInfo(internal_sfgdn_force_members_array[0])
					red_selection.position = default_position
					scroll_container_reset_line()
				else:
					DisplayNewlySelectedCharacterInfo(internal_sfgdn_force_members_array[i + 1])
					if red_selection.position != Vector2(default_position.x, vertical_offset + (vertical_offset * 7) - 3):
						red_selection.position = Vector2(default_position.x, red_selection.position.y + vertical_offset)
					
					# print(i, fm_size, red_selection.position)
					if i >= 6 && i < fm_size:
						print(i, " ", fm_size, " ", red_selection.position)
						print("awevawevawev")
						scroll_container_move_down_line()
				
				break
	
	elif event.is_action_pressed("ui_up"):
		var fm_size = internal_sfgdn_force_members_array.size()
		
		for i in fm_size:
			if internal_sfgdn_force_members_array[i].character == current_selection:
				# print(Singleton_CommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
			
				if i - 1 <= -1:
					DisplayNewlySelectedCharacterInfo(internal_sfgdn_force_members_array[fm_size - 1])
					
					if fm_size > 6:
						red_selection.position = Vector2(default_position.x, vertical_offset + (vertical_offset * 7) - 3)
						scroll_container_wrap_to_bottom()
					else:
						red_selection.position = Vector2(default_position.x, vertical_offset + (vertical_offset * fm_size) - 3)
					
				else:
					DisplayNewlySelectedCharacterInfo(internal_sfgdn_force_members_array[i - 1])
					if red_selection.position != default_position:
						red_selection.position = Vector2(default_position.x, red_selection.position.y - vertical_offset)
				
					# temp not usable
					if i < 4:
						scroll_container_move_up_line()
			
			
				break
	
	elif event.is_action_pressed("ui_a_key"):
		var fm_size = internal_sfgdn_force_members_array.size()
		
		for i in fm_size:
			if internal_sfgdn_force_members_array[i].character == current_selection:
				print(internal_sfgdn_force_members_array[i].character, current_selection)
				
				if Singleton_CommonVariables.selected_item != null:
					Singleton_CommonVariables.selected_target_character = internal_sfgdn_force_members_array[i]
				else:
					Singleton_CommonVariables.selected_character = internal_sfgdn_force_members_array[i]
			
				await Signal(get_tree().create_timer(0.1), "timeout")
				match Singleton_CommonVariables.action_type:
					"SHOP_BUY": CompletePurchaseAndGiveItemToSelectedCharacter()
					
					"SHOP_SELL":
						Singleton_CommonVariables.selected_character = internal_sfgdn_force_members_array[i]
						StartCharacterItemSelectionForSell()
					
					"HQ_JOIN_OR_LEAVE":
						Singleton_CommonVariables.selected_character = internal_sfgdn_force_members_array[i]
						ToggleActiveInForceStatusForCharacter()
						
					"PRIEST_DEAD":
						Singleton_CommonVariables.selected_character = internal_sfgdn_force_members_array[i]
						ConfirmRevieveCharacter()
					
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
		
		match Singleton_CommonVariables.action_type:
			"PRIEST_DEAD": GoBackToPriestMenu()
			
			"HQ_JOIN_OR_LEAVE": GoBackToHQMenu()
			
			_: GoBackToShopItemSelectionMenu()
			# pass
		
		# Singleton_Game_GlobalCommonVariables.action_type = null
		
		# Singleton_Game_GlobalCommonVariables.menus_root_node.OverworldActionMenuRoot.OpenInventoryMenu()
	
	
func scroll_container_reset_line() -> void:
	await get_tree().process_frame
	ScollbarContainerNode.set_v_scroll(-vertical_offset)

func scroll_container_wrap_to_bottom() -> void:
	await get_tree().process_frame
	var fm_size = internal_sfgdn_force_members_array.size()
	# NOTE due to the extra control node we need to take away 2 from the total list size to get the 
	# visible end of list - hopefully this node gets a rework in Godot 4 and this can be cleaned and simplified
	# ScollbarContainerNode.set_v_scroll(vertical_offset * (fm_size - (fm_size - 4)))
	
	ScollbarContainerNode.set_v_scroll(vertical_offset * (fm_size - (fm_size - 3)))

func scroll_container_move_down_line() -> void:
	scroll_container_set_vertical_scroll(vertical_offset)

func scroll_container_move_up_line() -> void:
	scroll_container_set_vertical_scroll(-vertical_offset)

func scroll_container_set_vertical_scroll(scroll_distance_arg: int) -> void:
	await get_tree().process_frame # yield(get_tree(), "idle_frame")
	var x = ScollbarContainerNode.scroll_vertical
	ScollbarContainerNode.set_v_scroll(x + scroll_distance_arg)


func SelectItemOrSelectItemReciever() -> void:
	if Singleton_CommonVariables.selected_item == null:
		# itemsViewControlNode.set_item_selection_menu_active()
		return
	
	if Singleton_CommonVariables.selected_target_character.inventory.size() >= 4:
		# TODO: display hands full message
		
		Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
		
		return
	
	Singleton_CommonVariables.selected_target_character.inventory.push_back({
		"resource": Singleton_CommonVariables.selected_item.resource_path,
		"is_equipped": false
	})
	
	print(Singleton_CommonVariables.selected_target_character.inventory)
	
	var li = Singleton_CommonVariables.selected_target_character.inventory.size()
	Singleton_CommonVariables.selected_target_character.inventory[li - 1].is_equipped = false
	
	Singleton_CommonVariables.selected_character.inventory.remove(Singleton_CommonVariables.selected_item_idx)
	
	# DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.selected_target_character)
	
	Singleton_CommonVariables.selected_target_character = null
	Singleton_CommonVariables.selected_item = null
	Singleton_CommonVariables.selected_character = null
	Singleton_CommonVariables.selected_item_idx = null




func GoBackToShopItemSelectionMenu() -> void:
	# is_menu_active = false
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.interaction_attempt_to_talk()
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	hide()
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
	# Singleton_CommonVariables.menus_root_node.ShopMenuWrapperNode.s_show_shop_item_selection_menu()
	Singleton_CommonVariables.ui__shop_item_selection_menu.show_with_tween() #  s_show_shop_item_selection_menu()

func GoBackToPriestMenu() -> void:
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	hide()
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
	Singleton_CommonVariables.dialogue_box_node.hide()
	Singleton_CommonVariables.ui__priest_menu.s_show_priest_menu()


func GoBackToHQMenu() -> void:
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	hide()
	# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
	Singleton_CommonVariables.dialogue_box_node.hide()
	Singleton_CommonVariables.ui__hq_menu.show_with_tween()


# Buy (a option)
func CompletePurchaseAndGiveItemToSelectedCharacter() -> void:
	# if Singleton_Game_GlobalCommonVariables.gold < Singleton_Game_GlobalCommonVariables.selected_item.price_buy:
	# Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
	# return
	
	# Singleton_Game_GlobalCommonVariables.selected_item
	
	var fm_size = internal_sfgdn_force_members_array.size()
	var character = null
	
	for i in fm_size:
		if internal_sfgdn_force_members_array[i].character == current_selection:
			print(internal_sfgdn_force_members_array[i].character, current_selection)
			character = internal_sfgdn_force_members_array[i]
			break
	
	if character != null:
		print(character.name, character.inventory.size())
	
	# if character != null && character.unlocked && character.inventory.size() < 4:
	if character != null && character.inventory.size() < 4:
		# if Singleton_Game_GlobalCommonVariables.main_character_player_node.name == character.name
		#
		
		character.inventory.push_back({
			"resource": Singleton_CommonVariables.selected_item.resource_path,
			"is_equipped": false
		})
	else:
		Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
		return
	
	Singleton_CommonVariables.gold = Singleton_CommonVariables.gold - Singleton_CommonVariables.selected_item.price_buy
	Singleton_CommonVariables.ui__gold_info_box.UpdateGoldAmountDisplay()
	DisplayNewlySelectedCharacterInfo(character)
	set_menu_inactive()
	hide()
	
	# TODO: shouldn't be a new line should be two seaparate dialogue boxes per the original mega drive version
	
	Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable("Here you go! Use it in good health, my friend.\nWant anything else?")
	
	Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
	var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
	if result == "NO":
		active = false
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
		Singleton_CommonVariables.ui__shop_menu.s_show_shop_menu()
		Singleton_CommonVariables.action_type = null
		
		Singleton_CommonVariables.ui__gold_info_box.hide()
		Singleton_CommonVariables.dialogue_box_node.hide()
	elif result == "YES":
		active = false
		hide()
		
		Singleton_CommonVariables.action_type = "SHOP_BUY"
		
		Singleton_CommonVariables.ui__actor_micro_info_box.hide()
		
		Singleton_CommonVariables.ui__gold_info_box.show()
		Singleton_CommonVariables.ui__gold_info_box.ShopMenuPosition()
		
		Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
		Singleton_CommonVariables.dialogue_box_node.show()
		
		# Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.show()
		
		await Signal(get_tree().create_timer(0.1), "timeout")
		
		Singleton_CommonVariables.ui__shop_item_selection_menu.show_with_tween()
		#Singleton_CommonVariables.ui__shop_item_selection_menu.s_show_shop_item_selection_menu()
		


func ConfirmRevieveCharacter() -> void:	
	var fm_size = internal_sfgdn_force_members_array.size()
	var character = null
	
	if Singleton_CommonVariables.selected_character.alive:
		Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
		return
	
	var fmidx = 0
	for i in fm_size:
		if internal_sfgdn_force_members_array[i].name == Singleton_CommonVariables.selected_character.name:
			print(internal_sfgdn_force_members_array[i].name)
			character = internal_sfgdn_force_members_array[i]
			fmidx = i
			print("fmidx - " + str(fmidx))
			break
	
	if character == null:
		Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
		return
		
	print(character.name)
	
	set_menu_inactive()
	
	var revive_cost = character.level * 100
	
	Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable("Oh, my! " + character.name + " is in bad shape. I can revive them, but it will cost " + str(revive_cost) + " coins.\nAgreed?")
	
	Singleton_CommonVariables.ui__yes_or_no_prompt.s_show__yes_or_no_prompt()
	var result = await Signal(Singleton_CommonVariables.ui__yes_or_no_prompt, "signal__yes_or_no_prompt__choice")
	if result == "NO":
		active = true
		Singleton_CommonVariables.main_character_player_node.set_active_processing(false)
		# Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.s_show_shop_menu()
		# Singleton_Game_GlobalCommonVariables.action_type = null
		
		Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable("Remember that I'm always willing to record your deeds.")
		
		# Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
		# Singleton_Game_GlobalCommonVariables.dialogue_box_node.hide()
	elif result == "YES":
		active = true
		
		internal_sfgdn_force_members_array[fmidx].alive = true
		Singleton_CommonVariables.sf_game_data_node.ForceMembers[character.character].alive = true
		
		flist_vbox_container.get_child(fmidx).get_node("DeadStaticLabel").hide()
		
		# Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().show()
		# Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().ShopMenuPosition()
		
		Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(character.name + " has revived!\n")
		Singleton_CommonVariables.dialogue_box_node.show()
	
	#	Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
	
	# Singleton_Game_GlobalCommonVariables.gold = Singleton_Game_GlobalCommonVariables.gold - Singleton_Game_GlobalCommonVariables.selected_item.price_buy
	# Singleton_Game_GlobalCommonVariables.menus_root_node.GoldInfoBox.UpdateGoldAmountDisplay()
	# DisplayNewlySelectedCharacterInfo(character)
	
	# hide()
	
	# TODO: shouldn't be a new line should be two seaparate dialogue boxes per the original mega drive version
#
#	Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("Here you go! Use it in good health, my friend.\nWant anything else?")
#
#	Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.s_show__yes_or_no_prompt()
#	var result = yield(Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.YesOrNoPromptRoot, "signal__yes_or_no_prompt__choice")
#	if result == "NO":
#		active = false
#		Singleton_Game_GlobalCommonVariables.main_character_player_node.set_active_processing(false)
#		Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.s_show_shop_menu()
#		Singleton_Game_GlobalCommonVariables.action_type = null
#
#		Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
#		Singleton_Game_GlobalCommonVariables.dialogue_box_node.hide()
#	elif result == "YES":
#		active = false
#		hide()
#
#		Singleton_Game_GlobalCommonVariables.action_type = "SHOP_BUY"
#
#		Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
#
#		Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().show()
#		Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().ShopMenuPosition()
#
#		Singleton_Game_GlobalCommonVariables.dialogue_box_node.play_message_none_interactable("What would you like?")
#		Singleton_Game_GlobalCommonVariables.dialogue_box_node.show()
#
#		# Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.show()
#		Singleton_Game_GlobalCommonVariables.menus_root_node.ShopItemSelectionMenu.show()
#		Singleton_Game_GlobalCommonVariables.menus_root_node.ShopMenuWrapperNode.s_show_shop_item_selection_menu()

func ToggleActiveInForceStatusForCharacter() -> void:
	active = true
	var fm_size = internal_sfgdn_force_members_array.size()
	var character = null
	
	var fmidx = 0
	for i in fm_size:
		if internal_sfgdn_force_members_array[i].name == Singleton_CommonVariables.selected_character.name:
			# print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].name)
			character = internal_sfgdn_force_members_array[i]
			fmidx = i
			# print("fmidx - " + str(fmidx))
			break
	
	if character == null:
		Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
		return
	
	if Singleton_CommonVariables.sf_game_data_node.ForceMembers[character.character].active_in_force:
		Singleton_CommonVariables.sf_game_data_node.ForceMembers[character.character].active_in_force = false
		internal_sfgdn_force_members_array[fmidx].active_in_force = false
		flist_vbox_container.get_child(fmidx).get_node("ActiveForceStaticLabel").hide()
		Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(character.name + " has gone to the reserves!\n")
	else:
		Singleton_CommonVariables.sf_game_data_node.ForceMembers[character.character].active_in_force = true
		internal_sfgdn_force_members_array[fmidx].active_in_force = true
		flist_vbox_container.get_child(fmidx).get_node("ActiveForceStaticLabel").show()
		Singleton_CommonVariables.dialogue_box_node.play_message_none_interactable(character.name + " has joined the active force!\n")
	
	Singleton_CommonVariables.dialogue_box_node.show()
	pass

func StartCharacterItemSelectionForSell() -> void:
	active = false
	
	$InventoryPreviewRoot.set_menu_active()
	
	pass


func DisplayNewlySelectedCharacterInfo(force_member) -> void:
	DisplayItemsFullInfo(force_member)
	
	var c = force_member
	current_selection = c.character
	
	if cnode != null:
		cnode.queue_free()
	
	print("TODO: FIXME MicroMemberListView - use singleton values instead of character nodes")
#	print(c.character_base_node)
#	cnode = load(c.character_base_node)
#	cnode = cnode.instantiate()
#	var cnode_actor = cnode.get_actor_root_node_internal()
#
#	if cnode_actor.promotion_stage == 0:
#		if cnode_actor.texture_sprite_portrait_unpromoted != null:
#			portrait_sprite.texture = cnode_actor.texture_sprite_portrait_unpromoted
#	elif cnode_actor.promotion_stage == 1:
#		if cnode_actor.texture_sprite_portrait_promoted != null:
#			portrait_sprite.texture = cnode_actor.texture_sprite_portrait_promoted


func DisplayItemsFullInfo(force_member) -> void:
	var c = force_member
	CleanDisplayItemsFullInfoForNextDisplay()
	
	var i = 0
	for item in c.inventory:
		var irl = load(item.resource)
		print("irl", irl)
		if irl != null:
			InventoryPreviewRoot.get_child(i).texture = irl.texture
			
		i = i + 1


func CleanDisplayItemsFullInfoForNextDisplay() -> void:
	for i in 4:
		InventoryPreviewRoot.get_child(i).texture = EmptyItemSlotTexture



#	Singleton_Game_GlobalCommonVariables.selected_target_character = null
#	Singleton_Game_GlobalCommonVariables.selected_item = null
#	Singleton_Game_GlobalCommonVariables.selected_character = null
#	Singleton_Game_GlobalCommonVariables.selected_item_idx = null

