@abstract
extends Character
class_name Enemy

signal on_death(position: Vector2, enemy: String)

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
		
func _handle_collision(collision: KinematicCollision2D) -> void:
	if collision.get_collider().has_method("on_collision"):
		collision.get_collider().on_collision(collision)
	var recoil_velocity = (velocity * -2).limit_length(max_recoil_speed())
	_recoil(recoil_velocity, 0.5, Tween.TRANS_QUAD)
	
func _move_to_target(delta: float):
	velocity = position.direction_to(target.position) * delta * speed
		
func _on_awareness_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		target = body

func _on_defeat() -> void:
	on_death.emit(position, enemy_name())
	queue_free()
