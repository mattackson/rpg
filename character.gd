@abstract
extends CharacterBody2D

# any player controller or ai controlled body with movement
class_name Character

signal ease_velocity_finished()

var target: Node2D = null
var speed: float = 3000
var _velocity_tween: Tween = null

@abstract func _handle_collision(collision: KinematicCollision2D) -> void
@abstract func _control_and_set_velocity(delta: float) -> void

func _physics_process(delta: float) -> void:
	if not _velocity_tween:
		_control_and_set_velocity(delta)
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		_handle_collision(collision)

func _recoil(recoil_velocity: Vector2, duration: float = 0.2, trans: Tween.TransitionType = Tween.TRANS_CUBIC):
	assert(duration > 0, "for_seconds must be positive")
	velocity = recoil_velocity
	tween_velocity(Vector2.ZERO, duration, Tween.EASE_OUT, trans)

func tween_velocity(target_velocity: Vector2, duration: float = 0.2, ease: Tween.EaseType = Tween.EASE_OUT, trans: Tween.TransitionType = Tween.TRANS_QUINT):
	if _velocity_tween:
		_velocity_tween.kill()
		
	_velocity_tween = create_tween()
	_velocity_tween.tween_property(self, "velocity", target_velocity, duration).set_ease(ease).set_trans(trans)
	_velocity_tween.tween_callback(_enable_movement)

func _enable_movement():
	_velocity_tween = null
