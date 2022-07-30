extends Node

export var health : int = 5
export var max_life : int = 10
export var cast_speed : float = 1.0 #a multiplier based on circumstance

#TODO: damage/heal, getters and setters
#Try to control this implementation through the Enemy script
func damage(value:int) -> void:
	var old = health
	value = abs(value)
	if health - value < 0:
		health = 0
	else:
		health -= value

func get_health() -> int:
	return health

func get_max_health() -> int:
	return max_life

func get_cast_speed() -> float:
	return cast_speed
