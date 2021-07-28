# extends Node
extends TileMap

signal signal_logic_completed

var pself

func play_turn(self_arg):
	pself = self_arg
	
	print("Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number ", Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number)
	
	####
	
	var res = pself.is_character_actor_within_attack_range()
	if res != Vector2.ZERO:
		Singleton_Game_GlobalBattleVariables.target_selection_node.setup_use_range_and_target_range_selection_enemey_static()
		Singleton_Game_GlobalBattleVariables.target_selection_node.target_range.draw_cursor_at_position(res)
		pself.internal_attack_actor_found()
			
		emit_signal("signal_logic_completed")
		pself.internal_call_complete()
	
	# 204 y line
	var possible_target_array = []
	for character in Singleton_Game_GlobalBattleVariables.character_nodes.get_children():
		if character.position.y <= 204:
			possible_target_array.append(character)
	
	print("\nPossible Target Array Start")
	for a in possible_target_array:
		print(a.name)
	print("\nPossible Target Array End")
	
	if possible_target_array[0] != null:
		go_to_target(possible_target_array[0])
		
	
	# yield(pself.get_tree().create_timer(0.3), "timeout")
	yield(pself.get_tree().create_timer(10.3), "timeout")
	
	emit_signal("signal_logic_completed")
	pself.internal_call_complete()
	
	return
	#####
	
#	if Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number == 1:
#		for _i in range(4):
#			pself.random_move_direction(2)
#			yield(pself, "signal_move_direction_completed")
#
#		pself.animationPlayer.play("DownMovement")
#
#		emit_signal("signal_logic_completed")
#		pself.internal_call_complete()
#	else:
#		# yield(pself.get_tree().create_timer(0.1), "timeout")
#
#		var res = pself.is_character_actor_within_attack_range()
#		if res != Vector2.ZERO:
#			Singleton_Game_GlobalBattleVariables.target_selection_node.setup_use_range_and_target_range_selection_enemey_static()
#			Singleton_Game_GlobalBattleVariables.target_selection_node.target_range.draw_cursor_at_position(res)
#			pself.internal_attack_actor_found()
#
#			emit_signal("signal_logic_completed")
#			pself.internal_call_complete()
#		else:
#
#			yield(pself.get_tree().create_timer(0.3), "timeout")
#			pself.internal_call_complete()
	
	# yield(pself.get_tree().create_timer(0.3), "timeout")
	# pself.internal_call_complete()



func go_to_target(target_node_arg):
	print(pself.position, " ", target_node_arg.position)
	
	astar_connect_walkable_cells()
	
	if pself.position.x >= target_node_arg.position.x and pself.position.y <= target_node_arg.position.y:
		# Top Left and Left Across and Top Down
		pself.random_move_direction(2)
		yield(pself, "signal_move_direction_completed")
		
		pass
	
	
	pass

# onready var astar_node = AStar.new()
var astar_node
var map_size

var path_start_position = Vector2(8, 8) #  = Vector2(8* 24, 8 * 24) # world_to_map(Vector2(8, 8))
var path_end_position = Vector2(6, 8) # = Vector2(6 * 24, 8 * 24) # world_to_map(Vector2(6, 8))

var _point_path = []

const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color('#fff')


	
# Singleton_Game_GlobalBattleVariables.active_actor_move_point_representation

func astar_connect_walkable_cells(): # (points_array):
	astar_node = AStar.new()
	
	var mpr = Singleton_Game_GlobalBattleVariables.active_actor_move_point_representation
	var temp_point_index
	
	map_size = Vector2(13, 13) # vpos from gen move array
	
	for v in mpr:
		temp_point_index = calculate_point_index(v)
		astar_node.add_point(temp_point_index, Vector3(v.x, v.y, 0))
	
	for point in mpr: # points_array
		var point_index = calculate_point_index(point)
		# For every cell in the map, we check the one to the top, right.
		# left and bottom of it. If it's in the map and not an obstalce,
		# We connect the current point with it
		var points_relative = PoolVector2Array([
			Vector2(point.x + 1, point.y),
			Vector2(point.x - 1, point.y),
			Vector2(point.x, point.y + 1),
			Vector2(point.x, point.y - 1)])
		for point_relative in points_relative:
			var point_relative_index = calculate_point_index(point_relative)

			if is_outside_map_bounds(point_relative):
				continue
			if not astar_node.has_point(point_relative_index):
				continue
			# Note the 3rd argument. It tells the astar_node that we want the
			# connection to be bilateral: from point A to B and B to A
			# If you set this value to false, it becomes a one-way path
			# As we loop through all points we can set it to false
			astar_node.connect_points(point_index, point_relative_index, false)
	
	find_path(0, 0)
	
	pass


func find_path(world_start, world_end):
	# path_start_position = Vector2(path_start_position.x, path_start_position.y)# world_to_map(Vector2(8, 8))
	# path_end_position = Vector2(path_end_position.x, path_end_position.y)# path_end_position # world_to_map(Vector2(6, 8))
	_recalculate_path()

func _recalculate_path():
	# clear_previous_path_drawing()
	var start_point_index = calculate_point_index(path_start_position) # / 24 # TileSize
	var end_point_index = calculate_point_index(path_end_position) # / 24
	# This method gives us an array of points. Note you need the start and end
	# points' indices as input
	
	for p in astar_node.get_points():
		print(p)
	# for a in astar_node.
	
	
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)
	#astar_node.get_point_path(72, 70) #
	 
	# Redraw the lines and circles from the start to the end point
	_draw()


func clear_previous_path_drawing():
	if not _point_path:
		return
	var point_start = _point_path[0]
	var point_end = _point_path[len(_point_path) - 1]
	# set_cell(point_start.x, point_start.y, -1)
	# set_cell(point_end.x, point_end.y, -1)


func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y


func calculate_point_index(point):
	return point.x + map_size.x * point.y


func _draw():
	if not _point_path:
		return
	var point_start = _point_path[0]
	var point_end = _point_path[len(_point_path) - 1]

	var v = Vector2(point_start.x, point_start.y)
	var last_point = v + Vector2(12, 12)
	for index in range(1, len(_point_path)):
		v = Vector2(_point_path[index].x, _point_path[index].y)
		var current_point = v + Vector2(12, 12)
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		draw_circle(current_point, BASE_LINE_WIDTH * 2.0, DRAW_COLOR)
		last_point = current_point
		
	yield(pself, "freeze")
	
	pass
