extends Enemy

var health: int = 1000
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
			
func _process(delta: float) -> void:
	if health <= 0:
		_on_defeat()

func _process_impl(delta: float):
	if target:
		var distance_to_target = (target.position - position).length()
		if distance_to_target < 50 && !_is_attack_on_cooldown:
			$AnimationPlayer.play("attack")
		else:
			_move_to_target(delta)
			
func _attack_target():
	var attack_velocity = (target.position - position).normalized() * _attack_speed
	ease_velocity_to(attack_velocity, 0.3, 0.1)
	_is_attack_on_cooldown = true
	Timers.after(2, _unset_attack_on_cooldown)
	Log.info("attacking", {"current_velocity": velocity, "attack_velocity": attack_velocity, "current_speed": velocity.length()})
	
func _unset_attack_on_cooldown():
	_is_attack_on_cooldown = false

func on_spell_hit(_spell: Spells.SpellType, direction: Vector2, damage: int, caster: Node2D) -> void:
	health -= damage
	_recoil(direction * damage * 10, 0.2, 0.2)
