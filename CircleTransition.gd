extends ColorRect

signal finished
signal done

var circle_value : float = 1.05

func _process(delta) -> void:
	circle_change(circle_value)

func transition_out(time:float) -> void:
	visible = true
	var tween = create_tween()
	circle_change(0)
	yield(tween.tween_property(self, "circle_value", 1.05, time).set_ease(Tween.EASE_IN),"finished")
	emit_signal("done")

func transition_dark(time:float) -> void:
	visible = true
	var tween = create_tween()
	circle_change(1.05)
	yield(tween.tween_property(self, "circle_value", 0.0, time).set_ease(Tween.EASE_IN),"finished")
	emit_signal("done")
	visible = false

func circle_change(new_value:float) -> void:
	self.material.set_shader_param("circle_size", new_value)
	print(material.get_shader_param("circle_size"))
