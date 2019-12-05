extends Node2D
class_name Weapon

signal attack_finished()

onready var body = $Body
var damage_area

export (float) var held_distance = 12
export (float) var attack_range = 3.0 * 16
export (float) var attack_duration = 0.1

var is_attacking = false

func aim_at_target(target_position : Vector2):
	var angle = target_position.angle()
	position.x = cos(angle) * held_distance
	position.y = sin(angle) * held_distance
	rotation = angle
	show_behind_parent = false if angle >= 0 else true

func attack() -> bool:
	assert(false)
	return false

func _attack_complete():
	is_attacking = false
	emit_signal("attack_finished")