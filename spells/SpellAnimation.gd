extends Node

class_name SpellAnimation

export var hit_particles : PackedScene

signal hit
signal finished

func _ready() -> void:
	pass

func _play(attacker:Node2D, defender:Node2D) -> void:
	pass

func play(attacker:Node2D, defender:Node2D) -> Node:
	_play(attacker, defender)
	return self
