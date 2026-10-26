extends RigidBody2D

signal on_death(position: Vector2)

var MAX_SPEED: int = 30
var MAX_V: Vector2 = Vector2(MAX_SPEED, MAX_SPEED)
var MIN_V: Vector2 = Vector2(-MAX_SPEED, -MAX_SPEED)

var health: int = 100;
var speed: int = 200;
var target: Node2D = null;

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if target:
		var new_clamped_linear_velocity = linear_velocity + (delta * speed * position.direction_to(target.position))
		new_clamped_linear_velocity = new_clamped_linear_velocity.clamp(MIN_V, MAX_V)
		linear_velocity = new_clamped_linear_velocity
		
func on_spell_hit(_spell: Player.Spell, direction: Vector2, damage: int, caster: Node2D) -> void:
	health -= damage
	if health <= 0:
		_on_defeat()
		
	apply_central_impulse(direction * damage)
	
	target = caster
	
func _on_defeat() -> void:
	Enemies.on_enemy_defeat(position, "ooze")
	on_death.emit(position)
	queue_free()

func _on_awareness_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		target = body
		
func _on_body_entered(body: Node) -> void:
	if body.has_method("on_collision"):
		body.on_collision()
		
	apply_central_impulse(linear_velocity * -1)
