extends Node2D
class_name Weapon

export (float) var attack_range = 3.0 * 16
export (float) var attack_duration = 0.1

onready var damage_area = $DamageArea
onready var attack_tween = $AttackTween

var is_attacking = false

func _ready():
	damage_area.monitoring = false

func attack() -> bool:
	if !is_attacking:
		is_attacking = true
		attack_tween.interpolate_property(self, "position:x", position.x, attack_range, attack_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		attack_tween.interpolate_property(self, "position:x", attack_range, position.x, attack_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT, attack_duration)
		attack_tween.interpolate_callback(self, attack_duration * 2, "_attack_complete")
		attack_tween.start()
		damage_area.monitoring = true
		return true
	else:
		return false

func _attack_complete():
	is_attacking = false
	damage_area.monitoring = false