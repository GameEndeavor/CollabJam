extends Weapon

onready var attack_tween = $AttackTween

func _ready():
	damage_area = $Body/DamageArea
	damage_area.add_faction_exception(get_parent().faction)
	damage_area.monitoring = false

func attack() -> bool:
	if !is_attacking:
		is_attacking = true
		attack_tween.interpolate_property(body, "position:x", body.position.x, attack_range, attack_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		attack_tween.interpolate_property(body, "position:x", attack_range, body.position.x, attack_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT, attack_duration)
		attack_tween.interpolate_callback(self, attack_duration * 2, "_attack_complete")
		attack_tween.start()
		damage_area.monitoring = true
		$AttackSFX.play()
		return true
	else:
		return false

func _attack_complete():
	damage_area.monitoring = false
	._attack_complete()

func _on_DamageArea_entity_damaged(entity):
	if entity is Player:
		if !$PlayerHurt.playing:
			$PlayerHurt.play()
	else:
		if !$EnemyHurt.playing:
			$EnemyHurt.play()
