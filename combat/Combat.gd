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
export(Array, PackedScene) var particle_array

#player nodes
onready var player = $Player
onready var player_spell_box = $GUI/PSContainer
onready var player_stats = $Player/CombatStats
onready var player_slist = $Player/CombatSpells
onready var player_health = $GUI/PlayerHealth
onready var player_honey_count = $GUI/HoneyCounter
onready var honey_timer = $GUI/HoneyCounter/HoneyProgress
onready var spellbook = $GUI/SpellbookContainer
onready var spell_position = $Player/SpellPos
onready var player_hit_position = $Player/HitPos

#enemy nodes
onready var enemy_spell_box = $GUI/ESContainer
onready var enemy_health = $GUI/EnemyHealth
onready var spell_timer = $GUI/SpellTimer
onready var enemy_pos = $EnemyLoad
onready var enemy_target = $EnemyLoad/SpellTarget

#GUI
onready var gui = $GUI
onready var ready_message = $GUI/ReadyMessage
onready var damage_popup = $GUI/DamagePopup
onready var pause_menu = $CanvasLayer/Pause

#Sound
onready var combat_audio = $CombatAudio

var enemy : Enemy #Passes ref from calling scene. TODO: MUST CHANGE! Needs error checking.

enum CombatState {LOADING, PLAYING, ENDING, TRANSITION}
var current_state

var is_casting := false
var enemy_casting := false
var is_finished := false
var player_spell = "" #current string input from player
#TODO: handle unhandled input from symbols not supported by fonts
var allowed_chars = {" ":" ","q":"q","w":"w","e":"e","r":"r","t":"t","y":"y","u":"u","i":"i","o":"o","p":"p",
"a":"a","s":"s","d":"d","f":"f","g":"g","h":"h","j":"j","k":"k","l":"l","z":"z","x":"x","c":"c","v":"v",
"b":"b","n":"n","m":"m",",":",",".":".","/":"/",";":";",":":":","'":"'","!":"!","?":"?","-":"-","_":"_","\"":"\"","\\":"\\",
"Q":"Q","W":"W","E":"E","R":"R","T":"T","Y":"Y","U":"U","I":"I","O":"O","P":"P","A":"A","S":"S","D":"D",
"F":"F","G":"G","H":"H","J":"J","K":"K","L":"L","Z":"Z","X":"X","C":"C","V":"V","B":"B","N":"N","M":"M",
"1":"1","2":"2","3":"3","4":"4","5":"5","6":"6","7":"7","8":"8","9":"9","0":"0"}

export var normal_color : Color = Color(1,1,1,1)
export var correct_color : Color = Color (0,1,0,1)
export var b_correct_color : Color = Color (1,0,1,1)

export var player_enemy_trans_out : float = 500.0

var player_text_tags = "[center][shake]"
var enemy_text_tags = "[center]"
var spellbook_tags = "[center][wave amp=100 freq=2]"
var e_spell_matching = false	#if the current player spell matches a portion of the enemy spell
var b_spell_matching = false	#if the current player spell matches a portion of the book spell

signal dispelled()
signal enemy_defeated()
signal player_defeated()
signal back_to_menu()
signal request_quit()
signal particles_loaded()
signal setup_finished()
signal start_dialogue(path)
signal dialogue_ended()

func _ready():
	#TODO: is it better to just handle this all from the resource? consult.
	current_state = CombatState.LOADING
	
	#connecting signals to buttons
	for button in pause_menu.container.get_children():
		button.connect("select", self, "_p_selected")

func _exit_tree():
	if not enemy == null:	
		enemy.queue_free()
	pass

func setup(new_enemy:PackedScene) -> void:
	is_finished = false
	
	player_stats.health = player_ref.health
	player_stats.max_health = player_ref.max_health
	player_stats.honey = player_ref.max_honey/2
	player_stats.max_honey = player_ref.max_honey
	
	player_health.max_value = 1000
	player_health.value = int(float(player_stats.health)/float(player_stats.max_health)*float(player_health.max_value))
	player_honey_count.setup(player_stats.max_honey, player_stats.honey)
	
	enemy = new_enemy.instance()
	enemy_pos.add_child(enemy)
	enemy.show()
	enemy_health.max_value = 1000
	var bar_value = int((float(enemy.get_health())/float(enemy.get_max_health()))*enemy_health.max_value)
	enemy_health.animate_value(bar_value,0.1)
	
	#cleaning out any leftover visual data
	player_spell = ""
	player_spell_box.set_text(player_text_tags + player_spell)
	enemy_spell_box.set_text("")
	spellbook.close()
	#spellbook.see_data(false)
	
	gui.rect_position.y -= gui.rect_size.y
	player.position.x -= player_enemy_trans_out
	enemy_pos.position.x += player_enemy_trans_out
	
	pause_gameplay()
	
	#preload particles
	preload_particles()
	yield(self, "particles_loaded")
	##TODO: set up BGM loading
	
	emit_signal("setup_finished")

