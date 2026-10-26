extends Area2D

var speed: int = 0;
var direction: Vector2 = Vector2.ZERO;
var damage: int = 40;
var caster: Node2D = null;

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += delta * speed * direction

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	rotation = new_direction.angle()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("on_spell_hit"):
		body.on_spell_hit(Player.Spell.Bolt, direction, damage, caster)
	queue_free()
