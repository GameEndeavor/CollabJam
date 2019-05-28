extends StateMachine

func _ready():
	_add_state("idle")
	_add_state("pursue")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	if state == states.pursue:
		parent._set_pursuit_velocity()
	
	parent._update_facing()
	
	parent._apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			if parent._should_pursue_player():
				return states.pursue
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass