extends Node

var _spawn_root: Node = null;
var _book: PackedScene = preload("res://scenes/book.tscn")

func register_spawn_root(spawn_root: Node) -> void:
	_spawn_root = spawn_root
	
func roll_loot(position: Vector2, from: String) -> void:
	var item = null
	var roll = randi_range(0, 1000)
	
	match from:
		"ooze":
			if roll < 100:
				item = "book"
	
	if item:
		_spawn_item(position, item)
			
func _spawn_item(position: Vector2, item_name: String) -> void:
	var item = _book.instantiate()
	item.position = position
	_spawn_root.add_child(item)
	
	
			
	
