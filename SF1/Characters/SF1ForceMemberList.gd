extends Node


func _ready():
	Singleton_Game_GlobalCommonVariables.sf_game_data_node = self


var camera_zoom: Vector2 = Vector2(1, 1)


var c1 = {
	# story flags - in order
	"spoken_to_the_king": false,
	"initial_force_joined": false,
	"kings_permission": false,
	"exited_guardiana_once": false,
	"battle_1_complete": false,
	"battle_2_complete": false,
	"entered_guardiana_post_battle_2": false,
	"kane_cutscene_guardiana_castle_played": false,
	"battle_3_complete": false,
	"spoken_to_guardiana_man_in_alterone_bar": false,
	"spoken_to_alterone_king_post_guardiana_invasion": false,
	"searched_alterone_jail_bars": false,
	"battle_4_complete": false,
	"spoken_to_alterone_king_post_battle_4": false,
	"pulled_the_chain": false,
	
	# misc falgs
	"guardiana_trolley_pushed": false,
	"alterone_trolley_pushed": false,
	"approached_alterone_rune_knights": false,
	
	# TODO: chest flags? where would it be best to track this
}


enum E_SF1_FM {
	MAX,
	LUKE,
	KEN,
	TAO,
	HANS,
	LOWE,
	GONG,
	GORT,
	MAE,
	KHRIS
}

# TEMP: FIXME: refactor
# make this this a global enum somewhere else
enum E_SF1_CLASSES {
	SDMN, KNT, WARR, SKNT, MAGE, MONK, HEAL, ACHR, ASKT,
	BDMN, WKNT, DRGN, RBT, WRWF, SMR, NINJ, HERO, PLDN, 
	GLDR, SBRN, WIZD, MSMK, VICR, BWMS, SKNT, SKYW, SKYL,
	GRDR, CYBG, WFBN, YGRT, MGCR
}
# TEMP: FIXME: refactor
# make this this a global enum somewhere else
# taken from Item.gd
enum E_SF1_ATTRIBUTES {
	NONE, ATTACK, DEFENSE,
	AGILITY, MOVE, CRITICAL, HP, MP,
	YGRT
}


# TODO: copy over the base stats 
# https://sf1.shiningforcecentral.com/characters/shining-force/

# TODO: create character profile resources
# and apply the resource instead - probably a better way to handle this kind of thing


##########
########## TODO: IMPORTANT:
##########
# Seriously rethink the structure of the forcemembers data
# it might be best to have the characters use a resource for editor editability
# then link the resource need here within the force that includes none character battle data
# like rename, leader, unlocked, active_in_force etc, 
# spells especially - need better handling 
# using ForceMembers for certain values then loading the node for character stats
# then reusing forcemembers for latest is awful I nener should have allowed it to get to this point
###########


var ForceMembers = [
	# Max
	{
		"character": E_SF1_FM.MAX,
		"leader": true,
		
		# CRITICAL: IMPORTANT: FIXME: TODO: 
		# is_promoted should be here for easy checking of with sprites to use
		# espeically for overworld cutscenes and the like instead of needing to load the 
		# node or the character resource file
		# "is_promoted"
		
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
		"class_idx": E_SF1_CLASSES.SDMN,
		
		"level": 1,
		
		"status_effects": [
			
		],
		
		"ai_target_priority": 25,
		
		"movement_type": "Standard",
		
		"stats": {
			"attack": 14,
			"attack_boost": 0,
			# resource for stat growth unprom
			# and promoted probably should have those
			
			"defense": 4,
			"defense_boost": 0,
			
			"agility": 4,
			"agility_boost": 0,
			
			"move": 6,
			"move_boost": 0,
			
			"hp": 12,
			"hp_boost": 0,
			
			"mp": 8,
			"mp_boost": 0,
			
			"critical_hit_chance": 2,
			"critical_hit_chance_boost": 0,
			
			"double_attack_chance": 10,
			"double_attack_chance_boost": 0,
			
			"dodge_chance": 10,
			"dodge_chance_boost": 0,
		},
		
		"resistances": {
			"magic": 0,
			"magic_boost": 0,
			
			"slow": 0,
			"slow_boost": 0,
			
			"muddle": 0,
			"muddle_boost": 0,
			
			"sleep": 0,
			"sleep_boost": 0,
			
			"desoul": 0,
			"desoul_boost": 0,
			
			"bolt": 0,
			"bolt_boost": 0,
			
			"blaze": 0,
			"blaze_boost": 0,
			
			"freeze": 0,
			"freeze_boost": 0,
		},
		
		"experience": 0,
		
		"inventory": [
			# Up
			{
				"resource": "res://SF1/Items/Weapons/Spear.tres",
				"is_equipped": false
			},
			
			# Left
			{
				"resource": "res://SF1/Items/Weapons/ShortSword.tres",
				"is_equipped": true
			},
			
			# Right
			{
				"resource": "res://SF1/Items/Usables/MedicalHerb.tres",
				"is_equipped": false
			},
			
			# Down
			{
				"resource": "res://SF1/Items/Weapons/BronzeLance.tres",
				"is_equipped": false
			},
		],
		
		"spells": [
			{
				# "name": "Egress",
				# Egress
				"resource": "res://SF1/Spells/Egress/Egress.tres",
				"levels": [
					1,
				]
			},
		]
	},
	
	# Tao
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
		
		"inventory": [
			# Up
			{
				"resource": "res://SF1/Items/Weapons/WoodenStaff.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
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
		
		"inventory": [
			# Up
			{
				"resource": "res://SF1/Items/Weapons/WoodenArrow.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
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
		
		"inventory": [
			# Up
			{
				"resource": "res://SF1/Items/Weapons/Spear.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
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
		
		"inventory": [
			# Up
			{
				"resource": "res://SF1/Items/Weapons/ShortSword.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
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
		
		"inventory": [
			# Up
			{
				"resource": "res://SF1/Items/Weapons/WoodenStaff.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
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
		
		"inventory": [
			# Up
			
			# Left
			
			# Right
			
			# Down
		],
		
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
		
		"inventory": [
			# Up
			{
				"resource": "res://SF1/Items/Weapons/HandAxe.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
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
		
		"inventory": [
			# Up
			{
				"resource": "res://SF1/Items/Weapons/BronzeLance.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
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
		
		"inventory": [
			# Up
			{
				"resource": "res://SF1/Items/Weapons/WoodenStaff.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
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


