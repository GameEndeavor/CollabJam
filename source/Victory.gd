extends Node2D

func _ready():
	Effects.scene_changer.fade_in()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Effects.scene_changer.change_scene("res://World/Levels/FirstEncounter.tscn", 0)