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
func draw_cursor_and_get_targets(_center_actor_target_selected):
	pass

# NOTE: very important to have a easy way to clean up the resources after turn ends
# TODO: free the cursor(here) and the script load new instance where these scripts are pulled from
# func cleanup
# 
