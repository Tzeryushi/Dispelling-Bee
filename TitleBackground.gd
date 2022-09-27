extends ParallaxBackground

export var speed : float = 50.0
export var rot_speed : float = 0.1
export var noise : float = 0.083

export var color_override : Color = Color(1,1,1,1)

var direction = Vector2(0,1)

func _ready() -> void:
	$ParallaxLayer/Background.modulate = color_override

func _process(delta) -> void:
	scroll_offset += direction * speed * delta
	direction = direction.rotated(rot_speed * delta)
