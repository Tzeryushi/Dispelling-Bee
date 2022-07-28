extends "res://combat/Enemy.gd"


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
	current_spell = randi() % enemy_spells.list.size()
