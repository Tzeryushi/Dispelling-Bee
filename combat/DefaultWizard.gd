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
	return enemy_spells.get_text(current_spell)

func get_tags() -> String:
	return enemy_spells.get_tags(current_spell)

func get_solve() -> String:
	return enemy_spells.get_solve(current_spell)

func get_drain() -> int:
	return enemy_spells.get_drain(current_spell)
	
func get_damage() -> int:
	return enemy_spells.get_damage(current_spell)
	
func get_speed() -> float:
	return enemy_spells.get_speed(current_spell)

func next_spell() -> void:
	#implement specific behavior to get the next spell
	#should I pass a reference to player stats in here? Food for thought.
	if first_spell:
		current_spell = first_spell_index
		first_spell = false
		return
	var next_spell = current_spell
	while current_spell == next_spell:
		next_spell = randi() % enemy_spells.spell_list.size()
	current_spell = next_spell

func get_spell_animation() -> PackedScene:
	return enemy_spells.get_spell_animation(current_spell)
