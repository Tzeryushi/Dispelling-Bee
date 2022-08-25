extends Node2D

#Script should instantiate enemy upon load in
#Should be passed character data from Main instantiation (player stats, enemy ref)
#Polls enemy for spell list and runs its attack cycle using embedded behaviour
#Ends encounter and sends a signal containing changes to player

#MAJOR TODO: Handle keyboard input for dispelling!
#Idea: Delegate tasks?

#TODO: load stats dynamically - won't necessarily be the same file in the future
export var player_ref : Resource
export var player_spell_ref : Resource

#player nodes
onready var player = $Player
onready var player_spell_box = $GUI/PSContainer
onready var player_stats = $Player/CombatStats
onready var player_slist = $Player/CombatSpells
onready var player_health = $GUI/PlayerHealth
onready var player_honey_count = $GUI/HoneyCounter
onready var honey_timer = $GUI/HoneyCounter/HoneyProgress/HoneyTimer
onready var spellbook = $GUI/SpellbookContainer
onready var spell_position = $Player/SpellPos

#enemy nodes
onready var enemy_spell_box = $GUI/ESContainer
onready var enemy_health = $GUI/EnemyHealth
onready var spell_timer = $GUI/SpellTimer
onready var enemy_pos = $EnemyLoad
onready var enemy_target = $EnemyLoad/SpellTarget

#temp nodes for protoyping
var enemy #TODO: MUST CHANGE! Needs a proper load in after pass from Main layer. Also error checking.

var is_casting : bool = false
var player_spell = "" #current string input from player
#TODO: handle unhandled input from symbols not supported by fonts
var allowed_chars = {" ":" ","q":"q","w":"w","e":"e","r":"r","t":"t","y":"y","u":"u","i":"i","o":"o","p":"p",
"a":"a","s":"s","d":"d","f":"f","g":"g","h":"h","j":"j","k":"k","l":"l","z":"z","x":"x","c":"c","v":"v",
"b":"b","n":"n","m":"m",",":",",".":".","/":"/",";":";",":":":","'":"'","!":"!","?":"?","-":"-","_":"_",
"Q":"Q","W":"W","E":"E","R":"R","T":"T","Y":"Y","U":"U","I":"I","O":"O","P":"P","A":"A","S":"S","D":"D",
"F":"F","G":"G","H":"H","J":"J","K":"K","L":"L","Z":"Z","X":"X","C":"C","V":"V","B":"B","N":"N","M":"M",
"1":"1","2":"2","3":"3","4":"4","5":"5","6":"6","7":"7","8":"8","9":"9","0":"0"}

export var normal_color : Color = Color(1,1,1,1)
export var correct_color : Color = Color (0,1,0,1)
export var b_correct_color : Color = Color (1,0,1,1)
var player_text_tags = "[center][shake]"
var enemy_text_tags = "[center]"
var spellbook_tags = "[center][wave amp=100 freq=2]"
var e_spell_matching = false	#if the current player spell matches a portion of the enemy spell
var b_spell_matching = false	#if the current player spell matches a portion of the book spell

signal dispelled()
signal enemy_defeated()
signal player_defeated()

func _ready():
	#TODO: is it better to just handle this all from the resource? consult.
	player_stats.health = player_ref.health
	player_stats.max_health = player_ref.max_health
	player_stats.honey = player_ref.honey
	player_stats.max_honey = player_ref.max_honey
	
	player_health.max_value = 1000
	player_health.value = int(float(player_stats.health)/float(player_stats.max_health)*float(player_health.max_value))
	player_honey_count.setup(player_stats.max_honey, player_stats.honey)
	
	honey_timer.start()

func _exit_tree():
	if not enemy == null:	
		enemy.queue_free()
	pass

func setup(new_enemy:PackedScene) -> void:
	enemy = new_enemy.instance()
	enemy_pos.add_child(enemy)
	enemy.show()
	enemy_health.max_value = 1000
	enemy_health.value = int((float(enemy.get_health())/float(enemy.get_max_health()))*enemy_health.max_value)
	next_spell()
	next_player_spell()

