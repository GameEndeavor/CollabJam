extends Node

var player setget ,_get_player
var first_level = true
var is_game_won = false

func _get_player():
	return player if is_instance_valid(player) else null

func reset():
	first_level = true
	is_game_won = false