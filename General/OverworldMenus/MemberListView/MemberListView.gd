extends Node2D

# TODO really need to move to the node process method instead of a hardcoded active variable
var active = false

var cnode = null

var MemberSelectionLine = load("res://General/OverworldMenus/MemberListView/MemberSelectionLine.tscn")

var MemberMagicLine = load("res://General/OverworldMenus/MemberListView/MemberMagicLine.tscn")
var MemberItemLine = load("res://General/OverworldMenus/MemberListView/MemberItemLine.tscn")

onready var portrait_sprite = $PortraitWrapperNode/PortraitSprite

onready var red_selection = $RedSelectionBorderRoot


onready var selected_character_info_name_label = $StatNinePatchRect/NameLabel
onready var selected_character_info_class_label = $StatNinePatchRect/ClassLabel
onready var selected_character_info_level_label = $StatNinePatchRect/LevelLabel

onready var selected_character_info_magic_vbox = $StatNinePatchRect/SpellsVBoxContainer
onready var selected_character_info_magic_nothing = $StatNinePatchRect/MagicNothingStaticLabel

onready var selected_character_info_inventory_vbox = $StatNinePatchRect/InventoryVBoxContainer
onready var selected_character_info_inventory_nothing = $StatNinePatchRect/ItemsNothingStaticLabel

onready var flist_vbox_container = $StatNinePatchRect2/ScrollContainer/VBoxContainer

var current_selection = null

func _ready():
	
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
		
	
	pass


func _input(event):
	if event.is_action_pressed("ui_down"):
		print("a")
		
		var fm_size = Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers.size()
		
		for i in fm_size:
			if Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character == current_selection:
				print(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i].character, current_selection)
				
				if i + 1 >= fm_size:
					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[0])
					
					red_selection.position = Vector2(10, 96)
				else:
					DisplayNewlySelectedCharacterInfo(Singleton_Game_GlobalCommonVariables.sf_game_data_node.ForceMembers[i + 1])
					red_selection.position = Vector2(10, red_selection.position.y + 12)
				
				break
		


func DisplayNewlySelectedCharacterInfo(force_member) -> void:
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
		selected_character_info_magic_nothing.show()
		selected_character_info_inventory_nothing.hide()


