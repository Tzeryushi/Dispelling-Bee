extends TextureProgress

func animate_value(target_value:float, duration = 1.0):
	var tween := create_tween()
	tween.tween_property(self, "value", target_value, duration).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
