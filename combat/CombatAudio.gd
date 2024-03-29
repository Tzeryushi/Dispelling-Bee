extends Node

onready var speech_player = $SpeechPlayer

func play_speech(key:String) -> bool:
	if speech_player.lookup_and_queue(key):
		return true
	return false
