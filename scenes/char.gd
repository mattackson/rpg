extends CharacterBody2D

class_name CharacterBase

signal cast(spell: String, position: Vector2, direction: Vector2, caster: Node2D)

const MAX_SPEED: int = 160
const MIN_ZOOM = Vector2(1, 1)
const MAX_ZOOM = Vector2(4, 4)

var _is_idle_up: bool = false;
var _is_idle: bool = true;

var _input_velocity_x: float = 0
var _braking_velocity_x: float = 0
var _input_velocity_y: float = 0
var _braking_velocity_y: float = 0

func _ready() -> void:
	_start_idle()

func _physics_process(delta: float) -> void:
	#Movement.move_player_v1_weird(delta, self)
	velocity = Input.get_vector("left", "right", "up", "down") * 150
	
	# max around 120 per process
	move_and_slide()
		
	if Input.is_action_just_pressed("primary"):
		cast_spell(Player.get_spell())
		
	if velocity == Vector2.ZERO:
		if not _is_idle:
			$Sprite2D.frame = 0
			_start_idle()
	else:
		_stop_idle();
	
	if velocity.x != 0:
		$Sprite2D.frame = 5
		$Sprite2D.flip_h = velocity.x > 0
	elif velocity.y > 0:
		_is_idle = false
		$Sprite2D.frame = 6
	elif velocity.y < 0:
		_is_idle = false
		$Sprite2D.frame = 7
	
func cast_spell(spell: Player.Spell) -> void:
	var direction = position.direction_to(get_global_mouse_position())
	cast.emit(spell, position, direction, self)
	
func on_collision() -> void:
	Player.remove_player_health(10)

func _stop_idle() -> void:
	$AnimationPlayer.stop(false)
	_is_idle = false
	_idle_down()
		
func _start_idle() -> void:
	$AnimationPlayer.play("idle")
	_is_idle = true
	
func _idle_up() -> void:
	if velocity == Vector2.ZERO:
		$Sprite2D.position.y -= 2
		$Shadow.visible = false
		$Shadow2.visible = true
		_is_idle_up = true

func _idle_down() -> void:
	if _is_idle_up:
		$Sprite2D.position.y += 2
		$Shadow.visible = true
		$Shadow2.visible = false
		_is_idle_up = false
