extends Node2D

# TODO really need to move to the node process method instead of a hardcoded active variable
var active = false

var cnode = null

var EmptyItemSlotTexture = preload("res://Assets/SFCD/Items/EmptyItemSlot.png")

var MemberSelectionLine = preload("res://General/ControlsOverworld/MemberListView/MemberSelectionLine.tscn")

var MemberMagicLine = preload("res://General/ControlsOverworld/MemberListView/MemberMagicLine.tscn")
var MemberItemLine = preload("res://General/ControlsOverworld/MemberListView/MemberItemLine.tscn")

@onready var ScollbarContainerNode = $StatNinePatchRect2/ScrollContainer

@onready var portrait_sprite = $PortraitWrapperNode/PortraitSprite

@onready var red_selection = $RedSelectionBorderRoot


@onready var selected_character_info_name_label = $StatNinePatchRect/StaticCharacterInfoControlNode/NameLabel
@onready var selected_character_info_class_label = $StatNinePatchRect/StaticCharacterInfoControlNode/ClassLabel
@onready var selected_character_info_level_label = $StatNinePatchRect/StaticCharacterInfoControlNode/LevelLabel

@onready var overview_mangic_and_inventory_control_node = $StatNinePatchRect/OverviewMagicAndInventoryControlNode

@onready var selected_character_info_magic_vbox = $StatNinePatchRect/OverviewMagicAndInventoryControlNode/SpellsVBoxContainer
@onready var selected_character_info_magic_nothing = $StatNinePatchRect/OverviewMagicAndInventoryControlNode/MagicNothingStaticLabel

@onready var selected_character_info_inventory_vbox = $StatNinePatchRect/OverviewMagicAndInventoryControlNode/InventoryVBoxContainer
@onready var selected_character_info_inventory_nothing = $StatNinePatchRect/OverviewMagicAndInventoryControlNode/ItemsNothingStaticLabel

@onready var flist_vbox_container = $StatNinePatchRect2/ScrollContainer/VBoxContainer

### ItemIconsControlNode
@onready var itemsViewControlNode = $StatNinePatchRect/ItemsViewControl
@onready var itemsView_itemIconsControlNode = $StatNinePatchRect/ItemsViewControl/ItemIconsControlNode
@onready var itemsView_itemNameAndEquippedControlNode = $StatNinePatchRect/ItemsViewControl/ItemNameAndEquippedControlNode
### ItemIconsControlNode

### EquipItemsControlNode
@onready var equipItemsControlNode = $StatNinePatchRect/EquipItemsViewControl
### EquipItemsControlNode

var current_selection = null
var unlocked_characters_size = 0

func _ready():
	Singleton_CommonVariables.ui__member_list_menu = self
	
	var invisible_scrollbar_theme = Theme.new()
	var empty_stylebox = StyleBoxEmpty.new()
	invisible_scrollbar_theme.set_stylebox("scroll", "VScrollBar", empty_stylebox)
	invisible_scrollbar_theme.set_stylebox("scroll", "HScrollBar", empty_stylebox)
	# ScollbarContainerNode.get_v_scrollbar().theme = invisible_scrollbar_theme
	# ScollbarContainerNode.get_h_scrollbar().theme = invisible_scrollbar_theme
	
	DisplayNewlySelectedCharacterInfo(Singleton_CommonVariables.sf_game_data_node.ForceMembers[0])
	
	# Test not used node
	# var c = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0]
	# flist_vbox_container.get_node("CharacterWrapperNode/NameStaticLabel").text = c.name
	# flist_vbox_container.get_node("CharacterWrapperNode/ClassStaticLabel").text = c.class
	# flist_vbox_container.get_node("CharacterWrapperNode/LevelStaticLabel").text = str(c.level)
	
	load_character_lines()
	
	pass


func set_menu_active() -> void:
	active = true


func set_items_view_active():
	overview_mangic_and_inventory_control_node.hide()
	DisplayNewlySelectedCharacterInfo(Singleton_CommonVariables.sf_game_data_node.ForceMembers[0])
#	itemsViewControlNode.CleanItemSlots()
#	itemsViewControlNode.DisplayItems()
	
	current_selection = Singleton_CommonVariables.sf_game_data_node.ForceMembers[0].name
	red_selection.position = Vector2(21, 94)
	
	equipItemsControlNode.CleanItemSlots()
	itemsViewControlNode.show()


func set_overvview_view_active():
	itemsViewControlNode.hide()
	itemsViewControlNode.CleanItemSlots()
	overview_mangic_and_inventory_control_node.show()


func load_character_lines() -> void:
	for child in flist_vbox_container.get_children():
		child.queue_free()
	
	unlocked_characters_size = 0
	
	for character in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
		if !character.unlocked:
			continue
		
		unlocked_characters_size += 1
		
		var CLine = MemberSelectionLine.instantiate()
		
		if character.active_in_force:
			CLine.get_node("ActiveForceStaticLabel").show()
		else:
			CLine.get_node("ActiveForceStaticLabel").hide()
		
		CLine.get_node("NameStaticLabel").text = character.name
		CLine.get_node("ClassStaticLabel").text = character.class_full
		CLine.get_node("LevelStaticLabel").text = str(character.level)
		
		flist_vbox_container.add_child(CLine)
	
	# Remove this if Godot 4 fixes this
	# fake last item to prevent godot clipping issues
	if unlocked_characters_size > 5:
		var CLine = MemberSelectionLine.instantiate()
		flist_vbox_container.add_child(CLine)
	

