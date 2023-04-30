extends Node2D

# TODO: figure out how to compress these two microinfoboxes into 1 and just instnace 2 unique copies
# no difference in scripts except for the global ui actor box set

const max_hp_mp_bar_width_size: int = 74
var _tween: Tween

@onready var name_label: Label = $NinePatchRect/NameLabel
@onready var class_label: Label = $NinePatchRect/ClassLabel
@onready var level_label: Label = $NinePatchRect/LevelLabel
@onready var current_hp_label: Label = $NinePatchRect/CurrentHPLabel
@onready var current_mp_label: Label = $NinePatchRect/CurrentMPLabel

@onready var hp_background_color_rect: ColorRect = $NinePatchRect/HPBarWrapperControl/BackgroundColorRect
@onready var hp_foreground_color_rect: ColorRect = $NinePatchRect/HPBarWrapperControl/ForegroundColorRect
@onready var hp_center_color_rect: ColorRect = $NinePatchRect/HPBarWrapperControl/StaticCenterWrapColorRect
@onready var hp_right_color_rect: ColorRect = $NinePatchRect/HPBarWrapperControl/StaticRightEdgeColorRect

@onready var mp_bar: Control = $NinePatchRect/MPBarWrapperControl
@onready var mp_background_color_rect: ColorRect = $NinePatchRect/MPBarWrapperControl/BackgroundColorRect
@onready var mp_foreground_color_rect: ColorRect = $NinePatchRect/MPBarWrapperControl/ForegroundColorRect
@onready var mp_center_color_rect: ColorRect = $NinePatchRect/MPBarWrapperControl/StaticCenterWrapColorRect
@onready var mp_right_color_rect: ColorRect = $NinePatchRect/MPBarWrapperControl/StaticRightEdgeColorRect

# actor box pos
const actor_top_right_pos: Vector2 = Vector2(200, 8)
# target actor pos for selections and battle
const target_actor_bottom_left_pos: Vector2 = Vector2(8, 134)
const target_actor_bottom_right_pos: Vector2 = Vector2(200, 134)

# TODO: NOTE: plan for multi tierred hp and mp bars for values over 100 (??) in SF1
# divide current hp by 100
# then in an enum of lets say 10 (for 1000 hp)
# go to the index for the colour
# for the background color just use one index behind
# last one is red for the normal depleted bar would work with current setup just modifiy
# foreground and background color rect colors and done


func _ready():
	Singleton_CommonVariables.ui__target_actor_micro_info_box = self
	calculate_hp_or_mp_bar_width_and_set(8, 12, 8, 8)
	pass

func calculate_hp_or_mp_bar_width_and_set(current_hp, total_hp, current_mp, total_mp):
	# [62 * 1.2] = 74 max pixel width of bars for right now

	print(current_hp, " ", total_hp, " ", current_mp, " ",  total_mp)

	# total_hp * 1.2
	var hp_total_width = int(total_hp * 1.2)
	if hp_total_width > max_hp_mp_bar_width_size:
		hp_total_width = max_hp_mp_bar_width_size
	elif hp_total_width < 0:
		hp_total_width = 0
	# current_hp * 1.2 scale yellow bar as well
	var current_hp_width = int(current_hp * 1.2)
	if current_hp_width > max_hp_mp_bar_width_size:
		current_hp_width = max_hp_mp_bar_width_size
	elif current_hp_width < 0:
		current_hp_width = 0

	hp_background_color_rect.size.x = hp_total_width
	hp_center_color_rect.size.x = hp_total_width
	hp_right_color_rect.position.x = hp_total_width + hp_center_color_rect.position.x
	hp_foreground_color_rect.size.x = current_hp_width

	if total_mp != 0:
		var mp_total_width = int(total_mp * 1.2)
		if mp_total_width > max_hp_mp_bar_width_size:
			mp_total_width = max_hp_mp_bar_width_size
		elif mp_total_width < 0:
			mp_total_width = 0
		# current_hp * 1.2 scale yellow bar as well
		var current_mp_width = int(current_mp * 1.2)
		if current_mp_width > max_hp_mp_bar_width_size:
			current_mp_width = max_hp_mp_bar_width_size
		elif current_mp_width < 0:
			current_mp_width = 0

		mp_bar.show()
		mp_background_color_rect.size.x = mp_total_width
		mp_center_color_rect.size.x = mp_total_width
		mp_right_color_rect.position.x = mp_total_width + mp_center_color_rect.position.x
		mp_foreground_color_rect.size.x = current_mp_width
	else:
		mp_bar.hide()

