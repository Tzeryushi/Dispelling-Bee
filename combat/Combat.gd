extends Node2D

#Script should instantiate enemy upon load in
#Should be passed character data from Main instantiation (player stats, enemy ref)
#Polls enemy for spell list and runs its attack cycle using embedded behaviour
#Ends encounter and sends a signal containing changes to player

#MAJOR TODO: Handle keyboard input for dispelling!

onready var player_spell_box = $GUI/PSContainer/PSpellText
onready var enemy_spell_box = $GUI/ESContainer/ESpellText

var player_spell = ""
#TODO: pass reformatted enemy spell (with punct. rules and reverse)

var player_text_tags = "[wave]"


#handle the keyboard input. Subject to change. Restrict keys with hash?
func _unhandled_key_input(event) -> void:
	if not event.is_pressed():
		if player_spell != null and not player_spell.empty() and event.scancode == KEY_BACKSPACE:
			player_spell.erase(player_spell.length() - 1, 1)
		else:
			var key_typed = PoolByteArray([event.unicode]).get_string_from_utf8()
			player_spell = player_spell + key_typed
		if player_spell != null:
			player_spell_box.bbcode_text = player_text_tags + player_spell
		
		#handle spell cast - should send a signal to player node? depends.
