extends Node

var _spawn_root: Node = null;
var _spawn_timer: Timer = null;
var _ooze: PackedScene = preload("res://scenes/ooze.tscn")
var _orb: PackedScene = preload("res://scenes/orb.tscn")
var _num_enemies: int = 0;
var _player: PlayerCharacter = null;

func _ready() -> void:
	_spawn_timer = Timer.new()
	_spawn_timer.wait_time = 1.0
	_spawn_timer.connect("timeout", _on_spawn_timer)
	_spawn_timer.autostart = true

func register(spawn_root: Node, player: PlayerCharacter) -> void:
	_spawn_root = spawn_root
	_spawn_root.add_child(_spawn_timer)
	_player = player
	
func _on_enemy_defeat(position: Vector2, enemy: String) -> void:
	_num_enemies -= 1
	Items.roll_loot(position, enemy)
	
func _spawn() -> void:
	var ooze: Node2D = _orb.instantiate();
	ooze.position = Vectors.location_near(_player.position)
	ooze.on_death.connect(_on_enemy_defeat)	
	_spawn_root.add_child(ooze)
	_num_enemies += 1

func _on_spawn_timer() -> void:
	if _num_enemies < 1:
		_spawn()
	
