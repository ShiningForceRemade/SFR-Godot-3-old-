extends Node

# export var battle_sub_scene_path: String = ""

# bmc - battle_menu_center_ x and y cordinates
const bmc_x: int = 171
const bmc_y: int = 182

# onready var battleAttackAnimationPlayer = $CanvasLayerInfoControls/BattleAttackAnimationPlayer
onready var landEffectPopupTween = $CanvasLayerInfoControls/LandEffectPopupTween
onready var landEffectPopupRoot = $CanvasLayerInfoControls/LandEffectPopupRoot
onready var activeActorMicroInfoTween = $CanvasLayerInfoControls/ActiveAcorMicroInfoTween
onready var activeActorMicroInfoRoot = $CanvasLayerInfoControls/ActiveActorMicroInfoRoot	
	
onready var battleActionsMenuTween = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleActionsMenuTween
onready var battleActionsMenuRoot = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleActionsMenuRoot

onready var battleInventoryMenuTween = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuTween
onready var battleInventoryMenuRoot = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot

onready var battleMagicMenuTween = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleMagicMenuTween
onready var battleMagicMenuRoot = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleMagicMenuRoot

onready var battleEquipMenuTween = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleEquipMenuTween
onready var battleEquipMenuRoot = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleEquipMenuRoot

onready var battleViewSelectedActorInfoTween = $CanvasLayerInfoControls/BattleViewSelectedActorInfoTween
onready var battleViewSelectedActorInfoRoot = $CanvasLayerInfoControls/BattleViewSelectedActorInfoRoot

onready var battleUseMenuTween = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleUseMenuTween
onready var battleUseMenuRoot = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleUseMenuRoot

onready var battleDropMenuTween = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleDropMenuTween
onready var battleDropMenuRoot = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleDropMenuRoot

onready var battleGiveMenuTween = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleGiveMenuTween
onready var battleGiveMenuRoot = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleGiveMenuRoot

onready var microActorInventoryViewTween = $CanvasLayerInfoControls/BattleMenusWrapperRoot/MicroActorInventoryViewTween
onready var microActorInventoryViewRoot = $CanvasLayerInfoControls/BattleMenusWrapperRoot/MicroActorInventoryViewRoot

onready var noValidOptionWarningBoxTween = $CanvasLayerInfoControls/BattleMenusWrapperRoot/NoValidOptionWarningBoxTween
onready var noValidOptionWarningBoxRoot = $CanvasLayerInfoControls/BattleMenusWrapperRoot/NoValidOptionWarningBoxRoot

onready var targetActorMicroInfoTween = $CanvasLayerInfoControls/TargetActorMicroInfoTween
onready var targetActorMicroInfoRoot = $CanvasLayerInfoControls/TargetActorMicroInfoRoot

onready var topLevelFader = $CanvasLayerTopLevelFader/ColorRect

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
	s_hide_micro_actor_inventory_view()
	s_hide_no_valid_option_warning_box()
	
	Singleton_Game_GlobalBattleVariables.dialogue_box_node = $CanvasLayerInfoControls/DialogueBoxRoot
	
	Singleton_Game_GlobalBattleVariables.battle_base = self
	
	topLevelFader.clear_black_fade()
	
	print("Game Version - ", ProjectSettings.get_setting("application/config/Version"))
	
	# if battle_sub_scene_path != "":
	#	change_battle_scene(battle_sub_scene_path)
	
	connect_battle_logic_to_self()


func change_battle_scene(new_scene_resource_path: String) -> void:
	var new_scene = load(new_scene_resource_path).instance();
	call_deferred("_deferred_change_scene", new_scene)

func _deferred_change_scene(new_scene) -> void:
	var BattleNodeRoot = get_node("BattleNodeRoot")
	for child in BattleNodeRoot.get_children():
		child.queue_free()
	
	BattleNodeRoot.add_child(new_scene)
	
	# connect_battle_logic_to_self()


