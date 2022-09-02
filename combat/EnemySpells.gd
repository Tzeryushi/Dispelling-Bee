extends Node

class_name EnemySpells

export(Array, Resource) var spell_list
export(Array, PackedScene) var anim_list

func get_text(index:int) -> String:
	return spell_list[index].name
func get_solve(index:int) -> String:
	return spell_list[index].solve
func get_tags(index:int) -> String:
	var final = ""
	if spell_list[index].shake_tag:
		final += "[shake]"
	if spell_list[index].wave_tag:
		final += "[wave]"
	if spell_list[index].tornado_tag:
		final += "[tornado]"
	if spell_list[index].fade_tag:
		final += "[fade]"
	if spell_list[index].rainbow_tag:
		final += "[rainbow]"
	final += spell_list[index].custom_tag
	return final
func get_damage(index:int) -> int:
	return spell_list[index].damage
func get_drain(index:int) -> int:
	return spell_list[index].drain
func get_speed(index:int) -> float:
	return spell_list[index].speed
func get_spell_animation(index:int) -> PackedScene:
	return spell_list[index].animation
