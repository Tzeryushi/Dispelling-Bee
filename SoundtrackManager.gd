extends Node

onready var player := $AudioStreamPlayer

enum THEME {
	TITLE, MENU, BATTLE1, BATTLE2, BATTLE3, VICTORY, LOSS, INTRO
}

#dictionary to store all soundtracks with enum key
var track_list = {
	THEME.INTRO:preload("res://audio/soundtrack/handarth_intro.ogg"),
	THEME.BATTLE1:preload("res://audio/soundtrack/banjofight.ogg"),
	THEME.BATTLE3:preload("res://audio/soundtrack/battleGroovin.ogg"),
	THEME.VICTORY:preload("res://audio/soundtrack/victory.ogg")
}

var loaded_theme : int = THEME.INTRO

func play(theme:int):
	player.stop()
	loaded_theme = theme
	if track_list.has(loaded_theme):
		player.stream = track_list[loaded_theme]
		player.play()

func reset():
	player.play(0.0)

func play_at(time:float):
	#TODO: Catch for playing at unavailable time
	player.play(time)

func stop():
	if player.playing:
		player.stop()

func resume():
	if !player.playing:
		player.play()
