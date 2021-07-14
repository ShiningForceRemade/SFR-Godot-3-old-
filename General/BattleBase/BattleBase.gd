extends Node

# bmc - battle_menu_center_ x and y cordinates
const bmc_x: int = 171
const bmc_y: int = 182

# onready var battleAttackAnimationPlayer = $CanvasLayerInfoControls/BattleAttackAnimationPlayer

func _ready():
	# battleAttackAnimationPlayer.hide()
	s_hide_action_menu()
	s_hide_battle_inventory_menu()
	s_hide_battle_magic_menu()
	s_hide_battle_equip_menu()
	s_hide_battle_view_selected_actor_info_menu()
	s_hide_battle_use_menu()
	s_hide_battle_drop_menu()
	s_hide_battle_give_menu()
	
	print("Game Version - ", ProjectSettings.get_setting("application/config/Version"))
	
	if $BattleOneRoot.connect("signal_land_effect_under_tile", self, "s_land_effect") != OK:
		print("BattleBase - signal_land_effect_under_tile failed to connect")
		
	if $BattleOneRoot.connect("signal_active_character_or_enemey", self, "s_active_character_or_enemey") != OK:
		print("BattleBase - signal_active_character_or_enemey failed to connect")
	
	if $BattleOneRoot.connect("signal_hide_land_effect_and_active_actor_info", self, "s_hide_land_effect_and_active_actor_info") != OK:
		print("BattleBase - signal_hide_land_effect_and_active_actor_info failed to connect")
		
	if $BattleOneRoot.connect("signal_show_land_effect_and_active_actor_info", self, "s_show_land_effect_and_active_actor_info") != OK:
		print("BattleBase - signal_show_land_effect_and_active_actor_info failed to connect")
		
	if $BattleOneRoot.connect("signal_show_character_action_menu", self, "s_show_character_action_menu") != OK:
		print("BattleBase - signal_show_character_action_menu failed to connect")

	if $BattleOneRoot.connect("signal_selected_actor_underneath_cursor", self, "s_selected_actor_underneath_cursor") != OK:
		print("BattleBase - signal_selected_actor_underneath_cursor failed to connect")

func s_selected_actor_underneath_cursor():
	print("WE INNNNN")
	s_show_battle_view_selected_actor_info_menu()
	#print("Selected Actor under cursor")
	#print(Singleton_Game_GlobalBattleVariables.selected_actor_type, Singleton_Game_GlobalBattleVariables.selected_actor)
	#emit_signal("signal_selected_actor_underneath_cursor") 

func s_land_effect(land_effect):
	$CanvasLayerInfoControls.update_land_effect(land_effect)

func s_active_character_or_enemey(name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp):
	$CanvasLayerInfoControls.update_active_character_or_enemey_info(name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp)	

# Land Effect and Active Actor Info Windows Start
func s_hide_land_effect_and_active_actor_info():
	# lots of works need to done to setup looped background music 
	# and one shoot sound effects (FX) sounds and ways to stop em
	# Singleton_Game_AudioManager.play("res://Assets/SF1/SoundBank/Jingle - Curse.mp3")
	set_land_effect_and_active_actor_positions(500, -90)
	
func s_show_land_effect_and_active_actor_info():
	set_land_effect_and_active_actor_positions(270, 6)

