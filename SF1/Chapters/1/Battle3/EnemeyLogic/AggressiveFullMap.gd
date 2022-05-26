# extends Node
extends TileMap

signal signal_logic_completed
signal signal_complete_a_path_check

var pself

func play_turn(self_arg):
	pself = self_arg
	
	print("Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number ", Singleton_Game_GlobalBattleVariables.field_logic_node.turn_number)
	
	var res = pself.is_character_actor_within_attack_range()
	if res != Vector2.ZERO:
		pself.change_facing_direction(res)
		Singleton_Game_GlobalBattleVariables.target_selection_node.setup_use_range_and_target_range_selection_enemey_static()
		Singleton_Game_GlobalBattleVariables.target_selection_node.target_range.draw_cursor_at_position(res)
		pself.internal_attack_actor_found()
		
		emit_signal("signal_logic_completed")
		pself.internal_call_complete()
		return
	
	# 204 y line
	var possible_target_array = []
	for character in Singleton_Game_GlobalBattleVariables.character_nodes.get_children():
		# if character.position.y <= 204:
			possible_target_array.append(character)
	
	print("\nPossible Target Array Start")
	for a in possible_target_array:
		print(a.name)
	print("\nPossible Target Array End")
	
	if possible_target_array.size() != 0:
		go_to_target(possible_target_array[0])
		
		for i in range(possible_target_array.size()):
			# CLEAN: TODO: REFACTOR: IMPORTANT:			
			attempt_to_find_path(possible_target_array[i])
			yield(self, "signal_complete_a_path_check")
		
			res = pself.is_character_actor_within_attack_range()
			if res != Vector2.ZERO:
				pself.change_facing_direction(res)
				Singleton_Game_GlobalBattleVariables.target_selection_node.setup_use_range_and_target_range_selection_enemey_static()
				Singleton_Game_GlobalBattleVariables.target_selection_node.target_range.draw_cursor_at_position(res)
				pself.internal_attack_actor_found()
			
				#emit_signal("signal_logic_completed")
				#pself.internal_call_complete()
				yield(Singleton_Game_GlobalBattleVariables.battle_scene_node, "signal_battle_complete_damage_step")
			
				
				yield(pself.get_tree().create_timer(0.3), "timeout")
	
				emit_signal("signal_logic_completed")
				pself.internal_call_complete()
	
				return
	
	
	yield(pself.get_tree().create_timer(0.3), "timeout")
	
	emit_signal("signal_logic_completed")
	pself.internal_call_complete()
	
	return


func go_to_target(target_node_arg):
	print(pself.position, " ", target_node_arg.position)
	
	astar_connect_walkable_cells(target_node_arg)
	# yield(self, "signal_complete_a_path_check")
	
	# if pself.position.x >= target_node_arg.position.x and pself.position.y <= target_node_arg.position.y:
		# Top Left and Left Across and Top Down
	#	pself.random_move_direction(2)
	#	yield(pself, "signal_move_direction_completed")
		
	#	pass
	
	
	pass

# onready var astar_node = AStar.new()
var astar_node
var map_size

var path_start_position
var path_end_position

var _point_path = []

const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color('#fff')

func astar_connect_walkable_cells(target_node_arg):
	astar_node = AStar.new()
	
	var mpr = Singleton_Game_GlobalBattleVariables.active_actor_move_point_representation
	var temp_point_index
	
	var actor_movement = pself.get_character_movement()
	map_size = Vector2(actor_movement * 2 + 1, actor_movement * 2 + 1)
	
	for v in mpr:
		temp_point_index = calculate_point_index(v)
		astar_node.add_point(temp_point_index, Vector3(v.x, v.y, 0))
	
	for point in mpr:
		var point_index = calculate_point_index(point)

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
			
			astar_node.connect_points(point_index, point_relative_index, false)
	pass

func attempt_to_find_path(target_node_arg):
	var sp = Singleton_Game_GlobalBattleVariables.field_logic_node.tilemap.world_to_map(pself.position)
	var ep = Singleton_Game_GlobalBattleVariables.field_logic_node.tilemap.world_to_map(target_node_arg.position)
	
	find_path(sp, ep)

