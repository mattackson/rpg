@abstract extends Node2D
class_name Spell

var speed: int = 0;
var direction: Vector2 = Vector2.ZERO;
var caster: Node2D = null;
var _base_damage: int = -1;
var _enabled: bool = false

@abstract func spell_type() -> Spells.SpellType
@abstract func base_damage() -> int
@abstract func _on_spell_hit() -> void

func _ready() -> void:
	_base_damage = base_damage()

func _process(delta: float) -> void:
	position += delta * speed * direction

func cast(cast_direction: Vector2) -> void:
	speed = 300
	direction = cast_direction
	rotation = cast_direction.angle()
	_enabled = true

func _on_body_entered(body: Node2D) -> void:
	if not _enabled:
		return
		
	if body.has_method("on_spell_hit"):
		body.on_spell_hit(spell_type(), direction, _base_damage * scale.x, caster)
	_enabled = false
	_on_spell_hit()
	
