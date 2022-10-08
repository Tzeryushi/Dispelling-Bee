extends Resource

class_name PlayerSpells

#Spellbooks in the future?
var spell_index : int = 0
var spell_key: String = ""
var first_spell : bool = true
export var first_spell_index : int = 1

export(Array, Resource) var spell_list
#export var list = {"pew-pew":{"Damage":1,"Honey":3, "Name": "Pew-pew"}}

#func add_spell(solve:String, damage:int, cost:int, name:String) -> void:
#	list[solve]["Damage"] = damage
#	list[solve]["Honey"] = cost
#	list[solve]["Name"] = name

func _get_weighted_index() -> int:
	if spell_list.size() == 1:
		return 0
	var weighted_array = []
	for i in range(spell_list.size()):
#		if i == spell_index:
#			weighted_array.append(0.0)
#		else:
		weighted_array.append(spell_list[i].weight)
	var prefix_array = []
	prefix_array.append(weighted_array[0])
	for i in range(1, weighted_array.size()):
		prefix_array.append(prefix_array[i-1]+weighted_array[i])
	randomize()
	var random = rand_range(0.0, prefix_array.back())
	var choose_index = 0
	for i in range(0, prefix_array.size()):
		if (prefix_array[i]>random):
			choose_index = i
			break
	return choose_index

func next_spell() -> void:
	if first_spell:
		if first_spell_index >= 0:
			spell_index = first_spell_index
			spell_key = spell_list[spell_index].get_random_key()
			first_spell = false
			return
		else:
			randomize()
			spell_index = randi()%spell_list.size()
			spell_key = spell_list[spell_index].get_random_key()
			first_spell = false
			return
	#TODO: weighted algo
	spell_index = _get_weighted_index()
#	var next_spell = spell_index
#	while spell_index == next_spell:
#		next_spell = randi() % spell_list.size()
#	spell_index = next_spell
	var new_key = spell_list[spell_index].get_random_key()
	while new_key == spell_key:
		new_key = spell_list[spell_index].get_random_key()
	spell_key = new_key

func validate(key:String) -> bool:
	if key == spell_list[spell_index].name_list[spell_key]:
		return true
	else:
		return false

func has_spell(key:String) -> int:
	for i in range(spell_list.size()):
		if spell_list[i].solve == key:
			return i
	return -1

func get_solve() -> String:
	return spell_list[spell_index].name_list[spell_key]

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
	return spell_key

func get_index_spell_name(index:int) -> String:
	if index >= 0 and index < spell_list.size():
		return spell_list[index].name
	return "nope"
