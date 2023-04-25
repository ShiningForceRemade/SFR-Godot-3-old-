extends CN_SF1_Item

class_name CN_SF1_Item_Armor

enum character_classes {SWORDSMAN}

# Godot needs to re-add enum array support sigh
#@export_enum("Swordsman - SDMN", "Knight - KNT",
#	"Warrior - WARR", "Sky Knight - SKNT", "Mage - MAGE",
#	"Monk - MONK", "Healer - HEAL", "Archer - ACHR", "ASKT",
#	"Birdman - BDMN", "Winged Knight - WKNT", "Dragon - DRGN", 
#	"Robot - RBT", "Werewolf - WRWF", "Samurai - SMR", 
#	"Ninja - NINJ", "Hero - HERO", "Paladin - PLDN", 
#	"Galaditor - GLDR", "SBRN", "Wizard - WIZD", 
#	"Master Monk - MSMK", "Vicar - VICR", "BWMS", 
#	"Sky Knight - SKNT", "Sky Warrior - SKYW", "SKYL",
#	"GRDR", "Cyborg - CYBG", "Wolf Barron - WFBN", "Yogurt - YGRT",
#	"MGCR") var equippable_by: Array # [int]

@export var equippable_by: Array[String] # [int]

func _ready():
	pass

func get_item_type() -> String:
	return "Armor"
