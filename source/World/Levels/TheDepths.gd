extends "res://World/Level.gd"

onready var objective = $Tilemaps/Decor/Entities/Objective

func _process(delta):
	if !Globals.is_game_won && objective.get_child_count() == 0:
		Globals.is_game_won = true
		for hostage in get_tree().get_nodes_in_group("hostages"):
			hostage.celebrate()
		Globals.player.has_control = false
		Globals.player.velocity = Vector2.ZERO
		yield(get_tree().create_timer(3.0), "timeout")
		Effects.scene_changer.fade_out()
		yield(Effects.scene_changer, "animation_finished")
		get_tree().change_scene("res://Victory.tscn")
		Globals.reset()
		set_process(false)