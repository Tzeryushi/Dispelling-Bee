extends Node2D

class_name TempMenu

onready var container = $Control/VBoxContainer

export var flags : Resource

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

func focus_update() -> void:
	$Control/VBoxContainer/Button.grab_focus()
	for button in container.get_children():
		if flags.enemy_flags[button.text] == 2:
			button.check.visible = true
		else:
			button.check.visible = false
