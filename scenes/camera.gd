extends Camera2D

func _ready() -> void:
	pass
	get_tree().create_tween()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("zoom_in"):
		var new_zoom = zoom + Cameras.ZOOM_INCREMENT
		zoom = new_zoom.min(Cameras.MAX_ZOOM)

	if Input.is_action_pressed("zoom_out"):
		var new_zoom = zoom - Cameras.ZOOM_INCREMENT
		zoom = new_zoom.max(Cameras.MIN_ZOOM)

func save() -> Dictionary:
	return {
		"zoom": Vectors.to_dict(zoom)
	}
	
