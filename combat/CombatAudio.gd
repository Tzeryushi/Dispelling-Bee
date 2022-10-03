extends Node

onready var speech_player = $SpeechPlayer

onready var groovin_bgm = $Groovin

var loaded_bgm : AudioStreamPlayer

#TODO: BGM loading and slow, pitch, stutter effects

func _ready():
	loaded_bgm = groovin_bgm

func play_speech(key:String) -> bool:
	if speech_player.lookup_and_queue(key):
		return true
	return false

func set_bgm(player:AudioStreamPlayer) -> void:
	loaded_bgm = player

func reset_bgm() -> void:
	loaded_bgm.play(0.0)

func play_bgm() -> void:
	loaded_bgm.play()

func pause_bgm() -> void:
	loaded_bgm.stop()
