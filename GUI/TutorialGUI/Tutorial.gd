extends Node2D

export(Array, PackedScene) var panels

onready var right_button := $GUI/RightButton
onready var left_button := $GUI/LeftButton
onready var right_arrow := $GUI/RightButton/Arrow
onready var left_arrow := $GUI/LeftButton/Arrow
onready var gui := $GUI

var current_panel : TutPanel

#animate opening
#contain all separate tutpanel packedscenes
#grab focus upon opening
#animate switching between panels based on button input
#animate closing
#send signal back to menu scene to regrab focus

#should I have put the buttons in the base tutorial scene? absolutely!
#do I want to go back and change it? absolutely not!

func _ready() -> void:
	if !panels.empty():
		current_panel = panels[0].instance()
		gui.add_child(current_panel)
	#get_focus()

func is_focused() -> bool:
	if gui.get_focus_owner() == right_button:
		return true
	elif gui.get_focus_owner() == left_button:
		return true
	return false

func get_focus() -> void:
	right_button.grab_focus()

func next_scene(forward:bool) -> void:
	#add scene, forwards or back in array
	#connect new scene's signals
	pass

#Right Button
func _on_RightButton_pressed():
	emit_signal("right_pressed")

func _on_RightButton_mouse_entered():
	_light_right(Color(2.0, 2.0, 2.0))
func _on_RightButton_mouse_exited():
	_light_right(Color(1.0, 1.0, 1.0))
func _on_RightButton_focus_entered():
	_light_right(Color(2.0, 2.0, 2.0))
func _on_RightButton_focus_exited():
	_light_right(Color(1.0, 1.0, 1.0))
func _light_right(value:Color) -> void:
	right_arrow.modulate = value

#Left Button
func _on_LeftButton_pressed():
	emit_signal("left_pressed")

func _on_LeftButton_mouse_entered():
	_light_left(Color(2.0, 2.0, 2.0))
func _on_LeftButton_mouse_exited():
	_light_left(Color(1.0, 1.0, 1.0))
func _on_LeftButton_focus_entered():
	_light_left(Color(2.0, 2.0, 2.0))
func _on_LeftButton_focus_exited():
	_light_left(Color(1.0, 1.0, 1.0))
func _light_left(value:Color) -> void:
	left_arrow.modulate = value
