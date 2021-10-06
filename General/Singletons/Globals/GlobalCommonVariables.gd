extends Node

# Node refs
var game_management_wrapper_node = null
var camera_node = null
var dialogue_box_node = null
var scene_manager_node = null

# TODO: move battle vars battle scene to enum for overworld battle and in battle scene instead
var is_currently_in_battle_scene = false

# TODO: for selectable main character and party leader
var main_character_resource_pck = null

# dialog commons
var dialogue_box_is_currently_active = false

var main_character_active_kinematic_body_node = null

# Game Specific Variables
var sf_game_data_node = null

# var E_SF_CHARACTERS = null
# var SF_CHARACTERS = null 

# var SF1ForceMemberList = load("res://SF1/Characters/SF1ForceMemberList.gd")

# var E_SF_CHARACTERS = SF1ForceMemberList.E_SF1_FM
# var SF_CHARACTERS = SF1ForceMemberList.ForceMembers
