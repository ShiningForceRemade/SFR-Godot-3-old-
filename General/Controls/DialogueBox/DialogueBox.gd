extends Control

signal signal_dialogue_completed

onready var dialogueRichTextLabel = $NinePatchRect/DialogueRichTextLabel
onready var dialogueTween = $DialogueTween

func _ready():
	
	self.hide()
	
	Singleton_Game_GlobalCommonVariables.dialogue_box_node = self
	
	# Singleton_Game_GlobalBattleVariables.dialogue_box_node = self
	
	dialogueTween.connect("tween_completed", self, "s_battle_message_complete")
	
	# wait till all the children are loaded and an idle frame starts maybe not the best idea????
	# yield(get_tree(), "idle_frame")
	
	# self.connect("signal_texture_action", 
	# node, 
	# "_toggle_texture_visibility")
	
	# self.connect("signal__dialogbox__finished_dialog", 
	# node, 
	# "_finished_dialog")
	
	_process_new_resource_file()
	
	pass


func battle_message_play(str_arg = "") -> void:
	dialogueTween.connect("tween_completed", self, "s_battle_message_complete")
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.rect_position = Vector2(72, 160)
	dialogueRichTextLabel.percent_visible = 0
	dialogueRichTextLabel.show()
	
	dialogueRichTextLabel.bbcode_text = str_arg
	
	dialogueTween.interpolate_property(dialogueRichTextLabel, "percent_visible",
	0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	dialogueTween.start()


func s_battle_message_complete(node_arg, property_arg) -> void: 
	# dialogueTween.connect("tween_completed", self, "s_battle_message_complete")
	# print("Tween completed ", node_arg, " ", property_arg)
	# yield(get_tree().create_timer(1.5), "timeout")
	
	# Singleton_Game_GlobalBattleVariables.dialogue_box_node.rect_position = Vector2(72, 262)
	# dialogueRichTextLabel.hide()
	
	emit_signal("signal_dialogue_completed")


func play_message(str_arg = "") -> void:
	dialogueTween.disconnect("tween_completed", self, "s_battle_message_complete")
	Singleton_Game_GlobalBattleVariables.dialogue_box_node.rect_position = Vector2(72, 160)
	dialogueRichTextLabel.percent_visible = 1
	dialogueRichTextLabel.show()
	
	dialogueRichTextLabel.bbcode_text = str_arg
	
	#dialogueTween.interpolate_property(dialogueRichTextLabel, "percent_visible",
	#0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	# dialogueTween.start()
	
	# yield(get_tree().create_timer(0.5), "timeout")
	
	
	get_tree().paused = true





signal signal__dialoguebox__finished_dialog

export(Dictionary) var ON_END_DICT = {}

export(String, FILE, '*.json') var external_file = ''
var parsed_external_file = {}

var dialogue = {}

var dialogue_index = 0
var finished = false

var dialogue_box_is_visible = true

var wait_for_user_input_end = false


func _process_new_resource_file():
	var file = File.new()
	print(external_file)
	if external_file != "":
		file.open(external_file, file.READ)
		parsed_external_file = JSON.parse(file.get_as_text())
	
		if parsed_external_file.error == OK:
			var data = parsed_external_file.result
			dialogue_index = 0
			dialogue = data.script
		else:
			print("Error: ", parsed_external_file.error)
			print("\tError Line: ", parsed_external_file.error_line)
			print("\tError String: ", parsed_external_file.error_string)
	
		file.close()
		visible = true
		dialogue_box_is_visible = visible
		Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = true
		load_dialog()
	else:
		dialogueRichTextLabel.bbcode_text = "Add script file - (file a bug report)"
		finished = true


func _process(_delta):
	if visible == false:
		# dont process dialog if the dialog is hidden
		return
		
	if (Input.is_action_just_pressed("ui_a_key") || Input.is_action_just_pressed("ui_accept")) and !wait_for_user_input_end:
		if finished:
			load_dialog()
		else:
			dialogueTween.stop(dialogueRichTextLabel, "percent_visible")
			dialogueRichTextLabel.percent_visible = 1
			finished = true
		
func _input(event):
	if(event.is_action_pressed("ui_hide")) and !wait_for_user_input_end:
		if Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active:
			visible = !dialogue_box_is_visible
			dialogue_box_is_visible = visible

func load_dialog():
	print("Here")
	if dialogue_index < dialogue.size():
		finished = false
		for key in dialogue[dialogue_index]:
			print("Inner Loop key ", key + " value is " + str(dialogue[dialogue_index][key]))
			if key == "Text":
				dialogueRichTextLabel.bbcode_text = check_and_replace_text_sub_points(dialogue[dialogue_index][key])
			elif key == "Expression":
				var expression := Expression.new()
				for command in dialogue[dialogue_index][key]:
					var command_split = command.split(" -|- ")
					#print(str(command_split))
					print(command)
					var error = expression.parse(str(command_split[1]), [])
					
					if error != OK:
						print(expression.get_error_text())
						break
					var result = expression.execute([], get_node(str(command_split[0])), true)
					if expression.has_execute_failed():
						print("Failed to execute expression", result)
					else:
						print("Success", result)
						
				dialogue_index += 1
				load_dialog()
				return
			elif key == "Sound":
				var sound_to_play = dialogue[dialogue_index][key].split(" | ")
				# sound to play 0 is type fx for sound effect and eventually music to change background music
				Singleton_Game_AudioManager.play_sfx(sound_to_play[1])
				dialogue_index += 1
				load_dialog()
				return
			elif key == "ShowPortrait":
				#var portrait_args = dialogue[dialogue_index][key].split(" | ")
				var portrait_args = dialogue[dialogue_index][key]
				print(dialogue[dialogue_index][key])
				
				# sound to play 0 is type fx for sound effect and eventually music to change background music
				var pn = get_parent().get_node("PortraitPopupRoot")
				pn.show()
				pn.load_portrait(portrait_args)
				dialogue_index += 1
				load_dialog()
				return
			elif key == "HidePortrait":
				#var portrait_args = dialogue[dialogue_index][key].split(" | ")
				
				var pn = get_parent().get_node("PortraitPopupRoot")
				pn.hide()
				
				dialogue_index += 1
				load_dialog()
				return
		
		dialogue_index += 1
		dialogueRichTextLabel.percent_visible = 0
		dialogueTween.interpolate_property(dialogueRichTextLabel, "percent_visible", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		dialogueTween.start()
	else:
		visible = false
		emit_signal("signal__dialogbox__finished_dialog")
		Singleton_Game_GlobalCommonVariables.dialogue_box_is_currently_active = false
		
		if Singleton_Game_GlobalCommonVariables.interaction_node_reference != null:
			Singleton_Game_GlobalCommonVariables.interaction_node_reference.interaction_completed()


func _on_Tween_tween_completed(object, key):
	# finished = true
	pass


func check_and_replace_text_sub_points(str_arg: String) -> String:
	var nstr = str_arg
	
	if "{main_character_name}" in nstr:
		nstr = nstr.replace("{main_character_name}", Singleton_Game_GlobalCommonVariables.main_character_player_node.get_actor_name())
	
	return nstr
