extends Spell

func spell_type() -> Spells.SpellType:
	return Spells.SpellType.Bolt
	
func base_damage() -> int:
	return 20
	
func _on_spell_hit() -> void:
	queue_free()
