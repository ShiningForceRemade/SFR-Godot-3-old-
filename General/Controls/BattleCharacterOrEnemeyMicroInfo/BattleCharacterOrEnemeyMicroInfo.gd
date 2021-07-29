extends Control

# onready var HPBar = $NinePatchRect/HPBarWrapperControl
# onready var MPBar = $NinePatchRect/MPBarWrapperControl
const max_hp_mp_bar_width_size: int = 74

# TODO: NOTE: plan for multi tierred hp and mp bars for values over 100 (??) in SF1
# divide current hp by 100
# then in an enum of lets say 10 (for 1000 hp)
# go to the index for the colour
# for the background color just use one index behind
# last one is red for the normal depleted bar would work with current setup just modifiy
# foreground and background color rect colors and done

func _ready():
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
			
	$NinePatchRect/HPBarWrapperControl/BackgroundColorRect.rect_size.x = hp_total_width
	$NinePatchRect/HPBarWrapperControl/StaticCenterWrapColorRect.rect_size.x = hp_total_width
	$NinePatchRect/HPBarWrapperControl/StaticRightEdgeColorRect.rect_position.x = hp_total_width + $NinePatchRect/HPBarWrapperControl/StaticCenterWrapColorRect.rect_position.x
	$NinePatchRect/HPBarWrapperControl/ForegroundColorRect.rect_size.x = current_hp_width

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
		
		$NinePatchRect/MPBarWrapperControl.show()
		$NinePatchRect/MPBarWrapperControl/BackgroundColorRect.rect_size.x = mp_total_width
		$NinePatchRect/MPBarWrapperControl/StaticCenterWrapColorRect.rect_size.x = mp_total_width
		$NinePatchRect/MPBarWrapperControl/StaticRightEdgeColorRect.rect_position.x = mp_total_width + $NinePatchRect/MPBarWrapperControl/StaticCenterWrapColorRect.rect_position.x
		$NinePatchRect/MPBarWrapperControl/ForegroundColorRect.rect_size.x = current_mp_width
	else:
		$NinePatchRect/MPBarWrapperControl.hide()

func update_active_info(name_arg, class_arg, level, current_hp, total_hp, current_mp, total_mp):
	print("ARHGUYIHWUIHAUIWHUDFIHWUFI")
	
	calculate_hp_or_mp_bar_width_and_set(current_hp, total_hp, current_mp, total_mp)
	
	$NinePatchRect/NameLabel.text = str(name_arg)
	
	# TODO: add option to show or hide the class
	# shinig force 1 style doesnt have this display
	# shining force 2 style has shorthand class name (ex. Swordsman is SWDM)
	if class_arg != null:
		$NinePatchRect/ClassLabel.text = str(class_arg) + " "
	else:
		$NinePatchRect/ClassLabel.text = ""
	
	# TODO: add option to show or hide the L 
	# shinig force 1 style keep the L
	# shining force 2 style drop the L
	if level != null:
		$NinePatchRect/LevelLabel.text = "L" + str(level)
	else:
		$NinePatchRect/LevelLabel.text = ""
	
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
	
	$NinePatchRect/CurrentHPLabel.text = str(current_hp) + "/" + hp_spacing + str(total_hp)
	$NinePatchRect/CurrentMPLabel.text = str(current_mp) + "/" + mp_spacing + str(total_mp)

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
