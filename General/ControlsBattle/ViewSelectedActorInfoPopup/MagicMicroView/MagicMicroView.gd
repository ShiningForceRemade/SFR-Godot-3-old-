extends Control

@onready var spellBar = preload("res://General/ControlsBattle/ViewSelectedActorInfoPopup/MagicMicroView/SpellLevelBar.tscn")

@onready var magic_texture_rect: TextureRect = $MagicTextureRect
@onready var name_label: Label = $Label
@onready var hbox: HBoxContainer = $HBoxContainer


func _ready() -> void:
	pass


func init_spell_micro_info(spell_obj) -> void:
	name_label.text = spell_obj.name
	magic_texture_rect.texture = spell_obj.spell_texture
	
	var spell_levels_size = spell_obj.levels.size()
	if spell_levels_size == 0:
		hbox.hide()
	else:
		hbox.show()
		for _throw_away in range(spell_levels_size):
			var sbn = spellBar.instantiate()
			hbox.add_child(sbn)
