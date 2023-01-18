extends Node2D

class_name TempMenu

onready var container = $Control/VBoxContainer
onready var pause = $CanvasLayer/Pause
onready var tut_button = $Control/TutorialButton

export var flags : Resource
export var tutorial_scene : PackedScene
var theme = SoundtrackManager.THEME.MENU
var tutorial_window : Tutorial
var tut_focus : bool = false


signal request_quit

func _ready() -> void:
	for button in pause.container.get_children():
		button.connect("select", self, "_p_selected")
	
func _input(event) -> void:
	if !is_focused() and !tut_focus:
		$Control/VBoxContainer/Button.grab_focus()
	elif tut_focus:
		if !tutorial_window.is_focused():
			tutorial_window.get_focus()
	
func is_focused() -> bool:
	for button in container.get_children():
		if container.get_focus_owner() == button:
			return true
	if container.get_focus_owner() == tut_button:
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

func _p_selected(id) -> void:
	match id:
		"resume":
			return
		"exit":
			emit_signal("request_quit")

func _on_TutorialButton_pressed():
	open_tutorial()

func open_tutorial() -> void:
	tutorial_window = tutorial_scene.instance()
	add_child(tutorial_window)
	tut_focus = true
	yield(tutorial_window, "closed")
	tut_focus = false
	disconnect("closed", tutorial_window, "close_tutorial")
	tutorial_window.queue_free()
