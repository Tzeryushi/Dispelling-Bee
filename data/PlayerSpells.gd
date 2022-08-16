extends Resource

class_name PlayerSpells

#Spellbooks in the future?
var spell_index : int = 0
var first_spell : bool = true
export var first_spell_index : int = 2

export(Array, Resource) var spell_list
#export var list = {"pew-pew":{"Damage":1,"Honey":3, "Name": "Pew-pew"}}

#func add_spell(solve:String, damage:int, cost:int, name:String) -> void:
#	list[solve]["Damage"] = damage
#	list[solve]["Honey"] = cost
#	list[solve]["Name"] = name

func next_spell() -> void:
	if first_spell:
		spell_index = first_spell_index
		first_spell = false
		return
	var next_spell = spell_index
	while spell_index == next_spell:
		next_spell = randi() % spell_list.size()
	spell_index = next_spell

func validate(key:String) -> bool:
	if key == spell_list[spell_index].solve:
		return true
	else:
		return false

func has_spell(key:String) -> int:
	for i in range(spell_list.size()):
		if spell_list[i].solve == key:
			return i
	return -1

func get_damage() -> int:
	return spell_list[spell_index].damage

func get_index_damage(index:int) -> int:
	if index >= 0 and index < spell_list.size():
		return spell_list[index].damage
	return -1

func get_cost() -> int:
	return spell_list[spell_index].cost

func get_index_cost(index:int) -> int:
	if index >= 0 and index < spell_list.size():
		return spell_list[index].cost
	return -1

func get_spell_name() -> String:
	return spell_list[spell_index].name

func get_index_spell_name(index:int) -> String:
	if index >= 0 and index < spell_list.size():
		return spell_list[index].name
	return "nope"
