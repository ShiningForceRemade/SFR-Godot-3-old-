extends Node2D

signal signal__yes_or_no_prompt__choice

var is_menu_active: bool = false

enum e_menu_options {
	YES_OPTION,
	NO_OPTION,
}
var currently_selected_option: int = e_menu_options.YES_OPTION

onready var animationPlayer = $AnimationPlayer

onready var yes_spirte    = $YesActionSprite
onready var no_spirte     = $NoActionSprite

# onready var noValidOptionNode = get_parent().get_node("NoValidOptionWarningBoxRoot")

func _ready():
	set_sprites_to_zero_frame()
	$AnimationPlayer.playback_speed = 2
	animationPlayer.play("YesMenuOption")


func set_menu_active() -> void:
	yield(get_tree().create_timer(0.02), "timeout")
	
	is_menu_active = true
	
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_options.YES_OPTION
	animationPlayer.play("YesMenuOption")


func _process(_delta):
	if !is_menu_active:
		return
	
	if Input.is_action_just_pressed("ui_a_key"):
		print("Accept Action - ", currently_selected_option)
		if currently_selected_option == e_menu_options.YES_OPTION:
			YesChoiceSelected()
			return
		elif currently_selected_option == e_menu_options.NO_OPTION:
			NoChoiceSelected()
			return
	
	elif Input.is_action_just_pressed("ui_b_key"):
		menu_option_selected(e_menu_options.NO_OPTION, "NoMenuOption")
		
		# Small yield to quickly show the no selection before disappering
		yield(get_tree().create_timer(0.1), "timeout")
		
		NoChoiceSelected()
		return
		
	elif Input.is_action_just_pressed("ui_right"):
		menu_option_selected(e_menu_options.NO_OPTION, "NoMenuOption")
	elif Input.is_action_just_pressed("ui_left"):
		menu_option_selected(e_menu_options.YES_OPTION, "YesMenuOption")


func menu_option_selected(e_menu_option_selected, animation_name: String) -> void:
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_option_selected
	animationPlayer.play(animation_name)


func set_sprites_to_zero_frame() -> void:
	yes_spirte.frame = 0
	no_spirte.frame = 0


func YesChoiceSelected() -> void:
	is_menu_active = false
	
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	
	Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.s_hide__yes_or_no_prompt()
	
	emit_signal("signal__yes_or_no_prompt__choice", "YES")


func NoChoiceSelected() -> void:
	is_menu_active = false
	
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	
	Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.s_hide__yes_or_no_prompt()
	
	emit_signal("signal__yes_or_no_prompt__choice", "NO")
