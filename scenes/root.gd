extends Node2D

signal on_spell_change(new_spell: Player.Spell)

var book = preload("res://scenes/book.tscn")

func _ready() -> void:
	var data_as_json = FileAccess.open("user://game.json", FileAccess.READ).get_line()
	var json = JSON.new()
	json.parse(data_as_json)
	var data = json.data
	
	Spells.register_player(self, $Player)
	Player.register_player($Player, data.get(Player.SAVE_PATH, {}))
	Enemies.register_spawn_root(self)
	Items.register_spawn_root(self)
	Camera.register_camera($Player/Camera2D, data.get(Camera.SAVE_PATH, {}))
	
func _save() -> void:
	var save_file = FileAccess.open("user://game.json", FileAccess.WRITE)
	var data = {
		"player": Player.save(),
		"camera": Camera.save()
	}
	save_file.store_line(JSON.stringify(data))
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		_save()
