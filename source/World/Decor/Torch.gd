extends StaticBody2D

func _ready():
	var duration = $AnimationPlayer.current_animation.length()
	$AnimationPlayer.seek(duration * randf())