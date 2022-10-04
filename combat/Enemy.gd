extends Node2D

class_name Enemy

#Implement spell cycle and damagers here
#Extend this script on child nodes to specify behavior
onready var enemy_stats = $EnemyStats
onready var enemy_spells = $EnemySpells
onready var image = $Sprite

var current_spell = 0
var default_spell = {"Text":"Oops...", "Tags":"[tornado]", "Solve":"spoo...", "Damage":1, "Drain":1, "Speed":15}


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
func get_speed() -> float:
	return -1.0

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

func get_spell_animation() -> PackedScene:
	return null

func flash_color(color:Color, flash_time = 0.05, flashes = 2) -> void:
	pass
	var tween = create_tween()
	for _i in range(0, flashes):
		tween.tween_property(image, "modulate", color, flash_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		tween.tween_property(image, "modulate", Color(1,1,1,1), flash_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func attack() -> void:
	pass

func hurt() -> void:
	pass
