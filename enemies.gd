extends Node

signal all_enemies_spawned()
signal all_enemies_defeated()

var _spawn_root: Node = null
var _orb: PackedScene = preload("res://scenes/orb.tscn")
var _num_enemies: int = 0
var _num_spawners_triggered: int = 0
var _default_target: Node2D = null
var _spawners: Array[Spawner]

func register(spawn_root: Node, spawners: Array[Spawner]) -> void:
	_spawn_root = spawn_root
	_spawners = spawners
	
func set_default_target(default_target: Node2D) -> void:
	_default_target = default_target
	
func queue_enemy_spawns(num_enemies_per_spawner: int) -> Signal:
	for spawner in _spawners:
		spawner.spawn_enemies(num_enemies_per_spawner)
		_num_spawners_triggered += 1
		spawner.all_enemies_spawned.connect(_decrement_num_spawners_triggered)
		
	return all_enemies_spawned

func _decrement_num_spawners_triggered():
	_num_spawners_triggered -= 1
	if _num_spawners_triggered == 0:
		all_enemies_spawned.emit()	
	
func _on_enemy_defeat(position: Vector2, enemy: String) -> void:
	_num_enemies -= 1
	if _num_enemies == 0:
		all_enemies_defeated.emit()
	Items.roll_loot(position, enemy)
	
func spawn(position: Vector2, target: Node2D = _default_target) -> Enemy:
	var ooze: Enemy = _orb.instantiate();
	ooze.position = position
	ooze.on_death.connect(_on_enemy_defeat)	
	ooze.target = target
	_spawn_root.add_child(ooze)
	_num_enemies += 1
	return ooze
