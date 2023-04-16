extends Resource

class_name CN_SF1_StatGrowthCurves

func _ready():
	pass 

enum E_CURVE {
	LINEAR,
	EARLY,
	EARLY_AND_LATE,
	LATE
}

const CURVES = [
	# E_CURVE.LINEAR
	[
		Vector2(1, 0),
		Vector2(20, 100)
	],
	
	# E_CURVE.EARLY
	[
		Vector2(1, 0),
		Vector2(4, 50),
		Vector2(6, 70),
		Vector2(10, 90),
		Vector2(14, 95),
		Vector2(20, 100)
	],
	
	# E_CURVE.EARLY_AND_LATE_CURVE
	[
		Vector2(1, 0),
		Vector2(4, 30),
		Vector2(6, 40),
		Vector2(14, 60),
		Vector2(16, 70),
		Vector2(20, 100)
	],
	
	# E_CURVE.LATE
	[
		Vector2(1, 0),
		Vector2(10, 20),
		Vector2(14, 40),
		Vector2(20, 100)
	]
]
