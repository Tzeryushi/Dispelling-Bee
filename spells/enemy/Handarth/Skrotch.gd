extends SpellAnimation

onready var projectile = $Projectile
onready var line = $Line2D

export var trail_length = 10
export var speed: float = 1.0

var hit : bool = false

func _process(delta) -> void:
	if !hit:
		var point = projectile.position
		line.add_point(point)
		while line.get_point_count() > trail_length:
			line.remove_point(0)
	if line.get_point_count() == 0:
		emit_signal("finished")
		queue_free()
	elif hit:
		line.remove_point(0)

func _play(attacker, defender) -> void:
	var tween = create_tween()
	projectile.position = attacker.global_position
	projectile.scale = Vector2(0,0)
	tween.tween_property(projectile, "rotation", -20*PI, speed).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	tween.parallel().tween_property(projectile, "scale", Vector2(0.8, 0.8), speed/4.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	yield(tween.parallel().tween_property(projectile, "position", defender.global_position, speed).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT),"finished")
	emit_signal("hit")
	hit = true
