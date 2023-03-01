extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var img = get_viewport().get_texture().get_data()
		
	await get_tree().idle_frame
	await get_tree().idle_frame
		
	img.flip_y()
	
	texture = img;
	
	pass
