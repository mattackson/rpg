extends Node

const SAVE_PATH: String = "camera"
const MIN_ZOOM: Vector2 = Vector2(0.5, 0.5)
const MAX_ZOOM: Vector2 = Vector2(8, 8) 
const ZOOM_INCREMENT: Vector2 = Vector2(0.1, 0.1)

var _camera: Camera2D = null;

func register_camera(camera: Camera2D, data: Dictionary) -> void:
	_camera = camera
	_load(data)

func _load(data: Dictionary) -> void:
	_camera.zoom = Vectors.from_dict(data.get("zoom", {}), MIN_ZOOM)
