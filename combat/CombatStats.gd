extends Node

signal health_changed(old_value, new_value)

var health : int = 1
var max_health : int = 10
var honey : int = 1
var max_honey : int = 5

func change_honey(value) -> void:
	if honey + value > max_honey:
		honey = max_honey
	elif honey + value < 0:
		honey = 0
	else:
		honey += value

func change_health(value) -> void:
	var old = health
	if health + value > max_health:
		health = max_health
	elif health + value < 0:
		health = 0
	else:
		health += value
	emit_signal("health_changed", old, health)

func damage(value) -> void:
	var old = health
	value = abs(value)
	if health - value < 0:
		health = 0
	else:
		health -= value
	emit_signal("health_changed", old, health)
