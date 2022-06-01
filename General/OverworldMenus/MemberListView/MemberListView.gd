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


onready var selected_character_info_name_label = $StatNinePatchRect/StaticCharacterInfoControlNode/NameLabel
onready var selected_character_info_class_label = $StatNinePatchRect/StaticCharacterInfoControlNode/ClassLabel
onready var selected_character_info_level_label = $StatNinePatchRect/StaticCharacterInfoControlNode/LevelLabel

onready var selected_character_info_magic_vbox = $StatNinePatchRect/OverviewMagicAndInventoryControlNode/SpellsVBoxContainer
onready var selected_character_info_magic_nothing = $StatNinePatchRect/OverviewMagicAndInventoryControlNode/MagicNothingStaticLabel

onready var selected_character_info_inventory_vbox = $StatNinePatchRect/OverviewMagicAndInventoryControlNode/InventoryVBoxContainer
onready var selected_character_info_inventory_nothing = $StatNinePatchRect/OverviewMagicAndInventoryControlNode/ItemsNothingStaticLabel

onready var flist_vbox_container = $StatNinePatchRect2/ScrollContainer/VBoxContainer

### ItemIconsControlNode
onready var itemsViewControlNode = $StatNinePatchRect/ItemsViewControl
onready var itemsView_itemIconsControlNode = $StatNinePatchRect/ItemsViewControl/ItemIconsControlNode
onready var itemsView_itemNameAndEquippedControlNode = $StatNinePatchRect/ItemsViewControl/ItemNameAndEquippedControlNode
### ItemIconsControlNode

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
		CLine.get_node("NameStaticLabel").text = character.name
		CLine.get_node("ClassStaticLabel").text = character.class
		CLine.get_node("LevelStaticLabel").text = str(character.level)
		
		flist_vbox_container.add_child(CLine)
	
	# Remove this if Godot 4 fixes this
	# fake last item to prevent godot clipping issues
	var CLine = MemberSelectionLine.instance()
	flist_vbox_container.add_child(CLine)
	
	pass


func _input(event):
	if active == false:
		return
	
	if event.is_action_pressed("ui_down"):
		print("a")
		
		var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
		
		for i in fm_size:
			if Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character == current_selection:
				print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
				
				if i + 1 >= fm_size:
					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0])
					red_selection.position = Vector2(10, 96)
					scroll_container_reset_line()
				else:
					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i + 1])
					if red_selection.position != Vector2(10, 96 + (12 * 5)):
						red_selection.position = Vector2(10, red_selection.position.y + 12)
					
					if i >= 5 && i < fm_size:
						scroll_container_move_down_line()
				
				break
	
	elif event.is_action_pressed("ui_up"):
		print("a")
		
		var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
		
		for i in fm_size:
			if Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character == current_selection:
				print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
				
				if i - 1 <= -1:
					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[fm_size - 1])
					red_selection.position = Vector2(10, 96 + (12 * 5))
					scroll_container_wrap_to_bottom()
				else:
					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i - 1])
					if red_selection.position != Vector2(10, 96):
						red_selection.position = Vector2(10, red_selection.position.y - 12)
					
					# temp not usable
					if i < 5:
						scroll_container_move_up_line()
				
				
				break
				
	elif event.is_action_pressed("ui_b_key"):
		Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
		hide()
		active = false
	
	
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
	selected_character_info_name_label.text = c.name
	selected_character_info_class_label.text = c.class
	selected_character_info_level_label.text = str(c.level)
	
	
	# Spells
	for child in selected_character_info_magic_vbox.get_children():
		child.queue_free()
	
	if cnode_actor.spells_id.size() > 0:
		selected_character_info_magic_nothing.hide()
		selected_character_info_magic_vbox.show()
		
		for spell in cnode_actor.spells_id:
			var mml = MemberMagicLine.instance()
			
			mml.get_node("SpellLabel").text = spell.name
			
			selected_character_info_magic_vbox.add_child(mml)
		
	else:
		selected_character_info_magic_nothing.show()
		selected_character_info_magic_vbox.hide()
	
	
	# Inventory
	for child in selected_character_info_inventory_vbox.get_children():
		child.queue_free()
	
	# cnode_actor.inventory_items_id;
	# cnode_actor.is_item_equipped;
	
	if cnode_actor.inventory_items_id.size() > 0:
		selected_character_info_inventory_nothing.hide()
		selected_character_info_inventory_vbox.show()
		
		for i in cnode_actor.inventory_items_id.size():
			var mil = MemberItemLine.instance()
			
			mil.get_node("ItemLabel").text = cnode_actor.inventory_items_id[i].item_name
			
			if cnode_actor.is_item_equipped[i]:
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
	
