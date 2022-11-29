extends Sprite

export var rotation_speed = 2.0
export var direction := 1

func _process(delta) -> void:
	rotation += direction * rotation_speed * delta
