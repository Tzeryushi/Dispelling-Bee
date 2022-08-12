extends Enemy

var first_spell = true
var first_spell_index = 2

func dict_pull(key:String) -> String:
	#returns value of a key in the current spell
	#yeah this isn't a great name but it's funny leave me alone
	if not range(enemy_spells.list.size()).has(current_spell) or current_spell == null:
		return default_spell[key]
		print("Enemy spells not loaded, or spell list is empty")
	else:
		return enemy_spells.list[current_spell][key]

func get_text() -> String:
	return dict_pull("Text")

func get_solve() -> String:
	return dict_pull("Solve")

func get_drain() -> int:
	return int(dict_pull("Drain"))
	
func get_damage() -> int:
	return int(dict_pull("Damage"))
	
func get_speed() -> int:
	return int(dict_pull("Speed"))

func next_spell() -> void:
	#implement specific behavior to get the next spell
	#should I pass a reference to player stats in here? Food for thought.
	if first_spell:
		current_spell = first_spell_index
		first_spell = false
		return
	var next_spell = current_spell
	while current_spell == next_spell:
		next_spell = randi() % enemy_spells.list.size()
	current_spell = next_spell
