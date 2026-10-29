extends Enemy

var health: int = 100
var _is_attack_on_cooldown: bool = true
var _attack_speed: float = 200

func awareness_area() -> Area2D:
	return $AwarenessArea
	
func enemy_name() -> String:
	return "orb"

func max_recoil_speed() -> float:
	return 200
	
func _ready() -> void:
	super()
	Timers.after(2, _unset_attack_on_cooldown)
	$HealthBar.offset_x = -6
	$HealthBar.offset_y = -11
	$HealthBar.width = 14
			
func _process(delta: float) -> void:
	super(delta)
	if health <= 0:
		_on_defeat()


func _control_and_set_velocity(delta: float):
	if target:
		var distance_to_target = (target.position - position).length()
		if distance_to_target < 50 && !_is_attack_on_cooldown:
			$AnimationPlayer.play("attack")
		else:
			_move_to_target(delta)
			
func _attack_target():
	var attack_velocity = (target.position - position).normalized() * _attack_speed
	tween_velocity(attack_velocity, 0.3)
	_is_attack_on_cooldown = true
	Timers.after(2, _unset_attack_on_cooldown)
	Log.info("attacking", {"current_velocity": velocity, "attack_velocity": attack_velocity, "current_speed": velocity.length()})
	
func _unset_attack_on_cooldown():
	_is_attack_on_cooldown = false

func on_spell_hit(_spell: Spells.SpellType, direction: Vector2, damage: int, caster: Node2D) -> void:
	target = caster
	health -= damage
	$HealthBar.tween_health(health / 100.0)
	_recoil(direction * damage * 10, 0.2)
