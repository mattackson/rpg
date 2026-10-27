extends Item

func name() -> String:
	return "book"

func _on_body_entered(_body: Node2D) -> void:
	Log.info("Item body entered by", {"node": _body})
	Players.set_player_spell(Spells.SpellType.Fireball)
	queue_free()
