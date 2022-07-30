extends Node

var list = {"pew-pew":{"Damage":1,"Honey":3, "Name": "Pew-pew"}}


func add_spell(solve:String, damage:int, cost:int, name:String) -> void:
	list[solve]["Damage"] = damage
	list[solve]["Honey"] = cost
	list[solve]["Name"] = name

func has_spell(key:String) -> bool:
	if list.has(key):
		return true
	return false

func get_damage(key:String) -> int:
	if not list.has(key):
		print("Key not in dictionary. Uh-oh!")
		return -1
	return list[key]["Damage"]

func get_cost(key:String) -> int:
	if not list.has(key):
		print("Key not in dictionary. Uh-oh!")
		return -1
	return list[key]["Honey"]

func get_spell_name(key:String) -> String:
	if not list.has(key):
		print("Key not in dictionary. Uh-oh!")
		return "nope"
	return list[key]["Name"]
