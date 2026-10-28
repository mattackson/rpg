extends Node

func after(s: float, call: Callable) -> void:
	var timer = Timer.new()
	timer.wait_time = s
	timer.connect("timeout", call)
	timer.connect("timeout", timer.queue_free)
	timer.autostart = true
	timer.one_shot = true
	add_child(timer)
	
