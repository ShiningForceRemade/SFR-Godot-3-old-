extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.hide()
	
	pass # Replace with function body.


func load_portrait(portrait_resource_path: String) -> void:
	print("here ----", portrait_resource_path)
	get_node("PortraitTextureRect").texture = load(portrait_resource_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
