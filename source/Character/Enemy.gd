extends Character
class_name Enemy

onready var prepare_attack_timer = $Timers/PrepareAttack
onready var attack_cooldown_timer = $Timers/AttackCooldown

export (float) var detection_radius = 6 * 16
export (float) var max_attack_radius = 4 * 16
export (float) var chase_distance = 8 * 16
export (float) var arrival_distance = 2 * 16
export (float) var arrival_deadzone = 1 * 16

func _ready():
	animation_player = $AnimationPlayer

func _apply_pursuit_velocity():
	var target = Globals.player
	
	var dist = (target.position - position).length()
	var desired_velocity = (target.position - position).normalized() * move_speed
	
	if dist < arrival_distance + arrival_deadzone:
		desired_velocity *= max(dist / float(arrival_distance) - arrival_deadzone, 0)
	
	velocity = velocity.linear_interpolate(desired_velocity, move_weight)

func _apply_stop_velocity():
	velocity = velocity.linear_interpolate(Vector2.ZERO, move_weight)

func aim_weapon_at_player():
	weapon_handler.aim_at_target(Globals.player.position - position)

func _should_pursue_player():
	var dist = (Globals.player.position - position).length()
	return true if dist <= detection_radius else false

func has_target():
	var dist = (Globals.player.position - position).length()
	return true if dist < chase_distance else false

func _should_prepare_attack():
	var dist = (Globals.player.position - position).length()
	return true if dist < max_attack_radius else false

func _prepare_attack():
	if prepare_attack_timer.is_stopped():
		prepare_attack_timer.start()