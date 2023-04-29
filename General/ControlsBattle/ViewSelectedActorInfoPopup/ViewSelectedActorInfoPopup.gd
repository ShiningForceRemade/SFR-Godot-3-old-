extends Node2D


var battle_view_selected_actor_info_menu_active: bool = false

@onready var itemInfoNode = preload("res://General/ControlsBattle/ViewSelectedActorInfoPopup/ItemMicroView/ItemMicroView.tscn")
@onready var spellInfoNode = preload("res://General/ControlsBattle/ViewSelectedActorInfoPopup/MagicMicroView/MagicMicroView.tscn")

@onready var class_label: Label = $StatsNinePatchRect/ClassLabel
@onready var name_label: Label = $StatsNinePatchRect/NameLabel
@onready var level_label: Label = $StatsNinePatchRect/LevelLabel
@onready var exp_label: Label = $StatsNinePatchRect/ExpLabel

@onready var sprite: Sprite2D = $KillsNinePatchRect/OverworldActorSprite2D
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
	Singleton_CommonVariables.ui__view_selected_actor_info_node = self


func set_battle_view_selected_actor_info_menu_active() -> void:
	battle_view_selected_actor_info_menu_active = true
	show()
	
	# $GoldNinePatchRect/GoldAmountLabel.text = str(Singleton_Game_GlobalOverworldVariables.coins)
	
	if Singleton_CommonVariables.battle__selected_actor_type == "Character":
		display_character_info()
	elif Singleton_CommonVariables.battle__selected_actor_type == "Enemey":
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
			
			Singleton_CommonVariables.battle__selected_actor = null
			Singleton_CommonVariables.battle__selected_actor_type = null
			hide()
			
			await Signal(get_tree().create_timer(0.1), "timeout")
			# re-act cursor through global ref to it
			Singleton_CommonVariables.battle__cursor_node.set_active()
			

func display_character_info() -> void:
	var actor = Singleton_CommonVariables.battle__selected_actor.find_child("CharacterRoot", true)
	
	# TODO: check promotion stage to determine which sprites to use
	# sprite.texture = actor.texture_sprite_overworld_unpromoted
	
	class_label.text = actor.get_class_short() #  char_class_array[actor.character_class]
	name_label.text = actor.get_name() # str(actor.character_name)
	
	level_label.text = str(actor.get_level()) # str(actor.level)
	exp_label.text = str(actor.get_exp())  # str(actor.experience_points)
	
#	kills_label.text = str(actor.aps_enemey_kills)
#	defeats_label.text = str(actor.aps_times_defeated)
	kills_label.text = "N/A" # str(actor.enemey_kills)
	defeats_label.text = "N/A" # str(actor.times_defeated)
	
	display_actor_info(actor)



func display_enemey_info() -> void:
	var actor = Singleton_CommonVariables.battle__selected_actor.find_child("EnemeyRoot", true)
	
	# sprite.texture = actor.texture_sprite_overworld
	
	class_label.text = "" # char_class_array[actor.character_class]
	name_label.text = str(actor.enemey_name)
	
	level_label.text = str(actor.effective_level)
	exp_label.text = "N/A" # str(actor.experience_points)

	kills_label.text = "N/A" # str(actor.enemey_kills)
	defeats_label.text = "N/A" # str(actor.times_defeated)
	
	display_actor_info(actor)


func display_actor_info(actor: Node2D) -> void:
		# $PortraitSprite.show()
	# TODO: create protrait get function that checks if unpromtoed or promoted or other
	# $PortraitSprite.texture = actor.texture_protrait
		# TODO: when adding boss enemeies with sprites add a check to hide or display similar to character info minus gold display
	# $PortraitSprite.hide()
	
	# Stats
	hp_label.text = str(actor.get_hp_current()) + "/" + str(actor.get_hp_total())
	mp_label.text = str(actor.get_mp_current()) + "/" + str(actor.get_mp_total())
	
	# TODO: need functions to get the actual attack weapon equips and other bonuses
	attack_label.text = str(actor.get_attack()) # "FIXME" # str(actor.get_attack()) # str(actor.attack)
	defense_label.text = str(actor.get_defense())
	move_label.text = str(actor.get_movement())
	agility_label.text = str(actor.get_agility())
	
	# Inventory
	print(actor)
	var inventory = actor.get_inventory()
	var inventory_item_size = inventory.size()
	print(inventory_item_size)
	
	
	if inventory_item_size == 0:
		# $StatNinePatchRect/ItemsNothingStaticLabel.show()
		item_vbox.hide()
	else:
		# $StatNinePatchRect/ItemsNothingStaticLabel.hide()
		item_vbox.show()
		
		for n in item_vbox.get_children():
			n.queue_free()
		
		if actor.actor_type == "character": # character
			for n in range(inventory_item_size):
				var itemInfoN = itemInfoNode.instantiate()
				itemInfoN.cust_scale = Vector2(0.8, 0.8)
				var item_res = load(inventory[n].resource)
				itemInfoN.texture = item_res.texture
				itemInfoN.item_name = item_res.item_name
				itemInfoN.is_equipped = inventory[n].is_equipped
				item_vbox.add_child(itemInfoN)
		elif actor.actor_type == "enemey": # enemey
			for n in range(inventory_item_size):
				var itemInfoN = itemInfoNode.instantiate()
				itemInfoN.cust_scale = Vector2(0.8, 0.8)
				var item_res = inventory[n]
				itemInfoN.texture = item_res.texture
				itemInfoN.item_name = item_res.item_name
				itemInfoN.is_equipped = actor.is_item_equipped[n]
				item_vbox.add_child(itemInfoN)
	
	# Spells
	var magic = actor.get_magic()
	var spells_size = magic.size()
	print(spells_size)
	
	if spells_size == 0:
		# $StatNinePatchRect/MagicNothingStaticLabel.show()
		magic_vbox.hide()
	else:
		# $StatNinePatchRect/MagicNothingStaticLabel.hide()
		magic_vbox.show()
		
		for n in magic_vbox.get_children():
			n.queue_free()
		
		for n in range(spells_size):
			var spellInfoN = spellInfoNode.instantiate()
			spellInfoN.spell_obj = load(magic[n].resource)
			spellInfoN.cust_scale = Vector2(0.8, 0.8)
			magic_vbox.add_child(spellInfoN)
