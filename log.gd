extends Node

var _json: JSON = JSON.new()

# logs a single value with a message
func msg(message: String, val: Variant = null) -> void:
	print(message + ": val=" + str(val))
	
# logs a dictionary with a message
func info(message: String, params: Dictionary = {}) -> void:
	print(message + ": " + _json.stringify(params, "  "))
		
