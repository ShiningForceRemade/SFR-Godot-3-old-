extends Node2D

# center screen position
# 132, 101

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
		# yield(get_tree().create_timer(0.02), "timeout")
		# event.is_action_released("ui_accept"):
		print("Accept Action - ", currently_selected_option)
		if currently_selected_option == e_menu_options.YES_OPTION:
			is_menu_active = false
			
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.s_hide__yes_or_no_prompt()
			
			emit_signal("signal__yes_or_no_prompt__choice", "YES")
			
			# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
			# Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
			# Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
			
			return
		elif currently_selected_option == e_menu_options.NO_OPTION:
			is_menu_active = false
			
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.s_hide__yes_or_no_prompt()
			
			emit_signal("signal__yes_or_no_prompt__choice", "NO")
			
			# Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://General/PriestMenu/Scripts/AttemptToRaiseDead.json"
			# Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
			# get_parent().get_parent().get_parent().s_show_battle_inventory_menu()
			
			return

func _input(event):
	if is_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Go To NO option - Double check on the actual rom")
			return
			
			is_menu_active = false
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			yield(get_tree().create_timer(0.02), "timeout")
			
			# Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal().active = true
			# get_parent().get_parent().get_parent().s_show_battle_action_menu("down")
			# TODO add animation
			hide()
			
			Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
			Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
			Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
			#get_parent().get_parent().get_parent().s_hide_action_menu()
			return
			
#		if event.is_action_released("ui_a_key"):
#			yield(get_tree().create_timer(0.02), "timeout")
#			# event.is_action_released("ui_accept"):
#			print("Accept Action - ", currently_selected_option)
#			if currently_selected_option == e_menu_options.YES_OPTION:
#				is_menu_active = false
#
#				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
#				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
#
#				Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.s_hide__yes_or_no_prompt()
#
#				# Singleton_Game_GlobalCommonVariables.main_character_player_node.active = true
#				# Singleton_Game_GlobalCommonVariables.menus_root_node.gold_info_box_node().hide()
#				# Singleton_Game_GlobalCommonVariables.menus_root_node.character_info_box_node().hide()
#
#				return
#			elif currently_selected_option == e_menu_options.NO_OPTION:
#				is_menu_active = false
#
#				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
#				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
#
#				Singleton_Game_GlobalCommonVariables.menus_root_node.UserInteractionPromptsRoot.s_hide__yes_or_no_prompt()
#
#				# Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
#				# Singleton_Game_GlobalCommonVariables.dialogue_box_node.external_file = "res://General/PriestMenu/Scripts/AttemptToRaiseDead.json"
#				# Singleton_Game_GlobalCommonVariables.dialogue_box_node._process_new_resource_file()
#				# get_parent().get_parent().get_parent().s_show_battle_inventory_menu()
#
#				return
		
		if event.is_action_pressed("ui_right"):
			menu_option_selected(e_menu_options.NO_OPTION, "NoMenuOption")
		elif event.is_action_pressed("ui_left"):
			menu_option_selected(e_menu_options.YES_OPTION, "YesMenuOption")


func menu_option_selected(e_menu_option_selected, animation_name: String) -> void:
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_option_selected
	animationPlayer.play(animation_name)


func set_sprites_to_zero_frame() -> void:
	yes_spirte.frame = 0
	no_spirte.frame = 0

