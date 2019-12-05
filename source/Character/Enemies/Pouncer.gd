extends Enemy

const POUNCE_SPEED : float = 6 * 16.0
const MAX_POUNCE_DISTANCE = 4 * 16
const AFTER_POUNCE_DISTANCE = 2 * 16

export (bool) var is_hidden = true

onready var pounce_tween = $PounceTween
onready var sprite = $Body/Sprite

var is_pouncing = false

func pounce_at_player():
	_pounce(Globals.player.position)

func _after_pounce():
	_pounce(position + velocity.normalized() * AFTER_POUNCE_DISTANCE)

func _pounce(target_position : Vector2):
	var diff = (target_position - position)
	velocity = diff.normalized() * POUNCE_SPEED
	var pounce_duration = diff.length() / POUNCE_SPEED
	pounce_tween.interpolate_property(sprite, "position:y", sprite.position.y, sprite.position.y - 8, pounce_duration / 2.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	pounce_tween.interpolate_property(sprite, "position:y", sprite.position.y - 8, sprite.position.y, pounce_duration / 2.0, Tween.TRANS_SINE, Tween.EASE_IN, pounce_duration / 2.0)
	pounce_tween.interpolate_callback(self, pounce_duration, "_on_pounce_finished")
	pounce_tween.start()
	is_pouncing = true

func _on_pounce_finished():
	is_pouncing = false

func can_alert():
	return !is_hidden