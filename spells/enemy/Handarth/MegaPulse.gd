extends SpellAnimation

export var spell_ring : PackedScene

export var small_ring_size := Vector2(0.3, 0.3)
export var small_ring_tiny := Vector2(0.001, 0.001)
export var small_time := 0.2
export var big_ring_big := Vector2(7.5, 7.5)
export var big_time := 0.4


func _play(attacker, defender) -> void:
	var tween_1 = create_tween()
	var tween_2 = create_tween()
	var ring_1 = spell_ring.instance()
	add_child(ring_1)
	ring_1.position = (attacker.get_global_position() - Vector2(135, 40))
	ring_1.scale = small_ring_size
	var ring_2 = spell_ring.instance()
	add_child(ring_2)
	ring_2.position = (attacker.get_global_position() + Vector2(135, 40))
	ring_2.scale = small_ring_size
	ring_2.visible = false
	var ring_3 = spell_ring.instance()
	add_child(ring_3)
	ring_3.position = (attacker.get_global_position())
	ring_3.scale = Vector2(0.0001, 0.0001)
	ring_3.visible = false
	tween_1.tween_property(ring_1, "scale", (small_ring_size+small_ring_tiny)/2, small_time/2)
	tween_1.tween_property(ring_1, "scale", small_ring_tiny, small_time/2)
	tween_1.parallel().tween_property(ring_2, "visible", true, 0.0001)
	tween_1.parallel().tween_property(ring_2, "scale", small_ring_tiny, small_time)
	
	tween_1.tween_property(ring_2, "scale", small_ring_tiny, small_time*1.5)
	
	tween_1.parallel().tween_property(ring_3, "visible", true, 0.0001)
	yield(tween_1.tween_property(ring_3, "scale", big_ring_big/2, big_time/2), "finished")
	tween_1.parallel().tween_property(ring_3, "modulate:a", 0.0, big_time)
	emit_signal("hit")
	tween_1.tween_property(ring_3, "scale", big_ring_big, big_time/2)
	#tween_1.parallel().tween_property(ring_3, "modulate:a", 0.0, big_time/2)
	
	emit_signal("finished")
