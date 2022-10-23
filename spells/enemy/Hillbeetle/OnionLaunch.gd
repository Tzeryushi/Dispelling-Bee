extends SpellAnimation

onready var projectile := $Onion
onready var spin_part := $Onion/DirtSpinParticle

export var speed : float = 0.5

func _play(attacker, defender) -> void:
	#shooting the onion
	var tween = create_tween()
	projectile.position = attacker.global_position
	projectile.scale = Vector2(0,0)
	tween.tween_property(projectile, "scale", Vector2(0.8, 0.8), 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	yield(tween, "finished")
	spin_part.play()
	tween = create_tween()
	tween.tween_property(projectile, "position", defender.global_position, speed).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(projectile, "rotation", 20*PI, speed).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	yield(tween, "finished")
	spin_part.stop()
	emit_signal("hit")
	projectile.visible = false
	
	#particles
	var part = hit_particles.instance()
	add_child(part)
	part.position = defender.global_position
	part.play()
	yield(part,"finished")
	emit_signal("finished")
	
