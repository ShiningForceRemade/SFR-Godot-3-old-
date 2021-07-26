extends Resource

class_name CN_SF_AnimationSpellResource

export var primary_animation_texture: Texture
export var particle_animation_texture: Texture

export var hframes: int = 1
export var vframes: int = 1

export var use_sub_area: bool = false

export var rect_position_x_offset: int = 0
export var rect_position_y_offset: int = 0
export var rect_position_x_size: int = 0
export var rect_position_y_size: int = 0

# TODO: maybe set this up as an array based tied to level
# 0 index is level 1 animation etc
export var animation_res: Animation

func _ready():
	pass
