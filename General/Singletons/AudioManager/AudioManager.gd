extends Node

signal signal__audio_manager__soundeffect__finished

const bus = "Master"
const bus_music = "Music"
const bus_alt_music = "Alt_Music"
const bus_soundeffects = "FX"
const bus_dialogue_sfx = "Dialogue_SFX"

const num_players_music = 1
const num_players_alt_music = 1
const num_players_sound_effects = 6

var available_music_p = []  # The available players.
var queue_music_p = []  # The queue of sounds to play.

var available_alt_music_p = []  # The available players.
var queue_alt_music_p = []  # The queue of sounds to play.

var available_sound_effects_p = []  # The available players.
var queue_sound_effects_p = []  # The queue of sounds to play.

var dialogue_playing: bool = false
var dialoguePlayer: AudioStreamPlayer

func _ready():
	#AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_soundeffects), true)
	#AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_music), true)
	#AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), true)
	
# Re-enable this for dialgoue sound-effects P1
#	dialoguePlayer = AudioStreamPlayer.new() 
#	dialoguePlayer.connect("finished", self, "_dialogue_on_sfx_finished", [dialoguePlayer])
#	dialoguePlayer.stream = load("res://Assets/SF2/Sounds/SFX/sfx_Dialogue_03.wav")
#	dialoguePlayer.bus = bus_dialogue_sfx
#	add_child(dialoguePlayer)
	
	for i in num_players_music:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available_music_p.append(p)
		p.connect("finished", self, "_music_on_stream_finished", [p])
		p.bus = bus_music
	
	for i in num_players_alt_music:
		var p = AudioStreamPlayer.new()
		
		p.connect("finished", self, "_music_on_stream_finished", [p])
		p.bus = bus_alt_music
		add_child(p)
		available_alt_music_p.append(p)
	
	for i in num_players_sound_effects:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available_sound_effects_p.append(p)
		p.connect("finished", self, "_soundeffect_on_stream_finished", [p])
		p.bus = bus_soundeffects


func _music_on_stream_finished(stream) -> void:
	available_music_p.append(stream)
	# stream.stop()
	# print("Sound - ", available, idx)
	# available[idx].stop()
func _soundeffect_on_stream_finished(stream) -> void:
	available_sound_effects_p.append(stream)
	emit_signal("signal__audio_manager__soundeffect__finished")

func _dialogue_on_sfx_finished(stream) -> void:
	if dialogue_playing:
		dialoguePlayer.play()
		# emit_signal("signal__audio_manager__soundeffect__finished")
	
	pass

# Re-enable this for dialgoue sound-effects P2
func play_dialogue_sfx() -> void:
#	dialoguePlayer.play()
#	dialogue_playing = true
	pass

func stop_dialogue_sfx() -> void:
#	dialoguePlayer.stop()
#	dialogue_playing = false
	pass


func play_music(sound_path) -> void:
	queue_music_p.append(sound_path)


func pause_all_music() -> void:
	#f not queue_music_p.empty() and not available_music_p.empty():
	for a_m_p in available_music_p:
		a_m_p.stop()


func resume_all_music() -> void:
	#f not queue_music_p.empty() and not available_music_p.empty():
	for a_m_p in available_music_p:
		a_m_p.play()

func play_music_n(sound_path) -> void:
	# NOTE: Probably good idea to use runtime format always to avoid discrepencies between development and release builds
	# if Singleton_Dev_Internal.is_debug_build:
	#	# available_alt_music_p[0].stream = load(sound_path)
	var r_stream = get_runtime_audio_file_data_for_stream(sound_path)
	if r_stream != null:
		available_music_p[0].stream = r_stream
		available_music_p[0].play()


func stop_music_n() -> void:
	available_music_p[0].stop()


func play_alt_music_n(sound_path) -> void:
	# NOTE: Probably good idea to use runtime format always to avoid discrepencies between development and release builds
	# if Singleton_Dev_Internal.is_debug_build:
	#	# available_alt_music_p[0].stream = load(sound_path)
	var r_stream = get_runtime_audio_file_data_for_stream(sound_path)
	if r_stream != null:
		available_alt_music_p[0].stream = r_stream
		available_alt_music_p[0].play()

func stop_alt_music_n() -> void:
	available_alt_music_p[0].stop()


func get_runtime_audio_file_data_for_stream(audio_file):
	var file = File.new()
	if file.file_exists(audio_file):
		var stream
		file.open(audio_file, file.READ)
		var buffer = file.get_buffer(file.get_len())
		stream = AudioStreamMP3.new()
		
		# IMPORTANT: NOTE:
		# Wav file support needs to be tested if wav files are ever loaded dynamically at runtime
		# stream = AudioStreamSample.new()
		# stream.format = AudioStreamSample.FORMAT_16_BITS
		# stream.stereo = true
		
		stream.data = buffer
		file.close()
		return stream
	else:
		return null


# When sfx files are fixed and post processed probably should use dynamic import as well
func play_sfx(sound_path) -> void:
	queue_sound_effects_p.append(sound_path)


func pause_all_sfx() -> void:
	if not queue_sound_effects_p.empty() and not available_sound_effects_p.empty():
		for a_s_e_p in available_sound_effects_p:
			a_s_e_p.stop()


func play(type, sound_path) -> void:
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
