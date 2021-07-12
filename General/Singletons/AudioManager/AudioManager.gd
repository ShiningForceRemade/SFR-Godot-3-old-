extends Node

var num_players = 8
var bus = "master"

var available = []  # The available players.
var available_played = []  # The available players.
var queue = []  # The queue of sounds to play.

func _ready():
	# Create the pool of AudioStreamPlayer nodes.

	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p], i)
		p.bus = bus

func _on_stream_finished(stream):#, idx):
	# When finished playing a stream, make the player available again.
	# stream.stop()
	#print("Sound - ", available, idx)
	#available[idx].stop()
	available.append(stream)

func play(sound_path):
	queue.append(sound_path)

func _process(_delta):
	# Play a queued sound if any players are available.

	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
