extends Node2D

class_name Enemy

#Implement spell cycle and damagers here
#Extend this script on child nodes to specify behavior
onready var enemy_stats = $EnemyStats
onready var enemy_spells = $EnemySpells
onready var image = $Sprite

var current_spell = 0
var default_spell = {"Text":"Oops...", "Tags":"[tornado]", "Solve":"spoo...", "Damage":1, "Drain":1, "Speed":15}
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

func get_tags() -> String:
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

func damage(value:int) -> void:
	enemy_stats.damage(value)
	pass

func get_health() -> int:
	return enemy_stats.get_health()
func get_max_health() -> int:
	return enemy_stats.get_max_health()
func get_cast_speed() -> float:
	return enemy_stats.get_cast_speed()

func flash_color(color:Color, flash_time = 0.5, flashes = 2) -> void:
	var tween = create_tween()
	for i in range(0, flashes):
		print("loop")
		tween.tween_property(image, "modulate", color, 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		tween.tween_property(image, "modulate", Color(1,1,1,1), 0.05).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
