extends Node

func from_dict(val: Dictionary, default: Vector2) -> Vector2:
	if val.has("x") && val.has("y"):
		var x = val["x"]
		if x:
			return Vector2(val["x"], val["y"])
		else:
			return default
	else:
		return Vector2.ZERO
	
func to_dict(val: Vector2) -> Dictionary[String, int]:
	return {
		"x": val.x,
		"y": val.y
	}
	
func location_near(val: Vector2) -> Vector2:
	var distance = randi_range(30, 50)
	return val + _random_direction() * distance
	
func _random_direction() -> Vector2:
	return Vector2.from_angle(randf_range(0, PI))
