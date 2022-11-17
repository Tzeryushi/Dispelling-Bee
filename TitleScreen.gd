extends Node2D

signal game_start

var theme = SoundtrackManager.THEME.TITLE

func _input(event) -> void:
	if event.is_action_pressed("ui_accept"):
		emit_signal("game_start")
