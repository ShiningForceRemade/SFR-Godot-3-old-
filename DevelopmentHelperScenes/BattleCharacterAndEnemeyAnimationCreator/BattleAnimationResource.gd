extends Resource

class_name CN_SF_AnimationResource

export var actor_animation_texture: Texture

export var hframes: int = 1
export var vframes: int = 1

export var use_sub_area: bool

export var rect_position_x_offset: int
export var rect_position_y_offset: int
export var rect_position_x_size: int
export var rect_position_y_size: int

# TODO: make this an array and have a way to tie default animations back to it
# probably better and more flexible than pre setting the animations 
# leave for demo to be reworked
export var animation_res: Animation

export var animation_res_idle: Animation
export var animation_res_attack: Animation

func _ready():
	pass