func update_active_info(name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp):
	print("ARHGUYIHWUIHAUIWHUDFIHWUFI")

	calculate_hp_or_mp_bar_width_and_set(current_hp, total_hp, current_mp, total_mp)

	name_label.text = str(name_arg)

	# TODO: add option to show or hide the class
	# shinig force 1 style doesnt have this display
	# shining force 2 style has shorthand class name (ex. Swordsman is SWDM)
	if class_arg != null:
		class_label.text = str(class_arg) + " "
	else:
		class_label.text = ""

	# TODO: add option to show or hide the L 
	# shinig force 1 style keep the L
	# shining force 2 style drop the L
	if level != null:
		level_label.text = "L" + str(level)
	else:
		level_label.text = ""

	var total_HP_len = str(total_hp).length()
	var total_MP_len = str(total_mp).length()
	# var spacing = 0
	var hp_spacing = ""
	var mp_spacing = ""

	if total_HP_len == total_MP_len:
		pass
	elif total_HP_len > total_MP_len:
		for n in (total_HP_len -1):
			mp_spacing += " "
	else:
		for n in (total_MP_len -1):
			hp_spacing += " "

	current_hp_label.text = str(current_hp) + "/" + hp_spacing + str(total_hp)
	current_mp_label.text = str(current_mp) + "/" + mp_spacing + str(total_mp)

func display_micro_info_for_actor(node_arg) -> void:
	# TODO: simply this charcter and enemey are so much closer now in logic
	# the distinctions seem larger unneeded now
	# probably should add a get actor type which can return character or enemey
	# and have that as check for AI related resources but otherwise should handle them largely the same
	var wr = weakref(node_arg)
	if (!wr.get_ref()):
		return

	var actor_root = node_arg.get_child(0) # node_arg.get_node("CharacterRoot")

	print(actor_root)

	if actor_root.name == "CharacterRoot":
		update_active_info(actor_root.character_name, 
		actor_root.cget_class(), 
		actor_root.level, 
		actor_root.HP_Current, 
		actor_root.HP_Total, 
		actor_root.MP_Current, 
		actor_root.MP_Total)
	elif actor_root.name == "EnemeyRoot":
		update_active_info(actor_root.enemey_name, 

		"", # actor_root.monster_class, 
		null, # actor_root.effective_level, 

		actor_root.HP_Current, 
		actor_root.HP_Total, 
		actor_root.MP_Current, 
		actor_root.MP_Total)


func display_actor_info(node_arg) -> void:
#	var wr = weakref(node_arg)
#	if (!wr.get_ref()):
#		return

	var actor_root = node_arg.get_child(0).actor

	print(node_arg)

	if actor_root.name == "CharacterRoot":
		update_active_info(
			actor_root.get_actor_name(), 
			actor_root.get_class_short(),
			actor_root.get_level(), 
			actor_root.get_hp_current(), 
			actor_root.get_hp_total(), 
			actor_root.get_mp_current(),
			actor_root.get_mp_total()
		)
	elif actor_root.name == "EnemeyRoot":
		update_active_info(actor_root.enemey_name, 

		"", # actor_root.monster_class, 
		null, # actor_root.effective_level, 

		actor_root.HP_Current, 
		actor_root.HP_Total, 
		actor_root.MP_Current, 
		actor_root.MP_Total)
	
	pass

## Show Hide Cust with tween

const default_position: Vector2 = Vector2(200, 8)
const hidden_position: Vector2 = Vector2(320, 8)

func show_cust() -> void: 
	position = hidden_position
	show()
	
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", default_position, Singleton_CommonVariables.menu_tween_time)
	_tween.set_trans(Tween.TRANS_LINEAR)


func hide_cust() -> void: 
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", hidden_position, Singleton_CommonVariables.menu_tween_time)
	_tween.set_trans(Tween.TRANS_LINEAR)
	_tween.tween_callback(hide)


# const hidden_target_position: Vector2 = Vector2(320, 134)
# const target_actor_bottom_left_pos: Vector2 = Vector2(8, 134)
# const target_actor_bottom_right_pos: Vector2 = Vector2(200, 134)

func show_cust_target() -> void: 
	position = Vector2(320, 134) # hidden_position
	show()
	
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", target_actor_bottom_right_pos, Singleton_CommonVariables.menu_tween_time)
	_tween.set_trans(Tween.TRANS_LINEAR)


func hide_cust_target() -> void: 
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", Vector2(320, 134), Singleton_CommonVariables.menu_tween_time)
	_tween.set_trans(Tween.TRANS_LINEAR)
	_tween.tween_callback(hide)


const hidden_target_battle_scene = Vector2(-120, 134)
const target_battle_scene = Vector2(8, 134)

func show_cust_target_battle_scene() -> void: 
	position = hidden_target_battle_scene
	show()
	
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", target_battle_scene, Singleton_CommonVariables.menu_tween_time)
	_tween.set_trans(Tween.TRANS_LINEAR)

func hide_cust_target_battle_scene() -> void: 
	if _tween:
		_tween.kill()
	
	_tween = get_tree().create_tween()
	_tween.tween_property(self, "position", hidden_target_battle_scene, Singleton_CommonVariables.menu_tween_time)
	_tween.set_trans(Tween.TRANS_LINEAR)
	_tween.tween_callback(hide)