func _input(event):
	if active == false:
		return
	
#	if event.is_action_pressed("test_key_z"):
#		load_character_lines()
	
	if event.is_action_pressed("ui_down"):
		var fm_size = Singleton_CommonVariables.sf_game_data_node.ForceMembers.size()
		
		var idx = 0
		for c in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
			if c.name == current_selection:
				break
			
			idx += 1
		
		# print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[idx].name, current_selection)
		
		if idx + 1 >= fm_size:
			if !Singleton_CommonVariables.sf_game_data_node.ForceMembers[0].unlocked:
				return
			
			DisplayNewlySelectedCharacterInfo(Singleton_CommonVariables.sf_game_data_node.ForceMembers[0])
			red_selection.position = Vector2(21, 94)
			scroll_container_reset_line()
			return
		
		while idx + 1 < fm_size:
			if !Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx + 1].unlocked:
				idx += 1
				continue
			
			if current_selection == Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx + 1].name:
				return
			
			print(Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx + 1].name)
			
			DisplayNewlySelectedCharacterInfo(Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx + 1])
			if red_selection.position != Vector2(21, 94 + (12 * 5)):
				red_selection.position = Vector2(21, red_selection.position.y + 12)
				
			if idx >= 5 && idx < fm_size:
				scroll_container_move_down_line()
		
		return
	elif event.is_action_pressed("ui_up"):
		var fm_size = Singleton_CommonVariables.sf_game_data_node.ForceMembers.size()
		
		var idx = 0
		for c in Singleton_CommonVariables.sf_game_data_node.ForceMembers:
			if c.name == current_selection:
				break
			
			idx += 1
		
		# print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[idx].name, current_selection)
		
		if idx - 1 <= -1:
			if !Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_size - 1].unlocked:
				return
				
			DisplayNewlySelectedCharacterInfo(Singleton_CommonVariables.sf_game_data_node.ForceMembers[fm_size - 1])
			red_selection.position = Vector2(21, 94 + (12 * 5))
			scroll_container_wrap_to_bottom()
		
		while idx - 1 >= 0:
			if !Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx - 1].unlocked:
				idx -= 1
				continue
			
			if current_selection == Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx - 1].name:
				return
			
			print(Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx - 1].name)
			
			DisplayNewlySelectedCharacterInfo(Singleton_CommonVariables.sf_game_data_node.ForceMembers[idx - 1])
			if red_selection.position != Vector2(21, 94):
				red_selection.position = Vector2(21, red_selection.position.y - 12)
			
			# temp not usable
			if idx < 5:
				scroll_container_move_up_line()
		
		return
	
	elif event.is_action_pressed("ui_a_key"):
		var fm_size = Singleton_CommonVariables.sf_game_data_node.ForceMembers.size()
		
		for i in fm_size:
			if Singleton_CommonVariables.sf_game_data_node.ForceMembers[i].name == current_selection:
				print(Singleton_CommonVariables.sf_game_data_node.ForceMembers[i].name, current_selection)
				
				if Singleton_CommonVariables.selected_item != null:
					Singleton_CommonVariables.selected_target_character = Singleton_CommonVariables.sf_game_data_node.ForceMembers[i]
				else:
					Singleton_CommonVariables.selected_character = Singleton_CommonVariables.sf_game_data_node.ForceMembers[i]
			
				await Signal(get_tree().create_timer(0.1), "timeout")
				match Singleton_CommonVariables.action_type:
					"GIVE": SelectItemOrSelectItemReciever()
					
					"EQUIP": 
						equipItemsControlNode.DisplayCharacterStats(Singleton_CommonVariables.sf_game_data_node.ForceMembers[i])
						itemsViewControlNode.hide()
						equipItemsControlNode.set_equip_menu_active()
						
					_: itemsViewControlNode.set_item_selection_menu_active()
				
				# active = false
				
		# hide()
		# active = false
		return
		
	elif event.is_action_pressed("ui_b_key"):
		# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
		hide()
		active = false
		# Singleton_Game_GlobalCommonVariables.action_type = null
		
		Singleton_CommonVariables.ui__inventory_menu.show()
		Singleton_CommonVariables.ui__inventory_menu.set_menu_active()
		
		Singleton_CommonVariables.selected_character = null
		Singleton_CommonVariables.selected_item = null
		Singleton_CommonVariables.selected_item_idx = null
		Singleton_CommonVariables.selected_target_character = null
		Singleton_CommonVariables.action_type = null
	
	
func scroll_container_reset_line() -> void:
	await get_tree().process_frame
	ScollbarContainerNode.set_v_scroll(-16)

