extends RichTextLabel

var screen_resolution = Vector2.ZERO
var ideal_position = Vector2.ZERO

signal finished

func _ready() -> void:
	screen_resolution = OS.get_screen_size()#Vector2(Globals.get("display/width"),Globals.get("display/height"))
	ideal_position = rect_position
	rect_scale = Vector2(0.0,0.0)
	rect_position = screen_resolution/2.0

func ready_up(time:float) -> void:
	rect_scale = Vector2(0.0,0.0)
	rect_position = screen_resolution/2.0
	modulate.a = 1.0
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "rect_scale", Vector2(1.0,1.0), time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	yield(tween.parallel().tween_property(self, "rect_position", ideal_position, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC),"finished")
	emit_signal("finished")
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
