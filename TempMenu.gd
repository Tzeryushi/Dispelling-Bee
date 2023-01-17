extends Node2D

class_name TempMenu

onready var container = $Control/VBoxContainer
onready var pause = $CanvasLayer/Pause

export var flags : Resource
export var tutorial_scene : PackedScene
var theme = SoundtrackManager.THEME.MENU
var tutorial_window
var tut_focus : bool = false

signal request_quit

func _ready() -> void:
	for button in pause.container.get_children():
		button.connect("select", self, "_p_selected")
	open_tutorial()
	
func _input(event) -> void:
	if !is_focused() and !tut_focus:
		$Control/VBoxContainer/Button.grab_focus()
	elif !tutorial_window.is_focused() and tut_focus:
		tutorial_window.get_focus()
	
func is_focused() -> bool:
	for button in container.get_children():
		if container.get_focus_owner() == button:
			return true
	return false

func focus_update() -> void:
	if $Control/VBoxContainer/Button.is_inside_tree():
		$Control/VBoxContainer/Button.grab_focus()
	for button in container.get_children():
		if flags.enemy_flags[button.text] == 2:
			button.check.visible = true
		else:
			button.check.visible = false

func open_tutorial() -> void:
	tutorial_window = tutorial_scene.instance()
	add_child(tutorial_window)
	tut_focus = true

func _p_selected(id) -> void:
	match id:
		"resume":
			return
		"exit":
			emit_signal("request_quit")
