extends CanvasLayer

onready var animation_player = $AnimationPlayer
onready var scene_changer = $SceneChanger

func _on_player_death():
	Engine.time_scale = 0.33
	animation_player.play("death_fade")
	yield(animation_player, "animation_finished")
	get_tree().reload_current_scene()
	Engine.time_scale = 1.0
	$Control/Grayscale.self_modulate.a = 0
	scene_changer.fade_in()

func _on_win_game():
	pass