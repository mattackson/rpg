extends Node2D

signal on_spell_change(new_spell: Player.Spell)

var bolt = preload("res://scenes/bolt.tscn")
var fireball = preload("res://scenes/fireball.tscn")
var book = preload("res://scenes/book.tscn")

func _ready() -> void:
	var data_as_json = FileAccess.open("user://game.json", FileAccess.READ).get_line()
	var json = JSON.new()
	json.parse(data_as_json)
	var data = json.data
	
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
	
func _on_cast(spell: Player.Spell, new_position: Vector2, direction: Vector2, caster: Node2D) -> void:
	var bolt_instance = _resolve_spell(spell).instantiate()
	bolt_instance.position = new_position + direction * 20
	bolt_instance.speed = 300;
	bolt_instance.set_direction(direction)
	bolt_instance.caster = caster
	add_child(bolt_instance)
	
func _resolve_spell(spell: Player.Spell) -> PackedScene:
		if spell == Player.Spell.Bolt:
			return bolt
		else:
			return fireball

func _on_ooze_on_death(new_position: Vector2) -> void:
	var book_instance = book.instantiate()
	book_instance.position = new_position
	book_instance.connect("book_picked_up", _on_book_picked_up)
	add_child(book_instance)
	
func _on_book_picked_up() -> void:
	Player.set_spell(Player.Spell.Fireball)
	on_spell_change.emit(Player.Spell.Fireball)
	
	
