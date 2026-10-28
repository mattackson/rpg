@abstract
extends CharacterBody2D
class_name Enemy

signal on_death(position: Vector2, enemy: String)

var target: Node2D = null
var speed: float = 3000
var _recently_collided: bool = false

@abstract func get_awareness_area() -> Area2D

func _ready() -> void:
	get_awareness_area().body_entered.connect(_on_awareness_area_body_entered)
	set_collision_layer_value(3, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
	set_collision_mask_value(4, true)

func _physics_process(delta: float) -> void:
	if target && not _recently_collided:
		velocity = position.direction_to(target.position) * delta * speed
	
	var collision = move_and_collide(velocity * delta)
	if collision && collision.get_collider().has_method("on_collision"):
		collision.get_collider().on_collision(collision)
		_recently_collided = true
		Timers.after(0.5, _unset_recently_collided)
		velocity = -velocity
		
		
func _on_awareness_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		target = body
	
func _unset_recently_collided():
	_recently_collided = false
