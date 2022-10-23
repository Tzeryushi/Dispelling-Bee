extends Node2D

var back_color : Color = Color(0.0, 0.0, 0.0, 0.5)

func _draw() -> void:
	draw_circle(Vector2(0,0), 350.0/2.0, back_color)

func set_and_draw(color:Color) -> void:
	back_color = color
	update()
