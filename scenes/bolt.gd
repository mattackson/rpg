extends Spell

func spell_type() -> Spells.SpellType:
	return Spells.SpellType.Bolt
	
func base_damage() -> int:
	return 20
