extends Node


func _ready():
	Singleton_Game_GlobalCommonVariables.sf_game_data_node = self


enum E_SF1_FM {
	MAX,
	TAO,
	HANS,
	KEN,
	LUKE,
	LOWE,
	GONG,
	GORT,
	MAE,
	KHRIS
}

# TODO: copy over the base stats 
# https://sf1.shiningforcecentral.com/characters/shining-force/

# TODO: create character profile resources
# and apply the resource instead - probably a better way to handle this kind of thing

var ForceMembers = [
	{
		"character": E_SF1_FM.MAX,
		"leader": true,
		
		# TODO: create a base path for characters and use in a similar fashion to the soundback
		# of - ex. base + "Max.tscn" || "MaxNPC.tscn" etc
		
		# battle node?
		"character_base_node": "res://SF1/Characters/Max/Max.tscn",
		# HQ NPC node
		"character_npc_scene": "res://SF1/Characters/Max/MaxNPC.tscn",
		
		"unlocked": true,
		"active_in_force": true,
		
		"name": "Max", # TODO: do nicknames
		"race": "Human",
		
		"class": "Swordsman",
		"class_short": "SWDM",
		
		"level": 1,
		
		"spells": [
			{
				"name": "Egress",
				"levels": [
					1,
				]
			},
		]
	},
	
	{
		"character": E_SF1_FM.TAO,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Tao/Tao.tscn",
		"character_npc_scene": "res://SF1/Characters/Tao/TaoNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		
		"name": "Tao", # TODO: do nicknames
		"race": "Elf",
		
		"class": "Mage",
		"class_short": "MAGE",
		
		"level": 1,
		
		"spells": [
			{
				"name": "Blaze",
				"levels": [
					1,
					4,
					12,
					20
				]
			},
			
			{
				"name": "Sleep",
				"levels": [
					8
				]
			},
			
			{
				"name": "Dispel",
				"levels": [
					16
				]
			},
			
			{
				"name": "Boost",
				"levels": [
					27
				]
			},
		]
	},
	
	{
		"character": E_SF1_FM.HANS,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Hans/Hans.tscn",
		"character_npc_scene": "res://SF1/Characters/Hans/HansNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		
		"name": "Hans", # TODO: do nicknames
		"race": "Elf",
		
		"class": "Archer",
		"class_short": "ARCH",
		
		"level": 1,
		"spells": []
	},
	
		
	{
		"character": E_SF1_FM.KEN,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Ken/Ken.tscn",
		"character_npc_scene": "res://SF1/Characters/Ken/KenNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		
		"name": "Ken", # TODO: do nicknames
		"race": "Centaur",
		
		"class": "Knight",
		"class_short": "KNHT",
		
		"level": 1,
		"spells": []
	},
	
		
	{
		"character": E_SF1_FM.LUKE,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Luke/Luke.tscn",
		"character_npc_scene": "res://SF1/Characters/Luke/LukeNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		
		"name": "Luke", # TODO: do nicknames
		"race": "Dwarf",
		
		"class": "Warrior",
		"class_short": "WARR",
		
		"level": 1,
		"spells": []
	},
	
	{
		"character": E_SF1_FM.LOWE,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Lowe/Lowe.tscn",
		"character_npc_scene": "res://SF1/Characters/Lowe/LoweNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		
		"name": "Lowe", # TODO: do nicknames
		"race": "Halfling",
		
		"class": "Healer",
		"class_short": "HEAL",
		
		"level": 1,
		
		"spells": [
			{
				"name": "Heal",
				"levels": [
					1,
					7,
					16,
					22
				]
			},
			
			{
				"name": "Detox",
				"levels": [
					4
				]
			},
			
			{
				"name": "Slow",
				"levels": [
					10,
					19
				]
			},
			
			{
				"name": "Quick",
				"levels": [
					13,
					25
				]
			},
		]
	},
	
	{
		"character": E_SF1_FM.GONG,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Gong/Gong.tscn",
		"character_npc_scene": "res://SF1/Characters/Gong/GongNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		
		"name": "Gong", # TODO: do nicknames
		"race": "Half Giant",
		
		"class": "Monk",
		"class_short": "MONK",
		
		"level": 1,
		"spells": [
			{
				"name": "Heal",
				"levels": [
					1,
					8,
					16,
					24
				]
			},
			
			{
				"name": "Aura",
				"levels": [
					30
				]
			}
		]
	},
	
	{
		"character": E_SF1_FM.GORT,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Gort/Gort.tscn",
		"character_npc_scene": "res://SF1/Characters/Gort/GortNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		
		"name": "Gort", # TODO: do nicknames
		"race": "Dwarf",
		
		"class": "Warrior",
		"class_short": "WARR",
		
		"level": 2,
		"spells": []
	},
	
	{
		"character": E_SF1_FM.MAE,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Mae/Mae.tscn",
		"character_npc_scene": "res://SF1/Characters/Mae/MaeNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		
		"name": "Mae", # TODO: do nicknames
		"race": "Centaur",
		
		"class": "Knight",
		"class_short": "KNTE",
		
		"level": 2,
		"spells": []
	},
	
	{
		"character": E_SF1_FM.KHRIS,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Khris/Khris.tscn",
		"character_npc_scene": "res://SF1/Characters/Khris/KhrisNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		
		"name": "Khris", # TODO: do nicknames
		"race": "Kyantol",
		
		"class": "Healer",
		"class_short": "HEAL",
		
		"level": 2,
		"spells": [
			{
				"name": "Heal",
				"levels": [
					1,
					5,
					16,
					21
				]
			},
			
			{
				"name": "Slow",
				"levels": [
					8
				]
			},
			
			{
				"name": "Quick",
				"levels": [
					12
				]
			},
			
			{
				"name": "Aura",
				"levels": [
					20,
					28
				]
			}
		]
	},
]

## TODO: IMPORTANT: Create resource files for characters and load those instead
# as well as inserting nad reading data from them better than pulling the node instance
# while keeping editor editability


