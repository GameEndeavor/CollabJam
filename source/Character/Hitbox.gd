extends Area2D
class_name Hitbox

export (NodePath) var entity_path

var entity

func _ready():
	entity = get_node(entity_path) if entity_path != "" else get_parent()