func find_path(world_start, world_end):
	path_start_position = world_start
	path_end_position = world_end
	
	for p in astar_node.get_points():
		print(p)
		
	# Start self tile from active actor movement grid
	var start_point_index = calculate_point_index(path_start_position)
	
	# Since targets are obstacles in the path finding sense
	# we need to check the tiles to the left right top and bottom of the target
	# if one of those tile paths is found we have our movement path towards the target
	# otherwise we need to pick a square further away since we can't reach or attack the actor this turn
	# will expand on this AI logic later for demo naive reach and attack only
	
	var end_point_index
	
	# Target Actor Tile Above
	end_point_index = calculate_point_index(Vector2(path_end_position.x, path_end_position.y - 1))
	_point_path = astar_node.get_point_path(start_point_index, end_point_index) # astar_node.get_point_path(start_point_index, end_point_index)
	if _point_path.size() != 0:
		if not is_enemey_actor_at_end_tile(Vector2(path_end_position.x, path_end_position.y - 1)):
			print("TOP - ", _point_path)
			move_to_point_end_from_path(_point_path)
			return
	
	# Bottom
	end_point_index = calculate_point_index(Vector2(path_end_position.x, path_end_position.y + 1))
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)
	if _point_path.size() != 0:
		if not is_enemey_actor_at_end_tile(Vector2(path_end_position.x, path_end_position.y + 1)):
			print("Bottom - ", _point_path)
			move_to_point_end_from_path(_point_path)
			return
	
	# Left
	end_point_index = calculate_point_index(Vector2(path_end_position.x - 1, path_end_position.y))
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)
	if _point_path.size() != 0:
		if not is_enemey_actor_at_end_tile(Vector2(path_end_position.x - 1, path_end_position.y)):
			print("Left - ", _point_path)
			move_to_point_end_from_path(_point_path)
			return
	
	# Right
	end_point_index = calculate_point_index(Vector2(path_end_position.x + 1, path_end_position.y))
	_point_path = astar_node.get_point_path(start_point_index, end_point_index)
	if _point_path.size() != 0:
		if not is_enemey_actor_at_end_tile(Vector2(path_end_position.x + 1, path_end_position.y)):
			print("Right - ", _point_path)
			move_to_point_end_from_path(_point_path)
			return
	
	# TODO: add argument to this signal if true target was reachable and attacked
	# if false do path finding and attack second target and so on
	yield(pself.get_tree().create_timer(0.01), "timeout")
	emit_signal("signal_complete_a_path_check")
	# _draw()


func is_outside_map_bounds(point):
	return point.x < 0 or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y


func calculate_point_index(point):
	return point.x + map_size.x * point.y


func move_to_point_end_from_path(point_path_arg):
	var current_pos = path_start_position
	# Skipping first element since thats the current cell the actor is one
	for idx in range(1, point_path_arg.size()):
		if point_path_arg[idx].x < current_pos.x:
			print("move left")
			current_pos.x -= 1
			pself.random_move_direction(1)
			yield(pself, "signal_move_direction_completed")
		elif point_path_arg[idx].x > current_pos.x:
			print("move right")
			current_pos.x += 1
			pself.random_move_direction(0)
			yield(pself, "signal_move_direction_completed")
		elif point_path_arg[idx].y < current_pos.y:
			print("move top")
			current_pos.y -= 1
			pself.random_move_direction(2)
			yield(pself, "signal_move_direction_completed")
		elif point_path_arg[idx].y > current_pos.y:
			print("move bottom")
			current_pos.y += 1
			pself.random_move_direction(3)
			yield(pself, "signal_move_direction_completed")
			
	emit_signal("signal_complete_a_path_check")
	pass

func is_enemey_actor_at_end_tile(end_point) -> bool:
	var tile_point
	for enemey_actor in Singleton_Game_GlobalBattleVariables.enemey_nodes.get_children():
		tile_point = Singleton_Game_GlobalBattleVariables.field_logic_node.tilemap.world_to_map(enemey_actor.position)
		if tile_point == end_point:
			return true
			
	return false


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