#resources loaded in, start animations and begin game loop
#this should begin as the scene transition dictates
func startup() -> void:
	var tween = create_tween()
	tween.tween_property(gui, "rect_position", Vector2(0,0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(player, "position", Vector2(player.position.x+player_enemy_trans_out, player.position.y), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(enemy_pos, "position", Vector2(enemy_pos.position.x-player_enemy_trans_out, enemy_pos.position.y), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("start_dialogue", enemy.get_intro_id())
	yield(self, "dialogue_ended")
	if is_finished == true:
		return
	ready_message.ready_up(1.5)
	yield(ready_message, "finished")
	player_spell = ""
	player_spell_box.set_text(player_text_tags + player_spell)
	next_player_spell()
	next_spell()
	spell_timer.start_timer()
	honey_timer.start_timer()
	unpause_gameplay()

#pauses timers and prevents player input
func pause_gameplay() -> void:
	#TODO: lower BGM or stop?
	player.pause()
	combat_audio.pause_bgm()
	spell_timer.pause_timer()
	honey_timer.pause_timer()
	is_casting = true

#unpauses timers and allows player input	
func unpause_gameplay() -> void:
	player.idle_loop()
	combat_audio.play_bgm()
	spell_timer.unpause_timer()
	honey_timer.unpause_timer()
	is_casting = false

func cleanup() -> void:
	is_finished = true
	var player_victory = false
	if enemy.get_health() <= 0:
		player_victory = true
		player_spell = "[rainbow]PLAYER VICTORY! Temp buffer, 1.5"
	elif player_stats.health <= 0:
		player_victory = false
		player_spell = "[rainbow]PLAYER DEFEAT! Temp buffer, 1.5"
	player_spell_box.set_text(player_text_tags + player_spell)
	Engine.time_scale = 0.5
	spell_timer.pause_timer()
	honey_timer.pause_timer()
	yield(get_tree().create_timer(1.5), "timeout")
	Engine.time_scale = 1.0
	pause_gameplay()
	if player_victory:
		emit_signal("start_dialogue", enemy.get_victory_id())
		enemy.set_winstate(2)
		yield(self, "dialogue_ended")
		emit_signal("enemy_defeated")
	else:
		emit_signal("start_dialogue", enemy.get_defeat_id())
		if enemy.get_winstate() == 0:
			enemy.set_winstate(1)
		yield(self, "dialogue_ended")
		emit_signal("player_defeated")

#handle the keyboard input.
func _unhandled_input(event) -> void:
	if is_casting or is_finished:
		return
	if event is InputEventKey and event.is_pressed():
		if player_spell != null and not player_spell.empty() and event.scancode == KEY_BACKSPACE:
			player_spell.erase(player_spell.length() - 1, 1)
			color_spells(player_spell)
			if player_spell != null:
				player_spell_box.set_text(player_text_tags + player_spell) #player_text_tags
		elif player_spell.empty() and event.scancode == KEY_ENTER:
			if spellbook.refresh():
				next_player_spell()
		elif allowed_chars.has(PoolByteArray([event.unicode]).get_string_from_utf8()): #checking list of allowed keys
			var key_typed = PoolByteArray([event.unicode]).get_string_from_utf8()
			combat_audio.play_speech(key_typed)
			if !player_spell_box.full_text(key_typed):
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
	spell_timer.set_timer(enemy.get_speed())
	color_spells(player_spell)
	player_spell_box.set_text(player_text_tags + player_spell)
	
func next_player_spell() -> void:
	player_spell_ref.next_spell()
	var holdstr = "[center]"+String(player_spell_ref.get_cost())
	spellbook.new_spell(spellbook_tags+player_spell_ref.get_spell_name(), holdstr, 0.0)
	#spellbook.set_text(spellbook_tags+player_spell_ref.get_spell_name())
	#spellbook.set_cost(holdstr)
	color_spells(player_spell)
	player_spell_box.set_text(player_text_tags + player_spell)

#spell takes an input and formats it accordingly against the currently loaded enemy spell, and compares
#TODO: update in the future to compare against loaded player spells! (maybe)
func spell(input:String) -> void:
	var p_spell = input.to_lower()
	#var spell_index = player_spell_ref.has_spell(p_spell)
	if player_spell_ref.validate(p_spell):
		#check if player has enough honey
		var cost = player_spell_ref.get_cost()
		if player_stats.can_afford(cost):
			is_casting = true
			player_spell_box.pop_up_text()
			#charge player and damage enemy
			player_stats.change_honey(-cost)
			player.attack()
			var anim = player_spell_ref.spell_list[player_spell_ref.has_spell(p_spell)].animation.instance()
			add_child(anim)
			player_spell = ""
			player_spell_box.set_text(player_text_tags + player_spell)
			next_player_spell()
			anim.play(spell_position, enemy_target)
			is_casting = false
			yield(anim, "hit")
			enemy.flash_color(Color(1,0.1,0.1,1), 0.04, 2)
			Globals.camera.shake(730, 0.2)
			damage_enemy(player_spell_ref.get_damage())
			if enemy.get_health() <= 0:
				cleanup()
			yield(anim, "finished")
			anim.queue_free()
		else:
			#no honey
			player_spell_box.flash_honey_notice()
			player_spell = ""
			player_spell_box.set_text(player_text_tags + player_spell)
			color_spells(player_spell)
	else:
		#check enemy spell
		var e_spell = enemy.get_solve()
		if p_spell == e_spell and !enemy_casting:
			#dispel
			player_spell_box.pop_up_text()
			enemy_spell_box.dead_down_text()
			player_stats.change_honey(enemy.get_drain())
			enemy.dispelled()
			next_spell() #next enemy spell
		else:
			player_spell_box.dead_down_text()
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
	if e_match and !enemy_casting:
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
	if !e_match and e_spell_matching and !enemy_casting:
		#enemy_spell_box.set_text(enemy_text_tags+enemy.get_tags()+enemy.get_text())
		enemy_spell_box.change_text_color(normal_color)
		e_spell_matching = false
	elif !b_match and b_spell_matching:
		#spellbook.set_text(spellbook_tags+player_spell_ref.get_spell_name())
		spellbook.change_text_color(normal_color)
		b_spell_matching = false
	if (!e_match or enemy_casting) and !b_match:
		player_spell_box.change_text_color(normal_color)
		player_text_tags = player_text_tags.replace("[rainbow]","")

func damage_enemy(value:int) -> void:
	#damages and receives changed value back from enemy
	#could have probably passed back new health through damage function, huh?
	#this is to avoid signal wackiness with instanced enemies - I'll figure that out later
	enemy.damage(value)
	damage_popup.popup(-abs(value), enemy_target.global_position)
	var bar_value = int((float(enemy.get_health())/float(enemy.get_max_health()))*enemy_health.max_value)
	#enemy_health.value = enemy.get_health()
	enemy_health.animate_value(bar_value, 1.0)
	#TODO: win condition checking must sanitize any yields for animations and field updates first

func preload_particles() -> void:
	var instances = []
	for i in particle_array:
		instances.append(i.instance())
		add_child(instances[-1])
		instances[-1].play()
	yield(get_tree().create_timer(1.0), "timeout")
	for i in instances:
		i.queue_free()
	emit_signal("particles_loaded")

func finish_dialogue() -> void:
	#after passing to main for dialogue, will emit this signal
	#this allows the code to functionally yield to itself, though technically it's
	#yielding to the parent node anyways
	emit_signal("dialogue_ended")

func _on_Timer_timeout() -> void:
	#TODO: Update with damage and so on - subject to change!
	spell_timer.pause_timer()
	enemy_spell_box.pop_up_text()
	enemy_spell_box.set_text(enemy_text_tags+"")
	enemy_casting = true
	color_spells(player_spell)
	player_spell_box.set_text(player_text_tags + player_spell)
	var anim = enemy.get_spell_animation().instance()
	add_child(anim)
	enemy.attack()
	anim.play(enemy_target, player_hit_position)
	yield(anim, "hit")
	if !is_finished:
		var dmg = enemy.get_damage()
		player_stats.damage(dmg)
		damage_popup.popup(-abs(dmg), player_hit_position.global_position)
		player.flash_color(Color(1,0,0,1))
		Globals.camera.shake(1000, 0.3)
	yield(anim, "finished")
	enemy_casting = false
	anim.queue_free()
	
	if player_stats.health <= 0:
		cleanup()
		return
	spell_timer.unpause_timer()
	next_spell()

func _on_CombatStats_health_changed(old_value, new_value) -> void:
	#TODO: might just incept this into a script for the health bar instead of clogging this up
	var bar_value = int((float(new_value)/float(player_stats.max_health))*player_health.max_value)
	player_health.animate_value(bar_value, 1.0)
	#player_health.value = new_value

func _on_HoneyTimer_timeout():
	player_stats.change_honey(1)

func _p_selected(id) -> void:
	match id:
		"back_to_menu":
			is_finished = true
			pause_gameplay()
			emit_signal("back_to_menu")
		"resume":
			return
		"exit":
			emit_signal("request_quit")
