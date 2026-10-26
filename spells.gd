extends Node

var _root: Node = null; 

var _bolt = preload("res://scenes/bolt.tscn")
var _fireball = preload("res://scenes/fireball.tscn")

func register_player(root: Node2D, player: CharacterBase) -> void:
	_root = root
	player.cast.connect(_on_cast)

func _on_cast(spell: Player.Spell, new_position: Vector2, direction: Vector2, caster: Node2D) -> void:
	var bolt_instance = _resolve_spell(spell).instantiate()
	bolt_instance.position = new_position + direction * 20
	bolt_instance.speed = 300;
	bolt_instance.set_direction(direction)
	bolt_instance.caster = caster
	_root.add_child(bolt_instance)
	
func _resolve_spell(spell: Player.Spell) -> PackedScene:
	if spell == Player.Spell.Bolt:
		return _bolt
	else:
		return _fireball
