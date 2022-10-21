extends RichTextLabel

export var rotate : float = 7.0
export var time : float = 1.0

var initial_scale : Vector2

func _ready() -> void:
	_start_tween()

func _start_tween() -> void:
	var tween = create_tween()
	yield(tween.parallel().tween_property(self, "rect_rotation", rotate, time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE),"finished")
	rotate = -rotate
	_start_tween()
