extends RichTextLabel

onready var complete_text := $CompletionTime

var ideal_position := Vector2.ZERO

signal finished

func _ready() -> void:
	ideal_position = rect_position

func float_msg(time:float) -> void:
	rect_position = ideal_position + Vector2(rect_size.x/2.0, rect_size.y/2.0)
	rect_scale = Vector2(0.0,0.0)
	modulate.a = 1.0
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "rect_scale", Vector2(1.0,1.0), time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	yield(tween.parallel().tween_property(self, "rect_position", ideal_position, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC),"finished")
	emit_signal("finished")
	var tween2 = create_tween()
	yield(tween2.tween_property(self, "modulate:a", 0.0, 0.3), "finished")
	var moob = "mood"
	tween.kill()
	visible = false

func set_time_msg(value:String) -> void:
	complete_text.bbcode_text = value
