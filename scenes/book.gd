extends Item

func name() -> String:
	return "book"

func _on_body_entered(_body: Node2D) -> void:
	Player.set_spell(Player.Spell.Fireball)
	queue_free()
