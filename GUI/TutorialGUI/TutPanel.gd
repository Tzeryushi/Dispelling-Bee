extends Control

onready var right_button := $RightButton
onready var left_button := $LeftButton
onready var right_arrow := $RightButton/Arrow
onready var left_arrow := $LeftButton/Arrow


func get_focus() -> void:
	right_button.grab_focus()

#Right Button
func _on_RightButton_pressed():
	pass # send signal to tutorial scene

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
	pass # send signal to tutorial scene

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

