extends Node

signal player_died();
signal player_spell_changed(new_spell: Spell);

enum Spell {Bolt = 0, Fireball = 1}

const SAVE_PATH: String = "player"

var bolt_texture = preload("res://assets/export/bolt-icon.png")
var fireball_texture = preload("res://assets/export/fireball-icon.png")
var spells: Dictionary[Spell, Variant] = {
	Spell.Bolt: bolt_texture,
	Spell.Fireball: fireball_texture
}

var _player: CharacterBody2D = null;
var _player_health: int = 100;
var _spell: Spell = Spell.Bolt;
	
func get_player_position() -> Vector2:
	return _player.position

func register_player(player: CharacterBody2D, data: Dictionary) -> void:
	_player = player
	_load(data)
	
func remove_player_health(val: int) -> void:
	_player_health -= val
	if _player_health <= 0:
		player_died.emit()
	
func set_spell(val: Spell) -> void:
	_spell = val
	player_spell_changed.emit(val)

func get_spell() -> Spell:
	return _spell
	
func save() -> Dictionary:
	return {
		"position": Vectors.to_dict(_player.position),
		"health": _player_health,
		"spell": _spell
	}
	
func _load(data: Dictionary) -> void:
	_player.position = Vectors.from_dict(data.get("position", {}), Vector2.ZERO)
	_player_health = data["health"]
	_spell = data["spell"]
