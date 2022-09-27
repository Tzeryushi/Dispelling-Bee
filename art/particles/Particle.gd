class_name ParticleAnimation
extends Node

signal finished

func play() -> void:
	emit_signal("finished")
	pass
