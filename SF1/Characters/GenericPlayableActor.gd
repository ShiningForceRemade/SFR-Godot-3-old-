extends Node

signal signal_completed_turn

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func play_turn() -> void:
	pass


func end_turn() -> void:
	emit_signal("signal_completed_turn")
