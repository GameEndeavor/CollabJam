extends KinematicBody2D

signal damaged(amount)
signal killed()

export (float) var max_health = 5
export (float) var move_speed_units = 3 setget _set_move_speed_units
export (float) var move_weight = 0.1
export (float) var detection_radius = 5 * 16

onready var state_machine = $StateMachine
onready var body = $Body
onready var status_animation_player = $StatusAnimation
onready var immunity_timer = $Timers/ImmunityTimer

onready var health = max_health setget _set_health

var faction = "enemy"
var velocity = Vector2.ZERO
onready var move_speed = move_speed_units * 16 setget _set_move_speed

func _ready():
	add_to_group(faction)

func _set_pursuit_velocity():
	var target = Globals.player
	
	var desired_velocity = (target.position - position).normalized() * move_speed
	velocity = velocity.linear_interpolate(desired_velocity, move_weight)

func _apply_movement():
	velocity = move_and_slide(velocity)

func damage(amount):
	if immunity_timer.is_stopped():
		immunity_timer.start()
		status_animation_player.play("damage")
		status_animation_player.queue("immunity")
		_set_health(health - amount)
		emit_signal("damaged", amount)

func kill():
	emit_signal("killed")
	queue_free()

func _update_facing():
	if velocity.x != 0:
		body.scale.x = sign(velocity.x)

func _should_pursue_player():
	var dist = (Globals.player.position - position).length()
	return true if dist <= detection_radius else false

func _set_move_speed_units(value):
	move_speed = value * 16
	move_speed_units = value

func _set_move_speed(value):
	move_speed = value
	move_speed_units = value / 16.0

func _set_health(value):
	health = clamp(value, 0, max_health)
	if health == 0:
		kill()

func _on_ImmunityTimer_timeout():
	status_animation_player.play("rest")
