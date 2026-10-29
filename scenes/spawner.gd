extends Node2D
class_name Spawner

signal all_enemies_spawned()

var enemies_to_spawn: int = 0
var is_active: bool = true

var _num_spawned_enemies: int = 0

func spawn_enemies(val: int) -> void:
	_num_spawned_enemies = 0
	enemies_to_spawn = val
	
func _process(delta: float) -> void:
	pass

func _on_enemy_defeat(position: Vector2, enemy: String) -> void:
	pass

func _on_spawn_timer() -> void:
	if is_active and _num_spawned_enemies < enemies_to_spawn:
		var spawned_enemy: Enemy = Enemies.spawn(position)
		spawned_enemy.on_death.connect(_on_enemy_defeat)
		_num_spawned_enemies += 1
		
		if _num_spawned_enemies == enemies_to_spawn:
			all_enemies_spawned.emit()
		
	
