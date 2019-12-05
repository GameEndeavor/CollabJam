extends Node2D

const PlayerPS = preload("res://Character/Player.tscn")

onready var spawnpoints = $SpawnPoints
onready var entities = $Tilemaps/Decor/Entities
onready var player_health_bar = $UI/Interface/PlayerHealthBar

func _ready():
	if Globals.first_level:
		Effects.scene_changer.fade_in()
	spawn_player(0)
	Globals.first_level = false

func spawn_player(spawn_id : int):
	var spawn = spawnpoints.get_child(spawn_id)
	var player = PlayerPS.instance()
	entities.add_child(player)
	player.global_position = spawn.global_position