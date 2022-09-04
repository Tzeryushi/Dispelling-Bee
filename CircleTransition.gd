extends ColorRect

signal finished
signal done

var circle_value : float = 1.05

func transition_out(time:float) -> void:
	visible = true
	var tween = create_tween()
	circle_change(0.0)
	yield(tween.tween_method(self, "circle_change", 0.0, 1.05, time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART),"finished")
	emit_signal("done")
	visible = false

func transition_dark(time:float) -> void:
	visible = true
	var tween = create_tween()
	circle_change(1.05)
	yield(tween.tween_method(self, "circle_change", 1.05, 0.0, time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART),"finished")
	emit_signal("done")

func circle_change(new_value:float) -> void:
	self.material.set_shader_param("circle_size", new_value)
