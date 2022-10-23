extends Node2D

onready var container = $Control/VBoxContainer

func _ready() -> void:
	$Control/VBoxContainer/Button.grab_focus()

func _enter_tree():
	pass
	
func _input(event) -> void:
	if !is_focused():
		$Control/VBoxContainer/Button.grab_focus()
	
func is_focused() -> bool:
	for button in container.get_children():
		if container.get_focus_owner() == button:
			return true
	return false
