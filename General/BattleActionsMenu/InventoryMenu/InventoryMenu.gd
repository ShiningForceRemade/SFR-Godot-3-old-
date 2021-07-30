extends Node2D

var is_battle_inventory_menu_active: bool = false

enum e_inventory_menu_options {
	USE_OPTION,
	GIVE_OPTION,
	EQUIP_OPTION,
	DROP_OPTION
}
var currently_selected_option: int = e_inventory_menu_options.USE_OPTION

onready var animationPlayer = $AnimationPlayer
onready var label = $NinePatchRect/Label

onready var use_spirte = $UseActionSprite
onready var give_spirte = $GiveActionSprite
onready var equip_spirte = $EquipActionSprite
onready var drop_spirte = $DropActionSprite

func _ready():
	set_sprites_to_zero_frame()
	$AnimationPlayer.playback_speed = 2
	animationPlayer.play("UseMenuOption")
	label.text = "Use"

func set_battle_inventory_menu_active():
	is_battle_inventory_menu_active = true

func _input(event):
	if is_battle_inventory_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Battle Inventory Menu")
			is_battle_inventory_menu_active = false
			
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			# Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").active = true
			get_parent().get_parent().get_parent().s_hide_battle_inventory_menu()
			get_parent().get_parent().get_parent().s_show_battle_action_menu("right")
			
			# TODO: HACK: FIXME: Dirty hack need a better way to gurantee when action is completed to prevent retrigger
			# yield on signal seems busted sometimes gets double called or falls through?
			yield(get_tree().create_timer(0.1), "timeout")
			get_parent().get_node("BattleActionsMenuRoot").set_menu_active()
			return
			
		if event.is_action_released("ui_a_key"): # event.is_action_released("ui_accept"):
			print("Accept Action - ", currently_selected_option)
			#if currently_selected_option == e_menu_options.STAY_OPTION:
			#	print("Currently Active Character Node - ", Singleton_Game_GlobalBattleVariables.currently_active_character)
			#	Singleton_Game_GlobalBattleVariables.currently_active_character.s_complete_turn()
				
			#	# emit_signal("signal_completed_turn")
			#	is_battle_inventory_menu_active = false
			#	get_parent().get_parent().s_hide_action_menu()
			#	return
			if currently_selected_option == e_inventory_menu_options.EQUIP_OPTION:
				is_battle_inventory_menu_active = false
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
				get_parent().get_parent().get_parent().s_hide_battle_inventory_menu("right")
				get_parent().get_parent().get_parent().s_show_battle_equip_menu()
				return
			elif currently_selected_option == e_inventory_menu_options.USE_OPTION:
				is_battle_inventory_menu_active = false
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
				get_parent().get_parent().get_parent().s_hide_battle_inventory_menu("right")
				get_parent().get_parent().get_parent().s_show_battle_use_menu()
				return
			elif currently_selected_option == e_inventory_menu_options.DROP_OPTION:
				is_battle_inventory_menu_active = false
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
				get_parent().get_parent().get_parent().s_hide_battle_inventory_menu("right")
				get_parent().get_parent().get_parent().s_show_battle_drop_menu()
				return
			elif currently_selected_option == e_inventory_menu_options.GIVE_OPTION:
				is_battle_inventory_menu_active = false
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
				get_parent().get_parent().get_parent().s_hide_battle_inventory_menu("right")
				get_parent().get_parent().get_parent().s_show_battle_give_menu()
				return
			
		if event.is_action_pressed("ui_down"):
			print("Drop")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
			set_sprites_to_zero_frame()
			currently_selected_option = e_inventory_menu_options.DROP_OPTION
			animationPlayer.play("DropMenuOption")
			label.text = "Drop"
		elif event.is_action_pressed("ui_up"):
			print("Use")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
			set_sprites_to_zero_frame()
			currently_selected_option = e_inventory_menu_options.USE_OPTION
			animationPlayer.play("UseMenuOption")
			label.text = "Use"
		elif event.is_action_pressed("ui_right"):
			print("Equip")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
			set_sprites_to_zero_frame()
			currently_selected_option = e_inventory_menu_options.EQUIP_OPTION
			animationPlayer.play("EquipMenuOption")
			label.text = "Equip"
		elif event.is_action_pressed("ui_left"):
			print("Give")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
			set_sprites_to_zero_frame()
			currently_selected_option = e_inventory_menu_options.GIVE_OPTION
			animationPlayer.play("GiveMenuOption")
			label.text = "Give"
			
func set_sprites_to_zero_frame():
	use_spirte.frame = 0
	give_spirte.frame = 0
	equip_spirte.frame = 0
	drop_spirte.frame = 0
