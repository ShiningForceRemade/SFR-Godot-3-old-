extends Node2D

export var character_actor_animation_res: Resource
export var enemey_actor_animation_res: Resource

onready var characterSprite = $CharacterWrapper/CharacterSprite
onready var char_animationPlayer = $CharacterWrapper/AnimationPlayer

onready var enemeySprite = $EnemeyWrapper/EnemeySprite
onready var enemey_animationPlayer = $EnemeyWrapper/AnimationPlayer

const internal_animation_name: String = "A Long Random String Is this even needed"

func _ready():
	# yield(get_tree().create_timer(1), "timeout")
	
	# char actor
	internal_init_resource_for_actor(characterSprite, character_actor_animation_res)
	char_animationPlayer.add_animation(internal_animation_name, character_actor_animation_res.animation_res)
	char_animationPlayer.play(internal_animation_name)
	
	# enemey actor
	internal_init_resource_for_actor(enemeySprite, enemey_actor_animation_res)
	enemey_animationPlayer.add_animation(internal_animation_name, enemey_actor_animation_res.animation_res)
	enemey_animationPlayer.play(internal_animation_name)
	

func internal_init_resource_for_actor(actorSprite, actor_animation_res):
	actorSprite.texture = actor_animation_res.actor_animation_texture
	actorSprite.region_enabled = actor_animation_res.use_sub_area
	
	actorSprite.hframes = actor_animation_res.hframes
	actorSprite.vframes = actor_animation_res.vframes
	
	# print(actor_animation_res.use_sub_area)
	if actor_animation_res.use_sub_area:
		# print(actor_animation_res.use_sub_area)
		actorSprite.region_rect.position.x = actor_animation_res.rect_position_x_offset
		actorSprite.region_rect.position.y = actor_animation_res.rect_position_y_offset
		actorSprite.region_rect.size.x = actor_animation_res.rect_position_x_size
		actorSprite.region_rect.size.y = actor_animation_res.rect_position_y_size

func setup_enemey_actor_attacking():
	internal_init_resource_for_actor(characterSprite, character_actor_animation_res)
	
	# enemey
	internal_init_resource_for_actor(enemeySprite, enemey_actor_animation_res)
	enemey_animationPlayer.add_animation(internal_animation_name, enemey_actor_animation_res.animation_res)
	enemey_animationPlayer.play(internal_animation_name)
	# enemey_animationPlayer.remove_animation(internal_animation_name)

func setup_character_actor_attacking():
	# enemey
	internal_init_resource_for_actor(enemeySprite, enemey_actor_animation_res)
	
	# char
	internal_init_resource_for_actor(characterSprite, character_actor_animation_res)
	char_animationPlayer.add_animation(internal_animation_name, enemey_actor_animation_res.animation_res)
	char_animationPlayer.play(internal_animation_name)
	# char_animationPlayer.remove_animation(internal_animation_name)
