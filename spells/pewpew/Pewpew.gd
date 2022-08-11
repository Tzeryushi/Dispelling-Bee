extends SpellAnimation

func _play(attacker:Node2D, defender:Node2D) -> void:
	#the idea is to grab the position of the attacking node, and
	#animate the graphic over to the defending node
	#we'll emit a signal when we finish so that a class that is yielding for the animation
	#can know when to continue
	$AnimatedSprite.visible = true
	$AnimatedSprite.position = attacker.position
	if !$fire.is_playing():
		$fire.play()
#	var tween = Tween.new()
#	add_child(tween)
	var tween := create_tween()
	#tween.connect("tween_completed", self, "on_tween_completed")
#	tween.interpolate_property($AnimatedSprite, "position", attacker.position, defender.position, 0.5, Tween.TRANS_QUAD)
#	tween.start()
	#tween.tween_property($AnimatedSprite, "position", Vector2(300,500), 1)
	#TODO: make functionality of time yield endemic to spellanimation?
	yield(tween.tween_property($AnimatedSprite, "position", defender.position, 1), "finished")
	$AnimatedSprite.visible = false
	emit_signal("hit")
	if !$hit.is_playing():
		$hit.play()
		yield($hit, "finished")
		print("passed")
		emit_signal("finished")
	else:
		print("output")
		emit_signal("finished")
