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
	Enemies.register(self, [$Spawner, $Spawner2, $Spawner3, $Spawner4])
	Enemies.set_default_target($Stump)
	Items.register_spawn_root(self)
	Cameras.register_camera($Player/Camera)
	UI.register($CanvasLayer/Hud)
	Draw.register(self)
	
	Game.start_game()

func _save() -> void:
	var save_file = FileAccess.open("user://game.json", FileAccess.WRITE)
	Log.info("Save file", {"path": save_file.get_path_absolute()})
	var data = {
		"player": $Player.save(),
		"camera": $Player/Camera.save()
	}
	save_file.store_line(JSON.stringify(data))
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		_save()
		
	if Input.is_action_just_pressed("slow_time"):
		Game.time_scale = 0.5
		Timers.after(5, _unset_slow_time)
		
func _unset_slow_time():
	Game.time_scale = 1.0
	
