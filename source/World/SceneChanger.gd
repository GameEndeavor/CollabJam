extends Node

signal animation_finished()

onready var animation_player : AnimationPlayer = get_node("../AnimationPlayer")

func change_scene(scene_path : String, spawn_id : int, delay : float = 0.0):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("background_fade")
	yield(animation_player, "animation_finished")
	get_tree().change_scene(scene_path)
	yield(get_tree(), "idle_frame")
#	get_tree().current_scene.spawn_player(spawn_id)
	animation_player.play_backwards("background_fade")
	yield(animation_player, "animation_finished")

func fade_in():
	animation_player.play_backwards("background_fade")
	yield(animation_player, "animation_finished")
	emit_signal("animation_finished")

func fade_out():
	animation_player.play("background_fade")
	yield(animation_player, "animation_finished")
	emit_signal("animation_finished")