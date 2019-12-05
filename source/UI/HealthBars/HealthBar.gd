extends Control

onready var bar_over = $BarOver
onready var bar_under = $BarBack
onready var tween = $Tween
onready var shaker = $Shaker

export (float) var shake_amplitude = 3.0

onready var reset_value = rect_position

func set_max_health(value):
	bar_over.max_value = value
	bar_under.max_value = value

func _on_health_updated(value):
	bar_over.value = value
	tween.interpolate_property(bar_under, "value", bar_under.value, value, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	shaker.start(self, "rect_position", reset_value, 0.2, 15, shake_amplitude)