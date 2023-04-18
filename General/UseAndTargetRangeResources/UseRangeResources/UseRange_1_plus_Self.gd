extends CN_SF_UseRange

func _ready():
	pass


func draw_use_range() -> void:
	draw_use_range_tiles(get_use_range_array_representation())


func get_use_range_array_representation() -> Array:
	return [
		[null,    1, null],
		[1,       1,    1],
		[null,    1, null],
	]
