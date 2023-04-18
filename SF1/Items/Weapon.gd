extends CN_SF1_Item

class_name CN_SF1_Item_Weapon

# TODO: target types for weapons should be cleaned up
# doesn't make sense to have target enemeies and characters in the way its currently
# setup since from the character actors perspective the target is enemeies
# but from enemeies it would be characters
# needs to be simplifed and made clearer 
# maybe something like oppsite actor type, current actor type,  both
# and additional field for self

enum character_classes {SWORDSMAN}

@export var battle_texture: Texture

@export var chance_to_crack: bool = false

@export_enum("Swordsman - SDMN", "Knight - KNT",
	"Warrior - WARR", "Sky Knight - SKNT", "Mage - MAGE",
	"Monk - MONK", "Healer - HEAL", "Archer - ACHR", "ASKT",
	"Birdman - BDMN", "Winged Knight - WKNT", "Dragon - DRGN", 
	"Robot - RBT", "Werewolf - WRWF", "Samurai - SMR", 
	"Ninja - NINJ", "Hero - HERO", "Paladin - PLDN", 
	"Galaditor - GLDR", "SBRN", "Wizard - WIZD", 
	"Master Monk - MSMK", "Vicar - VICR", "BWMS", 
	"Sky Knight - SKNT", "Sky Warrior - SKYW", "SKYL",
	"GRDR", "Cyborg - CYBG", "Wolf Barron - WFBN", "Yogurt - YGRT",
	"MGCR") var equippable_by: int # Array[int]

func _ready():
	pass

func get_item_type() -> String:
	return "Weapon"
