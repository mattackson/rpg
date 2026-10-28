extends Enemy

func get_awareness_area() -> Area2D:
	return $AwarenessArea

# Called when the node enters the scene dtree for the first time.
func _ready() -> void:
	super()
