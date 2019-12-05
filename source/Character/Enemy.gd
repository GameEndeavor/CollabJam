extends Character
class_name Enemy

const ALERT_RANGE = 96

export (bool) var debug = false

onready var neighbors = $Neighbors
onready var prepare_attack_timer = $Timers/PrepareAttack
onready var attack_cooldown_timer = $Timers/AttackCooldown
onready var health_bar = $HealthBar
onready var telegraph_tracking_timer = $Timers/TelegraphTrackingTImer

export (float) var detection_radius = 6 * 16
export (float) var max_attack_radius = 4 * 16
export (float) var chase_distance = 12 * 16
export (float) var arrival_distance = 2 * 16
export (float) var arrival_deadzone = 1 * 16
export (int, -1, 1, 2) var initial_facing = 1
var is_alerted

func _ready():
	animation_player = $AnimationPlayer
	$DamageArea.call_deferred("add_faction_exception", faction)
	health_bar.set_max_health(max_health)
	call_deferred("_set_initial_facing")
	health_bar.hide()

func _set_initial_facing():
	body.get_node("Sprite").flip_h = true if initial_facing == 1 else false
	if weapon != null:
		weapon.aim_at_target(Vector2.RIGHT * initial_facing)

func _apply_pursuit_velocity():
	var target = Globals.player
	
	if target != null:
		var dist = (target.position - position).length()
		var desired_velocity = (target.position - position).normalized()
		desired_velocity += _get_separation_velocity()
		
		desired_velocity = desired_velocity.normalized() * move_speed
		
		if dist < arrival_distance + arrival_deadzone:
			desired_velocity *= max(dist / float(arrival_distance) - arrival_deadzone, 0)
		
		velocity = velocity.linear_interpolate(desired_velocity, move_weight)

var a = Vector2.ZERO
func _get_separation_velocity():
	var desired_velocity = Vector2()
	
	var count = 0
	for neighbor in neighbors.get_overlapping_bodies():
		if neighbor != self && neighbor.is_in_group(faction):
			desired_velocity += (position - neighbor.position)
			count += 1
	if count != 0:
		desired_velocity /= float(count)
		desired_velocity = desired_velocity.normalized()
	return desired_velocity

func _apply_stop_velocity():
	velocity = velocity.linear_interpolate(Vector2.ZERO, move_weight)

func aim_weapon_at_player():
	if Globals.player != null:
		weapon.aim_at_target(Globals.player.position - position)

func _should_pursue_player():
	if Globals.player != null:
		var dist = (Globals.player.position - position).length()
		# TODO: Use raycasts to see and facing to check if can see player
		return true if dist <= detection_radius else false
	else:
		return false

func has_target():
	if Globals.player != null:
		var dist = (Globals.player.position - position).length()
		return true if dist < chase_distance else false
	else:
		return false

func _should_prepare_attack():
	if Globals.player != null:
		var dist = (Globals.player.position - position).length()
		return true if dist < max_attack_radius else false
	else:
		return false

func _prepare_attack():
	if prepare_attack_timer.is_stopped():
		prepare_attack_timer.start()

func telegraph_attack():
	pass

func _on_Enemy_health_updated(health):
	health_bar.show()

func _update_facing():
	if weapon != null:
		var facing_right = false if abs(weapon.position.angle()) < PI / 2.0 else true
		body.get_node("Sprite").flip_h = false if facing_right else true
	else:
		._update_facing()

func can_alert():
	return true

func alert():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy != self:
			var dist = (enemy.global_position - position).length()
			if enemy.can_alert() && dist < ALERT_RANGE && enemy.state_machine.state == enemy.state_machine.states.idle:
				enemy.state_machine.set_state(enemy.state_machine.states.pursue)
				enemy.alert()