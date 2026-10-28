extends Node2D

var origin: Vector2
var target: Vector2
var color: Color = Color.RED

func _draw():
	var vector = target - origin
	draw_line(origin, target, color, 0.5)
	draw_line(target, target + vector.rotated(PI + 0.5).normalized() * 5, color, 0.5)
	draw_line(target, target + vector.rotated(PI - 0.5).normalized() * 5, color, 0.5)
