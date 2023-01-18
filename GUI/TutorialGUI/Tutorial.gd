extends Node2D

class_name Tutorial

export(Array, PackedScene) var panels
export var shift_amount : float = 1000.0
export var shift_time : float = 1.0

onready var right_button := $GUI/RightButton
onready var left_button := $GUI/LeftButton
onready var exit_button := $GUI/ExitButton
onready var gui := $GUI

var current_panel : TutPanel
var panel_number : int

signal closed

#animate opening
#contain all separate tutpanel packedscenes
#grab focus upon opening
#animate switching between panels based on button input
#animate closing
#send signal back to menu scene to regrab focus

#should I have put the buttons in the base tutorial scene? absolutely!
#do I want to go back and change it? absolutely not!

func _ready() -> void:
	#this sets the first panel on the node being instanced from the menu
	#if the array of panel scenes has no members (this would be erroneous), should not run
	if !panels.empty():
		panel_number = 0
		current_panel = panels[0].instance()
		gui.add_child(current_panel)
		_check_first_last()
	scale = Vector2(0.01, 0.01)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func _close() -> void:
	#animation to disappear
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.01, 0.01), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	yield(tween, "finished")
	emit_signal("closed")

func is_focused() -> bool:
	#checks if the tutorial panel (as opposed to the main menu) has focus or not
	if gui.get_focus_owner() == right_button or gui.get_focus_owner() == left_button:
		return true
	elif gui.get_focus_owner() == exit_button:
		return true
	return false

func get_focus() -> void:
	if right_button.get_focus_mode() != 0:
		right_button.grab_focus()
	else:
		left_button.grab_focus()

func next_scene(forward:bool) -> void:
	#add scene, forwards or back in array
	#update panel_number
	#connect new scene's signals
	if !forward and panel_number == 0: return
	elif forward and panel_number == panels.size()-1: return
	
	if !forward: panel_number -= 1
	else: panel_number += 1
	
	var old_panel = current_panel
	current_panel = panels[panel_number].instance()
	gui.add_child(current_panel)
	var cur_pos = current_panel.rect_position
	var old_new_pos : Vector2
	if !forward:
		current_panel.rect_position.x -= shift_amount  #needs balancing mathematically
		old_new_pos = old_panel.rect_position + Vector2(shift_amount,0.0)
	else:
		current_panel.rect_position.x += shift_amount
		old_new_pos = old_panel.rect_position - Vector2(shift_amount,0.0)
	#animation should go here
	var tween = create_tween()
	tween.tween_property(current_panel, "rect_position", cur_pos, shift_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(old_panel, "rect_position", old_new_pos, shift_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	yield(tween, "finished")
	old_panel.queue_free()
	
	_check_first_last()
	pass

func _check_first_last() -> void:
	#determines if the current panel is the first or last in the array
	#disables buttons if it is
	if panel_number == 0:
		left_button.disabled = true
		right_button.disabled = false
		if gui.get_focus_owner() == left_button:
			right_button.grab_focus()
		left_button.set_focus_mode(0)
		right_button.set_focus_mode(2)
	elif panel_number == panels.size()-1:
		right_button.disabled = true
		left_button.disabled = false
		if gui.get_focus_owner() == right_button:
			left_button.grab_focus()
		right_button.set_focus_mode(0)
		left_button.set_focus_mode(2)
	else:
		left_button.disabled = false
		left_button.set_focus_mode(2)
		right_button.disabled = false
		right_button.set_focus_mode(2)
	pass

func _plink() -> void:
	$Plink.play()

#Right Button
func _on_RightButton_pressed():
	next_scene(true)

#Left Button
func _on_LeftButton_pressed():
	next_scene(false)

func _on_ExitButton_pressed():
	_close()
