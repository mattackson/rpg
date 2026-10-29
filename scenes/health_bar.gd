extends Node2D

var offset_x: float
var offset_y: float
var width: float
var health: float = 1.0
var _health_tween: Tween = null

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var healthy_width = width * health
	draw_rect(Rect2(offset_x, offset_y, width, 2), Color.DARK_RED, true)
	draw_rect(Rect2(offset_x, offset_y, healthy_width, 2), Color.LIME_GREEN, true)
	
func tween_health(val: float):
	_health_tween = create_tween()
	_health_tween.tween_property(self, "health", val, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
