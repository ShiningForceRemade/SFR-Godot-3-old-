extends Node2D

signal signal_selected_actor_underneath_cursor

var active: bool = false

const tile_size: int = 24
const TILE_SIZE: int = 24

onready var characters = get_parent().get_node("Characters")
onready var enemies = get_parent().get_node("Enemies")

onready var movementTween = $MovementTween
var y_tile_move = 0
var x_tile_move = 0
var tile_move_time: float = 0.1

func _ready() -> void:
	Singleton_Game_GlobalBattleVariables.cursor_root_ref = self
	hide()
	pass


func set_active() -> void:
	print("Cursor is active")
	position = Singleton_Game_GlobalBattleVariables.currently_active_character.global_position
	show()
	active = true
	Singleton_Game_GlobalBattleVariables.camera_node.playerNode = self


func _process(_delta) -> void:
	if active:
		if movementTween.is_active():
			return
		
		y_tile_move = 0
		x_tile_move = 0
		# tile_move_time = 0.1
		# TODO: test the timing a bit more 0.1 seems fine for done
		# half time tween seems too fast for sprint effect
		# if Input.is_action_pressed("ui_left_shift"):
		# 	tile_move_time = 0.075
		
		if Input.is_action_pressed("ui_right"):
			x_tile_move = TILE_SIZE
		elif Input.is_action_pressed("ui_left"):
			x_tile_move = -TILE_SIZE
			
		if Input.is_action_pressed("ui_up"):
			y_tile_move = -TILE_SIZE
		elif Input.is_action_pressed("ui_down"):
			y_tile_move = TILE_SIZE
		
		if x_tile_move != 0 || y_tile_move != 0:
				movementTween.interpolate_property(self, 'position', self.position, 
				Vector2(self.position.x + x_tile_move, self.position.y + y_tile_move), 
				tile_move_time, Tween.TRANS_LINEAR)
		
		movementTween.start()


func _input(event) -> void:
	if active:
		if event.is_action_released("ui_b_key"):
			if position == Singleton_Game_GlobalBattleVariables.currently_active_character.global_position:
				print("Same Pos")
			
				# cursor_root.position = previous_actor_pos
	
			var distance = Singleton_Game_GlobalBattleVariables.currently_active_character.global_position.distance_to(position)
			#var distance = sqrt((a.node.position.x - cursor_root.position.x) * 2 + (a.node.position.y - cursor_root.position.y) * 2)
	
			print(distance)
			# TODO: create different movement speed choices
			# also provide a fixed time choice without the distance * speed calc
			var tween_time = distance * 0.00325
			if tween_time <= 0:
				tween_time = 0
			
			movementTween.interpolate_property(self, 'position', self.position, 
			Singleton_Game_GlobalBattleVariables.currently_active_character.global_position, 
			tween_time, # 0.25,
			 Tween.TRANS_LINEAR, Tween.EASE_OUT)
			
			yield(get_tree().create_timer(tween_time + 0.05), "timeout")
			
			print("Hide")
			active = false
			hide()
			
			Singleton_Game_GlobalBattleVariables.camera_node.playerNode = Singleton_Game_GlobalBattleVariables.currently_active_character
			
			# so dirty really need to look into a proper method of handling these kinds of things soon
			yield(get_tree().create_timer(0.1), "timeout")
			
			Singleton_Game_GlobalBattleVariables.currently_active_character.get_actor_root_node_internal().active = true
		##elif event.is_action_released("ui_a_key"):
		##	print("A key")
		## a should bring up the menu
		## while c should give the land effect and character info box
		## for demo just have both go to the same place
		elif event.is_action_released("ui_c_key") || event.is_action_released("ui_a_key"):
			print("C key")
			print("position of cursor - ", position)
			
			print("\nEnemeies")
			for enemey in enemies.get_children():
				print(enemey.name)
				print(enemey.global_position)
				if position == enemey.global_position:
					print("\nFind em\n")
					active = false
					
					Singleton_Game_GlobalBattleVariables.selected_actor_type = "Enemey"
					Singleton_Game_GlobalBattleVariables.selected_actor = enemey
					
					emit_signal("signal_selected_actor_underneath_cursor")
			
			print("\nCharacters")
			for character in characters.get_children():
				#print(character.name)
				#print("Pos - ", character.position)
				#print("Kin Pos - ", character.get_character_current_pos())
				if position == character.global_position:
					#print("\nFind em\n")
					active = false
					
					Singleton_Game_GlobalBattleVariables.selected_actor_type = "Character"
					Singleton_Game_GlobalBattleVariables.selected_actor = character
					
					emit_signal("signal_selected_actor_underneath_cursor")
			
#		if event.is_action_pressed("ui_left"):
#			position.x -= tile_size
#		elif event.is_action_pressed("ui_right"):
#			position.x += tile_size
#		elif event.is_action_pressed("ui_up"):
#			position.y -= tile_size
#		elif event.is_action_pressed("ui_down"):
#			position.y += tile_size


func move_to_new_pos_battle_scene(cur_pos: Vector2, new_pos: Vector2, t = 0.75) -> void:
	movementTween.interpolate_property(self, "position",
			cur_pos, new_pos, t,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	movementTween.start()
