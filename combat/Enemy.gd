extends Node2D

#Implement spell cycle and damagers here
#Extend this script on child nodes to specify behavior
onready var enemy_spells = $EnemySpells

var current_spell = 0
var default_spell = {"Text":"[tornado]Oops...", "Solve":"spoo...", "Damage":1, "Drain":1, "Speed":15}
#we need functions for the following:
#current spell text
#current spell solve
#spell dispel charge amount
#spell damage
#spell cast speed
#cycling to the next spell
#While we could simply pass the dictionary to the combat script,
#it's cleaner to decouple the code and virtualize the behavior here
#Additionally, this allows us to create individualized dictionaries
#based on enemy behavior without the risk of breaking coupled code.

func get_text() -> String:
	return "Not implemented"

func get_solve() -> String:
	return "Not implemented"

func get_drain() -> int:
	return -1
	
func get_damage() -> int:
	return -1
	
func get_speed() -> int:
	return -1

func next_spell() -> void:
	#implement specific behavior to get the next spell
	#should I pass a reference to player stats in here? Food for thought.
	pass
