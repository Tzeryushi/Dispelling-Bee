extends Button

signal button_combat(enemy)

export(PackedScene) var enemy_scene = preload("res://combat/HatWizard.tscn")

func _ready() :
	connect("pressed", self, "_button_pressed")
	
func _button_pressed() -> void:
	emit_signal("button_combat", enemy_scene)
