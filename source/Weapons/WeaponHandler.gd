extends Position2D

onready var held_distance = position.length()

func aim_at_target(target_position : Vector2):
	var angle = target_position.angle()
	position.x = cos(angle) * held_distance
	position.y = sin(angle) * held_distance
	rotation = angle
	show_behind_parent = false if angle >= 0 else true