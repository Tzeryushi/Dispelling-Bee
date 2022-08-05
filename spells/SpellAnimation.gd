extends Node

class_name SpellAnimation

signal finished

var tween : Tween

func _ready() -> void:
	tween = Tween.new()
	add_child(tween)

func _play(attacker:Node2D, defender:Node2D) -> void:
	pass

func play(attacker:Node2D, defender:Node2D) -> Node:
	_play(attacker, defender)
	return self
