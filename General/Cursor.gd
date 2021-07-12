extends Node2D

signal signal_selected_actor_underneath_cursor

var active: bool = false

const tile_size: int = 24

onready var characters = get_parent().get_node("Characters")
onready var enemies = get_parent().get_node("Enemies")

func _ready():
	Singleton_Game_GlobalBattleVariables.cursor_root_ref = self
	hide()
	pass

func set_active():
	print("Cursor is active")
	position = Singleton_Game_GlobalBattleVariables.currently_active_character.position
	show()
	active = true
	
func _input(event):
	if active:
		if event.is_action_released("ui_b_key"):
			print("Hide")
			active = false
			hide()
			
			# so dirty really need to look into a proper method of handling these kinds of things soon
			yield(get_tree().create_timer(0.1), "timeout")
			
			Singleton_Game_GlobalBattleVariables.currently_active_character.get_node("CharacterRoot").active = true
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
				print(enemey.position)
				if position == enemey.position:
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
				if position == character.position:
					#print("\nFind em\n")
					active = false
					
					Singleton_Game_GlobalBattleVariables.selected_actor_type = "Character"
					Singleton_Game_GlobalBattleVariables.selected_actor = character
					
					emit_signal("signal_selected_actor_underneath_cursor")
			
		
		if event.is_action_pressed("ui_left"):
			position.x -= tile_size
		elif event.is_action_pressed("ui_right"):
			position.x += tile_size
		elif event.is_action_pressed("ui_up"):
			position.y -= tile_size
		elif event.is_action_pressed("ui_down"):
			position.y += tile_size