func connect_battle_logic_to_self() -> void:
	var battleNodeRoot = get_node("BattleNodeRoot").get_child(0) # 
	
	battleNodeRoot.disconnect("signal_land_effect_under_tile", self, "s_land_effect")
	if battleNodeRoot.connect("signal_land_effect_under_tile", self, "s_land_effect") != OK:
		print("BattleBase - signal_land_effect_under_tile failed to connect")
	
	battleNodeRoot.disconnect("signal_active_character_or_enemey", self, "s_active_character_or_enemey")
	if battleNodeRoot.connect("signal_active_character_or_enemey", self, "s_active_character_or_enemey") != OK:
		print("BattleBase - signal_active_character_or_enemey failed to connect")
	
	battleNodeRoot.disconnect("signal_hide_land_effect_and_active_actor_info", self, "s_hide_land_effect_and_active_actor_info")
	if battleNodeRoot.connect("signal_hide_land_effect_and_active_actor_info", self, "s_hide_land_effect_and_active_actor_info") != OK:
		print("BattleBase - signal_hide_land_effect_and_active_actor_info failed to connect")
	
	battleNodeRoot.disconnect("signal_show_land_effect_and_active_actor_info", self, "s_show_land_effect_and_active_actor_info")
	if battleNodeRoot.connect("signal_show_land_effect_and_active_actor_info", self, "s_show_land_effect_and_active_actor_info") != OK:
		print("BattleBase - signal_show_land_effect_and_active_actor_info failed to connect")
	
	battleNodeRoot.disconnect("signal_show_character_action_menu", self, "s_show_character_action_menu")
	if battleNodeRoot.connect("signal_show_character_action_menu", self, "s_show_character_action_menu") != OK:
		print("BattleBase - signal_show_character_action_menu failed to connect")
	
	battleNodeRoot.disconnect("signal_selected_actor_underneath_cursor", self, "s_selected_actor_underneath_cursor")
	if battleNodeRoot.connect("signal_selected_actor_underneath_cursor", self, "s_selected_actor_underneath_cursor") != OK:
		print("BattleBase - signal_selected_actor_underneath_cursor failed to connect")


