extends Node2D

class_name Ending

onready var gui := $GUI
onready var exit_button := $GUI/ExitButton

signal closed

func _ready() -> void:
	scale = Vector2(0.01, 0.01)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func is_focused() -> bool:
	if gui.get_focus_owner() == exit_button:
		return true
	return false

func get_focus() -> void:
	exit_button.grab_focus()

func _close() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.01, 0.01), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	yield(tween, "finished")
	emit_signal("closed")

func _on_ExitButton_pressed():
	_close()
