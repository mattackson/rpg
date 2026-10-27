extends Node

var _json: JSON = JSON.new()

func info(message: String, params: Dictionary = {}) -> void:
	print(message + ": " + _json.stringify(params, "  "))
		
