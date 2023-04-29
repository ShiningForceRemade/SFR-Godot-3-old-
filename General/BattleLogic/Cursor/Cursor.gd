extends Node2D

var active: bool = false

# TODO: really need to move these constants into global common vars
const TILE_SIZE: int = 24
const HALF_TILE_SIZE: int = 12

var movementTween: Tween
var y_tile_move = 0
var x_tile_move = 0
var tile_move_time: float = 0.1
var actor_g_pos: Vector2


func _ready() -> void:
	Singleton_CommonVariables.battle__cursor_node = self
	hide()
	pass


func set_active() -> void:
	# print("Cursor is active")
	actor_g_pos = Singleton_CommonVariables.battle__currently_active_actor.get_child(0).global_position
	position = actor_g_pos
	
	show()
	active = true
	# Singleton_CommonVariables.camera_node.playerNode = self


func _process(_delta) -> void:
	if active:
		y_tile_move = 0
		x_tile_move = 0
		
		if Input.is_action_pressed("ui_right"):
			x_tile_move = TILE_SIZE
		elif Input.is_action_pressed("ui_left"):
			x_tile_move = -TILE_SIZE
		
		if Input.is_action_pressed("ui_up"):
			y_tile_move = -TILE_SIZE
		elif Input.is_action_pressed("ui_down"):
			y_tile_move = TILE_SIZE
		
		if x_tile_move != 0 || y_tile_move != 0:
			if Input.is_action_pressed("ui_left_shift"):
				await move_to_new_position(Vector2(self.position.x + x_tile_move, self.position.y + y_tile_move), 0.075)
			else:
				await move_to_new_position(Vector2(self.position.x + x_tile_move, self.position.y + y_tile_move), tile_move_time)


func _input(_event: InputEvent) -> void:
	if active:
		if Input.is_action_just_pressed("ui_b_key"):
			if position == actor_g_pos:
				# print("Same Pos")
				# Why did I have this in the godot 3 version again?
				pass
			
			var distance = actor_g_pos.distance_to(position)
			
			# TODO: create different movement speed choices
			var tween_time = distance * 0.00125
			
			await move_to_new_position(actor_g_pos, tween_time)
			await Signal(get_tree().create_timer(0.05), "timeout")
			
			active = false
			hide()
			Singleton_CommonVariables.battle__currently_active_actor.get_child(0).set_active_processing(true)
			# Singleton_CommonVariables.camera_node.playerNode = Singleton_CommonVariables.battle__currently_active_actor
		
		
		
		##elif event.is_action_released("ui_a_key"):
		##	print("A key")
		## a should bring up the menu
		## while c should give the land effect and character info box
		## for demo just have both go to the same place
		elif Input.is_action_just_pressed("ui_c_key") || Input.is_action_just_pressed("ui_a_key"):
			for enemey in Singleton_CommonVariables.battle__enemies.get_children():
				if position == enemey.get_child(0).global_position:
					active = false
					
					Singleton_CommonVariables.battle__selected_actor_type = "Enemey"
					Singleton_CommonVariables.battle__selected_actor = enemey
					
					Singleton_CommonVariables.ui__view_selected_actor_info_node.set_battle_view_selected_actor_info_menu_active()
			for character in Singleton_CommonVariables.battle__characters.get_children():
				if position == character.get_child(0).global_position:
					active = false
					
					Singleton_CommonVariables.battle__selected_actor_type = "Character"
					Singleton_CommonVariables.battle__selected_actor = character
					
					Singleton_CommonVariables.ui__view_selected_actor_info_node.set_battle_view_selected_actor_info_menu_active()

#		if event.is_action_pressed("ui_left"):
#			position.x -= tile_size
#		elif event.is_action_pressed("ui_right"):
#			position.x += tile_size
#		elif event.is_action_pressed("ui_up"):
#			position.y -= tile_size
#		elif event.is_action_pressed("ui_down"):
#			position.y += tile_size


func move_to_new_position(new_pos: Vector2, t: float = 0.025) -> void:
	movementTween = create_tween()
	movementTween.tween_property(self, "position", new_pos, t)
	movementTween.set_trans(Tween.TRANS_LINEAR)
	movementTween.set_ease(Tween.EASE_OUT)
	active = false
	await movementTween.finished
	active = true
