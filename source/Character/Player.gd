extends KinematicBody2D

const BASE_MOVE_SPEED = 6 * 16

onready var body = $Body
onready var weapon_handler = $WeaponHandler
onready var weapon = $WeaponHandler/Sword

onready var weapon_distance = weapon_handler.position.length()

var faction = "ally"
var velocity = Vector2.ZERO
var move_direction = Vector2.ZERO
var desired_velocity = Vector2.ZERO
var is_attacking = false

func _ready():
	Globals.player = self
	add_to_group(faction)
	weapon.damage_area.add_faction_exception(faction)

func _input(event):
	if event.is_action_pressed("attack"):
		weapon.attack()

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
	var angle = get_local_mouse_position().angle()
	weapon_handler.position.x = cos(angle) * weapon_distance
	weapon_handler.position.y = sin(angle) * weapon_distance
	weapon_handler.rotation = angle
	weapon_handler.show_behind_parent = false if angle >= 0 else true

func _apply_movement():
	velocity = velocity.linear_interpolate(desired_velocity, _get_move_weight())
	velocity = move_and_slide(velocity)

func _get_move_weight():
	return 0.3

func _on_AttackTween_tween_completed(object, key):
	is_attacking = false
