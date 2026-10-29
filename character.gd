@abstract
extends CharacterBody2D

# any player controller or ai controlled body with movement
class_name Character

var target: Node2D = null
var speed: float = 3000
var _ease_velocity_progress: float
var _ease_velocity_duration: float
var _ease_velocity_curve: float
var _initial_velocity: Vector2
var _target_velocity: Vector2

@abstract func _handle_collision(collision: KinematicCollision2D) -> void
@abstract func _process_impl(delta: float) -> void

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if is_easing_velocity():
		_handle_easing_velocity(delta)
	else:
		_process_impl(delta)
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		_handle_collision(collision)

func _recoil(recoil_velocity: Vector2, for_seconds: float = 0.2, curve: float = 0.1):
	assert(for_seconds > 0, "for_seconds must be positive")
	velocity = recoil_velocity
	ease_velocity_to(Vector2.ZERO, for_seconds, curve)

func ease_velocity_to(target_velocity: Vector2, for_seconds: float = 0.2, curve: float = 0.1):
	_ease_velocity_duration = for_seconds
	_ease_velocity_progress = 0
	_ease_velocity_curve = curve
	_initial_velocity = velocity
	_target_velocity = target_velocity

func is_easing_velocity() -> bool:
	return _target_velocity != Vector2.INF

func _handle_easing_velocity(delta: float):
	if _target_velocity != Vector2.INF:
		# say we're going 10, we need to be at 0 when _recoil_progress has reached the desired length of time
		_ease_velocity_progress += delta
		
		# compute an input for the easing curve based on how far we are towards the end
		var ease_curve_input = _ease_velocity_progress / _ease_velocity_duration
		var ease_curve_progress = ease(ease_curve_input, _ease_velocity_curve)
		
		# now compute what the velocity should be... somehow. If we start going (1, 1), then if we're halfway through decelerating, we should get (0.5, 0.5)
		# ease_curve_progress should be 0.5 at that point
		# so we should take recoil_velocity and subtract a parallel vector multipled by ease_curve_progress?
		var velocity_diff = (_target_velocity - _initial_velocity) * ease_curve_progress
		velocity = _initial_velocity + velocity_diff
		
		if _ease_velocity_progress >= _ease_velocity_duration:
			# we should be done
			_target_velocity = Vector2.INF
