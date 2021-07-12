extends Control

func _ready():
	pass
	
func init_spell_micro_info(spell_obj):
	$SpellNameLabel.text = spell_obj.name
	$SpellTextureRect.texture = spell_obj.spell_texture
	
	var spell_levels_size = spell_obj.levels.size()
	if spell_levels_size == 0:
		$HBoxContainer.hide()
	else:
		$HBoxContainer.show()
		var spellBarNode = load("res://General/BattleViewSelectedActorInfo/Spell/SpellLevelBar.tscn")
		
		for n in range(spell_levels_size):
			var sbn = spellBarNode.instance()
			$HBoxContainer.add_child(sbn)
