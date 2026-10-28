@abstract
extends CharacterBody2D
class_name Enemy

signal on_death(position: Vector2, enemy: String)

var target: Node2D = null
var speed: float = 3000
var _recently_collided: bool = false
var _recoil_target: Vector2 = Vector2.INF
var _recoiling_from: Vector2 = Vector2.INF
var _ease_velocity_progress: float
var _ease_velocity_duration: float
var _ease_velocity_curve: float
var _recoil_velocity: Vector2 = Vector2.INF

var _initial_velocity: Vector2
var _target_velocity: Vector2

@abstract func awareness_area() -> Area2D
@abstract func enemy_name() -> String
@abstract func max_recoil_speed() -> float

func _ready() -> void:
	awareness_area().body_entered.connect(_on_awareness_area_body_entered)
	set_collision_layer_value(3, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
	set_collision_mask_value(4, true)
		
func is_recoiling() -> bool:
	return _recoil_velocity != Vector2.INF

func _on_awareness_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		target = body

func _recoil(recoil_velocity: Vector2, for_seconds: float = 0.2, curve: float = 0.1):
	assert(for_seconds > 0, "for_seconds must be positive in _recoil")
	recoil_velocity = recoil_velocity.limit_length(max_recoil_speed())
	_recoil_velocity = recoil_velocity
	_ease_velocity_duration = for_seconds
	_ease_velocity_progress = 0
	_ease_velocity_curve = curve
	
	velocity = _recoil_velocity
	_initial_velocity = velocity
	_target_velocity = Vector2.ZERO

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

func _on_defeat() -> void:
	on_death.emit(position, enemy_name())
	queue_free()

func _move_to_target(delta: float):
	velocity = position.direction_to(target.position) * delta * speed
