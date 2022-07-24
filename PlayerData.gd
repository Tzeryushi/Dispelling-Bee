extends Node

export var health : int = 5
export var max_health : int = 10
export var honey : int = 0
export var max_honey : int = 5

#TODO: add player image
#TODO: add player input name
#FEATURE: level system
#TODO: add spellbook (new node?)

#holds player data. Ref is held in Main and used to populate combat
#TODO: getters and setters. Main will alter data after receiving signal upon end of combat
#Problem: should signals be sent from here or main to update out of combat UI?

func level_out() -> void:
	if health > max_health:
		health = max_health
	if honey > max_honey:
		honey = max_honey

func get_health() -> int:
	return health

func get_honey() -> int:
	return honey

func take_damage(value) -> void:
	value = abs(value)
	if health-value >= 1:
		health -= value

func heal(value) -> void:
	value = abs(value)
	if health+value <= max_health:
		health += value
	else:
		health = max_health

func update_honey(value) -> void:
	honey = value
	level_out()
	
func add_honey(value) -> void:
	if honey+value < 0:
		honey = 0
	elif honey+value > max_honey:
		honey = max_honey
	else:
		honey += value
