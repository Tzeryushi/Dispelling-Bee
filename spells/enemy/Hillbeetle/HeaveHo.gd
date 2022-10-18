extends SpellAnimation

onready var ball_path := $AnimationPath
onready var ball_follow := $AnimationPath/Follow
onready var dirtball := $AnimationPath/Follow/DirtBall
onready var spin_part := $AnimationPath/Follow/DirtSpinParticle

export var dirtball_accel : float = -25.0

var dirtball_rot_velocity : float = 0
var animation_curve : Curve2D

func _process(delta) -> void:
	dirtball_rot_velocity += dirtball_accel * delta
	dirtball.rotation += dirtball_rot_velocity * delta

func _play(attacker, defender) -> void:
	spin_part.play()
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
	spin_part.stop()
	
	dirtball.visible = false
	var part = hit_particles.instance()
	add_child(part)
	part.position = defender.global_position
	part.play()
	yield(part,"finished")
	part.queue_free()
	emit_signal("finished")
	queue_free()
