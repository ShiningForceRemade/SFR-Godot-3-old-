extends Node

# meta

## Controls how long menu tweens take
var menu_tween_time = 0.1

## TODO: probably should make this an enum
## something like "in battle" "in cutscene" "overworld" "in battle cutscene" etc to smooth out behaviours and interactions
var is_currently_in_battle_scene = true # false

# Node refs
var game_management_wrapper_node = null
var menus_root_node = null
var camera_node = null
var dialogue_box_node = null
var scene_manager_node = null
var top_level_fader_node = null


### ui node refs

# TODO: probably should make helpers to instace these scenes instead of having everything running
# clean up after C1 release
var ui__portrait_popup: Node2D = null
var ui__gold_info_box: Node2D = null
var ui__actor_micro_info_box: Node2D = null
var ui__yes_or_no_prompt: Node2D = null
var ui__not_valid_box: Node2D = null

var ui__priest_menu: Node2D = null
var ui__hq_menu: Node2D = null
var ui__shop_menu: Node2D = null
var ui__shop_item_selection_menu: Node2D = null

var ui__magic_menu: Node2D = null

var ui__inventory_menu: Node2D = null
var ui__drop_menu: Node2D = null
var ui__equip_menu: Node2D = null
var ui__give_menu: Node2D = null
var ui__use_menu: Node2D = null

var ui__member_list_menu: Node2D = null

var ui__overworld_action_menu: Node2D = null
var ui__micro_member_list_view: Node2D = null

var ui__battle_action_menu: Node2D = null

# battle ui controls
var ui__land_effect_popup_node: Node2D = null
var ui__view_selected_actor_info_node: Node2D = null

# TODO: refactor disgusting temp for demo
# values null | "YES" | "NO"
var interaction_yes_or_no_selection = null

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

### Battle Variables

var battle_scene_node: Node2D

var battle__logic_node: Node

var battle__logic__target_selection_node: Node
var battle__logic__target_selection_wrapper_node: Node2D
var battle__target_use_range_array_representation
var battle__target_selector_array_representation
var battle__target_selection_actor
var battle__target_selection_type # item -- spell -- normal attack -- etc..

var battle__turn_order_array: Array
var battle__turn_number: int

var battle__control_enemies: bool = true
var battle__currently_active_actor

var battle__cursor_node: Node2D
var battle__selected_actor = null # Node2D or null
var battle__selected_actor_type # : String or null 

var active_actor_move_array_representation
# TODO: NOTE: collapsed into move_array but still being used somewhere need to clean fully
var active_actor_move_point_representation

var battle__tilemap_info_group__background: TileMap
var battle__tilemap_info_group__foreground: TileMap
var battle__tilemap_info_group__stand: TileMap
var battle__tilemap_info_group__terrain: TileMap
var battle__movement_tiles_wrapper_node: Node2D
var battle__enemies: Node2D
var battle__characters: Node2D


