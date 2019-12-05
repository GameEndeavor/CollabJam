extends Weapon

const Fireball_PS = preload("res://Weapons/WeaponEntities/FireballEntity.tscn")

onready var fireball_entity
onready var cooldown_timer = $Cooldown

var emitting = false setget _set_emitting

func _ready():
	_spawn_fireball()

func attack() -> bool:
	if !is_attacking && emitting && fireball_entity.can_launch():
		is_attacking = true
		cooldown_timer.start()
		var pos = fireball_entity.global_position
		var rot = fireball_entity.global_rotation
		body.remove_child(fireball_entity)
		get_tree().current_scene.add_child(fireball_entity)
		fireball_entity.global_position = pos
		fireball_entity.global_rotation = rot
		fireball_entity.launch(position.angle())
		fireball_entity = null
		return true
	else:
		return false

func _spawn_fireball():
	fireball_entity = Fireball_PS.instance()
	body.add_child(fireball_entity)
	fireball_entity.damage_area.add_faction_exception(get_parent().faction)
	fireball_entity.particles.emitting = emitting

func _set_emitting(value):
	emitting = value
	fireball_entity.particles.emitting = value

func _on_Cooldown_timeout():
	_spawn_fireball()
	_attack_complete()