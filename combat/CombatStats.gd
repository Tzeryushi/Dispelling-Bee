extends Node

signal health_changed(old_value, new_value)
signal honey_changed(old_value, new_value)

signal honey_overfill()
signal honey_not_enough()

var health : int = 1
var max_health : int = 10
var honey : int = 1
var max_honey : int = 5

func can_afford(cost:int) -> bool:
	if honey - cost >= 0:
		return true
	emit_signal("honey_not_enough")
	return false

func change_honey(value) -> void:
	var old = honey
	if honey + value > max_honey:
		emit_signal("honey_overfill")
	honey = clamp((honey + value), 0, max_honey)
	emit_signal("honey_changed", old, honey)

func change_health(value) -> void:
	var old = health
	health = clamp((health+value), 0, max_health)
	emit_signal("health_changed", old, health)

func damage(value) -> void:
	var old = health
	value = abs(value)
	if health - value < 0:
		health = 0
	else:
		health -= value
	emit_signal("health_changed", old, health)
