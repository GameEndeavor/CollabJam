extends Node2D

const PlayerPS = preload("res://Character/Player.tscn")

onready var spawn = $SpawnPoints/Spawnpoint
onready var entities = $Tilemaps/Decor/Entities

func _ready():
	var player = PlayerPS.instance()
	entities.add_child(player)
	player.global_position = spawn.global_position