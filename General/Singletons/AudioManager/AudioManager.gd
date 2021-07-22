extends Node

const bus = "Master"
const bus_music = "Music"
const bus_soundeffects = "FX"

const num_players_music = 2
const num_players_sound_effects = 6

var available_music_p = []  # The available players.
var queue_music_p = []  # The queue of sounds to play.

var available_sound_effects_p = []  # The available players.
var queue_sound_effects_p = []  # The queue of sounds to play.

func _ready():
	#AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_soundeffects), true)
	#AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_music), true)
	#AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), true)
	
	for i in num_players_music:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available_music_p.append(p)
		p.connect("finished", self, "_music_on_stream_finished", [p])
		p.bus = bus_music
	
	for i in num_players_sound_effects:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available_sound_effects_p.append(p)
		p.connect("finished", self, "_soundeffect_on_stream_finished", [p])
		p.bus = bus_soundeffects

func _music_on_stream_finished(stream):
	available_music_p.append(stream)
	# stream.stop()
	# print("Sound - ", available, idx)
	# available[idx].stop()
func _soundeffect_on_stream_finished(stream):
	available_sound_effects_p.append(stream)

func play_music(sound_path):
	queue_music_p.append(sound_path)

func play_sfx(sound_path):
	queue_sound_effects_p.append(sound_path)
		
func play(type, sound_path):
	if type == "music":
		queue_music_p.append(sound_path)
	elif type == "fx":
		queue_sound_effects_p.append(sound_path)

func _process(_delta):
	# Play a queued sound if any players are available.
	if not queue_music_p.empty() and not available_music_p.empty():
		available_music_p[0].stream = load(queue_music_p.pop_front())
		available_music_p[0].play()
		available_music_p.pop_front()
	
	if not queue_sound_effects_p.empty() and not available_sound_effects_p.empty():
		available_sound_effects_p[0].stream = load(queue_sound_effects_p.pop_front())
		available_sound_effects_p[0].play()
		available_sound_effects_p.pop_front()	
