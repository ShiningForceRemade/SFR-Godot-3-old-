extends Node

var battle_base

var camera_node

var battle_scene_node

var dialogue_box_node

var currently_active_character
var active_actor_movement_array
var active_actor_move_array_representation
var active_actor_move_point_representation

var character_nodes
var enemey_nodes

var tilemaps_wrapper
var tilemap_foreground
var tilemap_background
var tilemap_stand
var tilemap_terrain

var currently_selected_actor

var field_logic_node
var target_selection_node
var character_wrapper_node
var enemies_wrapper_node

var cursor_root_ref = null

var selected_actor
var selected_actor_type

var is_currently_in_battle_scene = false

var control_enemies = false # true

signal signal_completed_turn

func _ready():
	pass

func self_node():
	return self

func set_currently_active_character(node):
	currently_active_character = node
	# print("\n\n Set currently active character")
	if currently_active_character.connect("signal_completed_turn",Callable(self,"s_completed_turn")) != OK:
		print("SingletonGlobalBattleVariables - failed to connect")

func s_completed_turn():
	# TODO: check might be outdated comment - doesnt yield work
	emit_signal("signal_completed_turn")
	currently_active_character.disconnect("signal_completed_turn",Callable(self,"s_completed_turn"))
