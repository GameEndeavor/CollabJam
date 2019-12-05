extends Character
class_name Player

const BASE_MOVE_SPEED = 6 * 16

onready var camera = $Camera2D
onready var camera_shaker = $Camera2D/Shaker

var move_direction = Vector2.ZERO
var desired_velocity = Vector2.ZERO
var is_attacking = false
var is_force_walking = false
var is_dead = false
var has_control = true

func _ready():
	Globals.player = self
	_set_weapon($SteelSword)
	var health_bar = get_tree().current_scene.player_health_bar
	health_bar.set_max_health(max_health)
	connect("health_updated", health_bar, "_on_health_updated")
	connect("health_updated", self, "_on_health_updated")
#	weapon.emitting = true

func _input(event):
	if event.is_action_pressed("attack"):
		attack()

func _physics_process(delta):
	if !is_dead && has_control:
		_handle_move_input()
		_update_facing()
		_move_weapon()
		_apply_movement()

func _handle_move_input():
	if !is_force_walking:
		move_direction = Vector2.ZERO
		move_direction.x = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
		move_direction.y = -int(Input.is_action_pressed("move_up")) + int(Input.is_action_pressed("move_down"))
	
	desired_velocity = move_direction.normalized() * BASE_MOVE_SPEED

func _update_facing():
	var direction = sign(get_local_mouse_position().x)
	if direction != 0:
		body.scale.x = direction

func _move_weapon():
	weapon.aim_at_target(get_local_mouse_position())

func lock_move_direction(normal):
	move_direction = normal
	
	is_force_walking = true

func _apply_movement():
	velocity = velocity.linear_interpolate(desired_velocity, _get_move_weight())
	velocity = move_and_slide(velocity)

func _get_move_weight():
	return 0.3

func _on_AttackTween_tween_completed(object, key):
	is_attacking = false

func _on_health_updated(value):
	camera_shaker.start(camera, "offset", Vector2.ZERO, 0.2, 8, 8)

func kill():
	move_direction = Vector2.ZERO
	is_dead = true
	Effects._on_player_death()