func set_land_effect_and_active_actor_positions(active_x: int, land_x: int):
	var tween_landeffect = $CanvasLayerInfoControls/LandEffectPopupTween
	var aair_rect = $CanvasLayerInfoControls/ActiveActorMicroInfoRoot.rect_position
	tween_landeffect.interpolate_property($CanvasLayerInfoControls/ActiveActorMicroInfoRoot, "rect_position",
			aair_rect, Vector2(active_x, aair_rect.y), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_landeffect.start()
	
	var tween_activeActor = $CanvasLayerInfoControls/ActiveAcorMicroInfoTween
	var lep_rect = $CanvasLayerInfoControls/LandEffectPopupRoot.rect_position
	tween_activeActor.interpolate_property($CanvasLayerInfoControls/LandEffectPopupRoot, "rect_position",
			lep_rect, Vector2(land_x, lep_rect.y), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_activeActor.start()

# Land Effect and Active Actor Info Windows End

# Action Menu
# delete these three functions after checking over
func s_show_action_menu():
	set_action_menu(500)

func s_hide_action_menu():
	set_action_menu(500)

func set_action_menu(xpos: int):
	var tween_actionMenu = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleActionsMenuTween
	var bam_rect = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleActionsMenuRoot.position
	tween_actionMenu.interpolate_property($CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleActionsMenuRoot, "position",
			bam_rect, Vector2(xpos, bam_rect.y), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_actionMenu.start()

func s_show_character_action_menu():
	internal_tween_battle_action_menu(bmc_x, bmc_y + 80, bmc_x, bmc_y)
	$CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleActionsMenuRoot.set_menu_active()

func s_hide_character_action_menu():
	internal_tween_battle_action_menu(bmc_x, bmc_y, bmc_x, bmc_y + 80)
	$CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleActionsMenuRoot.set_menu_active()

func s_show_battle_action_menu(tween_direction):
	if tween_direction == "right":
		internal_tween_battle_action_menu(bmc_x * 2.5, bmc_y, bmc_x, bmc_y)
	else:
		internal_tween_battle_action_menu(bmc_x, bmc_y, bmc_x, bmc_y + 80)

func internal_tween_battle_action_menu(ox, oy, nx, ny):
	var tween_actionMenu = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleActionsMenuTween
	#var bim_rect = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot.position
	#print(bim_rect)
	tween_actionMenu.interpolate_property($CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleActionsMenuRoot, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_actionMenu.start()	

###
# Battle Actions Menus Start
###

func s_show_battle_inventory_menu(tween_direction = "not_right"):
	if tween_direction == "right":
		internal_tween_battle_inventory_menu(bmc_x * 2.5, bmc_y, bmc_x, bmc_y)
	else:
		# var tween_inventoryMenu = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuTween
		#var bam_rect = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleActionsMenuRoot.position
		#print(bam_rect)
		#tween_inventoryMenu.interpolate_property($CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot, "position",
		#		Vector2(bmc_x, bmc_y), Vector2(bmc_x * 2.5, bmc_y), 0.1,
		#		Tween.TRANS_LINEAR, Tween.EASE_OUT)
		#tween_inventoryMenu.start()
		internal_tween_battle_inventory_menu(bmc_x, bmc_y + 80, bmc_x, bmc_y)
		
	$CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot.set_battle_inventory_menu_active()
	
	# pass

func s_hide_battle_inventory_menu(tween_direction = "not_right"):
	if tween_direction == "right":
		internal_tween_battle_inventory_menu(bmc_x, bmc_y, bmc_x * 2.5, bmc_y)
	else:
		internal_tween_battle_inventory_menu(bmc_x, bmc_y, bmc_x, bmc_y + 80)

func internal_tween_battle_inventory_menu(ox, oy, nx, ny):
	var tween_inventoryMenu = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuTween
	#var bim_rect = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot.position
	#print(bim_rect)
	tween_inventoryMenu.interpolate_property($CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_inventoryMenu.start()

###
# Battle Actions Menus End
###

### 
# Battle Magic Menu Start
###

func s_hide_battle_magic_menu():
	internal_tween_battle_magic_menu(bmc_x + 11, bmc_y, bmc_x + 11, bmc_y + 80)

func s_show_battle_magic_menu():
	internal_tween_battle_magic_menu(bmc_x + 11, bmc_y + 80, bmc_x + 11, bmc_y)
	$CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleMagicMenuRoot.set_battle_magic_menu_active()

func internal_tween_battle_magic_menu(ox, oy, nx, ny):
	print("Magic Menu tween")
	var tween_magicMenu = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleMagicMenuTween
	print(tween_magicMenu)
	#var bim_rect = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot.position
	#print(bim_rect)
	tween_magicMenu.interpolate_property($CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleMagicMenuRoot, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_magicMenu.start()

### 
# Battle Magic Menu End
###

###
# Battle Equip Menu Start
###

func s_hide_battle_equip_menu():
	internal_tween_battle_equip_menu(bmc_x + 11, bmc_y, bmc_x + 11, bmc_y + 92)

func s_show_battle_equip_menu():
	internal_tween_battle_equip_menu(bmc_x + 11, bmc_y + 92, bmc_x + 11, bmc_y)
	$CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleEquipMenuRoot.set_battle_equip_menu_active()

func internal_tween_battle_equip_menu(ox, oy, nx, ny):
	print("Equip Menu tween")
	var tween_equipMenu = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleEquipMenuTween
	print(tween_equipMenu)
	#var bim_rect = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot.position
	#print(bim_rect)
	tween_equipMenu.interpolate_property($CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleEquipMenuRoot, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_equipMenu.start()

###
# Battle Equip Menu End
###

###
# Battle View Selected Actor Info Start
###

func s_hide_battle_view_selected_actor_info_menu():
	internal_tween_battle_view_selected_actor_info_menu(95, 33, 95, 33 - 220)

func s_show_battle_view_selected_actor_info_menu():
	internal_tween_battle_view_selected_actor_info_menu(95, 33 + 220, 95, 33)
	$CanvasLayerInfoControls/BattleViewSelectedActorInfoRoot.set_battle_view_selected_actor_info_menu_active()

func internal_tween_battle_view_selected_actor_info_menu(ox, oy, nx, ny):
	print("Battle View Selected Actor Info tween")
	var tween_equipMenu = $CanvasLayerInfoControls/BattleViewSelectedActorInfoTween
	print(tween_equipMenu)
	#var bim_rect = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot.position
	#print(bim_rect)
	tween_equipMenu.interpolate_property($CanvasLayerInfoControls/BattleViewSelectedActorInfoRoot, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_equipMenu.start()

###
# Battle View Selected Actor Info End
###

### Use Menu Start

func s_hide_battle_use_menu():
	internal_tween_battle_battle_use_menu(bmc_x + 11, bmc_y, bmc_x + 11, bmc_y + 92)

func s_show_battle_use_menu():
	internal_tween_battle_battle_use_menu(bmc_x + 11, bmc_y + 92, bmc_x + 11, bmc_y)
	$CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleUseMenuRoot.set_battle_use_menu_active()

func internal_tween_battle_battle_use_menu(ox, oy, nx, ny):
	print("Use Menu tween")
	var tween_useMenu = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleUseMenuTween
	print(tween_useMenu)
	#var bim_rect = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot.position
	#print(bim_rect)
	tween_useMenu.interpolate_property($CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleUseMenuRoot, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_useMenu.start()

### Use Menu End

### Use Menu Start

func s_hide_battle_drop_menu():
	internal_tween_battle_battle_drop_menu(bmc_x + 11, bmc_y, bmc_x + 11, bmc_y + 92)

func s_show_battle_drop_menu():
	internal_tween_battle_battle_drop_menu(bmc_x + 11, bmc_y + 92, bmc_x + 11, bmc_y)
	$CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleDropMenuRoot.set_battle_drop_menu_active()

func internal_tween_battle_battle_drop_menu(ox, oy, nx, ny):
	print("Use Menu tween")
	var tween_dropMenu = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleDropMenuTween
	print(tween_dropMenu)
	#var bim_rect = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot.position
	#print(bim_rect)
	tween_dropMenu.interpolate_property($CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleDropMenuRoot, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_dropMenu.start()

### Use Menu End

### Give Menu Start

func s_hide_battle_give_menu():
	internal_tween_battle_battle_give_menu(bmc_x + 11, bmc_y, bmc_x + 11, bmc_y + 92)

func s_show_battle_give_menu():
	internal_tween_battle_battle_give_menu(bmc_x + 11, bmc_y + 92, bmc_x + 11, bmc_y)
	$CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleGiveMenuRoot.set_battle_give_menu_active()

func internal_tween_battle_battle_give_menu(ox, oy, nx, ny):
	print("Use Give tween")
	var tween_giveMenu = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleGiveMenuTween
	print(tween_giveMenu)
	#var bim_rect = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot.position
	#print(bim_rect)
	tween_giveMenu.interpolate_property($CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleGiveMenuRoot, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_giveMenu.start()

### Give Menu End
