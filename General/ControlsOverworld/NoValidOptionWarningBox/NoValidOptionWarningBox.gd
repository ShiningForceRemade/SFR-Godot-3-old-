extends Node2D

@onready var textLabel = $BackgroundNinePatchRect/TextLabel

var internal_cleanup_timer: Timer
const internal_cleanup_timer_name: String = "internal_cleanup_timer__no_valid_option_warning_box"

var is_no_valid_option_active: bool = false

var re_show_action_menu: bool = true


func _ready():
	Singleton_CommonVariables.ui__not_valid_box = self
	pass


func _input(event):
	if is_no_valid_option_active:
		if event.is_action_released("ui_a_key") or event.is_action_released("ui_b_key") or event.is_action_released("ui_c_key"):
			s_internal_cleanup_timer_completed()


func set_text(text_arg: String) -> void:
	textLabel.text = text_arg


func set_paused_text() -> void:
	set_text("PAUSED")


func set_no_target_text() -> void:
	set_text("No target.")


func set_no_maigc_text() -> void:
	set_text("No magic.")


func set_no_cant_use_text() -> void:
	set_text("Can't use.")


func start_self_clear_timer() -> void:
	internal_cleanup_timer = Timer.new()
	internal_cleanup_timer.set_name(internal_cleanup_timer_name)
	var _ignore = internal_cleanup_timer.connect("timeout", Callable(self, "s_internal_cleanup_timer_completed"))
	internal_cleanup_timer.set_wait_time(3)
	add_child(internal_cleanup_timer)
	internal_cleanup_timer.start()
	
	is_no_valid_option_active = true


func s_internal_cleanup_timer_completed() -> void:
	internal_cleanup_timer.stop()
	internal_cleanup_timer.queue_free()
	internal_cleanup_timer = null
	
	is_no_valid_option_active = false
	
	Singleton_CommonVariables.ui__not_valid_box.hide()
	# get_parent().get_parent().get_parent().s_hide_no_valid_option_warning_box()
	
	# TODO: FIXME: Dirty hack waiting a tiny bit to prevent double b released from trigger here
	# and in the battle action menu leading to a premature closing of the menu
	await Signal(get_tree().create_timer(0.1), "timeout")
	
	if re_show_action_menu:
		get_parent().get_parent().get_parent().s_show_character_action_menu()
