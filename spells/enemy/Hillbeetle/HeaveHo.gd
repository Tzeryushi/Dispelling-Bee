extends SpellAnimation

onready var ball_path := $AnimationPath
onready var ball_follow := $AnimationPath/Follow

var animation_curve : Curve2D

func _play(attacker, defender) -> void:
	animation_curve = Curve2D.new()
	animation_curve.add_point(attacker.global_position, Vector2.ZERO, Vector2(-500.0, -350.0))
	animation_curve.add_point(defender.global_position, Vector2(200.0, -600.0), Vector2.ZERO)
	ball_path.set_curve(animation_curve)
	ball_follow.unit_offset = 0.0
	var tween = create_tween()
	tween.tween_property(ball_follow, "unit_offset", 0.3, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	yield(tween, "finished")
	tween = create_tween()
	tween.tween_property(ball_follow, "unit_offset", 1.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	yield(tween, "finished")
	emit_signal("hit")
	emit_signal("finished")
	queue_free()
