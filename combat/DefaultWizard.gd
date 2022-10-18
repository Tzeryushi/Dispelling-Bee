extends Enemy

onready var sprite = $Sprite

var first_spell = true
var first_spell_index = 0

var spell_key = ""

func _ready() -> void:
	next_spell()

func dict_pull(key:String) -> String:
	#returns value of a key in the current spell
	#yeah this isn't a great name but it's funny leave me alone
	if not range(enemy_spells.list.size()).has(current_spell) or current_spell == null:
		print("Enemy spells not loaded, or spell list is empty")
		return default_spell[key]
	else:
		return enemy_spells.list[current_spell][key]

func get_text() -> String:
	return enemy_spells.get_text(current_spell, spell_key)

func get_tags() -> String:
	return enemy_spells.get_tags(current_spell)

func get_solve() -> String:
	return enemy_spells.get_solve(current_spell, spell_key)

func get_drain() -> int:
	return enemy_spells.get_drain(current_spell)
	
func get_damage() -> int:
	return enemy_spells.get_damage(current_spell)
	
func get_speed() -> float:
	return enemy_spells.get_speed(current_spell)

func _get_weighted_index() -> int:
	if enemy_spells.spell_list.size() == 1:
		return 0
	var weighted_array = []
	for i in range(enemy_spells.spell_list.size()):
#		if i == spell_index:
#			weighted_array.append(0.0)
#		else:
		weighted_array.append(enemy_spells.spell_list[i].weight)
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
	#implement specific behavior to get the next spell
	#should I pass a reference to player stats in here? Food for thought.
#	if first_spell:
#		randomize()
#		current_spell = randi() % enemy_spells.spell_list.size()
#		first_spell = false
#		return
#	var next_spell = current_spell
#	while current_spell == next_spell:
#		next_spell = randi() % enemy_spells.spell_list.size()
#	current_spell = next_spell
	
	if first_spell:
		if first_spell_index >= 0:
			current_spell = first_spell_index
			spell_key = enemy_spells.spell_list[current_spell].get_random_key()
			first_spell = false
			return
		else:
			randomize()
			current_spell = randi()%enemy_spells.spell_list.size()
			spell_key = enemy_spells.spell_list[current_spell].get_random_key()
			first_spell = false
			return
	#TODO: weighted algo
	current_spell = _get_weighted_index()

	var new_key = enemy_spells.spell_list[current_spell].get_random_key()
	if enemy_spells.spell_list[current_spell].name_list.size() > 1:
		while new_key == spell_key:
			new_key = enemy_spells.spell_list[current_spell].get_random_key()
	spell_key = new_key

func get_spell_animation() -> PackedScene:
	return enemy_spells.get_spell_animation(current_spell)
	
func attack() -> void:
	sprite.attack()
	
func attack2() -> void:
	sprite.attack2()

func hurt() -> void:
	#$OuchShort.play()
	sprite.hurt()
	#TODO: hurt animation. Tweens?

func _on_EnemyStats_damaged():
	hurt() # Replace with function body.
	print("oauch")
