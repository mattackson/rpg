@abstract extends Node2D
class_name Spell

var speed: int = 0;
var direction: Vector2 = Vector2.ZERO;
var caster: Node2D = null;

var _base_damage: int = -1;

@abstract func spell_type() -> Spells.SpellType
@abstract func base_damage() -> int

func _ready() -> void:
	_base_damage = base_damage()

func _process(delta: float) -> void:
	position += delta * speed * direction

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	rotation = new_direction.angle()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("on_spell_hit"):
		body.on_spell_hit(spell_type(), direction, _base_damage * scale.x, caster)
	_on_spell_hit()
	
func _on_spell_hit() -> void:
	queue_free()
