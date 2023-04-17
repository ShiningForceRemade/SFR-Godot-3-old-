extends Node2D

var self_hidden: bool = false


func _ready():
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !self_hidden:
		print(body, Singleton_CommonVariables.main_character_active_kinematic_body_node)
		if body == Singleton_CommonVariables.main_character_active_kinematic_body_node:
			self_hidden = true
			self.hide()
			Singleton_AudioManager.play_alt_music_n(Singleton_DevToolingManager.base_path + "Assets/SF1/SoundEffects/DoorOpened.mp3")
