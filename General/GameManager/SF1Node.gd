extends Node


func _ready():
	Singleton_CommonVariables.sf_game_data_node = self


var camera_zoom: Vector2 = Vector2(1, 1)


var c1 = {
	# story flags - in order
	"spoken_to_varios": false,
	"spoken_to_lowe": false,
	"entered_kings_throne": false,
	"spoken_to_the_king": false,
	"accepted_kings_plan": false,
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
	"spoken_to_kane_alterone": false,
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
	GLDR, SBRN, WIZD, MSMK, VICR, BWMS, SKYW, SKYL,
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
# magic especially - need better handling 
# using ForceMembers for certain values then loading the node for character stats
# then reusing forcemembers for latest is awful I nener should have allowed it to get to this point
###########


var ForceMembers = [
	# Max
	{
		"character": E_SF1_FM.MAX,
		
		# TODO: this shouldn't be part of the forceMembers dictionary
		# should be separate var outside and track the force member enum value
		# REFACTOR: after finishing migration to Godot 4
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
		"alive": true,
		
		"name": "Max", # TODO: do nicknames
		"race": "Human",
		
		"class_full": "Swordsman",
		"class_short": "SWDM",
		"class_idx": E_SF1_CLASSES.SDMN,
		
		"level": 1,
		
		"status_effects": [
			
		],
		
		"ai_target_priority": 100,
		
		"movement_type": "Standard",
		
		"stats": {
			"attack": 6,
			"attack_boost": 0,
			"attack_target_unpromoted": 17,
			"attack_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			"attack_target_promoted": 23,
			"attack_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"defense": 4,
			"defense_boost": 0,
			"defense_target_unpromoted": 16,
			"defense_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			"defense_target_promoted": 48,
			"defense_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"agility": 4,
			"agility_boost": 0,
			"agility_target_unpromoted": 14,
			"agility_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			"agility_target_promoted": 35,
			"agility_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY],
			
			"move": 6,
			"move_boost": 0,
			
			"hp": 12,
			"hp_boost": 0,
			"hp_target_unpromoted": 23,
			"hp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"hp_target_promoted": 46,
			"hp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"mp": 8,
			"mp_boost": 0,
			"mp_target_unpromoted": 4,
			"mp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			"mp_target_promoted": 2,
			"mp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			
			"critical_hit_chance": 3,
			"critical_hit_chance_boost": 0,
			"critical_hit_chance_target_unpromoted": 4,
			"critical_hit_chance_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"critical_hit_chance_target_promoted": 8,
			"critical_hit_chance_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"double_attack_chance": 7,
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
		
		"magic": [
			{
				# "name": "Egress",
				# Egress
				"resource": "res://SF1/Spells/Egress/Egress.tres",
				"levels": [
					1, # TODO: IMPORTANT: need to handle pre promotion and promotion unlock levels
					# probably also need an unlock state in the case of promoting prior to getting the spell but not being the promoted target level ex kazin from sf2 
				]
			},
		]
	},
	
	# Luke
	{
		"character": E_SF1_FM.LUKE,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Luke/Luke.tscn",
		"character_npc_scene": "res://SF1/Characters/Luke/LukeNPC.tscn",
		
		"unlocked": true,
		"active_in_force": false,
		"alive": true,
		
		"name": "Luke", # TODO: do nicknames
		"race": "Dwarf",
		
		"class_full": "Warrior",
		"class_short": "WARR",
		"class_idx": E_SF1_CLASSES.WARR,
		
		"level": 1,
		
		"status_effects": [
			
		],
		
		"ai_target_priority": 0,
		
		"movement_type": "Standard",
		
		"stats": {
			"attack": 9,
			"attack_boost": 0,
			"attack_target_unpromoted": 14,
			"attack_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"attack_target_promoted": 26,
			"attack_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"defense": 7,
			"defense_boost": 0,
			"defense_target_unpromoted": 19,
			"defense_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"defense_target_promoted": 53,
			"defense_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"agility": 4,
			"agility_boost": 0,
			"agility_target_unpromoted": 12,
			"agility_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"agility_target_promoted": 35,
			"agility_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			
			"move": 6,
			"move_boost": 0,
			
			"hp": 9,
			"hp_boost": 0,
			"hp_target_unpromoted": 16,
			"hp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			"hp_target_promoted": 40,
			"hp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"mp": 0,
			"mp_boost": 0,
			"mp_target_unpromoted": 0,
			"mp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"mp_target_promoted": 0,
			"mp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
						
			"critical_hit_chance": 3,
			"critical_hit_chance_boost": 0,
			"critical_hit_chance_target_unpromoted": 4,
			"critical_hit_chance_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"critical_hit_chance_target_promoted": 8,
			"critical_hit_chance_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"double_attack_chance": 7,
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
				"resource": "res://SF1/Items/Weapons/ShortSword.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
		"magic": []
	},
	
	# Ken
	{
		"character": E_SF1_FM.KEN,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Ken/Ken.tscn",
		"character_npc_scene": "res://SF1/Characters/Ken/KenNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		"alive": true,
		
		"name": "Ken", # TODO: do nicknames
		"race": "Centaur",
		
		"class_full": "Knight",
		"class_short": "KNHT",
		"class_idx": E_SF1_CLASSES.KNT,
		
		"level": 1,
		
		"status_effects": [
			
		],
		
		"ai_target_priority": 0,
		
		"movement_type": "Mounted",
		
		"stats": {
			"attack": 7,
			"attack_boost": 0,
			"attack_target_unpromoted": 14,
			"attack_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"attack_target_promoted": 21,
			"attack_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LATE],
			
			"defense": 6,
			"defense_boost": 0,
			"defense_target_unpromoted": 15,
			"defense_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LATE],
			"defense_target_promoted": 37,
			"defense_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LATE],
			
			"agility": 5,
			"agility_boost": 0,
			"agility_target_unpromoted": 14,
			"agility_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"agility_target_promoted": 40,
			"agility_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"move": 7,
			"move_boost": 0,
			
			"hp": 8,
			"hp_boost": 0,
			"hp_target_unpromoted": 23,
			"hp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY],
			"hp_target_promoted": 42,
			"hp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"mp": 0,
			"mp_boost": 0,
			"mp_target_unpromoted": 0,
			"mp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"mp_target_promoted": 0,
			"mp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"critical_hit_chance": 3,
			"critical_hit_chance_boost": 0,
			"critical_hit_chance_target_unpromoted": 1,
			"critical_hit_chance_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"critical_hit_chance_target_promoted": 5,
			"critical_hit_chance_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			
			"double_attack_chance": 7,
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
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
		"magic": []
	},
	
	# Tao
	{
		"character": E_SF1_FM.TAO,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Tao/Tao.tscn",
		"character_npc_scene": "res://SF1/Characters/Tao/TaoNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		"alive": true,
		
		"name": "Tao", # TODO: do nicknames
		"race": "Elf",
		
		"class_full": "Mage",
		"class_short": "MAGE",
		"class_idx": E_SF1_CLASSES.MAGE,
		
		"level": 1,
		
		"status_effects": [
			
		],
		
		"ai_target_priority": 75,
		
		"movement_type": "Standard",
		
		"stats": {
			"attack": 4,
			"attack_boost": 0,
			"attack_target_unpromoted": 7,
			"attack_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"attack_target_promoted": 12,
			"attack_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"defense": 4,
			"defense_boost": 0,
			"defense_target_unpromoted": 11,
			"defense_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"defense_target_promoted": 29,
			"defense_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"agility": 6,
			"agility_boost": 0,
			"agility_target_unpromoted": 18,
			"agility_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"agility_target_promoted": 46,
			"agility_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY],
			
			"move": 5,
			"move_boost": 0,
			
			"hp": 10,
			"hp_boost": 0,
			"hp_target_unpromoted": 12,
			"hp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"hp_target_promoted": 38,
			"hp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LATE],
			
			"mp": 7,
			"mp_boost": 0,
			"mp_target_unpromoted": 34,
			"mp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			"mp_target_promoted": 47,
			"mp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"critical_hit_chance": 3,
			"critical_hit_chance_boost": 0,
			"critical_hit_chance_target_unpromoted": 1,
			"critical_hit_chance_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"critical_hit_chance_target_promoted": 2,
			"critical_hit_chance_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"double_attack_chance": 7,
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
				"resource": "res://SF1/Items/Weapons/WoodenStaff.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
		"magic": [
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
	
	# Hans
	{
		"character": E_SF1_FM.HANS,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Hans/Hans.tscn",
		"character_npc_scene": "res://SF1/Characters/Hans/HansNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		"alive": true,
		
		"name": "Hans", # TODO: do nicknames
		"race": "Elf",
		
		"class_full": "Archer",
		"class_short": "ARCH",
		"class_idx": E_SF1_CLASSES.ACHR,
		
		"level": 1,
		
		"status_effects": [
			
		],
		
		"ai_target_priority": 25,
		
		"movement_type": "Forest",
		
		"stats": {
			"attack": 6,
			"attack_boost": 0,
			"attack_target_unpromoted": 12,
			"attack_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LATE],
			"attack_target_promoted": 14,
			"attack_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"defense": 5,
			"defense_boost": 0,
			"defense_target_unpromoted": 13,
			"defense_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LATE],
			"defense_target_promoted": 31,
			"defense_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"agility": 6,
			"agility_boost": 0,
			"agility_target_unpromoted": 12,
			"agility_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			"agility_target_promoted": 41,
			"agility_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"move": 5,
			"move_boost": 0,
			
			"hp": 12,
			"hp_boost": 0,
			"hp_target_unpromoted": 18,
			"hp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LATE],
			"hp_target_promoted": 39,
			"hp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LATE],
			
			"mp": 0,
			"mp_boost": 0,
			"mp_target_unpromoted": 0,
			"mp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"mp_target_promoted": 0,
			"mp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"critical_hit_chance": 3,
			"critical_hit_chance_boost": 0,
			"critical_hit_chance_target_unpromoted": 4,
			"critical_hit_chance_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"critical_hit_chance_target_promoted": 9,
			"critical_hit_chance_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LATE],
			
			"double_attack_chance": 7,
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
				"resource": "res://SF1/Items/Weapons/WoodenArrow.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
		"magic": []
	},
	
	# Lowe
	{
		"character": E_SF1_FM.LOWE,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Lowe/Lowe.tscn",
		"character_npc_scene": "res://SF1/Characters/Lowe/LoweNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		"alive": true,
		
		"name": "Lowe", # TODO: do nicknames
		"race": "Halfling",
		
		"class_full": "Healer",
		"class_short": "HEAL",
		"class_idx": E_SF1_CLASSES.HEAL,
		
		"level": 1,
		
		"status_effects": [
			
		],
		
		"ai_target_priority": 25,
		
		"movement_type": "Standard",
		
		"stats": {
			"attack": 6,
			"attack_boost": 0,
			"attack_target_unpromoted": 10,
			"attack_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"attack_target_promoted": 13,
			"attack_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"defense": 5,
			"defense_boost": 0,
			"defense_target_unpromoted": 10,
			"defense_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"defense_target_promoted": 30,
			"defense_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"agility": 5,
			"agility_boost": 0,
			"agility_target_unpromoted": 13,
			"agility_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"agility_target_promoted": 40,
			"agility_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY],
			
			"move": 5,
			"move_boost": 0,
			
			"hp": 11,
			"hp_boost": 0,
			"hp_target_unpromoted": 15,
			"hp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"hp_target_promoted": 40,
			"hp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"mp": 10,
			"mp_boost": 0,
			"mp_target_unpromoted": 25,
			"mp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			"mp_target_promoted": 38,
			"mp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"critical_hit_chance": 3,
			"critical_hit_chance_boost": 0,
			"critical_hit_chance_target_unpromoted": 2,
			"critical_hit_chance_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"critical_hit_chance_target_promoted": 6,
			"critical_hit_chance_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"double_attack_chance": 7,
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
				"resource": "res://SF1/Items/Weapons/WoodenStaff.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
		"magic": [
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
	
	# Gong
	{
		"character": E_SF1_FM.GONG,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Gong/Gong.tscn",
		"character_npc_scene": "res://SF1/Characters/Gong/GongNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		"alive": true,
		
		"name": "Gong", # TODO: do nicknames
		"race": "Half Giant",
		
		"class_full": "Monk",
		"class_short": "MONK",
		"class_idx": E_SF1_CLASSES.MONK,
		
		"level": 1,
		
		"status_effects": [
			
		],
		
		"ai_target_priority": 0,
		
		"movement_type": "Standard",
		
		"stats": {
			"attack": 11,
			"attack_boost": 0,
			"attack_target_unpromoted": 29,
			"attack_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"attack_target_promoted": 26, # TODO: CHECK: is this right?
			"attack_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"defense": 4,
			"defense_boost": 0,
			"defense_target_unpromoted": 16,
			"defense_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			"defense_target_promoted": 31,
			"defense_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"agility": 6,
			"agility_boost": 0,
			"agility_target_unpromoted": 11,
			"agility_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			"agility_target_promoted": 39,
			"agility_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"move": 5,
			"move_boost": 0,
			
			"hp": 11,
			"hp_boost": 0,
			"hp_target_unpromoted": 19,
			"hp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"hp_target_promoted": 42,
			"hp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"mp": 8,
			"mp_boost": 0,
			"mp_target_unpromoted": 16,
			"mp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"mp_target_promoted": 28,
			"mp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			
			"critical_hit_chance": 3,
			"critical_hit_chance_boost": 0,
			"critical_hit_chance_target_unpromoted": 4,
			"critical_hit_chance_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"critical_hit_chance_target_promoted": 20,
			"critical_hit_chance_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LATE],
			
			"double_attack_chance": 7,
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
			
			# Left
			
			# Right
			
			# Down
		],
		
		"magic": [
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
	
	# Gort
	{
		"character": E_SF1_FM.GORT,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Gort/Gort.tscn",
		"character_npc_scene": "res://SF1/Characters/Gort/GortNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		"alive": true,
		
		"name": "Gort", # TODO: do nicknames
		"race": "Dwarf",
		
		"class_full": "Warrior",
		"class_short": "WARR",
		"class_idx": E_SF1_CLASSES.WARR,
		
		"level": 2,
		
		"status_effects": [
			
		],
		
		"ai_target_priority": 0,
		
		"movement_type": "Standard",
		
		"stats": {
			"attack": 8,
			"attack_boost": 0,
			"attack_target_unpromoted": 17,
			"attack_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"attack_target_promoted": 19,
			"attack_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"defense": 7,
			"defense_boost": 0,
			"defense_target_unpromoted": 18,
			"defense_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			"defense_target_promoted": 51,
			"defense_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"agility": 4,
			"agility_boost": 0,
			"agility_target_unpromoted": 13,
			"agility_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"agility_target_promoted": 33,
			"agility_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			
			"move": 6,
			"move_boost": 0,
			
			"hp": 12,
			"hp_boost": 0,
			"hp_target_unpromoted": 16,
			"hp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"hp_target_promoted": 42,
			"hp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"mp": 0,
			"mp_boost": 0,
			"mp_target_unpromoted": 0,
			"mp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"mp_target_promoted": 0,
			"mp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"critical_hit_chance": 3,
			"critical_hit_chance_boost": 0,
			"critical_hit_chance_target_unpromoted": 4,
			"critical_hit_chance_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"critical_hit_chance_target_promoted": 8,
			"critical_hit_chance_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"double_attack_chance": 7,
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
				"resource": "res://SF1/Items/Weapons/HandAxe.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
		"magic": []
	},
	
	# Mae
	{
		"character": E_SF1_FM.MAE,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Mae/Mae.tscn",
		"character_npc_scene": "res://SF1/Characters/Mae/MaeNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		"alive": true,
		
		"name": "Mae", # TODO: do nicknames
		"race": "Centaur",
		
		"class_full": "Knight",
		"class_short": "KNTE",
		"class_idx": E_SF1_CLASSES.KNT,
		
		"level": 2,
		
		"status_effects": [
			
		],
		
		"ai_target_priority": 0,
		
		"movement_type": "Mounted",
		
		"stats": {
			"attack": 5,
			"attack_boost": 0,
			"attack_target_unpromoted": 15,
			"attack_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"attack_target_promoted": 18,
			"attack_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"defense": 5,
			"defense_boost": 0,
			"defense_target_unpromoted": 15,
			"defense_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY],
			"defense_target_promoted": 35,
			"defense_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"agility": 7,
			"agility_boost": 0,
			"agility_target_unpromoted": 14,
			"agility_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"agility_target_promoted": 45,
			"agility_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"move": 7,
			"move_boost": 0,
			
			"hp": 11,
			"hp_boost": 0,
			"hp_target_unpromoted": 24,
			"hp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LATE],
			"hp_target_promoted": 43,
			"hp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY],
			
			"mp": 0,
			"mp_boost": 0,
			"mp_target_unpromoted": 0,
			"mp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"mp_target_promoted": 0,
			"mp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"critical_hit_chance": 3,
			"critical_hit_chance_boost": 0,
			"critical_hit_chance_target_unpromoted": 1,
			"critical_hit_chance_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"critical_hit_chance_target_promoted": 4,
			"critical_hit_chance_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"double_attack_chance": 7,
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
				"resource": "res://SF1/Items/Weapons/BronzeLance.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
		"magic": []
	},
	
	# Khris
	{
		"character": E_SF1_FM.KHRIS,
		"leader": false,
		
		"character_base_node": "res://SF1/Characters/Khris/Khris.tscn",
		"character_npc_scene": "res://SF1/Characters/Khris/KhrisNPC.tscn",
		
		"unlocked": false,
		"active_in_force": false,
		"alive": true,
		
		"name": "Khris", # TODO: do nicknames
		"race": "Kyantol",
		
		"class_full": "Healer",
		"class_short": "HEAL",
		"class_idx": E_SF1_CLASSES.HEAL,
		
		"level": 2,
		
		"status_effects": [
			
		],
		
		"ai_target_priority": 25,
		
		"movement_type": "Standard",
		
		"stats": {
			"attack": 6,
			"attack_boost": 0,
			"attack_target_unpromoted": 10,
			"attack_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LATE],
			"attack_target_promoted": 14,
			"attack_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"defense": 5,
			"defense_boost": 0,
			"defense_target_unpromoted": 11,
			"defense_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"defense_target_promoted": 31,
			"defense_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY],
			
			"agility": 4,
			"agility_boost": 0,
			"agility_target_unpromoted": 13,
			"agility_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"agility_target_promoted": 38,
			"agility_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"move": 5,
			"move_boost": 0,
			
			"hp": 10,
			"hp_boost": 0,
			"hp_target_unpromoted": 15,
			"hp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"hp_target_promoted": 37,
			"hp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"mp": 7,
			"mp_boost": 0,
			"mp_target_unpromoted": 25,
			"mp_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.EARLY_AND_LATE],
			"mp_target_promoted": 38,
			"mp_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"critical_hit_chance": 3,
			"critical_hit_chance_boost": 0,
			"critical_hit_chance_target_unpromoted": 1,
			"critical_hit_chance_unpromoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			"critical_hit_chance_target_promoted": 4,
			"critical_hit_chance_promoted_growth_curve": CN_SF1_StatGrowthCurves.CURVES[CN_SF1_StatGrowthCurves.E_CURVE.LINEAR],
			
			"double_attack_chance": 7,
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
				"resource": "res://SF1/Items/Weapons/WoodenStaff.tres",
				"is_equipped": true
			},
			
			# Left
			
			# Right
			
			# Down
		],
		
		"magic": [
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

# Movement types and their penalties
# ripped from the sf2 land guide probably not fully accurate for SF1 
# TODO: verify
const sf_movement_types = [
	# (standard / walking) = 0
	{
		"SKY": 0,
		"GROUND": 1.0,
		"PATH_AND_BRIDGE": 1.0,
		"OVERGROWTH": 1.5,
		"FOREST": 2.0,
		"MOUNTAIN": 1.5,
		"SAND": 1.5,
		"HIGH_MOUNTAIN": 0,
		"WATER": 0,
	},
	
	# (mounted / horses / centaurs) = 1
	{
		"SKY": 0,
		"GROUND": 1.0,
		"PATH_AND_BRIDGE": 1.0,
		"OVERGROWTH": 1.5,
		"FOREST": 2.5,
		"MOUNTAIN": 2.5,
		"SAND": 2.5,
		"HIGH_MOUNTAIN": 0,
		"WATER": 0,
	},
	
	# aquatic = 2
	{
		"SKY": 0,
		"GROUND": 0,
		"PATH_AND_BRIDGE": 0,
		"OVERGROWTH": 0,
		"FOREST": 0,
		"MOUNTAIN": 0,
		"SAND": 0,
		"HIGH_MOUNTAIN": 0,
		"WATER": 1.0,
	},
	
	# (forest / elves / animals / beastman) = 3
	{
		"SKY": 0,
		"GROUND": 1.0,
		"PATH_AND_BRIDGE": 1.0,
		"OVERGROWTH": 1.0,
		"FOREST": 1.0,
		"MOUNTAIN": 1.0,
		"SAND": 2.0,
		"HIGH_MOUNTAIN": 0,
		"WATER": 0,
	},
	
	# (mechanical) = 4
	{
		"SKY": 0,
		"GROUND": 1.0,
		"PATH_AND_BRIDGE": 1.0,
		"OVERGROWTH": 1.0,
		"FOREST": 1.5,
		"MOUNTAIN": 1.5,
		"SAND": 1.5,
		"HIGH_MOUNTAIN": 0,
		"WATER": 0,
	},
	
	# (flying) = 5
	{
		"SKY": 1.0,
		"GROUND": 1.0,
		"PATH_AND_BRIDGE": 1.0,
		"OVERGROWTH": 1.0,
		"FOREST": 1.0,
		"MOUNTAIN": 1.0,
		"SAND": 1.0,
		"HIGH_MOUNTAIN": 1.0,
		"WATER": 1.0,
	},
	
	# (hovering) = 6
	# high mountains if I remember correctly cant be passed with hover units
	# TODO: double check
	{
		"SKY": 1.0,
		"GROUND": 1.0,
		"PATH_AND_BRIDGE": 1.0,
		"OVERGROWTH": 1.0,
		"FOREST": 1.0,
		"MOUNTAIN": 1.0,
		"SAND": 1.0,
		"HIGH_MOUNTAIN": 1.0,
		"WATER": 1.0,
	},
]

