extends Camera2D

func save() -> Dictionary:
	return {
		"zoom": Vectors.to_dict(zoom)
	}
	
