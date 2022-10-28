extends Control

onready var container = $ColorRect/VBoxContainer

func _ready() -> void:
	for button in container.get_children():
		if button is Button:
			button.connect("pressed", self, "pause_unpause")

func _input(event) -> void:
	if event.is_action_pressed("pause"):
		pause_unpause()

func pause_unpause() -> void:
	print("trigger")
	var new_state = not get_tree().paused
	get_tree().paused = new_state
	if new_state:
		$ColorRect/VBoxContainer/MenuButton.grab_focus()
	visible = new_state
