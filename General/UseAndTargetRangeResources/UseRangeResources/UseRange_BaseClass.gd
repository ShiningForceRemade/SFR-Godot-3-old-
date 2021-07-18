extends Resource

class_name CN_SF_UseRange

func _ready():
	pass

static func draw_use_range():
	print("Base Class")
	pass

# TODO: probably should add a helper func that just calls these two funcs together
# probably won't need this separation down the line

func get_use_range_array_representation() -> Array:
	return [[null]]
