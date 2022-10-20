extends Node2D

# signal _ready

signal signal_completed_turn
signal signal_character_moved(new_pos)

signal signal_show_character_action_menu

signal signal_switch_focus_to_cursor

func _ready():
	# print("Tao is ready")
	# get_parent().RestartAfterActorChange()
	# emit_signal("_ready")
	pass

# Getters
func cget_agility() -> int:
	return $CharacterRoot.agility

func cget_spells():
	return $CharacterRoot.spells_id

func cget_actor_name() -> String: return $CharacterRoot.character_name
func cget_level() -> int: return $CharacterRoot.level
func cget_hp_total() -> int: return $CharacterRoot.HP_Total
func cget_hp_current() -> int: return $CharacterRoot.HP_Current
func cget_mp_total() -> int: return $CharacterRoot.MP_Total
func cget_mp_current() -> int: return $CharacterRoot.MP_Current
func cget_class() -> String: return $CharacterRoot.cget_class()

func cget_movement_type() -> int: return $CharacterRoot.movement_type

# mucking around setup clean later when methods picked

# play_turn
func play_turn():
	print("\n" + $CharacterRoot.character_name + " Turn Start\n")	
	$CharacterRoot.play_turn()
	if $CharacterRoot.connect("signal_completed_turn", self, "s_complete_turn") != OK:
		print($CharacterRoot.character_name + " - signal_completed_turn failed to connect")
		
	if $CharacterRoot.connect("signal_character_moved", self, "s_char_moved")  != OK:
		print($CharacterRoot.character_name + " - signal_character_moved failed to connect")
		
	if $CharacterRoot.connect("signal_show_character_action_menu", self, "s_show_character_action_menu") != OK:
		print($CharacterRoot.character_name + " - signal_show_character_action_menu failed to connect")
	# yield(self, "signal_completed_turn")
	
	if $CharacterRoot.connect("signal_switch_focus_to_cursor", self, "s_switch_focus_to_cursor") != OK:
		print($CharacterRoot.character_name + " - signal_switch_focus_to_cursor failed to connect")

func s_switch_focus_to_cursor():
	print($CharacterRoot.character_name + " Switch to cursor - \'b\' was pressed\n")
	emit_signal("signal_switch_focus_to_cursor")

func s_complete_turn():
	print("\n" + $CharacterRoot.character_name + " Turn End\n")
	$CharacterRoot.animationPlayer.play("DownMovement")
	$CharacterRoot.disconnect("signal_completed_turn", self, "s_complete_turn")
	$CharacterRoot.disconnect("signal_character_moved", self, "s_char_moved")
	$CharacterRoot.disconnect("signal_show_character_action_menu", self, "s_show_character_action_menu")
	$CharacterRoot.disconnect("signal_switch_focus_to_cursor", self, "s_switch_focus_to_cursor")
	emit_signal("signal_completed_turn")

func s_char_moved(new_pos):
	emit_signal("signal_character_moved", new_pos)

func s_show_character_action_menu():
	emit_signal("signal_show_character_action_menu")

func get_character_movement():
	return $CharacterRoot.move

func get_character_current_pos() -> Vector2:
	return $CharacterRoot/KinematicBody2D.position

func get_kinematic_body():
	return $CharacterRoot/KinematicBody2D

func get_actor_root_node_internal():
	return get_node("CharacterRoot")
