extends Node

# Node refs
var game_management_wrapper_node = null
var menus_root_node = null
var camera_node = null
var dialogue_box_node = null
var scene_manager_node = null

# TODO: move battle vars battle scene to enum for overworld battle and in battle scene instead
var is_currently_in_battle_scene = false

# TODO: for selectable main character and party leader
var main_character_resource_pck = null

var main_character_player_node = null

var priest_egress_location = null
var upcoming_battle_number = 1

var gold: int = 10000
# var gold: int = 0

var item_box = []

## menus selections
## TODO: refactor and clean this later on
## none of these should really be globals
var selected_character = null
var selected_item = null
var selected_item_idx = null
var selected_target_character = null
var action_type = null
##

# position location
var position_location_st = "Overworld_Alterone_Castle" # null

# dialog commons
var dialogue_box_is_currently_active = false
# TODO(feldc): when Godot 4 releases make this a callback instead
var interaction_node_reference = null

var main_character_active_kinematic_body_node = null

# Game Specific Variables
var sf_game_data_node = null

# var E_SF_CHARACTERS = null
# var SF_CHARACTERS = null 

# var SF1ForceMemberList = load("res://SF1/Characters/SF1ForceMemberList.gd")

# var E_SF_CHARACTERS = SF1ForceMemberList.E_SF1_FM
# var SF_CHARACTERS = SF1ForceMemberList.ForceMembers
