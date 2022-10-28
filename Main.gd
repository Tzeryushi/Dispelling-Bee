extends Node

#TODO: Implement scene instancing and swapping
#TODO: combat instance and data passing (both ways? signal at battle end?)
export(NodePath) var combat
export(NodePath) var temp_menu
export(NodePath) var title_screen
export(NodePath) var dialogue

onready var player_data = $PlayerData

var is_transition := false

onready var circle_transition = $Transition/CircleTransition

func _ready():
	combat = get_node(combat)
	temp_menu = get_node(temp_menu)
	title_screen = get_node(title_screen)
	dialogue = get_node(dialogue)
	remove_child(combat)
	remove_child(temp_menu)

func _exit_tree() -> void:
	combat.queue_free()
	temp_menu.queue_free()
	title_screen.queue_free()

func combat_to_menu():
	_transition(combat, temp_menu)
	temp_menu.focus_update()

func _on_Button_button_combat(enemy):
	if is_transition:
		return
	is_transition = true
	circle_transition.transition_dark(0.7)
	yield(circle_transition, "done")
	remove_child(temp_menu)
	add_child_below_node(player_data, combat)
	combat.setup(enemy)
	yield(combat, "setup_finished")
	circle_transition.transition_out(0.7)
	yield(circle_transition, "done")
	#transition
	combat.startup()
	is_transition = false

func _on_Combat_enemy_defeated():
	combat_to_menu()

func _on_Combat_player_defeated():
	combat_to_menu()
	
func _on_Combat_back_to_menu():
	combat_to_menu()
	
func _transition(unload:Node, to_load:Node) -> void:
	if is_transition:
		return
	else:
		is_transition = true
		circle_transition.transition_dark(0.7)
		yield(circle_transition, "done")
		remove_child(unload)
		add_child(to_load)
		yield(get_tree().create_timer(0.5), "timeout")
		circle_transition.transition_out(0.7)
		yield(circle_transition, "done")
		is_transition = false

func _on_TitleScreen_game_start():
	_transition(title_screen, temp_menu)
	temp_menu.focus_update()

func _on_Combat_start_dialogue(path):
	dialogue.start_dialogue(path)
	yield(dialogue, "finished")
	combat.finish_dialogue()

func _on_Combat_request_quit():
	get_tree().quit()
