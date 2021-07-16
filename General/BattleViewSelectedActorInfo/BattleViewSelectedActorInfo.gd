extends Node2D

onready var itemInfoNode = preload("res://General/BattleViewSelectedActorInfo/Item/ItemMicroView.tscn")
onready var spellInfoNode = preload("res://General/BattleViewSelectedActorInfo/Spell/SpellMicroView.tscn")

var battle_view_selected_actor_info_menu_active: bool = false

# move this to a better place maybe a separate data script
# singleton seems like overkill
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

func _ready():
	pass

func set_battle_view_selected_actor_info_menu_active():
	battle_view_selected_actor_info_menu_active = true
	
	if Singleton_Game_GlobalBattleVariables.selected_actor_type == "Character":
		display_character_info()
	elif Singleton_Game_GlobalBattleVariables.selected_actor_type == "Enemey":
		display_enemey_info()
	else:
		print("BUG")

func _input(event):
	if battle_view_selected_actor_info_menu_active:
		if event.is_action_released("ui_b_key"):
			for n in $StatNinePatchRect/InventoryVBoxContainer.get_children():
				n.queue_free()
			for n in $StatNinePatchRect/SpellsVBoxContainer.get_children():
				n.queue_free()
			
			battle_view_selected_actor_info_menu_active = false
			Singleton_Game_GlobalBattleVariables.selected_actor = null
			Singleton_Game_GlobalBattleVariables.selected_actor_type = null
			# re-act cursor through global ref to it
			Singleton_Game_GlobalBattleVariables.cursor_root_ref.active = true
			get_parent().get_parent().s_hide_battle_view_selected_actor_info_menu()

func display_character_info():
	var actor = Singleton_Game_GlobalBattleVariables.selected_actor.get_node("CharacterRoot")
	
	$PortraitSprite.show()
	$PortraitSprite.texture = actor.texture_protrait
	
	$PortraitNinePatchRect.show()
	$GoldNinePatchRect.show()
	
	$StatNinePatchRect/ClassLabel.text = char_class_array[actor.character_class]
	$StatNinePatchRect/NameLabel.text = str(actor.character_name)
	
	$StatNinePatchRect/LevelLabel.text = str(actor.level)
	$StatNinePatchRect/HPLabel.text = str(actor.HP_Current) + "/" + str(actor.HP_Total)
	$StatNinePatchRect/MPLabel.text = str(actor.MP_Current) + "/" + str(actor.MP_Total)
	$StatNinePatchRect/ExpLabel.text = str(actor.experience_points)
	
	$StatNinePatchRect/AttackLabel.text = str(actor.attack)
	$StatNinePatchRect/DefenseLabel.text = str(actor.defense)
	$StatNinePatchRect/MoveLabel.text = str(actor.move)
	$StatNinePatchRect/AgilityLabel.text = str(actor.agility)
	
	$CharacterNinePatchRect/KillsAmountLabel.text = str(actor.enemey_kills)
	$CharacterNinePatchRect/DefeatAmountLabel.text = str(actor.times_defeated)
	
	print(actor)
	var inventory_item_size = actor.inventory_items_id.size()
	print(inventory_item_size)
	
	if inventory_item_size == 0:
		$StatNinePatchRect/ItemsNothingStaticLabel.show()
		$StatNinePatchRect/InventoryVBoxContainer.hide()
	else:
		$StatNinePatchRect/ItemsNothingStaticLabel.hide()
		$StatNinePatchRect/InventoryVBoxContainer.show()
		
		for n in range(inventory_item_size):
			var itemInfoN = itemInfoNode.instance()
			itemInfoN.init_item_micro_info(actor.inventory_items_id[n].texture, actor.inventory_items_id[n].item_name, actor.is_item_equipped[n])
			$StatNinePatchRect/InventoryVBoxContainer.add_child(itemInfoN)
	
	var spells_size = actor.spells_id.size()
	print(spells_size)
	
	if spells_size == 0:
		$StatNinePatchRect/MagicNothingStaticLabel.show()
		$StatNinePatchRect/SpellsVBoxContainer.hide()
	else:
		$StatNinePatchRect/MagicNothingStaticLabel.hide()
		$StatNinePatchRect/SpellsVBoxContainer.show()
		
		for n in range(spells_size):
			var spellInfoN = spellInfoNode.instance()
			spellInfoN.init_spell_micro_info(actor.spells_id[n])
			$StatNinePatchRect/SpellsVBoxContainer.add_child(spellInfoN)


func display_enemey_info():
	var actor = Singleton_Game_GlobalBattleVariables.selected_actor.get_node("EnemeyRoot")
	
	# TODO: when adding boss enemeies with sprites add a check to hide or display similar to character info minus gold display
	$PortraitSprite.hide()
	
	$GoldNinePatchRect.hide()
	$PortraitNinePatchRect.hide()
	
	$StatNinePatchRect/ClassLabel.text = "N/A" # char_class_array[actor.character_class]
	$StatNinePatchRect/NameLabel.text = str(actor.enemey_name)
	
	$StatNinePatchRect/LevelLabel.text = str(actor.effective_level)
	$StatNinePatchRect/HPLabel.text = str(actor.HP_Current) + "/" + str(actor.HP_Total)
	$StatNinePatchRect/MPLabel.text = str(actor.MP_Current) + "/" + str(actor.MP_Total)
	$StatNinePatchRect/ExpLabel.text = "N/A" # str(actor.experience_points)
	
	$StatNinePatchRect/AttackLabel.text = str(actor.attack)
	$StatNinePatchRect/DefenseLabel.text = str(actor.defense)
	$StatNinePatchRect/MoveLabel.text = str(actor.move)
	$StatNinePatchRect/AgilityLabel.text = str(actor.agility)
	
	$CharacterNinePatchRect/KillsAmountLabel.text = "0" # str(actor.enemey_kills)
	$CharacterNinePatchRect/DefeatAmountLabel.text = "0" # str(actor.times_defeated)
	
	print(actor)
	var inventory_item_size = actor.inventory_items_id.size()
	print(inventory_item_size)
	
	if inventory_item_size == 0:
		$StatNinePatchRect/ItemsNothingStaticLabel.show()
		$StatNinePatchRect/InventoryVBoxContainer.hide()
	else:
		$StatNinePatchRect/ItemsNothingStaticLabel.hide()
		$StatNinePatchRect/InventoryVBoxContainer.show()
		
		for n in range(inventory_item_size):
			var itemInfoN = itemInfoNode.instance()
			itemInfoN.init_item_micro_info(actor.inventory_items_id[n].texture, actor.inventory_items_id[n].item_name, actor.is_item_equipped[n])
			$StatNinePatchRect/InventoryVBoxContainer.add_child(itemInfoN)
	
	var spells_size = actor.spells_id.size()
	print(spells_size)
	
	if spells_size == 0:
		$StatNinePatchRect/MagicNothingStaticLabel.show()
		$StatNinePatchRect/SpellsVBoxContainer.hide()
	else:
		$StatNinePatchRect/MagicNothingStaticLabel.hide()
		$StatNinePatchRect/SpellsVBoxContainer.show()
		
		for n in range(spells_size):
			var spellInfoN = spellInfoNode.instance()
			spellInfoN.init_spell_micro_info(actor.spells_id[n])
			$StatNinePatchRect/SpellsVBoxContainer.add_child(spellInfoN)
			
	pass
