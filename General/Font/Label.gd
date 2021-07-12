extends Label

var bitmapFont: BitmapFont

var bitmapMenuFont: BitmapFont

func _ready():
	# one time generation needed
	# generate_menu_font()
	# generate_dialog_font()
	
	pass

func generate_dialog_font():
	bitmapFont = BitmapFont.new()
	bitmapFont.add_texture(preload("res://Assets/SF1/Font-Dialogue.png"))
	bitmapFont.height = 15

	# ord returns unicode integer value of string/single character
	
	var p = 0
	# Captial A to Z
	for i in range(65, 91):
		var c = i - 32 if i > 31 && i < 132 else 0
		print(str(i, " = ", char(i), " -> ", c))
		bitmapFont.add_char(i, 0,
		Rect2((p * 10) + 1, 0, 10, 15), 
		Vector2.ZERO, 10)
		p = p + 1
	
	# TODO: probably should add special space forward size for I J and maybe T maybe 6 instead of 10
	
	# W special sizing argh
	bitmapFont.add_char(87, 0,
		Rect2((22 * 10) + 1, 0, 13, 15), 
		Vector2.ZERO, 10)
	
	# X
	bitmapFont.add_char(88, 0,
		Rect2((23 * 10) + 1 + 2, 0, 10, 15), 
		Vector2.ZERO, 10)
	
	# Y
	bitmapFont.add_char(89, 0,
		Rect2((24 * 10) + 4, 0, 10, 15), 
		Vector2.ZERO, 10)
		
	# Z
	bitmapFont.add_char(90, 0,
		Rect2((25 * 10) + 4, 0, 10, 15), 
		Vector2.ZERO, 10)

	p = 0
	# lowercase a to z
	for i in range(97, 123):
		var c = i - 32 if i > 31 && i < 132 else 0
		print(str(i, " = ", char(i), " -> ", c))
		bitmapFont.add_char(i, 0,
		Rect2((p * 10) + 1, 16, 10, 16), 
		Vector2.ZERO, 8)
		p = p + 1
	
	# TODO: probably should add special space forward size for i j l r and maybe t maybe 6 instead of 10
	
	p = 0
	# 0 to 9
	for i in range(48, 58):
		var c = i - 32 if i > 31 && i < 132 else 0
		print(str(i, " = ", char(i), " -> ", c))
		bitmapFont.add_char(i, 0,
		Rect2((p * 10) + 1, 32, 10, 16), 
		Vector2.ZERO, 8)
		p = p + 1

	# TODO: probably should add special space forward size for 1

	# 127-131 = space also?
	# 32 = space (seems to work without issues)
	bitmapFont.add_char(32, 0, Rect2(208, 32, 16, 16), Vector2.ZERO, 8) 
	# 44 = ,
	bitmapFont.add_char(44, 0, Rect2(121, 32, 10, 16), Vector2.ZERO, 8) #4
	# 46 = .
	bitmapFont.add_char(46, 0, Rect2(131, 32, 10, 16), Vector2.ZERO, 8) #4
	# 45 = -
	bitmapFont.add_char(45, 0, Rect2(101, 32, 10, 16), Vector2.ZERO, 8)
	# 33 = !
	bitmapFont.add_char(33, 0, Rect2(151, 32, 10, 16), Vector2.ZERO, 8)#4
	# 63 = ?
	bitmapFont.add_char(63, 0, Rect2(141, 32, 10, 16), Vector2.ZERO, 8)#4
	# 35 = #
	bitmapFont.add_char(35, 0, Rect2(111, 32, 10, 16), Vector2.ZERO, 8)
	# 39 = '
	bitmapFont.add_char(39, 0, Rect2(161, 32, 10, 16), Vector2.ZERO, 8)#4
	
	# kerning pairs shorten distance
	bitmapFont.add_kerning_pair(ord("."), ord(" "), 2)
	bitmapFont.add_kerning_pair(ord("?"), ord(" "), 2)
	bitmapFont.add_kerning_pair(ord("!"), ord(" "), 2)
	bitmapFont.add_kerning_pair(ord(","), ord(" "), 4)
	
	# TODO: loop through all captial and lowercase letters to remove overly large spacing
	# bitmapFont.add_kerning_pair(ord("'"), ord("r"), 4)
	
	var resourcePath: String = "res://General/Font/FontDialogue.res"
	if(ResourceSaver.save(resourcePath, bitmapFont) == OK):
		theme = Theme.new()
		theme.default_font = bitmapFont

