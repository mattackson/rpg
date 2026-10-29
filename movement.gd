extends Node

func move_player_v1_weird(delta: float, player: PlayerCharacter) -> void:
	if Input.is_action_pressed("left"):
		player._braking_velocity_x = 0
		player._input_velocity_x = clamp(player._input_velocity_x - 0.3, -1.0, 0) 
	elif Input.is_action_pressed("right"):
		player._braking_velocity_x = 0
		player._input_velocity_x = clamp(player._input_velocity_x + 0.3, 0, 1.0)
	elif player.velocity.x != 0:
		player._braking_velocity_x = clamp(player._braking_velocity_x + 0.01, 0, 1)
	
	var abs_x = abs(player._input_velocity_x)
	var velocity_change_x = 0
	if player._braking_velocity_x > 0:
		velocity_change_x = player.velocity.x * -1 *  ease(player._braking_velocity_x, 0.33)
	else:
		var x_sign = 1
		if player._input_velocity_x < 0:
			x_sign = -1
		velocity_change_x = x_sign * ease(abs_x, 1.5) * 5

	player.velocity.x = clamp(player.velocity.x + velocity_change_x, -player.MAX_SPEED, player.MAX_SPEED)
	
	if Input.is_action_pressed("up"):
		player._braking_velocity_y = 0
		player._input_velocity_y = clamp(player._input_velocity_y - 0.3, -1.0, 0) 
	elif Input.is_action_pressed("down"):
		player._braking_velocity_y = 0
		player._input_velocity_y = clamp(player._input_velocity_y + 0.3, 0, 1.0)
	elif player.velocity.y != 0:
		player._braking_velocity_y = clamp(player._braking_velocity_y + 0.01, 0, 1)
	
	var velocity_change_y = 0
	if player._braking_velocity_y > 0:
		velocity_change_y = player.velocity.y * -1 * ease(player._braking_velocity_y, 0.33)
	else:
		var sign = 1
		if player._input_velocity_y < 0:
			sign = -1
		velocity_change_y = sign * ease(abs_x, 3) * 5

	player.velocity.y = clamp(player.velocity.y + velocity_change_y, -player.MAX_SPEED, player.MAX_SPEED)
