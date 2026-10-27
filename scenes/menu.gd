extends Control

const MENU_MARGIN: int = 5
const MENU_BORDER: int = 5

var _menu_colour: Color = Color(Colours.menu_light, 0.6)
var _menu_border_colour: Color = Color(Colours.menu_dark, 0.6)

func _ready() -> void:
	modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
func _process(_delta: float) -> void:
	pass

func fade_out() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.1)
	await tween.finished

func _draw() -> void:
	var min_x = MENU_MARGIN
	var min_y = MENU_MARGIN
	var width = Display.VIEWPORT_SIZE.x - (2 * MENU_MARGIN)
	var height = Display.VIEWPORT_SIZE.y - (2 * MENU_MARGIN)
	draw_rect(Rect2(min_x, min_y, width, height), _menu_colour)
	
	var inner_min_x = min_x + MENU_BORDER
	var inner_min_y = min_y + MENU_BORDER
	var inner_width = width - (2 * MENU_BORDER)
	var inner_height = height - (2 * MENU_BORDER)
	draw_rect(Rect2(inner_min_x, inner_min_y, inner_width, inner_height), _menu_border_colour)
