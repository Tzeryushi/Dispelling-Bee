extends TextureProgress

var shake_values = [0.0, 20.0]

func animate_value(target_value:float, duration = 1.0):
	var tween := create_tween()
	tween.tween_property(self, "value", target_value, duration).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
#	tween.parallel().tween_property(self, "position", shake_values[1], duration/2.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
#	tween.tween_property(self, "position", shake_values[0], duration/2.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
