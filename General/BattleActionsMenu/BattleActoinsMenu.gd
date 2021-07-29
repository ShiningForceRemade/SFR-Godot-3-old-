extends Node2D

var is_menu_active: bool =  false

enum e_menu_options {
	ATTACK_OPTION,
	MAGIC_OPTION,
	INVENTORY_OPTION,
	STAY_OPTION
}
var currently_selected_option: int = e_menu_options.STAY_OPTION

onready var animationPlayer = $AnimationPlayer
onready var label = $NinePatchRect/Label

onready var attack_spirte    = $AttackActionSprite
onready var magic_spirte     = $MagicActionSprite
onready var inventory_spirte = $InventoryActionSprite
onready var stay_spirte      = $StayActionSprite

onready var noValidOptionNode = get_parent().get_node("NoValidOptionWarningBoxRoot")

func _ready():
	set_sprites_to_zero_frame()
	$AnimationPlayer.playback_speed = 2
	animationPlayer.play("StayMenuOption")
	label.text = "Stay"


func set_menu_active() -> void:
	is_menu_active = true


func _input(event):
	if is_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Action Menu")
			is_menu_active = false
			yield(get_tree().create_timer(0.02), "timeout")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").active = true
			get_parent().get_parent().get_parent().s_show_battle_action_menu("down")
			#get_parent().get_parent().get_parent().s_hide_action_menu()
			return
			
		if event.is_action_released("ui_a_key"):
			yield(get_tree().create_timer(0.1), "timeout")
			# event.is_action_released("ui_accept"):
			print("Accept Action - ", currently_selected_option)
			if currently_selected_option == e_menu_options.STAY_OPTION:
				print("Currently Active Character Node - ", Singleton_Game_GlobalBattleVariables.currently_active_character)
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
				Singleton_Game_GlobalBattleVariables.currently_active_character.s_complete_turn()
				
				# emit_signal("signal_completed_turn")
				is_menu_active = false
				get_parent().get_parent().get_parent().s_hide_action_menu()
				return
			elif currently_selected_option == e_menu_options.INVENTORY_OPTION:
				is_menu_active = false
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
				get_parent().get_parent().get_parent().s_hide_action_menu()
				get_parent().get_parent().get_parent().s_show_battle_inventory_menu()
				return
			elif currently_selected_option == e_menu_options.MAGIC_OPTION:
				is_menu_active = false
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
				
				if Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").spells_id.size() == 0:
					noValidOptionNode.set_no_maigc_text()
					# get_parent().get_parent().get_parent().s_hide_action_menu()
					get_parent().get_parent().get_parent().s_hide_character_action_menu()
					get_parent().get_parent().get_parent().s_show_no_valid_option_warning_box()
				else:
					get_parent().get_parent().get_parent().s_hide_action_menu()
					get_parent().get_parent().get_parent().s_show_battle_magic_menu()
					
				return
			elif currently_selected_option == e_menu_options.ATTACK_OPTION:
				is_menu_active = false
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
				Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
				
				get_parent().get_parent().get_parent().s_hide_character_action_menu()
				# get_parent().get_parent().get_parent().s_show_battle_magic_menu()
				# setup_attack_range_and_selection()
				
				# TODO move this within the target select node itself
				var equip_arg = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").inventory_items_id[0]
				Singleton_Game_GlobalBattleVariables.target_selection_node.setup_use_range_and_target_range_selection(equip_arg)
				
				return
		
		if event.is_action_pressed("ui_down"):
			print("Down")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
			set_sprites_to_zero_frame()
			currently_selected_option = e_menu_options.STAY_OPTION
			animationPlayer.play("StayMenuOption")
			label.text = "Stay"
		elif event.is_action_pressed("ui_up"):
			print("up")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
			set_sprites_to_zero_frame()
			currently_selected_option = e_menu_options.ATTACK_OPTION
			animationPlayer.play("AttackMenuOption")
			label.text = "Attack"
		elif event.is_action_pressed("ui_right"):
			print("Right")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
			set_sprites_to_zero_frame()
			currently_selected_option = e_menu_options.INVENTORY_OPTION
			animationPlayer.play("InventoryMenuOption")
			label.text = "Inventory"
		elif event.is_action_pressed("ui_left"):
			print("Left")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
			set_sprites_to_zero_frame()
			currently_selected_option = e_menu_options.MAGIC_OPTION
			animationPlayer.play("MagicMenuOption")
			label.text = "Magic"
			


func set_sprites_to_zero_frame() -> void:
	attack_spirte.frame = 0
	magic_spirte.frame = 0
	inventory_spirte.frame = 0
	stay_spirte.frame = 0


func setup_attack_range_and_selection():
	# TODO: FIXME: temp while migrating to github and setting new structure
	var equips = Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").inventory_items_id
	var item_use_range
	var target_range
	for equip in equips:
		if equip is CN_SF1_Item_Weapon:
			print(equip)
			print(equip.item_use_range_path)
			item_use_range = load(equip.item_use_range_path).new()
			print(item_use_range)
			item_use_range._ready()
			# TODO create cleanup function to remove the attack grid when canclled or completed
			item_use_range.draw_use_range()
			target_range = load(equip.item_use_target_path).new()
			# TODO create cleanup function for this to remove the curosr
			target_range.draw_cursor_and_get_targets("test arg 123")
			return
