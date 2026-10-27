extends CharacterBody2D

class_name CharacterBase

signal cast(spell: Spell, direction: Vector2, caster: Node2D)
signal player_died();
signal player_spell_changed(new_spell: Spell);

const MAX_SPEED: int = 160
const MIN_ZOOM = Vector2(1, 1)
const MAX_ZOOM = Vector2(4, 4)
const SAVE_PATH: String = "player"

var _is_idle_up: bool = false;
var _is_idle: bool = true;

var _input_velocity_x: float = 0
var _braking_velocity_x: float = 0
var _input_velocity_y: float = 0
var _braking_velocity_y: float = 0

var _charging_spell: Spell = null

var _health: int = 100;
var _spell: Spells.SpellType = Spells.SpellType.Bolt;

func get_health() -> int:
	return _health
	
func set_health(val: int) -> void:
	_health = val
	
func get_spell() -> Spells.SpellType:
	return _spell
	
func set_spell(val: Spells.SpellType) -> void:
	_spell = val

func _ready() -> void:
	_start_idle()

func _process(delta: float) -> void:
		#Movement.move_player_v1_weird(delta, self)
	velocity = Input.get_vector("left", "right", "up", "down") * 130
	move_and_slide()
		
	if Input.is_action_pressed("primary"):
		if _charging_spell == null:
			_charging_spell = Spells.create_spell(_spell, position + Vector2(0, -20))
		else:
			var charge = delta * 2
			_charging_spell.scale = Vector2.ONE.min(_charging_spell.scale + Vector2(charge, charge))
			_charging_spell.position = position + Vector2(0, -20)
			_charging_spell.rotation = _charging_spell.position.direction_to(get_global_mouse_position()).angle()
	else:
		if _charging_spell != null:
			cast_spell()
			_charging_spell = null
	
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

func cast_spell() -> void:
	var direction = _charging_spell.position.direction_to(get_global_mouse_position())
	cast.emit(_charging_spell, direction, self)
	
func on_collision() -> void:
	_health -= 10
	if _health <= 0:
		player_died.emit()

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

func save() -> Dictionary:
	return {
		"position": Vectors.to_dict(position),
		"health": _health,
		"spell": _spell
	}
	
func _load(data: Dictionary) -> void:
	position = Vectors.from_dict(data.get("position", {}), Vector2.ZERO)
	_health = data["health"]
	_spell = data["spell"]
