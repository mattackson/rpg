extends Control
class_name Hud

var _menu_scene: PackedScene = preload("res://scenes/menu.tscn")
var _menu: Control = null

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_toggle_pause(!get_tree().paused)
		
	if Input.is_action_just_pressed("menu"):
		_toggle_menu()

func _on_root_on_spell_change(new_spell: Spells.SpellType) -> void:
	set_spell_icon_texture(new_spell)

func set_spell_icon_texture(new_spell: Spells.SpellType) -> void:
	$SpellContainer/SpellIcon.texture = Spells.spells[new_spell]

func _toggle_pause(val: bool) -> void:
	get_tree().paused = val

func _toggle_menu() -> void:
	if _menu:
		await _menu.fade_out();
		_menu.queue_free()
		_toggle_pause(false)
	else:
		_menu = _menu_scene.instantiate()
		add_child(_menu)
		_toggle_pause(true)
