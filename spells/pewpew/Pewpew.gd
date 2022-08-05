extends SpellAnimation

func _play(attacker:Node2D, defender:Node2D) -> void:
	#the idea is to grab the position of the attacking node, and
	#animate the graphic over to the defending node
	#we'll emit a signal when we finish so that a class that is yielding for the animation
	#can know when to continue
	$AnimatedSprite.visible = true
	$AnimatedSprite.position = attacker.position
#	var tween = Tween.new()
#	add_child(tween)
	tween.interpolate_property($AnimatedSprite, "position", attacker.position, defender.position, 0.5, Tween.TRANS_QUAD)
	tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("finished")
