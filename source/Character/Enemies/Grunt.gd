extends Enemy

func _ready():
	_set_weapon($RustySword)

func _on_Neighbors_body_entered(body):
#	print($Neighbors.get_overlapping_bodies().size())
	pass # Replace with function body.
