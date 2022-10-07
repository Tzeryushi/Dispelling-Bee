extends Control

onready var arrow = $DialogueBox/NextPrompt

export var text_speed = 0.03

func _ready() -> void:
	arrow.visible = false

func load_dialogue() -> void:
	pass
