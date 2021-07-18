extends Node2D

onready var textLabel = $BackgroundNinePatchRect/TextLabel

var internal_cleanup_timer: Timer
const internal_cleanup_timer_name: String = "internal_cleanup_timer__no_valid_option_warning_box"

var is_no_valid_option_active: bool = false

func _ready():
	pass

func _input(event):
	if is_no_valid_option_active:
		if event.is_action_released("ui_a_key") or event.is_action_released("ui_b_key") or event.is_action_released("ui_c_key"):
			s_internal_cleanup_timer_completed()


func set_text(text_arg: String) -> void:
	textLabel.text = text_arg

func set_no_target_text() -> void:
	set_text("No target.")

func set_no_maigc_text() -> void:
	set_text("No magic.")

func start_self_clear_timer() -> void:
	internal_cleanup_timer = Timer.new()
	internal_cleanup_timer.set_name(internal_cleanup_timer_name)
	internal_cleanup_timer.connect("timeout", self, "s_internal_cleanup_timer_completed")
	internal_cleanup_timer.set_wait_time(3)
	add_child(internal_cleanup_timer)
	internal_cleanup_timer.start()
	
	is_no_valid_option_active = true

func s_internal_cleanup_timer_completed() -> void:
	internal_cleanup_timer.stop()
	internal_cleanup_timer.queue_free()
	internal_cleanup_timer = null
	
	is_no_valid_option_active = false
	
	get_parent().get_parent().get_parent().s_hide_no_valid_option_warning_box()
	
	# TODO: FIXME: Dirty hack waiting a tiny bit to prevent double b released from trigger here
	# and in the battle action menu leading to a premature closing of the menu
	yield(get_tree().create_timer(0.1), "timeout")
	
	get_parent().get_parent().get_parent().s_show_character_action_menu()
