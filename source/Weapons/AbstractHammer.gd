extends Weapon

onready var animation_player = $AttackAnimator

func _ready():
	damage_area = $Body/DamageArea
	damage_area.add_faction_exception(get_parent().faction)
	damage_area.monitoring = false

func attack() -> bool:
	if !is_attacking:
		is_attacking = true
		animation_player.play("attack")
		damage_area.monitoring = true
		$AttackSFX.play()
		return true
	else:
		return false

func _attack_complete():
	damage_area.monitoring = false
	._attack_complete()

func _on_AttackAnimator_animation_finished(anim_name):
	if anim_name == "attack":
		_attack_complete()

func _on_DamageArea_entity_damaged(entity):
	if !$PlayerHurt.playing:
		$PlayerHurt.play()