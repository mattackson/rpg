extends Node

signal player_died();
signal player_spell_changed(new_spell: Spell);

const SAVE_PATH: String = "player"

var _player: CharacterBase = null;
	
func get_player_position() -> Vector2:
	return _player.position
	
func get_player_spell() -> Spells.SpellType:
	return _player.get_spell()
	
func set_player_spell(val: Spells.SpellType) -> void:
	_player.set_spell(val)
	player_spell_changed.emit(val)

func register_player(player: CharacterBase, data: Dictionary) -> void:
	_player = player
	if data:
		_load(data)
	
func save() -> Dictionary:
	return {
		"position": Vectors.to_dict(_player.position),
		"health": _player.get_health(),
		"spell": _player.get_spell()
	}
	
func _load(data: Dictionary) -> void:
	_player.position = Vectors.from_dict(data.get("position", {}), Vector2.ZERO)
	_player.set_health(data["health"])
	_player.set_spell(data["spell"])
