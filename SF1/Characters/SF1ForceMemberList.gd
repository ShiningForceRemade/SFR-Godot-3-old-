extends Node

func _ready():
	Singleton_Game_GlobalCommonVariables.sf_game_data_node = self


enum E_SF1_FM {
	MAX,
	TAO,
	HANS,
	KEN,
	LUKE,
	LOWE
}

var ForceMembers = [
	{
		"character": E_SF1_FM.MAX,
		"character_base_node": "res://SF1/Characters/Max/Max.tscn",
		
		"unlocked": true,
		
		"name": "Max", # TODO: do nicknames
		
		"class": "Swordsman",
		"class_short": "SWDM",
		
		"level": 1
	},
	
	{
		"character": E_SF1_FM.TAO,
		"character_base_node": "res://SF1/Characters/Tao/Tao.tscn",
		
		"unlocked": true,
		
		"name": "Tao", # TODO: do nicknames
		
		"class": "Mage",
		"class_short": "MAGE",
		
		"level": 1
	},
	
	{
		"character": E_SF1_FM.HANS,
		"character_base_node": "res://SF1/Characters/Hans/Hans.tscn",
		
		"unlocked": true,
		
		"name": "Hans", # TODO: do nicknames
		
		"class": "Archer",
		"class_short": "ARCH",
		
		"level": 1
	},
	
		
	{
		"character": E_SF1_FM.KEN,
		"character_base_node": "res://SF1/Characters/Ken/Ken.tscn",
		
		"unlocked": true,
		
		"name": "Ken", # TODO: do nicknames
		
		"class": "Knight",
		"class_short": "KNHT",
		
		"level": 1
	},
	
		
	{
		"character": E_SF1_FM.LUKE,
		"character_base_node": "res://SF1/Characters/Luke/Luke.tscn",
		
		"unlocked": true,
		
		"name": "Luke", # TODO: do nicknames
		
		"class": "Warrior",
		"class_short": "WARR",
		
		"level": 1
	},
	
	{
		"character": E_SF1_FM.LOWE,
		"character_base_node": "res://SF1/Characters/Lowe/Lowe.tscn",
		
		"unlocked": true,
		
		"name": "Lowe", # TODO: do nicknames
		
		"class": "Healer",
		"class_short": "HEAL",
		
		"level": 1
	},
]

## TODO: IMPORTANT: Create resource files for characters and load those instead
# as well as inserting nad reading data from them better than pulling the node instance
# while keeping editor editability

