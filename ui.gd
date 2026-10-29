extends Node

var _hud: Hud = null

func register(hud: Hud) -> void:
	_hud = hud
	
	Players.player_spell_changed.connect(_hud.set_spell_icon_texture)
	_hud.set_spell_icon_texture(Players.get_player_spell())
	
func display_text(val: String, duration: float) -> Signal:
	return _hud.display_text(val, duration)
	
