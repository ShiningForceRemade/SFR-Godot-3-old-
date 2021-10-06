extends Node2D

var is_menu_active: bool =  false

enum e_menu_options {
	TALK_OPTION,
	MAGIC_OPTION,
	INVENTORY_OPTION,
	SEARCH_OPTION
}
var currently_selected_option: int = e_menu_options.TALK_OPTION

onready var animationPlayer = $AnimationPlayer
onready var label = $NinePatchRect/Label

onready var talk_spirte    = $TalkActionSprite
onready var magic_spirte     = $MagicActionSprite
onready var inventory_spirte = $InventoryActionSprite
onready var search_spirte      = $SearchActionSprite

onready var noValidOptionNode = get_parent().get_node("NoValidOptionWarningBoxRoot")

func _ready():
	set_sprites_to_zero_frame()
	$AnimationPlayer.playback_speed = 2
	animationPlayer.play("TalkMenuOption")
	label.text = "Talk"


func set_menu_active() -> void:
	is_menu_active = true
	
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_options.TALK_OPTION
	animationPlayer.play("TalkMenuOption")
	label.text = "Talk"


func _input(event):
	if is_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Action Menu")
			is_menu_active = false
			yield(get_tree().create_timer(0.02), "timeout")
			Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal().active = true
			get_parent().get_parent().get_parent().s_show_battle_action_menu("down")
			#get_parent().get_parent().get_parent().s_hide_action_menu()
			return
			
		if event.is_action_released("ui_a_key"):
			yield(get_tree().create_timer(0.02), "timeout")
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
				
				if Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal().spells_id.size() == 0:
					noValidOptionNode.re_show_action_menu = true
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
				
				var caa = Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal()
				
				var equip_arg = caa.inventory_items_id[0]
				
				if caa.actor_type == "character":
					# TODO move this within the target select node itself
					# TODO: need to adjust this to handle attacking without a weapon equipped
					# if caa.inventory_items_id.length > 0:	
					Singleton_Game_GlobalBattleVariables.target_selection_node.setup_use_range_and_target_range_selection(equip_arg)
				elif caa.actor_type == "enemey":
					# TODO add a selectable version of the below also need to add get actor type to the bases
					# also really need to start cleaning up a lot of this cruft 
					Singleton_Game_GlobalBattleVariables.target_selection_node.setup_use_range_and_target_range_selection(equip_arg, "character")
					# Singleton_Game_GlobalBattleVariables.target_selection_node.setup_use_range_and_target_range_selection_enemey_static()
				else:
					# TODO: should add a prefix to my errors for easy filtering
					print("FELDC - Actor doesn't have type (not character or enemey)")
					push_error("FELDC - Actor doesn't have type (not character or enemey)")
				
				return
		
		if event.is_action_pressed("ui_down"):
			menu_option_selected(e_menu_options.SEARCH_OPTION, "SearchMenuOption", "Search")
		elif event.is_action_pressed("ui_up"):
			menu_option_selected(e_menu_options.TALK_OPTION, "TalkMenuOption", "Talk")
		elif event.is_action_pressed("ui_right"):
			menu_option_selected(e_menu_options.INVENTORY_OPTION, "InventoryMenuOption", "Inventory")
		elif event.is_action_pressed("ui_left"):
			menu_option_selected(e_menu_options.MAGIC_OPTION, "MagicMenuOption", "Magic")


func menu_option_selected(e_menu_option_selected, animation_name: String, label_text: String) -> void:
	Singleton_Game_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
	set_sprites_to_zero_frame()
	currently_selected_option = e_menu_option_selected
	animationPlayer.play(animation_name)
	label.text = label_text


func set_sprites_to_zero_frame() -> void:
	talk_spirte.frame = 0
	magic_spirte.frame = 0
	inventory_spirte.frame = 0
	search_spirte.frame = 0

