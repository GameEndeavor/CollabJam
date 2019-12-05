extends StateMachine

func _ready():
	_add_state("idle")
	_add_state("pursue")
	_add_state("telegraph")
	_add_state("pounce")
	_add_state("after_pounce")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	if state == states.pursue:
		parent._apply_pursuit_velocity()
		if parent._should_prepare_attack():
			parent._prepare_attack()
	elif state != states.pounce && state != states.after_pounce:
		parent._apply_stop_velocity()
	
	parent._update_facing()
	
	parent._apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			if parent._should_pursue_player():
				return states.pursue
		states.pursue:
			if !parent.has_target():
				return states.idle
		states.telegraph:
			if !parent.animation_player.is_playing():
				return states.pounce
		states.pounce:
			if !parent.is_pouncing:
				return states.after_pounce
		states.after_pounce:
			if !parent.is_pouncing:
				return states.idle
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.pounce:
			parent.pounce_at_player()
		states.after_pounce:
			parent._after_pounce()

func _exit_state(old_state, new_state):
	pass

func _on_PrepareAttack_timeout():
	if state == states.pursue:
		set_state(states.telegraph)