#handle the keyboard input.
func _unhandled_input(event) -> void:
	if is_casting:
		return
	if event is InputEventKey and event.is_pressed():
		if player_spell != null and not player_spell.empty() and event.scancode == KEY_BACKSPACE:
			player_spell.erase(player_spell.length() - 1, 1)
			color_spells(player_spell)
			if player_spell != null:
				player_spell_box.set_text(player_text_tags + player_spell) #player_text_tags
		elif allowed_chars.has(PoolByteArray([event.unicode]).get_string_from_utf8()): #checking list of allowed keys
			var key_typed = PoolByteArray([event.unicode]).get_string_from_utf8()
			player_spell = player_spell + key_typed
			color_spells(player_spell)
			if player_spell != null:
				player_spell_box.set_text(player_text_tags + player_spell) #player_text_tags
		if event.is_action_pressed("ui_accept"):
			#TODO: Animation for casts, and backfires.
			spell(player_spell)
		#handle spell cast - should send a signal to player node? depends.
		#TODO: handle spell/dispell based on player spell list
		
func next_spell() -> void:
	#in the future, this will run a method from the enemy, which will determine the next spell based on individual factors.
	enemy.next_spell()
	enemy_spell_box.set_text(enemy_text_tags+enemy.get_tags()+enemy.get_text())
	spell_timer.set_timer(float(enemy.get_speed()))
	color_spells(player_spell)
	player_spell_box.set_text(player_text_tags + player_spell)
	
func next_player_spell() -> void:
	player_spell_ref.next_spell()
	spellbook.set_text(spellbook_tags+player_spell_ref.get_spell_name())
	var holdstr = "[center]"+String(player_spell_ref.get_cost())
	spellbook.set_cost(holdstr)
	color_spells(player_spell)
	player_spell_box.set_text(player_text_tags + player_spell)

#spell takes an input and formats it accordingly against the currently loaded enemy spell, and compares
#TODO: update in the future to compare against loaded player spells!
func spell(input:String) -> void:
	var p_spell = input.to_lower()
	#var spell_index = player_spell_ref.has_spell(p_spell)
	if player_spell_ref.validate(p_spell):
		#check if player has enough honey
		var cost = player_spell_ref.get_cost()
		if player_stats.can_afford(cost):
			is_casting = true
			#charge player and damage enemy
			player_stats.change_honey(-cost)
			var anim = player_spell_ref.spell_list[player_spell_ref.has_spell(p_spell)].animation.instance()
			add_child(anim)
			player_spell = ""
			player_spell_box.set_text(player_text_tags + player_spell)
			next_player_spell()
			anim.play(spell_position, enemy_target)
			is_casting = false
			yield(anim, "hit")
			enemy.flash_color(Color(1,0.1,0.1,1), 0.04, 2)
			Globals.camera.shake(300, 0.1)
			damage_enemy(player_spell_ref.get_damage())
			if enemy_health.value <= 0:
				#TODO: this is only so that fields that are deleted upon scene swap are not set
				#Delete this once transitions are in place.
				anim.queue_free()
				return
			else:
				#this is a dirty audio buffer for sounds that continue to play after a spell "hits"
				#consider refactoring in the future
				yield(anim, "finished")
				anim.queue_free()
		else:
			#no honey
			player_spell_box.flash_honey_notice()
			player_spell = ""
			player_spell_box.set_text(player_text_tags + player_spell)
	else:
		var e_spell = enemy.get_solve()
		if p_spell == e_spell:
			player_stats.change_honey(enemy.get_drain())
			next_spell()
		player_spell = ""
		player_spell_box.set_text(player_text_tags + player_spell)

