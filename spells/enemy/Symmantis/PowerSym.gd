extends SpellAnimation

onready var player = $AnimationPlayer

func _play(attacker, defender) -> void:
	player.play("Beam")
	yield(player, "animation_finished")
	emit_signal("finished")

func hit() -> void:
	emit_signal("hit")
