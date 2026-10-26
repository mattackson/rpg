extends Node

signal player_died();

enum Spell {Bolt = 0, Fireball = 1}

var bolt_texture = preload("res://assets/export/bolt-icon.png")
var fireball_texture = preload("res://assets/export/fireball-icon.png")
var spells: Dictionary[Spell, Variant] = {
	Spell.Bolt: bolt_texture,
	Spell.Fireball: fireball_texture
}

var _player_health = 100;
var _spell: Spell = Spell.Bolt;

func remove_player_health(val: int) -> void:
	_player_health -= val
	if _player_health <= 0:
		player_died.emit()
	
func set_spell(val: Spell) -> void:
	_spell = val

func get_spell() -> Spell:
	return _spell
