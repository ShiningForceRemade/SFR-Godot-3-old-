extends Node2D

@onready var left_wrapper = $Left
@onready var right_wrapper = $Right

@onready var left_background = $Left/Background
@onready var left_foreground = $Left/Foreground
@onready var center_background = $Center/Background
@onready var center_foreground = $Center/Foreground
@onready var right_background = $Right/Background
@onready var right_foreground = $Right/Foreground

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func hide_extra_backgrounds() -> void:
	left_wrapper.hide()
	right_wrapper.hide()


func set_foreground_frame(frame_idx: int) -> void:
	left_foreground.frame = frame_idx
	center_foreground.frame = frame_idx
	right_foreground.frame = frame_idx


func set_background_frame(frame_idx: int) -> void:
	left_background.frame = frame_idx
	center_background.frame = frame_idx
	right_background.frame = frame_idx


# TODO: LOW PRIORITY make a func that accepts a new image and a frame idx
# so other images can be pulled for backgrounds and not just whats in the background mapping

