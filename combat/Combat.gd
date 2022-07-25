extends Node2D

#Script should instantiate enemy upon load in
#Should be passed character data from Main instantiation (player stats, enemy ref)
#Polls enemy for spell list and runs its attack cycle using embedded behaviour
#Ends encounter and sends a signal containing changes to player

#MAJOR TODO: Handle keyboard input for dispelling!
#Idea: Delegate tasks?

onready var player_spell_box = $GUI/PSContainer/PSpellText
onready var enemy_spell_box = $GUI/ESContainer/ESpellText
onready var spell_timer = $GUI/SpellTimer

onready var enemy_spells = $Enemy/EnemySpells #TEMPORARY! will pull from Enemy node after behavior is made

var next_spell_count = 0 #TEMPORARY! Behavior will be coded later
var current_enemy_spell = ""

var player_spell = ""
#TODO: pass reformatted enemy spell (with punct. rules and reverse)

var player_text_tags = "[center][wave]"

signal dispelled()

func _ready():
	next_spell()

#handle the keyboard input. Subject to change. Restrict keys with hash?
func _unhandled_input(event) -> void:
	if event is InputEventKey and event.is_pressed():
		if player_spell != null and not player_spell.empty() and event.scancode == KEY_BACKSPACE:
			player_spell.erase(player_spell.length() - 1, 1)
		else:
			var key_typed = PoolByteArray([event.unicode]).get_string_from_utf8()
			player_spell = player_spell + key_typed
		if player_spell != null:
			player_spell_box.bbcode_text = player_text_tags + player_spell
		if event.is_action_pressed("ui_accept"):
			spell(player_spell)
		#handle spell cast - should send a signal to player node? depends.
		#TODO: handle spell/dispell based on player spell list
		
func next_spell() -> void:
	#in the future, this will run a method from the enemy, which will determine the next spell based on individual factors.
	if range(enemy_spells.list.size()).has(next_spell_count):
		enemy_spell_box.bbcode_text = "[center]"+enemy_spells.list[next_spell_count]["Text"]
	else:
		next_spell_count = 0
		if range(enemy_spells.list.size()).has(next_spell_count):
			#bad! array is not set in enemy spells.
			print("Empty array in enemy spell list. Whoopsie.")
		enemy_spell_box.bbcode_text = "[center]"+enemy_spells.list[next_spell_count]["Text"]
	current_enemy_spell = enemy_spells.list[next_spell_count]
	spell_timer.set_timer(float(current_enemy_spell["Speed"]))
	next_spell_count += 1

#spell takes an input and formats it accordingly against the currently loaded enemy spell, and compares
#TODO: update in the future to compare against loaded player spells!
func spell(input:String) -> void:
	var e_spell = current_enemy_spell["Solve"]
	var p_spell = input.to_lower()
	if p_spell == e_spell:
		next_spell()
	player_spell = ""
	player_spell_box.bbcode_text = player_text_tags + player_spell


func _on_Timer_timeout():
	#TODO: Update with damage and so on
	next_spell()
