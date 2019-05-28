extends Area2D

export (float) var damage_amount = 1

var faction_exceptions = []

func add_faction_exception(faction):
	faction_exceptions.append(faction)

func _on_DamageArea_area_entered(hitbox):
	if hitbox is Hitbox:
		var entity = hitbox.entity
		if !faction_exceptions.has(entity.faction):
			entity.damage(damage_amount)
