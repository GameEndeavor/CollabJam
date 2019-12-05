extends Area2D
class_name Hitbox

export (NodePath) var entity_path = ".."
onready var entity = get_node(entity_path)