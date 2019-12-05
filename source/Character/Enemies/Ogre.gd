extends Enemy

func _ready():
	_set_weapon($Hammer)

func telegraph_attack():
	weapon.animation_player.play("telegraph")