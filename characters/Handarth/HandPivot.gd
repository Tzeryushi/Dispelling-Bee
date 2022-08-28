extends Position2D

export var rotation_speed = 2.0
onready var hand = $Hand1

func _process(delta) -> void:
	rotation += rotation_speed * delta
	hand.global_rotation = 0
