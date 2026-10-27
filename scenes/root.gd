extends Node2D

signal on_spell_change(new_spell: Spells.SpellType)

var book = preload("res://scenes/book.tscn")

func _ready() -> void:
	var data = {}
	var file = FileAccess.open("user://game.json", FileAccess.READ)
	if file:
		var data_as_json = FileAccess.open("user://game.json", FileAccess.READ).get_line()
		var json = JSON.new()
		var error = json.parse(data_as_json)
		if error == Error.OK:
			data = json.data
			Log.info("Loaded save data", data)
		else:
			Log.info("Error parsing save file", {"error_code": error})
	
	Players.register_player($Player, data.get(Players.SAVE_PATH, {}))
	Spells.register_player(self, $Player)
	Enemies.register(self, $Player)
	Items.register_spawn_root(self)
	Camera.register_camera($Player/Camera2D, data.get(Camera.SAVE_PATH, {}))
	Ui.register($CanvasLayer/Hud)

func _save() -> void:
	var save_file = FileAccess.open("user://game.json", FileAccess.WRITE)
	Log.info("Save file", {"path": save_file.get_path_absolute()})
	var data = {
		"player": $Player.save(),
		"camera": Camera.save()
	}
	save_file.store_line(JSON.stringify(data))
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		_save()
