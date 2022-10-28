extends Button

onready var arrow := $Center

export var signal_string: String = "Default Signal"

signal select(sig_id)

func _ready() -> void:
	connect("mouse_entered", self, "_hover_in")
	connect("mouse_exited", self, "_hover_out")
	connect("focus_entered", self, "_hover_in")
	connect("focus_exited", self, "_hover_out")

func _on_MenuButton_pressed():
	emit_signal("select", signal_string)

func _hover_in() -> void:
	arrow.visible = true
	grab_focus()

func _hover_out() -> void:
	arrow.visible = false
