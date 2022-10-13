extends Resource

class_name EnemySpell

export var name_list : Dictionary
export var name : String
export var solve : String
export var shake_tag : bool = false
export var wave_tag : bool = false
export var tornado_tag : bool = false
export var fade_tag : bool = false
export var rainbow_tag : bool = false
export var custom_tag : String = ""
export var damage : int = 1
export var drain : int = 1
export var speed : float = 15
export var animation : PackedScene
export var weight: int = 3

func get_random_key() -> String:
	var keys = name_list.keys()
	return keys[randi() % keys.size()]
