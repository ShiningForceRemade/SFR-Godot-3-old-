extends Node

var battle_base

var currently_active_character

var currently_selected_actor

var field_logic_node
var character_wrapper_node
var enemies_wrapper_node

var cursor_root_ref = null

var selected_actor
var selected_actor_type

signal signal_completed_turn

func _ready():
	pass

func self_node():
	return self

func set_currently_active_character(node):
	currently_active_character = node
	print("\n\n Set currently active character")
	if currently_active_character.connect("signal_completed_turn", self, "s_completed_turn") != OK:
		print("SingletonGlobalBattleVariables - failed to connect")

func s_completed_turn():
	print("AHHHHHH YEAHHHHHHHh now why doesnt yield work")
	emit_signal("signal_completed_turn")
	currently_active_character.disconnect("signal_completed_turn", self, "s_completed_turn")
