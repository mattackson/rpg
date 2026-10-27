extends Node

enum SpellType {Bolt, Fireball}

var _root: Node = null; 
var _bolt = preload("res://scenes/bolt.tscn")
var bolt_texture = preload("res://assets/export/bolt-icon.png")
var _fireball = preload("res://scenes/fireball.tscn")
var fireball_texture = preload("res://assets/export/fireball-icon.png")

var spells: Dictionary[SpellType, Variant] = {
	SpellType.Bolt: bolt_texture,
	SpellType.Fireball: fireball_texture
}

func register_player(root: Node2D, player: CharacterBase) -> void:
	_root = root
	player.cast.connect(_on_cast)

func create_spell(spell: SpellType, position: Vector2) -> Spell:
	var spell_instance = _resolve_spell(spell).instantiate()
	spell_instance.position = position
	spell_instance.scale = Vector2(0.2, 0.2)
	_root.add_child(spell_instance)
	return spell_instance

func _on_cast(spell: Spell, direction: Vector2, caster: Node2D) -> void:
	spell.speed = 300
	spell.set_direction(direction)
	spell.caster = caster
	
func _resolve_spell(spell: SpellType) -> PackedScene:
	if spell == Spells.SpellType.Bolt:
		return _bolt
	else:
		return _fireball
