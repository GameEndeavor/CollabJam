extends Node2D

export (PackedScene) var enemy_scene = null

func _ready():
	if enemy_scene != null:
		var entity = enemy_scene.instance()
		get_parent().add_child(entity)
		queue_free()