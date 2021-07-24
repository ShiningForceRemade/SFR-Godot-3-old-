extends Resource

class_name CN_SF_UseRange

var center_segment = Color("7de1e1e1")
var top_left_segment = center_segment
var top_right_segment = center_segment
var bottom_left_segment = center_segment
var bottom_right_segment = center_segment

func _ready():
	pass

func draw_use_range():
	print("Base Class")
	pass

# TODO: probably should add a helper func that just calls these two funcs together
# probably won't need this separation down the line

func get_use_range_array_representation() -> Array:
	return [[null]]
