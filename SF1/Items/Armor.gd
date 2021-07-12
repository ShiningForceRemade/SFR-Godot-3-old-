extends CN_SF1_Item

class_name CN_SF1_Item_Armor

enum character_classes {SWORDSMAN}

export(Array, int, "Swordsman - SDMN", "Knight - KNT",
	"Warrior - WARR", "Sky Knight - SKNT", "Mage - MAGE",
	"Monk - MONK", "Healer - HEAL", "Archer - ACHR", "ASKT",
	"Birdman - BDMN", "Winged Knight - WKNT", "Dragon - DRGN", 
	"Robot - RBT", "Werewolf - WRWF", "Samurai - SMR", 
	"Ninja - NINJ", "Hero - HERO", "Paladin - PLDN", 
	"Galaditor - GLDR", "SBRN", "Wizard - WIZD", 
	"Master Monk - MSMK", "Vicar - VICR", "BWMS", 
	"Sky Knight - SKNT", "Sky Warrior - SKYW", "SKYL",
	"GRDR", "Cyborg - CYBG", "Wolf Barron - WFBN", "Yogurt - YGRT",
	"MGCR") var equippable_by

func _ready():
	pass
