extends Resource

class_name SpellModel

export var name_list : Dictionary
export var name : String
export var solve : String
export var damage : int = 1
export var cost : int = 3
export var animation : PackedScene
export var weight : int = 3

func get_random_key() -> String:
	var keys = name_list.keys()
	return keys[randi() % keys.size()]
