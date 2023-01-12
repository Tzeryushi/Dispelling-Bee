extends SpellAnimation

func _play(attacker, defender) -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("hit")
	emit_signal("finished")
	queue_free()
