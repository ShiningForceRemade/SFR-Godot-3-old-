extends ColorRect

@onready var fadeTween = create_tween() # get_parent().get_node("Tween")

func _ready():
	self.modulate = Color(0, 0, 0, 0)
	pass

func dim_screen() -> void:
	modulate.a = 0.3
	# color = Color(0, 0, 0, 1)
	# modulate = Color(0, 0, 0, 255)
	pass

func clear_black_fade() -> void:
	# modulate = Color(255, 255, 255, 0)
	modulate = Color(0, 0, 0, 0)


func black_fade_anim_in() -> void:
	fadeTween.interpolate_property(self, "modulate:a",
	0.0, 1.0, 
	0.325, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	fadeTween.start()


func black_fade_anim_out() -> void:
	# print("hey")
	
	# self.modulate = Color(0, 0, 0, 255)
	
	fadeTween.interpolate_property(self, "modulate:a",
	1.0, 0.0, 
	0.325, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	fadeTween.start()


func black_fade_anim_in_out() -> void:
	black_fade_anim_in()
	# await self.signal_black_fade_in_out_completed
	black_fade_anim_out()
	pass


func s_cleanup_black_fade_tween() -> void:
	emit_signal("signal_black_fade_in_out_completed")
