extends Sprite

export var rotation_speed = 2.0
export var direction := 1
var speed_mod = 1.0

func _process(delta) -> void:
	rotation += direction * rotation_speed * delta * speed_mod

func change_rot_speed(fraction:float):
	speed_mod = fraction
