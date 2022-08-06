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
	var tween := create_tween()
#	tween.interpolate_property($AnimatedSprite, "position", attacker.position, defender.position, 0.5, Tween.TRANS_QUAD)
#	tween.start()
	tween.tween_property($AnimatedSprite, "position", Vector2(100,200), 1)
	tween.tween_property($AnimatedSprite, "position", Vector2(300,500), 1)
	
	#TODO: make functionality of time yield endemic to spellanimation?
	yield(get_tree().create_timer(2), "timeout")
	emit_signal("finished")
