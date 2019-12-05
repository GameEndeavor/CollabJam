extends StateMachine

func _ready():
	_add_state("idle")
	_add_state("pursue")
	_add_state("telegraph")
	_add_state("attack")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	pass

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass