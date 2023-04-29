extends Resource

class_name CN_SF_TargetRange

var bc_cursor_ref

func _ready():
	pass

# NOTE: TODO: ?
#  Might be a good idea to have a second cursor node just always in the tree
# and modify its texture and position when targeting
# default cursor node is the single select and can handle all basic needs
# more thought needed
func draw_cursor_at_position(position_arg: Vector2):
	pass


func cleanup_cursor() -> void:
	bc_cursor_ref.queue_free()


func array_representation():
	return [
		1
	]
