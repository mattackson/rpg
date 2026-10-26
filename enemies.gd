extends Node

var _spawn_root: Node = null;
var _spawn_timer: Timer = null;
var _ooze: PackedScene = preload("res://scenes/ooze.tscn")
var _num_enemies: int = 0;
var _cooldown: bool = false;

func _ready() -> void:
	_spawn_timer = Timer.new()
	_spawn_timer.wait_time = 1.0
	_spawn_timer.connect("timeout", _on_spawn_timer)
	_spawn_timer.autostart = true

func register_spawn_root(spawn_root: Node) -> void:
	_spawn_root = spawn_root
	_spawn_root.add_child(_spawn_timer)
	
func on_enemy_defeat(position: Vector2, enemy: String) -> void:
	_num_enemies -= 1
	Items.roll_loot(position, enemy)
	
func _spawn() -> void:
	var ooze = _ooze.instantiate();
	ooze.position = Vectors.location_near(Player.get_player_position())
	_spawn_root.add_child(ooze)
	_cooldown = true
	_num_enemies += 1

func _on_spawn_timer() -> void:
	if _num_enemies < 1:
		_spawn()
	
