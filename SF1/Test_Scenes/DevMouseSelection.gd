extends Node2D

#onready var tilemap = get_parent()
onready var tilemap = get_parent().get_node("TileMap")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(tilemap)
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				# Get which tile is under the mouse
				var mouse_pos = tilemap.get_local_mouse_position()
				var cell_pos = tilemap.world_to_map(mouse_pos)
				var tile_id = tilemap.get_cellv(cell_pos)
				
				var tile_name = tilemap.tile_set.tile_get_name(tile_id)

				print(mouse_pos)
				print(cell_pos)
				print(tile_id)
				print(tile_name)
				print(tilemap.get_cell(cell_pos.x, cell_pos.y))
				
				# Do stuff according to the above
				#if tile_name == "white":
					# For example, turn the tile into a black tile when clicked
				#	var black_tile_id = tilemap.tile_set.find_tile_by_name("black")
				#	tilemap.set_cellv(cell_pos, black_tile_id)
