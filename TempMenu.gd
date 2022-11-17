extends Node2D

class_name TempMenu

onready var container = $Control/VBoxContainer
onready var pause = $CanvasLayer/Pause

export var flags : Resource
var theme = SoundtrackManager.THEME.MENU

signal request_quit

func _ready() -> void:
	for button in pause.container.get_children():
		button.connect("select", self, "_p_selected")
	
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

func _p_selected(id) -> void:
	match id:
		"resume":
			return
		"exit":
			emit_signal("request_quit")
