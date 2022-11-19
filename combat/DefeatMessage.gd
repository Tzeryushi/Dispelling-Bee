extends RichTextLabel

var ideal_position := Vector2.ZERO

signal finished

func _ready() -> void:
	ideal_position = rect_position

func float_msg(time:float, gonk_time) -> void:
	rect_position = ideal_position
	rect_scale = Vector2(0.0,0.0)
	modulate.a = 1.0
	rect_rotation = 0.0
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "rect_scale", Vector2(1.0,1.0), time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	yield(tween, "finished")
	var tween3 = create_tween()
	tween3.tween_property(self, "rect_rotation", -15.0, gonk_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween3.parallel().tween_property(self, "rect_position", rect_position + Vector2(0, 100), gonk_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	yield(tween3, "finished")
	emit_signal("finished")
	var tween2 = create_tween()
	yield(tween2.tween_property(self, "modulate:a", 0.0, 0.3), "finished")
	var moob = "mood"
	tween.kill()
	visible = false