func generate_menu_font():
	bitmapFont = BitmapFont.new()
	bitmapFont.add_texture(preload("res://Assets/SF1/Font-Menu.png"))
	bitmapFont.height = 8

	# ord returns unicode integer value of string/single character
	
	var p = 0
	# Captial A to Z
	for i in range(65, 91):
		var c = i - 32 if i > 31 && i < 132 else 0
		print(str(i, " = ", char(i), " -> ", c))
		bitmapFont.add_char(i, 0,
		Rect2((p * 8) + 1, 2, 8, 8), 
		Vector2.ZERO, 8)
		p = p + 1

	p = 0
	# lowercase a to z
	for i in range(97, 123):
		var c = i - 32 if i > 31 && i < 132 else 0
		print(str(i, " = ", char(i), " -> ", c))
		bitmapFont.add_char(i, 0,
		Rect2((p * 8) + 1, 18, 8, 8), 
		Vector2.ZERO, 8)
		p = p + 1

	p = 0
	# 0 to 9
	for i in range(48, 58):
		var c = i - 32 if i > 31 && i < 132 else 0
		print(str(i, " = ", char(i), " -> ", c))
		bitmapFont.add_char(i, 0,
		Rect2((p * 8) + 1, 34, 8, 8), 
		Vector2.ZERO, 8)
		p = p + 1

	# 127-131 = space also?
	# 32 = space (seems to work without issues)
	bitmapFont.add_char(32, 0, Rect2(210, 2, 8, 8), Vector2.ZERO, 8) 
	# 44 = ,
	bitmapFont.add_char(44, 0, Rect2(81, 34, 8, 8), Vector2.ZERO, 8) #4
	# 46 = .
	bitmapFont.add_char(46, 0, Rect2(89, 34, 8, 8), Vector2.ZERO, 8) #4
	# 45 = -
	bitmapFont.add_char(45, 0, Rect2(98, 34, 8, 8), Vector2.ZERO, 8)
	# 33 = !
	bitmapFont.add_char(33, 0, Rect2(105, 34, 8, 8), Vector2.ZERO, 8)#4
	# 63 = ?
	bitmapFont.add_char(63, 0, Rect2(113, 34, 8, 8), Vector2.ZERO, 8)#4
	# 35 = #
	bitmapFont.add_char(35, 0, Rect2(121, 34, 8, 8), Vector2.ZERO, 8)
	# 39 = '
	bitmapFont.add_char(39, 0, Rect2(129, 34, 8, 8), Vector2.ZERO, 8)#4
	# 37 = %
	bitmapFont.add_char(37, 0, Rect2(144, 32, 8, 8), Vector2.ZERO, 8)#4
	# 47 = %
	bitmapFont.add_char(47, 0, Rect2(152, 32, 8, 8), Vector2.ZERO, 8)#4
	
	# kerning pairs shorten distance
	bitmapFont.add_kerning_pair(ord("."), ord(" "), 2)
	bitmapFont.add_kerning_pair(ord("?"), ord(" "), 2)
	bitmapFont.add_kerning_pair(ord("!"), ord(" "), 2)
	bitmapFont.add_kerning_pair(ord(","), ord(" "), 4)
	
	# TODO: loop through all captial and lowercase letters to remove overly large spacing
	# bitmapFont.add_kerning_pair(ord("'"), ord("r"), 4)
	
	var resourcePath: String = "res://General/Font/FontMenu.res"
	if(ResourceSaver.save(resourcePath, bitmapFont) == OK):
		theme = Theme.new()
		theme.default_font = bitmapFont
