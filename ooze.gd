extends RigidBody2D
class_name Ooze 

signal on_death(position: Vector2, enemy: String)

var MAX_SPEED: int = 30
var MAX_V: Vector2 = Vector2(MAX_SPEED, MAX_SPEED)
var MIN_V: Vector2 = Vector2(-MAX_SPEED, -MAX_SPEED)

var health: int = 200
var speed: int = 100
var target: Node2D = null
var _recently_collided: bool = false
var _previous_linear_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	_previous_linear_velocity = linear_velocity
	if health <= 0:
		_on_defeat()
		return
		
	if target and not _recently_collided:
		apply_force(delta * 10000 * position.direction_to(target.position))
		
	if linear_velocity.length() > speed:
		apply_force(delta * -5 * linear_velocity)

func on_spell_hit(_spell: Spells.SpellType, direction: Vector2, damage: int, caster: Node2D) -> void:
	health -= damage
	apply_central_impulse(direction * damage * 3)
	target = caster
	
func _on_defeat() -> void:
	on_death.emit(position, "ooze")
	queue_free()

func _on_awareness_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		target = body
		
func _on_body_entered(body: Node) -> void:
	if body.has_method("on_collision"):
		body.on_collision(_previous_linear_velocity)
	_recently_collided = true
	Timers.after(0.5, _unset_recently_collided)
	
func _unset_recently_collided():
	_recently_collided = false
	
	