func color_spells(input:String) -> void:
	#color the spell text if it lines up with enemy spells
	var e_spell = enemy.get_solve()
	var book_spell = player_spell_ref.get_solve()
	var p_spell = input.to_lower()
	if p_spell.length() == 0:
		if e_spell_matching:
			enemy_spell_box.change_text_color(normal_color)
			e_spell_matching = false
		if b_spell_matching:
			spellbook.change_text_color(normal_color)
			b_spell_matching = false
		player_spell_box.change_text_color(normal_color)
		player_text_tags = player_text_tags.replace("[rainbow]","")
		return
	var digit = 0
	var e_match = true
	var b_match = true
	for i in p_spell:
		if i != e_spell.substr(digit, 1):
			e_match = false
		if i != book_spell.substr(digit, 1):
			b_match = false
		digit += 1
	if e_match:
		if !e_spell_matching:
			enemy_spell_box.change_text_color(correct_color)
		#enemy_spell_box.set_text(enemy_text_tags + enemy.get_tags() + enemy.get_text().insert(e_spell.length()-p_spell.length(), "[color=#"+correct_color.to_html()+"]") + "[/color]")
		if p_spell.length() == e_spell.length():
			player_spell_box.change_text_color(normal_color)
			player_text_tags += "[rainbow]"
		else:
			player_spell_box.change_text_color(correct_color)
			player_text_tags = player_text_tags.replace("[rainbow]","")
		e_spell_matching = true
	if b_match:
		if !b_spell_matching:
			spellbook.change_text_color(b_correct_color)
		#spellbook.set_text(spellbook_tags + "[color=#"+b_correct_color.to_html()+"]" + player_spell_ref.get_spell_name().insert(p_spell.length(),"[/color]"))
		if p_spell.length() == book_spell.length():
			player_spell_box.change_text_color(normal_color)
			player_text_tags += "[rainbow]"
		else:
			player_spell_box.change_text_color(b_correct_color)
			player_text_tags = player_text_tags.replace("[rainbow]","")
		b_spell_matching = true
	if !e_match and e_spell_matching:
		#enemy_spell_box.set_text(enemy_text_tags+enemy.get_tags()+enemy.get_text())
		enemy_spell_box.change_text_color(normal_color)
		e_spell_matching = false
	elif !b_match and b_spell_matching:
		#spellbook.set_text(spellbook_tags+player_spell_ref.get_spell_name())
		spellbook.change_text_color(normal_color)
		b_spell_matching = false
	if !e_match and !b_match:
		player_spell_box.change_text_color(normal_color)
		player_text_tags = player_text_tags.replace("[rainbow]","")

func damage_enemy(value:int) -> void:
	#damages and receives changed value back from enemy
	#could have probably passed back new health through damage function, huh?
	#this is to avoid signal wackiness with instanced enemies - I'll figure that out later
	enemy.damage(value)
	var bar_value = int((float(enemy.get_health())/float(enemy.get_max_health()))*enemy_health.max_value)
	#enemy_health.value = enemy.get_health()
	enemy_health.animate_value(bar_value, 1.0)
	#TODO: win condition checking must sanitize any yields for animations and field updates first
	if enemy.get_health() <= 0:
		emit_signal("enemy_defeated")
		
func reverse_string(text:String) -> String:
	var rev_array = ""
	var digit = text.length() - 1
	for i in text:
		rev_array += text.substr(digit, 1)
		digit -= 1
	return rev_array

func _on_Timer_timeout() -> void:
	#TODO: Update with damage and so on - subject to change!
	player_stats.damage(enemy.get_damage())
	player.flash_color(Color(1,0,0,1))
	Globals.camera.shake(500, 0.3)
	if player_stats.health <= 0:
		emit_signal("player_defeated")
		return
	next_spell()

func _on_CombatStats_health_changed(old_value, new_value) -> void:
	#TODO: might just incept this into a script for the health bar instead of clogging this up
	var bar_value = int((float(new_value)/float(player_stats.max_health))*player_health.max_value)
	player_health.animate_value(bar_value, 1.0)
	#player_health.value = new_value

func _on_HoneyTimer_timeout():
	player_stats.change_honey(1)
