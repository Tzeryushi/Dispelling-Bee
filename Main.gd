extends Node

#TODO: Implement scene instancing and swapping
#TODO: combat instance and data passing (both ways? signal at battle end?)
export(NodePath) var combat
export(NodePath) var temp_menu

onready var circle_transition = $CircleTransition

func _ready():
	combat = get_node(combat)
	temp_menu = get_node(temp_menu)
	remove_child(combat)

func _exit_tree() -> void:
	combat.queue_free()
	temp_menu.queue_free()

func _on_Button_button_combat(enemy):
	yield(circle_transition.transition_dark(0.5),"finished")
	remove_child(temp_menu)
	add_child(combat)
	combat.setup(enemy)
	yield(circle_transition.transition_out(0.5),"finished")
	#transition
	combat.startup()

func _on_Combat_enemy_defeated():
	remove_child(combat)
	add_child(temp_menu)

func _on_Combat_player_defeated():
	remove_child(combat)
	add_child(temp_menu)
