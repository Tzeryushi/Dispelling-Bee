extends ColorRect

signal finished

func transition_out(time:float) -> void:
	visible = true
	var tween = create_tween()
	yield(tween.tween_property(get_material(), "shader_param/circle_size", 1.05, time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART),"finished")
	emit_signal("finished")

func transition_dark(time:float) -> void:
	visible = true
	var mat = get_material()
	var tween = create_tween()
	yield(tween.tween_property(mat, "shader_param/circle_size", 0, time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART),"finished")
	emit_signal("finished")
	visible = false
