extends Node2D


var battle_view_selected_actor_info_menu_active: bool = false

@onready var itemInfoNode = preload("res://General/ControlsBattle/ViewSelectedActorInfoPopup/ItemMicroView/ItemMicroView.tscn")
@onready var spellInfoNode = preload("res://General/ControlsBattle/ViewSelectedActorInfoPopup/MagicMicroView/MagicMicroView.tscn")

@onready var class_label: Label = $StatsNinePatchRect/ClassLabel
@onready var name_label: Label = $StatsNinePatchRect/NameLabel
@onready var level_label: Label = $StatsNinePatchRect/LevelLabel
@onready var exp_label: Label = $StatsNinePatchRect/ExpLabel

@onready var kills_label: Label = $KillsNinePatchRect/KillsLabel
@onready var defeats_label: Label = $KillsNinePatchRect/DefeatsLabel

@onready var hp_label: Label = $StatsNinePatchRect/HPLabel
@onready var mp_label: Label = $StatsNinePatchRect/MPLabel
@onready var attack_label: Label = $StatsNinePatchRect/AttackLabel
@onready var defense_label: Label = $StatsNinePatchRect/DefenseLabel
@onready var move_label: Label = $StatsNinePatchRect/MoveLabel
@onready var agility_label: Label = $StatsNinePatchRect/AgilityLabel

# @onready var item_static_label: Label = $StatsNinePatchRect/ItemsStaticLabel
@onready var item_vbox: VBoxContainer = $StatsNinePatchRect/ItemsVBoxContainer
# @onready var magic_static_label: Label = $StatsNinePatchRect/MagicStaticLabel
@onready var magic_vbox: VBoxContainer = $StatsNinePatchRect/MagicVBoxContainer

# TODO: move this to a better place maybe a separate data script
# but having it here and in the character base route seems prone to issues
const char_class_array = ["SDMN", "KNT",
		"WARR", "SKNT", "MAGE",
		"MONK", "HEAL", "ACHR", "ASKT",
		"BDMN", "WKNT", "DRGN", 
		"RBT", "WRWF", "SMR", 
		"NINJ", "HERO", "PLDN", 
		"GLDR", "SBRN", "WIZD", 
		"MSMK", "VICR", "BWMS", 
		"SKNT", "SKYW", "SKYL",
		"GRDR", "CYBG", "WFBN", "YGRT",
		"MGCR"]


func _ready() -> void:
	Singleton_CommonVariables.view_selected_actor_info_node = self


func set_battle_view_selected_actor_info_menu_active() -> void:
	battle_view_selected_actor_info_menu_active = true
	
	# $GoldNinePatchRect/GoldAmountLabel.text = str(Singleton_Game_GlobalOverworldVariables.coins)
	
	if Singleton_BattleVariables.selected_actor_type == "Character":
		display_character_info()
	elif Singleton_BattleVariables.selected_actor_type == "Enemey":
		display_enemey_info()
	else:
		print("BUG")

func _input(event):
	if battle_view_selected_actor_info_menu_active:
		if event.is_action_released("ui_b_key"):
			for n in item_vbox.get_children():
				n.queue_free()
			for n in magic_vbox.get_children():
				n.queue_free()
			
			battle_view_selected_actor_info_menu_active = false
			Singleton_BattleVariables.selected_actor = null
			Singleton_BattleVariables.selected_actor_type = null
			
			get_parent().get_parent().s_hide_battle_view_selected_actor_info_menu()
			
			await Signal(get_tree().create_timer(0.1), "timeout")
			# re-act cursor through global ref to it
			Singleton_BattleVariables.cursor_root_ref.active = true
			

func display_character_info() -> void:
	var actor = Singleton_BattleVariables.selected_actor.get_node("CharacterRoot")
	
	# $PortraitSprite.show()
	# TODO: create protrait get function that checks if unpromtoed or promoted or other
	# $PortraitSprite.texture = actor.texture_protrait
	
	# $PortraitNinePatchRect.show()
	# $GoldNinePatchRect.show()
	
	class_label.text = char_class_array[actor.character_class]
	name_label.text = str(actor.character_name)
	
	level_label.text = str(actor.level)
	exp_label.text = str(actor.experience_points)
	
	kills_label.text = str(actor.aps_enemey_kills)
	defeats_label.text = str(actor.aps_times_defeated)
	
	display_actor_info(actor)



func display_enemey_info() -> void:
	var actor = Singleton_BattleVariables.selected_actor.get_node("EnemeyRoot")
	
	# TODO: when adding boss enemeies with sprites add a check to hide or display similar to character info minus gold display
	# $PortraitSprite.hide()
	
	# $GoldNinePatchRect.hide()
	# $PortraitNinePatchRect.hide()
	
	class_label.text = "N/A" # char_class_array[actor.character_class]
	name_label.text = str(actor.enemey_name)
	
	level_label.text = str(actor.effective_level)
	exp_label.text = "N/A" # str(actor.experience_points)

	kills_label.text = "N/A" # str(actor.enemey_kills)
	defeats_label.text = "N/A" # str(actor.times_defeated)
	
	display_actor_info(actor)


func display_actor_info(actor) -> void:
	# Stats
	hp_label.text = str(actor.HP_Current) + "/" + str(actor.HP_Total)
	mp_label.text = str(actor.MP_Current) + "/" + str(actor.MP_Total)
	
	attack_label.text = str(actor.get_attack()) # str(actor.attack)
	defeats_label.text = str(actor.defense)
	move_label.text = str(actor.move)
	agility_label.text = str(actor.agility)
	
	# Inventory
	print(actor)
	var inventory_item_size = actor.inventory_items_id.size()
	print(inventory_item_size)
	
	if inventory_item_size == 0:
		# $StatNinePatchRect/ItemsNothingStaticLabel.show()
		item_vbox.hide()
	else:
		# $StatNinePatchRect/ItemsNothingStaticLabel.hide()
		item_vbox.show()
		
		for n in range(inventory_item_size):
			var itemInfoN = itemInfoNode.instance()
			itemInfoN.init_item_micro_info(actor.inventory_items_id[n].texture, actor.inventory_items_id[n].item_name, actor.is_item_equipped[n])
			item_vbox.add_child(itemInfoN)
	
	# Spells
	var spells_size = actor.spells_id.size()
	print(spells_size)
	
	if spells_size == 0:
		# $StatNinePatchRect/MagicNothingStaticLabel.show()
		magic_vbox.hide()
	else:
		# $StatNinePatchRect/MagicNothingStaticLabel.hide()
		magic_vbox.show()
		
		for n in range(spells_size):
			var spellInfoN = spellInfoNode.instance()
			spellInfoN.init_spell_micro_info(actor.spells_id[n])
			magic_vbox.add_child(spellInfoN)
