extends Node2D

var is_battle_inventory_menu_active: bool = false

enum e_inventory_menu_options {
	USE_OPTION,
	GIVE_OPTION,
	EQUIP_OPTION,
	DROP_OPTION
}
var currently_selected_option: int = e_inventory_menu_options.USE_OPTION

@onready var animationPlayer = $AnimationPlayer

@onready var label = $NinePatchRect/Label

@onready var use_spirte   = $UseActionSprite
@onready var give_spirte  = $GiveActionSprite
@onready var equip_spirte = $EquipActionSprite
@onready var drop_spirte  = $DropActionSprite


func _ready():
	Singleton_CommonVariables.ui__inventory_menu = self
	set_sprites_to_zero_frame()
	# $AnimationPlayer.playback_speed = 2
	animationPlayer.play("UseMenuOption")
	label.text = "Use"


func show_with_tween() -> void:
	show()
	set_menu_active()


func set_menu_active() -> void:
	is_battle_inventory_menu_active = true


func _input(event):
	if is_battle_inventory_menu_active:
		if event.is_action_released("ui_b_key"):
			print("Cancel Battle Inventory Menu")
			is_battle_inventory_menu_active = false
			Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
			
			Singleton_CommonVariables.ui__inventory_menu.hide()
			# Singleton_BattleVariables.battle_base.s_hide_battle_inventory_menu()
			
			Singleton_CommonVariables.ui__battle_action_menu.show()
			Singleton_CommonVariables.ui__gold_info_box.show_cust()
			Singleton_CommonVariables.ui__actor_micro_info_box.show_cust()
			
			# Singleton_BattleVariables.battle_base.s_show_battle_action_menu("right")
			
			# TODO: HACK: FIXME: Dirty hack need a better way to gurantee when action is completed to prevent retrigger
			# yield on signal seems busted sometimes gets double called or falls through?
			await Signal(get_tree().create_timer(0.1), "timeout")
			
			Singleton_CommonVariables.ui__battle_action_menu.set_menu_active()
			# get_parent().get_node("BattleActionsMenuRoot").set_menu_active()
			return
			
		if event.is_action_released("ui_a_key"):
			print("Accept Action - ", currently_selected_option)
			
			if currently_selected_option == e_inventory_menu_options.EQUIP_OPTION:
				cleanup_for_sub_menu_navigation()
				
				# TODO: all of these options are going to depend on in vbattle or not
				# different following menus will be needed
				
				if Singleton_CommonVariables.is_currently_in_battle_scene:
					Singleton_CommonVariables.ui__equip_menu.show()
					Singleton_CommonVariables.ui__equip_menu.set_menu_active()
				else:
					Singleton_CommonVariables.action_type = "EQUIP"
					Singleton_CommonVariables.ui__member_list_menu.show()
					Singleton_CommonVariables.ui__member_list_menu.set_overvview_view_active()
					Singleton_CommonVariables.ui__member_list_menu.set_menu_active()
				
				return
			elif currently_selected_option == e_inventory_menu_options.USE_OPTION:
				cleanup_for_sub_menu_navigation()
				
				if Singleton_CommonVariables.is_currently_in_battle_scene:
					Singleton_CommonVariables.ui__use_menu.show()
					Singleton_CommonVariables.ui__use_menu.set_battle_use_menu_active()
				else:
					Singleton_CommonVariables.action_type = "USE"
					Singleton_CommonVariables.ui__member_list_menu.show()
					Singleton_CommonVariables.ui__member_list_menu.set_overvview_view_active()
					Singleton_CommonVariables.ui__member_list_menu.set_menu_active()
				
				return
			elif currently_selected_option == e_inventory_menu_options.DROP_OPTION:
				cleanup_for_sub_menu_navigation()
				
				if Singleton_CommonVariables.is_currently_in_battle_scene:
					Singleton_BattleVariables.battle_base.s_show_battle_drop_menu()
				else:
					Singleton_CommonVariables.action_type = "DROP"
					Singleton_CommonVariables.ui__member_list_menu.show()
					Singleton_CommonVariables.ui__member_list_menu.set_overvview_view_active()
					Singleton_CommonVariables.ui__member_list_menu.set_menu_active()
				
				return
			elif currently_selected_option == e_inventory_menu_options.GIVE_OPTION:
				cleanup_for_sub_menu_navigation()
				
				if Singleton_CommonVariables.is_currently_in_battle_scene:
					Singleton_BattleVariables.battle_base.s_show_battle_give_menu()
				else:
					Singleton_CommonVariables.action_type = "GIVE"
					Singleton_CommonVariables.ui__member_list_menu.show()
					Singleton_CommonVariables.ui__member_list_menu.set_overvview_view_active()
					Singleton_CommonVariables.ui__member_list_menu.set_menu_active()
				
				return
			
		if event.is_action_pressed("ui_down"):
			select_sub_inventory_menu("Drop", "DropMenuOption", e_inventory_menu_options.DROP_OPTION)
		elif event.is_action_pressed("ui_up"):
			select_sub_inventory_menu("Use", "UseMenuOption", e_inventory_menu_options.USE_OPTION)
		elif event.is_action_pressed("ui_right"):
			select_sub_inventory_menu("Equip", "EquipMenuOption", e_inventory_menu_options.EQUIP_OPTION)
		elif event.is_action_pressed("ui_left"):
			select_sub_inventory_menu("Give", "GiveMenuOption", e_inventory_menu_options.GIVE_OPTION)


func cleanup_for_sub_menu_navigation() -> void:
	is_battle_inventory_menu_active = false
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuSelectSoundModif.wav")
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuPanSoundCut.wav")
	Singleton_CommonVariables.ui__inventory_menu.hide()
	# Singleton_BattleVariables.battle_base.s_hide_battle_inventory_menu("right")


func select_sub_inventory_menu(sub_menu_name: String, animation_name: String, sub_menu_option) -> void:
	# print(sub_menu_name)
	Singleton_AudioManager.play_sfx("res://Assets/Sounds/MenuMoveSoundCut.wav")
	set_sprites_to_zero_frame()
	currently_selected_option = sub_menu_option
	animationPlayer.play(animation_name)
	label.text = sub_menu_name


func set_sprites_to_zero_frame() -> void:
	use_spirte.frame = 0
	give_spirte.frame = 0
	equip_spirte.frame = 0
	drop_spirte.frame = 0