func s_selected_actor_underneath_cursor():
	s_show_battle_view_selected_actor_info_menu()
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
	var aair_rect = activeActorMicroInfoRoot.rect_position
	landEffectPopupTween.interpolate_property(activeActorMicroInfoRoot, "rect_position",
			aair_rect, Vector2(active_x, aair_rect.y), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	landEffectPopupTween.start()
	
	var lep_rect = landEffectPopupRoot.rect_position
	activeActorMicroInfoTween.interpolate_property(landEffectPopupRoot, "rect_position",
			lep_rect, Vector2(land_x, lep_rect.y), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	activeActorMicroInfoTween.start()

func s_hide_land_effect():
	# set_land_effect_and_active_actor_positions(500, -90)
	var aair_rect = activeActorMicroInfoRoot.rect_position
	landEffectPopupTween.interpolate_property(landEffectPopupRoot, "rect_position",
			aair_rect, Vector2(500, -90), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	landEffectPopupTween.start()

func s_show_land_effect():
	# set_land_effect_and_active_actor_positions(500, -90)
	# var aair_rect = activeActorMicroInfoRoot.rect_position
	landEffectPopupTween.interpolate_property(landEffectPopupRoot, "rect_position",
			Vector2(-66, 6), Vector2(6, 6), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	landEffectPopupTween.start()
	
# Land Effect and Active Actor Info Windows End

func force_show_land_effect():
	landEffectPopupRoot.show()
	landEffectPopupRoot.rect_position = Vector2(6, 6)

# Action Menu
# delete these three functions after checking over
# TODO: rename to follow the standard naming convention of all the other menus need to clean s_hide_action_menu used in a fair few places
# func s_show_action_menu():
# 	set_action_menu(500)

func s_hide_action_menu():
	set_action_menu(500)

func set_action_menu(xpos: int):
	var tween_actionMenu = battleActionsMenuTween
	var bam_rect = battleActionsMenuRoot.position
	tween_actionMenu.interpolate_property(battleActionsMenuRoot, "position",
			bam_rect, Vector2(xpos, bam_rect.y), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween_actionMenu.start()

func s_show_character_action_menu():
	internal_tween_move_to_position(bmc_x, bmc_y + 80, bmc_x, bmc_y, battleActionsMenuTween, battleActionsMenuRoot)
	battleActionsMenuRoot.set_menu_active()

func s_hide_character_action_menu():
	internal_tween_move_to_position(bmc_x, bmc_y, bmc_x, bmc_y + 80, battleActionsMenuTween, battleActionsMenuRoot)
	# battleActionsMenuRoot.set_menu_active()

func s_show_battle_action_menu(tween_direction):
	if tween_direction == "right":
		internal_tween_move_to_position(bmc_x * 2.5, bmc_y, bmc_x, bmc_y, battleActionsMenuTween, battleActionsMenuRoot)
	else:
		internal_tween_move_to_position(bmc_x, bmc_y, bmc_x, bmc_y + 80, battleActionsMenuTween, battleActionsMenuRoot)

###
# Battle Actions Menus Start
###

func s_show_battle_inventory_menu(tween_direction = "not_right"):
	if tween_direction == "right":
		internal_tween_move_to_position(bmc_x * 2.5, bmc_y, bmc_x, bmc_y, battleInventoryMenuTween, battleInventoryMenuRoot)
	else:
		# var tween_inventoryMenu = $CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuTween
		#var bam_rect = battleActionsMenuRoot.position
		#print(bam_rect)
		#tween_inventoryMenu.interpolate_property($CanvasLayerInfoControls/BattleMenusWrapperRoot/BattleInventoryMenuRoot, "position",
		#		Vector2(bmc_x, bmc_y), Vector2(bmc_x * 2.5, bmc_y), 0.1,
		#		Tween.TRANS_LINEAR, Tween.EASE_OUT)
		#tween_inventoryMenu.start()
		#internal_tween_battle_inventory_menu(bmc_x, bmc_y + 80, bmc_x, bmc_y)
		internal_tween_move_to_position(bmc_x, bmc_y + 80, bmc_x, bmc_y, battleInventoryMenuTween, battleInventoryMenuRoot)
		
	battleInventoryMenuRoot.set_battle_inventory_menu_active()
	
	# pass

func s_hide_battle_inventory_menu(tween_direction = "not_right"):
	if tween_direction == "right":
		internal_tween_move_to_position(bmc_x, bmc_y, bmc_x * 2.5, bmc_y, battleInventoryMenuTween, battleInventoryMenuRoot)
	else:
		internal_tween_move_to_position(bmc_x, bmc_y, bmc_x, bmc_y + 80, battleInventoryMenuTween, battleInventoryMenuRoot)


func s_hide_battle_magic_menu():
	internal_tween_move_to_position(bmc_x + 11, bmc_y, bmc_x + 11, bmc_y + 80, battleMagicMenuTween, battleMagicMenuRoot)

func s_show_battle_magic_menu():
	internal_tween_move_to_position(bmc_x + 11, bmc_y + 80, bmc_x + 11, bmc_y, battleMagicMenuTween, battleMagicMenuRoot)
	battleMagicMenuRoot.set_battle_magic_menu_active()


func s_hide_battle_equip_menu():
	internal_tween_move_to_position(bmc_x + 11, bmc_y, bmc_x + 11, bmc_y + 92, battleEquipMenuTween, battleEquipMenuRoot)

func s_show_battle_equip_menu():
	internal_tween_move_to_position(bmc_x + 11, bmc_y + 92, bmc_x + 11, bmc_y, battleEquipMenuTween, battleEquipMenuRoot)
	battleEquipMenuRoot.set_battle_equip_menu_active()


func s_hide_battle_view_selected_actor_info_menu():
	internal_tween_move_to_position(95, 33, 95, 33 - 220, battleViewSelectedActorInfoTween, battleViewSelectedActorInfoRoot)

func s_show_battle_view_selected_actor_info_menu():
	internal_tween_move_to_position(95, 33 + 220, 95, 33, battleViewSelectedActorInfoTween, battleViewSelectedActorInfoRoot)
	battleViewSelectedActorInfoRoot.set_battle_view_selected_actor_info_menu_active()


func s_hide_battle_use_menu():
	internal_tween_move_to_position(bmc_x + 11, bmc_y, bmc_x + 11, bmc_y + 92, battleUseMenuTween, battleUseMenuRoot)

func s_show_battle_use_menu():
	internal_tween_move_to_position(bmc_x + 11, bmc_y + 92, bmc_x + 11, bmc_y, battleUseMenuTween, battleUseMenuRoot)
	battleUseMenuRoot.set_battle_use_menu_active()


func s_hide_battle_drop_menu():
	internal_tween_move_to_position(bmc_x + 11, bmc_y, bmc_x + 11, bmc_y + 92, battleDropMenuTween, battleDropMenuRoot)

func s_show_battle_drop_menu():
	internal_tween_move_to_position(bmc_x + 11, bmc_y + 92, bmc_x + 11, bmc_y, battleDropMenuTween, battleDropMenuRoot)
	battleDropMenuRoot.set_battle_drop_menu_active()


func s_hide_battle_give_menu():
	internal_tween_move_to_position(bmc_x + 11, bmc_y, bmc_x + 11, bmc_y + 92, battleGiveMenuTween, battleGiveMenuRoot)

func s_show_battle_give_menu():
	internal_tween_move_to_position(bmc_x + 11, bmc_y + 92, bmc_x + 11, bmc_y, battleGiveMenuTween, battleGiveMenuRoot)
	battleGiveMenuRoot.set_battle_give_menu_active()


func s_hide_target_actor_micro():
	# if targetActorMicroInfoRoot.position != Vector2(270, 186):
	internal_tween_move_to_rect_position(270, 186, 434, 186, targetActorMicroInfoTween, targetActorMicroInfoRoot)

func s_show_target_actor_micro():
	internal_tween_move_to_rect_position(434, 186, 270, 186, targetActorMicroInfoTween, targetActorMicroInfoRoot)
	targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_selected_actor)

func s_show_target_actor_micro_in_battle():
	internal_tween_move_to_rect_position(-150, 186, 6, 186, targetActorMicroInfoTween, targetActorMicroInfoRoot)
	targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_selected_actor)

func s_hide_target_actor_micro_in_battle():
	internal_tween_move_to_rect_position(6, 186, -150, 186, targetActorMicroInfoTween, targetActorMicroInfoRoot)
	targetActorMicroInfoRoot.display_micro_info_for_actor(Singleton_Game_GlobalBattleVariables.currently_selected_actor)


func s_hide_micro_actor_inventory_view():
	internal_tween_move_to_position(370, 131, 535, 131, microActorInventoryViewTween, microActorInventoryViewRoot)
	# maybe call the microactor clean up sprites function here

func s_show_micro_actor_inventory_view():
	internal_tween_move_to_position(535, 131, 370, 131, microActorInventoryViewTween, microActorInventoryViewRoot)
	microActorInventoryViewRoot.show_selected_actor_inventory_items()


func s_hide_no_valid_option_warning_box():
	internal_tween_move_to_position(170, 100, -90, 100, noValidOptionWarningBoxTween, noValidOptionWarningBoxRoot)
	# maybe call the microactor clean up sprites function here

func s_show_no_valid_option_warning_box():
	internal_tween_move_to_position(430, 100, 170, 100, noValidOptionWarningBoxTween, noValidOptionWarningBoxRoot)
	noValidOptionWarningBoxRoot.start_self_clear_timer()


### helpers

func internal_tween_move_to_position(ox, oy, nx, ny, tweenNode, targetNode) -> void:
	print(tweenNode)
	tweenNode.interpolate_property(targetNode, "position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenNode.start()


func internal_tween_move_to_rect_position(ox, oy, nx, ny, tweenNode, targetNode) -> void:
	print(tweenNode)
	tweenNode.interpolate_property(targetNode, "rect_position",
			Vector2(ox, oy), Vector2(nx, ny), 0.1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenNode.start()
