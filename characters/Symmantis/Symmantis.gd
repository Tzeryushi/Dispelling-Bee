extends "res://combat/DefaultWizard.gd"

export var base_switch_percent := 0.5

var symmetric := true
var switch_counter := 0
var current_list = enemy_spells

var asym_spells

#TODO:
#Implement next_spell() - this should also include switch counter
	#should channel when the switch is made
#custom weighted index spell (pass in spell list as parameter)

func get_text() -> String:
	return current_list.get_text(current_spell, spell_key)

func get_tags() -> String:
	return current_list.get_tags(current_spell)

func get_solve() -> String:
	return current_list.get_solve(current_spell, spell_key)

func get_drain() -> int:
	return current_list.get_drain(current_spell)
	
func get_damage() -> int:
	return current_list.get_damage(current_spell)
	
func get_speed() -> float:
	return current_list.get_speed(current_spell)

func _get_weighted_index() -> int:
	if current_list.spell_list.size() == 1:
		return 0
	var weighted_array = []
	for i in range(current_list.spell_list.size()):
#		if i == spell_index:
#			weighted_array.append(0.0)
#		else:
		weighted_array.append(current_list.spell_list[i].weight)
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
		#this is often run before the node fully initializes, so we set our references here
		asym_spells = $AsymSpells
		#should draw from normal spell list on first propagation
		current_list = enemy_spells
		if first_spell_index >= 0:
			current_spell = first_spell_index
			spell_key = current_list.spell_list[current_spell].get_random_key()
			first_spell = false
			return
		else:
			randomize()
			current_spell = randi()%current_list.spell_list.size()
			spell_key = current_list.spell_list[current_spell].get_random_key()
			first_spell = false
			return
	else:
		#increase chance of swap by an cubic percent increase for each spell cast
		#1.4496 - 8.136x + 5.1995x2 or so
		#or 50/50? needs playtesting
		randomize()
		if (randf() < (pow(switch_counter,2)*.052 + switch_counter*0.082 + 0.015)/2):
			swap_mode()
	
	current_spell = _get_weighted_index()

	var new_key = current_list.spell_list[current_spell].get_random_key()
	if current_list.spell_list[current_spell].name_list.size() > 1:
		while new_key == spell_key:
			new_key = current_list.spell_list[current_spell].get_random_key()
	spell_key = new_key
	switch_counter += 1

func get_spell_animation() -> PackedScene:
	return current_list.get_spell_animation(current_spell)
	
func attack() -> void:
	if current_list.get_animation_index(current_spell) == 1:
		attack2()
	else:
		sprite.attack()

func swap_mode() -> void:
	symmetric = !symmetric
	switch_counter = 0
	if symmetric:
		current_list = enemy_spells
	else:
		current_list = asym_spells
	
	#send proper data to sprite animations
	if sprite.get_mode() != symmetric:
		sprite.swap_mode()
		sprite.channel()	#we use channel here to reuse naming architecture. Not necessary, though.
