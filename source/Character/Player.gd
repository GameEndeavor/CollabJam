extends Character

const BASE_MOVE_SPEED = 6 * 16

#onready var body = $Body
#onready var weapon_handler = $WeaponHandler

#var velocity = Vector2.ZERO
var move_direction = Vector2.ZERO
var desired_velocity = Vector2.ZERO
var is_attacking = false

func _ready():
	Globals.player = self
	_set_weapon($WeaponHandler/Sword)

func _input(event):
	if event.is_action_pressed("attack"):
		attack()

func _physics_process(delta):
	_handle_move_input()
	_move_weapon()
	_apply_movement()

func _handle_move_input():
	move_direction = Vector2.ZERO
	move_direction.x = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	move_direction.y = -int(Input.is_action_pressed("move_up")) + int(Input.is_action_pressed("move_down"))
	
	desired_velocity = move_direction.normalized() * BASE_MOVE_SPEED
	
	if desired_velocity.x != 0:
		body.scale.x = sign(desired_velocity.x)

func _move_weapon():
	weapon_handler.aim_at_target(get_local_mouse_position())

func _apply_movement():
	velocity = velocity.linear_interpolate(desired_velocity, _get_move_weight())
	velocity = move_and_slide(velocity)

func _get_move_weight():
	return 0.3

func _on_AttackTween_tween_completed(object, key):
	is_attacking = false
