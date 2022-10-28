extends Node2D

var hidden: bool = false

func _ready():
	pass


func _on_Area2D_body_entered(body):
	if !hidden:
		if body == Singleton_Game_GlobalCommonVariables.main_character_active_kinematic_body_node:
			hidden = true
			self.hide()
			Singleton_Game_AudioManager.play_alt_music_n(Singleton_Dev_Internal.base_path + "Assets/SF1/SoundEffects/DoorOpened.mp3")
