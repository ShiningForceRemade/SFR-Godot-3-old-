extends Control

onready var itemTextRedSelection = $ItemTextRedSelectionBorderRoot

const ITEM_TEXT_SELECTION_POSITIONS = [
	Vector2(155, 8),
	Vector2(155, 22),
	Vector2(155, 38),
	Vector2(155, 54),
]

enum E_SelectedItem {
	UP,
	LEFT,
	RIGHT,
	DOWN
}
var selected_item: int = E_SelectedItem.UP

var is_item_view_selection_menu_active: bool = false
# 

func _ready():
	pass


func set_item_selection_menu_active():
	if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() > 0:
		get_parent().get_parent().active = false
		is_item_view_selection_menu_active = true
		itemTextRedSelection.position = ITEM_TEXT_SELECTION_POSITIONS[0]
		selected_item = E_SelectedItem.UP
		itemTextRedSelection.show()
	else:
		Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")

func set_item_selection_menu_inactive():
	is_item_view_selection_menu_active = false
	itemTextRedSelection.hide()


func _process(_delta):
	if !is_item_view_selection_menu_active:
		return

# UI navigation based on icons maybe make this a settings choice
#	if Input.is_action_just_pressed("ui_down"):
#		if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() >= 4:
#			itemTextRedSelection.position = ITEM_TEXT_SELECTION_POSITIONS[3]
#			selected_item = E_SelectedItem.DOWN
#	elif Input.is_action_just_pressed("ui_up"):
#		if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() >= 1:
#			itemTextRedSelection.position = ITEM_TEXT_SELECTION_POSITIONS[0]
#			selected_item = E_SelectedItem.UP
#	elif Input.is_action_just_pressed("ui_left"):
#		if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() >= 2:
#			itemTextRedSelection.position = ITEM_TEXT_SELECTION_POSITIONS[1]
#			selected_item = E_SelectedItem.LEFT
#	elif Input.is_action_just_pressed("ui_right"):
#		if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() >= 3:
#			itemTextRedSelection.position = ITEM_TEXT_SELECTION_POSITIONS[2]
#			selected_item = E_SelectedItem.RIGHT
	
	
	if Input.is_action_just_pressed("ui_down"):
		if (selected_item + 1) < 4 && (Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() > (selected_item + 1)):
			itemTextRedSelection.position = ITEM_TEXT_SELECTION_POSITIONS[selected_item + 1]
			selected_item = selected_item + 1
	elif Input.is_action_just_pressed("ui_up"):
		if (selected_item - 1) > -1:
			itemTextRedSelection.position = ITEM_TEXT_SELECTION_POSITIONS[selected_item - 1]
			selected_item = selected_item - 1
	
	if Input.is_action_just_pressed("ui_a_key"):
		print("")
		
		match Singleton_Game_GlobalCommonVariables.action_type:
			"GIVE": SetFindTargetOfGiveItem()
			"EQUIP": SetEquipMenuActiveForCharacter()
			"DROP": DropItemFromCharacter()
			"USE": UseItemFromCharacter()
			
		return
	elif Input.is_action_just_pressed("ui_b_key"):
		set_item_selection_menu_inactive()
		get_parent().get_parent().active = true
#		Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
#		hide()
# 		active = false
	

func DropItemFromCharacter() -> void:
	# print(Singleton_Game_GlobalCommonVariables.selected_character.inventory, selected_item)
	Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(selected_item)
	itemTextRedSelection.position = ITEM_TEXT_SELECTION_POSITIONS[0]
	selected_item = E_SelectedItem.UP
	get_parent().get_parent().DisplayItemsFullInfo(Singleton_Game_GlobalCommonVariables.selected_character)
	
	if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() == 0:
		set_item_selection_menu_inactive()
		get_parent().get_parent().active = true

func UseItemFromCharacter() -> void:
	# if Singleton_Game_GlobalCommonVariables.selected_character.inventory.size() >= selected_item:
	#	Singleton_Game_GlobalCommonVariables.selected_character.inventory[selected_item]
	
	Singleton_Game_AudioManager.play_sfx("res://Assets/SF2/Sounds/SFX/sfx_Error.wav")
	
	# TODO: the rest of this when working on Chapter 2


func SetEquipMenuActiveForCharacter() -> void:
	# Singleton_Game_GlobalCommonVariables.selected_character
	hide()
	is_item_view_selection_menu_active = false
	
	get_parent().get_parent().equipItemsControlNode.show()
	get_parent().get_parent().equipItemsControlNode.DisplayCharacterStats(Singleton_Game_GlobalCommonVariables.selected_character)
	
	# TODO: impl
	


func SelectCharacterToRecieveItem() -> void:
	# Singleton_Game_GlobalCommonVariables.selected_character
	pass
	# TODO: impl
	

func SetFindTargetOfGiveItem() -> void:
	# print(Singleton_Game_GlobalCommonVariables.selected_character.inventory, selected_item)
	Singleton_Game_GlobalCommonVariables.selected_item = Singleton_Game_GlobalCommonVariables.selected_character.inventory[selected_item]
	# TODO: clean var names to be clearer later
	Singleton_Game_GlobalCommonVariables.selected_item_idx = selected_item
	
	# Singleton_Game_GlobalCommonVariables.selected_character.inventory.remove(selected_item)
	# itemTextRedSelection.position = ITEM_TEXT_SELECTION_POSITIONS[0]
	# selected_item = E_SelectedItem.UP
	# get_parent().get_parent().DisplayItemsFullInfo(Singleton_Game_GlobalCommonVariables.selected_character)
	
	set_item_selection_menu_inactive()
	get_parent().get_parent().active = true
	
	# pass

### none of these should really be globals
#var selected_character = null
#var selected_item = null
#var selected_target_character = null
#var action_type = null
