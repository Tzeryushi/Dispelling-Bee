extends RichTextLabel

export var velocity_init := 600.0
export var grav_accel := 1300.0

var velocity := Vector2.ZERO

func _ready() -> void:
	var direction = Vector2(0, -1)
	direction = Vector2(direction.x*cos(rand_range(-PI/3,PI/3))-direction.y*sin(rand_range(-PI/3,PI/3)), direction.x*sin(rand_range(-PI/3,PI/3))+direction.y*cos(rand_range(-PI/3,PI/3)))
	velocity = direction * velocity_init

func _process(delta) -> void:
	velocity += Vector2(0, grav_accel) * delta
	rect_position += velocity * delta

func set_text(value:String) -> void:
	bbcode_text = value
