extends Node2D

#Script should instantiate enemy upon load in
#Should be passed character data from Main instantiation (player stats, enemy ref)
#Polls enemy for spell list and runs its attack cycle using embedded behaviour
#Ends encounter and sends a signal containing changes to player

#MAJOR TODO: Handle keyboard input for dispelling!
#Idea: Delegate tasks?

#TODO: load stats dynamically - won't necessarily be the same file in the future
export var player_ref : Resource

#player nodes
onready var player_spell_box = $GUI/PSContainer/PSpellText
onready var player_stats = $Player/CombatStats
onready var player_health = $GUI/PlayerHealth
onready var player_honey_count = $GUI/HoneyCounter

#enemy nodes
onready var enemy_spell_box = $GUI/ESContainer/ESpellText
onready var enemy_health = $GUI/EnemyHealth
onready var spell_timer = $GUI/SpellTimer
onready var enemy_pos = $EnemyLoad

#temp nodes for protoyping
var enemy #TODO: MUST CHANGE! Needs a proper load in after pass from Main layer. Also error checking.

var player_spell = "" #current string input from player
#TODO: handle unhandled input from symbols not supported by fonts

var player_text_tags = "[center][wave]"

signal dispelled()

func _ready():
	#TODO: is it better to just handle this all from the resource? consult.
	player_stats.health = player_ref.health
	player_stats.max_health = player_ref.max_health
	player_stats.honey = player_ref.honey
	player_stats.max_honey = player_ref.max_honey
	player_health.max_value = player_stats.max_health
	player_health.value = player_stats.health
	player_honey_count.setup(player_stats.max_honey, player_stats.honey)

func _exit_tree():
	if not enemy == null:	
		enemy.queue_free()
	pass

func setup(new_enemy:PackedScene) -> void:
	enemy = new_enemy.instance()
	enemy_pos.add_child(enemy)
	enemy.show()
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
	enemy.next_spell()
	enemy_spell_box.bbcode_text = "[center]"+enemy.get_text()
	spell_timer.set_timer(float(enemy.get_speed()))

#spell takes an input and formats it accordingly against the currently loaded enemy spell, and compares
#TODO: update in the future to compare against loaded player spells!
func spell(input:String) -> void:
	var e_spell = enemy.get_solve()
	var p_spell = input.to_lower()
	if p_spell == e_spell:
		player_stats.change_honey(enemy.get_drain())
		next_spell()
	player_spell = ""
	player_spell_box.bbcode_text = player_text_tags + player_spell


func _on_Timer_timeout():
	#TODO: Update with damage and so on - subject to change!
	player_stats.damage(enemy.get_damage())
	next_spell()


func _on_CombatStats_health_changed(old_value, new_value):
	#TODO: might just incept this into a script for the health bar instead of clogging this up
	player_health.value = new_value
