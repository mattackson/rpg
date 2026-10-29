extends Node

var time_scale: float = 1.0

var _condition_timer: Timer = null

func _ready() -> void:
	_condition_timer = Timer.new()
	_condition_timer.autostart = true
	_condition_timer.start(1)

func start_game():
	await level_1()

func level_1():
	await UI.display_text("They are coming", 3)
	await UI.display_text("I'm serious...", 2)
	await UI.display_text("Ok then, here you go", 1)
	await Enemies.queue_enemy_spawns(3)
	await Enemies.all_enemies_defeated
	await UI.display_text("Not bad", 5)
	
