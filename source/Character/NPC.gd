extends Node2D

onready var animation_player = $AnimationPlayer

export (int, -1, 1, 2) var facing = 1

func _ready():
	get_node("Body/Sprite").flip_h = false if facing == 1 else true

func celebrate():
	yield(get_tree().create_timer(randf() * 0.5), "timeout")
	animation_player.play("celebrate")