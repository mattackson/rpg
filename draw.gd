extends Node

var _root: Node2D
var _arrow: PackedScene = preload("res://debug/arrow.tscn")

func register(root: Node2D):
	_root = root

func arrow(origin: Vector2, target: Vector2, color: Color = Color.RED):
	var arrow_instance = _arrow.instantiate()
	arrow_instance.origin = origin
	arrow_instance.target = target
	arrow_instance.color = color
	_root.add_child(arrow_instance)
	
