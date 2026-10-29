extends Spell

func spell_type() -> Spells.SpellType:
	return Spells.SpellType.Fireball

func base_damage() -> int:
	return 50

func _on_spell_hit() -> void:
	speed = 0
	$AnimationPlayer.play("on_spell_hit")
	await $AnimationPlayer.animation_finished
	queue_free()