func scroll_container_wrap_to_bottom() -> void:
	await get_tree().process_frame
	var fm_size = Singleton_CommonVariables.sf_game_data_node.ForceMembers.size()
	# NOTE due to the extra control node we need to take away 2 from the total list size to get the 
	# visible end of list - hopefully this node gets a rework in Godot 4 and this can be cleaned and simplified
	ScollbarContainerNode.set_v_scroll(16 * (fm_size - (fm_size - 4)))

func scroll_container_move_down_line() -> void:
	scroll_container_set_vertical_scroll(16)

func scroll_container_move_up_line() -> void:
	scroll_container_set_vertical_scroll(-16)

func scroll_container_set_vertical_scroll(scroll_distance_arg: int) -> void:
	await get_tree().process_frame
	var x = ScollbarContainerNode.scroll_vertical
	ScollbarContainerNode.set_v_scroll(x + scroll_distance_arg)


func DisplayNewlySelectedCharacterInfo(force_member) -> void:
	DisplayItemsFullInfo(force_member)
	
	var c = force_member
	current_selection = c.name
	
	if cnode != null:
		cnode.queue_free()
	
	
	cnode = load(c.textures_and_scenes[c.promotion_stage].player_scene).instantiate();
	
	print("Premature return fixme later")
	return
	
	var cnode_actor = cnode.get_actor_root_node_internal()
	
	# print(cnode, cnode_actor)
	
	if cnode_actor.promotion_stage == 0:
		portrait_sprite.texture = cnode_actor.texture_sprite_portrait_unpromoted
	
	selected_character_info_name_label.text = c.name
	selected_character_info_class_label.text = c.class_full
	selected_character_info_level_label.text = str(c.level)
	
	
	# Spells
	for child in selected_character_info_magic_vbox.get_children():
		child.queue_free()
	
	if c.magic.size() > 0:
		selected_character_info_magic_nothing.hide()
		selected_character_info_magic_vbox.show()
		
		for spell in c.magic:
			var mml = MemberMagicLine.instantiate()
			
			mml.get_node("SpellLabel").text = load(spell.resource).name
			
			selected_character_info_magic_vbox.add_child(mml)
		
	else:
		selected_character_info_magic_nothing.show()
		selected_character_info_magic_vbox.hide()
	
	
	# Inventory
	for child in selected_character_info_inventory_vbox.get_children():
		child.queue_free()
	
	# cnode_actor.inventory_items_id;
	# cnode_actor.is_item_equipped;
	
	if c.inventory.size() > 0:
		selected_character_info_inventory_nothing.hide()
		selected_character_info_inventory_vbox.show()
		
		for i in c.inventory.size():
			var mil = MemberItemLine.instantiate()
			
			mil.get_node("ItemLabel").text = load(c.inventory[i].resource).item_name
			
			if c.inventory[i].is_equipped:
				mil.get_node("EquippedStaticLabel").show()
			else:
				mil.get_node("EquippedStaticLabel").hide()
				
			selected_character_info_inventory_vbox.add_child(mil)
		
	else:
		selected_character_info_inventory_nothing.show()
		selected_character_info_inventory_vbox.hide()


func DisplayItemsFullInfo(force_member) -> void:
	var c = force_member
	CleanDisplayItemsFullInfoForNextDisplay()
	
	# itemsViewControlNode
	
	var i = 0
	for item in c.inventory:
		var irl = load(item.resource)
		print(irl)
		itemsView_itemIconsControlNode.get_child(i).texture = irl.texture
		
		itemsView_itemNameAndEquippedControlNode.get_child(i).get_child(1).text = irl.item_name
		if force_member.inventory[i].is_equipped:
			itemsView_itemNameAndEquippedControlNode.get_child(i).get_child(0).show()
		
		i = i + 1

func CleanDisplayItemsFullInfoForNextDisplay() -> void:
	for i in 4:
		itemsView_itemIconsControlNode.get_child(i).texture = EmptyItemSlotTexture
		
		itemsView_itemNameAndEquippedControlNode.get_child(i).get_child(1).text = ""
		itemsView_itemNameAndEquippedControlNode.get_child(i).get_child(0).hide()


func SelectItemOrSelectItemReciever() -> void:
	if Singleton_CommonVariables.selected_item == null:
		itemsViewControlNode.set_item_selection_menu_active()
		return
	
	if Singleton_CommonVariables.selected_target_character.inventory.size() >= 4:
		# TODO: display hands full message
		
		Singleton_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
		
		return
	
	Singleton_CommonVariables.selected_target_character.inventory.push_back(Singleton_CommonVariables.selected_item)
	
	print(Singleton_CommonVariables.selected_target_character.inventory)
	
	var li = Singleton_CommonVariables.selected_target_character.inventory.size()
	Singleton_CommonVariables.selected_target_character.inventory[li - 1].is_equipped = false
	
	Singleton_CommonVariables.selected_character.inventory.remove_at(Singleton_CommonVariables.selected_item_idx)
	
	DisplayNewlySelectedCharacterInfo(Singleton_CommonVariables.selected_target_character)
	
	Singleton_CommonVariables.selected_target_character = null
	Singleton_CommonVariables.selected_item = null
	Singleton_CommonVariables.selected_character = null
	Singleton_CommonVariables.selected_item_idx = null
