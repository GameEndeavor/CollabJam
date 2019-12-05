extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

onready var duration_timer = $Duration
onready var frequency_timer = $Frequency
onready var shake_tween = $ShakeTween

var amplitude = 0
var priority = 0
var obj = null
var property = null
var reset_value

func start(obj, property, reset_value, duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	if priority >= self.priority:
		self.priority = priority
		self.amplitude = amplitude
		self.obj = obj
		self.property = property
		self.reset_value = reset_value
		
		duration_timer.wait_time = duration
		frequency_timer.wait_time = 1 / float(frequency)
		duration_timer.start()
		frequency_timer.start()
		
		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	shake_tween.interpolate_property(obj, property, obj.get(property), reset_value + rand, frequency_timer.wait_time, TRANS, EASE)
	shake_tween.start()

func _reset():
	shake_tween.interpolate_property(obj, property, obj.get(property), reset_value, frequency_timer.wait_time, TRANS, EASE)

func _on_Frequency_timeout():
	_new_shake()

func _on_Duration_timeout():
	_reset()
	frequency_timer.stop()
