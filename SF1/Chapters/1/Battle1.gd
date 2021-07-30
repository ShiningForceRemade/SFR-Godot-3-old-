extends Node2D

var tilemap_show: bool = true

signal signal_land_effect_under_tile(land_effect)
signal signal_active_character_or_enemey(name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp)
signal signal_hide_land_effect_and_active_actor_info
signal signal_show_land_effect_and_active_actor_info

signal signal_show_character_action_menu
# signal signal_hide_character_action_menu

signal signal_selected_actor_underneath_cursor

onready var battleAttackAnimationPlayer = $BattleAttackAnimationPlayerRoot

onready var tilemap_terrian_node = $TileMapTileInformation

func _ready():
	battleAttackAnimationPlayer.hide()
	
	Singleton_Game_AudioManager.play_music_n("res://Assets/SF1/SoundBank/Battle 1 (Standard).mp3")
	
	Singleton_Game_GlobalBattleVariables.character_wrapper_node = $Characters
	Singleton_Game_GlobalBattleVariables.enemies_wrapper_node = $Enemies
	
	if $FieldLogicNode.connect("signal_land_effect_under_tile", self, "s_land_effect") != OK:
		print("Log - Error: Battle1.tscn - connect signal_land_effect_under_tile not okay")
		
	if $FieldLogicNode.connect("signal_active_character_or_enemey", self, "s_active_character_or_enemey_info") != OK:
		print("Log - Error: Battle1.tscn - connect signal_active_character_or_enemey not okay")
	
	if $FieldLogicNode.connect("signal_hide_land_effect_and_active_actor_info", self, "s_hide_land_effect_and_active_actor_info") != OK:
		print("Log - Error: Battle1.tscn - connect signal_hide_land_effect_and_active_actor_info not okay")
	if $FieldLogicNode.connect("signal_show_land_effect_and_active_actor_info", self, "s_show_land_effect_and_active_actor_info") != OK:
		print("Log - Error: Battle1.tscn - connect signal_show_land_effect_and_active_actor_info not okay")
	
	if $FieldLogicNode.connect("signal_show_character_action_menu", self, "s_show_character_action_menu") != OK:
		print("Log - Error: Battle1.tscn - connect signal_show_character_action_menu not okay")
	
	if $CursorRoot.connect("signal_selected_actor_underneath_cursor", self, "s_selected_actor_underneath_cursor") != OK:
		print("Log - Error: Battle1.tscn - connect signal_selected_actor_underneath_cursor not okay")

func s_selected_actor_underneath_cursor():
	print("Selected Actor under cursor")
	print(Singleton_Game_GlobalBattleVariables.selected_actor_type, Singleton_Game_GlobalBattleVariables.selected_actor)
	emit_signal("signal_selected_actor_underneath_cursor") 

func _input(event):
	if event.is_action_pressed("ui_hide"):
		if tilemap_show:
			$TileMapTileInformation.hide()
		else:
			$TileMapTileInformation.show()
			
		tilemap_show = !tilemap_show
	
	# if event.is_action_pressed("ui_end"):
	#	 s_hide_land_effect_and_active_actor_info()
	# elif event.is_action_pressed("ui_home"):
	#	 s_show_land_effect_and_active_actor_info()

func s_land_effect(land_effect):
	# print("Battle1 - Land effect is - ", land_effect)
	emit_signal("signal_land_effect_under_tile", land_effect)

func s_active_character_or_enemey_info(name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp):
	print("Active is - ", name)
	emit_signal("signal_active_character_or_enemey", name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp)
	
func ss_active_character_or_enemey_info(name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp):
	print("Active is - ", name)
	emit_signal("signal_active_character_or_enemey", name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp)

func s_hide_land_effect_and_active_actor_info():
	emit_signal("signal_hide_land_effect_and_active_actor_info")
	
func s_show_land_effect_and_active_actor_info():
	emit_signal("signal_show_land_effect_and_active_actor_info")

func s_show_character_action_menu():
	emit_signal("signal_show_character_action_menu")
