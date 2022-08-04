extends Resource

class_name PlayerSpells

#Spellbooks in the future?
#This is just an idea for a way to keep track of spells.
#As spells are simply referenced and not changed, and they can only
#be added to a player*, it makes sense to have them globally accessible.

export(Array, Resource) var spell_list
export var list = {"pew-pew":{"Damage":1,"Honey":3, "Name": "Pew-pew"}}

func add_spell(solve:String, damage:int, cost:int, name:String) -> void:
	list[solve]["Damage"] = damage
	list[solve]["Honey"] = cost
	list[solve]["Name"] = name

func has_spell(key:String) -> int:
	for i in range(spell_list.size()):
		if spell_list[i].solve == key:
			return i
#	if list.has(key):
#		return true
	return -1

func get_damage(index:int) -> int:
	if index >= 0 and index < spell_list.size():
		return spell_list[index].damage
	return -1
#	if not list.has(key):
#		print("Key not in dictionary. Uh-oh!")
#		return -1
#	return list[key]["Damage"]

func get_cost(index:int) -> int:
	if index >= 0 and index < spell_list.size():
		return spell_list[index].cost
	return -1
#	if not list.has(key):
#		print("Key not in dictionary. Uh-oh!")
#		return -1
#	return list[key]["Honey"]

func get_spell_name(index:int) -> String:
	if index >= 0 and index < spell_list.size():
		return spell_list[index].name
	return "nope"
#	if not list.has(key):
#		print("Key not in dictionary. Uh-oh!")
#		return "nope"
#	return list[key]["Name"]
