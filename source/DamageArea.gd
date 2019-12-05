extends Area2D

signal entity_damaged(entity)

export (float) var damage_amount = 1

var faction_exceptions = []

func add_faction_exception(faction):
	faction_exceptions.append(faction)

func _on_DamageArea_area_entered(hitbox):
	if hitbox is Hitbox && is_instance_valid(hitbox.entity):
		if !faction_exceptions.has(hitbox.entity.faction):
			hitbox.entity.damage(damage_amount)
			emit_signal("entity_damaged", hitbox.entity)
